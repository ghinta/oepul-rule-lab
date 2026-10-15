#!/usr/bin/env python3
"""Check document identity and quote location, separately from semantic review.

Requires pypdf. This does not verify the claim a citation is used to support.
"""
import argparse
import hashlib
from html.parser import HTMLParser
import json
from pathlib import Path
import re

import pypdf

HERE = Path(__file__).resolve().parent


class HTMLText(HTMLParser):
    def __init__(self):
        super().__init__()
        self.parts = []

    def handle_data(self, value):
        self.parts.append(value)


def normalize(value):
    return " ".join(value.replace("\u00ad", "").split())


def match(quote, text):
    if normalize(quote) in normalize(text):
        return "normalized_whitespace"
    compact = lambda s: re.sub(r"[^\w]", "", s, flags=re.UNICODE).lower()
    return "compact_punctuation_and_whitespace" if compact(quote) in compact(text) else "not_found"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--candidate-root", type=Path, required=True)
    parser.add_argument("--verify", action="store_true")
    args = parser.parse_args()
    root = args.candidate_root.resolve()
    binding = json.loads((HERE / "binding.json").read_text())
    sources = {}
    for item in binding["files"]:
        if item["kind"] != "original_source":
            continue
        path = root / item["path"]
        assert hashlib.sha256(path.read_bytes()).hexdigest() == item["sha256"]
        if path.suffix == ".pdf":
            pages = [p.extract_text() for p in pypdf.PdfReader(path).pages]
        else:
            html = HTMLText()
            html.feed(path.read_text())
            pages = [" ".join(html.parts)]
        sources[path.name] = pages
    run = root / "runs" / binding["run_id"]
    references = json.loads((run / "workspace/rules/citations.json").read_text())["references"]
    located = []
    for ref in references:
        pages = sources[Path(ref["source_path"]).name]
        page = ref["page"] or 1
        located.append({"reference_id": ref["reference_id"], "page": ref["page"],
                        "match": match(ref["evidence_text"], pages[page - 1])})
    fixture = json.loads((HERE / "development-probes.json").read_text())
    probe_sources = []
    for key, ref in fixture["source_evidence"].items():
        pages = sources[Path(ref["source"]).name]
        probe_sources.append({"source_id": key, "page": ref["page"],
                              "match": match(ref["quote"], pages[(ref["page"] or 1) - 1])})
    result = {"kind": "quote-location-check-not-semantic-approval", "pypdf_version": pypdf.__version__,
              "original_references": located, "development_source_evidence": probe_sources,
              "limitations": "Compact matching tolerates typography/punctuation and PDF extraction. A located heading does not verify table values or the claimed legal consequence."}
    data = (json.dumps(result, ensure_ascii=False, indent=2, sort_keys=True) + "\n").encode()
    path = HERE / "source-check.json"
    if args.verify:
        assert data == path.read_bytes()
    else:
        path.write_bytes(data)
    missing = [x for x in [*located, *probe_sources] if x["match"] == "not_found"]
    print(json.dumps({"historical_citations": len(located), "probe_evidence": len(probe_sources), "unlocated": missing}))
    assert not missing, "Inspect unlocated quotes; never infer semantic correctness from a match."


if __name__ == "__main__":
    main()
