package oepul.o6_21

import rego.v1

# Required values from data.o6_21_tables are intentionally kept in data so that
# the published weight and conversion tables remain auditable data, not code.
space_requirement(weight_kg) := requirement if {
	weight_kg <= 150
	requirement := data.space_requirements_m2[0]
}

space_requirement(weight_kg) := requirement if {
	weight_kg > 150
	weight_kg <= 220
	requirement := data.space_requirements_m2[1]
}

space_requirement(weight_kg) := requirement if {
	weight_kg > 220
	weight_kg <= 350
	requirement := data.space_requirements_m2[2]
}

space_requirement(weight_kg) := requirement if {
	weight_kg > 350
	weight_kg <= 500
	requirement := data.space_requirements_m2[3]
}

space_requirement(weight_kg) := requirement if {
	weight_kg > 500
	requirement := data.space_requirements_m2[4]
}

rgve_factor(animal, age) := factor if {
	some row in data.rgve_factors
	row.animal == animal
	row.age == age
	factor := row.rgve_per_head
}

eligible_category(category) if {
	category == "male_under_0_5"
}

eligible_category(category) if {
	category == "male_at_least_0_5"
}

eligible_category(category) if {
	category == "female_under_0_5"
}

eligible_category(category) if {
	category == "female_0_5_to_under_2"
}

valid_litter(animal) if {
	animal.lying_surface_closed
	animal.lying_surface_perforation_percent <= 5
	animal.littered_lying_area_m2 >= 0.4 * animal.required_total_area_m2
	animal.lying_area_soft_and_dry
}

valid_group_housing(animal) if {
	animal.group_housed
	valid_litter(animal)
	animal.available_total_area_m2 >= animal.required_total_area_m2
}

valid_group_housing(animal) if {
	animal.individually_housed
	animal.individual_housing_health_reason
	animal.individual_housing_days <= 10
	valid_litter(animal)
}

category_dairy_disallowed(category) if {
	category.name == "female_0_5_to_under_2"
	input.participation.has_dairy_delivery
}

category_missing_qplus(category) if {
	startswith(category.name, "female_")
	not input.participation.qplus_or_equivalent_full_year
}

health_service_missing if {
	input.participation.eligible_cattle_rgve > 10
	not input.participation.recognised_cattle_health_service_full_year
}

compost_turning_method_eligible if {
	input.compost_supplement.turns_with_compost_turner >= 2
	input.compost_supplement.minimum_days_between_turns >= 14
}

valid_group_housing(animal) if {
	animal.age_days < 21
	animal.individually_housed
	animal.social_contact_with_calves
	valid_litter(animal)
}

category_eligible(category) if {
	eligible_category(category.name)
	category.all_animals_of_category_enrolled
	category.year_conditions_met
	category.average_rgve >= 0
	not category_dairy_disallowed(category)
	not category_missing_qplus(category)
	every animal in category.animals { valid_group_housing(animal) }
}

measure_eligible if {
	input.participation.average_rgve_all_categories >= 2
	every category in input.participation.categories { category_eligible(category) }
	input.participation.total_eligible_categories > 0
	input.participation.animals_kept_in_austria
	not health_service_missing
}

compost_supplement_eligible if {
	input.compost_supplement.requested
	input.compost_supplement.all_farm_farmyard_manure_composted
	input.compost_supplement.documentation_complete
	not input.compost_supplement.compost_barn
	compost_turning_method_eligible
}

compost_supplement_eligible if {
	input.compost_supplement.requested
	input.compost_supplement.all_farm_farmyard_manure_composted
	input.compost_supplement.documentation_complete
	not input.compost_supplement.compost_barn
	input.compost_supplement.eligible_unturned_mixture_from_2025
}

premium_rate_eur_per_rgve := data.premium_eur_per_rgve.standard_from_2024 if {
	not input.payment.overlap_with_pasture_alp_or_coupled_support
}

premium_rate_eur_per_rgve := data.premium_eur_per_rgve.overlap_from_2024 if {
	input.payment.overlap_with_pasture_alp_or_coupled_support
}

premium_eur := amount if {
	measure_eligible
	amount := input.participation.eligible_cattle_rgve * premium_rate_eur_per_rgve
}

compost_supplement_eur := amount if {
	compost_supplement_eligible
	amount := input.participation.eligible_cattle_rgve * data.premium_eur_per_rgve.compost_supplement_from_2024
}
