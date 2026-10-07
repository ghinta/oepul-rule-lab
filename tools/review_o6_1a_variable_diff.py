"""Read-only comparison of historical UBB proposals; never promote fields."""

from __future__ import annotations

import argparse
import csv
import hashlib
import io
import json
from pathlib import Path
import re
import subprocess

from rulelab.cli import flatten, profile_diff, rego_input_paths
from rulelab.grounding import normalize_evidence
from pypdf import PdfReader

ROOT = Path(__file__).resolve().parents[1]
DOSSIER = ROOT / "docs/analysis/o6_1a-variable-diff-20261007"
RUNS = {
    "luna": "v2-o6_1a-luna-high-20260930",
    "opus": "v2-o6_1a-opus-5.5-high-20260929",
}
LAB_COMMIT = "7a296d28cb5b92e2758c5a3889c929ea1db60fe5"
APP_COMMIT = "5296108f5756ef1463c25a49d93d4a346e9b5e9c"


def load(path: Path):
    return json.loads(path.read_text())


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def require(condition: bool, message: str):
    if not condition:
        raise ValueError(message)


def source_paths():
    paths = [
        DOSSIER / "app-baseline.json",
        ROOT / "sources/oepul/originals/o6_1a_ubb_2026_04.pdf",
        ROOT / "sources/oepul/legal/20241011_srl_oepul_2023.pdf",
    ]
    for name in RUNS.values():
        run = ROOT / "runs" / name
        paths.extend(run / p for p in [
            "run.json", "model.json", "baseline_profile.json",
            "artifacts/inventory.json", "artifacts/profile-diff.json",
            "artifacts/proposed-profile.json", "artifacts/input-paths.json",
            "artifacts/direct-profile-diff.json", "artifacts/grounding-validation.json",
            "artifacts/technical-validation.json", "workspace/rules/profile_changes.json",
            "workspace/rules/rules.json", "workspace/rules/citations.json",
            "workspace/notes/assumptions.md",
        ])
        for folder, glob in [("policy", "*.rego"), ("data", "*.json"), ("tests", "*.rego")]:
            paths.extend(sorted((run / "workspace" / folder).rglob(glob)))
    return sorted(paths)


def manifest():
    return {
        "lab_commit": LAB_COMMIT,
        "app_commit": APP_COMMIT,
        "files": {str(p.relative_to(ROOT)): digest(p) for p in source_paths()},
    }


def app_paths(app: dict) -> tuple[dict, dict]:
    declared = flatten(app["files"]["backend/policy/farm_profile_schema_blueprint.json"]["schema"])
    registered = {}
    for path, file in app["files"].items():
        if "field_registry_v1.csv" not in path:
            continue
        prefix = "land.parcels[]." if "parcel_field" in path else (
            "livestock.species_groups[]." if "livestock_field" in path else ""
        )
        for row in file["rows"]:
            registered[prefix + row["variable_path"]] = row
    return declared, registered


