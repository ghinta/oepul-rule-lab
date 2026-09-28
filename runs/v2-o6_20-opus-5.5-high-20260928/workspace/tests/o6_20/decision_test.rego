package oepul.o6_20.decision_test

import data.oepul.o6_20.decision
import data.oepul.o6_20.eligibility
import data.oepul.o6_20.premium
import data.oepul.o6_20.rgve

full_diary := {
	"maintained": true,
	"records_category_or_group": true,
	"records_location": true,
	"records_period_start_end_per_location": true,
	"records_daily_animal_interruption_reasons": true,
	"significant_changes_recorded_same_day": true,
}

cow(id, coupled) := {
	"animal_id": id,
	"category_code": "cattle_female_2y_plus",
	"rgve_class": "cattle_2y_plus",
	"coupled_alpine_support_applied": coupled,
}

ewe(id) := {
	"animal_id": id,
	"category_code": "sheep_female_1y_plus",
	"rgve_class": "sheep_1y_plus",
	"application_date": "2026-04-10",
	"ear_tag": sprintf("AT%s", [id]),
	"sex": "female",
	"birth_date": "2022-03-01",
}

base_input := {
	"farm": {
		"year": 2026,
		"applicant": {
			"legal_form": "natural_person",
			"is_active_farmer": true,
			"has_agricultural_activity": true,
			"farms_in_own_name_and_account": true,
		},
		"oepul_participation": {"first_oepul_year": 2023, "conditionality_compliant": true},
	},
	"land": {"total_area_ha": 30, "protected_cultivation_area_ha": 0},
	"oepul_measures": {"tierwohl_weide": {
		"participation_start_year": 2024,
		"grazing_diary": full_diary,
		"vis_reporting_complete": true,
		"equids_ueln_identified": true,
		"animal_list_complete": true,
		"categories": [
			{
				"category_code": "cattle_female_2y_plus",
				"supplement_150_applied": true,
				"supplement_150_application_date": "2026-04-10",
				"grazing_days_all_animals": 160,
				"days_with_min_one_animal_present": 214,
			},
			{
				"category_code": "sheep_female_1y_plus",
				"grazing_days_all_animals": 130,
				"birth_stall_days": 10,
				"individual_birth_documentation": false,
				"days_with_min_one_animal_present": 214,
			},
			{
				"category_code": "equids_6m_plus",
				"grazing_days_all_animals": 140,
				"days_with_min_one_animal_present": 214,
				"count_entries": [{"rgve_class": "equid_large_adult_3y_plus", "applied_count": 2, "compliant_count": 2}],
			},
		],
		"animals": array.concat(
			[cow("c1", true), cow("c2", false), cow("c3", false)],
			[ewe(sprintf("s%d", [i])) | some i in numbers.range(1, 10)],
		),
	}},
}

patched(ops) := json.patch(base_input, ops)

approx(a, b) if abs(a - b) < 0.0001

rule_hit(inp, rule_id) if {
	some v in decision.violations with input as inp
	v.rule_id == rule_id
}

# --- Grundfall ---------------------------------------------------------------

test_baseline_contract_valid_without_violations if {
	decision.result.contract_valid with input as base_input
	count(decision.violations) == 0 with input as base_input
}

test_baseline_total_rgve if {
	approx(rgve.total_rgve, 6.5) with input as base_input
}

test_baseline_premium_bands if {
	# Rinder: 2,0 RGVE x 40 + 1,0 RGVE (gekoppelte Stützung) x 20 + Zuschlag 3,0 x 16 = 148
	# Schafe: 1,5 x 40 = 60; Equiden: 2,0 x 40 = 80 -> 288 (Maximum 432)
	approx(premium.gross_min, 288) with input as base_input
	approx(premium.gross_max, 432) with input as base_input
	approx(premium.net_min, 288) with input as base_input
}

# --- RGVE-Beispiele aus dem Informationsblatt (Kap. 10) -----------------------

test_rgve_example_heifers_bought_10_april if {
	inp := patched([{"op": "replace", "path": "/oepul_measures/tierwohl_weide/animals", "value": [{"animal_id": sprintf("k%d", [i]), "category_code": "cattle_female_6m_to_2y", "rgve_class": "cattle_6m_to_2y", "present_from": "2026-04-10"} | some i in numbers.range(1, 5)]}])
	approx(rgve.animals_rgve("cattle_female_6m_to_2y"), 2.8738) with input as inp
}

