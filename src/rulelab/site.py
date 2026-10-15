"""Data bundle for the static GitHub Pages run explorer under ``docs/``.

The page itself is static HTML/JS. Everything it shows is derived from the
finalized run artifacts in ``runs/*`` plus two reviewable analysis configs in
``config/analysis``. The bundle is deterministic: rebuilding from the same runs
yields byte-identical output, so ``rulelab site --check`` can detect a stale
page. ``runs/*`` is git-ignored and published runs are force-added, so inside a
git checkout only tracked (published or staged) runs are included.
"""

from __future__ import annotations

import json
import re
import subprocess
from collections import Counter
from pathlib import Path
from typing import Any

REPO_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_RUNS_ROOT = REPO_ROOT / "runs"
DEFAULT_SITE_DATA = REPO_ROOT / "docs" / "assets" / "data.js"
DEFAULT_CONCEPTS = REPO_ROOT / "config" / "analysis" / "profile-concepts-v1.json"
DEFAULT_RULE_CATEGORIES = REPO_ROOT / "config" / "analysis" / "rule-categories-v1.json"
DEFAULT_MEASURE_CATALOG = REPO_ROOT / "measures" / "catalog.json"
REPOSITORY_URL = "https://github.com/ghinta/oepul-rule-lab"
SITE_DATA_CONTRACT = "run-explorer-data-v1.0.0"
SITE_DATA_GLOBAL = "RULELAB_DATA"

MODEL_LABELS = {
    "claude-opus-5-5": "Claude Opus 5.5",
    "gpt-5.6-terra": "GPT-5.6 Terra",
    "gpt-5.6-luna": "GPT-5.6 Luna",
    "gpt-5.6-sol": "GPT-5.6 Sol",
    "gpt-6-astra": "GPT-6 Astra",
    "gpt-5.5": "GPT-5.5",
}
# Baseline first, challenger second: pair metrics read "challenger vs baseline".
COMPARISON_MODELS = ("gpt-5.6-terra", "claude-opus-5-5")
SOURCE_KINDS = ("measure", "atb", "srl", "srl_annex", "notice", "other")
PROPOSAL_TYPE_MAX_CHARS = 120
EVIDENCE_MATCH_THRESHOLD = 0.6
EVIDENCE_MIN_SHARED_TOKENS = 3
_EVIDENCE_TOKEN = re.compile(r"[0-9a-zäöüß]{3,}")
_EVIDENCE_STOPWORDS = frozenset(
    (
        "der die das und oder ein eine einer eines einem einen ist sind wird "
        "werden wurde nicht auch für über nach beim bei sowie dass diese dieser "
        "dieses den dem des mit von vom zum zur auf aus als bis wenn sich kann "
        "können muss müssen nur noch alle allen jeweils sofern gemäß hat haben "
        "sein seine ihre ihr pro"
    ).split()
)
_SHEET_VERSION = re.compile(r"_(\d{4})_(\d{2})\.pdf$")
_ENGLISH_MARKERS = re.compile(r"\b(the|must|and|are|is|of|for|with)\b")
_GERMAN_MARKERS = re.compile(r"\b(der|die|das|und|ist|sind|werden|für|mit)\b")


def _read_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def tracked_run_ids(runs_root: Path) -> set[str] | None:
    """Run directories whose ``run.json`` git tracks; ``None`` outside git."""
    try:
        result = subprocess.run(
            ["git", "-C", str(runs_root), "ls-files", "-z", "--", "*/run.json"],
            capture_output=True,
            check=False,
        )
    except OSError:
        return None
    if result.returncode != 0:
        return None
    paths = [entry for entry in result.stdout.decode("utf-8").split("\0") if entry]
    return {Path(entry).parts[0] for entry in paths}


def load_concepts(path: Path = DEFAULT_CONCEPTS) -> list[dict[str, Any]]:
    concepts = _read_json(path)["concepts"]
    for concept in concepts:
        concept["regex"] = re.compile(concept["pattern"])
    return concepts


