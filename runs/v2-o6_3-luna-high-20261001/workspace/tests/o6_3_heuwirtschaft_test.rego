package oepul.o6_3_test

import rego.v1

test_valid_heuwirtschaft_with_option if {
	result := data.oepul.o6_3.result with input as {
		"farm": {"heuwirtschaft": {
			"measure": "o6_3",
			"contract_start_year": 2025,
			"year": 2025,
			"participation": {"combined_measure": "o6_1a"},
			"first_year": {"mown_meadow_meadow_pasture_ha": 2.5, "rgve_total": 3.9, "fodder_area_ha": 10},
			"silage_preparation_and_feeding": false,
			"feed_fermentation": false,
			"silage_storage": false,
			"green_feeding_majority_april_to_september": true,
			"third_party_cuttings_only_dry_hay": true,
			"mower_conditioner_used": false,
			"mower_conditioner_present": false,
			"no_mower_conditioner_option": true,
		}},
		"land": {"parcels": [
			{"area_ha": 10, "land_use": "grassland", "oepul": {"is_applied": true, "is_second_crop": false, "is_premium_eligible": true}},
		]},
		"livestock": {"species_groups": [
			{"species": "cattle", "category": "ab_2_jahre", "animal_count": 3},
			{"species": "sheep_goats", "category": "ab_1_jahr", "animal_count": 6},
		]},
	}
	result.eligible == true
	result.first_year_access == true
	result.rgve_total == 3.9
	result.fodder_area_ha == 10
	result.premium_eur_per_ha == 167.4
	result.premium_eur == 1674
	count(result.violations) == 0
}

test_second_year_low_stock_does_not_change_rate_rule_input if {
	result := data.oepul.o6_3.result with input as {
		"farm": {"heuwirtschaft": {
			"measure": "o6_3",
			"contract_start_year": 2024,
			"year": 2026,
			"participation": {"combined_measure": "o6_1b"},
			"first_year": {"mown_meadow_meadow_pasture_ha": 2, "rgve_total": 0.6, "fodder_area_ha": 2},
			"silage_preparation_and_feeding": false,
			"feed_fermentation": false,
			"silage_storage": false,
			"green_feeding_majority_april_to_september": true,
			"third_party_cuttings_only_dry_hay": true,
			"no_mower_conditioner_option": false,
		}},
		"land": {"parcels": [{"area_ha": 2, "land_use": "grassland", "oepul": {"is_applied": true, "is_second_crop": false, "is_premium_eligible": true}}]},
		"livestock": {"species_groups": [{"species": "cattle", "category": "ab_2_jahre", "animal_count": 1}]},
	}
	result.first_year_access == true
	result.premium_eur_per_ha == 145.8
}

test_noncompliance_is_reported if {
	result := data.oepul.o6_3.result with input as {
		"farm": {"heuwirtschaft": {
			"measure": "o6_3",
			"contract_start_year": 2025,
			"year": 2025,
			"participation": {"combined_measure": "o6_1a"},
			"first_year": {"mown_meadow_meadow_pasture_ha": 1.5, "rgve_total": 0.2, "fodder_area_ha": 2},
			"silage_preparation_and_feeding": true,
			"feed_fermentation": true,
			"silage_storage": true,
			"green_feeding_majority_april_to_september": false,
			"third_party_cuttings_only_dry_hay": false,
			"no_mower_conditioner_option": false,
		}},
		"land": {"parcels": [{"area_ha": 2, "land_use": "grassland", "oepul": {"is_applied": true, "is_second_crop": false, "is_premium_eligible": true}}]},
		"livestock": {"species_groups": []},
	}
	result.eligible == false
	count(result.violations) >= 5
}

test_second_crop_is_excluded_from_fodder_area if {
	result := data.oepul.o6_3.result with input as {
		"farm": {"heuwirtschaft": {
			"measure": "o6_3",
			"contract_start_year": 2025,
			"year": 2025,
			"participation": {"combined_measure": "o6_1a"},
			"first_year": {"mown_meadow_meadow_pasture_ha": 2, "rgve_total": 0.6, "fodder_area_ha": 2},
			"silage_preparation_and_feeding": false,
			"feed_fermentation": false,
			"silage_storage": false,
			"green_feeding_majority_april_to_september": true,
			"third_party_cuttings_only_dry_hay": true,
			"no_mower_conditioner_option": false,
		}},
		"land": {"parcels": [
			{"area_ha": 2, "land_use": "grassland", "oepul": {"is_applied": true, "is_second_crop": false, "is_premium_eligible": true}},
			{"area_ha": 3, "land_use": "arable", "oepul": {"is_applied": true, "crop_name": "klee", "is_second_crop": true, "is_premium_eligible": false}},
		]},
		"livestock": {"species_groups": [{"species": "cattle", "category": "ab_2_jahre", "animal_count": 1}]},
	}
	result.fodder_area_ha == 2
	result.premium_area_ha == 2
	result.premium_eur_per_ha == 145.8
}

test_drought_2026_exception_is_explicit if {
	result := data.oepul.o6_3.result with input as {
		"farm": {"heuwirtschaft": {
			"measure": "o6_3",
			"contract_start_year": 2025,
			"year": 2026,
			"participation": {"combined_measure": "o6_1a"},
			"first_year": {"mown_meadow_meadow_pasture_ha": 2, "rgve_total": 0.6, "fodder_area_ha": 2},
			"silage_preparation_and_feeding": false,
			"feed_fermentation": false,
			"silage_storage": false,
			"green_feeding_majority_april_to_september": true,
			"third_party_cuttings_only_dry_hay": true,
			"no_mower_conditioner_option": false,
			"drought_exception_area": true,
			"no_harvestable_stand": true,
		}},
		"land": {"parcels": [{"area_ha": 2, "land_use": "arable", "oepul": {"is_applied": true, "crop_name": "futtergräser", "is_second_crop": false, "is_premium_eligible": true}}]},
		"livestock": {"species_groups": [{"species": "cattle", "category": "ab_2_jahre", "animal_count": 1}]},
	}
	result.drought_exception_applies == true
}
