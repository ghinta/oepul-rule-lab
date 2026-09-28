package oepul.o6_23_test

import data.oepul.o6_23

parcel_p1 := {
	"parcel_id": "P1",
	"area_ha": 2.0,
	"land_use": "grassland",
	"operations": {
		"cutting_dates": ["2026-07-10", "2026-09-01"],
		"mowing_material_removed": true,
		"full_area_grazed": false,
		"grazing_uses": 0,
		"fertilizer": {"mineral_n_kg_per_ha": 0, "organic_n_kg_per_ha": 0},
	},
	"constraints": {"natura2000": {
		"in_natura2000_or_high_nature_value_area": true,
		"project_confirmation_present": true,
		"project_confirmation_codes": ["N2GI06", "N2GL03"],
		"project_confirmation_complied": true,
		"n2_code_marked": true,
		"divsz_code_marked": true,
		"grassland_type": "maehwiese",
		"earliest_cut_date": "2026-07-01",
		"earliest_cut_date_state_ordinance_2026": null,
		"in_national_park": false,
		"national_park_name": null,
		"fertilization_applied": false,
	}},
	"oepul": {
		"measures": ["23", "1A"],
		"op_codes": [],
		"naturschutz_codes": [],
		"other_area_payments_eur_per_ha": 0,
		"transferred_during_year": false,
		"successor_continues_until_year_end": false,
	},
	"eligibility": {
		"located_in_austria": true,
		"actively_farmed": true,
		"is_other_area": false,
		"is_gloez_landscape_element": false,
		"mainly_agricultural_use": true,
		"is_experimental_area_vf": false,
		"is_short_rotation_or_nursery": false,
	},
}

parcel_p2 := {
	"parcel_id": "P2",
	"area_ha": 1.5,
	"land_use": "grassland",
	"operations": {
		"cutting_dates": ["2026-05-20", "2026-07-01", "2026-08-20"],
		"mowing_material_removed": true,
		"full_area_grazed": false,
		"grazing_uses": 0,
		"fertilizer": {"mineral_n_kg_per_ha": 0, "organic_n_kg_per_ha": 0},
	},
	"constraints": {"natura2000": {
		"in_natura2000_or_high_nature_value_area": true,
		"project_confirmation_present": true,
		"project_confirmation_codes": ["N2GI05"],
		"project_confirmation_complied": true,
		"n2_code_marked": true,
		"divsz_code_marked": false,
		"grassland_type": "maehweide",
		"earliest_cut_date": null,
		"earliest_cut_date_state_ordinance_2026": null,
		"in_national_park": false,
		"national_park_name": null,
		"fertilization_applied": false,
	}},
	"oepul": {
		"measures": ["23"],
		"op_codes": [],
		"naturschutz_codes": [],
		"other_area_payments_eur_per_ha": 0,
		"transferred_during_year": false,
		"successor_continues_until_year_end": false,
	},
	"eligibility": {"located_in_austria": true, "actively_farmed": true},
}

base_input := {
	"farm": {
		"farm_id": "F1",
		"year": 2026,
		"applicant": {
			"legal_form": "natural_person",
			"public_body_share_percent": 0,
			"is_active_farmer": true,
			"performs_agricultural_activity": true,
			"farms_in_own_name_and_account": true,
		},
		"oepul": {
			"first_participation_year": 2023,
			"conditionality_compliant": true,
			"on_site_check_refused": false,
			"o6_23": {
				"contract_start_year": 2024,
				"measure_application_date": "2023-12-15",
				"deregistration_date": null,
				"control_notice_date": null,
				"content_violation_stage": "none",
				"full_reductions_in_contract_period": 0,
				"takeover": null,
			},
		},
	},
	"land": {
		"total_area_ha": 50,
		"protected_cultivation_area_ha": 0,
		"parcels": [parcel_p1, parcel_p2],
	},
}

with_parcels(ps) := json.patch(base_input, [{"op": "replace", "path": "/land/parcels", "value": ps}])

