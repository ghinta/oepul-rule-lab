package oepul.o6_19_test

import data.oepul.o6_19
import rego.v1

rule_ids(vs) := {v.rule_id | some v in vs}

test_base_case_eligible_and_premium if {
	d := o6_19.decision with input as base_input
	d.eligible == true
	d.access_consequence == "none"
	count(d.violations) == 0

	# P1: 1.404,0 + EBBA01 108,0 = 1.512,0 -> Obergrenze 1.500 EUR/ha; P2: 637,2 EUR/ha; RNP 270 EUR.
	d.parcels.P1.rate_eur_per_ha == 1512
	d.parcels.P1.premium_eur == 3000
	d.parcels.P2.premium_eur == 1911.6
	d.regional_plan_surcharge_eur == 270
	d.measure_premium_eur == 5181.6
}

test_contract_period_mapping if {
	cp := o6_19.contract_period with input as base_input
	cp.years == 5
	cp.end == "2028-12-31"
	cp23 := o6_19.contract_period with input as with_patch([{"op": "replace", "path": "/oepul/o6_19/contract_start_year", "value": 2023}])
	cp23.years == 6
}

test_contract_start_2026_rejected if {
	inp := with_patch([
		{"op": "replace", "path": "/oepul/o6_19/contract_start_year", "value": 2026},
		{"op": "replace", "path": "/oepul/o6_19/measure_application_date", "value": "2025-12-01"},
	])
	ids := rule_ids(o6_19.participation_violations) with input as inp
	"R-O619-CONTRACT-PERIOD" in ids
	"R-O619-APP-LAST-ENTRY" in ids
	c := o6_19.access_consequence with input as inp
	c == "no_contract"
}

test_application_after_deadline if {
	inp := with_patch([{"op": "replace", "path": "/oepul/o6_19/measure_application_date", "value": "2024-01-02"}])
	"R-O619-APP-DEADLINE" in rule_ids(o6_19.participation_violations) with input as inp
}

test_min_area_first_year if {
	inp := with_patch([
		{"op": "replace", "path": "/farm/year", "value": 2024},
		{"op": "replace", "path": "/land/parcels/0/area_ha", "value": 0.5},
		{"op": "replace", "path": "/land/parcels/1/area_ha", "value": 0.4},
	])
	"R-O619-MIN-AREA-FIRST-YEAR" in rule_ids(o6_19.participation_violations) with input as inp
	c := o6_19.access_consequence with input as inp
	c == "no_contract"
	p := o6_19.measure_premium_eur with input as inp
	p == 0
}

test_min_area_first_year_exactly_one_ha if {
	inp := with_patch([
		{"op": "replace", "path": "/farm/year", "value": 2024},
		{"op": "replace", "path": "/land/parcels/0/area_ha", "value": 0.6},
		{"op": "replace", "path": "/land/parcels/1/area_ha", "value": 0.4},
	])
	not "R-O619-MIN-AREA-FIRST-YEAR" in rule_ids(o6_19.participation_violations) with input as inp
}

test_later_year_without_compliant_parcel if {
	inp := with_patch([
		{"op": "replace", "path": "/land/parcels/0/oepul/ebw/indicators_recorded", "value": false},
		{"op": "replace", "path": "/land/parcels/1/oepul/ebw/in_project_confirmation", "value": false},
	])
	"R-O619-MIN-PARCEL-LATER-YEARS" in rule_ids(o6_19.participation_violations) with input as inp
	c := o6_19.access_consequence with input as inp
	c == "no_premium_this_year"
}

test_missing_project_confirmation if {
	inp := with_patch([{"op": "replace", "path": "/oepul/o6_19/project_confirmation_present", "value": false}])
	"R-O619-PROJECT-CONFIRMATION" in rule_ids(o6_19.participation_violations) with input as inp
	d := o6_19.decision with input as inp
	d.eligible == false
}

