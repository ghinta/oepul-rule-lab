"""Read-only, hash-bound development screening of historical Luna candidates.

These observations are neither independent reference labels nor a benchmark.
Only the explicitly frozen policy/data files are loaded, one run at a time.
"""
from __future__ import annotations

import argparse
from collections import Counter
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
from typing import Any

from rulelab.cli import opa_platform_key, verify_opa_binary

ROOT = Path(__file__).resolve().parents[2]
REPORT = Path("docs/analysis/luna-screening-20261011")
MEASURES = ("o6_1a", "o6_1b", "o6_1c", *(f"o6_{i}" for i in range(2, 25)))
BASE_COMMIT = "7a296d28cb5b92e2758c5a3889c929ea1db60fe5"
MODEL = "gpt-5.6-luna"
BLOCKED_BUILTINS = ("http.send", "net.lookup_ip_addr", "time.now_ns", "uuid.rfc4122", "rand.intn", "opa.runtime")
DATA_PATH = r"data(?:\.[A-Za-z_][A-Za-z_0-9]*)+"
PROJECTION_ITEM = r'"[A-Za-z_][A-Za-z_0-9]*"\s*:\s*' + DATA_PATH


def json_bytes(value: Any) -> bytes:
    return (json.dumps(value, ensure_ascii=False, indent=2, sort_keys=True, allow_nan=False) + "\n").encode()


def load_json(path: Path) -> dict:
    def pairs(items):
        result = {}
        for key, value in items:
            if key in result:
                raise ValueError(f"Duplicate JSON key {key!r} in {path}")
            result[key] = value
        return result

    def nonfinite(value):
        raise ValueError(f"Nonfinite JSON value {value} in {path}")

    value = json.loads(path.read_text(encoding="utf-8"), object_pairs_hook=pairs, parse_constant=nonfinite)
    if not isinstance(value, dict):
        raise ValueError(f"Expected JSON object: {path}")
    json_bytes(value)  # also rejects overflow to infinity (e.g. 1e999)
    return value


def relative_file(root: Path, name: str) -> Path:
    path = Path(name)
    if not name or path.is_absolute() or ".." in path.parts or path.as_posix() != name:
        raise ValueError(f"Expected normalized repository-relative path: {name!r}")
    result = root / path
    if not result.resolve().is_relative_to(root.resolve()):
        raise ValueError(f"Path escapes repository: {name}")
    if not result.is_file():
        raise ValueError(f"Missing bound file: {name}")
    return result


def record(root: Path, path: Path) -> dict:
    name = path.relative_to(root).as_posix()
    value = relative_file(root, name).read_bytes()
    return {"path": name, "sha256": hashlib.sha256(value).hexdigest(), "bytes": len(value)}


def verify_records(root: Path, records: list[dict]) -> None:
    seen = set()
    for expected in records:
        name = expected["path"]
        if name in seen:
            raise ValueError(f"Duplicate bound path: {name}")
        seen.add(name)
        actual = record(root, relative_file(root, name))
        if actual != expected:
            raise ValueError(f"Bound file changed: {name}")


def validate_query(query: str) -> None:
    if not isinstance(query, str) or len(query) > 4000:
        raise ValueError("Expected bounded native query")
    if re.fullmatch(DATA_PATH, query):
        return
    if re.fullmatch(r"\{\s*" + PROJECTION_ITEM + r"(?:\s*,\s*" + PROJECTION_ITEM + r")*\s*\}", query):
        keys = re.findall(r'"([A-Za-z_][A-Za-z_0-9]*)"\s*:', query)
        if len(keys) == len(set(keys)):
            return
    raise ValueError(f"Only native data paths or bounded object projections are allowed: {query!r}")


