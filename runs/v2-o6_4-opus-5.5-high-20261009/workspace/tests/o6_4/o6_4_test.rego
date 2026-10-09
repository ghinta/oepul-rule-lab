package oepul.o6_4_test

import rego.v1

import data.oepul.o6_4

# Basisfall: Tiroler Betrieb, 2026, zwei Bergmahdschläge, Vertragsbeginn 2024
base_parcel := {
	"parcel_id": "BM-1",
	"area_ha": 2.0,
	"land_use": "grassland",
	"mountain_meadow": {
		"enrolled_in_o6_4": true,
		"declared_as_bergmaehder": true,
		"above_permanent_settlement_limit": true,
		"share_above_1200m_percent": 80,
		"above_home_farm_elevation": true,
		"adjacent_to_home_farm_land": false,
		"declared_mowing_code": "BM2",
		"full_mowing_years": [2024],
	},
	"operations": {
		"mowing_events": [{"date": "2026-07-20", "full_area": true, "cut_material_removed": true, "mulched": false, "method": "hand_motor_mower"}],
		"grazing_events": [{"start_date": "2026-08-20", "end_date": "2026-09-15"}],
		"fertilizer_applications": [{"date": "2026-05-02", "type": "solid_manure", "demand_based": true}],
		"psm_applications": [],
	},
	"oepul": {"premium_measures": [], "codes": []},
}

base_input := {
	"farm": {
		"year": 2026,
		"region": {"federal_state": "Tirol", "district": "Landeck"},
		"is_alm_operation": false,
		"applicant": {
			"legal_form": "natural_person",
			"is_active_farmer": true,
			"manages_in_own_name_and_account": true,
			"has_disposal_over_areas": true,
		},
	},
	"land": {"total_area_ha": 25.0, "parcels": [base_parcel]},
	"oepul": {
		"first_participation_year": 2023,
		"participating_measures": ["4"],
		"o6_4": {
			"application_date": "2023-11-20",
			"contract_start_date": "2024-01-01",
			"area_2025_ha": 2.0,
			"area_previous_year_ha": 2.0,
			"area_current_year_ha": 2.0,
		},
	},
}

with_parcel(changes) := object.union(base_input, {"land": {"total_area_ha": 25.0, "parcels": [object.union(base_parcel, changes)]}})

with_measure(changes) := object.union(base_input, {"oepul": {"o6_4": object.union(base_input.oepul.o6_4, changes)}})

# --- Teilnahmefähige Flächen ---------------------------------------------------

test_base_parcel_is_bergmahd if {
	o6_4.parcel_is_bergmahd["BM-1"] with input as base_input
}

test_share_exactly_50_percent_not_eligible if {
	inp := with_parcel({"mountain_meadow": object.union(base_parcel.mountain_meadow, {"share_above_1200m_percent": 50})})
	some f in o6_4.parcel_failures["BM-1"] with input as inp
	f.rule_id == "O64-ELIG-003"
	not o6_4.parcel_is_bergmahd["BM-1"] with input as inp
}

test_share_above_50_percent_eligible if {
	inp := with_parcel({"mountain_meadow": object.union(base_parcel.mountain_meadow, {"share_above_1200m_percent": 50.5})})
	o6_4.parcel_is_bergmahd["BM-1"] with input as inp
}

test_below_settlement_limit_not_eligible if {
	inp := with_parcel({"mountain_meadow": object.union(base_parcel.mountain_meadow, {"above_permanent_settlement_limit": false})})
	some f in o6_4.parcel_failures["BM-1"] with input as inp
	f.rule_id == "O64-ELIG-002"
}

test_not_declared_as_bergmaehder_not_eligible if {
	inp := with_parcel({"mountain_meadow": object.union(base_parcel.mountain_meadow, {"declared_as_bergmaehder": false})})
	some f in o6_4.parcel_failures["BM-1"] with input as inp
	f.rule_id == "O64-ELIG-001"
}

