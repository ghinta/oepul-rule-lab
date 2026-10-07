"""Reproducible, read-only admission preparation for 26 historical run pairs."""
from __future__ import annotations

import argparse
import csv
import hashlib
import io
import json
from pathlib import Path
import re
import subprocess

from rulelab.cli import flatten, profile_diff, rego_input_paths

ROOT = Path(__file__).resolve().parents[1]
DOSSIER = ROOT / 'docs/analysis/all-measure-variable-review-20261008'
MEASURES = ('o6_1a', 'o6_1b', 'o6_1c', *(f'o6_{i}' for i in range(2, 25)))
LAB_COMMIT = '7a296d28cb5b92e2758c5a3889c929ea1db60fe5'
APP_COMMIT = '5296108f5756ef1463c25a49d93d4a346e9b5e9c'
# Frozen review inputs; replacing runs, questions or answers requires an explicit new review snapshot.
PINNED_INPUTS = {'app-baseline.json': 'e8d5426aa7aa1110b1daf7b678d9c9bccf2ab19fbe280f4b09df0d2e349d3119', 'run-selection.json': '337a2979ee56313147b7c3e902d2b64ade5cde29dd25bd2f92a9e51e6bdb2554', 'questions.json': 'd976a68dc16af91abbc6529408e0d427e9935da198fa0773a788a72ed2c3297a', 'source-manifest.json': '6a173a9a5c8929d981cfc7ae19d2104a325732a7c6e8577ca6c16afb3a6f08bb'}


def load(path):
    return json.loads(path.read_text())


def require(condition, message):
    if not condition:
        raise ValueError(message)


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def dump(value):
    return json.dumps(value, ensure_ascii=False, indent=2) + '\n'


def bases():
    for name in ['app-baseline.json', 'run-selection.json']:
        require(digest(DOSSIER / name) == PINNED_INPUTS[name], f'pinned input changed: {name}')
    selection = load(DOSSIER / 'run-selection.json')
    require(tuple(selection) == MEASURES, 'required 26 measures/order changed')
    require(all(set(pair) == {'luna', 'opus'} for pair in selection.values()), 'required run pair missing')
    require(len({name for pair in selection.values() for name in pair.values()}) == 52, 'required 52 unique runs missing')
    app = load(DOSSIER / 'app-baseline.json')
    require(app['commit'] == APP_COMMIT and app['runtime_values_included'] is False, 'unexpected App basis')
    rows = app['files']['docs/mapping/20-dictionary/measure-readiness-classification-v1.csv']['rows']
    require(tuple(row['measure_id'] for row in rows) == MEASURES, 'App measure inventory mismatch')
    declared = flatten(app['files']['backend/policy/farm_profile_schema_blueprint.json']['schema'])
    registered = set()
    for path, item in app['files'].items():
        if 'field_registry_v1.csv' in path:
            prefix = 'land.parcels[].' if 'parcel_field' in path else (
                'livestock.species_groups[].' if 'livestock_field' in path else '')
            registered.update(prefix + row['variable_path'] for row in item['rows'])
    return selection, declared, registered


def source_manifest():
    selection, _, _ = bases()
    paths = [DOSSIER / name for name in ['run-selection.json', 'app-baseline.json', 'questions.json']]
    # Include source PDFs/HTML as well as all referenced generated artifacts.
    paths.extend(sorted((ROOT / 'sources').rglob('*')))
    for pair in selection.values():
        for name in pair.values():
            run = ROOT / 'runs' / name
            paths.extend(run / p for p in ['run.json', 'model.json', 'baseline_profile.json',
                'artifacts/profile-diff.json', 'artifacts/proposed-profile.json',
                'artifacts/direct-profile-diff.json', 'artifacts/input-paths.json',
                'artifacts/technical-validation.json', 'artifacts/grounding-validation.json'])
            for folder in ['rules', 'policy', 'data', 'tests', 'notes']:
                paths.extend(sorted((run / 'workspace' / folder).rglob('*')))
    return {'lab_commit': LAB_COMMIT, 'app_commit': APP_COMMIT,
            'files': {str(p.relative_to(ROOT)): digest(p) for p in sorted(set(paths)) if p.is_file()}}


