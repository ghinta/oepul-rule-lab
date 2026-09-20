package oepul.o6_1a

import rego.v1

base_input := {
	"farm": {"year": 2026, "region": {"federal_state": "Niederösterreich", "district": "Amstetten"}},
	"land": {
		"arable_area_ha": 10,
		"grassland_area_ha": 4,
		"mown_grassland_area_excluding_mountain_meadows_ha": 4,
		"parcels": [
			{
				"parcel_id": "A1",
				"area_ha": 5,
				"land_use": "arable",
				"slope_percent": 0,
				"crop": {"crop_category": "cereal", "crop_name": "Weizen"},
				"operations": {"psm_used": false, "fertilizer": {"mineral_n_kg_per_ha": 0, "organic_n_kg_per_ha": 0}},
				"constraints": {"biodiversity_area": {"is_biodiversity_area": false}},
			},
			{
				"parcel_id": "A2",
				"area_ha": 4,
				"land_use": "arable",
				"slope_percent": 0,
				"crop": {"crop_category": "legume", "crop_name": "Erbsen"},
				"operations": {"psm_used": false, "fertilizer": {"mineral_n_kg_per_ha": 0, "organic_n_kg_per_ha": 0}},
				"constraints": {"biodiversity_area": {"is_biodiversity_area": false}},
			},
			{
				"parcel_id": "DIV-A",
				"area_ha": 1,
				"land_use": "arable",
				"slope_percent": 0,
				"codes": ["DIV"],
				"crop": {"crop_category": "fallow", "crop_name": "Grünbrache"},
				"operations": {"psm_used": false, "biodiversity_use_count": 1, "fertilizer": {"mineral_n_kg_per_ha": 0, "organic_n_kg_per_ha": 0}},
				"constraints": {"biodiversity_area": {"is_biodiversity_area": true, "sowing_date": "2026-05-01", "seed_mix": {"insect_pollinated_partners": 7, "plant_families": 3, "non_insect_pollinated_percent": 10}}},
			},
			{
				"parcel_id": "DIV-G",
				"area_ha": 0.4,
				"land_use": "grassland",
				"slope_percent": 10,
				"codes": ["DIVSZ"],
				"crop": {"crop_category": "other", "crop_name": "Mähwiese/-weide"},
				"operations": {"psm_used": false, "first_use_date": "2026-07-15", "fertilizer": {"mineral_n_kg_per_ha": 0, "organic_n_kg_per_ha": 0}},
				"constraints": {"biodiversity_area": {"is_biodiversity_area": true, "variant_code": "DIVSZ"}},
			},
		],
		"field_blocks": [
			{"field_block_id": "FB-A", "land_use": "arable", "area_ha": 6, "biodiversity_credit_area_ha": 0.15},
			{"field_block_id": "FB-G", "land_use": "grassland", "area_ha": 6, "mown_area_excluding_mountain_meadows_ha": 6, "biodiversity_credit_area_ha": 0.15},
		],
	},
	"livestock": {"species_groups": [{"species": "cattle", "category": "cattle_from_2_years", "animal_count": 2, "gve": 2}]},
	"documentation": {"biodiversity_training_hours_since_2022": 3},
}

test_base_input_allows if {
	allow with input as base_input
}

test_cereal_maize_limit_violation if {
	bad_land := object.union(base_input.land, {"parcels": [object.union(base_input.land.parcels[0], {"area_ha": 8}), base_input.land.parcels[1], base_input.land.parcels[2], base_input.land.parcels[3]]})
	bad := object.union(base_input, {"land": bad_land})
	result := violations with input as bad
	has_violation(result, "O6_1A.ARABLE_DIVERSIFICATION.CEREAL_MAIZE_MAX_75")
}

test_arable_biodiversity_minimum_violation if {
	bad_land := object.union(base_input.land, {"parcels": [base_input.land.parcels[0], base_input.land.parcels[1], object.union(base_input.land.parcels[2], {"area_ha": 0.5}), base_input.land.parcels[3]]})
	bad := object.union(base_input, {"land": bad_land})
	result := violations with input as bad
	has_violation(result, "O6_1A.ARABLE_BIODIVERSITY.MIN_7_PERCENT")
}

test_divrs_species_violation if {
	divrs := object.union(base_input.land.parcels[3], {
		"codes": ["DIVRS"],
		"constraints": {"average_grassland_score": 35, "biodiversity_area": {"is_biodiversity_area": true, "variant_code": "DIVRS", "seed_mix": {"species_count": 20, "plant_families": 7, "sowing_rate_kg_per_ha": 20, "max_single_species_weight_percent": 5}}},
	})
	bad_land := object.union(base_input.land, {"parcels": [base_input.land.parcels[0], base_input.land.parcels[1], base_input.land.parcels[2], divrs]})
	bad := object.union(base_input, {"land": bad_land})
	result := violations with input as bad
	has_violation(result, "O6_1A.DIVRS.REGIONAL_SEED_MIX")
}

test_livestock_classification if {
	result := classification with input as base_input
	result == {"is_livestock_holding": true, "rgve_total": 2, "forage_area_ha": 4}
}

test_dry_2026_third_use_exception if {
	div := object.union(base_input.land.parcels[2], {"op_code_no_ubb_premium": true, "operations": object.union(base_input.land.parcels[2].operations, {"biodiversity_use_count": 3})})
	exc_land := object.union(base_input.land, {"parcels": [base_input.land.parcels[0], base_input.land.parcels[1], div, base_input.land.parcels[3]]})
	exc := object.union(base_input, {"land": exc_land})
	result := violations with input as exc
	not has_violation(result, "O6_1A.ARABLE_BIODIVERSITY.MAX_TWO_USES")
}

test_premium_rate_loaded if {
	premium_rates.arable_base == 85.0
	premium_rates.pheromone_beet == 150.0
}

has_violation(result, rule_id) if {
	some v in result
	v.rule_id == rule_id
}
