# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_17`

Modus: `discover`
Run-ID: `v2-o6_17-luna-high-20261005`

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
- sources/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf (seitenmarkierter Text: sources/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_17` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v2-o6_17-luna-high-20261005`;
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
vorbereiteten Workspace und repariere alle folgenden Validierungsfehler.
Führe danach den lokalen OPA-Validator erneut aus und prüfe alle Verträge,
bis `verify-grounding` fehlerfrei wäre.

1. Quellenbelege: Die Belegtexte `o617_method_records` und
   `o617_training_followup` sind auf ihren zitierten Seiten nicht auffindbar.
   Korrigiere Quelle, Seite und kurzen wörtlichen `evidence_text` auf
   maschinell auffindbare Formulierungen und passe die verknüpften Regeln an.
2. Cross-References: Entferne oder referenziere die unbenutzten Quellenbelege
   `notice_2026_biodiversity`, `notice_2026_drought_0805`,
   `notice_2026_drought_0812`, `notice_2026_insecticide`,
   `o617_kennarten_annex_source` und `o617_overview` regelkonform. Ergänze
   außerdem die bislang im Coverage Ledger fehlenden Regeln
   `o617.minimum.following_years_relaxed` und `o617.soil.exclusions` mit
   passenden Coverage-Einträgen oder korrigiere ihren Scope konsistent.
3. Profile und Rego: Ergänze alle fehlenden Blattpfade mit zulässigen,
   nicht-null Repräsentativwerten, Rule-IDs und Citation-IDs, insbesondere
   `oepul.o6_17.bonus_requested`,
   `oepul.o6_17.grassland_break_exception`,
   `oepul.o6_17.grassland_break_documented`,
   `oepul.o6_17.training_person_departure_date`,
   `oepul.o6_17.training_person_role`,
   `oepul.o6_17.training_event_id`, `oepul.o6_17.slope_percent`,
   `land.parcels[].o6_17.identified_kennarten`,
   `land.parcels[].o6_17.section_species_counts` und
   `land.parcels[].o6_17.transect_sections`. Keine Array- oder
   Objekt-Container als Änderung; Arrays werden durch echte JSON-Arrays mit
   repräsentativen Werten beschrieben. Entferne überlappende Änderungen.
4. Stelle sicher, dass danach weder Regel-Input-Pfade noch Rego-Input-Pfade
   außerhalb von Canonical Farm Profile und gültigen Profile-Vorschlägen
   liegen. Lass keine ungeprüften Fehler zurück.
