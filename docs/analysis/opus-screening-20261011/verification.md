# Verification of diagnostic preparation

These checks establish reproducible development observations. They do not
supply independent domain labels or approve the study method.

| Original check | Recorded result |
| --- | --- |
| Fixed publication | PR #79 at `e009eed4a83ff076b26eba33ac433ac2b0642621`; 1,430 relevant files checked against published Git blob IDs |
| Selection | 36 finalized publications, 26 latest candidates, ten superseded; all metadata bound |
| Translation contracts | 26 valid fixtures accounting for all 78 original Luna roles through mappings or gaps |
| Isolated strict compilation | 26/26 passed, native policy/data only |
| Supported partial probes | 59 executed: 54 defined, five runtime errors; five complete fixture gaps |
| Exact Opus replay | JSON/CSV/Markdown/HTML and all bindings passed |
| Luna execution | 76 defined, two undefined from the original 78 cases |
| Repository regressions | 136 tests passed, including 18 new integrity/execution checks |
| Validator | 11 tests passed |
| o6_3 source/app contract | Passed; eight promotion blockers stayed open |
| Four proposed thesis-clause source PDFs | Matching direct PDF hashes in the selected Opus source packs |
| Review | All 26 translations reviewed; unsupported o6_9 individual records removed and o6_12 query narrowed to supported facts |
| Formatting | `git diff --check` passed |

Before publication, the first local report draft was discarded after the o6_9
correction. The final manifest bound the corrected fixture. No discarded draft
was committed; changed input was correctly rejected against the old draft.
Historical model rules were unaffected.

Repeat from the analysis repository root with a separate pinned candidate checkout:

```bash
PYTHONPATH=src OPA_BIN=./tools/opa python -m rulelab.opus_screening verify \
  --candidate-root ../candidate-e009eed
```

CI checks the candidate Git HEAD and repeats the same comparison. A remote CI
pass must be tied to its actual commit/run, not assumed from a local pass.

The later path-privacy cleanup updates current metadata bindings, the Luna
baseline reference and English presentation. Pinned Opus source/rule/data/test
bytes and original fixtures/observations remain unchanged. Old report hashes
refer to the original publication, not this updated presentation.
See [publication rules](../../publication.md).
