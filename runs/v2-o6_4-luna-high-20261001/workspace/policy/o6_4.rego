package o6_4

import rego.v1

default premium_amount := null

premium_amount := data.o6_4.premiums_eur_per_ha[y][input.farm.o6_4.code] if {
	input.farm.o6_4.year >= 2023
	y := sprintf("%v", [input.farm.o6_4.year])
	data.o6_4.premiums_eur_per_ha[y][input.farm.o6_4.code]
}

participates(parcel) if {
	some participation in parcel.measure_participation
	participation.measure == "o6_4"
	participation.participating == true
}

eligible_parcel_ids contains parcel.parcel_id if {
	some parcel in input.land.parcels
	participates(parcel)
	parcel.land_use == data.o6_4.eligible_land_use
	parcel.above_local_settlement_boundary == true
	parcel.difficult_to_manage == true
	parcel.elevation_above_1200_area_ha > parcel.area_ha / 2
	parcel.elevation_above_1200_area_ha > 0
	parcel.elevation_m > input.land.home_farm_elevation_m
	parcel.is_alpine_farm_exception != true
	parcel.parcel_id != ""
}

eligible_parcel_ids contains parcel.parcel_id if {
	some parcel in input.land.parcels
	participates(parcel)
	parcel.land_use == data.o6_4.eligible_land_use
	parcel.above_local_settlement_boundary == true
	parcel.difficult_to_manage == true
	parcel.elevation_above_1200_area_ha > parcel.area_ha / 2
	parcel.elevation_above_1200_area_ha > 0
	parcel.is_alpine_farm_exception == true
	parcel.parcel_id != ""
}

eligibility_findings contains {"parcel_id": parcel.parcel_id, "reason": "Bergmähder_land_use_required"} if {
	some parcel in input.land.parcels
	participates(parcel)
	parcel.land_use != data.o6_4.eligible_land_use
}

eligibility_findings contains {"parcel_id": parcel.parcel_id, "reason": "above_local_settlement_boundary_required"} if {
	some parcel in input.land.parcels
	participates(parcel)
	parcel.above_local_settlement_boundary != true
}

eligibility_findings contains {"parcel_id": parcel.parcel_id, "reason": "difficult_to_manage_required"} if {
	some parcel in input.land.parcels
	participates(parcel)
	parcel.difficult_to_manage != true
}

eligibility_findings contains {"parcel_id": parcel.parcel_id, "reason": "more_than_half_above_1200m_required"} if {
	some parcel in input.land.parcels
	participates(parcel)
	parcel.elevation_above_1200_area_ha <= parcel.area_ha / 2
}

eligibility_findings contains {"parcel_id": parcel.parcel_id, "reason": "parcel_must_be_above_home_farm_elevation"} if {
	some parcel in input.land.parcels
	participates(parcel)
	parcel.elevation_m <= input.land.home_farm_elevation_m
	parcel.is_alpine_farm_exception != true
}

missing_data contains "land.parcels[].elevation_above_1200_area_ha" if {
	some parcel in input.land.parcels
	participates(parcel)
	not parcel.elevation_above_1200_area_ha
}

missing_data contains "land.home_farm_elevation_m" if {
	some parcel in input.land.parcels
	participates(parcel)
	not input.land.home_farm_elevation_m
}

violations contains {"parcel_id": parcel.parcel_id, "reason": "mowing_not_full_area"} if {
	some parcel in input.land.parcels
	participates(parcel)
	some mowing in parcel.operations.mowing_years
	mowing.full_area != true
}

violations contains {"parcel_id": parcel.parcel_id, "reason": "mowing_material_not_removed"} if {
	some parcel in input.land.parcels
	participates(parcel)
	some mowing in parcel.operations.mowing_years
	mowing.mowed_material_removed != true
}

violations contains {"parcel_id": parcel.parcel_id, "reason": "more_than_one_mowing_per_year"} if {
	some parcel in input.land.parcels
	participates(parcel)
	count([mowing | mowing := parcel.operations.mowing_years[_]; mowing.year == input.farm.o6_4.year]) > 1
}

violations contains {"parcel_id": parcel.parcel_id, "reason": "mulching_not_allowed"} if {
	some parcel in input.land.parcels
	participates(parcel)
	parcel.operations.mulching == true
}

violations contains {"parcel_id": parcel.parcel_id, "reason": "grazing_before_16_august"} if {
	some parcel in input.land.parcels
	participates(parcel)
	some grazing in parcel.operations.grazing_periods
	grazing.start_date < sprintf("%v-08-16", [input.farm.o6_4.year])
}

violations contains {"parcel_id": parcel.parcel_id, "reason": "grazing_not_aftermath"} if {
	some parcel in input.land.parcels
	participates(parcel)
	some grazing in parcel.operations.grazing_periods
	grazing.grazing_type != "aftermath"
}

allowed_fertilizer(application) if {
	application.material == "household_wastewater"
}

allowed_fertilizer(application) if {
	application.material == "solid_manure"
	application.original_form == true
	application.needs_based == true
}

