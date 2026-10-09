# o6_11: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_11-luna-20260920`

9 Vorschläge; Blattpfade: {'added': 32, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.applicant.has_disposal_rights` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `farm.applicant.is_active_farmer` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `farm.applicant.operates_in_own_name_and_account` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `farm.applicant.public_authority_control_percent` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `farm.oepul.herbicide_purchases_storage[].is_herbicide` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.oepul.herbicide_purchases_storage[].permitted_for_other_crops` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.oepul.herbicide_purchases_storage[].product_name` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.oepul.herbicide_purchases_storage[].quantity` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `farm.oepul.herbicide_purchases_storage[].record_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `farm.oepul.herbicide_purchases_storage[].unit` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.oepul.k20_continuation_only` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.oepul.measure_applications[].active` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `farm.oepul.measure_applications[].measure_id` | added | nicht vorhanden | `"o6_11"` | nicht deklariert | nein |
| `farm.oepul.measure_applications[].parcel_ids[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.oepul.measure_applications[].participation_type` | added | nicht vorhanden | `"whole_farm"` | nicht deklariert | nein |
| `farm.oepul.o6_11_application_year` | added | nicht vorhanden | `2025` | nicht deklariert | nein |
| `farm.oepul.o6_11_contract_start_year` | added | nicht vorhanden | `2025` | nicht deklariert | nein |
| `land.oepul_eligible_area_ha` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].crop.plant_material_is_grafted` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].location_country` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].management_records[].annual_care` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].management_records[].commitment_period_complete` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].management_records[].harvest_removed` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].management_records[].proper_planting` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].o6_11_code` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.pesticide_applications[].active_ingredient` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].operations.pesticide_applications[].application_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].operations.pesticide_applications[].area_fraction` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].operations.pesticide_applications[].effect_type` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].operations.pesticide_applications[].is_herbicide` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].operations.pesticide_applications[].product_name` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `0` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_11-luna-20260920/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_11-luna-20260920/workspace/rules/citations.json).

## opus: `v2-o6_11-opus-5.5-high-20261001`

10 Vorschläge; Blattpfade: {'added': 67, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `documentation.plant_protection_inventory[].active_substances[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `documentation.plant_protection_inventory[].effect_type` | added | nicht vorhanden | `"enum(herbicide&#124;insecticide&#124;fungicide&#124;other)"` | nicht deklariert | nein |
| `documentation.plant_protection_inventory[].in_storage` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `documentation.plant_protection_inventory[].intended_crop_category` | added | nicht vorhanden | `"enum(cereal&#124;maize&#124;oilseed&#124;legume&#124;root&#124;vegetable&#124;orchard&#124;vineyard&#124;hop&#124;fallow&#124;other)&#124;null"` | nicht deklariert | nein |
| `documentation.plant_protection_inventory[].product_name` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `documentation.plant_protection_inventory[].purchased_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `documentation.plant_protection_inventory[].quantity` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `documentation.plant_protection_inventory[].quantity_plausible` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `documentation.plant_protection_inventory[].records_documented` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `documentation.plant_protection_inventory[].unit` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `farm.applicant.farms_in_own_name_and_account` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_public_body` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.legal_form` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_person&#124;association)"` | nicht deklariert | nein |
| `farm.applicant.public_body_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.conditionality_compliant` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `farm.oepul.first_participation_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.full_reduction_count_in_contract_period` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.oepul.measures[].application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.measures[].contract_start_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.measures[].conversion_application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.measures[].conversion_target` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `farm.oepul.measures[].exit_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.measures[].exit_type` | added | nicht vorhanden | `"enum(voluntary&#124;loss_of_control&#124;permanent_special_circumstance&#124;revision_clause_refusal)&#124;null"` | nicht deklariert | nein |
| `farm.oepul.measures[].is_organic_partial_farm` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `farm.oepul.measures[].measure_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.oepul.measures[].organic_partial_culture_areas[]` | added | nicht vorhanden | `"enum(arable_grassland&#124;wine_fruit_hop)"` | nicht deklariert | nein |
| `farm.oepul.measures[].payment_claim_overdue_more_than_one_year` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `farm.oepul.measures[].payment_claim_submitted` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `farm.oepul.on_site_inspection_refusal_force_majeure` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `farm.oepul.on_site_inspection_refused` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.previous_year_measure_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.sanction_level` | added | nicht vorhanden | `"enum(warning&#124;r2&#124;r5&#124;r10&#124;r25&#124;r50&#124;r100&#124;exclusion)&#124;null"` | nicht deklariert | nein |
| `farm.oepul.special_circumstances[].all_conditions_met_on_changed_areas` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `farm.oepul.special_circumstances[].force_majeure` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `farm.oepul.special_circumstances[].occurrence_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `farm.oepul.special_circumstances[].reported` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.special_circumstances[].type` | added | nicht vorhanden | `"enum(force_majeure&#124;permanent&#124;temporary)"` | nicht deklariert | nein |
| `farm.oepul.takeover.expansion_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.takeover.taken_over_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.takeover.takeover_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.takeover.taking_farm_previously_in_measure` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].crop.is_grafted` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].crop.usage_type` | added | nicht vorhanden | `"enum(wine&#124;cutting_vineyard&#124;vine_nursery&#124;other_wine&#124;fruit&#124;hop&#124;other_special_crop&#124;tree_nursery)&#124;null"` | nicht deklariert | nein |
| `land.parcels[].is_fenced` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.actively_farmed` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul.excluded_measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul.is_gaec_landscape_element` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.is_trial_area` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.located_in_austria` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul.national_park` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.op_cases[]` | added | nicht vorhanden | `"enum(harvest_not_fulfilled&#124;public_funding_overlap&#124;official_compensation_area&#124;commitment_not_full_year&#124;commitment_not_full_contract_period&#124;ungrafted_fruit&#124;third_party_fault)"` | nicht deklariert | nein |
| `land.parcels[].oepul.other_area_payments_eur_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.public_funding_overlap` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.permanent_crop_management.annual_care_done` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.permanent_crop_management.harvested_and_removed` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.permanent_crop_management.properly_planted` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_applications[].active_substances[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_applications[].application_zone` | added | nicht vorhanden | `"enum(area&#124;fence_line&#124;stem)&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_applications[].date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_applications[].effect_type` | added | nicht vorhanden | `"enum(herbicide&#124;insecticide&#124;fungicide&#124;other)"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_applications[].is_area_wide` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_applications[].is_organic_approved` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_applications[].product_name` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_11-opus-5.5-high-20261001/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_11-opus-5.5-high-20261001/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
