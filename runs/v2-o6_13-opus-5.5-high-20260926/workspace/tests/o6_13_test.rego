package oepul.o6_13_test

import data.oepul.o6_13

# ---------------------------------------------------------------------------
# Testfixtures
# ---------------------------------------------------------------------------
base_application := {
	"date": "2026-04-10",
	"organism_species": "Encarsia formosa",
	"quantity": 5000,
	"quantity_unit": "Stück",
	"purchase_receipt_available": true,
	"reason": "Befall mit Weißer Fliege",
	"target": "Bekämpfung Weiße Fliege an Tomaten",
	"listed_in_psm_register": true,
	"applied_at_register_rate": true,
	"replaces_psm_use": true,
	"covers_entire_area": true,
	"use_type": "plant_protection",
}

base_parcel := {
	"parcel_id": "P1",
	"area_ha": 0.8,
	"land_use": "special_crop",
	"oepul_codes": ["NUE"],
	"protected_cultivation": {
		"structure_type": "fixed_greenhouse",
		"covering_material": "glass",
		"growing_system": "grown_soil",
		"field_use_type": "A",
		"sales_area_ha": 0.05,
	},
	"minimum_management": {"properly_cultivated": true, "annual_care": true, "harvested_share_percent": 95},
	"beneficial_organism_applications": [base_application],
}

base_input := {
	"farm": {
		"farm_id": "F1",
		"year": 2026,
		"region": {"federal_state": "Tirol", "district": "Innsbruck-Land"},
		"applicant": {
			"legal_form": "natural_person",
			"is_public_body": false,
			"is_active_farmer": true,
			"has_agricultural_activity": true,
			"farms_in_own_name_and_account": true,
			"has_control_over_declared_areas": true,
		},
		"oepul": {
			"first_participation_year": 2024,
			"o6_13": {
				"entry_year": 2025,
				"measure_application_date": "2024-11-20",
				"contract_active_previous_year": true,
				"nue_used_previous_year": true,
				"mfa_submitted_previous_year": true,
				"member_of_producer_organisation_with_op_covering_organisms": false,
			},
		},
	},
	"land": {"total_area_ha": 150, "parcels": [base_parcel]},
}

with_parcel(overrides) := object.union(base_input, {"land": {"parcels": [object.union(base_parcel, overrides)]}})

with_farm(overrides) := object.union(base_input, {"farm": overrides})

with_state(overrides) := object.union(base_input, {"farm": {"oepul": {"o6_13": overrides}}})

with_application(overrides) := with_parcel({"beneficial_organism_applications": [object.union(base_application, overrides)]})

issue_rule_ids(inp) := {i.rule_id | some i in o6_13.parcel_issues with input as inp}

access_rule_ids(inp) := {f.rule_id | some f in o6_13.access_failures with input as inp}

contract_rule_ids(inp) := {f.rule_id | some f in o6_13.contract_failures with input as inp}

# ---------------------------------------------------------------------------
# Grundfall, Prämie, Obergrenze, Modulation
# ---------------------------------------------------------------------------
test_base_case_eligible if {
	d := o6_13.decision with input as base_input
	d.eligible == true
	d.access_requirements_met == true
	d.contract.in_force == true
	d.premium.eligible_area_ha == 0.75
	d.premium.gross_eur == 1620
	d.premium.net_eur == 1620
}

test_premium_rate_2023_and_from_2024 if {
	o6_13.premium_rate("A", 2023) == 2000
	o6_13.premium_rate("GA", 2023) == 2000
	o6_13.premium_rate("A", 2024) == 2160
	o6_13.premium_rate("GA", 2026) == 2160
}

test_area_payment_cap_equals_rate if {
	o6_13.area_payment_cap(2023) == 2000
	o6_13.area_payment_cap(2025) == 2160
	o6_13.capped_rate("GA", 2024) == 2160
}

test_premium_2023_uses_2000 if {
	inp := object.union(with_farm({"year": 2023, "oepul": {"o6_13": {"entry_year": 2023, "measure_application_date": "2022-12-15"}}}), {"land": {"parcels": [object.union(base_parcel, {"beneficial_organism_applications": [object.union(base_application, {"date": "2023-05-01"})]})]}})
	d := o6_13.decision with input as inp
	d.premium.gross_eur == 1500
}

test_modulation_example_220_ha if {
	round(o6_13.modulation_factor(220) * 10000) == 9909
}

test_modulation_below_200_ha if {
	o6_13.modulation_factor(150) == 1
}

test_modulation_large_farm if {
	round(o6_13.modulation_factor(1500) * 10000) == 8400
}