test_below_home_farm_not_eligible_for_regular_farm if {
	inp := with_parcel({"mountain_meadow": object.union(base_parcel.mountain_meadow, {"above_home_farm_elevation": false})})
	some f in o6_4.parcel_failures["BM-1"] with input as inp
	f.rule_id == "O64-ELIG-004"
}

test_alm_operation_may_lie_below_alm_site if {
	p := with_parcel({"mountain_meadow": object.union(base_parcel.mountain_meadow, {"above_home_farm_elevation": false})})
	inp := object.union(p, {"farm": object.union(base_input.farm, {"is_alm_operation": true})})
	o6_4.parcel_is_bergmahd["BM-1"] with input as inp
}

test_adjacent_to_home_farm_only_warning if {
	inp := with_parcel({"mountain_meadow": object.union(base_parcel.mountain_meadow, {"adjacent_to_home_farm_land": true})})
	some w in o6_4.parcel_warnings["BM-1"] with input as inp
	w.rule_id == "O64-ELIG-005"
	o6_4.parcel_is_bergmahd["BM-1"] with input as inp
}

test_missing_elevation_share_reported if {
	mm := object.remove(base_parcel.mountain_meadow, ["share_above_1200m_percent"])
	inp := object.union(base_input, {"land": {"total_area_ha": 25.0, "parcels": [object.union(object.remove(base_parcel, ["mountain_meadow"]), {"mountain_meadow": mm})]}})
	"share_above_1200m_percent" in o6_4.parcel_missing["BM-1"] with input as inp
	not o6_4.parcel_is_bergmahd["BM-1"] with input as inp
}

test_no_minimum_area_and_no_combination_obligation if {
	o6_4.minimum_participation_area_ha == null
	o6_4.combination_obligation == false
	o6_4.all_bergmaehder_required == false
}

test_parcel_below_50_m2_no_premium if {
	inp := with_parcel({"area_ha": 0.004})
	some f in o6_4.parcel_premium_exclusions["BM-1"] with input as inp
	f.rule_id == "O64-ELIG-010"
	o6_4.net_premium_total == 0 with input as inp
}

# --- Förderwerbende Person / Betrieb ------------------------------------------

test_public_body_not_eligible if {
	inp := object.union(base_input, {"farm": object.union(base_input.farm, {"applicant": object.union(base_input.farm.applicant, {"legal_form": "public_body"})})})
	some f in o6_4.applicant_failures with input as inp
	f.rule_id == "O64-GEN-002"
}

test_legal_person_public_share_over_25_not_eligible if {
	app := object.union(base_input.farm.applicant, {"legal_form": "legal_person", "public_body_share_percent": 30})
	inp := object.union(base_input, {"farm": object.union(base_input.farm, {"applicant": app})})
	some f in o6_4.applicant_failures with input as inp
	f.rule_id == "O64-GEN-002"
}

test_legal_person_public_share_25_eligible if {
	app := object.union(base_input.farm.applicant, {"legal_form": "legal_person", "public_body_share_percent": 25})
	inp := object.union(base_input, {"farm": object.union(base_input.farm, {"applicant": app})})
	o6_4.applicant_eligible with input as inp
}

test_minimum_farm_size_first_year_only if {
	small := object.union(base_input, {"land": {"total_area_ha": 1.2, "parcels": [base_parcel]}, "oepul": object.union(base_input.oepul, {"first_participation_year": 2026})})
	some f in o6_4.applicant_failures with input as small
	f.rule_id == "O64-GEN-004"
	later := object.union(small, {"oepul": object.union(base_input.oepul, {"first_participation_year": 2024})})
	o6_4.applicant_eligible with input as later
}

# --- Förderbedingungen ---------------------------------------------------------

test_base_has_no_violations if {
	count(o6_4.effective_violations) == 0 with input as base_input
}

