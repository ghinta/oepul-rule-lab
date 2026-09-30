package oepul.o6_2_test

import data.oepul.o6_2

violation_ids(inp) := ids if {
	vs := o6_2.violations with input as inp
	ids := {v.rule_id | some v in vs}
}

with_inputs(idx, inputs) := with_parcel(idx, "operations/fertilizer/inputs", inputs)

test_base_has_no_violations if {
	vs := o6_2.violations with input as base_input
	count(vs) == 0
}

test_external_mineral_n_prohibited if {
	inp := with_inputs(2, [{"input_id": "mineral_n_fertilizer", "external_origin": true}])
	"O6_2-OBL-N-FERT-001" in violation_ids(inp)
}

test_mineral_n_amount_prohibited if {
	inp := with_parcel(0, "operations/fertilizer/mineral_n_kg_per_ha", 40)
	"O6_2-OBL-N-FERT-002" in violation_ids(inp)
}

test_external_manure_and_eu_compost_allowed if {
	inp := with_inputs(2, [
		{"input_id": "slurry_guelle", "external_origin": true},
		{"input_id": "farmyard_manure", "external_origin": true},
		{"input_id": "compost_eu_2018_848", "external_origin": true},
		{"input_id": "non_n_mineral_fertilizer", "external_origin": true},
		{"input_id": "own_domestic_wastewater", "external_origin": false},
	])
	count(violation_ids(inp)) == 0
}

test_biogas_digestate_only_as_return if {
	bad := with_inputs(2, [{"input_id": "biogas_digestate_return", "external_origin": true, "is_return_of_delivered_slurry": false}])
	"O6_2-OBL-N-FERT-001" in violation_ids(bad)
	good := with_inputs(2, [{"input_id": "biogas_digestate_return", "external_origin": true, "is_return_of_delivered_slurry": true}])
	count(violation_ids(good)) == 0
}

test_sewage_sludge_and_residues_prohibited if {
	every input_id in ["sewage_sludge", "molasses", "carbokalk", "stillage_schlempe", "corn_steep_liquor", "potato_fruit_water"] {
		"O6_2-OBL-N-FERT-001" in violation_ids(with_inputs(0, [{"input_id": input_id, "external_origin": true}]))
	}
}

test_unknown_external_n_input_prohibited if {
	inp := with_inputs(0, [{"input_id": "pelletized_chicken_manure_product", "external_origin": true, "contains_n": true}])
	"O6_2-OBL-N-FERT-001" in violation_ids(inp)
}

test_fertilizer_ban_also_on_non_eligible_area if {
	inp := json.patch(base_input, [{"op": "add", "path": "/land/parcels/-", "value": {"parcel_id": "GH1", "area_ha": 0.2, "land_use": "other", "land_use_code": "GA", "crop": {"crop_category": "vegetable", "crop_name": "Paradeiser", "non_eligible_type": "protected_cultivation"}, "operations": {"fertilizer": {"inputs": [{"input_id": "mineral_n_fertilizer", "external_origin": true}]}}}}])
	"O6_2-OBL-N-FERT-001" in violation_ids(inp)
}

test_broadcast_chemical_psm_on_grassland_prohibited if {
	inp := with_parcel(2, "operations/psm_applications", [{"application_mode": "broadcast", "organic_approved_only": false}])
	"O6_2-OBL-PSM-001" in violation_ids(inp)
}

test_bio_psm_and_single_plant_allowed_on_grassland if {
	inp := with_parcel(2, "operations/psm_applications", [
		{"application_mode": "broadcast", "organic_approved_only": true},
		{"application_mode": "single_plant", "organic_approved_only": false},
	])
	not "O6_2-OBL-PSM-001" in violation_ids(inp)
}

test_seed_treatment_on_forage_prohibited if {
	inp := with_parcel(1, "operations/psm_applications", [{"application_mode": "seed_treatment", "organic_approved_only": false}])
	"O6_2-OBL-PSM-001" in violation_ids(inp)
}

test_broadcast_psm_on_cereal_allowed if {
	not "O6_2-OBL-PSM-001" in violation_ids(base_input)
}