def run_diff(model: str, name: str, declared: dict, registered: dict) -> dict:
    run = ROOT / "runs" / name
    metadata = load(run / "run.json")
    require(metadata["measure"] == "o6_1a" and metadata["status"] == "finalized", "unexpected run basis")
    require(metadata["run_id"] == name, "run identity mismatch")
    baseline = load(run / "baseline_profile.json")
    proposed = load(run / "artifacts/proposed-profile.json")
    delta = profile_diff(baseline, proposed)
    require(delta == load(run / "artifacts/profile-diff.json"), "historical profile diff mismatch")
    require(not any(load(run / "artifacts/direct-profile-diff.json").values()), "historical baseline was edited")
    changes = load(run / "workspace/rules/profile_changes.json")["changes"]
    require(bool(changes), "empty proposal inventory")
    require(len({c["path"] for c in changes}) == len(changes), "duplicate proposal path")
    rules = load(run / "workspace/rules/rules.json")["rules"]
    rule_ids = {r["id"] for r in rules}
    require(len(rule_ids) == len(rules), "duplicate rule ID")
    citations = load(run / "workspace/rules/citations.json")["references"]
    citation_ids = {c["reference_id"] for c in citations}
    require(len(citation_ids) == len(citations), "duplicate citation ID")
    for c in changes:
        require(set(c["rule_ids"]) <= rule_ids, f"unknown rules at {c['path']}")
        require(set(c["source_reference_ids"]) <= citation_ids, f"unknown citation at {c['path']}")
    leaves = []
    for action, values in delta.items():
        for path, value in values.items():
            before = value["before"] if action == "changed" else (value if action == "removed" else None)
            after = value["after"] if action == "changed" else (value if action == "added" else None)
            parents = [c for c in changes if path == c["path"] or path.startswith(c["path"] + ".") or path.startswith(c["path"] + "[]")]
            require(bool(parents), f"diff leaf without proposal: {path}")
            leaves.append({
                "path": path, "action": action,
                "before_present": action != "added", "before": before,
                "after_present": action != "removed", "after": after,
                "proposal_paths": [c["path"] for c in parents],
                "rule_ids": sorted({i for c in parents for i in c["rule_ids"]}),
                "source_reference_ids": sorted({i for c in parents for i in c["source_reference_ids"]}),
                "app_schema_present": path in declared,
                "app_schema_notation": declared.get(path),
                "app_registered_exact_path": path in registered,
                "admission_status": "not_decided",
                "semantic_equivalence": "not_reviewed",
            })
    declared_inputs = sorted({p for r in rules for c in r["conditions"] for p in c["input_paths"]})
    stored_inputs = load(run / "artifacts/input-paths.json")
    scanned = rego_input_paths(sorted((run / "workspace/policy").rglob("*.rego")))
    # Record literal root access locations independently of the historical scanner.
    # This is an observation, not a complete alias/helper analysis.
    direct_root_sites = []
    for module in sorted((run / "workspace/policy").rglob("*.rego")):
        for number, line in enumerate(module.read_text().splitlines(), 1):
            if re.search(r"object\.get\(\s*input\s*,", line):
                direct_root_sites.append({"file": str(module.relative_to(ROOT)), "line": number, "expression": line.strip()})
    notes = (run / "workspace/notes/assumptions.md").read_text()
    return {
        "run_id": name, "model": load(run / "model.json"),
        "generation_attempt": metadata["generation_attempt"], "finalized_at": metadata["finalized_at"],
        "proposal_count": len(changes), "rule_count": len(rules),
        "baseline_sha256": digest(run / "baseline_profile.json"),
        "profile_diff": delta, "leaf_diff": sorted(leaves, key=lambda x: x["path"]),
        "proposals": changes,
        "citations": [
            {k: c[k] for k in ["reference_id", "source_id", "source_path", "source_sha256", "page", "section", "evidence_text"]}
            for c in citations
            if c["reference_id"] in {i for change in changes for i in change["source_reference_ids"]}
        ],
        "declared_rule_input_paths": declared_inputs,
        "stored_rego_input_paths": stored_inputs,
        "current_extractor_paths": scanned,
        "literal_object_get_input_sites": direct_root_sites,
        "consumption_review_status": "incomplete_static_analysis",
        "model_assumptions": notes,
        "model_assumptions_accepted": False,
    }


def build() -> dict:
    app = load(DOSSIER / "app-baseline.json")
    require(app["commit"] == APP_COMMIT and app["runtime_values_included"] is False, "unexpected app baseline")
    declared, registered = app_paths(app)
    runs = {model: run_diff(model, name, declared, registered) for model, name in RUNS.items()}
    require(runs["luna"]["baseline_sha256"] == runs["opus"]["baseline_sha256"], "different model baseline profiles")
    paths = {m: {c["path"] for c in r["proposals"]} for m, r in runs.items()}
    opus_citations = load(ROOT / "runs" / RUNS["opus"] / "workspace/rules/citations.json")["references"]
    period_evidence = []
    for reference_id, relative in [
        ("REF-UBB-P27-PZR-07", "originals/o6_1a_ubb_2026_04.pdf"),
        ("REF-SRL-P32-UBB-20", "legal/20241011_srl_oepul_2023.pdf"),
    ]:
        citation = next(c for c in opus_citations if c["reference_id"] == reference_id)
        pdf = ROOT / "sources/oepul" / relative
        require(digest(pdf) == citation["source_sha256"], "question source version mismatch")
        page = PdfReader(pdf).pages[citation["page"] - 1].extract_text()
        require(normalize_evidence(citation["evidence_text"]) in normalize_evidence(page), "question quote not on cited PDF page")
        period_evidence.append({k: citation[k] for k in ["reference_id", "source_sha256", "page", "section", "evidence_text"]})
    return {
        "schema_version": "o6_1a_variable_diff.v1", "measure_id": "o6_1a",
        "app_commit": APP_COMMIT, "lab_commit": LAB_COMMIT,
        "scope": "Historical model proposals, not accepted App schema changes; model sample values are never defaults",
        "promotion_ready": False, "admission_status": "not_decided",
        "runs": runs,
        "same_spelling_proposal_paths": sorted(paths["luna"] & paths["opus"]),
        "same_spelling_implies_equivalence": False,
        "questions": [
            {"id": "PHEROMONE_PERIOD", "status": "awaiting_user_input", "asked_in_chat": True,
             "question": "Wie wird das Ende der Vegetationsperiode fachlich bestimmt und belegt?",
             "evidence": period_evidence},
            {"id": "FIELD_PIECE_IDENTITY", "status": "awaiting_user_input", "asked_in_chat": True,
             "question": "Ist feldstueckskennung je Betrieb/Antragsjahr der bestätigte Gruppierungsschlüssel?",
             "app_code": "backend/app/api/recommender.py:build_parcel_display_metadata"},
        ],
    }


