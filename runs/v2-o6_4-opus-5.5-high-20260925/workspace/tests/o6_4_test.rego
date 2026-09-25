package oepul.o6_4_test

import data.oepul.o6_4

# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

base_parcel := {
	"parcel_id": "P1",
	"area_ha": 2.0,
	"land_use": "grassland",
	"mountain_meadow": {
		"declared_as_mountain_meadow": true,
		"above_local_permanent_settlement_limit": true,
		"share_above_1200m_percent": 80,
		"parcel_altitude_m": 1500,
		"adjacent_to_home_farm_areas": false,
	},
	"oepul_measure_participation": [{"measure_id": "o6_4", "premium_component": "area", "payment_eur_per_ha": null}],
	"oepul_codes": ["BM2"],
	"operations": {
		"cutting_dates": ["2026-07-20"],
		"mowing": {
			"full_area": true,
			"mown_material_removed": true,
			"mulched": false,
			"mown_material_left_lying": false,
			"method": "hand_guided_motor_mower",
			"mowed_previous_year": false,
		},
		"grazing_dates": ["2026-08-20"],
		"psm_used": false,
		"psm_only_bio_approved_substances": null,
		"fertilizer": {"mineral_n_kg_per_ha": 0, "organic_n_kg_per_ha": null, "applied_types": ["solid_manure"]},
	},
	"constraints": {"in_national_park": false},
}

base_measure_record := {
	"measure_id": "o6_4",
	"contract_start_date": "2024-01-01",
	"measure_application_date": "2023-12-15",
	"exit_date": null,
	"exit_reason": null,
	"full_reductions_100pct_count": 0,
}

base_participation := {
	"applicant_type": "natural_person",
	"public_body_share_percent": 0,
	"is_active_farmer": true,
	"manages_in_own_name_and_account": true,
	"first_oepul_participation_year": 2024,
	"protected_cultivation_area_ha": 0,
	"is_alpine_farm_operation": false,
	"home_farm_altitude_m": 900,
	"measures": [base_measure_record],
}

input_with(parcels) := {
	"farm": {"year": 2026, "oepul_participation": base_participation},
	"land": {"total_area_ha": 20, "parcels": parcels},
}

base_input := input_with([base_parcel])

parcel_with(path, value) := json.patch(base_parcel, [{"op": "replace", "path": path, "value": value}])

has_violation(result, rule_id) if {
	some v in result
	v.rule_id == rule_id
}

# ---------------------------------------------------------------------------
# Prämie (O6_4-PREM-001/-002)
# ---------------------------------------------------------------------------

test_premium_bm2_2026 if {
	o6_4.parcel_premium.P1 == 1188 with input as base_input
	o6_4.premium_before_modulation == 1188 with input as base_input
}

test_premium_rates_by_year if {
	o6_4.premium_rate("BM1", 2023) == 350
	o6_4.premium_rate("BM1", 2024) == 378
	o6_4.premium_rate("BM2", 2023) == 550
	o6_4.premium_rate("BM3", 2023) == 900
	o6_4.premium_rate("BM3", 2028) == 972
	o6_4.premium_rate("BM0", 2026) == 0
}

test_bm0_year_no_premium_but_no_mowing_violation_if_mowed_previous_year if {
	p := json.patch(base_parcel, [
		{"op": "replace", "path": "/oepul_codes", "value": ["BM0"]},
		{"op": "replace", "path": "/operations/cutting_dates", "value": ["2025-07-15"]},
	])
	inp := input_with([p])
	o6_4.parcel_premium.P1 == 0 with input as inp
	o6_4.premium_parcel_reason("P1") == "no_mowing" with input as inp
	not has_violation(o6_4.violation, "O6_4-MOW-001") with input as inp
}

test_two_years_without_mowing_is_violation if {
	p := json.patch(base_parcel, [
		{"op": "replace", "path": "/oepul_codes", "value": ["BM0"]},
		{"op": "replace", "path": "/operations/cutting_dates", "value": []},
	])
	has_violation(o6_4.violation, "O6_4-MOW-001") with input as input_with([p])
}

