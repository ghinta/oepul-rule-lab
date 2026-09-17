from __future__ import annotations

import json
from pathlib import Path, PurePosixPath
from typing import Annotated, Any, Literal, TypeVar

from pydantic import (
    AfterValidator,
    BaseModel,
    ConfigDict,
    Field,
    JsonValue,
    StringConstraints,
    ValidationError,
    field_validator,
    model_validator,
)


NonEmptyStr = Annotated[
    str, StringConstraints(strip_whitespace=True, min_length=1, max_length=2000)
]
Identifier = Annotated[
    str,
    StringConstraints(
        strip_whitespace=True,
        min_length=3,
        max_length=160,
        pattern=r"^[A-Za-z0-9][A-Za-z0-9._-]+$",
    ),
]
Sha256 = Annotated[str, StringConstraints(pattern=r"^[0-9a-f]{64}$")]
ProfilePath = Annotated[
    str,
    StringConstraints(
        pattern=(
            r"^[A-Za-z_][A-Za-z0-9_]*(?:\[\])?"
            r"(?:\.[A-Za-z_][A-Za-z0-9_]*(?:\[\])?)*$"
        )
    ),
]


def _safe_relative_path(value: str) -> str:
    path = PurePosixPath(value)
    if path.is_absolute() or ".." in path.parts or value.startswith("./"):
        raise ValueError("must be a safe run-relative POSIX path")
    return value


RelativePath = Annotated[NonEmptyStr, AfterValidator(_safe_relative_path)]


class StrictModel(BaseModel):
    model_config = ConfigDict(extra="forbid", strict=True)


class RuleCondition(StrictModel):
    expression: NonEmptyStr
    description: NonEmptyStr
    input_paths: list[ProfilePath] = Field(default_factory=list)


class RuleResult(StrictModel):
    outcome: NonEmptyStr
    description: NonEmptyStr
    value: JsonValue | None = None


class Rule(StrictModel):
    id: Identifier
    rule_type: NonEmptyStr
    statement: NonEmptyStr
    conditions: list[RuleCondition]
    result: RuleResult
    source_reference_ids: list[Identifier] = Field(min_length=1)
    rego_symbols: list[NonEmptyStr] = Field(default_factory=list)

    @field_validator("source_reference_ids", "rego_symbols")
    @classmethod
    def unique_string_list(cls, value: list[str]) -> list[str]:
        if len(value) != len(set(value)):
            raise ValueError("items must be unique")
        return value


class RulesCatalogV2(StrictModel):
    contract_version: Literal["rules-catalog-v2.0.0"]
    measure: Annotated[str, StringConstraints(pattern=r"^o6_[0-9]+[a-z]?$")]
    rules: list[Rule] = Field(min_length=1)

    @field_validator("rules")
    @classmethod
    def unique_rule_ids(cls, value: list[Rule]) -> list[Rule]:
        ids = [rule.id for rule in value]
        if len(ids) != len(set(ids)):
            raise ValueError("rule IDs must be unique")
        return value


class ArtifactUse(StrictModel):
    artifact_path: RelativePath
    symbol: NonEmptyStr
    line_start: Annotated[int, Field(ge=1)] | None
    line_end: Annotated[int, Field(ge=1)] | None

    @model_validator(mode="after")
    def ordered_lines(self) -> "ArtifactUse":
        if (
            self.line_start is not None
            and self.line_end is not None
            and self.line_end < self.line_start
        ):
            raise ValueError("line_end must be greater than or equal to line_start")
        return self


class SourceReference(StrictModel):
    reference_id: Identifier
    source_id: NonEmptyStr
    source_path: RelativePath
    source_sha256: Sha256
    page: Annotated[int, Field(ge=1)] | None
    section: NonEmptyStr | None
    claim: NonEmptyStr
    evidence_text: Annotated[
        str, StringConstraints(strip_whitespace=True, min_length=8, max_length=600)
    ]
    used_by: list[ArtifactUse] = Field(min_length=1)


class SourceReferencesV2(StrictModel):
    contract_version: Literal["source-references-v2.0.0"]
    run_id: Identifier
    references: list[SourceReference] = Field(min_length=1)

    @field_validator("references")
    @classmethod
    def unique_reference_ids(
        cls, value: list[SourceReference]
    ) -> list[SourceReference]:
        ids = [reference.reference_id for reference in value]
        if len(ids) != len(set(ids)):
            raise ValueError("reference IDs must be unique")
        return value


class ProfileChange(StrictModel):
    action: Literal["add", "change", "remove"]
    path: ProfilePath
    value_before: JsonValue | None = None
    value_after: JsonValue | None = None
    rationale: NonEmptyStr
    rule_ids: list[Identifier] = Field(min_length=1)
    source_reference_ids: list[Identifier] = Field(min_length=1)

    @field_validator("rule_ids", "source_reference_ids")
    @classmethod
    def unique_links(cls, value: list[str]) -> list[str]:
        if len(value) != len(set(value)):
            raise ValueError("linked IDs must be unique")
        return value

    @model_validator(mode="after")
    def values_match_action(self) -> "ProfileChange":
        if self.action == "add" and (
            self.value_before is not None or self.value_after is None
        ):
            raise ValueError("add requires only value_after")
        if self.action == "remove" and (
            self.value_before is None or self.value_after is not None
        ):
            raise ValueError("remove requires only value_before")
        if self.action == "change" and (
            self.value_before is None
            or self.value_after is None
            or self.value_before == self.value_after
        ):
            raise ValueError("change requires distinct before and after values")
        return self


