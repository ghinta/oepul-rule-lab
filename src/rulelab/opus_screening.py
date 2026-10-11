"""Hash-bound Opus development diagnosis; no model generation or promotion.

The published candidate snapshot and the main-based analysis remain separate.
Historical sources, profiles, queries and model outputs are never repaired.
"""
from __future__ import annotations

import argparse
from collections import Counter
import csv
import hashlib
import io
import os
from pathlib import Path

from rulelab import screening as core
from rulelab.screening_report import render_report

ROOT = core.ROOT
REPORT = Path("docs/analysis/opus-screening-20261011")
LUNA_REPORT = Path("docs/analysis/luna-screening-20261011")
MODEL = "claude-opus-5-5"
CANDIDATE_COMMIT = "e009eed4a83ff076b26eba33ac433ac2b0642621"
LUNA_COMMIT = "d2b63972c99056fde4e032029e1432639e281fda"
SELECTION = "latest finalized candidate per measure by max(finalized_at, run_id); no success filter"
REPLAY = (
    "PYTHONPATH=src OPA_BIN=/absolute/path/opa python -m rulelab.opus_screening verify "
    "--candidate-root /absolute/path/candidate-e009eed"
)
DISCLAIMER = (
    "Synthetische, bereits sichtbare Entwicklungsfälle auf unveränderten historischen "
    "Opus-Artefakten. Die Luna-Fakten werden nur bei belegbarer Vertragszuordnung "
    "übersetzt; nicht abbildbare Fakten bleiben ausdrücklich offen. Native Ausgaben "
    "sind keine unabhängig beurteilten Sollwerte, keine Genauigkeitsmessung und "
    "keine Förderfreigabe. Unterschiedliche Quellen, Werkzeuge und Budgets erlauben "
    "keine isolierte Aussage über den Modelleffekt."
)


def select_candidates(candidate_root: Path) -> tuple[dict[str, str], list[dict]]:
    selected: dict[str, dict] = {}
    inventory = []
    for path in sorted((candidate_root / "runs").glob("*/run.json")):
        run = core.load_json(path)
        if run.get("model", {}).get("model") != MODEL:
            continue
        if run.get("status") != "finalized":
            raise ValueError("The pinned Opus publication contains an unfinished candidate")
        if path.parent.name != run["run_id"] or run["measure"] not in core.MEASURES:
            raise ValueError("Published candidate path/identity mismatch")
        if not isinstance(run.get("finalized_at"), str) or not run["finalized_at"]:
            raise ValueError("Finalized selection requires a timestamp")
        inventory.append({"run_id": run["run_id"], "measure_id": run["measure"],
                          "finalized_at": run["finalized_at"],
                          "metadata": core.record(candidate_root, path)})
        previous = selected.get(run["measure"])
        if previous is None or (run["finalized_at"], run["run_id"]) > (previous["finalized_at"], previous["run_id"]):
            selected[run["measure"]] = run
    if set(selected) != set(core.MEASURES) or len(inventory) != 36:
        raise ValueError("Pinned publication must contain 36 finalized Opus runs for 26 measures")
    return {measure: selected[measure]["run_id"] for measure in core.MEASURES}, inventory


def validate_translation(root: Path, fixture: dict) -> None:
    translation = fixture.get("luna_translation")
    if not isinstance(translation, dict):
        raise ValueError("Opus fixture needs explicit Luna fact translation")
    expected = (LUNA_REPORT / "fixtures" / f"{fixture['measure_id']}.json").as_posix()
    if translation.get("fixture_path") != expected:
        raise ValueError("Translation must refer to the matching frozen Luna fixture")
    original = core.load_json(core.relative_file(root, expected))
    cases = translation.get("cases")
    if not isinstance(cases, list) or [c.get("case_id") for c in cases] != [c["case_id"] for c in original["cases"]]:
        raise ValueError("Translation must account for every original Luna case, including gaps")
    for case in cases:
        for key in ("mapped_facts", "unmapped_facts"):
            if not isinstance(case.get(key), list) or any(not isinstance(x, str) or not x.strip() for x in case[key]):
                raise ValueError("Translation facts must be explicit nonempty descriptions")
        if not case["mapped_facts"] and not case["unmapped_facts"]:
            raise ValueError("Translation cannot silently omit all facts")
    if not isinstance(translation.get("comparison_limit"), str) or not translation["comparison_limit"].strip():
        raise ValueError("Translation needs an explicit comparison limit")


