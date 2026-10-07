# o6_4: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_4-luna-high-20261001`

20 Vorschläge; Blattpfade: {'added': 43, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.first_oepul_year` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.o6_4.access_year` | added | nicht vorhanden | `2026` | nicht deklariert | nein |
| `farm.o6_4.added_area_ha` | added | nicht vorhanden | `4` | nicht deklariert | nein |
| `farm.o6_4.base_2025_area_ha` | added | nicht vorhanden | `8` | nicht deklariert | nein |
| `farm.o6_4.code` | added | nicht vorhanden | `"BM0"` | nicht deklariert | nein |
| `farm.o6_4.compliance.conditionality_compliant` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `farm.o6_4.compliance.violations[].code` | added | nicht vorhanden | `"none"` | nicht deklariert | nein |
| `farm.o6_4.compliance.violations[].detected` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.o6_4.contract_start_year` | added | nicht vorhanden | `2025` | nicht deklariert | nein |
| `farm.o6_4.measure_application_date` | added | nicht vorhanden | `"2024-12-31"` | nicht deklariert | nein |
| `farm.o6_4.measure_change_date` | added | nicht vorhanden | `"2025-12-31"` | nicht deklariert | nein |
| `farm.o6_4.previous_measure_area_ha` | added | nicht vorhanden | `8` | nicht deklariert | nein |
| `farm.o6_4.reduction_ha` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `farm.o6_4.target_measure` | added | nicht vorhanden | `"o6_18"` | nicht deklariert | nein |
| `farm.o6_4.year` | added | nicht vorhanden | `2026` | nicht deklariert | nein |
| `land.eligible_agricultural_area_ha` | added | nicht vorhanden | `1.5` | nicht deklariert | nein |
| `land.home_farm_elevation_m` | added | nicht vorhanden | `900` | nicht deklariert | nein |
| `land.parcels[].above_local_settlement_boundary` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].active_agricultural_management` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].code` | added | nicht vorhanden | `"BM0"` | nicht deklariert | nein |
| `land.parcels[].correctly_identified_for_measure` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].difficult_to_manage` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].elevation_above_1200_area_ha` | added | nicht vorhanden | `1.1` | nicht deklariert | nein |
| `land.parcels[].elevation_m` | added | nicht vorhanden | `1250` | nicht deklariert | nein |
| `land.parcels[].is_alpine_farm_exception` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].measure_participation[].measure` | added | nicht vorhanden | `"o6_4"` | nicht deklariert | nein |
| `land.parcels[].measure_participation[].participating` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer_applications[].material` | added | nicht vorhanden | `"solid_manure"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer_applications[].needs_based` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer_applications[].original_form` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].operations.grazing_periods[].end_date` | added | nicht vorhanden | `"2026-10-31"` | nicht deklariert | nein |
| `land.parcels[].operations.grazing_periods[].grazing_type` | added | nicht vorhanden | `"aftermath"` | nicht deklariert | nein |
| `land.parcels[].operations.grazing_periods[].start_date` | added | nicht vorhanden | `"2026-08-16"` | nicht deklariert | nein |
| `land.parcels[].operations.mowing_years[].full_area` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].operations.mowing_years[].method` | added | nicht vorhanden | `"motor_mower"` | nicht deklariert | nein |
| `land.parcels[].operations.mowing_years[].mowed_material_removed` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].operations.mowing_years[].year` | added | nicht vorhanden | `2026` | nicht deklariert | nein |
| `land.parcels[].operations.mulching` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].operations.plant_protection_applications[].bio_regulation_2018_848_allowed` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].operations.plant_protection_applications[].product` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].other_measures[].component` | added | nicht vorhanden | `"landscape_element_compensation"` | nicht deklariert | nein |
| `land.parcels[].other_measures[].measure_code` | added | nicht vorhanden | `"o6_1a_landscape_element_compensation"` | nicht deklariert | nein |
| `land.protected_area_ha` | added | nicht vorhanden | `0.5` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_4-luna-high-20261001/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_4-luna-high-20261001/workspace/rules/citations.json).

## opus: `v2-o6_4-opus-5.5-high-20260925`

21 Vorschläge; Blattpfade: {'added': 46, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.oepul_participation.applicant_type` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_person&#124;association&#124;public_body)"` | nicht deklariert | nein |
| `farm.oepul_participation.first_oepul_participation_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul_participation.home_farm_altitude_m` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul_participation.is_active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul_participation.is_alpine_farm_operation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul_participation.manages_in_own_name_and_account` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul_participation.measures[].contract_start_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul_participation.measures[].enrolled_area_2025_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul_participation.measures[].enrolled_area_current_year_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul_participation.measures[].enrolled_area_previous_year_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul_participation.measures[].exit_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul_participation.measures[].exit_reason` | added | nicht vorhanden | `"enum(measure_switch_to_higher_value&#124;loss_of_control_over_area&#124;force_majeure_or_permanent_circumstances&#124;revision_clause_refusal&#124;other)&#124;null"` | nicht deklariert | nein |
| `farm.oepul_participation.measures[].full_reductions_100pct_count` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.oepul_participation.measures[].measure_application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul_participation.measures[].measure_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.oepul_participation.measures[].reduction_exempt_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul_participation.measures[].switch_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul_participation.measures[].switch_target_measure` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `farm.oepul_participation.measures[].takeover_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul_participation.measures[].takeover_expansion_share` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul_participation.protected_cultivation_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul_participation.public_body_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].constraints.in_national_park` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].constraints.national_park_without_relevant_restrictions` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].located_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | ja |
| `land.parcels[].mountain_meadow.above_local_permanent_settlement_limit` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].mountain_meadow.adjacent_to_home_farm_areas` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].mountain_meadow.declared_as_mountain_meadow` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].mountain_meadow.difficult_to_manage` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].mountain_meadow.parcel_altitude_m` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].mountain_meadow.share_above_1200m_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].non_eligible_categories[]` | added | nicht vorhanden | `"enum(short_rotation_coppice_nurseries&#124;not_actively_farmed&#124;other_areas&#124;not_declared_or_misidentified&#124;national_park&#124;not_mainly_agricultural&#124;gloez_landscape_element&#124;scientific_trial_vf)"` | nicht deklariert | nein |
| `land.parcels[].oepul_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul_measure_participation[].measure_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul_measure_participation[].payment_eur_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_measure_participation[].premium_component` | added | nicht vorhanden | `"enum(area&#124;landscape_element)"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer.applied_types[]` | added | nicht vorhanden | `"enum(solid_manure&#124;own_household_wastewater&#124;solid_manure_dissolved_in_water&#124;slurry&#124;liquid_manure&#124;mineral_fertilizer&#124;lime_fertilizer&#124;sewage_sludge&#124;composted_sewage_sludge&#124;compost&#124;digestate&#124;other_fertilizer)"` | nicht deklariert | nein |
| `land.parcels[].operations.grazing_dates[]` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].operations.mowing.full_area` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.mowing.method` | added | nicht vorhanden | `"enum(tractor_or_mowing_tractor&#124;hand_guided_motor_mower&#124;scythe_or_motor_scythe&#124;none)&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.mowing.mowed_previous_year` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.mowing.mown_material_left_lying` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.mowing.mown_material_removed` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.mowing.mulched` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_only_bio_approved_substances` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].transferred_mid_year_without_continuation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_4-opus-5.5-high-20260925/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_4-opus-5.5-high-20260925/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
