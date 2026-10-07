# o6_17: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_17-luna-high-20261005`

50 Vorschläge; Blattpfade: {'added': 54, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `land.parcels[].o6_17.agl_code` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].o6_17.first_use` | added | nicht vorhanden | `"enum(mowing&#124;other)"` | nicht deklariert | nein |
| `land.parcels[].o6_17.gloez2_or_gloez4_or_gloez9` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].o6_17.identified_kennarten[].identification_status` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].o6_17.identified_kennarten[].name` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].o6_17.is_bergmaehder` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].o6_17.is_one_cut_meadow` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].o6_17.observed_kennarten[].name` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].o6_17.record` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].o6_17.section_species_counts[].kennarten_count` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].o6_17.section_species_counts[].section_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].o6_17.sections[].regular_kennarten[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].o6_17.sections[].section_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].o6_17.sketch` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].o6_17.survey_dates[].date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].o6_17.survey_start_distance_m` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].o6_17.transect_sections[].section_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].o6_17.transect_sections[].transect_geometry` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].o6_17.transect_width_m` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].o6_17.usage_code` | added | nicht vorhanden | `"enum(two_mow&#124;three_or_more_mow&#124;one_cut_meadow&#124;litter_meadow)"` | nicht deklariert | nein |
| `livestock.species_groups[].o6_17.age_or_size_category` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `livestock.species_groups[].o6_17.held_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.species_groups[].o6_17.rgve_factor` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `oepul.o6_17.additional_training_hours.biodiversity` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `oepul.o6_17.additional_training_hours.organic_farming` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `oepul.o6_17.application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul.o6_17.area_2025_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `oepul.o6_17.area_access_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `oepul.o6_17.area_reduction_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `oepul.o6_17.average_grassland_score` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `oepul.o6_17.bonus_requested` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_17.combination` | added | nicht vorhanden | `"enum(ubb&#124;bio&#124;bio_part_farm)"` | nicht deklariert | nein |
| `oepul.o6_17.contract_start_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `oepul.o6_17.forage_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `oepul.o6_17.grassland_break_documented` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_17.grassland_break_exception` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `oepul.o6_17.grassland_share_excluding_alpine_percent` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `oepul.o6_17.is_first_participation_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_17.land_transfer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_17.mown_grassland_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `oepul.o6_17.participating` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_17.previous_measure_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `oepul.o6_17.rgve_total` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `oepul.o6_17.slope_percent` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `oepul.o6_17.soil_basis_grassland_under_18_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `oepul.o6_17.soil_method` | added | nicht vorhanden | `"enum(sachgerechte_duengung&#124;EUF)"` | nicht deklariert | nein |
| `oepul.o6_17.soil_parameters[].parameter` | added | nicht vorhanden | `"enum(pH&#124;phosphorus&#124;potassium&#124;humus)"` | nicht deklariert | nein |
| `oepul.o6_17.soil_samples_submitted` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `oepul.o6_17.total_farm_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `oepul.o6_17.training_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul.o6_17.training_event_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `oepul.o6_17.training_hours` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `oepul.o6_17.training_person_departure_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul.o6_17.training_person_role` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_17-luna-high-20261005/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_17-luna-high-20261005/workspace/rules/citations.json).

## opus: `v2-o6_17-opus-5.5-high-20261002`

