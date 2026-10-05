package oepul.o6_22

import rego.v1

default eligible := false

measure_scope if {
	input.livestock.o6_22.measure == "o6_22"
}

eligible if {
	measure_scope
	input.livestock.o6_22.participation_gve >= 2
}

category_definition(category_id) := category if {
	some category in data.o6_22.categories
	category.id == category_id
}

gve_factor(category_id) := factor if {
	category := category_definition(category_id)
	factor := category.gve_per_head
}

required_space(category_id, weight_band) := requirement if {
	some requirement in data.o6_22.stall_space_requirements
	requirement.category == category_id
	requirement.weight_band == weight_band
}

sow_required_space(sow_type) := requirement if {
	some requirement in data.o6_22.sow_space_requirements
	requirement.category == sow_type
}

premium_eur_per_gve(category_id, year) := amount if {
	category := category_definition(category_id)
	year == 2023
	amount := category.base_premium_eur_per_gve_2023
}

premium_eur_per_gve(category_id, year) := amount if {
	category := category_definition(category_id)
	year >= 2024
	amount := category.base_premium_eur_per_gve_from_2024
}

uncut_surcharge_eur_per_gve(category_id, year) := amount if {
	category := category_definition(category_id)
	category.uncut_surcharge_eur_per_gve_2023 != null
	year == 2023
	amount := category.uncut_surcharge_eur_per_gve_2023
}

uncut_surcharge_eur_per_gve(category_id, year) := amount if {
	category := category_definition(category_id)
	category.uncut_surcharge_eur_per_gve_from_2024 != null
	year >= 2024
	amount := category.uncut_surcharge_eur_per_gve_from_2024
}

protein_surcharge_eur_per_gve(category_id, year) := amount if {
	category := category_definition(category_id)
	year == 2023
	amount := category.protein_surcharge_eur_per_gve_2023
}

protein_surcharge_eur_per_gve(category_id, year) := amount if {
	category := category_definition(category_id)
	year >= 2024
	amount := category.protein_surcharge_eur_per_gve_from_2024
}

compost_surcharge_eur_per_gve(category_id, year) := amount if {
	category := category_definition(category_id)
	year >= 2025
	amount := category.compost_surcharge_eur_per_gve_from_2025
}

free_range_max_gve_per_ha := data.o6_22.free_range.fallback_max_gve_per_ha

free_range_density_ok if {
	authority_limit := input.livestock.o6_22.free_range.authority_max_gve_per_ha
	authority_limit != null
	authority_limit >= input.livestock.o6_22.free_range.actual_gve_per_ha
}

free_range_density_ok if {
	input.livestock.o6_22.free_range.authority_max_gve_per_ha == null
	input.livestock.o6_22.free_range.actual_gve_per_ha <= free_range_max_gve_per_ha
}

sow_shelter_ok if {
	input.livestock.o6_22.sow_type != "breeding_sows"
}

sow_shelter_ok if {
	input.livestock.o6_22.sow_type == "breeding_sows"
	input.livestock.o6_22.free_range.farrowing_huts_available
}

free_range_compliant if {
	free_range_density_ok
	input.livestock.o6_22.free_range.continuous_use_years <= data.o6_22.free_range.max_continuous_use_years
	input.livestock.o6_22.free_range.wild_boar_exclusion
	input.livestock.o6_22.free_range.feed_and_water_separated
	input.livestock.o6_22.free_range.feed_on_hard_surface_or_moved_regularly
	input.livestock.o6_22.free_range.feed_roofed
	input.livestock.o6_22.free_range.roofed_three_sided_bedded_shelter
	input.livestock.o6_22.free_range.all_animals_can_lie_simultaneously
	sow_shelter_ok
}

stall_area_compliant(category_id, weight_band, animals, usable_area_m2, bedded_area_m2) if {
	requirement := required_space(category_id, weight_band)
	usable_area_m2 >= animals * requirement.total_area_m2_per_animal
	bedded_area_m2 >= usable_area_m2 * 0.4
	bedded_area_m2 >= animals * requirement.lying_area_m2_per_animal
}

