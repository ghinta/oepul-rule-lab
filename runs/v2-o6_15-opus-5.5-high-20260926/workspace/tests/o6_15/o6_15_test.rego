package oepul.o6_15_test

import data.oepul.o6_15

# ---------------------------------------------------------------------------
# Testfixtures
# ---------------------------------------------------------------------------

full_care := {
	"daily_care": true,
	"night_care_when_required": true,
	"herding_substantial_part_of_day": true,
	"sufficient_water_supply": true,
	"animal_care": true,
	"treatment_of_diseases_and_injuries": true,
	"safety_measures": true,
	"site_adapted_grazing_management": true,
}

alm_base := {
	"alpine_pasture_area_ha": 150,
	"in_alm_cadastre_or_alm_area": true,
	"managed_from_home_farm": false,
	"visible_boundary_to_grassland": true,
	"herder_accommodation_available": true,
	"care": full_care,
}

base_input(y, alm_list) := {
	"farm": {"year": y, "applicant": {"legal_form": "association", "public_body_share_percent": 0, "is_active_farmer": true, "is_alm_operator": true}},
	"land": {"total_area_ha": 120},
	"oepul_participation": {"first_oepul_year": 2023, "measures": [
		{"measure_id": "o6_14", "participating_in_year": true},
		{"measure_id": "o6_15", "participating_in_year": true, "contract_start_year": 2024, "application_date": "2023-12-10"},
	]},
	"alpine_farming": {
		"herding_application": {"payment_application_submission_date": sprintf("%d-07-01", [y])},
		"alms": alm_list,
	},
}

cattle(id, n, category, up, down) := {
	"animal_id": id, "species": "cattle", "rgve_category": "cattle_2y_plus", "count": n,
	"behirtung_category": category, "drive_up_date": up, "drive_down_date": down,
	"report_date_up": up, "report_date_down": down,
}

dairy_cattle(id, n, up, down) := object.union(cattle(id, n, "dairy_cows", up, down), {"milked": true, "milked_days": 60, "calved_by_july_1": true})

# Beispiel 1 (Kapitel 9): 95 Rinder-RGVE, davon 40 Milchkühe, 2 Hirten
example1_alm := object.union(alm_base, {
	"alm_id": "ALM1",
	"herders": [{"person_id": "H1"}, {"person_id": "H2"}],
	"herded_categories": ["dairy_cows", "other_cattle"],
	"animals": [
		dairy_cattle("cows", 40, "2025-06-10", "2025-09-20"),
		cattle("others", 55, "other_cattle", "2025-06-10", "2025-09-20"),
	],
})

example1_input := base_input(2025, [example1_alm])

# Beispiel 2 (Kapitel 9): zwei Teilbetriebs-Almen, je 110 Tage behirtet
moved(a, total) := object.union(a, {"total_alpine_days_all_herded_alms": total, "first_drive_up_date": "2025-06-01"})

alm_a := object.union(alm_base, {
	"alm_id": "A",
	"is_separate_sub_holding": true,
	"herders": [{"person_id": "HIRTIN_A"}],
	"herded_categories": ["dairy_cows", "other_cattle"],
	"animals": [
		dairy_cattle("cows_stay", 20, "2025-06-01", "2025-09-19"),
		moved(dairy_cattle("cows_move", 20, "2025-06-01", "2025-08-06"), 110),
		cattle("young_stay", 10, "other_cattle", "2025-06-01", "2025-09-19"),
		moved(cattle("young_move", 10, "other_cattle", "2025-06-01", "2025-08-06"), 110),
	],
})

sheep(id, n, milked, up, down) := {
	"animal_id": id, "species": "sheep", "rgve_category": "sheep_1y_plus", "count": n,
	"behirtung_category": "sheep", "milked": milked, "milked_days": 80, "ear_tag": sprintf("AT-%s", [id]),
	"drive_up_date": up, "drive_down_date": down, "report_date_up": up, "report_date_down": down,
}

