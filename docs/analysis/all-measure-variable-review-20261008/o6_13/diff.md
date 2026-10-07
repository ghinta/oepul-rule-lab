# o6_13: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_13-luna-high-20261004`

6 Vorschläge; Blattpfade: {'added': 33, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.measure_application.contract_year` | added | nicht vorhanden | `2026` | nicht deklariert | nein |
| `farm.measure_application.drought_no_harvestable_stock` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.measure_application.first_participation` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `farm.measure_application.requested` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.measure_application.submitted_by` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `farm.measure_application.withdrawal_date` | added | nicht vorhanden | `null` | nicht deklariert | nein |
| `farm.operation_program.member` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.operation_program.organism_use_compensated` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `farm.region.country` | added | nicht vorhanden | `"AT"` | nicht deklariert | nein |
| `land.parcels[].measure_application.code` | added | nicht vorhanden | `"NUE"` | nicht deklariert | nein |
| `land.parcels[].measure_application.crop_is_late_summer_or_autumn` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].measure_application.harvested_percent` | added | nicht vorhanden | `100` | nicht deklariert | nein |
| `land.parcels[].measure_application.other_premium` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].measure_application.proper_annual_care` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].measure_application.proper_cultivation` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].measure_application.requested` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].organism_application.ages_register_entry` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].organism_application.application_rate_compliant` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].organism_application.date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].organism_application.goal` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].organism_application.is_pollinator_only` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].organism_application.organism_type` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].organism_application.purchase_evidence` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].organism_application.quantity` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].organism_application.reason` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].organism_application.replaces_plant_protection_use` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].protected_cultivation.active_production` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].protected_cultivation.aisle_necessary` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].protected_cultivation.area_role` | added | nicht vorhanden | `"production"` | nicht deklariert | nein |
| `land.parcels[].protected_cultivation.classification_medium_april_1` | added | nicht vorhanden | `"grown_soil"` | nicht deklariert | nein |
| `land.parcels[].protected_cultivation.cultivation_medium` | added | nicht vorhanden | `"grown_soil"` | nicht deklariert | nein |
| `land.parcels[].protected_cultivation.is_protected_cultivation` | added | nicht vorhanden | `true` | nicht deklariert | nein |
| `land.parcels[].protected_cultivation.structure_type` | added | nicht vorhanden | `"fixed_greenhouse_glass"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_13-luna-high-20261004/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_13-luna-high-20261004/workspace/rules/citations.json).

## opus: `v2-o6_13-opus-5.5-high-20260926`

23 Vorschläge; Blattpfade: {'added': 76, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.applicant.farms_in_own_name_and_account` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.has_agricultural_activity` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.has_control_over_declared_areas` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_public_body` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.legal_form` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_person&#124;association_of_persons)"` | nicht deklariert | nein |
| `farm.applicant.public_body_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.first_participation_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_13.admin_check_result_notified_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_13.compliance.hundred_percent_reductions_in_contract_period` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.oepul.o6_13.compliance.sanction_stage` | added | nicht vorhanden | `"enum(none&#124;warning&#124;reduction_2&#124;reduction_5&#124;reduction_10&#124;reduction_25&#124;reduction_50&#124;reduction_100&#124;exclusion)"` | nicht deklariert | nein |
| `farm.oepul.o6_13.contract_active_previous_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_13.entry_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_13.excluded_from_measure` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_13.measure_application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_13.member_of_producer_organisation_with_op_covering_organisms` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_13.mfa_submitted_previous_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_13.nue_used_previous_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_13.on_site_check_announced_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_13.takeover.approved_by_ama` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_13.takeover.extension_to_other_areas_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_13.takeover.request_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_13.takeover.taken_over_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_13.takeover.taker_already_participating` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_13.withdrawal.declared_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_13.withdrawal.declared_online_in_mfa` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_13.withdrawn_previous_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.minimum_size_additional_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].actively_managed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].area_type` | added | nicht vorhanden | `"enum(standard&#124;energy_wood_short_rotation&#124;pussy_willow_production&#124;vine_nursery&#124;tree_nursery&#124;not_actively_managed&#124;other_area&#124;not_mainly_agricultural&#124;gloez_landscape_element)"` | nicht deklariert | nein |
| `land.parcels[].beneficial_organism_applications[].applied_at_register_rate` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].beneficial_organism_applications[].covers_entire_area` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].beneficial_organism_applications[].date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].beneficial_organism_applications[].listed_in_psm_register` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].beneficial_organism_applications[].organism_species` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].beneficial_organism_applications[].purchase_receipt_available` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].beneficial_organism_applications[].quantity` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].beneficial_organism_applications[].quantity_unit` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].beneficial_organism_applications[].reason` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].beneficial_organism_applications[].replaces_psm_use` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].beneficial_organism_applications[].target` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].beneficial_organism_applications[].use_type` | added | nicht vorhanden | `"enum(plant_protection&#124;bumblebee_pollination&#124;other)"` | nicht deklariert | nein |
| `land.parcels[].correctly_identified` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].drought.crop_usually_harvested_late_summer_or_autumn` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].drought.no_harvestable_crop_due_to_drought` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].force_majeure_recognised` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].funding_overlap.official_compensation_area` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].funding_overlap.other_public_funding_same_service` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].funding_overlap.statutory_or_official_requirement` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].located_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | ja |
| `land.parcels[].minimum_management.annual_care` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].minimum_management.harvested_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].minimum_management.properly_cultivated` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].national_park` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].national_park_relevant_restrictions` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].non_compliance_due_to_third_party_fault` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].op_measure_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].other_measures_on_parcel[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].protected_cultivation.covering_material` | added | nicht vorhanden | `"enum(glass&#124;foil&#124;plastic&#124;none)&#124;null"` | nicht deklariert | nein |
| `land.parcels[].protected_cultivation.display_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].protected_cultivation.excess_path_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].protected_cultivation.field_use_type` | added | nicht vorhanden | `"enum(A&#124;GA&#124;other)"` | nicht deklariert | nein |
| `land.parcels[].protected_cultivation.growing_system` | added | nicht vorhanden | `"enum(grown_soil&#124;pots&#124;substrate&#124;containers&#124;alternating)"` | nicht deklariert | nein |
| `land.parcels[].protected_cultivation.growing_system_on_april_1` | added | nicht vorhanden | `"enum(grown_soil&#124;pots&#124;substrate&#124;containers)&#124;null"` | nicht deklariert | nein |
| `land.parcels[].protected_cultivation.is_other_protected_area` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].protected_cultivation.necessary_path_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].protected_cultivation.sales_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].protected_cultivation.storage_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].protected_cultivation.structure_id` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].protected_cultivation.structure_type` | added | nicht vorhanden | `"enum(fixed_greenhouse&#124;unfixed_foil_tunnel&#124;none)"` | nicht deklariert | nein |
| `land.parcels[].protected_cultivation.unused_area_between_structures_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].records.kept_per_parcel` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].transfer.successor_continues_same_or_higher_measure` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].transfer.transferred_during_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_13-opus-5.5-high-20260926/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_13-opus-5.5-high-20260926/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
