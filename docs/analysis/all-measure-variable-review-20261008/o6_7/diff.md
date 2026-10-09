# o6_7: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_7-luna-high-20261002`

21 Vorschläge; Blattpfade: {'added': 60, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `documentation.o6_7_field_records.covered_all_arable` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.o6_7_field_records.covered_year` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.o6_7_field_records.problem_weed_evidence_available` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.o6_7_field_records.required_dates_complete` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `documentation.o6_7_field_records.seed_evidence_available` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.oepul.application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.application_submitted` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.oepul.drought_2026.credible_forward_management` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.oepul.drought_2026.drought_no_harvestable_stand` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.oepul.drought_2026.field_emergence_full_cover` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `farm.oepul.drought_2026.planting_conditions_unavailable` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.oepul.drought_2026.proper_establishment` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.oepul.drought_2026.volunteer_cereal_share_percent` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `farm.oepul.first_participation` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.oepul.measure_6_participating` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.oepul.participating` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.oepul.switch_requested` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.oepul.withdrawn` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.region.country` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].crop.gloez8_variant` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].crop.sequence.is_intercrop` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].crop.sequence.is_main_crop` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].crop.sequence.is_threshing_loss` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].crop.sequence.is_volunteer` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].crop.sequence.next_crop` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].crop.sequence.previous_crop` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.active_planting_day_of_year` | added | nicht vorhanden | `1` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.duration_days` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.feed_use` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.gap_days.intercrop_turnover_to_main_sowing` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.gap_days.main_harvest_to_intercrop` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.gap_days.main_harvest_to_main_sowing` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.maintenance_day_of_year` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.mechanical_removal` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.mixture_partners[].name` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.mixture_partners[].plant_family` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.mixture_partners[].share_percent` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.mixture_partners[].winter_hardy` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.regrowth_after_use` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.threshed` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.tillage_kills_cover` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.turnover_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.turnover_day_of_year` | added | nicht vorhanden | `1` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.winter_hardy_share_percent` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer.mineral_n_application_periods[].end` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer.mineral_n_application_periods[].kg_per_ha` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer.mineral_n_application_periods[].start` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_application_periods[].date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_application_periods[].product` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `measure.o6_7.application_submitted` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `measure.o6_7.cover_share_percent` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `measure.o6_7.credible_forward_management` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `measure.o6_7.drought_no_harvestable_stand` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `measure.o6_7.field_emergence_full_cover` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `measure.o6_7.harvest_share_percent` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `measure.o6_7.measure_6_participating` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `measure.o6_7.participating` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `measure.o6_7.planting_conditions_unavailable` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `measure.o6_7.proper_establishment` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `measure.o6_7.volunteer_cereal_share_percent` | added | nicht vorhanden | `0` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_7-luna-high-20261002/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_7-luna-high-20261002/workspace/rules/citations.json).

## opus: `v2-o6_7-opus-5.5-high-20260925`

25 Vorschläge; Blattpfade: {'added': 88, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.applicant.carries_out_agricultural_activity` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.legal_form` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_person&#124;association&#124;territorial_authority)"` | nicht deklariert | nein |
| `farm.applicant.manages_in_own_name_and_account` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.public_body_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.control_refusal_force_majeure` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.control_refused` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.first_participation_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_7.application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_7.contract_lapsed_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_7.first_contract_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_7.new_measure_application_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_7.premium_rate_eur_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_7.reentry_after_exit_or_missing_mfa` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_7.revision_consent_refused` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_7.self_report_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_7.switch_to_6_application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_7.takeover_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_7.withdrawal_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.participations[].measure_code` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.oepul.participations[].options[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.oepul.participations[].year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].acquisition.acquired_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].acquisition.unvegetated_at_acquisition` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].area_type_code` | added | nicht vorhanden | `"enum(short_rotation_coppice&#124;catkin_production&#124;vine_or_tree_nursery&#124;not_actively_farmed&#124;other_area&#124;not_declared_for_measure&#124;national_park_no_premium&#124;not_mainly_agricultural&#124;gloez_landscape_element&#124;trial_area_vf)&#124;null"` | nicht deklariert | nein |
| `land.parcels[].district` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].es_acker_mulch_direct_strip_till` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].federal_state` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].force_majeure_recognised` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].gi_periods[].end_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].gi_periods[].start_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].gloez8_npf_variant` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].greening.records.catch_crop_break` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.records.catch_crop_sowing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.records.following_main_crop_sowing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.records.full_year_jan_to_dec` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.records.main_crop_harvest` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].combined_n_fertilisation_at_sowing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].crop_name` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].declared_in_mfa` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].double_use_field_fodder` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].drought_2026_late_sowing_justified` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].end_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].following_main_crop_sowing_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].full_coverage_achieved` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].full_regreening_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].fully_frost_killed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].is_undersown` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].kind` | added | nicht vorhanden | `"enum(main_crop&#124;catch_crop&#124;green_fallow&#124;nat_self_greening)"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].mineral_n_dates[]` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].mixture.cereal_excess_from_volunteer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].mixture.cereal_maize_share` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].mixture.frost_killed_share` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].mixture.green_rye_varieties_only` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].mixture.is_volunteer_only` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].mixture.partner_count` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].mixture.partners_visible_in_field` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].mixture.plant_family_count` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].mixture.seed_proof_available` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].nitrate_ban_end_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].operations[].cover_maintained` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].operations[].date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].operations[].evidence_kept` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].operations[].fully_frost_killed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].operations[].ground_near` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].operations[].problem_weed` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].operations[].regrowth_expected` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].operations[].type` | added | nicht vorhanden | `"enum(reconsolidation_rolling&#124;rolling&#124;chopping&#124;maintenance_mowing&#124;mowing_with_removal&#124;grazing&#124;harrowing_in_seed&#124;strip_till_preparation&#124;deep_loosening&#124;harrowing&#124;tillage&#124;knife_roller&#124;threshing)"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].operations[].whole_area` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].proper_sowing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].psm_dates[]` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].removal_method` | added | nicht vorhanden | `"enum(tillage_implement&#124;ground_near_chopping_after_frost&#124;direct_or_mulch_or_striptill_sowing&#124;frost_killed_and_collapsed&#124;rolled_down&#124;harrowing&#124;autumn_trimming_with_regrowth)&#124;null"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].segment_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].start_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].threshed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].tillage_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].greening.segments[].undersown_host_harvest_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].harvested_share` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].is_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].national_park` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].no_harvestable_crop_due_to_drought` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul_measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].op_measure_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].transfer.successor_continues_until_year_end` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].transfer.transferred_during_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].usage_category` | added | nicht vorhanden | `"enum(main_crop&#124;arable_fodder&#124;green_fallow&#124;other_arable&#124;protected_cultivation_arable)"` | nicht deklariert | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
