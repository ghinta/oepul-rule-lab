"""Check public metadata and Pages files without displaying sensitive values."""

from __future__ import annotations

from html.parser import HTMLParser
from pathlib import Path
import json
import re
import subprocess
from urllib.parse import unquote, urlsplit

from rulelab.publication import HOST_PATH

ROOT = Path(__file__).resolve().parents[1]
SITE = ROOT / "docs"
SECRET = re.compile(
    r"gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,}|"
    r"sk-(?:proj-|ant-)?[A-Za-z0-9_-]{25,}|AKIA[A-Z0-9]{16}|"
    r"-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----"
)


class Page(HTMLParser):
    def __init__(self):
        super().__init__()
        self.language = None
        self.links = []

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag == "html":
            self.language = attrs.get("lang")
        self.links.extend(attrs[key] for key in ("href", "src") if attrs.get(key))


def main() -> int:
    names = subprocess.check_output(
        ["git", "ls-files", "--cached", "--others", "--exclude-standard"],
        cwd=ROOT, text=True,
    ).splitlines()
    failures = []
    checked = 0
    published = set(names)
    for name in ("adaptations/o6_3/lineage.json",
                 "docs/analysis/o6_3-variable-contract-20261007/baseline.json"):
        record = json.loads((ROOT / name).read_text())
        for field in ("files", "upstream_sha256"):
            for dependency in record.get(field, {}):
                if dependency not in published or not (ROOT / dependency).is_file():
                    failures.append(f"{name}: dependency is not published: {dependency}")
    for name in sorted(set(names)):
        path = ROOT / name
        public_metadata = (name.startswith("runs/") and path.name in
                           {"run.json", "technical-validation.json"})
        public_site = name.startswith("docs/") and path.suffix in {".json", ".html", ".js", ".csv"}
        if name.startswith("runs/") and "/raw/" in name:
            failures.append(f"{name}: raw logs must stay local")
        if not (public_metadata or public_site) or not path.is_file():
            continue
        text = path.read_text(encoding="utf-8")
        checked += 1
        # Dynamic JS links include /workspace/ as a repository path segment,
        # not a host directory. Inspect literal host paths separately there.
        host_pattern = (re.compile(r"/(?:Users|home)/[^\s\"']+")
                        if path.suffix == ".js" else HOST_PATH)
        for line, value in enumerate(text.splitlines(), 1):
            if host_pattern.search(value):
                failures.append(f"{name}:{line}: host path in public output")
            if SECRET.search(value):
                failures.append(f"{name}:{line}: possible credential in public output")
        if path.suffix == ".html":
            page = Page()
            page.feed(text)
            if page.language != "en":
                failures.append(f"{name}: public HTML must declare English")
            for link in page.links:
                parts = urlsplit(link)
                if parts.scheme or parts.netloc or not parts.path:
                    continue
                target = (path.parent / unquote(parts.path)).resolve()
                if not target.is_relative_to(SITE) or not target.is_file():
                    failures.append(f"{name}: local link is not served by Pages: {link}")
    if failures:
        print("\n".join(failures))
        return 1
    print(f"Public metadata and Pages checks passed ({checked} files).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