test_two_mowings_violation if {
	ev := [
		{"date": "2026-07-01", "full_area": true, "cut_material_removed": true, "mulched": false, "method": "hand_motor_mower"},
		{"date": "2026-09-01", "full_area": true, "cut_material_removed": true, "mulched": false, "method": "hand_motor_mower"},
	]
	inp := with_parcel({"operations": object.union(base_parcel.operations, {"mowing_events": ev})})
	some v in o6_4.violations with input as inp
	v.rule_id == "O64-OBL-002"
}

test_mulching_violation if {
	ev := [{"date": "2026-07-01", "full_area": true, "cut_material_removed": false, "mulched": true, "method": "tractor"}]
	inp := with_parcel({"operations": object.union(base_parcel.operations, {"mowing_events": ev})})
	some v in o6_4.violations with input as inp
	v.rule_id == "O64-OBL-003"
}

test_cut_left_on_field_violation_and_no_premium if {
	ev := [{"date": "2026-07-01", "full_area": true, "cut_material_removed": false, "mulched": false, "method": "tractor"}]
	inp := with_parcel({"operations": object.union(base_parcel.operations, {"mowing_events": ev})})
	some v in o6_4.violations with input as inp
	v.rule_id == "O64-OBL-003"
	o6_4.expected_mowing_code["BM-1"] == "BM0" with input as inp
	o6_4.net_premium_total == 0 with input as inp
}

test_no_mowing_two_consecutive_years_violation if {
	mm := object.union(base_parcel.mountain_meadow, {"full_mowing_years": [2024], "declared_mowing_code": "BM0"})
	inp := object.union(with_parcel({"mountain_meadow": mm, "operations": object.union(base_parcel.operations, {"mowing_events": []})}), {"farm": object.union(base_input.farm, {"year": 2026})})
	some v in o6_4.violations with input as inp
	v.rule_id == "O64-OBL-001"
}

test_no_mowing_one_year_allowed if {
	mm := object.union(base_parcel.mountain_meadow, {"full_mowing_years": [2024, 2025], "declared_mowing_code": "BM0"})
	inp := with_parcel({"mountain_meadow": mm, "operations": object.union(base_parcel.operations, {"mowing_events": []})})
	count(o6_4.effective_violations) == 0 with input as inp
	o6_4.expected_mowing_code["BM-1"] == "BM0" with input as inp
	o6_4.net_premium_total == 0 with input as inp
}

test_grazing_before_16_august_violation if {
	ops := object.union(base_parcel.operations, {"grazing_events": [{"start_date": "2026-08-15", "end_date": "2026-09-01"}]})
	inp := with_parcel({"operations": ops})
	some v in o6_4.violations with input as inp
	v.rule_id == "O64-OBL-004"
}

test_post_grazing_from_16_august_allowed_in_bm0_year if {
	mm := object.union(base_parcel.mountain_meadow, {"full_mowing_years": [2025], "declared_mowing_code": "BM0"})
	ops := object.union(base_parcel.operations, {"mowing_events": [], "grazing_events": [{"start_date": "2026-08-16", "end_date": "2026-09-30"}]})
	inp := with_parcel({"mountain_meadow": mm, "operations": ops})
	count(o6_4.effective_violations) == 0 with input as inp
	o6_4.post_grazing_allowed("2026-08-16")
	not o6_4.post_grazing_allowed("2026-08-15")
}

test_slurry_and_lime_violations if {
	ops := object.union(base_parcel.operations, {"fertilizer_applications": [
		{"date": "2026-04-20", "type": "slurry"},
		{"date": "2026-04-21", "type": "lime"},
	]})
	inp := with_parcel({"operations": ops})
	ids := {v.rule_id | some v in o6_4.violations with input as inp}
	"O64-OBL-006" in ids
	"O64-OBL-008" in ids
}