def validate_fixture(fixture: dict, measure_id: str, run_id: str) -> None:
    if fixture.get("measure_id") != measure_id or fixture.get("run_id") != run_id:
        raise ValueError("Fixture and frozen candidate IDs differ")
    for key in ("input_contract_note", "output_contract_note", "case_origin"):
        if not isinstance(fixture.get(key), str) or not fixture[key].strip():
            raise ValueError(f"Missing fixture explanation: {key}")
    cases = fixture.get("cases")
    if not isinstance(cases, list) or len(cases) > 3:
        raise ValueError("Expected at most three development cases")
    if not cases and not (isinstance(fixture.get("gap"), str) and fixture["gap"].strip()):
        raise ValueError("Empty cases need an explicit fixture gap")
    validate_query(fixture["query"])
    seen = set()
    for case in cases:
        case_id = case.get("case_id")
        if not isinstance(case_id, str) or not re.fullmatch(r"[a-z][a-z_0-9-]*", case_id) or case_id in seen:
            raise ValueError("Invalid or duplicate development case ID")
        seen.add(case_id)
        if not isinstance(case.get("input"), dict) or not isinstance(case.get("purpose"), str) or not case["purpose"].strip():
            raise ValueError("Each development case needs object input and purpose")
        if {"expected", "expected_output", "golden_label"} & case.keys():
            raise ValueError("Development observations must not contain reference labels")
        json_bytes(case["input"])
    references = fixture.get("references")
    if not isinstance(references, list) or not references:
        raise ValueError("Fixture needs native artifact references")
    for ref in references:
        name = ref.get("path", "")
        if not name or Path(name).is_absolute() or ".." in Path(name).parts or Path(name).as_posix() != name:
            raise ValueError("Invalid reference path")
        if not isinstance(ref.get("detail"), str) or not ref["detail"].strip():
            raise ValueError("Reference needs explanation")
    if not isinstance(fixture.get("open_dependencies"), list) or any(not isinstance(x, str) or not x.strip() for x in fixture["open_dependencies"]):
        raise ValueError("Expected explicit open-dependency list")


def input_changes(before: Any, after: Any, path: str = "") -> list[dict]:
    """JSON-pointer diff preserving absent, null, false and empty collections."""
    if isinstance(before, dict) and isinstance(after, dict):
        changes = []
        for key in sorted(before.keys() | after.keys()):
            child = path + "/" + key.replace("~", "~0").replace("/", "~1")
            if key in before and key in after:
                changes.extend(input_changes(before[key], after[key], child))
            else:
                changes.append({"path": child, "before": {"present": key in before, **({"value": before[key]} if key in before else {})},
                                "after": {"present": key in after, **({"value": after[key]} if key in after else {})}})
        return changes
    if isinstance(before, list) and isinstance(after, list):
        changes = []
        for i in range(max(len(before), len(after))):
            child = path + f"/{i}"
            if i < len(before) and i < len(after):
                changes.extend(input_changes(before[i], after[i], child))
            else:
                changes.append({"path": child, "before": {"present": i < len(before), **({"value": before[i]} if i < len(before) else {})},
                                "after": {"present": i < len(after), **({"value": after[i]} if i < len(after) else {})}})
        return changes
    if type(before) is type(after) and before == after:
        return []
    return [{"path": path, "before": {"present": True, "value": before}, "after": {"present": True, "value": after}}]


def candidate_artifacts(root: Path, run_id: str) -> list[Path]:
    run = root / "runs" / run_id
    # Model transcripts/binaries are not loaded or republished. All interpretation
    # artifacts, prompts, tests and historical validation records are hash-bound.
    files = [p for p in run.rglob("*") if p.is_file() and p.relative_to(run).parts[0] not in {"raw"}
             and "tools" not in p.relative_to(run).parts]
    return sorted(files)


