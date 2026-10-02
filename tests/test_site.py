from __future__ import annotations

import json
import subprocess
import tempfile
import unittest
from pathlib import Path

from rulelab import site


def write_json(path: Path, value: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False), encoding="utf-8")


def make_run(
    root: Path,
    run_id: str,
    model: str,
    *,
    rules: list[dict],
    citations: list[dict],
    added: dict[str, str],
    cost: float | None = None,
) -> None:
    run_dir = root / run_id
    metadata = {
        "run_id": run_id,
        "measure": "o6_9",
        "status": "finalized",
        "finalized_at": "2026-10-01T10:00:00+00:00",
        "generation_attempt": 1,
        "model": {
            "model": model,
            "reasoning_effort": "high",
            "adapter": "claude-cli" if model == "claude-opus-5-5" else "codex-cli",
            "timeout_seconds": 3600,
        },
        "sources": [
            {"name": "o6_allgemeine_teilnahmebedingungen_2026_04.pdf"},
            {"name": "o6_9_ausbringung_fluessiger_wirtschaftsduenger_2026_06.pdf"},
        ],
        "metrics": {
            "structured_rule_count": len(rules),
            "source_reference_count": len(citations),
            "grounding_valid": True,
            "technical_validation_exit_code": 0,
        },
    }
    if cost is not None:
        metadata["generator_result"] = {
            "total_cost_usd": cost,
            "duration_api_ms": 90000,
        }
    write_json(run_dir / "run.json", metadata)
    workspace = run_dir / "workspace" / "rules"
    write_json(workspace / "rules.json", {"rules": rules})
    write_json(workspace / "citations.json", {"references": citations})
    write_json(
        workspace / "coverage.json",
        {
            "sources": [
                {
                    "source_path": "workspace/sources/o6_9_ausbringung_2026_06.pdf",
                    "items": [
                        {"disposition": "rules"},
                        {
                            "disposition": "unresolved",
                            "locator": "1.12 Abweichungen",
                            "reason": "GSP-AV fehlt",
                        },
                    ],
                }
            ]
        },
    )
    write_json(
        run_dir / "artifacts" / "profile-diff.json",
        {"added": added, "changed": {}, "removed": {}},
    )


def citation(path: str, page: int, text: str) -> dict:
    return {
        "source_path": f"workspace/sources/{path}",
        "page": page,
        "evidence_text": text,
    }


class ConceptAndCategoryTests(unittest.TestCase):
    def setUp(self) -> None:
        self.concepts = site.load_concepts()
        self.categories = site.load_rule_categories()

    def test_checked_in_concepts_assign_typical_paths(self) -> None:
        expected = {
            "farm.applicant.is_active_farmer": "active_farmer",
            "land.parcels[].oepul.is_gloez_landscape_element": "gloez",
            "land.point_landscape_elements[].crown_diameter_m": "landscape_elements",
            "livestock.pig_feeding.rations[].feeding_mode": "feeding",
            "land.parcels[].operations.psm_applications[].date": "psm",
            "manure_management.declared_volumes.trailing_hose_m3": "slurry_application",
            "farm.oepul.o6_2.takeover.takeover_date": "takeover",
            "land.parcels[].oepul_codes[]": "oepul_codes",
        }
        for path, concept in expected.items():
            self.assertEqual(site.assign_concept(path, self.concepts), concept, path)

    def test_unknown_paths_fall_back_to_other(self) -> None:
        self.assertEqual(site.assign_concept("zz.unmatched", self.concepts), "other")

    def test_rule_types_map_to_categories(self) -> None:
        expected = {
            "premium_rate": "praemie",
            "combination_exclusion": "kombination",
            "eligibility": "zugang",
            "scope determination": "zugang",
            "sanction": "abwicklung",
            "application_deadline": "verfahren",
            "temporary_exception": "ausnahme",
            "obligation": "auflage",
            "definition": "definition",
            None: "definition",
        }
        for rule_type, category in expected.items():
            self.assertEqual(
                site.categorize_rule_type(rule_type, self.categories),
                category,
                rule_type,
            )


class HelperTests(unittest.TestCase):
    def test_source_kind_and_measure_sheet(self) -> None:
        self.assertEqual(
            site.source_kind("o6_allgemeine_teilnahmebedingungen_2026_04.pdf"), "atb"
        )
        self.assertEqual(
            site.source_kind("20241011_srl_oepul_2023_anhaenge.pdf"), "srl_annex"
        )
        self.assertEqual(site.source_kind("20241011_srl_oepul_2023.pdf"), "srl")
        self.assertEqual(site.source_kind("2026-08-05__duerre.html"), "notice")
        self.assertEqual(
            site.source_kind("o6_22_tierwohl-schweinehaltung_2025_10.pdf"), "measure"
        )
        sources = [
            {"name": "o6_22_tierwohl_2025_10.pdf"},
            {"name": "o6_2_betriebsmittel_2026_04.pdf"},
        ]
        self.assertEqual(
            site.measure_sheet("o6_2", sources),
            ("o6_2_betriebsmittel_2026_04.pdf", "2026-04"),
        )

    def test_evidence_coverage_accepts_split_quotes(self) -> None:
        long_quote = [
            citation(
                "a.pdf",
                2,
                "Im ersten Teilnahmejahr müssen zumindest 3,00 ha Almweideflächen bewirtschaftet werden, welche mit 3,00 RGVE bestoßen werden.",
            )
        ]
        split = [
            citation(
                "a.pdf",
                2,
                "Im ersten Teilnahmejahr müssen zumindest 3,00 ha Almweideflächen bewirtschaftet",
            ),
            citation("a.pdf", 2, "mit 3,00 RGVE bestoßen"),
        ]
        other_page = [
            citation(
                "a.pdf",
                3,
                "Im ersten Teilnahmejahr müssen zumindest 3,00 ha Almweideflächen",
            )
        ]
        self.assertEqual(site.evidence_coverage(long_quote, split), 1.0)
        self.assertEqual(site.evidence_coverage(long_quote, other_page), 0.0)
        self.assertIsNone(site.evidence_coverage([], split))
        self.assertEqual(site.page_coverage(long_quote, split), 1.0)

    def test_english_share_detects_statement_language(self) -> None:
        statements = [
            "The farm must keep records.",
            "Der Betrieb muss Aufzeichnungen führen.",
        ]
        self.assertEqual(site.english_share(statements), 0.5)


