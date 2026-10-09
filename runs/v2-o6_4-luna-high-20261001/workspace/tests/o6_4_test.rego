package o6_4

import rego.v1

test_premium_2026_by_mowing_code if {
	premium_amount with input as {"farm": {"o6_4": {"year": 2026, "code": "BM1"}}} == 378
	premium_amount with input as {"farm": {"o6_4": {"year": 2026, "code": "BM2"}}} == 594
	premium_amount with input as {"farm": {"o6_4": {"year": 2026, "code": "BM3"}}} == 972
	premium_amount with input as {"farm": {"o6_4": {"year": 2026, "code": "BM0"}}} == 0
}

test_eligible_parcel_requires_majority_above_1200m if {
	ids := eligible_parcel_ids with input as {"land": {"home_farm_elevation_m": 900, "parcels": [{"parcel_id": "P1", "area_ha": 2, "land_use": "Bergmähder", "above_local_settlement_boundary": true, "difficult_to_manage": true, "elevation_m": 1250, "elevation_above_1200_area_ha": 1.1, "is_alpine_farm_exception": false, "measure_participation": [{"measure": "o6_4", "participating": true}]}]}}
	ids == {"P1"}
}

test_ineligible_parcel_below_majority if {
	findings := eligibility_findings with input as {"land": {"home_farm_elevation_m": 900, "parcels": [{"parcel_id": "P1", "area_ha": 2, "land_use": "Bergmähder", "elevation_m": 1000, "elevation_above_1200_area_ha": 1, "measure_participation": [{"measure": "o6_4", "participating": true}]}]}}
	{"parcel_id": "P1", "reason": "more_than_half_above_1200m_required"} in findings
}

test_bm0_has_no_premium if {
	no_mowing_no_premium with input as {"farm": {"o6_4": {"year": 2026, "code": "BM0"}}}
}

test_prohibited_fertilizer_is_violation if {
	findings := violations with input as {"farm": {"o6_4": {"year": 2026, "code": "BM1"}}, "land": {"parcels": [{"parcel_id": "P1", "measure_participation": [{"measure": "o6_4", "participating": true}], "operations": {"fertilizer_applications": [{"material": "mineral_fertilizer"}]}}]}}
	{"parcel_id": "P1", "reason": "prohibited_fertilizer_or_sludge"} in findings
}

test_landscape_element_exception_is_allowed if {
	findings := violations with input as {"farm": {"o6_4": {"year": 2026, "code": "BM1"}}, "land": {"parcels": [{"parcel_id": "P1", "measure_participation": [{"measure": "o6_4", "participating": true}], "other_measures": [{"measure_code": "o6_1a_landscape_element_compensation"}]}]}}
	not {"parcel_id": "P1", "reason": "unpermitted_combination"} in findings
}

test_invalid_code_is_violation if {
	findings := violations with input as {"farm": {"o6_4": {"year": 2026, "code": "BM9"}}}
	{"reason": "invalid_mowing_code"} in findings
}

test_contract_and_modulation_rules if {
	end := contract_end_date with input as {"farm": {"o6_4": {"contract_start_year": 2025}}}
	duration := contract_duration_years with input as {"farm": {"o6_4": {"contract_start_year": 2025}}}
	factor := modulation_factor with input as {"land": {"total_area_ha": 220}}
	end == "2028-12-31"
	duration == 4
	factor == 0.9909090909090909091
}

test_area_access_and_measure_change if {
	area_access_allowed with input as {"farm": {"o6_4": {"access_year": 2026, "added_area_ha": 4, "base_2025_area_ha": 8}}}
	measure_change_allowed with input as {"farm": {"o6_4": {"measure_change_date": "2025-12-31", "target_measure": "o6_18"}}}
	op_code_no_premium with input as {"land": {"parcels": [{"code": "OP"}]}}
}

test_conditionality_uses_measure_profile_object if {
	conditionality_compliant with input as {"farm": {"o6_4": {"compliance": {"conditionality_compliant": true}}}}
}

test_array_profile_fields_are_read_from_flat_parcel_leaves if {
	findings := violations with input as {"farm": {"o6_4": {"year": 2026, "code": "BM1"}}, "land": {"parcels": [{"parcel_id": "P1", "measure_participation": [{"measure": "o6_4", "participating": true}], "operations": {"mowing_years": [{"year": 2026, "full_area": false}], "grazing_periods": [{"start_date": "2026-08-15", "grazing_type": "aftermath"}], "plant_protection_applications": [{"bio_regulation_2018_848_allowed": false}]}}]}}
	{"parcel_id": "P1", "reason": "mowing_not_full_area"} in findings
	{"parcel_id": "P1", "reason": "grazing_before_16_august"} in findings
	{"parcel_id": "P1", "reason": "prohibited_plant_protection_product"} in findings
}
