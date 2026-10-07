# o6_3: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_3-luna-high-20261001`

23 Vorschläge; Blattpfade: {'added': 30, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.heuwirtschaft.application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.heuwirtschaft.contract_start_year` | added | nicht vorhanden | `"int"` | nicht deklariert | ja |
| `farm.heuwirtschaft.current_rgve_density` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.heuwirtschaft.drought_exception_area` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.heuwirtschaft.eligible_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.heuwirtschaft.feed_fermentation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | ja |
| `farm.heuwirtschaft.first_year.fodder_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | ja |
| `farm.heuwirtschaft.first_year.mown_meadow_meadow_pasture_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | ja |
| `farm.heuwirtschaft.first_year.rgve_total` | added | nicht vorhanden | `"number"` | nicht deklariert | ja |
| `farm.heuwirtschaft.green_feeding_majority_april_to_september` | added | nicht vorhanden | `"boolean"` | nicht deklariert | ja |
| `farm.heuwirtschaft.measure` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.heuwirtschaft.mower_conditioner_present` | added | nicht vorhanden | `"boolean"` | nicht deklariert | ja |
| `farm.heuwirtschaft.mower_conditioner_used` | added | nicht vorhanden | `"boolean"` | nicht deklariert | ja |
| `farm.heuwirtschaft.no_harvestable_stand` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.heuwirtschaft.no_mower_conditioner_option` | added | nicht vorhanden | `"boolean"` | nicht deklariert | ja |
| `farm.heuwirtschaft.option_application_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.heuwirtschaft.participation.combined_measure` | added | nicht vorhanden | `"enum(o6_1a&#124;o6_1b&#124;o6_1b_teilbetrieb)"` | nicht deklariert | ja |
| `farm.heuwirtschaft.prior_year_was_tierholding` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.heuwirtschaft.silage_preparation_and_feeding` | added | nicht vorhanden | `"boolean"` | nicht deklariert | ja |
| `farm.heuwirtschaft.silage_storage` | added | nicht vorhanden | `"boolean"` | nicht deklariert | ja |
| `farm.heuwirtschaft.third_party_cuttings_only_dry_hay` | added | nicht vorhanden | `"boolean"` | nicht deklariert | ja |
| `farm.heuwirtschaft.year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.parcels[].oepul.country` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul.crop_category` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.crop_name` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.grassland_type` | added | nicht vorhanden | `"enum(mähwiese&#124;mähweide&#124;streuwiese&#124;bergmähder&#124;other&#124;null)"` | nicht deklariert | nein |
| `land.parcels[].oepul.is_applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.is_premium_eligible` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.is_second_crop` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.measure` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_3-luna-high-20261001/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_3-luna-high-20261001/workspace/rules/citations.json).

## opus: `v2-o6_3-opus-5.5-high-20260930`

34 Vorschläge; Blattpfade: {'added': 65, 'removed': 0, 'changed': 1}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.applicant.is_active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_public_body` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.legal_form` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_entity&#124;association)"` | nicht deklariert | nein |
| `farm.applicant.public_body_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.feeding.feedstuffs[].feed_id` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `farm.feeding.feedstuffs[].fermentation_in_production` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.feeding.feedstuffs[].name` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.feeding.green_feeding.all_roughage_animals_included` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.feeding.green_feeding.communal_pasture_or_alm_days_apr_sep` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.feeding.green_feeding.eingrasen_or_pasture_days_apr_sep` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.feeding.green_forage_fermentation_occurred` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.feeding.haylage_or_fermented_hay_produced` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.feeding.non_storable_without_foil_pressed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.feeding.own_silage_stock_used_after_contract_start` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.feeding.silage_fed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.feeding.silage_produced` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.feeding.silage_stored` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.forage_transfers[].form` | added | nicht vorhanden | `"enum(dry_hay&#124;green_forage&#124;wilted_forage&#124;silage&#124;haylage)"` | nicht deklariert | nein |
| `farm.forage_transfers[].indicates_silage_use` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.forage_transfers[].one_time_tedding_then_removed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.forage_transfers[].recipient_is_hay_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.machinery.mower_conditioner_present` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.machinery.mower_conditioner_used` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.control_refused` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.first_participation_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.force_majeure.cause` | added | nicht vorhanden | `"enum(drought_2026&#124;other&#124;null)"` | nicht deklariert | nein |
| `farm.oepul.force_majeure.obligations_not_maintainable` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.force_majeure.recognised` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_3.area_change.base_2025_grassland_measure_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_3.area_change.current_grassland_measure_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_3.area_change.decrease_loss_of_disposal_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_3.area_change.decrease_permitted_conversion_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_3.area_change.previous_year_grassland_measure_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_3.contract_start_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_3.exit.exit_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_3.exit.exited` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_3.exit.force_majeure_or_exceptional_circumstances_recognised` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_3.hundred_percent_reductions_in_contract_period` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.oepul.o6_3.measure_application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_3.option_no_mower_conditioner.applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_3.option_no_mower_conditioner.marked_in_mfa_details` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_3.payment_application_missing_over_one_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_3.payment_application_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_3.takeover.extension_share` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_3.takeover.is_takeover` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_3.takeover.takeover_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_3.takeover.taker_already_participating` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.participating_measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].crop.forage_crop_type` | added | nicht vorhanden | `"enum(futtergraeser&#124;wechselwiese&#124;kleegras&#124;klee&#124;luzerne&#124;sonstiges_feldfutter&#124;ackerweide&#124;null)"` | nicht deklariert | ja |
| `land.parcels[].crop.is_second_crop` | added | nicht vorhanden | `"boolean"` | nicht deklariert | ja |
| `land.parcels[].enrolled_measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].grassland_type` | added | nicht vorhanden | `"enum(maehwiese_maehweide&#124;streuwiese&#124;bergmaehder&#124;dauerweide&#124;hutweide&#124;other&#124;null)"` | nicht deklariert | ja |
| `land.parcels[].located_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | ja |
| `land.parcels[].national_park.has_relevant_management_restrictions` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].national_park.name` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].non_eligible_area_type` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].op_measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].operations.grazed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.mown_previous_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].other_capped_oepul_payments_eur_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.species_groups[].average_count` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].kept_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.species_groups[].rgve_category` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].species` | changed | `"enum(cattle&#124;pigs&#124;sheep_goats&#124;horses&#124;poultry&#124;rabbits&#124;other)"` | `"enum(cattle&#124;pigs&#124;sheep_goats&#124;horses&#124;poultry&#124;rabbits&#124;deer&#124;new_world_camelids&#124;other)"` | `"enum(cattle&#124;pigs&#124;sheep_goats&#124;horses&#124;poultry&#124;rabbits&#124;other)"` | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_3-opus-5.5-high-20260930/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_3-opus-5.5-high-20260930/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
