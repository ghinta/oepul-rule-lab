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
| `artifact-inventory-v1.schema.json` | Final file-level inventory and hashes for a completed run |
| `profile-diff-v1.schema.json` | Current flattened `artifacts/profile-diff.json` shape |
| `source-references-v1.schema.json` | Source-to-symbol references in `workspace/rules/citations.json` |
| `rules-catalog-v1.schema.json` | Strukturierter Katalog aller extrahierten Aussagen |
| `run-comparison-v1.schema.json` | Vergleichbare Kennzahlen mehrerer Modellläufe |
| `raw-log-event-v1.schema.json` | Minimal JSON-object constraint for each provider-native JSONL event |

The schemas use JSON Schema Draft 2020-12. Contract versions describe file
semantics, not research protocol versions.

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

`discover` permits the generator to extend or correct only the working copy
when a source rule requires an unrepresented fact. A rule must not be dropped
merely because the starting profile is incomplete.

`conform` prohibits any working-profile change. Finalization still produces a
diff for auditability and marks the run failed when any of `added`, `removed`,
or `changed` is non-empty.

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
    notes/assumptions.md
    tools/opa_validate.py
    tools/opa-version.txt
  raw/
    events.jsonl
    stderr.log
    final-message.md
  artifacts/
    profile-diff.json
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
Rego module, Rego test, structured rule catalog, citations, assumptions, diff,
and raw log. The CLI materializes it only after every required output exists;
otherwise `metrics.json` lists the missing outputs and the run is marked failed.

## Required generator outputs

The generator must produce all of the following even when some semantics remain
ambiguous:

- `workspace/rules/rules.json`: every discovered normative or
  decision-relevant statement;
- `workspace/rules/citations.json`: source, page, section, normalized claim,
  and generated Rego symbol/line mapping;
- Rego-v1 modules below `workspace/policy/`;
- meaningful generated tests below `workspace/tests/`;
- `workspace/notes/assumptions.md`: ambiguity and unresolved questions.

`prepare` copies the rule-catalog and source-reference schemas into the
isolated workspace. `finalize` rejects wrong top-level versions or shapes,
invalid required rule fields, unresolved citation artifact paths, and source
hash mismatches before it writes an inventory. This validation intentionally
has no optional Python package dependency so the contract gate remains active
in minimal agent environments.

Generated tests are extraction aids, not independent proof that a rule is
semantically correct.

## Profile diff

The live finalizer flattens both profiles into dot paths. Paths found only in
the working copy appear under `added`, lost paths under `removed`, and changed
values as `{before, after}` under `changed`. Array shapes use the `[]` marker
because the canonical profile is a shape blueprint rather than farm case data.

The diff records what changed. The structured rule catalog, citations, and
assumptions record why. Every discovered input path should link to at least one
extracted rule and source reference during validation.

## Source references and raw protocol

Source references store a normalized claim rather than a long verbatim extract.
The source hash binds it to the copied document; page and section locate it;
`used_by` maps it to generated symbols and line ranges.

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
finalizer output. The following declared capabilities are not yet executed by
the CLI and must not be inferred from config files alone:

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
