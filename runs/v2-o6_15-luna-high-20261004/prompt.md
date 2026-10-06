# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_15`

Modus: `discover`
Run-ID: `v2-o6_15-luna-high-20261004`

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
- sources/o6_15_tierwohl-behirtung_2026_04.pdf (seitenmarkierter Text: sources/o6_15_tierwohl-behirtung_2026_04.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_15` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v2-o6_15-luna-high-20261004`;
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
vorbereiteten Workspace, repariere **alle** folgenden Fehler vollständig und
führe danach den lokalen Validator wiederholt aus, bis die Grounding-
Validierung ohne Fehler besteht.

1. `rules/rules.json`: Entferne doppelte Werte in
   `source_reference_ids` der Regeln 5 und 11. Stelle sicher, dass sämtliche
   IDs in `coverage.json` und `profile_changes.json` exakt auf gültige,
   eindeutige Rule-IDs aus dem finalen Regelkatalog zeigen; beseitige auch die
   dadurch derzeit als unbenutzt erkannten Quellenbelege.
2. `rules/citations.json`: Korrigiere `CIT-GEN-P22-REENTRY`, denn Seite 22
   liegt außerhalb der extrahierten Seiten des referenzierten PDFs. Korrigiere
   außerdem `CIT-O615-P2-ANIMALS`, dessen Belegtext auf der angegebenen PDF-
   Seite nicht auffindbar ist. Verwende jeweils korrekte Seite und einen
   maschinell auffindbaren kurzen wörtlichen Beleg; passe verknüpfte Regeln
   und Coverage-Einträge nötigenfalls an.
3. `rules/coverage.json`: Der Scope `srl-general-modulation` darf nicht über
   die tatsächlich geprüften Seiten hinausreichen. Korrigiere `pages_reviewed`
   oder die abgedeckten Stellen konsistent.
4. `data/` und `rules/data_inventory.json`: Es fehlt
   `data/rgve_key.json`, obwohl es inventarisiert beziehungsweise von Rego
   erwartet wird. Erzeuge diese Daten aus der Quelle vollständig oder entferne
   die unzulässige Referenz konsistent aus Policy und Inventar. In jedem Fall
   müssen alle Inventarpfade exakt `workspace/data/...` verwenden und genau
   den vorhandenen Datendateien entsprechen.
5. `rules/profile_changes.json` und Policy: Keine Änderung darf auf einem
   Array-Container enden. Ersetze `land.alms[]`,
   `land.alms[].herders[]`, `participation.measures[]` und
   `participation.o6_15_reports[]` durch konkrete zulässige Blattpfade mit
   repräsentativen Objektwerten gemäß Contract und Canonical Farm Profile.
   Entferne überlappende Container-Änderungen. Alle in Rego verwendeten
   `input.*`-Pfade müssen entweder im Canonical Farm Profile vorhanden sein
   oder als zulässige Blattpfade vorgeschlagen werden. Verwende dessen echte
   Struktur statt paralleler Top-Level-Pfade wie `input.animals`,
   `input.herd_protection_dog`, `input.reports` usw.; passe Rego, Regeln und
   Profile-Vorschläge einheitlich an.
6. Führe mindestens
   `python3 tools/opa_validate.py validate --workspace . --target policy --target data --target tests --write --result-json technical-validation.json --pretty`
   aus. Kontrolliere anschließend die fünf JSON-Artefakte gegen die Verträge
   und lasse keine bekannten Validierungsfehler zurück.

## Zweiter verbindlicher Reparaturauftrag

Die vorige Reparatur hat noch nicht bestanden. Nimm folgende konkrete
Korrekturen vor und prüfe danach erneut mit dem Validator:

1. In `profile_changes.json` haben die Add-Änderungen an den Indizes 29 und
   32 (`land.parcels[].op_code`, `documentation.sanction_finding`) ein
   unzulässiges `value_after: null`. Bei `action: "add"` darf ausschließlich
   ein **nicht-null** `value_after` stehen. Verwende einen Repräsentativwert
   in der tatsächlichen Typnotation des Canonical Profiles und kein
   `value_before`.
2. Beseitige nicht nur Array-Container, sondern auch alle Objekt-Container als
   Profile-Vorschlag. Die vorhandenen Vorschläge für
   `farm.o6_15_exit`, `farm.o6_15_drought`, `land.parcels[].care`,
   `livestock.species_groups[].report` und
   `livestock.herd_protection_dog` reichen nicht: ersetze sie durch konkrete
   Blattpfade für **jeden** tatsächlich im Rego verwendeten Unterpfad, etwa
   `farm.o6_15_exit.requested`,
   `farm.o6_15_exit.exit_effective_date`,
   `farm.o6_15_drought.drought_prevented_obligation`,
   `land.parcels[].care.daily_care` sowie die einzelnen Hund- und Report-
   Attribute. Überlappende übergeordnete Änderungen entfernen.
3. Die Grounding-Prüfung listet alle noch fehlenden Pfade auf (u. a.
   `farm.participates_almbewirtschaftung`, Felder der Parcel-,
   Species-Group-, Documentation- und Herd-Protection-Dog-Strukturen).
   Ergänze jeden davon als zulässigen Blattpfad oder ändere die betroffene
   Rego-Regel konsistent auf eine bereits gültige Profile-Struktur. Es darf
   am Ende kein einziger fehlender `input.*`- oder Regel-Eingabepfad bleiben.
4. Wiederhole `verify-grounding` gedanklich anhand des bereitgestellten
   Validators: Erfolg beim OPA-Validator allein genügt nicht. Korrigiere
   iterativ alle Contract- und Profile-Application-Fehler vor Abschluss.