def create_manifest(root: Path, report_dir: Path, base_commit: str = BASE_COMMIT) -> dict:
    selected = {}
    for path in sorted((root / "runs").glob("*/run.json")):
        run = load_json(path)
        if run.get("model", {}).get("model") == MODEL:
            measure = run.get("measure")
            if measure in selected:
                raise ValueError(f"Multiple Luna candidates for {measure}; select explicitly")
            selected[measure] = run
    if set(selected) != set(MEASURES):
        raise ValueError("Luna inventory must contain exactly the 26 measures")
    entries = []
    for measure in MEASURES:
        run = selected[measure]
        run_id = run["run_id"]
        if run["status"] != "finalized" or Path(run_id).name != run_id:
            raise ValueError(f"Invalid historical candidate: {run_id}")
        fixture_path = report_dir / "fixtures" / f"{measure}.json"
        fixture = load_json(fixture_path)
        validate_fixture(fixture, measure, run_id)
        for ref in fixture["references"]:
            relative_file(root, ref["path"])
        artifacts = [record(root, p) for p in candidate_artifacts(root, run_id)]
        load_paths = [item["path"] for item in artifacts if
                      (f"/workspace/policy/" in item["path"] and item["path"].endswith(".rego")) or
                      (f"/workspace/data/" in item["path"] and item["path"].endswith(".json"))]
        if not any("/policy/" in path for path in load_paths):
            raise ValueError(f"Missing policy bundle: {run_id}")
        sources = []
        for source in run["sources"]:
            actual = record(root, relative_file(root, "sources/oepul/" + source["source_path"]))
            if actual["sha256"] != source["sha256"] or actual["bytes"] != source["bytes"]:
                raise ValueError(f"Historical source unavailable or changed: {actual['path']}")
            sources.append(actual)
        profile = record(root, relative_file(root, run["profile"]["path"]))
        if profile["sha256"] != run["profile"]["sha256"]:
            raise ValueError("Canonical profile no longer matches historical candidate")
        entries.append({"measure_id": measure, "run_id": run_id, "model": run["model"],
                        "mode": run["mode"], "generation_attempt": run.get("generation_attempt"),
                        "created_at": run.get("created_at"), "finalized_at": run.get("finalized_at"),
                        "fixture": record(root, fixture_path), "profile": profile,
                        "sources": sources, "artifacts": artifacts, "load_paths": load_paths})
    return {"schema_version": 1, "kind": "development-diagnostic", "base_commit": base_commit,
            "model": MODEL, "opa_version": (root / "runner/validation/opa-version.txt").read_text().strip(),
            "runtime_contract": {"blocked_builtins": list(BLOCKED_BUILTINS), "eval_timeout_seconds": 10,
                                 "process_timeout_seconds": 20, "strict_builtin_errors": True},
            "runtime_records": [record(root, root / p) for p in
                                ("runner/validation/opa-version.txt", "runner/validation/opa-checksums.json")],
            "entries": entries}


def verify_manifest(root: Path, manifest: dict) -> None:
    if manifest.get("schema_version") != 1 or manifest.get("kind") != "development-diagnostic" or manifest.get("model") != MODEL:
        raise ValueError("Unsupported screening manifest")
    if manifest.get("runtime_contract") != {"blocked_builtins": list(BLOCKED_BUILTINS), "eval_timeout_seconds": 10,
                                            "process_timeout_seconds": 20, "strict_builtin_errors": True}:
        raise ValueError("Runtime contract changed; create a separate screening")
    entries = manifest["entries"]
    if [e["measure_id"] for e in entries] != list(MEASURES) or len({e["run_id"] for e in entries}) != 26:
        raise ValueError("Manifest must bind every measure exactly once")
    runtime_records = [record(root, root / path) for path in
                       ("runner/validation/opa-version.txt", "runner/validation/opa-checksums.json")]
    if manifest["runtime_records"] != runtime_records:
        raise ValueError("Manifest must bind both runtime pin files exactly")
    verify_records(root, manifest["runtime_records"])
    if (root / "runner/validation/opa-version.txt").read_text().strip() != manifest["opa_version"]:
        raise ValueError("Manifest OPA version differs from repository pin")
    for entry in entries:
        records = [entry["fixture"], entry["profile"], *entry["artifacts"], *entry["sources"]]
        verify_records(root, records)
        artifact_paths = {r["path"] for r in entry["artifacts"]}
        run = load_json(root / f"runs/{entry['run_id']}/run.json")
        if run["measure"] != entry["measure_id"] or run["run_id"] != entry["run_id"] or run["model"] != entry["model"] or run["model"]["model"] != MODEL or run["status"] != "finalized":
            raise ValueError("Manifest candidate metadata differs from bound run")
        for field in ("mode", "generation_attempt", "created_at", "finalized_at"):
            if entry.get(field) != run.get(field):
                raise ValueError(f"Manifest metadata differs from historical run: {field}")
        if entry["profile"]["path"] != run["profile"]["path"] or entry["profile"]["sha256"] != run["profile"]["sha256"]:
            raise ValueError("Manifest profile differs from historical profile")
        expected_sources = [{"path": "sources/oepul/" + source["source_path"], "sha256": source["sha256"], "bytes": source["bytes"]}
                            for source in run["sources"]]
        if entry["sources"] != expected_sources:
            raise ValueError("Manifest sources differ from historical source selection")
        expected_artifacts = {p.relative_to(root).as_posix() for p in candidate_artifacts(root, entry["run_id"])}
        if expected_artifacts != artifact_paths:
            raise ValueError("Candidate artifact inventory changed")
        expected_load = [r["path"] for r in entry["artifacts"] if
                         ("/workspace/policy/" in r["path"] and r["path"].endswith(".rego")) or
                         ("/workspace/data/" in r["path"] and r["path"].endswith(".json"))]
        if entry["load_paths"] != expected_load:
            raise ValueError("Evaluation load list differs from frozen native policy/data")
        fixture = load_json(root / entry["fixture"]["path"])
        validate_fixture(fixture, entry["measure_id"], entry["run_id"])
        for ref in fixture["references"]:
            if ref["path"] not in artifact_paths:
                raise ValueError("Fixture reference is outside its frozen candidate")


