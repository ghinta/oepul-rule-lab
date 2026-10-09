"""Validate agenda coverage and admission safeguards without App/network access."""
import argparse
import copy
import hashlib
import json
import re
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
FAMILIES = {f"D{i:02}" for i in range(1, 11)}
BLOCKERS = {
    "GROUP_IDENTITY", "COUNT_BASIS", "GREEN_FEEDING_HISTORY", "RECOGNITION_TIME",
    "GENERAL_FUNDING", "ANNUAL_EVIDENCE", "SOURCE_CURRENTNESS", "OPUS_REVISION",
}
CONSTRAINTS = {
    "CURRENT_YEAR_SELECTED_DATA", "EXPERT_OPERATOR_OVERRIDE_AMA", "AUTO_OWN_DOCUMENTED_SNAPSHOT",
    "ALLOWED_NEW_AREA_ENTITIES", "VISIBLE_CREATION_PROVENANCE", "PROVENANCE_TEXT_EXPORT_DRIFT",
    "FUTURE_REASONED_NOTE", "INPUT_SOURCE_DISTINCT_FROM_NORMATIVE_AUTHORITY",
    "ORIGINAL_QUESTIONS_REMAIN_OPEN", "DRAFTS_NO_MERGE_THESIS",
}


def digest(data):
    return hashlib.sha256(data).hexdigest()


def read(name):
    return json.loads((HERE / name).read_text())


def require(condition, message):
    if not condition:
        raise ValueError(message)


def load_bundle():
    return {name: read(name + ".json") for name in
            ("question-index", "decision-catalogue", "rest-scopes", "synergy-plan", "input-manifest")}


def source_questions():
    refined = {}
    for path in sorted((ROOT / "docs/analysis").glob("o6_*-variable-review-20261008/questions.json")):
        for q in json.loads(path.read_text()):
            require(q["id"] not in refined, "Duplicate refined source question")
            refined[q["id"]] = (str(path.relative_to(ROOT)), q)
    path = "docs/analysis/all-measure-variable-review-20261008/questions.json"
    original = {}
    for questions in json.loads((ROOT / path).read_text()).values():
        for q in questions:
            require(q["id"] not in original, "Duplicate original source question")
            original[q["id"]] = (path, q)
    require(len(refined) == 289 and len(original) == 129, "Required 289+129 source coverage")
    require(not refined.keys() & original.keys(), "Source question sets must remain distinct")
    return refined, original


def validate_structure(bundle):
    index, cards, rest, plan, manifest = (bundle[n] for n in
        ("question-index", "decision-catalogue", "rest-scopes", "synergy-plan", "input-manifest"))
    refined, original = source_questions()
    expected = {**refined, **original}
    questions = index["questions"]
    require(len(questions) == 418 and {q["question_id"] for q in questions} == expected.keys(),
            "Complete unique 418 question IDs required")
    require(index["promotion_ready"] is False and cards["promotion_ready"] is False
            and plan["promotion_ready"] is False, "Agenda cannot silently authorize promotion")
    for q in questions:
        source_file, source = expected[q["question_id"]]
        require(q["file"] == source_file, "Question source identity changed")
        require(q["kind"] == ("refined" if q["question_id"] in refined else "original"),
                "Distinct original/refined provenance required")
        require(q["status"] == source["status"] == "open_before_app_admission"
                and q["answer"] is source["answer"] is None, "Question must remain open/unanswered")
        require(q["primary_decision"] in FAMILIES, "Unknown primary family")
        require(len(q["related_decisions"]) == len(set(q["related_decisions"]))
                and set(q["related_decisions"]) <= FAMILIES - {q["primary_decision"]},
                "Invalid related family")
        require(q["source_sha256"] == digest((ROOT / source_file).read_bytes()),
                "Question hash does not match original source")
    gates = index["o6_3_blockers"]
    require(len(gates) == 8 and {g["blocker_id"] for g in gates} == BLOCKERS,
            "Exact required eight o6_3 blockers")
    source_gates = json.loads((ROOT / gates[0]["file"]).read_text())["blockers"]
    require(len(source_gates) == 8 and {g["id"] for g in source_gates} == BLOCKERS,
            "Source blockers cannot disappear")
    require(all(g["status"] == "open_before_full_recommendation" for g in source_gates),
            "Original blocker statuses must remain open")
    for g in gates:
        require(g["status"] == "open_before_full_recommendation" and g["answer"] is None,
                "Agenda blocker statuses must remain open")
        require(g["primary_decision"] in FAMILIES, "Invalid blocker family")
    require(next(g for g in gates if g["blocker_id"] == "OPUS_REVISION")["audience"]
            == "technical_artifact_review", "OPUS revision is not a domain answer")
    decisions = cards["decisions"]
    require(len(decisions) == 10 and {d["id"] for d in decisions} == FAMILIES, "Exact ten families")
    for d in decisions:
        require(d["answer"] is None and d["status"] == "open_for_scoped_domain_answers",
                "No assumed family answer")
        for field, actual in (
            ("question_ids", [q["question_id"] for q in questions if q["primary_decision"] == d["id"]]),
            ("related_question_ids", [q["question_id"] for q in questions if d["id"] in q["related_decisions"]]),
            ("blocker_ids", [g["blocker_id"] for g in gates if g["primary_decision"] == d["id"]]),
        ):
            require(d[field] == actual, "Family navigation differs from question/gate index")
    constraints = rest["confirmed_product_constraints"]
    require(len(constraints) == 10 and {c["id"] for c in constraints} == CONSTRAINTS,
            "Required confirmed product constraints")
    require(all(c["status"] == "confirmed" and c["reask"] is False for c in constraints),
            "Confirmed requirements cannot become new permission gates")
    require(digest(json.dumps(constraints, ensure_ascii=False, sort_keys=True,
                             separators=(",", ":")).encode()) == manifest["confirmed_constraints_sha256"],
            "Confirmed product wording changed")
    scopes = rest["additional_decisions"]
    require(len(scopes) == 13 and len({s["id"] for s in scopes}) == 13, "Rest scope coverage")
    for s in scopes:
        require(s["answer"] is None and s["status"] == "open", "No assumed rest-scope answer")
        require(s["decision_family"] in FAMILIES and s["kind"] in {"domain", "product", "technical"},
                "Rest scope classification invalid")
        for ref in s["existing_question_refs"]:
            require(ref["id"] in expected or ref["id"] in BLOCKERS, "Invented original question ID")
            require((ROOT / ref["canonical_file"]).is_file(), "Invalid canonical question reference")
    steps = {s["id"]: s for s in plan["implementation_order"]}
    require(len(steps) == 8 and set(steps) == {f"I{i:02}" for i in range(1, 9)}, "Eight implementation steps")
    require(steps["I05"]["depends_on"] == [], "Source capture may proceed before expert answers")
    done, visiting = set(), set()
    def visit(sid):
        require(sid in steps and sid not in visiting, "Unknown dependency or dependency cycle")
        if sid in done:
            return
        visiting.add(sid)
        for dep in steps[sid]["depends_on"]:
            visit(dep)
        visiting.remove(sid)
        done.add(sid)
    for sid in steps:
        visit(sid)
    require(len(plan["synergies"]) == 9 and len(plan["concreteTechnicalFollowups"]) == 7,
            "Synergy/technical followup coverage")
    return {"refined_questions": 289, "original_questions": 129, "unique_question_ids": 418,
            "separate_open_o6_3_blockers": 8, "decision_families": 10,
            "synergies": 9, "technical_followups": 7, "implementation_steps": 8}


