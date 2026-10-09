package oepul.o6_1c_test

import data.oepul.o6_1c

# --- Basisfall -------------------------------------------------------------

test_base_case_contract_valid_without_violations if {
	d := o6_1c.decision with input as base_input
	d.contract_valid == true
	count(d.access_violations) == 0
	count(d.application_violations) == 0
	count(d.commitment_violations) == 0
	count(d.parcel_exclusions) == 0
}

test_base_case_premium_band if {
	d := o6_1c.decision with input as base_input
	approx(d.npa_eligible_area_ha, 1.6)
	approx(d.afs_eligible_area_ha, 0.3)
	approx(d.premium_band.min_eur, 740)
	approx(d.premium_band.max_eur, 960)
	approx(d.premium_band.guaranteed_eur, 740)
}

# --- Angebot / Vertrag -----------------------------------------------------

test_scope_measure_not_offered_before_2025 if {
	inp := replace("/farm/year", 2024)
	o6_1c.access_violations[_].rule_id == "O6_1C-SCOPE-002" with input as inp
}

test_contract_is_one_year_measure if {
	o6_1c.is_one_year_measure with input as base_input
	p := o6_1c.commitment_period with input as base_input
	p == {"start": "2026-01-01", "end": "2026-12-31"}
}

test_application_after_31_december_is_late if {
	inp := replace("/farm/oepul/o6_1c/application_date", "2026-01-05")
	vs := o6_1c.application_violations with input as inp
	has_rule(vs, "O6_1C-APP-001")
	not o6_1c.contract_valid with input as inp
}

test_last_entry_2027 if {
	ok := patched([
		{"op": "replace", "path": "/farm/year", "value": 2027},
		{"op": "replace", "path": "/farm/oepul/o6_1c/first_contract_year", "value": 2027},
		{"op": "replace", "path": "/farm/oepul/o6_1c/application_date", "value": "2026-12-31"},
	])
	not has_rule(o6_1c.application_violations, "O6_1C-APP-002") with input as ok
	late := patched([
		{"op": "replace", "path": "/farm/year", "value": 2028},
		{"op": "replace", "path": "/farm/oepul/o6_1c/first_contract_year", "value": 2028},
		{"op": "replace", "path": "/farm/oepul/o6_1c/application_date", "value": "2027-12-20"},
	])
	has_rule(o6_1c.application_violations, "O6_1C-APP-002") with input as late
}

test_automatic_extension_into_following_year if {
	inp := replace("/farm/year", 2027)
	o6_1c.contract_extended_into_year with input as inp
	o6_1c.contract_valid with input as inp
}

test_continuation_requires_multiple_application if {
	inp := patched([
		{"op": "replace", "path": "/farm/year", "value": 2027},
		{"op": "replace", "path": "/farm/oepul/o6_1c/multiple_application_submitted", "value": false},
	])
	has_rule(o6_1c.application_violations, "O6_1C-APP-011") with input as inp
}

test_deregistration_during_year_invalidates_measure if {
	inp := replace("/farm/oepul/o6_1c/deregistration_date", "2026-06-01")
	d := o6_1c.decision with input as inp
	d.deregistered_in_year == true
	d.contract_valid == false
	d.premium_band.max_eur == 0
}

test_deregistration_from_following_year_keeps_current_year if {
	inp := replace("/farm/oepul/o6_1c/deregistration_date", "2027-01-01")
	o6_1c.contract_valid with input as inp
}

test_reentry_requires_new_measure_application if {
	inp := patched([{"op": "add", "path": "/farm/oepul/o6_1c/reentry_after_exit_or_exclusion", "value": true}])
	has_rule(o6_1c.application_violations, "O6_1C-APP-010") with input as inp
	inp2 := json.patch(inp, [{"op": "add", "path": "/farm/oepul/o6_1c/new_measure_application_submitted", "value": true}])
	not has_rule(o6_1c.application_violations, "O6_1C-APP-010") with input as inp2
}

