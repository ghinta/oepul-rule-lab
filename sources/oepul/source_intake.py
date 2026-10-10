#!/usr/bin/env python3
"""Validate current-source intake separately from historical source manifests.

CI validates the inventory and its evidence contracts. --require-ready requires
actual current originals, archived index evidence and complete scoped reviews;
a green inventory check alone never means the source intake is complete.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
from datetime import date, datetime
from pathlib import Path
from typing import Literal
from urllib.parse import urlparse

from pydantic import BaseModel, ConfigDict, Field, ValidationError, field_validator

# Existing source implementation remains the only downloader/importer.
if str(Path(__file__).parent) not in sys.path:
    sys.path.insert(0, str(Path(__file__).parent))
import manage_sources as sources

ROOT = sources.REPO_ROOT
INVENTORY_PATH = Path(__file__).with_name('intake.json')
EXTRA_SCOPES = {
    'oepul_sonderrichtlinie_2023': 'original_pdf',
    'oepul_sonderrichtlinie_2023_anhaenge': 'original_pdf',
    'wrrl_programme': 'original_pdf',
    'wrrl_annex3': 'table_package',
    'gsp_av': 'original_pdf',
    'napv': 'original_pdf',
    'training_providers': 'table_package',
    'combination_matrix_l': 'table_package',
    'combination_matrix_j': 'table_package',
    'premium_rates': 'table_package',
    'livestock_factors': 'table_package',
    'nitrogen_factors': 'table_package',
    'plant_protection_register': 'register_package',
    'bio_input_catalogue': 'register_package',
    'gis_layer_versions': 'gis_package',
    'year_specific_notices': 'notice_package',
}
REQUIRED_SCOPES = {**{key: 'information_sheet' for key in sources.EXPECTED_DOCUMENT_IDS}, **EXTRA_SCOPES}
CLAUSE_DATES = {'second_amendment_general': (date(2027, 1, 1), 2027), 'psm_declaration_change': (None, 2026)}


class Record(BaseModel):
    model_config = ConfigDict(extra='forbid')


class FileEvidence(Record):
    local_path: str
    sha256: str = Field(pattern=r'^[0-9a-f]{64}$')

    @field_validator('local_path')
    @classmethod
    def relative_path(cls, value: str) -> str:
        path = Path(value)
        if path.is_absolute() or '..' in path.parts or not value or value == '.':
            raise ValueError('evidence path must be a nonempty repository-relative path')
        return value


class Capture(FileEvidence):
    file_size_bytes: int = Field(gt=0)
    official_url: str
    retrieved_at: datetime
    provenance: FileEvidence
    kind: Literal['original_file'] = 'original_file'

    @field_validator('retrieved_at')
    @classmethod
    def timezone_required(cls, value: datetime) -> datetime:
        if value.tzinfo is None:
            raise ValueError('capture date must include a timezone')
        return value


class IndexObservation(Record):
    checked_on: date
    index_url: str
    target_url: str
    method: Literal['web_connector_link_resolution', 'http_index_snapshot']
    snapshot: FileEvidence | None = None
    additional_target_urls: list[str] = Field(default_factory=list)


class Review(FileEvidence):
    reviewed_by: str = Field(min_length=1)
    original_source_hashes: list[str] = Field(min_length=1)
    expected_inventory: FileEvidence


class Scope(Record):
    source_id: str
    title: str = Field(min_length=1)
    kind: Literal['information_sheet', 'original_pdf', 'table_package', 'register_package', 'gis_package', 'notice_package']
    needed_scope: str = Field(min_length=1)
    capture: Capture | None = None
    additional_captures: list[Capture] = Field(default_factory=list)
    index_observation: IndexObservation | None = None
    review: Review | None = None
    pending_reason: str = Field(min_length=1)


class Clause(Record):
    clause_id: str
    source_id: Literal['oepul_sonderrichtlinie_2023']
    source_edition: Literal['2026-10-01']
    locator: Literal['SRL section 1.20, printed page 27']
    effective_from: date | None
    application_year: int
    original_capture_pending: bool


class Inventory(Record):
    schema_version: Literal[1]
    observed_on: date
    legal_completeness_claimed: Literal[False]
    completion_claimed: bool
    baseline_manifest: FileEvidence
    historical_scope_note: str = Field(min_length=1)
    scopes: list[Scope]
    clause_applicability: list[Clause]


def verify_file(record: FileEvidence, root: Path) -> Path:
    path = (root / record.local_path).resolve()
    if not path.is_relative_to(root.resolve()) or not path.is_file():
        raise sources.SourceError(f'missing/outside-repository evidence: {record.local_path}')
    if hashlib.sha256(path.read_bytes()).hexdigest() != record.sha256:
        raise sources.SourceError(f'evidence SHA-256 mismatch: {record.local_path}')
    return path


def verify_capture(scope: Scope, root: Path, observed_on: date) -> None:
    capture = scope.capture
    assert capture is not None
    path = verify_file(capture, root)
    if capture.retrieved_at.date() > observed_on:
        raise sources.SourceError(f'{scope.source_id}: capture is after inventory observation date')
    parsed_url = urlparse(capture.official_url)
    if parsed_url.scheme != 'https' or not parsed_url.hostname or parsed_url.username or parsed_url.password:
        raise sources.SourceError(f'{scope.source_id}: original URL must be public HTTPS')
    if not sources.reviewed_authority_url(capture.official_url):
        raise sources.SourceError(f'{scope.source_id}: original publisher not in reviewed registry')
    if (scope.source_id in sources.EXPECTED_DOCUMENT_IDS or scope.source_id in sources.LEGAL_SOURCES or scope.source_id in sources.SUPPLEMENTAL_PDFS) and path.name != Path(parsed_url.path).name:
        raise sources.SourceError(f'{scope.source_id}: original filename and URL mismatch')
    provenance = json.loads(verify_file(capture.provenance, root).read_text())
    if path.stat().st_size != capture.file_size_bytes:
        raise sources.SourceError(f'original size mismatch: {capture.local_path}')
    records = provenance.get('documents', []) + provenance.get('legal_basis_documents', []) + provenance.get('year_specific_notices', [])
    if provenance.get('capture_method') == 'supplied_original_file':
        records.append(provenance)
    expected_sources = {
        'combination_matrix_l': {'oepul_sonderrichtlinie_2023_anhaenge'},
        'combination_matrix_j': {'oepul_sonderrichtlinie_2023_anhaenge'},
        'livestock_factors': {'oepul_sonderrichtlinie_2023_anhaenge'},
        'nitrogen_factors': {'nitrogen_factors', 'napv', 'wrrl_annex3', 'oepul_sonderrichtlinie_2023_anhaenge'},
    }.get(scope.source_id, {scope.source_id})
    if not any((record.get('document_id') or record.get('source_id')) in expected_sources and all(record.get(key) == getattr(capture, key) for key in ('local_path', 'sha256', 'file_size_bytes', 'official_url')) and datetime.fromisoformat(record.get('retrieved_at', '').replace('Z', '+00:00')) == capture.retrieved_at for record in records):
        raise sources.SourceError(f'capture is not supported by original provenance: {capture.local_path}')
    if scope.source_id in sources.EXPECTED_DOCUMENT_IDS:
        if sources.document_id(path.name) != scope.source_id:
            raise sources.SourceError(f'{scope.source_id}: wrong measure original')
        sources.sheet_pdf_metadata(path, sources.edition(path.name))
    elif scope.source_id in sources.LEGAL_SOURCES or scope.source_id in {'combination_matrix_l', 'combination_matrix_j', 'livestock_factors'}:
        legal_id = scope.source_id if scope.source_id in sources.LEGAL_SOURCES else 'oepul_sonderrichtlinie_2023_anhaenge'
        spec = sources.LEGAL_SOURCES[legal_id]
        if path.name != spec['filename']:
            raise sources.SourceError(f'{scope.source_id}: current October 2026 legal edition required')
        sources.legal_pdf_metadata(path, spec)
    elif scope.source_id in sources.SUPPLEMENTAL_PDFS:
        if path.name != sources.SUPPLEMENTAL_PDFS[scope.source_id]:
            raise sources.SourceError(f'{scope.source_id}: registered edition required')
        sources.generic_pdf_metadata(path)
    elif path.suffix.lower() == '.pdf':
        sources.generic_pdf_metadata(path)
    elif scope.source_id in sources.SUPPLEMENTAL_IMPORT_FORMATS:
        sources.original_format_metadata(path, scope.source_id)


def verify_review(scope: Scope, root: Path) -> None:
    review = scope.review
    assert review is not None
    captures = ([scope.capture] if scope.capture else []) + scope.additional_captures
    if not captures or len(set(review.original_source_hashes)) != len(review.original_source_hashes) or set(review.original_source_hashes) != {capture.sha256 for capture in captures}:
        raise sources.SourceError(f'{scope.source_id}: review must bind to this captured original')
    artifact = json.loads(verify_file(review, root).read_text())
    if artifact.get('scope_id') != scope.source_id or artifact.get('original_source_hashes') != review.original_source_hashes:
        raise sources.SourceError(f'{scope.source_id}: review source/scope mismatch')
    expected_artifact = json.loads(verify_file(review.expected_inventory, root).read_text())
    if expected_artifact.get('scope_id') != scope.source_id or expected_artifact.get('original_source_hashes') != review.original_source_hashes or not expected_artifact.get('source_locator') or not expected_artifact.get('established_by') or expected_artifact['established_by'] == review.reviewed_by:
        raise sources.SourceError(f'{scope.source_id}: independently established original inventory missing')
    expected, items = expected_artifact.get('expected_item_ids'), artifact.get('items')
    footnote_ids, footnotes = expected_artifact.get('expected_footnote_ids'), artifact.get('footnotes')
    if not isinstance(expected, list) or not expected or len(set(expected)) != len(expected) or not isinstance(items, list):
        raise sources.SourceError(f'{scope.source_id}: complete item inventory missing')
    actual = [item.get('id') for item in items]
    if len(actual) != len(set(actual)) or set(actual) != set(expected) or any(not item.get('source_locator') or 'value' not in item for item in items):
        raise sources.SourceError(f'{scope.source_id}: complete sourced items missing')
    if not isinstance(footnote_ids, list) or len(set(footnote_ids)) != len(footnote_ids) or not isinstance(footnotes, list):
        raise sources.SourceError(f'{scope.source_id}: explicit footnote inventory missing')
    actual_notes = [note.get('id') for note in footnotes]
    if len(actual_notes) != len(set(actual_notes)) or set(actual_notes) != set(footnote_ids) or any(not note.get('source_locator') or not note.get('text') for note in footnotes):
        raise sources.SourceError(f'{scope.source_id}: footnote coverage incomplete')
    if scope.kind == 'gis_package' and (not artifact.get('crs') or not artifact.get('layer_version') or not artifact.get('spatial_extent')):
        raise sources.SourceError(f'{scope.source_id}: GIS CRS/version/extent missing')


def validate_inventory(data: dict, root: Path = ROOT, require_ready: bool = False, needed_scopes: set[str] | None = None) -> dict[str, list[str]]:
    try:
        inventory = Inventory.model_validate(data)
    except ValidationError as exc:
        raise sources.SourceError(str(exc)) from exc
    ids = [scope.source_id for scope in inventory.scopes]
    if len(ids) != len(set(ids)) or set(ids) != set(REQUIRED_SCOPES):
        raise sources.SourceError('required source scope set missing, duplicated or changed')
    clauses = {clause.clause_id: (clause.effective_from, clause.application_year) for clause in inventory.clause_applicability}
    if len(inventory.clause_applicability) != len(CLAUSE_DATES) or clauses != CLAUSE_DATES:
        raise sources.SourceError('required 2026/2027 clause applicability changed or missing')
    verify_file(inventory.baseline_manifest, root)
    ready, pending = [], []
    for scope in inventory.scopes:
        if scope.kind != REQUIRED_SCOPES[scope.source_id]:
            raise sources.SourceError(f'{scope.source_id}: required scope kind changed')
        if scope.capture:
            verify_capture(scope, root, inventory.observed_on)
        if scope.additional_captures and scope.capture is None:
            raise sources.SourceError(f'{scope.source_id}: primary original missing')
        for capture in scope.additional_captures:
            verify_capture(scope.model_copy(update={'capture': capture}), root, inventory.observed_on)
        if scope.review:
            verify_review(scope, root)
        observation = scope.index_observation
        if observation and observation.checked_on != inventory.observed_on:
            raise sources.SourceError(f'{scope.source_id}: index observation must match inventory date')
        current = False
        if observation and observation.method == 'http_index_snapshot':
            if observation.snapshot is None:
                raise sources.SourceError(f'{scope.source_id}: HTTP index snapshot missing')
            body = verify_file(observation.snapshot, root).read_bytes()
            links = sources.parse_all_links(body, observation.index_url)
            targets = [observation.target_url] + observation.additional_target_urls
            if len(targets) != len(set(targets)) or not set(targets) <= {link.url for link in links}:
                raise sources.SourceError(f'{scope.source_id}: target missing from captured index')
            if scope.capture:
                captures = [scope.capture] + scope.additional_captures
                current = {capture.official_url for capture in captures} == set(targets) and all(capture.retrieved_at.date() >= observation.checked_on for capture in captures)
        elif observation and observation.snapshot is not None:
            raise sources.SourceError(f'{scope.source_id}: connector metadata cannot claim raw index bytes')
        byte_only_scope = scope.kind == 'information_sheet' or scope.source_id in sources.LEGAL_SOURCES or scope.source_id == 'wrrl_programme'
        if current and scope.capture and (byte_only_scope or scope.review):
            ready.append(scope.source_id)
        else:
            pending.append(scope.source_id)
    legal_pending = 'oepul_sonderrichtlinie_2023' not in ready
    if any(clause.original_capture_pending != legal_pending for clause in inventory.clause_applicability):
        raise sources.SourceError('clause evidence status must match current SRL capture status')
    needed = set(REQUIRED_SCOPES) if needed_scopes is None else needed_scopes
    if not needed <= set(REQUIRED_SCOPES):
        raise sources.SourceError('unknown required source scope')
    missing = pending if inventory.completion_claimed else sorted(set(pending) & needed) if require_ready else []
    if missing:
        raise sources.SourceError('current intake is incomplete; pending scopes: ' + ', '.join(missing))
    return {'ready': ready, 'pending': pending}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--inventory', type=Path, default=INVENTORY_PATH)
    parser.add_argument('--require-ready', action='store_true')
    parser.add_argument('--scope', action='append', choices=sorted(REQUIRED_SCOPES), help='needed consumer scope; repeat as needed, default all scopes')
    args = parser.parse_args()
    try:
        result = validate_inventory(json.loads(args.inventory.read_text()), require_ready=args.require_ready, needed_scopes=set(args.scope) if args.scope else None)
    except (sources.SourceError, OSError, ValueError, TypeError, KeyError) as exc:
        print(f'ERROR: {exc}', file=sys.stderr)
        return 1
    observed_on = json.loads(args.inventory.read_text())['observed_on']
    print(f"PASS: intake inventory integrity as_of={observed_on}; ready={len(result['ready'])}; pending={len(result['pending'])}; not a live/legal/admission approval")
    for source_id in result['pending']:
        print(f'PENDING: {source_id}')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
