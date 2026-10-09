"""Guard the frozen, explicitly unapproved 26-measure review snapshot."""
import copy
import importlib.util
import json
from pathlib import Path
import shutil
import tempfile
import unittest
from unittest.mock import patch

SPEC = importlib.util.spec_from_file_location('all_measure_review', Path(__file__).resolve().parents[1] / 'tools/review_all_measure_variables.py')
review = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(review)


class AllMeasureReviewTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.data = review.build()
        cls.bound = review.source_manifest()

    def test_complete_snapshot_and_outputs(self):
        self.assertEqual(review.validate(), {'measures': 26, 'runs': 52, 'question_groups': 129, 'promotion_ready': False})

    def test_deleted_measure_model_or_leaf_is_rejected(self):
        for kind in ('measure', 'model', 'leaf', 'proposal_reference'):
            with self.subTest(kind=kind):
                actual = copy.deepcopy(self.data)
                if kind == 'measure':
                    del actual['o6_24']
                elif kind == 'model':
                    del actual['o6_22']['runs']['opus']
                elif kind == 'leaf':
                    actual['o6_1b']['runs']['luna']['leaf_diff'].pop()
                else:
                    actual['o6_1b']['runs']['luna']['proposal_references'].popitem()
                with self.assertRaisesRegex(ValueError, 'incomplete/changed'):
                    review.validate(data=actual, bound=self.bound)

    def test_implicit_admission_or_equivalence_is_rejected(self):
        for kind in ('promotion', 'admission', 'equivalence', 'accepted_assumption', 'consumption'):
            with self.subTest(kind=kind):
                actual = copy.deepcopy(self.data)
                item = actual['o6_3']
                if kind == 'promotion': item['promotion_ready'] = True
                elif kind == 'admission': item['runs']['luna']['leaf_diff'][0]['admission_status'] = 'accepted'
                elif kind == 'equivalence': item['same_spelling_implies_equivalence'] = True
                elif kind == 'accepted_assumption': item['runs']['opus']['model_assumptions_accepted'] = True
                else: item['runs']['opus']['consumption_review_status'] = 'complete'
                with self.assertRaisesRegex(ValueError, 'incomplete/changed'):
                    review.validate(data=actual, bound=self.bound)

    def test_deleted_or_closed_question_and_invented_answer_are_rejected(self):
        # Test the authoritative input itself, not just a generated copy.
        for kind in ('delete', 'close', 'answer', 'id'):
            with self.subTest(kind=kind), tempfile.TemporaryDirectory() as tmp:
                target = Path(tmp)
                items = review.load(review.DOSSIER / 'questions.json')
                if kind == 'delete': items['o6_1a'].clear()
                elif kind == 'close': items['o6_1a'][0]['status'] = 'resolved'
                elif kind == 'answer': items['o6_1a'][0]['answer'] = 'September 30 is sufficient'
                else: items['o6_1a'][0]['id'] = 'o6_1a-replaced'
                (target / 'questions.json').write_text(review.dump(items))
                with patch.object(review, 'DOSSIER', target), self.assertRaisesRegex(ValueError, 'required question set'):
                    review.questions()

    def test_run_replacement_cannot_be_hidden_by_regeneration(self):
        with tempfile.TemporaryDirectory() as tmp:
            target = Path(tmp)
            shutil.copy(review.DOSSIER / 'app-baseline.json', target)
            selection = review.load(review.DOSSIER / 'run-selection.json')
            selection['o6_11']['luna'] = 'a-new-unreviewed-luna-run'
            (target / 'run-selection.json').write_text(review.dump(selection))
            with patch.object(review, 'DOSSIER', target), self.assertRaisesRegex(ValueError, 'pinned input changed'):
                review.bases()

    def test_falsified_app_schema_cannot_be_hidden_by_regeneration(self):
        with tempfile.TemporaryDirectory() as tmp:
            target = Path(tmp)
            shutil.copy(review.DOSSIER / 'run-selection.json', target)
            app = review.load(review.DOSSIER / 'app-baseline.json')
            app['files']['backend/policy/farm_profile_schema_blueprint.json']['schema']['farm']['year'] = 2027
            (target / 'app-baseline.json').write_text(review.dump(app))
            with patch.object(review, 'DOSSIER', target), self.assertRaisesRegex(ValueError, 'pinned input changed'):
                review.bases()

    def test_missing_or_modified_source_manifest_is_rejected(self):
        actual = copy.deepcopy(self.bound)
        actual['files'].popitem()
        with self.assertRaisesRegex(ValueError, 'inventory/hash'):
            review.validate(bound=actual)

    def test_changed_existing_definition_and_scanner_gap_are_visible(self):
        ubb = self.data['o6_1a']['runs']['opus']
        changed = [l for l in ubb['leaf_diff'] if l['action'] == 'changed']
        self.assertEqual([l['path'] for l in changed], ['land.parcels[].constraints.biodiversity_area.type'])
        self.assertNotEqual(changed[0]['before'], changed[0]['after'])
        self.assertEqual(ubb['stored_rego_input_paths']['paths'], [])
        self.assertEqual(ubb['stored_rego_input_paths']['count'], 0)
        self.assertTrue(ubb['literal_object_get_input_sites'])
        self.assertEqual(ubb['consumption_review_status'], 'incomplete_static_analysis')
        self.assertTrue(self.data['o6_5']['runs']['luna']['conditions_without_input_path_declaration'])


if __name__ == '__main__':
    unittest.main()