test_rgve_example_sheep_reported_in_time if {
	a := {"animal_id": "s", "category_code": "sheep_female_1y_plus", "rgve_class": "sheep_1y_plus", "present_from": "2026-05-03", "arrival_report_date": "2026-05-07"}
	rgve.animal_days(a) == 182 with input as base_input
}

test_rgve_example_goats_late_report_counts_from_report_minus_7 if {
	a := {"animal_id": "g", "category_code": "goats_female_1y_plus", "rgve_class": "goats_1y_plus", "present_from": "2026-06-06", "arrival_report_date": "2026-06-23"}
	rgve.animal_days(a) == 138 with input as base_input
	rgve.animal_start(a) == "2026-06-16" with input as base_input
}

test_rgve_example_goat_died_on_alm if {
	a := {"animal_id": "g", "category_code": "goats_female_1y_plus", "rgve_class": "goats_1y_plus", "departure_date": "2026-07-14"}
	rgve.animal_days(a) == 104 with input as base_input
}

test_rgve_dwarf_cattle_factor if {
	rgve.factor("dwarf_cattle_2y_plus") == 0.5
	rgve.class_allowed("cattle_male_6m_plus", "dwarf_cattle_6m_to_2y")
	not rgve.class_allowed("cattle_female_2y_plus", "cattle_6m_to_2y")
}

# --- Mindestteilnahme ------------------------------------------------------------

test_min_participation_below_2_rgve_invalidates_contract if {
	inp := patched([
		{"op": "replace", "path": "/oepul_measures/tierwohl_weide/categories", "value": [{"category_code": "sheep_female_1y_plus", "grazing_days_all_animals": 150, "days_with_min_one_animal_present": 214}]},
		{"op": "replace", "path": "/oepul_measures/tierwohl_weide/animals", "value": [ewe(sprintf("s%d", [i])) | some i in numbers.range(1, 10)]},
	])
	rule_hit(inp, "o6_20.min_participation.rgve")
	not decision.result.contract_valid with input as inp
}

test_category_presence_female_cattle_pair_combined_days if {
	cats := [
		{"category_code": "cattle_female_2y_plus", "grazing_days_all_animals": 150, "days_with_min_one_animal_present": 214},
		{"category_code": "cattle_female_6m_to_2y", "grazing_days_all_animals": 150, "days_with_min_one_animal_present": 70, "female_cattle_combined_single_animal_days": 180},
	]
	inp := patched([{"op": "replace", "path": "/oepul_measures/tierwohl_weide/categories", "value": cats}])
	not rule_hit(inp, "o6_20.min_participation.category_presence")
}

test_category_presence_without_pair_fails if {
	inp := patched([{"op": "replace", "path": "/oepul_measures/tierwohl_weide/categories/2/days_with_min_one_animal_present", "value": 100}])
	rule_hit(inp, "o6_20.min_participation.category_presence")
}

test_category_without_eligible_animal_lapses if {
	inp := patched([{"op": "add", "path": "/oepul_measures/tierwohl_weide/categories/-", "value": {"category_code": "goats_female_1y_plus", "grazing_days_all_animals": 150, "days_with_min_one_animal_present": 214}}])
	rule_hit(inp, "o6_20.application.category_lapse_no_animal")
}

test_unknown_category_rejected if {
	inp := patched([{"op": "add", "path": "/oepul_measures/tierwohl_weide/categories/-", "value": {"category_code": "pigs", "grazing_days_all_animals": 150}}])
	rule_hit(inp, "o6_20.categories.closed_list")
}

# --- Weidehaltung und Zuschlag ----------------------------------------------------

test_supplement_not_reached_requires_correction_and_removes_supplement if {
	inp := patched([{"op": "replace", "path": "/oepul_measures/tierwohl_weide/categories/0/grazing_days_all_animals", "value": 140}])
	rule_hit(inp, "o6_20.obligation.supplement_150_days")
	premium.category_results.cattle_female_2y_plus.supplement_premium_min_eur == 0 with input as inp
	premium.category_results.cattle_female_2y_plus.premium_eligible with input as inp
}

test_birth_stall_days_extend_required_grazing if {
	inp := patched([{"op": "replace", "path": "/oepul_measures/tierwohl_weide/categories/1/grazing_days_all_animals", "value": 125}])
	rule_hit(inp, "o6_20.obligation.grazing_min_days")
	not premium.category_results.sheep_female_1y_plus.premium_eligible with input as inp
}

