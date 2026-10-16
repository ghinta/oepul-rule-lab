# Hay farming: source-backed adaptation for #97

This is a manually repaired, limited candidate based on the Luna run and the
sources bound in `lineage.json`. It evaluates part of the hay-farming measure
(`Heuwirtschaft`). It does not provide a complete funding recommendation.
The historical model rules and shared farm profile are separate from it.
The Opus revisions announced for 8 October 2026 are not included; a later app
integration must check their relevant changes again.

## Run

From the repository root, with a matching OPA executable:

```bash
PYTHONPATH=src python3 -m rulelab.heuwirtschaft \
  --input adaptations/o6_3/fixtures/merkblatt-example.json \
  --opa-bin ./tools/opa
```

The CLI validates the input with Pydantic models matching `input.schema.json`,
then runs Rego. Python does not calculate a second domain decision. `status`
covers only the listed clauses; `indicative_premium_eur` is a gross estimate.
General eligibility, parcel combinations, new land, payment modulation,
reductions and payment processing are not fully implemented.

## Input contract for app integration

The host builds a separate input copy from the current snapshot and valid
factual additions. Keep scenario assumptions separate. The host sets
`context.current_year`, `context.snapshot_year` and `context.as_of` from the
request and actual data, rather than letting users edit them. The CLI checks
consistency; P1/P2 must select the current data.

| Input | Required meaning and evidence |
| --- | --- |
| `farm.year`, `context.*` | Current funding year, snapshot year and assessment date; no silent previous-year fallback. |
| `contract_start_year`, `first_year.*` | Valid contract and dated first-year evidence. Current livestock cannot prove historical stocking. |
| `land.parcels_complete`, `livestock.species_groups_complete` | Explicit confirmation that the effective inventory is complete. An import alone is insufficient. |
| `land.parcels[]` | Stable ID, area, land use, Austrian location and application link. Cutting dates are observations up to the assessment date. |
| `crop.forage_crop_type` | Known code from `data/tables.json` or explicitly confirmed `non_fodder`. Unknown codes remain `missing_data`. For forage crops, provide `is_second_crop`. |
| `livestock.species_groups[]` | Stable group ID, species and RGVE category from the closed table. Map age and size explicitly. A known `other` category can represent deer or New World camelids. |
| `average_count`, `animal_count` | Supported average or reference-date stock. Cattle require an average; other submitted averages must have the required basis. |
| `farm.heuwirtschaft.*` | Actual current facts about silage, fermentation, green feeding, transfers and options. Missing/null means unknown; `false` is an explicit denial. |
| `operations.full_mowing_and_removal`, `full_grazing` | Separate annual management evidence. One cutting date does not prove full-area mowing or removal. |
| `exceptions.recognitions[]` | Actual AMA recognition, with obligation, year, period and parcel IDs where required. Intent or an estimate is insufficient. |

Every consumed path needs a registry entry, consumption dependency and app
DecisionTrace covering origin, overrides, withdrawal and expiry. A registered
field alone is not an integration. `missing_data` lists missing consumed paths.
Wrong types, nonfinite numbers, duplicate IDs and impossible observation dates
are rejected before OPA. Missing and null remain genuine data gaps.

The three clause statuses distinguish satisfaction, known failure and missing
facts. Annual obligations remain open before their season/year ends. A matching
authority recognition triggers review of its legal effect, without suppressing
other violations or implying a positive overall decision.

## Evidence and limits

`citations.json` links repairs and obligations to exact PDF pages, sections and
quotes. `decision.rule_sources` maps every obligation ID to its evidence,
including silage preparation/feeding, fermentation, storage, green feeding and
hay transfers. Tests check these links and all bound source/upstream hashes.
RGVE factors and payment rates keep the Luna source inventory's values; category,
species and averaging metadata were added. Table values are not editable farm facts.

Force-majeure effects and the method for assessing predominant green feeding
need expert review. Two-year mountain-meadow management and other excluded
shared conditions remain outside this candidate. See [acceptance](docs/acceptance.md),
[verification](docs/verification.md) and [reasons](reasons.md). #97 remains open.
