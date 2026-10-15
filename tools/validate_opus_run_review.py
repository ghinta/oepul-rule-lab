#!/usr/bin/env python3
"""Validate the sequential public Opus audit ledger, identities and coverage.

Coverage is a completeness check of the audit ledger, never semantic approval.
Pending dossiers do not acquire completed status through this validator.
"""
from __future__ import annotations

import argparse
from collections import Counter
import importlib.util
from pathlib import Path
import subprocess
import sys

REPO = Path(__file__).resolve().parents[1]
HERE = REPO / "docs/analysis/opus-run-review"
SPEC = importlib.util.spec_from_file_location("opus_public_audit_runner", HERE / "audit_runner.py")
runner = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(runner)


def same_items(actual, expected, label):
    runner.require(Counter(actual) == Counter(expected), f"Incomplete or duplicate {label} coverage")


def catalog(root, run_id):
    base = root / "runs" / run_id / "workspace/rules"
    rules = runner.read_json(base / "rules.json")["rules"]
    proposals = runner.read_json(base / "profile_changes.json")["changes"]
    inventory = runner.read_json(base / "data_inventory.json")["artifacts"]
    return {"rule_ids": [item["id"] for item in rules],
            "profile_change_paths": [item["path"] for item in proposals],
            "tables": [(artifact["path"], table["json_pointer"])
                       for artifact in inventory for table in artifact["tables"]]}


def validate_coverage(coverage, expected, binding):
    same_items(coverage["rule_ids"], expected["rule_ids"], "catalog rule")
    # A multiset deliberately preserves separate proposals at the same path.
    same_items(coverage["profile_change_paths"], expected["profile_change_paths"], "profile proposal")
    same_items([(item["path"], item["json_pointer"]) for item in coverage["tables"]],
               expected["tables"], "catalog table pointer")
    same_items(coverage["source_paths"],
               [item["path"] for item in binding["files"] if item["kind"] == "original_source"],
               "original source")


def validate_observations(directory, binding):
    fixture_path = directory / "development-probes.json"
    fixture = runner.read_json(fixture_path)
    observations = runner.read_json(directory / "observations.json")
    modern = "measure_id" in binding
    runner.require(fixture.get("run_id", binding["run_id"]) == binding["run_id"], "Fixture run differs")
    if modern:
        runner.require(fixture.get("measure_id") == binding["measure_id"] and
                       fixture.get("run_id") == binding["run_id"], "Fixture identity differs")
        runner.require(observations.get("measure_id") == binding["measure_id"], "Observed measure differs")
    runner.require(observations["candidate_commit"] == runner.CANDIDATE_COMMIT and
                   observations["run_id"] == binding["run_id"], "Observation identity differs")
    runner.require(observations["binding_sha256"] == runner.digest(directory / "binding.json") and
                   observations["fixture_sha256"] == runner.digest(fixture_path), "Observation hashes differ")
    runner.require(observations.get("opa_version") == binding["opa_version"] and
                   observations.get("compile") == "strict_passed", "Observation runtime metadata differs")
    cases = fixture["cases"]
    observed = observations["cases"]
    runner.require(isinstance(cases, list) and bool(cases), "Fixture cases must be nonempty")
    ids = [case["case_id"] for case in cases]
    runner.require(all(isinstance(item, str) and item for item in ids) and len(ids) == len(set(ids)),
                   "Fixture case IDs must be unique nonempty strings")
    runner.require(runner.typed_equal(ids, [case["case_id"] for case in observed]),
                   "Observation case order/coverage differs")
    historical_query = None
    if modern:
        _, entry = runner.manifest_entry(binding["measure_id"])
        runner.check_record(REPO, entry["fixture"])
        historical_query = runner.read_json(REPO / entry["fixture"]["path"])["query"]
    for source, result in zip(cases, observed):
        runner.require(isinstance(source["input"], dict), "Fixture needs explicit native input objects")
        runner.require(isinstance(source["expectations"], list) and bool(source["expectations"]),
                       "Fixture needs explicit expectations")
        if modern:
            query = source.get("query", fixture.get("query"))
            runner.allowed_query(query, binding["measure_id"], fixture, historical_query)
            runner.require(runner.typed_equal(result.get("query"), query), "Observed effective query differs")
        runner.require(result["input_sha256"] == runner.hashlib.sha256(runner.encoded(source["input"])).hexdigest(),
                       "Observed input hash differs")
        runner.require(result["status"] in {"defined", "undefined", "runtime_error", "process_timeout"},
                       "Unknown native evaluation status")
        runner.require(("output" in result) == (result["status"] == "defined"),
                       "Undefined/error output must be absent; defined null remains present")
        checks = [runner.check_expectation(item, result) for item in source["expectations"]]
        runner.require(runner.typed_equal(checks, result["checks"]), "Recorded expectation checks differ")
        runner.require(not any(check.get("invalid_rule_collection") is True for check in checks),
                       f"Invalid rule collection in fixture case {source['case_id']}: "
                       "contains_rule/excludes_rule require arrays of rule_id objects")
    summary = {"cases": len(observed), "checks": sum(len(case["checks"]) for case in observed),
               "expectations_met": sum(check["passed"] for case in observed for check in case["checks"])}
    runner.require(runner.typed_equal(observations["summary"], summary), "Observation summary differs")


