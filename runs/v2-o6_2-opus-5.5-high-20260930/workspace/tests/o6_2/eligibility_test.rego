package oepul.o6_2_test

import data.oepul.o6_2

access_failures(inp) := f if {
	f := o6_2.access_condition_failures with input as inp
}

test_base_access_ok if {
	count(access_failures(base_input)) == 0
	o6_2.contract_valid with input as base_input
	o6_2.eligible with input as base_input
}

test_missing_ubb_is_access_failure_later_year_no_premium if {
	inp := with_oepul("participating_measures", ["2"])
	"O6_2-ACC-UBB-001" in access_failures(inp)
	o6_2.no_premium_this_year_due_to_access with input as inp
	premium := o6_2.net_premium_eur with input as inp
	premium == 0
}

test_missing_ubb_in_first_year_no_contract if {
	inp := json.patch(base_input, [
		{"op": "replace", "path": "/farm/year", "value": 2024},
		{"op": "replace", "path": "/farm/oepul/participating_measures", "value": ["2"]},
	])
	o6_2.no_contract_due_to_access with input as inp
	not o6_2.contract_valid with input as inp
}

test_bio_combination_excluded if {
	inp := with_oepul("participating_measures", ["1A", "1B", "2"])
	"O6_2-COMB-BIO-001" in access_failures(inp)
}

test_bio_partial_farm_wine_fruit_hop_allowed if {
	inp := json.patch(base_input, [
		{"op": "replace", "path": "/farm/oepul/participating_measures", "value": ["1A", "1B", "2"]},
		{"op": "add", "path": "/farm/oepul/bio_partial_farm", "value": {"is_partial_farm": true, "bio_culture_area": "wine_fruit_hop"}},
	])
	not "O6_2-COMB-BIO-001" in access_failures(inp)
}

test_bio_partial_farm_arable_grassland_not_allowed if {
	inp := json.patch(base_input, [
		{"op": "replace", "path": "/farm/oepul/participating_measures", "value": ["1A", "1B", "2"]},
		{"op": "add", "path": "/farm/oepul/bio_partial_farm", "value": {"is_partial_farm": true, "bio_culture_area": "arable_grassland"}},
	])
	"O6_2-COMB-BIO-001" in access_failures(inp)
}

test_public_body_not_eligible if {
	inp := with_oepul("applicant_type", "public_body")
	"O6_2-GEN-APPLICANT-001" in access_failures(inp)
}

test_legal_person_public_share if {
	over := json.patch(base_input, [
		{"op": "replace", "path": "/farm/oepul/applicant_type", "value": "legal_person"},
		{"op": "add", "path": "/farm/oepul/public_body_share_percent", "value": 30},
	])
	"O6_2-GEN-APPLICANT-001" in access_failures(over)
	at := json.patch(over, [{"op": "replace", "path": "/farm/oepul/public_body_share_percent", "value": 25}])
	not "O6_2-GEN-APPLICANT-001" in access_failures(at)
}

test_minimum_farm_size_first_year if {
	small := json.patch(base_input, [
		{"op": "replace", "path": "/farm/oepul/first_oepul_participation_year", "value": 2026},
		{"op": "replace", "path": "/land/parcels", "value": [{"parcel_id": "S1", "area_ha": 1.2, "land_use": "grassland", "crop": {"crop_category": "other", "crop_name": "Mähwiese"}}]},
	])
	"O6_2-GEN-MINSIZE-001" in access_failures(small)
	ok := json.patch(small, [{"op": "replace", "path": "/land/parcels/0/area_ha", "value": 1.5}])
	not "O6_2-GEN-MINSIZE-001" in access_failures(ok)
}

test_minimum_size_not_required_after_first_year if {
	small := json.patch(base_input, [{"op": "replace", "path": "/land/parcels", "value": [{"parcel_id": "S1", "area_ha": 1.2, "land_use": "grassland", "crop": {"crop_category": "other", "crop_name": "Mähwiese"}}]}])
	not "O6_2-GEN-MINSIZE-001" in access_failures(small)
}

test_application_deadline if {
	late := with_oepul("o6_2/application_date", "2024-01-05")
	failures := o6_2.contract_failures with input as late
	"O6_2-APP-DEADLINE-001" in failures
}

test_last_entry_2025 if {
	ok := json.patch(base_input, [
		{"op": "replace", "path": "/farm/oepul/o6_2/contract_start_year", "value": 2025},
		{"op": "replace", "path": "/farm/oepul/o6_2/application_date", "value": "2024-12-31"},
	])
	ok_failures := o6_2.contract_failures with input as ok
	count(ok_failures) == 0
	late := json.patch(base_input, [
		{"op": "replace", "path": "/farm/oepul/o6_2/contract_start_year", "value": 2026},
		{"op": "replace", "path": "/farm/oepul/o6_2/application_date", "value": "2025-12-15"},
	])
	late_failures := o6_2.contract_failures with input as late
	"O6_2-APP-LASTENTRY-001" in late_failures
	"O6_2-APP-DEADLINE-001" in late_failures
}

test_single_area_combination_table if {
	o6_2.single_area_combinable("1A")
	o6_2.single_area_combinable("12")
	o6_2.single_area_premium_reduction("16")
	not o6_2.single_area_combinable("18")
	not o6_2.single_area_combinable("1B")
	not o6_2.single_area_combinable("4")
	not o6_2.single_area_combinable("14")
}

test_parcel_in_naturschutz_gets_no_o6_2_premium if {
	inp := with_parcel(2, "parcel_measures", ["1A", "2", "18"])
	excl := o6_2.parcel_exclusions with input as inp
	["G1", "single_area_combination_conflict"] in excl
}
