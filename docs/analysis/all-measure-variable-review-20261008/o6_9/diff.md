# o6_9: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_9-luna-high-20261002`

12 Vorschläge; Blattpfade: {'added': 70, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `application.amount_m3` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `application.application_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `application.application_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `application.biogas_has_excluded_input` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.biogas_origin_proof` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.external_equipment` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.injected_rainwater` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.is_water_mixed_solid_manure` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.land_use` | added | nicht vorhanden | `"enum(arable&#124;grassland)"` | nicht deklariert | nein |
| `application.manure_type` | added | nicht vorhanden | `"enum(slurry&#124;urine&#124;biogas_slurry)"` | nicht deklariert | nein |
| `application.method` | added | nicht vorhanden | `"enum(trailing_hose&#124;trailing_shoe&#124;injection)"` | nicht deklariert | nein |
| `application.records_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.records_include[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `application.requested_by_december_31` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.requested_m3` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `calculation.arable_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `calculation.cattle_gve` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `calculation.eligible_fertilizable_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.arable_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.fertilizable_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].operations.manure_application.amount_m3` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].operations.manure_application.application_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].operations.manure_application.application_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].operations.manure_application.biogas_origin_proof` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.manure_application.external_equipment` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.manure_application.manure_type` | added | nicht vorhanden | `"enum(slurry&#124;urine&#124;biogas_slurry)"` | nicht deklariert | nein |
| `land.parcels[].operations.manure_application.method` | added | nicht vorhanden | `"enum(trailing_hose&#124;trailing_shoe&#124;injection)"` | nicht deklariert | nein |
| `land.parcels[].operations.manure_application.records_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.separation_event.date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].operations.separation_event.external_equipment` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.separation_event.mechanical_phase_separation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.separation_event.origin` | added | nicht vorhanden | `"enum(own_cattle&#124;external_cattle)"` | nicht deklariert | nein |
| `land.parcels[].operations.separation_event.records_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.separation_event.separated_liquid_m3` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].operations.separation_event.separation_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `livestock.species_groups[].annual_average_gve` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].feeding.all_animals_compliant` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.species_groups[].feeding.feeding_mode` | added | nicht vorhanden | `"enum(average&#124;phase)"` | nicht deklariert | nein |
| `livestock.species_groups[].feeding.phase_feeding_technically_plausible` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].feeding.proof_available` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.species_groups[].feeding.raw_protein_g_per_kg_dm_88_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `measure` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `participation.application_m3` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `participation.base_measure_valid` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `participation.categories[]` | added | nicht vorhanden | `"application"` | nicht deklariert | nein |
| `participation.contract_year_completed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `participation.groundwater_protection_pig_bonus` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `participation.measure_requested_by_december_31` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `participation.quantity_requested_by_november_30` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `participation.separated_m3` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `participation.transfer_case` | added | nicht vorhanden | `"enum(closure&#124;division&#124;merger&#124;other)"` | nicht deklariert | nein |
| `participation.withdrawal_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `pig_feeding.all_pigs_compliant` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `pig_feeding.average_limit_met` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `pig_feeding.feeding_mode` | added | nicht vorhanden | `"enum(average&#124;phase)"` | nicht deklariert | nein |
| `pig_feeding.gve_pigs_annual_average` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `pig_feeding.phase_feeding_technically_plausible` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `pig_feeding.phase_limit_met` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `pig_feeding.proof_available` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `pig_feeding.raw_protein_g_per_kg_dm_88_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `separation.date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `separation.external_equipment` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `separation.mechanical_phase_separation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `separation.origin` | added | nicht vorhanden | `"enum(own_cattle&#124;external_cattle)"` | nicht deklariert | nein |
| `separation.records_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `separation.records_include[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `separation.requested_m3` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `separation.separated_liquid_m3` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `separation.separated_m3` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `separation.separation_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_9-luna-high-20261002/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_9-luna-high-20261002/workspace/rules/citations.json).

## opus: `v2-o6_9-opus-5.5-high-20260925`

26 Vorschläge; Blattpfade: {'added': 63, 'removed': 0, 'changed': 1}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `documentation.separation_records_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.legal_form` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_person&#124;association_of_persons&#124;public_body)"` | nicht deklariert | nein |
| `farm.applicant.public_body_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul_first_participation_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].constraints.has_n_fertilization_need` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].constraints.in_national_park` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].constraints.total_fertilization_ban` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].crop.is_pure_legume_stand` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].district` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].operations.harvested_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.no_harvestable_crop_due_to_drought` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.pig_feeding.all_pigs_covered` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.pig_feeding.phase_feeding_plausible` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.pig_feeding.rations[].animal_category` | added | nicht vorhanden | `"enum(piglet_8_32&#124;fattening_average&#124;fattening_32_60&#124;fattening_60_90&#124;fattening_from_90&#124;sow_gestating&#124;sow_lactating&#124;boar_from_50)"` | nicht deklariert | nein |
| `livestock.pig_feeding.rations[].crude_protein_g_per_kg_88dm` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.pig_feeding.rations[].feeding_mode` | added | nicht vorhanden | `"enum(average&#124;phase&#124;single)"` | nicht deklariert | nein |
| `livestock.pig_feeding.rations[].protein_value_source` | added | nicht vorhanden | `"enum(lab_analysis&#124;literature_standard&#124;manufacturer_declaration)"` | nicht deklariert | nein |
| `livestock.pig_feeding.recipe_evidence_available` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.species_groups[].average_animal_count` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].gve_annual_average` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].gve_key_category` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].kept_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.species_groups[].manure.application_technology` | changed | `"enum(broadcast&#124;trailing_hose&#124;trailing_shoe&#124;injection&#124;incorporation&#124;unknown)"` | `"enum(broadcast&#124;trailing_hose&#124;trailing_shoe&#124;injection&#124;incorporation&#124;swivel_distributor&#124;impact_plate_boom&#124;unknown)"` | `"enum(broadcast&#124;trailing_hose&#124;trailing_shoe&#124;injection&#124;incorporation&#124;unknown)"` | nein |
| `manure_management.applications[].area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `manure_management.applications[].crop_name` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `manure_management.applications[].date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `manure_management.applications[].equipment_source` | added | nicht vorhanden | `"enum(own&#124;external_service&#124;shared_purchase)"` | nicht deklariert | nein |
| `manure_management.applications[].manure_kind` | added | nicht vorhanden | `"enum(guelle&#124;jauche&#124;biogasguelle&#124;festmist&#124;festmist_mit_wasser&#124;other)"` | nicht deklariert | nein |
| `manure_management.applications[].parcel_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `manure_management.applications[].parcel_ids[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `manure_management.applications[].technique` | added | nicht vorhanden | `"enum(trailing_hose&#124;trailing_shoe&#124;injection&#124;swivel_distributor&#124;impact_plate_boom&#124;broadcast&#124;incorporation&#124;unknown)"` | nicht deklariert | nein |
| `manure_management.applications[].volume_m3` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `manure_management.applications[].volume_m3_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `manure_management.biogas_excluded_components_present[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `manure_management.biogas_inputs[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `manure_management.declared_volumes.declared_on` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `manure_management.declared_volumes.injection_m3` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `manure_management.declared_volumes.separation_m3` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `manure_management.declared_volumes.trailing_hose_m3` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `manure_management.declared_volumes.trailing_shoe_m3` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `manure_management.evidence.biogas_input_evidence_available` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `manure_management.evidence.external_separator_invoices_available` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `manure_management.evidence.external_service_invoices_available` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `manure_management.evidence.shared_equipment_inspectable` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `manure_management.evidence.shared_equipment_invoice_to_participants` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `manure_management.evidence.shared_separator_inspectable` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `manure_management.evidence.shared_separator_invoice_to_participants` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `manure_management.separations[].date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `manure_management.separations[].equipment_source` | added | nicht vorhanden | `"enum(own&#124;external_service&#124;shared_purchase)"` | nicht deklariert | nein |
| `manure_management.separations[].phases_separated_mechanically` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `manure_management.separations[].separator_type` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `manure_management.separations[].slurry_origin` | added | nicht vorhanden | `"enum(own_cattle&#124;external&#124;other_species)"` | nicht deklariert | nein |
| `manure_management.separations[].volume_m3` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `oepul_applications[].applied_on` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `oepul_applications[].component` | added | nicht vorhanden | `"enum(measure&#124;n_reduced_pig_feeding&#124;n_reduced_pig_feeding_supplement&#124;other)"` | nicht deklariert | nein |
| `oepul_applications[].contract_start_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `oepul_applications[].lapsed_in_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `oepul_applications[].measure_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `oepul_applications[].takeover_reason` | added | nicht vorhanden | `"enum(farm_dissolution&#124;farm_division&#124;farm_merger&#124;other&#124;null)"` | nicht deklariert | nein |
| `oepul_applications[].withdrawn_on` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_9-opus-5.5-high-20260925/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_9-opus-5.5-high-20260925/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