def validate_legacy(root, entry, opa):
    """The original first-run dossier remains byte-preserved and keeps its schema."""
    directory = (HERE / entry["audit"]).resolve().parent
    runner.require(directory == REPO / "docs/analysis/opus-o6-1a-audit-20261015",
                   "Unexpected legacy first-run dossier")
    old = runner.read_json(directory / "binding.json")
    expected = runner.make_binding(root, entry["measure_id"])
    for key in ("candidate_commit", "run_id", "opa_version", "opa_sha256"):
        runner.require(old[key] == expected[key], f"Legacy {key} differs")
    # Legacy binds every original run artifact/source. New canonical/profile
    # runtime pin records are checked by make_binding without rewriting legacy.
    records = {item["path"]: item for item in expected["files"]
               if item["kind"] not in {"canonical_profile", "runtime_pin"}}
    runner.require({item["path"] for item in old["files"]} == set(records), "Legacy bound file set differs")
    for item in old["files"]:
        wanted = records[item["path"]]
        runner.require({key: item[key] for key in wanted} == wanted and
                       set(item) <= set(wanted) | {"pdf_pages"}, "Legacy file record differs")
    coverage = {"rule_ids": [item["rule_id"] for item in runner.read_json(directory / "rule-review.json")["rules"]],
                "profile_change_paths": [item["proposal_path"] for item in
                                         runner.read_json(directory / "input-review.json")["proposal_ledger"]],
                "tables": runner.read_json(directory / "tables-review.json")["tables"],
                "source_paths": [item["path"] for item in old["files"] if item["kind"] == "original_source" ]}
    validate_coverage(coverage, catalog(root, entry["run_id"]), expected)
    validate_observations(directory, old)
    if opa:
        subprocess.run([sys.executable, str(directory / "replay.py"), "--candidate-root", str(root),
                        "--opa", str(opa), "--verify"], cwd=REPO, check=True, timeout=300)