test_modulation_applied_to_net_premium if {
	inp := object.union(base_input, {"land": {"total_area_ha": 220}})
	d := o6_13.decision with input as inp
	d.premium.net_eur == 1605.27
}

test_payment_deadline_and_advance if {
	d := o6_13.decision with input as base_input
	d.premium.payment_deadline == "2027-06-30"
	d.premium.max_advance_payment_eur == 1215
}

test_minor_amount_threshold if {
	inp := with_parcel({"area_ha": 0.02, "protected_cultivation": {"sales_area_ha": 0}})
	d := o6_13.decision with input as inp
	d.premium.net_eur == 43.2
	d.premium.may_be_withheld_as_minor_amount == true
}

# ---------------------------------------------------------------------------
# Zugangsvoraussetzungen
# ---------------------------------------------------------------------------
test_operational_programme_excludes if {
	inp := with_state({"member_of_producer_organisation_with_op_covering_organisms": true})
	"O6_13-ACC-01" in access_rule_ids(inp)
	d := o6_13.decision with input as inp
	d.eligible == false
	d.no_contract_due_to_access_failure == true
}

test_minimum_participation_requires_creditable_use if {
	inp := with_application({"replaces_psm_use": false})
	"O6_13-ACC-02" in access_rule_ids(inp)
	v := {x.rule_id | some x in o6_13.obligation_violations with input as inp}
	"O6_13-OBL-01" in v
}

test_public_body_not_eligible if {
	inp := with_farm({"applicant": {"is_public_body": true}})
	"O6_13-GEN-APPL-03" in access_rule_ids(inp)
}

test_legal_person_public_share_above_25 if {
	inp := with_farm({"applicant": {"legal_form": "legal_person", "public_body_share_percent": 30}})
	"O6_13-GEN-APPL-02" in access_rule_ids(inp)
}

test_legal_person_public_share_25_ok if {
	inp := with_farm({"applicant": {"legal_form": "legal_person", "public_body_share_percent": 25}})
	not "O6_13-GEN-APPL-02" in access_rule_ids(inp)
}

test_unknown_legal_form if {
	inp := with_farm({"applicant": {"legal_form": "foundation_abroad"}})
	"O6_13-GEN-APPL-01" in access_rule_ids(inp)
}

test_not_active_farmer if {
	inp := with_farm({"applicant": {"is_active_farmer": false}})
	"O6_13-GEN-APPL-04" in access_rule_ids(inp)
}

test_minimum_farm_size_first_year_failed if {
	inp := object.union(with_farm({"oepul": {"first_participation_year": 2026}}), {"land": {"total_area_ha": 1.0, "protected_cultivation_area_ha": 0.3}})
	"O6_13-GEN-SIZE-01" in access_rule_ids(inp)
}

test_minimum_farm_size_protected_half_hectare if {
	inp := object.union(with_farm({"oepul": {"first_participation_year": 2026}}), {"land": {"total_area_ha": 0.5, "protected_cultivation_area_ha": 0.5}})
	not "O6_13-GEN-SIZE-01" in access_rule_ids(inp)
}

test_minimum_farm_size_total_with_additional_area if {
	inp := object.union(with_farm({"oepul": {"first_participation_year": 2026}}), {"land": {"total_area_ha": 1.0, "minimum_size_additional_area_ha": 0.5, "protected_cultivation_area_ha": 0.3}})
	not "O6_13-GEN-SIZE-01" in access_rule_ids(inp)
}

test_minimum_farm_size_not_required_after_first_year if {
	inp := object.union(base_input, {"land": {"total_area_ha": 0.2, "protected_cultivation_area_ha": 0.2}})
	not "O6_13-GEN-SIZE-01" in access_rule_ids(inp)
}

# ---------------------------------------------------------------------------
# Nützlingseinsatz und Aufzeichnungen
# ---------------------------------------------------------------------------
test_bumblebees_not_creditable if {
	inp := with_application({"use_type": "bumblebee_pollination"})
	"O6_13-SCOPE-01" in issue_rule_ids(inp)
	some a in o6_13.non_creditable_applications with input as inp
	"O6_13-OBL-03: Hummelvölker für die Bestäubung sind nicht anrechenbar" in a.reasons
}

test_not_in_psm_register_not_creditable if {
	inp := with_application({"listed_in_psm_register": false})
	not o6_13.creditable_application(object.union(base_application, {"listed_in_psm_register": false})) with input as inp
	"O6_13-SCOPE-01" in issue_rule_ids(inp)
}

test_application_outside_year_not_creditable if {
	inp := with_application({"date": "2025-10-01"})
	"O6_13-SCOPE-01" in issue_rule_ids(inp)
}

