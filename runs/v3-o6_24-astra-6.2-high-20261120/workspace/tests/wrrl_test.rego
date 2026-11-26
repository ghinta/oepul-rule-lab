package oepul.o6_24_test

import data.oepul.o6_24 as w
import rego.v1

parcel := {"parcel_id": "s1", "area_ha": 3, "land_use": "arable", "crop": {"crop_category": "cereal", "crop_name": "Winterweichweizen"}, "wrrl": {"zone_ha": 2, "claimed_correctly": true, "active_production": true, "increased_n_permit": false, "codes": [], "exclusions": []}}
app := {"application_for_year": 2027, "measure_application_date": "2026-12-31", "annual_mfa_submitted": true, "effective_withdrawal_date": null, "previous_contract_continuable": false, "takeover_approved": false}
person := {"legal_form": "legal_person", "public_share_pct": 25, "public_body_or_institution": false, "equivalent_or_indirect_public_control": false, "own_name_and_account": true, "control_of_declared_land": true, "active_farmer": true, "agricultural_activity": true}
profile := {"farm": {"year": 2027, "first_oepul_year": 2027, "applicant": person, "wrrl": app}, "land": {"parcels": [parcel], "minimum_size_eligible_at_ha": 3, "mfa_home_area_ha": 220}}
modify(p, changes) := object.union(p, {"wrrl": object.union(p.wrrl, changes)})
with_area(n) := modify(parcel, {"zone_ha": n})

test_gis_share_and_last_entry if {
	w.base_premium_eur == 108 with input as profile
	w.minimum_met with input as profile
	w.contract_status == "Antragsvoraussetzungen erfüllt" with input as profile
}

test_threshold_below if {
	w.contract_status == "Mindestfläche unterschritten" with input as profile with input.land.parcels as [with_area(1.9999)]
}

test_sum_only_arable_in_zone if {
	other := {"land_use": "grassland", "area_ha": 40}
	w.zone_arable_ha == 2 with input.land.parcels as [with_area(1), with_area(1), other, with_area(0)]
}

test_missing_layer_is_unknown if {
	w.decision.zone_arable_ha == null with input.land.parcels as [{"land_use": "arable", "area_ha": 4}]
	w.decision.base_premium_before_checks_eur == null with input as {}
}

test_inconsistent_layer if not w.zone_arable_ha with input.land.parcels as [with_area(4)]
test_late_application if {
	w.base_premium_eur == 0 with input as profile with input.farm.wrrl.measure_application_date as "2027-01-01"
}

test_exit_december_vs_january if {
	w.contract_status == "abgemeldet" with input as profile with input.farm.wrrl.effective_withdrawal_date as "2027-12-31"
	w.base_premium_eur == 108 with input as profile with input.farm.wrrl.effective_withdrawal_date as "2028-01-01"
}

test_no_new_entry_2028_but_renewal if {
	w.contract_status == "Neuantrag fehlt oder verspätet" with input as profile with input.farm.year as 2028
	w.contract_status == "Antragsvoraussetzungen erfüllt" with input as profile with input.farm.year as 2028 with input.farm.wrrl.previous_contract_continuable as true
}

test_mfa_missing_ends_payment if {
	w.base_premium_eur == 0 with input as profile with input.farm.wrrl.annual_mfa_submitted as false
}

test_permit_excludes_payment_but_area_still_managed if {
	p := modify(parcel, {"increased_n_permit": true})
	w.minimum_met with input.land.parcels as [p]
	w.base_premium_eur == 0 with input as profile with input.land.parcels as [p]
	w.permit_code_checks.s1 == false with input.land.parcels as [p]
	w.permit_code_checks.s1 with input.land.parcels as [modify(p, {"codes": ["OPWRRL"]})]
}

test_fallow_and_op if {
	w.base_area(object.union(parcel, {"crop": {"crop_category": "fallow"}})) == 0
	w.base_area(modify(parcel, {"codes": ["OP"]})) == 0
	w.base_area(modify(parcel, {"codes": ["OPBIO"]})) == 2
}

test_exclusions_and_missing_claim if {
	w.base_area(modify(parcel, {"exclusions": ["Rebschule"]})) == 0
	not w.base_area(modify(parcel, {"claimed_correctly": null}))
}

