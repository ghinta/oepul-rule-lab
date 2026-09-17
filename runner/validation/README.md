# OPA validation runner

This directory provides the technical validation layer for generated Rego run
workspaces. It deliberately answers only whether artifacts are formatted,
strictly compilable, and executable under their OPA tests. It does not assess
source fidelity, rule semantics, or experiment eligibility.

The default OPA version is pinned in `opa-version.txt`. With no local `opa`
binary, the runner uses `openpolicyagent/opa:<version>-static` through Docker.

## Validate a run workspace

```sh
python3 runner/validation/opa_validate.py validate \
  --workspace runs/example-run/workspace \
  --target . \
  --result-json runs/example-run/technical-validation.json \
  --pretty
```

The exit codes are `0` for pass, `1` for a validation failure, and `2` for a
runner/configuration error. JSON is always emitted to stdout and may also be
written atomically with `--result-json`.

Run individual stages with `fmt`, `check`, or `test`. Formatting is read-only
unless `--write` is supplied:

```sh
python3 runner/validation/opa_validate.py fmt --workspace RUN_DIR
python3 runner/validation/opa_validate.py fmt --workspace RUN_DIR --write
python3 runner/validation/opa_validate.py check --workspace RUN_DIR
python3 runner/validation/opa_validate.py test --workspace RUN_DIR
```

Targets are workspace-relative and repeatable. Paths that escape the workspace
are rejected. Override the runtime through `--runtime`, `--opa-bin`,
`--opa-version`, and `--opa-image`, or the corresponding `OPA_RUNTIME`,
`OPA_BIN`, `OPA_VERSION`, and `OPA_IMAGE` environment variables.

## Tests

The unit suite uses a deterministic fake OPA executable and needs only Python:

```sh
python3 -m unittest discover -s runner/validation/tests -v
```

The real-runtime smoke fixture can be checked with the pinned Docker image:

```sh
python3 runner/validation/opa_validate.py validate \
  --workspace runner/validation/fixtures/valid \
  --runtime docker \
  --pretty
```

`fixtures/test-failure` is an intentional failing fixture for verifying that a
non-zero `opa test` result is preserved in the machine-readable report.
