"""Protect open expert decisions and historical evidence for each completed slice."""
import copy
import os
from pathlib import Path
import unittest

from tools import review_individual_measure as review
from rulelab.grounding import normalize_evidence


class IndividualMeasureReviewTests(unittest.TestCase):
    def records(self, measure):
        dossier = review.dossier_path(measure)
        return (review.read(dossier / 'leaf-review.json'),
                review.read(dossier / 'questions.json'),
                review.read(review.INVENTORY / measure / 'variable-diff.json')['runs'],
                review.read(dossier / 'review.json'))

    def test_original_sources_and_complete_dossiers(self):
        self.assertTrue(review.CONFIG_HASHES, 'no individual slices registered')
        for measure in review.CONFIG_HASHES:
            with self.subTest(measure=measure):
                result = review.validate(measure)
                self.assertFalse(result['promotion_ready'])
                self.assertGreater(result['open_questions'], 0)

    def test_required_blockers_cannot_disappear_close_or_gain_answers(self):
        for measure in review.CONFIG_HASHES:
            leaves, questions, runs, config = self.records(measure)
            for kind in ('all_deleted', 'one_deleted', 'id', 'closed', 'answer', 'evidence'):
                with self.subTest(measure=measure, mutation=kind):
                    changed = copy.deepcopy(questions)
                    if kind == 'all_deleted': changed.clear()
                    elif kind == 'one_deleted': changed.pop()
                    elif kind == 'id': changed[0]['id'] = 'invented-question'
                    elif kind == 'closed': changed[0]['status'] = 'resolved'
                    elif kind == 'answer': changed[0]['answer'] = 'assumed'
                    else: changed[0]['evidence'] = []
                    with self.assertRaises(ValueError):
                        review.validate_records(leaves, changed, runs, config)

    def test_leaf_before_after_and_unapproved_aliases_are_preserved(self):
        for measure in review.CONFIG_HASHES:
            leaves, questions, runs, config = self.records(measure)
            for kind in ('deleted', 'replaced', 'value', 'admitted', 'alias'):
                with self.subTest(measure=measure, mutation=kind):
                    changed = copy.deepcopy(leaves)
                    if kind == 'deleted': changed.pop()
                    elif kind == 'replaced': changed[0]['path'] = 'invented'
                    elif kind == 'value': changed[0]['after'] = 'invented default'
                    elif kind == 'admitted': changed[0]['app_admission'] = 'accepted'
                    else: changed[0]['semantic_equivalence'] = 'confirmed'
                    with self.assertRaises(ValueError):
                        review.validate_records(changed, questions, runs, config)

    def test_evidence_must_be_on_its_exact_original_page(self):
        for measure in review.CONFIG_HASHES:
            with self.subTest(measure=measure):
                audit = review.read(review.dossier_path(measure) / 'citation-audit.json')
                sources = review.OriginalSources()
                original = next(c for c in audit if c['page'] and c['page'] > 1
                                and normalize_evidence(c['evidence_text']) not in normalize_evidence(
                                    sources.text(c['source_path'], 1)))
                citation = copy.deepcopy(original)
                citation['page'] = 1
                with self.assertRaisesRegex(ValueError, 'original quote/page mismatch'):
                    sources.check_quote(citation, 'evidence_text')

    def test_unreviewed_measure_is_not_silently_reported_complete(self):
        with self.assertRaisesRegex(ValueError, 'no completed individual review'):
            review.validate('invented-measure')

    @unittest.skipUnless(os.environ.get('OPA_BIN'), 'set OPA_BIN for historical observation replay')
    def test_documented_observations_are_reproducible(self):
        for measure in review.CONFIG_HASHES:
            with self.subTest(measure=measure):
                review.replay_probes(measure, Path(os.environ['OPA_BIN']))
