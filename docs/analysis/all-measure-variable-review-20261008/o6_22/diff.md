# o6_22: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_22-luna-high-20261005`

1 Vorschläge; Blattpfade: {'added': 78, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `livestock.o6_22.animals_kept_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.annual_average_gve` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `livestock.o6_22.application.application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `livestock.o6_22.application.measure_takeover` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.application.requested_categories[].category` | added | nicht vorhanden | `"enum(piglets&#124;growers_and_fattening_pigs&#124;breeding_sows_and_mated_gilts)"` | nicht deklariert | nein |
| `livestock.o6_22.application.requested_supplements[].supplement` | added | nicht vorhanden | `"enum(uncut&#124;protein_feed&#124;solid_manure_compost)"` | nicht deklariert | nein |
| `livestock.o6_22.applied_heads` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `livestock.o6_22.bedded_system` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.category` | added | nicht vorhanden | `"enum(piglets&#124;growers_and_fattening_pigs&#124;breeding_sows_and_mated_gilts)"` | nicht deklariert | nein |
| `livestock.o6_22.conditions_met_continuously_from_eligible_weight` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.deregistered_heads` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `livestock.o6_22.eligible_gve` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.o6_22.eligible_pig_gve` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.o6_22.free_range.actual_gve_per_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.o6_22.free_range.all_animals_can_lie_simultaneously` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.free_range.authority_max_gve_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `livestock.o6_22.free_range.continuous_use_years` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.o6_22.free_range.documentation[].animal_count` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `livestock.o6_22.free_range.documentation[].end_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `livestock.o6_22.free_range.documentation[].parcel_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `livestock.o6_22.free_range.documentation[].start_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `livestock.o6_22.free_range.documentation_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.free_range.farrowing_huts_available` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.free_range.feed_and_water_separated` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.free_range.feed_on_hard_surface_or_moved_regularly` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.free_range.feed_roofed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.free_range.roofed_three_sided_bedded_shelter` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.free_range.wild_boar_exclusion` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.group_is_homogeneous` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.housing_mode` | added | nicht vorhanden | `"enum(stall&#124;free_range&#124;combined)"` | nicht deklariert | nein |
| `livestock.o6_22.individual_housing_days` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `livestock.o6_22.measure` | added | nicht vorhanden | `"o6_22"` | nicht deklariert | nein |
| `livestock.o6_22.participation_gve` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.o6_22.reference_method` | added | nicht vorhanden | `"enum(april_1&#124;annual_average)"` | nicht deklariert | nein |
| `livestock.o6_22.reporting.animal_stock_reported` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.reporting.category_conditions_not_met` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.reporting.contract_year_completed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.reporting.deregistration_date_within_funding_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.reporting.eligible_animals_in_category` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `livestock.o6_22.reporting.pig_keeper` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.reporting.vis_movements_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.sick_or_injured` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.sow_type` | added | nicht vorhanden | `"enum(breeding_sows&#124;mated_gilts)"` | nicht deklariert | nein |
| `livestock.o6_22.stall.animals` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.o6_22.stall.bedded_area_m2` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.o6_22.stall.dry_bedded_area` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.stall.enrichment_continuously_available` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.stall.enrichment_material` | added | nicht vorhanden | `"enum(grass&#124;straw&#124;hay)"` | nicht deklariert | nein |
| `livestock.o6_22.stall.fixed_permanent_access` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.stall.group_housing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.stall.liquid_excreta_collectable` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.stall.perforation_percent` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.o6_22.stall.roof_over_lying_area` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.stall.three_sided_protection` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.stall.usable_area_m2` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.o6_22.statutory_group_housing_not_required` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.supplement_facts.all_farm_pigs_compliant` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.supplement_facts.all_farm_solid_manure_composted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.supplement_facts.all_participating_animals_uncut` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.supplement_facts.applies_to_whole_category` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.supplement_facts.compost_documentation_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.supplement_facts.compost_log_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.supplement_facts.compost_pile_installed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.supplement_facts.compost_requested` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.supplement_facts.compost_stall` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.supplement_facts.compost_turn_count` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `livestock.o6_22.supplement_facts.compost_turn_interval_days` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.o6_22.supplement_facts.composter_on_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.supplement_facts.composting_process_applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.supplement_facts.inter_farm_use_documented` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.supplement_facts.nitrate_action_program_compliant` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.supplement_facts.no_noncompliant_protein_feed_storage_or_feeding` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.supplement_facts.organic_mix_present` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.supplement_facts.protein_feed_evidence_available` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.supplement_facts.protein_requested` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.supplement_facts.uncut_requested` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.o6_22.weight_band` | added | nicht vorhanden | `"enum(up_to_20_kg&#124;up_to_32_kg&#124;up_to_50_kg&#124;up_to_85_kg&#124;over_85_kg)"` | nicht deklariert | nein |
| `livestock.o6_22.year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_22-luna-high-20261005/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_22-luna-high-20261005/workspace/rules/citations.json).