test_partial_mowing_gives_no_premium if {
	p := parcel_with("/operations/mowing/full_area", false)
	o6_4.premium_parcel_reason("P1") == "no_valid_full_mowing" with input as input_with([p])
	o6_4.parcel_premium.P1 == 0 with input as input_with([p])
}

# ---------------------------------------------------------------------------
# Teilnahmefähige Flächen (O6_4-ELIG-*)
# ---------------------------------------------------------------------------

test_base_parcel_eligible if {
	o6_4.eligibility.P1.eligible with input as base_input
}

test_half_above_1200m_not_enough if {
	p := parcel_with("/mountain_meadow/share_above_1200m_percent", 50)
	inp := input_with([p])
	"O6_4-ELIG-002" in o6_4.eligibility.P1.failed_rules with input as inp
	o6_4.parcel_premium.P1 == 0 with input as inp
}

test_not_declared_as_mountain_meadow if {
	p := parcel_with("/mountain_meadow/declared_as_mountain_meadow", false)
	"O6_4-ELIG-001" in o6_4.eligibility.P1.failed_rules with input as input_with([p])
}

test_below_settlement_limit if {
	p := parcel_with("/mountain_meadow/above_local_permanent_settlement_limit", false)
	"O6_4-ELIG-003" in o6_4.eligibility.P1.failed_rules with input as input_with([p])
}

test_below_home_farm_fails_unless_alpine_farm if {
	p := parcel_with("/mountain_meadow/parcel_altitude_m", 850)
	inp := input_with([p])
	"O6_4-ELIG-004" in o6_4.eligibility.P1.failed_rules with input as inp
	alp := json.patch(inp, [{"op": "replace", "path": "/farm/oepul_participation/is_alpine_farm_operation", "value": true}])
	o6_4.eligibility.P1.eligible with input as alp
}

test_adjacent_is_only_advisory if {
	p := parcel_with("/mountain_meadow/adjacent_to_home_farm_areas", true)
	inp := input_with([p])
	o6_4.eligibility.P1.eligible with input as inp
	some a in o6_4.advisory with input as inp
	a.rule_id == "O6_4-ELIG-005"
}

test_non_eligible_category if {
	p := json.patch(base_parcel, [{"op": "add", "path": "/non_eligible_categories", "value": ["not_mainly_agricultural"]}])
	"GEN-ELIG-002" in o6_4.eligibility.P1.failed_rules with input as input_with([p])
}

# ---------------------------------------------------------------------------
# Förderverpflichtungen (O6_4-MOW/GRAZE/FERT/PSM/CODE)
# ---------------------------------------------------------------------------

test_base_has_no_violations if {
	count(o6_4.violation) == 0 with input as base_input
}

test_max_one_mowing_per_year if {
	p := parcel_with("/operations/cutting_dates", ["2026-07-01", "2026-09-01"])
	has_violation(o6_4.violation, "O6_4-MOW-002") with input as input_with([p])
}

test_mulching_not_allowed if {
	p := parcel_with("/operations/mowing/mulched", true)
	has_violation(o6_4.violation, "O6_4-MOW-003") with input as input_with([p])
}

test_mown_material_left_lying_not_allowed if {
	p := parcel_with("/operations/mowing/mown_material_left_lying", true)
	has_violation(o6_4.violation, "O6_4-MOW-003") with input as input_with([p])
}

test_grazing_before_16_august_violation if {
	p := parcel_with("/operations/grazing_dates", ["2026-08-15"])
	has_violation(o6_4.violation, "O6_4-GRAZE-001") with input as input_with([p])
}

test_after_grazing_from_16_august_allowed_even_without_mowing if {
	p := json.patch(base_parcel, [
		{"op": "replace", "path": "/operations/grazing_dates", "value": ["2026-08-16"]},
		{"op": "replace", "path": "/oepul_codes", "value": ["BM0"]},
		{"op": "replace", "path": "/operations/cutting_dates", "value": ["2025-07-10"]},
	])
	not has_violation(o6_4.violation, "O6_4-GRAZE-001") with input as input_with([p])
}

test_prohibited_fertilizers if {
	every t in ["slurry", "lime_fertilizer", "solid_manure_dissolved_in_water", "sewage_sludge", "composted_sewage_sludge", "mineral_fertilizer"] {
		has_violation(o6_4.violation, "O6_4-FERT-001") with input as input_with([parcel_with("/operations/fertilizer/applied_types", [t])])
	}
}

