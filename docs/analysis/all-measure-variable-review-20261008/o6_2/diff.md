# o6_2: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_2-luna-high-20260930`

23 Vorschläge; Blattpfade: {'added': 56, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `application_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.compliance.external_n_fertilizer_kg` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.compliance.livestock_n_kg_per_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.compliance.purchase_storage_records_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.forage_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.input_inventory[].crop_scope` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `farm.input_inventory[].documentation_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.input_inventory[].input_type` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.input_inventory[].is_prohibited` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.input_inventory[].quantity` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.measures[].application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.measures[].application_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.measures[].contract_start_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.measures[].measure` | added | nicht vorhanden | `"o6_2"` | nicht deklariert | nein |
| `farm.measures[].participates` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.payment_components[].amount_eur_per_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.payment_components[].component` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.training.biodiversity_hours` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.training.completed_by` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.training.course_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.training.double_counted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.training.hours` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.training.provider_approved` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.training.trained_person_departure_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.measure_area_current_year` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.measure_area_previous_year` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].code` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].combined_area_payments_eur_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].crop.planting_material_quality` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].crop.second_crop` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].late_summer_or_autumn_harvest_crop` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].no_harvestable_stand_due_to_drought` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer.source` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_applications[].bio_allowed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_applications[].broad_application` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_applications[].individual_plant_treatment` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.seed_treatment` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.species_groups[].category_code` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].holding_country` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `program.change_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `program.o6_1a.participates` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `program.o6_1b.partial_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `program.o6_1b.participates` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `program.o6_2.application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `program.o6_2.application_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `program.o6_2.participates` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `program.target_measure` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `region.country` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `region.district` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `region.federal_state` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `region.is_mountain_area` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `region.is_protected_area` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `region.municipality` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `region.nUTS` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `region.water_protection_zone` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_2-luna-high-20260930/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_2-luna-high-20260930/workspace/rules/citations.json).

## opus: `v2-o6_2-opus-5.5-high-20260930`

26 Vorschläge; Blattpfade: {'added': 72, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.oepul.applicant_type` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_person&#124;association&#124;public_body)"` | nicht deklariert | nein |
| `farm.oepul.bio_partial_farm.bio_culture_area` | added | nicht vorhanden | `"enum(arable_grassland&#124;wine_fruit_hop&#124;null)"` | nicht deklariert | nein |
| `farm.oepul.bio_partial_farm.is_partial_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.first_oepul_participation_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_2.application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_2.area_reduction_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_2.committed_area_2025_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_2.contract_start_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_2.exit.exit_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_2.exit.reason` | added | nicht vorhanden | `"enum(none&#124;voluntary&#124;loss_of_control&#124;farm_transfer&#124;revision_clause_refusal&#124;permanent_circumstances)"` | nicht deklariert | nein |
| `farm.oepul.o6_2.new_area_additions_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_2.payment_application_missing_over_one_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_2.payment_application_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_2.previous_year_committed_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_2.sanction.full_reductions_in_contract_period` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.oepul.o6_2.sanction.level` | added | nicht vorhanden | `"enum(warning&#124;reduction_2&#124;reduction_5&#124;reduction_10&#124;reduction_25&#124;reduction_50&#124;reduction_100&#124;exclusion&#124;null)"` | nicht deklariert | nein |
| `farm.oepul.o6_2.switched_to_bio_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_2.takeover.extension_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_2.takeover.takeover_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_2.takeover.taker_previously_participating` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.on_site_control_refused` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.operating_supplies[].category` | added | nicht vorhanden | `"enum(fertilizer&#124;psm)"` | nicht deklariert | nein |
| `farm.oepul.operating_supplies[].external_origin` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.operating_supplies[].input_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.oepul.operating_supplies[].organic_approved_only` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.operating_supplies[].psm_permitted_in_other_crops` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.operating_supplies[].purchased` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.operating_supplies[].quantity_plausible` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.operating_supplies[].records_available` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.operating_supplies[].stored` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.participating_measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.oepul.public_body_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.trainings[].attendee_left_farm_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.trainings[].attendee_role` | added | nicht vorhanden | `"enum(applicant&#124;involved_farm_person&#124;other)"` | nicht deklariert | nein |
| `farm.oepul.trainings[].credited_to_other_commitment` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.trainings[].credited_to_other_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.trainings[].date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `farm.oepul.trainings[].hours` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.trainings[].provider_recognized` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.trainings[].topic` | added | nicht vorhanden | `"enum(nitrogen_fertilisation&#124;adapted_grassland_use_frequency&#124;biodiversity&#124;other)"` | nicht deklariert | nein |
| `land.parcels[].crop.forage_as_second_crop` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].crop.glaez8_npf` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].crop.non_eligible_type` | added | nicht vorhanden | `"enum(protected_cultivation&#124;vine_nursery&#124;tree_nursery&#124;energy_wood&#124;catkin_production&#124;fallow_not_active&#124;other_area&#124;glaez_landscape_element&#124;null)"` | nicht deklariert | nein |
| `land.parcels[].crop.usually_harvested_late_summer_or_autumn` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].district` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].federal_state` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].fruit_quality_planting_material` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].is_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].land_use_code` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].national_park` | added | nicht vorhanden | `"enum(neusiedlersee&#124;donau_auen&#124;kalkalpen&#124;other&#124;null)"` | nicht deklariert | nein |
| `land.parcels[].oepul_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer.inputs[].contains_n` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer.inputs[].external_origin` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer.inputs[].input_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer.inputs[].is_return_of_delivered_slurry` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.full_area_grazing` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.harvested_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.mowing_material_removed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.no_harvestable_crop_due_to_drought` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_applications[].application_mode` | added | nicht vorhanden | `"enum(broadcast&#124;seed_treatment&#124;single_plant)"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_applications[].organic_approved_only` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.psm_applications[].product_name` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].other_area_payments_eur_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].parcel_measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].previous_land_use_code` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].transferred_during_year_without_continuation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.nitrogen.manure_offtake_contract_n_kg` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `livestock.nitrogen.n_after_stall_storage_losses_kg` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `livestock.nitrogen.n_on_alm_or_community_pasture_kg` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].count_method` | added | nicht vorhanden | `"enum(cattle_database_daily_average&#124;reference_date_april_1&#124;average_animal_list)"` | nicht deklariert | nein |
| `livestock.species_groups[].held_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.species_groups[].rgve_key_id` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_2-opus-5.5-high-20260930/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_2-opus-5.5-high-20260930/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