37 Vorschläge; Blattpfade: {'added': 68, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.applicant.is_active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.legal_form` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_person&#124;association&#124;public_body)"` | nicht deklariert | nein |
| `farm.applicant.public_body_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.first_oepul_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.measures[].is_bio_partial_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.measures[].measure_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.oepul.o6_17.arable_grassland_swap` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_17.area_reduction_loss_of_disposal_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_17.area_reduction_permitted_conversion_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_17.contract_start_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_17.exit_without_repayment_approved` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_17.exit_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_17.full_reductions_in_contract_period` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.oepul.o6_17.measure_application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_17.measure_area_2025_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_17.measure_area_current_year_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_17.measure_area_previous_year_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_17.soil_sample_base_gloez_excluded_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_17.soil_sample_base_mfa2025_grassland_lt18_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_17.soil_samples[].assigned_mfa_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_17.soil_samples[].lab_accredited` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_17.soil_samples[].lab_submission_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `farm.oepul.o6_17.soil_samples[].method` | added | nicht vorhanden | `"enum(sgd&#124;euf)"` | nicht deklariert | nein |
| `farm.oepul.o6_17.soil_samples[].parameters[]` | added | nicht vorhanden | `"enum(ph&#124;p&#124;k&#124;humus)"` | nicht deklariert | nein |
| `farm.oepul.o6_17.soil_samples[].received_with_transferred_area` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_17.soil_samples[].recorded_in_invekos_gis` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_17.soil_samples[].sample_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `farm.oepul.o6_17.takeover.application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_17.takeover.expansion_to_other_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_17.takeover.taken_over_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_17.takeover.taker_previously_participating` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_17.training.confirmation_requested` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_17.training.confirmation_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_17.training.courses[].attendee_left_farm_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_17.training.courses[].attendee_role` | added | nicht vorhanden | `"enum(farm_manager&#124;involved_person)"` | nicht deklariert | nein |
| `farm.oepul.o6_17.training.courses[].course_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `farm.oepul.o6_17.training.courses[].credited_to_other_commitment` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_17.training.courses[].credited_to_other_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_17.training.courses[].hours` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.o6_17.training.courses[].provider_recognized` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_17.training.courses[].topics[]` | added | nicht vorhanden | `"enum(nutzungsverfahren_nutzungshaeufigkeit&#124;duengeplanung_tierbestand&#124;abgestufter_wiesenbau)"` | nicht deklariert | nein |
| `farm.oepul.o6_17.training.transmitted_by_provider` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul.field_use_type` | added | nicht vorhanden | `"enum(maehwiese_weide_zwei_nutzungen&#124;maehwiese_weide_drei_und_mehr_nutzungen&#124;einmaehdige_wiese&#124;streuwiese&#124;bergmaehder&#124;weide&#124;sonstige_gruenlandflaechen&#124;gruenlandbrache&#124;futtergraeser&#124;wechselwiese&#124;kleegras&#124;klee&#124;luzerne&#124;sonstiges_feldfutter&#124;ackerweide&#124;other)"` | nicht deklariert | nein |
| `land.parcels[].oepul.gloez_conversion_ban` | added | nicht vorhanden | `"enum(none&#124;gloez2&#124;gloez4&#124;gloez9)"` | nicht deklariert | nein |
| `land.parcels[].oepul.grassland_breaking_events[].area_m2` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].oepul.grassland_breaking_events[].documentation_kept` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.grassland_breaking_events[].event_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].oepul.grassland_breaking_events[].reason` | added | nicht vorhanden | `"enum(renewal&#124;pest_damage_renovation&#124;div_regional_seed_mixture&#124;vegetable_garden&#124;drainage_renewal&#124;drainage_new&#124;fill_up&#124;levelling&#124;sewer_construction&#124;other)"` | nicht deklariert | nein |
| `land.parcels[].oepul.grassland_breaking_events[].state_permit_obtained` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.grassland_number` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.grazed_fully` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.last_mowing_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul.national_park` | added | nicht vorhanden | `"enum(none&#124;neusiedlersee&#124;donau_auen&#124;kalkalpen&#124;other)"` | nicht deklariert | nein |
| `land.parcels[].oepul.national_park_relevant_restrictions` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.o6_17_op_code` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.other_area_payments_eur_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.renewal_equipment_used[]` | added | nicht vorhanden | `"enum(saatstriegel&#124;schlitzdrillgeraet&#124;walze&#124;wiesenegge&#124;other)"` | nicht deklariert | nein |
| `land.parcels[].oepul.species_rich.first_use_mowing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.species_rich.sketch_documented` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.species_rich.survey_dates[]` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].oepul.species_rich.survey_documented` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.species_rich.survey_sections[].indicator_species[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.species_groups[].kept_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.species_groups[].rgve_category` | added | nicht vorhanden | `"enum(cattle_lt_0_5y&#124;cattle_0_5_to_lt_2y&#124;cattle_ge_2y&#124;dwarf_cattle_lt_0_5y&#124;dwarf_cattle_0_5_to_lt_2y&#124;dwarf_cattle_ge_2y&#124;sheep_ge_1y&#124;sheep_lt_1y&#124;goats_ge_1y&#124;goats_lt_1y&#124;horse_small_foal_lt_0_5y&#124;horse_small_young_0_5_to_lt_3y&#124;horse_small_adult_ge_3y&#124;horse_large_foal_lt_0_5y&#124;horse_large_young_0_5_to_lt_3y&#124;horse_large_adult_ge_3y&#124;red_deer_ge_1y&#124;fallow_deer_other_farmed_game_ge_1y&#124;new_world_camelids_ge_1y&#124;camelids_deer_game_lt_1y&#124;pigs_piglets_ge_8kg&#124;pigs_young_fattening_ge_32kg&#124;pigs_breeding_sows_ge_50kg)"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_17-opus-5.5-high-20261002/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_17-opus-5.5-high-20261002/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
