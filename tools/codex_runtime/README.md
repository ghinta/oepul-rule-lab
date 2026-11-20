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
runner subsequently reads the actual five-hour quota, starts only at >=50%,
and stops at <=5%. Login and quota checks are not generation results.

Run the existing command with the generated launcher on PATH, from the
Rule Lab checkout that owns the prepared run. Use absolute paths when the
runtime scripts and prepared runs are in different worktrees:

```sh
PATH=/absolute/path/to/runtime-checkout/.rulelab-cache/codex-runtime/bin:$PATH \
  PYTHONPATH=src python -m rulelab run runs/<prepared-astra-run-id>
PYTHONPATH=src python -m rulelab finalize runs/<prepared-astra-run-id>
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