def validate_collection(directory, audit, binding):
    """Check that assembled coverage/expectations still come from authored parts."""
    specification = importlib.util.spec_from_file_location("opus_collection_helpers", HERE / "collect_review.py")
    collector = importlib.util.module_from_spec(specification)
    specification.loader.exec_module(collector)
    records = audit["parts"]
    runner.require([item["part"] for item in records] == list(collector.PARTS),
                   "Completed collection needs every authored part exactly once")
    parts, by_name = {}, {}
    for record in records:
        name = record["part"]
        runner.require(REPO / record["path"] == directory / f"{name}.json", "Authored part path differs")
        runner.check_record(REPO, record)
        part = runner.read_json(REPO / record["path"])
        collector.part_identity(part, binding["measure_id"], binding["run_id"])
        parts[name], by_name[name] = part, record
    runner.require(audit["candidate_commit"] == runner.CANDIDATE_COMMIT and
                   audit["binding_sha256"] == runner.digest(directory / "binding.json"),
                   "Collection binding identity differs")
    fixture_path = directory / "development-probes.json"
    provenance_path = directory / "collection-provenance.json"
    runner.require(audit["fixture_sha256"] == runner.digest(fixture_path) and
                   audit["collection_provenance_sha256"] == runner.digest(provenance_path),
                   "Collection fixture/provenance hash differs")
    rules = collector.authored_rules(parts)
    runner.require(runner.typed_equal(audit["rules"], rules), "Authored rule assessments were lost or changed")
    coverage = audit["coverage"]
    runner.require(runner.typed_equal(coverage["rule_ids"], [item["rule_id"] for item in rules]),
                   "Rule coverage was not derived from authored assessments")
    paths = [item.get("path", item.get("proposal_path")) for item in parts["inputs"]["proposal_ledger"]]
    runner.require(runner.typed_equal(coverage["profile_change_paths"], paths),
                   "Proposal coverage was not derived from authored ledger")
    tables = [{"path": collector.normalize_table_path(item.get("path", item.get("file", "")), binding["run_id"]),
               "json_pointer": item["json_pointer"]} for item in parts["tables"]["tables"]]
    runner.require(runner.typed_equal(coverage["tables"], tables), "Table coverage was not derived from authored ledger")
    fixture = runner.read_json(fixture_path)
    _, entry = runner.manifest_entry(binding["measure_id"])
    runner.check_record(REPO, entry["fixture"])
    default_query = runner.read_json(REPO / entry["fixture"]["path"])["query"]
    cases, origins = collector.authored_probes(parts, by_name, default_query)
    runner.require(runner.typed_equal(fixture["cases"], cases) and
                   runner.typed_equal(fixture["authored_parts"], records),
                   "Execution fixture differs from authored cases/expectations/evidence")
    runner.require(runner.typed_equal(fixture["allowed_queries"], sorted({case["query"] for case in cases})),
                   "Allowed query list differs from authored effective queries")
    provenance = runner.read_json(provenance_path)
    runner.require(runner.typed_equal(provenance["cases"], origins) and
                   runner.typed_equal(provenance["parts"], records), "Collection provenance differs")
    findings = []
    for name in collector.PARTS:
        findings.extend({**item, "audit_origin": {"part": name, "json_pointer": f"/findings/{index}"}}
                        for index, item in enumerate(parts[name].get("findings", [])))
    runner.require(runner.typed_equal(audit["findings"], findings), "Authored findings were lost or changed")
    expected_counts = {"parts": len(parts), "unique_catalog_rules": len(rules),
                       "authored_rule_assessments": sum(len(item["assessments"]) for item in rules),
                       "profile_proposals": len(paths), "catalog_tables": len(tables),
                       "authored_findings": len(findings),
                       "authored_findings_by_family": dict(sorted(Counter(item.get("family", "unspecified")
                                                                         for item in findings).items())),
                       "development_probes": len(cases), "app_promotions": 0, "expert_acceptances": 0}
    runner.require(runner.typed_equal(audit["summary"], expected_counts), "Collection summary differs")


