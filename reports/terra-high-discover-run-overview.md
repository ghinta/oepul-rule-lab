# Terra/high Discover-Runs: Gesamtübersicht

Stand: 30. September 2026 · Auswertung von `origin/main` bei
`0c788047ef032d201aff7ebdd0e07d1993fb052c`

## Kurzfazit

Alle 26 O6-Maßnahmen wurden mit `gpt-5.6-terra` und Reasoning-Stufe `high`
als Discover-Run finalisiert. Die Runs verwenden nicht pauschal einen alten
Quellenstand: Jeder eingefrorene Run enthält die allgemeinen
Teilnahmebedingungen von April 2026 sowie die vier versionierten amtlichen
Bekanntmachungen von Mai bis August 2026. Die maßnahmenspezifischen
Informationsblätter sind dagegen versionsgetreu gemischt: zehn sind aus 2026
(neun April, eines Juni), sechzehn sind weiterhin die im Quellenpaket
enthaltenen Ausgaben von Oktober 2025.

Die Runs haben **104 Vorschläge für Profiländerungen** geliefert (99 verschiedene
Pfadnamen), aber **keine Änderung am Canonical Farm Profile vorgenommen**. Alle
Vorschläge liegen ausschließlich in den jeweiligen Discover-Artefakten vor und
müssen vor einer Übernahme fachlich harmonisiert und entschieden werden.

## Quellenstand

Für jeden Run wurde die vollständige Quellenliste mit Dateiname und Prüfsumme
in dessen `run.json` eingefroren. Gemeinsame Quellen aller 26 Runs:

- `o6_allgemeine_teilnahmebedingungen_2026_04.pdf`
- `2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html`
- `2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html`
- `2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html`
- `2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html`

Die Einordnung „2025_10“ bedeutet hier nicht, dass eine veraltete Quelle gegen
eine spätere Fassung ausgetauscht wurde. Es ist der aktuell versionierte,
amtliche Stand des jeweiligen Maßnahmenblatts im lokalen Quellenpaket. Die
2026-Bekanntmachungen und die allgemeinen Teilnahmebedingungen ergänzen ihn.

| Stand des Maßnahmenblatts | Maßnahmen |
| --- | --- |
| `2026_04` | `o6_1a`, `o6_1b`, `o6_2`, `o6_8`, `o6_11`, `o6_12`, `o6_14`, `o6_15`, `o6_16` |
| `2026_06` | `o6_9` |
| `2025_10` | `o6_1c`, `o6_3`, `o6_4`, `o6_5`, `o6_6`, `o6_7`, `o6_10`, `o6_13`, `o6_17`, `o6_18`, `o6_19`, `o6_20`, `o6_21`, `o6_22`, `o6_23`, `o6_24` |

## Ergebnis und Gates

| Kennzahl | Ergebnis |
| --- | ---: |
| Finalisierte Terra/high-Runs | 26 |
| Strukturierte Regeln | 731 |
| Quellenreferenzen | 682 |
| Coverage-Einträge | 933 |
| Generierte Rego-Tests | 119 |
| Datentabellen in den Artefakten | 81 |
| Vorschläge für Profilfelder | 104 |
| Unterschiedliche vorgeschlagene Pfade | 99 |
| Additive Pfade in den einzelnen Profil-Diffs | 1.024 |

Alle 26 Runs sind finalisiert; `verify-grounding` ist jeweils gültig, die
technische Validierung endete jeweils mit Code 0, die Vertragsfehlerlisten und
Listen fehlender Artefakte sind leer und die Artefakt-Inventare wurden erzeugt.
In jedem Run ist `working_profile_unchanged: true`.

`conform_profile_unchanged` ist bei Discover-Runs erwartungsgemäß `false`: Es
wird bereits dann `false`, wenn der Run einen Profilvorschlag enthält. Das ist
kein Schreibvorgang am Canonical Farm Profile und kein fehlgeschlagenes Gate.

## Was die Modelle vorgeschlagen haben

