package oepul.o6_17_test

import data.oepul.o6_17
import rego.v1

test_first_year_eligibility_and_premium if {
	profile := {
		"farm": {"year": 2025},
		"land": {"grassland_area_ha": 10, "parcels": []},
		"oepul": {
			"o6_17": {
				"participating": true,
				"is_first_participation_year": true,
				"grassland_share_excluding_alpine_percent": 50,
				"rgve_total": 3,
				"forage_area_ha": 10,
				"combination": "ubb",
				"contract_start_year": 2025,
				"soil_basis_grassland_under_18_ha": 10.4,
				"mown_grassland_area_ha": 10,
				"average_grassland_score": 25,
				"slope_percent": 12,
				"soil_samples_submitted": 3,
				"grassland_break_documented": false,
				"total_farm_area_ha": 100,
			},
		},
	}
	result := o6_17.decision with input as profile
	result == {
		"eligible": true,
		"contract_duration_years": 4,
		"base_eligible_parcels": set(),
		"bonus_eligible_parcels": set(),
		"required_soil_samples": 3,
		"bonus_cap_ha": 2.5,
		"base_premium_eur_per_ha": 54,
		"bonus_premium_eur_per_ha": 262,
		"premium_multiplier": 1,
		"violations": set(),
	}
}

test_parcel_base_and_bonus_boundaries if {
	profile := {
		"farm": {"year": 2025},
		"land": {
			"grassland_area_ha": 4,
			"parcels": [
				{
					"parcel_id": "under18",
					"land_use": "grassland",
					"slope_percent": 17.9,
					"constraints": {"is_contract_nature_area": false},
					"o6_17": {"is_bergmaehder": false, "is_one_cut_meadow": true, "gloez2_or_gloez4_or_gloez9": false},
				},
				{
					"parcel_id": "over18-rich",
					"land_use": "grassland",
					"slope_percent": 18,
					"constraints": {"is_contract_nature_area": false},
					"o6_17": {"is_bergmaehder": false, "is_one_cut_meadow": false, "observed_kennarten": [{"name": "Wiesen-Salbei"}, {"name": "Wiesen-Margerite"}, {"name": "Zittergras"}, {"name": "Hornklee"}, {"name": "Bibernelle"}], "gloez2_or_gloez4_or_gloez9": true},
				},
			],
		},
		"oepul": {"o6_17": {"participating": true, "contract_start_year": 2025, "mown_grassland_area_ha": 4, "soil_basis_grassland_under_18_ha": 0, "total_farm_area_ha": 100, "grassland_break_documented": false, "combination": "bio", "is_first_participation_year": false}},
	}
	o6_17.base_eligible_parcels with input as profile == {"under18"}
	o6_17.bonus_eligible_parcels with input as profile == {"under18", "over18-rich"}
}

test_rgve_lookup if {
	o6_17.rgve_factor("cattle", "at_least_2_years") == 1
	o6_17.rgve_factor("sheep", "under_1_year") == 0.07
}

test_modulation_tiers if {
	profile := {"oepul": {"o6_17": {"total_farm_area_ha": 350}}}
	result := o6_17.premium_multiplier with input as profile
	result == 0.85
}