def run_diff(measure, model, name, declared, registered):
    run = ROOT / 'runs' / name
    meta = load(run / 'run.json')
    require(meta['run_id'] == name and meta['measure'] == measure and meta['status'] == 'finalized', 'run identity/status mismatch')
    model_info = load(run / 'model.json')
    require(('-luna' if model == 'luna' else '-opus-5.5') in name, 'model/run mismatch')
    delta = profile_diff(load(run / 'baseline_profile.json'), load(run / 'artifacts/proposed-profile.json'))
    require(delta == load(run / 'artifacts/profile-diff.json'), 'historical profile diff drift')
    require(not any(load(run / 'artifacts/direct-profile-diff.json').values()), 'historical baseline edited')
    changes = load(run / 'workspace/rules/profile_changes.json')['changes']
    require(changes and len({c['path'] for c in changes}) == len(changes), 'empty/duplicate proposals')
    rules = load(run / 'workspace/rules/rules.json')['rules']
    references = load(run / 'workspace/rules/citations.json')['references']
    rule_ids = {r['id'] for r in rules}
    ref_ids = {c['reference_id'] for c in references}
    require(len(rule_ids) == len(rules) and len(ref_ids) == len(references), 'duplicate rule/citation IDs')
    for c in changes:
        require(c['rule_ids'] and set(c['rule_ids']) <= rule_ids, f'proposal has invalid rules: {name}/{c["path"]}')
        require(c['source_reference_ids'] and set(c['source_reference_ids']) <= ref_ids, f'proposal has invalid citations: {name}/{c["path"]}')
    leaves = []
    for action, values in delta.items():
        for path, value in values.items():
            parents = [c for c in changes if path == c['path'] or path.startswith(c['path'] + '.') or path.startswith(c['path'] + '[]')]
            require(parents, f'unattributed diff: {name}/{path}')
            leaves.append({'path': path, 'action': action,
                'before_present': action != 'added',
                'before': value['before'] if action == 'changed' else (value if action == 'removed' else None),
                'after_present': action != 'removed',
                'after': value['after'] if action == 'changed' else (value if action == 'added' else None),
                'proposal_paths': [c['path'] for c in parents],
                'app_schema_present': path in declared, 'app_schema_notation': declared.get(path),
                'app_registered_exact_path': path in registered,
                'admission_status': 'not_decided', 'semantic_equivalence': 'not_reviewed'})
    modules = sorted((run / 'workspace/policy').rglob('*.rego'))
    sites = []
    for module in modules:
        for number, line in enumerate(module.read_text().splitlines(), 1):
            if re.search(r'object\.get\(\s*input\s*,', line):
                sites.append({'file': str(module.relative_to(ROOT)), 'line': number, 'expression': line.strip()})
    return {'run_id': name, 'model': model_info, 'generation_attempt': meta['generation_attempt'],
        'finalized_at': meta['finalized_at'], 'baseline_sha256': digest(run / 'baseline_profile.json'),
        'proposal_count': len(changes), 'proposal_paths': [c['path'] for c in changes],
        'proposal_references': {c['path']: {'rule_ids': c['rule_ids'], 'source_reference_ids': c['source_reference_ids']} for c in changes},
        'rule_count': len(rules), 'counts': {k: len(v) for k, v in delta.items()},
        'leaf_diff': sorted(leaves, key=lambda x: x['path']),
        'declared_rule_input_paths': sorted({p for r in rules for c in r['conditions'] for p in c.get('input_paths', [])}),
        'conditions_without_input_path_declaration': [
            {'rule_id': r['id'], 'condition_index': i}
            for r in rules for i, c in enumerate(r['conditions']) if 'input_paths' not in c],
        'stored_rego_input_paths': load(run / 'artifacts/input-paths.json'),
        'current_extractor_paths': rego_input_paths(modules),
        'literal_object_get_input_sites': sites,
        'consumption_review_status': 'incomplete_static_analysis',
        'model_assumptions_file': str((run / 'workspace/notes/assumptions.md').relative_to(ROOT)),
        'model_assumptions_accepted': False}


