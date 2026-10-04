package oepul.o6_14_test

import rego.v1

test_first_year_minimum_and_density_pass if {
	result := data.oepul.o6_14 with input as {
		"farm": {"year": 2026},
		"land": {"alpine_pastures": [{
			"alm_id": "A",
			"area_ha": 3,
			"access_stage": "stage_2",
			"is_in_austria": true,
			"feed_practices": {"natural_fodder_sufficient": true, "non_alpine_silage_or_green_fodder": false},
			"alm_inputs": {"pesticide_used": false, "fertilizer_used": false},
		}]},
		"livestock": {"alpine_movements": [{
			"animal_id": "c1",
			"alm_id": "A",
			"species": "cattle",
			"gve": 3,
			"alpung_days": 60,
			"is_held_in_austria": true,
		}]},
		"preferences_constraints": {
			"oepul_participation_requested": true,
			"oepul_first_participation_year": true,
			"oepul_options": {},
		},
		"documentation": {"oepul_reports": {
			"cattle_arrival_days": 14,
			"cattle_departure_days": 14,
			"other_arrival_days": 7,
			"other_departure_days": 7,
		}},
	}
	result.eligible
}

test_first_year_minimum_fails if {
	result := data.oepul.o6_14 with input as {
		"farm": {"year": 2026},
		"land": {"alpine_pastures": [{
			"alm_id": "A",
			"area_ha": 2.9,
			"access_stage": "stage_1",
			"is_in_austria": true,
			"feed_practices": {"natural_fodder_sufficient": true, "non_alpine_silage_or_green_fodder": false},
			"alm_inputs": {"pesticide_used": false, "fertilizer_used": false},
		}]},
		"livestock": {"alpine_movements": [{
			"animal_id": "c1",
			"alm_id": "A",
			"species": "cattle",
			"gve": 3,
			"alpung_days": 60,
			"is_held_in_austria": true,
		}]},
		"preferences_constraints": {
			"oepul_participation_requested": true,
			"oepul_first_participation_year": true,
			"oepul_options": {},
		},
		"documentation": {"oepul_reports": {
			"cattle_arrival_days": 14,
			"cattle_departure_days": 14,
			"other_arrival_days": 7,
			"other_departure_days": 7,
		}},
	}
	not result.eligible
}

test_naturschutz_density_and_incompatibility if {
	result := data.oepul.o6_14 with input as {
		"farm": {"year": 2026},
		"land": {"alpine_pastures": [{
			"alm_id": "A",
			"area_ha": 10,
			"access_stage": "stage_2",
			"is_in_austria": true,
			"feed_practices": {"natural_fodder_sufficient": true, "non_alpine_silage_or_green_fodder": false},
			"alm_inputs": {"pesticide_used": false, "fertilizer_used": false},
		}]},
		"livestock": {"alpine_movements": [{
			"animal_id": "c1",
			"alm_id": "A",
			"species": "cattle",
			"gve": 15,
			"alpung_days": 60,
			"is_held_in_austria": true,
		}]},
		"preferences_constraints": {
			"oepul_participation_requested": true,
			"oepul_options": {"naturschutz_auf_der_alm": true, "almweideplan": true},
		},
		"documentation": {"oepul_reports": {
			"cattle_arrival_days": 14,
			"cattle_departure_days": 14,
			"other_arrival_days": 7,
			"other_departure_days": 7,
		}},
	}
	not result.eligible
}

test_premium_cap_and_modulation if {
	result := data.oepul.o6_14 with input as {
		"farm": {"year": 2026},
		"land": {"alpine_pastures": [{
			"alm_id": "A",
			"area_ha": 50,
			"access_stage": "stage_2",
			"is_in_austria": true,
			"feed_practices": {"natural_fodder_sufficient": true, "non_alpine_silage_or_green_fodder": false},
			"alm_inputs": {"pesticide_used": false, "fertilizer_used": false},
		}]},
		"livestock": {"alpine_movements": [{
			"animal_id": "c1",
			"alm_id": "A",
			"species": "cattle",
			"gve": 43,
			"alpung_days": 60,
			"is_held_in_austria": true,
		}]},
		"preferences_constraints": {
			"oepul_participation_requested": false,
			"oepul_options": {},
		},
		"documentation": {"oepul_reports": {
			"cattle_arrival_days": 14,
			"cattle_departure_days": 14,
			"other_arrival_days": 7,
			"other_departure_days": 7,
		}},
	}
	result.premium_area.A == 43
	result.modulation_factor == 1
}

test_reporting_rules if {
	data.oepul.o6_14.reporting_rules.cattle.arrival_days == 14
	data.oepul.o6_14.reporting_rules.sheep_goats.late_credit_days == 7
}
