package oepul.o6_12_test

import data.oepul.o6_12

test_base_case_contract_and_eligible_parcels if {
	o6_12.contract_established with input as base_input
	o6_12.eligible_parcel_ids == {"W1", "O1"} with input as base_input
	o6_12.eligible_area_ha == 3.0 with input as base_input
	count(o6_12.access_condition_failures) == 0 with input as base_input
}

test_application_after_deadline_not_timely if {
	inp := with_o612({"application_submitted_date": "2024-01-03"})
	not o6_12.application_timely with input as inp
	"application_not_timely" in o6_12.access_condition_failures with input as inp
	not o6_12.contract_established with input as inp
}

test_entry_2026_not_possible if {
	inp := with_o612({"contract_start_year": 2026, "application_submitted_date": "2025-12-01"})
	not o6_12.entry_year_allowed with input as inp
	not o6_12.contract_established with input as inp
}

test_first_year_minimum_area_not_met if {
	small := object.union(vineyard, {"area_ha": 0.3})
	inp := json.patch(with_parcels([small]), [
		{"op": "replace", "path": "/farm/year", "value": 2024},
		{"op": "replace", "path": "/oepul/o6_12/contract_start_year", "value": 2024},
	])
	o6_12.first_year_minimum_area_status == "not_met" with input as inp
	o6_12.access_condition_consequence == "no_contract" with input as inp
}

test_first_year_minimum_area_counts_schnittweingarten_not_rebschule if {
	sw := object.union(vineyard, {"parcel_id": "S1", "area_ha": 0.3, "crop": {"crop_category": "vineyard", "usage_type": "schnittweingarten"}})
	rs := object.union(vineyard, {"parcel_id": "R1", "area_ha": 0.3, "crop": {"crop_category": "vineyard", "usage_type": "rebschule"}})
	inp := json.patch(with_parcels([sw, rs]), [
		{"op": "replace", "path": "/farm/year", "value": 2024},
		{"op": "replace", "path": "/oepul/o6_12/contract_start_year", "value": 2024},
	])
	o6_12.wine_fruit_hop_area_ha == 0.3 with input as inp
	o6_12.first_year_minimum_area_status == "not_met" with input as inp
}

test_bio_combination_excluded_unless_teilbetrieb_arable_grassland if {
	inp := json.patch(base_input, [{"op": "replace", "path": "/oepul/participating_measures", "value": ["1B", "12"]}])
	o6_12.bio_combination_conflict with input as inp
	"combination_with_organic_farming_excluded" in o6_12.access_condition_failures with input as inp
	inp2 := json.patch(inp, [{"op": "add", "path": "/oepul/bio_teilbetrieb", "value": {"is_participating": true, "organic_cultural_area": "arable_grassland"}}])
	not o6_12.bio_combination_conflict with input as inp2
	inp3 := json.patch(inp, [{"op": "add", "path": "/oepul/bio_teilbetrieb", "value": {"is_participating": true, "organic_cultural_area": "permanent_crops"}}])
	o6_12.bio_combination_conflict with input as inp3
}

test_public_body_not_eligible if {
	inp := json.patch(base_input, [{"op": "replace", "path": "/farm/applicant/legal_form", "value": "public_body"}])
	"public_body_not_eligible_for_measure_12" in o6_12.applicant_ineligibility_reasons with input as inp
	"applicant_not_eligible" in o6_12.access_condition_failures with input as inp
}

test_legal_person_public_share_above_25 if {
	inp := json.patch(base_input, [
		{"op": "replace", "path": "/farm/applicant/legal_form", "value": "legal_person"},
		{"op": "add", "path": "/farm/applicant/public_body_share_percent", "value": 30},
	])
	"public_body_share_exceeds_25_percent" in o6_12.applicant_ineligibility_reasons with input as inp
	inp2 := json.patch(inp, [{"op": "replace", "path": "/farm/applicant/public_body_share_percent", "value": 25}])
	o6_12.applicant_eligible with input as inp2
}

test_farm_minimum_size_first_oepul_year if {
	inp := json.patch(base_input, [
		{"op": "replace", "path": "/oepul/first_participation_year", "value": 2026},
		{"op": "replace", "path": "/land/total_area_ha", "value": 1.2},
	])
	not o6_12.farm_minimum_size_met with input as inp
	inp2 := json.patch(inp, [{"op": "add", "path": "/land/protected_cultivation_area_ha", "value": 0.5}])
	o6_12.farm_minimum_size_met with input as inp2
}

test_parcel_exclusions if {
	sonstige := object.union(vineyard, {"parcel_id": "X1", "crop": {"crop_category": "vineyard", "usage_type": "sonstige_weinflaeche"}})
	not_register := object.union(vineyard, {"parcel_id": "X2", "in_vineyard_register": false})
	ungrafted := object.union(orchard, {"parcel_id": "X3", "crop": {"crop_category": "orchard", "crop_name": "Walnuss", "grafted_planting_material": false}})
	op := object.union(vineyard, {"parcel_id": "X4", "oepul_codes": ["OP"]})
	np := object.union(vineyard, {"parcel_id": "X5", "national_park": "Neusiedlersee"})
	np_ok := object.union(vineyard, {"parcel_id": "X6", "national_park": "Thayatal"})
	undeclared := object.union(vineyard, {"parcel_id": "X7", "declared_measures": []})
	abroad := object.union(vineyard, {"parcel_id": "X8", "country": "CZ"})
	inp := with_parcels([sonstige, not_register, ungrafted, op, np, np_ok, undeclared, abroad])
	o6_12.eligible_parcel_ids == {"X6"} with input as inp
	"ineligible_usage_type" in o6_12.parcel_exclusions.X1 with input as inp
	"vineyard_not_in_vineyard_register" in o6_12.parcel_exclusions.X2 with input as inp
	"ungrafted_fruit_planting_material" in o6_12.parcel_exclusions.X3 with input as inp
	"code_op" in o6_12.parcel_exclusions.X4 with input as inp
	"national_park_without_premium" in o6_12.parcel_exclusions.X5 with input as inp
	"not_declared_for_measure" in o6_12.parcel_exclusions.X7 with input as inp
	"outside_austria" in o6_12.parcel_exclusions.X8 with input as inp
	"X3" in o6_12.op_code_required_parcels with input as inp
}

test_fruit_list_year_dependent if {
	papau := object.union(orchard, {"parcel_id": "P1", "crop": {"crop_category": "orchard", "crop_name": "Papau", "grafted_planting_material": true}})
	inp24 := json.patch(with_parcels([papau]), [{"op": "replace", "path": "/farm/year", "value": 2024}])
	"fruit_crop_not_listed" in o6_12.parcel_exclusions.P1 with input as inp24
	inp25 := json.patch(with_parcels([papau]), [{"op": "replace", "path": "/farm/year", "value": 2025}])
	o6_12.eligible_parcel_ids == {"P1"} with input as inp25
}

test_parcel_combination_anhang_l if {
	p := object.union(vineyard, {"declared_measures": ["12", "11", "10", "1B", "1A"]})
	inp := with_parcels([p])
	o6_12.parcel_combination_conflicts.W1 == {"1B"} with input as inp
	o6_12.parcel_combination_landscape_element_only.W1 == {"1A"} with input as inp
	o6_12.o6_10_organism_supplement_factor == 0.5 with input as inp
}