certified_dog(id, days) := {
	"dog_id": id,
	"certified_herd_protection_dog": true,
	"certificate_available_on_farm": true,
	"liability_insurance": true,
	"present_whole_alpine_period": true,
	"permanent_herd_member": true,
	"day_and_night_with_herd": true,
	"works_without_direct_commands": true,
	"entered_in_auftriebsliste": true,
	"days_on_this_alm": days,
}

alm_b := object.union(alm_base, {
	"alm_id": "B",
	"is_separate_sub_holding": true,
	"herders": [{"person_id": "HIRTE_B"}],
	"herded_categories": ["dairy_cows", "other_cattle", "equids", "sheep"],
	"animals": [
		moved(dairy_cattle("cows_move", 20, "2025-08-06", "2025-09-19"), 110),
		moved(cattle("young_move", 10, "other_cattle", "2025-08-06", "2025-09-19"), 110),
		{"animal_id": "horses", "species": "equid", "rgve_category": "equid_large_adult_3y_plus", "count": 10, "behirtung_category": "equids", "drive_up_date": "2025-06-01", "drive_down_date": "2025-09-19", "report_date_up": "2025-06-01", "planned_drive_down_date": "2025-09-19"},
		sheep("milk_sheep", 50, true, "2025-06-01", "2025-09-19"),
		sheep("other_sheep", 150, false, "2025-06-01", "2025-09-19"),
	],
	"herd_protection_dogs": [certified_dog("DOG1", 110)],
})

example2_input := object.union(base_input(2025, [alm_a, alm_b]), {"alpine_farming": {"herding_application": {"dog_supplement_requested": true}}})

# ---------------------------------------------------------------------------
# Prämienberechnung
# ---------------------------------------------------------------------------

test_example1_total_premium if {
	d := o6_15.decision with input as example1_input
	d.eligible == true
	d.alm_results.ALM1.base_premium_eur == 4725
	d.alm_results.ALM1.dairy_premium_eur == 5184
	d.gross_premium_eur == 9909
	d.net_premium_eur == 9909
}

test_example2_alm_a_proportional_rgve if {
	r := o6_15.alm_results.A with input as example2_input
	r.herded_rgve == 48
	r.dairy_rgve == 32
	r.base_premium_eur == 2376
	r.dairy_premium_eur == 4320
}

test_example2_alm_b_capped_at_50_rgve_per_herder if {
	r := o6_15.alm_results.B with input as example2_input
	r.herded_rgve == 52
	r.capped_rgve == 50
	r.dairy_rgve == 15.5
	r.base_premium_eur == 2430
	r.dairy_premium_eur == 2343.6
	r.dog_premium_eur == 1200
}

test_example2_total_uses_correct_arithmetic if {
	# Informationsblatt nennt 12.534,6 € (Rechenfehler bei Hirte Alm B: 20x81 + 30x27 = 2.430 €)
	d := o6_15.decision with input as example2_input
	d.gross_premium_eur == 12669.6
}

test_higher_rate_blocks if {
	o6_15.higher_rate_rgve(95) == 40
	o6_15.higher_rate_rgve(48) == 20
	o6_15.higher_rate_rgve(50) == 20
	o6_15.higher_rate_rgve(100) == 40
	o6_15.higher_rate_rgve(15.5) == 15.5
	o6_15.higher_rate_rgve(70) == 40
}

test_rates_2023 if {
	r := o6_15.rate_period with input as base_input(2023, [])
	r.herded_first_20_rgve_eur_per_rgve == 75
	r.herded_from_21st_rgve_eur_per_rgve == 25
	r.dairy_supplement_first_20_rgve_eur_per_rgve == 140
	r.herd_protection_dog_eur_per_dog == 700
}

test_rates_2024_dog if {
	r := o6_15.rate_period with input as base_input(2024, [])
	r.herd_protection_dog_eur_per_dog == 756
	r.herded_first_20_rgve_eur_per_rgve == 81
}

