package oepul.o6_24_test

import data.oepul.o6_24
import rego.v1

base_input := {
	"farm": {"year": 2026, "region": {"federal_state": "Steiermark", "district": "Graz"}},
	"documentation": {"o6_24": {"farm_book_retained_at_farm": true}},
	"land": {
		"parcels": [
			{"area_ha": 1.2, "land_use": "arable", "o6_24": {"in_wrrl_area": true, "is_fallow": false, "has_higher_n_permission": false, "nitrogen_class": "C", "annual_effective_n_kg_ha": 100, "nitrogen_limit_kg_ha": 120, "n_application_in_permitted_period": true, "farm_book_recorded": true, "opwrrl_code": false, "no_harvest_due_to_drought": false}},
			{"area_ha": 0.8, "land_use": "arable", "o6_24": {"in_wrrl_area": true, "is_fallow": false, "has_higher_n_permission": false, "nitrogen_class": "D", "annual_effective_n_kg_ha": 130, "nitrogen_limit_kg_ha": 144, "n_application_in_permitted_period": true, "farm_book_recorded": true, "opwrrl_code": false, "no_harvest_due_to_drought": false}},
		],
	},
}

test_eligible_and_premium if {
	o6_24.eligible with input as base_input
	o6_24.eligible_area_ha == 2 with input as base_input
	o6_24.premium_eur == 108 with input as base_input
}

test_minimum_area_failure if {
	too_small := object.union(base_input, {"land": {"parcels": [base_input.land.parcels[0]]}})
	not o6_24.minimum_area_met with input as too_small
}

test_high_n_approval_needs_code if {
	with_approval := object.union(base_input, {"land": {"parcels": array.concat(base_input.land.parcels, [{"area_ha": 1, "land_use": "arable", "o6_24": {"in_wrrl_area": true, "is_fallow": false, "has_higher_n_permission": true, "nitrogen_class": "C", "annual_effective_n_kg_ha": 100, "nitrogen_limit_kg_ha": 120, "n_application_in_permitted_period": true, "farm_book_recorded": true, "opwrrl_code": false, "no_harvest_due_to_drought": false}}])}})
	o6_24.violations[_].code == "high_n_permission" with input as with_approval
}

test_drought_exception_for_graz_2026 if {
	drought := object.union(base_input, {"land": {"parcels": [{"area_ha": 1.2, "land_use": "arable", "o6_24": {"in_wrrl_area": true, "is_fallow": false, "has_higher_n_permission": false, "nitrogen_class": "C", "annual_effective_n_kg_ha": 100, "nitrogen_limit_kg_ha": 120, "n_application_in_permitted_period": true, "farm_book_recorded": true, "opwrrl_code": false, "no_harvest_due_to_drought": true}}]}})
	o6_24.drought_harvest_exception_2026 with input as drought
}
