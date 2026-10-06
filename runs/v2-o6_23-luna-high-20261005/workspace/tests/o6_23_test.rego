package oepul.o6_23_test

import rego.v1

import data.oepul.o6_23

valid_input := {
	"farm": {"year": 2026},
	"land": {
		"total_area_ha": 100,
		"parcels": [{
			"parcel_id": "P1",
			"area_ha": 2,
			"land_use": "grassland",
			"country": "AT",
			"is_natura2000_or_high_nature_value": true,
			"project_confirmation": true,
			"application_code": "N2",
			"n2_code": "N2GI05",
			"annual_full_area_mown_or_grazed": true,
			"operations": {"fertilizer": {"mineral_n_kg_per_ha": 0, "organic_n_kg_per_ha": 0}, "cutting_dates": []},
		}],
	},
	"measure": {"o6_23": {
		"requested": true,
		"contract_years": 1,
		"application_date": "2025-12-31",
		"other_measures": ["o6_1a"],
	}},
}

test_valid_n2gi05 if {
	result := o6_23.evaluate with input as valid_input
	result.compliant
	result.premium_eur == 702
	result.parcel_results[0].premium_eur_ha == 351
}

test_2023_rate_table if {
	result := o6_23.evaluate with input as object.union(valid_input, {"farm": {"year": 2023}})
	result.parcel_results[0].premium_eur_ha == 325
}

test_gi_fertilizer_is_noncompliant if {
	result := o6_23.evaluate with input as object.union(valid_input, {
		"land": {"total_area_ha": 100, "parcels": [{
			"parcel_id": "P1", "area_ha": 2, "land_use": "grassland", "country": "AT",
			"is_natura2000_or_high_nature_value": true, "project_confirmation": true,
			"application_code": "N2", "n2_code": "N2GI06", "fertilizer_applied": true,
			"annual_full_area_mown_or_grazed": true,
		}]},
	})
	not result.compliant
	not result.all_parcels_valid
}

test_missing_n2_application_code_is_noncompliant if {
	result := o6_23.evaluate with input as object.union(valid_input, {
		"land": {"total_area_ha": 100, "parcels": [{
			"parcel_id": "P1", "area_ha": 2, "land_use": "grassland", "country": "AT",
			"is_natura2000_or_high_nature_value": true, "project_confirmation": true,
			"application_code": "", "n2_code": "N2GL37", "annual_full_area_mown_or_grazed": true,
		}]},
	})
	not result.compliant
}

test_disallowed_measure_is_noncompliant if {
	result := o6_23.evaluate with input as object.union(valid_input, {
		"measure": {"o6_23": {"requested": true, "contract_years": 1, "application_date": "2025-12-31", "other_measures": ["o6_3"]}},
	})
	not result.compliant
	result.invalid_combination
}

test_annex_j_matrix_is_used if {
	o6_23.chapter_pair_is_allowed("G", "A") == false
	o6_23.chapter_pair_is_allowed("G", "L")
}

test_annex_j_invalid_obligation_combination_is_noncompliant if {
	result := o6_23.evaluate with input as object.union(valid_input, {
		"land": {"total_area_ha": 100, "parcels": [{
			"parcel_id": "P1", "area_ha": 2, "land_use": "grassland", "country": "AT",
			"is_natura2000_or_high_nature_value": true, "project_confirmation": true,
			"application_code": "N2", "n2_code": "N2GI05", "annual_full_area_mown_or_grazed": true,
			"project_confirmation_obligations": [{"chapter": "G", "code": "GL02"}, {"chapter": "A", "code": "AA01"}],
		}]},
	})
	not result.compliant
	not result.all_parcels_valid
}

test_2026_cut_date_exception_preserves_premium if {
	result := o6_23.evaluate with input as object.union(valid_input, {
		"land": {"total_area_ha": 100, "parcels": [{
			"parcel_id": "P1", "area_ha": 1, "land_use": "grassland", "country": "AT",
			"is_natura2000_or_high_nature_value": true, "project_confirmation": true,
			"application_code": "N2", "n2_code": "N2GL04", "project_confirmation_cut_date": "2026-07-15",
			"operations": {"cutting_dates": ["2026-07-01"]}, "annual_full_area_mown_or_grazed": true,
		}]},
		"measure": {"o6_23": {"requested": true, "contract_years": 1, "application_date": "2025-12-31", "state_regulation_adjusted": true, "cut_date_changed": true}},
	})
	result.compliant
	result.exception_2026_cut_date
	result.parcel_results[0].premium_eur_ha == 226.8
}

test_modulation_is_progressive if {
	result := o6_23.evaluate with input as object.union(valid_input, {"land": {"total_area_ha": 220, "parcels": valid_input.land.parcels}})
	result.modulation_factor > 0.9909
	result.modulation_factor < 0.9910
}

test_withdrawal_current_year_invalidates if {
	result := o6_23.evaluate with input as object.union(valid_input, {"measure": {"o6_23": {"requested": true, "contract_years": 1, "application_date": "2025-12-31", "contract_year_completed": true, "withdrawal_date": "2026-06-01"}}})
	result.withdrawal_allowed
	result.withdrawal_invalid_current_year
}
