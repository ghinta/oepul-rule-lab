"""Integrity and risk reproduction for a review dossier, not golden tests."""

from __future__ import annotations

import copy
import json
import os
from pathlib import Path
import unittest

from rulelab.heuwirtschaft import evaluate
from tools.validate_o6_3_contract import load, validate


class VariableDossierTests(unittest.TestCase):
    def test_removing_promotion_blockers_is_rejected(self):
        review = copy.deepcopy(load("source-review.json"))
        review["blockers"] = []
        with self.assertRaisesRegex(ValueError, "required promotion blocker set"):
            validate(review=review)

    def test_closing_promotion_blocker_without_new_review_is_rejected(self):
        review = copy.deepcopy(load("source-review.json"))
        review["blockers"][0]["status"] = "resolved"
        with self.assertRaisesRegex(
            ValueError, "required promotion blocker is not open"
        ):
            validate(review=review)

    def test_complete_input_rule_source_and_app_inventory_join(self):
        result = validate()
        self.assertEqual(46, result["variables"])
        self.assertEqual(20, result["rgve_categories"])
        self.assertFalse(result["promotion_ready"])

    def test_missing_input_field_is_detected(self):
        contract = copy.deepcopy(load("variables.json"))
        contract["variables"].pop()
        with self.assertRaisesRegex(ValueError, "variable coverage"):
            validate(contract=contract)

    def test_registered_animal_count_cannot_claim_existing_o6_3_consumption(self):
        contract = copy.deepcopy(load("variables.json"))
        field = next(
            v for v in contract["variables"] if v["path"].endswith(".animal_count")
        )
        self.assertTrue(field["app"]["registered"])
        field["app"]["consumed_by_o6_3"] = True
        with self.assertRaisesRegex(ValueError, "App consumption drift"):
            validate(contract=contract)

    def test_average_count_cannot_be_mislabeled_as_existing_gve(self):
        contract = copy.deepcopy(load("variables.json"))
        field = next(
            v for v in contract["variables"] if v["path"].endswith(".average_count")
        )
        field["app"]["path"] = "gve"
        with self.assertRaisesRegex(ValueError, "App path drift"):
            validate(contract=contract)

    def test_source_quote_must_be_present_on_exact_page(self):
        citations = copy.deepcopy(load("citations.json"))
        citations[0]["quote"] = (
            "Unbelegte automatische Dürrebefreiung für alle Verpflichtungen"
        )
        with self.assertRaisesRegex(ValueError, "quote not found"):
            validate(citations=citations)

    def test_changed_small_equids_coefficient_is_detected(self):
        review = copy.deepcopy(load("source-review.json"))
        row = next(
            r
            for r in review["normative_tables"]["rgve"]
            if r["category_id"] == "kleine_equiden:adulte_ab_3_jahre"
        )
        row["rgve"] = 1.0
        with self.assertRaisesRegex(ValueError, "RGVE rate drift"):
            validate(review=review)


class DevelopmentObservationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not os.environ.get("OPA_BIN"):
            raise unittest.SkipTest(
                "OPA_BIN required to reproduce the pinned development observations"
            )
        cls.opa = Path(os.environ["OPA_BIN"])

    def test_documented_candidate_observations_and_open_risks_are_reproducible(self):
        review = load("source-review.json")
        blockers = {b["id"] for b in review["blockers"]}
        for case in load("development-probes.json")["cases"]:
            with self.subTest(case=case["id"]):
                actual = evaluate(json.dumps(case["input"]), self.opa)
                self.assertEqual(
                    case["observation"], {k: actual[k] for k in case["observation"]}
                )
                if case["blocker_id"] is not None:
                    self.assertIn(case["blocker_id"], blockers)
                self.assertFalse(review["promotion_ready"])