def validate_dossier(root, entry, opa):
    measure = entry["measure_id"]
    if measure == "o6_1a" and entry.get("audit", "").startswith("../opus-o6-1a-audit-"):
        validate_legacy(root, entry, opa)
        return
    directory = HERE / "measures" / measure
    audit = runner.read_json(directory / "audit.json")
    runner.require(audit["measure_id"] == measure and audit["run_id"] == entry["run_id"],
                   "Completed audit identity differs")
    runner.require(audit["status"] == entry["status"], "Completed audit and queue status differ")
    binding = runner.verify_binding(root, measure, runner.read_json(directory / "binding.json"))
    runner.require(audit.get("kind") == "authored-parts-public-source-audit-collection",
                   "New completed dossiers require an attributed authored-part collection")
    validate_collection(directory, audit, binding)
    validate_coverage(audit["coverage"], catalog(root, entry["run_id"]), binding)
    validate_observations(directory, binding)
    if opa:
        expected = runner.encoded(runner.replay(root, opa, measure, directory))
        runner.require((directory / "observations.json").read_bytes() == expected,
                       f"{measure}: reproduced observations differ")


def validate_queue():
    """Validate selection and sequential progress, without promoting any entry."""
    queue = runner.read_json(HERE / "queue.json")
    manifest = runner.read_json(runner.MANIFEST)
    runner.require(runner.digest(runner.MANIFEST) == runner.MANIFEST_SHA256, "Screening manifest changed")
    runner.require(queue["candidate_commit"] == runner.CANDIDATE_COMMIT, "Queue candidate differs")
    entries = queue["entries"]
    runner.require([(item["measure_id"], item["run_id"]) for item in entries] ==
                   [(item["measure_id"], item["run_id"]) for item in manifest["entries"]],
                   "Queue is not the exact frozen candidate selection/order")
    runner.require([item["order"] for item in entries] == list(range(1, len(entries) + 1)), "Queue order differs")
    complete = 0
    saw_pending = False
    in_progress = 0
    for entry in entries:
        status = entry["status"]
        done = status in runner.COMPLETED
        runner.require(done or status in {"individual_source_audit_pending", "individual_source_audit_in_progress", "in_progress"},
                       f"Unknown audit status: {status}")
        if done:
            runner.require(not saw_pending, "Completed audits must form a sequential queue prefix")
            complete += 1
        else:
            if status in {"individual_source_audit_in_progress", "in_progress"}:
                runner.require(not saw_pending, "Only the first unfinished measure can be in progress")
                in_progress += 1
            saw_pending = True
            path = HERE / "measures" / entry["measure_id"] / "audit.json"
            if path.exists():
                runner.require(runner.read_json(path).get("status") not in runner.COMPLETED,
                               "Completed dossier is incorrectly marked pending in queue")
    runner.require(in_progress <= 1, "At most one measure can be in progress")
    counts = queue["counts"]
    runner.require(counts["individual_source_audits_completed"] == complete and
                   counts["individual_source_audits_pending"] == len(entries) - complete,
                   "Queue completed/pending counts differ")
    runner.require(counts["app_promotions_in_this_round"] == 0 and
                   counts["expert_acceptances_in_this_round"] == 0,
                   "This collection round cannot claim App promotions or expert acceptance")
    return queue


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--candidate-root", type=Path, required=True)
    parser.add_argument("--measure", help="Validate one completed dossier plus the shared queue")
    parser.add_argument("--opa", type=Path, help="Additionally replay completed dossiers without mutations")
    args = parser.parse_args()
    root = args.candidate_root.resolve()
    opa = args.opa.resolve() if args.opa else None
    queue = validate_queue()
    entries = queue["entries"]
    if args.measure:
        runner.require(args.measure in {item["measure_id"] for item in entries}, "Unknown requested measure")
    complete = 0
    for entry in entries:
        if entry["status"] in runner.COMPLETED:
            complete += 1
            if not args.measure or args.measure == entry["measure_id"]:
                validate_dossier(root, entry, opa)
                print(f"{entry['measure_id']}: completed dossier identity/coverage verified")
    print(f"Queue verified: {complete} completed, {len(entries) - complete} unfinished; no acceptance inferred")


if __name__ == "__main__":
    main()
