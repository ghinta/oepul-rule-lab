from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path

from pydantic import ValidationError

from rulelab.contracts import (
    GENERATOR_CONTRACT_MODELS,
    ProfileChange,
    RulesCatalogV2,
)
from rulelab.grounding import (
    apply_profile_changes,
    normalize_evidence,
    sha256,
    source_evidence_text,
    validate_grounded_outputs,
)


class StrictContractTests(unittest.TestCase):
    def test_checked_in_json_schemas_match_pydantic_models(self) -> None:
        repository = Path(__file__).resolve().parents[1]
        for filename, model in GENERATOR_CONTRACT_MODELS.items():
            checked_in = json.loads(
                (repository / "contracts" / filename).read_text(encoding="utf-8")
            )
            self.assertEqual(checked_in, model.model_json_schema(), filename)

    def test_rules_catalog_rejects_unexpected_fields(self) -> None:
        payload = {
            "contract_version": "rules-catalog-v2.0.0",
            "measure": "o6_1a",
            "rules": [
                {
                    "id": "r01",
                    "rule_type": "eligibility",
                    "statement": "Example statement.",
                    "conditions": [],
                    "result": {
                        "outcome": "eligible",
                        "description": "Example result.",
                        "value": True,
                    },
                    "source_reference_ids": ["c01"],
                    "rego_symbols": [],
                    "invented_field": "must not be accepted",
                }
            ],
        }

        with self.assertRaises(ValidationError):
            RulesCatalogV2.model_validate(payload)

    def test_rules_catalog_rejects_duplicate_rule_ids(self) -> None:
        rule = {
            "id": "r01",
            "rule_type": "eligibility",
            "statement": "Example statement.",
            "conditions": [],
            "result": {
                "outcome": "eligible",
                "description": "Example result.",
                "value": True,
            },
            "source_reference_ids": ["c01"],
            "rego_symbols": [],
        }
        with self.assertRaises(ValidationError):
            RulesCatalogV2.model_validate(
                {
                    "contract_version": "rules-catalog-v2.0.0",
                    "measure": "o6_1a",
                    "rules": [rule, rule],
                }
            )


class EvidenceTests(unittest.TestCase):
    def test_html_extraction_ignores_scripts_and_normalizes_whitespace(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / "notice.html"
            source.write_text(
                "<html><script>invented text</script><body>Amtlicher   Beleg</body></html>",
                encoding="utf-8",
            )

            text, error = source_evidence_text(source, None)

            self.assertIsNone(error)
            self.assertEqual(normalize_evidence(text or ""), "amtlicher beleg")
            self.assertNotIn("invented", normalize_evidence(text or ""))

    def test_html_reference_rejects_pdf_page_number(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / "notice.html"
            source.write_text("<p>Beleg</p>", encoding="utf-8")

            text, error = source_evidence_text(source, 1)

            self.assertIsNone(text)
            self.assertEqual(error, "HTML references must use page=null")

    def test_reference_is_bound_to_prepared_source_hash_and_artifact_lines(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            run = Path(directory)
            source = run / "workspace" / "sources" / "notice.html"
            artifact = run / "workspace" / "policy" / "policy.rego"
            rules = run / "workspace" / "rules"
            source.parent.mkdir(parents=True)
            artifact.parent.mkdir(parents=True)
            rules.mkdir(parents=True)
            source.write_text("<p>Official evidence text.</p>", encoding="utf-8")
            artifact.write_text("package example\n", encoding="utf-8")
            (rules / "citations.json").write_text(
                json.dumps(
                    {
                        "contract_version": "source-references-v2.0.0",
                        "run_id": "test-run",
                        "references": [
                            {
                                "reference_id": "ref01",
                                "source_id": "notice",
                                "source_path": "workspace/sources/notice.html",
                                "source_sha256": sha256(source),
                                "page": None,
                                "section": "1",
                                "claim": "An official statement exists.",
                                "evidence_text": "Official evidence text.",
                                "used_by": [
                                    {
                                        "artifact_path": "workspace/policy/policy.rego",
                                        "symbol": "allow",
                                        "line_start": 2,
                                        "line_end": None,
                                    }
                                ],
                            }
                        ],
                    }
                ),
                encoding="utf-8",
            )
            metadata = {
                "run_id": "test-run",
                "measure": "o6_1a",
                "mode": "discover",
                "sources": [
                    {
                        "name": "notice.html",
                        "source_path": "notices/2026/notice.html",
                        "sha256": "0" * 64,
                    }
                ],
            }

            result = validate_grounded_outputs(run, metadata, {})

            self.assertIn(
                "ref01: prepared source was modified after run creation",
                result.errors["evidence"],
            )
            self.assertIn(
                "ref01: line_start exceeds artifact: workspace/policy/policy.rego",
                result.errors["cross_references"],
            )


class ProfileProposalTests(unittest.TestCase):
    def test_valid_profile_change_is_applied_to_a_copy(self) -> None:
        baseline = {"farm": {"year": "int"}}
        change = ProfileChange.model_validate(
            {
                "action": "add",
                "path": "farm.district",
                "value_before": None,
                "value_after": "string",
                "rationale": "The rule requires the district.",
                "rule_ids": ["r01"],
                "source_reference_ids": ["c01"],
            }
        )

        proposed, errors = apply_profile_changes(baseline, [change])

        self.assertEqual(errors, [])
        self.assertEqual(proposed["farm"]["district"], "string")
        self.assertNotIn("district", baseline["farm"])

    def test_profile_change_with_wrong_before_value_is_rejected(self) -> None:
        change = ProfileChange.model_validate(
            {
                "action": "change",
                "path": "farm.year",
                "value_before": "number",
                "value_after": "int|null",
                "rationale": "The rule allows a missing year.",
                "rule_ids": ["r01"],
                "source_reference_ids": ["c01"],
            }
        )

        _, errors = apply_profile_changes({"farm": {"year": "int"}}, [change])

        self.assertEqual(errors, ["value_before does not match baseline: farm.year"])


if __name__ == "__main__":
    unittest.main()