test_allowed_fertilizers if {
	p := parcel_with("/operations/fertilizer/applied_types", ["solid_manure", "own_household_wastewater"])
	not has_violation(o6_4.violation, "O6_4-FERT-001") with input as input_with([p])
}

test_mineral_n_violation if {
	p := parcel_with("/operations/fertilizer/mineral_n_kg_per_ha", 20)
	has_violation(o6_4.violation, "O6_4-FERT-001") with input as input_with([p])
}

test_psm_only_bio_allowed if {
	bio := json.patch(base_parcel, [
		{"op": "replace", "path": "/operations/psm_used", "value": true},
		{"op": "replace", "path": "/operations/psm_only_bio_approved_substances", "value": true},
	])
	not has_violation(o6_4.violation, "O6_4-PSM-001") with input as input_with([bio])
	conv := parcel_with("/operations/psm_used", true)
	has_violation(o6_4.violation, "O6_4-PSM-001") with input as input_with([conv])
}

test_code_must_match_method if {
	p := parcel_with("/oepul_codes", ["BM1"])
	has_violation(o6_4.violation, "O6_4-CODE-003") with input as input_with([p])
	o6_4.expected_code_for_method("hand_guided_motor_mower") == "BM2"
	o6_4.expected_code_for_method("scythe_or_motor_scythe") == "BM3"
}

test_mowing_code_without_mowing if {
	p := parcel_with("/operations/cutting_dates", [])
	has_violation(o6_4.violation, "O6_4-CODE-004") with input as input_with([p])
}

test_bm0_with_mowing if {
	p := parcel_with("/oepul_codes", ["BM0"])
	has_violation(o6_4.violation, "O6_4-CODE-004") with input as input_with([p])
}

test_missing_code if {
	p := parcel_with("/oepul_codes", [])
	has_violation(o6_4.violation, "O6_4-CODE-002") with input as input_with([p])
}

# ---------------------------------------------------------------------------
# Kombinationen (O6_4-PREM-003, Anhang L)
# ---------------------------------------------------------------------------

test_landscape_elements_of_ubb_and_bio_combinable if {
	p := parcel_with("/oepul_measure_participation", [
		{"measure_id": "o6_4", "premium_component": "area"},
		{"measure_id": "o6_1a", "premium_component": "landscape_element", "payment_eur_per_ha": 8.6},
	])
	count(o6_4.combination_conflict) == 0 with input as input_with([p])
}

test_area_premium_of_other_measures_not_combinable if {
	every m in ["o6_1a", "o6_1b", "o6_3", "o6_18", "o6_19", "o6_17"] {
		p := parcel_with("/oepul_measure_participation", [
			{"measure_id": "o6_4", "premium_component": "area"},
			{"measure_id": m, "premium_component": "area"},
		])
		count(o6_4.combination_conflict) == 1 with input as input_with([p])
	}
}

test_annex_l_row_4_only_1a_1b if {
	cells := [c.measure_id | some c in o6_4.combination_row.cells; c.marker != null]
	cells == ["1A", "1B"]
}

# ---------------------------------------------------------------------------
# OP-Code, Nationalpark, Obergrenze, Modulation
# ---------------------------------------------------------------------------

test_op_code_no_premium if {
	p := parcel_with("/oepul_codes", ["BM2", "OP"])
	o6_4.parcel_premium.P1 == 0 with input as input_with([p])
}

test_national_park_no_premium if {
	p := parcel_with("/constraints/in_national_park", true)
	inp := input_with([p])
	o6_4.premium_parcel_reason("P1") == "national_park" with input as inp
	count(o6_4.violation) == 0 with input as inp
}

test_cap_exceeded_flagged if {
	p := json.patch(base_parcel, [
		{"op": "replace", "path": "/oepul_codes", "value": ["BM3"]},
		{"op": "replace", "path": "/operations/mowing/method", "value": "scythe_or_motor_scythe"},
		{"op": "replace", "path": "/oepul_measure_participation", "value": [
			{"measure_id": "o6_4", "premium_component": "area"},
			{"measure_id": "o6_1b", "premium_component": "landscape_element", "payment_eur_per_ha": 400},
		]},
	])
	count(o6_4.cap_exceeded) == 1 with input as input_with([p])
	count(o6_4.cap_exceeded) == 0 with input as base_input
}