sow_space_compliant(sow_type, animals, usable_area_m2, bedded_area_m2) if {
	requirement := sow_required_space(sow_type)
	usable_area_m2 >= animals * requirement.total_area_m2_per_animal
	bedded_area_m2 >= animals * requirement.lying_area_m2_per_animal
}

uncut_surcharge_eligible if {
	input.livestock.o6_22.supplement_facts.uncut_requested
	input.livestock.o6_22.supplement_facts.all_participating_animals_uncut
	input.livestock.o6_22.supplement_facts.applies_to_whole_category
}

protein_surcharge_eligible if {
	input.livestock.o6_22.supplement_facts.protein_requested
	input.livestock.o6_22.supplement_facts.all_farm_pigs_compliant
	input.livestock.o6_22.supplement_facts.no_noncompliant_protein_feed_storage_or_feeding
	input.livestock.o6_22.supplement_facts.protein_feed_evidence_available
}

compost_surcharge_eligible if {
	input.livestock.o6_22.year >= 2025
	input.livestock.o6_22.supplement_facts.compost_requested
	input.livestock.o6_22.supplement_facts.all_farm_solid_manure_composted
	input.livestock.o6_22.supplement_facts.compost_turn_count >= 2
	input.livestock.o6_22.supplement_facts.compost_turn_interval_days >= 14
	input.livestock.o6_22.supplement_facts.compost_documentation_complete
	not input.livestock.o6_22.supplement_facts.compost_stall
}

compost_equipment_compliant if {
	input.livestock.o6_22.supplement_facts.composter_on_farm
}

compost_equipment_compliant if {
	not input.livestock.o6_22.supplement_facts.composter_on_farm
	input.livestock.o6_22.supplement_facts.inter_farm_use_documented
}

compost_alternative_compliant if {
	input.livestock.o6_22.supplement_facts.organic_mix_present
	input.livestock.o6_22.supplement_facts.composting_process_applied
}

compost_documentation_compliant if {
	input.livestock.o6_22.supplement_facts.compost_log_complete
}

report_deregistration_required if {
	input.livestock.o6_22.reporting.category_conditions_not_met
}

report_deregistration_required if {
	input.livestock.o6_22.individual_housing_days > 10
}

eligible_gve_from_heads := result if {
	result := (input.livestock.o6_22.applied_heads - input.livestock.o6_22.deregistered_heads) * gve_factor(input.livestock.o6_22.category)
}

uncut_surcharge_total := 0 if {
	not input.livestock.o6_22.supplement_facts.uncut_requested
}

uncut_surcharge_total := result if {
	uncut_surcharge_eligible
	result := input.livestock.o6_22.eligible_gve * uncut_surcharge_eur_per_gve(input.livestock.o6_22.category, input.livestock.o6_22.year)
}

protein_surcharge_total := 0 if {
	not input.livestock.o6_22.supplement_facts.protein_requested
}

protein_surcharge_total := result if {
	protein_surcharge_eligible
	result := input.livestock.o6_22.eligible_gve * protein_surcharge_eur_per_gve(input.livestock.o6_22.category, input.livestock.o6_22.year)
}

compost_surcharge_total := 0 if {
	not input.livestock.o6_22.supplement_facts.compost_requested
}

compost_surcharge_total := result if {
	compost_surcharge_eligible
	result := input.livestock.o6_22.eligible_gve * compost_surcharge_eur_per_gve(input.livestock.o6_22.category, input.livestock.o6_22.year)
}

premium_total_eur := total if {
	base := input.livestock.o6_22.eligible_gve * premium_eur_per_gve(input.livestock.o6_22.category, input.livestock.o6_22.year)
	total := ((base + uncut_surcharge_total) + protein_surcharge_total) + compost_surcharge_total
}

modulation_factor := 1 if {
	input.land.total_area_ha <= 200
}

modulation_factor := 0.9 if {
	input.land.total_area_ha > 200
	input.land.total_area_ha <= 300
}

modulation_factor := 0.85 if {
	input.land.total_area_ha > 300
	input.land.total_area_ha <= 1000
}

modulation_factor := 0.75 if {
	input.land.total_area_ha > 1000
}
