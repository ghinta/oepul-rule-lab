package oepul.o6_14_test

import data.oepul.o6_14

# --- Praemie: 1 ha je RGVE (Beispiele Kapitel 7) ---------------------------------

premium_43 := mk_input(2026, [alm("A", 50)], [cattle("cows", "2019-01-01", 43, [stay("A", "2026-06-01", "2026-09-15")])])

premium_67 := mk_input(2026, [alm("A", 50)], [cattle("cows", "2019-01-01", 67, [stay("A", "2026-06-01", "2026-09-15")])])

test_premium_area_limited_by_rgve if {
	approx(o6_14.alm_premium_area_ha.A, 43) with input as premium_43
	approx(o6_14.alm_base_premium.A, 1857.6) with input as premium_43
}

test_premium_area_limited_by_alm_area if {
	approx(o6_14.alm_premium_area_ha.A, 50) with input as premium_67
}

test_base_rate_2023_level_3 if {
	o6_14.base_rate(3, 2023) == 80
}

test_base_rate_2026_level_2 if {
	o6_14.base_rate(2, 2026) == 64.8
}

test_premium_total_uses_modulation if {
	s := o6_14.premium_summary with input as premium_43
	approx(s.premium_total_eur, 1857.6)
	s.modulation_factor == 1
}

# --- Modulation -----------------------------------------------------------------

test_modulation_example_180_rgve_no_modulation if {
	inp := mk_input(2026, [alm("A", 150), alm("B", 100)], [
		cattle("a", "2019-01-01", 100, [stay("A", "2026-06-01", "2026-09-01")]),
		cattle("b", "2019-01-01", 80, [stay("B", "2026-06-01", "2026-09-01")]),
	])
	approx(o6_14.modulation_base_ha, 180) with input as inp
	o6_14.modulation_factor == 1 with input as inp
}

test_modulation_example_300_rgve if {
	inp := mk_input(2026, [alm("A", 150), alm("B", 100)], [
		cattle("a", "2019-01-01", 180, [stay("A", "2026-06-01", "2026-09-01")]),
		cattle("b", "2019-01-01", 120, [stay("B", "2026-06-01", "2026-09-01")]),
	])
	approx(o6_14.modulation_base_ha, 250) with input as inp
	approx(o6_14.modulation_factor, 0.98) with input as inp
}

test_modulation_220_ha_general_example if {
	approx(o6_14.modulation_factor_for(220), 0.9909)
}

test_modulation_higher_tiers if {
	approx(o6_14.modulation_factor_for(1100), (((200 + (100 * 0.9)) + (700 * 0.85)) + (100 * 0.75)) / 1100)
}

test_payout_below_50_may_be_withheld if {
	inp := mk_input(2026, [alm("A", 3)], [cattle("c", "2019-01-01", 1, [stay("A", "2026-06-01", "2026-09-01")])])
	o6_14.payout_may_be_withheld with input as inp
}

test_kalkalpen_no_premium if {
	a := object.union(alm("A", 50), {"national_park": "kalkalpen"})
	inp := mk_input(2026, [a], [cattle("cows", "2019-01-01", 43, [stay("A", "2026-06-01", "2026-09-15")])])
	o6_14.alm_premium_area_ha.A == 0 with input as inp
}

test_other_national_park_premium_possible if {
	a := object.union(alm("A", 50), {"national_park": "other"})
	inp := mk_input(2026, [a], [cattle("cows", "2019-01-01", 43, [stay("A", "2026-06-01", "2026-09-15")])])
	approx(o6_14.alm_premium_area_ha.A, 43) with input as inp
}

test_alm_managed_from_home_farm_not_alm if {
	a := object.union(alm("A", 50), {"managed_from_home_farm": true})
	inp := mk_input(2026, [a], [cattle("cows", "2019-01-01", 43, [stay("A", "2026-06-01", "2026-09-15")])])
	o6_14.alm_premium_area_ha.A == 0 with input as inp
}

test_cap_general_2025 if {
	o6_14.area_payment_cap("general", 2025) == 1300
}

# --- Erschliessungszustand --------------------------------------------------------

test_access_level_averaged_example if {
	a := object.union(alm("A", 20), {"access_times_comparable": true, "access_units": [
		{"unit_id": "Niederalm", "access_level": 1, "alp_days": 3750, "drive_period_days": 130},
		{"unit_id": "Hochalm", "access_level": 3, "alp_days": 4800, "drive_period_days": 80},
	]})
	o6_14.effective_access_level(a) == 2
}

test_access_level_longest_drive_period if {
	a := object.union(alm("A", 20), {"access_times_comparable": false, "access_units": [
		{"unit_id": "Grundalm", "access_level": 1, "alp_days": 200, "drive_period_days": 5},
		{"unit_id": "Hochalm", "access_level": 3, "alp_days": 5000, "drive_period_days": 90},
	]})
	o6_14.effective_access_level(a) == 3
}

# --- Teilnahme, Vertrag, Fristen -----------------------------------------------------

test_contract_period_start_2024 if {
	inp := with_af(premium_43, {"measure": {"applied": true, "application_date": "2023-11-30", "commitment_start_year": 2024}})
	o6_14.contract_duration_years == 5 with input as inp
	o6_14.contract_end_date == "2028-12-31" with input as inp
}