class ProfileChangeSetV1(StrictModel):
    contract_version: Literal["profile-changes-v1.0.0"]
    run_id: Identifier
    measure: Annotated[str, StringConstraints(pattern=r"^o6_[0-9]+[a-z]?$")]
    changes: list[ProfileChange]

    @field_validator("changes")
    @classmethod
    def unique_change_paths(cls, value: list[ProfileChange]) -> list[ProfileChange]:
        paths = [change.path for change in value]
        if len(paths) != len(set(paths)):
            raise ValueError("profile change paths must be unique")
        return value


class PageRange(StrictModel):
    start: Annotated[int, Field(ge=1)]
    end: Annotated[int, Field(ge=1)]

    @model_validator(mode="after")
    def ordered_pages(self) -> "PageRange":
        if self.end < self.start:
            raise ValueError("end must be greater than or equal to start")
        return self


class CoverageItem(StrictModel):
    item_id: Identifier
    kind: Literal["section", "paragraph", "table", "footnote", "notice"]
    locator: NonEmptyStr
    page_start: Annotated[int, Field(ge=1)] | None
    page_end: Annotated[int, Field(ge=1)] | None
    disposition: Literal["rules", "not_rule", "unresolved"]
    rule_ids: list[Identifier] = Field(default_factory=list)
    reason: NonEmptyStr | None = None

    @model_validator(mode="after")
    def disposition_has_support(self) -> "CoverageItem":
        if self.page_start is None and self.page_end is not None:
            raise ValueError("page_end requires page_start")
        if (
            self.page_start is not None
            and self.page_end is not None
            and self.page_end < self.page_start
        ):
            raise ValueError("page_end must be greater than or equal to page_start")
        if self.disposition == "rules" and not self.rule_ids:
            raise ValueError("rules disposition requires rule_ids")
        if self.disposition != "rules" and self.rule_ids:
            raise ValueError("only rules disposition may contain rule_ids")
        if self.disposition != "rules" and self.reason is None:
            raise ValueError("not_rule and unresolved dispositions require a reason")
        return self


class CoverageSource(StrictModel):
    source_id: NonEmptyStr
    source_path: RelativePath
    source_sha256: Sha256
    review_scope: Literal["full_document", "targeted_sections"]
    scope_reason: NonEmptyStr | None = None
    pages_reviewed: list[PageRange]
    items: list[CoverageItem] = Field(min_length=1)

    @model_validator(mode="after")
    def targeted_scope_has_reason(self) -> "CoverageSource":
        if self.review_scope == "targeted_sections" and self.scope_reason is None:
            raise ValueError("targeted_sections requires scope_reason")
        return self


class CoverageLedgerV1(StrictModel):
    contract_version: Literal["coverage-ledger-v1.0.0"]
    run_id: Identifier
    sources: list[CoverageSource] = Field(min_length=1)

    @field_validator("sources")
    @classmethod
    def unique_source_paths(cls, value: list[CoverageSource]) -> list[CoverageSource]:
        paths = [source.source_path for source in value]
        if len(paths) != len(set(paths)):
            raise ValueError("coverage source paths must be unique")
        return value


class DataTable(StrictModel):
    name: NonEmptyStr
    json_pointer: Annotated[str, StringConstraints(pattern=r"^(?:/.*)?$")]
    row_count: Annotated[int, Field(ge=0)]
    source_reference_ids: list[Identifier] = Field(min_length=1)

    @field_validator("source_reference_ids")
    @classmethod
    def unique_source_reference_ids(cls, value: list[str]) -> list[str]:
        if len(value) != len(set(value)):
            raise ValueError("source reference IDs must be unique")
        return value


class DataArtifact(StrictModel):
    path: RelativePath
    sha256: Sha256
    description: NonEmptyStr
    tables: list[DataTable] = Field(min_length=1)

    @field_validator("tables")
    @classmethod
    def unique_table_locations(cls, value: list[DataTable]) -> list[DataTable]:
        locations = [(table.name, table.json_pointer) for table in value]
        if len(locations) != len(set(locations)):
            raise ValueError("table name and JSON pointer pairs must be unique")
        return value


class DataInventoryV1(StrictModel):
    contract_version: Literal["data-inventory-v1.0.0"]
    run_id: Identifier
    artifacts: list[DataArtifact]

    @field_validator("artifacts")
    @classmethod
    def unique_artifact_paths(cls, value: list[DataArtifact]) -> list[DataArtifact]:
        paths = [artifact.path for artifact in value]
        if len(paths) != len(set(paths)):
            raise ValueError("data artifact paths must be unique")
        return value


GENERATOR_CONTRACT_MODELS: dict[str, type[BaseModel]] = {
    "rules-catalog-v2.schema.json": RulesCatalogV2,
    "source-references-v2.schema.json": SourceReferencesV2,
    "profile-changes-v1.schema.json": ProfileChangeSetV1,
    "coverage-ledger-v1.schema.json": CoverageLedgerV1,
    "data-inventory-v1.schema.json": DataInventoryV1,
}


ModelT = TypeVar("ModelT", bound=BaseModel)


def load_contract(path: Path, model: type[ModelT]) -> tuple[ModelT | None, list[str]]:
    try:
        return model.model_validate_json(path.read_text(encoding="utf-8")), []
    except OSError as exc:
        return None, [str(exc)]
    except ValidationError as exc:
        errors = []
        for error in exc.errors(include_url=False):
            location = ".".join(str(part) for part in error["loc"]) or "root"
            errors.append(f"{location}: {error['msg']}")
        return None, errors
    except json.JSONDecodeError as exc:
        return None, [f"invalid JSON: {exc}"]


def export_generator_schemas(output: Path) -> list[Path]:
    output.mkdir(parents=True, exist_ok=True)
    written: list[Path] = []
    for filename, model in GENERATOR_CONTRACT_MODELS.items():
        target = output / filename
        target.write_text(
            json.dumps(model.model_json_schema(), ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        written.append(target)
    return written
