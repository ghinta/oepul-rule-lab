# ÖPUL Rule Lab

Rule Lab turns official ÖPUL documents into draft rules that a computer can run.
ÖPUL is Austria's agri-environmental programme. This lab helps study how models
extract its rules. Passing the checks does not mean that a rule is legally correct.

Each generator receives only the Canonical Farm Profile (the shared input
structure), the selected official sources, and the generation task.

- `discover` lets a model propose missing input fields and repair its Rego code
  and tests. Proposals are checked and applied to a separate profile copy.
- `conform` keeps the existing input structure and does not allow proposals.

The original profile and source documents stay unchanged.

## Quick start

Run these commands from the repository root, on your computer or in a container:

```bash
python3 -m pip install -e .
python3 -m rulelab prepare --measure o6_1a --model config/models/codex-gpt-5.5.json
python3 -m rulelab run runs/<run-id>
python3 -m rulelab verify-grounding runs/<run-id>
python3 -m rulelab finalize runs/<run-id>
python3 -m rulelab compare runs/<run-a> runs/<run-b>
PYTHONPATH=src python3 -m unittest discover -s tests -v
```

Replace `<run-id>` with the ID printed by `prepare`. `verify-grounding` checks
source evidence and contracts without writing run files. `finalize` writes the
checks, proposed profile and metrics under `artifacts/`.

The `.devcontainer/` setup includes Python and the pinned OPA version. OPA
(Open Policy Agent) is the program that runs the Rego rules. Before generation,
Rule Lab puts a verified OPA executable in `workspace/tools/opa`. It checks a
local executable's version or downloads one using the repository's SHA-256 pin.
The generator can then format, compile and test its own code without Docker.

## Models and adapters

Model settings live in `config/models/`. To change the model with the same
adapter, copy a JSON file and change its `model` value. Configurations are
included for `gpt-5.5`, `gpt-5.6-luna`, `gpt-5.6-terra`, `gpt-5.6-sol` and
`gpt-6-astra` using `codex-cli`, and `claude-opus-5-5` with `high` effort using
`claude-cli`. An external command adapter is described in
[the contracts guide](contracts/README.md).

Every run records its model, provider, adapter and reasoning effort in
`model.json`, `run.json` and the recorded invocation. IDs identify the measure,
model and effort, for example `v2-o6_4-opus-5.5-high-20260925`.

The Claude adapter starts Claude Code without an interactive UI (`claude -p`).
Only workspace file changes are accepted automatically. Operations that need
interactive approval are rejected. Web access, `git`, `gh`, `curl`, `wget` and
`docker` are blocked. MCP servers and user/project settings are not loaded.
Ambient `CLAUDE*`, `GH_TOKEN` and `GITHUB_TOKEN` variables are not passed on.
If child processes cannot use the local Claude login,
`RULELAB_CLAUDE_OAUTH_TOKEN_FILE` can point to a local token file. Its contents
are never written to run metadata.

`raw/events.jsonl` holds the event log; `raw/final-message.md` holds the final
message. `run.json` records turns, duration, token use and cost under
`generator_result`, and the session ID under `generator_session_id`.
Raw logs can contain private data: keep them out of public exports.

## Usage limits and resuming a run

Codex and Claude runs check only the subscription's five-hour window. The
weekly window does not gate a run. Codex reads its primary App Server window;
Claude reads `five_hour` through a small, tool-free `claude -p` request.

A run starts with at least **50%** remaining. Usage is checked every 30 seconds.
At **5% or less**, the generator stops cleanly and records
`aborted_usage_guard`. A Claude `rejected` status in any window also triggers
a stop. If usage cannot be read, the run does not start.

Claude is stopped with SIGINT so that its workspace and session can be resumed.
The resume command is recorded under `usage_guard.resume`:

```bash
python3 -m rulelab run runs/<run-id> --resume
python3 -m rulelab finalize runs/<run-id>
```

