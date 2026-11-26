"""Offline #115 tests. The child copies stdin and never calls a provider."""
import hashlib
import io
import tempfile
import unittest
from contextlib import redirect_stderr, redirect_stdout
from pathlib import Path
from unittest.mock import patch

from rulelab import cli


class CampaignPromptTests(unittest.TestCase):
    def setUp(self):
        temp = tempfile.TemporaryDirectory()
        self.addCleanup(temp.cleanup)
        self.root = Path(temp.name)
        self.run = self.root / "v3-o6_2-astra-6.2-high-20261120"
        for directory in ("workspace/tools", "workspace/rules", "raw", "artifacts"):
            (self.run / directory).mkdir(parents=True, exist_ok=True)
        receiver = self.root / "fake-codex"
        receiver.write_text("#!/bin/sh\ncat > received.bin\n")
        receiver.chmod(0o755)
        config = {"adapter": "codex-cli", "model": "gpt-6.2-astra", "reasoning_effort": "high",
                  "executable": str(receiver)}
        cli.write_json(self.run / "model.json", config)
        cli.write_json(self.run / "run.json", {
            "contract_version": "1.0", "run_id": self.run.name, "status": "prepared",
            "created_at": "fixture", "measure": "o6_2", "mode": "discover",
            "model": config, "profile": {}, "sources": [],
        })
        (self.run / "prompt.md").write_bytes("Prüfe die Belege.\r\n".encode())
        (self.run / "workspace/AGENTS.md").write_text("Mindestens 50 % im Fünf-Stunden-Fenster.")
        (self.run / "baseline_profile.json").write_text("{}")
        (self.run / "workspace/canonical_farm_profile.json").write_text("{}")
        self.enterContext(patch.object(cli.CodexRateLimitClient, "__enter__"))
        self.probe = self.enterContext(patch.object(cli.CodexRateLimitClient, "request"))
        self.enterContext(patch.object(cli, "stage_workspace_opa", return_value={}))
        self.enterContext(redirect_stdout(io.StringIO()))
        self.enterContext(redirect_stderr(io.StringIO()))

    def budget(self, used, minutes=10080):
        self.probe.return_value = {"rateLimits": {"secondary": {
            "windowDurationMins": minutes, "usedPercent": used}}}

    def launch(self, *extra, source=None):
        return cli.main(["run", str(source or self.run), "--codex-usage-window", "weekly", *extra])

    @staticmethod
    def snapshot(run):
        return {p.relative_to(run): cli.sha256(p) for p in run.rglob("*") if p.is_file()}

    def test_actual_stdin_is_bound_to_the_preflight_and_prepared_prompt(self):
        before = self.snapshot(self.run)
        self.budget(95)
        self.assertEqual(self.launch(), 0)
        meta = cli.read_json(self.run / "run.json")
        rec = cli.read_json(self.run / meta["prompt_record"]["path"])
        for entry in (meta["prompt_record"], *(rec[k] for k in ("prepared", "amendment", "effective", "instructions"))):
            path = self.run / entry["path"]
            self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), entry["sha256"])
            self.assertEqual(path.stat().st_size, entry["bytes"])
        received = (self.run / "workspace/received.bin").read_bytes()
        prepared = (self.run / rec["prepared"]["path"]).read_bytes()
        amendment = (self.run / rec["amendment"]["path"]).read_bytes()
        self.assertEqual(before[Path("prompt.md")], rec["prepared"]["sha256"])
        self.assertEqual(received, prepared + amendment)
        self.assertEqual(received, (self.run / rec["effective"]["path"]).read_bytes())
        self.assertEqual(rec["usage_guard"]["start_remaining_percent"], 5)
        self.assertEqual(rec["usage_guard"]["minimum_start_remaining_percent"], 5)
        self.assertIn("2026-11-26", rec["authorization"])
        for detail in ("#115", "10080 Minuten", "5.0 % Restbudget", "Start ab 5 %", "höchstens 5 %"):
            self.assertIn(detail, amendment.decode())
        self.assertEqual(meta["status"], "generated")
        self.assertEqual(cli.main(["finalize", str(self.run)]), 1)
        self.assertEqual(cli.read_json(self.run / "run.json")["status"], "failed")
        self.assertTrue((self.run / "artifacts/grounding-validation.json").is_file())

    def test_blocked_preflight_has_no_effective_prompt_or_process(self):
        self.budget(95.01)
        self.assertEqual(self.launch(), 75)
        self.assertFalse((self.run / "workspace/received.bin").exists())
        self.assertFalse(list(self.run.rglob("effective.md")))
        meta = cli.read_json(self.run / "run.json")
        self.assertNotIn("prompt_record", meta)
        self.assertIn("4.99% is below the required 5%", meta["usage_guard"]["reason"])

    def test_provider_denial_has_no_prompt_and_no_process(self):
        self.budget(2)
        self.probe.return_value["ordinaryUsageAllowed"] = False
        self.assertEqual(self.launch(), 75)
        self.assertFalse((self.run / "workspace/received.bin").exists())
        self.assertFalse(list(self.run.rglob("effective.md")))

    def test_stopped_generator_keeps_the_prompt_and_its_original_start_value(self):
        (self.root / "fake-codex").write_text("#!/bin/sh\ncat > received.bin\nexec sleep 30\n")
        self.probe.side_effect = [
            {"rateLimits": {"primary": {"windowDurationMins": 10080, "usedPercent": used}}}
            for used in (6, 95)
        ]
        with patch.object(cli, "USAGE_POLL_SECONDS", 0.2):
            self.assertEqual(self.launch(), 75)
        run_meta = cli.read_json(self.run / "run.json")
        self.assertEqual(run_meta["status"], "aborted_usage_guard")
        self.assertEqual(run_meta["usage_guard"]["last_remaining_percent"], 5)
        guard = cli.read_json(self.run / run_meta["prompt_record"]["path"])["usage_guard"]
        self.assertEqual(guard["start_remaining_percent"], 94)
        self.assertNotIn("last_remaining_percent", guard)

    def test_legacy_attempt_survives_refusal_blocked_fork_and_retry(self):
        meta = cli.read_json(self.run / "run.json")
        meta.update(status="failed", generation_attempt=1, generator_exit_code=0, finalized_at="old")
        cli.write_json(self.run / "run.json", meta)
        (self.run / "workspace/rules/partial.json").write_text("{}")
        (self.run / "raw/events.jsonl").write_text("original events\n")
        (self.run / "artifacts/metrics.json").write_text('{"required_outputs_missing":["rego_tests"]}')
        original = self.snapshot(self.run)
        with self.assertRaises(SystemExit):
            self.launch()
        self.probe.assert_not_called()
        self.assertEqual(original, self.snapshot(self.run))
        first, second = self.root / "first", self.root / "second"
        first.mkdir()
        second.mkdir()
        self.budget(96)
        self.assertEqual(self.launch("--attempt-root", str(first)), 75)
        blocked = first / self.run.name
        rejection = self.snapshot(blocked)
        self.budget(76.25)
        self.assertEqual(self.launch("--attempt-root", str(second), source=blocked), 0)
        child = second / self.run.name
        record = cli.read_json(child / "raw/prompts/2/record.json")
        self.assertEqual(record["usage_guard"]["start_remaining_percent"], 23.75)
        self.assertIn("vorhandenen Workspace", (child / "workspace/received.bin").read_text())
        self.assertEqual(cli.sha256(child / "raw/parent-run.json"), rejection[Path("run.json")])
        self.assertEqual(cli.sha256(blocked / "raw/parent-run.json"), original[Path("run.json")])
        self.assertTrue((child / "workspace/rules/partial.json").exists())
        self.assertFalse((child / "artifacts/metrics.json").exists())
        self.assertNotIn("finalized_at", cli.read_json(child / "run.json"))
        with self.assertRaises(SystemExit):
            self.launch("--attempt-root", str(second), source=blocked)
        self.assertEqual(original, self.snapshot(self.run))
        self.assertEqual(rejection, self.snapshot(blocked))

    def test_default_and_other_explicit_weekly_jobs_get_no_campaign_amendment(self):
        for window, minutes in (("five-hour", 300), ("weekly", 10080)):
            with self.subTest(window=window):
                other = self.root / window
                self.run.rename(other)
                meta = cli.read_json(other / "run.json")
                meta["run_id"] = other.name
                cli.write_json(other / "run.json", meta)
                self.budget(12, minutes)
                args = ["--codex-usage-window", window] if window == "weekly" else []
                self.assertEqual(cli.main(["run", str(other), *args]), 0)
                self.assertEqual((other / "workspace/received.bin").read_bytes(), (other / "prompt.md").read_text().encode())
                self.assertFalse(list(other.rglob("record.json")))
                other.rename(self.run)

    def test_mismatched_identity_is_rejected_and_dry_run_is_read_only(self):
        original = self.snapshot(self.run)
        self.assertEqual(self.launch("--dry-run", "--attempt-root", str(self.root / "preview")), 0)
        self.assertFalse((self.root / "preview").exists())
        self.assertEqual(original, self.snapshot(self.run))
        meta = cli.read_json(self.run / "run.json")
        meta["measure"] = "o6_14"
        cli.write_json(self.run / "run.json", meta)
        with self.assertRaises(SystemExit):
            self.launch()
        self.probe.assert_not_called()
