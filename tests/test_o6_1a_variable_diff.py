"""Protect the complete proposal inventory and its unapproved status."""

import copy
import unittest

from tools import review_o6_1a_variable_diff as review


class UbbVariableDiffTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.data = review.load(review.DOSSIER / "variable-diff.json")

    def test_observed_model_diffs_and_enum_change_are_preserved(self):
        counts = review.validate()
        self.assertEqual({"proposals": 81, "added": 91, "changed": 0, "removed": 0}, counts["luna"])
        self.assertEqual({"proposals": 67, "added": 190, "changed": 1, "removed": 0}, counts["opus"])
        change = self.data["runs"]["opus"]["profile_diff"]["changed"]
        self.assertEqual({"land.parcels[].constraints.biodiversity_area.type": {
            "before": "enum(annual|multi_year|null)",
            "after": "enum(DIV|DIVRS|DIVSZ|DIVNFZ|DIVAGF|null)",
        }}, change)

    def test_empty_diff_or_missing_model_cannot_pass(self):
        for mutate in [
            lambda d: d["runs"]["luna"]["leaf_diff"].clear(),
            lambda d: d["runs"].pop("opus"),
        ]:
            data = copy.deepcopy(self.data)
            mutate(data)
            with self.assertRaisesRegex(ValueError, "incomplete or changed"):
                review.validate(data)

    def test_single_silent_path_removal_is_rejected(self):
        data = copy.deepcopy(self.data)
        data["runs"]["opus"]["leaf_diff"].pop()
        with self.assertRaisesRegex(ValueError, "incomplete or changed"):
            review.validate(data)

    def test_proposals_cannot_be_silently_promoted(self):
        for mutate in [
            lambda d: d.update(promotion_ready=True),
            lambda d: d["runs"]["luna"]["leaf_diff"][0].update(admission_status="accepted"),
            lambda d: d["runs"]["opus"].update(model_assumptions_accepted=True),
        ]:
            data = copy.deepcopy(self.data)
            mutate(data)
            with self.assertRaisesRegex(ValueError, "incomplete or changed"):
                review.validate(data)

    def test_changed_source_binding_is_rejected(self):
        bound = review.load(review.DOSSIER / "source-manifest.json")
        bound["files"].pop(next(iter(bound["files"])))
        with self.assertRaisesRegex(ValueError, "source inventory/hash mismatch"):
            review.validate(bound=bound)

    def test_unanswered_questions_cannot_disappear_or_be_closed(self):
        for mutate in [
            lambda d: d["questions"].clear(),
            lambda d: d["questions"][0].update(status="resolved"),
        ]:
            data = copy.deepcopy(self.data)
            mutate(data)
            with self.assertRaisesRegex(ValueError, "incomplete or changed"):
                review.validate(data)


if __name__ == "__main__":
    unittest.main()
