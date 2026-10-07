"""Check the pinned o6_3 review dossier, not funding eligibility or promotion."""
from __future__ import annotations

import argparse
import csv
import hashlib
import io
import json
from pathlib import Path
import re
import subprocess
import sys

from pypdf import PdfReader

from rulelab.grounding import normalize_evidence
from rulelab.heuwirtschaft import Input

ROOT = Path(__file__).resolve().parents[1]
DOSSIER = ROOT / "docs/analysis/o6_3-variable-contract-20261007"


def schema_leaves(schema: dict) -> dict[str, dict]:
    def walk(node: dict, path: str):
        if "$ref" in node:
            yield from walk(schema["$defs"][node["$ref"].split("/")[-1]], path)
        elif "anyOf" in node:
            for child in node["anyOf"]:
                if child.get("type") != "null":
                    yield from walk(child, path)
        elif node.get("type") == "object":
            for name, child in node["properties"].items():
                yield from walk(child, f"{path}.{name}" if path else name)
        elif node.get("type") == "array" and (
            "$ref" in node["items"] or node["items"].get("type") == "object"
        ):
            yield from walk(node["items"], path + "[]")
        else:
            yield path, {k: v for k, v in node.items() if k not in {"title", "default"}}

    return dict(walk(schema, ""))


def load(name: str):
    return json.loads((DOSSIER / name).read_text())


def require(condition: bool, message: str):
    if not condition:
        raise ValueError(message)


def indexed(records: list[dict], key: str) -> dict[str, dict]:
    result = {r[key]: r for r in records}
    require(len(result) == len(records), f"duplicate {key}")
    return result