test_takeover_deadline_and_extension if {
	late := patched([{"op": "add", "path": "/farm/oepul/o6_1c/takeover", "value": {"date": "2026-04-16", "taken_over_area_ha": 2, "additional_area_ha": 0.5}}])
	has_rule(o6_1c.application_violations, "O6_1C-APP-012") with input as late
	ok := patched([{"op": "add", "path": "/farm/oepul/o6_1c/takeover", "value": {"date": "2026-04-15", "taken_over_area_ha": 2, "additional_area_ha": 1}}])
	not has_rule(o6_1c.application_violations, "O6_1C-APP-012") with input as ok
	too_big := patched([{"op": "add", "path": "/farm/oepul/o6_1c/takeover", "value": {"date": "2026-04-10", "taken_over_area_ha": 2, "additional_area_ha": 1.5}}])
	has_rule(o6_1c.application_violations, "O6_1C-APP-012") with input as too_big
}

test_takeover_deadline_2028_is_17_april if {
	o6_1c.takeover_deadline(2028) == "2028-04-17"
	o6_1c.takeover_deadline(2026) == "2026-04-15"
}

# --- Zugangsvoraussetzungen -------------------------------------------------

test_npa_excluded_with_ubb if {
	inp := replace("/farm/oepul/participating_measures", ["o6_1a"])
	has_rule(o6_1c.access_violations, "O6_1C-ELIG-001") with input as inp
	not o6_1c.contract_valid with input as inp
}

test_npa_excluded_with_full_bio if {
	inp := patched([
		{"op": "replace", "path": "/farm/oepul/participating_measures", "value": ["o6_1b"]},
		{"op": "replace", "path": "/farm/oepul/bio_participation_type", "value": "full"},
	])
	has_rule(o6_1c.access_violations, "O6_1C-ELIG-001") with input as inp
}

test_npa_allowed_with_bio_partial_farm_wine_fruit_hops if {
	inp := patched([
		{"op": "replace", "path": "/farm/oepul/participating_measures", "value": ["o6_1b"]},
		{"op": "replace", "path": "/farm/oepul/bio_participation_type", "value": "partial_wine_fruit_hops"},
	])
	not has_rule(o6_1c.access_violations, "O6_1C-ELIG-001") with input as inp
}

test_agroforest_only_allowed_with_ubb if {
	inp := patched([
		{"op": "replace", "path": "/farm/oepul/participating_measures", "value": ["o6_1a"]},
		{"op": "replace", "path": "/farm/oepul/o6_1c/categories", "value": ["agroforest"]},
	])
	not has_rule(o6_1c.access_violations, "O6_1C-ELIG-001") with input as inp
}

test_public_body_admitted_from_2025 if {
	inp := replace("/farm/applicant/type", "public_body")
	o6_1c.public_body_exception_applies with input as inp
	not has_rule(o6_1c.access_violations, "O6_1C-ELIG-002") with input as inp
}

test_inactive_farmer_not_eligible if {
	inp := replace("/farm/applicant/is_active_farmer", false)
	has_rule(o6_1c.access_violations, "O6_1C-ELIG-003") with input as inp
}

test_minimum_farm_size_first_year if {
	inp := patched([
		{"op": "replace", "path": "/farm/oepul/first_participation_year", "value": 2026},
		{"op": "replace", "path": "/land/total_area_ha", "value": 1.2},
	])
	has_rule(o6_1c.access_violations, "O6_1C-ELIG-004") with input as inp
	inp_ga := json.patch(inp, [{"op": "replace", "path": "/land/protected_cultivation_area_ha", "value": 0.5}])
	not has_rule(o6_1c.access_violations, "O6_1C-ELIG-004") with input as inp_ga
}

test_minimum_farm_size_not_required_after_first_year if {
	inp := replace("/land/total_area_ha", 1.2)
	not has_rule(o6_1c.access_violations, "O6_1C-ELIG-004") with input as inp
}

# --- Prämie -----------------------------------------------------------------

test_npa_capped_at_four_percent_of_arable_area if {
	inp := replace("/land/arable_area_ha", 20)
	d := o6_1c.decision with input as inp
	approx(d.npa_area_cap_ha, 0.8)
	approx(d.npa_eligible_area_ha, 0.8)
}

test_gloez4_part_not_eligible if {
	inp := replace("/land/parcels/0/o6_1c/npa/gloez4_buffer_area_ha", 0.3)
	approx(o6_1c.npa_eligible_area_ha, 1.3) with input as inp
}

