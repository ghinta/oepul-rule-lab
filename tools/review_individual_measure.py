"""Check manually reviewed measure dossiers without promoting their rules.

Only registered, individually completed dossiers are checked. Pinned historical
observations expose defects; they never define desired domain behavior.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from tools.review_o6_1c_variable_review import OriginalSources, digest, read, require

INVENTORY = ROOT / 'docs/analysis/all-measure-variable-review-20261008'
APP_COMMIT = '5296108f5756ef1463c25a49d93d4a346e9b5e9c'
MANIFEST_HASH = '6a173a9a5c8929d981cfc7ae19d2104a325732a7c6e8577ca6c16afb3a6f08bb'
CONFIG_HASHES = {
    'o6_2': 'b87139b4ad476b007f333ea7eed999ef5bab6d763be6d4c7823ec5c791a9e51c',
    'o6_3': 'e598624204755f1e40cbc8fd01f247905ae23469a7f605410e52d16e5296332a',
    'o6_4': '2e6a4708e444170f9c3aaa15adeb16080550a130558fdc0e3f6cf0c0c3b42ada',
    'o6_5': '769b38b5af5d322099820e6dbbfc7396122bf66c74e766b65e70cb27bdf7f580',
    'o6_6': 'd8660a9ac3480c212a596a48d04f5b5f9c9f1aa47bdc76abcbf4d0f82833ebef',
    'o6_7': '59879bd31b52525eedb18065278a150f92fc72e09619b0f57079f1de82702488',
    'o6_8': 'd1f08e3eb083152d062b803806f5b13662e7d5dc0c7f0fea02c799a66e8a8531',
    'o6_9': 'a1354b55f7f75e5d4fa321e7d916a968d904b166afff0d48909d5b0a20f57b79',
    'o6_10': '52250f794261293deaf627eff6353311079241acd5e72f94aa98a11b6d04a573',
    'o6_11': 'bbb587fd308bbc7cd3f22bfb135ddc3f55d5ca47dd812267dcef4158ca28b36c',
}  # Each completed slice is registered after its manual review.
INDEX = ROOT / 'docs/analysis/sequential-variable-reviews-20261008/README.md'
SEQUENCE = tuple(f'o6_{number}' for number in range(2, 25))


def render_index():
    require(set(CONFIG_HASHES) <= set(SEQUENCE), 'unexpected measure in sequential review')
    lines = ['# Fortlaufende Einzelprüfungen nach UBB, BIO und NPA/AFS', '',
             'App-Sammelissue: https://github.com/ghinta/oepul-recommender/issues/140.',
             'Arbeitsbranch: Draft Lab #103; UBB bleibt separat in Draft #102.', '',
             f'{len(CONFIG_HASHES)} weitere Maßnahmen einzeln dokumentiert; '
             f'{len(SEQUENCE)-len(CONFIG_HASHES)} weitere Einzelprüfungen ausstehend.',
             'Alle fachlichen Aufnahmeentscheidungen bleiben offen. Kein Merge, keine App-Promotion.', '',
             '| Maßnahme | Einzelprüfung | Blätter / Originalfundstellen / offene Fragen / OPA-Proben |',
             '| --- | --- | --- |']
    for measure in SEQUENCE:
        if measure in CONFIG_HASHES:
            config = read(dossier_path(measure) / 'review.json')
            counts = f'{config["leaf_count"]} / {config["citation_count"]} / {len(config["question_ids"])} / {config["probe_count"]}'
            lines.append(f'| {measure} | [dokumentiert, Aufnahme offen](../{measure}-variable-review-20261008/README.md) | {counts} |')
        else:
            lines.append(f'| {measure} | einzeln ausstehend | — |')
    lines += ['', 'Zahlen erfassen Prüfumfang, keine fachliche Qualität oder vollständige Rechtsfreigabe.',
              'Originalfundstellenprüfung bestätigt wörtliche Auffindbarkeit; historische OPA-Ausgaben sind Beobachtungen.',
              'Mögliche Wiederverwendung wird mit betroffenen Frage-IDs und unterschiedlichen Scopes dokumentiert;',
              'gemeinsame Namen oder gleiche technische Datentypen begründen keine fachlichen Aliase.', '']
    lines += ['[Laufende, belegte Synergiekandidaten](synergies.md) für die spätere gemeinsame Durchsicht.', '']
    return '\n'.join(lines)


def dossier_path(measure):
    return ROOT / f'docs/analysis/{measure}-variable-review-20261008'


def validate_records(leaves, questions, runs, config):
    expected = {(model, leaf['path']): leaf for model, run in runs.items()
                for leaf in run['leaf_diff']}
    actual = {(leaf['model'], leaf['path']): leaf for leaf in leaves}
    require(len(leaves) == len(actual) == config['leaf_count'] == len(expected)
            and set(actual) == set(expected), 'individual leaf coverage changed')
    groups = set(config['groups'])
    for key, item in actual.items():
        for field, value in expected[key].items():
            if field != 'semantic_equivalence':
                require(item[field] == value, f'before/after/proposal drift: {key}')
        require(item['review_group'] in groups
                and item['semantic_equivalence'] == 'not_approved'
                and item['app_admission'] == 'open_before_app_admission',
                'unapproved alias/admission/group drift')
    require(len(questions) == len(config['question_ids'])
            and {q['id'] for q in questions} == set(config['question_ids']),
            'required expert question set changed')
    for question in questions:
        require(question['status'] == 'open_before_app_admission'
                and question['answer'] is None, 'question silently closed/answered')
        require(question['question'] and question['reason'] and question['evidence']
                and question['blocking_groups']
                and set(question['blocking_groups']) <= groups, 'question evidence missing')
    require({g for q in questions for g in q['blocking_groups']} == groups,
            'group lost its open admission decision')


def replay_probes(measure, opa_bin):
    dossier = dossier_path(measure)
    config = read(dossier / 'review.json')
    probes = read(dossier / 'policy-probes.json')
    require(len(probes) == len({p['id'] for p in probes}) == config['probe_count'],
            'required probe set changed')
    for probe in probes:
        require(probe['purpose'] == 'technical_observation_not_desired_domain_behavior',
                'observation converted to desired domain behavior')
        if probe['model'] == 'app':
            require(probe['run_id'] is None, 'App probe has invented historical run')
            variant = probe.get('policy_variant')
            if variant is None:
                policy = ROOT / config['app_probe_policy']
                expected_sha = config['app_probe_policy_sha256']
            else:
                variants = config.get('app_probe_variants', {})
                require(variant in variants, 'unbound App policy variant')
                policy = ROOT / variants[variant]['policy_path']
                expected_sha = variants[variant]['policy_sha256']
            require(digest(policy) == expected_sha, 'App probe policy drift')
            data_args = ['--data', str(policy)]
        else:
            require(config['run_ids'][probe['model']] == probe['run_id'], 'probe run drift')
            workspace = ROOT / 'runs' / probe['run_id'] / 'workspace'
            data_args = ['--data', str(workspace / 'policy'), '--data', str(workspace / 'data')]
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / 'input.json'
            path.write_text(json.dumps(probe['input']))
            result = subprocess.run([str(opa_bin), 'eval', '--format=json', '--strict-builtin-errors',
                                     *data_args, '--input', str(path), probe['query']],
                                    capture_output=True, text=True, check=True)
        values = [e['value'] for row in json.loads(result.stdout).get('result', [])
                  for e in row['expressions']]
        require(values == probe['observed_values'], f'observation drift: {probe["id"]}')


def validate(measure, app_root=None, opa_bin=None):
    require(measure in CONFIG_HASHES, 'measure has no completed individual review')
    dossier = dossier_path(measure)
    require(digest(dossier / 'review.json') == CONFIG_HASHES[measure], 'pinned review config drift')
    config = read(dossier / 'review.json')
    require(config['measure'] == measure and config['app_commit'] == APP_COMMIT
            and config['promotion_ready'] is False
            and config['helper_consumption_complete'] is False
            and config['normative_entailment'] == 'not_asserted', 'unproven completion/promotion')
    for name, sha in config['inputs'].items():
        require(digest(dossier / name) == sha, f'pinned review evidence changed: {name}')
    for path, sha in config.get('related_artifacts', {}).items():
        require(digest(ROOT / path) == sha, f'related adaptation evidence changed: {path}')
    require(digest(INVENTORY / 'source-manifest.json') == MANIFEST_HASH, 'historical manifest drift')
    manifest = read(INVENTORY / 'source-manifest.json')['files']
    diff_path = INVENTORY / measure / 'variable-diff.json'
    require(digest(diff_path) == config['inventory_sha256'], 'individual inventory drift')
    runs = read(diff_path)['runs']
    require({m: r['run_id'] for m, r in runs.items()} == config['run_ids'], 'reviewed runs changed')
    expected_citations = {}
    source_paths = set()
    for model, run in runs.items():
        prefix = f'runs/{run["run_id"]}/'
        for path, sha in manifest.items():
            if path.startswith(prefix):
                require(digest(ROOT / path) == sha, f'historical run drift: {path}')
        metadata = read(ROOT / prefix / 'run.json')
        source_map = {s['name']: s for s in metadata['sources']}
        for source in source_map.values():
            path = 'sources/oepul/' + source['source_path']
            source_paths.add(path)
            require(digest(ROOT / path) == source['sha256'] == manifest[path], 'original source drift')
        used = {ref for p in run['proposal_references'].values() for ref in p['source_reference_ids']}
        for ref in read(ROOT / prefix / 'workspace/rules/citations.json')['references']:
            if ref['reference_id'] not in used:
                continue
            source = source_map[Path(ref['source_path']).name]
            require(ref['source_sha256'] == source['sha256'], 'citation source identity drift')
            expected_citations[(model, ref['reference_id'])] = {
                'model': model, 'reference_id': ref['reference_id'],
                'source_path': 'sources/oepul/' + source['source_path'],
                'source_sha256': source['sha256'], 'page': ref['page'],
                'evidence_text': ref['evidence_text'], 'literal_quote_found': True,
                'normative_entailment': 'not_asserted',
            }
    leaves, questions = read(dossier / 'leaf-review.json'), read(dossier / 'questions.json')
    validate_records(leaves, questions, runs, config)
    audit = read(dossier / 'citation-audit.json')
    require(len(audit) == len(expected_citations) == config['citation_count']
            and {(c['model'], c['reference_id']): c for c in audit} == expected_citations,
            'original citation checks changed')
    sources = OriginalSources()
    for citation in audit:
        sources.check_quote(citation, 'evidence_text')
    for question in questions:
        for citation in question['evidence']:
            require(citation['source_path'] in source_paths, 'unbound expert question source')
            sources.check_quote(citation, 'literal_fragment')
    app = read(dossier / 'app-code-evidence.json')
    require(app['commit'] == APP_COMMIT and app['runtime_values_included'] is False, 'App context drift')
    require(digest(ROOT / config['app_probe_policy']) == config['app_probe_policy_sha256']
            == app['files']['backend/policy/oepul_measures.rego']['sha256'], 'App policy copy drift')
    for variant in config.get('app_probe_variants', {}).values():
        require(digest(ROOT / variant['policy_path']) == variant['policy_sha256'],
                'additional App policy copy drift')
        if app_root:
            content = subprocess.check_output(
                ['git', 'show', f'{variant["commit"]}:{variant["source_path"]}'], cwd=app_root)
            require(hashlib.sha256(content).hexdigest() == variant['policy_sha256'],
                    'additional App commit/policy drift')
    if app_root:
        for path, item in app['files'].items():
            content = subprocess.check_output(['git', 'show', f'{APP_COMMIT}:{path}'], cwd=app_root)
            require(hashlib.sha256(content).hexdigest() == item['sha256'], 'App code drift')
            lines = content.decode().splitlines()
            for excerpt in item['excerpts']:
                require('\n'.join(lines[excerpt['start_line']-1:excerpt['end_line']]) == excerpt['text'],
                        'App excerpt drift')
    if opa_bin:
        replay_probes(measure, opa_bin)
    return {'measure': measure, 'leaf_paths': config['leaf_count'],
            'original_citations': config['citation_count'], 'open_questions': len(questions),
            'probes_replayed': config['probe_count'] if opa_bin else 0, 'promotion_ready': False}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--measure', choices=sorted(CONFIG_HASHES))
    parser.add_argument('--app-root', type=Path)
    parser.add_argument('--opa-bin', type=Path)
    parser.add_argument('--write-index', action='store_true')
    args = parser.parse_args()
    for measure in ([args.measure] if args.measure else CONFIG_HASHES):
        print(json.dumps(validate(measure, args.app_root, args.opa_bin), ensure_ascii=False))
    if not args.measure:
        expected = render_index()
        if args.write_index:
            INDEX.parent.mkdir(exist_ok=True)
            INDEX.write_text(expected)
        else:
            require(INDEX.read_text() == expected, 'sequential review status index drift')