test_dissolved_solid_manure_violation if {
	ops := object.union(base_parcel.operations, {"fertilizer_applications": [{"date": "2026-04-20", "type": "solid_manure_dissolved"}]})
	inp := with_parcel({"operations": ops})
	some v in o6_4.violations with input as inp
	v.rule_id == "O64-OBL-007"
}

test_sewage_sludge_violation_even_in_bm0_year if {
	mm := object.union(base_parcel.mountain_meadow, {"full_mowing_years": [2025], "declared_mowing_code": "BM0"})
	ops := object.union(base_parcel.operations, {"mowing_events": [], "fertilizer_applications": [{"date": "2026-04-20", "type": "composted_sewage_sludge"}]})
	inp := with_parcel({"mountain_meadow": mm, "operations": ops})
	some v in o6_4.violations with input as inp
	v.rule_id == "O64-OBL-006"
}

test_household_wastewater_allowed if {
	ops := object.union(base_parcel.operations, {"fertilizer_applications": [{"date": "2026-04-20", "type": "own_household_wastewater"}]})
	inp := with_parcel({"operations": ops})
	count(o6_4.effective_violations) == 0 with input as inp
}

test_psm_non_bio_violation_bio_allowed if {
	bad := with_parcel({"operations": object.union(base_parcel.operations, {"psm_applications": [{"date": "2026-06-01", "product": "X", "only_eu_2018_848_substances": false}]})})
	some v in o6_4.violations with input as bad
	v.rule_id == "O64-OBL-010"
	ok := with_parcel({"operations": object.union(base_parcel.operations, {"psm_applications": [{"date": "2026-06-01", "product": "Y", "only_eu_2018_848_substances": true}]})})
	count(o6_4.effective_violations) == 0 with input as ok
}

# --- Codierung -----------------------------------------------------------------

test_motor_mower_with_scythe_touchup_is_bm2 if {
	o6_4.expected_mowing_code["BM-1"] == "BM2" with input as base_input
}

test_mower_transporter_is_bm1 if {
	ev := [{"date": "2026-07-20", "full_area": true, "cut_material_removed": true, "mulched": false, "method": "mower_transporter"}]
	inp := with_parcel({"operations": object.union(base_parcel.operations, {"mowing_events": ev}), "mountain_meadow": object.union(base_parcel.mountain_meadow, {"declared_mowing_code": "BM1"})})
	o6_4.expected_mowing_code["BM-1"] == "BM1" with input as inp
	count(o6_4.effective_violations) == 0 with input as inp
}

test_flat_area_scythe_is_bm3 if {
	ev := [{"date": "2026-07-20", "full_area": true, "cut_material_removed": true, "mulched": false, "method": "scythe"}]
	inp := with_parcel({"operations": object.union(base_parcel.operations, {"mowing_events": ev}), "mountain_meadow": object.union(base_parcel.mountain_meadow, {"declared_mowing_code": "BM3"})})
	o6_4.expected_mowing_code["BM-1"] == "BM3" with input as inp
}

test_wrong_code_violation if {
	inp := with_parcel({"mountain_meadow": object.union(base_parcel.mountain_meadow, {"declared_mowing_code": "BM3"})})
	some v in o6_4.violations with input as inp
	v.rule_id == "O64-COD-002"
}

test_mowing_but_bm0_declared_violation if {
	inp := with_parcel({"mountain_meadow": object.union(base_parcel.mountain_meadow, {"declared_mowing_code": "BM0"})})
	some v in o6_4.violations with input as inp
	v.rule_id == "O64-COD-002"
}

# --- Prämie --------------------------------------------------------------------

test_rates if {
	o6_4.premium_rate("BM1", 2023) == 350.0
	o6_4.premium_rate("BM1", 2026) == 378.0
	o6_4.premium_rate("BM2", 2023) == 550.0
	o6_4.premium_rate("BM2", 2024) == 594.0
	o6_4.premium_rate("BM3", 2023) == 900.0
	o6_4.premium_rate("BM3", 2028) == 972.0
	o6_4.premium_rate("BM0", 2026) == 0.0
}

