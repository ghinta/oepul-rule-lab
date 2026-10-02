package oepul.o6_17_test

import rego.v1

import data.oepul.o6_17

rule_ids(vs) := {v.rule_id | some v in vs}

# --- Grünlandumbruch --------------------------------------------------------

test_no_violations_for_compliant_farm if {
	count(o6_17.violations) == 0 with input as base_input
}

test_ploughing_during_contract_is_violation if {
	p := parcel_with(meadow, {"grassland_breaking_events": [{"event_date": "2025-04-01", "area_m2": 60000, "reason": "renewal"}]})
	"O617-OBL-NO-PLOUGHING" in rule_ids(o6_17.ploughing_violations) with input as with_parcels([p, single_cut, clover])
}

test_ploughing_before_contract_not_relevant if {
	p := parcel_with(meadow, {"grassland_breaking_events": [{"event_date": "2022-09-01", "area_m2": 60000, "reason": "renewal"}]})
	count(o6_17.ploughing_violations) == 0 with input as with_parcels([p, single_cut, clover])
}

test_pest_damage_renovation_with_documentation_permitted if {
	p := parcel_with(meadow, {"grassland_breaking_events": [{"event_date": "2025-04-01", "area_m2": 8000, "reason": "pest_damage_renovation", "documentation_kept": true}]})
	count(o6_17.ploughing_violations) == 0 with input as with_parcels([p, single_cut, clover])
}

test_pest_damage_renovation_without_documentation_violation if {
	p := parcel_with(meadow, {"grassland_breaking_events": [{"event_date": "2025-04-01", "area_m2": 8000, "reason": "pest_damage_renovation", "documentation_kept": false}]})
	"O617-OBL-NO-PLOUGHING" in rule_ids(o6_17.ploughing_violations) with input as with_parcels([p, single_cut, clover])
}

test_divrs_new_seeding_permitted_with_ubb if {
	p := parcel_with(meadow, {"codes": ["DIVRS"], "grassland_breaking_events": [{"event_date": "2025-04-01", "area_m2": 5000, "reason": "div_regional_seed_mixture"}]})
	count(o6_17.ploughing_violations) == 0 with input as with_parcels([p, single_cut, clover])
}

test_divrs_without_code_is_violation if {
	p := parcel_with(meadow, {"grassland_breaking_events": [{"event_date": "2025-04-01", "area_m2": 5000, "reason": "div_regional_seed_mixture"}]})
	"O617-OBL-NO-PLOUGHING" in rule_ids(o6_17.ploughing_violations) with input as with_parcels([p, single_cut, clover])
}

test_minor_deviation_up_to_300_m2_permitted if {
	p := parcel_with(meadow, {"grassland_breaking_events": [{"event_date": "2025-04-01", "area_m2": 300, "reason": "vegetable_garden"}]})
	count(o6_17.ploughing_violations) == 0 with input as with_parcels([p, single_cut, clover])
}

test_minor_deviation_above_300_m2_violation if {
	p := parcel_with(meadow, {"grassland_breaking_events": [{"event_date": "2025-04-01", "area_m2": 301, "reason": "drainage_new"}]})
	"O617-OBL-NO-PLOUGHING" in rule_ids(o6_17.ploughing_violations) with input as with_parcels([p, single_cut, clover])
}

test_fill_up_above_300_with_permit_permitted if {
	p := parcel_with(meadow, {"grassland_breaking_events": [{"event_date": "2025-04-01", "area_m2": 900, "reason": "fill_up", "state_permit_obtained": true}]})
	count(o6_17.ploughing_violations) == 0 with input as with_parcels([p, single_cut, clover])
}

test_fill_up_above_300_without_permit_violation if {
	p := parcel_with(meadow, {"grassland_breaking_events": [{"event_date": "2025-04-01", "area_m2": 900, "reason": "fill_up"}]})
	"O617-OBL-NO-PLOUGHING" in rule_ids(o6_17.ploughing_violations) with input as with_parcels([p, single_cut, clover])
}

test_fill_up_unused_must_be_declared_other_grassland if {
	p := object.union(parcel_with(meadow, {"grassland_breaking_events": [{"event_date": "2025-04-01", "area_m2": 900, "reason": "fill_up", "state_permit_obtained": true}]}), {"operations": {"cutting_dates": []}})
	"O617-DEF-FILL-UP-UNUSED" in rule_ids(o6_17.fill_up_declaration_violations) with input as with_parcels([p, single_cut, clover])
}

test_arable_grassland_swap_violation if {
	"O617-OBL-NO-SWAP" in rule_ids(o6_17.ploughing_violations) with input as with_measure({"arable_grassland_swap": true})
}

