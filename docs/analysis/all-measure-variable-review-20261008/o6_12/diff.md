# o6_12: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_12-luna-high-20261003`

9 Vorschläge; Blattpfade: {'added': 30, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.measures.o6_12.area_wide_psm_application` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.measures.o6_12.authority_order_documented` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.measures.o6_12.authority_ordered_area` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.measures.o6_12.authority_ordered_chemical_synthetic_insecticide` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.measures.o6_12.authority_ordered_control` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.measures.o6_12.authority_ordered_substance_allowed` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.measures.o6_12.biological_farming_participation` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.measures.o6_12.biological_farming_scope` | added | nicht vorhanden | `null` | nicht deklariert | nein |
| `farm.measures.o6_12.chemical_synthetic_insecticide_used` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.measures.o6_12.compliance_status` | added | nicht vorhanden | `null` | nicht deklariert | nein |
| `farm.measures.o6_12.contract_start_year` | added | nicht vorhanden | `null` | nicht deklariert | nein |
| `farm.measures.o6_12.current_area_ha` | added | nicht vorhanden | `null` | nicht deklariert | nein |
| `farm.measures.o6_12.early_exit_approved` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.measures.o6_12.early_exit_reason` | added | nicht vorhanden | `null` | nicht deklariert | nein |
| `farm.measures.o6_12.first_participation_year` | added | nicht vorhanden | `null` | nicht deklariert | nein |
| `farm.measures.o6_12.participating` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.measures.o6_12.premium_target_type` | added | nicht vorhanden | `null` | nicht deklariert | nein |
| `farm.measures.o6_12.prior_area_ha` | added | nicht vorhanden | `null` | nicht deklariert | nein |
| `farm.measures.o6_12.quality_planting_material_ok` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.measures.o6_12.request_date` | added | nicht vorhanden | `null` | nicht deklariert | nein |
| `farm.measures.o6_12.sonstige_target_land_use` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.measures.o6_12.switch_request_date` | added | nicht vorhanden | `null` | nicht deklariert | nein |
| `farm.region.country` | added | nicht vorhanden | `"Austria"` | nicht deklariert | nein |
| `land.parcels[].operations.insecticide_authority_documented` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].operations.insecticide_authority_order` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].operations.insecticide_in_other_culture` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].operations.insecticide_is_bio_permitted` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].operations.insecticide_purchase_or_storage` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].operations.insecticide_purchase_storage_plausible` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].operations.insecticide_use` | added | nicht vorhanden | `false` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_12-luna-high-20261003/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_12-luna-high-20261003/workspace/rules/citations.json).

## opus: `v2-o6_12-opus-5.5-high-20260926`

17 Vorschläge; Blattpfade: {'added': 83, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.applicant.farms_in_own_name_and_account` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.performs_agricultural_activity` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.person_type` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_person&#124;association&#124;public_body)"` | nicht deklariert | nein |
| `farm.applicant.public_body_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].crop.fruit_grafted` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].crop.special_crop_type` | added | nicht vorhanden | `"enum(wine&#124;cutting_vineyard&#124;vine_nursery&#124;tree_nursery&#124;fruit&#124;hop&#124;other_wine&#124;other_special_crop&#124;null)"` | nicht deklariert | nein |
| `land.parcels[].location.in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].location.national_park` | added | nicht vorhanden | `"enum(neusiedlersee&#124;donau_auen&#124;kalkalpen&#124;other&#124;null)"` | nicht deklariert | nein |
| `land.parcels[].oepul.declared_for_o6_12` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.is_gloez_landscape_element` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.measure_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul.measure_op_code_o6_12` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.op_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul.other_area_payments_eur_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.psm_application_planned` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.psm_codes[]` | added | nicht vorhanden | `"enum(PSMBIO&#124;PSMCSI&#124;PSMCS)"` | nicht deklariert | nein |
| `land.parcels[].oepul.successor_continues_commitment` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.transferred_during_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.trial_area_vf` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.actively_farmed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.minimum_management.annual_care` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.minimum_management.harvest_and_removal` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.minimum_management.proper_planting` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.plant_protection_applications[].application_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].operations.plant_protection_applications[].area_wide` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.plant_protection_applications[].authority_ordered_control` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.plant_protection_applications[].chemical_synthetic` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.plant_protection_applications[].effect_type` | added | nicht vorhanden | `"enum(insecticide&#124;herbicide&#124;fungicide&#124;other)"` | nicht deklariert | nein |
| `land.parcels[].operations.plant_protection_applications[].organic_regulation_permitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.plant_protection_applications[].product_name` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `oepul.controls.admin_control_result_notified` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.controls.inspection_refused` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.controls.on_site_control_announced_or_done` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.first_participation_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `oepul.force_majeure.claim_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.force_majeure.obligations_not_met_due_to_drought` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.force_majeure.recognised` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.measures[].application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul.measures[].code` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `oepul.measures[].commitment_start_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `oepul.measures[].exit_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul.o6_12.area_change.current_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `oepul.o6_12.area_change.loss_of_disposal_right` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_12.area_change.permitted_conversion` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_12.area_change.previous_year_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `oepul.o6_12.authority_orders[].application_documented` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_12.authority_orders[].federal_state` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `oepul.o6_12.authority_orders[].in_designated_area` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_12.authority_orders[].order_documented` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_12.authority_orders[].organic_substances_available` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_12.authority_orders[].pest` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `oepul.o6_12.authority_orders[].prescribes_chemical_synthetic` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_12.authority_orders[].uploaded_to_eama` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_12.insecticide_stock[].organic_regulation_permitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_12.insecticide_stock[].permitted_use_in_other_crop` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_12.insecticide_stock[].product_name` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `oepul.o6_12.insecticide_stock[].purchased` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_12.insecticide_stock[].quantity_plausible` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_12.insecticide_stock[].records_available` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_12.insecticide_stock[].stored` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_12.leafhopper_exit.approved` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `oepul.o6_12.leafhopper_exit.reason_leafhopper_stated` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_12.leafhopper_exit.request_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul.o6_12.leafhopper_exit.requested` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_12.leafhopper_exit.submitted_via_eama_force_majeure_form` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_12.permanent_circumstances_recognised` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_12.revision_clause_consent_refused` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_12.sanction.full_reductions_in_contract_period` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `oepul.o6_12.sanction.stage` | added | nicht vorhanden | `"enum(warning&#124;2&#124;5&#124;10&#124;25&#124;50&#124;100&#124;exclusion&#124;null)"` | nicht deklariert | nein |
| `oepul.o6_12.switch_to_organic.effective_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul.o6_12.switch_to_organic.requested` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_12.takeover.ama_approved` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `oepul.o6_12.takeover.date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul.o6_12.takeover.expansion_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `oepul.o6_12.takeover.requested` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_12.takeover.taker_previously_participating` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.organic_partial_farm.is_partial_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.organic_partial_farm.organic_culture_area` | added | nicht vorhanden | `"enum(arable_grassland&#124;wine_fruit_hop&#124;null)"` | nicht deklariert | nein |
| `oepul.payment_application.submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.payment_application.years_overdue` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `oepul.total_payment_eur` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_12-opus-5.5-high-20260926/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_12-opus-5.5-high-20260926/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
