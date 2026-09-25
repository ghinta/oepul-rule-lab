from __future__ import annotations

import argparse
import io
import json
import os
import sys
import tempfile
import unittest
from contextlib import redirect_stdout
from pathlib import Path
from unittest.mock import patch

from rulelab import cli


class OpaValidationConfigurationTests(unittest.TestCase):
    def test_generated_data_is_loaded_during_validation(self) -> None:
        self.assertEqual(cli.OPA_VALIDATION_TARGETS, ("policy", "data", "tests"))


class OpaBootstrapTests(unittest.TestCase):
    def test_platform_key_normalizes_supported_architectures(self) -> None:
        with (
            patch.object(cli.platform, "system", return_value="Darwin"),
            patch.object(cli.platform, "machine", return_value="arm64"),
        ):
            self.assertEqual(cli.opa_platform_key(), "darwin-arm64")
        with (
            patch.object(cli.platform, "system", return_value="Linux"),
            patch.object(cli.platform, "machine", return_value="x86_64"),
        ):
            self.assertEqual(cli.opa_platform_key(), "linux-amd64")

    def test_matching_opa_bin_is_copied_into_workspace(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            workspace = root / "workspace"
            tools = workspace / "tools"
            tools.mkdir(parents=True)
            (tools / "opa-version.txt").write_text("1.18.2\n", encoding="utf-8")
            source = root / "opa"
            source.write_text(
                "#!/bin/sh\nprintf 'Version: 1.18.2\\nRego Version: v1\\n'\n",
                encoding="utf-8",
            )
            source.chmod(0o755)

            with patch.dict(os.environ, {"OPA_BIN": str(source)}):
                metadata = cli.stage_workspace_opa(
                    workspace, cache_root=root / "cache"
                )

            destination = tools / "opa"
            self.assertTrue(destination.is_file())
            self.assertTrue(os.access(destination, os.X_OK))
            self.assertEqual(metadata["version"], "1.18.2")
            self.assertEqual(metadata["source"], "OPA_BIN")
            self.assertTrue(metadata["self_test_available"])
            cli.verify_opa_binary(destination, "1.18.2")

    def test_generator_environment_exposes_workspace_opa_without_docker(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            workspace = Path(directory) / "workspace"
            tools = workspace / "tools"
            tools.mkdir(parents=True)
            environment = cli.generator_environment(workspace)

            self.assertEqual(environment["OPA_RUNTIME"], "local")
            self.assertEqual(environment["OPA_BIN"], str((tools / "opa").resolve()))
            self.assertEqual(environment["RULELAB_OPA_BIN"], "tools/opa")
            self.assertEqual(environment["PATH"].split(os.pathsep)[0], str(tools.resolve()))


class ProfileDiffTests(unittest.TestCase):
    def test_reports_added_removed_and_changed_paths(self) -> None:
        before = {"farm": {"year": "int", "old": "string"}, "parcels": [{"id": "string"}]}
        after = {"farm": {"year": "int|null", "new": "boolean"}, "parcels": [{"id": "string"}]}

        result = cli.profile_diff(before, after)

        self.assertEqual(result["added"], {"farm.new": "boolean"})
        self.assertEqual(result["removed"], {"farm.old": "string"})
        self.assertEqual(
            result["changed"],
            {"farm.year": {"before": "int", "after": "int|null"}},
        )


class RegoScanTests(unittest.TestCase):
    def test_collects_dotted_and_bracket_input_paths(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            policy = Path(directory) / "policy.rego"
            policy.write_text(
                'package test\nallow if input.farm.year >= 2026\nx := input["land"]\n',
                encoding="utf-8",
            )
            self.assertEqual(
                cli.rego_input_paths([policy]),
                ["input.farm.year", "input.land"],
            )

    def test_collects_nested_object_get_and_collection_alias_paths(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            policy = Path(directory) / "policy.rego"
            policy.write_text(
                """package test
land := object.get(input, "land", {})
parcels := object.get(land, "parcels", [])
eligible := [p | p := parcels[_]; object.get(p, "area_ha", 0) > 1]
allow if {
  p := eligible[_]
  p.crop.name == "Wheat"
}
""",
                encoding="utf-8",
            )

            paths = cli.rego_input_paths([policy])

            self.assertIn("input.land", paths)
            self.assertIn("input.land.parcels", paths)
            self.assertIn("input.land.parcels[].area_ha", paths)
            self.assertIn("input.land.parcels[].crop.name", paths)

    def test_rejects_rego_paths_absent_from_proposed_profile(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            policy = Path(directory) / "policy.rego"
            policy.write_text(
                "package test\nallow if input.farm.invented == true\n",
                encoding="utf-8",
            )

            paths, unknown = cli.validate_rego_profile_paths(
                [policy], {"farm": {"year": "int"}}
            )

            self.assertEqual(paths, ["input.farm.invented"])
            self.assertEqual(unknown, ["input.farm.invented"])


class CodexCommandTests(unittest.TestCase):
    def test_codex_command_uses_explicit_sandbox_without_auto_approval(self) -> None:
        command = cli.codex_command(
            {
                "model": "test-model",
                "executable": "codex",
                "reasoning_effort": "high",
            },
            Path("/tmp/example-run"),
        )

        self.assertIn("workspace-write", command)
        self.assertNotIn("--approve-for-me", command)
        self.assertIn('model_reasoning_effort="high"', command)

    def test_raw_attempts_are_rotated_without_overwriting_history(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            raw = Path(directory)
            (raw / "events.attempt-1.jsonl").write_text("old\n", encoding="utf-8")
            (raw / "events.jsonl").write_text("current\n", encoding="utf-8")
            (raw / "stderr.log").write_text("warning\n", encoding="utf-8")

            attempt = cli.prepare_raw_attempt(raw)

            self.assertEqual(attempt, 3)
            self.assertEqual(
                (raw / "events.attempt-2.jsonl").read_text(encoding="utf-8"),
                "current\n",
            )
            self.assertEqual(
                (raw / "stderr.attempt-2.log").read_text(encoding="utf-8"),
                "warning\n",
            )


class UsageGuardTests(unittest.TestCase):
    def test_uses_lowest_remaining_window_across_rate_limit_buckets(self) -> None:
        remaining = cli.rate_limit_remaining_percent(
            {
                "rateLimitsByLimitId": {
                    "codex": {
                        "primary": {"usedPercent": 25},
                        "secondary": {"usedPercent": 75},
                    },
                    "codex_other": {"primary": {"usedPercent": 60}},
                }
            }
        )

        self.assertEqual(remaining, 25.0)

    def test_rejects_missing_rate_limit_windows(self) -> None:
        with self.assertRaises(cli.UsageGuardError):
            cli.rate_limit_remaining_percent({"rateLimits": {}})

    def test_claude_uses_lowest_remaining_unified_window(self) -> None:
        remaining = cli.claude_rate_limit_remaining_percent(
            {
                "status": "allowed",
                "unifiedWindows": {
                    "five_hour": {"utilization": 0.76},
                    "seven_day": {"utilization": 0.09},
                },
            }
        )

        self.assertAlmostEqual(remaining, 24.0)

    def test_claude_rejected_status_means_no_remaining_quota(self) -> None:
        remaining = cli.claude_rate_limit_remaining_percent(
            {
                "status": "rejected",
                "unifiedWindows": {"five_hour": {"utilization": 0.2}},
            }
        )

        self.assertEqual(remaining, 0.0)

    def test_claude_rejects_missing_unified_windows(self) -> None:
        with self.assertRaises(cli.UsageGuardError):
            cli.claude_rate_limit_remaining_percent({"status": "allowed"})


class ClaudeAdapterTests(unittest.TestCase):
    CONFIG = {
        "adapter": "claude-cli",
        "model": "claude-opus-5-5",
        "executable": "claude",
        "reasoning_effort": "high",
        "args": [],
    }

    def test_claude_command_confines_tools_without_bypassing_permissions(
        self,
    ) -> None:
        command = cli.claude_command(self.CONFIG, "session-1")

        self.assertEqual(command[:2], ["claude", "-p"])
        self.assertIn("claude-opus-5-5", command)
        self.assertEqual(command[command.index("--effort") + 1], "high")
        self.assertEqual(command[command.index("--permission-mode") + 1], "acceptEdits")
        self.assertEqual(command[command.index("--permission-prompts") + 1], "none")
        self.assertEqual(command[command.index("--session-id") + 1], "session-1")
        self.assertNotIn("--dangerously-skip-permissions", command)
        self.assertIn("WebFetch", command[command.index("--disallowedTools") + 1])
        self.assertIn("--strict-mcp-config", command)

    def test_claude_resume_command_reuses_the_recorded_session(self) -> None:
        command = cli.claude_command(self.CONFIG, "session-1", resume=True)

        self.assertEqual(command[command.index("--resume") + 1], "session-1")
        self.assertNotIn("--session-id", command)

    def test_claude_environment_detaches_host_session(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            token = Path(directory) / "token"
            token.write_text("secret-token\n", encoding="utf-8")
            environment = cli.claude_environment(
                {
                    "PATH": "/bin",
                    "OPA_BIN": "tools/opa",
                    "CLAUDECODE": "1",
                    "CLAUDE_CODE_SESSION_ID": "host",
                    "MAX_THINKING_TOKENS": "1",
                    "GH_TOKEN": "forge",
                    cli.CLAUDE_TOKEN_FILE_ENV: str(token),
                }
            )

        self.assertEqual(environment["PATH"], "/bin")
        self.assertEqual(environment["OPA_BIN"], "tools/opa")
        self.assertEqual(environment["CLAUDE_CODE_OAUTH_TOKEN"], "secret-token")
        for removed in (
            "CLAUDECODE",
            "CLAUDE_CODE_SESSION_ID",
            "MAX_THINKING_TOKENS",
            "GH_TOKEN",
            cli.CLAUDE_TOKEN_FILE_ENV,
        ):
            self.assertNotIn(removed, environment)

    def test_result_summary_reads_final_stream_event(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            events = Path(directory) / "events.jsonl"
            events.write_text(
                "\n".join(
                    [
                        json.dumps({"type": "system", "subtype": "init"}),
                        "not json",
                        json.dumps(
                            {
                                "type": "result",
                                "subtype": "success",
                                "num_turns": 3,
                                "total_cost_usd": 1.5,
                                "result": "done",
                                "session_id": "ignored",
                            }
                        ),
                    ]
                ),
                encoding="utf-8",
            )

            summary = cli.claude_result_summary(events)

        self.assertEqual(
            summary,
            {"subtype": "success", "num_turns": 3, "total_cost_usd": 1.5, "result": "done"},
        )

    def _prepared_run(self, root: Path, script: str) -> Path:
        run = root / "runs" / "claude-run"
        (run / "workspace" / "tools").mkdir(parents=True)
        (run / "raw").mkdir()
        executable = root / "fake-claude"
        executable.write_text(f"#!{sys.executable}\n{script}", encoding="utf-8")
        executable.chmod(0o755)
        (run / "model.json").write_text(
            json.dumps({**self.CONFIG, "executable": str(executable)}),
            encoding="utf-8",
        )
        (run / "run.json").write_text(
            json.dumps({"run_id": "claude-run", "status": "prepared"}),
            encoding="utf-8",
        )
        (run / "prompt.md").write_text("Auftrag\n", encoding="utf-8")
        return run

    def test_claude_run_does_not_start_below_minimum_quota(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            run = self._prepared_run(Path(directory), "raise SystemExit(0)\n")
            with patch.object(
                cli.ClaudeRateLimitProbe, "remaining_percent", return_value=24.0
            ):
                result = cli.run_agent(
                    argparse.Namespace(run_dir=str(run), dry_run=False, resume=False)
                )

            metadata = json.loads((run / "run.json").read_text(encoding="utf-8"))

        self.assertEqual(result, cli.USAGE_GUARD_EXIT_CODE)
        self.assertEqual(metadata["status"], "not_started_usage_guard")
        self.assertEqual(metadata["usage_guard"]["status"], "blocked_start")

    def test_claude_run_stops_resumably_at_stop_threshold(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            run = self._prepared_run(
                Path(directory),
                "import sys, time\nsys.stdin.read()\ntime.sleep(30)\n",
            )
            with (
                patch.object(
                    cli.ClaudeRateLimitProbe,
                    "remaining_percent",
                    side_effect=[80.0, 4.0],
                ),
                patch.object(cli, "USAGE_POLL_SECONDS", 0.2),
                patch.object(cli, "stage_workspace_opa", return_value={}),
            ):
                result = cli.run_agent(
                    argparse.Namespace(run_dir=str(run), dry_run=False, resume=False)
                )

            metadata = json.loads((run / "run.json").read_text(encoding="utf-8"))

        self.assertEqual(result, cli.USAGE_GUARD_EXIT_CODE)
        self.assertEqual(metadata["status"], "aborted_usage_guard")
        self.assertEqual(metadata["usage_guard"]["status"], "aborted_low_remaining")
        self.assertTrue(metadata["usage_guard"]["resume"]["supported"])
        self.assertEqual(
            metadata["usage_guard"]["resume"]["session_id"],
            metadata["generator_session_id"],
        )

    def test_finalization_feedback_lists_failed_gates_for_resume(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            run = Path(directory)
            (run / "artifacts").mkdir()
            self.assertEqual(cli.finalization_feedback(run), "")
            (run / "artifacts" / "grounding-validation.json").write_text(
                json.dumps(
                    {
                        "status": "failed",
                        "errors": {
                            "evidence": ["c01: evidence_text not found"],
                            "data": [],
                        },
                    }
                ),
                encoding="utf-8",
            )
            (run / "artifacts" / "metrics.json").write_text(
                json.dumps(
                    {
                        "required_outputs_missing": [
                            "grounding_validation_failed",
                            "rego_tests",
                        ]
                    }
                ),
                encoding="utf-8",
            )

            feedback = cli.finalization_feedback(run)

        self.assertIn("- [evidence] c01: evidence_text not found", feedback)
        self.assertIn("- [required_outputs_missing] rego_tests", feedback)
        self.assertNotIn("grounding_validation_failed", feedback)

    def test_resume_is_rejected_for_codex_runs(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            run = self._prepared_run(Path(directory), "")
            (run / "model.json").write_text(
                json.dumps({"adapter": "codex-cli", "model": "test-model"}),
                encoding="utf-8",
            )
            with self.assertRaises(ValueError):
                cli.run_agent(
                    argparse.Namespace(run_dir=str(run), dry_run=False, resume=True)
                )

class PrepareTests(unittest.TestCase):
    def test_prepare_creates_an_isolated_workspace(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory).resolve()
            (root / "profiles").mkdir()
            (root / "prompts").mkdir()
            (root / "sources" / "oepul").mkdir(parents=True)
            (root / "config").mkdir()
            (root / "contracts").mkdir()
            for contract_name in cli.GENERATOR_CONTRACTS:
                (root / "contracts" / contract_name).write_text(
                    '{"type": "object"}\n', encoding="utf-8"
                )
            (root / "AGENTS.md").write_text("instructions", encoding="utf-8")
            (root / "profiles" / "canonical_farm_profile.json").write_text(
                '{"farm": {"year": "int"}}\n', encoding="utf-8"
            )
            (root / "prompts" / "generate_measure.md").write_text(
                "{{MEASURE_ID}} {{MODE}}\n{{SOURCE_LIST}}\n", encoding="utf-8"
            )
            source = root / "sources" / "oepul" / "o6_1a_ubb_2026_04.pdf"
            source.write_bytes(b"%PDF-test")
            model = root / "config" / "model.json"
            model.write_text(
                json.dumps({"adapter": "codex-cli", "model": "test-model"}),
                encoding="utf-8",
            )
            args = argparse.Namespace(
                measure="o6_1a",
                model=str(model),
                mode="discover",
                run_id="test-run",
                profile=str(root / "profiles" / "canonical_farm_profile.json"),
                sources=str(root / "sources" / "oepul"),
                all_sources=False,
                skip_pdf_text=True,
            )

            with patch.object(cli, "REPO_ROOT", root):
                result = cli.prepare(args)

            self.assertEqual(result, 0)
            run = root / "runs" / "test-run"
            self.assertTrue((run / "workspace" / "canonical_farm_profile.json").is_file())
            self.assertTrue((run / "workspace" / "sources" / source.name).is_file())
            self.assertTrue(
                (run / "workspace" / "contracts" / cli.GENERATOR_CONTRACTS[0]).is_file()
            )
            metadata = json.loads((run / "run.json").read_text(encoding="utf-8"))
            self.assertEqual(metadata["measure"], "o6_1a")
            self.assertEqual(metadata["mode"], "discover")


class FinalizeTests(unittest.TestCase):
    def test_finalize_writes_diff_metrics_and_inventory(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            run = Path(directory).resolve()
            workspace = run / "workspace"
            for relative in ("policy", "tests", "rules", "notes", "sources", "data"):
                (workspace / relative).mkdir(parents=True, exist_ok=True)
            (run / "raw").mkdir()
            (run / "artifacts").mkdir()
            profile = {"farm": {"year": "int"}}
            (run / "baseline_profile.json").write_text(
                json.dumps(profile), encoding="utf-8"
            )
            (workspace / "canonical_farm_profile.json").write_text(
                json.dumps(profile), encoding="utf-8"
            )
            source = workspace / "sources" / "source.html"
            source.write_text(
                "<html><body><p>Official evidence text for the example rule.</p></body></html>",
                encoding="utf-8",
            )
            (workspace / "policy" / "policy.rego").write_text(
                "package generated\nallow if input.farm.year >= 2026\n",
                encoding="utf-8",
            )
            (workspace / "tests" / "policy_test.rego").write_text(
                "package generated\ntest_placeholder if true\n", encoding="utf-8"
            )
            (workspace / "rules" / "rules.json").write_text(
                json.dumps(
                    {
                        "contract_version": "rules-catalog-v2.0.0",
                        "measure": "o6_1a",
                        "rules": [
                            {
                                "id": "r01",
                                "rule_type": "eligibility",
                                "statement": "Example rule.",
                                "conditions": [
                                    {
                                        "expression": "input.farm.year >= 2026",
                                        "description": "The application year is 2026 or later.",
                                        "input_paths": ["farm.year"],
                                    }
                                ],
                                "result": {
                                    "outcome": "eligible",
                                    "description": "The example condition is satisfied.",
                                    "value": True,
                                },
                                "source_reference_ids": ["c01"],
                                "rego_symbols": ["allow"],
                            }
                        ],
                    }
                ),
                encoding="utf-8",
            )
            (workspace / "rules" / "citations.json").write_text(
                json.dumps(
                    {
                        "contract_version": "source-references-v2.0.0",
                        "run_id": "test-run",
                        "references": [
                            {
                                "reference_id": "c01",
                                "source_id": "source",
                                "source_path": "workspace/sources/source.html",
                                "source_sha256": cli.sha256(source),
                                "page": None,
                                "section": "1",
                                "claim": "Example claim.",
                                "evidence_text": "Official evidence text for the example rule.",
                                "used_by": [
                                    {
                                        "artifact_path": "workspace/policy/policy.rego",
                                        "symbol": "allow",
                                        "line_start": 2,
                                        "line_end": 2,
                                    }
                                ],
                            }
                        ],
                    }
                ),
                encoding="utf-8",
            )
            (workspace / "rules" / "profile_changes.json").write_text(
                json.dumps(
                    {
                        "contract_version": "profile-changes-v1.0.0",
                        "run_id": "test-run",
                        "measure": "o6_1a",
                        "changes": [
                            {
                                "action": "add",
                                "path": "farm.district",
                                "value_before": None,
                                "value_after": "string",
                                "rationale": "The cited rule needs a district input.",
                                "rule_ids": ["r01"],
                                "source_reference_ids": ["c01"],
                            }
                        ],
                    }
                ),
                encoding="utf-8",
            )
            (workspace / "rules" / "coverage.json").write_text(
                json.dumps(
                    {
                        "contract_version": "coverage-ledger-v1.0.0",
                        "run_id": "test-run",
                        "sources": [
                            {
                                "source_id": "source",
                                "source_path": "workspace/sources/source.html",
                                "source_sha256": cli.sha256(source),
                                "review_scope": "full_document",
                                "scope_reason": None,
                                "pages_reviewed": [],
                                "items": [
                                    {
                                        "item_id": "cov01",
                                        "kind": "paragraph",
                                        "locator": "p1",
                                        "page_start": None,
                                        "page_end": None,
                                        "disposition": "rules",
                                        "rule_ids": ["r01"],
                                        "reason": None,
                                    }
                                ],
                            }
                        ],
                    }
                ),
                encoding="utf-8",
            )
            (workspace / "rules" / "data_inventory.json").write_text(
                json.dumps(
                    {
                        "contract_version": "data-inventory-v1.0.0",
                        "run_id": "test-run",
                        "artifacts": [],
                    }
                ),
                encoding="utf-8",
            )
            (workspace / "notes" / "assumptions.md").write_text(
                "No assumptions.\n", encoding="utf-8"
            )
            (run / "raw" / "events.jsonl").write_text("{}\n", encoding="utf-8")
            (run / "run.json").write_text(
                json.dumps(
                    {
                        "run_id": "test-run",
                        "mode": "discover",
                        "measure": "o6_1a",
                        "sources": [
                            {
                                "name": "source.html",
                                "source_path": "notices/2026/source.html",
                                "sha256": cli.sha256(source),
                                "bytes": source.stat().st_size,
                            }
                        ],
                    }
                ),
                encoding="utf-8",
            )

            with redirect_stdout(io.StringIO()):
                result = cli.finalize(
                    argparse.Namespace(run_dir=str(run), skip_validation=True)
                )

            self.assertEqual(result, 0)
            metrics = json.loads(
                (run / "artifacts" / "metrics.json").read_text(encoding="utf-8")
            )
            self.assertEqual(metrics["profile_paths_added"], 1)
            self.assertTrue(metrics["working_profile_unchanged"])
            self.assertTrue(metrics["grounding_valid"])
            self.assertEqual(metrics["required_outputs_missing"], [])
            self.assertTrue(metrics["inventory_created"])
            self.assertTrue((run / "artifacts" / "inventory.json").is_file())
            proposed = json.loads(
                (run / "artifacts" / "proposed-profile.json").read_text(
                    encoding="utf-8"
                )
            )
            self.assertEqual(proposed["farm"]["district"], "string")

    def test_finalize_rejects_contract_like_but_invalid_json_outputs(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            run = Path(directory).resolve()
            workspace = run / "workspace"
            for relative in ("policy", "tests", "rules", "notes", "sources"):
                (workspace / relative).mkdir(parents=True, exist_ok=True)
            (run / "raw").mkdir()
            (run / "artifacts").mkdir()
            (run / "baseline_profile.json").write_text("{}", encoding="utf-8")
            (workspace / "canonical_farm_profile.json").write_text(
                "{}", encoding="utf-8"
            )
            (workspace / "rules" / "rules.json").write_text(
                '{"schema_version":"old","rules":[{"id":"r1"}]}',
                encoding="utf-8",
            )
            (workspace / "rules" / "citations.json").write_text(
                '{"schema_version":"old","citations":[{"id":"c1"}]}',
                encoding="utf-8",
            )
            (workspace / "notes" / "assumptions.md").write_text(
                "Draft.\n", encoding="utf-8"
            )
            (run / "raw" / "events.jsonl").write_text("{}\n", encoding="utf-8")
            (run / "run.json").write_text(
                json.dumps(
                    {"run_id": "invalid-run", "mode": "discover", "measure": "o6_1a"}
                ),
                encoding="utf-8",
            )

            with redirect_stdout(io.StringIO()):
                result = cli.finalize(
                    argparse.Namespace(run_dir=str(run), skip_validation=True)
                )

            self.assertEqual(result, 1)
            metrics = json.loads(
                (run / "artifacts" / "metrics.json").read_text(encoding="utf-8")
            )
            self.assertIn("grounding_validation_failed", metrics["required_outputs_missing"])
            self.assertTrue(metrics["contract_errors"]["rules_catalog"])
            self.assertTrue(metrics["contract_errors"]["source_references"])

    def test_conform_mode_rejects_profile_changes_after_capture(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            run = Path(directory).resolve()
            workspace = run / "workspace"
            for relative in ("policy", "tests", "rules", "notes", "sources"):
                (workspace / relative).mkdir(parents=True, exist_ok=True)
            (run / "raw").mkdir()
            (run / "artifacts").mkdir()
            (run / "baseline_profile.json").write_text(
                '{"farm": {"year": "int"}}', encoding="utf-8"
            )
            (workspace / "canonical_farm_profile.json").write_text(
                '{"farm": {"year": "int", "new": "boolean"}}', encoding="utf-8"
            )
            (run / "run.json").write_text(
                json.dumps({"run_id": "test-conform", "mode": "conform"}),
                encoding="utf-8",
            )

            with redirect_stdout(io.StringIO()):
                result = cli.finalize(
                    argparse.Namespace(run_dir=str(run), skip_validation=True)
                )

            self.assertEqual(result, 1)
            metadata = json.loads((run / "run.json").read_text(encoding="utf-8"))
            self.assertEqual(metadata["status"], "failed")
            self.assertFalse(metadata["metrics"]["conform_profile_unchanged"])


class CompareTests(unittest.TestCase):
    def test_compare_collects_model_and_generation_metrics(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            run = Path(directory) / "run-a"
            run.mkdir()
            (run / "run.json").write_text(
                json.dumps(
                    {
                        "run_id": "run-a",
                        "measure": "o6_1a",
                        "mode": "discover",
                        "status": "finalized",
                        "model": {"provider": "openai", "model": "test-model"},
                        "metrics": {
                            "structured_rule_count": 42,
                            "profile_paths_added": 7,
                        },
                    }
                ),
                encoding="utf-8",
            )
            output = Path(directory) / "comparison.json"

            with redirect_stdout(io.StringIO()):
                result = cli.compare_runs(
                    argparse.Namespace(run_dirs=[str(run)], output=str(output))
                )

            self.assertEqual(result, 0)
            comparison = json.loads(output.read_text(encoding="utf-8"))
            self.assertEqual(comparison["runs"][0]["structured_rule_count"], 42)
            self.assertEqual(comparison["runs"][0]["profile_paths_added"], 7)


if __name__ == "__main__":
    unittest.main()
