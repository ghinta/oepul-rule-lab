package oepul.o6_17.obligations_test

import data.oepul.o6_17.fixtures
import data.oepul.o6_17.obligations

rule_ids(vs) := {v.rule_id | some v in vs}

with_breakup(e) := fixtures.with_parcels([
	object.union(fixtures.parcel_g1, {"o6_17": {"grassland_breakups": [e]}}),
	fixtures.parcel_g2,
	fixtures.parcel_a1,
])

test_base_farm_has_no_obligation_violations if {
	count(obligations.violations) == 0 with input as fixtures.base_input
}

test_ploughing_without_exception_is_violation if {
	inp := with_breakup({"type": "ploughing", "reason": "none", "area_m2": 5000})
	"o6_17.obligation.no_grassland_ploughing" in rule_ids(obligations.violations) with input as inp
}

test_ploughing_after_pest_damage_needs_documentation if {
	ok := with_breakup({"type": "ploughing", "reason": "pest_damage", "necessity_documented": true})
	not "o6_17.obligation.no_grassland_ploughing" in rule_ids(obligations.violations) with input as ok
	bad := with_breakup({"type": "ploughing", "reason": "pest_damage", "necessity_documented": false})
	"o6_17.obligation.no_grassland_ploughing" in rule_ids(obligations.violations) with input as bad
}

test_ploughing_for_biodiversity_reseeding_requires_ubb_or_bio if {
	ok := with_breakup({"type": "ploughing", "reason": "biodiversity_reseeding"})
	not "o6_17.obligation.no_grassland_ploughing" in rule_ids(obligations.violations) with input as ok
	no_ubb := object.union(ok, {"farm": {"oepul": {"participating_measures": ["17"]}}})
	"o6_17.obligation.no_grassland_ploughing" in rule_ids(obligations.violations) with input as no_ubb
}

test_minor_deviation_limit_300m2 if {
	ok := with_breakup({"type": "minor_deviation", "area_m2": 300})
	not "o6_17.obligation.minor_deviation_300m2" in rule_ids(obligations.violations) with input as ok
	bad := with_breakup({"type": "minor_deviation", "area_m2": 301})
	"o6_17.obligation.minor_deviation_300m2" in rule_ids(obligations.violations) with input as bad
}

test_fill_over_300m2_requires_permit if {
	bad := with_breakup({"type": "fill", "area_m2": 800, "state_permit_obtained": false})
	"o6_17.obligation.fill_over_300m2_permit" in rule_ids(obligations.violations) with input as bad
	ok := with_breakup({"type": "fill", "area_m2": 800, "state_permit_obtained": true})
	not "o6_17.obligation.fill_over_300m2_permit" in rule_ids(obligations.violations) with input as ok
}

test_fill_without_use_must_be_sonstige_gruenland if {
	inp := with_breakup({"type": "fill", "area_m2": 200, "no_use_in_year": true})
	"o6_17.obligation.fill_without_use_sonstige_gruenland" in rule_ids(obligations.violations) with input as inp
}

test_arable_grassland_swap_forbidden if {
	inp := fixtures.with_parcels([fixtures.parcel_g1, object.union(fixtures.parcel_a1, {"o6_17": {"arable_grassland_swap": true}})])
	"o6_17.obligation.no_arable_grassland_swap" in rule_ids(obligations.violations) with input as inp
}

test_renewal_devices if {
	ok := fixtures.with_parcels([object.union(fixtures.parcel_g1, {"o6_17": {"renewal_devices_used": ["Saatstriegel", "Wiesenegge"]}})])
	not "o6_17.obligation.allowed_renewal_devices" in rule_ids(obligations.violations) with input as ok
	bad := fixtures.with_parcels([object.union(fixtures.parcel_g1, {"o6_17": {"renewal_devices_used": ["Fräse"]}})])
	"o6_17.obligation.allowed_renewal_devices" in rule_ids(obligations.violations) with input as bad
}

test_training_insufficient_hours if {
	inp := fixtures.with_o6({"training_courses": [{"person_id": "p1", "person_role": "applicant", "topic": "grassland", "hours": 4, "course_date": "2024-03-01", "provider_recognized": true}]})
	not obligations.training_fulfilled with input as inp
	"o6_17.obligation.training_5h_grassland" in rule_ids(obligations.violations) with input as inp
}

test_training_hours_add_up_per_person if {
	inp := fixtures.with_o6({"training_courses": [
		{"person_id": "p2", "person_role": "involved_person", "topic": "grassland", "hours": 3, "course_date": "2023-02-01", "provider_recognized": true},
		{"person_id": "p2", "person_role": "involved_person", "topic": "grassland", "hours": 2, "course_date": "2025-11-01", "provider_recognized": true},
	]})
	obligations.training_fulfilled with input as inp
}

