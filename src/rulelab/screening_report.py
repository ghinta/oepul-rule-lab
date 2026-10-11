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
    "PYTHONPATH=src OPA_BIN=/absolute/path/opa python -m rulelab.screening verify "
    "--report-dir docs/analysis/luna-screening-20261011"
)
STATUS_LABELS = {
    "defined": "Wert definiert",
    "undefined": "Kein Wert (undefiniert)",
    "runtime_error": "Ausführungsfehler",
    "compile_error": "Kompilierfehler",
    "compiled": "Kompiliert",
    "fixture_gap": "Keine ausführbaren Fälle (fixture_gap)",
}
DISCLAIMER = (
    "Synthetische Entwicklungsfälle auf unveränderten historischen Luna-Artefakten. "
    "Die beobachteten Ausgaben sind keine unabhängig beurteilten Sollwerte, keine "
    "Genauigkeitsmessung und kein Nachweis der Quellkorrektheit. Es erfolgt keine "
    "Übernahme oder Förderfreigabe in der App."
)
EXPERT_NOTE = (
    "App-Issue #140 blockiert nur fachliche Sollurteile, die eine noch offene "
    "Auslegung benötigen. Technische Ausführung und dokumentierte Ausgabelücken "
    "können unabhängig davon untersucht werden."
)
INVENTORY_NOTE = (
    "Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. "
    "Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis "
    "unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind "
    "unvollständig, erfassen dynamische Referenzen nicht vollständig und sind "
    "kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten."
)
REFERENCE_NOTE = (
    "Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten "
    "helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; "
    "ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass "
    "unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt "
    "werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen "
    "Testfälle und dürfen nicht nachträglich dazu umetikettiert werden."
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
    return (artifact_base_url or "../../../") + quote(path, safe="/._-")


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
        return "Basis"
    return "ja" if case["output_changed_from_baseline"] else "nein"


def _csv_changed(case: dict[str, Any] | None) -> str:
    if case is None:
        return "fixture_gap"
    return str(case["output_changed_from_baseline"]).lower()


def _case_map(measure: dict[str, Any]) -> dict[str, dict[str, Any]]:
    return {case["case_id"]: case for case in measure["cases"]}


def _fact_state(state: dict[str, Any]) -> str:
    # A present JSON null is distinct from a removed member.
    return _json(state["value"]) if state["present"] else "Nicht vorhanden"


def _pre(value: Any) -> str:
    return "<pre>" + _escape(_json(value)) + "</pre>"


def _markdown_code(text: str) -> str:
    return "\n" + "\n".join("    " + line for line in text.splitlines()) + "\n"


def _compact_json(value: Any) -> str:
    return json.dumps(value, ensure_ascii=False, sort_keys=True)


def _html_inventory(measure: dict[str, Any]) -> str:
    inventory = measure.get("inventory")
    if inventory is None:
        return "<p class=empty>Kein zusätzliches Kandidateninventar erfasst.</p>"
    items = (
        ("Regelkatalog-Einträge", inventory["rule_count"]),
        ("Regeltypen", _compact_json(inventory["rule_type_counts"])),
        ("Quellen", inventory["source_count"]),
        ("Statisch erkannte Eingabepfade", len(inventory["static_policy_input_paths"])),
        ("Profilvorschläge", inventory["profile_proposal_count"]),
        ("Unabhängige Referenzfälle", inventory["independent_reference_case_status"]),
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
        "<div class=table-wrap><table><thead><tr><th>Quellen-ID</th>"
        "<th>Berichteter Prüfbereich</th><th>Einträge</th><th>Einordnung</th>"
        "</tr></thead><tbody>" + source_rows + "</tbody></table></div>"
        if source_rows else "<p>Keine Quellen-Coverage-Angabe im Inventar.</p>"
    )
    return (
        "<details><summary>Kandidateninventar und Referenzbedarf</summary><dl>"
        + descriptions + "</dl><p>" + _escape(INVENTORY_NOTE) + "</p><p>"
        + _escape(REFERENCE_NOTE) + "</p><details><summary>Statisch erkannte Eingabepfade</summary>"
        + _pre(inventory["static_policy_input_paths"]) + "</details>"
        + "<details><summary>Vom Modell berichtete Quellen-Coverage</summary>"
        + sources + "</details></details>"
    )


def _markdown_inventory(measure: dict[str, Any]) -> list[str]:
    inventory = measure.get("inventory")
    if inventory is None:
        return ["**Inventar:** Kein zusätzliches Kandidateninventar erfasst.\n"]
    lines = [
        "**Inventar:** " + str(inventory["rule_count"]) + " Regelkatalog-Einträge; "
        + str(inventory["source_count"]) + " Quellen; "
        + str(len(inventory["static_policy_input_paths"])) + " statisch erkannte Eingabepfade; "
        + str(inventory["profile_proposal_count"]) + " Profilvorschläge. "
        + "Unabhängige Referenzfälle: `"
        + _markdown(inventory["independent_reference_case_status"]) + "`.\n",
        "**Regeltypen:** `" + _markdown(_compact_json(inventory["rule_type_counts"])) + "`\n",
        "<details>\n<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>\n",
        INVENTORY_NOTE + "\n",
        "Statische Eingabepfade (keine Laufzeitspur):\n"
        + _markdown_code(_json(inventory["static_policy_input_paths"])),
    ]
    claims = inventory["source_coverage_claims"]
    if claims:
        lines.append(
            "| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |\n"
            "|---|---|---|---|"
        )
        lines.extend(
            "| " + _markdown(claim["source_id"]) + " | "
            + _markdown(claim["review_scope"]) + " | " + str(claim["item_count"])
            + " | " + _markdown(_compact_json(claim["disposition_counts"])) + " |"
            for claim in claims
        )
    else:
        lines.append("Keine Quellen-Coverage-Angabe im Inventar.")
    lines.extend(["\n</details>\n", REFERENCE_NOTE + "\n"])
    return lines


def _html_case(case: dict[str, Any]) -> str:
    status = case["status"]
    observed = (
        _pre(case["output"])
        if status == "defined"
        else "<p class=empty>Keine definierte native Ausgabe. Ein fehlender Wert "
        "wird weder durch null ersetzt noch als fachliche Ablehnung gewertet.</p>"
    )
    changes = case["changes_from_baseline"]
    error = (
        "<details><summary>Originaler OPA-Fehlertext</summary><pre>"
        + _escape(case["error"]) + "</pre></details>"
        if "error" in case else ""
    )
    diff = "<p>Keine Eingabeänderung gegenüber der Basis.</p>"
    if changes:
        rows = "".join(
            "<tr><td><code>" + _escape(change["path"]) + "</code></td><td><pre>"
            + _escape(_fact_state(change["before"])) + "</pre></td><td><pre>"
            + _escape(_fact_state(change["after"])) + "</pre></td></tr>"
            for change in changes
        )
        diff = (
            "<div class=table-wrap><table><thead><tr><th>Pfad</th>"
            "<th>Basis</th><th>Fall</th></tr></thead><tbody>" + rows
            + "</tbody></table></div>"
        )
    return (
        "<section class=case><h3>" + _escape(case["case_id"])
        + " <span class=badge>" + _escape(_status(case)) + "</span></h3><p>"
        + _escape(case["purpose"]) + "</p><p>Ausgabe gegenüber Basis geändert: <b>"
        + _escape(_changed(case)) + "</b></p><details><summary>Geänderte Fakten</summary>"
        + diff + "</details><details><summary>Synthetische Eingabe</summary>"
        + _pre(case["input"]) + "<p class=hash>SHA-256: <code>"
        + _escape(case["input_sha256"]) + "</code></p></details>"
        + "<details><summary>Native Ausgabe</summary>" + observed
        + "</details><details><summary>Vollständige OPA-Antwort</summary>"
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
    ) or "<li>Keine zusätzliche Abhängigkeit im Fixture dokumentiert; dies ist keine Vollständigkeitsbestätigung.</li>"
    compile_note = _escape(
        STATUS_LABELS.get(measure["compile"]["status"], measure["compile"]["status"])
    )
    compile_details = ""
    if measure["compile"]["errors"]:
        compile_details += (
            "<details><summary>Kompilierdiagnose als JSON</summary>"
            + _pre(measure["compile"]["errors"]) + "</details>"
        )
    if "error" in measure["compile"]:
        compile_details += (
            "<details><summary>Originaler OPA-Kompilierfehlertext</summary><pre>"
            + _escape(measure["compile"]["error"]) + "</pre></details>"
        )
    gap = (
        '<p class="notice"><b>Fixture-Lücke:</b> ' + _escape(measure["gap"]) + "</p>"
        if "gap" in measure else ""
    )
    return (
        '<article id="' + _escape(measure["measure_id"]) + '"><h2>'
        + _escape(measure["measure_id"]) + "</h2><p><code>"
        + _escape(measure["run_id"]) + "</code> · " + compile_note + "</p>"
        + compile_details + gap
        + '<p><a href="' + _escape(_fixture_href(measure)) + '">Fixture</a> · '
        + '<a href="' + _escape(_result_href(measure)) + '">Ergebnis-JSON</a></p>'
        + "<dl><dt>Eingaben und Einheiten</dt><dd>"
        + _escape(measure["input_contract_note"]) + "</dd><dt>Ausgabebedeutung</dt><dd>"
        + _escape(measure["output_contract_note"]) + "</dd><dt>Fallherkunft</dt><dd>"
        + _escape(measure["case_origin"]) + "</dd><dt>Native Query</dt><dd><code>"
        + _escape(measure["query"]) + "</code></dd></dl>"
        + _html_inventory(measure)
        + ("<details><summary>Zuordnung der Luna-Fakten und Vergleichslücken</summary>"
           + _pre(measure["luna_translation"]) + "</details>" if "luna_translation" in measure else "")
        + "<details><summary>Belege und offene Abhängigkeiten</summary><h3>Belege</h3><ul>"
        + references + "</ul><h3>Offene Abhängigkeiten</h3><ul>" + dependencies
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
        f"# {label}: diagnostische Sichtung der vorhandenen Regelkandidaten\n",
        disclaimer + "\n",
        EXPERT_NOTE + "\n",
        INVENTORY_NOTE + "\n",
        REFERENCE_NOTE + "\n",
        "Die native Ausgabe bleibt unverändert. `eligible` und ähnliche Felder haben "
        "je Kandidat unterschiedliche Bedeutungen; die Details stehen unten. "
        "`undefined` ist ein dokumentierter Befund. Eine definierte Ausgabe kann auch "
        "den JSON-Wert `null` enthalten; dieser unterscheidet sich von keinem Wert.\n",
        "[Befunde und nächste Entscheidung](findings.md) · [Aufklappbare Vorschau](index.html) · [Manifest](manifest.json) · "
        "[Alle Ergebnisse](results.json) · [Matrix als CSV](matrix.csv) · "
        "[Fixierung und Wiederholung](method.md)\n",
        f"Basiscommit: `{manifest['base_commit']}`. OPA: `{results['opa_version']}`. "
        "Policy und Daten werden je Run getrennt geladen; es erfolgt keine neue Modellgenerierung.\n",
        "## Ausführungsübersicht\n",
        "| Maßnahme | Run | Kompilierung | Basis | Variation | Fehlende Tatsache |\n"
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
        "\n`defined`: Query liefert einen nativen Wert. `undefined`: kein Wert. "
        "`runtime_error` und `compile_error`: technische Fehler mit originaler "
        "OPA-Diagnose im Ergebnis-JSON. `fixture_gap`: kein ausführbarer Fall; "
        "die konkrete Lücke steht beim Kandidaten. Diese Statuswerte sind keine fachlichen Bewertungen.\n",
        "## Reproduzieren\n",
        "Vom Repository-Wurzelverzeichnis mit der passenden absoluten OPA-Binary:\n",
        "```bash\n" + replay_command + "\n```\n",
        "Die Überprüfung vergleicht den eingefrorenen Bestand und die Ausgaben. "
        "Eingabe-, Artefakt- und Quellenhashes stehen im Manifest beziehungsweise "
        "Ergebnis-JSON. Die methodischen Grenzen sind in [method.md](method.md) beschrieben.\n",
        "## Kandidaten und beobachtete Fälle\n",
    ])
    for measure in measures:
        markdown.extend([
            f"### {_markdown(measure['measure_id'])}\n",
            f"Run: `{_markdown(measure['run_id'])}`. "
            f"[Fixture]({_fixture_href(measure)}) · [Native Ergebnisse]({_result_href(measure)})\n",
            "**Eingaben:** " + _markdown(measure["input_contract_note"]) + "\n",
            "**Ausgabebedeutung:** " + _markdown(measure["output_contract_note"]) + "\n",
            "**Herkunft:** " + _markdown(measure["case_origin"]) + "\n",
            "**Query:** `" + _markdown(measure["query"]) + "`\n",
            *_markdown_inventory(measure),
            *( ["**Zuordnung der Luna-Fakten und Vergleichslücken:**\n"
                + _markdown_code(_json(measure["luna_translation"]))] if "luna_translation" in measure else []),
            "| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |\n"
            "|---|---|---|---|",
        ])
        if not measure["cases"]:
            markdown.append("| — | fixture_gap | fixture_gap | Keine ausführbaren Fälle |")
        markdown.extend(
            "| " + _markdown(case["case_id"]) + " | " + _markdown(case["status"])
            + " | " + _changed(case) + " | " + _markdown(case["purpose"]) + " |"
            for case in measure["cases"]
        )
        if "gap" in measure:
            markdown.append("\n**Fixture-Lücke:** " + _markdown(measure["gap"]) + "\n")
        if measure["compile"]["errors"]:
            markdown.append(
                "\n**Kompilierdiagnose als JSON:**\n"
                + _markdown_code(_json(measure["compile"]["errors"]))
            )
        if "error" in measure["compile"]:
            markdown.append(
                "\n**Originaler OPA-Kompilierfehlertext:**\n"
                + _markdown_code(str(measure["compile"]["error"]))
            )
        for case in measure["cases"]:
            if "error" in case:
                markdown.append(
                    "\n**Originaler OPA-Fehlertext für " + _markdown(case["case_id"])
                    + ":**\n" + _markdown_code(str(case["error"]))
                )
        markdown.append("\n**Offene Abhängigkeiten:**\n")
        markdown.extend("- " + _markdown(item) for item in measure["open_dependencies"])
        if not measure["open_dependencies"]:
            markdown.append(
                "- Keine zusätzliche Abhängigkeit im Fixture dokumentiert; "
                "dies ist keine Vollständigkeitsbestätigung."
            )
        markdown.append("\n**Belege:**\n")
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
        '<!doctype html><html lang="de"><head><meta charset="utf-8">'
        '<meta name="viewport" content="width=device-width,initial-scale=1">'
        "<title>" + _escape(label) + ": diagnostische Regelvorschau</title><style>" + css
        + "</style></head><body><main><h1>" + _escape(label) + ": diagnostische Regelvorschau</h1>"
        + '<section class="intro"><p class="notice">' + _escape(disclaimer)
        + "</p><p>" + _escape(EXPERT_NOTE) + "</p><p>" + _escape(INVENTORY_NOTE)
        + "</p><p>" + _escape(REFERENCE_NOTE) + "</p><p>Basiscommit: <code>"
        + _escape(manifest["base_commit"]) + "</code> · OPA <code>"
        + _escape(results["opa_version"]) + "</code></p>"
        + '<p class="links"><a href="README.md">Dokumentation</a>'
        + '<a href="manifest.json">Manifest</a><a href="results.json">Alle Ergebnisse</a>'
        + '<a href="matrix.csv">CSV</a><a href="method.md">Methodik</a></p>'
        + "<p>Ein definierter Wert bestätigt keine fachliche Richtigkeit. Eine undefinierte "
        "Query ist ein Befund und hat keinen Wert; ein definierter JSON-Wert null bleibt null. "
        "Die Bedeutung von eligible und ähnlichen Feldern wird je Kandidat erläutert.</p>"
        + "<details><summary>Wiederholung</summary><pre>" + _escape(replay_command)
        + "</pre><p>Im Repository-Wurzelverzeichnis ausführen. Details zur Fixierung "
        + "stehen in method.md.</p></details></section>"
        + '<section class="matrix"><h2>Ausführungsübersicht</h2><div class="table-wrap">'
        + "<table><thead><tr><th>Maßnahme</th><th>Run</th><th>Kompilierung</th>"
        + "<th>Basis</th><th>Variation</th><th>Fehlende Tatsache</th></tr></thead><tbody>"
        + "".join(html_rows) + "</tbody></table></div></section>"
        + "".join(_html_measure(measure, entries[measure["measure_id"]], artifact_base_url) for measure in measures)
        + "</main></body></html>\n"
    )
    return {
        "README.md": "\n".join(markdown).rstrip() + "\n",
        "index.html": html_document,
        "matrix.csv": csv_buffer.getvalue(),
    }
