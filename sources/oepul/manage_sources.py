#!/usr/bin/env python3
"""Update and validate the current official AMA OePUL source pack."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
import tempfile
import unicodedata
import urllib.error
import urllib.parse
import urllib.request
from collections import Counter
from dataclasses import dataclass
from datetime import datetime, timezone
from html.parser import HTMLParser
from pathlib import Path
from typing import Any

try:
    from pypdf import PdfReader
except ImportError as exc:
    raise SystemExit("pypdf is required: python3 -m pip install pypdf") from exc


SOURCE_DIR = Path(__file__).resolve().parent
REPO_ROOT = SOURCE_DIR.parents[1]
ORIGINALS_DIR = SOURCE_DIR / "originals"
LEGAL_DIR = SOURCE_DIR / "legal"
NOTICES_DIR = SOURCE_DIR / "notices" / "2026"
PROVENANCE_DIR = SOURCE_DIR / "provenance"
MANIFEST_PATH = SOURCE_DIR / "manifest.json"
SCHEMA_PATH = SOURCE_DIR / "manifest.schema.json"
SHEETS_INDEX_URL = "https://www.ama.at/fachliche-informationen/oepul/merkblaetter"
LEGAL_INDEX_URL = "https://www.ama.at/fachliche-informationen/oepul/rechtliche-grundlagen"
NOTICES_INDEX_URL = "https://www.ama.at/fachliche-informationen/oepul/aktuelles/2026"
USER_AGENT = "oepul-rule-lab-source-updater/1.1 (+source provenance)"

VALID_CATEGORIES = ("Allgemein", "Grünland", "Acker", "Dauerkulturen", "Tiere")
CATEGORY_COUNTS = {"Allgemein": 6, "Grünland": 6, "Acker": 6, "Dauerkulturen": 4, "Tiere": 5}
EXPECTED_MEASURE_IDS = {"o6_1a", "o6_1b", "o6_1c", *(f"o6_{n}" for n in range(2, 25))}
EXPECTED_DOCUMENT_IDS = {"o6_general", *EXPECTED_MEASURE_IDS}
LEGAL_SOURCES = {
    "oepul_sonderrichtlinie_2023": {
        "filename": "20241011_srl_oepul_2023.pdf",
        "title": "Sonderrichtlinie ÖPUL 2023",
        "source_date": "2024-10-11",
        "version_label": "Zuletzt geändert mit: 2024-0.489.174",
    },
    "oepul_sonderrichtlinie_2023_anhaenge": {
        "filename": "20241011_srl_oepul_2023_anhaenge.pdf",
        "title": "Anhänge zur Sonderrichtlinie ÖPUL 2023",
        "source_date": "2024-10-11",
        "version_label": "Zuletzt geändert mit: 2024-0.489.174",
    },
    "gsp_anwendungsverordnung": {
        "filename": "gsp-av-fassung-vom-28012026.pdf",
        "title": "GAP-Strategieplan-Anwendungsverordnung (GSP-AV)",
        "source_date": "2026-01-28",
        "version_label": "Fassung vom 28.01.2026",
    },
    "napv": {
        "filename": "napv-fassung-vom-28-10-2024.pdf",
        "title": "Nitrat-Aktionsprogramm-Verordnung (NAPV)",
        "source_date": "2024-10-28",
        "version_label": "Fassung vom 28.10.2024",
        "applies_to_measures": ["o6_7", "o6_9", "o6_16", "o6_21", "o6_22"],
    },
    "grundwasserschutzprogramm_graz_bad_radkersburg_2018": {
        "filename": "grundwasserschutzprogramm-graz-bis-bad-radkersburg-2018-fassung-vom-01072026.pdf",
        "title": "Grundwasserschutzprogramm Graz bis Bad Radkersburg 2018",
        "source_date": "2026-07-01",
        "version_label": "Fassung vom 01.07.2026",
        "applies_to_measures": ["o6_24"],
    },
    "grundwasserschutzprogramm_graz_bad_radkersburg_2018_anlage3": {
        "filename": "grundwasserschutzprogramm-graz-bis-bad-radkersburg-2018_anlage3_2026.pdf",
        "title": "Anlage 3 zum Grundwasserschutzprogramm Graz bis Bad Radkersburg 2018",
        "source_date": None,
        "version_label": "Ausgabe 2026 laut Dateiname",
        "applies_to_measures": ["o6_24"],
    },
}
ANIMAL_MEASURES = ["o6_5", "o6_14", "o6_15", "o6_20", "o6_21", "o6_22"]
NOTICE_SOURCES = {
    "duerre_2026_foerderungsabwicklung": {
        "published_on": "2026-08-12",
        "slug": "duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung",
        "title": "Dürre 2026 – Erleichterungen in der ÖPUL-Förderungsabwicklung",
        "topic_tags": ["duerre", "ausnahmeregelung", "foerderungsabwicklung"],
    },
    "duerre_2026_oepul_ausgleichszulage": {
        "published_on": "2026-08-05",
        "slug": "duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage",
        "title": "Dürre 2026 – Erleichterungen bei ÖPUL und Ausgleichszulage",
        "topic_tags": ["duerre", "ausnahmeregelung", "ausgleichszulage"],
    },
    "rebzikade_2026_insektizidverzicht": {
        "published_on": "2026-06-12",
        "slug": "vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich",
        "title": "Vorzeitiger Ausstieg aus Insektizidverzicht Wein, Obst und Hopfen wegen Amerikanischer Rebzikade",
        "topic_tags": ["rebzikade", "ausnahmeregelung", "o6_12"],
    },
    "trockenheit_2026_biodiversitaetsflaechen": {
        "published_on": "2026-05-22",
        "slug": "trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen",
        "title": "Trockenheitsbedingte Ausnahmeregelungen für ÖPUL-Biodiversitätsflächen",
        "topic_tags": ["trockenheit", "ausnahmeregelung", "biodiversitaetsflaechen"],
    },
    "termine_2026_zwischenfruchtanbau": {
        "published_on": "2026-07-22",
        "slug": "terminueberblick-zu-der-oepul-massnahme-begruenung-von-ackerflaechen-zwischenfruchtanbau",
        "title": "Terminüberblick zu der ÖPUL-Maßnahme „Begrünung von Ackerflächen – Zwischenfruchtanbau“",
        "topic_tags": ["termine", "o6_6"],
        "applies_to_measures": ["o6_6"],
    },
    "aufzeichnungen_2026_grundwasserschutz_acker": {
        "published_on": "2026-08-25",
        "slug": "aufzeichnungsverpflichtungen-bei-der-oepul-massnahme-vorbeugender-grundwasserschutz-acker",
        "title": "Aufzeichnungsverpflichtungen bei der ÖPUL-Maßnahme „Vorbeugender Grundwasserschutz – Acker“",
        "topic_tags": ["aufzeichnungen", "o6_16"],
        "applies_to_measures": ["o6_16"],
    },
    "meldepflichten_2026_tierbezogene_massnahmen": {
        "published_on": "2026-09-02",
        "slug": "meldeverpflichtungen-zu-tierbezogenen-oepul-massnahmen",
        "title": "Meldeverpflichtungen zu tierbezogenen ÖPUL-Maßnahmen",
        "topic_tags": ["meldepflicht", "tiere"],
        "applies_to_measures": ANIMAL_MEASURES,
    },
}
EDITION_RE = re.compile(r"_(20\d{2})_(\d{2})\.pdf$")
MEASURE_RE = re.compile(r"^(o6_(?:1[abc]|[2-9]|1\d|2[0-4]))_")
STAND_RE = re.compile(
    r"\bSTAND\s+(Jänner|Februar|März|April|Mai|Juni|Juli|August|September|Oktober|November|Dezember)\s+(20\d{2})\b",
    re.IGNORECASE,
)
MONTHS = {"jänner": "01", "februar": "02", "märz": "03", "april": "04", "mai": "05", "juni": "06", "juli": "07", "august": "08", "september": "09", "oktober": "10", "november": "11", "dezember": "12"}


class SourceError(RuntimeError):
    pass


@dataclass(frozen=True)
class SourceLink:
    category: str
    title: str
    url: str


@dataclass(frozen=True)
class ResponseData:
    body: bytes
    response_url: str
    status: int
    content_type: str | None
    etag: str | None
    last_modified: str | None


class LinkParser(HTMLParser):
    def __init__(self, base_url: str) -> None:
        super().__init__(convert_charrefs=True)
        self.base_url = base_url
        self.category = ""
        self.heading: list[str] | None = None
        self.href: str | None = None
        self.anchor: list[str] = []
        self.links: list[SourceLink] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag == "h5":
            self.heading = []
        elif tag == "a" and (href := dict(attrs).get("href")):
            self.href, self.anchor = href, []

    def handle_data(self, data: str) -> None:
        if self.heading is not None:
            self.heading.append(data)
        if self.href is not None:
            self.anchor.append(data)

    def handle_endtag(self, tag: str) -> None:
        if tag == "h5" and self.heading is not None:
            self.category = normalize_space("".join(self.heading))
            self.heading = None
        elif tag == "a" and self.href is not None:
            self.links.append(SourceLink(self.category, normalize_space("".join(self.anchor)), urllib.parse.urljoin(self.base_url, self.href)))
            self.href, self.anchor = None, []


def normalize_space(value: str) -> str:
    return " ".join(value.split())


def utc_now() -> str:
    return datetime.now(timezone.utc).isoformat(timespec="seconds").replace("+00:00", "Z")


def new_run_id() -> str:
    return datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S%fZ")


def sha256_bytes(value: bytes) -> str:
    return hashlib.sha256(value).hexdigest()


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def relative_path(path: Path) -> str:
    return path.relative_to(REPO_ROOT).as_posix()


def request(url: str) -> ResponseData:
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    try:
        with urllib.request.urlopen(req, timeout=60) as response:
            return ResponseData(response.read(), response.geturl(), response.status, response.headers.get_content_type(), response.headers.get("ETag"), response.headers.get("Last-Modified"))
    except (urllib.error.URLError, TimeoutError) as exc:
        raise SourceError(f"request failed for {url}: {exc}") from exc


def parse_all_links(body: bytes, base_url: str) -> list[SourceLink]:
    parser = LinkParser(base_url)
    parser.feed(body.decode("utf-8"))
    return parser.links


def document_id(filename: str) -> str:
    if filename.startswith("o6_allgemeine_teilnahmebedingungen_"):
        return "o6_general"
    match = MEASURE_RE.match(filename)
    if not match:
        raise SourceError(f"cannot derive measure ID from {filename}")
    return match.group(1)


def edition(filename: str) -> str:
    match = EDITION_RE.search(filename)
    if not match:
        raise SourceError(f"filename has no YYYY_MM edition: {filename}")
    return f"{match.group(1)}-{match.group(2)}"


def sheet_links(body: bytes) -> list[SourceLink]:
    links = []
    for link in parse_all_links(body, SHEETS_INDEX_URL):
        filename = Path(urllib.parse.urlparse(link.url).path).name
        if link.category in VALID_CATEGORIES and filename.startswith("o6_") and filename.endswith(".pdf"):
            title = re.sub(r"\s*\(PDF,.*\)\s*$", "", link.title, flags=re.IGNORECASE)
            links.append(SourceLink(link.category, title, link.url))
    if len(links) != 27:
        raise SourceError(f"expected 27 current information-sheet PDFs, found {len(links)}")
    ids = {document_id(Path(urllib.parse.urlparse(link.url).path).name) for link in links}
    if ids != EXPECTED_DOCUMENT_IDS:
        raise SourceError(f"unexpected sheet inventory; missing={sorted(EXPECTED_DOCUMENT_IDS - ids)}, extra={sorted(ids - EXPECTED_DOCUMENT_IDS)}")
    if dict(Counter(link.category for link in links)) != CATEGORY_COUNTS:
        raise SourceError("unexpected information-sheet category counts")
    return links


def legal_links(body: bytes) -> dict[str, SourceLink]:
    by_filename = {Path(urllib.parse.urlparse(link.url).path).name: link for link in parse_all_links(body, LEGAL_INDEX_URL) if link.url.lower().endswith(".pdf")}
    missing = [spec["filename"] for spec in LEGAL_SOURCES.values() if spec["filename"] not in by_filename]
    if missing:
        raise SourceError(f"legal-basis page is missing expected PDFs: {missing}")
    return {source_id: by_filename[spec["filename"]] for source_id, spec in LEGAL_SOURCES.items()}


def scope_fields(spec: dict[str, Any]) -> dict[str, Any]:
    """Measure scope of a legal basis or notice; absent means all measures."""
    measures = spec.get("applies_to_measures")
    return {"applies_to_measures": sorted(measures)} if measures else {}


def notice_url(spec: dict[str, Any]) -> str:
    return f"{NOTICES_INDEX_URL}/{spec['slug']}"


def check_notice_index(body: bytes) -> None:
    live = {link.url.rstrip("/") for link in parse_all_links(body, NOTICES_INDEX_URL)}
    missing = [source_id for source_id, spec in NOTICE_SOURCES.items() if notice_url(spec).rstrip("/") not in live]
    if missing:
        raise SourceError(f"2026 notice index is missing selected notices: {missing}")


def notice_publication_date(body: bytes) -> str:
    text = body.decode("utf-8")
    match = re.search(
        r'class="c-news-page__date-to"[^>]*>\s*(\d{2})\.(\d{2})\.(20\d{2})\s*<',
        text,
    )
    if not match:
        raise SourceError("could not extract publication date from notice page")
    day, month, year = match.groups()
    return f"{year}-{month}-{day}"


def read_pdf(path: Path) -> tuple[PdfReader, str]:
    if path.read_bytes()[:5] != b"%PDF-":
        raise SourceError(f"not a PDF: {path}")
    try:
        reader = PdfReader(path)
        text = reader.pages[0].extract_text() or ""
    except Exception as exc:
        raise SourceError(f"cannot parse PDF {path}: {exc}") from exc
    return reader, text


def sheet_pdf_metadata(path: Path, declared_edition: str) -> tuple[str, int, str]:
    reader, text = read_pdf(path)
    match = STAND_RE.search(unicodedata.normalize("NFC", text))
    if not match:
        raise SourceError(f"could not extract printed STAND from {path.name}")
    month, year = match.groups()
    printed = f"{year}-{MONTHS[month.lower()]}"
    if printed != declared_edition:
        raise SourceError(f"edition mismatch for {path.name}: filename={declared_edition}, printed={printed}")
    return f"Stand {month} {year}", len(reader.pages), reader.pdf_header


def generic_pdf_metadata(path: Path) -> tuple[int, str]:
    reader, _ = read_pdf(path)
    return len(reader.pages), reader.pdf_header


def atomic_write(path: Path, body: bytes) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(dir=path.parent, delete=False) as stream:
        temp = Path(stream.name)
        stream.write(body)
    temp.replace(path)


def preserve(path: Path, body: bytes) -> None:
    if path.exists():
        if sha256_file(path) != sha256_bytes(body):
            raise SourceError(f"refusing to overwrite changed source filename: {path}")
    else:
        atomic_write(path, body)


def json_bytes(value: Any) -> bytes:
    return (json.dumps(value, ensure_ascii=False, indent=2) + "\n").encode()


def http_record(response: ResponseData) -> dict[str, Any]:
    return {"response_url": response.response_url, "status": response.status, "content_type": response.content_type, "etag": response.etag, "last_modified": response.last_modified}


def index_record(url: str, response: ResponseData, at: str) -> dict[str, Any]:
    return {"publisher": "Agrarmarkt Austria (AMA)", "url": url, "retrieved_at": at, "sha256": sha256_bytes(response.body)}


def pdf_response(url: str) -> ResponseData:
    response = request(url)
    if response.status != 200 or response.content_type != "application/pdf":
        raise SourceError(f"unexpected PDF response for {url}: HTTP {response.status}, {response.content_type}")
    return response


def build_sheet(link: SourceLink, response: ResponseData, at: str) -> dict[str, Any]:
    filename = Path(urllib.parse.urlparse(link.url).path).name
    source_id, source_edition = document_id(filename), edition(filename)
    target = ORIGINALS_DIR / filename
    preserve(target, response.body)
    label, pages, pdf_version = sheet_pdf_metadata(target, source_edition)
    if source_edition[:4] not in {"2025", "2026"}:
        raise SourceError(f"unexpected current edition: {filename}")
    return {
        "document_id": source_id, "measure_id": None if source_id == "o6_general" else source_id,
        "source_type": "general_information_sheet" if source_id == "o6_general" else "measure_information_sheet",
        "category": link.category, "title": link.title, "edition": source_edition, "edition_label": label,
        "edition_status": "current_2026_edition" if source_edition.startswith("2026-") else "official_current_2025_edition",
        "official_url": link.url, "source_filename": filename, "local_path": relative_path(target), "retrieved_at": at,
        "sha256": sha256_bytes(response.body), "file_size_bytes": len(response.body), "page_count": pages,
        "pdf_version": pdf_version, "http_provenance": http_record(response),
    }


def build_legal(source_id: str, link: SourceLink, response: ResponseData, at: str) -> dict[str, Any]:
    spec, target = LEGAL_SOURCES[source_id], LEGAL_DIR / LEGAL_SOURCES[source_id]["filename"]
    preserve(target, response.body)
    pages, pdf_version = generic_pdf_metadata(target)
    return {
        "source_id": source_id, "source_type": "legal_basis_pdf", "title": spec["title"], "source_date": spec["source_date"],
        "current_status": "current_official_target_at_capture", "version_label": spec["version_label"],
        "version_note": f"Official filename {spec['filename']}; current AMA target at capture, not relabelled as a newer edition.",
        **scope_fields(spec),
        "official_url": link.url, "source_filename": spec["filename"], "local_path": relative_path(target), "retrieved_at": at,
        "sha256": sha256_bytes(response.body), "file_size_bytes": len(response.body), "page_count": pages,
        "pdf_version": pdf_version, "http_provenance": http_record(response),
    }


def build_notice(source_id: str, response: ResponseData, at: str) -> dict[str, Any]:
    spec = NOTICE_SOURCES[source_id]
    filename = f"{spec['published_on']}__{spec['slug']}.html"
    target = NOTICES_DIR / filename
    preserve(target, response.body)
    if b"<html" not in response.body[:10000].lower():
        raise SourceError(f"notice is not recognizable HTML: {source_id}")
    printed_date = notice_publication_date(response.body)
    if printed_date != spec["published_on"]:
        raise SourceError(
            f"notice publication-date mismatch for {source_id}: "
            f"expected={spec['published_on']}, page={printed_date}"
        )
    return {
        "source_id": source_id, "source_type": "year_specific_notice_html", "publication_year": 2026,
        "published_on": spec["published_on"], "title": spec["title"], "topic_tags": spec["topic_tags"],
        **scope_fields(spec),
        "official_url": notice_url(spec), "source_filename": filename, "local_path": relative_path(target), "retrieved_at": at,
        "sha256": sha256_bytes(response.body), "file_size_bytes": len(response.body), "http_provenance": http_record(response),
    }


def update_sources() -> None:
    at, run_id = utc_now(), new_run_id()
    run_dir = PROVENANCE_DIR / run_id
    if run_dir.exists():
        raise SourceError(f"provenance run already exists: {run_id}")
    indexes = {"information_sheets": request(SHEETS_INDEX_URL), "legal_basis": request(LEGAL_INDEX_URL), "notices_2026": request(NOTICES_INDEX_URL)}
    sheets = sheet_links(indexes["information_sheets"].body)
    legal = legal_links(indexes["legal_basis"].body)
    check_notice_index(indexes["notices_2026"].body)
    documents = []
    for pos, link in enumerate(sheets, 1):
        record = build_sheet(link, pdf_response(link.url), at)
        documents.append(record)
        print(f"[sheet {pos:02d}/27] {record['document_id']} {record['edition']} {record['sha256']}")
    legal_documents = []
    for pos, (source_id, link) in enumerate(legal.items(), 1):
        record = build_legal(source_id, link, pdf_response(link.url), at)
        legal_documents.append(record)
        print(f"[legal {pos:02d}/{len(LEGAL_SOURCES):02d}] {source_id} {record['sha256']}")
    notices = []
    for pos, (source_id, spec) in enumerate(NOTICE_SOURCES.items(), 1):
        response = request(notice_url(spec))
        if response.status != 200 or response.content_type != "text/html":
            raise SourceError(f"unexpected notice response for {source_id}: HTTP {response.status}, {response.content_type}")
        record = build_notice(source_id, response, at)
        notices.append(record)
        print(f"[notice {pos:02d}/{len(NOTICE_SOURCES):02d}] {source_id} {record['sha256']}")
    counts = Counter(record["edition"] for record in documents)
    count_2026 = sum(record["edition_status"] == "current_2026_edition" for record in documents)
    manifest = {
        "schema_version": "1.1.0", "source_pack_id": "ama-oepul-current", "generated_at": at,
        "scope": {
            "mandatory_core": "27 current AMA OePUL information sheets", "core_complete": True,
            "legal_completeness_claimed": False,
            "note": "Includes the current AMA-linked OePUL special directive and annexes plus selected official 2026 notices. It is not an exhaustive inventory of every applicable Austrian or EU legal act, amendment, or case-specific decision.",
        },
        "source_indexes": {
            "information_sheets": index_record(SHEETS_INDEX_URL, indexes["information_sheets"], at),
            "legal_basis": index_record(LEGAL_INDEX_URL, indexes["legal_basis"], at),
            "notices_2026": index_record(NOTICES_INDEX_URL, indexes["notices_2026"], at),
        },
        "provenance": {
            "run_id": run_id, "information_sheets_index_snapshot_path": relative_path(run_dir / "merkblaetter.html"),
            "legal_basis_index_snapshot_path": relative_path(run_dir / "rechtliche-grundlagen.html"),
            "notices_index_snapshot_path": relative_path(run_dir / "aktuelles-2026.html"),
            "manifest_snapshot_path": relative_path(run_dir / "manifest.json"), "run_record_path": relative_path(run_dir / "run.json"),
        },
        "expected_document_ids": sorted(EXPECTED_DOCUMENT_IDS),
        "summary": {
            "core_document_count": 27, "edition_counts": dict(sorted(counts.items())), "current_2026_document_count": count_2026,
            "official_current_2025_document_count": 27 - count_2026, "legal_basis_document_count": len(legal_documents),
            "year_specific_notice_count": len(notices), "all_recorded_sources_are_current_index_targets": True,
        },
        "documents": documents, "legal_basis_documents": legal_documents, "year_specific_notices": notices,
    }
    validate_manifest(manifest, check_files=True)
    manifest_body = json_bytes(manifest)
    run_record = {
        "run_id": run_id, "started_at": at, "completed_at": utc_now(), "command": "update",
        "tool": relative_path(Path(__file__).resolve()), "tool_sha256": sha256_file(Path(__file__).resolve()), "user_agent": USER_AGENT,
        "source_index_urls": [SHEETS_INDEX_URL, LEGAL_INDEX_URL, NOTICES_INDEX_URL],
        "source_index_sha256": {key: sha256_bytes(response.body) for key, response in indexes.items()},
        "core_document_count": 27, "legal_basis_document_count": len(legal_documents), "year_specific_notice_count": len(notices),
        "manifest_sha256": sha256_bytes(manifest_body),
    }
    atomic_write(run_dir / "merkblaetter.html", indexes["information_sheets"].body)
    atomic_write(run_dir / "rechtliche-grundlagen.html", indexes["legal_basis"].body)
    atomic_write(run_dir / "aktuelles-2026.html", indexes["notices_2026"].body)
    atomic_write(run_dir / "manifest.json", manifest_body)
    atomic_write(run_dir / "run.json", json_bytes(run_record))
    atomic_write(MANIFEST_PATH, manifest_body)
    print(f"PASS: updated 27 core PDFs (2026={count_2026}, official-current 2025={27-count_2026}), {len(legal_documents)} legal PDFs and {len(notices)} official 2026 notices; run={run_id}")


def require(ok: bool, message: str, errors: list[str]) -> None:
    if not ok:
        errors.append(message)


def check_file(record: dict[str, Any], label: str, errors: list[str]) -> Path | None:
    path = REPO_ROOT / str(record.get("local_path", ""))
    require(path.is_file(), f"{label} file missing", errors)
    if not path.is_file():
        return None
    require(path.stat().st_size == record.get("file_size_bytes"), f"{label} size mismatch", errors)
    require(sha256_file(path) == record.get("sha256"), f"{label} SHA-256 mismatch", errors)
    return path


def validate_manifest(manifest: dict[str, Any], check_files: bool) -> None:
    errors: list[str] = []
    required = {"schema_version", "source_pack_id", "generated_at", "scope", "source_indexes", "provenance", "expected_document_ids", "summary", "documents", "legal_basis_documents", "year_specific_notices"}
    require(set(manifest) == required, "unexpected or missing manifest keys", errors)
    require(manifest.get("schema_version") == "1.1.0", "invalid schema version", errors)
    require(manifest.get("scope", {}).get("core_complete") is True, "core is not complete", errors)
    require(manifest.get("scope", {}).get("legal_completeness_claimed") is False, "legal completeness must not be claimed", errors)
    try:
        json.loads(SCHEMA_PATH.read_text())
    except (OSError, json.JSONDecodeError) as exc:
        errors.append(f"schema is invalid JSON: {exc}")
    documents, legal_documents, notices = manifest.get("documents", []), manifest.get("legal_basis_documents", []), manifest.get("year_specific_notices", [])
    require(len(documents) == 27, "expected 27 core documents", errors)
    require(len(legal_documents) == len(LEGAL_SOURCES), "legal PDF inventory mismatch", errors)
    require(len(notices) == len(NOTICE_SOURCES), "2026 notice inventory mismatch", errors)
    ids, categories, editions, statuses = [], Counter(), Counter(), Counter()
    for pos, record in enumerate(documents):
        label = f"documents[{pos}]"
        source_id, filename = record.get("document_id"), record.get("source_filename", "")
        ids.append(source_id); categories[record.get("category")] += 1
        require(record.get("measure_id") == (None if source_id == "o6_general" else source_id), f"{label} measure ID mismatch", errors)
        try:
            source_edition = edition(filename)
        except SourceError as exc:
            errors.append(str(exc)); source_edition = ""
        expected_status = "current_2026_edition" if source_edition.startswith("2026-") else "official_current_2025_edition"
        require(record.get("edition") == source_edition, f"{label} edition mismatch", errors)
        require(source_edition[:4] in {"2025", "2026"} and record.get("edition_status") == expected_status, f"{label} untruthful edition status", errors)
        editions[source_edition] += 1; statuses[expected_status] += 1
        if check_files and (path := check_file(record, label, errors)):
            try:
                printed, pages, pdf_version = sheet_pdf_metadata(path, source_edition)
                require((printed, pages, pdf_version) == (record.get("edition_label"), record.get("page_count"), record.get("pdf_version")), f"{label} PDF metadata mismatch", errors)
            except SourceError as exc:
                errors.append(str(exc))
    require(set(ids) == EXPECTED_DOCUMENT_IDS and len(ids) == len(set(ids)), "core IDs incomplete or duplicated", errors)
    require(dict(categories) == CATEGORY_COUNTS, "category counts mismatch", errors)
    for pos, record in enumerate(legal_documents):
        label, source_id = f"legal_basis_documents[{pos}]", record.get("source_id")
        spec = LEGAL_SOURCES.get(source_id, {})
        require(record.get("source_filename") == spec.get("filename") and record.get("source_date") == spec.get("source_date"), f"{label} identity mismatch", errors)
        require(record.get("version_label") == spec.get("version_label"), f"{label} version label mismatch", errors)
        require(record.get("applies_to_measures") == scope_fields(spec).get("applies_to_measures"), f"{label} measure scope mismatch", errors)
        if check_files and (path := check_file(record, label, errors)):
            try:
                require(generic_pdf_metadata(path) == (record.get("page_count"), record.get("pdf_version")), f"{label} PDF metadata mismatch", errors)
            except SourceError as exc:
                errors.append(str(exc))
    require({r.get("source_id") for r in legal_documents} == set(LEGAL_SOURCES), "legal IDs incomplete", errors)
    for pos, record in enumerate(notices):
        label, source_id = f"year_specific_notices[{pos}]", record.get("source_id")
        spec = NOTICE_SOURCES.get(source_id, {})
        require(record.get("published_on") == spec.get("published_on") and record.get("publication_year") == 2026, f"{label} date mismatch", errors)
        require(record.get("official_url") == (notice_url(spec) if spec else None), f"{label} URL mismatch", errors)
        require(record.get("applies_to_measures") == scope_fields(spec).get("applies_to_measures"), f"{label} measure scope mismatch", errors)
        if check_files and (path := check_file(record, label, errors)):
            body = path.read_bytes()
            require(b"<html" in body[:10000].lower(), f"{label} not HTML", errors)
            try:
                require(notice_publication_date(body) == spec.get("published_on"), f"{label} printed publication date mismatch", errors)
            except SourceError as exc:
                errors.append(str(exc))
    require({r.get("source_id") for r in notices} == set(NOTICE_SOURCES), "notice IDs incomplete", errors)
    summary = manifest.get("summary", {})
    require(summary.get("edition_counts") == dict(sorted(editions.items())), "edition-count summary mismatch", errors)
    require(summary.get("current_2026_document_count") == statuses["current_2026_edition"], "2026-count summary mismatch", errors)
    require(summary.get("official_current_2025_document_count") == statuses["official_current_2025_edition"], "2025-count summary mismatch", errors)
    require(summary.get("legal_basis_document_count") == len(legal_documents), "legal-count summary mismatch", errors)
    require(summary.get("year_specific_notice_count") == len(notices), "notice-count summary mismatch", errors)
    if errors:
        raise SourceError("\n".join(errors))


def validate_live(manifest: dict[str, Any]) -> None:
    live_sheets = {document_id(Path(urllib.parse.urlparse(link.url).path).name): link.url for link in sheet_links(request(SHEETS_INDEX_URL).body)}
    recorded_sheets = {record["document_id"]: record["official_url"] for record in manifest["documents"]}
    if live_sheets != recorded_sheets:
        raise SourceError("information-sheet URLs no longer match the official index")
    live_legal = {source_id: link.url for source_id, link in legal_links(request(LEGAL_INDEX_URL).body).items()}
    recorded_legal = {record["source_id"]: record["official_url"] for record in manifest["legal_basis_documents"]}
    if live_legal != recorded_legal:
        raise SourceError("legal-basis URLs no longer match the official index")
    check_notice_index(request(NOTICES_INDEX_URL).body)


def validate_sources(check_index: bool) -> None:
    try:
        manifest = json.loads(MANIFEST_PATH.read_text())
    except (OSError, json.JSONDecodeError) as exc:
        raise SourceError(f"cannot read manifest: {exc}") from exc
    validate_manifest(manifest, check_files=True)
    if check_index:
        validate_live(manifest)
    summary = manifest["summary"]
    suffix = "; live AMA indexes match" if check_index else ""
    legal_count, notice_count = len(LEGAL_SOURCES), len(NOTICE_SOURCES)
    print(f"PASS: 27/27 core PDFs, {legal_count}/{legal_count} legal PDFs and {notice_count}/{notice_count} notices verified; 2026 editions={summary['current_2026_document_count']}, official-current 2025 editions={summary['official_current_2025_document_count']}{suffix}")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    commands.add_parser("update")
    validate_parser = commands.add_parser("validate")
    validate_parser.add_argument("--check-index", action="store_true")
    args = parser.parse_args()
    try:
        update_sources() if args.command == "update" else validate_sources(args.check_index)
    except SourceError as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
