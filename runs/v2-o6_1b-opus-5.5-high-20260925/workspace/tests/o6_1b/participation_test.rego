package oepul.o6_1b_test

import data.oepul.o6_1b

test_base_farm_compliant if {
	vs := o6_1b.violations with input as base_input
	count(vs) == 0
}

test_rates_by_year if {
	o6_1b.rate_for_year("arable_base", 2023) == 205.0
	o6_1b.rate_for_year("arable_base", 2024) == 221.4
	o6_1b.rate_for_year("arable_base", 2025) == 235.0
	o6_1b.rate_for_year("arable_base", 2028) == 235.0
	o6_1b.rate_for_year("arable_div_ackerzahl_50", 2024) == 75.6
	o6_1b.rate_for_year("arable_div_ackerzahl_50", 2026) == 140.0
	not o6_1b.rate_for_year("transaction_costs", 2024)
	o6_1b.rate_for_year("transaction_costs", 2025) == 400.0
}

test_contract_period_years if {
	o6_1b.contract_period_years == 6 with input as base_input
	o6_1b.contract_period_years == 5 with input as with_patch([{"op": "replace", "path": "/oepul/o6_1b/contract_start_year", "value": 2024}, {"op": "replace", "path": "/oepul/o6_1b/application_date", "value": "2023-12-01"}])
	o6_1b.contract_period_years == 4 with input as with_patch([{"op": "replace", "path": "/oepul/o6_1b/contract_start_year", "value": 2025}, {"op": "replace", "path": "/oepul/o6_1b/application_date", "value": "2024-12-31"}])
}

test_entry_after_2025_not_possible if {
	inp := with_patch([{"op": "replace", "path": "/oepul/o6_1b/contract_start_year", "value": 2026}, {"op": "replace", "path": "/oepul/o6_1b/application_date", "value": "2025-12-01"}])
	"O61B-VZ-003" in ids(o6_1b.violations) with input as inp
}

test_late_measure_application if {
	inp := with_patch([{"op": "replace", "path": "/oepul/o6_1b/application_date", "value": "2023-01-10"}])
	"O61B-VZ-003" in ids(o6_1b.violations) with input as inp
}

test_control_contract_after_first_january if {
	inp := with_patch([{"op": "replace", "path": "/farm/certifications/organic/control_contract_start_date", "value": "2023-02-01"}])
	"O61B-ZT-001" in ids(o6_1b.violations) with input as inp
}

test_not_registered_with_food_authority if {
	inp := with_patch([{"op": "replace", "path": "/farm/certifications/organic/registered_with_food_authority", "value": false}])
	"O61B-ZT-001" in ids(o6_1b.violations) with input as inp
}

test_control_body_change_with_gap if {
	inp := with_patch([{"op": "replace", "path": "/farm/certifications/organic/control_body_change_without_gap", "value": false}])
	"O61B-ZT-002" in ids(o6_1b.violations) with input as inp
}

test_public_body_share_over_25 if {
	inp := with_patch([{"op": "replace", "path": "/oepul/applicant/public_body_share_percent", "value": 30}])
	"O61B-ATB-001" in ids(o6_1b.violations) with input as inp
}

test_minimum_farm_size_first_year if {
	small := [arable("A1", 1.0, "Winterweizen")]
	inp := json.patch(with_parcels(small), [{"op": "replace", "path": "/oepul/first_participation_year", "value": 2026}])
	"O61B-ATB-003" in ids(o6_1b.violations) with input as inp
	inp2 := json.patch(with_parcels(small), [{"op": "replace", "path": "/oepul/first_participation_year", "value": 2023}])
	not "O61B-ATB-003" in ids(o6_1b.violations) with input as inp2
}

test_combination_with_ubb_excluded if {
	inp := with_patch([{"op": "replace", "path": "/oepul/participating_measures", "value": ["o6_1b", "o6_1a"]}])
	"O61B-AN-001" in ids(o6_1b.violations) with input as inp
}

test_partial_farm_allows_combination_with_insektizidverzicht if {
	inp := with_patch([
		{"op": "replace", "path": "/oepul/participating_measures", "value": ["o6_1b", "o6_12"]},
		{"op": "add", "path": "/oepul/o6_1b/partial_farm", "value": {"is_partial": true, "organic_culture_area": "arable_grassland", "separate_facilities_and_land": true, "separate_input_storage": true, "applied_in_measure_application": true}},
	])
	vs := ids(o6_1b.violations) with input as inp
	not "O61B-AN-001" in vs

	# biologisch bewirtschaftete Acker-/Grünlandschläge ohne Code BIO
	"O61B-FL-004" in vs
}

test_partial_farm_without_separate_storage if {
	inp := with_patch([{"op": "add", "path": "/oepul/o6_1b/partial_farm", "value": {"is_partial": true, "organic_culture_area": "wine_fruit_hops", "separate_facilities_and_land": true, "separate_input_storage": false, "applied_in_measure_application": true}}])
	"O61B-TB-001" in ids(o6_1b.violations) with input as inp
}

test_nonproductive_arable_only_for_partial_wine_farm if {
	inp := with_patch([{"op": "replace", "path": "/oepul/participating_measures", "value": ["o6_1b", "o6_1c_nonproductive"]}])
	"O61B-AN-002" in ids(o6_1b.violations) with input as inp
	inp2 := with_patch([{"op": "replace", "path": "/oepul/participating_measures", "value": ["o6_1b", "o6_1c_agroforest"]}])
	not "O61B-AN-002" in ids(o6_1b.violations) with input as inp2
}

test_access_failure_first_year_no_contract if {
	inp := with_patch([
		{"op": "replace", "path": "/oepul/o6_1b/contract_start_year", "value": 2026},
		{"op": "replace", "path": "/farm/certifications/organic/registered_with_food_authority", "value": false},
	])
	o6_1b.access_failure_consequence == "no_contract" with input as inp
	inp2 := with_patch([{"op": "replace", "path": "/farm/certifications/organic/registered_with_food_authority", "value": false}])
	o6_1b.access_failure_consequence == "no_premium_this_year" with input as inp2
}