test_base_premium_bm2 if {
	o6_4.gross_premium["BM-1"] == 1188 with input as base_input
	o6_4.net_premium_total == 1188 with input as base_input
}

test_combination_with_other_measure_blocks_premium if {
	inp := with_parcel({"oepul": {"premium_measures": ["3"], "codes": []}})
	"3" in o6_4.combination_conflicts["BM-1"] with input as inp
	o6_4.net_premium_total == 0 with input as inp
}

test_landscape_elements_combinable_with_ubb if {
	inp0 := with_parcel({"oepul": {"premium_measures": [], "codes": [], "point_landscape_elements": [{"element": "other", "count": 3}]}})
	inp := object.union(inp0, {"oepul": object.union(inp0.oepul, {"participating_measures": ["1A", "4"]})})
	count(object.get(o6_4.combination_conflicts, "BM-1", set())) == 0 with input as inp
	abs(o6_4.le_premium["BM-1"] - 25.8) < 0.0001 with input as inp
	o6_4.net_premium_total == 1188 with input as inp
}

test_area_payment_cap_with_many_streuobst_trees if {
	mm := object.union(base_parcel.mountain_meadow, {"declared_mowing_code": "BM3"})
	ev := [{"date": "2026-07-20", "full_area": true, "cut_material_removed": true, "mulched": false, "method": "scythe"}]
	inp0 := with_parcel({"area_ha": 1.0, "mountain_meadow": mm, "operations": object.union(base_parcel.operations, {"mowing_events": ev}), "oepul": {"premium_measures": [], "codes": [], "point_landscape_elements": [{"element": "streuobst", "count": 80}]}})
	inp := object.union(inp0, {"oepul": object.union(inp0.oepul, {"participating_measures": ["1B", "4"]})})

	# 972 + 80 * 13 = 2012 > 1300 €/ha -> o6_4-Anteil auf 260 € gekürzt
	o6_4.net_premium["BM-1"] == 260 with input as inp
}

test_op_code_blocks_premium if {
	inp := with_parcel({"oepul": {"premium_measures": [], "codes": ["OP"]}})
	o6_4.net_premium_total == 0 with input as inp
}

test_national_park_neusiedlersee_blocks_premium if {
	inp := with_parcel({"oepul": {"premium_measures": [], "codes": [], "national_park": "neusiedlersee"}})
	o6_4.net_premium_total == 0 with input as inp
}

test_national_park_kalkalpen_premium_possible if {
	inp := with_parcel({"oepul": {"premium_measures": [], "codes": [], "national_park": "kalkalpen"}})
	o6_4.net_premium_total == 1188 with input as inp
}

test_modulation_220_ha if {
	inp := object.union(base_input, {"land": {"total_area_ha": 220.0, "parcels": [base_parcel]}})
	f := o6_4.modulation_factor with input as inp
	abs(f - 0.990909) < 0.00001
}

test_modulation_bands if {
	inp := object.union(base_input, {"land": {"total_area_ha": 1100.0, "parcels": [base_parcel]}})

	# 200*1 + 100*0.9 + 700*0.85 + 100*0.75 = 960 -> 960/1100
	f := o6_4.modulation_factor with input as inp
	abs(f - (960 / 1100)) < 0.00001
}

test_content_sanction_escalation if {
	inp := with_measure({"assessed_findings": [{"level": 2, "prior_occurrences_same_obligation": 1}]})

	# Stufe 2 (5 %) + Wiederholung -> Stufe 3 (10 %)
	o6_4.content_reduction_percent == 10 with input as inp
	o6_4.net_premium_total == 1069.2 with input as inp
}

test_warning_becomes_one_percent_from_2027 if {
	inp := object.union(with_measure({"assessed_findings": [{"level": 0}]}), {"farm": object.union(base_input.farm, {"year": 2027})})
	o6_4.content_reduction_percent == 1 with input as inp
	inp26 := with_measure({"assessed_findings": [{"level": 0}]})
	o6_4.content_reduction_percent == 0 with input as inp26
}