test_late_measure_application_no_contract if {
	inp := with_af(premium_43, {"measure": {"applied": true, "application_date": "2025-01-05", "commitment_start_year": 2025}})
	not o6_14.valid_contract with input as inp
	o6_14.premium_total == 0 with input as inp
}

test_entry_2026_not_possible if {
	inp := with_af(premium_43, {"measure": {"applied": true, "application_date": "2025-12-01", "commitment_start_year": 2026}})
	not o6_14.valid_contract with input as inp
}

test_takeover_until_15_july if {
	inp := with_af(premium_43, {"measure": {"applied": false}, "takeover": {"is_takeover": true, "submission_date": "2026-07-15", "previously_participating": false, "expansion_share": 0.2, "approved_by_ama": true}})
	o6_14.valid_contract with input as inp
}

test_takeover_17_july_2028 if {
	d := o6_14.deadline_date("measure_takeover", 2028)
	d == "2028-07-17"
}

test_minimum_participation_first_year_not_met if {
	inp := mk_input(2025, [alm("A", 2.5)], [cattle("c", "2019-01-01", 5, [stay("A", "2025-06-01", "2025-09-01")])])
	inp2 := with_af(inp, {"measure": {"applied": true, "application_date": "2024-12-01", "commitment_start_year": 2025}})
	v := o6_14.access_violations with input as inp2
	some x in v
	x.rule_id == "O614-ACCESS-001"
	o6_14.access_consequence == "no_contract" with input as inp2
}

test_minimum_participation_multiple_alms_ok if {
	inp := mk_input(2025, [alm("A", 1.5), alm("B", 1.5)], [
		cattle("c", "2019-01-01", 2, [stay("A", "2025-06-01", "2025-09-01")]),
		cattle("d", "2019-01-01", 1, [stay("B", "2025-06-01", "2025-09-01")]),
	])
	inp2 := with_af(inp, {"measure": {"applied": true, "application_date": "2024-12-01", "commitment_start_year": 2025}})
	o6_14.minimum_participation_met with input as inp2
}

test_later_year_below_minimum_ok if {
	inp := mk_input(2026, [alm("A", 2.5)], [cattle("c", "2019-01-01", 2, [stay("A", "2026-06-01", "2026-09-01")])])
	o6_14.access_conditions_met with input as inp
}

test_public_body_over_25_pct_excluded if {
	inp := object.union(premium_43, {"farm": object.union(premium_43.farm, {"applicant": {"legal_form": "legal_person", "public_body_share_pct": 30, "is_active_farmer": true}})})
	not o6_14.applicant_type_eligible with input as inp
}

test_not_alm_manager_access_violation if {
	inp := with_af(premium_43, {"is_alm_manager": false})
	v := o6_14.access_violations with input as inp
	some x in v
	x.rule_id == "O614-SCOPE-002"
}

test_field_list_late if {
	a := object.union(alm("A", 50), {"field_list_submission_date": "2026-04-16"})
	inp := mk_input(2026, [a], [])
	v := o6_14.deadline_violations with input as inp
	some x in v
	x.rule_id == "O614-APPL-004"
}

test_field_list_17_april_2028_ok if {
	a := object.union(alm("A", 50), {"field_list_submission_date": "2028-04-17", "drive_up_list_submission_date": "2028-07-01"})
	inp := mk_input(2028, [a], [])
	v := o6_14.deadline_violations with input as inp
	count([x | some x in v; x.rule_id == "O614-APPL-004"]) == 0
}

test_cattle_only_level1_no_drive_up_list_needed if {
	a := object.remove(alm("A", 50), ["drive_up_list_submission_date"])
	inp := mk_input(2026, [a], [cattle("cows", "2019-01-01", 43, [stay("A", "2026-06-01", "2026-09-15")])])
	v := o6_14.deadline_violations with input as inp
	count([x | some x in v; x.rule_id == "O614-APPL-005"]) == 0
}

test_sheep_alm_requires_drive_up_list if {
	a := object.remove(alm("A", 50), ["drive_up_list_submission_date"])
	inp := mk_input(2026, [a], [sheep("s", "2020-01-01", 20, [stay("A", "2026-06-01", "2026-09-15")])])
	v := o6_14.deadline_violations with input as inp
	some x in v
	x.rule_id == "O614-APPL-005"
}

test_cattle_only_with_behirtung_requires_list if {
	a := object.remove(alm("A", 50), ["drive_up_list_submission_date"])
	base := mk_input(2026, [a], [cattle("cows", "2019-01-01", 43, [stay("A", "2026-06-01", "2026-09-15")])])
	inp := object.union(base, {"farm": object.union(base.farm, {"oepul": {"first_oepul_year": 2023, "participating_measures": ["tierwohl_behirtung"]}})})
	v := o6_14.deadline_violations with input as inp
	some x in v
	x.rule_id == "O614-APPL-005"
}

test_drive_up_list_late if {
	a := object.union(alm("A", 50), {"drive_up_list_submission_date": "2026-07-16"})
	inp := mk_input(2026, [a], [sheep("s", "2020-01-01", 20, [stay("A", "2026-06-01", "2026-09-15")])])
	v := o6_14.deadline_violations with input as inp
	some x in v
	x.rule_id == "O614-APPL-005"
}
