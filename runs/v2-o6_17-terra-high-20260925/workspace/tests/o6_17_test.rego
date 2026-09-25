package oepul.o6_17_test

import rego.v1

test_compliant_farm_calculates_base_and_agl if {
	result := data.oepul.o6_17.evaluation with input as {
		"o6_17": {
			"application_year": 2025,
			"first_commitment_year": true,
			"participates_ubb": true,
			"participates_bio": false,
			"first_year_grassland_ha": 4,
			"first_year_agricultural_area_excl_alpine_ha": 8,
			"fodder_area_ha": 4,
			"mowed_grassland_ha": 4,
			"eligible_grassland_under_18_ha_maa_2025": 4,
			"animals": [{"animal_key": "cattle_at_least_two_years", "count": 2}],
			"training": {"completed_by_2025_12_31": true, "hours": 5, "provider_recognized": true},
			"soil_samples": {"valid_count": 1, "submitted_by_2025_12_31": true, "results_recorded_in_ama_database": true, "all_ph_p_k_humus": true, "accredited_laboratory": true},
			"parcels": [{"parcel_id": "G1", "area_ha": 4, "is_grassland": true, "slope_percent": 10, "grassland_number": 25, "gloez_umbrechungsverbot": false, "agl_requested": true, "mowed": true, "is_bergmaehder": false, "annual_cuts": 2, "indicator_species": ["Wiesen-Salbei", "Wiesen-Margerite", "Hornklee", "Wundklee", "Thymian"], "first_use_type": "mowing", "field_visit_documented": true, "operations": []}],
		},
	}
	result.tierhaltend
	result.base_payment_eur == 216
	result.agl_cap_ha == 2
	result.agl_requested_ha == 4
	count(result.violations) == 0
}

test_ploughing_and_missing_combo_are_violations if {
	violations := data.oepul.o6_17.violations with input as {"o6_17": {"application_year": 2025, "first_commitment_year": false, "participates_ubb": false, "participates_bio": false, "fodder_area_ha": 1, "mowed_grassland_ha": 1, "eligible_grassland_under_18_ha_maa_2025": 0, "animals": [], "training": {"completed_by_2025_12_31": true, "hours": 5, "provider_recognized": true}, "soil_samples": {"valid_count": 0, "submitted_by_2025_12_31": true, "results_recorded_in_ama_database": true, "all_ph_p_k_humus": true, "accredited_laboratory": true}, "parcels": [{"parcel_id": "G2", "area_ha": 1, "is_grassland": true, "slope_percent": 10, "grassland_number": 20, "gloez_umbrechungsverbot": false, "agl_requested": false, "mowed": true, "is_bergmaehder": false, "annual_cuts": 1, "indicator_species": [], "first_use_type": "mowing", "field_visit_documented": true, "operations": [{"kind": "ploughing", "pest_sanitation_documented": false, "regional_biodiversity_seed_mix": false}]}]}}
	violations.missing_required_combination_ubb_or_bio
	violations["greenland_ploughing_not_exception:G2"]
}

test_gloez_area_excluded_from_base_payment if {
	payment := data.oepul.o6_17.base_payment_eur with input as {"o6_17": {"application_year": 2025, "parcels": [{"area_ha": 3, "is_grassland": true, "slope_percent": 10, "grassland_number": 40, "gloez_umbrechungsverbot": true}]}}
	payment == 0
}

test_historical_2023_rates_are_available if {
	data.oepul.o6_17.base_rate(19, 2023) == 30
	data.oepul.o6_17.base_rate(20, 2023) == 50
	data.oepul.o6_17.agl_rate({"slope_percent": 10}, 2023) == 150
}