test_rates if {
	w.rate_eur_ha == 50 with input.farm.year as 2023
	w.rate_eur_ha == 54 with input.farm.year as 2024
	not w.rate_eur_ha with input.farm.year as 2022
}

mixed := modify(parcel, {"zone_ha": 1, "segments": [{"area_ha": 0.70, "gis_class": "D"}, {"area_ha": 0.30, "gis_class": "B"}], "class_limits": [{"class": "D", "kg_ha": 144}, {"class": "B", "kg_ha": 108}], "annual_effective_n_kg_ha": 133.2})

test_mixed_class_exact_weight if {
	w.weighted_limit(mixed) == 133.2
	w.nitrogen_checks.s1.within_limit with input.land.parcels as [mixed]
	w.nitrogen_checks.s1.within_limit == false with input.land.parcels as [modify(mixed, {"annual_effective_n_kg_ha": 134})]
}

test_unassigned_uses_c_missing_does_not if {
	w.effective_class({"gis_class": null}) == "C"
	not w.effective_class({})
	w.weighted_limit(modify(mixed, {"segments": [{"area_ha": 1, "gis_class": null}], "class_limits": [{"class": "C", "kg_ha": 120}]})) == 120
}

test_missing_external_rates_or_incomplete_coverage if {
	not w.weighted_limit(modify(mixed, {"class_limits": []}))
	not w.weighted_limit(modify(mixed, {"zone_ha": 2}))
	not w.weighted_limit(modify(mixed, {"class_limits": [{"class": "D", "kg_ha": 144}, {"class": "D", "kg_ha": 145}, {"class": "B", "kg_ha": 108}]}))
}

test_split_claim_and_records_both_required if {
	p := modify(parcel, {"higher_class_separate_application": true, "subplots_claimed_separately": true, "subplots_recorded_separately": false})
	w.split_checks.s1 == false with input.land.parcels as [p]
	w.split_checks.s1 with input.land.parcels as [modify(p, {"subplots_recorded_separately": true})]
}

test_window_endpoints_and_outside if {
	win := [{"start": "2026-04-01", "end": "2026-05-01"}]
	w.event_result({"date": "2026-05-01", "allowed_windows": win}) with input.farm.year as 2026
	w.event_result({"date": "2026-04-01", "allowed_windows": win}) with input.farm.year as 2026
	w.event_result({"date": "2026-05-02", "allowed_windows": win}) == false with input.farm.year as 2026
	not w.event_result({"date": "2026-02-30", "allowed_windows": win}) with input.farm.year as 2026
}

test_no_fertilizer_still_requires_records if {
	p := modify(parcel, {"n_applications": [], "section5_record": false})
	w.period_checks.s1 with input.land.parcels as [p]
	w.record_checks.s1 == false with input.land.parcels as [p]
}

test_book_at_farm_independent_of_keeping if {
	w.book_checks == {"section5_book_kept": true, "book_on_farm": false} with input.documentation as {"section5_book_kept": true, "book_on_farm": false}
}

dry := modify(parcel, {"state": "Steiermark", "district": "Leibnitz", "usual_late_summer_or_autumn_harvest": true, "crop_sensitive_to_heat_and_drought": true, "no_harvestable_crop_due_to_drought": true, "is_arable_forage": false, "sown_properly": true, "maintained_annually": true, "harvest_force_majeure_approved": false, "harvested_and_removed_pct": 0})

test_august_extension if {
	w.management_checks.s1 == "erfüllt" with input.land.parcels as [dry] with input.farm.year as 2026
	not w.automatic_drought(dry) with input.farm.year as 2025
	not w.automatic_drought(modify(dry, {"district": "Murau"})) with input.farm.year as 2026
	not w.automatic_drought(modify(dry, {"usual_late_summer_or_autumn_harvest": false})) with input.farm.year as 2026
}

test_harvest_and_unknown_evidence if {
	w.management_checks.s1 == "verletzt" with input.farm.year as 2025 with input.land.parcels as [modify(dry, {"harvested_and_removed_pct": 84.99})]
	w.management_checks.s1 == "erfüllt" with input.farm.year as 2025 with input.land.parcels as [modify(dry, {"harvested_and_removed_pct": 85})]
	w.management_checks.s1 == "offen" with input.land.parcels as [parcel]
}