def questions():
    require(digest(DOSSIER / 'questions.json') == PINNED_INPUTS['questions.json'], 'required question set/text/status changed')
    data = load(DOSSIER / 'questions.json')
    require(set(data) == {*MEASURES, 'cross_measure'}, 'required question groups missing')
    ids = []
    for measure, items in data.items():
        require(items, f'empty question group: {measure}')
        for item in items:
            ids.append(item['id'])
            require(item['id'].startswith(measure + '-') and item['status'] == 'open_before_app_admission', 'question identity/open status changed')
            require(item['question'] and item['origins'] and item['answer'] is None, 'question/evidence missing or unreviewed answer')
            for origin in item['origins']:
                p = ROOT / origin['file']
                lines = p.read_text().splitlines()
                require(1 <= origin['line'] <= origin['end_line'] <= len(lines), 'invalid question origin')
                require(origin['quote'] == '\n'.join(lines[origin['line']-1:origin['end_line']]), 'question origin quote drift')
    require(len(ids) == len(set(ids)), 'duplicate question IDs')
    return data


def build():
    selection, declared, registered = bases()
    catalogue = questions()
    result = {}
    for measure, pair in selection.items():
        runs = {model: run_diff(measure, model, name, declared, registered) for model, name in pair.items()}
        require(runs['luna']['baseline_sha256'] == runs['opus']['baseline_sha256'], 'different run baselines')
        result[measure] = {'schema_version': 'all_measure_variable_review.v1', 'measure_id': measure,
            'lab_commit': LAB_COMMIT, 'app_commit': APP_COMMIT,
            'admission_status': 'not_decided', 'promotion_ready': False, 'runs': runs,
            'same_spelling_implies_equivalence': False,
            'same_spelling_leaf_paths': sorted({l['path'] for l in runs['luna']['leaf_diff']} & {l['path'] for l in runs['opus']['leaf_diff']}),
            'questions': catalogue[measure]}
    return result


def cell(value):
    return '`' + json.dumps(value, ensure_ascii=False).replace('|', '&#124;').replace('`', '&#96;') + '`'


def render_diff(data):
    m = data['measure_id']
    lines = [f'# {m}: Variablen vorher / nachher', '',
        'Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.',
        'App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.',
        'Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.',
        'App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.', '']
    for model, run in data['runs'].items():
        lines += [f'## {model}: `{run["run_id"]}`', '', f'{run["proposal_count"]} Vorschläge; Blattpfade: {run["counts"]}.', '',
            '| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |',
            '| --- | --- | --- | --- | --- | --- |']
        for leaf in run['leaf_diff']:
            before = cell(leaf['before']) if leaf['before_present'] else 'nicht vorhanden'
            after = cell(leaf['after']) if leaf['after_present'] else 'entfernt'
            schema = cell(leaf['app_schema_notation']) if leaf['app_schema_present'] else 'nicht deklariert'
            lines.append(f'| `{leaf["path"]}` | {leaf["action"]} | {before} | {after} | {schema} | {"ja" if leaf["app_registered_exact_path"] else "nein"} |')
        lines += ['', f'Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/{run["run_id"]}/workspace/rules/profile_changes.json), [citations.json](../../../../runs/{run["run_id"]}/workspace/rules/citations.json).', '']
    lines += ['## Grenzen', '', 'Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.',
        'Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.',
        'Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.', '']
    return '\n'.join(lines)


def render_questions(items, heading):
    lines = [heading, '', 'Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.', '']
    for q in items:
        lines += [f'### {q["id"]}', '', q['question'], '', f'Status: `{q["status"]}` · Antwort: offen.', '']
        for o in q['origins']:
            lines += [f'Ursprung: `{o["file"]}:{o["line"]}–{o["end_line"]}`', '', '```text', o['quote'], '```', '']
    return '\n'.join(lines)


