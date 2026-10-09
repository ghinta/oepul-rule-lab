package oepul.o6_13_test

import data.oepul.o6_13
import rego.v1

valid_input := {
	"farm": {
		"year": 2026,
		"region": {"country": "AT", "federal_state": "Wien", "district": "Donaustadt"},
		"measure_application": {
			"requested": true,
			"contract_year": 2026,
			"first_participation": true,
			"submitted_by": "2025-12-31",
		},
		"operation_program": {"member": false, "organism_use_compensated": false},
	},
	"land": {
		"total_area_ha": 10,
		"arable_area_ha": 0,
		"grassland_area_ha": 0,
		"special_crops_area_ha": 0,
		"alpine_pasture_area_ha": 0,
		"parcels": [{
			"area_ha": 0.6,
			"land_use": "A",
			"protected_cultivation": {
				"is_protected_cultivation": true,
				"active_production": true,
				"structure_type": "fixed_greenhouse_glass",
				"cultivation_medium": "grown_soil",
				"area_role": "production",
			},
			"measure_application": {
				"requested": true,
				"code": "NUE",
				"harvested_percent": 100,
				"other_premium": false,
				"proper_cultivation": true,
				"proper_annual_care": true,
				"crop_is_late_summer_or_autumn": false,
			},
			"organism_application": {
				"organism_type": "predatory_mite",
				"quantity": 1000,
				"ages_register_entry": true,
				"application_rate_compliant": true,
				"replaces_plant_protection_use": true,
				"purchase_evidence": true,
				"reason": "biological pest control",
				"goal": "control of pests",
				"date": "2026-04-15",
				"is_pollinator_only": false,
			},
		}],
	},
}

test_valid_protected_cultivation if {
	result := o6_13.decision with input as valid_input
	result.eligible == true
	result.premium_eur_per_ha == 2160
}

test_operation_program_excludes if {
	result := o6_13.decision with input as object.union(valid_input, {
		"farm": object.union(valid_input.farm, {"operation_program": {"member": true, "organism_use_compensated": true}}),
	})
	result.eligible == false
	result.operation_program_exclusion == true
}

test_pollinator_only_is_not_an_eligible_nue_use if {
	result := o6_13.decision with input as object.union(valid_input, {
		"land": object.union(valid_input.land, {"parcels": [object.union(valid_input.land.parcels[0], {"organism_application": object.union(valid_input.land.parcels[0].organism_application, {"is_pollinator_only": true})})]}),
	})
	result.eligible == false
}

test_drought_exception_replaces_harvest_threshold_in_2026_scope if {
	base := object.union(valid_input, {
		"farm": object.union(valid_input.farm, {
			"region": {"federal_state": "Burgenland", "district": "Neusiedl am See"},
			"measure_application": object.union(valid_input.farm.measure_application, {"drought_no_harvestable_stock": true}),
		}),
		"land": object.union(valid_input.land, {"parcels": [object.union(valid_input.land.parcels[0], {"measure_application": object.union(valid_input.land.parcels[0].measure_application, {"harvested_percent": 0, "crop_is_late_summer_or_autumn": true})})]}),
	})
	result := o6_13.decision with input as base
	result.eligible == true
}

test_substrate_requires_ga_land_use if {
	base := object.union(valid_input, {"land": object.union(valid_input.land, {"parcels": [object.union(valid_input.land.parcels[0], {
		"land_use": "GA",
		"protected_cultivation": object.union(valid_input.land.parcels[0].protected_cultivation, {"cultivation_medium": "substrate"}),
	})]})})
	result := o6_13.decision with input as base
	result.eligible == true
}

test_other_premium_is_not_combinable_on_same_area if {
	base := object.union(valid_input, {"land": object.union(valid_input.land, {"parcels": [object.union(valid_input.land.parcels[0], {
		"measure_application": object.union(valid_input.land.parcels[0].measure_application, {"other_premium": true}),
	})]})})
	result := o6_13.decision with input as base
	result.eligible == false
}