test_all_districts_and_explicit_list if {
	w.automatic_drought(modify(dry, {"state": "Burgenland", "district": "Güssing"})) with input.farm.year as 2026
	not w.automatic_drought(modify(dry, {"state": "Oberösterreich", "district": "Gmunden"})) with input.farm.year as 2026
}

test_matrix_every_row_and_wrrl_positives if {
	rows := data.wrrl_tables.combination_matrix
	measures := {"1A", "1B", "1C", "2", "3", "4", "6", "7", "8", "9", "10", "11", "12", "13", "14", "16", "17", "18", "19", "23", "24"}
	count(rows) == 21
	{row.measure | some row in rows} == measures
	every row in rows {
		object.keys(row.cells) == measures
		every column, mark in row.cells { mark == w.matrix_cell(column, row.measure) }
	}
	{b | some b in measures; w.matrix_cell("24", b) == "x"} == {"1A", "1B", "2", "3", "6", "7", "8", "9", "16"}
}

test_parcel_cap_uses_payment_contributions if {
	rows := [
		{"parcel_id": "s1", "measure": "24", "eur_ha": 54},
		{"parcel_id": "s1", "measure": "2", "eur_ha": 1250},
		{"parcel_id": "s1", "measure": "6", "eur_ha": 200},
		{"parcel_id": "s2", "measure": "2", "eur_ha": 300},
	]
	w.parcel_cap_checks.s1 == {"subject_eur_ha": 1304, "ceiling_eur_ha": 1300, "excess_eur_ha": 4} with input as profile with input.farm.payment.parcel_contributions as rows
}

test_special_areas if {
	p := modify(parcel, {"other_measures": ["8", "1A", "18", "K20", "16"], "baw": true, "ag": false, "protected_pot_or_substrate": false})
	w.combination_checks.s1 == {"8": "ausgeschlossen", "1A": "kombinierbar", "18": "ausgeschlossen", "K20": "ausgeschlossen", "16": "kombinierbar"} with input.land.parcels as [p]
}

test_modulation_boundary_values if {
	w.modulation_factor == 1 with input.land.mfa_home_area_ha as 200
	round(w.modulation_factor * 10000) == 9909 with input as profile
	w.modulation_factor == 0.8625 with input.land.mfa_home_area_ha as 1200
}

test_warning_transition_and_caps if {
	w.sanction_schedule.Verwarnstufe == 0 with input.farm.year as 2026
	w.sanction_schedule.Verwarnstufe == 1 with input.farm.year as 2027
	amts := [{"measure": "24", "eur_ha": 54}, {"measure": "10", "eur_ha": 1250}, {"measure": "1C", "eur_ha": 100}]
	w.standard_cap(amts).excess_eur_ha == 4 with input.farm.year as 2025
	w.standard_cap(amts).excess_eur_ha == 0 with input.farm.year as 2024
}

test_takeover_april_and_area_limit if {
	w.takeover_window with input.farm.year as 2028 with input.farm.wrrl.takeover_date as "2028-04-17"
	not w.takeover_window with input.farm.year as 2026 with input.farm.wrrl.takeover_date as "2026-04-16"
	w.takeover_area_ok with input.farm.wrrl as {"takeover_original_ha": 2, "takeover_extension_ha": 1}
	w.takeover_area_ok == false with input.farm.wrrl as {"takeover_original_ha": 2, "takeover_extension_ha": 1.01}
}

test_applicant_and_first_year if {
	w.applicant_ok with input as profile
	not w.applicant_ok with input as profile with input.farm.applicant.public_share_pct as 25.01
	not w.applicant_ok with input as profile with input.farm.applicant.equivalent_or_indirect_public_control as true
	w.size_ok with input as profile with input.land as {"protected_cultivation_at_ha": 0.5}
	not w.size_ok with input as profile with input.land as {"protected_cultivation_at_ha": 0.49, "minimum_size_eligible_at_ha": 1.49}
}

test_crop_lists if {
	"Feldgemüse" in w.crop_groups("Pak Choi") with input.farm.year as 2023
	"Obst" in w.crop_groups("Papau") with input.farm.year as 2025
	w.crop_groups("Papau") == set() with input.farm.year as 2024
}

test_applicant_refusal_zero_vs_missing if {
	w.decision.base_premium_before_checks_eur == 0 with input as profile with input.farm.applicant.public_body_or_institution as true
	w.decision.base_premium_before_checks_eur == null with input as profile with input.farm.applicant as {}
}

