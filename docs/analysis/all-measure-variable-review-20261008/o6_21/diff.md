# o6_21: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_21-luna-high-20261005`

63 Vorschläge; Blattpfade: {'added': 66, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `documentation.records_available` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.all_eligible_animals_participating` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.animal_reported` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.animals[].animal_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.o6_21.animals[].category` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.o6_21.animals[].held_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.animals[].weight_kg` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.o6_21.animals_and_land_from_same_predecessor` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.application_submitted_by_december_31` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.average_fundable_rgve` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.o6_21.average_fundable_rgve_source` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.o6_21.calf_social_contact` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.calves_under_21_days_individually_housed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.category_fundable_animal_count` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.o6_21.compost.additional_organic_material_nondisregarded` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.compost.all_solid_manure_in_piles` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.compost.compost_barn` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.compost.composting_process` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.compost.minimum_interval_days` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.o6_21.compost.mode` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.o6_21.compost.napv_compliant` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.compost.records_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.compost.turning_equipment_available_or_proven` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.compost.turns` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.o6_21.compost_surcharge_requested` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.cow_count` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.o6_21.cow_group_area_calculated` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.departure_reported_in_cattle_database` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.exit_after_obligation_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.exit_submitted_online` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.fundable_rgve_total` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.o6_21.health_service_participation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.home_farm_stall_available` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.housing_periods_documented` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.individual_housing_days` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.o6_21.individual_housing_records_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.milk_delivery_to_dairy` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.minimum_participation_met` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.noncompliant_animals_count` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.o6_21.noncompliant_animals_reported_immediately` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.open_stall` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.overlap_with_alp_or_weide` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.participating_categories[]` | added | nicht vorhanden | `"male_from_half_year"` | nicht deklariert | nein |
| `farm.o6_21.qplus_rind_or_comparable` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.rgve_calculation_uses_age_pro_rata` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.shared_group` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.shared_group_area_calculated_for_all` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.stall.group_housing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.stall.hard_surface` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.stall.individual_housing_littered` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.stall.litter_depth_cm` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.o6_21.stall.littered_lying_area_percent` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.o6_21.stall.littered_system` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.stall.lying_area_m2_per_animal` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.o6_21.stall.lying_area_soft_and_dry` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.stall.open_stall_requirements_met` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.stall.perforation_percent` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.o6_21.stall.structural_requirements_met` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.stall.total_area_m2_per_animal` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.o6_21.stall.usable_area_definition_met` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.stall_sketch_and_occupancy_plan_available` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.o6_21.takeover_case` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.o6_21.year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.fodder_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.fodder_rgve` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `participation_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_21-luna-high-20261005/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_21-luna-high-20261005/workspace/rules/citations.json).

## opus: `v2-o6_21-opus-5.5-high-20260928`

