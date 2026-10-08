"""Keep the BIO admission blockers and reproducible review evidence intact."""
import copy
import importlib.util
import os
from pathlib import Path
import unittest

SPEC = importlib.util.spec_from_file_location('bio_review',
    Path(__file__).resolve().parents[1] / 'tools/review_o6_1b_variable_review.py')
review = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(review)


class BioVariableReviewTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.leaves = review.read(review.DOSSIER / 'leaf-review.json')
        cls.questions = review.read(review.DOSSIER / 'questions.json')
        cls.runs = review.read(review.INVENTORY / 'o6_1b/variable-diff.json')['runs']

    def test_original_sources_and_complete_individual_dossier(self):
        self.assertEqual(review.validate(), {
            'measure': 'o6_1b', 'leaf_paths': 287, 'original_citations': 235,
            'open_expert_questions': 11, 'policy_probes_replayed': 0,
            'promotion_ready': False, 'other_measures_reviewed': 0})

    def test_required_blockers_cannot_disappear_or_silently_close(self):
        for kind in ('all_deleted', 'one_deleted', 'id', 'closed', 'answer', 'evidence'):
            with self.subTest(kind=kind):
                questions = copy.deepcopy(self.questions)
                if kind == 'all_deleted': questions.clear()
                elif kind == 'one_deleted': questions.pop()
                elif kind == 'id': questions[0]['id'] = 'o6_1b-replaced'
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
        question = next(q for q in self.questions if q['id'] == 'o6_1b-PHEROMONE_RETENTION')
        citation = copy.deepcopy(question['evidence'][0])
        citation['page'] = 1
        with self.assertRaisesRegex(ValueError, 'original quote/page mismatch'):
            review.OriginalSources().check_quote(citation, 'literal_fragment')

    @unittest.skipUnless(os.environ.get('OPA_BIN'), 'set OPA_BIN to replay historical observations')
    def test_eight_documented_policy_observations_are_reproducible(self):
        # These intentionally expose bugs; they are not golden desired-behavior tests.
        review.replay_probes(Path(os.environ['OPA_BIN']))
