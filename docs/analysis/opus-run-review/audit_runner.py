#!/usr/bin/env python3
"""Bind/replay public developmental audit probes of one immutable Opus run.

This is diagnostic evidence, not an accuracy score, expert acceptance, or a
policy adaptation. Unmet source expectations are recorded findings. --verify
checks reproducibility, including those findings, without writing any file.
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]
MANIFEST = REPO / "docs/analysis/opus-screening-20261011/manifest.json"
MANIFEST_SHA256 = "575194a57dd09e52b52adc05de229abc7584414b32b5fadef36a9b83d4368f55"
NAMESPACE_REFERENCE = REPO / "docs/analysis/opus-screening-20261011/results/o6_1b.json"
NAMESPACE_REFERENCE_SHA256 = "0524f1d079bd06744b1a877f23af3c2adf0ff4c124146c6ba588e4fc7b8d4658"
CANDIDATE_COMMIT = "e009eed4a83ff076b26eba33ac433ac2b0642621"
BLOCKED = {"http.send", "net.lookup_ip_addr", "time.now_ns", "uuid.rfc4122", "rand.intn", "opa.runtime"}
PROCESS_TIMEOUT = 20
EVAL_TIMEOUT = 10
COMPLETED = {"source_audit_completed", "source_audit_completed_blocked"}


def encoded(value):
    return (json.dumps(value, ensure_ascii=False, indent=2, sort_keys=True, allow_nan=False) + "\n").encode()


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def reject_constant(value):
    raise ValueError(f"Non-JSON numeric constant: {value}")


def unique_object(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise ValueError(f"Duplicate JSON key: {key}")
        result[key] = value
    return result


def loads(value):
    return json.loads(value, parse_constant=reject_constant, object_pairs_hook=unique_object)


def read_json(path):
    return loads(path.read_bytes())


def require(condition, message):
    if not condition:
        raise ValueError(message)


def safe_path(root, relative):
    require(isinstance(relative, str), "A bound path must be a string")
    path = Path(relative)
    require(not path.is_absolute() and ".." not in path.parts, f"Unsafe relative path: {relative}")
    target = (root / path).resolve()
    require(target.is_relative_to(root.resolve()), f"Path escapes root: {relative}")
    return target


def check_record(root, record):
    path = safe_path(root, record["path"])
    require(path.is_file(), f"Missing bound file: {record['path']}")
    require(path.stat().st_size == record["bytes"] and digest(path) == record["sha256"],
            f"Changed bound file: {record['path']}")


def manifest_entry(measure):
    require(digest(MANIFEST) == MANIFEST_SHA256, "The frozen screening manifest has changed")
    manifest = read_json(MANIFEST)
    require(manifest["candidate_commit"] == CANDIDATE_COMMIT, "Unexpected candidate commit")
    matches = [entry for entry in manifest["entries"] if entry["measure_id"] == measure]
    require(len(matches) == 1, f"Not exactly one frozen candidate for {measure}")
    return manifest, matches[0]


def make_binding(root, measure):
    """Derive identity only; a successful binding does not mean a source was read."""
    manifest, entry = manifest_entry(measure)
    head = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip()
    require(head == CANDIDATE_COMMIT, f"Candidate HEAD differs: {head}")
    run_prefix = f"runs/{entry['run_id']}/"
    for record in entry["artifacts"]:
        require(record["path"].startswith(run_prefix), "Artifact is outside selected run")
        check_record(root, record)
    actual = {p.relative_to(root).as_posix() for p in safe_path(root, run_prefix).rglob("*") if p.is_file()}
    expected = {item["path"] for item in entry["artifacts"]}
    require(actual == expected, "Run file inventory differs from the published artifact inventory")
    run = read_json(safe_path(root, run_prefix + "run.json"))
    require(run["run_id"] == entry["run_id"] and run["measure"] == measure, "Run identity differs")
    declared_sources = sorted(
        ({"path": "sources/oepul/" + source["source_path"], "bytes": source["bytes"],
          "sha256": source["sha256"]} for source in run["sources"]), key=lambda item: item["path"])
    require(declared_sources == sorted(entry["sources"], key=lambda item: item["path"]),
            "Original run and frozen screening source sets differ")
    require(run["profile"]["path"] == entry["profile"]["path"] and
            run["profile"]["sha256"] == entry["profile"]["sha256"], "Profile identity differs")
    load_paths = entry["load_paths"]
    require(len(load_paths) == len(set(load_paths)), "Duplicate executable load path")
    for path in load_paths:
        require(path in expected and path.startswith(run_prefix + "workspace/") and
                path[len(run_prefix + "workspace/"):].startswith(("policy/", "data/")),
                f"Executable load path is not original policy/data: {path}")
        require(Path(path).suffix in {".rego", ".json"}, f"Unexpected executable extension: {path}")
    files = [{**record, "kind": "executable" if record["path"] in load_paths else "historical_artifact"}
             for record in entry["artifacts"]]
    for kind, records in (("original_source", entry["sources"]),
                          ("canonical_profile", [entry["profile"]]),
                          ("runtime_pin", manifest["runtime_records"])):
        for record in records:
            check_record(root, record)
            files.append({**record, "kind": kind})
    require(len({item["path"] for item in files}) == len(files), "Duplicate bound path")
    checksums = read_json(safe_path(root, "runner/validation/opa-checksums.json"))
    runtime = run["opa_runtime"]
    require(runtime["version"] == manifest["opa_version"], "Historical OPA version differs")
    require(runtime["sha256"] in {item["sha256"] for item in checksums[runtime["version"]].values()},
            "Historical OPA hash is absent from repository pins")
    return {"schema_version": 1, "kind": "public-development-source-audit-binding",
            "candidate_commit": CANDIDATE_COMMIT, "measure_id": measure, "run_id": entry["run_id"],
            "screening_manifest_sha256": MANIFEST_SHA256,
            "opa_version": runtime["version"], "opa_sha256": runtime["sha256"],
            "load_paths": load_paths, "files": sorted(files, key=lambda item: item["path"]),
            "note": "Identity only. Historical selftests are not independent labels. Only original policy/data are executed."}


def verify_binding(root, measure, binding):
    expected = make_binding(root, measure)
    require(binding == expected, "Binding differs from the exact historical source/artifact set")
    return expected


def typed_equal(left, right):
    """JSON structural equality, with 0/false distinct and 1/1.0 equivalent."""
    if type(left) in {int, float} and type(right) in {int, float}:
        return left == right
    if type(left) is not type(right):
        return False
    if isinstance(left, dict):
        return left.keys() == right.keys() and all(typed_equal(left[key], right[key]) for key in left)
    if isinstance(left, list):
        return len(left) == len(right) and all(typed_equal(a, b) for a, b in zip(left, right))
    return left == right


def lookup(value, path):
    require(isinstance(path, list), "Expectation paths must be arrays")
    for key in path:
        if isinstance(value, dict) and isinstance(key, str) and key in value:
            value = value[key]
        elif isinstance(value, list) and type(key) is int and 0 <= key < len(value):
            value = value[key]
        else:
            return False, None
    return True, value


def check_expectation(expectation, observed):
    operator = expectation["operator"]
    require(operator in {"equals", "contains_rule", "excludes_rule", "status_equals"},
            f"Unsupported expectation operator: {operator}")
    expected = expectation["expected"]
    if operator == "status_equals":
        actual = observed["status"]
    elif observed["status"] != "defined":
        return {**expectation, "actual_status": observed["status"], "passed": False}
    else:
        present, actual = lookup(observed["output"], expectation["path"])
        if not present:
            return {**expectation, "actual_absent": True, "passed": False}
    if operator in {"equals", "status_equals"}:
        passed = typed_equal(actual, expected)
    elif (isinstance(actual, list) and all(isinstance(item, dict) and
          isinstance(item.get("rule_id"), str) for item in actual)):
        actual = sorted({item["rule_id"] for item in actual})
        passed = (expected in actual) if operator == "contains_rule" else (expected not in actual)
    else:
        return {**expectation, "actual": actual, "invalid_rule_collection": True, "passed": False}
    return {**expectation, "actual": actual, "passed": passed}


def execute(opa, arguments, runtime, payload=None):
    try:
        process = subprocess.run([str(opa), *arguments], cwd=runtime,
                                 input=None if payload is None else encoded(payload),
                                 stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                 timeout=PROCESS_TIMEOUT, check=False)
    except subprocess.TimeoutExpired:
        return {"process_timeout_seconds": PROCESS_TIMEOUT}
    result = {"exit_code": process.returncode}
    if process.stdout:
        result["json"] = loads(process.stdout)
    if process.stderr:
        result["stderr"] = process.stderr.decode().replace(str(runtime), "<audit-runtime>")
    return result


def allowed_query(query, measure, fixture, historical_query):
    require(isinstance(query, str) and query.strip(), "A native query must be a nonempty string")
    prefixes = ("data.oepul." + measure, "data." + measure)
    simple = any(re.fullmatch(re.escape(prefix) + r"(?:\.[A-Za-z_][A-Za-z0-9_]*)*", query)
                 for prefix in prefixes)
    require(simple or query == historical_query or query in fixture.get("allowed_queries", []),
            "Compound query must be explicitly listed in fixture allowed_queries")


def replay(root, opa, measure, audit_dir):
    binding_path = audit_dir / "binding.json"
    binding = verify_binding(root, measure, read_json(binding_path))
    require(digest(opa) == binding["opa_sha256"], "OPA binary hash differs from exact historical pin")
    fixture_path = audit_dir / "development-probes.json"
    fixture_bytes = fixture_path.read_bytes()
    fixture = loads(fixture_bytes)
    require(fixture.get("measure_id", measure) == measure, "Fixture measure differs")
    require(fixture.get("run_id", binding["run_id"]) == binding["run_id"], "Fixture run differs")
    cases = fixture["cases"]
    require(isinstance(cases, list) and bool(cases), "Audit requires explicit nonempty development cases")
    ids = [case["case_id"] for case in cases]
    require(all(isinstance(item, str) and item for item in ids) and len(ids) == len(set(ids)),
            "Case IDs must be unique nonempty strings")
    _, entry = manifest_entry(measure)
    check_record(REPO, entry["fixture"])
    historical_query = read_json(REPO / entry["fixture"]["path"])["query"]
    for case in cases:
        require(isinstance(case["input"], dict), "Each case needs an explicit native input object")
        require(isinstance(case["expectations"], list) and bool(case["expectations"]),
                "Each probe needs explicit source-derived expectations")
        allowed_query(case.get("query", fixture.get("query")), measure, fixture, historical_query)
    observations = []
    with tempfile.TemporaryDirectory(prefix="opus-public-development-audit-") as directory:
        runtime = Path(directory)
        capabilities = execute(opa, ["capabilities", "--current"], runtime)
        require(capabilities.get("exit_code") == 0, f"Cannot load pinned capabilities: {capabilities}")
        capabilities = capabilities["json"]
        capabilities["allow_net"] = []
        capabilities["builtins"] = [item for item in capabilities["builtins"] if item["name"] not in BLOCKED]
        (runtime / "capabilities.json").write_bytes(encoded(capabilities))
        bound = {item["path"]: item for item in binding["files"]}
        copied = []
        prefix = f"runs/{binding['run_id']}/workspace/"
        for relative in binding["load_paths"]:
            target = safe_path(runtime / "bundle", relative[len(prefix):])
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(safe_path(root, relative), target)
            require(digest(target) == bound[relative]["sha256"], f"Runtime copy changed: {relative}")
            copied.append(target.relative_to(runtime).as_posix())
        # OPA derives JSON namespaces from the directory load root. Loading
        # each file independently would flatten data/<measure>/ and silently
        # change native evaluation semantics. Match the frozen screening.
        bundle_roots = ["bundle/policy", "bundle/data"]
        compiled = execute(opa, ["check", "--strict", "--format=json", "--capabilities",
                                 "capabilities.json", *bundle_roots], runtime)
        require(compiled.get("exit_code") == 0, f"Original strict compilation failed: {compiled}")
        load = [arg for path in bundle_roots for arg in ("--data", path)]
        for case in cases:
            query = case.get("query", fixture.get("query"))
            native = execute(opa, ["eval", "--format=json", "--stdin-input", "--strict-builtin-errors",
                                    f"--timeout={EVAL_TIMEOUT}s", "--capabilities", "capabilities.json",
                                    *load, query], runtime, case["input"])
            result = native.get("json", {})
            status = ("process_timeout" if "process_timeout_seconds" in native else
                      "runtime_error" if native["exit_code"] != 0 else
                      "defined" if result.get("result") else "undefined")
            observed = {"case_id": case["case_id"], "query": query, "status": status,
                        "input_sha256": hashlib.sha256(encoded(case["input"])).hexdigest()}
            if status == "defined":
                expressions = result["result"][0]["expressions"]
                require(len(result["result"]) == 1 and len(expressions) == 1,
                        "Use one expression per query; explicit object projection supports multiple values")
                observed["output"] = expressions[0]["value"]
            else:
                observed["native_result"] = result
                if status == "process_timeout":
                    observed["process_timeout_seconds"] = PROCESS_TIMEOUT
            if "stderr" in native:
                observed["stderr"] = native["stderr"]
            observed["checks"] = [check_expectation(check, observed) for check in case["expectations"]]
            observations.append(observed)
    return {"schema_version": 1, "kind": "public-development-source-audit",
            "candidate_commit": CANDIDATE_COMMIT, "measure_id": measure, "run_id": binding["run_id"],
            "binding_sha256": digest(binding_path),
            "fixture_sha256": hashlib.sha256(fixture_bytes).hexdigest(),
            "opa_version": binding["opa_version"], "compile": "strict_passed", "cases": observations,
            "summary": {"cases": len(observations), "checks": sum(len(item["checks"]) for item in observations),
                        "expectations_met": sum(check["passed"] for item in observations for check in item["checks"])}}


def namespace_preflight(root, opa):
    """Technical regression only: reproduce one frozen nested-data publication.

    This calls the low-level replay directly, which does not invoke preflight;
    it cannot recurse. Its temporary fixture is never a domain-source oracle.
    """
    require(digest(NAMESPACE_REFERENCE) == NAMESPACE_REFERENCE_SHA256,
            "Frozen namespace regression reference changed")
    reference = read_json(NAMESPACE_REFERENCE)
    baseline = next(item for item in reference["cases"] if item["case_id"] == "baseline")
    require(baseline["status"] == "defined", "Namespace regression needs an executed frozen baseline")
    _, entry = manifest_entry("o6_1b")
    check_record(REPO, entry["fixture"])
    original_fixture = read_json(REPO / entry["fixture"]["path"])
    original_case = next(item for item in original_fixture["cases"] if item["case_id"] == "baseline")
    require(typed_equal(baseline["input"], original_case["input"]), "Namespace regression input differs")
    with tempfile.TemporaryDirectory(prefix="opus-technical-namespace-control-") as temporary:
        directory = Path(temporary)
        binding = make_binding(root, "o6_1b")
        (directory / "binding.json").write_bytes(encoded(binding))
        fixture = {"kind": "technical-namespace-regression-not-source-expectations",
                   "measure_id": "o6_1b", "run_id": entry["run_id"], "query": original_fixture["query"],
                   "cases": [{"case_id": "technical-frozen-o6_1b-baseline", "input": original_case["input"],
                              "expectations": [{"operator": "status_equals", "expected": "defined"},
                                               {"operator": "equals", "path": [], "expected": baseline["output"]}]}]}
        (directory / "development-probes.json").write_bytes(encoded(fixture))
        observed = replay(root, opa, "o6_1b", directory)
        require(all(check["passed"] for case in observed["cases"] for check in case["checks"]),
                "Technical namespace preflight failed: frozen native BIO baseline not reproduced; do not interpret audit outputs")
    return {"kind": "technical-namespace-regression-not-semantic-approval", "status": "verified",
            "reference_path": NAMESPACE_REFERENCE.relative_to(REPO).as_posix(),
            "reference_sha256": NAMESPACE_REFERENCE_SHA256, "measure_id": "o6_1b", "case_id": "baseline",
            "candidate_commit": CANDIDATE_COMMIT, "native_status": "defined",
            "comparison": "Exact typed equality of the entire published native output; not normative correctness.",
            "source_audit_cases_added": 0}


def verify_all(root, opa):
    """Replay only completed queue entries; never mark skipped entries complete."""
    specification = importlib.util.spec_from_file_location(
        "opus_public_audit_validator", REPO / "tools/validate_opus_run_review.py")
    validator = importlib.util.module_from_spec(specification)
    specification.loader.exec_module(validator)
    queue = validator.validate_queue()
    print(json.dumps(namespace_preflight(root, opa)), flush=True)
    completed = skipped = 0
    for entry in queue["entries"]:
        measure = entry["measure_id"]
        if entry["status"] not in COMPLETED:
            skipped += 1
            print(f"{measure}: skipped ({entry['status']}); no completion inferred", flush=True)
            continue
        print(f"{measure}: verify completed dossier {entry['run_id']}", flush=True)
        # Includes the unchanged legacy replay.py for the original first audit.
        validator.validate_dossier(root, entry, opa)
        completed += 1
        print(f"{measure}: byte-identical replay verified", flush=True)
    print(json.dumps({"completed_dossiers_verified": completed, "unfinished_dossiers_skipped": skipped,
                      "app_promotions": 0, "expert_acceptances": 0}))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    target = parser.add_mutually_exclusive_group(required=True)
    target.add_argument("--measure")
    target.add_argument("--all", action="store_true", help="Verify completed dossiers in queue order; skip unfinished")
    parser.add_argument("--candidate-root", type=Path, required=True)
    parser.add_argument("--opa", type=Path)
    action = parser.add_mutually_exclusive_group(required=True)
    action.add_argument("--bind", action="store_true", help="Write exact historical binding; no source review claim")
    action.add_argument("--write", action="store_true", help="Write newly observed diagnostic evidence")
    action.add_argument("--verify", action="store_true", help="Replay and compare bytes, without writing")
    args = parser.parse_args()
    root = args.candidate_root.resolve()
    if args.all:
        if not args.verify or args.opa is None:
            parser.error("--all requires --verify and --opa; batch bind/write are prohibited")
        verify_all(root, args.opa.resolve())
        return
    audit_dir = safe_path(HERE / "measures", args.measure)
    require(not audit_dir.is_relative_to(root), "Audit output must be outside immutable candidate root")
    if args.bind:
        binding = make_binding(root, args.measure)
        if args.opa:
            require(digest(args.opa.resolve()) == binding["opa_sha256"], "OPA hash differs")
        audit_dir.mkdir(parents=True, exist_ok=True)
        (audit_dir / "binding.json").write_bytes(encoded(binding))
        print(json.dumps({"measure_id": args.measure, "bound_files": len(binding["files"])}))
        return
    require(args.opa is not None, "--opa is required for --write or --verify")
    print(json.dumps(namespace_preflight(root, args.opa.resolve())), flush=True)
    result = replay(root, args.opa.resolve(), args.measure, audit_dir)
    output = audit_dir / "observations.json"
    rendered = encoded(result)
    if args.verify:
        require(output.read_bytes() == rendered, "Observed evidence differs; inspect before replacing it")
    else:
        output.write_bytes(rendered)
    print(json.dumps({"measure_id": args.measure, **result["summary"]}))
    for item in result["cases"]:
        print(f"{item['case_id']}: {item['status']}, unmet expectations={sum(not check['passed'] for check in item['checks'])}")


if __name__ == "__main__":
    main()