# --- Geräte ------------------------------------------------------------------

test_allowed_renewal_equipment if {
	p := parcel_with(meadow, {"renewal_equipment_used": ["saatstriegel", "schlitzdrillgeraet", "walze", "wiesenegge"]})
	count(o6_17.renewal_equipment_violations) == 0 with input as with_parcels([p, single_cut, clover])
}

test_rotary_harrow_not_allowed if {
	p := parcel_with(meadow, {"renewal_equipment_used": ["kreiselegge"]})
	"O617-OBL-RENEWAL-EQUIPMENT" in rule_ids(o6_17.renewal_equipment_violations) with input as with_parcels([p, single_cut, clover])
}

# --- Weiterbildung -----------------------------------------------------------

course(patch) := object.union({"course_date": "2024-03-01", "hours": 5, "provider_recognized": true, "attendee_role": "farm_manager"}, patch)

test_training_met if {
	o6_17.training_met with input as base_input
}

test_training_involved_person_counts if {
	o6_17.training_met with input as with_measure({"training": {"courses": [course({"attendee_role": "involved_person"})]}})
}

test_training_before_2022_not_creditable if {
	inp := with_measure({"training": {"courses": [course({"course_date": "2021-11-30"})]}})
	not o6_17.training_met with input as inp
	"O617-OBL-TRAINING" in rule_ids(o6_17.training_violations) with input as inp
}

test_training_after_deadline_not_creditable if {
	not o6_17.training_met with input as with_measure({"training": {"courses": [course({"course_date": "2026-01-10"})]}})
}

test_training_hours_summed if {
	inp := with_measure({"training": {"courses": [course({"hours": 2}), course({"hours": 3, "course_date": "2025-11-01"})]}})
	o6_17.training_hours == 5 with input as inp
	o6_17.training_met with input as inp
}

test_training_unrecognized_provider_not_creditable if {
	not o6_17.training_met with input as with_measure({"training": {"courses": [course({"provider_recognized": false})]}})
}

test_training_double_counting_not_creditable if {
	not o6_17.training_met with input as with_measure({"training": {"courses": [course({"credited_to_other_commitment": true})]}})
	not o6_17.training_met with input as with_measure({"training": {"courses": [course({"credited_to_other_farm": true})]}})
}

test_trained_person_left_before_deadline if {
	not o6_17.training_met with input as with_measure({"training": {"courses": [course({"attendee_left_farm_date": "2025-06-30"})]}})
}

test_trained_person_left_after_deadline if {
	o6_17.training_met with input as with_measure({"training": {"courses": [course({"attendee_left_farm_date": "2026-03-01"})]}})
}

test_training_not_yet_due_in_2024 if {
	inp := object.union(with_measure({"training": {"courses": []}}), {"farm": object.union(base_input.farm, {"year": 2024, "oepul": object.union(base_input.farm.oepul, {"o6_17": object.union(base_input.farm.oepul.o6_17, {"training": {"courses": []}})})})})
	count(o6_17.training_violations) == 0 with input as inp
}

test_training_confirmation_not_submitted if {
	inp := with_measure({"training": {"courses": [course({})], "confirmation_requested": true, "confirmation_submitted": false}})
	"O617-OBL-TRAINING-CONFIRMATION" in rule_ids(o6_17.training_violations) with input as inp
}

# --- Bodenuntersuchungen -----------------------------------------------------

test_soil_samples_example_5_10_minus_0_20 if {
	o6_17.required_soil_samples == 1 with input as with_measure({"soil_sample_base_mfa2025_grassland_lt18_ha": 5.10, "soil_sample_base_gloez_excluded_ha": 0.20})
}

test_soil_samples_example_10_40 if {
	o6_17.required_soil_samples == 3 with input as with_measure({"soil_sample_base_mfa2025_grassland_lt18_ha": 10.40})
}

test_soil_samples_exactly_10_ha if {
	o6_17.required_soil_samples == 2 with input as with_measure({"soil_sample_base_mfa2025_grassland_lt18_ha": 10.0})
}

test_soil_samples_met if {
	o6_17.required_soil_samples == 2 with input as base_input
	o6_17.soil_sampling_met with input as base_input
}

test_soil_sample_missing_humus_not_creditable if {
	inp := with_measure({"soil_samples": [{
		"sample_date": "2024-10-01",
		"lab_submission_date": "2024-10-02",
		"lab_accredited": true,
		"method": "sgd",
		"parameters": ["ph", "p", "k"],
	}]})
	o6_17.creditable_soil_sample_count == 0 with input as inp
	"O617-OBL-SOIL-SAMPLES" in rule_ids(o6_17.soil_sampling_violations) with input as inp
}

