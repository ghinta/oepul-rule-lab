package o6_1b

import rego.v1

valid_base_input := {
	"year": 2026,
	"first_participation_year": 2025,
	"contract": {"start_year": 2025, "end_date": "2028-12-31"},
	"certifications": {"organic": {"is_certified": true, "control_body": "control"}},
	"land": {
		"total_area_ha": 100,
		"protected_cultivation_area_ha": 0,
		"arable_area_ha": 20,
		"mowed_grassland_area_ha": 20,
		"arable_biodiversity_area_ha": 1.4,
		"grassland_biodiversity_area_ha": 1.4,
		"grain_and_maize_share": 0.7,
		"max_crop_share": 0.5,
		"arable_fields_with_more_than_5ha_are_valid": true,
		"grassland_fields_with_more_than_5ha_are_valid": true,
	},
	"livestock": {
		"has_livestock": false,
		"uncertified_fattening_pigs": 0,
		"uncertified_chickens": 0,
		"conventional_equines_only": false,
	},
}

test_base_participation_is_eligible if {
	eligible with input as valid_base_input
}

test_arable_diversification_rejects_excessive_grain if {
	not arable_diversification_valid with input as object.union(valid_base_input, {"land": object.union(valid_base_input.land, {"grain_and_maize_share": 0.76})})
}

test_arable_biodiversity_threshold if {
	arable_biodiversity_minimum_valid with input as valid_base_input
}

test_arable_biodiversity_deadline_allows_unrestricted_quarter if {
	arable_biodiversity_deadline_valid with input as object.union(valid_base_input, {"biodiversity": {"arable": {"unrestricted_share": 0.25}}})
}

test_grassland_divnfz_requires_63_days if {
	grassland_variant_valid with input as object.union(valid_base_input, {"biodiversity": {"grassland": {"variant": "DIVNFZ", "dormant_days": 63, "second_use_in_year": true}}})
}

test_regional_seed_requires_30_species_and_7_families if {
	regional_seed_valid with input as object.union(valid_base_input, {"biodiversity": {"regional_seed": {"kind": "arable", "species_count": 30, "family_count": 7, "seed_rate_kg_ha": 20, "max_single_species_share": 0.05, "regional_origin_documented": true, "sown_date": "2026-05-15"}}})
}

test_pheromone_minimum if {
	pheromone_valid with input as object.union(valid_base_input, {"pheromone_traps": {"is_sugar_beet_or_previous_sugar_beet_parcel": true, "traps_per_ha": 15, "days_on_field": 35, "emptyings_during_minimum_period": 2, "records_complete": true}})
}

test_2026_early_use_requires_opbio if {
	management_code_for_2026_exception == "OPBIO" with input as object.union(valid_base_input, {"biodiversity": {"early_use_before_august": true}})
}

test_modulation_factor_for_220_hectares if {
	premium_cap_factor >= 0.9909
	premium_cap_factor <= 0.9910
		with input as object.union(valid_base_input, {"land": object.union(valid_base_input.land, {"total_area_ha": 220})})
}