def create_manifest(root: Path, candidate_root: Path, report: Path) -> dict:
    selection, inventory = select_candidates(candidate_root)
    manifest = core.create_manifest(root, report, LUNA_COMMIT, model=MODEL,
                                    run_ids=selection, candidate_root=candidate_root)
    luna_manifest = core.load_json(root / LUNA_REPORT / "manifest.json")
    # Validate the old baseline independently, retaining its existing format/bytes.
    core.verify_manifest(root, luna_manifest)
    manifest.update(candidate_commit=CANDIDATE_COMMIT, selection_method=SELECTION,
                    published_opus_inventory=inventory,
                    provider_revision="not_recorded_in_historical_run_metadata",
                    luna_baseline={"commit": LUNA_COMMIT, "records": [
                        core.record(root, root / LUNA_REPORT / name)
                        for name in ("manifest.json", "results.json", "matrix.csv")
                    ] + [core.record(root, root / LUNA_REPORT / "fixtures" / f"{m}.json") for m in core.MEASURES]})
    for entry in manifest["entries"]:
        fixture = core.load_json(root / entry["fixture"]["path"])
        validate_translation(root, fixture)
    return manifest


def verify_manifest(root: Path, candidate_root: Path, report: Path, manifest: dict) -> None:
    core.verify_manifest(root, manifest, model=MODEL, candidate_root=candidate_root)
    if manifest != create_manifest(root, candidate_root, report):
        raise ValueError("Opus manifest selection, provenance or Luna baseline changed")


def historical_conditions(root: Path, run: dict) -> dict:
    run_dir = root / "runs" / run["run_id"]
    prompts = [core.record(root, p) for p in sorted(run_dir.glob("*prompt*")) if p.is_file()]
    return {"run_id": run["run_id"], "model": run["model"],
            "provider_revision": "not_recorded_in_historical_run_metadata",
            "created_at": run["created_at"], "finalized_at": run["finalized_at"],
            "generation_attempt": run.get("generation_attempt"),
            "resumed_attempts": run.get("resumed_attempts", []),
            "invocation": run.get("invocation"),
            "quality_gate_version_recorded": run.get("quality_gate_version"),
            "historical_gate_note": "Version absent in run.json; handoff reports v1. No retrospective v2-generation claim.",
            "prompt_records": prompts, "profile": run["profile"],
            "source_records": run["sources"], "opa_runtime_recorded": run.get("opa_runtime"),
            "generator_result": run.get("generator_result"),
            "generator_exit_code": run.get("generator_exit_code"),
            "budget_note": "Historical CLI sessions/continuations and tool use are not a shared controlled budget. Missing Luna usage stays missing."}


def comparison(root: Path, candidate_root: Path, manifest: dict, results: dict) -> dict:
    luna = core.load_json(root / LUNA_REPORT / "manifest.json")
    luna_entries = {e["measure_id"]: e for e in luna["entries"]}
    observed = {m["measure_id"]: m for m in results["measures"]}
    rows = []
    for entry in manifest["entries"]:
        measure = entry["measure_id"]
        opus_run = core.load_json(candidate_root / "runs" / entry["run_id"] / "run.json")
        luna_run = core.load_json(root / "runs" / luna_entries[measure]["run_id"] / "run.json")
        same = {(s["source_path"], s["sha256"]) for s in opus_run["sources"]} == {
            (s["source_path"], s["sha256"]) for s in luna_run["sources"]}
        translation = observed[measure]["luna_translation"]
        coverage = core.load_json(candidate_root / "runs" / entry["run_id"] / "workspace/rules/coverage.json")
        unresolved = [{"source_id": source["source_id"], "item": item}
                      for source in coverage["sources"] for item in source["items"] if item["disposition"] == "unresolved"]
        rows.append({"measure_id": measure, "source_hash_sets_equal": same,
                     "luna": historical_conditions(root, luna_run),
                     "opus": historical_conditions(candidate_root, opus_run),
                     "translation": translation,
                     "executed_case_ids": [c["case_id"] for c in observed[measure]["cases"]],
                     "native_case_observations": [{"case_id": c["case_id"], "status": c["status"],
                        "input_change_count": len(c["changes_from_baseline"]),
                        "output_changed_from_baseline": c["output_changed_from_baseline"]}
                        for c in observed[measure]["cases"]],
                     "reported_unresolved_coverage": unresolved,
                     "semantic_judgement": "not_adjudicated", "isolated_model_effect": False})
    costs = [core.load_json(candidate_root / item["metadata"]["path"])["generator_result"]["total_cost_usd"]
             for item in manifest["published_opus_inventory"]]
    return {"kind": "development-diagnostic-comparison", "candidate_commit": CANDIDATE_COMMIT,
            "luna_commit": LUNA_COMMIT, "semantic_validation": False,
            "source_hash_set_counts": dict(Counter("same" if r["source_hash_sets_equal"] else "different" for r in rows)),
            "reported_unresolved_count": sum(len(r["reported_unresolved_coverage"]) for r in rows),
            "opus_cost_usd": {"latest_26": sum(r["opus"]["generator_result"]["total_cost_usd"] for r in rows),
                              "all_36": sum(costs),
                              "note": "Last generator_result per published run; cumulative attempts are not added again. These are reported list-cost equivalents, not invoices or fair model comparisons."},
            "measures": rows}


