# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_3`

Modus: `discover`
Run-ID: `v2-o6_3-luna-high-20261001`

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
- sources/o6_3_heuwirtschaft_2025_10.pdf (seitenmarkierter Text: sources/o6_3_heuwirtschaft_2025_10.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_3` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v2-o6_3-luna-high-20261001`;
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

## Reparaturauftrag nach unabhängiger Grounding-Prüfung (Attempt 2)

Der erste Entwurf ist erzeugt, aber nicht finalisierbar. Arbeite weiterhin nur
im Run-Workspace. Lies das Canonical Farm Profile, die Verträge und die
Quellen erneut; repariere die bestehenden Artefakte und führe vor Abschluss
technische sowie Grounding-Validierung aus.

1. Ersetze die nicht maschinell auffindbaren Belegtexte der Quellenbelege
`O63-G05`, `O63-L05`, `O63-M02`, `O63-M08` und `O63-M17` durch jeweils kurze,
exakte wörtliche Ausschnitte auf der bereits zitierten Quelle und Seite, oder
korrigiere Quelle/Seite zu einer realen vorbereiteten Fundstelle. Keine
Paraphrasen.
2. Ergänze `rules/profile_changes.json` mit belegten, nicht überlappenden
Blattänderungen, sodass die Regelpfade
`farm.heuwirtschaft.feed_fermentation` und
`farm.heuwirtschaft.option_application_year` im vorgeschlagenen Profil nach
Anwendung existieren.
3. Revidiere Profilvorschläge und/oder Rego auf eine einheitliche Struktur, so
dass auch alle fehlenden Rego-Eingabepfade auflösbar sind: `animals`,
`compliance` (alle aufgelisteten Unterfelder), `contract_start_year`,
`eligible_area_ha`, `first_year` (Futterfläche, Mähwiese/-weide, RGVE),
`fodder_parcels`, `measure`, `no_mower_conditioner_option`,
`participation.combined_measure` und `year`. Nutze für Listen repräsentative
Objekt-Arrays gemäß Canonical-Profile-Notation, nie Arraycontainer-Targets.
4. Fachliche Regeln und Belege nicht nur zum Bestehen der Prüfung entfernen;
das Canonical Farm Profile bleibt unverändert. Beende erst bei leerem
Grounding-Fehlerbericht.

## Verbindliche Korrekturstrategie (Attempt 3)

Der vorige Reparaturversuch hat keine fachlichen Dateien geändert. Nimm jetzt
gezielt die folgenden Korrekturen vor, statt Quellen oder Verträge erneut
vollständig auszugeben:

1. Öffne nur die fünf vorhandenen Citation-Objekte `O63-G05`, `O63-L05`,
`O63-M02`, `O63-M08`, `O63-M17` und ihre genannten Seiten in den
seitenmarkierten `sources/*.txt`-Dateien. Ersetze jeweils ausschließlich
`evidence_text` durch einen kurzen, buchstabengetreuen, zusammenhängenden
Ausschnitt dieser PDF-Seite. Prüfe ihn mit einer wörtlichen Suche im
seitenmarkierten Text.
2. Repariere die Profil-/Rego-Inkonsistenz durch Konsolidierung auf die bereits
vorgeschlagene Canonical-Profile-Struktur, nicht durch neue künstliche
Root-Felder. Ergänze bei Bedarf fehlende Blätter in dem vorhandenen
`farm.heuwirtschaft`-Vorschlag (insbesondere `feed_fermentation` und
`option_application_year`). Stelle Rego und Tests auf denselben verschachtelten
Pfad um: Teilnahme, Vertragsjahr, Optionen und Compliance unter
`input.farm.heuwirtschaft`; Flächen aus `input.land.parcels`; Tierdaten aus
`input.livestock.species_groups`. Ersetze die bisherigen freien Root-Zugriffe
wie `input.animals`, `input.compliance`, `input.contract_start_year`,
`input.eligible_area_ha`, `input.fodder_parcels`, `input.first_year`,
`input.measure`, `input.participation`, `input.no_mower_conditioner_option`
und `input.year` durch die konsistente Profilstruktur oder entferne eine nur
technische, nicht durch eine Regel belegte Berechnung.
3. Aktualisiere nur die zugehörigen Tests und die strukturierten Regelpfade,
falls nötig, so dass Regeln, Rego und Profile dieselben Eingaben meinen.
Erhalte die fachlichen Schwellen, Optionen und Aussagen. Keine Platzhalter,
kein Ändern des Canonical Farm Profile.
4. Führe danach die lokale OPA-Validierung erneut aus. Prüfe vor deinem
Abschluss, dass die genannten fünf Belegtexte auffindbar sind und dass Rego
keine Pfade außerhalb des durch `profile_changes` vorgeschlagenen Profils
referenziert.

## Abschließende Coverage-Korrektur (Attempt 4)

Die unabhängige Grounding-Prüfung meldet genau einen verbleibenden Fehler:
`O63.SECOND_CROP` fehlt im Coverage Ledger. Ergänze im Run-Workspace die
zutreffende, bereits geprüfte Quellenseite bzw. den Tabellen-/Abschnittseintrag
in `rules/coverage.json` um diese Regel-ID. Erhalte alle bestehenden
Regeln/Belege, ändere nichts am Canonical Farm Profile und führe anschließend
die lokale technische Prüfung aus.

## Exakte Ein-Zeilen-Reparatur (Attempt 5)

Die vorangehende Korrektur hat die Datei nicht geändert. Öffne
`rules/coverage.json`, finde den Eintrag mit `item_id` `O63-C10` (Tabelle
„7 Höhe der Prämie einschließlich Folgejahre und Rückforderungsregel“, Seiten
4–5) und ergänze in genau dessen `rule_ids` zusätzlich die Zeichenkette
`O63.SECOND_CROP`. Dieser Abschnitt enthält die Zweitkulturregel. Bewahre die
beiden bestehenden IDs `O63.PREMIUM_TABLE` und `O63.LATER_STOCKING`, ändere
sonst nichts im Run-Workspace und führe die lokale OPA-Validierung aus.
