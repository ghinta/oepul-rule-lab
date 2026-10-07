# o6_16: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_16-luna-high-20261005`

57 Vorschläge; Blattpfade: {'added': 61, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.bentazon_reauthorized` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.region.is_eastern_lower_austria_or_tullnerfeld` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.groundwater_arable_area_ha` | added | nicht vorhanden | `5.03` | nicht deklariert | nein |
| `land.parcels[].average_ackerzahl` | added | nicht vorhanden | `40.0` | nicht deklariert | nein |
| `land.parcels[].cover_crop_planted_by_11_15` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].crop_area_ha` | added | nicht vorhanden | `0.2` | nicht deklariert | nein |
| `land.parcels[].crop_category` | added | nicht vorhanden | `"maize"` | nicht deklariert | nein |
| `land.parcels[].field_record_complete` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].following_crop_planted_by_11_15` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].following_crop_reduction_kg_per_ha` | added | nicht vorhanden | `0.0` | nicht deklariert | nein |
| `land.parcels[].has_base_premium` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].id` | added | nicht vorhanden | `"p1"` | nicht deklariert | nein |
| `land.parcels[].in_groundwater_area` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].kg_number` | added | nicht vorhanden | `"32001"` | nicht deklariert | nein |
| `land.parcels[].nitrogen_surplus_kg_per_ha` | added | nicht vorhanden | `0.0` | nicht deklariert | nein |
| `land.parcels[].psm_active_ingredients[]` | added | nicht vorhanden | `"Metazachlor"` | nicht deklariert | nein |
| `land.parcels[].washout_broken_up` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].washout_cover_contains_legumes` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].washout_cover_new_sown` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].washout_grazed_or_threshed` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].washout_mown_or_chopped_every_two_years` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].washout_psm_or_fertilizer_used` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].washout_years_since_start` | added | nicht vorhanden | `2` | nicht deklariert | nein |
| `land.total_arable_area_ha` | added | nicht vorhanden | `10.0` | nicht deklariert | nein |
| `livestock.pig_gve_average` | added | nicht vorhanden | `1.0` | nicht deklariert | nein |
| `measure.first_participation_year` | added | nicht vorhanden | `2026` | nicht deklariert | nein |
| `measure.oo_chemical_psm_application` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `measure.oo_variant_3_cover` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `measure.participates_cover_evergreen` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `measure.participates_cover_intercrop` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `measure.participates_organic` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `measure.requested` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `options.cultan.external_equipment` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `options.cultan.has_ammonium_depot_injection` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `options.cultan.parcel_ids[]` | added | nicht vorhanden | `"p1"` | nicht deklariert | nein |
| `options.cultan.requested` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `options.psm_avoidance_surcharge.requested` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `options.strong_n_reduced_pig_feeding.also_claimed_in_liquid_manure_measure` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `options.strong_n_reduced_pig_feeding.feed_categories[].average_g_per_kg` | added | nicht vorhanden | `166.0` | nicht deklariert | nein |
| `options.strong_n_reduced_pig_feeding.feed_categories[].category` | added | nicht vorhanden | `"piglets_8_to_32_kg"` | nicht deklariert | nein |
| `options.strong_n_reduced_pig_feeding.feed_categories[].phase_g_per_kg` | added | nicht vorhanden | `null` | nicht deklariert | nein |
| `options.strong_n_reduced_pig_feeding.requested` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `options.vienna_humus.recognized_carbon_project_confirmation` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `options.vienna_humus.requested` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `options.vienna_humus.turning_tillage_other_than_after_maize` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `options.washout_risk.parcel_ids[]` | added | nicht vorhanden | `"p1"` | nicht deklariert | nein |
| `options.washout_risk.requested` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `records.cultan_external_service_evidence` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `records.cultan_field_records_complete` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `records.education_completed_date` | added | nicht vorhanden | `"2026-12-31"` | nicht deklariert | nein |
| `records.education_hours` | added | nicht vorhanden | `10.0` | nicht deklariert | nein |
| `records.education_provider_recognized` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `records.farm_balance_completed_by_next_01_31` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `records.farm_planning_completed_by_02_28` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `records.oo_ipm_inspection_or_warning_documented` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `records.pig_feed_recipe_evidence` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `records.soil_samples[].draw_date` | added | nicht vorhanden | `"2026-01-01"` | nicht deklariert | nein |
| `records.soil_samples[].lab_accredited` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `records.soil_samples[].submitted_date` | added | nicht vorhanden | `"2026-12-31"` | nicht deklariert | nein |
| `records.vienna_extra_education_hours` | added | nicht vorhanden | `3.0` | nicht deklariert | nein |
| `records.water_protection_concept_complete` | added | nicht vorhanden | `true` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_16-luna-high-20261005/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_16-luna-high-20261005/workspace/rules/citations.json).

