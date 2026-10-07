# o6_8: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_8-luna-high-20261002`

12 Vorschläge; Blattpfade: {'added': 45, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.oepul.application_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `farm.oepul.contract_start_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.oepul.first_participation_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.oepul.measure_applications[].active` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.measure_applications[].application_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.oepul.measure_applications[].measure_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.oepul.measure_area_reduction_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.measure_changes[].change_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `farm.oepul.measure_changes[].target_measure` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.oepul.prior_measure_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.withdrawal_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].application_codes[].code` | added | nicht vorhanden | `"enum(MS&#124;DS&#124;AH&#124;BAW&#124;US)"` | nicht deklariert | nein |
| `land.parcels[].country` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].erosion.baw_break_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].erosion.baw_establishment_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].erosion.baw_grazing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].erosion.baw_mowing_or_chopping_every_two_years` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].erosion.baw_sowing_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].erosion.baw_threshing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].erosion.erosion_entry_path_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].erosion.erosion_entry_path_kg_number` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].erosion.erosion_entry_path_share` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].erosion.evergreen_overwintering` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].erosion.hilling_spacing_m` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].erosion.hilling_until_foliage_reduction` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].erosion.legume_share` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].erosion.post_undersow_herbicide` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].erosion.post_undersow_tillage` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].erosion.preceding_cover_crop_variant` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].erosion.successor_uses_predecessor_establishment_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].erosion.undersow_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].erosion.undersow_harvested_as_crop` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].erosion.undersow_mixture_partner_count` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].erosion.undersow_orderly_with_required_partners` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].erosion.undersow_present_at_main_crop_harvest` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].erosion.winter_hardy` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].measure_codes[].code` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].measure_codes[].measure_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].operations.days_between_first_tillage_and_following_crop` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.full_area_tillage` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.harvestable_stand` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.plant_mulch_remaining` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.residues_between_strips` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.slot_drill_into_cover` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.strip_rows_only` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_8-luna-high-20261002/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_8-luna-high-20261002/workspace/rules/citations.json).

## opus: `v2-o6_8-opus-5.5-high-20261001`

23 Vorschläge; Blattpfade: {'added': 93, 'removed': 0, 'changed': 1}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.oepul.applicant.is_active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.applicant.legal_form` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_person&#124;association&#124;public_body)"` | nicht deklariert | nein |
| `farm.oepul.applicant.public_body_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.first_participation_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_8.application_submitted_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_8.contract_start_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_8.exit_reason` | added | nicht vorhanden | `"enum(loss_of_disposal&#124;revision_clause&#124;permanent_circumstances_reported&#124;other)&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_8.exit_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_8.farm_handover_to_successor` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_8.late_payment_application_within_one_year` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_8.payment_application_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_8.previous_year_measure_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.options[]` | added | nicht vorhanden | `"enum(16_humus_wien&#124;other)"` | nicht deklariert | nein |
| `farm.oepul.participating_measures[]` | added | nicht vorhanden | `"enum(1A&#124;1B&#124;1C&#124;2&#124;3&#124;4&#124;5&#124;6&#124;7&#124;8&#124;9&#124;10&#124;11&#124;12&#124;13&#124;14&#124;15&#124;16&#124;17&#124;18&#124;19&#124;20&#124;21&#124;22&#124;23&#124;24)"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.baw.div_code` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.baw.erosion_path_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.baw.erosion_path_share` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.baw.establishment_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.baw.existing_stand_retained` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.baw.existing_stand_type` | added | nicht vorhanden | `"enum(gruenbrache&#124;feldfutter)&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.baw.fertilized_since_first_declaration` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.baw.first_declared_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.baw.gloez4_buffer_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.baw.gloez8_fallow_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.baw.grassland_in_mfa_2020` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.baw.grazed` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.baw.green_cover_maintained` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.baw.last_mowing_or_mulching_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.baw.legume_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.baw.mowing_records_complete` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.baw.npf_code` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.baw.ploughing_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.baw.psm_used_since_first_declaration` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.baw.sowing_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.baw.threshed` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.baw.winter_hardy_mixture` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.codes[]` | added | nicht vorhanden | `"enum(MS&#124;DS&#124;AH&#124;BAW&#124;US)"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.crop_usage_type` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.harvest.force_majeure_application_filed` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.harvest.force_majeure_recognised` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.harvest.harvest_prevented_by_force_majeure` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.harvest.harvested_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.harvest.late_summer_or_autumn_harvest_crop` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.harvest.no_harvestable_stand_due_to_drought` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.location.country` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.location.district` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.location.federal_state` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.location.kg_nr` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.location.national_park` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.location.national_park_relevant_obligations` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.main_crop_sowing_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.op_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.other_area_payments_eur_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.other_measures_on_parcel[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.potato_ridges.created_by_planter_or_prompt_ridger` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.potato_ridges.distinct_effective_ridges` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.potato_ridges.every_4th_row_omitted` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.potato_ridges.in_furrows_except_tramlines` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.potato_ridges.interval_max_m` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.potato_ridges.maintained_until_haulm_reduction` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.potato_ridges.omission_necessary_weed_control_or_safety` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.preceding_catch_crop.overwintering` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.preceding_catch_crop.scheme` | added | nicht vorhanden | `"enum(oepul2023_zwf&#124;oepul2023_immergruen&#124;oepul2015_zwf&#124;gloez8_npf&#124;none)"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.preceding_catch_crop.variant` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.public_funding_overlap` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.tillage.cover_residues_retained_between_strips` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.tillage.deep_loosening` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.tillage.deep_loosening_cover_preserved` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.tillage.ds_method` | added | nicht vorhanden | `"enum(direct_seeding&#124;strip_till)&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.tillage.first_tillage_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.tillage.full_surface_tillage` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.tillage.inverting_or_deep_mixing` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.tillage.plant_mulch_on_surface` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.tillage.slot_seeding` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.tillage.strip_only_in_seed_row` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.transferred_without_continuation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.trial_area_vf` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.undersowing.adequate_emergence` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.undersowing.between_rows` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.undersowing.full_coverage_achieved` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.undersowing.harrowing_after_sowing` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.undersowing.harvested_with_main_crop` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.undersowing.herbicide_after_sowing` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.undersowing.main_crop_harvest_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.undersowing.maintained_until_main_crop_harvest` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.undersowing.mixture_partner_count` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.undersowing.partners_visible_in_field` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.undersowing.properly_established` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.undersowing.seed_proof_available` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.undersowing.sowing_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.undersowing.tillage_after_sowing` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_o6_8.undersowing.winter_field_bean` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.tillage_type` | changed | `"enum(plough&#124;reduced&#124;mulch&#124;no_till&#124;unknown)"` | `"enum(plough&#124;reduced&#124;mulch&#124;no_till&#124;strip_till&#124;unknown)"` | `"enum(plough&#124;reduced&#124;mulch&#124;no_till&#124;unknown)"` | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