test_known_zero_area_and_area_unknown if {
	w.decision.zone_arable_ha == 0 with input.land.parcels as []
	w.decision.zone_arable_ha == null with input as {}
}

test_differing_contract_groups if {
	w.term_group("24") == "einjährig"
	not w.multiyear_loss_tolerance("24", 30)
	w.multiyear_loss_tolerance("1A", 30) == 1.5
	w.multiyear_term("1B", "2024-01-01").years == 5
	w.growth_limited("24") == false
	w.switch_targets("24") == set() with input.farm.year as 2025
}

test_notice_limits_and_discretion if {
	w.max_advance_eur == 75 with input.farm.payment as {"expected_total_eur": 100, "administrative_checks_complete": true}
	not w.max_advance_eur with input.farm.payment as {"expected_total_eur": 100, "administrative_checks_complete": false}
	w.small_payment_discretion with input.farm.payment.final_total_eur as 50
	not w.small_payment_discretion with input.farm.payment.final_total_eur as 50.01
	w.payment_deadline == "2028-06-30" with input.farm.year as 2027
}

test_second_full_reduction_same_term if {
	w.sanction_outcome.exclude_and_recover with input.farm.payment.hundred_pct_reductions_same_contract as 2
	w.sanction_outcome.reduction_pct == 1 with input.farm.year as 2027 with input.farm.payment as {"assessed_level": "Verwarnstufe", "hundred_pct_reductions_same_contract": 0}
}

test_controls_and_nonharvest_codes if {
	w.exit_before_control with input.farm.wrrl as {"proposed_exit_date": "2026-07-11", "control_cutoffs": ["2026-07-12"]}
	not w.exit_before_control with input.farm.wrrl as {"proposed_exit_date": "2026-07-13", "control_cutoffs": ["2026-07-12"]}
	w.combo_correction_available with input.farm.wrrl as {"impossible_combination_found": true, "control_objection": false, "payout_notice_received": false}
	w.harvest_op_action(modify(parcel, {"harvest_duty_unmet": true, "intercrop_variant_established": true})) == "flächenbezogene OP-Codes; kein OPZWF"
}

test_trial_and_transfer_suppress_base if {
	p := modify(parcel, {"trial": {"approved_by_ministry": true, "prevents_compliance": true, "written_approval_on_farm": true, "type_area_location_recorded": true}})
	w.trial_documents(p) == false
	w.base_area(p) == 0
	w.trial_documents(modify(p, {"codes": ["VF"]}))
	q := modify(parcel, {"transfer": {"occurred_during_year": true, "successor_complies_to_year_end": false, "same_or_higher_measure": true}})
	w.base_area(q) == 0
}

test_conditionality_and_notification if {
	w.conditionality_for_full_payment == false with input.farm.conditionality as {"standards_met": true, "social_standards_met": false}
	w.incident_action(modify(parcel, {"incident": {"third_party_solely_responsible": false, "mfa_code_corrected": false, "reported_to_ama": false}})) == "Codekorrektur oder Selbstanzeige erforderlich"
}

test_weighted_payment_scenario if {
	result := w.decision with input as profile
	round(result.modulated_tariff_before_other_adjustments_eur * 100) == 10702
}

test_crops_and_mixture if {
	"Obst" in w.crop_groups("Brombeere") with input.farm.year as 2026
	"Feldgemüse" in w.crop_groups("Tomaten") with input.farm.year as 2025
	w.mixture_excluded_as_grain({"crop": {"mixture_grain_pct": 49.9}})
	not w.mixture_excluded_as_grain({"crop": {"mixture_grain_pct": 50}})
}

test_matrix_legend_and_footnotes if {
	w.matrix_terms("1B", "16") == "kombinierbar mit Prämienabschlag"
	w.matrix_terms("1A", "4") == "nur Abgeltung der Landschaftselemente"
	w.matrix_terms("10", "12") == "kombinierbar; bei Zuschlag Einsatz von Organismen mit Prämienabschlag"
	w.matrix_terms("24", "18") == "keine gemeinsame Flächenprämie"
	w.matrix_terms("24", "24") == "dieselbe Maßnahme"
	not w.matrix_terms("24", "unbekannt")
}
