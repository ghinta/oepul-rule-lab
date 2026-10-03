from __future__ import annotations

import importlib.util
import sys
import tempfile
import unittest
from pathlib import Path

MODULE_PATH = Path(__file__).resolve().parents[1] / "sources" / "oepul" / "manage_sources.py"
spec = importlib.util.spec_from_file_location("manage_sources", MODULE_PATH)
manage_sources = importlib.util.module_from_spec(spec)
sys.modules["manage_sources"] = manage_sources
spec.loader.exec_module(manage_sources)


def page(content: str, news: str) -> bytes:
    return (
        "<html><body><div class=\"c-news-page__content\">"
        f"<p>{content}</p></div>"
        "<aside><div class=\"c-news-page__quicklink-more\"><ul>"
        f"<li><div class=\"date\">{news}</div></li>"
        "</ul></div></aside></body></html>"
    ).encode()


class NoticePreservationTests(unittest.TestCase):
    def test_sidebar_only_change_keeps_stored_bytes(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "notice.html"
            stored = page("Dürre 2026: Erleichterungen", "22.07.2026")
            path.write_bytes(stored)
            live = page("Dürre 2026: Erleichterungen", "23.09.2026")
            self.assertEqual(manage_sources.preserve_notice(path, live), stored)
            self.assertEqual(path.read_bytes(), stored)

    def test_content_change_still_aborts(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "notice.html"
            path.write_bytes(page("Frist 31. August", "22.07.2026"))
            with self.assertRaises(manage_sources.SourceError):
                manage_sources.preserve_notice(path, page("Frist 15. September", "22.07.2026"))

    def test_new_notice_is_written(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "notice.html"
            body = page("Neu", "01.10.2026")
            self.assertEqual(manage_sources.preserve_notice(path, body), body)
            self.assertEqual(path.read_bytes(), body)

    def test_notice_content_removes_nested_sidebar(self) -> None:
        content = manage_sources.notice_content(page("Inhalt", "22.07.2026"))
        self.assertNotIn(b"quicklink-more", content)
        self.assertIn(b"Inhalt", content)
        self.assertTrue(content.endswith(b"<aside></aside></body></html>"))


if __name__ == "__main__":
    unittest.main()
