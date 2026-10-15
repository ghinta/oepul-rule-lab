#!/usr/bin/env python3
"""Replay public source-derived probes of one immutable Opus run; no model calls.

Failed source expectations are findings, not a failed replay. --verify checks that
the observed evidence matches observations.json, including failed expectations.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import tempfile

HERE = Path(__file__).resolve().parent
RUN_ID = "v2-o6_1a-opus-5.5-high-20260929"
COMMIT = "e009eed4a83ff076b26eba33ac433ac2b0642621"
BLOCKED = {"http.send", "net.lookup_ip_addr", "time.now_ns", "uuid.rfc4122", "rand.intn", "opa.runtime"}


def encoded(value):
    return (json.dumps(value, ensure_ascii=False, indent=2, sort_keys=True) + "\n").encode()


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def execute(opa, args, cwd, payload=None):
    proc = subprocess.run([str(opa), *args], input=None if payload is None else encoded(payload),
                          stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=cwd, timeout=20, check=False)
    value = {"exit_code": proc.returncode}
    if proc.stdout:
        value["json"] = json.loads(proc.stdout)
    if proc.stderr:
        value["stderr"] = proc.stderr.decode()
    return value


def lookup(value, path):
    for key in path:
        value = value[int(key)] if isinstance(value, list) else value[key]
    return value


def check_expectation(expectation, observed):
    if expectation["operator"] == "status_equals":
        actual = observed["status"]
    elif observed["status"] != "defined":
        return {**expectation, "actual_status": observed["status"], "passed": False}
    else:
        actual = lookup(observed["output"], expectation["path"])
    op = expectation["operator"]
    if op in {"equals", "status_equals"}:
        expected = expectation["expected"]
        same_kind = type(actual) is type(expected) or (
            type(actual) in {int, float} and type(expected) in {int, float}
        )
        passed = same_kind and actual == expected
    elif op == "contains_rule":
        actual = sorted({item["rule_id"] for item in actual})
        passed = expectation["expected"] in actual
    elif op == "excludes_rule":
        actual = sorted({item["rule_id"] for item in actual})
        passed = expectation["expected"] not in actual
    else:
        raise ValueError(f"Unsupported expectation: {op}")
    return {**expectation, "actual": actual, "passed": passed}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--candidate-root", type=Path, required=True)
    parser.add_argument("--opa", type=Path, required=True)
    parser.add_argument("--verify", action="store_true")
    args = parser.parse_args()
    root, opa = args.candidate_root.resolve(), args.opa.resolve()
    binding = json.loads((HERE / "binding.json").read_text())
    assert binding["candidate_commit"] == COMMIT
    assert binding["run_id"] == RUN_ID
    assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip() == COMMIT
    assert digest(opa) == binding["opa_sha256"]
    for item in binding["files"]:
        path = (root / item["path"]).resolve()
        assert path.is_relative_to(root)
        assert path.stat().st_size == item["bytes"] and digest(path) == item["sha256"], item["path"]
    fixture_bytes = (HERE / "development-probes.json").read_bytes()
    fixture = json.loads(fixture_bytes)
    observations = []
    with tempfile.TemporaryDirectory(prefix="opus-o6-1a-audit-") as temporary:
        runtime = Path(temporary)
        cap = execute(opa, ["capabilities", "--current"], runtime)["json"]
        cap["allow_net"] = []
        cap["builtins"] = [b for b in cap["builtins"] if b["name"] not in BLOCKED]
        (runtime / "capabilities.json").write_bytes(encoded(cap))
        for item in binding["files"]:
            if item["kind"] != "executable":
                continue
            relative = item["path"].split("/workspace/", 1)[1]
            target = runtime / "bundle" / relative
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(root / item["path"], target)
            assert digest(target) == item["sha256"]
        load = ["--data", "bundle/policy", "--data", "bundle/data"]
        compiled = execute(opa, ["check", "--strict", "--format=json", "--capabilities", "capabilities.json",
                                 "bundle/policy", "bundle/data"], runtime)
        assert compiled["exit_code"] == 0, compiled
        for case in fixture["cases"]:
            native = execute(opa, ["eval", "--format=json", "--stdin-input", "--strict-builtin-errors",
                                    "--timeout=10s", "--capabilities", "capabilities.json", *load,
                                    case.get("query", fixture["query"])], runtime, case["input"])
            result = native.get("json", {})
            status = "runtime_error" if native["exit_code"] != 0 else ("defined" if result.get("result") else "undefined")
            observed = {"case_id": case["case_id"], "status": status,
                        "input_sha256": hashlib.sha256(encoded(case["input"])).hexdigest()}
            if status == "defined":
                observed["output"] = result["result"][0]["expressions"][0]["value"]
            else:
                observed["native_result"] = result
            if "stderr" in native:
                observed["stderr"] = native["stderr"]
            observed["checks"] = [check_expectation(check, observed) for check in case["expectations"]]
            observations.append(observed)
    result = {"schema_version": 1, "kind": "public-development-source-audit",
              "candidate_commit": COMMIT, "run_id": RUN_ID,
              "binding_sha256": digest(HERE / "binding.json"),
              "fixture_sha256": hashlib.sha256(fixture_bytes).hexdigest(),
              "opa_version": "1.18.2", "compile": "strict_passed", "cases": observations,
              "summary": {"cases": len(observations), "checks": sum(len(o["checks"]) for o in observations),
                          "expectations_met": sum(c["passed"] for o in observations for c in o["checks"])}}
    rendered = encoded(result)
    path = HERE / "observations.json"
    if args.verify:
        assert rendered == path.read_bytes(), "Observed evidence differs; inspect before replacing it."
    else:
        path.write_bytes(rendered)
    print(json.dumps(result["summary"]))
    for observed in observations:
        failed = sum(not c["passed"] for c in observed["checks"])
        print(f"{observed['case_id']}: {observed['status']}, unmet expectations={failed}")


if __name__ == "__main__":
    main()