test_psm_code_required_until_2025 if {
	inp := json.patch(base_input, [
		{"op": "replace", "path": "/farm/year", "value": 2025},
		{"op": "add", "path": "/land/parcels/2/operations/psm_applications", "value": [{"application_mode": "broadcast", "organic_approved_only": true}]},
	])
	"O6_2-OBL-PSM-CODE-001" in violation_ids(inp)
	r1 := o6_2.required_psm_code(inp.land.parcels[2]) with input as inp
	r1 == "PSMBIO"
	coded := json.patch(inp, [{"op": "replace", "path": "/land/parcels/2/oepul_codes", "value": ["PSMBIO"]}])
	not "O6_2-OBL-PSM-CODE-001" in violation_ids(coded)
}

test_psmcs_sufficient_for_mixed_use if {
	inp := json.patch(base_input, [
		{"op": "replace", "path": "/farm/year", "value": 2024},
		{"op": "add", "path": "/land/parcels/1/operations/psm_applications", "value": [{"application_mode": "broadcast", "organic_approved_only": true}, {"application_mode": "broadcast", "organic_approved_only": false}]},
		{"op": "replace", "path": "/land/parcels/1/oepul_codes", "value": ["PSMCS"]},
	])
	not "O6_2-OBL-PSM-CODE-001" in violation_ids(inp)
}

test_no_psm_code_from_2026 if {
	inp := with_parcel(2, "operations/psm_applications", [{"application_mode": "broadcast", "organic_approved_only": true}])
	not "O6_2-OBL-PSM-CODE-001" in violation_ids(inp)
	not o6_2.psm_coding_obligation_applies with input as inp
}

test_purchase_of_mineral_n_prohibited if {
	inp := with_oepul("operating_supplies", [{"input_id": "mineral_n_fertilizer", "category": "fertilizer", "purchased": true, "external_origin": true}])
	"O6_2-OBL-SUPPLY-001" in violation_ids(inp)
}

test_storage_of_chemical_psm_allowed_for_other_crops if {
	ok := with_oepul("operating_supplies", [{"input_id": "herbicide_x", "category": "psm", "stored": true, "organic_approved_only": false, "psm_permitted_in_other_crops": true, "quantity_plausible": true, "records_available": true}])
	not "O6_2-OBL-SUPPLY-001" in violation_ids(ok)
	bad := with_oepul("operating_supplies", [{"input_id": "herbicide_x", "category": "psm", "stored": true, "organic_approved_only": false, "psm_permitted_in_other_crops": true, "quantity_plausible": false, "records_available": true}])
	"O6_2-OBL-SUPPLY-001" in violation_ids(bad)
}

test_training_met if {
	o6_2.training_requirement_met with input as base_input
}

test_training_split_courses_add_up if {
	inp := with_oepul("trainings", [
		{"topic": "nitrogen_fertilisation", "hours": 1.5, "date": "2022-03-01", "provider_recognized": true, "attendee_role": "applicant"},
		{"topic": "adapted_grassland_use_frequency", "hours": 1.5, "date": "2025-12-31", "provider_recognized": true, "attendee_role": "involved_farm_person"},
	])
	o6_2.training_requirement_met with input as inp
}

test_training_before_2022_not_creditable if {
	inp := with_oepul("trainings", [{"topic": "nitrogen_fertilisation", "hours": 3, "date": "2021-12-31", "provider_recognized": true, "attendee_role": "applicant"}])
	"O6_2-OBL-TRAIN-001" in violation_ids(inp)
}

test_training_person_left_before_deadline if {
	inp := with_oepul("trainings", [{"topic": "nitrogen_fertilisation", "hours": 3, "date": "2023-01-10", "provider_recognized": true, "attendee_role": "applicant", "attendee_left_farm_date": "2025-06-30"}])
	"O6_2-OBL-TRAIN-001" in violation_ids(inp)
}

test_training_person_left_after_deadline_ok if {
	inp := with_oepul("trainings", [{"topic": "nitrogen_fertilisation", "hours": 3, "date": "2023-01-10", "provider_recognized": true, "attendee_role": "applicant", "attendee_left_farm_date": "2026-03-01"}])
	o6_2.training_requirement_met with input as inp
}

test_training_double_credit_not_allowed if {
	inp := with_oepul("trainings", [{"topic": "nitrogen_fertilisation", "hours": 3, "date": "2023-01-10", "provider_recognized": true, "attendee_role": "applicant", "credited_to_other_commitment": true}])
	not o6_2.training_requirement_met with input as inp
}

test_psm_used_without_details_is_review_item if {
	inp := with_parcel(2, "operations/psm_used", true)
	items := o6_2.review_items with input as inp
	some r in items
	r.rule_id == "O6_2-OBL-PSM-001"
	r.parcel_id == "G1"
}
