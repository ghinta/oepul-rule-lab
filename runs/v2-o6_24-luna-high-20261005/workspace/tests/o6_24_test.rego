package oepul.o6_24_test

import data.oepul.o6_24
import rego.v1

valid_input := {
	"farm": {"year": 2026, "region": {"federal_state": "Steiermark", "district": "Graz"}},
	"land": {"parcels": [{
		"area_ha": 2.5,
		"land_use": "arable",
		"constraints": {"is_wrrl_area": true, "wrrl_higher_n_authorization": false},
		"operations": {"fertilizer": {
			"annual_effective_n_kg_per_ha": 120,
			"wrrl_annual_limit_kg_per_ha": 130,
			"application_period_compliant": true,
		}},
	}]},
	"documentation": {"wrrl_farm_book_complete": true},
}

test_valid_wrrl_participation if {
	result := o6_24.decision with input as valid_input
	result.all_measure_conditions_met
	result.premium_eur_per_ha == 54
}

test_minimum_participation_failure if {
	result := o6_24.decision with input as {
		"farm": {"year": 2026, "region": {"federal_state": "Steiermark", "district": "Graz"}},
		"land": {"parcels": [{
			"area_ha": 1.9,
			"land_use": "arable",
			"constraints": {"is_wrrl_area": true, "wrrl_higher_n_authorization": false},
			"operations": {"fertilizer": {
				"annual_effective_n_kg_per_ha": 100,
				"wrrl_annual_limit_kg_per_ha": 130,
				"application_period_compliant": true,
			}},
		}]},
		"documentation": {"wrrl_farm_book_complete": true},
	}
	not result.minimum_participation_met
}

test_high_n_authorization_excluded if {
	result := o6_24.decision with input as {
		"farm": {"year": 2026, "region": {"federal_state": "Steiermark", "district": "Graz"}},
		"land": {"parcels": [{
			"area_ha": 2.5,
			"land_use": "arable",
			"constraints": {"is_wrrl_area": true, "wrrl_higher_n_authorization": true},
			"operations": {"fertilizer": {
				"annual_effective_n_kg_per_ha": 100,
				"wrrl_annual_limit_kg_per_ha": 130,
				"application_period_compliant": true,
			}},
		}]},
		"documentation": {"wrrl_farm_book_complete": true},
	}
	not result.minimum_participation_met
}

test_combination_table_reference if {
	"1A" in o6_24.allowed_combination
	"23" in o6_24.allowed_combination
	not "14" in o6_24.allowed_combination
}

test_drought_exception_styria if {
	result := o6_24.decision with input as {
		"farm": {"year": 2026, "region": {"federal_state": "Steiermark", "district": "Weiz"}},
		"documentation": {"drought_no_harvestable_stand": true},
	}
	result.drought_exception_applies
}

test_drought_exception_not_applied_outside_area if {
	result := o6_24.decision with input as {
		"farm": {"year": 2026, "region": {"federal_state": "Steiermark", "district": "Murau"}},
		"documentation": {"drought_no_harvestable_stand": true},
	}
	not result.drought_exception_applies
}