violations contains {"parcel_id": parcel.parcel_id, "reason": "prohibited_fertilizer_or_sludge"} if {
	some parcel in input.land.parcels
	participates(parcel)
	some application in parcel.operations.fertilizer_applications
	not allowed_fertilizer(application)
}

violations contains {"parcel_id": parcel.parcel_id, "reason": "prohibited_plant_protection_product"} if {
	some parcel in input.land.parcels
	participates(parcel)
	some application in parcel.operations.plant_protection_applications
	application.bio_regulation_2018_848_allowed != true
}

violations contains {"parcel_id": parcel.parcel_id, "reason": "unpermitted_combination"} if {
	some parcel in input.land.parcels
	participates(parcel)
	some measure in parcel.other_measures
	not measure.measure_code in allowed_combination_measure
}

allowed_combination_measure contains "o6_1a_landscape_element_compensation" if {
	data.o6_4.combination_table_o6_4["1A"] == "landscape_element_compensation_only"
}

allowed_combination_measure contains "o6_1b_landscape_element_compensation" if {
	data.o6_4.combination_table_o6_4["1B"] == "landscape_element_compensation_only"
}

code_valid if {
	input.farm.o6_4.code in {"BM0", "BM1", "BM2", "BM3"}
}

violations contains {"reason": "invalid_mowing_code"} if {
	not code_valid
}

no_mowing_no_premium if {
	input.farm.o6_4.code == "BM0"
	premium_amount == 0
}

contract_end_date := "2028-12-31" if {
	input.farm.o6_4.contract_start_year in {2023, 2024, 2025}
}

contract_duration_years := 6 if {
	input.farm.o6_4.contract_start_year == 2023
}

contract_duration_years := 5 if {
	input.farm.o6_4.contract_start_year == 2024
}

contract_duration_years := 4 if {
	input.farm.o6_4.contract_start_year == 2025
}

application_deadline_valid if {
	input.farm.o6_4.measure_application_date <= sprintf("%v-12-31", [input.farm.o6_4.contract_start_year - 1])
}

area_access_allowed if {
	input.farm.o6_4.access_year in {2024, 2025}
}

area_access_allowed if {
	input.farm.o6_4.access_year >= 2026
	input.farm.o6_4.added_area_ha <= 5
}

area_access_allowed if {
	input.farm.o6_4.access_year >= 2026
	input.farm.o6_4.added_area_ha <= input.farm.o6_4.base_2025_area_ha * 0.5
}

measure_change_allowed if {
	input.farm.o6_4.measure_change_date <= "2025-12-31"
	input.farm.o6_4.target_measure in {"o6_18", "o6_19"}
}

premium_eligible_parcel_ids contains parcel.parcel_id if {
	some parcel in input.land.parcels
	parcel.active_agricultural_management == true
	parcel.correctly_identified_for_measure == true
	parcel.code != "OP"
	parcel.parcel_id != ""
}

first_year_minimum_size_met if {
	input.farm.first_oepul_year != true
}

first_year_minimum_size_met if {
	input.farm.first_oepul_year == true
	input.land.protected_area_ha >= 0.5
}

first_year_minimum_size_met if {
	input.farm.first_oepul_year == true
	input.land.eligible_agricultural_area_ha >= 1.5
}

conditionality_compliant if {
	input.farm.o6_4.compliance.conditionality_compliant == true
}

area_reduction_allowed if {
	input.farm.o6_4.reduction_ha <= 0.5
}

area_reduction_allowed if {
	input.farm.o6_4.reduction_ha <= 5
	input.farm.o6_4.reduction_ha <= input.farm.o6_4.previous_measure_area_ha * 0.05
}

modulation_factor := 1.0 if {
	input.land.total_area_ha <= 200
}

modulation_factor := (200 + ((input.land.total_area_ha - 200) * 0.9)) / input.land.total_area_ha if {
	input.land.total_area_ha > 200
	input.land.total_area_ha <= 300
}

modulation_factor := ((200 + (100 * 0.9)) + ((input.land.total_area_ha - 300) * 0.85)) / input.land.total_area_ha if {
	input.land.total_area_ha > 300
	input.land.total_area_ha <= 1000
}

modulation_factor := (((200 + (100 * 0.9)) + (700 * 0.85)) + ((input.land.total_area_ha - 1000) * 0.75)) / input.land.total_area_ha if {
	input.land.total_area_ha > 1000
}

op_code_no_premium if {
	some parcel in input.land.parcels
	parcel.code == "OP"
}

default compliance := {"status": "insufficient_data", "violations": [], "missing_data": []}

compliance := {"status": "non_compliant", "violations": violations, "missing_data": [x | x := missing_data[_]]} if {
	count(violations) > 0
}

compliance := {"status": "insufficient_data", "violations": [], "missing_data": [x | x := missing_data[_]]} if {
	count(violations) == 0
	count(missing_data) > 0
}

compliance := {"status": "compliant", "violations": [], "missing_data": []} if {
	count(violations) == 0
	count(missing_data) == 0
}
