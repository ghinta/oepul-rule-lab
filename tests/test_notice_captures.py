"""Changed official HTML must retain historical bytes and require explicit capture."""
from __future__ import annotations

import json
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'sources' / 'oepul'))
import manage_sources as sources


class NoticeCaptureTests(unittest.TestCase):
    def test_changed_notice_requires_opt_in_and_keeps_each_hashed_capture(self):
        source_id = 'duerre_2026_foerderungsabwicklung'
        url = sources.notice_url(sources.NOTICE_SOURCES[source_id])
        old = b'<html><span class="c-news-page__date-to">12.08.2026</span><main>Original</main></html>'
        new = old.replace(b'</html>', b'<footer>Updated navigation</footer></html>')
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            with patch.multiple(sources, REPO_ROOT=root, NOTICES_DIR=root / 'notices'):
                def capture(body, **kwargs):
                    response = sources.ResponseData(body, url, 200, 'text/html', None, None)
                    return sources.build_notice(source_id, response, '2026-10-10T00:00:00Z', **kwargs)

                first = capture(old)
                before = json.dumps(first, sort_keys=True)
                with self.assertRaisesRegex(sources.SourceError, 'refusing to overwrite'):
                    capture(new)
                second = capture(new, capture_changed=True)
                self.assertNotEqual(first['local_path'], second['local_path'])
                self.assertIn(sources.sha256_bytes(new), second['local_path'])
                self.assertEqual((root / first['local_path']).read_bytes(), old)
                self.assertEqual((root / second['local_path']).read_bytes(), new)
                self.assertEqual(json.dumps(first, sort_keys=True), before)
                self.assertEqual(capture(new, capture_changed=True), second)
                self.assertEqual(second['published_on'], first['published_on'])
                invalid = new.replace(b'12.08.2026', b'13.08.2026')
                with self.assertRaisesRegex(sources.SourceError, 'publication-date mismatch'):
                    capture(invalid, capture_changed=True)
                self.assertEqual(len(list((root / 'notices').rglob('*.html'))), 2)


if __name__ == '__main__':
    unittest.main()
