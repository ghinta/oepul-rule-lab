# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_7`

Modus: `discover`
Run-ID: `v2-o6_7-luna-high-20261002`

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
- sources/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf (seitenmarkierter Text: sources/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_7` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v2-o6_7-luna-high-20261002`;
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

## Verbindlicher Reparaturauftrag nach erstem vollständigem Lauf

Der zweite Versuch hat inhaltliche Dateien erzeugt, die strikte
Grounding-Prüfung scheitert jedoch. Arbeite ausschließlich im bestehenden
Workspace weiter, erhalte die fachliche Abdeckung und behebe **alle** folgenden
Punkte. Führe anschließend den lokalen Validator und `verify-grounding` erneut
aus, bis beide vollständig erfolgreich sind.

1. In `rules/citations.json` wurden die vorbereiteten PDF-Quellen irrtümlich
   als extrahierte `workspace/sources/*.txt` referenziert. Verwende für die
   allgemeinen Bedingungen, Anhänge und Maßnahmenblatt die tatsächlichen
   vorbereiteten `.pdf`-Pfade und ihre korrekten SHA-256-Werte; Seitenzahlen
   bleiben für PDFs zulässig. Das betrifft mindestens `ANNEX_L`, `GEN_P4` bis
   `GEN_P13`, `GEN_P17`, `GEN_P18`, `INFO_P1` bis `INFO_P10`,
   `INFO_P7_USE`, `M57_*`, `M58_*` und `MAIN_GENERAL_*`. Nur die tatsächlichen
   Notice-HTML-Dateien verwenden `page: null`. Stelle auch sicher, dass jede
   Citation von mindestens einer Regel genutzt wird: die ungenutzten
   `D2026_JUN12_NOT` und `D2026_MAY22_NOT` entweder korrekt mit einer Regel
   verbinden oder samt unbenutzter Verweise entfernen.
2. Korrigiere den Coverage Ledger auf genau die acht vorbereiteten Quellen:
   die vier PDFs `20241011_srl_oepul_2023.pdf`,
   `20241011_srl_oepul_2023_anhaenge.pdf`,
   `o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf` und
   `o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, plus die vier
   vorbereiteten Notice-HTMLs. Entferne alle `.txt`-Ledger-Pfade. Für HTML
   müssen `pages_reviewed` leer und der Scope `full_document` sein; für die
   PDFs verwende korrekte Seitenlisten und einen zulässigen Scope.
3. Repare `rules/profile_changes.json`: die Add-Änderungen 16 und 19 dürfen
   ausschließlich `value_after`, nicht `value_before`, enthalten. Ergänze die
   fehlenden Profilpfade konsistent als Objekte: mindestens `measure` für alle
   `input.measure.*`- und Regelbedingungen verwendeten Angaben und
   `farm.oepul` für alle `input.farm.oepul.*`-Angaben. Die Objekte müssen
   sämtliche tatsächlich verwendeten Kinder abdecken, z. B.
   `cover_share_percent`, `harvest_share_percent`,
   `field_emergence_full_cover`, `proper_establishment`,
   `credible_forward_management`, `mixture_partners`, `gap_days`,
   `turnover_date`, `withdrawn`, `measure_6_participating` und
   `application_date`. Verwende präzise bestehende Array-Objektnotation unter
   `land.parcels[].operations.cover_crop`; keine kollidierenden Einzel-Adds.
4. Korrigiere alle Datenverweise und das Inventar: die drei erzeugten Dateien
   `annex_l_combination_table.json`, `duerre_2026.json` und
   `o6_7_thresholds.json` existieren unter `workspace/data/`; alle
   Datenartefakt-Pfade im Regelkatalog und alle `data_inventory.json`-Pfade
   müssen genau diese `workspace/data/...`-Notation verwenden. Verweise dürfen
   nicht auf das unaufgelöste `data/...` zeigen.

Ändere weiterhin niemals das Canonical Farm Profile oder Quellmaterial. Keine
Platzhalter, keine erfundenen Quellen. Schließe erst mit einem vollständig
erfolgreichen technischen und Grounding-Ergebnis ab.

## Zweiter Reparaturdurchgang – exakte Restfehler

Die Quellen-, Coverage- und Pfadbenennungen sind nun korrekt. Repariere nur
noch die folgenden Validatorfehler, ohne Abdeckung zurückzunehmen:

1. `profile_changes.json`: Bei den nullwertigen Additionsfeldern
   `land.parcels[].crop.gloez8_variant` und
   `land.parcels[].operations.cover_crop.maintenance_day_of_year` erkennt das
   Schema wegen des JSON-`null` kein `value_after`. Gib beiden Additionsfeldern
   ein explizites, nicht-null Strukturmuster in derselben Notation wie das
   Canonical Profile (z. B. `string|null` bzw. `number|null`). Jede Add-Änderung
   muss ausschließlich ein wirksames `value_after` haben. Danach muss das
   vollständige Profilproposal wieder angewendet werden können; damit müssen
   auch `measure.o6_7.*`, `farm.oepul.*` und die genannten
   `land.parcels[].operations.cover_crop.*`-Pfade auflösbar sein.
2. `rules/data_inventory.json`: Verwende die vom Validator gezählten
   Zeilenzahlen, nicht die Anzahl der obersten Container: für
   `/duerre_2026/green_cover_exception` **5**, für
   `/duerre_2026/harvest_obligation_exception/states` **41** und für
   `/o6_7_thresholds` **32**. SHA-256, Pointer und Quellenbelege bleiben
   passend zu den vorhandenen Dateien.

Führe die vollständige strikte Validierung und Grounding-Prüfung selbst erneut
aus und behebe nur tatsächliche Restfehler, bis beide ohne Fehler bestehen.
