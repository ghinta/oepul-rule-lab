#!/usr/bin/env python3
"""Assemble authored public audit parts without inventing coverage or labels.

The default status is in_progress. --complete requires every assigned part and
exact ledger coverage; it is collection completion, never expert acceptance.
The shared queue remains untouched and requires separate reviewer action.
"""
from __future__ import annotations

import argparse
from collections import Counter
import copy
import importlib.util
from pathlib import Path

RUNNER_SPEC = importlib.util.spec_from_file_location("opus_collection_runner", Path(__file__).with_name("audit_runner.py"))
runner = importlib.util.module_from_spec(RUNNER_SPEC)
RUNNER_SPEC.loader.exec_module(runner)

PARTS = ("core", "general", "measure", "tables", "inputs")
PRIMARY_ORDER = ("general", "measure", "core", "tables", "inputs")
EXECUTION_FIELDS = {"exit_code", "execution_status", "status", "output", "native_result", "stderr"}


def validator_module():
    specification = importlib.util.spec_from_file_location(
        "opus_collection_validator", runner.REPO / "tools/validate_opus_run_review.py")
    module = importlib.util.module_from_spec(specification)
    specification.loader.exec_module(module)
    return module


def file_record(path, **fields):
    return {"path": path.relative_to(runner.REPO).as_posix(), "bytes": path.stat().st_size,
            "sha256": runner.digest(path), **fields}


def part_identity(part, measure, run_id):
    runner.require(part.get("measure_id") == measure and part.get("run_id") == run_id,
                   "Authored part identity differs")
    commit = part.get("candidate_commit", part.get("snapshot"))
    runner.require(commit == runner.CANDIDATE_COMMIT, "Authored part candidate snapshot differs")


def normalize_table_path(value, run_id):
    prefix = f"runs/{run_id}/"
    if value.startswith(prefix):
        value = value[len(prefix):]
    runner.require(value.startswith("workspace/data/") and ".." not in Path(value).parts,
                   f"Table ledger path is outside this run's data: {value}")
    return value


def differences(actual, expected):
    actual_count, expected_count = Counter(actual), Counter(expected)
    return {"missing": sorted((expected_count - actual_count).elements()),
            "extra": sorted((actual_count - expected_count).elements())}


def authored_rules(parts):
    grouped = {}
    for name in PARTS:
        for index, assessment in enumerate(parts.get(name, {}).get("rules", [])):
            rule_id = assessment.get("rule_id", assessment.get("id"))
            runner.require(isinstance(rule_id, str) and rule_id, "Authored rule lacks an explicit ID")
            grouped.setdefault(rule_id, []).append({"part": name, "json_pointer": f"/rules/{index}",
                                                     "assessment": assessment})
    result = []
    for rule_id in sorted(grouped):
        entries = grouped[rule_id]
        primary = min(entries, key=lambda item: PRIMARY_ORDER.index(item["part"]))
        result.append({"rule_id": rule_id,
                       "primary_for_navigation": {"part": primary["part"], "json_pointer": primary["json_pointer"]},
                       "assessments": entries})
    return result


def authored_probes(parts, records, default_query):
    cases, provenance = [], []
    seen = set()
    for name in PARTS:
        part = parts.get(name, {})
        for index, original in enumerate(part.get("probes", [])):
            case = copy.deepcopy(original)
            case_id = case.get("case_id")
            runner.require(isinstance(case_id, str) and case_id and case_id not in seen,
                           f"Duplicate or invalid authored case ID: {case_id}")
            seen.add(case_id)
            runner.require(isinstance(case.get("input"), dict), f"Case lacks native input: {case_id}")
            expectations = case.get("expectations")
            runner.require(isinstance(expectations, list) and bool(expectations),
                           f"Case lacks independently authored expectations: {case_id}")
            for expectation in expectations:
                runner.require(expectation.get("operator") in
                               {"equals", "contains_rule", "excludes_rule", "status_equals"} and
                               "expected" in expectation, f"Unsupported authored expectation: {case_id}")
                if expectation["operator"] != "status_equals":
                    runner.require(isinstance(expectation.get("path"), list),
                                   f"Expectation needs path array: {case_id}")
            # Raw author observations remain bound in the original part. They
            # must never become execution fixture expectations by assembly.
            removed = {key: case.pop(key) for key in list(case)
                       if key.startswith("observed") or key in EXECUTION_FIELDS}
            query = case.get("query", part.get("query", default_query))
            runner.require(isinstance(query, str) and bool(query.strip()), f"Case lacks a query: {case_id}")
            case["query"] = query
            cases.append(case)
            provenance.append({"case_id": case_id, "part": name, "part_sha256": records[name]["sha256"],
                               "json_pointer": f"/probes/{index}",
                               "query_inherited": "query" not in original,
                               "removed_execution_fields": sorted(removed),
                               "removed_execution_fields_sha256": runner.hashlib.sha256(runner.encoded(removed)).hexdigest(),
                               "expectations": "Copied unchanged from authored probe; no observed output used as an oracle."})
    return cases, provenance