def render_paths(data):
    maps = {model: {leaf['path']: leaf for leaf in run['leaf_diff']}
            for model, run in data['runs'].items()}
    common = set(maps['luna']) & set(maps['opus'])
    lines = [f'# {data["measure_id"]}: Pfade Luna / Opus', '',
        'Verglichen werden vollständige Blattpfade, keine ähnlich klingenden Namen.',
        'Gleiche Schreibweise oder gleiche Typnotation beweist weder dieselbe Definition noch denselben Rego-Konsum.',
        'Modell-exklusive Pfade stehen vollständig im [Variablendiff](diff.md); sie werden nicht automatisch als Aliase zusammengeführt.', '',
        f'Luna-exklusive Blattpfade: {len(set(maps["luna"]) - common)}; Opus-exklusive: {len(set(maps["opus"]) - common)}; gemeinsame Schreibweisen: {len(common)}.', '',
        '| Gemeinsamer Pfad | Luna-Notation danach | Opus-Notation danach | fachliche Zuordnung |',
        '| --- | --- | --- | --- |']
    for path in sorted(common):
        lines.append(f'| `{path}` | {cell(maps["luna"][path]["after"])} | {cell(maps["opus"][path]["after"])} | offen |')
    lines += ['', '## Geänderte bestehende Definitionen', '']
    for model, run in data['runs'].items():
        changed = [leaf for leaf in run['leaf_diff'] if leaf['action'] != 'added']
        for leaf in changed:
            lines.append(f'- {model}: `{leaf["path"]}`: {cell(leaf["before"])} → {cell(leaf["after"])}. Bestehende Bedeutung nicht überschreiben.')
    if not any(leaf['action'] != 'added' for run in data['runs'].values() for leaf in run['leaf_diff']):
        lines.append('Keine geänderten/entfernten Blattwerte im gespeicherten Profildiff. Implizite Umdeutungen bestehender Felder bleiben trotzdem prüfpflichtig.')
    lines += ['', '## Technischer Konsum bleibt offen', '']
    for model, run in data['runs'].items():
        lines.append(f'- {model}: {len(run["stored_rego_input_paths"]["paths"])} gespeicherte Scannerpfade; {len(run["literal_object_get_input_sites"])} beobachtete direkte object.get(input, …)-Zeilen; {len(run["conditions_without_input_path_declaration"])} Regelbedingungen ohne input_paths-Deklaration.')
    lines += ['', 'Diese Zahlen messen keine Vollständigkeit. Multiline-Zugriffe, lokale Aliase, Helper und Adapter brauchen eigene Prüfung.',
        'Vor Integration: bestätigte Fachdefinition → zugelassener App-Pfad → expliziter Adapter → tatsächlicher Rego-Zugriff → Grenzfalltest.', '',
        'Offene Fachentscheidungen: [questions.md](questions.md). Alle ursprünglichen Modellannahmen: [model-notes.md](model-notes.md).', '']
    return '\n'.join(lines)