def render(data: dict) -> str:
    lines = ["# o6_1a: Variablen vorher / nachher", "",
             "Vorher = unverändertes Ausgangsprofil des jeweiligen Modellruns; nachher = dessen Vorschlag.",
             "App vorher ist separat gegen Schema/Registries nach #137 angegeben. Eine leere Zelle ist kein Laufzeitnachweis.",
             "Keine dieser Änderungen ist damit in der App angenommen oder implementiert. Beispielwerte sind keine Defaults.", ""]
    for model, run in data["runs"].items():
        counts = {k: len(v) for k, v in run["profile_diff"].items()}
        lines.extend([f"## {model}: `{run['run_id']}`", "",
                      f"{run['proposal_count']} Änderungsvorschläge; Blattpfade: {counts['added']} hinzugefügt, {counts['changed']} geändert, {counts['removed']} entfernt.", "",
                      "| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Schema vorher | Exakt registriert |",
                      "| --- | --- | --- | --- | --- | --- |"])
        def cell(v):
            return "`" + json.dumps(v, ensure_ascii=False).replace("|", "&#124;") + "`"
        for leaf in run["leaf_diff"]:
            before = cell(leaf["before"]) if leaf["before_present"] else "nicht vorhanden"
            after = cell(leaf["after"]) if leaf["after_present"] else "entfernt"
            schema = cell(leaf["app_schema_notation"]) if leaf["app_schema_present"] else "nicht deklariert"
            lines.append(f"| `{leaf['path']}` | {leaf['action']} | {before} | {after} | {schema} | {'ja' if leaf['app_registered_exact_path'] else 'nein'} |")
        lines.extend(["", "Regel-/Quellenreferenzen und originale Vorschläge: `variable-diff.json`.", ""])
    lines.extend(["## Grenze der Pfadanalyse", "",
                  "Opus: gespeicherte und aktuell erneut extrahierte input-paths sind leer, obwohl direkte object.get(input, ...) Zugriffe vorhanden sind.",
                  "Der historische Scanner kann diese Eingabeform nicht vollständig erfassen. Die beobachteten Zugriffsstellen stehen im JSON; Helper-/Alias-Konsum bleibt ungeprüft.",
                  "Deklarierte Regelpfade, Profilvorschläge und vollständiger tatsächlicher Rego-Konsum dürfen nicht gleichgesetzt werden.", ""])
    return "\n".join(lines)


def validate(data: dict | None = None, bound: dict | None = None):
    require((bound if bound is not None else load(DOSSIER / "source-manifest.json")) == manifest(), "pinned source inventory/hash mismatch")
    expected = build()
    require((data if data is not None else load(DOSSIER / "variable-diff.json")) == expected, "incomplete or changed variable diff/admission state")
    require((DOSSIER / "diff.md").read_text() == render(expected), "Markdown diff drift")
    return {m: {"proposals": r["proposal_count"], **{k: len(v) for k, v in r["profile_diff"].items()}} for m, r in expected["runs"].items()}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="Write dossier outputs, never historical runs")
    parser.add_argument("--app-root", type=Path, help="Verify source hashes against the pinned App commit")
    args = parser.parse_args()
    if args.app_root:
        app = load(DOSSIER / "app-baseline.json")
        for path, item in app["files"].items():
            raw = subprocess.check_output(["git", "-C", str(args.app_root), "show", f"{APP_COMMIT}:{path}"])
            require(hashlib.sha256(raw).hexdigest() == item["sha256"], f"App file mismatch: {path}")
            if "schema" in item:
                require(item["schema"] == json.loads(raw), f"App schema copy mismatch: {path}")
            if "rows" in item:
                rows = list(csv.DictReader(io.StringIO(raw.decode())))
                if Path(path).name.startswith("measure_"):
                    rows = [r for r in rows if r["measure_id"] == "o6_1a"]
                require(item["rows"] == rows, f"App registry/dependency copy mismatch: {path}")
    if args.write:
        data = build()
        for name, value in [("source-manifest.json", manifest()), ("variable-diff.json", data)]:
            (DOSSIER / name).write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n")
        (DOSSIER / "diff.md").write_text(render(data))
    print(json.dumps(validate(), sort_keys=True))


if __name__ == "__main__":
    main()
