"""Original source editions, immutable capture and premature-admission safeguards."""
from __future__ import annotations

import copy
import hashlib
import json
import sys
import tempfile
import unittest
import zipfile
from pathlib import Path
from unittest.mock import patch

from pypdf import PdfWriter
from pypdf.generic import DecodedStreamObject, DictionaryObject, NameObject

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'sources' / 'oepul'))
import manage_sources as sources
import source_intake as intake


def pdf(path: Path, text: str, page_count: int = 1) -> bytes:
    writer = PdfWriter()
    page = writer.add_blank_page(width=200, height=200)
    font = DictionaryObject({NameObject('/Type'): NameObject('/Font'), NameObject('/Subtype'): NameObject('/Type1'), NameObject('/BaseFont'): NameObject('/Helvetica')})
    page[NameObject('/Resources')] = DictionaryObject({NameObject('/Font'): DictionaryObject({NameObject('/F1'): writer._add_object(font)})})
    stream = DecodedStreamObject()
    stream.set_data(f'BT /F1 12 Tf 10 100 Td ({text}) Tj ET'.encode('latin1'))
    page[NameObject('/Contents')] = writer._add_object(stream)
    for _ in range(page_count - 1):
        writer.add_blank_page(width=200, height=200)
    with path.open('wb') as output:
        writer.write(output)
    return path.read_bytes()


def evidence(root: Path, relative: str, body: bytes) -> dict:
    path = root / relative
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(body)
    return {'local_path': relative, 'sha256': hashlib.sha256(body).hexdigest()}


