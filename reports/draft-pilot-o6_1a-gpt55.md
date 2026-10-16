# Draft: o6_1a pilot with GPT-5.5

**Historical draft: technically reproducible, not domain-approved.**
This pilot predates the v2 source-evidence contracts. Its contract check is not
equivalent to today's exact-quote, coverage, table and profile-proposal checks.
A controlled comparison needs a new run under the current common contract.

Run `pilot2-o6_1a-gpt55` used `discover`, GPT-5.5, high reasoning, the April 2026
UBB leaflet and general conditions, the special directive/annexes and four
2026 notices. OPA reference: 1.18.2. The goal was to see whether a model could
produce a broad executable candidate from the shared profile and official sources.

## Recorded results

| Metric | Result |
|---|---:|
| Structured rules | 70 |
| Source citations | 63 |
| Rego files including tests | 2 / 1,008 lines |
| Detected input profile paths | 141 |
| Profile paths added | 194 |
| Profile paths removed | 28 |
| Profile paths changed | 5 |
| Separate data files | 1 / 27,038 bytes |
| Generated OPA tests | 7 |
| OPA Strict-Compile | passed |
| OPA Tests | 7/7 passed |
| Rule catalog contract | passed |
| Citation contract with hash/path check | passed |

The data file includes 20 RGVE factors, 85 rare crops, 53 flowering/medicinal/
spice plants, 74 native arable species, 68 native grassland species and a
structured orchard list. Long lists remain executable data.

The initial profile was too small for broad extraction. Discovery made missing
inputs visible. A repair fixed Rego syntax; another exposed outputs that looked
like the JSON contracts but did not match them. Finalization therefore checks
fields, source hashes and resolvable paths rather than counts alone. The first
scanner missed `object.get`; nested access, aliases and collections now reveal
141 input paths in this pilot.

## Limits and next step

Seventy rules do not prove completeness. Seven model-written tests cover only
a small share of rules/exceptions. Added, removed and changed profile paths
need review, especially the 28 removals and five changes. Quotes locate claims
but cannot settle interpretation or source precedence. The third model call
hit a usage limit after contract repair; later independent finalization, with
empty error lists and passing OPA tests, is the recorded technical acceptance.

Version the experiment contract, compare the same measure with another model
under the same setup, then review common profile changes before `conform`,
hidden tests and domain review. The original draft kept full pilot logs and
duplicated sources local. This report records the measurements; it does not
publish private raw logs or certify legal correctness.
