# Verification — Lab #104 continuation, 10 October 2026

Continuation starts at PR #105 head 3077bdc. The mutable root manifest now points
to immutable AMA capture run 20261010T205920107220Z. All September originals and
manifests remain intact. Tests pin the historical pre-HTTP 0/43 fixture instead of
requiring the current pointer to stay historical.

## Network and acquisition

- Current fresh observations: running, spec revision 2, enforced policy with
  *.ama.at plus package-manager presets. Initial startup state was unknown and
  was not asserted to be enforced; network-check.json records the distinction.
- Real requested Merkblätter GET: HTTP 200, 36,692 bytes, inherited proxy and TLS
  verification. No configuration/proxy/TLS bypass.
- Standard update stopped on changed notice HTML without overwriting history.
  Explicit update --capture-changed-notices succeeded additively.
- All 27 sheets freshly fetched with identical September hashes: 11 editions
  from 2026, 16 from 2025. SRL/annexes pass 94/104 pages and 2026-0.267.890 checks.
- manage_sources.py validate --check-index passed: three live AMA indexes,
  27 sheets, two legal PDFs and four core selected notices.
- Supplemental captures: WRRL programme/Anlage 3, provider list, AMA GSP-AV/NAPV
  mirrors and missing 25 August/2 September notices. Intake pins 40 distinct
  complete original files; supplied-file import labels and separate real HTTP
  observations remain truthful. Four changed notice article HTML sections are
  byte-identical to their historical versions; surrounding HTML changed.

## Independent source reviews and gates

- Inventories/extractions match: L 489 items/4 raw footnotes incl.441 cells;
  J 86/1 incl.64 cells; livestock 35/2 incl.23 factor rows; providers 129/1
  incl.105 X/blank cells; WRRL 540/31, all five tables, 127 substantive rows,
  399 data cells and structural blanks. Every matrix/provider cell and WRRL
  value/note was independently compared to the original. Reconciliation binds
  both separately hashed artifacts and explains their creation-time statuses.
- L and livestock have no completion review pin: official footnote 4 is clipped;
  Anhang A does not establish year, grazing and Alm period-source mapping.
- Inventory integrity: 33 ready, ten pending. Strict selected o6_3/J/providers/
  WRRL Anlage 3 acquisition passes; strict global readiness exits 1 naming all
  ten missing scopes. Source acquisition does not establish expert admission.

## Validation

- PYTHONPATH=src OPA_BIN=/workspace/.tools/opa OPA_RUNTIME=local python3 -m unittest
  discover -s tests -v: 112 tests passed without skips.
- Validator regressions: 11 tests passed. Final intake suite after the two extra
  notices: 22 tests passed; independent intake plus notice suite: 23 passed.
- Existing o6_3 contract: 46 variables, 17 rules, 46 citations, 20 RGVE categories;
  eight open blockers and promotion_ready false.
- Repository-pinned OPA 1.18.2: format, strict compile and tests passed; explicit
  nonempty adaptation test invocation passed 3/3.
- git diff --check passed. All 2,201 pre-existing tracked files in originals,
  legal, notices, provenance, runs, canonical profile and adaptations match
  3077bdc. New source artifacts in these paths are additive.
- Independent review: no actionable P1/P2 findings; original value/cell fidelity,
  source hashes/provenance, six notice targets and remaining gaps checked.

No model runs, thesis changes, App rule admission, expert-question closure or
merges. Synthetic fixtures are technical regression tests, not Golden validation.
Blocking PR CI is checked on the pushed final commit.
