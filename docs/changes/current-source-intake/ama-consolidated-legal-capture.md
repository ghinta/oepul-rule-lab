# AMA-verlinkte konsolidierte Rechtsfassungen: Aufnahme vom 10. Oktober 2026

Die bestehenden Funktionen `manage_sources.request`, `pdf_response` und
`import_original` haben die beiden aktuell vom AMA-Rechtsgrundlagenindex
verlinkten konsolidierten Original-PDFs aufgenommen. Die neue Aufnahme bewahrt
Dateiname und tatsächliches Konsolidierungsdatum; sie behauptet keine neue
Oktober-Rechtsfassung. Das Inventar und der Root-Manifestzeiger wurden durch
diesen Zusatzimport nicht verändert.

| Scope | Konsolidierte Fassung | Seiten | Original-SHA-256 |
| --- | --- | ---: | --- |
| `gsp_av` | 28.01.2026 | 94 | `d01dd8024d9575da1ec094506744c3aa7b43d1f8f17552a6aab62f422a755c10` |
| `napv` | 28.10.2024 | 42 | `6bec588cc818a8e6620f9abda47c4de0489e4cc65bdd20466595722ac0e0fc92` |

Die unveränderten Originalbytes liegen unter
`sources/oepul/supplemental/<scope>/<original-sha256>/`. Beide Originalantworten
waren HTTP 200 mit `application/pdf`. Ein erneut abgerufener AMA-Rechtsgrundlagenindex
bewahrt die vollständigen rohen HTML-Bytes und die verlinkten Original-URLs.
Die Capture-, Import-Provenance- und Indexpins einschließlich separater tatsächlicher
HTTP-Beobachtungen stehen in
`sources/oepul/provenance/supplemental-ama-legal-20261010T210115787092Z/capture-report.json`
(SHA-256 `5e84fc2f72a7f023d284184e8c2e7e146f48f7e636d737d28e4d3c5bb6dffbf3`).
Die Importkennzeichnung bleibt `supplied_original_file`, ohne erfundene HTTP-Provenance.
Beide Capture-Verträge wurden mit `source_intake.verify_capture` geprüft.

Beide Scopes bleiben ohne den dokumentierten Vergleich mit der zum Inventarstichtag
geltenden vollständigen RIS-Konsolidierung, Prüfung anwendbarer Änderungen und
vollständigen unabhängigen Original-/Tabellenreview offen. Für die NAPV sind alle
benötigten Anlagen, Einheiten, Fußnoten und die unterschiedlichen Bezugsgrößen von
Tier-Stickstoffausscheidung und jahreswirksamer Ausbringung getrennt zu prüfen.
Die Aufnahme ersetzt weder individuelle Sanktionsentscheidungen noch fachliche
Anrechnungsentscheidungen und behauptet keine rechtliche Vollständigkeit.
