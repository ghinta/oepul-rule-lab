package oepul.o6_16_test

import data.oepul.o6_16

test_farm_plan_deadline if {
	inp := with_o16({"farm_records": {"fertilization_plan_date": "2026-03-05"}})
	"o6_16.records.farm_plan_deadline" in rule_ids(o6_16.violations) with input as inp
}

test_farm_balance_deadline if {
	ok := with_o16({"farm_records": {"farm_balance_completed_date": "2027-01-31"}})
	not "o6_16.records.farm_balance_deadline" in rule_ids(o6_16.violations) with input as ok
	late := with_o16({"farm_records": {"farm_balance_completed_date": "2027-02-01"}})
	"o6_16.records.farm_balance_deadline" in rule_ids(o6_16.violations) with input as late
}

test_field_records_14_days if {
	inp := with_o16({"field_records": {"max_completion_delay_days": 15}})
	"o6_16.records.field_records_14_days" in rule_ids(o6_16.violations) with input as inp
}

test_field_records_electronic if {
	inp := with_o16({"field_records": {"electronic": false}})
	"o6_16.records.field_records_electronic" in rule_ids(o6_16.violations) with input as inp
}

test_field_records_small_crop_exempt if {
	small := object.union(maize_parcel, {"area_ha": 0.3})
	inp := object.union(with_parcels([small]), {"farm": {"oepul": {"o6_16": {"field_records": {"electronic": false}}}}})
	not o6_16.field_records_required with input as inp
	not "o6_16.records.field_records_electronic" in rule_ids(o6_16.violations) with input as inp
}

# Bodenproben: je angefangene 5 ha mindestens eine Probe (Beispiel 5,03 ha -> 2 Proben)
test_soil_samples_required_example if {
	o6_16.soil_samples_required(5.03) == 2
	o6_16.soil_samples_required(5) == 1
	o6_16.soil_samples_required(20) == 4
	o6_16.soil_samples_required(0) == 0
}

test_soil_samples_missing_after_deadline if {
	inp := with_year(with_o16({"soil_samples": [soil_sample("S1")]}), 2027)
	"o6_16.soil.samples_per_5ha" in rule_ids(o6_16.violations) with input as inp
}

test_soil_samples_open_in_2026 if {
	inp := with_o16({"soil_samples": [soil_sample("S1")]})
	not "o6_16.soil.samples_per_5ha" in rule_ids(o6_16.violations) with input as inp
	some o in o6_16.obligations with input as inp
	o.rule_id == "o6_16.soil.samples_per_5ha"
	o.status == "open"
}

test_soil_sample_before_2022_not_creditable if {
	old := object.union(soil_sample("S0"), {"sampling_date": "2021-10-01"})
	not o6_16.soil_sample_creditable(old)
	o6_16.soil_sample_creditable(soil_sample("S1"))
}

test_soil_sample_missing_parameter_not_creditable if {
	s := object.union(soil_sample("S0"), {"parameters": ["N", "P", "K", "pH"]})
	not o6_16.soil_sample_creditable(s)
}

test_soil_sample_from_other_farm_not_creditable if {
	s := object.union(soil_sample("S0"), {"received_with_parcel_from_other_farm": true})
	not o6_16.soil_sample_creditable(s)
}

test_soil_sample_mfa_assignment_example if {
	o6_16.soil_sample_mfa_year("2024-11-17", false) == 2024
	o6_16.soil_sample_mfa_year("2024-11-17", true) == 2025
}

# Weiterbildung
test_training_hours_counted if {
	o6_16.training_hours == 10 with input as base_input
	o6_16.training_fulfilled with input as base_input
}

test_training_before_2022_not_counted if {
	inp := with_o16({"training_courses": [{"course_id": "K0", "date": "2021-12-01", "hours": 10, "topics": ["grundwasserschutz"], "provider_recognized": true}]})
	o6_16.training_hours == 0 with input as inp
}

test_training_double_crediting_not_counted if {
	inp := with_o16({"training_courses": [{"course_id": "K1", "date": "2024-01-15", "hours": 10, "topics": ["humusaufbau"], "provider_recognized": true, "credited_to_other_commitment": true}]})
	o6_16.training_hours == 0 with input as inp
}

test_training_person_left_before_deadline if {
	inp := with_o16({"training_courses": [{"course_id": "K1", "date": "2024-01-15", "hours": 10, "topics": ["grundwasserschutz"], "provider_recognized": true, "attendee_left_farm_date": "2025-06-30"}]})
	o6_16.training_hours == 0 with input as inp
}

test_training_missing_after_2026 if {
	inp := with_year(with_o16({"training_courses": [{"course_id": "K1", "date": "2024-01-15", "hours": 8, "topics": ["grundwasserschutz"], "provider_recognized": true}]}), 2027)
	"o6_16.training.min_hours" in rule_ids(o6_16.violations) with input as inp
}

test_water_protection_concept_missing_after_2026 if {
	inp := with_year(with_o16({"water_protection_concept_date": null}), 2027)
	"o6_16.training.water_protection_concept" in rule_ids(o6_16.violations) with input as inp
}