test_cumulated_sanctions_capped_100 if {
	inp := with_measure({"assessed_findings": [{"level": 6}, {"level": 5}]})
	o6_4.content_reduction_percent == 100 with input as inp
}

test_exclusion_after_two_full_reductions if {
	inp := with_measure({"full_reductions_in_period": 2})
	o6_4.excluded_from_measure with input as inp
	o6_4.net_premium_total == 0 with input as inp
}

test_area_increase_cap_2026 if {
	p2 := object.union(base_parcel, {"parcel_id": "BM-2", "area_ha": 8.0})
	inp0 := object.union(base_input, {"land": {"total_area_ha": 25.0, "parcels": [base_parcel, p2]}})
	inp := object.union(inp0, {"oepul": object.union(base_input.oepul, {"o6_4": object.union(base_input.oepul.o6_4, {"area_2025_ha": 2.0})})})

	# Grenze 2 + max(1, 5) = 7 ha bei 10 ha prämienfähiger Fläche
	o6_4.area_increase_limit_ha == 7 with input as inp
	o6_4.access_factor == 0.7 with input as inp
}

test_area_increase_fully_eligible_2025 if {
	ops := object.union(base_parcel.operations, {"mowing_events": [{"date": "2025-07-20", "full_area": true, "cut_material_removed": true, "mulched": false, "method": "hand_motor_mower"}]})
	p1 := object.union(base_parcel, {"operations": ops})
	p2 := object.union(p1, {"parcel_id": "BM-2", "area_ha": 8.0})
	inp := object.union(base_input, {"farm": object.union(base_input.farm, {"year": 2025}), "land": {"total_area_ha": 25.0, "parcels": [p1, p2]}})
	o6_4.access_factor == 1 with input as inp

	# 10 ha * 594 €/ha ohne Zugangskürzung
	o6_4.net_premium_total == 5940 with input as inp
}

test_minimum_payment_waiver if {
	small := object.union(base_parcel, {"area_ha": 0.05})
	inp := object.union(base_input, {"land": {"total_area_ha": 25.0, "parcels": [small]}})
	o6_4.payment_may_be_waived with input as inp
}

# --- Antrag, Vertrag, Ausstieg, Flächenänderungen ------------------------------

test_contract_period_2024 if {
	o6_4.contract_period.duration_years == 5 with input as base_input
	o6_4.contract_active with input as base_input
}

test_late_application_no_contract if {
	inp := with_measure({"application_date": "2024-01-02"})
	some f in o6_4.contract_failures with input as inp
	f.rule_id == "O64-APP-001"
	not o6_4.contract_active with input as inp
}

test_entry_2026_not_possible if {
	inp := with_measure({"application_date": "2025-12-01", "contract_start_date": "2026-01-01"})
	ids := {f.rule_id | some f in o6_4.contract_failures with input as inp}
	"O64-APP-002" in ids
}

test_conversion_to_naturschutz_until_2025 if {
	ok := with_measure({"conversion": {"target_measure_number": "18", "contract_change_date": "2025-12-31", "parcel_ids": ["BM-1"]}})
	o6_4.conversion_valid with input as ok
	"BM-1" in o6_4.converted_parcels with input as ok
	late := with_measure({"conversion": {"target_measure_number": "19", "contract_change_date": "2026-12-31", "parcel_ids": ["BM-1"]}})
	not o6_4.conversion_valid with input as late
	wrong := with_measure({"conversion": {"target_measure_number": "1B", "contract_change_date": "2025-06-30", "parcel_ids": ["BM-1"]}})
	not o6_4.conversion_valid with input as wrong
}

test_exit_requires_repayment_and_blocks_year if {
	inp := with_measure({"exit_date": "2026-03-01"})
	o6_4.exit_repayment_required with input as inp
	o6_4.net_premium_total == 0 with input as inp
}