class EditionTests(unittest.TestCase):
    def test_historical_manifest_remains_valid_without_repinning(self):
        before = sources.MANIFEST_PATH.read_bytes()
        manifest = json.loads(before)
        sources.validate_manifest(manifest, check_files=True)
        self.assertEqual(sources.MANIFEST_PATH.read_bytes(), before)
        self.assertEqual(manifest['legal_basis_documents'][0]['source_date'], '2024-10-11')

    def test_current_index_selects_new_editions_and_rejects_old_only_index(self):
        links = ''.join(f'<a href="https://www.ama.at/media/new/{spec["filename"]}">{sid}</a>' for sid, spec in sources.LEGAL_SOURCES.items())
        self.assertEqual(set(sources.legal_links(links.encode())), set(sources.LEGAL_SOURCES))
        old = ''.join(f'<a href="https://www.ama.at/media/old/{spec["filename"]}">{sid}</a>' for sid, spec in sources.HISTORICAL_LEGAL_SOURCES.items())
        with self.assertRaises(sources.SourceError):
            sources.legal_links(old.encode())

    def test_import_archives_new_edition_retains_old_and_does_not_promote_manifest(self):
        sid = 'oepul_sonderrichtlinie_2023'
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            incoming = root / sources.LEGAL_SOURCES[sid]['filename']
            body = pdf(incoming, '2026-0.267.890', page_count=94)
            original = evidence(root, 'sources/oepul/legal/20241011_srl_oepul_2023.pdf', b'old untouched original')
            pointer = evidence(root, 'sources/oepul/manifest.json', b'{"historical":true}')
            with patch.multiple(sources, REPO_ROOT=root, LEGAL_DIR=root / 'sources/oepul/legal', PROVENANCE_DIR=root / 'sources/oepul/provenance'):
                record_path = sources.import_original(sid, incoming, 'https://www.ama.at/media/new/' + incoming.name, '2026-10-10T00:00:00Z', 'supplied public original for import test')
                record = json.loads(record_path.read_text())
                self.assertIsNone(record['http_provenance'])
                self.assertFalse(record['index_verified'])
                self.assertEqual(record['sha256'], hashlib.sha256(body).hexdigest())
                self.assertEqual((root / record['local_path']).read_bytes(), body)
                self.assertEqual(hashlib.sha256((root / original['local_path']).read_bytes()).hexdigest(), original['sha256'])
                self.assertEqual(hashlib.sha256((root / pointer['local_path']).read_bytes()).hexdigest(), pointer['sha256'])
                pdf(incoming, '2026-0.267.890 altered content', page_count=94)
                with self.assertRaisesRegex(sources.SourceError, 'refusing to overwrite'):
                    sources.import_original(sid, incoming, 'https://www.ama.at/media/new/' + incoming.name, '2026-10-10T00:00:00Z', 'altered source')

    def test_import_rejects_wrong_edition_cover_before_archiving(self):
        sid = 'oepul_sonderrichtlinie_2023'
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            incoming = root / sources.LEGAL_SOURCES[sid]['filename']
            pdf(incoming, '2024-0.489.174')
            with patch.multiple(sources, REPO_ROOT=root, LEGAL_DIR=root / 'sources/oepul/legal', PROVENANCE_DIR=root / 'sources/oepul/provenance'):
                with self.assertRaisesRegex(sources.SourceError, 'registered amendment'):
                    sources.import_original(sid, incoming, 'https://www.ama.at/media/new/' + incoming.name, '2026-10-10T00:00:00Z', 'wrong file')
                self.assertFalse((root / 'sources/oepul/legal').exists())

    def test_cover_only_pdf_is_not_the_complete_known_current_edition(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'srl_oepul_2023_20261001.pdf'
            pdf(path, '2026-0.267.890')
            with self.assertRaisesRegex(sources.SourceError, 'complete 94-page'):
                sources.legal_pdf_metadata(path, sources.LEGAL_SOURCES['oepul_sonderrichtlinie_2023'])

    def test_external_xlsx_and_gis_originals_are_content_addressed_and_truthful(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            workbook = root / 'current_rates.xlsx'
            with zipfile.ZipFile(workbook, 'w') as archive:
                archive.writestr('[Content_Types].xml', '<Types/>')
                archive.writestr('xl/workbook.xml', '<workbook/>')
                archive.writestr('xl/worksheets/sheet1.xml', '<worksheet/>')
            geojson = root / 'official_layer.geojson'
            geojson.write_text('{"type":"FeatureCollection","features":[]}')
            with patch.multiple(sources, REPO_ROOT=root, SUPPLEMENTAL_DIR=root / 'sources/oepul/supplemental', PROVENANCE_DIR=root / 'sources/oepul/provenance'):
                for sid, path, url in [('premium_rates', workbook, 'https://www.bmluk.gv.at/dam/current_rates.xlsx'), ('gis_layer_versions', geojson, 'https://www.data.gv.at/example/export?format=geojson')]:
                    record_path = sources.import_original(sid, path, url, '2026-10-10T00:00:00Z', 'supplied public original, review pending')
                    record = json.loads(record_path.read_text())
                    self.assertIn(record['sha256'], record['local_path'])
                    self.assertEqual((root / record['local_path']).read_bytes(), path.read_bytes())
                    self.assertIsNone(record['http_provenance'])
                    self.assertFalse(record['index_verified'])

    def test_register_versions_remain_separate_and_wrong_formats_fail(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            register = root / 'register.csv'
            register.write_text('code,status\nA,valid\n')
            with patch.multiple(sources, REPO_ROOT=root, SUPPLEMENTAL_DIR=root / 'sources/oepul/supplemental', PROVENANCE_DIR=root / 'sources/oepul/provenance'):
                first = json.loads(sources.import_original('plant_protection_register', register, 'https://www.baes.gv.at/export.csv', '2026-10-10T00:00:00Z', 'public register version one').read_text())
                register.write_text('code,status\nA,expired\n')
                second = json.loads(sources.import_original('plant_protection_register', register, 'https://www.baes.gv.at/export.csv', '2026-10-10T00:00:00Z', 'public register version two').read_text())
                self.assertNotEqual(first['local_path'], second['local_path'])
                self.assertEqual((root / first['local_path']).read_text(), 'code,status\nA,valid\n')
                with self.assertRaisesRegex(sources.SourceError, 'publisher'):
                    sources.import_original('plant_protection_register', register, 'https://unreviewed.example/export.csv', '2026-10-10T00:00:00Z', 'unreviewed attribution')
            bad = root / 'broken.xlsx'
            bad.write_bytes(b'not a workbook')
            with self.assertRaises(sources.SourceError):
                sources.original_format_metadata(bad, 'premium_rates')
            layer = root / 'plain.json'
            layer.write_text('{"invented":"not GIS"}')
            with self.assertRaisesRegex(sources.SourceError, 'FeatureCollection'):
                sources.original_format_metadata(layer, 'gis_layer_versions')


class IntakeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.original = json.loads(intake.INVENTORY_PATH.read_text())

    def fixture(self, root: Path) -> dict:
        data = copy.deepcopy(self.original)
        data['baseline_manifest'] = evidence(root, 'baseline.json', b'{}')
        for scope in data['scopes']:
            scope['capture'] = None
            scope['index_observation'] = None
        return data

    def current_scope(self, data: dict, root: Path, source_id: str = 'o6_3') -> dict:
        filename = 'o6_3_heuwirtschaft_2025_10.pdf'
        path = root / filename
        body = pdf(path, 'STAND Oktober 2025')
        original = evidence(root, filename, body)
        url = 'https://www.ama.at/media/test/' + filename
        record = {**original, 'document_id': source_id, 'file_size_bytes': len(body), 'official_url': url, 'retrieved_at': '2026-10-10T00:00:00Z'}
        provenance = evidence(root, 'provenance.json', json.dumps({'documents': [record]}).encode())
        snapshot = evidence(root, 'index.html', f'<a href="{url}">current</a>'.encode())
        scope = next(item for item in data['scopes'] if item['source_id'] == source_id)
        scope['capture'] = {**original, 'file_size_bytes': len(body), 'official_url': url, 'retrieved_at': '2026-10-10T00:00:00Z', 'provenance': provenance, 'kind': 'original_file'}
        scope['index_observation'] = {'checked_on': '2026-10-10', 'index_url': sources.SHEETS_INDEX_URL, 'target_url': url, 'method': 'http_index_snapshot', 'snapshot': snapshot}
        return scope

    def test_real_archived_bytes_and_link_observations_do_not_prove_current_completion(self):
        result = intake.validate_inventory(self.original)
        self.assertEqual(result['ready'], [])
        self.assertEqual(len(result['pending']), 43)
        with self.assertRaisesRegex(sources.SourceError, 'incomplete'):
            intake.validate_inventory(self.original, require_ready=True)

    def test_deleting_or_altering_required_scopes_never_passes(self):
        for action in ('delete', 'rename', 'duplicate', 'kind'):
            data = copy.deepcopy(self.original)
            if action == 'delete':
                data['scopes'].pop()
            elif action == 'rename':
                data['scopes'][0]['source_id'] = 'different_scope'
            elif action == 'duplicate':
                data['scopes'].append(copy.deepcopy(data['scopes'][0]))
            else:
                data['scopes'][0]['kind'] = 'original_pdf'
            with self.subTest(action=action), self.assertRaises(sources.SourceError):
                intake.validate_inventory(data)

    def test_claiming_complete_while_pending_fails(self):
        data = copy.deepcopy(self.original)
        data['completion_claimed'] = True
        with self.assertRaisesRegex(sources.SourceError, 'incomplete'):
            intake.validate_inventory(data)

    def test_metadata_hash_cannot_replace_original_hash(self):
        data = copy.deepcopy(self.original)
        data['scopes'][0]['capture']['sha256'] = data['baseline_manifest']['sha256']
        with self.assertRaisesRegex(sources.SourceError, 'SHA-256 mismatch'):
            intake.validate_inventory(data)

    def test_current_needed_scope_can_be_ready_while_other_scopes_stay_pending(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            data = self.fixture(root)
            self.current_scope(data, root)
            result = intake.validate_inventory(data, root, require_ready=True, needed_scopes={'o6_3'})
            self.assertEqual(result['ready'], ['o6_3'])
            self.assertEqual(len(result['pending']), 42)

    def test_direct_official_factor_import_is_accepted_as_capture_but_not_as_full_review(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            data = self.fixture(root)
            path = root / 'official_factors.csv'
            path.write_text('category,factor\nA,1\n')
            with patch.multiple(sources, REPO_ROOT=root, SUPPLEMENTAL_DIR=root / 'sources/oepul/supplemental', PROVENANCE_DIR=root / 'sources/oepul/provenance'):
                imported = sources.import_original('nitrogen_factors', path, 'https://www.ama.at/media/official_factors.csv', '2026-10-10T00:00:00Z', 'supplied official factor original; review pending')
            record = json.loads(imported.read_text())
            scope = next(item for item in data['scopes'] if item['source_id'] == 'nitrogen_factors')
            scope['capture'] = {key: record[key] for key in ['local_path', 'sha256', 'file_size_bytes', 'official_url', 'retrieved_at']}
            scope['capture']['provenance'] = {'local_path': str(imported.relative_to(root)), 'sha256': hashlib.sha256(imported.read_bytes()).hexdigest()}
            result = intake.validate_inventory(data, root)
            self.assertIn('nitrogen_factors', result['pending'])
            with self.assertRaisesRegex(sources.SourceError, 'incomplete'):
                intake.validate_inventory(data, root, require_ready=True, needed_scopes={'nitrogen_factors'})

    def test_wrong_measure_original_cannot_be_relabelled_as_ready(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            data = self.fixture(root)
            valid = self.current_scope(data, root)
            wrong = next(item for item in data['scopes'] if item['source_id'] == 'o6_1a')
            wrong['capture'] = valid['capture']
            wrong['index_observation'] = valid['index_observation']
            with self.assertRaisesRegex(sources.SourceError, 'not supported'):
                intake.validate_inventory(data, root)

    def test_old_index_or_future_capture_cannot_prove_current_scope(self):
        for field in ('old_index', 'future_index', 'future_capture'):
            with tempfile.TemporaryDirectory() as directory:
                root = Path(directory)
                data = self.fixture(root)
                scope = self.current_scope(data, root)
                if field == 'old_index':
                    scope['index_observation']['checked_on'] = '2026-10-09'
                elif field == 'future_index':
                    scope['index_observation']['checked_on'] = '2026-10-11'
                else:
                    scope['capture']['retrieved_at'] = '2026-10-11T00:00:00Z'
                with self.subTest(field=field), self.assertRaises(sources.SourceError):
                    intake.validate_inventory(data, root)

    def test_missing_raw_index_snapshot_cannot_be_claimed(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            data = self.fixture(root)
            scope = self.current_scope(data, root)
            scope['index_observation']['snapshot'] = None
            with self.assertRaisesRegex(sources.SourceError, 'snapshot missing'):
                intake.validate_inventory(data, root)

    def test_unpinned_or_path_escape_evidence_fails(self):
        data = copy.deepcopy(self.original)
        data['baseline_manifest']['local_path'] = '../outside.json'
        with self.assertRaises(sources.SourceError):
            intake.validate_inventory(data)

    def test_required_clause_dates_and_original_pending_status_cannot_disappear(self):
        for action in ('remove', 'date', 'pending'):
            data = copy.deepcopy(self.original)
            if action == 'remove':
                data['clause_applicability'].pop()
            elif action == 'date':
                data['clause_applicability'][0]['effective_from'] = '2026-01-01'
            else:
                data['clause_applicability'][0]['original_capture_pending'] = False
            with self.subTest(action=action), self.assertRaises(sources.SourceError):
                intake.validate_inventory(data)

    def test_independent_expected_inventory_prevents_self_declared_shrunken_table(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            data = self.fixture(root)
            original = self.current_scope(data, root)['capture']
            scope = intake.Scope.model_validate(next(item for item in data['scopes'] if item['source_id'] == 'training_providers'))
            scope.capture = intake.Capture.model_validate(original)
            expected = {'scope_id': scope.source_id, 'original_source_hashes': [original['sha256']], 'source_locator': 'whole original table, every row and note', 'established_by': 'independent original inventory reviewer', 'expected_item_ids': ['provider_a', 'provider_b'], 'expected_footnote_ids': ['note_1']}
            expected_file = evidence(root, 'expected.json', json.dumps(expected).encode())
            artifact = {'scope_id': scope.source_id, 'original_source_hashes': [original['sha256']], 'expected_item_ids': ['provider_a'], 'items': [{'id': 'provider_a', 'source_locator': 'page 1 row 1', 'value': 'A'}], 'footnotes': [{'id': 'note_1', 'source_locator': 'page 2', 'text': 'Note'}]}
            artifact_file = evidence(root, 'review.json', json.dumps(artifact).encode())
            scope.review = intake.Review.model_validate({**artifact_file, 'reviewed_by': 'extractor reviewer', 'original_source_hashes': [original['sha256']], 'expected_inventory': expected_file})
            with self.assertRaisesRegex(sources.SourceError, 'complete sourced items'):
                intake.verify_review(scope, root)
            artifact['items'].append({'id': 'provider_b', 'source_locator': 'page 1 row 2', 'value': 'B'})
            scope.review = intake.Review.model_validate({**evidence(root, 'review.json', json.dumps(artifact).encode()), 'reviewed_by': 'extractor reviewer', 'original_source_hashes': [original['sha256']], 'expected_inventory': expected_file})
            intake.verify_review(scope, root)
            artifact['footnotes'] = []
            scope.review = intake.Review.model_validate({**evidence(root, 'review.json', json.dumps(artifact).encode()), 'reviewed_by': 'extractor reviewer', 'original_source_hashes': [original['sha256']], 'expected_inventory': expected_file})
            with self.assertRaisesRegex(sources.SourceError, 'footnote coverage'):
                intake.verify_review(scope, root)


if __name__ == '__main__':
    unittest.main()
