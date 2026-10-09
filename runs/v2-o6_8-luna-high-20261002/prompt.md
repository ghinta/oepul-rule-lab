# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_8`

Modus: `discover`
Run-ID: `v2-o6_8-luna-high-20261002`

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
- sources/o6_8_erosionsschutz_acker_2026_04.pdf (seitenmarkierter Text: sources/o6_8_erosionsschutz_acker_2026_04.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_8` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v2-o6_8-luna-high-20261002`;
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

## Verbindlicher Reparaturauftrag nach technischer Prüfung

Der erste Lauf hat die fachlichen Dateien erzeugt, aber die strikte
Grounding-Prüfung meldet wenige präzise Restfehler. Erhalte alle Regeln und
behebe **jeden** folgenden Punkt ausschließlich im bestehenden Workspace;
führe Validator und `verify-grounding` danach erneut aus, bis beide sauber
durchlaufen.

1. Ergänze `O68-030` im Coverage Ledger mit einer fachlich passenden,
   bereits geprüften Abdeckungszeile; die Regel darf nicht länger als nicht
   abgedeckt gelten.
2. Ergänze in `rules/profile_changes.json` belegte, nicht kollidierende
   Profilvorschläge für alle fehlenden Pfade, in der Canonical-Profile-Notation
   und mit verknüpften Regel- und Quellen-IDs:
   - `land.parcels[].operations.days_between_first_tillage_and_following_crop`
   - `land.parcels[].operations.plant_mulch_remaining`
   - `land.parcels[].operations.full_area_tillage`
   - `land.parcels[].operations.slot_drill_into_cover`
   - `land.parcels[].operations.residues_between_strips`
   - `land.parcels[].operations.strip_rows_only`
   - `land.parcels[].country`
   - `farm.documentation` (oder passe die Regel auf den tatsächlich passenden
     vorhandenen Dokumentationspfad an)
   - `land.parcels[].operations.harvestable_stand`.
   Nutze bei vorhandenen Objekt- oder Arrayzusätzen eine zusammenhängende
   Erweiterung statt kollidierender Add-Änderungen.
3. Korrigiere in `rules/data_inventory.json` die Zeilenzahl des Pointers
   `workspace/data/drought_2026_exempt_districts.json` →
   `/drought_2026_exempt_districts/districts` auf **39**. Pfad, SHA-256 und
   Quellenbelege müssen zu der vorhandenen Datei passen.

Ändere niemals Quelldokumente oder das Canonical Farm Profile und erfinde keine
Evidenz. Beende erst nach vollständig erfolgreicher technischer und
Grounding-Validierung.
