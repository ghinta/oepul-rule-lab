# Draft: o6_16 with GPT-5.6 Terra

**Historical draft: technically checked, not domain-approved.**
Run `v2-o6_16-terra-20260919` used `discover`, GPT-5.6 Terra, high reasoning
and OPA 1.18.2. Sources were the April 2026 groundwater-protection leaflet and
general conditions, the special directive/annexes and four 2026 notices.
It studies whether discovery can recover rules and input fields for a measure
previously parked because required facts were missing.

## Recorded results

| Metric | Result |
|---|---:|
| Structured rules | 34 |
| With explicit Rego symbol | 21 |
| Source citations | 30 |
| Coverage entries | 40 |
| Proposed profile leaf paths | 94 |
| In the representative parcel object | 47 |
| Input paths directly used by Rego | 21 |
| Unknown Rego input paths | 0 |
| Data tables | 4 |
| Data file | 210,643 bytes |
| Generated OPA tests | 9 |
| OPA formatting | passed |
| OPA Strict-Compile | passed |
| OPA Tests | 9/9 passed |
| Source-evidence contracts and cross-links | passed, no errors |
| Direct shared-profile change | no |

The 94 leaf paths belong to one non-overlapping `add oepul.o6_16` proposal.
Proposal-object count therefore differs from variable count. Topics include
participation, deadlines, area history, nutrient planning/balance, training,
water protection, soil samples, the Vienna humus option, pig feeding, Cultan
and parcel-level nitrogen, substances and restricted periods.

The data file includes all 1,566 Annex G geographic entries, with cadastral
code, state, page and raw table text; pig-feed crude-protein limits; rates;
and the 2026 drought area list. The stable cadastral code is used because text
extraction cannot always separate political and cadastral municipality names.

The older GPT-5.5 run used the October 2025 leaflet, ten required input paths,
ten rule/error codes and five tests, including pre-evaluated facts such as
`soil_samples.requirement_met`, without the full executable Annex G list.
Terra's broader output is not an isolated model improvement: source edition,
contract, profile-discovery policy and validator also changed.

## Repair history and limits

Five attempts were recorded: a usage-limit interruption during an initial
multi-measure run; complete extraction; evidence/profile/inventory repairs;
a Rego inline-condition repair; and a namespace correction from nonexistent
filename namespaces to loaded `data.*` roots. Final host checks passed the
source-evidence, formatting, strict-compilation and nine-test checks.

Nine model tests cannot establish correctness of 34 rules. Thirteen catalog
rules lack an explicit Rego-symbol link. Referenced external legal facts, such
as substance authorization, remain external parameters. The 94 proposed paths
are not an approved shared profile. Expert and independent negative/reference
tests remain outstanding. This draft records technical results and limits,
without publishing private raw logs or claiming legal completeness.
