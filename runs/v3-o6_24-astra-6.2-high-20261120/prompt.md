# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_24`

Modus: `discover`
Run-ID: `v3-o6_24-astra-6.2-high-20261120`

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
   Schema exakt ein. Verwende als `run_id` exakt `v3-o6_24-astra-6.2-high-20261120`;
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


## Separater Korrekturversuch mit Validatorfeedback
Prüfe die folgenden Befunde im vorhandenen Workspace. Erhalte belegte Inhalte und korrigiere die Rückweisungsgründe anhand der Quellen und Daten.

Die deterministische Rule-Lab-Finalisierung (`finalize`) hat den bisherigen Stand abgelehnt. Behebe alle folgenden Fehler, ohne die Anforderungen aus `AGENTS.md` und den Schemas aufzuweichen:

- [data] row_count mismatch for workspace/data/wrrl.json/wrrl_tables/combination_matrix: expected 21, got 441
- [profile_application] overlapping profile changes are not allowed: farm.applicant, farm.applicant.equivalent_or_indirect_public_control
- [profile_application] overlapping profile changes are not allowed: farm.payment, farm.payment.parcel_contributions
- [profile_application] overlapping profile changes are not allowed: farm.wrrl, farm.wrrl.control_cutoffs
- [profile_application] overlapping profile changes are not allowed: farm.wrrl, farm.wrrl.control_objection
- [profile_application] overlapping profile changes are not allowed: farm.wrrl, farm.wrrl.impossible_combination_found
- [profile_application] overlapping profile changes are not allowed: farm.wrrl, farm.wrrl.payout_notice_received
- [profile_application] overlapping profile changes are not allowed: farm.wrrl, farm.wrrl.proposed_exit_date
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.ag
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.annual_effective_n_kg_ha
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.baw
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.class_limits
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.crop_sensitive_to_heat_and_drought
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.district
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.full_grazing
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.full_mow_and_remove
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.harvest_duty_unmet
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.harvest_force_majeure_approved
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.harvested_and_removed_pct
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.higher_class_separate_application
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.incident
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.intercrop_variant_established
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.is_arable_forage
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.maintained_annually
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.n_applications
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.national_park
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.no_harvestable_crop_due_to_drought
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.other_measures
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.protected_pot_or_substrate
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.section5_record
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.segments
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.sown_properly
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.state
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.subplots_claimed_separately
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.subplots_recorded_separately
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.transfer
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.trial
- [profile_application] overlapping profile changes are not allowed: land.parcels[].wrrl, land.parcels[].wrrl.usual_late_summer_or_autumn_harvest
- [profile_application] Rego uses paths absent from proposed profile: ['input.farm.applicant.eur_ha', 'input.farm.applicant.measure']