test_federal_state_top_up if {
	inp := object.union(example1_input, {"alpine_farming": {"herding_application": {"federal_state_top_up_granted": true, "federal_state_top_up_notified_by_may_15": true}}})
	r := o6_15.alm_results.ALM1 with input as inp
	r.federal_state_top_up_eur == 800
}

test_federal_state_top_up_requires_notification if {
	inp := object.union(example1_input, {"alpine_farming": {"herding_application": {"federal_state_top_up_granted": true}}})
	r := o6_15.alm_results.ALM1 with input as inp
	r.federal_state_top_up_eur == 0
}

# ---------------------------------------------------------------------------
# RGVE-Schlüssel und Altersstichtag 1. Juli
# ---------------------------------------------------------------------------

test_rgve_derivation_from_birth_date if {
	o6_15.derived_rgve_category({"species": "cattle", "birth_date": "2025-02-01"}) == "cattle_under_6m" with input as base_input(2025, [])
	o6_15.derived_rgve_category({"species": "cattle", "birth_date": "2025-01-01"}) == "cattle_6m_to_2y" with input as base_input(2025, [])
	o6_15.derived_rgve_category({"species": "cattle", "birth_date": "2023-07-01"}) == "cattle_2y_plus" with input as base_input(2025, [])
	o6_15.derived_rgve_category({"species": "cattle", "breed": "Dexter", "birth_date": "2024-03-01"}) == "dwarf_cattle_6m_to_2y" with input as base_input(2025, [])
	o6_15.derived_rgve_category({"species": "sheep", "birth_date": "2024-07-01"}) == "sheep_1y_plus" with input as base_input(2025, [])
	o6_15.derived_rgve_category({"species": "sheep", "birth_date": "2024-07-02"}) == "sheep_under_1y" with input as base_input(2025, [])
	o6_15.derived_rgve_category({"species": "equid", "equid_large_breed": true, "birth_date": "2022-06-30"}) == "equid_large_adult_3y_plus" with input as base_input(2025, [])
	o6_15.derived_rgve_category({"species": "equid", "birth_date": "2023-05-01"}) == "equid_small_young_6m_to_3y" with input as base_input(2025, [])
	o6_15.derived_rgve_category({"species": "new_world_camelid", "birth_date": "2025-01-15"}) == "new_world_camelid_under_1y" with input as base_input(2025, [])
}

test_rgve_factor_lookup if {
	o6_15.animal_rgve_factor({"species": "goat", "rgve_category": "goat_1y_plus"}) == 0.15
	o6_15.animal_rgve_factor({"species": "equid", "rgve_category": "equid_small_adult_3y_plus"}) == 0.5
	o6_15.animal_rgve_factor({"species": "cattle", "rgve_category": "dwarf_cattle_2y_plus"}) == 0.5
}

# ---------------------------------------------------------------------------
# Mindestteilnahme, Kombinationsverpflichtung, Vertrag
# ---------------------------------------------------------------------------

young_cattle_alm := object.union(alm_base, {
	"alm_id": "SMALL",
	"herders": [{"person_id": "H9"}],
	"herded_categories": ["other_cattle"],
	"animals": [{"animal_id": "young", "species": "cattle", "birth_date": "2024-03-01", "count": 4, "behirtung_category": "other_cattle", "drive_up_date": "2025-06-01", "drive_down_date": "2025-09-01", "report_date_up": "2025-06-01", "report_date_down": "2025-09-01"}],
})

test_min_rgve_not_met_contract_expires if {
	# Beispiel Kapitel 7: 4 Rinder 1/2 bis 2 Jahre = 2,40 RGVE
	d := o6_15.decision with input as base_input(2025, [young_cattle_alm])
	d.farm_herded_rgve == 2.4
	d.contract_status == "expired"
	d.eligible == false
	d.payable_premium_eur == 0
	some f in d.eligibility_failures
	f.rule_id == "o6_15.elig.min_rgve"
}

