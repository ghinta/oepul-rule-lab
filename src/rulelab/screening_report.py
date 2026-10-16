"""Static, deterministic views of native development-screening observations.

Rendering never turns technical execution or native ``eligible`` fields into
semantic judgements. The caller owns evaluation, validation and file writes.
"""

from __future__ import annotations

import csv
import html
import io
import json
from typing import Any
from urllib.parse import quote


REPLAY_COMMAND = (
    "PYTHONPATH=src OPA_BIN=./tools/opa python -m rulelab.screening verify "
    "--report-dir docs/analysis/luna-screening-20261011"
)
STATUS_LABELS = {
    "defined": "Value returned",
    "undefined": "No value (undefined)",
    "runtime_error": "Runtime error",
    "compile_error": "Compile error",
    "compiled": "Compiled",
    "fixture_gap": "No executable cases (fixture_gap)",
}
DISCLAIMER = (
    "These visible synthetic development cases run on unchanged historical Luna rules. "
    "Observed outputs have no independent expert labels. They do not measure accuracy "
    "or approve funding or app use."
)
EXPERT_NOTE = (
    "App issue #140 blocks domain judgements that need an unresolved interpretation. "
    "Technical execution and output gaps can be studied separately."
)
INVENTORY_NOTE = (
    "Rule counts and reported source coverage come from historical model outputs. "
    "They do not prove completeness. Static input paths may miss dynamic references; "
    "they do not show every fact read during execution."
)
REFERENCE_NOTE = (
    "Rule types, sources, required facts and open questions help choose the study scope. "
    "No estimate of expert hours is made. not_adjudicated means that independent cases "
    "and expert-confirmed expected decisions are still needed. These visible development "
    "cases must not later be described as hidden test cases."
)


def _json(value: Any) -> str:
    return json.dumps(value, ensure_ascii=False, indent=2, sort_keys=True)


def _escape(value: Any) -> str:
    return html.escape(str(value), quote=True)


def _markdown(value: Any) -> str:
    return html.escape(str(value), quote=False).replace("|", "\\|").replace(
        "\n", " "
    ).replace("`", "\\`")


def _repo_href(path: str, artifact_base_url: str | None = None) -> str:
    # Pages serves docs/ only. A relative ../../../runs link escapes that site.
    base = artifact_base_url or "https://github.com/ghinta/oepul-rule-lab/blob/main/"
    return base + quote(path, safe="/._-")


def _fixture_href(measure: dict[str, Any]) -> str:
    return "fixtures/" + quote(measure["measure_id"], safe="_-") + ".json"


def _result_href(measure: dict[str, Any]) -> str:
    return "results/" + quote(measure["measure_id"], safe="_-") + ".json"


def _case_status(case: dict[str, Any] | None) -> str:
    return case["status"] if case is not None else "fixture_gap"


def _status(case: dict[str, Any] | None) -> str:
    status = _case_status(case)
    return STATUS_LABELS.get(status, status)


def _changed(case: dict[str, Any]) -> str:
    if case["case_id"] == "baseline":
        return "Baseline"
    return "yes" if case["output_changed_from_baseline"] else "no"


def _csv_changed(case: dict[str, Any] | None) -> str:
    if case is None:
        return "fixture_gap"
    return str(case["output_changed_from_baseline"]).lower()


def _case_map(measure: dict[str, Any]) -> dict[str, dict[str, Any]]:
    return {case["case_id"]: case for case in measure["cases"]}


def _fact_state(state: dict[str, Any]) -> str:
    # A present JSON null is distinct from a removed member.
    return _json(state["value"]) if state["present"] else "Absent"


def _pre(value: Any) -> str:
    return "<pre>" + _escape(_json(value)) + "</pre>"


def _markdown_code(text: str) -> str:
    return "\n" + "\n".join("    " + line for line in text.splitlines()) + "\n"


def _compact_json(value: Any) -> str:
    return json.dumps(value, ensure_ascii=False, sort_keys=True)


