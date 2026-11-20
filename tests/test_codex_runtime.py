"""Runtime mount boundaries and pipe handling; no model calls or credentials."""

import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

SOURCE = Path(__file__).resolve().parents[1] / "tools/codex_runtime/runtime.py"
spec = importlib.util.spec_from_file_location("rulelab_codex_runtime", SOURCE)
runtime = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runtime)


class RuntimeTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.run = self.root / "runs/fixture-astra"
        self.workspace = self.run / "workspace"
        for name in ("sources", "contracts", "tools"):
            (self.workspace / name).mkdir(parents=True)
        (self.workspace / "canonical_farm_profile.json").write_text("{}")
        (self.workspace / "AGENTS.md").write_text("Fixture only")
        (self.run / "raw").mkdir()
        (self.run / "run.json").write_text(json.dumps({"run_id": self.run.name}))
        (self.run / "model.json").write_text(json.dumps({"adapter": "codex-cli", "model": "gpt-6.2-astra"}))
        self.config = {"runs_root": str(self.root / "runs"), "image_id": "sha256:fixture",
                       "seccomp_sha256": "fixture"}
        self.args = ["exec", "--cd", str(self.workspace), "--model", "gpt-6.2-astra",
                     "--sandbox", "workspace-write", "--output-last-message",
                     str(self.run / "raw/final-message.md"), "-"]

    def test_only_one_run_is_mounted_and_fixed_inputs_are_read_only(self):
        mounts, command = runtime.bind_run(self.args, self.config)
        self.assertIn(f"type=bind,src={self.run},dst={self.run}", mounts)
        for name in ("sources", "canonical_farm_profile.json", "AGENTS.md", "contracts", "tools"):
            path = self.workspace / name
            self.assertIn(f"type=bind,src={path},dst={path},readonly", mounts)
        self.assertEqual(command[-1], "-")
        self.assertIn('web_search="disabled"', command)
        proof = json.loads((self.run / "raw/runner-environment.json").read_text())
        self.assertFalse(proof["docker_socket_exposed_to_generator"])
        self.assertEqual(proof["native_sandbox"], "workspace-write")

    def test_outside_run_and_output_are_rejected(self):
        for field, replacement in (("--cd", str(self.root / "other/workspace")),
                                   ("--output-last-message", str(self.root / "outside"))):
            with self.subTest(field=field):
                args = list(self.args)
                args[args.index(field) + 1] = replacement
                with self.assertRaises(ValueError):
                    runtime.bind_run(args, self.config)

    def test_model_mismatch_and_sandbox_bypass_are_rejected(self):
        for flag, value in (("--model", "other-model"), ("--sandbox", "danger-full-access")):
            args = list(self.args)
            args[args.index(flag) + 1] = value
            with self.assertRaises(ValueError):
                runtime.bind_run(args, self.config)
        with self.assertRaises(ValueError):
            runtime.bind_run(self.args + ["--dangerously-bypass-approvals-and-sandbox"], self.config)

    def test_symlinked_input_and_output_are_rejected(self):
        path = self.workspace / "canonical_farm_profile.json"
        path.unlink()
        path.symlink_to(self.root / "not-an-input")
        with self.assertRaises(ValueError):
            runtime.bind_run(self.args, self.config)
        path.unlink()
        path.write_text("{}")
        (self.run / "raw/final-message.md").symlink_to(self.root / "outside")
        with self.assertRaises(ValueError):
            runtime.bind_run(self.args, self.config)

    def test_batched_rpc_responses_are_read_without_waiting_for_process_exit(self):
        source = """import sys,os,json
for _ in range(3): sys.stdin.buffer.readline()
rows=[{'id':1,'result':{}},{'id':2,'result':{'account':None}}]
os.write(1, b''.join((json.dumps(row)+'\\n').encode() for row in rows))
sys.stdin.buffer.read()
"""
        process = subprocess.Popen([sys.executable, "-c", source], stdin=subprocess.PIPE,
                                   stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, bufsize=0)
        try:
            with patch.object(runtime.subprocess, "Popen", return_value=process):
                results = runtime.rpc(self.config, [("account/read", {})], offline=True)
            self.assertEqual(set(results), {1, 2})
            self.assertEqual(process.returncode, 0)
        finally:
            if process.poll() is None:
                process.kill()
                process.wait()
            process.stdout.close()


if __name__ == "__main__":
    unittest.main()
