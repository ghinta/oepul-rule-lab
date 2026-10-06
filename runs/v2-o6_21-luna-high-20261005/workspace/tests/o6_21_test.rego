package tests.o6_21

import data.policy.o6_21 as measure
import rego.v1

valid_input := {
	"farm": {
		"o6_21": {
			"year": 2026,
			"participating_categories": ["male_from_half_year"],
			"average_fundable_rgve": 5,
			"fundable_rgve_total": 5,
			"all_eligible_animals_participating": true,
			"health_service_participation": false,
			"qplus_rind_or_comparable": false,
			"milk_delivery_to_dairy": false,
			"minimum_participation_met": true,
			"application_submitted_by_december_31": true,
			"overlap_with_alp_or_weide": false,
			"compost_surcharge_requested": false,
			"housing_periods_documented": true,
			"animals": [{"animal_id": "r1", "weight_kg": 501}],
			"stall": {
				"structural_requirements_met": true,
				"usable_area_definition_met": true,
				"group_housing": true,
				"littered_system": true,
				"perforation_percent": 0,
				"littered_lying_area_percent": 40,
				"lying_area_soft_and_dry": true,
				"total_area_m2_per_animal": 4.2,
				"lying_area_m2_per_animal": 1.68,
				"individual_housing_littered": true,
			},
		},
	},
}

test_valid_application_and_premium if {
	result := measure.decision with input as valid_input
	result.eligible
	result.premium_eur == 972
	result.application == "valid"
	result.contract_year == "one_year_and_auto_renewing"
}

test_minimum_rgve_is_required if {
	broken_profile := object.union(valid_input.farm.o6_21, {"average_fundable_rgve": 1.99})
	broken := {"farm": {"o6_21": broken_profile}}
	result := measure.decision with input as broken
	not result.eligible
	[violation | violation := result.violations[_]; violation.rule_id == "O621-MIN-RGVE"]
}

test_space_table_is_enforced if {
	broken_profile := object.union(valid_input.farm.o6_21, {"stall": object.union(valid_input.farm.o6_21.stall, {"total_area_m2_per_animal": 4.19})})
	broken := {"farm": {"o6_21": broken_profile}}
	result := measure.decision with input as broken
	not result.eligible
	[violation | violation := result.violations[_]; violation.rule_id == "O621-SPACE"]
}

test_female_milk_delivery_exclusion if {
	broken_profile := object.union(valid_input.farm.o6_21, {"participating_categories": ["female_half_to_two_years"], "milk_delivery_to_dairy": true, "qplus_rind_or_comparable": true})
	broken := {"farm": {"o6_21": broken_profile}}
	result := measure.decision with input as broken
	not result.eligible
	[violation | violation := result.violations[_]; violation.rule_id == "O621-MILK-DELIVERY"]
}

test_compost_surcharge_turning_path if {
	valid_compost := {
		"all_solid_manure_in_piles": true,
		"mode": "turned",
		"turns": 2,
		"minimum_interval_days": 14,
		"turning_equipment_available_or_proven": true,
		"records_complete": true,
		"napv_compliant": true,
		"compost_barn": false,
	}
	with_compost_profile := object.union(valid_input.farm.o6_21, {"compost_surcharge_requested": true, "compost": valid_compost})
	with_compost := {"farm": {"o6_21": with_compost_profile}}
	result := measure.decision with input as with_compost
	result.eligible
	result.premium_eur == 1080
}

test_overlap_uses_reduced_animal_rate if {
	overlap_profile := object.union(valid_input.farm.o6_21, {"overlap_with_alp_or_weide": true})
	overlap := {"farm": {"o6_21": overlap_profile}}
	result := measure.decision with input as overlap
	result.premium_eur == 810
}
