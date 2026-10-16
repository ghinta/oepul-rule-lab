# Source-evidence checks

Rule Lab checks generated files before accepting a run. These checks catch
invalid structures and unsupported references. They cannot prove that a legal
sentence has been interpreted correctly.

## What the finalizer checks

1. **File contracts.** Pydantic v2 models use `extra="forbid"`. Wrong types,
   unknown fields, duplicate IDs and invalid action combinations fail. JSON
   schemas are generated from the same models.
2. **Quoted evidence.** Each citation gives a source hash, page, claim and short
   exact `evidence_text`. The finalizer checks the hash and searches the
   normalized quote on that PDF page or in the HTML source. A paraphrase fails.
3. **Linked IDs.** Rules must reference existing citations. Each citation must
   be used by a rule. Profile proposals and data tables must link to existing
   rules or citations. File paths and row boundaries are checked too.
4. **Profile proposals.** The working `canonical_farm_profile.json` must keep
   the baseline structure. In `discover`, the model writes proposals to
   `rules/profile_changes.json`. The finalizer checks whether each `add`,
   `change` or `remove` fits the baseline, then writes a separate
   `artifacts/proposed-profile.json` and profile diff. Direct profile edits fail.
   Input paths used by rules and Rego must exist in the checked proposed profile.
5. **Coverage and tables.** `rules/coverage.json` maps reviewed sections,
   paragraphs, tables, footnotes and notices to rules, or explains `not_rule`
   and `unresolved`. Core sources other than legal foundations require full
   review, including every PDF page. Legal foundations may use a justified
   section scope. `rules/data_inventory.json` binds every JSON data file by
   hash and checks table pointers, row counts and citations. Array elements
   count as rows; nested lookup tables count scalar entries.

OPA also checks formatting, strict compilation and tests.

## Files

The model must produce `rules/rules.json`, `rules/citations.json`,
`rules/profile_changes.json`, `rules/coverage.json`, `rules/data_inventory.json`,
and the relevant Rego, tests, data and assumptions.

The finalizer writes `artifacts/grounding-validation.json`,
`artifacts/direct-profile-diff.json`, `artifacts/proposed-profile.json`,
`artifacts/profile-diff.json`, OPA validation results, metrics and an inventory.

To repeat the deterministic checks without changing run files:

```bash
python3 -m rulelab verify-grounding runs/<run-id>
```

## Limits

A genuine quote can support a wrong or incomplete implementation. Independent
reference cases, expert review and later hidden tests are still needed.
The checks make structural, evidence, coverage and linking failures visible;
they do not certify legal correctness or funding eligibility.
