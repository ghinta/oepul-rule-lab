# o6_1c: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_1c-luna-high-20260930`

58 Vorschläge; Blattpfade: {'added': 62, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.applicant.has_disposal_power` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_public_authority` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].agroforestry.average_width_m` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].agroforestry.browsing_protection` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].agroforestry.criteria_after_removal_remain` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].agroforestry.establishment_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].agroforestry.establishment_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].agroforestry.existing_strip` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].agroforestry.long_side_adjacent_to_forest` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].agroforestry.long_side_adjacent_to_landscape_element` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].agroforestry.max_tree_distance_m` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].agroforestry.natural_ingress_species[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].agroforestry.only_bio_authorized_browsing_protection` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].agroforestry.permanently_green` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].agroforestry.pruning` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].agroforestry.replanting_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].agroforestry.shrubs_between_trees` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].agroforestry.staking` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].agroforestry.trees[].common_name` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].agroforestry.trees[].natural_ingress` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].agroforestry.trees[].scientific_name` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].agroforestry.trees_per_100m` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].agroforestry.use_of_herbaceous_area` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].combination.other_measure_ids[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].constraints.gloez4_buffer_strip` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].counted_for_other_obligation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].country` | added | nicht vorhanden | `"AT"` | nicht deklariert | nein |
| `land.parcels[].is_special_crop` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].measure_category` | added | nicht vorhanden | `"enum(nonproductive_arable&#124;agroforestry_strip&#124;null)"` | nicht deklariert | nein |
| `land.parcels[].measure_code` | added | nicht vorhanden | `"enum(NPA&#124;LSE Agroforststreifen&#124;null)"` | nicht deklariert | nein |
| `land.parcels[].npa.break_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].npa.care_events_current_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.parcels[].npa.care_events_last_two_years` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.parcels[].npa.care_purpose` | added | nicht vorhanden | `"enum(ordinary&#124;weed_cleaning&#124;null)"` | nicht deklariert | nein |
| `land.parcels[].npa.clearance_method` | added | nicht vorhanden | `"enum(mechanical&#124;other&#124;null)"` | nicht deklariert | nein |
| `land.parcels[].npa.clearance_operation` | added | nicht vorhanden | `"enum(chopping&#124;incorporation&#124;null)"` | nicht deklariert | nein |
| `land.parcels[].npa.cut_material_removed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].npa.cut_material_used` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].npa.establishment` | added | nicht vorhanden | `"enum(new_sowing&#124;existing_green_fallow&#124;permanent_green&#124;self_greening&#124;null)"` | nicht deklariert | nein |
| `land.parcels[].npa.first_application_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].npa.following_crop` | added | nicht vorhanden | `"enum(wintering&#124;cover_crop&#124;other&#124;null)"` | nicht deklariert | nein |
| `land.parcels[].npa.grazing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].npa.psm_active_ingredients[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].npa.sowing_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].npa.was_broken_up` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].other_measure_premium` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].successor_continues_until_year_end` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].transfer_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `measure.application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `measure.bio_part_operation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.bio_participation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.combination_matrix.o6_1c.other_measure` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.compliance_breach` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.contract_end` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `measure.contract_start` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `measure.deregistered` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.id` | added | nicht vorhanden | `"o6_1c"` | nicht deklariert | nein |
| `measure.npa_area_with_care_before_august_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `measure.npa_participation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.premium_band_selected` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.ubb_participation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_1c-luna-high-20260930/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_1c-luna-high-20260930/workspace/rules/citations.json).

## opus: `v2-o6_1c-opus-5.5-high-20260925`

11 Vorschläge; Blattpfade: {'added': 88, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.applicant.carries_out_agricultural_activity` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.legal_form` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_person&#124;association&#124;public_body)"` | nicht deklariert | nein |
| `farm.applicant.manages_farm_in_own_name_and_account` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.public_body_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.admin_control_result_notified_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.conditionality_compliant` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.first_participation_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.full_reductions_in_contract_period` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.oepul.measure_participations[].application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.measure_participations[].category` | added | nicht vorhanden | `"enum(npa&#124;afs)&#124;null"` | nicht deklariert | nein |
| `farm.oepul.measure_participations[].deregistration_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.measure_participations[].first_contract_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.oepul.measure_participations[].measure_code` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.oepul.measure_participations[].option` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `farm.oepul.mfa_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.onsite_control_announced_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.onsite_control_refusal_force_majeure` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.onsite_control_refused` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.takeovers[].date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `farm.oepul.takeovers[].extension_to_other_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.takeovers[].measure_code` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.oepul.takeovers[].taken_over_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.agroforestry_strips[].adjacent_to_arable` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.agroforestry_strips[].area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.agroforestry_strips[].assigned_feldstueck_id` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.agroforestry_strips[].average_width_m` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.agroforestry_strips[].browsing_protection_agent_bio_approved` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.agroforestry_strips[].browsing_protection_agent_used` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.agroforestry_strips[].care.browsing_protection` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.agroforestry_strips[].care.pruning_as_needed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.agroforestry_strips[].care.stake_stabilization` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.agroforestry_strips[].establishment_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.agroforestry_strips[].fertilizer_used` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.agroforestry_strips[].herbaceous_permanently_green` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.agroforestry_strips[].herbaceous_use` | added | nicht vorhanden | `"enum(none&#124;maintenance_mowing&#124;mulching&#124;mowing_with_removal&#124;grazing)"` | nicht deklariert | nein |
| `land.agroforestry_strips[].is_special_crop_gspav_25_4` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.agroforestry_strips[].length_m` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.agroforestry_strips[].long_side_adjacent_to_forest_or_area_landscape_element` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.agroforestry_strips[].max_tree_spacing_m` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.agroforestry_strips[].oepul_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.agroforestry_strips[].oepul_status.in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.agroforestry_strips[].oepul_status.is_gloez_landscape_element` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.agroforestry_strips[].oepul_status.national_park` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.agroforestry_strips[].oepul_status.other_measure_premium_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.agroforestry_strips[].planting_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.agroforestry_strips[].psm_used` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.agroforestry_strips[].replanting_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.agroforestry_strips[].schlagnutzungsart` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.agroforestry_strips[].species[].count` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.agroforestry_strips[].species[].origin` | added | nicht vorhanden | `"enum(planted&#124;natural)"` | nicht deklariert | nein |
| `land.agroforestry_strips[].species[].scientific_name` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.agroforestry_strips[].strip_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.agroforestry_strips[].tree_count` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.agroforestry_strips[].trees_removed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.feldstuecke[].arable_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.feldstuecke[].feldstueck_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.landscape_elements_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].constraints.gloez4_buffer_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].npa.any_fertilization` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].npa.breaking_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].npa.establishment_type` | added | nicht vorhanden | `"enum(new_sowing&#124;self_greening&#124;retained_green_fallow&#124;retained_permanently_greened_arable)"` | nicht deklariert | nein |
| `land.parcels[].npa.first_npa_declaration_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.parcels[].npa.follow_up_crop` | added | nicht vorhanden | `"enum(winter_crop&#124;catch_crop&#124;other&#124;none)"` | nicht deklariert | nein |
| `land.parcels[].npa.grazed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].npa.maintenance_events[].biomass_removed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].npa.maintenance_events[].biomass_used` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].npa.maintenance_events[].date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].npa.maintenance_events[].type` | added | nicht vorhanden | `"enum(maintenance_mowing&#124;mulching&#124;cleaning_cut)"` | nicht deklariert | nein |
| `land.parcels[].npa.maintenance_in_previous_year` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].npa.psm_only_bio_active_substances` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].npa.removal_device` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].npa.removal_method` | added | nicht vorhanden | `"enum(mulching&#124;incorporation&#124;chemical&#124;other&#124;none)&#124;null"` | nicht deklariert | nein |
| `land.parcels[].npa.resown_after_breaking_existing_fallow` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].npa.sowing_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].npa.used_after_breaking` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul_status.authority_mandated_compensation_area` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul_status.commitment_not_fulfillable_full_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul_status.in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul_status.is_gloez_landscape_element` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul_status.national_park` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_status.noncompliance_third_party_fault` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul_status.other_measure_premium_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul_status.overlapping_public_funding` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul_status.scientific_trial_area` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].schlagnutzungsart` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_1c-opus-5.5-high-20260925/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_1c-opus-5.5-high-20260925/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
