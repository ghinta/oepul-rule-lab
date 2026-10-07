# o6_1a: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_1a-luna-high-20260930`

81 Vorschläge; Blattpfade: {'added': 91, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `documentation.arable_div_ha` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.arable_fertilizer_used` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.arable_fieldpieces[].area_ha` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.arable_fieldpieces[].div_plus_eligible_ha` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.arable_first_grazing_date` | added | nicht vorhanden | `"YYYY-MM-DD"` | nicht deklariert | nein |
| `documentation.arable_grazing` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.arable_psm_used` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.arable_removal_method` | added | nicht vorhanden | `"mechanical"` | nicht deklariert | nein |
| `documentation.arable_threshing` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.arable_uses_in_two_years` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.arable_uses_this_year` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.cereal_maize_share` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.drought_2026.drought_exception_applies` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.drought_2026.listed_district` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.drought_2026.no_harvestable_stand_due_to_drought` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.drought_2026.relief_code` | added | nicht vorhanden | `"OPUBB"` | nicht deklariert | nein |
| `documentation.drought_2026.third_use` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.grassland_conversion_ha` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.grassland_div_ha` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.grassland_fallow_days` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.grassland_fertilization_during_fallow` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.grassland_fieldpieces[].div_plus_eligible_ha` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.grassland_fieldpieces[].mown_area_ha` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.grassland_second_use` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.grassland_vehicle_entry_during_fallow` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.livestock_status` | added | nicht vorhanden | `"non_livestock"` | nicht deklariert | nein |
| `documentation.max_non_exempt_crop_share` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.monitoring.annual_data_complete` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.monitoring.induction_completed` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.monitoring.naturschutz_codes[].code` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `documentation.monitoring.participation_confirmation` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.pheromone` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.pheromone_days_after_sowing` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.pheromone_emptyings` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.pheromone_field_days` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.pheromone_records_complete` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.pheromone_traps_per_ha` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.regional_grassland_number` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.regional_origin_proven` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.regional_seed` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.regional_seed_max_species_weight_share` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.regional_seed_plant_families` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.regional_seed_rate_kg_per_ha` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.regional_seed_species_count` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.training_completion_date` | added | nicht vorhanden | `"YYYY-MM-DD"` | nicht deklariert | nein |
| `documentation.training_hours` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.training_participants[].course_date` | added | nicht vorhanden | `"YYYY-MM-DD"` | nicht deklariert | nein |
| `documentation.training_participants[].hours` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.training_participants[].person_role` | added | nicht vorhanden | `"farm_manager"` | nicht deklariert | nein |
| `documentation.training_participants[].provider_recognized` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.ubb_application_date` | added | nicht vorhanden | `"YYYY-MM-DD"` | nicht deklariert | nein |
| `documentation.wild_bird_cereal` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.wild_bird_protected_period_compliant` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.wild_bird_row_spacing_cm` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `documentation.wild_bird_undersown` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].biodiversity_area_ha` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].biodiversity_management.bio_psm_only` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].biodiversity_management.fertilizer_used` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].biodiversity_management.first_use_date` | added | nicht vorhanden | `"YYYY-MM-DD"` | nicht deklariert | nein |
| `land.parcels[].biodiversity_management.insect_flowering_partners` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].biodiversity_management.last_use_date` | added | nicht vorhanden | `"YYYY-MM-DD"` | nicht deklariert | nein |
| `land.parcels[].biodiversity_management.non_insect_share` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].biodiversity_management.plant_families` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].biodiversity_management.uses_in_two_years` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].biodiversity_management.uses_this_year` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].biodiversity_management.variant` | added | nicht vorhanden | `"DIVSZ"` | nicht deklariert | nein |
| `land.parcels[].fieldpiece_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].landscape_element.area_m2` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].landscape_element.kind` | added | nicht vorhanden | `"point_or_hedge"` | nicht deklariert | nein |
| `land.parcels[].landscape_element.width_m` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].measure_codes[].code` | added | nicht vorhanden | `"DIV"` | nicht deklariert | nein |
| `land.parcels[].measure_codes[].source_measure` | added | nicht vorhanden | `null` | nicht deklariert | nein |
| `land.parcels[].pheromone_records[].emptying_dates[]` | added | nicht vorhanden | `"YYYY-MM-DD"` | nicht deklariert | nein |
| `land.parcels[].pheromone_records[].installation_date` | added | nicht vorhanden | `"YYYY-MM-DD"` | nicht deklariert | nein |
| `land.parcels[].pheromone_records[].pheromone_purchase_documented` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].pheromone_records[].removal_date` | added | nicht vorhanden | `"YYYY-MM-DD"` | nicht deklariert | nein |
| `land.parcels[].pheromone_records[].traps_per_ha` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].quality_numbers.arable_number` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].quality_numbers.grassland_number` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].rare_variety.first_use_year` | added | nicht vorhanden | `2026` | nicht deklariert | nein |
| `land.parcels[].rare_variety.pure_variety` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].rare_variety.seed_documentation_complete` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].rare_variety.variety` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].seed_mix.max_species_weight_share` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].seed_mix.plant_families` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].seed_mix.regional_origin_proven` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].seed_mix.seed_rate_kg_per_ha` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].seed_mix.species_count` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].wild_bird_conditions.protected_period_compliant` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].wild_bird_conditions.row_spacing_cm` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].wild_bird_conditions.undersown` | added | nicht vorhanden | `false` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_1a-luna-high-20260930/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_1a-luna-high-20260930/workspace/rules/citations.json).

## opus: `v2-o6_1a-opus-5.5-high-20260929`

67 Vorschläge; Blattpfade: {'added': 190, 'removed': 0, 'changed': 1}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.oepul.applicant_type` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_person&#124;association&#124;public_body)"` | nicht deklariert | nein |
| `farm.oepul.bio_teilbetrieb_wein_obst_hopfen` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.first_oepul_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.oepul.land_top_up_steilflaechen_granted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.oepul.protected_cultivation_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.public_body_share` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.ubb.arable_div_invasive_share_percent` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.ubb.area_history.base_2025_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.ubb.area_history.current_year_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.ubb.area_history.increase_previously_committed_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.ubb.area_history.loss_of_control_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.ubb.area_history.permitted_conversion_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.ubb.area_history.previous_year_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.ubb.contract_start_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.oepul.ubb.conversion_to_bio_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.ubb.exit_before_contract_end` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.ubb.exit_reason` | added | nicht vorhanden | `"enum(none&#124;loss_of_control&#124;conversion_to_bio&#124;revision_clause&#124;permanent_circumstances_recognized&#124;other)"` | nicht deklariert | nein |
| `farm.oepul.ubb.full_reductions_in_contract_period` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.oepul.ubb.grassland_conservation.current_grassland_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.ubb.grassland_conservation.first_year_grassland_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.ubb.grassland_conservation.inter_farm_swap_gain_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.ubb.grassland_conservation.ploughed_previous_year_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.ubb.measure_application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.ubb.monitoring[].application_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `farm.oepul.ubb.monitoring[].data_recorded_timely_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.ubb.monitoring[].first_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.oepul.ubb.monitoring[].intro_event_completed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.ubb.monitoring[].participation_confirmation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.ubb.monitoring[].program` | added | nicht vorhanden | `"enum(grosstrappe&#124;biodiversitaetsmonitoring&#124;phaenoflex&#124;schnittzeit_phaenologie)"` | nicht deklariert | nein |
| `farm.oepul.ubb.payment_application_overdue_more_than_one_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.ubb.payment_application_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.ubb.point_landscape_elements[].applied_in_mfa` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.ubb.point_landscape_elements[].area_m2` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.ubb.point_landscape_elements[].coded_so` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.ubb.point_landscape_elements[].crown_diameter_m` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.ubb.point_landscape_elements[].distance_to_agricultural_area_m` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.ubb.point_landscape_elements[].field_piece_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.oepul.ubb.point_landscape_elements[].fruit_species` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `farm.oepul.ubb.point_landscape_elements[].id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.oepul.ubb.point_landscape_elements[].is_gloez` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.ubb.point_landscape_elements[].maintained_full_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.ubb.point_landscape_elements[].min_distance_to_other_m` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.ubb.point_landscape_elements[].on_alm_or_hutweide` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.ubb.point_landscape_elements[].permanent_support_frame_multiple_trees` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.ubb.point_landscape_elements[].streuobst` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.ubb.point_landscape_elements[].strong_growing_large_crown` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.ubb.point_landscape_elements[].tree_form` | added | nicht vorhanden | `"enum(hochstamm&#124;halbstamm&#124;other)&#124;null"` | nicht deklariert | nein |
| `farm.oepul.ubb.point_landscape_elements[].under_control` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.ubb.point_landscape_elements[].wild_form` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.ubb.takeover.additional_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.ubb.takeover.application_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `farm.oepul.ubb.takeover.includes_monitoring` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.ubb.takeover.reason` | added | nicht vorhanden | `"enum(betriebsaufloesung&#124;betriebsteilung&#124;betriebszusammenlegung&#124;other)&#124;null"` | nicht deklariert | nein |
| `farm.oepul.ubb.takeover.taken_over_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.ubb.training.courses[].attendee` | added | nicht vorhanden | `"enum(applicant&#124;involved_person)"` | nicht deklariert | nein |
| `farm.oepul.ubb.training.courses[].attendee_left_before_deadline` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.ubb.training.courses[].biodiversity_relevant` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.ubb.training.courses[].credited_to_other_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.ubb.training.courses[].credited_to_other_obligation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.ubb.training.courses[].date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `farm.oepul.ubb.training.courses[].hours` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.ubb.training.courses[].provider_recognized` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].area_kind` | added | nicht vorhanden | `"enum(agricultural&#124;gloez_landscape_element&#124;mehrnutzenhecke&#124;agroforststreifen)"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.breakup_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.breakup_reason` | added | nicht vorhanden | `"enum(none&#124;loss_of_control&#124;conversion_to_grassland&#124;other)"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.comparable_second_cut_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.consecutive_years_same_location` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.div_care_compliant` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.div_conditions_compliant` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.divrs_continuous_since_sowing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.drought_early_use` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.ebw_habitat_type_eligible` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.establishment_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.exemption_evidence_ok` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.first_declared_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.first_use_completed_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.followed_by_winter_crop_or_catch_crop` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.force_majeure_recognized` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.invasive_species_present` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.loss_of_control` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.nature_area_used` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.phenology_advance_days` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.ploughed_since` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.previous_year_code` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.removal_method` | added | nicht vorhanden | `"enum(mechanical&#124;chemical&#124;none)"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.resown_after_destruction` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.resown_due_to_weeds` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.seed_mixture.documented_labels_invoices` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.seed_mixture.ecotype_seed_used` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.seed_mixture.insect_pollinated_partners` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.seed_mixture.max_single_species_weight_percent` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.seed_mixture.non_insect_pollinated_share_percent` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.seed_mixture.plant_families` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.seed_mixture.regional_list_families` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.seed_mixture.regional_list_species` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.seed_mixture.regional_origin_certified` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.seed_mixture.seed_rate_kg_per_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.sowing_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.sowing_exemption` | added | nicht vorhanden | `"enum(none&#124;existing_fallow_since_2020&#124;oepul2015_div_sown_2021_2022)"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.use_dates_documented` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.used_after_breakup_same_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.used_previous_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.variant_change.date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.variant_change.from` | added | nicht vorhanden | `"enum(DIVSZ&#124;DIVNFZ&#124;DIVAGF&#124;DIVRS)"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.variant_change.to` | added | nicht vorhanden | `"enum(DIVSZ&#124;DIVNFZ&#124;DIVAGF&#124;DIVRS)"` | nicht deklariert | nein |
| `land.parcels[].biodiversity.weed_evidence_kept` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].compliance.obligation_not_met` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].compliance.self_reported` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].compliance.third_party_fault` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].constraints.biodiversity_area.type` | changed | `"enum(annual&#124;multi_year&#124;null)"` | `"enum(DIV&#124;DIVRS&#124;DIVSZ&#124;DIVNFZ&#124;DIVAGF&#124;null)"` | `"enum(annual&#124;multi_year&#124;null)"` | nein |
| `land.parcels[].crop.autochthonous_seed_production` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].crop.botanical_species` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].crop.cereal_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].crop.erosion_prone_crop` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].crop.first_use_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].crop.fwk_main_component` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].crop.is_mixture` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].crop.is_perennial` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].crop.pure_variety` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].crop.schlagnutzungsart` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].crop.second_crop_name` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].crop.seed_documentation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].crop.seed_harvest_this_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].crop.striped_poppy_varieties_unmixed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].crop.sugar_beet_previous_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].crop.undersown_subordinate_not_harvested` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].crop.variety` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].district` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].field_piece_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].harvest.force_majeure_recognized` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].harvest.harvested_share_percent` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].harvest.late_summer_autumn_crop` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].harvest.no_harvestable_stand_due_to_drought` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].hedge.adjacent_own_arable_field_piece` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].hedge.average_width_m` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].hedge.borders_forest_or_flat_lse_longside` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].hedge.fertilizer_or_psm_used` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].hedge.gis_confirmed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].hedge.herbaceous_div_care_compliant` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].hedge.herbaceous_permanently_green` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].hedge.herbaceous_share_percent` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].hedge.herbaceous_used` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].hedge.planted_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].hedge.state_concept` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].hedge.woody_care_ok` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].national_park` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].national_park_relevant_restrictions` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.bergmaehder_mown_previous_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.driving_events[].date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].operations.driving_events[].purpose` | added | nicht vorhanden | `"enum(crossing&#124;work&#124;parking&#124;storage&#124;turning&#124;irrigation_setup&#124;trailer)"` | nicht deklariert | nein |
| `land.parcels[].operations.erosion_protection_method` | added | nicht vorhanden | `"enum(none&#124;mulch_seeding&#124;direct_seeding&#124;strip_till&#124;other_measure_8_method)"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilization_events[].date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilization_events[].type` | added | nicht vorhanden | `"enum(mineral&#124;slurry&#124;solid_manure&#124;solid_manure_compost&#124;other)"` | nicht deklariert | nein |
| `land.parcels[].operations.mown_at_least_once` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_applications[].date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_applications[].organic_approved_only` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.use_events[].date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].operations.use_events[].material_removed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.use_events[].post_grazing_care` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.use_events[].type` | added | nicht vorhanden | `"enum(mow&#124;mulch&#124;graze&#124;thresh&#124;cleaning_cut&#124;mechanical_weeding&#124;harvest_whole_plant)"` | nicht deklariert | nein |
| `land.parcels[].pheromone_traps.breakup` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].pheromone_traps.breakup_documented` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].pheromone_traps.days_in_field` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.parcels[].pheromone_traps.emptied_count` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.parcels[].pheromone_traps.installation_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].pheromone_traps.lures_obtained_annually` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].pheromone_traps.pheromone_receipts_kept` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].pheromone_traps.records_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].pheromone_traps.reference_sowing_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].pheromone_traps.removed_before_harvest` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].pheromone_traps.resown_sugar_beet` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].pheromone_traps.traps_kept_or_reinstalled` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].pheromone_traps.traps_kept_until_sept_30` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].pheromone_traps.traps_per_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].project_conditions[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].soil_index.ackerzahl` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].soil_index.gruenlandzahl` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].total_area_payments_eur_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].transfer.successor_continues_until_year_end` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].transfer.transferred_during_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].wildkraut.row_spacing_cm` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].wildkraut.sowing_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].wildkraut.spring_cereal` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].wildkraut.threshing_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].wildkraut.undersown` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.species_groups[].average_count` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].kept_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.species_groups[].rgve_category` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_1a-opus-5.5-high-20260929/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_1a-opus-5.5-high-20260929/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
