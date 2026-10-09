# o6_6: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_6-luna-high-20261002`

8 Vorschläge; Blattpfade: {'added': 133, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `applicant.active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `applicant.disposal_power` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `applicant.own_account` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `documentation.conditionality_compliant` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.country` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.first_participation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.protected_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.total_eligible_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `o6_6.active_break` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.active_sowing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.actively_farmed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.additional_interseeding` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.after_frost` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.allowed_grass_seed_rye` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.ama_approved` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.annual_care` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.annual_reduction_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `o6_6.application_corrected` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.application_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `o6_6.approved` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.arable_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `o6_6.area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `o6_6.autumn_main_crop_in_next_mfa` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `o6_6.autumn_main_crop_planted` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `o6_6.autumn_shortening_while_growing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.break_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `o6_6.combination_allowed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.conditionality_compliant` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.conditions_not_met` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.contract_fulfilled` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.correction_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.correctly_identified` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.cover_material_preserved` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.crop` | added | nicht vorhanden | `"enum(winter_rape&#124;other)"` | nicht deklariert | nein |
| `o6_6.crop_harvest_period` | added | nicht vorhanden | `"enum(late_summer_or_autumn&#124;other)"` | nicht deklariert | nein |
| `o6_6.days_between_sowing_and_break` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `o6_6.district` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `o6_6.documentation.conditionality_compliant` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.documentation.problem_plant_proof` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.documentation.seed_propagation_proof` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.documentation.seed_purchase_evidence` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.drought_2026.application_corrected` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.drought_2026.crop_harvest_period` | added | nicht vorhanden | `"enum(late_summer_or_autumn&#124;other)"` | nicht deklariert | nein |
| `o6_6.drought_2026.district` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `o6_6.drought_2026.federal_state` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `o6_6.drought_2026.no_harvestable_stock` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.drought_2026.sowing_will_not_occur` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.drought_effect` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.drought_no_harvestable_stock` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.erosion_method` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `o6_6.federal_state` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `o6_6.following_main_crop` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.frost_rolling_preserves_cover` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.full_coverage` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.full_coverage_after_harvest` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.full_surface_tillage` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.gloez8_npf` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.grain_maize_share` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `o6_6.harmful_soil_tillage` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.harrowing_as_removal` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.harvested_share` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `o6_6.has_greened_parcel` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.herbicide_after_four_leaf_stage` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.immediate_post_sowing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.immergruen_application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `o6_6.insect_pollinated_partner_count` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `o6_6.knife_roller_used` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.land_use` | added | nicht vorhanden | `"enum(arable&#124;grassland&#124;special_crop&#124;alpine_pasture&#124;other)"` | nicht deklariert | nein |
| `o6_6.maintenance_action` | added | nicht vorhanden | `"enum(chopping_or_mowing&#124;other)"` | nicht deklariert | nein |
| `o6_6.maintenance_conditions` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.maintenance_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `o6_6.measure_application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `o6_6.measure_declared` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.mechanical_removal` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.mineral_n_applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.mixing_partner_count` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `o6_6.mixture_crops[].insect_pollinated` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.mixture_crops[].name` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `o6_6.mixture_crops[].plant_family` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `o6_6.mixture_partner_count_visible` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.next_year_relevant_area_declared` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.non_ground_level_chopping` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.non_insect_pollinated_share` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `o6_6.obligations_met_for_entire_period` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.online_withdrawal` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.only_variant_6_crops` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.op_code` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `o6_6.other_area_premiums_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `o6_6.parcels[].area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `o6_6.parcels[].break_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `o6_6.parcels[].land_use` | added | nicht vorhanden | `"enum(arable&#124;grassland&#124;special_crop&#124;alpine_pasture&#124;other)"` | nicht deklariert | nein |
| `o6_6.parcels[].parcel_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `o6_6.parcels[].sow_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `o6_6.participates_immergruen` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.plant_family_count` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `o6_6.post_deadline_change` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.preceding_main_crop` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.previous_measure_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `o6_6.problem_plant_present` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.proof_kept` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.proper_cultivation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.proper_installation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.psm_after_follow_crop_sowing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.psm_applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.regrowth_after_use` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.regrowth_expected` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.removal_done` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.rolling_after_applicable_date` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.seed_propagation_proof` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.seed_purchase_evidence` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.seeders_only_soil_contact` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.sow_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `o6_6.sowing_will_not_occur` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.successor_continues` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.successor_deregisters` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.takeover_area_increase` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `o6_6.takeover_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `o6_6.target_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `o6_6.threshed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.travel_ban_until` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `o6_6.travel_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `o6_6.travel_is_neighbor_crossing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.undersaat` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.variant` | added | nicht vorhanden | `"enum(1&#124;2&#124;3&#124;4&#124;5&#124;6&#124;7)"` | nicht deklariert | nein |
| `o6_6.variant_6_crop_in_next_mfa_as_main` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.variant_6_grass_rye_reseed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.variant_application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `o6_6.variant_period_after_harvest` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.violation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.volunteer_grain_share` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `o6_6.volunteer_or_self_greening` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `o6_6.withdrawal_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `parcel.country` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_6-luna-high-20261002/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_6-luna-high-20261002/workspace/rules/citations.json).

## opus: `v2-o6_6-opus-5.5-high-20260925`

47 Vorschläge; Blattpfade: {'added': 72, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.applicant.is_active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.legal_form` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_person&#124;association&#124;public_body)"` | nicht deklariert | nein |
| `farm.applicant.public_body_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.content_violation_level` | added | nicht vorhanden | `"enum(none&#124;warning&#124;retention_1&#124;2&#124;5&#124;10&#124;25&#124;50&#124;100&#124;exclusion)"` | nicht deklariert | nein |
| `farm.oepul.first_participation_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.inspection_announced_on` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.measures[].applied_on` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.measures[].contract_start_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.measures[].measure_code` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.oepul.measures[].withdrawal_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].constraints.groundwater_protection_area_ooe` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].eligibility_category` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].is_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].national_park` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].national_park_relevant_restrictions` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul_measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.cereal_maize_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.cereal_share_from_volunteer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.declared_as_main_crop_next_mfa` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.establishment` | added | nicht vorhanden | `"enum(sowing&#124;undersowing&#124;companion_sowing_in_winter_rape)"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.events[].cover_preserved` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.events[].coverage_maintained` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.events[].crossing_only` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.events[].date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.events[].full_surface` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.events[].ground_level` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.events[].immediately_after_sowing` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.events[].impairs_companion_crop` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.events[].on_frozen_ground` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.events[].only_drill_coulters` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.events[].plants_fully_frost_killed` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.events[].regrowth_expected` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.events[].type` | added | nicht vorhanden | `"enum(mineral_n_fertilization&#124;mineral_basic_fertilization_without_n&#124;farm_manure_application&#124;secondary_raw_material_application&#124;psm_application&#124;herbicide_application&#124;tillage&#124;knife_roller&#124;care_chopping&#124;care_mowing&#124;ground_level_chopping&#124;rolling&#124;additional_sowing_winter_hardy&#124;harrowing_in_additional_cover_crops&#124;strip_till_preparation&#124;deep_loosening&#124;use_mowing_removal&#124;grazing&#124;threshing&#124;driving)"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.farm_saved_seed_proof` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.farm_saved_seed_used` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.following_main_crop.actively_established` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.following_main_crop.crop_name` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.following_main_crop.declared_in_next_mfa` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.following_main_crop.sowing_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.following_main_crop.sowing_method` | added | nicht vorhanden | `"enum(conventional&#124;mulch&#124;direct&#124;strip_till)"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.full_coverage_achieved` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.green_rye_varieties[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.insect_pollinated_partner_count` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.is_npf_gloez8` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.mixture_partner_count` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.non_insect_pollinated_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.only_volunteer_or_self_seeded` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.partners_visible_in_field` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.plant_family_count` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.preceding_main_crop_harvest_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.problem_weed_evidence_kept` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.problem_weeds[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.properly_established` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.rape_four_leaf_stage_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.seed_proof_available` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.species[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.termination_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.termination_method` | added | nicht vorhanden | `"enum(plough&#124;cultivator&#124;rotary_harrow&#124;disc_harrow&#124;rotor_harrow&#124;rotary_tiller&#124;deep_loosener_with_turnover&#124;knife_roller&#124;ground_level_chopping_after_frost&#124;direct_mulch_or_strip_till_sowing&#124;frost_killed_and_collapsed&#124;rolled_down&#124;harrowing&#124;autumn_topping&#124;herbicide)"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.variant` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.variant_applied_on` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.variant_withdrawn` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.cover_crop.winter_hardiness` | added | nicht vorhanden | `"enum(winter_hardy&#124;frost_killed&#124;mixed&#124;unknown)"` | nicht deklariert | nein |
| `land.parcels[].operations.main_crop_harvest_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].public_funding_overlap` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].special_circumstance.occurred_on` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].special_circumstance.reported` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].special_circumstance.type` | added | nicht vorhanden | `"enum(permanent&#124;temporary&#124;force_majeure)"` | nicht deklariert | nein |
| `land.parcels[].transfer.successor_complies` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].transfer.successor_measure_code` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].transfer.transferred_on` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_6-opus-5.5-high-20260925/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_6-opus-5.5-high-20260925/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
