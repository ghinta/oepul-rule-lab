# Verification record

The original screening was checked on 11 October 2026 with Python 3.12.14 and
OPA 1.18.2, Linux amd64, pinned SHA-256
`9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8`.

| Original check | Recorded result |
| --- | --- |
| Repository tests | 118 passed, including 29 screening tests; none skipped |
| Validator tests | 11 passed |
| Isolated strict compilation | 26/26 candidates passed |
| Development cases | 78 executed: 76 defined, two undefined, no technical execution errors |
| Exact JSON/CSV/Markdown/HTML replay | `python -m rulelab.screening verify` passed |
| Data namespaces | Direct o6_18 bundle regression and all 21 o6_12–18 case cross-checks matched full OPA JSON |
| o6_3 contract | 46 inputs, 17 rule groups, 46 citations, 20 RGVE categories checked; eight blockers remained open |
| o6_3 adaptation | fmt, strict check and 3/3 OPA tests passed |
| Preview and matrix | Local links existed; CSV had 26 unique measures and 16 columns |
| Original historical files | Bound files were identical before/after screening |

Tests cover changed/missing bindings, incomplete provenance, unsupported queries,
path escapes, missing versus null and other types, error classification,
exclusion of model tests and directory loading. A regression rejects unknown
or reordered case roles before execution. It preserves the baseline with
optional variation/missing-fact probes. No tests assert expert golden labels.

The undefined outputs are `o6_8/variation` and `o6_17/missing_fact`; both remain
visible. Technical passes do not remove the [method limits](method.md).

The later public-path cleanup changes metadata, hash references and report
presentation only. It retains the original fixtures and observed results.
See [publication rules](../../publication.md); the figures above describe the
original run, not a claim that the old report bytes remain unchanged.