test_individual_birth_documentation_keeps_120_days if {
	inp := patched([
		{"op": "replace", "path": "/oepul_measures/tierwohl_weide/categories/1/grazing_days_all_animals", "value": 125},
		{"op": "replace", "path": "/oepul_measures/tierwohl_weide/categories/1/individual_birth_documentation", "value": true},
	])
	not rule_hit(inp, "o6_20.obligation.grazing_min_days")
}

test_forage_violation_and_drought_2026_consideration if {
	inp := patched([{"op": "add", "path": "/oepul_measures/tierwohl_weide/categories/0/forage_mainly_from_grazing", "value": false}])
	rule_hit(inp, "o6_20.obligation.forage_from_grazing")
	inp2 := json.patch(inp, [{"op": "add", "path": "/oepul_measures/tierwohl_weide/drought_affected_2026", "value": true}])
	not rule_hit(inp2, "o6_20.obligation.forage_from_grazing")
	some r in decision.review_items with input as inp2
	r.rule_id == "o6_20.notice2026.drought_forage_consideration"
}

test_force_majeure_suppresses_grazing_day_violation if {
	inp := patched([
		{"op": "replace", "path": "/oepul_measures/tierwohl_weide/categories/2/grazing_days_all_animals", "value": 90},
		{"op": "add", "path": "/oepul_measures/tierwohl_weide/force_majeure_recognized", "value": true},
	])
	not rule_hit(inp, "o6_20.obligation.grazing_min_days")
}

test_missing_water_access if {
	inp := patched([{"op": "add", "path": "/oepul_measures/tierwohl_weide/categories/0/water_access", "value": false}])
	rule_hit(inp, "o6_20.obligation.water_shelter")
}

test_incomplete_grazing_diary if {
	inp := patched([{"op": "replace", "path": "/oepul_measures/tierwohl_weide/grazing_diary/records_location", "value": false}])
	rule_hit(inp, "o6_20.obligation.grazing_diary")
}

# --- Meldepflichten -----------------------------------------------------------------

test_cattle_non_compliance_requires_report if {
	a := object.union(cow("c9", false), {"non_compliance_known_date": "2026-06-01"})
	inp := patched([{"op": "add", "path": "/oepul_measures/tierwohl_weide/animals/-", "value": a}])
	rule_hit(inp, "o6_20.reporting.cattle_deregistration")
	a2 := object.union(a, {"non_compliance_report_date": "2026-06-01", "reported_non_compliant": true})
	inp2 := patched([{"op": "add", "path": "/oepul_measures/tierwohl_weide/animals/-", "value": a2}])
	not rule_hit(inp2, "o6_20.reporting.cattle_deregistration")
}

test_cattle_growing_in_after_min_days_reached_needs_no_report if {
	a := object.union(cow("c9", false), {"non_compliance_known_date": "2026-09-01", "category_entry_date": "2026-09-01"})
	inp := patched([
		{"op": "add", "path": "/oepul_measures/tierwohl_weide/animals/-", "value": a},
		{"op": "add", "path": "/oepul_measures/tierwohl_weide/categories/0/min_days_reached_date", "value": "2026-08-15"},
	])
	not rule_hit(inp, "o6_20.reporting.cattle_deregistration")
}

test_sheep_movement_report_within_7_days if {
	ok := object.union(ewe("s20"), {"present_from": "2026-04-05", "arrival_report_date": "2026-04-12"})
	late := object.union(ewe("s21"), {"present_from": "2026-04-05", "arrival_report_date": "2026-04-13"})
	after_period := object.union(ewe("s22"), {"departure_date": "2026-11-05"})
	inp_ok := patched([{"op": "add", "path": "/oepul_measures/tierwohl_weide/animals/-", "value": ok}])
	inp_late := patched([{"op": "add", "path": "/oepul_measures/tierwohl_weide/animals/-", "value": late}])
	inp_after := patched([{"op": "add", "path": "/oepul_measures/tierwohl_weide/animals/-", "value": after_period}])
	not rule_hit(inp_ok, "o6_20.reporting.sheep_goat_movements")
	rule_hit(inp_late, "o6_20.reporting.sheep_goat_movements")
	not rule_hit(inp_after, "o6_20.reporting.sheep_goat_movements")
}

test_alm_stay_reported_as_departure_excludes_animal if {
	inp := patched([{"op": "add", "path": "/oepul_measures/tierwohl_weide/animals/3/departure_reported_while_on_alm", "value": true}])
	rule_hit(inp, "o6_20.reporting.sheep_goat_alm_not_departure")
	approx(rgve.category_rgve("sheep_female_1y_plus"), 1.35) with input as inp
}

