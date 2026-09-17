from __future__ import annotations

import argparse
import io
import json
import tempfile
import unittest
from contextlib import redirect_stdout
from pathlib import Path
from unittest.mock import patch

from rulelab import cli


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
            for relative in ("policy", "tests", "rules", "notes", "sources"):
                (workspace / relative).mkdir(parents=True, exist_ok=True)
            (run / "raw").mkdir()
            (run / "artifacts").mkdir()
            profile = {"farm": {"year": "int"}}
            (run / "baseline_profile.json").write_text(
                json.dumps(profile), encoding="utf-8"
            )
            profile["farm"]["district"] = "string"
            (workspace / "canonical_farm_profile.json").write_text(
                json.dumps(profile), encoding="utf-8"
            )
            (workspace / "sources" / "source.pdf").write_bytes(b"%PDF-source")
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
                        "contract_version": "rules-catalog-v1.0.0",
                        "measure": "o6_1a",
                        "rules": [
                            {
                                "id": "r1",
                                "rule_type": "eligibility",
                                "statement": "Example rule.",
                                "conditions": [],
                                "result": True,
                                "sources": [
                                    {
                                        "document": "workspace/sources/source.pdf",
                                        "page": 1,
                                    }
                                ],
                            }
                        ],
                    }
                ),
                encoding="utf-8",
            )
            (workspace / "rules" / "citations.json").write_text(
                json.dumps(
                    {
                        "contract_version": "source-references-v1.0.0",
                        "run_id": "test-run",
                        "references": [
                            {
                                "reference_id": "c01",
                                "source_id": "source",
                                "source_path": "workspace/sources/source.pdf",
                                "source_sha256": cli.sha256(
                                    workspace / "sources" / "source.pdf"
                                ),
                                "page": 1,
                                "section": "1",
                                "claim": "Example claim.",
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
            (workspace / "notes" / "assumptions.md").write_text(
                "No assumptions.\n", encoding="utf-8"
            )
            (run / "raw" / "events.jsonl").write_text("{}\n", encoding="utf-8")
            (run / "run.json").write_text(
                json.dumps(
                    {"run_id": "test-run", "mode": "discover", "measure": "o6_1a"}
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
            self.assertEqual(metrics["required_outputs_missing"], [])
            self.assertTrue(metrics["inventory_created"])
            self.assertTrue((run / "artifacts" / "inventory.json").is_file())

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
            self.assertIn(
                "structured_rules_contract_invalid",
                metrics["required_outputs_missing"],
            )
            self.assertIn(
                "source_references_contract_invalid",
                metrics["required_outputs_missing"],
            )
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
