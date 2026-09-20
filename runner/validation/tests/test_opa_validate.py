from __future__ import annotations

import json
import os
import subprocess
import sys
import tempfile
import textwrap
import unittest
from pathlib import Path


VALIDATION_DIR = Path(__file__).resolve().parents[1]
RUNNER = VALIDATION_DIR / "opa_validate.py"


FAKE_OPA = """\
#!/usr/bin/env python3
import pathlib
import sys


def files(paths):
    for raw in paths:
        path = pathlib.Path(raw)
        if path.is_file():
            yield path
        elif path.is_dir():
            yield from path.rglob("*.rego")


command, *args = sys.argv[1:]
if command == "version":
    print("Version: 1.18.2")
    print("Rego Version: v1")
elif command == "fmt":
    text = pathlib.Path(args[0]).read_text(encoding="utf-8")
    print(text.replace("package  ", "package "), end="")
elif command == "check":
    targets = [arg for arg in args if arg != "--strict"]
    if any("STRICT_FAIL" in path.read_text(encoding="utf-8") for path in files(targets)):
        print("strict check failed", file=sys.stderr)
        sys.exit(1)
elif command == "test":
    if any("TEST_FAIL" in path.read_text(encoding="utf-8") for path in files(args)):
        print("test failed", file=sys.stderr)
        sys.exit(2)
    print("PASS: 1/1")
else:
    print(f"unsupported fake command: {command}", file=sys.stderr)
    sys.exit(2)
"""


class OpaValidateTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory()
        self.root = Path(self.temporary.name)
        self.workspace = self.root / "run"
        self.workspace.mkdir()
        self.fake_opa = self.root / "opa"
        self.fake_opa.write_text(FAKE_OPA, encoding="utf-8")
        self.fake_opa.chmod(0o755)

    def tearDown(self) -> None:
        self.temporary.cleanup()

    def write_rego(self, name: str, content: str) -> Path:
        path = self.workspace / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(textwrap.dedent(content), encoding="utf-8")
        return path

    def invoke(self, command: str, *extra: str) -> tuple[subprocess.CompletedProcess[str], dict]:
        completed = subprocess.run(
            [
                sys.executable,
                str(RUNNER),
                command,
                "--workspace",
                str(self.workspace),
                "--runtime",
                "local",
                "--opa-bin",
                str(self.fake_opa),
                *extra,
            ],
            capture_output=True,
            text=True,
            encoding="utf-8",
            check=False,
        )
        return completed, json.loads(completed.stdout)

    def test_validate_passes_and_writes_machine_result(self) -> None:
        self.write_rego("policy.rego", "package generated\n")
        result_path = self.root / "results" / "validation.json"

        completed, result = self.invoke(
            "validate", "--result-json", str(result_path)
        )

        self.assertEqual(0, completed.returncode)
        self.assertEqual("passed", result["status"])
        self.assertEqual(0, result["exit_code"])
        self.assertEqual({"version", "fmt", "check", "test"}, set(result["stages"]))
        self.assertEqual(result, json.loads(result_path.read_text(encoding="utf-8")))

    def test_auto_runtime_prefers_workspace_opa(self) -> None:
        self.write_rego("policy.rego", "package generated\n")
        tools = self.workspace / "tools"
        tools.mkdir()
        workspace_opa = tools / "opa"
        workspace_opa.write_text(FAKE_OPA, encoding="utf-8")
        workspace_opa.chmod(0o755)

        completed = subprocess.run(
            [
                sys.executable,
                str(RUNNER),
                "validate",
                "--workspace",
                str(self.workspace),
            ],
            capture_output=True,
            text=True,
            encoding="utf-8",
            check=False,
        )
        result = json.loads(completed.stdout)

        self.assertEqual(0, completed.returncode)
        self.assertEqual("passed", result["status"])
        self.assertEqual("local", result["opa"]["runtime"])
        self.assertEqual(str(workspace_opa.resolve()), result["opa"]["binary"])

    def test_environment_can_force_local_runtime(self) -> None:
        self.write_rego("policy.rego", "package generated\n")
        tools = self.workspace / "tools"
        tools.mkdir()
        workspace_opa = tools / "opa"
        workspace_opa.write_text(FAKE_OPA, encoding="utf-8")
        workspace_opa.chmod(0o755)

        environment = os.environ.copy()
        environment["OPA_RUNTIME"] = "local"
        environment["OPA_BIN"] = str(workspace_opa)
        completed = subprocess.run(
            [
                sys.executable,
                str(RUNNER),
                "validate",
                "--workspace",
                str(self.workspace),
            ],
            capture_output=True,
            text=True,
            encoding="utf-8",
            check=False,
            env=environment,
        )
        result = json.loads(completed.stdout)

        self.assertEqual(0, completed.returncode)
        self.assertEqual("local", result["opa"]["runtime"])
        self.assertEqual(str(workspace_opa.resolve()), result["opa"]["binary"])

    def test_unformatted_file_fails_without_mutating_workspace(self) -> None:
        path = self.write_rego("policy.rego", "package  generated\n")

        completed, result = self.invoke("fmt")

        self.assertEqual(1, completed.returncode)
        self.assertEqual("failed", result["status"])
        self.assertEqual(1, result["exit_code"])
        self.assertEqual(["policy.rego"], result["stages"]["fmt"]["unformatted_files"])
        self.assertEqual("package  generated\n", path.read_text(encoding="utf-8"))

    def test_write_format_repairs_only_rego_formatting(self) -> None:
        path = self.write_rego("policy.rego", "package  generated\n")

        completed, result = self.invoke("fmt", "--write")

        self.assertEqual(0, completed.returncode)
        self.assertEqual("passed", result["status"])
        self.assertEqual(["policy.rego"], result["stages"]["fmt"]["formatted_files"])
        self.assertEqual("package generated\n", path.read_text(encoding="utf-8"))

    def test_strict_check_failure_is_machine_readable(self) -> None:
        self.write_rego("policy.rego", "package generated\n# STRICT_FAIL\n")

        completed, result = self.invoke("check")

        self.assertEqual(1, completed.returncode)
        self.assertEqual("failed", result["status"])
        self.assertEqual(1, result["stages"]["check"]["execution"]["returncode"])
        self.assertIn("strict check failed", result["stages"]["check"]["execution"]["stderr"])

    def test_opa_test_failure_is_machine_readable(self) -> None:
        self.write_rego("policy_test.rego", "package generated\n# TEST_FAIL\n")

        completed, result = self.invoke("test")

        self.assertEqual(1, completed.returncode)
        self.assertEqual("failed", result["status"])
        self.assertEqual(2, result["stages"]["test"]["execution"]["returncode"])

    def test_version_mismatch_stops_validation(self) -> None:
        self.write_rego("policy.rego", "package generated\n")

        completed, result = self.invoke("validate", "--opa-version", "9.9.9")

        self.assertEqual(1, completed.returncode)
        self.assertEqual("failed", result["status"])
        self.assertEqual("failed", result["stages"]["version"]["status"])
        self.assertNotIn("fmt", result["stages"])

    def test_target_may_not_escape_run_workspace(self) -> None:
        self.write_rego("policy.rego", "package generated\n")

        completed, result = self.invoke("validate", "--target", "../outside")

        self.assertEqual(2, completed.returncode)
        self.assertEqual("error", result["status"])
        self.assertEqual(2, result["exit_code"])
        self.assertIn("escapes workspace", result["error"])

    def test_rego_symlink_may_not_escape_run_workspace(self) -> None:
        outside = self.root / "outside.rego"
        outside.write_text("package outside\n", encoding="utf-8")
        (self.workspace / "linked.rego").symlink_to(outside)

        completed, result = self.invoke("validate")

        self.assertEqual(2, completed.returncode)
        self.assertEqual("error", result["status"])
        self.assertIn("resolves outside workspace", result["error"])

    def test_repeatable_targets_are_deduplicated(self) -> None:
        self.write_rego("policies/policy.rego", "package generated\n")

        completed, result = self.invoke(
            "validate", "--target", "policies", "--target", "policies"
        )

        self.assertEqual(0, completed.returncode)
        self.assertEqual(["policies"], result["targets"])
        self.assertEqual(["policies/policy.rego"], result["rego_files"])


if __name__ == "__main__":
    unittest.main(verbosity=2)