patch_p1(ops) := with_parcels([json.patch(parcel_p1, ops), parcel_p2])

patch_farm(ops) := json.patch(base_input, ops)

# --- Grundfall -------------------------------------------------------------

test_base_case_contract_valid if {
	d := o6_23.decision with input as base_input
	d.contract_valid
	d.farm_failures == []
}

test_base_case_premium_2026 if {
	# P1: (264,6 + 162,0) * 2,0 = 853,2; P2: 351,0 * 1,5 = 526,5
	d := o6_23.decision with input as base_input
	d.parcels.P1.rate_eur_per_ha == 426.6
	d.parcels.P1.premium_eur == 853.2
	d.parcels.P2.premium_eur == 526.5
	d.gross_premium_eur == 1379.7
	d.modulation_factor == 1
	d.premium_eur == 1379.7
}

test_rates_2023 if {
	inp := patch_farm([
		{"op": "replace", "path": "/farm/year", "value": 2023},
		{"op": "replace", "path": "/farm/oepul/o6_23/contract_start_year", "value": 2023},
		{"op": "replace", "path": "/farm/oepul/o6_23/measure_application_date", "value": "2022-12-01"},
	])
	d := o6_23.decision with input as inp
	d.parcels.P1.rate_eur_per_ha == 395
	d.parcels.P2.premium_eur == 487.5
}

test_rate_table_complete if {
	count(o6_23.known_codes) == 9
	o6_23.rate_for("N2GL37", 2025) == 540
	o6_23.rate_for("N2GL02", 2023) == 90
	o6_23.rate_for("N2GI07", 2024) == 183.6
}

test_one_year_measure_without_area_increase_restriction if {
	o6_23.is_one_year_measure
	not o6_23.area_increase_restricted
}

# --- Zugangsvoraussetzungen ------------------------------------------------

test_dauerweide_not_eligible if {
	inp := patch_p1([{"op": "replace", "path": "/constraints/natura2000/grassland_type", "value": "dauerweide"}])
	d := o6_23.decision with input as inp
	"grassland_type_not_eligible" in d.parcels.P1.access_failures
	d.parcels.P1.premium_eur == 0
	d.contract_valid
}

test_missing_project_confirmation if {
	inp := patch_p1([{"op": "replace", "path": "/constraints/natura2000/project_confirmation_present", "value": false}])
	d := o6_23.decision with input as inp
	"no_project_confirmation" in d.parcels.P1.access_failures
	not d.parcels.P1.eligible
}

test_not_grassland if {
	inp := patch_p1([{"op": "replace", "path": "/land_use", "value": "arable"}])
	d := o6_23.decision with input as inp
	"not_grassland" in d.parcels.P1.access_failures
}

test_confirmation_without_n2_code_not_applied if {
	inp := patch_p1([{"op": "replace", "path": "/constraints/natura2000/n2_code_marked", "value": false}])
	d := o6_23.decision with input as inp
	not d.parcels.P1
	"project_confirmation_without_n2_code" in d.farm_findings
}

test_unknown_code_reported if {
	inp := patch_p1([{"op": "replace", "path": "/constraints/natura2000/project_confirmation_codes", "value": ["N2GI06", "N2XX99"]}])
	d := o6_23.decision with input as inp
	d.parcels.P1.unknown_codes == ["N2XX99"]
	d.parcels.P1.rate_eur_per_ha == 264.6
}

test_op_code_blocks_premium if {
	inp := patch_p1([{"op": "replace", "path": "/oepul/op_codes", "value": ["OP"]}])
	d := o6_23.decision with input as inp
	"op_code_set" in d.parcels.P1.access_failures
	d.parcels.P1.premium_eur == 0
}

test_transfer_without_continuation if {
	inp := patch_p1([{"op": "replace", "path": "/oepul/transferred_during_year", "value": true}])
	d := o6_23.decision with input as inp
	"transfer_without_continuation" in d.parcels.P1.access_failures
}