11 Vorschläge; Blattpfade: {'added': 115, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.applicant.agricultural_activity` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.public_body_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.applicant.type` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_person&#124;association_of_persons&#124;public_body)"` | nicht deklariert | nein |
| `farm.dairy.direct_processing_and_marketing_only` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.dairy.milk_delivery_to_dairy` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.dairy.seasonal_alm_milk_delivery` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul_first_participation_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.programs.animal_health_service.from_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.programs.animal_health_service.participates` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.programs.animal_health_service.proof_requested_by_ama` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.programs.animal_health_service.proof_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.programs.animal_health_service.to_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.programs.animal_health_service.transmitted_by_service` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.programs.qplus_rind.from_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.programs.qplus_rind.participates` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.programs.qplus_rind.programme` | added | nicht vorhanden | `"enum(qplus_rind&#124;other)"` | nicht deklariert | nein |
| `farm.programs.qplus_rind.proof_requested_by_ama` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.programs.qplus_rind.proof_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.programs.qplus_rind.to_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.programs.qplus_rind.transmitted_by_service` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.suckler_cow_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.cattle_animals[].birth_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `livestock.cattle_animals[].breed` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `livestock.cattle_animals[].ear_tag` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `livestock.cattle_animals[].exit_reason` | added | nicht vorhanden | `"enum(slaughter&#124;sale&#124;death&#124;other_rdb_exit&#124;null)"` | nicht deklariert | nein |
| `livestock.cattle_animals[].housing.bedded_system` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.cattle_animals[].housing.conditions_breached_from` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `livestock.cattle_animals[].housing.full_slatted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.cattle_animals[].housing.group_housed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.cattle_animals[].housing.pen_id` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `livestock.cattle_animals[].housing.single_housing.bedded` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.cattle_animals[].housing.single_housing.calf_age_days_at_end` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `livestock.cattle_animals[].housing.single_housing.days` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `livestock.cattle_animals[].housing.single_housing.documented` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.cattle_animals[].housing.single_housing.reason` | added | nicht vorhanden | `"enum(illness&#124;injury&#124;calf&#124;other)"` | nicht deklariert | nein |
| `livestock.cattle_animals[].housing.single_housing.social_contact` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.cattle_animals[].housing.tethered` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.cattle_animals[].housing.year_round_outdoor_without_stall` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.cattle_animals[].is_dwarf_breed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.cattle_animals[].kept_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.cattle_animals[].o6_21_deregistered` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.cattle_animals[].on_farm_from` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `livestock.cattle_animals[].on_farm_until` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `livestock.cattle_animals[].other_support.alm_driven` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.cattle_animals[].other_support.coupled_support_alm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.cattle_animals[].other_support.tierwohl_weide_participation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.cattle_animals[].sex` | added | nicht vorhanden | `"enum(male&#124;female)"` | nicht deklariert | nein |
| `livestock.stall_buildings[].capacity_for_all_animals` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.stall_buildings[].floor_fixed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.stall_buildings[].floor_material` | added | nicht vorhanden | `"enum(concrete&#124;asphalt&#124;slatted&#124;gravel&#124;clay&#124;other)"` | nicht deklariert | nein |
| `livestock.stall_buildings[].liquid_manure_container` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.stall_buildings[].liquid_manure_occurs` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.stall_buildings[].liquid_tight_floor` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.stall_buildings[].roof_over_lying_places` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.stall_buildings[].seepage_drain_to_collection_pit` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.stall_buildings[].solid_roof_over_lying_area` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.stall_buildings[].stall_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `livestock.stall_buildings[].system` | added | nicht vorhanden | `"enum(closed&#124;open)"` | nicht deklariert | nein |
| `livestock.stall_buildings[].three_sided_enclosure` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.stall_pens[].all_animals_over_6_months_have_cubicle` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.stall_pens[].bedded_lying_area_m2` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.stall_pens[].calf_creep.bedded_lying_area_m2` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.stall_pens[].calf_creep.occupants[].count` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `livestock.stall_pens[].calf_creep.occupants[].kind` | added | nicht vorhanden | `"enum(young_cattle)"` | nicht deklariert | nein |
| `livestock.stall_pens[].calf_creep.occupants[].weight_kg` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.stall_pens[].calves_have_additional_lying_place` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.stall_pens[].counted_area_fixed_and_permanently_accessible` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.stall_pens[].cubicle_loose_housing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.stall_pens[].litter_absorbent_and_soft` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.stall_pens[].litter_depth_cm` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `livestock.stall_pens[].littered` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.stall_pens[].lying_area_perforation_percent` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.stall_pens[].lying_area_soft_and_dry` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.stall_pens[].lying_surface` | added | nicht vorhanden | `"enum(soft_plastic_or_rubber&#124;hard_rubber&#124;fixed_surface)"` | nicht deklariert | nein |
| `livestock.stall_pens[].occupants[].count` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `livestock.stall_pens[].occupants[].kind` | added | nicht vorhanden | `"enum(young_cattle&#124;cow)"` | nicht deklariert | nein |
| `livestock.stall_pens[].occupants[].weight_kg` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `livestock.stall_pens[].pen_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `livestock.stall_pens[].stall_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `livestock.stall_pens[].subareas_closed_off_outside_routine_work` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.stall_pens[].tschg_minimum_met` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.stall_pens[].usable_total_area_m2` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `oepul.controls.force_majeure_or_exceptional` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.controls.inspection_refused` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_21.applications[].first_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `oepul.o6_21.applications[].item` | added | nicht vorhanden | `"enum(male_lt_half_year&#124;male_ge_half_year&#124;female_lt_half_year&#124;female_half_to_2_years&#124;festmistkompostierung)"` | nicht deklariert | nein |
| `oepul.o6_21.applications[].late_reapplication_after_lapse` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_21.applications[].submitted_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `oepul.o6_21.applications[].written_request_to_ama` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_21.applied_categories[]` | added | nicht vorhanden | `"enum(male_lt_half_year&#124;male_ge_half_year&#124;female_lt_half_year&#124;female_half_to_2_years)"` | nicht deklariert | nein |
| `oepul.o6_21.composting.all_solid_manure_in_windrows_on_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_21.composting.compost_barn` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_21.composting.documented_items[]` | added | nicht vorhanden | `"enum(setup&#124;turning&#124;spreading_or_transfer_to_third_parties)"` | nicht deklariert | nein |
| `oepul.o6_21.composting.napv_compliant` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_21.composting.windrows[].composting_process_applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_21.composting.windrows[].device_on_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_21.composting.windrows[].external_use_documented` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_21.composting.windrows[].full_turnover_ensured` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_21.composting.windrows[].method` | added | nicht vorhanden | `"enum(turned&#124;mixed_layered&#124;turn_free_with_admixture)"` | nicht deklariert | nein |
| `oepul.o6_21.composting.windrows[].organic_material_admixture_substantial` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_21.composting.windrows[].plant_materials[]` | added | nicht vorhanden | `"enum(crop_residues&#124;straw&#124;green_cuttings&#124;shrub_cuttings&#124;branch_material)"` | nicht deklariert | nein |
| `oepul.o6_21.composting.windrows[].straw_rich_manure_only` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_21.composting.windrows[].turning_dates[]` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `oepul.o6_21.composting.windrows[].turning_device` | added | nicht vorhanden | `"enum(compost_turner&#124;manure_spreader&#124;other_equivalent_device&#124;front_loader)&#124;null"` | nicht deklariert | nein |
| `oepul.o6_21.composting.windrows[].windrow_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `oepul.o6_21.composting_supplement_applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_21.exits[].after_control_announcement_or_result` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_21.exits[].date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `oepul.o6_21.exits[].item` | added | nicht vorhanden | `"enum(measure&#124;male_lt_half_year&#124;male_ge_half_year&#124;female_lt_half_year&#124;female_half_to_2_years&#124;festmistkompostierung)"` | nicht deklariert | nein |
| `oepul.o6_21.occupancy_plan_available` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_21.stall_sketch_available` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_21.takeover.animals_and_areas_from_same_predecessor` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul.o6_21.takeover.reason` | added | nicht vorhanden | `"enum(farm_dissolution&#124;farm_division&#124;farm_merger&#124;other)"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_21-opus-5.5-high-20260928/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_21-opus-5.5-high-20260928/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