class BuildSiteDataTests(unittest.TestCase):
    def test_build_pairs_models_and_renders_deterministically(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            shared = "Die Prämie wird für maximal 50 m³ flüssigen Wirtschaftsdünger je ha gewährt."
            make_run(
                root,
                "v2-o6_9-terra",
                "gpt-5.6-terra",
                rules=[
                    {
                        "rule_type": "premium_rate",
                        "statement": "The premium is capped at 50 m3 per ha.",
                    }
                ],
                citations=[citation("o6_9_ausbringung_2026_06.pdf", 5, shared)],
                added={"o6_9.applications[].volume_m3": "number"},
            )
            make_run(
                root,
                "v2-o6_9-opus",
                "claude-opus-5-5",
                rules=[
                    {
                        "rule_type": "premium_rate",
                        "statement": "Die Prämie ist mit 50 m³ je ha begrenzt.",
                        "conditions": [{"input_paths": ["land.total_area_ha"]}],
                        "rego_symbols": ["data.oepul.o6_9.cap"],
                    },
                    {
                        "rule_type": "eligibility",
                        "statement": "Der Betrieb muss Gülle ausbringen.",
                    },
                ],
                citations=[
                    citation("o6_9_ausbringung_2026_06.pdf", 5, shared),
                    citation(
                        "o6_allgemeine_teilnahmebedingungen_2026_04.pdf",
                        3,
                        "Geförderte Flächen müssen in Österreich liegen.",
                    ),
                ],
                added={
                    "farm.applicant.is_active_farmer": "boolean",
                    "manure_management.declared_volumes.trailing_hose_m3": "number",
                },
                cost=12.345,
            )

            data = site.build_site_data(root)
            rendered = site.render_site_data(data)

        self.assertEqual(rendered, site.render_site_data(data))
        self.assertTrue(rendered.startswith("// Generated by"))
        self.assertEqual(
            [m["id"] for m in data["models"]], ["claude-opus-5-5", "gpt-5.6-terra"]
        )
        self.assertEqual(len(data["runs"]), 2)
        opus = next(run for run in data["runs"] if run["model"] == "claude-opus-5-5")
        self.assertEqual(opus["rules_with_rego"], 1)
        self.assertEqual(opus["rules_with_inputs"], 1)
        self.assertEqual(opus["categories"]["praemie"], 1)
        self.assertEqual(opus["citations_by_source"]["atb"], 1)
        self.assertEqual(opus["generation"]["cost_usd"], 12.35)
        self.assertEqual(opus["sheet_version"], "2026-06")
        terra = next(run for run in data["runs"] if run["model"] == "gpt-5.6-terra")
        self.assertEqual(terra["english_share"], 1.0)

        [pair] = data["pairs"]
        self.assertEqual(pair["measure"], "o6_9")
        self.assertEqual(pair["baseline_in_challenger"], 1.0)
        self.assertEqual(pair["challenger_in_baseline"], 0.5)
        self.assertEqual(pair["baseline_pages_in_challenger"], 1.0)

        concepts = {
            (data["runs"][i]["model"], path): concept
            for i, path, _, concept, _ in data["proposals"]
        }
        self.assertEqual(
            concepts[("claude-opus-5-5", "farm.applicant.is_active_farmer")],
            "active_farmer",
        )
        self.assertEqual(
            concepts[("gpt-5.6-terra", "o6_9.applications[].volume_m3")],
            "slurry_application",
        )
        self.assertEqual(len(data["unresolved"]), 2)

    def test_inside_git_only_tracked_runs_are_published(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            repo = Path(directory)
            subprocess.run(["git", "init", "-q", str(repo)], check=True)
            runs = repo / "runs"
            for run_id in ("published", "local-only"):
                make_run(
                    runs,
                    run_id,
                    "claude-opus-5-5",
                    rules=[{"rule_type": "eligibility", "statement": "Regel."}],
                    citations=[],
                    added={},
                )
            subprocess.run(
                ["git", "-C", str(repo), "add", "-f", "runs/published/run.json"],
                check=True,
            )

            data = site.build_site_data(runs)

        self.assertEqual([run["run_id"] for run in data["runs"]], ["published"])


if __name__ == "__main__":
    unittest.main()
