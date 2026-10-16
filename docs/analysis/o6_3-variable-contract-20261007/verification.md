# Verification record

Historical lab base: `0760684b5029d65feeca984bf627a3c6269a9955`.
App reference: `14e5422b9977f78eb2f7edfb99313e4aac39f9a7`.
Original branch: `codex/issue-136-o6-3-contract`.

The original local review passed 89 repository tests (nine new), 11 validator
tests, the dossier check with an actual pinned app checkout, and OPA 1.18.2
formatting, strict compilation and 3/3 direct tests. Ten dossier inputs were
also executed by real OPA. Python compilation and whitespace checks passed.

```bash
PYTHONPATH=src python3 tools/validate_o6_3_contract.py
PYTHONPATH=src python3 tools/validate_o6_3_contract.py --app-root ../pinned-app
PYTHONPATH=src OPA_BIN=./tools/opa python3 -m unittest discover -s tests -v
python3 -m unittest discover -s runner/validation/tests -v
python3 runner/validation/opa_validate.py validate --workspace adaptations/o6_3 \
  --runtime local --opa-bin ./tools/opa --target policy --target data \
  --target tests --result-json validation.json --pretty
```

The offline dossier check covers bound lab/source hashes, all 46 native schema
paths, 17 rule groups, 46 exact PDF quotes, 20 RGVE coefficients and mappings to
the versioned app CSV inventory. The optional app check also verifies its exact
commit and registry/dependency/adapter/service bytes.

Regression cases reject missing inputs or citations, false claims of app
consumption, average counts disguised as GVE, an incorrect small-equid factor,
and removed or silently closed blockers. The OPA case reproduces all ten
synthetic observations without endorsing their unresolved legal effects.
CI runs this dossier check and the existing suites. These checks concern a
bound app inventory, not an app test run on unchanged app code.

New Opus revisions and domain/integration blockers remain separate work.
The public-path migration rebinds metadata hashes; it keeps rule, source, input
and observed-output bytes unchanged. See [publication rules](../../publication.md).
