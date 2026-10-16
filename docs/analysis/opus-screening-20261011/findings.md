# Opus findings and next thesis decision

All 26 selected candidates have been diagnosed. The [matrix](matrix.csv),
[source/contract comparison](comparison.csv) and [native outputs](results.json)
link findings to exact files. Full app integration is not required for the
limited thesis experiment.

All 26 isolated policy/data bundles compile strictly with OPA 1.18.2. Of 59
supported translated probes, 54 return a value and five produce runtime errors.
Five measures have no meaningful native probe from the available Luna facts.
Different scopes make these execution counts unsuitable as an accuracy score
or ranking against the 78 Luna cases.

| Measure | Observation | Meaning |
| --- | --- | --- |
| o6_3 | All three probes fail at `general.rego:24`, multiplying by a missing previous-year area | Incomplete facts can cause a strict runtime failure despite historical model-test passes. |
| o6_14 | Both probes fail at `participation.rego:19`, subtracting one from a missing contract year | A reproducible error; exact dates and animal details are not invented. |
| o6_1a, o6_1b, o6_2, o6_5 | Variation inputs equal baseline inputs | The original changed fact has no supported native mapping; equal outputs do not prove insensitivity. |
| o6_12 | Insecticide use with unknown date yields no native violation | No violation is not proof of compliance; the year remains 2024. |
| o6_13, o6_15 | Missing parcel/alpine-pasture identity suppresses partial results | The broader native contracts need facts absent from the old cases. |
| o6_16 | Ten aggregate training hours cannot supply individual course records | A default of zero is not a factual training assessment. Variation/removal remain gaps. |
| o6_20, o6_23 | Missing facts may receive favorable defaults | Missing, false and confirmed compliance do not have a common meaning across models. |

Explicit `fixture_gap` records cover o6_17, o6_19, o6_21, o6_22 and o6_24:
dated laboratory records, individual parcels/indicators, animals/buildings,
category/count evidence or an equivalent supported input are missing.

Nine source sets differ from Luna; 17 match. The ledgers report 11 unresolved
coverage points. Original tool, repair and budget conditions also differ.
These constraints prevent an isolated claim that one model is better.
Costs in `comparison.json` are reported list-cost equivalents, not invoices;
last cumulative session values are counted once per publication.

For the four proposed #56 clauses, create a neutral common input matrix and
independent expert-labelled cases. Current probes for o6_13, o6_14 and o6_17
exercise different facts from those clauses and cannot validate them. Preserve
the historical 10.4-ha o6_17 basis without inventing a 0.4-ha parcel.
The diagnosis supplies input/evidence requirements, not study-method approval.
See [method.md](method.md) for the complete limits and follow-up sequence.