test_modulation_example_220_ha if {
	f := o6_1c.modulation_factor(220)
	approx(f, 218 / 220)
	approx(o6_1c.modulation_factor(150), 1)
	approx(o6_1c.modulation_factor(1200), (((200 + (100 * 0.9)) + (700 * 0.85)) + (200 * 0.75)) / 1200)
}

test_modulated_premium if {
	inp := replace("/land/total_area_ha", 220)
	d := o6_1c.decision with input as inp
	approx(d.premium_band.min_eur, 740 * (218 / 220))
}

test_not_counted_towards_area_payment_cap if {
	o6_1c.counts_towards_area_payment_cap == false with input as base_input
}

test_payment_deadline_and_advance if {
	o6_1c.payment_deadline == "2027-06-30" with input as base_input
	approx(o6_1c.max_advance_payment_eur, 555) with input as base_input
}

test_small_payment_may_be_waived if {
	inp := patched([
		{"op": "replace", "path": "/farm/oepul/o6_1c/categories", "value": ["npa"]},
		{"op": "replace", "path": "/land/parcels/0/area_ha", "value": 0.05},
		{"op": "replace", "path": "/land/parcels/1/area_ha", "value": 0.05},
	])
	o6_1c.payment_may_be_waived with input as inp
	not o6_1c.payment_may_be_waived with input as base_input
}

# --- Sanktionen / höhere Gewalt --------------------------------------------

test_sanction_cumulation_and_repeat_escalation if {
	inp := replace("/farm/oepul/o6_1c/findings", [{"stage": 3, "repeat_index": 1}, {"stage": 2, "repeat_index": 2}])
	o6_1c.sanction_percent_total == 10 with input as inp
}

test_warning_becomes_one_percent_from_2027 if {
	o6_1c.stage_percent(1, 2026) == 0
	o6_1c.stage_percent(1, 2027) == 1
}

test_sanction_capped_at_100_percent if {
	inp := replace("/farm/oepul/o6_1c/findings", [{"stage": 7, "repeat_index": 1}, {"stage": 6, "repeat_index": 1}])
	o6_1c.sanction_percent_total == 100 with input as inp
}

test_two_full_cuts_exclude_from_measure if {
	inp := patched([
		{"op": "add", "path": "/farm/oepul/o6_1c/full_cuts_in_period", "value": 1},
		{"op": "replace", "path": "/farm/oepul/o6_1c/findings", "value": [{"stage": 7, "repeat_index": 1}]},
	])
	o6_1c.excluded_from_measure with input as inp
	not o6_1c.excluded_from_measure with input as base_input
}

test_overdeclaration_sanction if {
	approx(o6_1c.sanctioned_area_basis_ha(10, 9), 7.5)
	approx(o6_1c.sanctioned_area_basis_ha(10, 9.8), 9.8)
	approx(o6_1c.sanctioned_area_basis_ha(9, 10), 9)
}

test_force_majeure_three_weeks if {
	o6_1c.force_majeure_claim_timely({"able_to_notify_date": "2026-07-01", "notification_date": "2026-07-21"})
	not o6_1c.force_majeure_claim_timely({"able_to_notify_date": "2026-07-01", "notification_date": "2026-07-26"})
	o6_1c.force_majeure_case_listed(5)
}

test_control_refusal_rejects_application if {
	inp := patched([{"op": "add", "path": "/farm/oepul/o6_1c/on_site_control_refused", "value": true}])
	o6_1c.application_rejected_for_control_refusal with input as inp
}

test_field_list_deadline_15_april if {
	inp := patched([{"op": "add", "path": "/farm/oepul/o6_1c/field_list_submission_date", "value": "2026-04-16"}])
	has_rule(o6_1c.application_violations, "O6_1C-APP-006") with input as inp
	ok := patched([{"op": "add", "path": "/farm/oepul/o6_1c/field_list_submission_date", "value": "2026-04-15"}])
	not has_rule(o6_1c.application_violations, "O6_1C-APP-006") with input as ok
}

test_reduction_order_complete if {
	count(o6_1c.reduction_order) == 11
	o6_1c.reduction_order[0] == "Kürzungen und Sanktionen bei Übererklärungen von Flächen gemäß Punkt 1.12.1.2"
}