After a failed `finalize`, `--resume` also sends the rejected evidence checks
and missing outputs to the generator. Each restart increases
`generation_attempt`; resumptions are listed in `resumed_attempts`.

## Official sources and checks

```bash
python3 sources/oepul/manage_sources.py update
python3 sources/oepul/manage_sources.py validate --check-index
```

The current source pack contains all 27 AMA core leaflets. Eleven carry a 2026
revision (ten from April, one from June); AMA still links October 2025 versions
for the other 16. The pack also includes the linked special directive and
annexes, plus four official exception notices for 2026. The manifest records
the real document dates, origins and checksums. Updating the pack may replace
or add official documents; an experiment can pin a Git commit when needed.

`prepare` creates a separate workspace with page-marked text for each PDF and
five binding JSON schemas. `finalize` checks types, unknown fields, linked IDs,
source and data hashes, exact quotes on the cited page, coverage, table row
counts, profile proposals, input paths, OPA formatting, strict compilation and
tests. See [source-evidence checks](docs/grounding-validation.md) for limits.
A correct quote can still be interpreted incorrectly: expert review and
independent reference cases remain necessary.

## Reports and manual adaptations

- [Run Explorer](https://ghinta.github.io/oepul-rule-lab/) compares published
  run metrics. Counts describe outputs, not model quality.
- [Luna screening](docs/analysis/luna-screening-20261011/README.md) runs 78
  visible synthetic development cases across 26 historical candidates.
- [Opus screening](docs/analysis/opus-screening-20261011/README.md) selects 26
  candidates from 36 finalized publications at the pinned PR #79 commit. It
  maps only facts that can be supported by the Luna cases. Different source
  versions, tools and budgets prevent a controlled claim about model quality.
- [The o6_3 input review](docs/analysis/o6_3-variable-contract-20261007/README.md)
  lists the evidence and app integration work still needed.
- [The hay-farming adaptation](adaptations/o6_3/README.md) is a separate,
  source-backed candidate for [#97](https://github.com/ghinta/oepul-rule-lab/issues/97).
- Historical drafts: [UBB pilot](reports/draft-pilot-o6_1a-gpt55.md),
  [groundwater protection](reports/draft-o6_16-gpt-5.6-terra.md) and
  [Terra overview](reports/terra-high-discover-run-overview.md).

These reports prepare later research and app work. They do not provide an
independent accuracy score or permission to approve funding.

## Paths, language and privacy

Public run metadata uses paths relative to the repository root. OPA validation
reports use paths relative to the validated workspace (`.`). Execution still
resolves the real local paths. This works in local checkouts, development
containers and cloud checkouts, including those under `/workspace/`.
External files are recorded as `external/<filename>` provenance labels; select
the real executable or input file again on another machine.

See [portable paths and public exports](docs/publication.md). Official German
sources, historical model prompts, fixtures and observed outputs retain their
original wording. English report controls and guides explain how to read them.
Personal paths are removed from current metadata; older Git commits may still
contain them. Git author identities are separate from file contents.

## Repository layout

```text
profiles/              shared farm input structure
sources/oepul/          official sources and source manifest
prompts/                model-independent generation task
config/models/          model and adapter settings
contracts/              JSON schemas for settings and run outputs
src/rulelab/            prepare/run/finalize CLI and analysis tools
runner/validation/      OPA formatting, compilation and test runner
runs/                   run folders (new local runs are ignored)
docs/                   public site and analysis reports
```

## Local verification

Choose an OPA executable that matches `runner/validation/opa-version.txt`:

```bash
OPA_BIN=./tools/opa PYTHONPATH=src python3 -m unittest discover -s tests -v
PYTHONPATH=src python3 -m unittest discover -s runner/validation/tests -v
PYTHONPATH=src python3 tools/check_publication.py
```

`OPA_BIN` may be a relative or absolute path for execution. Published metadata
must not include the host path. CI also repeats the frozen analyses and checks
the manual adaptation. Compiling code and passing model-written tests are
technical evidence; they do not establish domain correctness.
