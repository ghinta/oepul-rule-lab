package oepul.o6_11_test

import data.oepul.o6_11 as policy
import rego.v1

base_profile := {
	"farm": {
		"year": 2024,
		"oepul": {
			"o6_11_application_year": 2024,
			"o6_11_contract_start_year": 2024,
			"measure_applications": [],
		},
	},
	"land": {
		"parcels": [
			{
				"parcel_id": "V1",
				"area_ha": 0.6,
				"land_use": "special_crop",
				"crop": {
					"crop_category": "vineyard",
					"crop_name": "Wein",
				},
				"operations": {
					"pesticide_applications": [],
				},
			},
		],
	},
}

test_minimum_area_and_premium if {
	result := policy.decision with input as base_profile
	result.eligible
	result.target_area_ha == 0.6
	result.premium_eur_per_ha == 270
	result.premium_amount_eur == 162
}

test_herbicide_application_is_violation if {
	profile := object.union(base_profile, {
		"land": {
			"parcels": [
				{
					"parcel_id": "V1",
					"area_ha": 0.6,
					"land_use": "special_crop",
					"crop": {"crop_category": "vineyard", "crop_name": "Wein"},
					"operations": {
						"pesticide_applications": [
							{"effect_type": "Herbizid", "is_herbicide": true},
						],
					},
				},
			],
		},
	})
	result := policy.decision with input as profile
	not result.herbicide_ban_satisfied
	{"code": "herbicide_use", "severity": "content"} in result.violations
}

test_walnut_is_not_premium_area if {
	profile := object.union(base_profile, {
		"land": {
			"parcels": [
				{
					"parcel_id": "W1",
					"area_ha": 1.0,
					"land_use": "special_crop",
					"crop": {"crop_category": "orchard", "crop_name": "Walnüsse"},
					"operations": {"pesticide_applications": []},
				},
			],
		},
	})
	result := policy.decision with input as profile
	result.target_area_ha == 1
	result.premium_area_ha == 0
	result.eligible
}

test_bio_combination_is_excluded_except_part_farm if {
	profile := object.union(base_profile, {
		"farm": {
			"year": 2024,
			"oepul": {
				"o6_11_application_year": 2024,
				"o6_11_contract_start_year": 2024,
				"measure_applications": [
					{"measure_id": "o6_1b", "active": true, "participation_type": "whole_farm"},
				],
			},
		},
	})
	result := policy.decision with input as profile
	not result.combination_satisfied
	{"code": "bio_combination", "severity": "combination"} in result.violations
}

test_participation_area_counts_vineyard_orchard_hop_only if {
	profile := object.union(base_profile, {
		"land": {
			"parcels": [
				{
					"parcel_id": "A1",
					"area_ha": 0.4,
					"land_use": "special_crop",
					"crop": {"crop_category": "orchard", "crop_name": "Apfel"},
					"operations": {"pesticide_applications": []},
				},
				{
					"parcel_id": "X1",
					"area_ha": 5.0,
					"land_use": "arable",
					"crop": {"crop_category": "cereal", "crop_name": "Weizen"},
					"operations": {"pesticide_applications": []},
				},
			],
		},
	})
	result := policy.decision with input as profile
	result.target_area_ha == 0.4
	not result.eligible
}

test_general_minimum_farm_size_by_eligible_area if {
	profile := object.union(base_profile, {
		"land": object.union(base_profile.land, {"oepul_eligible_area_ha": 1.5}),
	})
	result := policy.decision with input as profile
	result.general_minimum_farm_size_satisfied
}

test_general_minimum_farm_size_missing_is_violation if {
	result := policy.decision with input as base_profile
	not result.general_minimum_farm_size_satisfied
	{"code": "general_minimum_farm_size", "severity": "access"} in result.violations
}
