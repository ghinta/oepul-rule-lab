"""Opus publication selection and frozen diagnostic boundaries, not policy scores."""

from __future__ import annotations

import copy
import csv
import hashlib
import io
import os
from pathlib import Path
import shutil
import tempfile
import unittest
from unittest.mock import patch

from rulelab import opus_screening as opus
from rulelab import screening as core
from tools import validate_opus_run_review as review


REPOSITORY = Path(__file__).resolve().parents[1]
ROLES = ("baseline", "variation", "missing_fact")


def write_json(path: Path, value: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(core.json_bytes(value))


def publication(root: Path) -> dict[str, str]:
    """All 26 measures plus ten superseded runs, including a failed latest run."""
    selected = {}
    for index, measure in enumerate(core.MEASURES):
        run_id = f"selected-{measure}"
        selected[measure] = run_id
        write_json(root / "runs" / run_id / "run.json", {
            "run_id": run_id, "measure": measure, "model": {"model": opus.MODEL},
            "status": "finalized", "finalized_at": "2026-10-11T12:00:00+00:00",
            "generator_exit_code": 1 if index == 0 else 0,
            "metrics": {"technical_validation_exit_code": 1 if index == 0 else 0},
        })
        if index < 10:
            old_id = f"zz-historical-{measure}"
            write_json(root / "runs" / old_id / "run.json", {
                "run_id": old_id, "measure": measure, "model": {"model": opus.MODEL},
                "status": "finalized", "finalized_at": "2026-10-10T12:00:00+00:00",
                "generator_exit_code": 0, "metrics": {"technical_validation_exit_code": 0},
            })
    return selected


def fixture(measure: str, run_id: str) -> dict:
    return {
        "measure_id": measure, "run_id": run_id, "query": "data.diagnostic.result",
        "input_contract_note": "Synthetischer boolescher Fakt, kein realer Betrieb.",
        "output_contract_note": "Nativer Faktwert; keine unabhängige Förderentscheidung.",
        "case_origin": "Sichtbare Entwicklungsfälle ohne Sollwerte oder Expertenlabels.",
        "cases": [
            {"case_id": "baseline", "purpose": "Explizites false beobachten.", "input": {"fact": False}},
            {"case_id": "variation", "purpose": "Nur den Fakt verändern.", "input": {"fact": True}},
            {"case_id": "missing_fact", "purpose": "Den Fakt entfernen.", "input": {}},
        ],
        "references": [{"path": f"runs/{run_id}/workspace/policy/measure.rego",
                        "detail": "Native result-Regel und Eingabefakt."}],
        "open_dependencies": [],
    }


def translation(measure: str) -> dict:
    return {
        "fixture_path": (opus.LUNA_REPORT / "fixtures" / f"{measure}.json").as_posix(),
        "cases": [{"case_id": role, "mapped_facts": [f"{role}: fact unverändert übernommen."],
                   "unmapped_facts": []} for role in ROLES],
        "comparison_limit": "Gleiche synthetische Fakten belegen keine fachliche Richtigkeit.",
    }


class PublicationSelectionTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        self.selected = publication(self.root)

    def test_all_36_runs_are_retained_and_latest_is_selected_without_success_filter(self):
        selected, inventory = opus.select_candidates(self.root)
        self.assertEqual(self.selected, selected)
        self.assertEqual(36, len(inventory))
        self.assertEqual(26, len(selected))
        failed = core.load_json(self.root / "runs" / selected["o6_1a"] / "run.json")
        self.assertEqual(1, failed["metrics"]["technical_validation_exit_code"])
        self.assertIn("zz-historical-o6_1a", {row["run_id"] for row in inventory})

    def test_run_id_breaks_finalized_timestamp_ties(self):
        path = self.root / "runs/zz-historical-o6_1b/run.json"
        run = core.load_json(path)
        run["finalized_at"] = "2026-10-11T12:00:00+00:00"
        write_json(path, run)
        selected, _ = opus.select_candidates(self.root)
        self.assertEqual("zz-historical-o6_1b", selected["o6_1b"])

    def test_unfinished_opus_run_is_rejected_even_if_it_would_not_win(self):
        path = self.root / "runs/zz-historical-o6_1a/run.json"
        run = core.load_json(path)
        run["status"] = "running"
        write_json(path, run)
        with self.assertRaisesRegex(ValueError, "unfinished"):
            opus.select_candidates(self.root)

    def test_other_model_unfinished_metadata_does_not_enter_opus_inventory(self):
        write_json(self.root / "runs/unrelated/run.json", {
            "model": {"model": core.MODEL}, "status": "running",
        })
        selected, inventory = opus.select_candidates(self.root)
        self.assertEqual(self.selected, selected)
        self.assertEqual(36, len(inventory))

    def test_mismatched_path_measure_and_missing_timestamp_are_rejected(self):
        path = self.root / "runs/selected-o6_1a/run.json"
        original = core.load_json(path)
        for field, value in (("run_id", "another-directory"), ("measure", "o6_99"),
                             ("finalized_at", None), ("finalized_at", "")):
            with self.subTest(field=field, value=value):
                write_json(path, dict(original, **{field: value}))
                with self.assertRaises(ValueError):
                    opus.select_candidates(self.root)

    def test_publication_count_and_measure_coverage_cannot_silently_change(self):
        path = self.root / "runs/selected-o6_24/run.json"
        path.unlink()
        with self.assertRaisesRegex(ValueError, "36 finalized Opus runs"):
            opus.select_candidates(self.root)


class TranslationAccountingTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        self.fixture = fixture("o6_3", "selected-o6_3")
        self.fixture["luna_translation"] = translation("o6_3")
        write_json(self.root / opus.LUNA_REPORT / "fixtures/o6_3.json", fixture("o6_3", "luna-o6_3"))

    def test_all_three_luna_roles_are_accounted_for_even_for_an_unexecutable_opus_gap(self):
        gap = copy.deepcopy(self.fixture)
        gap["cases"] = []
        gap["gap"] = "Kein belegbares natives Eingabeschema für diese Fakten."
        for case in gap["luna_translation"]["cases"]:
            case["unmapped_facts"] = case.pop("mapped_facts")
            case["mapped_facts"] = []
        opus.validate_translation(self.root, gap)
        core.validate_fixture(gap, "o6_3", "selected-o6_3")
        self.assertEqual(list(ROLES), [c["case_id"] for c in gap["luna_translation"]["cases"]])

    def test_omitted_duplicated_and_reordered_luna_cases_are_rejected(self):
        for cases in (["baseline", "variation"], ["baseline", "variation", "variation"],
                      ["baseline", "missing_fact", "variation"]):
            changed = copy.deepcopy(self.fixture)
            changed["luna_translation"]["cases"] = [
                {"case_id": role, "mapped_facts": ["Explizite Tatsache."], "unmapped_facts": []}
                for role in cases
            ]
            with self.subTest(cases=cases), self.assertRaisesRegex(ValueError, "every original Luna case"):
                opus.validate_translation(self.root, changed)

    def test_wrong_luna_measure_and_silent_fact_omissions_are_rejected(self):
        changes = [copy.deepcopy(self.fixture) for _ in range(4)]
        changes[0]["luna_translation"]["fixture_path"] = (opus.LUNA_REPORT / "fixtures/o6_4.json").as_posix()
        changes[1]["luna_translation"]["cases"][0]["mapped_facts"] = []
        changes[2]["luna_translation"]["cases"][0]["unmapped_facts"] = [""]
        changes[3]["luna_translation"]["comparison_limit"] = ""
        for changed in changes:
            with self.subTest(translation=changed["luna_translation"]), self.assertRaises(ValueError):
                opus.validate_translation(self.root, changed)

    def test_translated_inputs_cannot_supply_reference_labels(self):
        for label in ("expected", "expected_output", "golden_label"):
            changed = copy.deepcopy(self.fixture)
            changed["cases"][0][label] = False
            with self.subTest(label=label), self.assertRaisesRegex(ValueError, "reference labels"):
                core.validate_fixture(changed, "o6_3", "selected-o6_3")


class FrozenOpusContractTests(unittest.TestCase):
    """Small complete inventories exercise real manifest verification without mocks."""

    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        base = Path(self.directory.name)
        self.root = base / "analysis-repository"
        self.candidate = base / "historical-candidates"
        self.root.mkdir()
        self.candidate.mkdir()
        self.report = self.root / opus.REPORT
        for name in ("opa-version.txt", "opa-checksums.json"):
            target = self.root / "runner/validation" / name
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(REPOSITORY / "runner/validation" / name, target)
        selected = publication(self.candidate)
        source = b"A historical synthetic source, never a legal reference label.\n"
        profile = b"{}\n"
        for root in (self.root, self.candidate):
            path = root / "sources/oepul/legal/synthetic.txt"
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(source)
            path = root / "profiles/canonical_farm_profile.json"
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(profile)
        source_record = {"source_path": "legal/synthetic.txt", "sha256": hashlib.sha256(source).hexdigest(),
                         "bytes": len(source)}
        for path in sorted((self.candidate / "runs").glob("*/run.json")):
            run = core.load_json(path)
            self.complete_run(self.candidate, run, source_record, profile)
        for measure in core.MEASURES:
            run_id = f"luna-{measure}"
            run = {"run_id": run_id, "measure": measure, "model": {"model": core.MODEL},
                   "status": "finalized", "finalized_at": "2026-09-01T12:00:00+00:00"}
            self.complete_run(self.root, run, source_record, profile)
            write_json(self.root / opus.LUNA_REPORT / "fixtures" / f"{measure}.json", fixture(measure, run_id))
            translated = fixture(measure, selected[measure])
            translated["luna_translation"] = translation(measure)
            write_json(self.report / "fixtures" / f"{measure}.json", translated)
        luna_manifest = core.create_manifest(self.root, self.root / opus.LUNA_REPORT, opus.LUNA_COMMIT)
        write_json(self.root / opus.LUNA_REPORT / "manifest.json", luna_manifest)
        write_json(self.root / opus.LUNA_REPORT / "results.json", {"kind": "development-diagnostic"})
        (self.root / opus.LUNA_REPORT / "matrix.csv").write_text("measure_id,run_id\n", encoding="utf-8")
        self.manifest = opus.create_manifest(self.root, self.candidate, self.report)

    @staticmethod
    def complete_run(root: Path, run: dict, source: dict, profile: bytes) -> None:
        run.update(mode="discover", created_at="2026-09-01T12:00:00+00:00", generation_attempt=2,
                   sources=[source], profile={"path": "profiles/canonical_farm_profile.json",
                                             "sha256": hashlib.sha256(profile).hexdigest()},
                   generator_result={"total_cost_usd": 1.0})
        directory = root / "runs" / run["run_id"]
        write_json(directory / "run.json", run)
        policy = directory / "workspace/policy/measure.rego"
        policy.parent.mkdir(parents=True, exist_ok=True)
        policy.write_text("package diagnostic\nresult := input.fact\n", encoding="utf-8")
        # This conflicting model-test definition would poison every observation
        # if tests were accidentally added to the policy/data evaluation bundle.
        model_test = directory / "workspace/tests/model_test.rego"
        model_test.parent.mkdir(parents=True, exist_ok=True)
        model_test.write_text('package diagnostic\nresult := "model-test-only"\n', encoding="utf-8")
        write_json(directory / "workspace/rules/rules.json", {"rules": [{"rule_type": "synthetic"}]})
        write_json(directory / "workspace/rules/profile_changes.json", {"changes": []})
        write_json(directory / "workspace/rules/coverage.json", {"sources": []})
        write_json(directory / "artifacts/input-paths.json", {"paths": ["fact"]})

    def test_two_roots_are_bound_without_loading_model_tests_or_luna_policies(self):
        opus.verify_manifest(self.root, self.candidate, self.report, self.manifest)
        self.assertEqual(26, len(self.manifest["entries"]))
        self.assertEqual(36, len(self.manifest["published_opus_inventory"]))
        for entry in self.manifest["entries"]:
            self.assertTrue((self.root / entry["fixture"]["path"]).is_file())
            self.assertFalse((self.candidate / entry["fixture"]["path"]).exists())
            self.assertTrue(any("/workspace/tests/" in record["path"] for record in entry["artifacts"]))
            self.assertTrue(all(path.startswith(f"runs/{entry['run_id']}/workspace/policy/")
                                for path in entry["load_paths"]))

    def test_selection_provenance_and_inventory_cannot_be_relabelled(self):
        for field, replacement in (("selection_method", "best successful output"),
                                   ("candidate_commit", "unverified-head"),
                                   ("published_opus_inventory", self.manifest["published_opus_inventory"][:-1])):
            manifest = copy.deepcopy(self.manifest)
            manifest[field] = replacement
            with self.subTest(field=field), self.assertRaisesRegex(ValueError, "selection, provenance or Luna baseline changed"):
                opus.verify_manifest(self.root, self.candidate, self.report, manifest)

    def test_superseded_metadata_is_frozen_as_well_as_selected_candidates(self):
        path = self.candidate / "runs/zz-historical-o6_1a/run.json"
        run = core.load_json(path)
        run["generator_result"]["total_cost_usd"] = 99.0
        write_json(path, run)
        with self.assertRaisesRegex(ValueError, "selection, provenance or Luna baseline changed"):
            opus.verify_manifest(self.root, self.candidate, self.report, self.manifest)

    def test_opus_fixture_luna_baseline_and_runtime_files_cannot_change_after_freeze(self):
        paths = (self.report / "fixtures/o6_3.json",
                 self.root / opus.LUNA_REPORT / "fixtures/o6_3.json",
                 self.root / opus.LUNA_REPORT / "results.json",
                 self.root / "runner/validation/opa-version.txt",
                 self.root / "runner/validation/opa-checksums.json")
        for path in paths:
            original = path.read_bytes()
            path.write_bytes(original + b"\n")
            try:
                with self.subTest(path=path), self.assertRaises(ValueError):
                    opus.verify_manifest(self.root, self.candidate, self.report, self.manifest)
            finally:
                path.write_bytes(original)

    def test_an_unmapped_comparison_preserves_all_luna_cases_and_rejects_semantic_promotion(self):
        results = {"measures": [{"measure_id": entry["measure_id"], "cases": [],
                    "luna_translation": translation(entry["measure_id"])} for entry in self.manifest["entries"]]}
        for measure in results["measures"]:
            for case in measure["luna_translation"]["cases"]:
                case["unmapped_facts"] = case["mapped_facts"]
                case["mapped_facts"] = []
        compared = opus.comparison(self.root, self.candidate, self.manifest, results)
        self.assertFalse(compared["semantic_validation"])
        self.assertEqual(26, compared["source_hash_set_counts"]["same"])
        self.assertEqual({"latest_26": 26.0, "all_36": 36.0},
                         {key: compared["opus_cost_usd"][key] for key in ("latest_26", "all_36")})
        for row in compared["measures"]:
            self.assertEqual([], row["executed_case_ids"])
            self.assertEqual(list(ROLES), [c["case_id"] for c in row["translation"]["cases"]])
            self.assertEqual("not_adjudicated", row["semantic_judgement"])
            self.assertFalse(row["isolated_model_effect"])

    def test_native_replay_preserves_false_true_and_missing_fact_without_reference_scores(self):
        configured = os.environ.get("OPA_BIN")
        if not configured or not Path(configured).is_file():
            self.skipTest("OPA_BIN required for isolated native replay")
        results = core.execute(self.root, self.manifest, Path(configured), model=opus.MODEL,
                               candidate_root=self.candidate)
        self.assertEqual(26, len(results["measures"]))
        for measure in results["measures"]:
            cases = measure["cases"]
            self.assertEqual(list(ROLES), [case["case_id"] for case in cases])
            self.assertEqual(["defined", "defined", "undefined"], [case["status"] for case in cases])
            self.assertIs(cases[0]["output"], False)
            self.assertIs(cases[1]["output"], True)
            self.assertNotIn("output", cases[2])
            self.assertTrue(all(not ({"expected", "expected_output", "golden_label"} & case.keys()) for case in cases))
        files = opus.report_files(self.root, self.candidate, self.manifest, results)
        self.assertIn(b"not_adjudicated", files["comparison.json"])
        self.assertIn(b'"semantic_validation": false', files["comparison.json"])
        rows = list(csv.DictReader(io.StringIO(files["comparison.csv"].decode("utf-8"))))
        self.assertEqual(26, len(rows))
        self.assertTrue(all(row["executed_cases"] == "3" and row["semantic_judgement"] == "not_adjudicated" for row in rows))
        self.assertIn("keine Genauigkeitsmessung", files["README.md"].decode("utf-8"))
        opus.verify_manifest(self.root, self.candidate, self.report, self.manifest)


class AnalysisWriteBoundaryTests(unittest.TestCase):
    def test_both_directions_of_candidate_report_overlap_are_rejected_before_work(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory) / "repository"
            root.mkdir()
            report = root / opus.REPORT
            for candidate in (report / "historical", root, root / "docs/analysis"):
                with self.subTest(candidate=candidate), patch.object(opus, "ROOT", root), \
                     patch.object(opus, "create_manifest") as create:
                    with self.assertRaisesRegex(ValueError, "separate"):
                        opus.main(["freeze", "--candidate-root", str(candidate)])
                    create.assert_not_called()

    def test_report_outside_analysis_is_rejected_before_work(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            with patch.object(opus, "ROOT", root), patch.object(opus, "create_manifest") as create:
                with self.assertRaisesRegex(ValueError, "separate"):
                    opus.main(["freeze", "--candidate-root", str(root / "candidates"),
                               "--report-dir", "runs/overwritten"])
                create.assert_not_called()


class SourceAuditObservationTests(unittest.TestCase):
    """A malformed probe must not become a recorded source disagreement."""

    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        # The legacy envelope avoids unrelated manifest dependencies. Both
        # dossier formats use the same expectation checks under validation.
        self.binding = {"run_id": "synthetic-audit", "opa_version": "synthetic-runtime"}
        write_json(self.root / "binding.json", self.binding)

    def observations(self, operator, output):
        expectation = {"path": ["violations"], "operator": operator, "expected": "RULE-A"}
        case = {"case_id": "synthetic-rule-collection", "input": {},
                "expectations": [expectation]}
        write_json(self.root / "development-probes.json", {"cases": [case]})
        result = {"case_id": case["case_id"], "status": "defined", "output": {"violations": output},
                  "input_sha256": hashlib.sha256(review.runner.encoded(case["input"])).hexdigest()}
        result["checks"] = [review.runner.check_expectation(expectation, result)]
        observations = {"candidate_commit": review.runner.CANDIDATE_COMMIT,
                        "run_id": self.binding["run_id"], "opa_version": self.binding["opa_version"],
                        "compile": "strict_passed",
                        "binding_sha256": review.runner.digest(self.root / "binding.json"),
                        "fixture_sha256": review.runner.digest(self.root / "development-probes.json"),
                        "cases": [result],
                        "summary": {"cases": 1, "checks": 1,
                                    "expectations_met": int(result["checks"][0]["passed"])}}
        write_json(self.root / "observations.json", observations)
        return result["checks"][0]

    def test_rule_matchers_reject_nonempty_string_and_malformed_object_collections(self):
        outputs = (["RULE-A"], ["RULE-B"], [{"rule_id": None}],
                   [{"rule_id": "RULE-A"}, "RULE-B"])
        for operator in ("contains_rule", "excludes_rule"):
            for output in outputs:
                with self.subTest(operator=operator, output=output):
                    check = self.observations(operator, output)
                    self.assertIs(check["invalid_rule_collection"], True)
                    self.assertIs(check["passed"], False)
                    with self.assertRaisesRegex(ValueError, "Invalid rule collection.*synthetic-rule-collection"):
                        review.validate_observations(self.root, self.binding)

    def test_empty_rule_collections_remain_valid_without_static_type_inference(self):
        for operator, passed in (("contains_rule", False), ("excludes_rule", True)):
            with self.subTest(operator=operator):
                check = self.observations(operator, [])
                self.assertNotIn("invalid_rule_collection", check)
                self.assertIs(check["passed"], passed)
                review.validate_observations(self.root, self.binding)

    def test_well_formed_rule_collections_can_record_agreements_and_disagreements(self):
        for operator in ("contains_rule", "excludes_rule"):
            for rule_id in ("RULE-A", "RULE-B"):
                with self.subTest(operator=operator, rule_id=rule_id):
                    check = self.observations(operator, [{"rule_id": rule_id}])
                    self.assertNotIn("invalid_rule_collection", check)
                    self.assertIs(check["passed"], (rule_id == "RULE-A") == (operator == "contains_rule"))
                    review.validate_observations(self.root, self.binding)


if __name__ == "__main__":
    unittest.main()