test_national_park_parcel_still_eligible if {
	inp := patch_p1([
		{"op": "replace", "path": "/constraints/natura2000/in_national_park", "value": true},
		{"op": "replace", "path": "/constraints/natura2000/national_park_name", "value": "Neusiedlersee"},
	])
	d := o6_23.decision with input as inp
	d.parcels.P1.national_park_premium_allowed
	d.parcels.P1.premium_granted
}

test_gloez_landscape_element_not_eligible if {
	inp := patch_p1([{"op": "replace", "path": "/eligibility/is_gloez_landscape_element", "value": true}])
	d := o6_23.decision with input as inp
	"gloez_landscape_element" in d.parcels.P1.access_failures
}

test_statutory_requirements_compensable if {
	o6_23.statutory_requirements_compensable
}

# --- Förderwerbende Person und Betrieb -------------------------------------

test_public_body_not_eligible if {
	inp := patch_farm([{"op": "replace", "path": "/farm/applicant/legal_form", "value": "public_body"}])
	d := o6_23.decision with input as inp
	"public_body_not_eligible_for_o6_23" in d.applicant_failures
	not d.contract_valid
	d.premium_eur == 0
}

test_legal_person_public_share_above_limit if {
	inp := patch_farm([
		{"op": "replace", "path": "/farm/applicant/legal_form", "value": "legal_person"},
		{"op": "replace", "path": "/farm/applicant/public_body_share_percent", "value": 30},
	])
	d := o6_23.decision with input as inp
	"public_body_share_above_25_percent" in d.applicant_failures
}

test_legal_person_public_share_at_limit_ok if {
	inp := patch_farm([
		{"op": "replace", "path": "/farm/applicant/legal_form", "value": "legal_person"},
		{"op": "replace", "path": "/farm/applicant/public_body_share_percent", "value": 25},
	])
	d := o6_23.decision with input as inp
	d.applicant_failures == []
}

test_min_farm_size_first_year_failed if {
	inp := patch_farm([
		{"op": "replace", "path": "/farm/oepul/first_participation_year", "value": 2026},
		{"op": "replace", "path": "/land/total_area_ha", "value": 1.2},
	])
	d := o6_23.decision with input as inp
	"minimum_farm_size_not_met" in d.farm_failures
}

test_min_farm_size_protected_cultivation_ok if {
	inp := patch_farm([
		{"op": "replace", "path": "/farm/oepul/first_participation_year", "value": 2026},
		{"op": "replace", "path": "/land/total_area_ha", "value": 1.2},
		{"op": "replace", "path": "/land/protected_cultivation_area_ha", "value": 0.5},
	])
	d := o6_23.decision with input as inp
	not "minimum_farm_size_not_met" in d.farm_failures
}

test_min_farm_size_not_required_after_first_year if {
	inp := patch_farm([{"op": "replace", "path": "/land/total_area_ha", "value": 1.0}])
	o6_23.minimum_farm_size_met with input as inp
}

# --- Antrag, Vertragszeitraum, Ausstieg ------------------------------------

test_last_entry_2027_allowed if {
	inp := patch_farm([
		{"op": "replace", "path": "/farm/year", "value": 2027},
		{"op": "replace", "path": "/farm/oepul/o6_23/contract_start_year", "value": 2027},
		{"op": "replace", "path": "/farm/oepul/o6_23/measure_application_date", "value": "2026-12-31"},
	])
	o6_23.contract_active_in_year with input as inp
}

test_entry_2028_not_allowed if {
	inp := patch_farm([
		{"op": "replace", "path": "/farm/year", "value": 2028},
		{"op": "replace", "path": "/farm/oepul/o6_23/contract_start_year", "value": 2028},
		{"op": "replace", "path": "/farm/oepul/o6_23/measure_application_date", "value": "2027-12-15"},
	])
	d := o6_23.decision with input as inp
	"contract_not_active" in d.farm_failures
}

test_late_application if {
	inp := patch_farm([{"op": "replace", "path": "/farm/oepul/o6_23/measure_application_date", "value": "2024-01-05"}])
	not o6_23.application_timely with input as inp
}

