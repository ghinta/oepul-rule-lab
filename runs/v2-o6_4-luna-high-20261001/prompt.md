# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_4`

Modus: `discover`
Run-ID: `v2-o6_4-luna-high-20261001`

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
- sources/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf (seitenmarkierter Text: sources/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_4` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v2-o6_4-luna-high-20261001`;
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

Der erste Entwurf ist erzeugt, aber nicht finalisierbar. Arbeite nur im
Run-Workspace weiter, lies die Verträge und das Canonical Farm Profile erneut,
repariere alle vorhandenen Artefakte und prüfe technisch vor Abschluss.

1. Entferne oder korrekt verknüpfe die unbenutzten Quellenbelege
`C-ANNEX-GG`, `C-GENERAL-COMBINATION`, `C-GENERAL-EXIT`,
`C-NOTICE-BIODIV`, `C-NOTICE-DROUGHT-AUG12`, `C-NOTICE-DROUGHT-ERNT` und
`C-NOTICE-REBzikade`. Entferne keine fachlichen Regeln zur bloßen
Fehlervermeidung.
2. Überarbeite `profile_changes.json` ohne überlappende Eltern-/Kindpfade:
Der Vorschlag für `land.parcels[].measure` überlappt das Kind
`land.parcels[].measure.o6_4.code`; konsolidiere diese Angaben zu zulässigen
nicht überlappenden Blattänderungen bzw. repräsentativen Objekt-Arrays.
3. Sorge dafür, dass alle von Regeln und Rego genutzten Werte nach Anwendung
des vorgeschlagenen Profils existieren. Insbesondere: Zugangs-/Flächenwerte
`access_year`, `added_area_ha`, `base_2025_area_ha`, `previous_measure_area_ha`
und `reduction_ha`; Vertrags-/Antrags-/Wechselwerte `contract_start_year`,
`measure_application_date`, `measure_change_date`, `target_measure`; Maßnahme
und Jahr `code`, `year`, `total_area_ha`; allgemeine Betriebs-/Flächenwerte
`farm.first_oepul_year`, `land.eligible_agricultural_area_ha`,
`land.protected_area_ha`, `compliance.violations[]`; sowie die genannten
Parcel-Unterfelder `measure_participation`, `measure.other_measures`,
`active_agricultural_management`, `code`,
`correctly_identified_for_measure` und `operations.mulching`. Richte Regeln,
Rego und Tests auf eine konsistente Canonical-Profile-Struktur aus. Keine
Arraycontainer-Targets; Arrays als repräsentative Objekt-Arrays.
4. Korrigiere im Data Inventory die Zeilenzahl für
`workspace/data/o6_4_reference.json` am Pointer
`/o6_4/premiums_eur_per_ha` auf die vom Validator ermittelte Anzahl 24.
5. Das Canonical Farm Profile bleibt unverändert. Beende erst bei fehlerfreier
Grounding- und technischer Validierung.

## Verbindliche Korrekturstrategie (Attempt 3)

Der vorige Reparaturversuch hat keine Artefakte geändert. Beginne diesmal
sofort mit den folgenden konkreten Dateiänderungen und führe erst danach die
lokale technische Prüfung aus; gib keine vollständigen Dokumente oder Schemas
aus.

1. Öffne `rules/citations.json` und entferne ausschließlich die sieben
unbenutzten Referenzen `C-ANNEX-GG`, `C-GENERAL-COMBINATION`,
`C-GENERAL-EXIT`, `C-NOTICE-BIODIV`, `C-NOTICE-DROUGHT-AUG12`,
`C-NOTICE-DROUGHT-ERNT`, `C-NOTICE-REBzikade`. Ihre Aussagen bleiben nicht
als unreferenzierte Quelle bestehen; Regeln und belegte Daten bleiben erhalten.
2. Konsolidiere die Profileingaben. Das System darf nicht gleichzeitig
`land.parcels[].measure` und dessen Kind
`land.parcels[].measure.o6_4.code` ändern. Nutze eine eindeutige Struktur,
beispielsweise ein einziges `farm.o6_4`-Objekt für maßnahmeweite Werte
(Code, Jahr, Vertrag, Antrag, Wechsel, Zugang, Flächenänderung und
Compliance) und einzelne nichtüberlappende Parcel-Blätter. Passe ALLE
Regelbedingungen und Rego-Zugriffe von den bisherigen freien Rootpfaden
(`access_year`, `code`, `contract_start_year`, `year` usw.) auf diese
proposed-profile-Struktur an. Nutze die vorhandenen Canonical-Pfade wie
`land.total_area_ha`, `farm.year`, `land.parcels[]` oder klar ergänzte
`farm.o6_4.*`; erfinde keine unproposed Rootfelder.
3. Für neue Listeigenschaften ist der Change-Pfad der Feldname ohne ein
abschließendes `[]`, und `value_after` ist ein echtes JSON-Array mit
repräsentativem Objekt. Damit müssen insbesondere die Regelpfade für
`measure_participation`, `other_measures`, `operations.mulching`,
aktive Bewirtschaftung, korrekte Kennzeichnung und Compliance im
vorgeschlagenen Profil auflösbar sein. Aktualisiere auch Tests auf dieselbe
Struktur.
4. Öffne `rules/data_inventory.json` und setze die `row_count` für
`workspace/data/o6_4_reference.json` am Pointer
`/o6_4/premiums_eur_per_ha` exakt auf `24`.
5. Behalte jede fachliche Regel und ändere nie das Canonical Farm Profile.
Verifiziere vor Ende, dass `profile_changes` keine Eltern-/Kindüberlappung
enthält und dass Rego nur vorgeschlagene Profilpfade verwendet.

## Arrayblatt-Reparatur (Attempt 4)

Die dritte Fassung hat alle anderen Grounding-Fehler behoben. Es bleiben nur
Arraycontainer und dazugehörige Profilpfade. Repariere direkt in
`rules/profile_changes.json`, `rules/rules.json`, Rego und Tests:

1. Kein Profile-Change-Pfad darf mit `[]` enden. Ersetze die Änderungen für
`compliance.violations[]`, `land.parcels[].measure.other_measures[]`,
`land.parcels[].measure_participation[]`,
`land.parcels[].operations.fertilizer_applications[]`,
`land.parcels[].operations.grazing_periods[]`,
`land.parcels[].operations.mowing_years[]` und
`land.parcels[].operations.plant_protection_applications[]` durch zulässige
Blattpfade ohne abschließendes `[]`; ihr `value_after` muss jeweils ein echtes
JSON-Array mit repräsentativem Objekt sein.
2. Richte die Regel- und Rego-Pfade exakt auf diese Blattnamen aus. Einheitlich
gelten `land.parcels[].operations.mowing_years`,
`land.parcels[].operations.fertilizer_applications`,
`land.parcels[].operations.grazing_periods` und
`land.parcels[].operations.plant_protection_applications` als die
Arrayfelder; verwende keine widersprüchlichen Endungen. Verwende den in
Regeln erwarteten nichtverschachtelten Feldnamen
`land.parcels[].other_measures` oder passe Regel und Profil gleichzeitig auf
eine einzige nichtüberlappende Struktur an.
3. Vervollständige innerhalb des maßnahmeweiten Vorschlags
`farm.o6_4.compliance` die beiden Blätter
`conditionality_compliant` und `violations`, sodass
`farm.o6_4.compliance.conditionality_compliant` und
`farm.o6_4.compliance.violations` nach Anwendung vorhanden sind.
4. Erhalte alle fachlichen Regeln und führe danach die lokale OPA-Validierung
aus. Ziel ist ein leerer Grounding-Fehlerbericht.