Die Vorschläge sind **Datenerhebungs- und Modellierungsbedarfe**, keine bereits
übernommenen Änderungen. Wiederkehrende Gruppen sind:

- Antrags-, Teilnahme- und Anspruchsdaten, etwa `farm.applications`,
  `farm.applicant_eligibility`, `farm.first_oepul_participation_year` und
  `farm.measure_takeover`.
- Schlag- und bewirtschaftungsbezogene Angaben, etwa
  `land.parcels[].erosion_protection`, `land.parcels[].natura2000`,
  `land.parcels[].mountain_meadow` und maßnahmenspezifische `land.parcels[]`
  Blöcke.
- Tier-, Rassen- und Haltungsdaten wie `livestock.breeding_animals`,
  `participation` und `compost_supplement`.
- Nachweise, Ausnahmeereignisse und Dokumentation, zum Beispiel
  `documentation.o6_24`, `o6_7.drought_2026` und
  `farm.rebzikade_exit_application`.
- Eigene O6-Namespace-Blöcke, wenn eine Maßnahme ein umfangreicheres,
  fachlich zusammenhängendes Datenset braucht, etwa `o6_6`, `o6_9`, `o6_18`
  oder `farm.o6_24`.

Die Summe von 1.024 additiven Pfaden ist die Summe der einzelnen Run-Diffs und
nicht die Größe eines fertig konsolidierten globalen Schemas. Mehrere Runs
schlagen ähnlich gelagerte Felder unter unterschiedlichen Namen oder
Namespaces vor. Vor einer möglichen Übernahme braucht es daher eine
fachlich-technische Konsolidierung (Begriffe, Eigentümer, Typen,
Erhebungszeitpunkt und Datenschutz) sowie eine Produktentscheidung. Die
Recommender-Runtime und das Canonical Farm Profile wurden im Rahmen dieser
Runs nicht verändert.

## Pro Maßnahme

Die Links führen zu den vollständig prüfbaren Artefakten des jeweiligen Runs.
`Regeln/Ref.` steht für strukturierte Regeln und Quellenreferenzen;
`Coverage/Tests` für Coverage-Einträge und generierte Tests.

