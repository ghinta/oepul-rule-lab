# o6_20: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_20-luna-high-20261005`

3 Vorschläge; Blattpfade: {'added': 41, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `context.control_note_acknowledged` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `context.drought_2026` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].all_category_animals_participate` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].animal_count` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].animals_held_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].average_rgve` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].category` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].cattle_report_immediate` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].cattle_special_report_required` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].correction_or_report` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].count_correction_done` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].coupled_alpine_support_claimed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].days_present` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].entry_after_april` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].entry_report_within_7_days` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].exit_after_april` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].exit_report_within_7_days` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].grazing_substantial_part_of_day` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].groundfeed_predominantly_grazing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].on_common_pasture` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].optional_150_days` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].participating` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].pasture_days_are_counted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].pasture_treated_as_exit` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].replacement_by_growing_animals` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].shelter_access` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].temporary_pasture_stay` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].vis_reporting_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].water_access` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].weide_days` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].weide_diary_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.livestock.o6_20[].weide_period_valid` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_20_application.animals_and_land_same_predecessor` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_20_application.application_date_before_31_december` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_20_application.camel_application_count_present` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_20_application.cattle_database_calculated` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_20_application.individual_animal_data_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_20_application.measure_requested` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_20_application.option_150_application_on_time` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_20_application.takeover_due_to_restructuring` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_20_application.withdrawal_after_31_december` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_20-luna-high-20261005/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_20-luna-high-20261005/workspace/rules/citations.json).

## opus: `v2-o6_20-opus-5.5-high-20260928`

6 Vorschläge; Blattpfade: {'added': 92, 'removed': 0, 'changed': 1}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.applicant.farms_in_own_name_and_account` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.has_agricultural_activity` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_public_body` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.legal_form` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_person&#124;association_of_persons)"` | nicht deklariert | nein |
| `farm.applicant.public_body_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul_participation.conditionality_compliant` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul_participation.first_oepul_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.species_groups[].species` | changed | `"enum(cattle&#124;pigs&#124;sheep_goats&#124;horses&#124;poultry&#124;rabbits&#124;other)"` | `"enum(cattle&#124;pigs&#124;sheep_goats&#124;horses&#124;new_world_camelids&#124;poultry&#124;rabbits&#124;other)"` | `"enum(cattle&#124;pigs&#124;sheep_goats&#124;horses&#124;poultry&#124;rabbits&#124;other)"` | nein |
| `oepul_measures.tierwohl_stallhaltung_rinder.participating` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animal_list_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].animal_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].arrival_report_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].birth_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].category_code` | added | nicht vorhanden | `"enum(cattle_female_2y_plus&#124;cattle_female_6m_to_2y&#124;cattle_male_6m_plus&#124;sheep_female_1y_plus&#124;new_world_camelids_1y_plus&#124;goats_female_1y_plus&#124;equids_6m_plus)"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].category_entry_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].category_exit_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].coupled_alpine_support_applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].deleted_from_list` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].departure_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].departure_reason` | added | nicht vorhanden | `"enum(sale&#124;death&#124;slaughter&#124;other)&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].departure_report_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].departure_reported_while_on_alm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].ear_tag` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].grazed_with_category_until_departure` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].held_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].non_compliance_known_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].non_compliance_report_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].participating` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].present_from` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].reported_non_compliant` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].rgve_class` | added | nicht vorhanden | `"enum(cattle_6m_to_2y&#124;cattle_2y_plus&#124;dwarf_cattle_6m_to_2y&#124;dwarf_cattle_2y_plus&#124;sheep_1y_plus&#124;goats_1y_plus&#124;equid_small_young_6m_to_3y&#124;equid_small_adult_3y_plus&#124;equid_large_young_6m_to_3y&#124;equid_large_adult_3y_plus&#124;new_world_camelids_1y_plus)"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].sex` | added | nicht vorhanden | `"enum(female&#124;male)&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.animals[].structure_change_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].alm_only_fulfilment` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].animals_not_grazed_without_report` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].applied_at_home_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].average_rgve` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].birth_stall_days` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].category_code` | added | nicht vorhanden | `"enum(cattle_female_2y_plus&#124;cattle_female_6m_to_2y&#124;cattle_male_6m_plus&#124;sheep_female_1y_plus&#124;new_world_camelids_1y_plus&#124;goats_female_1y_plus&#124;equids_6m_plus)"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].contract_lapsed_previous_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].count_entries[].applied_count` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].count_entries[].compliant_count` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].count_entries[].count_corrected` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].count_entries[].count_increased_after_deadline` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].count_entries[].rgve_class` | added | nicht vorhanden | `"enum(equid_small_young_6m_to_3y&#124;equid_small_adult_3y_plus&#124;equid_large_young_6m_to_3y&#124;equid_large_adult_3y_plus&#124;new_world_camelids_1y_plus)"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].coupled_alpine_support_rgve` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].days_with_min_one_animal_present` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].deregistration_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].female_cattle_combined_single_animal_days` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].first_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].forage_mainly_from_grazing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].grazing_days_all_animals` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].grazing_substantial_part_of_day` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].individual_birth_documentation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].min_days_reached_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].non_compliance_reported` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].reapplied_by_correction` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].replaced_by_other_category` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].shelter_or_rapid_stall_access` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].supplement_150_application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].supplement_150_applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].supplement_150_removed_by_correction` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].water_access` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.categories[].written_request_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.control.on_site_control_refused` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.deregistration_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.drought_affected_2026` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.equids_ueln_identified` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.excluded_combinations_applied[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.exit_context.administrative_control_result_notified` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.exit_context.on_site_control_announced` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.exit_context.on_site_control_performed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.force_majeure_claimed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.force_majeure_recognized` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.grazing_diary.maintained` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.grazing_diary.records_category_or_group` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.grazing_diary.records_daily_animal_interruption_reasons` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.grazing_diary.records_location` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.grazing_diary.records_period_start_end_per_location` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.grazing_diary.significant_changes_recorded_same_day` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.measure_application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.obligations_kept_whole_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.participation_start_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.same_service_funded_elsewhere` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.sanction_stage` | added | nicht vorhanden | `"enum(none&#124;warning&#124;reduction_2&#124;reduction_5&#124;reduction_10&#124;reduction_25&#124;reduction_50&#124;reduction_100&#124;exclusion)"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.takeover.animals_and_areas_from_same_previous_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.takeover.is_takeover` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.takeover.reason` | added | nicht vorhanden | `"enum(farm_dissolution&#124;farm_division&#124;farm_merger&#124;other)&#124;null"` | nicht deklariert | nein |
| `oepul_measures.tierwohl_weide.vis_reporting_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_20-opus-5.5-high-20260928/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_20-opus-5.5-high-20260928/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
