package oepul.o6_13_test

import data.oepul.o6_13
import rego.v1

base := {
	"farm": {"year": 2026, "first_oepul_participation_year": false},
	"o6_13": {
		"year": 2026,
		"measure_applied": true,
		"first_participation_year": false,
		"operation_program_organism_compensated": false,
		"any_nue_use": true,
		"application_submitted_by_december_31": true,
		"parcels": [{
			"area_ha": 0.25,
			"application_code": "NUE",
			"protected_structure": "fixed_greenhouse_glass",
			"land_use_code": "GA",
			"growing_system": "substrate",
			"active_agricultural_production": true,
			"sales_display_storage_area": false,
			"unused_between_structures": false,
			"organism_application_replaces_psm": true,
			"organism_registered_at_ages": true,
			"organism_dose_matches_register": true,
			"records_complete": true,
			"other_single_area_premiums": [],
		}],
	},
}

test_eligible_and_premium if {
	o6_13.eligible with input as base
	o6_13.premium_eur == 540 with input as base
	violations := o6_13.violations with input as base
	count(violations) == 0
}

test_double_funding_is_denied if {
	"operation_program_double_funding" in o6_13.violations with input as object.union(base, {"o6_13": object.union(base.o6_13, {"operation_program_organism_compensated": true})})
}

test_bees_are_not_eligible if {
	facts := object.union(base, {"o6_13": object.union(base.o6_13, {"parcels": [object.union(base.o6_13.parcels[0], {"organism_registered_at_ages": false})]})})
	parcels := o6_13.eligible_parcels with input as facts
	count(parcels) == 0
}

test_soil_requires_a_code if {
	facts := object.union(base, {"o6_13": object.union(base.o6_13, {"parcels": [object.union(base.o6_13.parcels[0], {"growing_system": "soil", "land_use_code": "GA"})]})})
	"wrong_land_use_code_for_cultivation" in o6_13.violations with input as facts
}
