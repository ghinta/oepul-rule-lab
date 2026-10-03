from __future__ import annotations

import copy
import hashlib
import html
import json
import re
import unicodedata
from dataclasses import dataclass
from html.parser import HTMLParser
from pathlib import Path
from typing import Any

from .contracts import (
    CoverageLedgerV1,
    DataInventoryV1,
    ExecutionEvidenceV1,
    ProfileChange,
    ProfileChangeSetV1,
    RulesCatalogV2,
    SourceReferencesV2,
    load_contract,
)


@dataclass
class GroundingResult:
    rules: RulesCatalogV2 | None
    references: SourceReferencesV2 | None
    profile_changes: ProfileChangeSetV1 | None
    coverage: CoverageLedgerV1 | None
    data_inventory: DataInventoryV1 | None
    execution_evidence: ExecutionEvidenceV1 | None
    proposed_profile: dict[str, Any]
    errors: dict[str, list[str]]

    @property
    def valid(self) -> bool:
        return not any(self.errors.values())


class _VisibleHTML(HTMLParser):
    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.parts: list[str] = []
        self.ignored_depth = 0

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag in {"script", "style", "noscript"}:
            self.ignored_depth += 1

    def handle_endtag(self, tag: str) -> None:
        if tag in {"script", "style", "noscript"} and self.ignored_depth:
            self.ignored_depth -= 1

    def handle_data(self, data: str) -> None:
        if not self.ignored_depth:
            self.parts.append(data)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def normalize_evidence(value: str) -> str:
    value = html.unescape(value)
    value = unicodedata.normalize("NFKC", value)
    value = value.replace("\u00ad", "")
    value = re.sub(r"(?<=\w)-\s+(?=\w)", "", value)
    return re.sub(r"\s+", " ", value).strip().casefold()


def _pdf_pages(companion: Path) -> dict[int, str]:
    text = companion.read_text(encoding="utf-8", errors="replace")
    matches = list(re.finditer(r"(?m)^===== PAGE (\d+) =====\s*$", text))
    pages: dict[int, str] = {}
    for index, match in enumerate(matches):
        start = match.end()
        end = matches[index + 1].start() if index + 1 < len(matches) else len(text)
        pages[int(match.group(1))] = text[start:end]
    return pages


def source_evidence_text(
    source: Path, page: int | None
) -> tuple[str | None, str | None]:
    if source.suffix.lower() == ".pdf":
        if page is None:
            return None, "PDF references require a page"
        companion = source.with_suffix(".txt")
        if not companion.is_file():
            return None, f"missing page-marked companion: {companion.name}"
        pages = _pdf_pages(companion)
        if page not in pages:
            return None, f"page {page} is outside extracted PDF page range"
        return pages[page], None
    if page is not None:
        return None, "HTML references must use page=null"
    parser = _VisibleHTML()
    parser.feed(source.read_text(encoding="utf-8", errors="replace"))
    return " ".join(parser.parts), None


def _flatten(value: Any, prefix: str = "") -> dict[str, Any]:
    result: dict[str, Any] = {}
    if isinstance(value, dict):
        for key, child in value.items():
            path = f"{prefix}.{key}" if prefix else key
            result.update(_flatten(child, path))
    elif isinstance(value, list):
        marker = f"{prefix}[]"
        if value:
            result.update(_flatten(value[0], marker))
        else:
            result[marker] = []
    else:
        result[prefix] = value
    return result


def known_profile_paths(value: Any, prefix: str = "") -> set[str]:
    """Return object, array, and leaf paths available in a profile blueprint."""
    result: set[str] = {prefix} if prefix else set()
    if isinstance(value, dict):
        for key, child in value.items():
            path = f"{prefix}.{key}" if prefix else key
            result.update(known_profile_paths(child, path))
    elif isinstance(value, list):
        array_path = f"{prefix}[]"
        result.add(array_path)
        if value:
            result.update(known_profile_paths(value[0], array_path))
    return result


def _path_segments(path: str) -> list[tuple[str, bool]]:
    return [
        (part[:-2], True) if part.endswith("[]") else (part, False)
        for part in path.split(".")
    ]


def _set_profile_path(
    root: dict[str, Any], path: str, value: Any, remove: bool
) -> None:
    current: dict[str, Any] = root
    segments = _path_segments(path)
    for key, is_array in segments[:-1]:
        if key not in current:
            current[key] = [{}] if is_array else {}
        child = current[key]
        if is_array:
            if not isinstance(child, list):
                raise ValueError(f"{key} is not an array")
            if not child:
                child.append({})
            child = child[0]
        if not isinstance(child, dict):
            raise ValueError(f"{key} is not an object")
        current = child
    key, is_array = segments[-1]
    if is_array:
        raise ValueError("profile changes must target a leaf, not an array container")
    if remove:
        del current[key]
    else:
        current[key] = copy.deepcopy(value)


