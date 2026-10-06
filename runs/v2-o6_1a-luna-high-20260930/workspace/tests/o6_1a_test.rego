package o6_1a_test

import data.o6_1a
import rego.v1

test_arable_minimum_passes if {
	o6_1a.arable_minimum_ok with input as {
		"farm": {"year": 2026},
		"land": {"arable_area_ha": 10},
		"documentation": {"arable_div_ha": 0.7},
	}
}

test_arable_minimum_fails if {
	not o6_1a.arable_minimum_ok with input as {
		"farm": {"year": 2026},
		"land": {"arable_area_ha": 10},
		"documentation": {"arable_div_ha": 0.69},
	}
}

test_arable_fieldpiece_passes if {
	o6_1a.arable_fieldpiece_ok with input as {
		"land": {"arable_area_ha": 20},
		"documentation": {"arable_fieldpieces": [{"area_ha": 6, "div_plus_eligible_ha": 0.15}]},
	}
}

test_grassland_nfz_requires_63_days if {
	not o6_1a.grassland_nfz_ok with input as {
		"documentation": {
			"grassland_fallow_days": 62,
			"grassland_vehicle_entry_during_fallow": false,
			"grassland_fertilization_during_fallow": false,
			"grassland_second_use": true,
		},
	}
}

test_regional_seed_passes if {
	o6_1a.regional_seed_ok with input as {
		"documentation": {
			"regional_seed_species_count": 30,
			"regional_seed_plant_families": 7,
			"regional_seed_rate_kg_per_ha": 20,
			"regional_seed_max_species_weight_share": 0.05,
			"regional_origin_proven": true,
		},
	}
}

test_regional_grassland_seed_rejects_steepness if {
	not o6_1a.regional_grassland_seed_ok with input as {
		"land": {"parcels": [{"slope_percent": 18}]},
		"documentation": {
			"regional_grassland_number": 30,
			"regional_seed_species_count": 30,
			"regional_seed_plant_families": 7,
			"regional_seed_rate_kg_per_ha": 20,
			"regional_seed_max_species_weight_share": 0.05,
			"regional_origin_proven": true,
		},
	}
}

test_pheromone_requires_five_weeks if {
	not o6_1a.pheromone_ok with input as {
		"farm": {"year": 2026},
		"documentation": {
			"pheromone_traps_per_ha": 15,
			"pheromone_days_after_sowing": 14,
			"pheromone_field_days": 34,
			"pheromone_emptyings": 2,
			"pheromone_records_complete": true,
		},
	}
}

test_drought_third_use_codes if {
	o6_1a.drought_third_use_allowed with input as {
		"farm": {"year": 2026},
		"documentation": {"drought_2026": {"third_use": true, "relief_code": "OPBIO"}},
	}
}

test_arable_premium_2025 if {
	o6_1a.arable_base_premium == 85 with input as {"farm": {"year": 2025}}
}

test_modulation_200_is_full if {
	o6_1a.modulation_factor == 1 with input as {"land": {"total_area_ha": 200}}
}
