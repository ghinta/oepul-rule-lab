# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_19`

Modus: `discover`
Run-ID: `v2-o6_19-luna-high-20261005`

Arbeite ausschließlich im aktuellen Run-Workspace. Lies `AGENTS.md`, danach das
Canonical Farm Profile und anschließend die folgenden Quellen. Lies das
Maßnahmenblatt, die allgemeinen Teilnahmebedingungen und die 2026-Hinweise
vollständig. Durchsuche die Rechtsgrundlagen und Anhänge systematisch nach der
Maßnahme und lies alle gefundenen Abschnitte samt Definitionen, Tabellen,
Fußnoten und Querverweisen vollständig:

- sources/20241011_srl_oepul_2023.pdf (seitenmarkierter Text: sources/20241011_srl_oepul_2023.txt)
- sources/20241011_srl_oepul_2023_anhaenge.pdf (seitenmarkierter Text: sources/20241011_srl_oepul_2023_anhaenge.txt)
- sources/2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html
- sources/2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html
- sources/2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html
- sources/2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html
- sources/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf (seitenmarkierter Text: sources/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_19` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v2-o6_19-luna-high-20261005`;
   `source_path` und `artifact_path` beginnen mit
   `workspace/`, damit sie vom Run-Verzeichnis aus auflösbar sind. Ermittle die
   tatsächlichen SHA-256-Werte der kopierten Quellen. `evidence_text` ist ein
   kurzer wörtlicher Ausschnitt, der auf der angegebenen PDF-Seite bzw. in der
   HTML-Quelle tatsächlich vorkommt; eine Paraphrase ist hier unzulässig.
4. Implementiere ausführbare Rego-v1-Regeln unter `policy/` und aussagekräftige
   Tests unter `tests/`. Überführe umfangreiche Tabellen und geschlossene Listen
   vollständig nach `data/` und verwende sie aus Rego; fasse sie nicht nur
   beschreibend zusammen.
5. Ändere `canonical_farm_profile.json` niemals direkt. Lies
   `contracts/profile-changes-v1.schema.json` und schreibe benötigte Ergänzungen,
   Änderungen oder Löschungen nach `rules/profile_changes.json`. Jeder Vorschlag
   benötigt verknüpfte Regel- und Quellenbeleg-IDs. Verwende für `value_after`
   exakt die Struktur-Notation des Canonical Farm Profile: insbesondere ein
   JSON-Array mit repräsentativem Objekt statt des Strings `array<object>`. Im
   Modus `conform` muss das Array `changes` leer bleiben.
6. Führe OPA-Formatierung, Strict-Compile-Check und Tests wiederholt aus und
   repariere technische Fehler. Dokumentiere verbleibende fachliche
   Mehrdeutigkeiten in `notes/assumptions.md`.
7. Lies `contracts/coverage-ledger-v1.schema.json` und dokumentiere jeden
   geprüften Abschnitt, Absatz, jede Tabelle und Fußnote in
   `rules/coverage.json`: entweder mit Regel-IDs oder als `not_rule` bzw.
   `unresolved` samt Begründung. Maßnahmenblatt, allgemeine Bedingungen und
   2026-Hinweise werden vollständig geprüft; bei Rechtsgrundlagen darfst du
   gezielte Abschnitte mit begründetem `targeted_sections`-Scope verwenden.
8. Lies `contracts/data-inventory-v1.schema.json` und inventarisiere jede Datei
   unter `data/` in `rules/data_inventory.json`. Erfasse Tabellen über
   JSON-Pointer, Zeilenzahl und Quellenbeleg-IDs. Gibt es keine Datendateien,
   bleibt `artifacts` leer.
9. Validiere vor Abschluss alle fünf JSON-Ausgaben nochmals Feld für Feld gegen
   die mitgelieferten Schemas; ähnliche oder ältere Formate gelten als Fehler.

Lasse Regeln nicht allein wegen eines unvollständigen Ausgangsprofils weg. Ziel
ist zunächst maximale, quellengebundene und technisch lauffähige Extraktion;
eine unabhängige fachliche Bewertung findet später statt.

## Verbindlicher Reparaturauftrag nach Grounding-Validierung

Der Generierungsversuch ist nicht veröffentlichbar. Arbeite ausschließlich im
vorbereiteten Workspace und repariere sämtliche folgenden Fehler. Führe danach
den lokalen OPA-Validator erneut aus und kontrolliere die Grounding-Verträge,
bis sie ohne Fehler bestehen.

1. Quellen- und Cross-References: Die genannten Referenzen
   `GEN-P12-LAST-ENTRY`, `GEN-P14-TAKEOVER`, `GEN-P15-MEASURE-SWITCH`,
   `LEGAL-P21-APPLICATION`, `LEGAL-P29-DIV-CREDIT`, `MEAS-P4-BIODIVERSITY`,
   `MEAS-P5-APPLICATION`, `MEAS-P5-BIODIVERSITY-EXAMPLE`,
   `MEAS-P5-LAST-ENTRY` und `MEAS-P5-MEASURE-SWITCH` haben unzulässige
   Zeilenbereiche über das Ende von `workspace/rules/profile_changes.json`.
   Binde jede Referenz an das richtige Artefakt und vorhandene Zeilenbereiche.
   Korrigiere außerdem die nicht auffindbaren Belegtexte von
   `GEN-P15-MEASURE-SWITCH` und `LEGAL-P29-DIV-CREDIT` auf der passenden Seite
   und entferne oder nutze die derzeit unbenutzten Belege
   `GEN-P13-APPLICATION` und `MEAS-P7-HABITATS` regelkonform.
2. Coverage: Danach dürfen keine Cross-Reference-Fehler verbleiben; alle
   verknüpften Rule- und Citation-IDs müssen nach den Änderungen konsistent
   bleiben.
3. Profile und Rego: `documentation.ebw.parcels[]` und
   `documentation.ebw.parcels[].mandatory_indicator_codes[]` sind keine
   zulässigen Zielpfade. Ersetze sie durch konkrete Blatt-Eigenschaften ohne
   abschließendes `[]` und beschreibe Arrays als echte JSON-Arrays mit
   repräsentativen Werten. Ergänze darüber hinaus **alle** vom Validator
   genannten fehlenden `measure.*`- und Rego-Pfade als zulässige, nicht-null
   Blattpfade mit Rule- und Citation-Verknüpfungen, oder passe die Regeln und
   Rego konsistent auf vorhandene Canonical-Strukturen an. Keine
   Objekt-/Array-Container oder überlappende Änderungen.
4. Dateninventar: Korrigiere die `row_count`-Werte in
   `rules/data_inventory.json` auf die tatsächlichen Eintragszahlen:
   `acker` 12, `weiden` 21, `wiesen` 162 und `surcharges` 15. Ändere die
   Daten nur, wenn fachlich notwendig, und erhalte vollständige Tabellen.
5. Der technische Validator genügt nicht allein: Behebe alle Evidence-,
   Cross-Reference-, Profile-Application- und Datenfehler vollständig, bevor
   der Run endet.