def _html_inventory(measure: dict[str, Any]) -> str:
    inventory = measure.get("inventory")
    if inventory is None:
        return "<p class=empty>No additional candidate inventory recorded.</p>"
    items = (
        ("rule catalog entries", inventory["rule_count"]),
        ("Rule types", _compact_json(inventory["rule_type_counts"])),
        ("Sources", inventory["source_count"]),
        ("Static input paths", len(inventory["static_policy_input_paths"])),
        ("Profile proposals", inventory["profile_proposal_count"]),
        ("Independent reference cases", inventory["independent_reference_case_status"]),
    )
    descriptions = "".join(
        "<dt>" + _escape(label) + "</dt><dd>" + _escape(value) + "</dd>"
        for label, value in items
    )
    source_rows = "".join(
        "<tr><td><code>" + _escape(claim["source_id"]) + "</code></td><td>"
        + _escape(claim["review_scope"]) + "</td><td>" + _escape(claim["item_count"])
        + "</td><td><code>" + _escape(_compact_json(claim["disposition_counts"]))
        + "</code></td></tr>"
        for claim in inventory["source_coverage_claims"]
    )
    sources = (
        "<div class=table-wrap><table><thead><tr><th>Source ID</th>"
        "<th>Reported review scope</th><th>Entries</th><th>Classification</th>"
        "</tr></thead><tbody>" + source_rows + "</tbody></table></div>"
        if source_rows else "<p>No source coverage recorded in the inventory.</p>"
    )
    return (
        "<details><summary>Candidate inventory and reference work needed</summary><dl>"
        + descriptions + "</dl><p>" + _escape(INVENTORY_NOTE) + "</p><p>"
        + _escape(REFERENCE_NOTE) + "</p><details><summary>Static input paths</summary>"
        + _pre(inventory["static_policy_input_paths"]) + "</details>"
        + "<details><summary>Model-reported source coverage</summary>"
        + sources + "</details></details>"
    )


def _markdown_inventory(measure: dict[str, Any]) -> list[str]:
    inventory = measure.get("inventory")
    if inventory is None:
        return ["**Inventory:** No additional candidate inventory recorded.\n"]
    lines = [
        "**Inventory:** " + str(inventory["rule_count"]) + " rule catalog entries; "
        + str(inventory["source_count"]) + " sources; "
        + str(len(inventory["static_policy_input_paths"])) + " static input paths; "
        + str(inventory["profile_proposal_count"]) + " profile proposals. "
        + "Independent reference cases: `"
        + _markdown(inventory["independent_reference_case_status"]) + "`.\n",
        "**Rule types:** `" + _markdown(_compact_json(inventory["rule_type_counts"])) + "`\n",
        "<details>\n<summary>Static input paths and model-reported source coverage</summary>\n",
        INVENTORY_NOTE + "\n",
        "Static input paths (not an execution trace):\n"
        + _markdown_code(_json(inventory["static_policy_input_paths"])),
    ]
    claims = inventory["source_coverage_claims"]
    if claims:
        lines.append(
            "| Source ID | Reported review scope | Entries | Classification |\n"
            "|---|---|---|---|"
        )
        lines.extend(
            "| " + _markdown(claim["source_id"]) + " | "
            + _markdown(claim["review_scope"]) + " | " + str(claim["item_count"])
            + " | " + _markdown(_compact_json(claim["disposition_counts"])) + " |"
            for claim in claims
        )
    else:
        lines.append("No source coverage recorded in the inventory.")
    lines.extend(["\n</details>\n", REFERENCE_NOTE + "\n"])
    return lines


def _html_case(case: dict[str, Any]) -> str:
    status = case["status"]
    observed = (
        _pre(case["output"])
        if status == "defined"
        else "<p class=empty>No native output. A missing value "
        "is not replaced with null or treated as a funding rejection.</p>"
    )
    changes = case["changes_from_baseline"]
    error = (
        "<details><summary>Original OPA error text</summary><pre>"
        + _escape(case["error"]) + "</pre></details>"
        if "error" in case else ""
    )
    diff = "<p>No input change from the baseline.</p>"
    if changes:
        rows = "".join(
            "<tr><td><code>" + _escape(change["path"]) + "</code></td><td><pre>"
            + _escape(_fact_state(change["before"])) + "</pre></td><td><pre>"
            + _escape(_fact_state(change["after"])) + "</pre></td></tr>"
            for change in changes
        )
        diff = (
            "<div class=table-wrap><table><thead><tr><th>Path</th>"
            "<th>Baseline</th><th>Case</th></tr></thead><tbody>" + rows
            + "</tbody></table></div>"
        )
    return (
        "<section class=case><h3>" + _escape(case["case_id"])
        + " <span class=badge>" + _escape(_status(case)) + "</span></h3><p>"
        + _escape(case["purpose"]) + "</p><p>Output changed from baseline: <b>"
        + _escape(_changed(case)) + "</b></p><details><summary>Changed facts</summary>"
        + diff + "</details><details><summary>Synthetic input</summary>"
        + _pre(case["input"]) + "<p class=hash>SHA-256: <code>"
        + _escape(case["input_sha256"]) + "</code></p></details>"
        + "<details><summary>Native output</summary>" + observed
        + "</details><details><summary>Full OPA response</summary>"
        + _pre(case["opa_result"]) + "</details>" + error + "</section>"
    )


