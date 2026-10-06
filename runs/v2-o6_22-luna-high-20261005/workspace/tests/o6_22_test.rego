package oepul.o6_22_test

import rego.v1

test_minimum_participation_is_two_gve if {
	data.oepul.o6_22.eligible with input as {
		"livestock": {"o6_22": {"measure": "o6_22", "participation_gve": 2}},
	}
}

test_below_minimum_is_not_eligible if {
	not data.oepul.o6_22.eligible with input as {
		"livestock": {"o6_22": {"measure": "o6_22", "participation_gve": 1.99}},
	}
}

test_piglet_space_table if {
	data.oepul.o6_22.required_space("piglets", "up_to_20_kg") == {
		"category": "piglets",
		"weight_band": "up_to_20_kg",
		"max_weight_kg": 20,
		"lying_area_m2_per_animal": 0.12,
		"total_area_m2_per_animal": 0.3,
	}
}

test_stall_area_requires_forty_percent_bedding if {
	data.oepul.o6_22.stall_area_compliant("growers_and_fattening_pigs", "over_85_kg", 10, 11, 4.4)
	not data.oepul.o6_22.stall_area_compliant("growers_and_fattening_pigs", "over_85_kg", 10, 11, 4.39)
}

test_free_range_fallback_density if {
	data.oepul.o6_22.free_range_compliant with input as {
		"livestock": {"o6_22": {
			"sow_type": "mated_gilts",
			"free_range": {
				"authority_max_gve_per_ha": null,
				"actual_gve_per_ha": 4,
				"continuous_use_years": 1,
				"wild_boar_exclusion": true,
				"feed_and_water_separated": true,
				"feed_on_hard_surface_or_moved_regularly": true,
				"feed_roofed": true,
				"roofed_three_sided_bedded_shelter": true,
				"all_animals_can_lie_simultaneously": true,
				"farrowing_huts_available": false,
			},
		}},
	}
}

test_compost_requires_fourteen_day_interval if {
	data.oepul.o6_22.compost_surcharge_eligible with input as {
		"livestock": {"o6_22": {
			"year": 2025,
			"supplement_facts": {
				"compost_requested": true,
				"all_farm_solid_manure_composted": true,
				"compost_turn_count": 2,
				"compost_turn_interval_days": 14,
				"compost_documentation_complete": true,
				"compost_stall": false,
			},
		}},
	}
}

test_long_individual_housing_requires_deregistration if {
	data.oepul.o6_22.report_deregistration_required with input as {
		"livestock": {"o6_22": {"individual_housing_days": 11, "reporting": {"category_conditions_not_met": false}}},
	}
}

test_premium_from_2024 if {
	data.oepul.o6_22.premium_eur_per_gve("piglets", 2026) == 194.4
}

test_premium_calculation_uses_deregistered_heads if {
	result := data.oepul.o6_22.eligible_gve_from_heads with input as {
		"livestock": {"o6_22": {
			"category": "piglets",
			"applied_heads": 100,
			"deregistered_heads": 10,
		}},
	}
	result == 6.3
}
