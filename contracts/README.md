# Rule-Lab contracts

These contracts keep rule generation reproducible while allowing the model or
provider adapter to be replaced. Their purpose is maximum source-grounded rule
extraction. They do not impose thesis sampling, gold-test, holdout, or scoring
gates.

## Contract set

| File | Purpose |
|---|---|
| `model-config-v1.schema.json` | Live `config/models/*.json` adapter and model identity |
| `generation-config-v1.schema.json` | Declarative provider/model, source, mode, and output preset |
| `run-artifact-v1.schema.json` | Incremental `runs/<run_id>/run.json` metadata written by the CLI |
| `artifact-inventory-v2.schema.json` | Grounded file-level inventory and hashes for a completed run |
| `profile-diff-v1.schema.json` | Current flattened `artifacts/profile-diff.json` shape |
| `source-references-v2.schema.json` | Source-to-symbol references with verifiable evidence text |
| `rules-catalog-v2.schema.json` | Strict structured catalog with citation IDs |
| `profile-changes-v1.schema.json` | Source- and rule-linked profile change proposals |
| `coverage-ledger-v1.schema.json` | Section, paragraph, table, footnote, and notice review ledger |
| `data-inventory-v1.schema.json` | Hashes and row counts for generated executable tables |
| `execution-evidence-v1.schema.json` | Per-rule executable/documented/unresolved status, source-to-Rego links, and test evidence for Quality Gate v2 |
| `run-comparison-v1.schema.json` | Vergleichbare Kennzahlen mehrerer Modellläufe |
| `raw-log-event-v1.schema.json` | Minimal JSON-object constraint for each provider-native JSONL event |

The schemas use JSON Schema Draft 2020-12. Contract versions describe file
semantics, not research protocol versions.

The v1 rule-catalog, source-reference, and inventory schemas remain only for
reading archived pilots. New runs require the versions listed above. Regenerate
the six model-authored schemas from their authoritative Pydantic models with
`python3 -m rulelab export-schemas`.

## Model switching

The live CLI receives a file below `config/models/` through `--model`. A model
configuration fixes the provider, API style, adapter, provider-native model ID,
command, and timeout. Adapter files contain no credentials. New providers
should add an adapter branch to `model-config-v1.schema.json`; generated files
and the run layout remain unchanged.

The YAML generation presets are declarative examples for a future config
resolver. The current CLI continues to use explicit `prepare` arguments and the
referenced `config/models/*.json` file. A resolver must materialize the same
`run.json` and layout, not invent a second run format.

## Discover and conform

Both modes copy `profiles/canonical_farm_profile.json` twice:

- `baseline_profile.json` is the immutable comparison snapshot;
- `workspace/canonical_farm_profile.json` is the run-local working copy.

The working copy is read-only by contract in both modes. `discover` records
needed additions, changes, and removals in `rules/profile_changes.json`. The
finalizer validates their rule and source links, applies them to an in-memory
copy, and writes `artifacts/proposed-profile.json`. A rule must not be dropped
merely because the starting profile is incomplete.

`conform` requires an empty proposal list. Any direct working-profile edit
fails every mode and is captured separately in `direct-profile-diff.json`.

The canonical repository profile is never edited by a run. A useful discovery
can be reviewed and promoted later through a separate repository change.

## Run lifecycle and paths

One run represents one generated candidate. Multiple candidates receive
separate run IDs so profile changes, logs, and files cannot overwrite one
another.

```text
prepared -> running -> generated -> finalized
                   \-> failed
```

The fixed layout matches `src/rulelab/cli.py`:

```text
runs/<run_id>/
  run.json
  model.json
  prompt.md
  baseline_profile.json
  workspace/
    canonical_farm_profile.json
    sources/*
    policy/**/*.rego
    tests/**/*.rego
    rules/rules.json
    rules/citations.json
    rules/profile_changes.json
    rules/coverage.json
    rules/data_inventory.json
    rules/execution_evidence.json
    notes/assumptions.md
    tools/opa_validate.py
    tools/opa-version.txt
  raw/
    events.jsonl
    stderr.log
    final-message.md
  artifacts/
    profile-diff.json
    direct-profile-diff.json
    proposed-profile.json
    grounding-validation.json
    input-paths.json
    metrics.json
    inventory.json
```

`run.json` is updated incrementally and validated by
`run-artifact-v1.schema.json`. It captures the model configuration, source-file
digests, baseline-profile digest, mode, timestamps, exit status, and summary
metrics. Paths are repository-relative or run-relative; portable artifacts do
not depend on machine-specific absolute paths.

