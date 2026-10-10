#!/usr/bin/env python3
"""Update and validate the current official AMA OePUL source pack."""

from __future__ import annotations

import argparse
import csv
import hashlib
import io
import json
import re
import sqlite3
import sys
import tempfile
import unicodedata
import urllib.error
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET
import zipfile
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
SUPPLEMENTAL_DIR = SOURCE_DIR / "supplemental"
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
HISTORICAL_LEGAL_SOURCES = {
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
}
LEGAL_SOURCES = {
    source_id: {
        **spec,
        "filename": "srl_oepul_2023" + ("_anhaenge" if source_id.endswith("_anhaenge") else "") + "_20261001.pdf",
        "source_date": "2026-10-01",
        "version_label": "Zuletzt geändert mit: 2024-0.489.174 sowie 2026-0.267.890",
        "page_count": 104 if source_id.endswith("_anhaenge") else 94,
    }
    for source_id, spec in HISTORICAL_LEGAL_SOURCES.items()
}
LEGAL_EDITIONS = {
    source_id: {spec["filename"]: spec, LEGAL_SOURCES[source_id]["filename"]: LEGAL_SOURCES[source_id]}
    for source_id, spec in HISTORICAL_LEGAL_SOURCES.items()
}
SUPPLEMENTAL_PDFS = {
    "wrrl_programme": "grundwasserschutzprogramm-graz-bis-bad-radkersburg-2018-fassung-vom-01072026.pdf",
    "wrrl_annex3": "grundwasserschutzprogramm-graz-bis-bad-radkersburg-2018_anlage3_2026.pdf",
    "training_providers": "oepul2023_liste_anerkannter_bildungsanbieter_2025_10.pdf",
}
SUPPLEMENTAL_IMPORT_FORMATS = {
    "gsp_av": {"pdf", "html"}, "napv": {"pdf", "html"},
    "premium_rates": {"xlsx", "pdf"}, "nitrogen_factors": {"pdf", "xlsx", "csv"},
    "plant_protection_register": {"xlsx", "csv", "json", "xml", "html", "zip"},
    "bio_input_catalogue": {"xlsx", "csv", "json", "xml", "html", "zip", "pdf"},
    "gis_layer_versions": {"geojson", "json", "gpkg", "zip"},
    "year_specific_notices": {"html", "zip"},
}
# Attribution is supplied by the maintainer, never fabricated HTTP provenance.
# Adding a new publisher is an explicit reviewed registry change.
SUPPLEMENTAL_AUTHORITY_DOMAINS = {
    "ama.at", "bmluk.gv.at", "ris.bka.gv.at", "baes.gv.at", "bev.gv.at",
    "data.gv.at", "steiermark.at", "stmk.gv.at", "betriebsmittelbewertung.at",
}
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


def original_format_metadata(path: Path, source_id: str) -> dict[str, Any]:
    """Recognise supplied original formats; content/authority review stays separate."""
    kind = path.suffix.lower().removeprefix(".")
    if kind not in SUPPLEMENTAL_IMPORT_FORMATS.get(source_id, set()):
        raise SourceError(f"unsupported original format for {source_id}: {kind}")
    body = path.read_bytes()
    try:
        if kind == "pdf":
            pages, version = generic_pdf_metadata(path)
            return {"original_format": kind, "page_count": pages, "pdf_version": version}
        if kind in {"zip", "xlsx"}:
            with zipfile.ZipFile(io.BytesIO(body)) as archive:
                names = archive.namelist()
                if not names or any(Path(name).is_absolute() or ".." in Path(name).parts for name in names):
                    raise SourceError("empty/unsafe original archive inventory")
                if kind == "xlsx":
                    required = {"[Content_Types].xml", "xl/workbook.xml"}
                    worksheets = [name for name in names if re.fullmatch(r"xl/worksheets/sheet\d+\.xml", name)]
                    if not required <= set(names) or not worksheets:
                        raise SourceError("not an XLSX workbook with actual worksheets")
                    for name in sorted(required) + worksheets:
                        ET.fromstring(archive.read(name))
                return {"original_format": kind, "archive_member_count": len(names)}
        if kind in {"json", "geojson"}:
            parsed = json.loads(body)
            if not isinstance(parsed, (list, dict)):
                raise SourceError("original JSON must contain an object or list")
            if source_id == "gis_layer_versions" and (not isinstance(parsed, dict) or parsed.get("type") != "FeatureCollection" or not isinstance(parsed.get("features"), list)):
                raise SourceError("GIS JSON must be a GeoJSON FeatureCollection")
        elif kind == "xml":
            ET.fromstring(body)
        elif kind == "html":
            if b"<html" not in body[:10000].lower():
                raise SourceError("not a complete HTML original")
        elif kind == "csv":
            rows = list(csv.reader(io.StringIO(body.decode("utf-8-sig"))))
            if not rows or not any(rows):
                raise SourceError("empty CSV original")
        elif kind == "gpkg":
            if not body.startswith(b"SQLite format 3\x00"):
                raise SourceError("not a SQLite/GeoPackage original")
            # A SQLite header alone does not identify a GeoPackage.
            with sqlite3.connect(path.resolve().as_uri() + "?mode=ro", uri=True) as connection:
                if not connection.execute("SELECT name FROM sqlite_master WHERE name='gpkg_contents'").fetchone():
                    raise SourceError("GeoPackage content registry missing")
        return {"original_format": kind}
    except (ValueError, UnicodeDecodeError, ET.ParseError, zipfile.BadZipFile, sqlite3.DatabaseError, OSError) as exc:
        raise SourceError(f"invalid supplied {kind} original: {exc}") from exc


