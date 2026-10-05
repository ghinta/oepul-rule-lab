# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_24`

Modus: `discover`
Run-ID: `v2-o6_24-luna-high-20261005`

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
- sources/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf (seitenmarkierter Text: sources/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_24` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v2-o6_24-luna-high-20261005`;
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

## Reparaturlauf: Grounding- und Profilabgleich

Der erste Entwurf besteht die Grounding-Prüfung noch nicht. Korrigiere im
vorbereiteten Workspace alle folgenden Punkte und validiere anschließend erneut:

- Die in `rules/profile_changes.json` referenzierten Regel-IDs für
  `land.parcels[].constraints.is_wrrl_area` und
  `land.parcels[].constraints.wrrl_higher_n_authorization` müssen exakt mit
  vorhandenen `rule_id`-Werten übereinstimmen. Korrigiere die IDs oder die
  Regelkatalog-IDs ohne Regeln zu verlieren.
- Korrigiere `evidence_text` bei `O624-GEN-P17-CONTROL` und
  `O624-GEN-P5-APPLICANT` zu kurzen, wortgetreuen Ausschnitten, die auf der
  jeweils angegebenen Quelle und Seite maschinell auffindbar sind.
- Gleiche Rego und Profilvorschläge ab: Die Regeln O624-DROUGHT-001 und
  O624-PREM-001 sowie Rego verwenden `year`; O624-DROUGHT-001 verwendet zudem
  `region.district`. Ergänze belegte, nicht überlappende, zur Canonical-
  Profile-Struktur passende Vorschläge oder stelle Rego korrekt auf bereits
  vorgeschlagene Pfade um. `input.year` darf nicht als ungedeckter Pfad
  verbleiben.
- Das Datendokument `data/o6_24_reference_tables.json` muss als Datei im
  Workspace vorhanden sein und `rules/data_inventory.json` muss den exakten
  Inventarpfad `workspace/data/o6_24_reference_tables.json` verwenden, nicht
  `data/o6_24_reference_tables.json`.

Ändere weder Quelldokumente noch das Canonical Farm Profile. Führe vor dem
Abschluss den lokalen technischen Validator aus und beende erst bei einer
vollständig erfolgreichen Grounding-Prüfung.

## Zweiter Reparaturlauf: Dateninventar-Zeilenzahl

Die Grounding-Prüfung ist bis auf einen Eintrag erfolgreich. Korrigiere in
`rules/data_inventory.json` für
`workspace/data/o6_24_reference_tables.json` den JSON-Pointer
`/drought_2026_exception_districts`: Die tatsächliche `row_count` ist 41,
nicht 5. Prüfe danach den technischen Validator und die Grounding-Prüfung
erneut. Quellen und das Canonical Farm Profile bleiben unverändert.

## Dritter Reparaturlauf: Profilabdeckung wiederherstellen

Nach der Dateninventar-Korrektur ist die Profilabdeckung erneut fehlerhaft.
Behebe sie vollständig, ohne die bereits bestandenen Grounding-Bereiche zu
verschlechtern. Insbesondere verwenden O624-DROUGHT-001, O624-PREM-001 und
O624-SANCTION-002 die Eingabepfade `year` sowie `region.district`; Rego liest
außerdem `input.region.federal_state`. Ergänze für alle diese fachlich
benötigten Felder belegte, nicht überlappende Änderungsanträge in
`rules/profile_changes.json` in exakt der Struktur des Canonical Farm Profile
oder ändere Rego und Regeln konsistent auf bereits vorgeschlagene gültige
Pfade. Anschließend müssen sämtliche Rego-Inputpfade und jede Regelbedingung
durch die vorgeschlagene Profilstruktur abgedeckt sein. Führe den lokalen
Validator und die Grounding-Prüfung erneut aus; ändere weder Quellen noch das
Canonical Farm Profile.
