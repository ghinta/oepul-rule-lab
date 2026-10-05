# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_22`

Modus: `discover`
Run-ID: `v2-o6_22-luna-high-20261005`

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
- sources/o6_22_tierwohl-schweinehaltung_2025_10.pdf (seitenmarkierter Text: sources/o6_22_tierwohl-schweinehaltung_2025_10.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_22` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v2-o6_22-luna-high-20261005`;
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

## Reparaturlauf: zwingende Grounding-Korrekturen

Der erste Entwurf hat die Grounding-Prüfung nicht bestanden. Repariere die
Artefakte im vorbereiteten Workspace vollständig und führe anschließend erneut
den technischen Validator aus. Arbeite ausschließlich im Workspace und ändere
kein Canonical Profile oder Quellenmaterial.

- In `rules/rules.json` darf kein `source_reference_ids`-Array doppelte IDs
  enthalten (der Fehler betrifft insbesondere Regelindex 5).
- Gleiche alle Einträge in `rules/coverage.json` und in
  `rules/profile_changes.json` exakt gegen die tatsächlich vorhandenen
  `rule_id`-Werte ab. Ersetze veraltete/abweichende IDs oder ergänze die
  zugehörigen Regeln. Entferne außerdem keine Quellenbelege ohne Grund:
  Jeder Referenzbeleg muss von wenigstens einer Regel verwendet werden; nicht
  belegte Sachverhalte als `not_rule`/`unresolved` dokumentieren, statt
  Referenzen unverbunden zu lassen.
- Korrigiere die Belegtexte `sr22.category-end` und `srl.measure-space`, sodass
  `evidence_text` als kurzer, wortgetreuer Ausschnitt auf genau der angegebenen
  Seite und aus genau der angegebenen Quelle maschinell auffindbar ist.
- Der Datensatz `data/o6_22_tables.json` muss im Workspace liegen und die
  Inventarangabe in `rules/data_inventory.json` muss den exakten Pfad
  `workspace/data/o6_22_tables.json` verwenden (mit gültigen Pointern,
  Zeilenzahlen und Referenz-IDs).
- Bereinige die Profilvorschläge: Keine überlappenden Änderungen (insbesondere
  nicht gleichzeitig `livestock.o6_22` und dessen Unterpfad
  `livestock.o6_22.supplement_facts`). Verwende die verschachtelte, zum
  Canonical Profile passende Struktur und ein repräsentatives Array-Objekt, wo
  nötig. Jede in Rego gelesene Eingabepfad-Variable muss durch den vorgeschlagenen
  Profilpfad erreichbar sein; passe andernfalls Rego auf die vorgeschlagene
  Profilstruktur an. Die unzulässigen flachen Pfade wie `input.category`,
  `input.year`, `input.eligible_gve`, `input.free_range.*`,
  `input.compost_surcharge.*`, `input.protein_surcharge.*` und
  `input.uncut_surcharge.*` dürfen nicht ungeklärt verbleiben.
- Führe vor Abschluss mindestens aus:
  `python3 tools/opa_validate.py validate --workspace . --target policy --target data --target tests --write --result-json technical-validation.json --pretty`.
  Stelle sicher, dass Rego formatiert ist, Compile und Tests bestehen, und dass
  die fünf Regelartefakte die strikte Grounding-Prüfung bestehen.

## Zweiter Reparaturlauf: Dateninventar-Zeilenzahlen

Die zweite Grounding-Prüfung ist bis auf drei Einträge erfolgreich. Korrigiere
in `rules/data_inventory.json` ausschließlich die `row_count`-Angaben anhand
der tatsächlich enthaltenen Datensätze in `workspace/data/o6_22_tables.json`:

- Pointer `/o6_22/free_range`: 6 statt 1 Zeile.
- Pointer `/o6_22/premium_rules`: 3 statt 1 Zeile.
- Pointer `/o6_22/protein_feed_definition`: 4 statt 1 Zeile.

Prüfe danach die Schemas und den technischen Validator erneut. Ändere keine
Quellen oder das Canonical Farm Profile.
