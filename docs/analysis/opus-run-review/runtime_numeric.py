#!/usr/bin/env python3
"""Collect numeric comparison evidence; never replace the pinned runtime.

The independent reference is Python Decimal on fixed numeric literal pairs.
This probes the executable, not agricultural rules or model quality.
"""
import argparse
from decimal import Decimal
import hashlib
import json
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent
EXPECTED_SHA = "9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8"
PAIRS = [("1", "10.0"), ("3", "30.0"), ("2", "20.0"), ("5", "50.0"),
         ("1", "100.0"), ("11", "100.0"), ("1", "10"), ("3", "30"),
         ("1", "1.0"), ("10", "10.0"), ("1.5", "10.0"), ("9", "10.0"),
         ("0.3", "0.30"), ("0.05", "0.050"), ("10.0", "1")]
OPS = {"<": lambda a, b: a < b, ">=": lambda a, b: a >= b,
       "==": lambda a, b: a == b, ">": lambda a, b: a > b}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--opa", type=Path, required=True)
    parser.add_argument("--verify", action="store_true")
    args = parser.parse_args()
    opa = args.opa.resolve()
    require(hashlib.sha256(opa.read_bytes()).hexdigest() == EXPECTED_SHA, "OPA hash differs from frozen pin")
    rows = []
    for left, right in PAIRS:
        for op, compare in OPS.items():
            query = f"{left} {op} {right}"
            rows.append({"query": query, "reference": compare(Decimal(left), Decimal(right))})
    query = "[" + ",".join(row["query"] for row in rows) + "]"
    proc = subprocess.run([str(opa), "eval", "--strict-builtin-errors", "--timeout=10s", "--format=json", query],
                          capture_output=True, text=True, timeout=20, check=True)
    native = json.loads(proc.stdout)
    values = native["result"][0]["expressions"][0]["value"]
    for row, observed in zip(rows, values, strict=True):
        require(type(observed) is bool, "Expected a defined native boolean comparison")
        row.update(observed=observed, matches_reference=observed == row["reference"])
    result = {"kind": "pinned-runtime-numeric-diagnostic-not-model-score",
              "family": "SHARED_RUNTIME_NUMERIC", "opa_sha256": EXPECTED_SHA,
              "reference_method": "Exact Python Decimal comparisons of the stated base10 literals; no candidate policy or generated selftest supplies an expected value.",
              "version": subprocess.check_output([str(opa), "version"], text=True).splitlines(),
              "cases": rows, "checks": len(rows),
              "mismatches": sum(not r["matches_reference"] for r in rows),
              "limits": "These are selected executable comparisons, not a complete runtime test or a count of affected rules/runs. Rego cross-type ordering for null/false is a separate input-guard issue. No binary, policy, data or pin is changed."}
    rendered = (json.dumps(result, ensure_ascii=False, sort_keys=True, indent=2) + "\n").encode()
    path = HERE / "runtime-numeric.json"
    if args.verify:
        require(rendered == path.read_bytes(), "Recorded runtime comparison evidence differs")
    else:
        path.write_bytes(rendered)
    print(json.dumps({"checks": result["checks"], "mismatches": result["mismatches"]}))


if __name__ == "__main__":
    main()
