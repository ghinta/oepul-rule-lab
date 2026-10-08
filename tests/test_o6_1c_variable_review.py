"""Keep the NPA/AFS admission blockers and reproducible review evidence intact."""
import copy
import importlib.util
import os
from pathlib import Path
import unittest

SPEC = importlib.util.spec_from_file_location('npa_afs_review',
    Path(__file__).resolve().parents[1] / 'tools/review_o6_1c_variable_review.py')
review = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(review)


class NpaAfsVariableReviewTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.leaves = review.read(review.DOSSIER / 'leaf-review.json')
        cls.questions = review.read(review.DOSSIER / 'questions.json')
        cls.runs = review.read(review.INVENTORY / 'o6_1c/variable-diff.json')['runs']

    def test_original_sources_and_complete_individual_dossier(self):
        self.assertEqual(review.validate(), {
            'measure': 'o6_1c', 'leaf_paths': 150, 'original_citations': 97,
            'open_expert_questions': 10, 'policy_probes_replayed': 0,
            'promotion_ready': False, 'other_measures_reviewed': 0})

    def test_required_blockers_cannot_disappear_or_silently_close(self):
        for kind in ('all_deleted', 'one_deleted', 'id', 'closed', 'answer', 'evidence'):
            with self.subTest(kind=kind):
                questions = copy.deepcopy(self.questions)
                if kind == 'all_deleted': questions.clear()
                elif kind == 'one_deleted': questions.pop()
                elif kind == 'id': questions[0]['id'] = 'o6_1c-replaced'
                elif kind == 'closed': questions[0]['status'] = 'resolved'
                elif kind == 'answer': questions[0]['answer'] = 'assumed certified'
                else: questions[0]['evidence'] = []
                with self.assertRaises(ValueError):
                    review.validate_records(self.leaves, questions, self.runs)

    def test_leaf_coverage_before_after_and_admission_are_preserved(self):
        for kind in ('deleted', 'replaced', 'value', 'admitted', 'alias'):
            with self.subTest(kind=kind):
                leaves = copy.deepcopy(self.leaves)
                if kind == 'deleted': leaves.pop()
                elif kind == 'replaced': leaves[0]['path'] = 'invented'
                elif kind == 'value': leaves[0]['after'] = 'invented default'
                elif kind == 'admitted': leaves[0]['app_admission'] = 'accepted'
                else: leaves[0]['semantic_equivalence'] = 'confirmed'
                with self.assertRaises(ValueError):
                    review.validate_records(leaves, self.questions, self.runs)

    def test_literal_evidence_must_be_on_the_cited_original_page(self):
        question = next(q for q in self.questions if q['id'] == 'o6_1c-AFS_ENTITY_IDENTITY')
        citation = copy.deepcopy(question['evidence'][0])
        citation['page'] = 1
        with self.assertRaisesRegex(ValueError, 'original quote/page mismatch'):
            review.OriginalSources().check_quote(citation, 'literal_fragment')

    def test_literal_access_and_incomplete_helper_review_cannot_be_promoted(self):
        for model in ('luna', 'opus'):
            with self.subTest(model=model):
                leaves = copy.deepcopy(self.leaves)
                leaf = next(x for x in leaves if x['model'] == model)
                leaf['policy_access_review'] = 'fully_verified'
                with self.assertRaises(ValueError):
                    review.validate_access_sites(leaves, self.runs)

    @unittest.skipUnless(os.environ.get('OPA_BIN'), 'set OPA_BIN to replay historical observations')
    def test_thirteen_documented_policy_observations_are_reproducible(self):
        # These intentionally expose bugs; they are not golden desired-behavior tests.
        review.replay_probes(Path(os.environ['OPA_BIN']))