test_training_missing_after_2026 if {
	inp := with_patch([
		{"op": "replace", "path": "/farm/year", "value": 2027},
		{"op": "replace", "path": "/oepul/o6_19/training", "value": {"attended": false}},
	])
	"R-O619-TRAINING-DEADLINE" in rule_ids(o6_19.participation_violations) with input as inp
}

test_training_not_yet_due_in_2026 if {
	inp := with_patch([{"op": "replace", "path": "/oepul/o6_19/training", "value": {"attended": false}}])
	not "R-O619-TRAINING-DEADLINE" in rule_ids(o6_19.participation_violations) with input as inp
}

test_training_person_left_requires_repeat if {
	left := with_patch([
		{"op": "replace", "path": "/farm/year", "value": 2027},
		{"op": "add", "path": "/oepul/o6_19/training/trained_person_left_date", "value": "2026-06-30"},
	])
	"R-O619-TRAINING-DEADLINE" in rule_ids(o6_19.participation_violations) with input as left
	repeated := json.patch(left, [{"op": "add", "path": "/oepul/o6_19/training/repeat_attended_date", "value": "2026-11-15"}])
	not "R-O619-TRAINING-DEADLINE" in rule_ids(o6_19.participation_violations) with input as repeated
}

test_training_person_left_after_deadline_ok if {
	inp := with_patch([
		{"op": "replace", "path": "/farm/year", "value": 2027},
		{"op": "add", "path": "/oepul/o6_19/training/trained_person_left_date", "value": "2027-02-01"},
	])
	not "R-O619-TRAINING-DEADLINE" in rule_ids(o6_19.participation_violations) with input as inp
}

test_training_double_counting if {
	inp := with_patch([{"op": "add", "path": "/oepul/o6_19/training/same_event_credited_elsewhere", "value": true}])
	"R-O619-TRAINING-DEADLINE" in rule_ids(o6_19.participation_violations) with input as inp
}

test_training_confirmation_missing if {
	inp := with_patch([{"op": "add", "path": "/oepul/o6_19/training/confirmation_requested", "value": true}])
	"R-O619-TRAINING-CONFIRMATION" in rule_ids(o6_19.participation_violations) with input as inp
	ok := json.patch(inp, [{"op": "add", "path": "/oepul/o6_19/training/transmitted_by_coordination_body", "value": true}])
	not "R-O619-TRAINING-CONFIRMATION" in rule_ids(o6_19.participation_violations) with input as ok
}

test_regional_plan_once_with_naturschutz if {
	inp := with_patch([{"op": "add", "path": "/oepul/participation/naturschutz_regional_plan_granted", "value": true}])
	s := o6_19.regional_plan_surcharge_eur with input as inp
	s == 0
}

test_regional_plan_rate_2023 if {
	inp := with_patch([
		{"op": "replace", "path": "/farm/year", "value": 2023},
		{"op": "replace", "path": "/oepul/o6_19/regional_plan/first_year", "value": 2023},
		{"op": "replace", "path": "/oepul/o6_19/regional_plan/application_date", "value": "2022-12-01"},
	])
	r := o6_19.regional_plan_rate with input as inp
	r == 250
}

test_regional_plan_requires_confirmation if {
	inp := with_patch([{"op": "replace", "path": "/oepul/o6_19/regional_plan/participation_confirmation_present", "value": false}])
	s := o6_19.regional_plan_surcharge_eur with input as inp
	s == 0
}

test_regional_plan_deregistered if {
	inp := with_patch([{"op": "add", "path": "/oepul/o6_19/regional_plan/deregistered", "value": true}])
	s := o6_19.regional_plan_surcharge_eur with input as inp
	s == 0
}

test_regional_plan_last_entry if {
	inp := with_patch([
		{"op": "replace", "path": "/oepul/o6_19/regional_plan/first_year", "value": 2029},
		{"op": "replace", "path": "/oepul/o6_19/regional_plan/application_date", "value": "2028-12-01"},
	])
	not o6_19.regional_plan_application_timely with input as inp
}