## opus: `v2-o6_16-opus-5.5-high-20261002`

15 Vorschläge; Blattpfade: {'added': 110, 'removed': 0, 'changed': 1}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.applicant.legal_form` | added | nicht vorhanden | `"enum(natuerliche_person&#124;personengesellschaft_firmenbuch&#124;juristische_person&#124;personenvereinigung)"` | nicht deklariert | nein |
| `farm.applicant.public_body_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.first_oepul_participation_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_16.area_reduction_due_to_loss_of_control` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_16.bentazon_reauthorized` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_16.contract_start_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_16.cultan.applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_16.farm_records.farm_balance_completed_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_16.farm_records.fertilization_plan_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_16.farm_records.napv_compliant` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_16.field_records.content_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_16.field_records.electronic` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_16.field_records.max_completion_delay_days` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_16.humus_erosion_vienna.application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_16.humus_erosion_vienna.applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_16.humus_erosion_vienna.data_provided_on_request` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_16.humus_erosion_vienna.project_confirmation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_16.humus_erosion_vienna.start_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_16.leaching_risk_area.applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_16.measure_application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_16.n_reduced_pig_feeding.application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_16.n_reduced_pig_feeding.applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_16.n_reduced_pig_feeding.deregistered` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_16.n_reduced_pig_feeding.start_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_16.premium_area_2025_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_16.premium_area_previous_year_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_16.soil_sample_base_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_16.soil_samples[].analysis_method` | added | nicht vorhanden | `"enum(richtlinien_sachgerechte_duengung&#124;euf)"` | nicht deklariert | nein |
| `farm.oepul.o6_16.soil_samples[].area` | added | nicht vorhanden | `"enum(gebiet&#124;wien_gebiet)"` | nicht deklariert | nein |
| `farm.oepul.o6_16.soil_samples[].entered_in_invekos_gis` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_16.soil_samples[].lab_accredited` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_16.soil_samples[].lab_submission_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_16.soil_samples[].n_method` | added | nicht vorhanden | `"enum(nachlieferbarer_stickstoff&#124;mineralischer_stickstoff)"` | nicht deklariert | nein |
| `farm.oepul.o6_16.soil_samples[].parameters[]` | added | nicht vorhanden | `"enum(N&#124;P&#124;K&#124;pH&#124;humus)"` | nicht deklariert | nein |
| `farm.oepul.o6_16.soil_samples[].received_with_parcel_from_other_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_16.soil_samples[].sample_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.oepul.o6_16.soil_samples[].sampling_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `farm.oepul.o6_16.training_courses[].attendee_left_farm_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_16.training_courses[].attendee_role` | added | nicht vorhanden | `"enum(applicant&#124;involved_person)"` | nicht deklariert | nein |
| `farm.oepul.o6_16.training_courses[].course_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.oepul.o6_16.training_courses[].credited_to_other_commitment` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_16.training_courses[].credited_to_other_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_16.training_courses[].date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `farm.oepul.o6_16.training_courses[].hours` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.o6_16.training_courses[].provider_recognized` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_16.training_courses[].topics[]` | added | nicht vorhanden | `"enum(grundwasserschutz&#124;humusaufbau&#124;wassersparende_bewirtschaftung&#124;grundwasserschonende_bewaesserung&#124;stickstoff_emissionsreduzierte_fuetterung_schweine&#124;bodenproben&#124;pfluglose_bodenbearbeitung)"` | nicht deklariert | nein |
| `farm.oepul.o6_16.training_courses[].vienna_extra` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_16.upper_austria_top_up_funds_available` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_16.water_protection_concept_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.participating_measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].cadastral_community_number` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].harvest.harvested_share` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].harvest.no_harvestable_stand_due_to_drought` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].harvest.usually_harvested_late_summer_or_autumn` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].leaching_option.ackerzahl_avg` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].leaching_option.breakup_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].leaching_option.existing_stand_retained` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].leaching_option.first_ag_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].leaching_option.gloez4_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].leaching_option.gloez8_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].leaching_option.grassland_in_mfa_2020` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].leaching_option.grazed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].leaching_option.mix_contains_legumes` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].leaching_option.mix_winter_hardy` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].leaching_option.mowing_or_mulching_years[]` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.parcels[].leaching_option.previous_farm_first_ag_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].leaching_option.sowing_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].leaching_option.threshed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].n_management.follow_crop_n_fertilization_kg_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].n_management.follow_crop_n_requirement_kg_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].n_management.follow_crop_sowing_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].n_management.nmin_kg_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].n_management.offtake_basis` | added | nicht vorhanden | `"enum(n_requirement&#124;yield_based)&#124;null"` | nicht deklariert | nein |
| `land.parcels[].n_management.reduction_factor_applications` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].n_management.unused_cover_crop_n_kg_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].n_reduction_zone` | added | nicht vorhanden | `"enum(noerdliches_mittleres_burgenland&#124;oestliches_niederoesterreich_inkl_tullnerfeld&#124;wien&#124;restliche_gebietskulisse)&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul.in_protection_or_conservation_zone` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.o6_8_practices[]` | added | nicht vorhanden | `"enum(mulchsaat&#124;direktsaat&#124;strip_till&#124;untersaat)"` | nicht deklariert | nein |
| `land.parcels[].oepul.usage_type` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.o6_6_variant` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer_applications[].contractor_invoice_available` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer_applications[].date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer_applications[].external_contractor` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer_applications[].method` | added | nicht vorhanden | `"enum(broadcast&#124;trailing_hose&#124;trailing_shoe&#124;injection&#124;incorporation&#124;cultan_injection&#124;other)"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer_applications[].n_available_kg_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer_applications[].readily_soluble_n` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer_applications[].recorded` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer_applications[].slow_release` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_applications[].active_substances[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_applications[].date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_applications[].prior_field_inspection_documented` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_applications[].product_type` | added | nicht vorhanden | `"enum(bio&#124;chemical_synthetic)"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_applications[].seed_treatment` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_applications[].warning_service_documented` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].previous_crop.breakup_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].previous_crop.crop_category` | added | nicht vorhanden | `"enum(cereal&#124;maize&#124;oilseed&#124;legume&#124;root&#124;vegetable&#124;orchard&#124;vineyard&#124;hop&#124;fallow&#124;other)"` | nicht deklariert | nein |
| `land.parcels[].previous_crop.crop_name` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].previous_crop.harvest_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].previous_crop.n_saldo_kg_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.species_groups[].category` | changed | `"string&#124;null"` | `"enum(rinder_unter_halbes_jahr&#124;rinder_halbes_bis_2_jahre&#124;rinder_ab_2_jahre&#124;zwergrinder_unter_halbes_jahr&#124;zwergrinder_halbes_bis_2_jahre&#124;zwergrinder_ab_2_jahre&#124;schafe_ab_1_jahr&#124;schafe_unter_1_jahr&#124;ziegen_ab_1_jahr&#124;ziegen_unter_1_jahr&#124;pferde_klein_fohlen_unter_halbes_jahr&#124;pferde_klein_jungtiere_halbes_bis_3_jahre&#124;pferde_klein_ab_3_jahre&#124;pferde_gross_fohlen_unter_halbes_jahr&#124;pferde_gross_jungtiere_halbes_bis_3_jahre&#124;pferde_gross_ab_3_jahre&#124;rotwild_ab_1_jahr&#124;damwild_zuchtwild_ab_1_jahr&#124;neuweltkamele_ab_1_jahr&#124;neuweltkamele_wild_unter_1_jahr&#124;ferkel_ab_8kg&#124;jung_mastschweine_ab_32kg&#124;zucht_jungsauen_ab_50kg)&#124;null"` | `"string&#124;null"` | nein |
| `livestock.species_groups[].feeding.crude_protein_avg_g_per_kg` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].feeding.feeding_category` | added | nicht vorhanden | `"enum(ferkel_8_32kg&#124;jung_mast_jungsau_ungedeckt&#124;zuchtsau_tragend_jungsau_gedeckt&#124;zuchtsau_saeugend&#124;eber_ab_50kg)&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].feeding.phase_feeding` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.species_groups[].feeding.phase_feeding_plausible` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].feeding.phases[].crude_protein_g_per_kg` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.species_groups[].feeding.phases[].weight_from_kg` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.species_groups[].feeding.phases[].weight_to_kg` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].feeding.protein_basis` | added | nicht vorhanden | `"enum(feed_analysis&#124;literature_standard&#124;manufacturer_declaration)&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].feeding.recipe_evidence_available` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_16-opus-5.5-high-20261002/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_16-opus-5.5-high-20261002/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
