# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_2`

Modus: `discover`
Run-ID: `v2-o6_2-luna-high-20260930`

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
- sources/o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf (seitenmarkierter Text: sources/o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_2` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v2-o6_2-luna-high-20260930`;
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

Der erste Entwurf ist erzeugt, aber nicht finalisierbar. Arbeite weiter nur im
Run-Workspace. Lies die Verträge und das Canonical Farm Profile erneut,
repariere die vorhandenen Artefakte und führe die technische sowie die
Grounding-Validierung erneut aus. Beende erst bei leerem Fehlerbericht.

1. Entferne oder korrekt verknüpfe den unbenutzten Quellenbeleg `GEN-08`.
Der Quellenbeleg `O62-18` verweist auf eine nicht existierende/nicht
vorbereitete Quelle; ersetze ihn durch eine reale vorbereitete Quelle mit
exaktem Beleg oder korrigiere die betroffene Regel fachlich belegt.
2. Revidiere `profile_changes.json` vollständig: Keine Änderung darf direkt
auf einen Arraycontainer wie `farm.measures[]` oder
`land.parcels[].operations.psm_applications[]` zielen. Verwende stattdessen
zulässige Blattpfade bzw. repräsentative Objekt-Arrays gemäß Schema, ohne
überlappende Eltern-/Kindänderungen. Sorge dafür, dass alle von Regeln und
Rego genutzten Pfade nach Anwendung im vorgeschlagenen Profil existieren.
Das betrifft mindestens `year`, `application_year`, `farm.measures`,
`farm.input_inventory`, `farm.payment_components`, `land.parcels` samt
`operations`, `crop`, `land_use` und Dürre-/Zahlungsfeldern,
`land.measure_area_current_year`, `land.measure_area_previous_year`,
`livestock.species_groups`, `region.district`, `region.federal_state` sowie
die vollständigen `program.o6_1a`, `program.o6_1b`, `program.o6_2` und
`program.change_date`/`program.target_measure`-Felder. Berücksichtige
insbesondere alle als fehlend gemeldeten Rego-Pfade unter `input.*`; gleiche
Regelkatalog und Rego auf eine einheitliche, im vorgeschlagenen Profil
auflösbare Struktur ab.
3. Korrigiere im Data Inventory die `table_row_count` für
`workspace/data/drought_2026.json` am Pointer
`/drought_2026/automatic_higher_force_states`: Der Validator ermittelt 41,
nicht 5. Prüfe auch alle übrigen Tabellenzählungen gegen die tatsächliche
Validator-Semantik.
4. Keine fachlich relevanten Regeln, Tabellen oder Quellenbelege allein zum
Bestehen der Prüfung löschen. Das Canonical Farm Profile bleibt unverändert.

## Zweite Reparaturpräzisierung (Attempt 3)

Die zweite Fassung hat die Quellen- und Datenprobleme behoben, scheitert aber
noch an Profilvorschlägen. Repariere ausschließlich im Run-Workspace und
validiere erneut.

1. Entferne oder korrigiere die ungültigen no-op Änderungen `changes.8`,
`changes.9`, `changes.12` und `changes.13`: jeder Change muss einen vom
aktuellen Wert unterscheidbaren `value_after` haben. Lies dafür die aktuelle
Profile-Change-Datei und das Baseline-Profil; behalte erforderliche Felder als
zulässige Ergänzungen bei, statt sie unbesehen zu löschen.
2. Die vorigen Ergänzungen haben nicht die von Regeln/Rego benötigte Struktur
erzeugt. Baue `profile_changes.json` konsistent nach Schema und
Canonical-Profile-Notation neu auf: Jede fehlende Variable muss nach Anwendung
des Profils existieren, Array-Listen als repräsentative Objekt-Arrays, keine
Arraycontainer-Targets und keine überlappenden Eltern-/Kindänderungen.
3. Stelle besonders die vollständigen Substrukturen bereit, die die Prüfung
nennt: root `year` und `application_year`; `farm.compliance`,
`farm.training`, `farm.input_inventory`, `farm.payment_components`,
`farm.forage_area_ha`; `land.parcels` mit `operations.fertilizer`,
`operations.psm_applications`, `operations.seed_treatment`, `crop`, `code`
und Dürrefeldern; `land.measure_area_current_year`/
`land.measure_area_previous_year`; `livestock.species_groups`; `region`;
sowie `program.o6_1a`, `program.o6_1b`, `program.o6_2`, `program.change_date`
und `program.target_measure`. Richte Regelpfade und Rego konsistent darauf
aus. Insbesondere muss das finale vorgeschlagene Profil alle aufgelisteten
`input.*` Rego-Pfade tatsächlich auflösen.
4. Prüfe vor Ende die konkrete Anwendung der Profiländerungen auf eine Kopie
des Baseline-Profils und dann die Grounding-Validierung. Fachliche Regeln,
Tabellen und Belege dürfen nicht zur Fehlervermeidung weggelassen werden.

## Abschließende Quellenbeleg-Reparatur (Attempt 4)

Es bleibt nur ein Grounding-Fehler. Repariere im Run-Workspace den
Quellenbeleg `O62-18-TXT`: Er verweist auf eine nicht vorbereitete HTML-Quelle
und hat deshalb eine ungültige Seitennummer. Verknüpfe die fachliche Regel mit
einer tatsächlich vorbereiteten Quelle und deren exaktem, maschinell
findbarem Beleg (bei PDF mit reeller Seite; bei vorbereiteter HTML-Quelle mit
`page: null`), oder entferne ausschließlich diesen redundanten Beleg, falls
die Regel bereits vollständig mit gültigen Belegen verknüpft ist. Führe danach
Grounding- und technische Validierung aus und ändere nichts außerhalb des
Run-Workspace.