def apply_profile_changes(
    baseline: dict[str, Any], changes: list[ProfileChange]
) -> tuple[dict[str, Any], list[str]]:
    errors: list[str] = []
    flattened = _flatten(baseline)
    paths = [change.path for change in changes]
    for left in paths:
        for right in paths:
            if left != right and (
                right.startswith(left + ".") or right.startswith(left + "[].")
            ):
                errors.append(
                    f"overlapping profile changes are not allowed: {left}, {right}"
                )
    proposed = copy.deepcopy(baseline)
    for change in changes:
        exists = change.path in flattened
        if change.action == "add" and exists:
            errors.append(f"add path already exists: {change.path}")
            continue
        if change.action in {"change", "remove"} and not exists:
            errors.append(f"{change.action} path does not exist: {change.path}")
            continue
        if (
            change.action in {"change", "remove"}
            and flattened[change.path] != change.value_before
        ):
            errors.append(f"value_before does not match baseline: {change.path}")
            continue
        try:
            _set_profile_path(
                proposed,
                change.path,
                change.value_after,
                remove=change.action == "remove",
            )
        except (KeyError, TypeError, ValueError) as exc:
            errors.append(f"cannot apply {change.path}: {exc}")
    return proposed, sorted(set(errors))


def _resolve_json_pointer(value: Any, pointer: str) -> Any:
    if pointer == "":
        return value
    current = value
    for raw_part in pointer.lstrip("/").split("/"):
        part = raw_part.replace("~1", "/").replace("~0", "~")
        if isinstance(current, list):
            current = current[int(part)]
        else:
            current = current[part]
    return current


def _line_count(path: Path) -> int:
    return len(path.read_text(encoding="utf-8", errors="replace").splitlines())


def _line_range_contains_symbol(
    path: Path, symbol: str, line_start: int, line_end: int
) -> bool:
    """Check a declared Rego/test symbol at its claimed source location.

    This deliberately verifies a stable textual anchor, rather than trying to
    fully parse Rego a second time. OPA remains authoritative for compilation.
    """
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    if line_start < 1 or line_end > len(lines):
        return False
    pattern = re.compile(
        rf"(?m)^\s*{re.escape(symbol)}(?:\s+contains)?\s*(?:\(|:=|=|if|\{{)"
    )
    return bool(pattern.search("\n".join(lines[line_start - 1 : line_end])))


def table_row_count(value: Any) -> int:
    """Count rows in arrays or scalar lookup entries in nested objects."""
    if isinstance(value, list):
        return len(value)
    if isinstance(value, dict):
        return sum(
            table_row_count(child)
            if isinstance(child, (list, dict))
            else 1
            for child in value.values()
        )
    raise TypeError("resolved table must be a JSON array or object")


