# o6_15: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_15-luna-high-20261004`

60 Vorschläge; Blattpfade: {'added': 60, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `documentation.conditionality_compliant` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `documentation.full_year_obligation_met` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `documentation.sanction_finding` | added | nicht vorhanden | `"none"` | nicht deklariert | nein |
| `farm.active_farmer` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `farm.agricultural_activity` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `farm.controls_land` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `farm.first_oepul_participation` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `farm.o6_15_application_date` | added | nicht vorhanden | `"2025-12-31"` | nicht deklariert | nein |
| `farm.o6_15_drought.drought_prevented_obligation` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.o6_15_drought.higher_force_application_submitted` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.o6_15_exit.exit_effective_date` | added | nicht vorhanden | `"2027-01-01"` | nicht deklariert | nein |
| `farm.o6_15_exit.requested` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.o6_15_payment_application_date` | added | nicht vorhanden | `"2026-07-15"` | nicht deklariert | nein |
| `farm.participates_almbewirtschaftung` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.agricultural_area_with_additions_ha` | added | nicht vorhanden | `1.5` | nicht deklariert | nein |
| `land.parcels[].accommodation_available` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].actively_managed` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].care.animal_care` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].care.care_essential_part_of_day` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].care.daily_care` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].care.disease_and_injury_treatment` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].care.security_measures` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].care.water_available` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].grazing_management.site_adapted_grazing` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].grazing_management.subarea_rotation_or_fencing` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].herder_assignment.herder_id` | added | nicht vorhanden | `"representative-herder"` | nicht deklariert | nein |
| `land.parcels[].herder_assignment.only_one_alm` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].herder_assignment.rgve` | added | nicht vorhanden | `0.0` | nicht deklariert | nein |
| `land.parcels[].in_austria` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].is_alm` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].measure_declared` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].op_code` | added | nicht vorhanden | `"none"` | nicht deklariert | nein |
| `land.parcels[].pasture_segments[].end_date` | added | nicht vorhanden | `"2026-07-30"` | nicht deklariert | nein |
| `land.parcels[].pasture_segments[].interruption_days` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].pasture_segments[].pro_rata_factor` | added | nicht vorhanden | `1.0` | nicht deklariert | nein |
| `land.parcels[].pasture_segments[].start_date` | added | nicht vorhanden | `"2026-06-01"` | nicht deklariert | nein |
| `land.parcels[].stocking_days` | added | nicht vorhanden | `60` | nicht deklariert | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `0.0` | nicht deklariert | nein |
| `livestock.herd_protection_dog.certificate_recognized` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `livestock.herd_protection_dog.day_and_night_with_herd` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `livestock.herd_protection_dog.days_on_single_alm` | added | nicht vorhanden | `60` | nicht deklariert | nein |
| `livestock.herd_protection_dog.dogs_on_alm` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `livestock.herd_protection_dog.herded_animals_total_days` | added | nicht vorhanden | `60` | nicht deklariert | nein |
| `livestock.herd_protection_dog.liability_insurance` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `livestock.herd_protection_dog.permanent_herd_member` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `livestock.herd_protection_dog.requested` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `livestock.herd_protection_dog.works_without_direct_commands` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `livestock.species_groups[].age_years` | added | nicht vorhanden | `1` | nicht deklariert | nein |
| `livestock.species_groups[].calvings` | added | nicht vorhanden | `1` | nicht deklariert | nein |
| `livestock.species_groups[].held_in_austria` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `livestock.species_groups[].herded` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `livestock.species_groups[].herded_category_complete` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `livestock.species_groups[].herding_days` | added | nicht vorhanden | `60` | nicht deklariert | nein |
| `livestock.species_groups[].milked_days_on_alms` | added | nicht vorhanden | `45` | nicht deklariert | nein |
| `livestock.species_groups[].report.correction_days` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `livestock.species_groups[].report.days_after_event` | added | nicht vorhanden | `4` | nicht deklariert | nein |
| `livestock.species_groups[].report.deadline_days` | added | nicht vorhanden | `14` | nicht deklariert | nein |
| `livestock.species_groups[].report.ear_tag_present` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `livestock.species_groups[].report.event` | added | nicht vorhanden | `"arrival"` | nicht deklariert | nein |
| `livestock.species_groups[].report.milked_flag` | added | nicht vorhanden | `false` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_15-luna-high-20261004/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_15-luna-high-20261004/workspace/rules/citations.json).

## opus: `v2-o6_15-opus-5.5-high-20260926`

7 Vorschläge; Blattpfade: {'added': 93, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `alpine_farming.alms[].alm_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `alpine_farming.alms[].alpine_pasture_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].animal_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].behirtung_category` | added | nicht vorhanden | `"enum(dairy_cows&#124;other_cattle&#124;sheep&#124;goats&#124;equids&#124;new_world_camelids)"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].birth_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].breed` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].calved_by_july_1` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].count` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].drive_down_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].drive_up_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].ear_tag` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].equid_large_breed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].first_drive_up_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].interruption_days` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].is_dwarf_breed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].is_herded` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].kept_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].milked` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].milked_days` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].milked_flag_reported_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].planned_drive_down_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].report_date_down` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].report_date_up` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].rgve_category` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].species` | added | nicht vorhanden | `"enum(cattle&#124;sheep&#124;goat&#124;equid&#124;new_world_camelid&#124;other)"` | nicht deklariert | nein |
| `alpine_farming.alms[].animals[].total_alpine_days_all_herded_alms` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].care.animal_care` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].care.daily_care` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].care.herding_substantial_part_of_day` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].care.inspection_only` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].care.night_care_when_required` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].care.safety_measures` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].care.site_adapted_grazing_management` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].care.sufficient_water_supply` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].care.treatment_of_diseases_and_injuries` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].cross_border` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].declared_herder_count` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].herd_protection_dogs[].certificate_available_on_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].herd_protection_dogs[].certified_herd_protection_dog` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].herd_protection_dogs[].claimed_on_other_alm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].herd_protection_dogs[].day_and_night_with_herd` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].herd_protection_dogs[].days_on_this_alm` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `alpine_farming.alms[].herd_protection_dogs[].dog_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `alpine_farming.alms[].herd_protection_dogs[].entered_in_auftriebsliste` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].herd_protection_dogs[].liability_insurance` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].herd_protection_dogs[].permanent_herd_member` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].herd_protection_dogs[].present_whole_alpine_period` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].herd_protection_dogs[].works_without_direct_commands` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].herded_categories[]` | added | nicht vorhanden | `"enum(dairy_cows&#124;other_cattle&#124;sheep&#124;goats&#124;equids&#124;new_world_camelids)"` | nicht deklariert | nein |
| `alpine_farming.alms[].herder_accommodation_available` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].herders[].herds_other_alm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].herders[].person_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `alpine_farming.alms[].herding_funded_by_other_public_title` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].in_alm_cadastre_or_alm_area` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].is_separate_sub_holding` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].managed_from_home_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].national_park` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].permanent_circumstance_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].permanent_circumstance_force_majeure` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].stocked_rgve` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].stocking_days` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `alpine_farming.alms[].visible_boundary_to_grassland` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.alms[].water_supply_failed_due_to_drought` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.herding_application.dog_supplement_application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `alpine_farming.herding_application.dog_supplement_requested` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.herding_application.dog_supplement_start_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `alpine_farming.herding_application.federal_state_top_up_granted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.herding_application.federal_state_top_up_notified_by_may_15` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `alpine_farming.herding_application.payment_application_submission_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `documentation.control_refusal_force_majeure` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `documentation.on_site_control_refused` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_alm_operator` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.legal_form` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_person&#124;association&#124;public_body)"` | nicht deklariert | nein |
| `farm.applicant.public_body_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `oepul_participation.first_oepul_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `oepul_participation.measures[].application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_participation.measures[].contract_start_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `oepul_participation.measures[].deregistered_before_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_participation.measures[].deregistered_in_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_participation.measures[].deregistration_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_participation.measures[].full_reductions_in_contract_period` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `oepul_participation.measures[].late_correction_of_previous_measure_application` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_participation.measures[].measure_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `oepul_participation.measures[].participating_in_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_participation.measures[].previous_contract_expired` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_participation.measures[].reapplied_after_expiry` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_participation.measures[].takeover.animals_and_areas_from_same_predecessor` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_participation.measures[].takeover.is_takeover` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_participation.measures[].takeover.reason` | added | nicht vorhanden | `"enum(farm_dissolution&#124;farm_division&#124;farm_merger&#124;other)&#124;null"` | nicht deklariert | nein |
| `oepul_participation.measures[].written_request_to_ama_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_15-opus-5.5-high-20260926/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_15-opus-5.5-high-20260926/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
