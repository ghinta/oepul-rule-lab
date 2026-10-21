#!/usr/bin/env python3
"""Replay explicit source-component regressions; never changes historical runs.

Full audit replay is diagnostic: its unresolved interpretations and intentional
invalid inputs are not approval labels. Only reviewed regressions gate CI.
"""
from __future__ import annotations
import argparse
from concurrent.futures import ThreadPoolExecutor
import hashlib
import json
from pathlib import Path
import subprocess
from export import rewrite

ROOT = Path(__file__).resolve().parents[1]


def equal(a, b):
    if type(a) in (int, float) and type(b) in (int, float):
        return a == b
    if type(a) is not type(b):
        return False
    if isinstance(a, dict):
        return a.keys() == b.keys() and all(equal(a[k], b[k]) for k in a)
    if isinstance(a, list):
        return len(a) == len(b) and all(equal(x, y) for x, y in zip(a, b))
    return a == b


def check(expectation, observed):
    op, expected = expectation['operator'], expectation['expected']
    if op == 'status_equals':
        actual = observed['status']
    else:
        if observed['status'] != 'defined':
            return {**expectation, 'passed': False, 'actual_status': observed['status']}
        actual = observed['output']
        try:
            for part in expectation['path']:
                actual = actual[part]
        except (KeyError, IndexError, TypeError):
            return {**expectation, 'passed': False, 'actual_absent': True}
    if op in ('equals', 'status_equals'):
        passed = equal(actual, expected)
    elif op in ('contains_rule', 'excludes_rule'):
        if not isinstance(actual, list) or not all(isinstance(x, dict) and 'rule_id' in x for x in actual):
            return {**expectation, 'passed': False, 'invalid_rule_collection': True}
        actual = sorted({x['rule_id'] for x in actual})
        passed = (expected in actual) == (op == 'contains_rule')
    else:
        raise ValueError(f'Unsupported operator: {op}')
    return {**expectation, 'actual': actual, 'passed': passed}


def evaluate(opa, root, measure, fixture, case, bundle=None):
    command = [opa, 'eval', '--format=json', '--stdin-input', '--strict-builtin-errors',
               '--timeout=10s', '-d', str(root / measure / 'policy'),
               '-d', str(root / measure / 'data'), case.get('query', fixture['query'])]
    if bundle:
        command = [opa, 'eval', '--format=json', '--stdin-input', '--strict-builtin-errors',
                   '--timeout=10s', '-d', str(bundle), rewrite(case.get('query', fixture['query']), measure)]
    try:
        result = subprocess.run(command, input=json.dumps(case['input']), text=True,
                                capture_output=True, timeout=20, check=False)
        native = json.loads(result.stdout)
        if result.returncode:
            observed = {'status': 'runtime_error', 'errors': native.get('errors', []), 'stderr': result.stderr}
        elif not native.get('result'):
            observed = {'status': 'undefined'}
        else:
            observed = {'status': 'defined', 'output': native['result'][0]['expressions'][0]['value']}
    except subprocess.TimeoutExpired:
        observed = {'status': 'timeout'}
    checks = [check(e, observed) for e in case['expectations']]
    return {'case_id': case['case_id'], **observed, 'checks': checks,
            'passed': all(c['passed'] for c in checks)}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--opa', required=True)
    parser.add_argument('--root', type=Path, default=ROOT)
    parser.add_argument('--fixtures', type=Path, default=ROOT / 'tests')
    parser.add_argument('--measure', action='append')
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--jobs', type=int, default=4)
    parser.add_argument('--bundle', type=Path)
    parser.add_argument('--diagnostic', action='store_true')
    args = parser.parse_args()
    fixtures = sorted(args.fixtures.glob('*/development-probes.json'))
    fixtures += sorted(args.fixtures.glob('*.json'))
    reports = []
    for path in fixtures:
        fixture = json.loads(path.read_text())
        measure = fixture.get('measure_id', path.parent.name)
        if args.measure and measure not in args.measure:
            continue
        if not (args.root / measure / 'policy').exists() or 'cases' not in fixture:
            continue
        with ThreadPoolExecutor(max_workers=args.jobs) as pool:
            cases = list(pool.map(lambda c: evaluate(args.opa, args.root, measure, fixture, c, args.bundle), fixture['cases']))
        failed = sum(not c['passed'] for c in cases)
        reports.append({'measure_id': measure, 'fixture_sha256': hashlib.sha256(path.read_bytes()).hexdigest(),
                        'count': len(cases), 'failed': failed, 'cases': cases})
        print(f'{measure}: {len(cases)-failed}/{len(cases)} expectation sets met', flush=True)
    if not reports:
        raise SystemExit('No fixtures selected')
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps({'kind': 'development-regression-replay', 'expert_approved': False,
                                      'opa_sha256': hashlib.sha256(Path(args.opa).read_bytes()).hexdigest(),
                                      'measures': reports}, indent=2, ensure_ascii=False)+'\n')
    if any(r['failed'] for r in reports) and not args.diagnostic:
        raise SystemExit(1)


if __name__ == '__main__':
    main()
