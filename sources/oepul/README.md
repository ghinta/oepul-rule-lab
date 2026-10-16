# Official AMA ÖPUL sources

This folder stores a verifiable copy of the sources linked by AMA, the Austrian
paying agency. The core pack contains the general participation conditions and
all 26 measure leaflets. It also includes the linked special directive and its
annexes, plus four selected official exception notices for 2026.

Documents keep their real revision dates. A leaflet still linked as October
2025 is not renamed to look like a 2026 edition.

## Contents

| Path | Contents |
| --- | --- |
| `originals/` | Unchanged PDFs named by edition |
| `legal/` | Special directive and annexes, with official names and dates |
| `notices/2026/` | Unchanged HTML for selected 2026 exceptions |
| `manifest.json` | Current source records |
| `manifest.schema.json` | Manifest structure |
| `provenance/<run-id>/` | Three index-page snapshots, manifest and fetch log |
| `manage_sources.py` | Update and validation tool |

The leaflets say they are not legally binding. This pack does not claim legal
completeness: other national or EU law, later changes and individual decisions
may apply. The manifest records `scope.legal_completeness_claimed: false`.

## Update

Requires Python 3.11 or newer and `pypdf`. From the repository root:

```bash
python3 sources/oepul/manage_sources.py update
```

The tool fetches the three official indexes, checks for the general conditions
and 26 known measures, and downloads the linked core PDFs, two legal PDFs and
four selected notices. It checks PDF headers, filenames and printed revisions,
then writes new originals, a permanent retrieval record and the root manifest.
Existing originals with different bytes are never overwritten: a collision
stops the update for review as a new source edition. Old editions stay available.

## Validate

Check local files and metadata:

```bash
python3 sources/oepul/manage_sources.py validate
```

Also check all three live AMA indexes:

```bash
python3 sources/oepul/manage_sources.py validate --check-index
```

The second command needs network access. An official update can make the live
index differ legitimately; run `update` and review the changes. Additional
notices are selected explicitly in the updater's `NOTICE_SOURCES` list.
Original official documents remain in German to preserve exact citations.
