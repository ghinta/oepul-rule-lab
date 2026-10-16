# Luna screening: method and limits

This analysis supports [Lab #106](https://github.com/ghinta/oepul-rule-lab/issues/106).
It makes existing candidates observable before choosing the thesis scope.
It is not a controlled model comparison and has no independent expert labels.

## Bound inputs

`manifest.json` selects one finalized `gpt-5.6-luna` run for each of 26 measures:
o6_1a/b/c and o6_2–o6_24. The historical base is
`7a296d28cb5b92e2758c5a3889c929ea1db60fe5`. Hashes and byte sizes bind sources,
profile, metadata, configuration, prompts, proposed profile, rules, data,
model tests, assumptions and validation files. IDs, dates and recorded attempt
counts identify each run. Query, input/output scope and case origin are in the
bound fixtures. `load_paths` lists the exact executable files.

The path-privacy migration updates metadata and its hash references only;
source documents, profiles, prompts, rule/data/test files, fixtures and observed
results retain their bytes. See [publication rules](../../publication.md).
Raw transcripts and old local executables are not loaded or newly exported.
Recorded attempt counts do not count every internal model repair or tool call.

Sources are checked against each run's historical hashes, not replaced with
newer editions. File identity does not prove current law or complete interpretation.
Coverage and rule types are historical model claims, not a new full-text review.

## Execution

OPA 1.18.2 and its platform checksum must match the repository pins. The runner
copies only each candidate's bound policy/data files into a temporary bundle
and loads their directories to preserve native JSON namespaces. Other measures
and model tests are excluded. `opa check --strict` checks each isolated bundle.

Each case sends its full JSON input through stdin. No common farm contract or
implicit facts are added. Queries are native `data.*` paths or documented,
limited projections. An undefined component can make a whole projection
undefined; the runner does not replace it.

Execution uses `--strict-builtin-errors`, a ten-second evaluation limit and a
20-second process limit. Capabilities exclude network access, current time,
random values and runtime environment data. A required blocked builtin causes
a visible compile error. A historical pass never overrides a current error.
Bound files are checked before and after execution. Writes stay in this report
folder; there is no model generation, formatting repair or app promotion.

## Cases and output meaning

Each measure has a synthetic baseline, one targeted fact change and one fact
removal: 78 visible development cases. Some are derived from model tests;
each fixture documents its origin. They cannot later serve as independent
expert labels or hidden tests.

Cases start with `baseline`, followed by optional `variation` and `missing_fact`
in that order. Unknown/reordered roles are rejected. Empty cases need an
explicit gap. Results record full inputs, hashes, JSON-pointer changes, native
outputs and complete OPA JSON responses. Missing, `null`, `false`, zero and
empty lists stay distinct. Technical statuses do not imply domain correctness.
The meaning of `eligible` and payment fields varies by measure.

Static input paths are incomplete and are not a trace of all facts read at
runtime. One unchanged output does not prove that a fact is never used.
Dynamic input provenance remains a limit of this diagnosis.
Original German model notes and observed outputs remain identified as evidence
in the English report; translating them would change the research record.

## Repeat

From the repository root, using the matching local OPA executable:

```bash
PYTHONPATH=src OPA_BIN=./tools/opa python -m rulelab.screening verify
```

`verify` checks bindings, repeats execution and compares JSON, CSV, Markdown and
HTML byte for byte, without writes. Timings, temporary paths and host data are
excluded from observations. `replay` regenerates outputs from bound inputs.
`freeze` needs a new report folder and never replaces an existing manifest.

## App and thesis limits

A limited [app preview #139](https://github.com/ghinta/oepul-recommender/issues/139)
needs an explicit bundle/query, input mapping and clause/parcel/farm scope.
Show missing facts and conflicting partial results separately. Payment values
remain unconfirmed estimates. This analysis does not implement that integration.
The separate hay-farming adaptation in
[App #136](https://github.com/ghinta/oepul-recommender/issues/136) has different
rules; its output must not be equated with the historical Luna output.

Before the controlled study in
[App #56](https://github.com/ghinta/oepul-recommender/issues/56), select relevant
rule types and define independent cases, required facts and open interpretations.
Keep poor candidates in scope when appropriate; do not select by favorable
outputs. No accuracy ranking or unsupported expert-hour estimate is given.
[App #140](https://github.com/ghinta/oepul-recommender/issues/140) blocks only
domain judgements that need its unresolved interpretations, not all technical
execution. Opus diagnosis is tracked in
[Lab #107](https://github.com/ghinta/oepul-rule-lab/issues/107); full expansion
remains future work in Lab #108 and App #148.