test_training_before_2022_or_double_counted_not_valid if {
	old := fixtures.with_o6({"training_courses": [{"person_id": "p1", "person_role": "applicant", "topic": "grassland", "hours": 6, "course_date": "2021-12-31", "provider_recognized": true}]})
	not obligations.training_fulfilled with input as old
	double := fixtures.with_o6({"training_courses": [{"person_id": "p1", "person_role": "applicant", "topic": "grassland", "hours": 6, "course_date": "2024-03-01", "provider_recognized": true, "counted_for_other_commitment": true}]})
	not obligations.training_fulfilled with input as double
}

test_trained_person_leaving_before_deadline if {
	left := fixtures.with_o6({"training_courses": [{"person_id": "p1", "person_role": "applicant", "topic": "grassland", "hours": 6, "course_date": "2024-03-01", "provider_recognized": true, "person_left_farm_date": "2025-06-30"}]})
	not obligations.training_fulfilled with input as left
	left_later := fixtures.with_o6({"training_courses": [{"person_id": "p1", "person_role": "applicant", "topic": "grassland", "hours": 6, "course_date": "2024-03-01", "provider_recognized": true, "person_left_farm_date": "2026-02-01"}]})
	obligations.training_fulfilled with input as left_later
}

test_soil_sample_count_examples_from_information_sheet if {
	ex1 := fixtures.with_o6({"soil_sample_basis_area_ha": 4.9})
	obligations.required_soil_samples == 1 with input as ex1
	ex2 := fixtures.with_o6({"soil_sample_basis_area_ha": 10.4})
	obligations.required_soil_samples == 3 with input as ex2
	ex3 := fixtures.with_o6({"soil_sample_basis_area_ha": 10.0})
	obligations.required_soil_samples == 2 with input as ex3
}

test_soil_sample_basis_excludes_gloez_and_steep_parcels if {
	obligations.computed_basis_area_ha == 3.0 with input as fixtures.base_input
}

test_soil_sample_requirements if {
	bad := fixtures.with_o6({"soil_samples": [{"sample_id": "S1", "sample_date": "2021-10-01", "lab_submission_date": "2021-10-05", "lab_accredited": true, "method": "sgd", "parameters": ["ph", "phosphor", "kalium", "humus"], "recorded_in_invekos_gis": true}]})
	"o6_17.obligation.soil_samples_per_5ha" in rule_ids(obligations.violations) with input as bad
	no_humus := fixtures.with_o6({"soil_samples": [{"sample_id": "S1", "sample_date": "2025-04-02", "lab_submission_date": "2025-04-05", "lab_accredited": true, "method": "euf", "parameters": ["ph", "phosphor", "kalium"], "recorded_in_invekos_gis": true}]})
	obligations.valid_soil_sample_count == 0 with input as no_humus
	transferred := fixtures.with_o6({"soil_samples": [{"sample_id": "S1", "sample_date": "2025-04-02", "lab_submission_date": "2025-04-05", "lab_accredited": true, "method": "sgd", "parameters": ["ph", "phosphor", "kalium", "humus"], "received_with_transferred_parcel": true}]})
	obligations.valid_soil_sample_count == 0 with input as transferred
}

test_soil_sample_submitted_after_deadline_invalid if {
	late := fixtures.with_o6({"soil_samples": [{"sample_id": "S1", "sample_date": "2025-12-20", "lab_submission_date": "2026-01-05", "lab_accredited": true, "method": "sgd", "parameters": ["ph", "phosphor", "kalium", "humus"], "recorded_in_invekos_gis": true}]})
	obligations.valid_soil_sample_count == 0 with input as late
}

test_soil_results_must_be_recorded_in_gis if {
	inp := fixtures.with_o6({"soil_samples": [{"sample_id": "S9", "sample_date": "2025-04-02", "lab_submission_date": "2025-04-05", "lab_accredited": true, "method": "sgd", "parameters": ["ph", "phosphor", "kalium", "humus"], "recorded_in_invekos_gis": false}]})
	"o6_17.obligation.soil_sample_results_in_gis" in rule_ids(obligations.violations) with input as inp
}

test_soil_basis_missing_after_2025_reported if {
	inp := fixtures.with_year(2026)
	"farm.oepul.o6_17.soil_sample_basis_area_ha" in obligations.missing_inputs with input as inp
}
