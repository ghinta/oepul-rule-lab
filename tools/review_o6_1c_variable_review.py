"""Read-only integrity and original-source checks for the individual NPA/AFS dossier.

Historical OPA outputs are observations, never desired rule behavior.
No promotion, source/run rewriting, or domain answers are performed here.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path
import subprocess
import tempfile

from pypdf import PdfReader
from rulelab.grounding import _VisibleHTML, normalize_evidence

ROOT = Path(__file__).resolve().parents[1]
DOSSIER = ROOT / 'docs/analysis/o6_1c-variable-review-20261008'
INVENTORY = ROOT / 'docs/analysis/all-measure-variable-review-20261008'
APP_COMMIT = '5296108f5756ef1463c25a49d93d4a346e9b5e9c'
INPUT_HASHES = {
    'app-code-evidence.json': '255862ba86c10ab0ec0320f2df50d735b5cf52e7f1b74357ee4c48320bf858d8',
    'app-policy.rego': 'c0900ece3b883e1362a6ab1d00518be7ad456f6d4e05dba97a01f4eee48bd35a',
    'citation-audit.json': 'f69b40517ce2af08fa677b3635af6b1473c4985ed26da6cfdbc3037812064fb8',
    'leaf-review.json': '773ed2fe8a4f8ac7714d66c0e3c841bb13684f9fbff8edc05f2dba6eb7ff84da',
    'policy-probes.json': '3c948e9f93fa4463a4ace82dab30203029d8a65af547d2112373351bd7c8d986',
    'questions.json': '77537c9490b94742b211f6b6e0ce829ac54e68a4a8868ce2fc3ee637eac49f94',
}
MANIFEST_HASH = '6a173a9a5c8929d981cfc7ae19d2104a325732a7c6e8577ca6c16afb3a6f08bb'
QUESTION_IDS = {f'o6_1c-{key}' for key in (
    'CATEGORY_YEAR', 'AFS_ENTITY_IDENTITY', 'NPA_QUOTA_PART_AREA',
    'NPA_EVENTS_AND_YEAR_END', 'NPA_BIO_PSM_AND_FERT', 'AFS_TAXON_GSPAV',
    'AFS_CARE_ESTABLISHMENT', 'COMBINATION_VS_CREDIT', 'OFFICIAL_OP_CODES',
    'AREA_AND_PREMIUM',
)}
GROUPS = {'participation', 'npa_identity', 'npa_management', 'npa_inputs',
          'afs_identity_geometry', 'afs_species', 'afs_care_inputs',
          'area_codes_combination'}


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
    require(len(leaves) == 150 and len({(x['model'], x['path']) for x in leaves}) == 150,
            'required 150 unique NPA/AFS leaves missing')
    require({(x['model'], x['path']) for x in leaves} == set(expected),
            'NPA/AFS leaf coverage changed')
    for item in leaves:
        original = expected[(item['model'], item['path'])]
        for key, value in original.items():
            if key != 'semantic_equivalence':
                require(item[key] == value, f'NPA/AFS before/after/proposal drift: {item["path"]}')
        require(item['review_group'] in GROUPS and
                item['semantic_equivalence'] == 'not_approved' and
                item['app_admission'] == 'open_before_app_admission',
                'unapproved NPA/AFS admission or group drift')
    require(len(questions) == 10 and {q['id'] for q in questions} == QUESTION_IDS,
            'required NPA/AFS expert question set changed')
    for question in questions:
        require(question['status'] == 'open_before_app_admission' and question['answer'] is None,
                'NPA/AFS question silently closed/answered')
        require(question['blocking_groups'] and set(question['blocking_groups']) <= GROUPS
                and question['question'] and question['evidence'], 'NPA/AFS question evidence missing')
    require({g for q in questions for g in q['blocking_groups']} == GROUPS,
            'NPA/AFS group lost its open admission decision')


def validate_access_sites(leaves, runs):
    module = ROOT / 'runs' / runs['luna']['run_id'] / 'workspace/policy/o6_1c.rego'
    lines = module.read_text().splitlines()
    reads = 0
    for leaf in leaves:
        if leaf['model'] == 'opus':
            require(leaf['policy_access_review'] == 'helper_alias_review_incomplete',
                    'unproven Opus helper consumption approved')
            continue
        path = leaf['path']
        expression = ('p.' + path.split('land.parcels[].', 1)[1]
                      if path.startswith('land.parcels[].') else 'input.' + path)
        expression = expression.removesuffix('[]')
        if path == 'land.parcels[].agroforestry.trees[].scientific_name':
            expression = 'tree.scientific_name'
        sites = [{'file': str(module.relative_to(ROOT)), 'line': number, 'expression': line.strip()}
                 for number, line in enumerate(lines, 1)
                 if re.search(re.escape(expression) + r'(?![A-Za-z_0-9])', line)]
        require(leaf['literal_access_sites'] == sites, 'Luna literal access evidence drift')
        status = 'direct_read_in_single_module' if sites else 'no_access_in_single_module'
        require(leaf['policy_access_review'] == status, 'Luna access status drift')
        reads += bool(sites)
    require(reads == 20, 'Luna direct-read count changed')


def validate(app_root=None, opa_bin=None):
    for name, sha in INPUT_HASHES.items():
        require(digest(DOSSIER / name) == sha, f'pinned NPA/AFS review input changed: {name}')
    manifest_path = INVENTORY / 'source-manifest.json'
    require(digest(manifest_path) == MANIFEST_HASH, 'pinned historical manifest changed')
    manifest = read(manifest_path)['files']
    diff = read(INVENTORY / 'o6_1c/variable-diff.json')
    require(digest(INVENTORY / 'o6_1c/variable-diff.json') ==
            'ead0fba211994bd74473fb9db07318acbde710090843da745bd7d32881704f77', 'pinned NPA/AFS inventory diff changed')
    runs = diff['runs']
    require({m: r['run_id'] for m, r in runs.items()} == {
        'luna': 'v2-o6_1c-luna-high-20260930',
        'opus': 'v2-o6_1c-opus-5.5-high-20260925'}, 'NPA/AFS run selection changed')
    source_paths = set()
    expected_citations = {}
    for model, run in runs.items():
        prefix = f'runs/{run["run_id"]}/'
        for path, sha in manifest.items():
            if path.startswith(prefix):
                require(digest(ROOT / path) == sha, f'historical NPA/AFS run drift: {path}')
        metadata = read(ROOT / prefix / 'run.json')
        source_map = {s['name']: s for s in metadata['sources']}
        for source in source_map.values():
            path = 'sources/oepul/' + source['source_path']
            source_paths.add(path)
            require(digest(ROOT / path) == source['sha256'] == manifest[path],
                    f'original NPA/AFS source hash drift: {path}')
        references = read(ROOT / prefix / 'workspace/rules/citations.json')['references']
        used = {ref for p in run['proposal_references'].values() for ref in p['source_reference_ids']}
        for ref in references:
            if ref['reference_id'] not in used:
                continue
            source = source_map[Path(ref['source_path']).name]
            require(ref['source_sha256'] == source['sha256'], 'NPA/AFS citation source identity drift')
            expected_citations[(model, ref['reference_id'])] = {
                'model': model, 'reference_id': ref['reference_id'],
                'source_path': 'sources/oepul/' + source['source_path'],
                'source_sha256': source['sha256'], 'page': ref['page'],
                'evidence_text': ref['evidence_text'], 'literal_quote_found': True,
                'normative_entailment': 'not_asserted',
            }
    leaves, questions = read(DOSSIER / 'leaf-review.json'), read(DOSSIER / 'questions.json')
    validate_records(leaves, questions, runs)
    validate_access_sites(leaves, runs)
    audit = read(DOSSIER / 'citation-audit.json')
    require(len(audit) == len(expected_citations) == 97 and
            {(c['model'], c['reference_id']): c for c in audit} == expected_citations,
            'required 97 original NPA/AFS citation checks changed')
    sources = OriginalSources()
    for citation in audit:
        sources.check_quote(citation, 'evidence_text')
    for question in questions:
        for citation in question['evidence']:
            require(citation['source_path'] in source_paths, 'unbound NPA/AFS question source')
            sources.check_quote(citation, 'literal_fragment')
    app = read(DOSSIER / 'app-code-evidence.json')
    require(app['commit'] == APP_COMMIT and app['runtime_values_included'] is False,
            'NPA/AFS App evidence context changed')
    require(digest(DOSSIER / 'app-policy.rego') == app['files']['backend/policy/oepul_measures.rego']['sha256'],
            'App probe policy is not the pinned original source')
    if app_root:
        for path, item in app['files'].items():
            content = subprocess.check_output(['git', 'show', f'{APP_COMMIT}:{path}'], cwd=app_root)
            require(hashlib.sha256(content).hexdigest() == item['sha256'], 'NPA/AFS App source hash drift')
            lines = content.decode().splitlines()
            for excerpt in item['excerpts']:
                require('\n'.join(lines[excerpt['start_line']-1:excerpt['end_line']]) == excerpt['text'],
                        'NPA/AFS App excerpt drift')
    if opa_bin:
        replay_probes(opa_bin)
    return {'measure': 'o6_1c', 'leaf_paths': 150, 'original_citations': 97,
            'open_expert_questions': 10, 'policy_probes_replayed': 13 if opa_bin else 0,
            'promotion_ready': False, 'other_measures_reviewed': 0}


def replay_probes(opa_bin):
    for probe in read(DOSSIER / 'policy-probes.json'):
        require(probe['purpose'] == 'technical_observation_not_desired_domain_behavior',
                'observations must not become desired domain behavior')
        if probe['model'] == 'app':
            data_args = ['--data', str(DOSSIER / 'app-policy.rego')]
        else:
            workspace = ROOT / 'runs' / probe['run_id'] / 'workspace'
            data_args = ['--data', str(workspace / 'policy'), '--data', str(workspace / 'data')]
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / 'input.json'
            path.write_text(json.dumps(probe['input']))
            result = subprocess.run([str(opa_bin), 'eval', '--format=json', '--strict-builtin-errors',
                *data_args,
                '--input', str(path), probe['query']], capture_output=True, text=True, check=True)
        values = [e['value'] for row in json.loads(result.stdout).get('result', []) for e in row['expressions']]
        require(values == probe['observed_values'], f'historical NPA/AFS observation changed: {probe["id"]}')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--app-root', type=Path)
    parser.add_argument('--opa-bin', type=Path)
    args = parser.parse_args()
    print(json.dumps(validate(args.app_root, args.opa_bin), ensure_ascii=False))