def outputs(data):
    result = {}
    for m, item in data.items():
        result[f'{m}/variable-diff.json'] = dump(item)
        result[f'{m}/diff.md'] = render_diff(item)
        result[f'{m}/path-review.md'] = render_paths(item)
        result[f'{m}/questions.md'] = render_questions(item['questions'], f'# {m}: offene Fachentscheidungen')
        notes = [f'# {m}: unveränderte Modellnotizen', '', 'Sämtliche Modellannahmen sind unbestätigt. Auch nicht einzeln priorisierte Auslegungen müssen vor Übernahme geprüft werden.', '']
        for model, run in item['runs'].items():
            notes += [f'## {model}: `{run["run_id"]}`', '', (ROOT / run['model_assumptions_file']).read_text(), '']
        result[f'{m}/model-notes.md'] = '\n'.join(notes).rstrip() + '\n'
    catalogue = questions()
    result['cross-measure-questions.md'] = render_questions(catalogue['cross_measure'], '# Gemeinsame Fachentscheidungen')
    lines = ['# Variablen- und Pfadreview: alle 26 Maßnahmen', '',
        'Sammelissue: https://github.com/ghinta/oepul-recommender/issues/140 · Arbeitsauftrag: App #139.',
        f'Lab-Basis: `{LAB_COMMIT}` · App-Basis nach #137: `{APP_COMMIT}`.', '',
        '52 finalisierte historische Runs, je ein Luna- und Opus-Run. Spätere Überarbeitungen sind nicht enthalten.',
        'Dies ist die Vorbereitung der Expertenentscheidung. Regeln und Variablen werden damit nicht in die App übernommen.', '',
        '| Maßnahme | Luna Vorschläge / neue / geänderte Blattpfade | Opus Vorschläge / neue / geänderte Blattpfade | offene Fragegruppen | Dossier |',
        '| --- | --- | --- | --- | --- |']
    for m, item in data.items():
        cols = [f'{r["proposal_count"]} / {r["counts"]["added"]} / {r["counts"]["changed"]}' for r in item['runs'].values()]
        lines.append(f'| {m} | {cols[0]} | {cols[1]} | {len(item["questions"])} | [Diff]({m}/diff.md), [Pfade]({m}/path-review.md), [Fragen]({m}/questions.md), [alle Notizen]({m}/model-notes.md) |')
    lines += ['', '## Offene gemeinsame Entscheidungen', '', '[Quellenstände, Snapshot-Zeitbezug, gemeinsame IDs/Codes/RGVE, fehlende Daten und Behördenentscheidungen](cross-measure-questions.md).', '',
        '## Nächster Schritt', '', 'Expert:innen beantworten die Frage-IDs im Sammelissue mit Quelle, Geltungsjahr, Datenstand und Nachweis.',
        'Danach: pro Maßnahme zugelassene Variablen, Typ/Einheit/Scope und explizite Adapterpfade festlegen; offene Felder bleiben unknown.',
        'Erst danach App-Implementierung mit Herkunft/Snapshot, sinnvollen Grenzfalltests und CI. PRs bleiben bis zur Freigabe offen.', '',
        'o6_1a PR #102 bleibt separat offen; dessen zwei Fragen sind hier übernommen. o6_3 #97/acht Blocker und App #133 bleiben fachlich offen.',
        'Die vorhandene Heuwirtschaft-Adaptation ist keine Freigabe der rohen Luna-/Opus-Pfade. Keine Thesis-Datei wird verändert.', '',
        '## Technische Nachvollziehbarkeit', '', 'JSON-Blattdiffs enthalten Vorschlags-, Regel- und Quellen-IDs; Originalbelege verbleiben im historischen Run.',
        'source-manifest.json bindet alle Eingabedateien mit SHA-256. CI rekonstruiert alle Dossiers und schützt Vollständigkeit und offene Zustände.',
        'Exakte gleiche Namen beweisen keine fachliche Gleichheit. Der statische Rego-Scanner ist unvollständig; tatsächlicher Konsum ist noch nicht freigegeben.', '']
    result['README.md'] = '\n'.join(lines)
    return result


def validate(data=None, bound=None):
    require(digest(DOSSIER / 'source-manifest.json') == PINNED_INPUTS['source-manifest.json'], 'pinned source manifest changed')
    require((bound if bound is not None else load(DOSSIER / 'source-manifest.json')) == source_manifest(), 'pinned inventory/hash drift')
    expected = build()
    actual = data if data is not None else {m: load(DOSSIER / m / 'variable-diff.json') for m in MEASURES}
    require(actual == expected, 'incomplete/changed measure diff or admission state')
    for path, content in outputs(expected).items():
        require((DOSSIER / path).read_text() == content, f'generated dossier drift: {path}')
    return {'measures': len(expected), 'runs': sum(len(d['runs']) for d in expected.values()),
            'question_groups': sum(len(v) for v in questions().values()),
            'promotion_ready': False}


def verify_app(app_root):
    for path, item in load(DOSSIER / 'app-baseline.json')['files'].items():
        raw = subprocess.check_output(['git', '-C', str(app_root), 'show', f'{APP_COMMIT}:{path}'])
        require(hashlib.sha256(raw).hexdigest() == item['sha256'] and len(raw) == item['bytes'], f'App file drift: {path}')
        if 'schema' in item:
            require(item['schema'] == json.loads(raw), f'App schema drift: {path}')
        if 'rows' in item:
            require(item['rows'] == list(csv.DictReader(io.StringIO(raw.decode()))), f'App registry drift: {path}')


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--write', action='store_true')
    p.add_argument('--app-root', type=Path)
    args = p.parse_args()
    if args.app_root:
        verify_app(args.app_root)
    if args.write:
        data = build()
        for path, content in outputs(data).items():
            target = DOSSIER / path
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(content)
        (DOSSIER / 'source-manifest.json').write_text(dump(source_manifest()))
    print(json.dumps(validate(), sort_keys=True))


if __name__ == '__main__':
    main()