`artifacts/inventory.json` hashes every source copy, both profile snapshots,
Rego module, Rego test, structured rule catalog, citations, profile proposals,
coverage, data inventory, assumptions, diffs, grounding result, and raw log.
The CLI materializes it only after every required output exists;
otherwise `metrics.json` lists the missing outputs and the run is marked failed.

## Required generator outputs

The generator must produce all of the following even when some semantics remain
ambiguous:

- `workspace/rules/rules.json`: every discovered normative or
  decision-relevant statement;
- `workspace/rules/citations.json`: source, page, section, normalized claim,
  exact evidence text, and generated Rego symbol/line mapping;
- `workspace/rules/profile_changes.json`: proposed profile changes with rule and
  source-reference links;
- `workspace/rules/coverage.json`: disposition of reviewed source locations;
- `workspace/rules/data_inventory.json`: every generated data artifact, hash,
  JSON pointer, row count, and source-reference links;
- `workspace/rules/execution_evidence.json`: Quality Gate v2 classification of
  every rule, with direct Rego/source/test evidence for executable rules;
- Rego-v1 modules below `workspace/policy/`;
- meaningful generated tests below `workspace/tests/`;
- `workspace/notes/assumptions.md`: ambiguity and unresolved questions.

`prepare` copies all six Pydantic-generated schemas into the isolated
workspace. `finalize` applies strict Pydantic validation (`extra=forbid`), then
checks cross-references, exact evidence presence on the cited page, source and
data hashes, artifact line bounds, profile proposal preconditions, source
coverage, table row counts, and Quality Gate v2 execution evidence before it
writes an inventory.

Generated tests are extraction aids, not independent proof that a rule is
semantically correct.

## Profile diff

The live finalizer flattens the baseline and validated proposed profile into dot
paths. Paths found only in the proposal appear under `added`, lost paths under
`removed`, and changed values as `{before, after}` under `changed`. Array shapes
use the `[]` marker because the canonical profile is a shape blueprint rather
than farm case data.

The diff records what changed. The structured rule catalog, citations, and
assumptions record why. Every discovered input path should link to at least one
extracted rule and source reference during validation.

## Source references and raw protocol

Source references store a normalized claim plus a short verbatim
`evidence_text`. The source hash binds it to the copied document; page and
section locate it; the finalizer normalizes and finds the evidence on that page
or in the HTML source. `used_by` maps it to generated symbols and line ranges.

`raw/events.jsonl` is append-only provider-native stdout. Each non-empty line is
a JSON object, but provider fields remain verbatim. `raw/stderr.log` and
`raw/final-message.md` preserve remaining command output. Derive summaries in
new files instead of rewriting raw logs.

Adapters must not print credentials. Raw logs may contain prompt/source content
and should not be committed before review. `redact_credentials: true` in the
declarative config is required adapter behavior, not proof that arbitrary
provider output has already been sanitized.

## Examples and validation

Examples live under `config/`:

- `generation.discover.example.yaml`
- `generation.conform.example.yaml`
- `run-artifact.example.yaml`
- `artifact-inventory.example.yaml`
- `profile-diff.discover.example.yaml`
- `source-references.example.yaml`

Syntax-only checks need no project dependencies:

```bash
for schema in contracts/*.json config/models/*.json; do python3 -m json.tool "$schema" >/dev/null; done
ruby -e 'require "yaml"; ARGV.each { |path| YAML.safe_load(File.read(path), permitted_classes: [], aliases: false) }' config/*.yaml
```

Full validation should use a Draft 2020-12 implementation with external `$ref`
resolution rooted at `contracts/`. The runner validation and source-pack
directories remain independently owned; these contracts modify neither.

## Live-runner compatibility and remaining integration

`run-artifact-v1.schema.json` mirrors the keys and lifecycle currently emitted
by `src/rulelab/cli.py`; `profile-diff-v1.schema.json` mirrors the current
baseline-to-proposal diff. Pydantic and the grounding validator actively
execute the five generator contracts. The following declarative capabilities
are not yet applied to the live request:

1. `generation-*.yaml` is not yet a CLI input. Source scopes,
   `candidate_count`, temperature, top-p, seed, and token budget in that preset
   are therefore not applied to a live request.
2. The current CLI selects the requested measure, general conditions, legal
   sources and 2026 notices directly from `sources/oepul/manifest.json`; the
   declarative `clause_scopes` filter is not yet applied.
3. Raw JSONL shape and credential redaction depend on the chosen adapter; the
   CLI does not normalize provider events.

These are runner follow-ups, not reasons to weaken the generation contract.
Until they are implemented, `run.json` remains authoritative for what was
actually selected and invoked.