def assign_concept(profile_path: str, concepts: list[dict[str, Any]]) -> str:
    """Return the first concept whose pattern matches the lower-cased path."""
    lowered = profile_path.lower()
    for concept in concepts:
        if concept["regex"].search(lowered):
            return concept["id"]
    return "other"


def load_rule_categories(
    path: Path = DEFAULT_RULE_CATEGORIES,
) -> list[dict[str, Any]]:
    categories = _read_json(path)["categories"]
    for category in categories:
        category["regex"] = re.compile(category["pattern"])
    return categories


def categorize_rule_type(
    rule_type: str | None, categories: list[dict[str, Any]]
) -> str:
    lowered = (rule_type or "").lower()
    for category in categories:
        if category["regex"].search(lowered):
            return category["id"]
    return categories[-1]["id"]


def source_kind(source_name: str) -> str:
    name = Path(source_name).name.lower()
    if name.startswith("o6_allgemeine"):
        return "atb"
    if "srl" in name and "anhaenge" in name:
        return "srl_annex"
    if "srl" in name:
        return "srl"
    if re.match(r"\d{4}-\d{2}-\d{2}__", name):
        return "notice"
    if name.startswith("o6_"):
        return "measure"
    return "other"


def measure_sheet(
    measure: str, sources: list[dict[str, Any]]
) -> tuple[str | None, str | None]:
    """Find the measure information sheet of a run and its ``YYYY-MM`` version."""
    prefix = f"{measure}_"
    for source in sources:
        name = source.get("name", "")
        if name.startswith(prefix) and name.endswith(".pdf"):
            match = _SHEET_VERSION.search(name)
            version = f"{match.group(1)}-{match.group(2)}" if match else None
            return name, version
    return None, None


def english_share(statements: list[str]) -> float:
    """Share of rule statements that read as English rather than German."""
    if not statements:
        return 0.0
    english = 0
    for statement in statements:
        text = statement.lower()
        if len(_ENGLISH_MARKERS.findall(text)) > len(_GERMAN_MARKERS.findall(text)):
            english += 1
    return round(english / len(statements), 3)


def _evidence_tokens(text: str) -> frozenset[str]:
    return frozenset(
        token
        for token in _EVIDENCE_TOKEN.findall(text.lower())
        if token not in _EVIDENCE_STOPWORDS
    )


def _citation_key(citation: dict[str, Any]) -> tuple[str, Any]:
    return Path(citation.get("source_path", "")).name, citation.get("page")


def _quotes_match(left: frozenset[str], right: frozenset[str]) -> bool:
    if not left or not right:
        return False
    shared = len(left & right)
    if shared < min(EVIDENCE_MIN_SHARED_TOKENS, len(left), len(right)):
        return False
    return shared / min(len(left), len(right)) >= EVIDENCE_MATCH_THRESHOLD


def evidence_coverage(
    citations: list[dict[str, Any]], reference: list[dict[str, Any]]
) -> float | None:
    """Share of ``citations`` whose verbatim evidence also appears in ``reference``.

    Evidence texts are literal source quotes, so they are comparable across
    models regardless of the language of the rule statement. Two quotes match
    when they come from the same document page and the smaller one shares at
    least ``EVIDENCE_MATCH_THRESHOLD`` of its content words with the other, so
    a long quote split into several shorter ones still counts as covered.
    """
    if not citations:
        return None
    by_page: dict[tuple[str, Any], list[frozenset[str]]] = {}
    for item in reference:
        by_page.setdefault(_citation_key(item), []).append(
            _evidence_tokens(item.get("evidence_text", ""))
        )
    covered = 0
    for item in citations:
        tokens = _evidence_tokens(item.get("evidence_text", ""))
        candidates = by_page.get(_citation_key(item), [])
        if any(_quotes_match(tokens, other) for other in candidates):
            covered += 1
    return round(covered / len(citations), 3)