test_equid_count_correction_required if {
	inp := patched([{"op": "replace", "path": "/oepul_measures/tierwohl_weide/categories/2/count_entries/0/compliant_count", "value": 1}])
	rule_hit(inp, "o6_20.reporting.equid_camelid_count_correction")
	approx(rgve.category_rgve("equids_6m_plus"), 1.0) with input as inp
}

test_animal_held_abroad_not_eligible if {
	inp := patched([{"op": "add", "path": "/oepul_measures/tierwohl_weide/animals/0/held_in_austria", "value": false}])
	rule_hit(inp, "o6_20.gen.animals_in_austria")
	approx(rgve.category_rgve("cattle_female_2y_plus"), 2.0) with input as inp
}

# --- Beantragung, Ausstieg, Übernahme --------------------------------------------------

test_new_entry_requires_measure_application_by_31_december if {
	late := patched([
		{"op": "replace", "path": "/oepul_measures/tierwohl_weide/participation_start_year", "value": 2026},
		{"op": "add", "path": "/oepul_measures/tierwohl_weide/measure_application_date", "value": "2026-01-10"},
	])
	rule_hit(late, "o6_20.application.measure_application_deadline")
	in_time := json.patch(late, [{"op": "replace", "path": "/oepul_measures/tierwohl_weide/measure_application_date", "value": "2025-12-31"}])
	not rule_hit(in_time, "o6_20.application.measure_application_deadline")
}

test_no_new_entry_after_funding_year_2027 if {
	inp := patched([
		{"op": "replace", "path": "/farm/year", "value": 2028},
		{"op": "replace", "path": "/oepul_measures/tierwohl_weide/participation_start_year", "value": 2028},
		{"op": "add", "path": "/oepul_measures/tierwohl_weide/measure_application_date", "value": "2027-12-01"},
	])
	rule_hit(inp, "o6_20.application.last_entry")
}

test_no_new_category_after_funding_year_2027 if {
	inp := patched([
		{"op": "replace", "path": "/farm/year", "value": 2028},
		{"op": "add", "path": "/oepul_measures/tierwohl_weide/categories/2/first_year", "value": 2028},
		{"op": "add", "path": "/oepul_measures/tierwohl_weide/categories/2/application_date", "value": "2027-12-01"},
	])
	rule_hit(inp, "o6_20.application.last_entry")
	not premium.category_results.equids_6m_plus.premium_eligible with input as inp
	premium.category_results.cattle_female_2y_plus.premium_eligible with input as inp
}

test_supplement_application_deadline_15_april_and_17_april_2028 if {
	late := patched([{"op": "replace", "path": "/oepul_measures/tierwohl_weide/categories/0/supplement_150_application_date", "value": "2026-04-16"}])
	rule_hit(late, "o6_20.application.supplement_150_deadline")
	premium.category_results.cattle_female_2y_plus.supplement_premium_min_eur == 0 with input as late
	y2028 := json.patch(late, [
		{"op": "replace", "path": "/farm/year", "value": 2028},
		{"op": "replace", "path": "/oepul_measures/tierwohl_weide/categories/0/supplement_150_application_date", "value": "2028-04-17"},
	])
	not rule_hit(y2028, "o6_20.application.supplement_150_deadline")
}

test_deregistration_within_year_invalidates if {
	inp := patched([{"op": "add", "path": "/oepul_measures/tierwohl_weide/deregistration_date", "value": "2026-05-01"}])
	rule_hit(inp, "o6_20.exit.deregistration")
	not decision.result.contract_valid with input as inp
	next_year := patched([{"op": "add", "path": "/oepul_measures/tierwohl_weide/deregistration_date", "value": "2027-01-02"}])
	not rule_hit(next_year, "o6_20.exit.deregistration")
}

test_lapsed_category_reentry_needs_correction_and_request if {
	inp := patched([{"op": "add", "path": "/oepul_measures/tierwohl_weide/categories/2/contract_lapsed_previous_year", "value": true}])
	rule_hit(inp, "o6_20.application.category_reentry")
	ok := json.patch(inp, [
		{"op": "add", "path": "/oepul_measures/tierwohl_weide/categories/2/reapplied_by_correction", "value": true},
		{"op": "add", "path": "/oepul_measures/tierwohl_weide/categories/2/written_request_submitted", "value": true},
	])
	not rule_hit(ok, "o6_20.application.category_reentry")
}