test_modulation_example_220_ha if {
	f := o6_4.modulation_factor(220)
	abs(f - (218 / 220)) < 0.000001
	round(f * 10000) == 9909
}

test_modulation_tiers if {
	o6_4.modulation_factor(150) == 1
	abs(o6_4.modulation_factor(1200) - ((((200 + 90) + 595) + 150) / 1200)) < 0.000001
	o6_4.modulation_factor(0) == 1
}

test_premium_after_modulation if {
	inp := json.patch(base_input, [{"op": "replace", "path": "/land/total_area_ha", "value": 220}])
	o6_4.premium_after_modulation == round((1188 * (218 / 220)) * 100) / 100 with input as inp
}

test_small_payment_and_advance if {
	o6_4.payment_may_be_waived(50)
	not o6_4.payment_may_be_waived(50.01)
	o6_4.max_advance_payment(1000) == 750
}

# ---------------------------------------------------------------------------
# Vertrag, Antrag, Wechsel, Übernahme, Ausstieg
# ---------------------------------------------------------------------------

test_contract_periods if {
	o6_4.contract_period_for_start("2023-01-01").years == 6
	o6_4.contract_period_for_start("2024-01-01").years == 5
	o6_4.contract_period_for_start("2025-01-01").years == 4
	o6_4.contract_end_date == "2028-12-31"
}

test_entry_years if {
	o6_4.entry_year_allowed(2025)
	not o6_4.entry_year_allowed(2026)
}

test_application_deadline if {
	o6_4.application_timely("2024-12-31", "2025-01-01")
	not o6_4.application_timely("2025-01-02", "2025-01-01")
}

test_application_status_valid if {
	o6_4.application_status.contract_valid with input as base_input
}

test_application_status_late_entry if {
	inp := json.patch(base_input, [
		{"op": "replace", "path": "/farm/oepul_participation/measures/0/contract_start_date", "value": "2026-01-01"},
		{"op": "replace", "path": "/farm/oepul_participation/measures/0/measure_application_date", "value": "2025-12-20"},
	])
	"O6_4-APP-002" in o6_4.application_status.reasons with input as inp
}

test_switch_to_nature_conservation if {
	o6_4.switch_allowed("o6_18", "2025-12-31")
	o6_4.switch_allowed("o6_19", "2025-06-01")
	not o6_4.switch_allowed("o6_18", "2026-01-01")
	not o6_4.switch_allowed("o6_1b", "2025-06-01")
}

test_takeover if {
	o6_4.takeover_deadline(2026) == "2026-04-15"
	o6_4.takeover_deadline(2028) == "2028-04-17"
	o6_4.takeover_allowed("2026-04-15", 0.5)
	not o6_4.takeover_allowed("2026-04-16", 0.2)
	not o6_4.takeover_allowed("2026-03-01", 0.6)
}

test_early_exit_repayment if {
	exit := json.patch(base_input, [{"op": "replace", "path": "/farm/oepul_participation/measures/0/exit_date", "value": "2026-06-01"}])
	o6_4.early_exit_repayment_required with input as exit
	exempt := json.patch(exit, [{"op": "replace", "path": "/farm/oepul_participation/measures/0/exit_reason", "value": "loss_of_control_over_area"}])
	not o6_4.early_exit_repayment_required with input as exempt
	not o6_4.measure_valid_in_year(2026) with input as exit
	o6_4.measure_valid_in_year(2026) with input as base_input
}

test_non_application_consequence if {
	o6_4.non_application_consequence(true) == "commitment_remains_no_payment"
	o6_4.non_application_consequence(false) == "commitment_ends_full_repayment"
}

# ---------------------------------------------------------------------------
# Allgemeine Bedingungen
# ---------------------------------------------------------------------------

