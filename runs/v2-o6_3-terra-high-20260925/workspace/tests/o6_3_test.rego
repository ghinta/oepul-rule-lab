package oepul.o6_3_test

import data.oepul.o6_3
import rego.v1

base_input := {
	"land": {"parcels": [
		{"area_ha": 2.5, "land_use": "grassland", "heuwirtschaft_use": "mown_meadow_or_pasture", "crop": {"crop_name": null}},
		{"area_ha": 1, "land_use": "arable", "heuwirtschaft_second_crop": false, "crop": {"crop_name": "Klee"}},
	]},
	"heuwirtschaft": {
		"base_measure": "ubb",
		"animals": [{"category": "cattle_2_plus", "count": 2}],
		"silage": {"prepared": false, "fed": false, "stored": false, "own_stock_consumed": false},
		"mowing_material_transfers": [{"form": "dry_hay"}],
		"green_feeding": {"during_majority_of_vegetation": true, "applies_to_all_roughage_animals": true},
		"option_no_mowing_conditioner": false,
		"mowing_conditioner_used": false,
		"mowing_conditioner_present": false,
	},
}

test_first_year_eligible if {
	o6_3.eligible_first_year with input as base_input
	o6_3.premium_rate_eur_per_ha == 145.8 with input as base_input
	o6_3.eligible_premium_area_ha == 3.5 with input as base_input
}

test_no_conditioner_premium if {
	o6_3.premium_rate_eur_per_ha == 167.4 with input as object.union(base_input, {"heuwirtschaft": object.union(base_input.heuwirtschaft, {"option_no_mowing_conditioner": true})})
}

test_silage_violation if {
	not o6_3.silage_compliant with input as object.union(base_input, {"heuwirtschaft": object.union(base_input.heuwirtschaft, {"silage": {"prepared": true, "fed": false, "stored": false, "own_stock_consumed": false}})})
}

test_second_crop_excluded_from_premium_and_fodder_area if {
	test_input := object.union(base_input, {"land": {"parcels": [
		{"area_ha": 2.5, "land_use": "grassland", "heuwirtschaft_use": "mown_meadow_or_pasture", "crop": {"crop_name": null}},
		{"area_ha": 1, "land_use": "arable", "heuwirtschaft_second_crop": true, "crop": {"crop_name": "Klee"}},
	]}})
	o6_3.eligible_premium_area_ha == 2.5 with input as test_input
	o6_3.fodder_area_ha == 2.5 with input as test_input
}
