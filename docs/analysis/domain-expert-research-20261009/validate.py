"""Check research references and preserve open domain decisions; no network."""
import argparse
import collections
import copy
import hashlib
import json
import re
from pathlib import Path
from urllib.parse import urlsplit

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
EXPECTED_FAMILIES = {f"D{i:02}" for i in range(1, 11)}
EXPECTED_GATES = {
    "GROUP_IDENTITY", "COUNT_BASIS", "GREEN_FEEDING_HISTORY", "RECOGNITION_TIME",
    "GENERAL_FUNDING", "ANNUAL_EVIDENCE", "SOURCE_CURRENTNESS", "OPUS_REVISION",
}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def digest(data):
    return hashlib.sha256(data).hexdigest()


def read(name):
    return json.loads((HERE / (name + ".json")).read_text())


def load_bundle():
    return {n: read(n) for n in ("proposals", "sources", "coverage", "input-manifest")}


def validate_structure(bundle):
    proposals_doc, source_doc, coverage = (bundle[n] for n in ("proposals", "sources", "coverage"))
    index = json.loads((ROOT / "docs/analysis/domain-expert-agenda-20261009/question-index.json").read_text())
    questions = {q["question_id"] for q in index["questions"]}
    require(len(index["questions"]) == len(questions) == 418, "Required 418 distinct original IDs")
    require(all(q["status"] == "open_before_app_admission" and q["answer"] is None for q in index["questions"]),
            "Original questions must remain open")
    gates = index["o6_3_blockers"]
    require(len(gates) == 8 and {g["blocker_id"] for g in gates} == EXPECTED_GATES
            and all(g["status"] == "open_before_full_recommendation" and g["answer"] is None for g in gates),
            "Exact eight open blockers required")
    rest_path = ROOT / "docs/analysis/domain-expert-agenda-20261009/rest-scopes.json"
    rests = {s["id"] for s in json.loads(rest_path.read_text())["additional_decisions"]}
    families = proposals_doc["families"]
    require(len(families) == 10 and {f["id"] for f in families} == EXPECTED_FAMILIES, "All ten research themes")
    require(proposals_doc["promotion_ready"] is False and proposals_doc["domain_answers_recorded"] == 0,
            "Research cannot authorize domain admission")
    sources = source_doc["sources"]
    source_map = {s["id"]: s for s in sources}
    require(len(source_map) == len(sources) == 40, "Forty unique opened source URL records")
    require(len({s["canonical_url"] for s in sources}) == len(sources), "Duplicate source URL")
    quote_words = collections.Counter()
    for source in sources:
        require(urlsplit(source["url"]).scheme == "https", "Original HTTPS source URL required")
        require(source["original_document_sha256"] is None
                and source["capture_kind"] == "opened_web_original_sections", "Metadata hash is not PDF proof")
        quote_words[source["quote_budget_work_id"]] += len(source["short_quote"].split())
        record = dict(source)
        declared = record.pop("record_sha256")
        require(digest(json.dumps(record, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode()) == declared,
                "Research source record hash mismatch")
        require(source["observations"], "Read observations required")
        for observation in source["observations"]:
            require(observation["read_at"][:10] == "2026-10-09" and observation["locator"]
                    and observation["freshness_limit"], "Source date/section/freshness scope required")
    require(all(words <= 25 for words in quote_words.values()), "Quote limit per work, including mirrors")
    proposals = [p for f in families for p in f["proposals"]]
    require(len(proposals) == len({p["id"] for p in proposals}) == 30, "Thirty distinct preliminary proposals")
    referenced = set()
    case_count = 0
    for family in families:
        require(family["status"] == "research_before_domain_validation" and family["answer"] is None,
                "No invented family answer")
        require(len(family["proposals"]) == 3, "Three proposals per theme")
        for proposal in family["proposals"]:
            require(proposal["family"] == family["id"] and proposal["id"].startswith("R-" + family["id"] + "-"),
                    "Proposal family identity")
            require(proposal["status"] == "proposal_before_domain_validation" and proposal["answer"] is None,
                    "Proposal cannot silently become approved")
            require(proposal.get("domain_approved", False) is False, "No expert admission inferred from sources")
            require(proposal["basis"] in {"source_supported", "design_proposal", "needs_expert"}, "Source/design/expert split")
            require(set(proposal["question_ids"]) <= questions, "Invented original question ID")
            require(set(proposal["blocker_ids"]) <= EXPECTED_GATES, "Invented blocker")
            require(set(proposal["rest_scope_refs"]) <= rests, "Invented rest scope")
            require(proposal["source_ids"] and set(proposal["source_ids"]) <= source_map.keys(), "Missing source evidence")
            require(proposal["expert_decision"] and proposal["implementation_consequence"], "Scoped expert rest and App consequence")
            referenced.update(proposal["question_ids"])
            for case in proposal["independent_cases"]:
                require(case["status"] == "suggested_case_before_expert_review" and case["limits"],
                        "Proposed case is not a Golden oracle")
                case_count += 1
    require(sorted(referenced) == coverage["referenced_question_ids"], "Scope reference coverage changed")
    require(sorted(questions - referenced) == coverage["not_directly_referenced_question_ids"], "Unreferenced questions cannot vanish")
    require(coverage["counts"]["referenced_original_question_ids"] == len(referenced)
            and coverage["counts"]["suggested_independent_cases"] == case_count, "Coverage counts mismatch")
    return {"families": 10, "preliminary_proposals": 30, "opened_source_url_records": 40,
            "referenced_existing_question_ids": len(referenced), "existing_questions_preserved_open": 418,
            "blockers_preserved_open": 8, "suggested_cases_not_golden_tests": case_count}


def validate_files(bundle):
    manifest = bundle["input-manifest"]
    for ref in manifest["inputs"]:
        require(digest((ROOT / ref["path"]).read_bytes()) == ref["sha256"], "Original agenda/source file changed")
    entry = manifest["agenda_readme_entry"]
    text = (ROOT / entry["path"]).read_text()
    require(text.count(entry["added_entry"]) == 1, "Exact one research navigation entry")
    require(digest(text.replace(entry["added_entry"], "", 1).encode()) == entry["original_sha256"],
            "Previous agenda content changed")
    count = 0
    for path in HERE.glob("*.md"):
        for target in re.findall(r"\]\(([^)]+)\)", path.read_text()):
            if "://" in target or target.startswith("#"):
                continue
            require((path.parent / target.split("#")[0]).is_file(), "Broken local research link")
            count += 1
    return {"pinned_original_files": len(manifest["inputs"]), "original_bytes_unchanged": True,
            "previous_agenda_preserved": True, "local_links_checked": count}


def self_test(bundle):
    def remove_evidence(b):
        b["proposals"]["families"][0]["proposals"][0]["source_ids"] = []
    mutations = [
        lambda b: b["proposals"]["families"].pop(),
        lambda b: b["proposals"].update(promotion_ready=True),
        lambda b: b["proposals"]["families"][0]["proposals"][0].update(status="approved"),
        lambda b: b["proposals"]["families"][0]["proposals"][0]["question_ids"].append("invented-legacy-id"),
        remove_evidence,
        lambda b: b["sources"]["sources"][0].update(original_document_sha256="claimed-PDF-hash"),
        lambda b: b["coverage"]["not_directly_referenced_question_ids"].clear(),
    ]
    for mutate in mutations:
        altered = copy.deepcopy(bundle)
        mutate(altered)
        try:
            validate_structure(altered)
        except ValueError:
            continue
        raise ValueError("Research mutation bypassed integrity guard")
    return len(mutations)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    bundle = load_bundle()
    result = validate_structure(bundle)
    result.update(validate_files(bundle))
    if args.self_test:
        result["rejected_integrity_mutations"] = self_test(bundle)
    print(json.dumps(result, ensure_ascii=False, indent=2))