def run_opa(binary: Path, args: list[str], cwd: Path, payload: dict | None = None) -> dict:
    try:
        done = subprocess.run([str(binary), *args], cwd=cwd, input=json_bytes(payload).decode() if payload is not None else None,
                              text=True, capture_output=True, timeout=20, check=False)
    except subprocess.TimeoutExpired:
        return {"exit_code": None, "error": "OPA process timeout after 20 seconds"}
    except OSError as exc:
        raise ValueError(f"Cannot execute pinned OPA: {exc}") from exc
    result = {"exit_code": done.returncode}
    if done.stdout.strip():
        try:
            result["json"] = json.loads(done.stdout)
        except json.JSONDecodeError:
            result["error"] = done.stdout.strip()
    if done.stderr.strip():
        result["error"] = done.stderr.strip()
    return result


def diagnostic_inventory(root: Path, entry: dict) -> dict:
    """Historical model declarations, explicitly separate from verified coverage."""
    run = root / "runs" / entry["run_id"]
    rules = load_json(run / "workspace/rules/rules.json")["rules"]
    coverage = load_json(run / "workspace/rules/coverage.json")["sources"]
    return {
        "rule_count": len(rules),
        "rule_type_counts": dict(sorted(Counter(rule["rule_type"] for rule in rules).items())),
        "static_policy_input_paths": load_json(run / "artifacts/input-paths.json")["paths"],
        "profile_proposal_count": len(load_json(run / "workspace/rules/profile_changes.json")["changes"]),
        "source_count": len(entry["sources"]),
        "source_coverage_claims": [{"source_id": source["source_id"], "review_scope": source["review_scope"],
                                   "item_count": len(source["items"]),
                                   "disposition_counts": dict(sorted(Counter(item["disposition"] for item in source["items"]).items()))}
                                  for source in coverage],
        "independent_reference_case_status": "not_adjudicated",
    }


