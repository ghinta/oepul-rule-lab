#!/usr/bin/env python3
"""Freeze declared native input types and evidence; proposals are not expert approval.

Absent values stay absent. The schema validates supplied values, not applicability
or completeness of legal evidence. No implicit default/coercion is emitted.
"""
from __future__ import annotations
import argparse
import copy
import hashlib
import json
from pathlib import Path
import re
import subprocess
from export import ROOT, dump


def schema(value):
    if isinstance(value, dict):
        return {'type': 'object', 'additionalProperties': False,
                'properties': {k: schema(v) for k, v in value.items()}}
    if isinstance(value, list):
        if len(value) != 1:
            raise ValueError(f'Expected one representative array item: {value}')
        return {'type': 'array', 'items': schema(value[0]), 'maxItems': 5000}
    if value == '1.0':
        return {'type': 'string', 'const': '1.0'}
    if value.startswith('enum('):
        match = re.fullmatch(r'enum\((.+)\)(\|null)?', value)
        if not match:
            raise ValueError(value)
        options = [None if v == 'null' else v for v in match[1].split('|')]
        if match[2] and None not in options:
            options.append(None)
        # The only numeric enum is the alpine access category, used numerically
        # by its native consumer. Measure-code enums remain strings.
        if value == 'enum(1|2|3)':
            options = [1, 2, 3]
        return {'enum': options}
    parts = value.split('|')
    types = {'boolean': 'boolean', 'number': 'number', 'int': 'integer', 'date': 'string', 'string': 'string', 'null': 'null'}
    result = {'type': [types[p] for p in parts] if len(parts) > 1 else types[parts[0]]}
    if 'date' in parts:
        result['format'] = 'date'
    if 'string' in parts:
        result['maxLength'] = 2000
    return result


def locate(root, path):
    node = root
    for token in path.split('.'):
        array = token.endswith('[]')
        key = token[:-2] if array else token
        node = node.setdefault('properties', {}).setdefault(key, {'type': 'array', 'items': {'type': 'object', 'additionalProperties': False, 'properties': {}}} if array else {'type': 'object', 'additionalProperties': False, 'properties': {}})
        if array:
            node = node['items']
    return node


def build(candidate):
    lineage = json.loads((ROOT / 'lineage.json').read_text())
    commit = subprocess.check_output(['git', '-C', str(candidate), 'rev-parse', 'HEAD'], text=True).strip()
    if commit != lineage['candidate_commit']:
        raise ValueError('Candidate checkout must match pinned source commit')
    basepath = candidate / 'profiles/canonical_farm_profile.json'
    base = json.loads(basepath.read_text())
    for entry in lineage['entries']:
        workspace = candidate / 'runs' / entry['run_id'] / 'workspace'
        changes_path = workspace / 'rules/profile_changes.json'
        references = json.loads((workspace / 'rules/citations.json').read_text())['references']
        source_by_hash = {s['sha256']: s['path'] for s in entry['sources']}
        for ref in references:
            ref['original_path'] = source_by_hash.get(ref['source_sha256'])
        changes = json.loads(changes_path.read_text())['changes']
        root = schema(copy.deepcopy(base))
        for change in changes:
            if change['action'] not in ('add', 'change'):
                raise ValueError(change)
            node = locate(root, change['path'])
            node.clear()
            node.update(schema(change['value_after']))
            node['description'] = change['rationale']
            node['x-rule-ids'] = change['rule_ids']
            node['x-source-reference-ids'] = change['source_reference_ids']
        if entry['measure_id'] == 'o6_9':
            # Input audit O69: the notice consumes parcel location, which may
            # differ from the farm address. No district alias or null coercion.
            for key, title in [('district', 'Politischer Bezirk des Schlages'), ('federal_state', 'Bundesland des Schlages')]:
                node = locate(root, 'land.parcels[].' + key)
                node.clear()
                node.update({'type': 'string', 'maxLength': 2000,
                    'description': title + ' in der amtlichen Schreibweise der Dürre-Mitteilung vom 05.08.2026. Nur bei fehlender Schlagangabe verwendet das Regelwerk die Betriebsregion.',
                    'x-source-reference-ids': ['REF-N0805-02'],
                    'x-contract-origin': 'manual adaptation of audited unmanaged native read'})
        dump(ROOT / 'contracts' / (entry['measure_id'] + '.json'), {
            'schema_version': 1, 'measure_id': entry['measure_id'], 'schema': root,
            'declaration_only': True, 'expert_approved': False,
            'canonical_sha256': hashlib.sha256(basepath.read_bytes()).hexdigest(),
            'profile_changes_sha256': hashlib.sha256(changes_path.read_bytes()).hexdigest(),
            'references': references})


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--candidate', type=Path, required=True)
    build(parser.parse_args().candidate)