def _html_measure(measure: dict[str, Any], entry: dict[str, Any], artifact_base_url: str | None = None) -> str:
    references = "".join(
        '<li><a href="' + _escape(_repo_href(ref["path"], artifact_base_url)) + '"><code>'
        + _escape(ref["path"]) + "</code></a>: " + _escape(ref["detail"])
        + "</li>" for ref in measure["references"]
    )
    dependencies = "".join(
        "<li>" + _escape(item) + "</li>" for item in measure["open_dependencies"]
    ) or "<li>No further dependency recorded in this fixture; completeness is not confirmed.</li>"
    compile_note = _escape(
        STATUS_LABELS.get(measure["compile"]["status"], measure["compile"]["status"])
    )
    compile_details = ""
    if measure["compile"]["errors"]:
        compile_details += (
            "<details><summary>Compile diagnostics as JSON</summary>"
            + _pre(measure["compile"]["errors"]) + "</details>"
        )
    if "error" in measure["compile"]:
        compile_details += (
            "<details><summary>Original OPA compile error text</summary><pre>"
            + _escape(measure["compile"]["error"]) + "</pre></details>"
        )
    gap = (
        '<p class="notice"><b>Fixture gap:</b> ' + _escape(measure["gap"]) + "</p>"
        if "gap" in measure else ""
    )
    return (
        '<article id="' + _escape(measure["measure_id"]) + '"><h2>'
        + _escape(measure["measure_id"]) + "</h2><p><code>"
        + _escape(measure["run_id"]) + "</code> · " + compile_note + "</p>"
        + compile_details + gap
        + '<p><a href="' + _escape(_fixture_href(measure)) + '">Fixture</a> · '
        + '<a href="' + _escape(_result_href(measure)) + '">Result JSON</a></p>'
        + "<dl><dt>Inputs and units</dt><dd>"
        + _escape(measure["input_contract_note"]) + "</dd><dt>Output meaning</dt><dd>"
        + _escape(measure["output_contract_note"]) + "</dd><dt>Case origin</dt><dd>"
        + _escape(measure["case_origin"]) + "</dd><dt>Native query</dt><dd><code>"
        + _escape(measure["query"]) + "</code></dd></dl>"
        + _html_inventory(measure)
        + ("<details><summary>Luna fact mapping and comparison gaps</summary>"
           + _pre(measure["luna_translation"]) + "</details>" if "luna_translation" in measure else "")
        + "<details><summary>Evidence and open dependencies</summary><h3>Evidence</h3><ul>"
        + references + "</ul><h3>Open dependencies</h3><ul>" + dependencies
        + "</ul><p class=hash>Fixture SHA-256: <code>"
        + _escape(entry["fixture"]["sha256"]) + "</code></p></details>"
        + "".join(_html_case(case) for case in measure["cases"]) + "</article>"
    )