test_soil_sample_too_late if {
	inp := with_measure({"soil_samples": [{
		"sample_date": "2025-12-20",
		"lab_submission_date": "2026-01-03",
		"lab_accredited": true,
		"method": "sgd",
		"parameters": ["ph", "p", "k", "humus"],
	}]})
	o6_17.creditable_soil_sample_count == 0 with input as inp
}

test_soil_sample_received_with_area_not_creditable if {
	inp := with_measure({"soil_samples": [{
		"sample_date": "2024-10-01",
		"lab_submission_date": "2024-10-02",
		"lab_accredited": true,
		"method": "sgd",
		"parameters": ["ph", "p", "k", "humus"],
		"received_with_transferred_area": true,
	}]})
	o6_17.creditable_soil_sample_count == 0 with input as inp
}

test_soil_results_must_be_recorded_in_gis if {
	inp := with_measure({"soil_samples": [{
		"sample_date": "2024-10-01",
		"lab_submission_date": "2024-10-02",
		"lab_accredited": true,
		"method": "sgd",
		"parameters": ["ph", "p", "k", "humus"],
		"recorded_in_invekos_gis": false,
	}]})
	"O617-DOC-SOIL-RESULTS-GIS" in rule_ids(o6_17.soil_sampling_violations) with input as inp
}

test_soil_sample_base_fallback_from_parcels_2025 if {
	gloez := object.union(parcel_with(meadow, {"gloez_conversion_ban": "gloez9"}), {"parcel_id": "G9", "area_ha": 0.2})
	steep := object.union(meadow, {"parcel_id": "ST", "slope_percent": 25})
	second := object.union(meadow, {"parcel_id": "P5", "area_ha": 5.0})
	inp := json.remove(with_parcels([meadow, second, gloez, steep, clover]), ["farm/oepul/o6_17/soil_sample_base_mfa2025_grassland_lt18_ha"])
	o6_17.soil_sample_base_ha == 11 with input as inp
	o6_17.required_soil_samples == 3 with input as inp
}

# --- AGL-Dokumentation --------------------------------------------------------

rich_species := ["wiesen_salbei", "wiesen_margerite", "hornklee", "wiesen_glockenblume", "zittergras"]

agl_meadow := parcel_with(meadow, {"codes": ["AGL"], "species_rich": {
	"survey_sections": [{"indicator_species": rich_species}, {"indicator_species": array.concat(rich_species, ["thymian"])}],
	"survey_dates": ["2025-05-20"],
	"first_use_mowing": true,
	"survey_documented": true,
	"sketch_documented": true,
}})

test_agl_species_requirement_met if {
	o6_17.agl_species_requirement_met(agl_meadow)
}

test_agl_section_with_four_species_fails if {
	p := parcel_with(agl_meadow, {"species_rich": object.union(agl_meadow.oepul.species_rich, {"survey_sections": [{"indicator_species": rich_species}, {"indicator_species": ["wiesen_salbei", "hornklee", "zittergras", "thymian"]}]})})
	not o6_17.agl_species_requirement_met(p)
	"O617-AGL-SPECIES" in rule_ids(o6_17.agl_violations) with input as with_parcels([p, single_cut, clover])
}

test_agl_non_listed_species_not_counted if {
	p := parcel_with(agl_meadow, {"species_rich": object.union(agl_meadow.oepul.species_rich, {"survey_sections": [{"indicator_species": ["wiesen_salbei", "hornklee", "zittergras", "thymian", "loewenzahn_taraxacum"]}]})})
	not o6_17.agl_species_requirement_met(p)
}

test_agl_first_use_grazing_violation if {
	p := parcel_with(agl_meadow, {"species_rich": object.union(agl_meadow.oepul.species_rich, {"first_use_mowing": false})})
	"O617-AGL-FIRST-USE-MOWING" in rule_ids(o6_17.agl_violations) with input as with_parcels([p, single_cut, clover])
}

test_agl_missing_documentation_violation if {
	p := parcel_with(agl_meadow, {"species_rich": object.union(agl_meadow.oepul.species_rich, {"sketch_documented": false})})
	"O617-AGL-DOCUMENTATION" in rule_ids(o6_17.agl_violations) with input as with_parcels([p, single_cut, clover])
}

test_agl_code_on_single_cut_meadow_not_needed if {
	p := parcel_with(single_cut, {"codes": ["AGL"]})
	"O617-AGL-CODE-FIELD-USE" in rule_ids(o6_17.agl_violations) with input as with_parcels([meadow, p, clover])
}