## opus: `v2-o6_22-opus-5.5-high-20260928`

40 Vorschläge; Blattpfade: {'added': 90, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.applicant.carries_out_agricultural_activity` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.farm_managed_in_own_name_and_account` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_public_body` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.legal_form` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_person&#124;association)"` | nicht deklariert | nein |
| `farm.applicant.public_body_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.control_refused` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.first_participation_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.average_animal_list_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.species_groups[].average_animal_count` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].average_live_weight_kg` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.pasture.continuous_use_months` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.pasture.documentation_per_plot_complete` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.pasture.double_fence_or_solid_enclosure` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.pasture.farrowing_huts_available` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.pasture.feeding_and_watering_paved_or_relocated` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.pasture.feeding_and_watering_separated` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.pasture.feeding_place_roofed` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.pasture.rotation_total_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.pasture.shelter_all_animals_lie_simultaneously` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.pasture.shelter_littered` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.pasture.shelter_roofed` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.pasture.shelter_three_sided_closed` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.pasture.unpaved_area_declared_as_other_land` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.pasture.water_permit_max_gve_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.stall.enclosed_sides` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.stall.enrichment_material` | added | nicht vorhanden | `"enum(grass&#124;straw&#124;hay&#124;other&#124;none&#124;unknown)"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.stall.floor_liquid_tight` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.stall.floor_paved` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.stall.is_open_stall` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.stall.liquid_manure_container` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.stall.litter_material` | added | nicht vorhanden | `"enum(straw&#124;straw_pellets&#124;hay&#124;hay_pellets&#124;sawdust&#124;ground_corn_cobs&#124;ground_elephant_grass&#124;rock_flour&#124;other&#124;null)"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.stall.lying_area_dry` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.stall.lying_area_perforation_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.stall.lying_area_roofed` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.stall.minimal_litter` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.stall.outdoor_run_permanently_accessible` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.stall.paved_outdoor_run_area_m2` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].housing.stall.seepage_drain_to_pit` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].is_wild_boar` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.species_groups[].kept_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.species_groups[].pig_welfare.compliant_throughout_holding_period` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.species_groups[].pig_welfare.group_housing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.species_groups[].pig_welfare.single_housing.documented` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].pig_welfare.single_housing.littered` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].pig_welfare.single_housing.max_days` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].pig_welfare.single_housing.reason` | added | nicht vorhanden | `"enum(illness_or_injury&#124;other&#124;null)"` | nicht deklariert | nein |
| `livestock.species_groups[].pig_welfare.sow_phase` | added | nicht vorhanden | `"enum(empty_or_pregnant&#124;farrowing_or_suckling&#124;null)"` | nicht deklariert | nein |
| `livestock.species_groups[].tail_docked` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.species_groups[].tierliste_category` | added | nicht vorhanden | `"enum(ferkel_8_20&#124;ferkel_20_32&#124;jungschweine_32_50&#124;mastschweine_50_80&#124;mastschweine_80_110&#124;mastschweine_ab_110&#124;jungsauen_nicht_gedeckt_ab_50&#124;jungsauen_gedeckt_ab_50&#124;aeltere_sauen_nicht_gedeckt_ab_50&#124;aeltere_sauen_gedeckt_ab_50&#124;zuchteber_ab_50&#124;null)"` | nicht deklariert | nein |
| `oepul_application.o6_22.animal_health_service.from` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_application.o6_22.animal_health_service.participating` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_application.o6_22.animal_health_service.proof_available` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `oepul_application.o6_22.animal_health_service.to` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_application.o6_22.category_applications[].applied_on` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `oepul_application.o6_22.category_applications[].first_commitment_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `oepul_application.o6_22.category_applications[].measure_category` | added | nicht vorhanden | `"enum(ferkel&#124;jung_mastschweine&#124;zuchtsauen)"` | nicht deklariert | nein |
| `oepul_application.o6_22.deregistrations[].average_count` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `oepul_application.o6_22.deregistrations[].measure_category` | added | nicht vorhanden | `"enum(ferkel&#124;jung_mastschweine&#124;zuchtsauen)"` | nicht deklariert | nein |
| `oepul_application.o6_22.deregistrations[].notified_immediately` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_application.o6_22.gvo_free_protein_feed.all_protein_feed_gvo_free_european` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `oepul_application.o6_22.gvo_free_protein_feed.non_compliant_protein_feed_stored_or_fed` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `oepul_application.o6_22.gvo_free_protein_feed.purchase_proofs_available` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `oepul_application.o6_22.solid_manure_composting.all_solid_manure_composted_on_farm` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `oepul_application.o6_22.solid_manure_composting.compost_stall_system` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `oepul_application.o6_22.solid_manure_composting.documentation_complete` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `oepul_application.o6_22.solid_manure_composting.nitrate_action_programme_compliant` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `oepul_application.o6_22.solid_manure_composting.windrows[].complete_turning` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `oepul_application.o6_22.solid_manure_composting.windrows[].composting_process_applied` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `oepul_application.o6_22.solid_manure_composting.windrows[].equipment_owned_or_use_documented` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `oepul_application.o6_22.solid_manure_composting.windrows[].method` | added | nicht vorhanden | `"enum(turned&#124;mixed_or_layered&#124;unturned_with_additives)"` | nicht deklariert | nein |
| `oepul_application.o6_22.solid_manure_composting.windrows[].plant_material_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `oepul_application.o6_22.solid_manure_composting.windrows[].straw_rich_manure_only` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `oepul_application.o6_22.solid_manure_composting.windrows[].turn_dates[]` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `oepul_application.o6_22.solid_manure_composting.windrows[].turning_equipment` | added | nicht vorhanden | `"enum(compost_turner&#124;manure_spreader&#124;equivalent_device&#124;front_loader&#124;none)"` | nicht deklariert | nein |
| `oepul_application.o6_22.solid_manure_composting.windrows[].windrow_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `oepul_application.o6_22.stall_sketch_and_occupancy_plan_available` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `oepul_application.o6_22.supplement_applications[].applied_on` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `oepul_application.o6_22.supplement_applications[].first_commitment_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `oepul_application.o6_22.supplement_applications[].measure_category` | added | nicht vorhanden | `"enum(ferkel&#124;jung_mastschweine&#124;zuchtsauen)&#124;null"` | nicht deklariert | nein |
| `oepul_application.o6_22.supplement_applications[].supplement` | added | nicht vorhanden | `"enum(unkupiert&#124;gvo_frei_eiweiss&#124;festmistkompostierung)"` | nicht deklariert | nein |
| `oepul_application.o6_22.takeover.animals_and_areas_from_same_previous_farm` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `oepul_application.o6_22.takeover.is_takeover` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_application.o6_22.takeover.reason` | added | nicht vorhanden | `"enum(dissolution&#124;division&#124;merger&#124;other&#124;null)"` | nicht deklariert | nein |
| `oepul_application.o6_22.vis_reporting_complete` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `oepul_application.o6_22.withdrawals[].measure_category` | added | nicht vorhanden | `"enum(ferkel&#124;jung_mastschweine&#124;zuchtsauen)&#124;null"` | nicht deklariert | nein |
| `oepul_application.o6_22.withdrawals[].notified_on` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `oepul_application.o6_22.withdrawals[].scope` | added | nicht vorhanden | `"enum(measure&#124;category&#124;supplement)"` | nicht deklariert | nein |
| `oepul_application.o6_22.withdrawals[].supplement` | added | nicht vorhanden | `"enum(unkupiert&#124;gvo_frei_eiweiss&#124;festmistkompostierung&#124;null)"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_22-opus-5.5-high-20260928/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_22-opus-5.5-high-20260928/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
