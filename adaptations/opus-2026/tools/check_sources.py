#!/usr/bin/env python3
"""Verify quoted correction evidence against immutable original documents."""
import argparse
import hashlib
from html.parser import HTMLParser
import json
from pathlib import Path
import re
import subprocess
from export import ROOT, dump


class Text(HTMLParser):
    def __init__(self):
        super().__init__()
        self.parts = []
    def handle_data(self, text):
        self.parts.append(text)


def normalize(text):
    return re.sub(r'\s+', ' ', text.replace('\xad', '').replace('\u00a0', ' ')).strip()


def check(candidate, output):
    lineage = json.loads((ROOT / 'lineage.json').read_text())
    source_hashes = {s['path']: s['sha256'] for e in lineage['entries'] for s in e['sources']}
    status = json.loads((ROOT / 'correction-status.json').read_text())
    cache, findings = {}, []
    for measure in status['measures']:
        fixture = json.loads((ROOT / 'tests' / (measure['measure_id'] + '.json')).read_text())
        selected = measure['newly_met_audit_cases'] + measure.get('additional_integration_regressions', [])
        for case in fixture['cases']:
            if case['case_id'] not in selected:
                continue
            evidence = case.get('source_evidence', [])
            if case.get('source_ids'):
                evidence = [fixture['source_evidence'][key] for key in case['source_ids']]
            if not evidence:
                raise ValueError('Correction lacks source evidence: ' + case['case_id'])
            for item in evidence:
                source = item.get('source_path', item.get('source', item.get('path')))
                if source and not source.startswith('sources/'):
                    source = 'sources/oepul/' + source
                pages = item.get('pdf_pages') or [item.get('page', item.get('pdf_page'))]
                quote = item.get('quote', item.get('source_quote', ''))
                result = {'measure_id': measure['measure_id'], 'case_id': case['case_id'],
                          'source_path': source, 'pages': pages, 'quote': quote}
                if source not in source_hashes or not quote:
                    result['status'] = 'incomplete_locator'
                else:
                    path = candidate / source
                    digest = hashlib.sha256(path.read_bytes()).hexdigest()
                    result['sha256'] = digest
                    if digest != source_hashes[source]:
                        raise ValueError('Source digest mismatch: ' + source)
                    if source not in cache:
                        if path.suffix == '.pdf':
                            cache[source] = [subprocess.check_output(['pdftotext', mode, str(path), '-'], text=True).split('\f') for mode in ('-layout', '-raw')]
                        else:
                            parser = Text(); parser.feed(path.read_text()); cache[source] = [[' '.join(parser.parts)]]
                    texts = [' '.join(extraction[page-1] for page in pages if type(page) is int) if any(type(p) is int for p in pages) else ' '.join(extraction) for extraction in cache[source]]
                    result['status'] = 'found' if any(normalize(quote) in normalize(text) for text in texts) else 'not_found'
                findings.append(result)
    dump(output, {'kind': 'correction-source-quote-check', 'method': 'pdftotext -layout or -raw / HTML text; whitespace and soft-hyphen normalization only', 'checks': findings})
    bad = [f for f in findings if f['status'] != 'found']
    print(f'{len(findings)-len(bad)}/{len(findings)} source quotes found')
    for f in bad:
        print(f["measure_id"], f["case_id"], f["status"], f["source_path"], f["pages"], f["quote"][:100])
    if bad:
        raise SystemExit(1)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--candidate', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    check(args.candidate, args.output)