test_deregistration_during_year_invalidates_year if {
	inp := patch_farm([{"op": "replace", "path": "/farm/oepul/o6_23/deregistration_date", "value": "2026-03-01"}])
	d := o6_23.decision with input as inp
	"contract_not_active" in d.farm_failures
	d.premium_eur == 0
}

test_deregistration_after_control_notice_ineffective if {
	inp := patch_farm([
		{"op": "replace", "path": "/farm/oepul/o6_23/deregistration_date", "value": "2026-06-10"},
		{"op": "replace", "path": "/farm/oepul/o6_23/control_notice_date", "value": "2026-06-01"},
	])
	d := o6_23.decision with input as inp
	not o6_23.deregistration_effective with input as inp
	d.contract_valid
}

test_reentry_after_previous_exit_needs_application if {
	inp := patch_farm([{"op": "replace", "path": "/farm/oepul/o6_23/deregistration_date", "value": "2025-02-01"}])
	o6_23.reentry_requires_new_application with input as inp
}

test_minimum_participation_not_met if {
	inp := with_parcels([json.patch(parcel_p1, [{"op": "replace", "path": "/constraints/natura2000/project_confirmation_present", "value": false}])])
	d := o6_23.decision with input as inp
	"minimum_participation_not_met" in d.farm_failures
	not d.contract_valid
}

test_on_site_check_refused if {
	inp := patch_farm([{"op": "replace", "path": "/farm/oepul/on_site_check_refused", "value": true}])
	d := o6_23.decision with input as inp
	"on_site_check_refused" in d.farm_failures
}

# --- Förderverpflichtungen ------------------------------------------------

test_fertilization_ban_violation if {
	inp := patch_p1([{"op": "replace", "path": "/operations/fertilizer/organic_n_kg_per_ha", "value": 30}])
	d := o6_23.decision with input as inp
	"fertilization_despite_ban" in d.parcels.P1.obligation_violations
	"obligation_violations_present" in d.farm_findings
}

test_cut_before_earliest_date if {
	inp := patch_p1([{"op": "replace", "path": "/operations/cutting_dates", "value": ["2026-06-20"]}])
	d := o6_23.decision with input as inp
	"cut_before_earliest_cut_date" in d.parcels.P1.obligation_violations
}

test_drought_2026_state_ordinance_date_applies if {
	inp := patch_p1([
		{"op": "replace", "path": "/operations/cutting_dates", "value": ["2026-06-20"]},
		{"op": "replace", "path": "/constraints/natura2000/earliest_cut_date_state_ordinance_2026", "value": "2026-06-15"},
	])
	d := o6_23.decision with input as inp
	not "cut_before_earliest_cut_date" in d.parcels.P1.obligation_violations
	d.parcels.P1.drought_2026_cut_date_release_used
	d.parcels.P1.premium_granted
}

test_drought_ordinance_date_ignored_outside_2026 if {
	inp := json.patch(
		patch_p1([
			{"op": "replace", "path": "/operations/cutting_dates", "value": ["2025-06-20"]},
			{"op": "replace", "path": "/constraints/natura2000/earliest_cut_date", "value": "2025-07-01"},
			{"op": "replace", "path": "/constraints/natura2000/earliest_cut_date_state_ordinance_2026", "value": "2025-06-15"},
		]),
		[{"op": "replace", "path": "/farm/year", "value": 2025}],
	)
	d := o6_23.decision with input as inp
	"cut_before_earliest_cut_date" in d.parcels.P1.obligation_violations
}

test_missing_earliest_cut_date if {
	inp := patch_p1([{"op": "replace", "path": "/constraints/natura2000/earliest_cut_date", "value": null}])
	d := o6_23.decision with input as inp
	"earliest_cut_date_missing" in d.parcels.P1.obligation_violations
}

test_minimum_grassland_management if {
	inp := patch_p1([
		{"op": "replace", "path": "/operations/cutting_dates", "value": []},
		{"op": "replace", "path": "/operations/full_area_grazed", "value": false},
	])
	d := o6_23.decision with input as inp
	"minimum_grassland_management_not_met" in d.parcels.P1.obligation_violations
}

