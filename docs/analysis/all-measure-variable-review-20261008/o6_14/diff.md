# o6_14: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_14-luna-high-20261004`

72 Vorschläge; Blattpfade: {'added': 72, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `documentation.alpine_records_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `documentation.oepul_application_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `documentation.oepul_field_list_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `documentation.oepul_only_cattle` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `documentation.oepul_participates_tierwohl_behirtung` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `documentation.oepul_reports.cattle_arrival_days` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `documentation.oepul_reports.cattle_departure_days` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `documentation.oepul_reports.other_arrival_days` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `documentation.oepul_reports.other_departure_days` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `documentation.oepul_stocking_list_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.alpine_pastures[].access_stage` | added | nicht vorhanden | `"enum(stage_1&#124;stage_2&#124;stage_3)"` | nicht deklariert | nein |
| `land.alpine_pastures[].alm_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.alpine_pastures[].alm_inputs.fertilizer_bio_allowed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].alm_inputs.fertilizer_used` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].alm_inputs.non_alpine_slurry_or_liquid_manure` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].alm_inputs.pesticide_bio_only` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].alm_inputs.pesticide_used` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].alm_inputs.separated_home_farm_slurry_solids` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].alm_inputs.sewage_sludge` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].almweideplan.annual_review_documented` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].almweideplan.communicated_to_workers` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].almweideplan.contains_required_assessment` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].almweideplan.course.completed_by` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.alpine_pastures[].almweideplan.course.hours` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.alpine_pastures[].almweideplan.course.recognized_provider` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].almweideplan.course.relevant_content` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].almweideplan.plan_created_by_deadline` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].almweideplan.plan_for_all_alms` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].almweideplan.strong_intensity` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].almweideplan.strong_intensity_reason` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.alpine_pastures[].area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.alpine_pastures[].feed_practices.natural_fodder_sufficient` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].feed_practices.non_alpine_silage_or_green_fodder` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].feed_practices.own_alpine_silage` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].feed_practices.own_alpine_silage_fed_on_same_alm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].is_alm_definition_met` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].is_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].naturschutz.course.completed_by` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.alpine_pastures[].naturschutz.course.hours` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.alpine_pastures[].naturschutz.course.recognized_provider` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].naturschutz.course.relevant_content` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].naturschutz.no_new_drainage` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].naturschutz.no_terrain_correction` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].naturschutz.project_codes[].code` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.alpine_pastures[].naturschutz.project_confirmation_for_all_parcels` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].naturschutz.sensitive_area_fertilizer_free` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].naturschutz.troughs_not_in_wetlands` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].project_confirmation_for_all_parcels` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.alpine_pastures[].stocking_records[].foreign_area_evidence` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.alpine_pastures[].stocking_records[].foreign_relief_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.alpine_pastures[].stocking_records[].rgve` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.alpine_pastures[].stocking_records[].rgve_per_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.alpine_pastures[].stocking_records[].stocking_days` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.alpine_pastures[].stocking_records[].year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `livestock.alpine_movements[].alm_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `livestock.alpine_movements[].alpung_days` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `livestock.alpine_movements[].alpung_end` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `livestock.alpine_movements[].alpung_start` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `livestock.alpine_movements[].animal_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `livestock.alpine_movements[].arrival_report_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `livestock.alpine_movements[].departure_report_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `livestock.alpine_movements[].gve` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.alpine_movements[].is_held_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.alpine_movements[].species` | added | nicht vorhanden | `"enum(cattle&#124;sheep&#124;goats&#124;equines&#124;camelids)"` | nicht deklariert | nein |
| `preferences_constraints.oepul_2026_drought_force_majeure.affected_by_drought` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `preferences_constraints.oepul_2026_drought_force_majeure.commitment_unfulfillable` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `preferences_constraints.oepul_2026_drought_force_majeure.individual_application_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `preferences_constraints.oepul_contract_start_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `preferences_constraints.oepul_first_participation_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `preferences_constraints.oepul_options.almweideplan` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `preferences_constraints.oepul_options.naturschutz_auf_der_alm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `preferences_constraints.oepul_participation_requested` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_14-luna-high-20261004/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_14-luna-high-20261004/workspace/rules/citations.json).

