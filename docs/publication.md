# Portable paths and public exports

Run commands from the repository root. The checkout may be on a laptop, in a
development container or in a cloud workspace; its absolute location is not
part of a published result.

## Path bases

| Record | Base | Example |
| --- | --- | --- |
| `run.json` invocation and tool provenance | Repository root | `runs/example/workspace` |
| `profile.path` | Repository root | `profiles/canonical_farm_profile.json` |
| Source `source_path` | The selected source pack | `originals/leaflet.pdf` |
| OPA `workspace`, file names and diagnostics | Validated workspace | `.`, `policy/main.rego` |
| OPA `workspace_path` in run metadata | Run folder | `workspace/tools/opa` |
| External host input or executable | Provenance label only | `external/opa` |

The launcher uses absolute paths internally when required. A public invocation
is a normalized record of the arguments, not a shell command to paste and run.
To repeat a run, use the Rule Lab CLI and choose the local executable again.
External labels do not resolve files. Source and tool hashes retain content
identity without exposing a username or directory layout.

The exporter handles old local checkout paths as well as cloud paths. It does
not rewrite source documents, rule evidence, input values or observed outputs.

## Existing research records

The path cleanup changes public run and validation metadata only. References to
those files are updated to their new hashes and byte sizes. Original source,
profile, prompt, policy, test, data and per-measure observation bytes stay unchanged.
Aggregate result files receive the new manifest checksum. The path-only changes
are recorded in [the migration record](metadata-path-migration.json).
The withdrawn raw transcript keeps its old checksum there, but is no longer a
file dependency of the public adaptation or input-review dossier.
The pinned Opus checkout keeps its original manifest bindings. Its displayed
historical conditions are cleaned when exported into `comparison.json`.
A checksum proves file identity, not legal correctness.

Public guides and report controls use English. German official sources,
historical prompts, model explanations and observed results keep their original
wording so that citations and experiments remain reproducible. Detailed report
sections identify this original evidence explicitly.

## Checks before publishing

```bash
PYTHONPATH=src python3 tools/check_publication.py
```

This check rejects recognizable personal or cloud host paths and common secret
formats in public metadata and website files. It also checks HTML language and
local static links. It is a focused check, not a complete secret audit.

Keep raw logs, credentials, OAuth files and real farm records out of public
exports. Public AMA contact details in original official sources are preserved.
Git author email addresses and old commits are separate records. This cleanup
does not rewrite Git history or remove already published copies.
