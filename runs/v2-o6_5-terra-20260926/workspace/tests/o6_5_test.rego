package oepul.o6_5_test

import rego.v1

test_2026_drought_holding_and_premium if {
	profile := {"farm": {"year": 2026}, "livestock": {"breeding_animals": [{"animal_id": "AT1", "breed": "Murbodner", "purebred": true, "zuchtbook_registered": true, "held_from_april_1": true, "held_through_august_31": true, "category": "cow", "milk_recording": true}]}}
	result := data.oepul.o6_5 with input as profile
	result.eligible
	amount := data.oepul.o6_5.premium({"breed": "Murbodner", "category": "cow", "milk_recording": true}) with input as profile
	amount > 334
	amount < 335
}

test_excludes_unknown_breed if {
	result := data.oepul.o6_5 with input as {"farm": {"year": 2025}, "livestock": {"breeding_animals": [{"animal_id": "AT2", "breed": "Unknown", "purebred": true, "zuchtbook_registered": true, "held_from_april_1": true, "held_through_december_31": true}]}}
	count(result.errors) == 1
}

test_regular_year_requires_december if {
	result := data.oepul.o6_5 with input as {"farm": {"year": 2025}, "livestock": {"breeding_animals": [{"animal_id": "AT3", "breed": "Noriker", "purebred": true, "zuchtbook_registered": true, "held_from_april_1": true, "held_through_december_31": false}]}}
	count(result.errors) == 1
}