test_exit_after_control_announcement_blocked if {
	inp := with_measure({"exit_date": "2026-06-01", "control_announced_or_notified_date": "2026-05-20"})
	o6_4.exit_blocked_by_control with input as inp
}

test_area_decrease_within_tolerance if {
	inp := with_measure({"area_previous_year_ha": 8.0, "area_current_year_ha": 7.6})

	# 5 % von 8 ha = 0,4 ha, aber jedenfalls 0,5 ha zulässig
	o6_4.area_decrease_tolerance_ha == 0.5 with input as inp
	not o6_4.area_decrease_repayment_ha > 0 with input as inp
}

test_area_decrease_over_tolerance_repayment if {
	inp := with_measure({"area_previous_year_ha": 200.0, "area_current_year_ha": 190.0})

	# Toleranz min(10 ha, 5 ha) = 5 ha -> 10 ha Rückzahlung
	o6_4.area_decrease_repayment_ha == 10 with input as inp
}

test_area_decrease_by_loss_of_disposal_not_counted if {
	inp := with_measure({"area_previous_year_ha": 10.0, "area_current_year_ha": 6.0, "area_lost_disposal_ha": 4.0})
	o6_4.area_decrease_ha == 0 with input as inp
}

test_takeover_deadlines if {
	ok := with_measure({"takeover": {"date": "2028-04-17", "taker_previously_participating": false, "taken_over_area_ha": 2, "extension_area_ha": 1}})
	count(o6_4.takeover_failures) == 0 with input as ok
	late := with_measure({"takeover": {"date": "2026-04-16", "taker_previously_participating": false, "taken_over_area_ha": 2, "extension_area_ha": 1.5}})
	count(o6_4.takeover_failures) == 2 with input as late
}

test_force_majeure_timely_excuses_violation if {
	mm := object.union(base_parcel.mountain_meadow, {"full_mowing_years": [2024], "declared_mowing_code": "BM0"})
	p := with_parcel({"mountain_meadow": mm, "operations": object.union(base_parcel.operations, {"mowing_events": []})})
	claim := {"parcel_ids": ["BM-1"], "category": "eu_2021_2116_art3", "able_to_report_date": "2026-08-01", "reported_date": "2026-08-20", "documented": true}
	inp := object.union(p, {"oepul": object.union(p.oepul, {"force_majeure_claims": [claim]})})
	count(o6_4.effective_violations) == 0 with input as inp
	count(o6_4.excused_violations) == 1 with input as inp
}

test_force_majeure_late_not_recognized if {
	claim := {"parcel_ids": ["BM-1"], "able_to_report_date": "2026-08-01", "reported_date": "2026-08-23", "documented": true}
	not o6_4.fm_claim_recognized(claim)
}

test_over_declaration_sanction if {
	inp := with_measure({"declared_area_ha": 10.0, "determined_area_ha": 9.5})

	# Differenz 0,5 ha > 3 % von 9,5 ha (0,285 ha) -> 0,75 ha
	o6_4.over_declaration_sanction_ha == 0.75 with input as inp
}

test_control_refusal_blocks_premium if {
	inp := with_measure({"on_site_control_refused": true})
	o6_4.net_premium_total == 0 with input as inp
}

test_missing_payment_claim if {
	inp := with_measure({"payment_claim_submitted": false, "payment_claim_overdue_more_than_one_year": true})
	o6_4.payment_claim_obligation_ended with input as inp
	o6_4.net_premium_total == 0 with input as inp
}

test_no_2026_derogation_for_bergmaehder if {
	o6_4.notices_2026_o6_4_derogation == false
}

test_decision_object if {
	d := o6_4.decision with input as base_input
	d.measure == "o6_4"
	d.net_premium_eur == 1188
	d.parcels["BM-1"].effective_mowing_code == "BM2"
}