test_combination_obligation_missing if {
	inp := json.patch(example1_input, [{"op": "replace", "path": "/oepul_participation/measures/0/participating_in_year", "value": false}])
	d := o6_15.decision with input as inp
	d.contract_status == "expired"
	some f in d.eligibility_failures
	f.rule_id == "o6_15.elig.combination_almbewirtschaftung"
}

test_new_entry_requires_application_by_dec_31 if {
	inp := json.patch(example1_input, [
		{"op": "replace", "path": "/oepul_participation/measures/1/contract_start_year", "value": 2025},
		{"op": "replace", "path": "/oepul_participation/measures/1/application_date", "value": "2025-01-05"},
	])
	d := o6_15.decision with input as inp
	d.contract_status == "not_concluded"
}

test_new_entry_timely if {
	inp := json.patch(example1_input, [
		{"op": "replace", "path": "/oepul_participation/measures/1/contract_start_year", "value": 2025},
		{"op": "replace", "path": "/oepul_participation/measures/1/application_date", "value": "2024-12-31"},
	])
	o6_15.contract_status == "valid" with input as inp
}

test_last_entry_2027 if {
	inp := json.patch(base_input(2028, [example1_alm]), [
		{"op": "replace", "path": "/oepul_participation/measures/1/contract_start_year", "value": 2028},
		{"op": "replace", "path": "/oepul_participation/measures/1/application_date", "value": "2027-12-01"},
	])
	o6_15.contract_status == "not_concluded" with input as inp
}

test_reentry_after_expiry_with_late_correction if {
	inp := json.patch(example1_input, [
		{"op": "add", "path": "/oepul_participation/measures/1", "value": {
			"measure_id": "o6_15", "contract_start_year": 2025, "application_date": "2026-01-20",
			"previous_contract_expired": true, "late_correction_of_previous_measure_application": true,
			"written_request_to_ama_submitted": true,
		}},
		{"op": "remove", "path": "/oepul_participation/measures/2"},
	])
	o6_15.contract_status == "valid" with input as inp
	o6_15.reentry_requires_ama_recognition with input as inp
}

test_reentry_without_request_fails if {
	inp := json.patch(example1_input, [
		{"op": "add", "path": "/oepul_participation/measures/1", "value": {
			"measure_id": "o6_15", "contract_start_year": 2025, "application_date": "2026-01-20",
			"previous_contract_expired": true, "late_correction_of_previous_measure_application": true,
		}},
		{"op": "remove", "path": "/oepul_participation/measures/2"},
	])
	o6_15.contract_status == "not_concluded" with input as inp
}

test_deregistration_in_year if {
	inp := json.patch(example1_input, [{"op": "add", "path": "/oepul_participation/measures/1/deregistered_in_year", "value": true}])
	d := o6_15.decision with input as inp
	d.contract_status == "deregistered"
	d.eligible == false
}

test_exit_effective_following_year if {
	o6_15.exit_effective_year("2025-10-01") == 2026 with input as example1_input
}

test_takeover_rules if {
	ok := json.patch(example1_input, [{"op": "add", "path": "/oepul_participation/measures/1/takeover", "value": {"is_takeover": true, "reason": "farm_division", "animals_and_areas_from_same_predecessor": true}}])
	o6_15.takeover_allowed with input as ok
	bad := json.patch(example1_input, [{"op": "add", "path": "/oepul_participation/measures/1/takeover", "value": {"is_takeover": true, "reason": "purchase", "animals_and_areas_from_same_predecessor": true}}])
	d := o6_15.decision with input as bad
	some f in d.eligibility_failures
	f.rule_id == "o6_15.app.takeover"
}

# ---------------------------------------------------------------------------
# Förderwerbende Person und allgemeine Bedingungen
# ---------------------------------------------------------------------------

test_public_body_not_eligible if {
	inp := json.patch(example1_input, [{"op": "replace", "path": "/farm/applicant/legal_form", "value": "public_body"}])
	not o6_15.applicant_eligible with input as inp
}