test_not_full_coverage if {
	inp := with_application({"covers_entire_area": false})
	some i in o6_13.parcel_issues with input as inp
	i.rule_id == "O6_13-SCOPE-01"
	i.message == "Nützlingseinsatz nicht flächendeckend auf dem Schlag"
}

test_records_incomplete if {
	inp := with_application({"reason": "", "purchase_receipt_available": false})
	v := {x.rule_id | some x in o6_13.obligation_violations with input as inp}
	"O6_13-DOC-01" in v
	not o6_13.records_complete with input as inp
}

test_records_complete_base if {
	o6_13.records_complete with input as base_input
}

# ---------------------------------------------------------------------------
# Teilnahmefähige Flächen und Nutzungsart
# ---------------------------------------------------------------------------
test_open_field_not_eligible if {
	inp := with_parcel({"protected_cultivation": {"structure_type": "none"}})
	"O6_13-ELIG-01" in issue_rule_ids(inp)
}

test_fixed_greenhouse_requires_cover if {
	inp := with_parcel({"protected_cultivation": {"covering_material": "none"}})
	"O6_13-ELIG-01" in issue_rule_ids(inp)
}

test_unfixed_foil_tunnel_eligible if {
	inp := with_parcel({"protected_cultivation": {"structure_type": "unfixed_foil_tunnel"}})
	not "O6_13-ELIG-01" in issue_rule_ids(inp)
}

test_non_eligible_parts_are_subtracted if {
	inp := with_parcel({"area_ha": 1.0, "protected_cultivation": {"sales_area_ha": 0.1, "display_area_ha": 0.05, "storage_area_ha": 0.05, "unused_area_between_structures_ha": 0.1, "necessary_path_area_ha": 0.08}})
	d := o6_13.decision with input as inp
	d.premium.eligible_area_ha == 0.7
}

test_grown_soil_must_be_a if {
	inp := with_parcel({"protected_cultivation": {"field_use_type": "GA"}})
	"O6_13-APP-05" in issue_rule_ids(inp)
}

test_substrate_must_be_ga if {
	inp := with_parcel({"protected_cultivation": {"growing_system": "substrate", "field_use_type": "GA"}})
	count(issue_rule_ids(inp)) == 0
}

test_alternating_uses_april_first if {
	bad := with_parcel({"protected_cultivation": {"growing_system": "alternating", "growing_system_on_april_1": "pots", "field_use_type": "A"}})
	"O6_13-APP-06" in issue_rule_ids(bad)
	good := with_parcel({"protected_cultivation": {"growing_system": "alternating", "growing_system_on_april_1": "pots", "field_use_type": "GA"}})
	count(issue_rule_ids(good)) == 0
}

test_field_use_type_must_be_a_or_ga if {
	inp := with_parcel({"protected_cultivation": {"field_use_type": "G"}})
	"O6_13-APP-04" in issue_rule_ids(inp)
}

test_parcel_without_nue_code_not_considered if {
	inp := with_parcel({"oepul_codes": []})
	d := o6_13.decision with input as inp
	d.eligible == false
	d.contract.lapses_after_year == true
	count(d.parcels) == 0
}

test_nursery_not_eligible if {
	inp := with_parcel({"area_type": "tree_nursery"})
	"O6_13-GEN-NE-01" in issue_rule_ids(inp)
}

test_other_protected_area_not_eligible if {
	inp := with_parcel({"protected_cultivation": {"is_other_protected_area": true}})
	"O6_13-GEN-NE-01" in issue_rule_ids(inp)
}

test_outside_austria if {
	inp := with_parcel({"located_in_austria": false})
	"O6_13-GEN-LOC-01" in issue_rule_ids(inp)
}

test_national_park_neusiedler_see_excluded if {
	inp := with_parcel({"national_park": "Neusiedler See"})
	"O6_13-GEN-NP-01" in issue_rule_ids(inp)
}

test_national_park_kalkalpen_without_restrictions_ok if {
	inp := with_parcel({"national_park": "Kalkalpen", "national_park_relevant_restrictions": false})
	not "O6_13-GEN-NP-01" in issue_rule_ids(inp)
}

test_other_national_park_with_restrictions_excluded if {
	inp := with_parcel({"national_park": "Hohe Tauern", "national_park_relevant_restrictions": true})
	"O6_13-GEN-NP-01" in issue_rule_ids(inp)
}

test_op_code_no_premium if {
	inp := with_parcel({"oepul_codes": ["NUE", "OP"]})
	"O6_13-GEN-OP-01" in issue_rule_ids(inp)
	d := o6_13.decision with input as inp
	d.premium.gross_eur == 0
}

