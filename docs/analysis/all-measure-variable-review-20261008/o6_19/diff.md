# o6_19: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_19-luna-high-20261005`

58 Vorschläge; Blattpfade: {'added': 59, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `measure.accession_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `measure.all_oepul_area_in_ebw` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.applicable_takeover_deadline` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `measure.application_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `measure.application_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `measure.arable_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `measure.area_2025_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `measure.combination_scope` | added | nicht vorhanden | `"enum(field&#124;farm)"` | nicht deklariert | nein |
| `measure.commitment_end_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `measure.commitment_years` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `measure.contract_end_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `measure.conversion_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `measure.conversion_target` | added | nicht vorhanden | `"enum(naturschutz&#124;ebw)"` | nicht deklariert | nein |
| `measure.div_code` | added | nicht vorhanden | `"enum(DIV&#124;DIVSZ)"` | nicht deklariert | nein |
| `measure.drought_2026.affected_biodiversity_area_in_ebw` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.drought_2026.proposed_use_follows_project_confirmation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.eligible_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `measure.entry_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `measure.expansion_percent` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `measure.field_piece_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `measure.first_commitment_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.id` | added | nicht vorhanden | `"o6_19"` | nicht deklariert | nein |
| `measure.indicator_code` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `measure.other_measure` | added | nicht vorhanden | `"enum(none&#124;naturschutz&#124;natura_2000&#124;ubb_landscape_element&#124;bio_landscape_element&#124;ubb&#124;bio)"` | nicht deklariert | nein |
| `measure.parcel_code` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `measure.premium.conservation_status` | added | nicht vorhanden | `"enum(A&#124;B&#124;C)"` | nicht deklariert | nein |
| `measure.premium.difficulty_index` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `measure.premium.habitat` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `measure.premium.land_use` | added | nicht vorhanden | `"enum(acker&#124;weiden&#124;wiesen)"` | nicht deklariert | nein |
| `measure.prior_year_measure_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `measure.project_confirmation.indicator_observation_database_current` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.project_confirmation.parcels[].mandatory_indicator_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `measure.project_confirmation.parcels[].mandatory_indicators_met` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.project_confirmation.present` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.project_confirmation.reference_area_present` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.project_confirmation.regular_care_every_second_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.reduction_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `measure.regional_nature_conservation_plan.also_naturschutz` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.regional_nature_conservation_plan.annual_confirmation_present` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.regional_nature_conservation_plan.awards_this_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `measure.regional_nature_conservation_plan.requested` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.requested` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.start_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `measure.surcharges.ebba01.awards_on_area` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `measure.surcharges.ebba01.reason_documented` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.surcharges.ebba01.reason_qualifies` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.surcharges.ebba01.requested` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.surcharges.ebba02.reason_documented` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.surcharges.ebba02.requested` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.surcharges.ebba02.very_good_conservation_status` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.surcharges.ebhg.protection_layer_share` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `measure.surcharges.ebhg.requested` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.takeover_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `measure.total_farm_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `measure.training.not_double_counted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.training.participant_is_farm_person` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.training.regional_network_meeting_by_2026_12_31` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.training.written_confirmation_available` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.violation_assessed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_19-luna-high-20261005/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_19-luna-high-20261005/workspace/rules/citations.json).

## opus: `v2-o6_19-opus-5.5-high-20260927`

94 Vorschläge; Blattpfade: {'added': 97, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `land.parcels[].oepul.codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.chapter7_habitat` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.conservation_status` | added | nicht vorhanden | `"enum(A&#124;B&#124;C)"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.cuts_per_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.deviation_agreed_with_coordination_body` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.deviation_confirmation_amended_in_writing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.difficulty` | added | nicht vorhanden | `"enum(leicht&#124;mittel&#124;schwer)&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.ebba_reason_id` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.ecological_value_too_low` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.habitat_area_reported_in_gis` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.in_project_confirmation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.indicators[].binding` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.indicators[].code` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.indicators[].fulfilled` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.indicators_recorded` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.is_arable_set_aside` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.is_grassland_fallow` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.last_use_or_care_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.managed_as_grassland` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.management_deviation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.premium_habitat` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.premium_table` | added | nicht vorhanden | `"enum(wiesen&#124;weiden&#124;voegel&#124;acker)"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.previous_year_land_use` | added | nicht vorhanden | `"enum(arable&#124;grassland&#124;special_crop&#124;alpine_pasture&#124;other)&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.reference_area_present` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.requires_regular_care` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.schutzgut_layer_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.split_by_habitat_type` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.surcharge_codes[]` | added | nicht vorhanden | `"enum(EBBA01&#124;EBBA02&#124;EBHG01&#124;EBHG02)"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.use_2026.early_use_before_permitted_date` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.use_2026.shortened_rest_period` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.ebw.use_2026.third_use` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.field_piece_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.field_piece_id` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.gloez4_buffer_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.gloez8_set_aside_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.harvest_2026.late_summer_or_autumn_crop` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.harvest_2026.no_harvestable_stand_due_to_drought` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.harvest_2026.obligation_not_met_due_to_drought` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.located_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.national_park` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.national_park_relevant_requirements` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.other_area_payments_eur_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.other_measure_premium_claims[].component` | added | nicht vorhanden | `"enum(area_premium&#124;landscape_elements)"` | nicht deklariert | nein |
| `land.parcels[].oepul.other_measure_premium_claims[].measure` | added | nicht vorhanden | `"enum(1A&#124;1B&#124;2&#124;3&#124;4&#124;6&#124;7&#124;8&#124;9&#124;10&#124;11&#124;12&#124;13&#124;14&#124;16&#124;17&#124;18&#124;23&#124;24)"` | nicht deklariert | nein |
| `land.parcels[].oepul.successor_continues_commitment` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.transferred_during_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.usage_type` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `oepul.applicant.active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.applicant.public_body_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `oepul.applicant.type` | added | nicht vorhanden | `"enum(natural_person&#124;partnership&#124;legal_person&#124;association&#124;public_body)"` | nicht deklariert | nein |
| `oepul.control_refused` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.first_oepul_participation_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `oepul.force_majeure_recognised` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_19.all_oepul_area_ebw_eligible` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_19.area_decrease_exempt_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `oepul.o6_19.circumstance.conditions_met_on_changed_areas` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_19.circumstance.kind` | added | nicht vorhanden | `"enum(force_majeure&#124;permanent&#124;temporary)"` | nicht deklariert | nein |
| `oepul.o6_19.circumstance.occurred_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul.o6_19.circumstance.outside_control` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_19.circumstance.reported_in_time` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_19.contract_start_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `oepul.o6_19.deregistered_in_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_19.ebw_area_2025_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `oepul.o6_19.exited_before_contract_end` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_19.measure_application_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `oepul.o6_19.payment_claim_missing_over_one_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_19.previous_year_ebw_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `oepul.o6_19.project_confirmation_present` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_19.regional_plan.application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul.o6_19.regional_plan.applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_19.regional_plan.deregistered` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_19.regional_plan.first_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `oepul.o6_19.regional_plan.participation_confirmation_present` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_19.sanctions.count_100_percent` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `oepul.o6_19.sanctions.stage` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `oepul.o6_19.switch.effective_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `oepul.o6_19.switch.from` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `oepul.o6_19.switch.to` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `oepul.o6_19.takeover.date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `oepul.o6_19.takeover.expansion_share` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `oepul.o6_19.takeover.farm_dissolution_split_or_merger` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_19.takeover.includes_regional_plan` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_19.training.attendance_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul.o6_19.training.attended` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_19.training.attendee_role` | added | nicht vorhanden | `"enum(farm_manager&#124;involved_person)&#124;null"` | nicht deklariert | nein |
| `oepul.o6_19.training.confirmation_requested` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_19.training.confirmation_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_19.training.credited_to_other_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_19.training.repeat_attended_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul.o6_19.training.same_event_credited_elsewhere` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_19.training.trained_person_left_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul.o6_19.training.transmitted_by_coordination_body` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.participation.bio` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.participation.naturschutz` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.participation.naturschutz_regional_plan_granted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.participation.ubb` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.protected_cultivation_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_19-opus-5.5-high-20260927/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_19-opus-5.5-high-20260927/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