def page_coverage(
    citations: list[dict[str, Any]], reference: list[dict[str, Any]]
) -> float | None:
    """Share of distinct cited document pages that ``reference`` also cites."""
    pages = {_citation_key(item) for item in citations}
    if not pages:
        return None
    reference_pages = {_citation_key(item) for item in reference}
    return round(len(pages & reference_pages) / len(pages), 3)


def _model_entry(model_id: str) -> dict[str, Any]:
    return {"id": model_id, "label": MODEL_LABELS.get(model_id, model_id)}


def summarize_run(
    run_dir: Path,
    concepts: list[dict[str, Any]],
    categories: list[dict[str, Any]],
) -> dict[str, Any]:
    """Collect everything the page needs from one finalized run directory."""
    metadata = _read_json(run_dir / "run.json")
    metrics = metadata.get("metrics", {})
    model = metadata.get("model", {})
    workspace = run_dir / "workspace"
    rules = _read_json(workspace / "rules" / "rules.json").get("rules", [])
    citations = _read_json(workspace / "rules" / "citations.json").get("references", [])
    coverage = _read_json(workspace / "rules" / "coverage.json").get("sources", [])
    diff = _read_json(run_dir / "artifacts" / "profile-diff.json")
    sheet, sheet_version = measure_sheet(
        metadata["measure"], metadata.get("sources", [])
    )

    category_counts = Counter(
        categorize_rule_type(rule.get("rule_type"), categories) for rule in rules
    )
    citation_counts = Counter(
        source_kind(item.get("source_path", "")) for item in citations
    )
    dispositions: Counter[str] = Counter()
    unresolved: list[dict[str, str]] = []
    for source in coverage:
        for item in source.get("items", []):
            disposition = item.get("disposition") or "unknown"
            dispositions[disposition] += 1
            if disposition == "unresolved":
                unresolved.append(
                    {
                        "source": Path(source.get("source_path", "")).name,
                        "locator": item.get("locator", ""),
                        "reason": item.get("reason") or "",
                    }
                )

    generator = metadata.get("generator_result") or {}
    cost = generator.get("total_cost_usd")
    api_ms = generator.get("duration_api_ms")
    proposals = []
    for path, value in sorted(diff.get("added", {}).items()):
        proposals.append(
            (path, _compact_type(value), assign_concept(path, concepts), "added")
        )
    for path, value in sorted(diff.get("changed", {}).items()):
        after = value.get("after") if isinstance(value, dict) else value
        proposals.append(
            (path, _compact_type(after), assign_concept(path, concepts), "changed")
        )

    record = {
        "run_id": metadata["run_id"],
        "measure": metadata["measure"],
        "model": model.get("model"),
        "effort": model.get("reasoning_effort"),
        "adapter": model.get("adapter"),
        "status": metadata.get("status"),
        "finalized_at": metadata.get("finalized_at"),
        "sheet": sheet,
        "sheet_version": sheet_version,
        "source_count": len(metadata.get("sources", [])),
        "rules": metrics.get("structured_rule_count", len(rules)),
        "references": metrics.get("source_reference_count", len(citations)),
        "coverage": metrics.get("coverage_item_count"),
        "tests": metrics.get("generated_test_count"),
        "proposals": metrics.get("profile_change_proposal_count"),
        "paths_added": metrics.get("profile_paths_added"),
        "paths_changed": metrics.get("profile_paths_changed"),
        "rego_files": metrics.get("rego_files"),
        "rego_lines": metrics.get("rego_lines"),
        "data_tables": metrics.get("data_table_count"),
        "data_bytes": metrics.get("data_bytes"),
        "grounding_valid": bool(metrics.get("grounding_valid")),
        "validation_exit_code": metrics.get("technical_validation_exit_code"),
        "rules_with_inputs": sum(
            1
            for rule in rules
            if any(c.get("input_paths") for c in rule.get("conditions") or [])
        ),
        "rules_with_rego": sum(1 for rule in rules if rule.get("rego_symbols")),
        "english_share": english_share([rule.get("statement", "") for rule in rules]),
        "categories": {c["id"]: category_counts.get(c["id"], 0) for c in categories},
        "citations_by_source": {
            kind: citation_counts.get(kind, 0) for kind in SOURCE_KINDS
        },
        "coverage_dispositions": dict(sorted(dispositions.items())),
        "generation": {
            "attempts": metadata.get("generation_attempt"),
            "cost_usd": round(cost, 2) if isinstance(cost, (int, float)) else None,
            "api_minutes": (
                round(api_ms / 60000, 1) if isinstance(api_ms, (int, float)) else None
            ),
            "timeout_seconds": model.get("timeout_seconds"),
        },
    }
    return {
        "record": record,
        "proposals": proposals,
        "citations": citations,
        "unresolved": unresolved,
    }