def reviewed_authority_url(url: str) -> bool:
    parsed = urllib.parse.urlparse(url)
    host = (parsed.hostname or "").lower()
    return parsed.scheme == "https" and not parsed.username and not parsed.password and not parsed.fragment and any(host == domain or host.endswith("." + domain) for domain in SUPPLEMENTAL_AUTHORITY_DOMAINS)


def legal_pdf_metadata(path: Path, spec: dict[str, Any]) -> tuple[int, str]:
    reader, cover = read_pdf(path)
    marker = "2026-0.267.890" if spec["source_date"] == "2026-10-01" else "2024-0.489.174"
    if marker not in cover:
        raise SourceError(f"legal PDF cover does not identify registered amendment {marker}")
    if spec.get("page_count") is not None and len(reader.pages) != spec["page_count"]:
        raise SourceError(f"legal PDF is not the registered complete {spec['page_count']}-page edition")
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
    filename = Path(urllib.parse.urlparse(link.url).path).name
    spec = LEGAL_EDITIONS[source_id].get(filename)
    if spec is None:
        raise SourceError(f"unregistered legal edition: {source_id}/{filename}")
    target = LEGAL_DIR / filename
    with tempfile.NamedTemporaryFile(suffix=".pdf") as stream:
        stream.write(response.body)
        stream.flush()
        pages, pdf_version = legal_pdf_metadata(Path(stream.name), spec)
    preserve(target, response.body)
    return {
        "source_id": source_id, "source_type": "legal_basis_pdf", "title": spec["title"], "source_date": spec["source_date"],
        "current_status": "current_official_target_at_capture", "version_label": spec["version_label"],
        "version_note": f"Official edition dated {spec['source_date']}; current AMA target at capture. Publication date does not establish clause applicability.",
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
    print(f"PASS: updated 27 core PDFs (2026={count_2026}, official-current 2025={27-count_2026}), 2 legal PDFs and 4 official 2026 notices; run={run_id}")


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
        spec = LEGAL_EDITIONS.get(source_id, {}).get(record.get("source_filename"), {})
        require(record.get("source_filename") == spec.get("filename") and record.get("source_date") == spec.get("source_date"), f"{label} identity mismatch", errors)
        require(record.get("version_label") == spec.get("version_label"), f"{label} version label mismatch", errors)
        if check_files and (path := check_file(record, label, errors)):
            try:
                require(legal_pdf_metadata(path, spec) == (record.get("page_count"), record.get("pdf_version")), f"{label} PDF metadata mismatch", errors)
            except SourceError as exc:
                errors.append(str(exc))
    require({r.get("source_id") for r in legal_documents} == set(LEGAL_SOURCES), "legal IDs incomplete", errors)
    for pos, record in enumerate(notices):
        label, source_id = f"year_specific_notices[{pos}]", record.get("source_id")
        spec = NOTICE_SOURCES.get(source_id, {})
        require(record.get("published_on") == spec.get("published_on") and record.get("publication_year") == 2026, f"{label} date mismatch", errors)
        require(record.get("official_url") == (notice_url(spec) if spec else None), f"{label} URL mismatch", errors)
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


def validate_sources(check_index: bool, manifest_path: Path = MANIFEST_PATH) -> None:
    try:
        manifest = json.loads(manifest_path.read_text())
    except (OSError, json.JSONDecodeError) as exc:
        raise SourceError(f"cannot read manifest: {exc}") from exc
    validate_manifest(manifest, check_files=True)
    if check_index:
        validate_live(manifest)
    summary = manifest["summary"]
    suffix = "; live AMA indexes match" if check_index else ""
    print(f"PASS: 27/27 core PDFs, 2/2 legal PDFs and 4/4 notices verified; 2026 editions={summary['current_2026_document_count']}, official-current 2025 editions={summary['official_current_2025_document_count']}{suffix}")


def import_original(source_id: str, input_path: Path, official_url: str, retrieved_at: str, evidence_note: str) -> Path:
    """Archive supplied originals without pretending to have fetched them over HTTP.

    The immutable import record does not change the current manifest or prove
    that a public index still points to these bytes. Review/promote separately.
    """
    parsed = urllib.parse.urlparse(official_url)
    filename = Path(parsed.path).name
    if parsed.scheme != "https" or not parsed.hostname or parsed.username or parsed.password or parsed.fragment:
        raise SourceError("local import expects a public HTTPS document URL without credentials")
    core_or_fixed_pdf = source_id in EXPECTED_DOCUMENT_IDS or source_id in LEGAL_EDITIONS or source_id in SUPPLEMENTAL_PDFS
    if core_or_fixed_pdf and (parsed.hostname != "www.ama.at" or parsed.query):
        raise SourceError("registered AMA originals require the exact public AMA PDF URL")
    if core_or_fixed_pdf and input_path.name != filename:
        raise SourceError("supplied filename must match the official document URL")
    try:
        captured = datetime.fromisoformat(retrieved_at.replace("Z", "+00:00"))
    except ValueError as exc:
        raise SourceError("retrieved-at must be an ISO date/time") from exc
    if captured.tzinfo is None or captured > datetime.now(timezone.utc):
        raise SourceError("retrieved-at must have a timezone and cannot be in the future")
    if not evidence_note.strip():
        raise SourceError("local import requires a source/evidence note")
    if source_id in EXPECTED_DOCUMENT_IDS:
        if document_id(filename) != source_id:
            raise SourceError("information-sheet ID does not match supplied filename")
        source_edition = edition(filename)
        label, pages, version = sheet_pdf_metadata(input_path, source_edition)
        metadata = {"edition": source_edition, "edition_label": label}
        target = ORIGINALS_DIR / filename
    elif source_id in LEGAL_EDITIONS:
        spec = LEGAL_EDITIONS[source_id].get(filename)
        if spec is None:
            raise SourceError("unregistered legal edition")
        pages, version = legal_pdf_metadata(input_path, spec)
        metadata = {"source_date": spec["source_date"], "version_label": spec["version_label"]}
        target = LEGAL_DIR / filename
    elif SUPPLEMENTAL_PDFS.get(source_id) == filename:
        pages, version = generic_pdf_metadata(input_path)
        metadata = {}
        target = LEGAL_DIR / filename
    elif source_id in SUPPLEMENTAL_IMPORT_FORMATS:
        if not reviewed_authority_url(official_url):
            raise SourceError("supplemental publisher is not in the reviewed authority registry")
        metadata = original_format_metadata(input_path, source_id)
        target = SUPPLEMENTAL_DIR / source_id / sha256_file(input_path) / input_path.name
        pages, version = None, None
        filename = input_path.name
    else:
        raise SourceError("source ID or document edition is not registered for local import")
    body = input_path.read_bytes()
    record = {
        "schema_version": 1, "source_id": source_id, "capture_method": "supplied_original_file",
        "official_url": official_url, "source_filename": filename, "local_path": relative_path(target),
        "retrieved_at": retrieved_at, "imported_at": utc_now(), "sha256": sha256_bytes(body),
        "file_size_bytes": len(body), "page_count": pages, "pdf_version": version,
        "http_provenance": None, "index_verified": False, "evidence_note": evidence_note,
        **metadata,
    }
    run_dir = PROVENANCE_DIR / ("import-" + new_run_id())
    if run_dir.exists():
        raise SourceError(f"import provenance run already exists: {run_dir}")
    preserve(target, body)
    preserve(run_dir / "import.json", json_bytes(record))
    return run_dir / "import.json"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    commands.add_parser("update")
    validate_parser = commands.add_parser("validate")
    validate_parser.add_argument("--check-index", action="store_true")
    validate_parser.add_argument("--manifest", type=Path, default=MANIFEST_PATH)
    import_parser = commands.add_parser("import", help="archive supplied original PDF with truthful local provenance")
    import_parser.add_argument("--source-id", required=True)
    import_parser.add_argument("--file", type=Path, required=True)
    import_parser.add_argument("--official-url", required=True)
    import_parser.add_argument("--retrieved-at", required=True)
    import_parser.add_argument("--evidence-note", required=True)
    args = parser.parse_args()
    try:
        if args.command == "update":
            update_sources()
        elif args.command == "validate":
            validate_sources(args.check_index, args.manifest)
        else:
            path = import_original(args.source_id, args.file, args.official_url, args.retrieved_at, args.evidence_note)
            print(f"PASS: original imported; current manifest unchanged; index/table review pending: {relative_path(path)}")
    except (SourceError, OSError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
