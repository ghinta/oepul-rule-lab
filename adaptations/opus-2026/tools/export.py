#!/usr/bin/env python3
"""Export isolated native bundles. This changes namespaces, never rule semantics."""
from __future__ import annotations
import argparse
import copy
import hashlib
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
TOKENS = re.compile(r'"(?:\\.|[^"\\])*"|`[^`]*`|#[^\n]*|\bdata\.')


def rewrite(text, measure):
    text = TOKENS.sub(lambda m: f'data.opus_2026.{measure}.' if m[0] == 'data.' else m[0], text)
    return re.sub(r'(?m)^(package\s+)', rf'\1opus_2026.{measure}.', text)


def dump(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n')


def merge(target, value):
    for key, item in value.items():
        if key not in target:
            target[key] = copy.deepcopy(item)
        elif isinstance(target[key], dict) and isinstance(item, dict):
            merge(target[key], item)
        elif target[key] != item:
            raise ValueError(f'Conflicting OPA data key: {key}')


def query(entry):
    mid = entry['measure_id']
    if mid in ('o6_12', 'o6_14'):
        return f'data.oepul.{mid}.decision'
    if mid == 'o6_16':
        # This candidate exposes independent components, no decision document.
        keys = ['creditable_training_hours', 'obligation_violations', 'access_violations',
                'soil_samples_required', 'creditable_soil_samples', 'gwa_arable_area_ha', 'premium']
        return '{' + ', '.join(f'"{key}": data.oepul.o6_16.{key}' for key in keys) + '}'
    return entry['query']


def export(destination):
    policy = destination / 'policy'
    reference = destination / 'reference'
    if destination.exists() and any(destination.iterdir()):
        raise ValueError('Destination must be empty (no stale modules)')
    lineage = json.loads((ROOT / 'lineage.json').read_text())
    statuses = {s['measure_id']: s for s in json.loads((ROOT / 'correction-status.json').read_text())['measures']}
    tables = {}
    entries = []
    api = ['package opus_2026.api', '']
    for entry in lineage['entries']:
        mid = entry['measure_id']
        data = {}
        files = []
        expected = {Path(f['adapted_path']).relative_to('adaptations/opus-2026').as_posix(): f['adapted_sha256'] for f in entry['files']}
        actual_paths = {p.relative_to(ROOT).as_posix() for p in (ROOT / mid).rglob('*') if p.is_file()}
        if actual_paths != expected.keys():
            raise ValueError('Native artifact inventory mismatch: ' + mid)
        for source in sorted((ROOT / mid).rglob('*')):
            if not source.is_file():
                continue
            relative = source.relative_to(ROOT / mid)
            if hashlib.sha256(source.read_bytes()).hexdigest() != expected[source.relative_to(ROOT).as_posix()]:
                raise ValueError('Adapted native artifact digest mismatch: ' + str(source))
            if source.suffix == '.rego':
                output = policy / 'opus_2026' / mid / relative
                output.parent.mkdir(parents=True, exist_ok=True)
                output.write_text(rewrite(source.read_text(), mid))
            elif relative.parts[0] == 'data' and source.suffix == '.json':
                node = data
                for name in relative.parts[1:-1]:
                    node = node.setdefault(name, {})
                merge(node, json.loads(source.read_text()))
            else:
                raise ValueError(f'Unexpected native artifact: {source}')
            files.append({'path': source.relative_to(ROOT).as_posix(), 'sha256': hashlib.sha256(source.read_bytes()).hexdigest()})
        tables[mid] = data
        full_query = query(entry)
        api.append(f'results["{mid}"] := {rewrite(full_query, mid)}')
        contract = json.loads((ROOT / 'contracts' / f'{mid}.json').read_text())
        dump(reference / 'contracts' / f'{mid}.json', contract)
        entries.append({'measure_id': mid, 'run_id': entry['run_id'], 'source_query': full_query,
                        'opa_path': f'opus_2026/api/results/{mid}', 'sources': entry['sources'],
                        'files': files, 'status': statuses[mid],
                        'contract_sha256': hashlib.sha256((ROOT / 'contracts' / f'{mid}.json').read_bytes()).hexdigest()})
    policy.mkdir(parents=True, exist_ok=True)
    engine_id = hashlib.sha256(json.dumps(entries, sort_keys=True, separators=(',', ':')).encode()).hexdigest()
    api += [f'bundle_id := \"{engine_id}\"', 'evaluation[measure] := {\"bundle_id\": bundle_id, \"value\": value} if { some measure, value in results }']
    (policy / 'opus_2026_api.rego').write_text('\n\n'.join(api) + '\n')
    dump(policy / 'opus_2026_tables.json', {'opus_2026': tables})
    manifest = {'schema_version': 1, 'engine': 'opus-2026-adapted', 'source_year': 2026,
                'candidate_commit': lineage['candidate_commit'], 'audit_commit': lineage['audit_commit'],
                'expert_approved': False, 'engine_id': engine_id, 'entries': entries}
    manifest['policy_files'] = [{'path': p.relative_to(policy).as_posix(), 'sha256': hashlib.sha256(p.read_bytes()).hexdigest()}
                                for p in sorted(policy.rglob('*')) if p.is_file()]
    manifest['bundle_digest'] = hashlib.sha256(json.dumps(manifest, sort_keys=True, separators=(',', ':')).encode()).hexdigest()
    dump(reference / 'manifest.json', manifest)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    export(parser.parse_args().output)
