"""Read-only integrity and original-source checks for the individual BIO dossier.

Historical OPA outputs are observations, never desired rule behavior.
No promotion, source/run rewriting, or domain answers are performed here.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import tempfile

from pypdf import PdfReader
from rulelab.grounding import _VisibleHTML, normalize_evidence

ROOT = Path(__file__).resolve().parents[1]
DOSSIER = ROOT / 'docs/analysis/o6_1b-variable-review-20261008'
INVENTORY = ROOT / 'docs/analysis/all-measure-variable-review-20261008'
APP_COMMIT = '5296108f5756ef1463c25a49d93d4a346e9b5e9c'
INPUT_HASHES = {
    'app-code-evidence.json': '53acbb510f5f2620555ec6a9b0fba87bee20f74a44baee9938c9d3b29e956d5d',
    'citation-audit.json': '00066a6fe8698e2b88c26b2deb5af4545acc86da05024ccc9bef3106aad21139',
    'leaf-review.json': '83de21a13ffebad2a2f4b05381675f345c39daf641d566e0449fd7aead72718f',
    'policy-probes.json': '0a04b2cdfc1e2a16089f665d341dce59c099869b9b835885bc5af298946393e8',
    'questions.json': '10cbcc6a037f8186b7e5067c86e0db799efd733726e00d3b8ada4b3d45483714',
}
MANIFEST_HASH = '6a173a9a5c8929d981cfc7ae19d2104a325732a7c6e8577ca6c16afb3a6f08bb'
QUESTION_IDS = {f'o6_1b-{key}' for key in (
    'BIO_SCOPE_CONTROL', 'FIELD_DIV_IDENTITY', 'EXACT_TEN_HA', 'DIVNFZ_COMPLETION',
    'RGVE_STOCK_BASIS', 'MONITORING_PROGRAMME', 'PHEROMONE_RETENTION',
    'TRAINING_EVIDENCE', 'SEED_UNITS_AND_VARIANTS', 'DIV_TOPUP_SEPARATION',
    'HISTORY_AND_OTHER_OPTIONS',
)}
GROUPS = {'participation', 'land_identity', 'div_accounting', 'div_management',
          'seed', 'training', 'livestock', 'monitoring', 'pheromone',
          'area_history', 'crop_options', 'landscape_bees'}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read(path):
    return json.loads(path.read_text())


class OriginalSources:
    def __init__(self):
        self.pdfs = {}
        self.pages = {}

    def text(self, relative_path, page):
        key = (relative_path, page)
        if key not in self.pages:
            path = ROOT / relative_path
            if path.suffix == '.pdf':
                if relative_path not in self.pdfs:
                    self.pdfs[relative_path] = PdfReader(path)
                require(isinstance(page, int) and 1 <= page <= len(self.pdfs[relative_path].pages),
                        'invalid original PDF page')
                self.pages[key] = self.pdfs[relative_path].pages[page - 1].extract_text()
            else:
                require(page is None, 'HTML must not specify a PDF page')
                parser = _VisibleHTML()
                parser.feed(path.read_text())
                self.pages[key] = ' '.join(parser.parts)
        return self.pages[key]

    def check_quote(self, citation, key):
        require(normalize_evidence(citation[key]) in normalize_evidence(
            self.text(citation['source_path'], citation['page'])),
            f'original quote/page mismatch: {citation.get("reference_id", key)}')


def validate_records(leaves, questions, runs):
    expected = {(model, leaf['path']): leaf for model, run in runs.items()
                for leaf in run['leaf_diff']}
    require(len(leaves) == 287 and len({(x['model'], x['path']) for x in leaves}) == 287,
            'required 287 unique BIO leaves missing')
    require({(x['model'], x['path']) for x in leaves} == set(expected),
            'BIO leaf coverage changed')
    for item in leaves:
        original = expected[(item['model'], item['path'])]
        for key, value in original.items():
            if key != 'semantic_equivalence':
                require(item[key] == value, f'BIO before/after/proposal drift: {item["path"]}')
        require(item['review_group'] in GROUPS and
                item['semantic_equivalence'] == 'not_approved' and
                item['app_admission'] == 'open_before_app_admission',
                'unapproved BIO admission or group drift')
    require(len(questions) == 11 and {q['id'] for q in questions} == QUESTION_IDS,
            'required BIO expert question set changed')
    for question in questions:
        require(question['status'] == 'open_before_app_admission' and question['answer'] is None,
                'BIO question silently closed/answered')
        require(question['blocking_groups'] and set(question['blocking_groups']) <= GROUPS
                and question['question'] and question['evidence'], 'BIO question evidence missing')
    require({g for q in questions for g in q['blocking_groups']} == GROUPS,
            'BIO group lost its open admission decision')


def validate(app_root=None, opa_bin=None):
    for name, sha in INPUT_HASHES.items():
        require(digest(DOSSIER / name) == sha, f'pinned BIO review input changed: {name}')
    manifest_path = INVENTORY / 'source-manifest.json'
    require(digest(manifest_path) == MANIFEST_HASH, 'pinned historical manifest changed')
    manifest = read(manifest_path)['files']
    diff = read(INVENTORY / 'o6_1b/variable-diff.json')
    require(digest(INVENTORY / 'o6_1b/variable-diff.json') ==
            '8e842cfb2ec70d8a0a388548bbd4b344ad3aaf300530419037004616eb08c5d0', 'pinned BIO inventory diff changed')
    runs = diff['runs']
    require({m: r['run_id'] for m, r in runs.items()} == {
        'luna': 'v2-o6_1b-luna-high-20260930',
        'opus': 'v2-o6_1b-opus-5.5-high-20260925'}, 'BIO run selection changed')
    source_paths = set()
    expected_citations = {}
    for model, run in runs.items():
        prefix = f'runs/{run["run_id"]}/'
        for path, sha in manifest.items():
            if path.startswith(prefix):
                require(digest(ROOT / path) == sha, f'historical BIO run drift: {path}')
        metadata = read(ROOT / prefix / 'run.json')
        source_map = {s['name']: s for s in metadata['sources']}
        for source in source_map.values():
            path = 'sources/oepul/' + source['source_path']
            source_paths.add(path)
            require(digest(ROOT / path) == source['sha256'] == manifest[path],
                    f'original BIO source hash drift: {path}')
        references = read(ROOT / prefix / 'workspace/rules/citations.json')['references']
        used = {ref for p in run['proposal_references'].values() for ref in p['source_reference_ids']}
        for ref in references:
            if ref['reference_id'] not in used:
                continue
            source = source_map[Path(ref['source_path']).name]
            require(ref['source_sha256'] == source['sha256'], 'BIO citation source identity drift')
            expected_citations[(model, ref['reference_id'])] = {
                'model': model, 'reference_id': ref['reference_id'],
                'source_path': 'sources/oepul/' + source['source_path'],
                'source_sha256': source['sha256'], 'page': ref['page'],
                'evidence_text': ref['evidence_text'], 'literal_quote_found': True,
                'normative_entailment': 'not_asserted',
            }
    leaves, questions = read(DOSSIER / 'leaf-review.json'), read(DOSSIER / 'questions.json')
    validate_records(leaves, questions, runs)
    audit = read(DOSSIER / 'citation-audit.json')
    require(len(audit) == len(expected_citations) == 235 and
            {(c['model'], c['reference_id']): c for c in audit} == expected_citations,
            'required 235 original BIO citation checks changed')
    sources = OriginalSources()
    for citation in audit:
        sources.check_quote(citation, 'evidence_text')
    for question in questions:
        for citation in question['evidence']:
            require(citation['source_path'] in source_paths, 'unbound BIO question source')
            sources.check_quote(citation, 'literal_fragment')
    app = read(DOSSIER / 'app-code-evidence.json')
    require(app['commit'] == APP_COMMIT and app['runtime_values_included'] is False,
            'BIO App evidence context changed')
    if app_root:
        for path, item in app['files'].items():
            content = subprocess.check_output(['git', 'show', f'{APP_COMMIT}:{path}'], cwd=app_root)
            require(hashlib.sha256(content).hexdigest() == item['sha256'], 'BIO App source hash drift')
            lines = content.decode().splitlines()
            for excerpt in item['excerpts']:
                require('\n'.join(lines[excerpt['start_line']-1:excerpt['end_line']]) == excerpt['text'],
                        'BIO App excerpt drift')
    if opa_bin:
        replay_probes(opa_bin)
    return {'measure': 'o6_1b', 'leaf_paths': 287, 'original_citations': 235,
            'open_expert_questions': 11, 'policy_probes_replayed': 8 if opa_bin else 0,
            'promotion_ready': False, 'other_measures_reviewed': 0}


def replay_probes(opa_bin):
    for probe in read(DOSSIER / 'policy-probes.json'):
        workspace = ROOT / 'runs' / probe['run_id'] / 'workspace'
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / 'input.json'
            path.write_text(json.dumps(probe['input']))
            result = subprocess.run([str(opa_bin), 'eval', '--format=json', '--strict-builtin-errors',
                '--data', str(workspace / 'policy'), '--data', str(workspace / 'data'),
                '--input', str(path), probe['query']], capture_output=True, text=True, check=True)
        values = [e['value'] for row in json.loads(result.stdout).get('result', []) for e in row['expressions']]
        require(values == probe['observed_values'], f'historical BIO observation changed: {probe["id"]}')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--app-root', type=Path)
    parser.add_argument('--opa-bin', type=Path)
    args = parser.parse_args()
    print(json.dumps(validate(args.app_root, args.opa_bin), ensure_ascii=False))
