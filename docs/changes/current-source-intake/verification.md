# Verification — Lab #104

Base: `7a296d2` (main). No current original download was possible: the managed
network allowlist excludes the needed AMA/BMLUK/RIS domains. Reading through
the independent web connector is recorded as link/section observation, never
as a hash or HTTP capture of the original PDFbytes.

Observed checks:

- `PYTHONPATH=src python3 -m unittest discover -s tests -v`: 78 tests passed;
  two existing OPA-dependent classes skipped locally because `OPA_BIN` was not
  supplied. CI stages the repository-pinned binary before this suite.
- `PYTHONPATH=src python3 -m unittest discover -s runner/validation/tests -v`: 11 tests passed.
- New `test_source_intake.py`: 19 tests passed. Covers historical validation,
  current legal editions and 94/104-page completeness check; cover-only/wrong
  edition rejection; immutable originals; truthful supplied-file provenance;
  current consumer scope versus pending scopes; missing/altered required IDs,
  false completion, metadata hashes, wrong measure original, stale/future dates,
  missing raw index evidence, independent item/footnote coverage, real format
  recognition and content-addressed external register/XLSX/GIS capture.
- `python3 sources/oepul/manage_sources.py validate`: 27 original sheets,
  two historical legal originals and four selected notices verified against the
  unchanged September manifest.
- `python3 sources/oepul/source_intake.py`: inventory integrity passed, as of
  2026-10-10, 0 ready and 43 pending. This is the expected truthful state.
- `python3 sources/oepul/source_intake.py --require-ready --scope o6_3`:
  exit 1 with explicit pending scope. Strict global readiness also remains
  pending; complete original/table/GIS capture was not performed.
- 2,192 existing tracked files under originals/legal/notices/provenance/runs,
  canonical profile and root source manifest were compared bytewise with the
  base commit: all unchanged.
- Python compilation and `git diff --check` passed.

Fixtures are synthetic, public-source-shaped data. No real farm data, model
run, expert answer, App rule admission, historical citation repin or completed
current matrix audit is claimed. New actual originals can be acquired via the
existing updater once the hosts are permitted, or through its reviewed local
original import path; required current captures/reviews remain open in #104.