def _compact_type(value: Any) -> str:
    text = value if isinstance(value, str) else json.dumps(value, ensure_ascii=False)
    if len(text) > PROPOSAL_TYPE_MAX_CHARS:
        return text[: PROPOSAL_TYPE_MAX_CHARS - 1] + "…"
    return text


def _pair_record(
    measure: str,
    baseline_index: int,
    challenger_index: int,
    baseline_citations: list[dict[str, Any]],
    challenger_citations: list[dict[str, Any]],
) -> dict[str, Any]:
    def of_kind(citations: list[dict[str, Any]], kind: str) -> list[dict[str, Any]]:
        return [c for c in citations if source_kind(c.get("source_path", "")) == kind]

    by_kind: dict[str, dict[str, Any]] = {}
    for kind in SOURCE_KINDS:
        base = of_kind(baseline_citations, kind)
        chal = of_kind(challenger_citations, kind)
        if not base and not chal:
            continue
        by_kind[kind] = {
            "baseline": len(base),
            "challenger": len(chal),
            "baseline_in_challenger": evidence_coverage(base, chal),
            "challenger_in_baseline": evidence_coverage(chal, base),
        }
    return {
        "measure": measure,
        "baseline": baseline_index,
        "challenger": challenger_index,
        "baseline_pages": len({_citation_key(c) for c in baseline_citations}),
        "challenger_pages": len({_citation_key(c) for c in challenger_citations}),
        "baseline_pages_in_challenger": page_coverage(
            baseline_citations, challenger_citations
        ),
        "challenger_pages_in_baseline": page_coverage(
            challenger_citations, baseline_citations
        ),
        "baseline_in_challenger": evidence_coverage(
            baseline_citations, challenger_citations
        ),
        "challenger_in_baseline": evidence_coverage(
            challenger_citations, baseline_citations
        ),
        "by_source": by_kind,
    }


