from __future__ import annotations

import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from rulelab import cli
from rulelab.publication import public_metadata
from rulelab.screening_report import render_report
from rulelab import screening


class PortableMetadataTests(unittest.TestCase):
    def test_relocated_checkouts_produce_identical_records(self):
        records = []
        for root in (Path('/Users/example/projects/oepul-rule-lab'),
                     Path('/workspace/oepul-rule-lab'), Path('/srv/project'),
                     Path('/Users/example/My Projects/oepul-rule-lab')):
            command = cli.codex_command(
                {"executable": "codex", "model": "test-model", "args": []},
                root / 'runs/example',
            )
            before = list(command)
            records.append(public_metadata({"invocation": command}, root))
            self.assertEqual(command, before, 'Execution arguments must stay absolute')
        self.assertEqual(records[0], records[1])
        self.assertEqual(records[1], records[2])
        self.assertEqual(records[2], records[3])
        self.assertIn('runs/example/workspace', records[0]['invocation'])
        self.assertIn('runs/example/raw/final-message.md', records[0]['invocation'])

    def test_public_writer_cleans_nested_host_paths_without_changing_input(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            original = {"invocation": [str(root / 'runs/demo/workspace')],
                        "opa_runtime": {"path": '/home/example/private/bin/opa'}}
            with patch.object(cli, 'REPO_ROOT', root):
                cli.write_json(root / 'run.json', original)
            saved = json.loads((root / 'run.json').read_text())
            self.assertEqual(saved['invocation'], ['runs/demo/workspace'])
            self.assertEqual(saved['opa_runtime']['path'], 'external/opa')
            self.assertEqual(original['invocation'], [str(root / 'runs/demo/workspace')])

    def test_legacy_paths_are_relative_and_other_records_keep_their_meaning(self):
        root = Path('/workspace/oepul-rule-lab')
        value = {'path': '/Users/example/old/oepul-rule-lab/runs/demo/workspace',
                 'url': 'https://example.org/home/example/file',
                 'pointer': '/optional/rate',
                 'relative': 'runs/demo/workspace/policy/main.rego',
                 'values': [None, False, 0, [], 'unchanged']}
        result = public_metadata(value, root)
        self.assertEqual(result['path'], 'runs/demo/workspace')
        for field in ('url', 'pointer', 'relative', 'values'):
            self.assertEqual(result[field], value[field])

    def test_similar_checkout_prefix_is_not_treated_as_this_repository(self):
        self.assertEqual(public_metadata('/workspace/lab-other/bin/opa', Path('/workspace/lab')),
                         'external/opa')

    def test_external_input_provenance_never_exposes_its_parent_directories(self):
        self.assertEqual(cli.display_path(Path('/srv/private/profile.json'),
                                         Path('/workspace/lab')), 'external/profile.json')

    def test_pages_links_reach_repository_artifacts_and_original_results_are_preserved(self):
        root = Path(__file__).resolve().parents[1]
        report = root / 'docs/analysis/luna-screening-20261011'
        manifest = screening.load_json(report / 'manifest.json')
        results = screening.load_json(report / 'results.json')
        before = screening.json_bytes(results)
        html = render_report(manifest, results)['index.html']
        self.assertIn('<html lang="en">', html)
        self.assertIn('Original evidence (German)', html)
        self.assertIn('href="https://github.com/ghinta/oepul-rule-lab/blob/main/runs/', html)
        self.assertNotIn('href="../../../runs/', html)
        self.assertEqual(screening.json_bytes(results), before)


if __name__ == '__main__':
    unittest.main()