def validate_files(bundle, app_root=None):
    manifest = bundle["input-manifest"]
    for item in manifest["inputs"]:
        data = (ROOT / item["path"]).read_bytes()
        if item["mode"] == "historical_content_after_removing_single_agenda_entry":
            entry = item["agenda_entry"].encode()
            require(data.count(entry) == 1, "Exact one agenda navigation entry required")
            data = data.replace(entry, b"", 1)
        require(digest(data) == item["sha256"], "Pinned source content changed: " + item["path"])
    for q in bundle["question-index"]["questions"]:
        for ref in q["block_contexts"]:
            data = json.loads((ROOT / ref["file"]).read_text())
            scope = next((s for s in data["scopes"] if s["id"] == ref["scope_id"]), None)
            require(scope is not None, "Unknown block scope")
            ids = scope.get("existing_question_ids", []) + [r["id"] for r in scope.get("question_refs", [])]
            require(q["question_id"] in ids, "Block does not contain attributed question")
    for path in HERE.glob("*.md"):
        for target in re.findall(r"\]\(([^)]+)\)", path.read_text()):
            if "://" in target or target.startswith("#"):
                continue
            require((path.parent / target.split("#")[0]).is_file(), "Broken Markdown link: " + target)
    plan = bundle["synergy-plan"]
    for item in plan["synergies"] + plan["concreteTechnicalFollowups"]:
        for ref in item.get("artifact_refs", []):
            if "path" not in ref:
                continue
            require((ROOT / ref["path"]).is_file(), "Missing synergy evidence")
            if ref.get("scope_ids"):
                scopes = json.loads((ROOT / ref["path"]).read_text())["scopes"]
                require(set(ref["scope_ids"]) <= {s["id"] for s in scopes}, "Unknown synergy scope")
    if app_root:
        for item in plan["verification"]["app_file_pin_checks"]:
            require(digest((app_root / item["path"]).read_bytes()) == item["sha256"], "App pin content changed")
        for item in plan["concreteTechnicalFollowups"]:
            for ref in item["code_refs"]:
                lines = (app_root / ref["path"]).read_text().splitlines()
                require(ref["anchor"] in "\n".join(lines[ref["line_start"]-1:ref["line_end"]]),
                        "App code anchor mismatch")
    return {"pinned_input_files": len(manifest["inputs"]), "source_content_unchanged": True,
            "links_and_block_scopes_valid": True, "app_pin_checked_locally": app_root is not None}


def self_test(bundle):
    mutations = [
        lambda b: b["question-index"]["questions"].pop(),
        lambda b: b["question-index"]["o6_3_blockers"].clear(),
        lambda b: b["question-index"]["o6_3_blockers"][0].update(status="resolved"),
        lambda b: b["question-index"]["questions"][0].update(answer="assumed"),
        lambda b: b["decision-catalogue"]["decisions"].pop(),
        lambda b: b["rest-scopes"]["confirmed_product_constraints"].pop(),
        lambda b: b["synergy-plan"]["implementation_order"][0].update(depends_on=["I03"]),
    ]
    for mutate in mutations:
        altered = copy.deepcopy(bundle)
        mutate(altered)
        try:
            validate_structure(altered)
        except ValueError:
            continue
        raise ValueError("Mutation bypassed the admission integrity safeguards")
    return len(mutations)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--self-test", action="store_true")
    parser.add_argument("--app-root", type=Path)
    args = parser.parse_args()
    bundle = load_bundle()
    result = validate_structure(bundle)
    result.update(validate_files(bundle, args.app_root))
    if args.self_test:
        result["rejected_integrity_mutations"] = self_test(bundle)
    print(json.dumps(result, ensure_ascii=False, indent=2))
