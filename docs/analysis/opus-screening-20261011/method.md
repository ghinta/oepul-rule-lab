# Opus screening: method and limits

This diagnosis supports [Lab #107](https://github.com/ghinta/oepul-rule-lab/issues/107)
after the [Luna screening](../luna-screening-20261011/README.md). It prepares a
limited study for App #56 / draft #149, without new model generation or
independent expert labels.

## Fixed snapshots

The historical Luna baseline is `d2b63972c99056fde4e032029e1432639e281fda`.
Opus candidates come only from PR #79 at
`e009eed4a83ff076b26eba33ac433ac2b0642621`. Of 36 finalized publications,
`max(finalized_at, run_id)` selects the latest for each of 26 measures.
The ten superseded runs remain recorded. Selection does not filter by output,
rule count or technical success.

CI checks the candidate checkout's actual Git HEAD. Manifest hashes separately
check the bound files: all 36 metadata records and, for the selected 26,
sources, profile, model settings, prompts, proposed fields, policy, data,
model tests, catalogs, coverage, assumptions, historical checks and fixtures.
`load_paths` restricts execution to native policy/data files. Raw logs and old
binaries are excluded. A provider revision was not recorded and is not invented.

The privacy migration rebinds sanitized main-checkout metadata and the Luna
baseline records. The pinned Opus candidate checkout remains unchanged; exported
historical conditions are sanitized without changing its input hashes.
See [publication rules](../../publication.md).

Nine source sets differ from Luna: o6_1c, o6_4, o6_9, o6_12, o6_16, o6_17,
o6_21, o6_22 and o6_24. Seventeen sets match. Matching hashes prove identical
files, not correct interpretation or current law. New editions are not substituted.

## Same facts, native input contracts

`luna_translation` links every measure to its Luna fixture and accounts for all
three original roles: baseline, variation and missing fact. It documents mapped
paths/meaning, unsupported facts and scope differences, even when `cases=[]`.

Supported renaming, exact enum mappings and unit conversions are allowed.
Unknown animal categories, individual events, dates, permissions, registration
or compliance are not filled from model tests. Missing, null, false, zero and
empty lists stay distinct. Years and quantities are not changed to obtain a
preferred output; o6_12 stays in 2024.

A partial translation is a partial probe. When the original variation cannot be
mapped, native inputs may be identical: this is a translation gap, not proof
that a rule ignores the fact. JSON-pointer differences show actual changes.
Without a meaningful supported probe, the fixture has no executable cases and
states its gap. All 26 candidates still undergo isolated compilation.

## Execution and replay

OPA 1.18.2 and its platform checksum must match the repository pins. Only bound
policy/data directories are loaded, preserving JSON namespaces. Model tests
are case-origin evidence, not independent reference tests. Strict compilation
and bounded `data.*` queries use capabilities excluding network, current time,
randomness and runtime environment data. Evaluation is limited to ten seconds
and the process to 20 seconds.

`defined`, `undefined`, `runtime_error`, `compile_error` and `fixture_gap` describe
execution only. A defined `eligible=false` with incomplete inputs is not an
independent negative domain judgement. Payment and aggregate scopes differ.
Undefined components can make a complete projection undefined.

Use two separate checkouts. From the analysis repository root:

```bash
git clone https://github.com/ghinta/oepul-rule-lab.git ../candidate-e009eed
git -C ../candidate-e009eed checkout e009eed4a83ff076b26eba33ac433ac2b0642621
PYTHONPATH=src OPA_BIN=./tools/opa python -m rulelab.opus_screening verify \
  --candidate-root ../candidate-e009eed
```

`verify` checks bindings before/after execution and compares JSON, CSV, Markdown
and HTML byte for byte, without writes. `freeze` never overwrites a manifest.
Writes stay under `docs/analysis`, outside the candidate. Merging PR #79 is not
required. Original German model notes, fixtures and outputs remain evidence
inside the English report.

## Historical conditions and thesis scope

`comparison.json` records sources, profile, model/adapter, reasoning, timeout,
prompt hashes, attempts/resumptions, historical OPA metadata, available usage
and costs, and mapping gaps. Each run's last `generator_result` is counted once;
cumulative session values are not added again across resumptions. Attempt counts
do not include every internal repair or tool call. Missing Luna usage stays
missing. Different tools, repairs, budgets and sources prevent a controlled
claim about the model effect.

Historical records omit `quality_gate_version`; the handoff reports v1. A later
v2 metadata pass does not prove generation under v2 or domain completeness.
The ledgers report 11 unresolved coverage points: eight in the nine renewed
candidates and three in o6_1a, o6_10 and o6_23. These are model claims.

The four proposed thesis clauses remain a small targeted selection. Existing
probes do not establish the o6_13 deadline, o6_14 animal-group or o6_17 required
sample clauses: they exercise other facts. The o6_17 historical 10.4-ha basis
must not be rebuilt from today's ten hectares or an invented 0.4-ha parcel.

A neutral study matrix, common budgets and fixed model revisions need separate
binding, followed by independent cases (#51) and a collector (#52). Visible
cases cannot become hidden tests retroactively. #140 blocks only judgements
whose relevant interpretation remains open, not this technical diagnosis.
