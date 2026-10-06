# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_18`

Modus: `discover`
Run-ID: `v2-o6_18-luna-high-20261005`

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
- sources/o6_18_naturschutz_2025_10.pdf (seitenmarkierter Text: sources/o6_18_naturschutz_2025_10.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_18` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v2-o6_18-luna-high-20261005`;
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
vorbereiteten Workspace, repariere **alle** nachfolgenden Fehler und führe den
lokalen OPA-Validator wiederholt aus. Kontrolliere danach die Grounding-
Verträge, bis keine Fehler mehr verbleiben.

1. `coverage.json`: Die zwei `item_id`-Werte unter `sources.2.items` erfüllen
   das erlaubte Muster nicht. Benenne sie in eindeutige IDs aus Buchstaben,
   Ziffern, Punkt, Unterstrich oder Bindestrich um. Danach muss jedes der
   momentan als fehlend genannten `O618-*`-Regelobjekte durch mindestens einen
   gültigen Coverage-Eintrag abgedeckt sein; keine Regel darf aus dem Ledger
   fehlen.
2. Quellenbelege: `SRC-DROUGHT-HARVEST` und `SRC-SRL-FALLOW` referenzieren
   PDFs ohne Seite; ergänze korrekte Seiten. `SRC-GENERAL-SWITCH` hat einen auf
   der zitierten Seite nicht auffindbaren Belegtext. Korrigiere Seite und
   kurzen, maschinell auffindbaren wörtlichen `evidence_text` jeweils
   konsistent mit den Regeln.
3. Dateninventar und Daten: Die vier inventarisierten Dateien
   `duerre_2026.json`, `kombinationen.json`, `naturschutz_auflagen.json` und
   `praemiensaetze.json` müssen tatsächlich unter `workspace/data/o6_18/`
   vorhanden sein und alle Inventarpfade müssen exakt diesen `workspace/data/`
   Präfix verwenden. Richte Policy und Inventory auf dieselben vorhandenen
   Dateien aus und erfasse Zeilenzahlen korrekt.
4. Profile und Rego: Entferne den Array-Container
   `land.parcels[].naturschutz_codes[]`; verwende für die Eigenschaft ohne
   abschließendes `[]` einen echten JSON-Arraywert. Entferne den übergeordneten
   `application`-Vorschlag, der sich mit Unterpfaden überschneidet. Ergänze
   stattdessen jeden fehlenden tatsächlichen Blattpfad aus der Validatorliste
   (einschließlich der `application.*`-Werte, `year`, Parcel-Flächen- und
   Nutzungswerte) als zulässige, nicht-null Profile-Änderung mit Rule- und
   Citation-Verknüpfung. Nutze die reale Canonical-Struktur: insbesondere darf
   Rego nicht auf die parallele Form `input.parcel.*` zugreifen, sondern muss
   die passende `land.parcels[]`-Struktur verwenden. Keine Array- oder
   Objekt-Container, keine überlappenden Änderungen.
5. Stelle am Ende sicher, dass keinerlei Regel-Input-Pfade oder Rego-
   Input-Pfade außerhalb des Canonical Farm Profile und der gültigen
   `profile_changes.json` liegen. Erfolg des OPA-Validators genügt nicht;
   behebe die Grounding-Fehler vollständig.

## Zweiter verbindlicher Reparaturauftrag

Es verbleiben nur zwei Dateninventarfehler. Arbeite ausschließlich im
vorbereiteten Workspace und korrigiere in `rules/data_inventory.json` die
`row_count`-Werte an den folgenden JSON-Pointern auf die tatsächlichen
Zeilen-/Eintragszahlen der vorhandenen Daten:

- `workspace/data/o6_18/duerre_2026.json/duerre_2026/automatic_higher_force_harvest/states`: 41
- `workspace/data/o6_18/duerre_2026.json/duerre_2026/early_arable_biodiversity`: 5

Ändere die Daten nur, falls dies fachlich erforderlich ist; sonst passe das
Inventar an. Führe danach den lokalen Validator erneut aus und prüfe alle
Grounding-Verträge, bis keine Fehler verbleiben.