test_full_grazing_meets_minimum_management if {
	inp := patch_p1([
		{"op": "replace", "path": "/operations/cutting_dates", "value": []},
		{"op": "replace", "path": "/operations/full_area_grazed", "value": true},
	])
	d := o6_23.decision with input as inp
	not "minimum_grassland_management_not_met" in d.parcels.P1.obligation_violations
}

test_use_frequency_mismatch_hint if {
	inp := patch_p1([{"op": "replace", "path": "/operations/cutting_dates", "value": ["2026-07-10", "2026-08-10", "2026-09-10"]}])
	d := o6_23.decision with input as inp
	d.parcels.P1.use_frequency_mismatch
	not d.parcels.P2.use_frequency_mismatch
}

# --- Kombinationen ---------------------------------------------------------

test_combination_with_heuwirtschaft_conflict if {
	inp := patch_p1([{"op": "replace", "path": "/oepul/measures", "value": ["23", "3"]}])
	d := o6_23.decision with input as inp
	d.parcels.P1.combination_conflicts == ["3"]
	not d.parcels.P1.premium_granted
}

test_combination_allowed_measures if {
	inp := patch_p1([{"op": "replace", "path": "/oepul/measures", "value": ["23", "1B_TB", "2", "18", "19"]}])
	d := o6_23.decision with input as inp
	d.parcels.P1.combination_conflicts == []
}

test_annex_l_row_23 if {
	o6_23.annex_l_combinable("18")
	o6_23.annex_l_combinable("1A")
	not o6_23.annex_l_combinable("17")
	not o6_23.annex_l_combinable("24")
}

test_annex_j_weide_chapter_conflict if {
	inp := patch_p1([{"op": "replace", "path": "/oepul/naturschutz_codes", "value": ["WA01", "LA01", "GB01"]}])
	d := o6_23.decision with input as inp
	d.parcels.P1.annex_j_conflicts == ["WA01"]
	not d.parcels.P1.premium_granted
}

test_annex_j_grosstrappe_alias_conflict if {
	inp := patch_p1([{"op": "replace", "path": "/oepul/naturschutz_codes", "value": ["TA01"]}])
	d := o6_23.decision with input as inp
	d.parcels.P1.annex_j_conflicts == ["TA01"]
}

# --- Obergrenzen, Modulation, Kürzungen ------------------------------------

test_cap_default if {
	inp := patch_p1([{"op": "replace", "path": "/oepul/other_area_payments_eur_per_ha", "value": 1100}])
	d := o6_23.decision with input as inp
	d.parcels.P1.cap_exceeded
	d.parcels.P1.capped_rate_eur_per_ha == 200
	d.parcels.P1.premium_eur == 400
}

test_cap_naturschutz if {
	inp := patch_p1([
		{"op": "replace", "path": "/oepul/other_area_payments_eur_per_ha", "value": 1100},
		{"op": "replace", "path": "/oepul/measures", "value": ["23", "18"]},
	])
	d := o6_23.decision with input as inp
	d.parcels.P1.capped_rate_eur_per_ha == 400
}

test_cap_2023 if {
	o6_23.cap_amount("default", 2023) == 1200
	o6_23.cap_amount("default", 2026) == 1300
	o6_23.cap_amount("naturschutz_or_ebw", 2024) == 1500
}

test_modulation_220_ha if {
	inp := patch_farm([{"op": "replace", "path": "/land/total_area_ha", "value": 220}])
	f := o6_23.modulation_factor with input as inp
	f > 0.9909
	f < 0.9910
}

test_modulation_1200_ha if {
	# (200*1 + 100*0,9 + 700*0,85 + 200*0,75) / 1200
	inp := patch_farm([{"op": "replace", "path": "/land/total_area_ha", "value": 1200}])
	f := o6_23.modulation_factor with input as inp
	f == 1035 / 1200
}