def validate(
    *, contract: dict | None = None, review: dict | None = None,
    citations: list[dict] | None = None, app_root: Path | None = None,
) -> dict:
    contract = load("variables.json") if contract is None else contract
    review = load("source-review.json") if review is None else review
    citations = load("citations.json") if citations is None else citations
    baseline = load("baseline.json")
    inventory = load("app-inventory.json")
    paths = indexed(contract["variables"], "path")
    rules = indexed(review["rules"], "id")
    evidence = indexed(citations, "id")
    blockers = indexed(review["blockers"], "id")
    require(review["promotion_ready"] is False, "review is not a promotion approval")
    require(baseline["app_commit"] == inventory["commit"], "App baseline mismatch")
    require(baseline["opus_revisions"]["completed_revision_commit"] is None,
            "completed Opus revision needs a new reviewed baseline")
    for path, expected in baseline["files"].items():
        require(hashlib.sha256((ROOT / path).read_bytes()).hexdigest() == expected,
                f"candidate changed: {path}")
    for path, expected in baseline["upstream_sha256"].items():
        require(hashlib.sha256((ROOT / path).read_bytes()).hexdigest() == expected,
                f"historical artifact changed: {path}")
    sources = {s["path"]: s["sha256"] for s in baseline["sources"]}
    for path, expected in sources.items():
        require(hashlib.sha256((ROOT / path).read_bytes()).hexdigest() == expected,
                f"source changed: {path}")
    readers = {}
    for citation in citations:
        path = citation["path"]
        require(path in sources, f"unbound source: {path}")
        if path not in readers:
            readers[path] = PdfReader(ROOT / path)
        page = citation["page"]
        require(1 <= page <= len(readers[path].pages), "invalid citation page")
        text = normalize_evidence(readers[path].pages[page - 1].extract_text())
        require(normalize_evidence(citation["quote"]) in text,
                f"quote not found: {citation['id']}")

    expected = schema_leaves(Input.model_json_schema())
    require(set(paths) == set(expected), "variable coverage differs from typed input")
    policy = (ROOT / "adaptations/o6_3/policy/heuwirtschaft.rego").read_text()
    for rule in rules.values():
        require(set(rule["variables"]) <= set(paths), f"unknown variable: {rule['id']}")
        require(set(rule["source_ids"]) <= set(evidence), f"unbound rule: {rule['id']}")
        require(rule["source_ids"] or rule["id"] == "CURRENT_BASIS", "missing normative source")
        require(set(rule["depends_on"]) <= set(rules) and rule["id"] not in rule["depends_on"],
                f"unknown rule dependency: {rule['id']}")
        for symbol in rule["rego_symbols"]:
            require(re.search(r"\b" + re.escape(symbol) + r"\b", policy) is not None,
                    f"missing Rego symbol: {symbol}")

    csv_files = {}
    for entry in inventory["files"]:
        require(hashlib.sha256(entry["text"].encode()).hexdigest() == entry["sha256"],
                f"inventory checksum: {entry['path']}")
        csv_files[Path(entry["path"]).name] = list(csv.DictReader(io.StringIO(entry["text"])))
    for path, variable in paths.items():
        require(variable["json_schema"] == expected[path], f"type drift: {path}")
        consumers = {r["id"] for r in rules.values() if path in r["variables"]}
        require(set(variable["rule_ids"]) == consumers and bool(consumers), f"consumer drift: {path}")
        source_ids = {s for r in rules.values() if path in r["variables"] for s in r["source_ids"]}
        require(set(variable["source_ids"]) == source_ids, f"source join drift: {path}")
        require(variable["opa_path"] == "input." + path, f"OPA mapping drift: {path}")
        for key in ["definition", "origin", "purpose", "time_contract", "unknown_handling", "required_when", "unit"]:
            require(bool(variable[key]), f"empty variable metadata {key}: {path}")
        mapping = variable["app"]
        kind = variable["scope"]
        if kind in {"scalar", "parcel", "livestock", "collection"}:
            native = path.removeprefix("land.parcels[].") if kind == "parcel" else (
                path.removeprefix("livestock.species_groups[].") if kind == "livestock" else path
            )
            require(mapping["path"] == native, f"App path drift: {path}")
            registry_name = {"scalar": "supplemental", "parcel": "parcel", "livestock": "livestock"}.get(kind)
            rows = csv_files[f"{registry_name}_field_registry_v1.csv"] if registry_name else []
            existing = next((r for r in rows if r["variable_path"] == native), None)
            registered = bool(existing) if kind != "collection" else native in inventory["collection_paths"]
            dependencies = csv_files[f"measure_{registry_name or 'collection'}_dependency_v1.csv"]
            consumed = any(r["measure_id"] == "o6_3" and r.get("variable_path", r.get("collection_path")) == native for r in dependencies)
            require(mapping["registered"] == registered, f"registry drift: {path}")
            require(mapping["consumed_by_o6_3"] == consumed, f"App consumption drift: {path}")
            require(mapping["type"] == (existing["value_type"] if existing else "date[]" if registered else None),
                    f"App type drift: {path}")
        else:
            require(not mapping["registered"] and not mapping["consumed_by_o6_3"],
                    f"structural field pretends to be editable: {path}")

    tables = json.loads((ROOT / "adaptations/o6_3/data/tables.json").read_text())["heuwirtschaft_tables"]
    normative = review["normative_tables"]
    rates = indexed(normative["rgve"], "category_id")
    require(len(rates) == 20, "incomplete RGVE categories")
    require(set(rates) == {r["category_id"] for r in tables["rgve_rates"]}, "RGVE category drift")
    for row in tables["rgve_rates"]:
        reviewed = rates[row["category_id"]]
        require(reviewed["rgve"] == row["rgve"] and reviewed["species"] == row["species"], "RGVE rate drift")
        require(set(reviewed["source_ids"]) <= set(evidence) and reviewed["source_ids"], "unbound RGVE rate")
    # Ordered full PDF category blocks; the small-equid context also contains
    # height 1,48, so the final N decimals are the actual RGVE coefficients.
    for source_id in {s for row in rates.values() for s in row["source_ids"]}:
        group = [rates[row["category_id"]]["rgve"] for row in tables["rgve_rates"]
                 if source_id in rates[row["category_id"]]["source_ids"]]
        numbers = [float(n.replace(",", ".")) for n in re.findall(r"\b\d+,\d+\b", evidence[source_id]["quote"])]
        require(numbers[-len(group):] == group, f"RGVE coefficients disagree with source: {source_id}")
    for name in ["eligible_grassland_types", "excluded_grassland_types", "eligible_arable_fodder_crops", "arable_fodder_for_livestock_calculation", "eligible_combinations"]:
        require(normative[name] == tables[name], f"classification drift: {name}")
    require(normative["premium_rates"] == tables["premium_rates_eur_per_ha"], "premium rate drift")
    for blocker in blockers.values():
        require(blocker["rule_id"] in rules and blocker["required_resolution"], "invalid promotion blocker")
    for extension in contract["proposed_evidence_extensions"]:
        require(extension["not_in_current_input_schema"] is True, "unimplemented extension appears implemented")
        require(set(extension["source_ids"]) <= set(evidence), "unbound extension")
    if app_root is not None:
        head = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=app_root, text=True).strip()
        require(head == inventory["commit"], "App checkout is not pinned review baseline")
        for entry in inventory["files"] + inventory["code_files"]:
            require(hashlib.sha256((app_root / entry["path"]).read_bytes()).hexdigest() == entry["sha256"],
                    f"live App baseline drift: {entry['path']}")
    return dict(variables=len(paths), rules=len(rules), citations=len(evidence),
                rgve_categories=len(rates), open_blockers=len(blockers), promotion_ready=False)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--app-root", type=Path)
    args = parser.parse_args()
    try:
        print(json.dumps(validate(app_root=args.app_root), ensure_ascii=False))
    except (ValueError, KeyError, OSError) as exc:
        print(str(exc), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