def execute(root: Path, manifest: dict, opa_bin: Path) -> dict:
    verify_manifest(root, manifest)
    opa_bin = opa_bin.resolve()
    verify_opa_binary(opa_bin, manifest["opa_version"])
    checksums = load_json(root / "runner/validation/opa-checksums.json")
    expected = checksums[manifest["opa_version"]][opa_platform_key()]["sha256"]
    if hashlib.sha256(opa_bin.read_bytes()).hexdigest() != expected:
        raise ValueError("OPA executable differs from repository platform checksum")
    observed = []
    with tempfile.TemporaryDirectory(prefix="rulelab-screening-") as temporary:
        runtime = Path(temporary)
        cap = run_opa(opa_bin, ["capabilities", "--current"], runtime)
        if cap["exit_code"] != 0 or "json" not in cap:
            raise ValueError("Could not derive pinned OPA capabilities")
        capabilities = cap["json"]
        capabilities["builtins"] = [b for b in capabilities["builtins"] if b["name"] not in BLOCKED_BUILTINS]
        capabilities["allow_net"] = []
        (runtime / "capabilities.json").write_bytes(json_bytes(capabilities))
        for entry in manifest["entries"]:
            bundle = runtime / "bundle"
            bundle.mkdir()
            load_args = ["--data", "bundle/policy"]
            if any("/workspace/data/" in name for name in entry["load_paths"]):
                load_args.extend(["--data", "bundle/data"])
            for name in entry["load_paths"]:
                suffix = name.split("/workspace/", 1)[1]
                target = bundle / suffix
                target.parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(relative_file(root, name), target)
                bound = next(r for r in entry["artifacts"] if r["path"] == name)
                if hashlib.sha256(target.read_bytes()).hexdigest() != bound["sha256"]:
                    raise ValueError(f"Candidate changed during bundle copy: {name}")
            fixture = load_json(root / entry["fixture"]["path"])
            compiled = run_opa(opa_bin, ["check", "--strict", "--format=json", "--capabilities", "capabilities.json",
                              *load_args[1::2]], runtime)
            measure = {key: fixture[key] for key in ("measure_id", "run_id", "query", "input_contract_note", "output_contract_note", "case_origin", "references", "open_dependencies")}
            measure["inventory"] = diagnostic_inventory(root, entry)
            if "gap" in fixture:
                measure["gap"] = fixture["gap"]
            measure["compile"] = {"status": "compiled" if compiled["exit_code"] == 0 else "compile_error", "errors": compiled.get("json", {}).get("errors", []), **({"error": compiled["error"]} if "error" in compiled else {})}
            measure["cases"] = []
            for case in fixture["cases"]:
                value = {**case, "input_sha256": hashlib.sha256(json_bytes(case["input"])).hexdigest(),
                         "changes_from_baseline": input_changes(fixture["cases"][0]["input"], case["input"])}
                if compiled["exit_code"] != 0:
                    value.update(status="compile_error", opa_result={})
                else:
                    evaluated = run_opa(opa_bin, ["eval", "--format=json", "--stdin-input", "--strict-builtin-errors", "--timeout=10s",
                                               "--capabilities", "capabilities.json", *load_args, fixture["query"]], runtime, case["input"])
                    native = evaluated.get("json", {})
                    value["opa_result"] = native
                    value["status"] = "runtime_error" if evaluated["exit_code"] != 0 else ("defined" if native.get("result") else "undefined")
                    if "error" in evaluated:
                        value["error"] = evaluated["error"]
                    if value["status"] == "defined":
                        value["output"] = native["result"][0]["expressions"][0]["value"]
                base = measure["cases"][0] if measure["cases"] else value
                value["output_changed_from_baseline"] = (value["status"], json_bytes(value.get("output"))) != (base["status"], json_bytes(base.get("output")))
                measure["cases"].append(value)
            observed.append(measure)
            shutil.rmtree(bundle)
    verify_manifest(root, manifest)  # also detects any historical writes during execution
    return {"schema_version": 1, "kind": "development-diagnostic", "opa_version": manifest["opa_version"],
            "manifest_sha256": hashlib.sha256(json_bytes(manifest)).hexdigest(), "measures": observed}


def report_files(manifest: dict, results: dict) -> dict[str, bytes]:
    from rulelab.screening_report import render_report
    files = {"results.json": json_bytes(results)}
    files.update({f"results/{m['measure_id']}.json": json_bytes(m) for m in results["measures"]})
    files.update({name: content.encode() for name, content in render_report(manifest, results).items()})
    return files


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("freeze", "replay", "verify"))
    parser.add_argument("--report-dir", type=Path, default=REPORT)
    parser.add_argument("--opa-bin", type=Path, default=Path(os.environ.get("OPA_BIN", "tools/opa")))
    args = parser.parse_args(argv)
    report = (ROOT / args.report_dir).resolve()
    # Writes are confined to analysis output; never a historical run/source/profile.
    if not report.is_relative_to(ROOT / "docs/analysis"):
        raise ValueError("Screening outputs must be under repository docs/analysis")
    manifest_path = report / "manifest.json"
    if args.command == "freeze":
        if manifest_path.exists():
            raise ValueError("Manifest already frozen; use a new report directory for changed inputs")
        base = subprocess.run(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True, capture_output=True, check=True).stdout.strip()
        manifest = create_manifest(ROOT, report, base_commit=base)
        verify_manifest(ROOT, manifest)
        manifest_path.write_bytes(json_bytes(manifest))
        print(f"Frozen {len(manifest['entries'])} historical Luna candidates")
        return 0
    manifest = load_json(manifest_path)
    results = execute(ROOT, manifest, args.opa_bin)
    files = report_files(manifest, results)
    for name, payload in files.items():
        target = report / name
        if not target.resolve().is_relative_to(report):
            raise ValueError(f"Output path escapes screening report: {name}")
        if args.command == "verify":
            if not target.is_file() or target.read_bytes() != payload:
                raise ValueError(f"Screening replay differs from checked-in output: {name}")
        else:
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(payload)
    counts = {status: sum(c["status"] == status for m in results["measures"] for c in m["cases"])
              for status in ("defined", "undefined", "runtime_error", "compile_error")}
    print(json.dumps({"measures": len(results["measures"]), "case_status_counts": counts, "semantic_validation": False}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