| Maßnahme | Eingefrorenes Maßnahmenblatt | Regeln/Ref. | Coverage/Tests | Profilvorschläge |
| --- | --- | ---: | ---: | --- |
| `o6_1a` | `o6_1a_ubb_2026_04.pdf` | 38 / 44 | 34 / 8 | 1: `ubb` ([Artefakte](../runs/v2-o6_1a-terra-20260920/artifacts/metrics.json)) |
| `o6_1b` | `o6_1b_biologische_wirtschaftsweise_2026_04.pdf` | 36 / 40 | 38 / 4 | 11: `oepul.mown_grassland_ha`, `oepul.fodder_area_ha`, `oepul.rgve_total`, `oepul.cereal_maize_ha`, `oepul.crop_shares`, `oepul.arable_biodiversity_credit_ha`, `oepul.grassland_biodiversity_credit_ha`, `oepul.biodiversity_parcels`, `oepul.wild_herb_parcels`, `oepul.pheromone_parcels`, `oepul.education` ([Vorschläge](../runs/v2-o6_1b-terra-20260925/workspace/rules/profile_changes.json)) |
| `o6_1c` | `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf` | 32 / 14 | 22 / 4 | 3: `land.parcels[].o6_1c`, `farm.o6_1c_application`, `o6_1c` ([Vorschläge](../runs/v2-o6_1c-terra-20260926/workspace/rules/profile_changes.json)) |
| `o6_2` | `o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf` | 29 / 25 | 41 / 3 | 3: `o6_2`, `land.parcels[].o6_2`, `farm.o6_2` ([Vorschläge](../runs/v2-o6_2-terra-20260921/workspace/rules/profile_changes.json)) |
| `o6_3` | `o6_3_heuwirtschaft_2025_10.pdf` | 31 / 41 | 46 / 5 | 6: `heuwirtschaft`, `land.parcels[].heuwirtschaft_use`, `land.parcels[].heuwirtschaft_second_crop`, `land.parcels[].measure_history`, `farm.applications`, `land.parcels[].funding_constraints` ([Vorschläge](../runs/v2-o6_3-terra-high-20260925/workspace/rules/profile_changes.json)) |
| `o6_4` | `o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf` | 20 / 31 | 26 / 3 | 8: `land.parcels[].country`, `land.parcels[].mountain_meadow`, `farm.operator_type`, `farm.is_active_farmer`, `farm.operates_on_own_account`, `oepul.participations`, `oepul.first_participation_year`, `oepul.area_related_payment_sum_eur_per_ha` ([Vorschläge](../runs/v2-o6_4-terra-high-20260925/workspace/rules/profile_changes.json)) |
| `o6_5` | `o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf` | 26 / 17 | 30 / 3 | 5: `livestock.breeding_animals`, `farm.measure_takeover`, `farm.beneficiary_conditions_met`, `farm.first_oepul_participation_year`, `documentation.conditionality_compliant` ([Vorschläge](../runs/v2-o6_5-terra-20260926/workspace/rules/profile_changes.json)) |
| `o6_6` | `o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf` | 32 / 25 | 32 / 3 | 1: `o6_6` ([Vorschläge](../runs/v2-o6_6-terra-20260926/workspace/rules/profile_changes.json)) |
| `o6_7` | `o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf` | 34 / 20 | 31 / 4 | 10: `o6_7.minimum_green_cover_percent`, `o6_7.gaps`, `o6_7.intercrops`, `o6_7.field_records`, `o6_7.application`, `o6_7.selected_measures`, `o6_7.exit`, `o6_7.nature_area_self_cover_events`, `o6_7.late_area_accessions`, `o6_7.drought_2026` ([Vorschläge](../runs/v2-o6_7-terra-20260926/workspace/rules/profile_changes.json)) |
| `o6_8` | `o6_8_erosionsschutz_acker_2026_04.pdf` | 26 / 24 | 32 / 6 | 2: `farm.oepul`, `land.parcels[].erosion_protection` ([Vorschläge](../runs/v2-o6_8-terra-high-retry-20260924/workspace/rules/profile_changes.json)) |
| `o6_9` | `o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf` | 25 / 19 | 53 / 4 | 1: `o6_9` ([Vorschläge](../runs/v2-o6_9-terra-high-20260925/workspace/rules/profile_changes.json)) |
| `o6_10` | `o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf` | 31 / 27 | 38 / 5 | 2: `o6_10`, `land.parcels[].o6_10` ([Vorschläge](../runs/v2-o6_10-terra-20260927/workspace/rules/profile_changes.json)) |
| `o6_11` | `o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf` | 23 / 19 | 39 / 2 | 5: `farm.oepul_participation`, `o6_11`, `land.parcels[].o6_11`, `land.parcels[].operations.plant_protection_applications`, `land.parcels[].land_use_name` ([Vorschläge](../runs/v2-o6_11-terra-20260927/workspace/rules/profile_changes.json)) |
| `o6_12` | `o6_12_insektizidverzicht_wein_obst_hopfen_2026_04.pdf` | 34 / 40 | 44 / 5 | 10: `farm.participations`, `farm.organic_whole_farm`, `farm.organic_partial_scope`, `farm.erosionschutz_organism_supplement`, `land.parcels[].country`, `land.parcels[].crop.is_grafted`, `land.parcels[].o6_12_nonpremium`, `land.parcels[].operations.insecticide_applications`, `insecticide_inventory`, `farm.rebzikade_exit_application` ([Vorschläge](../runs/v2-o6_12-terra-20260928/workspace/rules/profile_changes.json)) |
| `o6_13` | `o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf` | 26 / 26 | 39 / 4 | 7: `farm.first_oepul_participation_year`, `farm.applicant_eligibility`, `o6_13`, `land.parcels[].operations.proper_establishment`, `land.parcels[].operations.harvested_share`, `farm.region.national_park_name`, `farm.o6_13_drought_2026` ([Vorschläge](../runs/v2-o6_13-terra-20260928/workspace/rules/profile_changes.json)) |
| `o6_14` | `o6_14_almbewirtschaftung_2026_04.pdf` | 30 / 22 | 28 / 3 | 3: `applicant`, `alpine_pastures`, `applications` ([Vorschläge](../runs/v2-o6_14-terra-20260928/workspace/rules/profile_changes.json)) |
| `o6_15` | `o6_15_tierwohl-behirtung_2026_04.pdf` | 25 / 24 | 23 / 5 | 2: `farm.o6_15`, `farm.applicant_eligibility` ([Vorschläge](../runs/v2-o6_15-terra-20260928/workspace/rules/profile_changes.json)) |
| `o6_16` | `o6_16_vorbeugender_grundwasserschutz_acker_2026_04.pdf` | 34 / 30 | 40 / 9 | 1: `oepul.o6_16` ([Vorschläge](../runs/v2-o6_16-terra-20260919/workspace/rules/profile_changes.json)) |
| `o6_17` | `o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf` | 28 / 31 | 46 / 4 | 3: `o6_17`, `farm.applicant`, `land.parcels[].oepul_code` ([Vorschläge](../runs/v2-o6_17-terra-high-20260925/workspace/rules/profile_changes.json)) |
| `o6_18` | `o6_18_naturschutz_2025_10.pdf` | 25 / 19 | 23 / 7 | 1: `o6_18` ([Vorschläge](../runs/v2-o6_18-terra-retry-20260929/workspace/rules/profile_changes.json)) |
| `o6_19` | `o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf` | 30 / 31 | 52 / 5 | 4: `oepul.o6_19`, `oepul.claimant`, `oepul.protected_cultivation_area_ha`, `oepul.qualifying_agricultural_area_ha` ([Vorschläge](../runs/v2-o6_19-terra-20260929/workspace/rules/profile_changes.json)) |
| `o6_20` | `o6_20_tierwohl_weide_2025_10.pdf` | 32 / 23 | 20 / 4 | 1: `o6_20` ([Vorschläge](../runs/v2-o6_20-terra-20260929/workspace/rules/profile_changes.json)) |
| `o6_21` | `o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf` | 17 / 18 | 24 / 4 | 3: `participation`, `compost_supplement`, `payment` ([Vorschläge](../runs/v2-o6_21-terra-20260929/workspace/rules/profile_changes.json)) |
| `o6_22` | `o6_22_tierwohl-schweinehaltung_2025_10.pdf` | 24 / 22 | 61 / 4 | 1: `oepul_o6_22` ([Vorschläge](../runs/v2-o6_22-terra-20260929/workspace/rules/profile_changes.json)) |
| `o6_23` | `o6_23_natura2000-landwirtschaft_2025_10.pdf` | 22 / 25 | 27 / 7 | 7: `farm.applicant`, `application`, `land.protected_cultivation_area_ha`, `land.parcels[].country`, `land.parcels[].is_national_park`, `land.parcels[].op_code`, `land.parcels[].natura2000` ([Vorschläge](../runs/20260930T002730Z__o6_23__gpt-5.6-terra/workspace/rules/profile_changes.json)) |
| `o6_24` | `o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf` | 21 / 25 | 44 / 4 | 3: `farm.o6_24`, `land.parcels[].o6_24`, `documentation.o6_24` ([Vorschläge](../runs/20260930T004645Z__o6_24__gpt-5.6-terra/workspace/rules/profile_changes.json)) |

## Vollständigkeit

Abgedeckt sind `o6_1a`, `o6_1b`, `o6_1c` und `o6_2` bis `o6_24` — jeweils
mit einem finalisierten Discover-Run für `gpt-5.6-terra` auf `high`.