## opus: `v2-o6_14-opus-5.5-high-20260926`

4 Vorschläge; Blattpfade: {'added': 136, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `alpine_farming.alms[].access_level` | added | nicht vorhanden | `"enum(1&#124;2&#124;3)"` | nicht deklariert | nein |
| `alpine_farming.alms[].access_times_comparable` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].access_units[].access_level` | added | nicht vorhanden | `"enum(1&#124;2&#124;3)"` | nicht deklariert | nein |
| `alpine_farming.alms[].access_units[].alp_days` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `alpine_farming.alms[].access_units[].drive_period_days` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `alpine_farming.alms[].access_units[].unit_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `alpine_farming.alms[].adjacent_to_home_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].alm_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `alpine_farming.alms[].alm_pasture_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `alpine_farming.alms[].boundary_or_management_difference_visible` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].drive_up_list_submission_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].feeding.alm_foreign_green_fodder_fed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].feeding.alm_silage_moved_to_home_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].feeding.basic_fodder_supplementation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].feeding.compensatory_feeding` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].feeding.silage_alm_own` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].feeding.silage_fed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].feeding.silage_produced` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].feeding.silage_stored` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].fertilisation.alm_foreign_slurry_applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].fertilisation.home_farm_manure_applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].fertilisation.home_farm_separated_slurry_solids_applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].fertilisation.non_organic_fertiliser_used` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].fertilisation.sewage_sludge_applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].field_list_submission_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].foreign_adjacent_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].foreign_area_report_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].grazing_plan.increased_intensity_applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].grazing_plan.increased_intensity_declared_in_drive_up_list` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].grazing_plan.increased_intensity_justified_in_plan` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].in_alm_cadastre_or_alm_area` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].is_own_alm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].managed_from_home_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].nata_coding_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].national_park` | added | nicht vorhanden | `"enum(none&#124;kalkalpen&#124;neusiedlersee&#124;donau_auen&#124;other)"` | nicht deklariert | nein |
| `alpine_farming.alms[].nature_conservation.drainage_upgrade_consent` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].nature_conservation.drainage_upgraded` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].nature_conservation.fertilised_habitats[]` | added | nicht vorhanden | `"enum(moor&#124;wetland&#124;calcareous_grassland&#124;siliceous_grassland&#124;nardus_grassland&#124;other)"` | nicht deklariert | nein |
| `alpine_farming.alms[].nature_conservation.measures[].affected_share_pct` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].nature_conservation.measures[].code` | added | nicht vorhanden | `"enum(NAW1&#124;NAW2&#124;NAW3&#124;NAD1&#124;NAD2&#124;NAD3&#124;NAB1&#124;NAB2&#124;NAB3)"` | nicht deklariert | nein |
| `alpine_farming.alms[].nature_conservation.new_drainage` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].nature_conservation.participates` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].nature_conservation.project_requirements_met` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].nature_conservation.terrain_correction` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].nature_conservation.watering_point_in_wetland_or_spring` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].plant_protection.non_organic_psm_used` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].plots[].area_wide_psm_types[]` | added | nicht vorhanden | `"enum(organic&#124;chemical_synthetic)"` | nicht deklariert | nein |
| `alpine_farming.alms[].plots[].codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `alpine_farming.alms[].plots[].other_area_measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `alpine_farming.alms[].plots[].plot_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `alpine_farming.alms[].plots[].project_confirmation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.animals[].animal_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `alpine_farming.animals[].birth_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `alpine_farming.animals[].breed` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `alpine_farming.animals[].count` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `alpine_farming.animals[].ear_tag` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `alpine_farming.animals[].equine_size_class` | added | nicht vorhanden | `"enum(small&#124;large&#124;null)"` | nicht deklariert | nein |
| `alpine_farming.animals[].home_stable_only_for_milking` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `alpine_farming.animals[].in_tierwohl_weide_or_rare_breeds` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.animals[].new_drive_up_report_with_new_home_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.animals[].non_compliance_reported` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.animals[].presence_compliant` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.animals[].rgve_category_id` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `alpine_farming.animals[].sold_without_drive_down` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.animals[].species` | added | nicht vorhanden | `"enum(cattle&#124;sheep&#124;goat&#124;equine&#124;new_world_camelid&#124;other)"` | nicht deklariert | nein |
| `alpine_farming.animals[].stays[].alm_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `alpine_farming.animals[].stays[].drive_down_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `alpine_farming.animals[].stays[].drive_down_report_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.animals[].stays[].drive_up_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `alpine_farming.animals[].stays[].drive_up_report_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.animals[].stays[].in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.animals[].stays[].planned_drive_down_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.circumstance.drought_prevents_compliance` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.circumstance.force_majeure` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.circumstance.force_majeure_application_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.circumstance.occurrence_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.circumstance.reported` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.circumstance.type` | added | nicht vorhanden | `"enum(permanent&#124;temporary&#124;null)"` | nicht deklariert | nein |
| `alpine_farming.control.refused` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.exit.exit_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.exit.exited` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.exit.operator_change` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.exit.reason` | added | nicht vorhanden | `"enum(voluntary&#124;loss_of_control&#124;revision_clause&#124;force_majeure&#124;permanent_circumstance_reported&#124;null)"` | nicht deklariert | nein |
| `alpine_farming.grazing_plan_supplement.application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.grazing_plan_supplement.applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.grazing_plan_supplement.course.attendee_role` | added | nicht vorhanden | `"enum(farm_manager&#124;alm_manager&#124;significantly_involved_person&#124;other)"` | nicht deklariert | nein |
| `alpine_farming.grazing_plan_supplement.course.completed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.grazing_plan_supplement.course.completion_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.grazing_plan_supplement.course.covers_required_topics` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.grazing_plan_supplement.course.credited_to_other_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.grazing_plan_supplement.course.double_counted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.grazing_plan_supplement.course.hours` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `alpine_farming.grazing_plan_supplement.course.provider_recognized` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.grazing_plan_supplement.deregistered` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.grazing_plan_supplement.first_application_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `alpine_farming.grazing_plan_supplement.plan.annual_review_documented` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.grazing_plan_supplement.plan.assessment_ecological_value` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.grazing_plan_supplement.plan.assessment_site_yield` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.grazing_plan_supplement.plan.covers_all_alms` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.grazing_plan_supplement.plan.created_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.grazing_plan_supplement.plan.created_with_or_communicated_to_involved_persons` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.grazing_plan_supplement.plan.development_goals_and_management_needs` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.grazing_plan_supplement.plan.grazing_and_steering_measures_per_plot` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.grazing_plan_supplement.takeover_context` | added | nicht vorhanden | `"enum(farm_dissolution&#124;farm_division&#124;farm_merger&#124;other&#124;null)"` | nicht deklariert | nein |
| `alpine_farming.is_alm_manager` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.measure.application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.measure.applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.measure.commitment_start_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `alpine_farming.measure.payment_claim_missing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.measure.payment_claim_missing_over_one_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.nature_conservation_supplement.application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.nature_conservation_supplement.applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.nature_conservation_supplement.commitment_start_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `alpine_farming.nature_conservation_supplement.course.attendee_role` | added | nicht vorhanden | `"enum(alm_manager&#124;herder&#124;significantly_involved_person&#124;other)"` | nicht deklariert | nein |
| `alpine_farming.nature_conservation_supplement.course.completed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.nature_conservation_supplement.course.completion_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.nature_conservation_supplement.course.content_nature_conservation_related` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.nature_conservation_supplement.course.credited_to_other_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.nature_conservation_supplement.course.double_counted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.nature_conservation_supplement.course.hours` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `alpine_farming.nature_conservation_supplement.course.provider_recognized` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.nature_conservation_supplement.course.replacement_course_completed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.nature_conservation_supplement.course.trained_person_left_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.nature_conservation_supplement.course.trained_person_left_date_known` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.sanction_history.full_reductions_in_contract_period` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `alpine_farming.takeover.approved_by_ama` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.takeover.expansion_share` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `alpine_farming.takeover.is_takeover` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.takeover.previously_participating` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.takeover.submission_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.applicant.is_active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.legal_form` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_person&#124;association_of_persons&#124;public_body)"` | nicht deklariert | nein |
| `farm.applicant.public_body_share_pct` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.first_oepul_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.participating_measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_14-opus-5.5-high-20260926/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_14-opus-5.5-high-20260926/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
