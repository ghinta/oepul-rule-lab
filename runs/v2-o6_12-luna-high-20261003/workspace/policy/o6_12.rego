package oepul.o6_12

import rego.v1

target_parcel(parcel) if {
	parcel.crop.crop_category == "vineyard"
	parcel.crop.crop_name != "rebschule"
	parcel.land_use != "other_wine"
	parcel.land_use != "other_special_crop"
	parcel.land_use != "nursery"
}

target_parcel(parcel) if {
	parcel.crop.crop_category == "orchard"
	parcel.crop.crop_name in data.eligible_obst_crops
	parcel.crop.crop_name != "rebschule"
	parcel.land_use != "other_wine"
	parcel.land_use != "other_special_crop"
	parcel.land_use != "nursery"
}

target_parcel(parcel) if {
	parcel.crop.crop_category == "hop"
	parcel.crop.crop_name != "rebschule"
	parcel.land_use != "other_wine"
	parcel.land_use != "other_special_crop"
	parcel.land_use != "nursery"
}

target_parcels contains parcel if {
	parcel := input.land.parcels[_]
	target_parcel(parcel)
}

target_area_ha := sum([parcel.area_ha | parcel := input.land.parcels[_]; target_parcel(parcel)])

minimum_participation_met if {
	input.farm.measures.o6_12.participating == true
	input.farm.measures.o6_12.first_participation_year == input.farm.year
	target_area_ha >= 0.5
}

minimum_participation_met if {
	input.farm.measures.o6_12.participating == true
	input.farm.measures.o6_12.first_participation_year < input.farm.year
}

contract_end_year := 2028 if {
	input.farm.measures.o6_12.participating == true
}

contract_years := 6 if {
	input.farm.measures.o6_12.contract_start_year == 2023
}

contract_years := 5 if {
	input.farm.measures.o6_12.contract_start_year == 2024
}

contract_years := 4 if {
	input.farm.measures.o6_12.contract_start_year == 2025
}

insecticide_violation contains parcel.parcel_id if {
	parcel := input.land.parcels[_]
	target_parcel(parcel)
	parcel.operations.insecticide_use == true
	not parcel.operations.insecticide_is_bio_permitted
	not parcel.operations.insecticide_authority_order
}

insecticide_violation contains parcel.parcel_id if {
	parcel := input.land.parcels[_]
	target_parcel(parcel)
	parcel.operations.insecticide_authority_order == true
	not parcel.operations.insecticide_authority_documented
}

purchase_storage_violation contains parcel.parcel_id if {
	parcel := input.land.parcels[_]
	target_parcel(parcel)
	parcel.operations.insecticide_purchase_or_storage == true
	not parcel.operations.insecticide_in_other_culture
}

purchase_storage_violation contains parcel.parcel_id if {
	parcel := input.land.parcels[_]
	target_parcel(parcel)
	parcel.operations.insecticide_purchase_or_storage == true
	parcel.operations.insecticide_in_other_culture == true
	not parcel.operations.insecticide_purchase_storage_plausible
}

reporting_code_required if {
	input.farm.year <= 2025
	input.farm.measures.o6_12.area_wide_psm_application == true
}

reporting_code_required if {
	input.farm.year <= 2025
	input.farm.measures.o6_12.chemical_synthetic_insecticide_used == true
}

reporting_code_required if {
	input.farm.year <= 2025
	input.farm.measures.o6_12.authority_ordered_chemical_synthetic_insecticide == true
}

reporting_not_required if {
	input.farm.year >= 2026
}

reporting_code := "PSMCSI" if {
	input.farm.year <= 2025
	input.farm.measures.o6_12.chemical_synthetic_insecticide_used == true
}

reporting_code := "PSMCS" if {
	input.farm.year <= 2025
	input.farm.measures.o6_12.chemical_synthetic_insecticide_used == false
	input.farm.measures.o6_12.area_wide_psm_application == true
}

premium_rate_eur_per_ha := rate if {
	parcel_type := input.farm.measures.o6_12.premium_target_type
	row := data.premium_rates_eur_per_ha[_]
	row.target_type == parcel_type
	input.farm.year == 2023
	row.from_year == 2023
	rate := row.rate
}

premium_rate_eur_per_ha := rate if {
	parcel_type := input.farm.measures.o6_12.premium_target_type
	row := data.premium_rates_eur_per_ha[_]
	row.target_type == parcel_type
	input.farm.year >= 2024
	row.from_year == 2024
	rate := row.rate
}

premium_eligible if {
	minimum_participation_met
	count(insecticide_violation) == 0
	count(purchase_storage_violation) == 0
	input.farm.measures.o6_12.quality_planting_material_ok == true
	input.farm.measures.o6_12.sonstige_target_land_use == false
}

combination_allowed if {
	input.farm.measures.o6_12.biological_farming_participation == false
}

combination_allowed if {
	input.farm.measures.o6_12.biological_farming_participation == true
	input.farm.measures.o6_12.biological_farming_scope == "part_farm_arable_grassland"
}

switch_to_biological_allowed if {
	input.farm.measures.o6_12.switch_request_date <= "2025-12-31"
}

early_exit_2026_without_repayment if {
	input.farm.year >= 2026
	input.farm.measures.o6_12.early_exit_reason == "american_rebzikade_control"
	input.farm.measures.o6_12.early_exit_approved == true
}

early_exit_premium_2026 := 0.0 if {
	early_exit_2026_without_repayment
	input.farm.year == 2026
}

authority_order_exception if {
	input.farm.measures.o6_12.authority_ordered_control == true
	input.farm.measures.o6_12.authority_order_documented == true
	input.farm.measures.o6_12.authority_ordered_substance_allowed == true
}

authority_order_exception if {
	input.farm.measures.o6_12.authority_ordered_control == true
	input.farm.measures.o6_12.authority_order_documented == true
	input.farm.measures.o6_12.authority_ordered_substance_allowed == false
	input.farm.region.federal_state in {"Steiermark", "Burgenland", "Niederösterreich"}
	input.farm.measures.o6_12.authority_ordered_area == true
}