test_public_share_threshold if {
	over := json.patch(example1_input, [{"op": "replace", "path": "/farm/applicant/public_body_share_percent", "value": 30}])
	not o6_15.applicant_eligible with input as over
	limit := json.patch(example1_input, [{"op": "replace", "path": "/farm/applicant/public_body_share_percent", "value": 25}])
	o6_15.applicant_eligible with input as limit
}

test_applicant_must_be_alm_operator if {
	inp := json.patch(example1_input, [{"op": "replace", "path": "/farm/applicant/is_alm_operator", "value": false}])
	not o6_15.applicant_eligible with input as inp
}

test_min_farm_size_first_year if {
	inp := json.patch(example1_input, [
		{"op": "replace", "path": "/oepul_participation/first_oepul_year", "value": 2025},
		{"op": "replace", "path": "/land/total_area_ha", "value": 1.2},
	])
	not o6_15.min_farm_size_met with input as inp
}

test_control_refusal if {
	inp := object.union(example1_input, {"documentation": {"on_site_control_refused": true}})
	d := o6_15.decision with input as inp
	d.eligible == false
}

# ---------------------------------------------------------------------------
# Tierbezogene Bedingungen
# ---------------------------------------------------------------------------

test_late_cattle_report_limits_recognized_days if {
	a := object.union(cattle("late", 5, "other_cattle", "2025-06-01", "2025-08-10"), {"report_date_up": "2025-06-30"})
	o6_15.recognized_days_this_alm(a) == 55 with input as example1_input
	not o6_15.meets_min_herding_duration(a) with input as example1_input
	o6_15.drive_up_reported_late(a) with input as example1_input
}

test_sheep_report_retroactive_7_days if {
	a := object.union(sheep("s1", 1, false, "2025-06-01", "2025-08-15"), {"report_date_up": "2025-06-20"})
	o6_15.recognized_days_this_alm(a) == 63 with input as example1_input
}

test_interruptions_do_not_count if {
	a := object.union(cattle("int", 5, "other_cattle", "2025-06-01", "2025-08-05"), {"interruption_days": 10})
	o6_15.recognized_days_this_alm(a) == 55 with input as example1_input
}

test_drive_up_after_july_15_not_counted if {
	a := cattle("late_up", 10, "other_cattle", "2025-07-16", "2025-09-30")
	alm := object.union(example1_alm, {"animals": [dairy_cattle("cows", 40, "2025-06-10", "2025-09-20"), a]})
	r := o6_15.alm_results.ALM1 with input as base_input(2025, [alm])
	r.herded_rgve == 40
}

test_dairy_cow_requires_45_milking_days if {
	a := object.union(dairy_cattle("c", 1, "2025-06-01", "2025-09-01"), {"milked_days": 44})
	not o6_15.is_dairy_qualified(a) with input as example1_input
}

test_dairy_cow_requires_calving if {
	a := object.union(dairy_cattle("c", 1, "2025-06-01", "2025-09-01"), {"calved_by_july_1": false})
	not o6_15.is_dairy_qualified(a) with input as example1_input
}

test_dairy_sheep_age if {
	young := {"species": "sheep", "birth_date": "2024-08-01", "milked": true, "milked_days": 60}
	not o6_15.is_dairy_qualified(young) with input as example1_input
	old := {"species": "sheep", "birth_date": "2024-06-01", "milked": true, "milked_days": 60}
	o6_15.is_dairy_qualified(old) with input as example1_input
}

test_milked_flag_sheep_not_after_july_15 if {
	a := object.union(sheep("s", 1, true, "2025-07-12", "2025-09-30"), {"milked_flag_reported_date": "2025-07-17"})
	not o6_15.milked_flag_timely(a) with input as example1_input
	b := object.union(sheep("s", 1, true, "2025-07-01", "2025-09-30"), {"milked_flag_reported_date": "2025-07-06"})
	o6_15.milked_flag_timely(b) with input as example1_input
}

