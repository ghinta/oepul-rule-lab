# Hay farming: source review and input contract

Historical review date: 7 October 2026. Step 1 of
[App #136](https://github.com/ghinta/oepul-recommender/issues/136), linked to
[Lab #97](https://github.com/ghinta/oepul-rule-lab/issues/97).
Lab base: `0760684b5029d65feeca984bf627a3c6269a9955` (PR #99).
App base: `14e5422b9977f78eb2f7edfb99313e4aac39f9a7` (PR #135).

## Result

The bound adaptation has 46 typed input paths, 17 rule/calculation groups and
20 RGVE categories. Sources, types, rule consumers and existing app registries
are linked per path. This is an implementation draft, not approval for app use.
Rule-specific open questions remain in `source-review.json`.

Four registered fields can be reused: parcel area, land use, animal count and
cutting dates. Only cutting dates are currently consumed by the app's o6_3
policy. Existing management events do not prove full-area management. App #135
separates time, snapshot and scenarios; it does not fill these data gaps.

The lab reads `input.farm/land/livestock/exceptions/context`. The app reads
`input.payload` with trusted `input.evaluation_context`. A new measure adapter
must copy only `current_year`, `snapshot_year`, `as_of` into the strict lab
context, map checked effective facts to native paths, and retain snapshot
ID/digest and sources in app provenance. The old Category-C presence check is
not a complete funding decision. This mapping is defined, not implemented here.

`purpose` / `app.evidence_purpose` describe host identity and `current_fact`;
they do not add a database purpose. Historical first-year evidence is captured
as a current snapshot-bound declaration with `evidence_time_role:
historical_first_year` and its real evidence year. Contract start cannot be
inferred from the earliest date of an unrelated measure.

Animal identity needs special care: the app groups animals by species, whereas
RGVE needs stable age/breed/size cohorts. Overwriting a species group with one
category would lose evidence. Plan stable cohorts while retaining old IDs and
provenance. Existing `gve` is not proof of RGVE.

## Source review

The six-page hay-farming leaflet and 21-page general conditions were reviewed,
including tables and exceptions. The relevant directive sections, hay-farming
rule on PDF page 50, Annex A RGVE key on PDF page 3 and scoped drought notices
of 5/12 August 2026 were cross-checked. This is not a full review of all measures
or all 103 annex pages. `citations.json` contains 46 exact page/section quotes.
All 20 coefficients are checked against source table blocks. Payment rates
135/155 EUR for 2023 and 145.8/167.4 EUR from 2024, including the zero tier,
remain normative data. The directive/annexes are legally authoritative;
leaflets are explanatory. Hash identity alone does not establish current law.

| Rule group | Source and review result |
| --- | --- |
| CURRENT_BASIS | Technical host contract from App #135, not a funding law. |
| CONTRACT / COMBINATION | Leaflet 3.1/3.2/6: start 2023–2025, end 2028, concurrent UBB/BIO/partial-farm BIO combination. Require actual contract/application evidence. |
| FIRST_YEAR_AREA / FIRST_YEAR_RGVE | Leaflet 3.3/3.4/4: 2 ha and 0.30 RGVE/ha in the first year. Later years need historical evidence, not current stock as a substitute. |
| CURRENT_RGVE | Leaflet 8 / Annex A: all categories; small equids 0.50, not 1.00; consider dwarf breeds/deer footnote. Cattle use day-based database averages; others use the required reference-date/submitted average list. |
| FORAGE_AREA | All applied grassland/arable forage, including arable pasture; exclude second crops. Payment exclusion alone does not reduce this denominator. |
| PREMIUM_AREA / PREMIUM_RATE | Mown meadows/meadow pastures and eligible arable forage. Arable pasture counts in the denominator, not the payment area. Shared exclusions, combinations, new land and settlement remain incomplete. |
| SILAGE / FERMENTATION / STORAGE | Leaflet 5.1/5.3: whole farm, all species/buildings/old stocks; do not assume byproducts or haylage are allowed. |
| GREEN_FEEDING | Leaflet 5.2: predominant share from 1 April–30 September for all roughage eaters; shared/alpine pasture may count. No source-confirmed 92-day or addition method. |
| HAY_TRANSFER | Leaflet 5.4: dry hay only, including transfers between hay farms. Explicit complete confirmation of no transfer can support compliance; missing data cannot. |
| MOWER_CONDITIONER | Leaflet 5.5: valid annual option excludes use on all farm land and presence of relevant equipment. |
| MINIMUM_MANAGEMENT | Directive 1.6.3.3: full-area mowing AND removal, or grazing. One date is insufficient. Mountain meadows and special exceptions need separate handling. |
| RECOGNITION | Directive 1.7.4.1 / section 6 GSP-AV: review affected obligation, land, time and legal effect. No blanket drought/recognition flag. |

## Open before a full recommendation

1. **GROUP_IDENTITY:** stable RGVE cohorts, not one species group.
2. **COUNT_BASIS:** count plus year, reference date/period, source and actual
   average-list status. An optional number alone is insufficient.
3. **GREEN_FEEDING_HISTORY:** zero animals today does not prove zero through the
   past season. Seasonal history and the assessment method are missing.
4. **RECOGNITION_TIME:** the candidate currently requires `as_of` inside the
   recognition period, potentially missing earlier incidents. Model incident
   and obligation periods separately.
5. **GENERAL_FUNDING:** applicant/parcel eligibility, OP codes, combinations,
   new land, mountain meadows, modulation, caps and sanctions are incomplete.
6. **ANNUAL_EVIDENCE:** observations are not final annual compliance or annual
   averages. Show open obligations/periods; separate reasoned future notes.
7. **SOURCE_CURRENTNESS:** check applicable law before app use; a year label is
   not proof of currentness.
8. **OPUS_REVISION:** compare the revisions announced for 8 October 2026.
   The bound September run is a reference only.

`proposed_evidence_extensions` in `variables.json` records planned metadata.
The strict current schema does not accept those proposed fields yet.

## Development observations and next work

`development-probes.json` contains ten synthetic inputs and observed outputs:
seven source cases (leaflet example, later year without animals, camelid/equid
boundaries, contract end, unknown storage and unmown arable forage) plus three
remaining-risk probes. These show that zero current animals with unknown green
feeding can produce `eligible`/EUR 0; an unsupported average can be preferred;
and a May–June recognition assessed in October can miss legal-effect review.
These problematic outputs are observations, not approved expected decisions.

The next app step must address the structure/data-flow gaps and connect only
supported clauses. Later work connects UI, DecisionTrace and stored runs.
#97/#136 stay open. This review changes no candidate rules, app storage or farm
profile and supplies no model ranking, hidden tests or independent accuracy score.

Files: `baseline.json`, `app-inventory.json`, `source-review.json`,
[variables](variables.md) / `variables.json`, `citations.json`,
`development-probes.json`, [verification](verification.md), [reasons](reasons.md).
Original machine-readable evidence keeps its wording.
