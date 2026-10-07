from __future__ import annotations

import copy
import hashlib
import json
import os
from pathlib import Path
import shutil
import unittest

from pydantic import ValidationError
from pypdf import PdfReader

from rulelab.heuwirtschaft import Input, evaluate

ROOT = Path(__file__).resolve().parents[1]
BUNDLE = ROOT / "adaptations/o6_3"
BASE = json.loads((BUNDLE / "fixtures/merkblatt-example.json").read_text())


def case(year=2026, area=None, groups=None):
    value = copy.deepcopy(BASE)
    value["farm"]["year"] = year
    value["context"] = {"current_year": year, "snapshot_year": year, "as_of": f"{year}-10-07"}
    for parcel in value["land"]["parcels"]:
        parcel["operations"]["cutting_dates"] = [f"{year}-06-01"] if parcel["operations"]["cutting_dates"] else []
    if area is not None:
        parcel = copy.deepcopy(value["land"]["parcels"][0])
        parcel["area_ha"] = area
        value["land"]["parcels"] = [parcel]
    if groups is not None:
        value["livestock"]["species_groups"] = groups
    return value


def group(category, count=1, species="other", average=None):
    return {"group_id": "ANIMALS", "species": species, "rgve_category": category,
            "animal_count": count, "average_count": average, "kept_in_austria": True}


class InputContractTests(unittest.TestCase):
    def validate(self, value):
        return Input.model_validate_json(json.dumps(value))

    def test_absent_and_explicit_empty_collections_remain_distinct(self):
        absent = self.validate({}).livestock.species_groups
        empty = self.validate({"livestock": {"species_groups": [], "species_groups_complete": True}}).livestock.species_groups
        self.assertIsNone(absent)
        self.assertEqual([], empty)

    def test_booleans_do_not_coerce_strings_or_numbers(self):
        for bad in ["false", "true", 0, 1]:
            with self.subTest(bad=bad):
                value = case(); value["farm"]["heuwirtschaft"]["silage_storage"] = bad
                with self.assertRaises(ValidationError): self.validate(value)

    def test_counts_do_not_coerce_booleans_or_negative_numbers(self):
        for bad in [True, -1, "4"]:
            with self.subTest(bad=bad):
                value = case(); value["livestock"]["species_groups"][0]["average_count"] = bad
                with self.assertRaises(ValidationError): self.validate(value)

    def test_entity_duplicates_are_rejected(self):
        for collection, key in [("land", "parcels"), ("livestock", "species_groups")]:
            with self.subTest(collection=collection):
                value = case(); value[collection][key].append(copy.deepcopy(value[collection][key][0]))
                with self.assertRaises(ValidationError): self.validate(value)

    def test_cutting_dates_must_be_observed_in_the_evaluated_year(self):
        for bad in ["2025-06-01", "2026-12-31", "bad-date"]:
            with self.subTest(bad=bad):
                value = case(); value["land"]["parcels"][0]["operations"]["cutting_dates"] = [bad]
                with self.assertRaises(ValidationError): self.validate(value)

    def test_unscoped_recognition_is_rejected(self):
        value = case(); value["exceptions"]["recognitions"] = [{"recognised": True}]
        with self.assertRaises(ValidationError): self.validate(value)

    def test_normative_rate_and_unscoped_drought_flags_are_not_farm_facts(self):
        for field in ["premium_eur_per_ha", "drought_exception_area"]:
            value = case(); value["farm"]["heuwirtschaft"][field] = True
            with self.assertRaises(ValidationError): self.validate(value)

    def test_checked_in_schema_matches_the_models(self):
        self.assertEqual(Input.model_json_schema(), json.loads((BUNDLE / "input.schema.json").read_text()))

    def test_historical_artifacts_and_sources_keep_their_bound_hashes(self):
        lineage = json.loads((BUNDLE / "lineage.json").read_text())
        for path, digest in lineage["upstream_sha256"].items():
            with self.subTest(path=path): self.assertEqual(digest, hashlib.sha256((ROOT / path).read_bytes()).hexdigest())
        for source in lineage["sources"]:
            with self.subTest(path=source["path"]): self.assertEqual(source["sha256"], hashlib.sha256((ROOT / source["path"]).read_bytes()).hexdigest())

    def test_table_adaptation_preserves_all_source_values(self):
        original = json.loads((ROOT / "runs/v2-o6_3-luna-high-20261001/workspace/data/o6_3_tables.json").read_text())
        adapted = json.loads((BUNDLE / "data/tables.json").read_text())["heuwirtschaft_tables"]
        stripped = copy.deepcopy(adapted)
        for row in stripped["rgve_rates"]:
            for key in ["category_id", "species", "average_required"]: row.pop(key)
        self.assertEqual(original, stripped)
        self.assertEqual(20, len(adapted["rgve_rates"]))
        self.assertEqual(20, len({row["category_id"] for row in adapted["rgve_rates"]}))

    def test_source_quotes_are_on_the_bound_pdf_pages(self):
        evidence = json.loads((BUNDLE / "citations.json").read_text())
        readers = {}
        for record in evidence:
            path = record["path"]
            if path not in readers: readers[path] = PdfReader(ROOT / path)
            text = " ".join(readers[path].pages[record["page"]-1].extract_text().split())
            with self.subTest(id=record["id"]): self.assertIn(" ".join(record["quote"].split()), text)


class SourceCaseTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        path = os.environ.get("OPA_BIN") or shutil.which("opa")
        if not path: raise unittest.SkipTest("Set OPA_BIN to pinned OPA 1.18.2 for source-case tests")
        cls.opa = Path(path)

    def run_case(self, value):
        return evaluate(json.dumps(value), self.opa, BUNDLE)

    def test_merkblatt_example(self):
        result = self.run_case(case())
        self.assertEqual("eligible", result["status"])
        self.assertEqual(5, result["current_rgve"])
        self.assertEqual(13, result["forage_area_ha"])
        self.assertEqual(11, result["premium_area_ha"])
        self.assertEqual(1603.8, result["indicative_premium_eur"])

    def test_later_year_no_animals_keeps_contract_checks_and_zero_rate(self):
        result = self.run_case(case(groups=[]))
        self.assertEqual("eligible", result["status"])
        self.assertEqual([], result["basis_failures"])
        self.assertEqual(0, result["indicative_rate_eur_per_ha"])

    def test_later_year_below_two_ha_does_not_repeat_entry_minimum(self):
        result = self.run_case(case(area=1))
        self.assertEqual("eligible", result["status"])
        self.assertEqual([], result["basis_failures"])

    def test_first_year_camelids_exact_threshold(self):
        value = case(year=2025, area=2, groups=[group("neuweltkamele:ab_1_jahr", 4)])
        value["farm"]["heuwirtschaft"]["contract_start_year"] = 2025
        result = self.run_case(value)
        self.assertEqual("eligible", result["status"])
        self.assertAlmostEqual(.6, result["current_rgve"])
        self.assertEqual(291.6, result["indicative_premium_eur"])

    def test_small_equids_below_first_year_threshold(self):
        value = case(year=2025, area=2, groups=[group("kleine_equiden:adulte_ab_3_jahre", 1, "horses")])
        value["farm"]["heuwirtschaft"]["contract_start_year"] = 2025
        result = self.run_case(value)
        self.assertEqual(.5, result["current_rgve"])
        self.assertEqual("ineligible", result["status"])
        self.assertIn("FIRST_YEAR_RGVE", result["basis_failures"])

    def test_every_source_category_is_consumed(self):
        tables = json.loads((BUNDLE / "data/tables.json").read_text())["heuwirtschaft_tables"]
        for row in tables["rgve_rates"]:
            with self.subTest(category=row["category_id"]):
                g = group(row["category_id"], 10, row["species"], 10 if row["average_required"] else None)
                result = self.run_case(case(groups=[g]))
                self.assertEqual("eligible", result["status"])
                self.assertAlmostEqual(10 * row["rgve"], result["current_rgve"])

    def test_unknown_or_wrong_species_category_is_missing_data(self):
        for g in [group("unknown"), group("rinder:ab_2_jahre", species="horses", average=5)]:
            result = self.run_case(case(groups=[g]))
            self.assertEqual("missing_data", result["status"])
            self.assertIsNone(result["indicative_premium_eur"])

    def test_average_count_wins_over_reference_count(self):
        result = self.run_case(case(groups=[group("rinder:ab_2_jahre", 999, "cattle", 5)]))
        self.assertEqual(5, result["current_rgve"])

    def test_missing_cattle_average_is_not_replaced_by_reference_count(self):
        result = self.run_case(case(groups=[group("rinder:ab_2_jahre", 999, "cattle")]))
        self.assertEqual("missing_data", result["status"])
        self.assertIn("livestock.species_groups[ANIMALS].average_count", result["missing_data"])

    def test_explicit_zero_average_is_a_known_count(self):
        result = self.run_case(case(groups=[group("rinder:ab_2_jahre", 999, "cattle", 0)]))
        self.assertEqual("eligible", result["status"])
        self.assertEqual(0, result["current_rgve"])
        self.assertEqual(0, result["indicative_rate_eur_per_ha"])

    def test_unconfirmed_export_and_absent_array_are_not_zero_animals(self):
        for collection in [None, []]:
            value = case(); value["livestock"] = {"species_groups_complete": False, "species_groups": collection}
            result = self.run_case(value)
            self.assertEqual("missing_data", result["status"])
            self.assertIsNone(result["current_rgve"])

    def test_foreign_stock_is_not_counted(self):
        value = case(); value["livestock"]["species_groups"][0]["kept_in_austria"] = False
        result = self.run_case(value)
        self.assertEqual(0, result["current_rgve"])

    def test_first_year_area_boundary(self):
        for area, expected in [(1.99, "ineligible"), (2, "eligible")]:
            value = case(year=2025, area=area)
            value["farm"]["heuwirtschaft"]["contract_start_year"] = 2025
            self.assertEqual(expected, self.run_case(value)["status"])

    def test_missing_or_wrong_dated_history_is_explicit(self):
        value = case(); value["farm"]["heuwirtschaft"]["first_year"] = {}
        self.assertEqual("missing_data", self.run_case(value)["status"])
        value = case(); value["farm"]["heuwirtschaft"]["first_year"]["year"] = 2025
        result = self.run_case(value)
        self.assertEqual("missing_data", result["status"])
        self.assertIn("farm.heuwirtschaft.first_year.year_alignment", result["missing_data"])

    def test_contract_boundary_and_current_snapshot(self):
        for year, expected in [(2023, "ineligible"), (2028, "eligible"), (2029, "ineligible"), (2030, "ineligible")]:
            value = case(year=year)
            result = self.run_case(value)
            self.assertEqual(expected, result["status"])
            if expected == "ineligible": self.assertIsNone(result["indicative_premium_eur"])
        for field in ["current_year", "snapshot_year"]:
            value = case(); value["context"][field] = 2025
            self.assertEqual("missing_data", self.run_case(value)["status"])

    def test_unknown_silage_storage_never_claims_no_storage(self):
        for missing in ["absent", None]:
            value = case()
            if missing == "absent": value["farm"]["heuwirtschaft"].pop("silage_storage")
            else: value["farm"]["heuwirtschaft"]["silage_storage"] = None
            result = self.run_case(value)
            self.assertEqual("missing_data", result["status"])
            self.assertIsNone(result["indicative_premium_eur"])
            self.assertIn("farm.heuwirtschaft.silage_storage", result["missing_data"])

    def test_known_false_and_true_silage_have_different_results(self):
        value = case(); value["farm"]["heuwirtschaft"]["silage_storage"] = True
        result = self.run_case(value)
        self.assertEqual("ineligible", result["status"])
        self.assertIn({"id": "STORAGE", "parcel_id": None}, result["violations"])
        self.assertEqual("eligible", self.run_case(case())["status"])

    def test_missing_cutting_dates_and_confirmed_no_cut_are_distinct(self):
        value = case(area=2); value["land"]["parcels"][0]["operations"]["cutting_dates"] = None
        result = self.run_case(value)
        self.assertEqual("missing_data", result["status"])
        self.assertEqual(5, result["current_rgve"])
        self.assertIsNone(result["premium_area_ha"])
        value["land"]["parcels"][0]["operations"]["cutting_dates"] = []
        result = self.run_case(value)
        self.assertEqual("eligible", result["status"])
        self.assertEqual(0, result["indicative_premium_eur"])

    def test_second_crop_does_not_count_as_forage_or_premium(self):
        value = case(); value["land"]["parcels"][2]["crop"]["is_second_crop"] = True
        result = self.run_case(value)
        self.assertEqual(10, result["forage_area_ha"])
        self.assertEqual(8, result["premium_area_ha"])

    def test_option_only_requires_machine_facts_if_requested(self):
        value = case(); value["farm"]["heuwirtschaft"]["no_mower_conditioner_option"] = True
        self.assertEqual("missing_data", self.run_case(value)["status"])
        value["farm"]["heuwirtschaft"].update({"mower_conditioner_used": False, "mower_conditioner_present": False})
        self.assertEqual(1841.4, self.run_case(value)["indicative_premium_eur"])

    def test_green_feeding_before_due_is_not_a_failed_annual_obligation(self):
        value = case(); value["context"]["as_of"] = "2026-09-01"
        value["farm"]["heuwirtschaft"]["green_feeding_majority_april_to_september"] = None
        result = self.run_case(value)
        self.assertEqual("eligible", result["status"])
        self.assertTrue(result["notes"])
        value["context"]["as_of"] = "2026-10-07"
        self.assertEqual("missing_data", self.run_case(value)["status"])

    def test_arable_fodder_management_is_not_automatically_waived(self):
        value = case(); value["context"]["as_of"] = "2026-12-31"
        p = value["land"]["parcels"][2]
        p["operations"] = {"cutting_dates": [], "full_mowing_and_removal": False, "full_grazing": False}
        result = self.run_case(value)
        self.assertEqual("ineligible", result["status"])
        self.assertIn({"id": "MINIMUM_MANAGEMENT", "parcel_id": "A1"}, result["violations"])
        value["context"]["as_of"] = "2026-10-07"
        self.assertEqual("eligible", self.run_case(value)["status"])

    def test_unknown_exception_inventory_does_not_settle_a_potentially_waived_violation(self):
        value = case(); value["farm"]["heuwirtschaft"]["silage_storage"] = True; value["exceptions"] = {}
        self.assertEqual("missing_data", self.run_case(value)["status"])

    def test_recognition_never_blanket_waives_other_obligations(self):
        value = case(); value["farm"]["heuwirtschaft"].update({"silage_storage": True, "feed_fermentation": True})
        value["exceptions"]["recognitions"] = [{"reference": "AMA-SYNTHETIC", "authority": "AMA", "recognised": True,
            "year": 2026, "obligation_id": "STORAGE", "valid_from": "2026-01-01", "valid_to": "2026-12-31"}]
        result = self.run_case(value)
        self.assertEqual("ineligible", result["status"])
        self.assertIn({"id": "FERMENTATION", "parcel_id": None}, result["violations"])
        self.assertNotIn({"id": "STORAGE", "parcel_id": None}, result["violations"])
        self.assertTrue(any("exceptions.review" in field for field in result["missing_data"]))

    def test_recognition_exact_scope_requires_review_without_positive_claim(self):
        value = case(); value["farm"]["heuwirtschaft"]["silage_storage"] = True
        record = {"reference": "AMA-SYNTHETIC", "authority": "AMA", "recognised": True, "year": 2026,
                  "obligation_id": "STORAGE", "valid_from": "2026-01-01", "valid_to": "2026-12-31"}
        value["exceptions"]["recognitions"] = [record]
        self.assertEqual("missing_data", self.run_case(value)["status"])
        for patch in [{"recognised": False}, {"year": 2025, "valid_from": "2025-01-01", "valid_to": "2025-12-31"},
                      {"valid_to": "2026-09-01"}, {"obligation_id": "FERMENTATION"}]:
            value["exceptions"]["recognitions"] = [dict(record, **patch)]
            self.assertEqual("ineligible", self.run_case(value)["status"])