test_milked_flag_cattle_14_days if {
	a := object.union(dairy_cattle("c", 1, "2025-06-01", "2025-09-01"), {"milked_flag_reported_date": "2025-06-15"})
	o6_15.milked_flag_timely(a) with input as example1_input
	b := object.union(dairy_cattle("c", 1, "2025-06-01", "2025-09-01"), {"milked_flag_reported_date": "2025-06-16"})
	not o6_15.milked_flag_timely(b) with input as example1_input
}

test_all_animals_per_category_must_be_herded if {
	a := object.union(cattle("unherded", 3, "other_cattle", "2025-06-10", "2025-09-20"), {"is_herded": false})
	alm := object.union(example1_alm, {"animals": [dairy_cattle("cows", 40, "2025-06-10", "2025-09-20"), a]})
	d := o6_15.decision with input as base_input(2025, [alm])
	some v in d.obligation_violations
	v.rule_id == "o6_15.obl.all_animals_per_category"
	v.subject == "unherded"
}

test_equid_planned_down_date_no_report if {
	a := {"species": "equid", "drive_up_date": "2025-06-01", "drive_down_date": "2025-09-01", "planned_drive_down_date": "2025-09-01"}
	not o6_15.drive_down_report_required(a)
	b := object.union(a, {"planned_drive_down_date": "2025-09-10"})
	o6_15.drive_down_report_required(b)
}

test_sheep_ear_tag_required if {
	s := object.remove(sheep("s", 1, false, "2025-06-01", "2025-09-01"), ["ear_tag"])
	alm := object.union(example1_alm, {"herded_categories": ["dairy_cows", "other_cattle", "sheep"], "animals": [dairy_cattle("cows", 40, "2025-06-10", "2025-09-20"), s]})
	d := o6_15.decision with input as base_input(2025, [alm])
	some v in d.obligation_violations
	v.rule_id == "o6_15.app.sheep_goat_ear_tag"
}

# ---------------------------------------------------------------------------
# Almbezogene Bedingungen
# ---------------------------------------------------------------------------

test_only_inspection_not_sufficient if {
	alm := object.union(example1_alm, {"care": object.union(full_care, {"inspection_only": true})})
	d := o6_15.decision with input as base_input(2025, [alm])
	d.alm_results.ALM1.eligible == false
	d.alm_results.ALM1.gross_premium_eur == 0
}

test_missing_water_supply_violation if {
	alm := object.union(example1_alm, {"care": object.union(full_care, {"sufficient_water_supply": false})})
	r := o6_15.alm_results.ALM1 with input as base_input(2025, [alm])
	"o6_15.obl.daily_care" in r.failures
}

test_accommodation_required if {
	alm := object.union(example1_alm, {"herder_accommodation_available": false})
	r := o6_15.alm_results.ALM1 with input as base_input(2025, [alm])
	"o6_15.obl.accommodation" in r.failures
}

test_min_stocking_via_consecutive_animals if {
	alm := object.union(alm_base, {
		"alm_id": "SEQ",
		"stocking_days": 80,
		"herders": [{"person_id": "HX"}],
		"herded_categories": ["other_cattle"],
		"animals": [
			cattle("first", 5, "other_cattle", "2025-06-01", "2025-07-11"),
			cattle("second", 5, "other_cattle", "2025-07-11", "2025-08-20"),
		],
	})
	o6_15.alm_min_stocking_met(alm) with input as base_input(2025, [alm])
	no_days := object.remove(alm, ["stocking_days"])
	not o6_15.alm_min_stocking_met(no_days) with input as base_input(2025, [no_days])
}

test_alm_definition_home_farm if {
	alm := object.union(example1_alm, {"managed_from_home_farm": true})
	r := o6_15.alm_results.ALM1 with input as base_input(2025, [alm])
	"o6_15.def.alm" in r.failures
}

