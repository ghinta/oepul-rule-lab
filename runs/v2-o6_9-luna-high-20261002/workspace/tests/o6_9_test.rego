package oepul.o6_9_test

import rego.v1

test_valid_application_and_separation if {
	result := data.oepul.o6_9.result with input as {
		"measure": "o6_9",
		"farm": {"year": 2026, "arable_area_ha": 20},
		"participation": {
			"categories": ["application", "separation"],
			"application_m3": 100,
			"separated_m3": 40,
			"base_measure_valid": true,
			"measure_requested_by_december_31": true,
			"groundwater_protection_pig_bonus": false,
		},
		"application": {
			"method": "trailing_shoe",
			"land_use": "arable",
			"manure_type": "slurry",
			"injected_rainwater": false,
			"is_water_mixed_solid_manure": false,
			"records_complete": true,
			"records_include": {"amount_m3", "manure_type", "date", "method", "parcel"},
			"requested_by_december_31": true,
			"requested_m3": 100,
		},
		"separation": {
			"origin": "own_cattle",
			"mechanical_phase_separation": true,
			"separated_m3": 40,
			"records_complete": true,
			"records_include": {"date", "separated_liquid_m3"},
			"requested_m3": 40,
		},
		"pig_feeding": {"gve_pigs_annual_average": 0, "all_pigs_compliant": true, "proof_available": true},
		"calculation": {"eligible_fertilizable_area_ha": 2, "cattle_gve": 3, "arable_area_ha": 20},
	}
	result.eligible
	result.violations == []
	result.premium == 210
}

test_application_cap_and_disallowed_device if {
	result := data.oepul.o6_9.result with input as {
		"measure": "o6_9",
		"farm": {"year": 2026, "arable_area_ha": 10},
		"participation": {"categories": ["application"], "application_m3": 100, "separated_m3": 0, "base_measure_valid": true, "measure_requested_by_december_31": true, "groundwater_protection_pig_bonus": false},
		"application": {"method": "broadcast", "land_use": "arable", "manure_type": "slurry", "injected_rainwater": false, "is_water_mixed_solid_manure": false, "records_complete": true, "records_include": {"amount_m3", "manure_type", "date", "method", "parcel"}, "requested_by_december_31": true, "requested_m3": 100},
		"separation": {"requested_m3": 0, "separated_m3": 0},
		"pig_feeding": {"gve_pigs_annual_average": 0, "all_pigs_compliant": true, "proof_available": true},
		"calculation": {"eligible_fertilizable_area_ha": 1, "cattle_gve": 0, "arable_area_ha": 10},
	}
	not result.eligible
	"application_requirements_not_met" in result.violations
	result.premium == 0
}

test_pig_threshold_and_incompatibility if {
	result := data.oepul.o6_9.result with input as {
		"measure": "o6_9",
		"farm": {"year": 2025, "arable_area_ha": 10},
		"participation": {"categories": ["pig_feeding"], "application_m3": 0, "separated_m3": 0, "base_measure_valid": true, "measure_requested_by_december_31": true, "groundwater_protection_pig_bonus": true},
		"application": {"requested_m3": 0},
		"separation": {"requested_m3": 0, "separated_m3": 0},
		"pig_feeding": {"gve_pigs_annual_average": 10, "all_pigs_compliant": true, "proof_available": true},
		"calculation": {"eligible_fertilizable_area_ha": 0, "cattle_gve": 0, "arable_area_ha": 10},
	}
	not result.eligible
	"incompatible_pig_bonus" in result.violations
}