test_measure_specific_op_code if {
	inp := with_parcel({"op_measure_codes": ["o6_13"]})
	"O6_13-GEN-OP-01" in issue_rule_ids(inp)
}

test_vf_code_no_premium if {
	inp := with_parcel({"oepul_codes": ["NUE", "VF"]})
	"O6_13-GEN-VF-01" in issue_rule_ids(inp)
}

test_third_party_fault_no_premium if {
	inp := with_parcel({"non_compliance_due_to_third_party_fault": true})
	"O6_13-GEN-OP-02" in issue_rule_ids(inp)
}

test_double_funding if {
	inp := with_parcel({"funding_overlap": {"other_public_funding_same_service": true}})
	"O6_13-GEN-DBL-01" in issue_rule_ids(inp)
}

test_transfer_without_continuation if {
	inp := with_parcel({"transfer": {"transferred_during_year": true, "successor_continues_same_or_higher_measure": false}})
	"O6_13-GEN-DUR-02" in issue_rule_ids(inp)
}

test_transfer_with_continuation_ok if {
	inp := with_parcel({"transfer": {"transferred_during_year": true, "successor_continues_same_or_higher_measure": true}})
	not "O6_13-GEN-DUR-02" in issue_rule_ids(inp)
}

# ---------------------------------------------------------------------------
# Kombination (Anhang L)
# ---------------------------------------------------------------------------
test_no_combination_on_single_parcel if {
	inp := with_parcel({"other_measures_on_parcel": ["o6_1a"]})
	"O6_13-COMB-01" in issue_rule_ids(inp)
}

test_anhang_l_row_13_empty if {
	every other in ["1A", "1B", "1C", "2", "3", "4", "6", "7", "8", "9", "10", "11", "12", "14", "16", "17", "18", "19", "23", "24"] {
		not o6_13.combinable_on_single_parcel("13", other)
	}
}

test_anhang_l_other_cells_present if {
	o6_13.combinable_on_single_parcel("1A", "2")
	o6_13.combinable_on_single_parcel("24", "16")
	not o6_13.combinable_on_single_parcel("1A", "1B")
}

# ---------------------------------------------------------------------------
# Mindestbewirtschaftung, Dürre 2026
# ---------------------------------------------------------------------------
test_harvest_below_85_percent if {
	inp := with_parcel({"minimum_management": {"harvested_share_percent": 80}})
	"O6_13-GEN-MBK-01" in issue_rule_ids(inp)
	"P1" in o6_13.force_majeure_application_required with input as inp
}

test_harvest_exactly_85_percent_ok if {
	inp := with_parcel({"minimum_management": {"harvested_share_percent": 85}})
	not "O6_13-GEN-MBK-01" in issue_rule_ids(inp)
}

drought_parcel := {
	"minimum_management": {"harvested_share_percent": 0},
	"drought": {"no_harvestable_crop_due_to_drought": true, "crop_usually_harvested_late_summer_or_autumn": true},
}

test_drought_2026_listed_district_waives_harvest if {
	inp := object.union(with_parcel(drought_parcel), {"farm": {"region": {"federal_state": "Niederösterreich", "district": "Tulln"}}})
	not "O6_13-GEN-MBK-01" in issue_rule_ids(inp)
	count(o6_13.force_majeure_application_required) == 0 with input as inp
}

test_drought_2026_steiermark_extension if {
	inp := object.union(with_parcel(drought_parcel), {"farm": {"region": {"federal_state": "Steiermark", "district": "Leibnitz"}}})
	not "O6_13-GEN-MBK-01" in issue_rule_ids(inp)
}

test_drought_2026_burgenland_all_districts if {
	inp := object.union(with_parcel(drought_parcel), {"farm": {"region": {"federal_state": "Burgenland", "district": "Oberwart"}}})
	not "O6_13-GEN-MBK-01" in issue_rule_ids(inp)
}

test_drought_not_listed_district if {
	inp := object.union(with_parcel(drought_parcel), {"farm": {"region": {"federal_state": "Steiermark", "district": "Liezen"}}})
	"O6_13-GEN-MBK-01" in issue_rule_ids(inp)
}

test_drought_only_2026 if {
	inp := object.union(with_parcel(drought_parcel), {"farm": {"year": 2025, "region": {"federal_state": "Niederösterreich", "district": "Tulln"}}})
	not o6_13.drought_2026_harvest_exemption(object.union(base_parcel, drought_parcel)) with input as inp
}