test_herder_only_one_alm if {
	second := object.union(example1_alm, {"alm_id": "ALM2", "herders": [{"person_id": "H1"}]})
	inp := base_input(2025, [example1_alm, second])
	o6_15.valid_herder_count(example1_alm) == 2 with input as inp
	o6_15.valid_herder_count(second) == 0 with input as inp
	d := o6_15.decision with input as inp
	some v in d.obligation_violations
	v.rule_id == "o6_15.app.one_alm_per_herder"
	v.alm_id == "ALM2"
}

# ---------------------------------------------------------------------------
# Herdenschutzhunde
# ---------------------------------------------------------------------------

dog_input(dogs) := object.union(
	base_input(2025, [object.union(example1_alm, {"herd_protection_dogs": dogs})]),
	{"alpine_farming": {"herding_application": {"dog_supplement_requested": true}}},
)

test_dog_40_days_not_eligible if {
	r := o6_15.alm_results.ALM1 with input as dog_input([certified_dog("D1", 40)])
	r.paid_dogs == 0
	r.dog_premium_eur == 0
}

test_dog_65_days_eligible_rate_2025 if {
	r := o6_15.alm_results.ALM1 with input as dog_input([certified_dog("D1", 65)])
	r.paid_dogs == 1
	r.dog_premium_eur == 1200
}

test_dog_max_five_per_alm if {
	dogs := [certified_dog(sprintf("D%d", [i]), 90) | some i in numbers.range(1, 6)]
	r := o6_15.alm_results.ALM1 with input as dog_input(dogs)
	r.eligible_dogs == 6
	r.paid_dogs == 5
	r.dog_premium_eur == 6000
}

test_dog_requires_certificate_and_insurance if {
	r := o6_15.alm_results.ALM1 with input as dog_input([object.union(certified_dog("D1", 90), {"liability_insurance": false})])
	r.paid_dogs == 0
}

test_dog_only_on_one_alm if {
	a1 := object.union(example1_alm, {"herd_protection_dogs": [certified_dog("D1", 65)]})
	a2 := object.union(example1_alm, {"alm_id": "ALM2", "herders": [{"person_id": "H3"}], "herd_protection_dogs": [certified_dog("D1", 65)]})
	inp := object.union(base_input(2025, [a1, a2]), {"alpine_farming": {"herding_application": {"dog_supplement_requested": true}}})
	r := o6_15.alm_results.ALM1 with input as inp
	r.paid_dogs == 0
}

test_dog_supplement_last_entry_2028 if {
	inp := object.union(dog_input([certified_dog("D1", 65)]), {"alpine_farming": {"herding_application": {"dog_supplement_start_year": 2029}}})
	not o6_15.dog_supplement_entry_ok with input as inp
	late := object.union(dog_input([certified_dog("D1", 65)]), {"alpine_farming": {"herding_application": {"dog_supplement_start_year": 2025, "dog_supplement_application_date": "2025-01-10"}}})
	not o6_15.dog_supplement_entry_ok with input as late
}

# ---------------------------------------------------------------------------
# Fristen, Modulation, Auszahlung, Sanktionen, 2026-Hinweise
# ---------------------------------------------------------------------------

test_payment_application_deadline_2028_july_17 if {
	inp := json.patch(base_input(2028, [example1_alm]), [{"op": "replace", "path": "/alpine_farming/herding_application/payment_application_submission_date", "value": "2028-07-17"}])
	o6_15.payment_application_timely with input as inp
}

test_payment_application_deadline_2027_july_15 if {
	inp := json.patch(base_input(2027, [example1_alm]), [{"op": "replace", "path": "/alpine_farming/herding_application/payment_application_submission_date", "value": "2027-07-16"}])
	not o6_15.payment_application_timely with input as inp
	d := o6_15.decision with input as inp
	some f in d.deadline_findings
	f.rule_id == "o6_15.app.payment_application_deadline"
}

