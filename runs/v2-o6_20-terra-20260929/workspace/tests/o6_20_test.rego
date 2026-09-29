package oepul.o6_20_test

import data.oepul.o6_20
import rego.v1

test_eligible_base_category if {
	o6_20.eligible with input as {"o6_20": {"categories": [{"id": "cow", "requested": true, "avg_rgve": 2.0, "grazing_days": 120, "optional_150_days": false, "all_animals_grazed": true, "forage_mostly_grazed": true, "substantial_day_grazing": true, "water_access": true, "shelter_access": true, "diary_complete": true}]}}
}

test_150_day_option_is_enforced if {
	some violation in o6_20.violations with input as {"o6_20": {"categories": [{"id": "cow", "requested": true, "avg_rgve": 2.0, "grazing_days": 149, "optional_150_days": true, "all_animals_grazed": true, "forage_mostly_grazed": true, "substantial_day_grazing": true, "water_access": true, "shelter_access": true, "diary_complete": true}]}}
	violation.code == "minimum_grazing_days"
	violation.required == 150
}

test_two_rgve_minimum_is_enforced if {
	some violation in o6_20.violations with input as {"o6_20": {"categories": [{"id": "goat", "requested": true, "avg_rgve": 1.95, "grazing_days": 120, "optional_150_days": false, "all_animals_grazed": true, "forage_mostly_grazed": true, "substantial_day_grazing": true, "water_access": true, "shelter_access": true, "diary_complete": true}]}}
	violation.code == "minimum_rgve"
}

test_gve_table_is_used if {
	o6_20.rgve_factor("equine_large_adult") == 1.0
}
