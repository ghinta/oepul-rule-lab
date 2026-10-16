# Verification for #97

Original base: `84482b59264c04e3f645460ebe15f6b64b3b85ef`.
Original branch: `codex/issue-97-heuwirtschaft`. Local review: 7 October 2026.

The original review passed 80 repository tests, 11 validator tests and OPA
1.18.2 formatting, strict compilation and three direct tests. Forty-one new
Python tests checked contracts, provenance and actual OPA outputs, including
all 20 RGVE categories. Quotes were found on the cited PDF pages; schemas
matched Pydantic and bound file hashes were checked.

The first remote run exposed an environment-dependent auto-selection test.
It now removes only explicit `OPA_BIN`/`OPA_RUNTIME` overrides; the separate
override test remains. Local OPA passed the version check; CI separately uses
the official platform binary and checksum. A local pass is not a remote CI pass.

| Source/review case | Observed adaptation result |
| --- | --- |
| Leaflet example | 5 RGVE / 13 ha; 11 ha payment area, EUR 1,603.80 indication |
| Later year without animals | Historical entry remains satisfied, current rate zero |
| Four adult New World camelids on 2 ha in first year | 0.60 RGVE, threshold met |
| One small adult equid on 2 ha in first year | 0.50 RGVE, threshold missed |
| Year 2030 after a 2028 contract end | Outside contract, no positive payment indication |
| Unknown silage storage | `missing_data`, null payment indication |
| Unmown arable forage in drought area | No automatic exemption; obligation open before due date, violated after due date when failure is confirmed |

Further cases cover averaging, explicit null, incomplete/empty exports, category
conflicts, foreign locations, the 1.99/2-ha boundary, dated entry, snapshot/year,
cutting dates, second crops, options, seasonal obligations and scoped recognition.
A matching recognition requests legal review while retaining other violations.

Review #99 corrected `kleegrass` missing from the first-year denominator:
0.7 RGVE / 2 ha appeared to pass, but the extra 1-ha clover-grass field makes
0.7 / 3 ha fail. Unknown crop codes now yield `missing_data` and null sums,
rate and estimate; confirmed `non_fodder` is checked separately. Nonfinite
numbers are rejected before OPA in all six numeric area/stock fields. All seven
obligation IDs have exact source links, checked on their PDF pages.

```bash
OPA_BIN=./tools/opa PYTHONPATH=src python3 -m unittest discover -s tests -v
python3 -m unittest discover -s runner/validation/tests -v
python3 runner/validation/opa_validate.py validate \
  --workspace adaptations/o6_3 --runtime local --opa-bin ./tools/opa \
  --target policy --target data --target tests --pretty
```

These are visible development regressions, not a controlled model benchmark.
Later public-metadata changes update lineage hashes only; the candidate rules,
sources, fixtures and observed results retain their bytes.
