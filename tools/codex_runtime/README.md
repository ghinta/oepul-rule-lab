# Isolated Codex runner — #115

Use this host-side launcher when the managed computer mounts its Codex home
read-only. It creates a separate non-root Linux environment with a normal,
writable user home and a fresh login. It never changes `HOME` or `CODEX_HOME`,
copies existing credentials, or remounts protected host paths.

Requirements: Linux, task UID 1000, Node/npm, Python and the local Docker socket.
The fixed Codex version is 0.171.0; npm integrity hashes are in package-lock.json.
The builder preserves Docker registry credentials and proxy settings. Its
Buildx/npm state goes in ignored `.rulelab-cache/codex-runtime/`.

```sh
python tools/codex_runtime/runtime.py build --runs-root /absolute/path/to/prepared/runs
python tools/codex_runtime/runtime.py preflight
python tools/codex_runtime/runtime.py codex login --device-auth
```

Complete the browser login yourself. Credentials stay in Docker volume
`oepul-rulelab-codex-home-v1`; do not post them in chat or commit them. The launcher
refuses to reuse a same-named volume without its ownership label. Rebuilding does
not log out. Removing that volume removes this runner's login.

Preflight checks that the App Server initializes and the real Codex sandbox
allows workspace writes while denying outside writes and network sockets.
`account_present=false` means login is still needed. The existing Rule Lab
runner reads the selected window. The #115 Astra campaign can start at 5%
weekly budget remaining. Other runs require 50% at start. A reading of 5% or
less during generation stops the run.

Run the existing command with the generated launcher on PATH, from the
Rule Lab checkout that owns the prepared run. Use absolute paths when the
runtime scripts and prepared runs are in different worktrees. For #115, set
`run` to one confirmed prepared Astra run. This previews the command:

```sh
PATH=/absolute/path/to/runtime-checkout/.rulelab-cache/codex-runtime/bin:$PATH \
  PYTHONPATH=src python -m rulelab run "$run" --codex-usage-window weekly --dry-run
```

Only the configured runs directory and `gpt-6.2-astra` profiles are accepted.
The container mounts one run, with its sources, baseline profile, AGENTS.md,
contracts and tools read-only. The model uses local OPA; no Docker executable
or Docker socket is supplied to the generator. Host-side container setup is
repository maintenance, not a change to the generator's local-OPA requirement.
The normal Codex workspace-write sandbox stays enabled; native web search is
disabled. `--skip-git-repo-check` is needed because the other runs and repository
history are not mounted. Actual runtime provenance goes to
`raw/runner-environment.json`; model/provider observations remain in normal logs.

### Recovering campaign #115

On the campaign host, first check that the old controller and generator are
inactive. Reconcile the 26 IDs against the private campaign manifest, workspace
inputs and hashes, current `run.json`, logs and validation reports. The
manifest is in `.rulelab-cache/campaigns/astra-6.2-20261120.json`. Retain it
and the original runs. Record the patched runner revision or patch hash in
the campaign log. For a read-only status list in the comparison checkout:

```sh
jq -s 'sort_by(.measure)[] | {run_id, status, generation_attempt, generator_exit_code,
  finalized_at, grounding_valid: .metrics.grounding_valid, missing: .metrics.required_outputs_missing}' \
  runs/v3-*-astra-6.2-high-20261120/run.json
```

- For the nine reported as unstarted, select only entries still confirmed
  pending locally. Run one at a time. On the first budget or execution error
  stop the queue; preserve the return code, guard and logs.
- For a budget question such as `o6_2` or `o6_14`, confirm the final message
  and partial outputs. An approved retry uses a new ephemeral Codex session
  on a copy of that workspace. The run ID stays the same for embedded
  citations. `--attempt-root` copies the workspace and prepared inputs, binds
  the parent's exact `run.json`, and starts fresh logs and validation artifacts.
  Point the isolated runner's configured `runs_root` at that destination
  root before launch. The same new root can hold one attempt per distinct
  run ID, including first attempts. An existing destination run is refused.
- For `o6_1a` and other source/contract failures, preserve the failed result
  and inspect `artifacts/grounding-validation.json`, `artifacts/metrics.json`
  and the technical validation output. `verify-grounding` is read-only.
  Any later content repair needs its own labeled attempt and rationale.
- For `o6_15`, first check whether finalization has since completed. If still
  open and quiescent, copy the whole run into a new private directory and
  finalize that copy with the pinned OPA. For example, with `run` set to its
  original directory and `OPA_BIN` set to the verified executable:

```sh
review_dir=$(mktemp -d) &&
test -d "$run" && test ! -L "$run" &&
cp -RP -- "$run" "$review_dir/" &&
test -z "$(find "$review_dir" -type l -print -quit)" &&
OPA_RUNTIME=local PYTHONPATH=src python3 -m rulelab finalize "$review_dir/$(basename "$run")"
```

For a later authorized generation, choose **one** of the following launch
commands. Set `run` to the verified source directory. For the second command,
`new_runs_root` must be an existing private root outside that source. Keep
the isolated launcher's bin directory first in `PATH` as shown above.

```sh
# First generation in a pristine prepared workspace
PYTHONPATH=src python3 -m rulelab run "$run" --codex-usage-window weekly
# Separate attempt, including after a guard block or interruption
PYTHONPATH=src python3 -m rulelab run "$run" --codex-usage-window weekly --attempt-root "$new_runs_root"
```

Record each attempt's location, parent, guard, generator exit and finalization
exit separately in the private campaign log. After generator exit 0, run
`PYTHONPATH=src python3 -m rulelab finalize "$attempt_dir"` on **that attempt**
(`$run` or `$new_runs_root/$(basename "$run")`). A completed negative validation
is an outcome. An exception, missing result or stale `running` needs local
investigation. Count success only for a full finalization that returns 0 and
writes `status=finalized`. Keep every failed or interrupted attempt.

After an accepted preflight, the runner stores the prepared bytes, the runtime
amendment and the exact generator stdin under `raw/prompts/<attempt>/`.
The record binds their hashes, workspace instructions, scope, timestamp and
measured guard values. Earlier attempts have no retrospective prompt proof.
From the new attempt directory, verify the recorded bytes offline:

```sh
record=$(jq -er '.prompt_record.path' run.json) &&
jq -r '.prompt_record | "\(.sha256)  \(.path)"' run.json | sha256sum -c - &&
jq -r '.prepared,.amendment,.effective,.instructions | "\(.sha256)  \(.path)"' "$record" | sha256sum -c - &&
dir=$(dirname "$record") && cat "$dir/prepared.md" "$dir/amendment.md" | cmp - "$dir/effective.md"
```

The outer container is non-root, has no Linux capabilities, uses no-new-privileges,
and has a read-only root plus writable home, temporary storage and one run.
`seccomp.json` is Docker's default-deny profile, with six syscall allowances
for nested unprivileged user/mount/PID namespaces: clone, unshare, setns, mount,
umount2 and pivot_root. Kernel capability checks and the inner Codex sandbox
remain active. No privileged container or sandbox-disable flag is used.

Upstream profile: `moby/profiles/seccomp/default.json`, retrieved 20 November
2026, SHA-256 `3320527d4568265ac97a077609b1bfd4cfd0d789eeb9239b7e094b1526675406`.
The complete derived profile is committed for review. Build records bind its
hash and the actual image ID; changed images/profiles require another build
and preflight. A configured session CA is mounted read-only when needed, never
baked into image layers. TLS verification remains enabled.

Existing Luna/Opus runs stay historical. A changed CLI/container/tool version
must remain visible in the comparison; technical checks do not establish
domain correctness or current availability of the requested model.