def report_files(root: Path, candidate_root: Path, manifest: dict, results: dict) -> dict[str, bytes]:
    files = {"results.json": core.json_bytes(results)}
    files.update({f"results/{m['measure_id']}.json": core.json_bytes(m) for m in results["measures"]})
    rendered = render_report(manifest, results, label="Opus", replay_command=REPLAY, disclaimer=DISCLAIMER,
                             artifact_base_url=f"https://github.com/ghinta/oepul-rule-lab/blob/{CANDIDATE_COMMIT}/")
    intro = (f"Kandidatencommit: `{CANDIDATE_COMMIT}` (unveränderlicher PR-#79-Stand). "
             "26 aktuelle Kandidaten aus 36 finalisierten Veröffentlichungen; zehn ersetzte Runs bleiben in der Historie. "
             "[Historische Bedingungen und Zuordnung](comparison.json) · [Vergleichsmatrix](comparison.csv).\n\n")
    rendered["README.md"] = rendered["README.md"].replace("## Ausführungsübersicht", intro + "## Ausführungsübersicht", 1)
    rendered["index.html"] = rendered["index.html"].replace('<a href="matrix.csv">CSV</a>',
        '<a href="matrix.csv">CSV</a><a href="comparison.json">Historische Bedingungen</a>'
        '<a href="comparison.csv">Vergleichsmatrix</a><span>Kandidatencommit: ' + CANDIDATE_COMMIT + '</span>', 1)
    files.update({name: value.encode() for name, value in rendered.items()})
    compared = comparison(root, candidate_root, manifest, results)
    files["comparison.json"] = core.json_bytes(compared)
    buffer = io.StringIO(newline="")
    writer = csv.writer(buffer, lineterminator="\n")
    writer.writerow(("measure_id", "luna_run_id", "opus_run_id", "source_hash_sets_equal", "executed_cases",
                     "unmapped_fact_descriptions", "native_variation_input_changes", "reported_unresolved", "semantic_judgement", "comparison_limit"))
    for row in compared["measures"]:
        writer.writerow((row["measure_id"], row["luna"]["run_id"], row["opus"]["run_id"], row["source_hash_sets_equal"],
                         len(row["executed_case_ids"]), sum(len(c["unmapped_facts"]) for c in row["translation"]["cases"]),
                         next((c["input_change_count"] for c in row["native_case_observations"] if c["case_id"] == "variation"), "fixture_gap"),
                         len(row["reported_unresolved_coverage"]), row["semantic_judgement"], row["translation"]["comparison_limit"]))
    files["comparison.csv"] = buffer.getvalue().encode()
    return files


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("freeze", "replay", "verify"))
    parser.add_argument("--candidate-root", type=Path, required=True)
    parser.add_argument("--report-dir", type=Path, default=REPORT)
    parser.add_argument("--opa-bin", type=Path, default=Path(os.environ.get("OPA_BIN", "tools/opa")))
    args = parser.parse_args(argv)
    report = (ROOT / args.report_dir).resolve()
    candidate_root = args.candidate_root.resolve()
    if (not report.is_relative_to(ROOT / "docs/analysis") or candidate_root.is_relative_to(report)
            or report.is_relative_to(candidate_root)):
        raise ValueError("Analysis writes must be separate from the historical candidate snapshot")
    path = report / "manifest.json"
    if args.command == "freeze":
        if path.exists():
            raise ValueError("Manifest already frozen; use a new report directory for changed inputs")
        manifest = create_manifest(ROOT, candidate_root, report)
        verify_manifest(ROOT, candidate_root, report, manifest)
        path.write_bytes(core.json_bytes(manifest))
        print("Frozen 26 Opus candidates and all 36 publication metadata records")
        return 0
    manifest = core.load_json(path)
    verify_manifest(ROOT, candidate_root, report, manifest)
    results = core.execute(ROOT, manifest, args.opa_bin, model=MODEL, candidate_root=candidate_root)
    verify_manifest(ROOT, candidate_root, report, manifest)
    for name, payload in report_files(ROOT, candidate_root, manifest, results).items():
        target = report / name
        if not target.resolve().is_relative_to(report):
            raise ValueError("Report output escapes analysis directory")
        if args.command == "verify":
            if not target.is_file() or target.read_bytes() != payload:
                raise ValueError(f"Opus replay differs from frozen output: {name}")
        else:
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(payload)
    counts = Counter(c["status"] for m in results["measures"] for c in m["cases"])
    print(core.json_bytes({"measures": len(results["measures"]), "case_status_counts": dict(counts),
                          "fixture_gaps": sum(not m["cases"] for m in results["measures"]),
                          "semantic_validation": False}).decode().strip())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