test_takeover_only_on_dissolution_division_merger if {
	bad := patched([{"op": "add", "path": "/oepul_measures/tierwohl_weide/takeover", "value": {"is_takeover": true, "reason": "lease", "animals_and_areas_from_same_previous_farm": true}}])
	rule_hit(bad, "o6_20.gen.takeover")
	good := patched([{"op": "add", "path": "/oepul_measures/tierwohl_weide/takeover", "value": {"is_takeover": true, "reason": "farm_division", "animals_and_areas_from_same_previous_farm": true}}])
	not rule_hit(good, "o6_20.gen.takeover")
}

test_sheep_late_individual_application_not_eligible if {
	inp := patched([{"op": "replace", "path": "/oepul_measures/tierwohl_weide/animals/3/application_date", "value": "2026-04-20"}])
	rule_hit(inp, "o6_20.application.sheep_goat_individual")
	approx(rgve.category_rgve("sheep_female_1y_plus"), 1.35) with input as inp
}

# --- Allgemeine Bedingungen -----------------------------------------------------------

test_public_body_permitted_for_tierwohl_weide if {
	inp := patched([{"op": "add", "path": "/farm/applicant/is_public_body", "value": true}])
	eligibility.public_body_involved with input as inp
	eligibility.public_body_permitted with input as inp
	not rule_hit(inp, "o6_20.gen.applicant.public_body")
}

test_min_farm_size_in_first_oepul_year if {
	inp := patched([
		{"op": "replace", "path": "/farm/oepul_participation/first_oepul_year", "value": 2026},
		{"op": "replace", "path": "/land/total_area_ha", "value": 1.2},
	])
	rule_hit(inp, "o6_20.gen.min_farm_size_first_year")
	later := patched([{"op": "replace", "path": "/land/total_area_ha", "value": 1.2}])
	not rule_hit(later, "o6_20.gen.min_farm_size_first_year")
}

test_control_refusal_invalidates if {
	inp := patched([{"op": "add", "path": "/oepul_measures/tierwohl_weide/control", "value": {"on_site_control_refused": true}}])
	rule_hit(inp, "o6_20.gen.control_refusal")
}

# --- Prämie: Modulation, Sanktion, Mindestbetrag, Querverweis --------------------------------

test_modulation_example_220_ha if {
	approx(premium.modulation_factor(220), 0.990909)
	approx(premium.modulation_factor(150), 1)
	approx(premium.modulation_factor(1200), (((200 + (100 * 0.9)) + (700 * 0.85)) + (200 * 0.75)) / 1200)
}

test_sanction_warning_becomes_1_percent_from_2027 if {
	inp := patched([{"op": "add", "path": "/oepul_measures/tierwohl_weide/sanction_stage", "value": "warning"}])
	premium.sanction_percent == 0 with input as inp
	inp2027 := json.patch(inp, [{"op": "replace", "path": "/farm/year", "value": 2027}])
	premium.sanction_percent == 1 with input as inp2027
	inp25 := patched([{"op": "add", "path": "/oepul_measures/tierwohl_weide/sanction_stage", "value": "reduction_25"}])
	approx(premium.net_min, 216) with input as inp25
}

test_min_payout_threshold if {
	not premium.below_min_payout with input as base_input
	premium.max_advance_min_eur == 216 with input as base_input
}

test_o6_21_reduced_rate_with_weide if {
	inp := patched([{"op": "add", "path": "/oepul_measures/tierwohl_stallhaltung_rinder", "value": {"participating": true}}])
	premium.o6_21_rate == 162 with input as inp
}

test_coupled_support_halves_only_base if {
	premium.category_results.cattle_female_2y_plus.base_premium_min_eur == 100 with input as base_input
	premium.category_results.cattle_female_2y_plus.supplement_premium_min_eur == 48 with input as base_input
}

# --- Datentabellen ------------------------------------------------------------------------

test_data_tables_complete if {
	count(data.o6_20.category_catalog.categories) == 7
	count(data.o6_20.rgve_key.measure_sheet) == 11
	count(data.o6_20.rgve_key.annex_a) == 23
	count(data.o6_20.premium.sanction_stages) == 8
	count(data.o6_20.general_conditions.one_year_measures) == 13
	count(data.o6_20.general_conditions.takeover_individual_case_measures) == 10
}