def assemble(root, measure, *, complete=False, completed_status="source_audit_completed_blocked"):
    runner.require(completed_status in runner.COMPLETED, "Unknown explicit completion status")
    directory = runner.safe_path(runner.HERE / "measures", measure)
    runner.require(not directory.is_relative_to(root), "Audit output must be outside candidate root")
    binding_path = directory / "binding.json"
    binding = runner.verify_binding(root, measure, runner.read_json(binding_path))
    run_id = binding["run_id"]
    parts, records = {}, {}
    missing_parts = []
    for name in PARTS:
        path = directory / f"{name}.json"
        if not path.is_file():
            missing_parts.append(name)
            continue
        part = runner.read_json(path)
        part_identity(part, measure, run_id)
        parts[name] = part
        records[name] = file_record(path, part=name)
    runner.require(bool(parts), "No authored parts available")
    rules = authored_rules(parts)
    proposals = parts.get("inputs", {}).get("proposal_ledger", [])
    proposal_paths = [item.get("path", item.get("proposal_path")) for item in proposals]
    runner.require(all(isinstance(path, str) and path for path in proposal_paths),
                   "A proposal ledger row lacks an explicit path")
    tables = []
    for table in parts.get("tables", {}).get("tables", []):
        path = normalize_table_path(table.get("path", table.get("file", "")), run_id)
        pointer = table["json_pointer"]
        runner.require(isinstance(pointer, str) and pointer.startswith("/"), "Invalid authored table pointer")
        tables.append({"path": path, "json_pointer": pointer})
    validator = validator_module()
    expected = validator.catalog(root, run_id)
    coverage = {"rule_ids": [item["rule_id"] for item in rules], "profile_change_paths": proposal_paths,
                "tables": tables,
                "source_paths": [item["path"] for item in binding["files"] if item["kind"] == "original_source"]}
    checks = {"rules": differences(coverage["rule_ids"], expected["rule_ids"]),
              "profile_proposals": differences(proposal_paths, expected["profile_change_paths"]),
              "tables": differences([(item["path"], item["json_pointer"]) for item in tables], expected["tables"])}
    runner.require(not any(item["extra"] for item in checks.values()),
                   f"Authored ledgers contain extra/duplicate catalogue entries: {checks}")
    if complete:
        runner.require(not missing_parts, f"Cannot complete: missing authored parts {missing_parts}")
        runner.require(not any(item["missing"] for item in checks.values()),
                       f"Cannot complete: authored coverage is incomplete: {checks}")
        validator.validate_coverage(coverage, expected, binding)
    _, entry = runner.manifest_entry(measure)
    runner.check_record(runner.REPO, entry["fixture"])
    default_query = runner.read_json(runner.REPO / entry["fixture"]["path"])["query"]
    cases, case_provenance = authored_probes(parts, records, default_query)
    runner.require(bool(cases), "No authored developmental probes available")
    fixture = {"schema_version": 1, "kind": "public-development-source-audit-probes",
               "measure_id": measure, "run_id": run_id, "candidate_commit": runner.CANDIDATE_COMMIT,
               "query": default_query, "allowed_queries": sorted({case["query"] for case in cases}),
               "scope": "Authored source-derived developmental probes; not study references, expert acceptance, or complete-farm approval.",
               "source_evidence": {}, "cases": cases,
               "authored_parts": [records[name] for name in PARTS if name in records],
               "evidence_note": "Per-case source_evidence and expectations are copied unchanged. Original part observations are never converted into expected answers."}
    provenance = {"schema_version": 1, "kind": "authored-audit-collection-provenance",
                  "measure_id": measure, "run_id": run_id, "candidate_commit": runner.CANDIDATE_COMMIT,
                  "parts": fixture["authored_parts"], "cases": case_provenance,
                  "rule_aggregation": "All overlapping assessments retained. General/legal part is primary for navigation, followed by measure, core, tables, inputs; no synthesized verdict.",
                  "source_reading": "Original source identities come from binding.json. Full reading, targeted rereading and exact-hash reuse remain authored claims in the part reading logs, not machine quote approval."}
    findings = []
    reading_logs = []
    reading_keys = ("scope", "source_sections", "source_bindings", "sources", "source_reading", "legal_subreview")
    for name in PARTS:
        part = parts.get(name, {})
        for index, finding in enumerate(part.get("findings", [])):
            runner.require("audit_origin" not in finding, "Authored finding uses reserved audit_origin field")
            findings.append({**finding, "audit_origin": {"part": name, "json_pointer": f"/findings/{index}"}})
        reading_logs.extend({"part": name, "part_sha256": records[name]["sha256"], "json_pointer": f"/{key}"}
                            for key in reading_keys if key in part)
    family_counts = Counter(item.get("family", "unspecified") for item in findings)
    fixture_path = directory / "development-probes.json"
    provenance_path = directory / "collection-provenance.json"
    fixture_bytes = runner.encoded(fixture)
    provenance_bytes = runner.encoded(provenance)
    audit = {"schema_version": 1, "kind": "authored-parts-public-source-audit-collection",
             "measure_id": measure, "run_id": run_id, "candidate_commit": runner.CANDIDATE_COMMIT,
             "status": completed_status if complete else "in_progress",
             "completion_scope": "Explicit collection completion only; shared queue unchanged; no semantic approval inferred.",
             "binding_sha256": runner.digest(binding_path), "parts": fixture["authored_parts"],
             "fixture_sha256": runner.hashlib.sha256(fixture_bytes).hexdigest(),
             "collection_provenance_sha256": runner.hashlib.sha256(provenance_bytes).hexdigest(),
             "coverage": coverage, "coverage_checks": checks, "missing_parts": missing_parts,
             "rules": rules, "findings": findings, "source_reading_logs": reading_logs,
             "summary": {"parts": len(parts), "unique_catalog_rules": len(rules),
                         "authored_rule_assessments": sum(len(item["assessments"]) for item in rules),
                         "profile_proposals": len(proposals), "catalog_tables": len(tables),
                         "authored_findings": len(findings), "authored_findings_by_family": dict(sorted(family_counts.items())),
                         "development_probes": len(cases), "app_promotions": 0, "expert_acceptances": 0},
             "limitations": ["Coverage comes only from authored ledgers; the historical catalogue is used to detect omissions, never to fill them.",
                             "Source paths are identity coverage. Source-reading claims and semantic findings remain attributable to their authored parts.",
                             "Multiple assessments/findings can overlap or disagree. All are preserved for later review and cross-measure synthesis.",
                             "Completion does not repair policies, remove findings, approve aliases, promote App results, or accept domain conclusions."]}
    # Validate all data before performing the explicitly requested reversible writes.
    directory.mkdir(parents=True, exist_ok=True)
    fixture_path.write_bytes(fixture_bytes)
    provenance_path.write_bytes(provenance_bytes)
    (directory / "audit.json").write_bytes(runner.encoded(audit))
    return audit


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--measure", required=True)
    parser.add_argument("--candidate-root", type=Path, required=True)
    parser.add_argument("--complete", action="store_true", help="Explicit collection completion; does not change shared queue")
    parser.add_argument("--completed-status", choices=sorted(runner.COMPLETED), default="source_audit_completed_blocked")
    args = parser.parse_args()
    audit = assemble(args.candidate_root.resolve(), args.measure, complete=args.complete,
                     completed_status=args.completed_status)
    print(runner.json.dumps({"measure_id": args.measure, "status": audit["status"], **audit["summary"]}))


if __name__ == "__main__":
    main()