def validate_grounded_outputs(
    run_dir: Path,
    metadata: dict[str, Any],
    baseline_profile: dict[str, Any],
) -> GroundingResult:
    workspace = run_dir / "workspace"
    contract_paths = {
        "rules_catalog": (workspace / "rules" / "rules.json", RulesCatalogV2),
        "source_references": (
            workspace / "rules" / "citations.json",
            SourceReferencesV2,
        ),
        "profile_changes": (
            workspace / "rules" / "profile_changes.json",
            ProfileChangeSetV1,
        ),
        "coverage": (workspace / "rules" / "coverage.json", CoverageLedgerV1),
        "data_inventory": (
            workspace / "rules" / "data_inventory.json",
            DataInventoryV1,
        ),
    }
    quality_gate_v2 = metadata.get("quality_gate_version") == "v2"
    if quality_gate_v2:
        contract_paths["execution_evidence"] = (
            workspace / "rules" / "execution_evidence.json",
            ExecutionEvidenceV1,
        )
    loaded: dict[str, Any] = {}
    errors: dict[str, list[str]] = {key: [] for key in contract_paths}
    errors["cross_references"] = []
    errors["evidence"] = []
    errors["profile_application"] = []
    errors["coverage_scope"] = []
    errors["data"] = []
    for key, (path, model) in contract_paths.items():
        value, validation_errors = load_contract(path, model)
        loaded[key] = value
        errors[key].extend(validation_errors)

    rules: RulesCatalogV2 | None = loaded["rules_catalog"]
    references: SourceReferencesV2 | None = loaded["source_references"]
    profile_changes: ProfileChangeSetV1 | None = loaded["profile_changes"]
    coverage: CoverageLedgerV1 | None = loaded["coverage"]
    data_inventory: DataInventoryV1 | None = loaded["data_inventory"]
    execution_evidence: ExecutionEvidenceV1 | None = loaded.get("execution_evidence")
    run_id = str(metadata.get("run_id", ""))
    measure = str(metadata.get("measure", ""))

    if rules is not None and rules.measure != measure:
        errors["cross_references"].append("rules catalog measure differs from run")
    for name, value in (
        ("source references", references),
        ("profile changes", profile_changes),
        ("coverage ledger", coverage),
        ("data inventory", data_inventory),
    ):
        if value is not None and value.run_id != run_id:
            errors["cross_references"].append(f"{name} run_id differs from run")
    if profile_changes is not None and profile_changes.measure != measure:
        errors["cross_references"].append("profile changes measure differs from run")
    if execution_evidence is not None and execution_evidence.run_id != run_id:
        errors["cross_references"].append("execution evidence run_id differs from run")

    rule_ids = {rule.id for rule in rules.rules} if rules else set()
    reference_ids = (
        {reference.reference_id for reference in references.references}
        if references
        else set()
    )
    used_reference_ids: set[str] = set()
    if rules is not None:
        for rule in rules.rules:
            missing = set(rule.source_reference_ids) - reference_ids
            if missing:
                errors["cross_references"].append(
                    f"rule {rule.id} has unknown references: {sorted(missing)}"
                )
            used_reference_ids.update(rule.source_reference_ids)
    unused_references = reference_ids - used_reference_ids
    if unused_references:
        errors["cross_references"].append(
            f"references unused by rules: {sorted(unused_references)}"
        )

    expected_sources = {
        f"workspace/sources/{source['name']}": source
        for source in metadata.get("sources", [])
        if isinstance(source, dict) and isinstance(source.get("name"), str)
    }

    if references is not None:
        for reference in references.references:
            source = run_dir / reference.source_path
            prefix = reference.reference_id
            if reference.source_path not in expected_sources:
                errors["evidence"].append(
                    f"{prefix}: source is not part of the prepared source selection"
                )
            if not source.is_file():
                errors["evidence"].append(f"{prefix}: source does not exist")
                continue
            source_digest = sha256(source)
            prepared_digest = expected_sources.get(reference.source_path, {}).get(
                "sha256"
            )
            if prepared_digest is not None and source_digest != prepared_digest:
                errors["evidence"].append(
                    f"{prefix}: prepared source was modified after run creation"
                )
            if source_digest != reference.source_sha256:
                errors["evidence"].append(f"{prefix}: source SHA-256 mismatch")
            source_text, source_error = source_evidence_text(source, reference.page)
            if source_error:
                errors["evidence"].append(f"{prefix}: {source_error}")
            elif normalize_evidence(reference.evidence_text) not in normalize_evidence(
                source_text or ""
            ):
                errors["evidence"].append(
                    f"{prefix}: evidence_text not found on cited page/source"
                )
            for use in reference.used_by:
                artifact = run_dir / use.artifact_path
                if not artifact.is_file():
                    errors["cross_references"].append(
                        f"{prefix}: artifact does not exist: {use.artifact_path}"
                    )
                    continue
                artifact_lines = _line_count(artifact)
                if use.line_start is not None and use.line_start > artifact_lines:
                    errors["cross_references"].append(
                        f"{prefix}: line_start exceeds artifact: {use.artifact_path}"
                    )
                if use.line_end is not None and use.line_end > artifact_lines:
                    errors["cross_references"].append(
                        f"{prefix}: line_end exceeds artifact: {use.artifact_path}"
                    )

    if quality_gate_v2 and execution_evidence is not None:
        rule_by_id = {rule.id: rule for rule in rules.rules} if rules else {}
        execution_by_rule = {
            evidence.rule_id: evidence for evidence in execution_evidence.rules
        }
        missing_execution = set(rule_by_id) - set(execution_by_rule)
        extra_execution = set(execution_by_rule) - set(rule_by_id)
        if missing_execution:
            errors["cross_references"].append(
                f"rules missing execution evidence: {sorted(missing_execution)}"
            )
        if extra_execution:
            errors["cross_references"].append(
                f"execution evidence has unknown rules: {sorted(extra_execution)}"
            )
        references_by_id = (
            {reference.reference_id: reference for reference in references.references}
            if references
            else {}
        )
        for rule_id, evidence in execution_by_rule.items():
            rule = rule_by_id.get(rule_id)
            if rule is None or evidence.status != "executable":
                continue
            if set(evidence.source_reference_ids) != set(rule.source_reference_ids):
                errors["cross_references"].append(
                    f"executable rule {rule_id} must evidence exactly its catalog source references"
                )
            declared_symbols = set(rule.rego_symbols)
            for use in evidence.rego_uses:
                artifact = run_dir / use.artifact_path
                if artifact.suffix != ".rego" or not artifact.is_file():
                    errors["cross_references"].append(
                        f"executable rule {rule_id} has missing Rego artifact: {use.artifact_path}"
                    )
                    continue
                if use.line_start is None or use.line_end is None:
                    errors["cross_references"].append(
                        f"executable rule {rule_id} requires bounded Rego source lines"
                    )
                    continue
                if use.symbol not in declared_symbols:
                    errors["cross_references"].append(
                        f"executable rule {rule_id} maps undeclared Rego symbol: {use.symbol}"
                    )
                if not _line_range_contains_symbol(
                    artifact, use.symbol, use.line_start, use.line_end
                ):
                    errors["cross_references"].append(
                        f"executable rule {rule_id} cannot find Rego symbol {use.symbol} at declared lines"
                    )
            for test in evidence.tests:
                artifact = run_dir / test.artifact_path
                if artifact.suffix != ".rego" or not artifact.is_file():
                    errors["cross_references"].append(
                        f"executable rule {rule_id} has missing test artifact: {test.artifact_path}"
                    )
                    continue
                if not _line_range_contains_symbol(
                    artifact, test.symbol, test.line_start, test.line_end
                ):
                    errors["cross_references"].append(
                        f"executable rule {rule_id} cannot find test {test.symbol} at declared lines"
                    )
            for reference_id in evidence.source_reference_ids:
                reference = references_by_id.get(reference_id)
                if reference is None:
                    continue
                direct_code_link = any(
                    use.artifact_path == rego_use.artifact_path
                    and use.symbol == rego_use.symbol
                    and use.line_start is not None
                    and use.line_end is not None
                    for rego_use in evidence.rego_uses
                    for use in reference.used_by
                )
                if not direct_code_link:
                    errors["cross_references"].append(
                        f"executable rule {rule_id} lacks a direct source-to-Rego link for {reference_id}"
                    )

    proposed_profile = copy.deepcopy(baseline_profile)
    if profile_changes is not None:
        if metadata.get("mode") == "conform" and profile_changes.changes:
            errors["profile_application"].append(
                "conform runs may not propose profile changes"
            )
        for change in profile_changes.changes:
            missing_rules = set(change.rule_ids) - rule_ids
            missing_refs = set(change.source_reference_ids) - reference_ids
            if missing_rules:
                errors["cross_references"].append(
                    f"profile {change.path} has unknown rules: {sorted(missing_rules)}"
                )
            if missing_refs:
                errors["cross_references"].append(
                    f"profile {change.path} has unknown references: "
                    f"{sorted(missing_refs)}"
                )
        proposed_profile, profile_errors = apply_profile_changes(
            baseline_profile, profile_changes.changes
        )
        errors["profile_application"].extend(profile_errors)

    if rules is not None:
        available_paths = known_profile_paths(proposed_profile)
        for rule in rules.rules:
            declared_paths = {
                path
                for condition in rule.conditions
                for path in condition.input_paths
            }
            unknown_paths = declared_paths - available_paths
            if unknown_paths:
                errors["profile_application"].append(
                    f"rule {rule.id} uses paths absent from proposed profile: "
                    f"{sorted(unknown_paths)}"
                )

    covered_rule_ids: set[str] = set()
    if coverage is not None:
        coverage_by_path = {source.source_path: source for source in coverage.sources}
        missing_coverage = set(expected_sources) - set(coverage_by_path)
        extra_coverage = set(coverage_by_path) - set(expected_sources)
        if missing_coverage:
            errors["coverage_scope"].append(
                f"sources missing from coverage ledger: {sorted(missing_coverage)}"
            )
        if extra_coverage:
            errors["coverage_scope"].append(
                f"unknown sources in coverage ledger: {sorted(extra_coverage)}"
            )
        for path_value, source in coverage_by_path.items():
            path = run_dir / path_value
            if not path.is_file():
                errors["coverage_scope"].append(
                    f"coverage source missing: {path_value}"
                )
                continue
            source_digest = sha256(path)
            prepared_digest = expected_sources.get(path_value, {}).get("sha256")
            if prepared_digest is not None and source_digest != prepared_digest:
                errors["coverage_scope"].append(
                    f"prepared source was modified after run creation: {path_value}"
                )
            if source_digest != source.source_sha256:
                errors["coverage_scope"].append(
                    f"coverage source SHA-256 mismatch: {path_value}"
                )
            original = expected_sources.get(path_value, {}).get("source_path", "")
            if (
                not str(original).startswith("legal/")
                and source.review_scope != "full_document"
            ):
                errors["coverage_scope"].append(
                    f"non-legal source must use full_document scope: {path_value}"
                )
            reviewed_pages: set[int] = set()
            for page_range in source.pages_reviewed:
                reviewed_pages.update(range(page_range.start, page_range.end + 1))
            if path.suffix.lower() == ".pdf":
                if not reviewed_pages:
                    errors["coverage_scope"].append(
                        f"PDF coverage must review at least one page: {path_value}"
                    )
                companion = path.with_suffix(".txt")
                if not companion.is_file():
                    errors["coverage_scope"].append(
                        f"PDF coverage requires page-marked companion: {path_value}"
                    )
                    page_count = 0
                else:
                    page_count = len(_pdf_pages(companion))
                if page_count == 0:
                    errors["coverage_scope"].append(
                        f"PDF companion contains no page markers: {path_value}"
                    )
                elif source.review_scope == "full_document" and reviewed_pages != set(
                    range(1, page_count + 1)
                ):
                    errors["coverage_scope"].append(
                        f"full-document PDF page coverage incomplete: {path_value}"
                    )
            elif source.pages_reviewed:
                errors["coverage_scope"].append(
                    f"HTML coverage must use an empty pages_reviewed list: {path_value}"
                )
            for item in source.items:
                unknown_rules = set(item.rule_ids) - rule_ids
                if unknown_rules:
                    errors["cross_references"].append(
                        f"coverage {item.item_id} has unknown rules: "
                        f"{sorted(unknown_rules)}"
                    )
                covered_rule_ids.update(item.rule_ids)
                if (
                    item.page_start is not None
                    and item.page_start not in reviewed_pages
                ):
                    errors["coverage_scope"].append(
                        f"coverage {item.item_id} starts outside pages_reviewed"
                    )
                if item.page_end is not None and item.page_end not in reviewed_pages:
                    errors["coverage_scope"].append(
                        f"coverage {item.item_id} ends outside pages_reviewed"
                    )
    uncovered_rules = rule_ids - covered_rule_ids
    if uncovered_rules:
        errors["cross_references"].append(
            f"rules absent from coverage ledger: {sorted(uncovered_rules)}"
        )

    actual_data_files = {
        str(path.relative_to(run_dir))
        for path in (workspace / "data").rglob("*.json")
        if path.is_file()
    }
    if data_inventory is not None:
        inventory_paths = {artifact.path for artifact in data_inventory.artifacts}
        if inventory_paths != actual_data_files:
            errors["data"].append(
                "data inventory paths differ from workspace data files: "
                f"missing={sorted(actual_data_files - inventory_paths)}, "
                f"extra={sorted(inventory_paths - actual_data_files)}"
            )
        for artifact in data_inventory.artifacts:
            path = run_dir / artifact.path
            if not path.is_file():
                errors["data"].append(f"data artifact missing: {artifact.path}")
                continue
            if sha256(path) != artifact.sha256:
                errors["data"].append(f"data SHA-256 mismatch: {artifact.path}")
            try:
                data = json.loads(path.read_text(encoding="utf-8"))
            except (OSError, json.JSONDecodeError) as exc:
                errors["data"].append(f"invalid data JSON {artifact.path}: {exc}")
                continue
            for table in artifact.tables:
                missing_refs = set(table.source_reference_ids) - reference_ids
                if missing_refs:
                    errors["cross_references"].append(
                        f"data table {table.name} has unknown references: "
                        f"{sorted(missing_refs)}"
                    )
                try:
                    records = _resolve_json_pointer(data, table.json_pointer)
                    count = table_row_count(records)
                except (KeyError, IndexError, TypeError, ValueError) as exc:
                    errors["data"].append(
                        f"cannot resolve {artifact.path}{table.json_pointer}: {exc}"
                    )
                    continue
                if count != table.row_count:
                    errors["data"].append(
                        f"row_count mismatch for {artifact.path}{table.json_pointer}: "
                        f"expected {table.row_count}, got {count}"
                    )

    for key in errors:
        errors[key] = sorted(set(errors[key]))
    return GroundingResult(
        rules=rules,
        references=references,
        profile_changes=profile_changes,
        coverage=coverage,
        data_inventory=data_inventory,
        execution_evidence=execution_evidence,
        proposed_profile=proposed_profile,
        errors=errors,
    )