def render_report(manifest: dict, results: dict, *, label: str = "Luna",
                  replay_command: str = REPLAY_COMMAND, disclaimer: str = DISCLAIMER,
                  artifact_base_url: str | None = None) -> dict[str, str]:
    """Return static report files without reading files or mutating arguments."""
    entries = {entry["measure_id"]: entry for entry in manifest["entries"]}
    measures = results["measures"]
    markdown = [
        f"# {label}: development screening of existing rule candidates\n",
        disclaimer + "\n",
        EXPERT_NOTE + "\n",
        INVENTORY_NOTE + "\n",
        REFERENCE_NOTE + "\n",
        "Original evidence (German) is preserved in the detailed sections: model notes, "
        "case descriptions and observed outputs keep their original wording. "
        "`eligible` has a different scope in each candidate. `undefined` means no value; "
        "a defined JSON `null` remains a separate value.\n",
        "[Findings and next decision](findings.md) · [Expandable preview](index.html) · [Manifest](manifest.json) · "
        "[All results](results.json) · [CSV matrix](matrix.csv) · "
        "[Frozen inputs and replay](method.md)\n",
        f"Base commit: `{manifest['base_commit']}`. OPA: `{results['opa_version']}`. "
        "Policy and data are loaded separately for each run. No new model generation takes place.\n",
        "## Execution overview\n",
        "| Measure | Run | Compilation | Baseline | Variation | Missing fact |\n"
        "|---|---|---|---|---|---|",
    ]
    html_rows = []
    csv_buffer = io.StringIO(newline="")
    writer = csv.writer(csv_buffer, lineterminator="\n")
    writer.writerow([
        "measure_id", "run_id", "compile_status", "baseline_status",
        "variation_status", "missing_fact_status", "variation_output_changed",
        "missing_fact_output_changed", "query", "output_contract_note",
        "rule_count", "rule_types", "source_count", "static_input_path_count",
        "profile_proposal_count", "independent_reference_case_status",
    ])
    for measure in measures:
        cases = _case_map(measure)
        inventory = measure.get("inventory")
        ordered = [cases.get(name) for name in ("baseline", "variation", "missing_fact")]
        markdown.append(
            f"| [{_markdown(measure['measure_id'])}]({_result_href(measure)}) "
            f"| `{_markdown(measure['run_id'])}` | {_markdown(measure['compile']['status'])} "
            + "| " + " | ".join(_markdown(_case_status(case)) for case in ordered) + " |"
        )
        html_rows.append(
            '<tr><th scope=row><a href="#' + _escape(measure["measure_id"]) + '">'
            + _escape(measure["measure_id"]) + "</a></th><td><code>"
            + _escape(measure["run_id"]) + "</code></td><td>"
            + _escape(measure["compile"]["status"]) + "</td>"
            + "".join("<td>" + _escape(_status(case)) + "</td>" for case in ordered)
            + "</tr>"
        )
        writer.writerow([
            measure["measure_id"], measure["run_id"], measure["compile"]["status"],
            *(_case_status(case) for case in ordered),
            _csv_changed(cases.get("variation")),
            _csv_changed(cases.get("missing_fact")),
            measure["query"], measure["output_contract_note"],
            inventory["rule_count"] if inventory is not None else "",
            _compact_json(inventory["rule_type_counts"]) if inventory is not None else "",
            inventory["source_count"] if inventory is not None else "",
            len(inventory["static_policy_input_paths"]) if inventory is not None else "",
            inventory["profile_proposal_count"] if inventory is not None else "",
            inventory["independent_reference_case_status"] if inventory is not None else "",
        ])
    markdown.extend([
        "\n`defined`: the query returns a value. `undefined`: no value. "
        "`runtime_error` and `compile_error`: technical errors; the original OPA details "
        "are in the result JSON. `fixture_gap`: no executable case; see the candidate's "
        "gap description. These statuses are not domain judgements.\n",
        "## Reproduce\n",
        "From the repository root, using the matching OPA executable:\n",
        "```bash\n" + replay_command + "\n```\n",
        "Verification compares the bound files and outputs. Input, source and artifact "
        "hashes are recorded in the manifest and result JSON. See [method.md](method.md) "
        "for the scope and limits.\n",
        "## Candidates and observed cases\n",
    ])
    for measure in measures:
        markdown.extend([
            f"### {_markdown(measure['measure_id'])}\n",
            f"Run: `{_markdown(measure['run_id'])}`. "
            f"[Fixture]({_fixture_href(measure)}) · [Native results]({_result_href(measure)})\n",
            "**Inputs:** " + _markdown(measure["input_contract_note"]) + "\n",
            "**Output meaning:** " + _markdown(measure["output_contract_note"]) + "\n",
            "**Origin:** " + _markdown(measure["case_origin"]) + "\n",
            "**Query:** `" + _markdown(measure["query"]) + "`\n",
            *_markdown_inventory(measure),
            *( ["**Luna fact mapping and comparison gaps:**\n"
                + _markdown_code(_json(measure["luna_translation"]))] if "luna_translation" in measure else []),
            "| Case | Observed status | Output changed from baseline | Purpose |\n"
            "|---|---|---|---|",
        ])
        if not measure["cases"]:
            markdown.append("| — | fixture_gap | fixture_gap | No executable cases |")
        markdown.extend(
            "| " + _markdown(case["case_id"]) + " | " + _markdown(case["status"])
            + " | " + _changed(case) + " | " + _markdown(case["purpose"]) + " |"
            for case in measure["cases"]
        )
        if "gap" in measure:
            markdown.append("\n**Fixture gap:** " + _markdown(measure["gap"]) + "\n")
        if measure["compile"]["errors"]:
            markdown.append(
                "\n**Compile diagnostics as JSON:**\n"
                + _markdown_code(_json(measure["compile"]["errors"]))
            )
        if "error" in measure["compile"]:
            markdown.append(
                "\n**Original OPA compile error text:**\n"
                + _markdown_code(str(measure["compile"]["error"]))
            )
        for case in measure["cases"]:
            if "error" in case:
                markdown.append(
                    "\n**Original OPA error text for " + _markdown(case["case_id"])
                    + ":**\n" + _markdown_code(str(case["error"]))
                )
        markdown.append("\n**Open dependencies:**\n")
        markdown.extend("- " + _markdown(item) for item in measure["open_dependencies"])
        if not measure["open_dependencies"]:
            markdown.append(
                "- No further dependency recorded in this fixture; "
                "completeness is not confirmed."
            )
        markdown.append("\n**Evidence:**\n")
        markdown.extend(
            f"- [{_markdown(ref['path'])}]({_repo_href(ref['path'], artifact_base_url)}): "
            + _markdown(ref["detail"]) for ref in measure["references"]
        )
        markdown.append("")
    css = """
    :root{font-family:system-ui,sans-serif;color:#17253a;background:#f3f5f8;line-height:1.55}
    body{margin:0}main{max-width:1180px;margin:auto;padding:2rem 1rem 4rem}
    h1{font-size:clamp(1.6rem,4vw,2.4rem);line-height:1.2}h2{margin-top:0}
    a{color:#174b8c;text-underline-offset:.16em}article,.intro,.matrix{background:white;
    border:1px solid #d6deea;border-radius:.7rem;padding:1.3rem;margin:1.25rem 0}
    .notice{border-left:4px solid #50719c;padding-left:1rem}.table-wrap{overflow:auto}
    table{border-collapse:collapse;width:100%;font-size:.9rem}th,td{text-align:left;
    vertical-align:top;border-bottom:1px solid #d6deea;padding:.6rem}thead{background:#eef2f7}
    code,pre{font-family:ui-monospace,monospace;font-size:.86rem}pre{white-space:pre-wrap;
    overflow-wrap:anywhere;background:#f0f3f7;padding:.85rem;border-radius:.35rem}
    code{overflow-wrap:anywhere}dt{font-weight:700;margin-top:.8rem}dd{margin:.15rem 0 .6rem}
    .case{border-top:1px solid #d6deea;padding-top:.65rem;margin-top:1rem}
    details{margin:.55rem 0}summary{cursor:pointer;font-weight:600;padding:.25rem 0}
    .badge{display:inline-block;font-size:.8rem;font-weight:500;background:#e5ecf5;
    border-radius:.35rem;padding:.15rem .5rem}.hash,.empty{font-size:.88rem;color:#46546a}
    .links{display:flex;gap:1rem;flex-wrap:wrap}article{scroll-margin-top:1rem}
    """
    html_document = (
        '<!doctype html><html lang="en"><head><meta charset="utf-8">'
        '<meta name="viewport" content="width=device-width,initial-scale=1">'
        "<title>" + _escape(label) + ": development rule preview</title><style>" + css
        + "</style></head><body><main><h1>" + _escape(label) + ": development rule preview</h1>"
        + '<section class="intro"><p class="notice">' + _escape(disclaimer)
        + "</p><p>" + _escape(EXPERT_NOTE) + "</p><p>" + _escape(INVENTORY_NOTE)
        + "</p><p>" + _escape(REFERENCE_NOTE) + "</p><p>Base commit: <code>"
        + _escape(manifest["base_commit"]) + "</code> · OPA <code>"
        + _escape(results["opa_version"]) + "</code></p>"
        + '<p class="links"><a href="README.md">Documentation</a>'
        + '<a href="manifest.json">Manifest</a><a href="results.json">All results</a>'
        + '<a href="matrix.csv">CSV</a><a href="method.md">Method</a></p>'
        + "<p>Original evidence (German): detailed model notes, case descriptions and "
        "observed outputs retain their original wording. A defined value does not prove "
        "domain correctness. An undefined query has no value; a defined JSON null stays null. "
        "The scope of eligible and similar fields is explained for each candidate.</p>"
        + "<details><summary>Replay</summary><pre>" + _escape(replay_command)
        + "</pre><p>Run from the repository root. Details of the frozen inputs "
        + "are in method.md.</p></details></section>"
        + '<section class="matrix"><h2>Execution overview</h2><div class="table-wrap">'
        + "<table><thead><tr><th>Measure</th><th>Run</th><th>Compilation</th>"
        + "<th>Baseline</th><th>Variation</th><th>Missing fact</th></tr></thead><tbody>"
        + "".join(html_rows) + "</tbody></table></div></section>"
        + "".join(_html_measure(measure, entries[measure["measure_id"]], artifact_base_url) for measure in measures)
        + "</main></body></html>\n"
    )
    return {
        "README.md": "\n".join(markdown).rstrip() + "\n",
        "index.html": html_document,
        "matrix.csv": csv_buffer.getvalue(),
    }
