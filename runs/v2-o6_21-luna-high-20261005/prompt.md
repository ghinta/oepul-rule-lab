# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_21`

Modus: `discover`
Run-ID: `v2-o6_21-luna-high-20261005`

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
- sources/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf (seitenmarkierter Text: sources/o6_21_tierwohl-stallhaltung_rinder_2025_10.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_21` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v2-o6_21-luna-high-20261005`;
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
vorbereiteten Workspace und repariere alle folgenden Fehler. Führe danach den
lokalen Validator erneut aus und prüfe alle Grounding-Verträge bis zum
fehlerfreien Abschluss.

1. **Alle** Quellenbelege sind falsch an die extrahierten `.txt`-Dateien
   gebunden. `citations.json` muss ausschließlich Pfade verwenden, die exakt
   der vorbereiteten Source-Auswahl entsprechen: `workspace/sources/<original
   PDF-oder-HTML-Dateiname>`, nicht deren Text-Companions. Binde jeden
   `SRC-*`-Beleg auf das zugrunde liegende PDF bzw. die vorbereitete HTML-Datei
   zurück und setze `source_sha256` auf deren tatsächlichen Hash. PDF-Belege
   benötigen eine gültige Seite; HTML-Belege müssen `page: null` verwenden.
   Verifiziere anschließend jeden `evidence_text` wieder an der korrekten
   Quelle und Seite. Ändere keine Quellen außerhalb der vorbereiteten Auswahl.
2. Ergänze die fehlende Regel `O621-LITTER-QUALITY` im Coverage Ledger.
3. Dateninventar: Die vorhandene Datei ist
   `workspace/data/o6_21_tables.json`; korrigiere den Artefaktpfad in
   `rules/data_inventory.json` von `data/o6_21_tables.json` auf diesen
   vollständigen Workspace-Pfad und halte alle Tabellenangaben konsistent.
4. Profile und Rego: Ergänze einen zulässigen, nicht-null Blattpfad für
   `participation_year`. Ergänze außerdem die tatsächlich verwendeten
   `farm.o6_21.cow_count`, `farm.o6_21.open_stall` und
   `farm.o6_21.shared_group` als zulässige konkrete Blattpfade samt Rule- und
   Citation-Verknüpfungen, oder passe Rego konsistent auf eine vorhandene
   Canonical-Struktur an. Keine Container- oder überlappenden Änderungen.
5. OPA-Erfolg allein genügt nicht: Behebe alle Evidence-, Coverage-, Daten-
   und Profile-Application-Fehler vollständig vor Abschluss.