test_sanction_stage_5_percent if {
	inp := patch_farm([{"op": "replace", "path": "/farm/oepul/o6_23/content_violation_stage", "value": "5"}])
	d := o6_23.decision with input as inp
	d.sanction_reduction_percent == 5
	d.premium_eur == 1310.72
}

test_warning_before_2027_no_reduction if {
	inp := patch_farm([{"op": "replace", "path": "/farm/oepul/o6_23/content_violation_stage", "value": "warning"}])
	o6_23.sanction_reduction_percent == 0 with input as inp
}

test_warning_from_2027_one_percent if {
	inp := patch_farm([
		{"op": "replace", "path": "/farm/year", "value": 2027},
		{"op": "replace", "path": "/farm/oepul/o6_23/content_violation_stage", "value": "warning"},
	])
	o6_23.sanction_reduction_percent == 1 with input as inp
}

test_exclusion_after_two_full_reductions if {
	inp := patch_farm([{"op": "replace", "path": "/farm/oepul/o6_23/full_reductions_in_contract_period", "value": 2}])
	d := o6_23.decision with input as inp
	"excluded_from_measure" in d.farm_failures
}

test_payout_below_minimum if {
	small := json.patch(parcel_p2, [{"op": "replace", "path": "/area_ha", "value": 0.1}])
	inp := with_parcels([small])
	d := o6_23.decision with input as inp
	d.premium_eur == 35.1
	"payout_may_be_withheld_below_50_eur" in d.farm_findings
}

test_payment_due_and_advance if {
	d := o6_23.decision with input as base_input
	d.payment_due_by == "2027-06-30"
	adv := o6_23.advance_payment_max_eur with input as base_input

	# 75 % von 1.379,70 EUR = 1.034,775 EUR (Rundung auf Cent)
	adv >= 1034.77
	adv <= 1034.78
}

test_conditionality_finding if {
	inp := patch_farm([{"op": "replace", "path": "/farm/oepul/conditionality_compliant", "value": false}])
	d := o6_23.decision with input as inp
	"conditionality_not_complied" in d.farm_findings
}

# --- Biodiversitätsflächen-Anrechnung -------------------------------------

test_biodiversity_creditable_area if {
	d := o6_23.decision with input as base_input
	d.biodiversity_creditable_area_ha == 2
	d.parcels.P1.biodiversity_creditable
	not d.parcels.P2.biodiversity_creditable
}

test_biodiversity_divsz_missing if {
	inp := patch_p1([{"op": "replace", "path": "/constraints/natura2000/divsz_code_marked", "value": false}])
	d := o6_23.decision with input as inp
	"divsz_code_missing_on_cut_delay_parcel" in d.farm_findings
	d.biodiversity_creditable_area_ha == 0
}

test_biodiversity_divsz_without_cut_delay if {
	p2 := json.patch(parcel_p2, [{"op": "replace", "path": "/constraints/natura2000/divsz_code_marked", "value": true}])
	inp := with_parcels([parcel_p1, p2])
	d := o6_23.decision with input as inp
	"divsz_code_without_cut_delay" in d.farm_findings
}

# --- Maßnahmenübernahme ----------------------------------------------------

test_takeover_allowed if {
	inp := patch_farm([{"op": "replace", "path": "/farm/oepul/o6_23/takeover", "value": {"application_date": "2026-04-15", "taken_over_area_ha": 4, "additional_area_ha": 2}}])
	o6_23.takeover_allowed with input as inp
}

test_takeover_too_late_and_too_large if {
	inp := patch_farm([{"op": "replace", "path": "/farm/oepul/o6_23/takeover", "value": {"application_date": "2026-04-16", "taken_over_area_ha": 4, "additional_area_ha": 2.5}}])
	f := o6_23.takeover_failures with input as inp
	f == {"takeover_after_deadline", "takeover_expansion_above_50_percent"}
}

test_takeover_deadline_2028 if {
	o6_23.takeover_deadline(2028) == "2028-04-17"
	o6_23.takeover_deadline(2026) == "2026-04-15"
}