test_modulation_factor if {
	o6_15.modulation_factor_for(190) == 1
	o6_15.modulation_factor_for(220) == 218 / 220
	o6_15.modulation_factor_for(230) == 227 / 230
	o6_15.modulation_factor_for(1100) == (((200 + 90) + 595) + 75) / 1100
}

test_modulation_basis_capped_by_area if {
	# Beispiel: 230 ha Almweidefläche, 250 RGVE aufgetrieben -> Basis 230
	alm := object.union(example1_alm, {"alpine_pasture_area_ha": 230, "stocked_rgve": 250})
	o6_15.modulation_basis == 230 with input as base_input(2025, [alm])
	alm2 := object.union(example1_alm, {"alpine_pasture_area_ha": 230, "stocked_rgve": 190})
	o6_15.modulation_factor == 1 with input as base_input(2025, [alm2])
}

test_modulation_applied_to_premium if {
	alm := object.union(example1_alm, {"alpine_pasture_area_ha": 230, "stocked_rgve": 250})
	d := o6_15.decision with input as base_input(2025, [alm])
	d.net_premium_eur == round((9909 * (227 / 230)) * 100) / 100
}

test_small_payout_may_be_waived if {
	# 3 Rinder-RGVE nur für eine Hirtin: 3 x 81 = 243 EUR > 50 -> nicht verzichtbar
	alm := object.union(alm_base, {"alm_id": "S", "herders": [{"person_id": "H5"}], "herded_categories": ["other_cattle"], "animals": [cattle("c", 3, "other_cattle", "2025-06-01", "2025-09-01")]})
	d := o6_15.decision with input as base_input(2025, [alm])
	d.net_premium_eur == 243
	d.payout_may_be_waived == false
}

test_payment_deadline_and_advance if {
	d := o6_15.decision with input as example1_input
	d.payment_deadline == "2026-06-30"
	d.max_advance_payment_eur == 7431.75
}

test_sanction_warning_until_2026 if {
	o6_15.sanction_share("warning") == 0 with input as base_input(2026, [])
	o6_15.sanction_share("warning") == 0.01 with input as base_input(2027, [])
	o6_15.sanction_share("reduction_25") == 0.25 with input as base_input(2027, [])
}

test_exclusion_after_two_full_reductions if {
	inp := json.patch(example1_input, [{"op": "add", "path": "/oepul_participation/measures/1/full_reductions_in_contract_period", "value": 2}])
	o6_15.exclusion_from_measure with input as inp
}

test_drought_2026_force_majeure_advisory if {
	alm := object.union(example1_alm, {"water_supply_failed_due_to_drought": true})
	d := o6_15.decision with input as base_input(2026, [alm])
	some a in d.advisories
	a.rule_id == "o6_15.notice2026.drought_force_majeure"
}

test_no_drought_advisory_2025 if {
	alm := object.union(example1_alm, {"water_supply_failed_due_to_drought": true})
	d := o6_15.decision with input as base_input(2025, [alm])
	every a in d.advisories {
		a.rule_id != "o6_15.notice2026.drought_force_majeure"
	}
}

test_permanent_circumstance_after_drive_up if {
	alm := object.union(example1_alm, {"permanent_circumstance_date": "2025-08-01"})
	o6_15.permanent_circumstance_premium_possible(alm) with input as base_input(2025, [alm])
	before := object.union(example1_alm, {"permanent_circumstance_date": "2025-05-01"})
	ids := o6_15.permanent_circumstance_no_premium with input as base_input(2025, [before])
	"ALM1" in ids
}

test_np_kalkalpen_advisory if {
	alm := object.union(example1_alm, {"national_park": "Kalkalpen"})
	d := o6_15.decision with input as base_input(2025, [alm])
	some a in d.advisories
	a.rule_id == "o6_15.gen.np_kalkalpen"
}

test_multiple_reduction_order if {
	order := o6_15.multiple_reduction_order
	count(order) == 11
	order[0] == "area_over_declaration"
	order[6] == "modulation"
	order[10] == "conditionality"
}