test_force_majeure_recognised_waives_harvest if {
	inp := with_parcel({"minimum_management": {"harvested_share_percent": 10}, "force_majeure_recognised": true})
	not "O6_13-GEN-MBK-01" in issue_rule_ids(inp)
}

# ---------------------------------------------------------------------------
# Vertrag, Beantragung, Ausstieg
# ---------------------------------------------------------------------------
test_is_one_year_measure if {
	o6_13.is_one_year_measure
	d := o6_13.decision with input as base_input
	d.contract.period.start == "2026-01-01"
	d.contract.period.end == "2026-12-31"
}

test_new_entry_2027_valid if {
	inp := with_farm({"year": 2027, "oepul": {"o6_13": {"entry_year": 2027, "measure_application_date": "2026-12-31"}}})
	o6_13.new_entry_valid with input as inp
}

test_entry_after_2027_not_possible if {
	inp := with_farm({"year": 2028, "oepul": {"o6_13": {"entry_year": 2028, "measure_application_date": "2027-12-01"}}})
	"O6_13-APP-02" in contract_rule_ids(inp)
}

test_late_application if {
	inp := with_farm({"year": 2027, "oepul": {"o6_13": {"entry_year": 2027, "measure_application_date": "2027-01-05"}}})
	"O6_13-APP-01" in contract_rule_ids(inp)
	not o6_13.contract_in_force with input as inp
}

test_contract_lapsed_without_nue_previous_year if {
	inp := with_state({"nue_used_previous_year": false})
	"O6_13-CON-03" in contract_rule_ids(inp)
	not o6_13.contract_in_force with input as inp
}

test_reentry_after_mfa_not_submitted if {
	inp := with_state({"mfa_submitted_previous_year": false})
	"O6_13-APP-07" in contract_rule_ids(inp)
}

test_new_application_deadline_after_lapse if {
	d := o6_13.decision with input as base_input
	d.contract.new_application_deadline_for_next_year == "2026-12-31"
}

test_withdrawal_during_year_invalidates_year if {
	inp := with_state({"withdrawal": {"declared_date": "2026-03-01", "declared_online_in_mfa": true}})
	"O6_13-EXIT-03" in contract_rule_ids(inp)
	d := o6_13.decision with input as inp
	d.contract.in_force == false
	d.premium.net_eur == 0
	d.contract.earliest_withdrawal_without_loss == "2027-01-01"
}

test_withdrawal_after_on_site_check_announcement_inadmissible if {
	inp := with_state({"on_site_check_announced_date": "2026-02-01", "withdrawal": {"declared_date": "2026-03-01", "declared_online_in_mfa": true}})
	f := {x.rule_id | some x in o6_13.withdrawal_findings with input as inp}
	"O6_13-EXIT-05" in f
	o6_13.contract_in_force with input as inp
}

test_no_conversion_for_o6_13 if {
	d := o6_13.decision with input as base_input
	d.contract.conversion_available == false
	count(o6_13.conversion_targets("o6_1a")) == 1
}

test_takeover_deadlines if {
	o6_13.takeover_deadline(2026) == "2026-04-15"
	o6_13.takeover_deadline(2028) == "2028-04-17"
	o6_13.takeover_deadline(2023) == "2023-04-17"
}

test_takeover_late_and_extension if {
	inp := with_state({"takeover": {"request_date": "2026-04-20", "taken_over_area_ha": 1.0, "extension_to_other_areas_ha": 0.6}})
	f := [x.message | some x in o6_13.takeover_findings with input as inp]
	count(f) == 2
}

test_takeover_not_individual_case_only if {
	not o6_13.takeover_only_in_individual_cases
}

# ---------------------------------------------------------------------------
# Kürzungen
# ---------------------------------------------------------------------------
test_reduction_10_percent if {
	inp := with_state({"compliance": {"sanction_stage": "reduction_10"}})
	d := o6_13.decision with input as inp
	d.premium.content_reduction_percent == 10
	d.premium.net_eur == 1458
}

test_warning_no_reduction_before_2027 if {
	inp := with_state({"compliance": {"sanction_stage": "warning"}})
	o6_13.content_reduction_percent == 0 with input as inp
}

test_warning_one_percent_from_2027 if {
	inp := object.union(with_state({"compliance": {"sanction_stage": "warning"}}), {"farm": {"year": 2027}})
	o6_13.content_reduction_percent == 1 with input as inp
}

test_exclusion_after_two_full_reductions if {
	inp := with_state({"compliance": {"sanction_stage": "reduction_100", "hundred_percent_reductions_in_contract_period": 2}})
	d := o6_13.decision with input as inp
	d.sanction.exclusion_and_recovery == true
	d.eligible == false
	d.premium.net_eur == 0
}