def build_site_data(
    runs_root: Path = DEFAULT_RUNS_ROOT,
    concepts_path: Path = DEFAULT_CONCEPTS,
    categories_path: Path = DEFAULT_RULE_CATEGORIES,
    measure_catalog: Path = DEFAULT_MEASURE_CATALOG,
) -> dict[str, Any]:
    concepts = load_concepts(concepts_path)
    categories = load_rule_categories(categories_path)
    titles = {
        item["id"]: item["title"] for item in _read_json(measure_catalog)["measures"]
    }
    measure_order = {measure: index for index, measure in enumerate(titles)}

    tracked = tracked_run_ids(runs_root)
    summaries = []
    for run_dir in sorted(path for path in runs_root.iterdir() if path.is_dir()):
        if not (run_dir / "run.json").is_file():
            continue
        if tracked is not None and run_dir.name not in tracked:
            continue
        if _read_json(run_dir / "run.json").get("status") != "finalized":
            continue
        summaries.append(summarize_run(run_dir, concepts, categories))
    summaries, history = _split_superseded(summaries)
    summaries.sort(
        key=lambda item: (
            measure_order.get(item["record"]["measure"], len(measure_order)),
            item["record"]["model"] or "",
            item["record"]["run_id"],
        )
    )

    runs = [item["record"] for item in summaries]
    proposals = [
        [index, path, value_type, concept, kind]
        for index, item in enumerate(summaries)
        for path, value_type, concept, kind in item["proposals"]
    ]
    unresolved = [
        [index, entry["source"], entry["locator"], entry["reason"]]
        for index, item in enumerate(summaries)
        for entry in item["unresolved"]
    ]

    baseline_model, challenger_model = COMPARISON_MODELS
    by_measure_model = {
        (run["measure"], run["model"]): index for index, run in enumerate(runs)
    }
    pairs = []
    for measure in titles:
        base_index = by_measure_model.get((measure, baseline_model))
        chal_index = by_measure_model.get((measure, challenger_model))
        if base_index is None or chal_index is None:
            continue
        pairs.append(
            _pair_record(
                measure,
                base_index,
                chal_index,
                summaries[base_index]["citations"],
                summaries[chal_index]["citations"],
            )
        )

    known_models = list(MODEL_LABELS)
    model_ids = sorted(
        {run["model"] for run in runs},
        key=lambda m: (
            known_models.index(m) if m in known_models else len(known_models),
            m,
        ),
    )
    return {
        "contract_version": SITE_DATA_CONTRACT,
        "repository": REPOSITORY_URL,
        "as_of": max((run["finalized_at"] or "" for run in runs), default=None),
        "comparison": {"baseline": baseline_model, "challenger": challenger_model},
        "measures": [
            {"id": measure, "title": title} for measure, title in titles.items()
        ],
        "models": [_model_entry(model_id) for model_id in model_ids],
        "rule_categories": [
            {"id": c["id"], "label": c["label"], "phase": c["recommender_phase"]}
            for c in categories
        ],
        "source_kinds": list(SOURCE_KINDS),
        "concepts": [
            {
                "id": c["id"],
                "label": c["label"],
                "group": c["group"],
                "class": c["recommender_class"],
                "ama": c["ama"],
            }
            for c in concepts
        ],
        "runs": runs,
        "history": history,
        "proposals": proposals,
        "unresolved": unresolved,
        "pairs": pairs,
    }


def _split_superseded(
    summaries: list[dict[str, Any]],
) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    """Keep the newest finalized run per measure and model; list the rest.

    A rerun (for example with a refreshed source pack) replaces the earlier run
    of the same measure and model in every aggregate, comparison and table, so
    nothing is counted twice. The replaced runs stay visible as history.
    """

    def order(item: dict[str, Any]) -> tuple[str, str]:
        record = item["record"]
        return (record["finalized_at"] or "", record["run_id"])

    latest: dict[tuple[str, str | None], dict[str, Any]] = {}
    for item in summaries:
        key = (item["record"]["measure"], item["record"]["model"])
        if key not in latest or order(item) > order(latest[key]):
            latest[key] = item
    current_ids = {item["record"]["run_id"] for item in latest.values()}
    history = []
    for item in summaries:
        record = item["record"]
        if record["run_id"] in current_ids:
            continue
        history.append(
            {
                "run_id": record["run_id"],
                "measure": record["measure"],
                "model": record["model"],
                "finalized_at": record["finalized_at"],
                "rules": record["rules"],
                "references": record["references"],
                "coverage": record["coverage"],
                "unresolved": len(item["unresolved"]),
                "cost_usd": record["generation"]["cost_usd"],
                "superseded_by": latest[(record["measure"], record["model"])][
                    "record"
                ]["run_id"],
            }
        )
    history.sort(key=lambda entry: (entry["measure"], entry["model"] or "", entry["run_id"]))
    current = [item for item in summaries if item["record"]["run_id"] in current_ids]
    return current, history


def render_site_data(data: dict[str, Any]) -> str:
    payload = json.dumps(data, ensure_ascii=False, separators=(",", ":"))
    return (
        "// Generated by `python3 -m rulelab site` from runs/* and config/analysis.\n"
        "// Do not edit by hand.\n"
        f"window.{SITE_DATA_GLOBAL} = {payload};\n"
    )
