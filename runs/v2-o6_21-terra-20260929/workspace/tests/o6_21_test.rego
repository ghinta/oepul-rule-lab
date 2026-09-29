package oepul.o6_21_test

import data.oepul.o6_21
import rego.v1

test_space_table if {
	o6_21.space_requirement(350).total_area_m2 == 3.0
	o6_21.space_requirement(501).total_area_m2 == 4.2
	o6_21.rgve_factor("cattle", "under_0_5_year") == 0.4
}

test_eligible_and_standard_premium if {
	case_input := {
		"participation": {"average_rgve_all_categories": 2, "eligible_cattle_rgve": 3, "total_eligible_categories": 1, "animals_kept_in_austria": true, "has_dairy_delivery": false, "qplus_or_equivalent_full_year": true, "recognised_cattle_health_service_full_year": false, "categories": [{"name": "male_at_least_0_5", "all_animals_of_category_enrolled": true, "year_conditions_met": true, "average_rgve": 3, "animals": [{"group_housed": true, "lying_surface_closed": true, "lying_surface_perforation_percent": 5, "littered_lying_area_m2": 1.44, "required_total_area_m2": 3.6, "lying_area_soft_and_dry": true, "available_total_area_m2": 3.6}]}]},
		"payment": {"overlap_with_pasture_alp_or_coupled_support": false},
		"compost_supplement": {"requested": false},
	}
	o6_21.category_eligible(case_input.participation.categories[0]) with input as case_input
	o6_21.measure_eligible with input as case_input
	rate := o6_21.premium_rate_eur_per_rgve with input as case_input
	rate == 194.4
	o6_21.premium_eur with input as case_input
}

test_dairy_delivery_excludes_female_older_category if {
	category := {"name": "female_0_5_to_under_2", "all_animals_of_category_enrolled": true, "year_conditions_met": true, "average_rgve": 2, "animals": []}
	not o6_21.category_eligible(category) with input.participation.has_dairy_delivery as true
}

test_compost_alternative_from_2025 if {
	case_input := {"compost_supplement": {"requested": true, "all_farm_farmyard_manure_composted": true, "documentation_complete": true, "compost_barn": false, "eligible_unturned_mixture_from_2025": true}}
	o6_21.compost_supplement_eligible with input as case_input
}