test_public_body_not_eligible if {
	inp := json.patch(base_input, [{"op": "replace", "path": "/farm/oepul_participation/applicant_type", "value": "public_body"}])
	not o6_4.applicant_eligible with input as inp
	share := json.patch(base_input, [{"op": "replace", "path": "/farm/oepul_participation/public_body_share_percent", "value": 30}])
	not o6_4.applicant_eligible with input as share
	o6_4.applicant_eligible with input as base_input
}

test_minimum_farm_size_first_year if {
	first := json.patch(base_input, [
		{"op": "replace", "path": "/farm/oepul_participation/first_oepul_participation_year", "value": 2026},
		{"op": "replace", "path": "/land/total_area_ha", "value": 1.0},
	])
	not o6_4.minimum_farm_size_met with input as first
	ok := json.patch(first, [{"op": "replace", "path": "/land/total_area_ha", "value": 1.5}])
	o6_4.minimum_farm_size_met with input as ok
	later := json.patch(base_input, [{"op": "replace", "path": "/land/total_area_ha", "value": 1.0}])
	o6_4.minimum_farm_size_met with input as later
}

test_area_reduction_tolerance if {
	o6_4.area_reduction_tolerance_ha(4) == 0.5
	o6_4.area_reduction_tolerance_ha(40) == 2
	o6_4.area_reduction_tolerance_ha(200) == 5
	o6_4.area_reduction_repayment_ha(40, 37, 0) == 3
	o6_4.area_reduction_repayment_ha(40, 38.5, 0) == 0
	o6_4.area_reduction_repayment_ha(40, 30, 9) == 0
}

test_area_additions if {
	o6_4.premium_eligible_area_limit_ha(4, 2026) == 9
	o6_4.premium_eligible_area_limit_ha(20, 2027) == 30
	o6_4.area_addition_excess_ha(12, 4, 2026) == 3
	o6_4.area_addition_excess_ha(50, 4, 2025) == 0
}

test_sanction_stages if {
	o6_4.sanction_reduction_percent(0, 2026) == 0
	o6_4.sanction_reduction_percent(0, 2027) == 1
	o6_4.sanction_reduction_percent(4, 2026) == 25
	o6_4.sanction_reduction_percent(6, 2026) == 100
}

test_exclusion_after_two_full_reductions if {
	inp := json.patch(base_input, [{"op": "replace", "path": "/farm/oepul_participation/measures/0/full_reductions_100pct_count", "value": 2}])
	o6_4.excluded_from_measure with input as inp
	not o6_4.excluded_from_measure with input as base_input
}

test_access_failure_consequence if {
	o6_4.access_failure_consequence(1) == "no_contract"
	o6_4.access_failure_consequence(3) == "no_premium_in_year"
}

test_mid_year_transfer_without_continuation if {
	p := json.patch(base_parcel, [{"op": "add", "path": "/transferred_mid_year_without_continuation", "value": true}])
	has_violation(o6_4.violation, "GEN-DUR-002") with input as input_with([p])
}

test_permanent_circumstance_premium_year if {
	o6_4.premium_in_year_of_permanent_circumstance("2026-05-01", false)
	not o6_4.premium_in_year_of_permanent_circumstance("2026-03-01", false)
	o6_4.premium_in_year_of_permanent_circumstance("2026-03-01", true)
}

test_commitment_period_calendar_year if {
	o6_4.commitment_period(2026) == {"from": "2026-01-01", "to": "2026-12-31"}
}

test_decision_aggregate if {
	d := o6_4.decision with input as base_input
	d.premium_before_modulation_eur == 1188
	d.applicant_eligible
	d.parcels.P1.bm_code == "BM2"
	d.parcels.P1.premium_status == "premium"
	d.application.contract_valid
}

test_grassland_basis_excludes_mountain_meadows if {
	other := json.patch(base_parcel, [
		{"op": "replace", "path": "/parcel_id", "value": "P2"},
		{"op": "replace", "path": "/area_ha", "value": 5.5},
		{"op": "replace", "path": "/mountain_meadow/declared_as_mountain_meadow", "value": false},
		{"op": "replace", "path": "/oepul_measure_participation", "value": []},
	])
	o6_4.grassland_basis_excluding_mountain_meadows_ha == 5.5 with input as input_with([base_parcel, other])
}
