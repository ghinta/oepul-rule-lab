# Tests der betriebsbezogenen Bedingungen, Prämienberechnung und 2026-Festlegungen von o6_6.
package oepul.o6_6_test

import data.oepul.o6_6

patch(inp, path, value) := json.patch(inp, [{"op": "add", "path": path, "value": value}])

test_min_arable_area_1_5_ha if {
	inp := patch(base_input, "/land/arable_area_ha", 1.49)
	o6_6.contract_lapses with input as inp
	not o6_6.farm_premium_eligible with input as inp
	o6_6.decision.net_premium_min_eur == 0 with input as inp
	not o6_6.contract_lapses with input as patch(base_input, "/land/arable_area_ha", 1.5)
}

test_contract_lapses_without_greened_parcel if {
	inp := patch(base_input, "/land/parcels", [{"parcel_id": "X", "area_ha": 5, "land_use": "arable"}])
	some r in o6_6.contract_lapse_reasons with input as inp
	r.rule_id == "O6_6-CONTRACT-LAPSE"
}

test_first_year_farm_min_size if {
	inp := patch(patch(patch(base_input, "/farm/oepul/first_participation_year", 2026), "/land/total_area_ha", 1.4), "/land/arable_area_ha", 1.4)
	"O6_6-GEN-FARM-MIN-SIZE" in farm_violation_ids(inp)
	ok := patch(patch(patch(base_input, "/farm/oepul/first_participation_year", 2026), "/land/total_area_ha", 1.4), "/land/protected_cultivation_area_ha", 0.5)
	not "O6_6-GEN-FARM-MIN-SIZE" in farm_violation_ids(ok)
}

test_public_body_allowed_for_o6_6 if {
	inp := patch(base_input, "/farm/applicant", {"legal_form": "public_body", "is_active_farmer": true})
	not "O6_6-GEN-APPLICANT" in farm_violation_ids(inp)
	inp2 := patch(base_input, "/farm/applicant", {"legal_form": "legal_person", "public_body_share_percent": 60, "is_active_farmer": true})
	not "O6_6-GEN-APPLICANT" in farm_violation_ids(inp2)
}

test_applicant_not_active_farmer if {
	inp := patch(base_input, "/farm/applicant/is_active_farmer", false)
	"O6_6-GEN-APPLICANT" in farm_violation_ids(inp)
}

test_no_simultaneous_o6_7 if {
	inp := patch(base_input, "/farm/oepul/measures/-", {"measure_code": "7", "applied_on": "2025-12-01", "contract_start_year": 2026})
	"O6_6-NO-O6_7" in farm_violation_ids(inp)
}

test_switch_to_o6_7_replaces if {
	inp := json.patch(base_input, [
		{"op": "add", "path": "/farm/oepul/measures/0/withdrawal_date", "value": "2025-12-20"},
		{"op": "add", "path": "/farm/oepul/measures/-", "value": {"measure_code": "7", "applied_on": "2025-12-20", "contract_start_year": 2026}},
	])
	not "O6_6-NO-O6_7" in farm_violation_ids(inp)
	o6_6.switch_to_o6_7_allowed(2027)
	not o6_6.switch_to_o6_7_allowed(2028)
}

test_measure_application_deadline if {
	inp := json.patch(base_input, [{"op": "replace", "path": "/farm/oepul/measures/0", "value": {"measure_code": "6", "applied_on": "2026-01-05", "contract_start_year": 2026}}])
	"O6_6-MEASURE-APPLICATION" in farm_violation_ids(inp)
}

test_last_entry_2027 if {
	inp := json.patch(base_input, [{"op": "replace", "path": "/farm/oepul/measures/0", "value": {"measure_code": "6", "applied_on": "2027-12-01", "contract_start_year": 2028}}])
	"O6_6-LAST-ENTRY" in farm_violation_ids(inp)
}

test_exit_in_current_year_invalidates if {
	inp := patch(base_input, "/farm/oepul/measures/0/withdrawal_date", "2026-06-01")
	"O6_6-EXIT" in farm_violation_ids(inp)
	not o6_6.farm_premium_eligible with input as inp
}

test_exit_after_inspection_announcement_ineffective if {
	inp := patch(patch(base_input, "/farm/oepul/measures/0/withdrawal_date", "2026-06-01"), "/farm/oepul/inspection_announced_on", "2026-05-20")
	"O6_6-GEN-EXIT-UNTIL-INSPECTION" in farm_violation_ids(inp)
	not "O6_6-EXIT" in farm_violation_ids(inp)
}

test_exit_next_year_before_period_end if {
	inp := patch(base_input, "/farm/oepul/measures/0/withdrawal_date", "2027-01-10")
	"O6_6-EXIT-TIMING" in farm_violation_ids(inp)
	inp2 := patch(base_input, "/farm/oepul/measures/0/withdrawal_date", "2027-03-22")
	not "O6_6-EXIT-TIMING" in farm_violation_ids(inp2)
}

test_premium_band_calculation if {
	o6_6.gross_premium_min_eur == 2799 with input as base_input
	o6_6.gross_premium_max_eur == 3421 with input as base_input
}

test_ineligible_parcel_gets_no_premium if {
	inp := with_parcel(set_cc(v2_parcel, "sowing_date", "2026-08-20"))
	o6_6.parcel_results["P-V2"].premium_min_eur == 0 with input as inp
	not o6_6.parcel_results["P-V2"].creditable with input as inp
}

test_obligation_violation_keeps_parcel_creditable if {
	inp := with_parcel(set_cc(v2_parcel, "events", [{"type": "psm_application", "date": "2026-09-01"}]))
	o6_6.parcel_results["P-V2"].creditable with input as inp
	o6_6.parcel_results["P-V2"].premium_min_eur == 1710 with input as inp
}

test_op_code_blocks_premium if {
	p := json.patch(v2_parcel, [{"op": "replace", "path": "/oepul_codes", "value": ["OPZWF"]}])
	o6_6.parcel_results["P-V2"].premium_min_eur == 0 with input as with_parcel(p)
	q := json.patch(v2_parcel, [{"op": "replace", "path": "/oepul_codes", "value": ["OPBIO"]}])
	o6_6.parcel_results["P-V2"].premium_min_eur == 1710 with input as with_parcel(q)
}

test_national_park_neusiedlersee_no_premium if {
	p := json.patch(v2_parcel, [{"op": "add", "path": "/national_park", "value": "Neusiedlersee"}])
	o6_6.parcel_results["P-V2"].premium_min_eur == 0 with input as with_parcel(p)
}

test_non_eligible_category if {
	p := json.patch(v2_parcel, [{"op": "add", "path": "/eligibility_category", "value": "tree_nursery"}])
	o6_6.parcel_results["P-V2"].premium_min_eur == 0 with input as with_parcel(p)
}

test_parcel_outside_austria if {
	p := json.patch(v2_parcel, [{"op": "replace", "path": "/is_in_austria", "value": false}])
	o6_6.parcel_results["P-V2"].premium_min_eur == 0 with input as with_parcel(p)
}

test_late_variant_application_blocks if {
	p := set_cc(v2_parcel, "variant_applied_on", "2026-09-01")
	o6_6.parcel_results["P-V2"].premium_min_eur == 0 with input as with_parcel(p)
	q := set_cc(set_cc(set_cc(v2_parcel, "variant", 4), "sowing_date", "2026-08-30"), "variant_applied_on", "2026-09-30")
	o6_6.parcel_results["P-V2"].premium_min_eur == 1530 with input as with_parcel(q)
}

test_transfer_without_compliance_blocks if {
	p := json.patch(v2_parcel, [{"op": "add", "path": "/transfer", "value": {"transferred_on": "2027-01-01", "successor_complies": false}}])
	o6_6.parcel_results["P-V2"].premium_min_eur == 0 with input as with_parcel(p)
}

test_lease_to_immergruen_after_31_12_continues if {
	p := json.patch(v2_parcel, [{"op": "add", "path": "/transfer", "value": {"transferred_on": "2027-01-01", "successor_complies": false, "successor_measure_code": "7"}}])
	o6_6.parcel_results["P-V2"].premium_min_eur == 1710 with input as with_parcel(p)
}

test_modulation_220_ha if {
	inp := patch(base_input, "/land/total_area_ha", 220)
	f := o6_6.modulation_factor with input as inp
	abs(f - 0.990909) < 0.0001
}

test_modulation_tiers_1200_ha if {
	inp := patch(base_input, "/land/total_area_ha", 1200)
	f := o6_6.modulation_factor with input as inp
	expected := (((200 + 90) + 595) + 150) / 1200
	abs(f - expected) < 0.000001
}

test_sanction_level_reduces_premium if {
	inp := patch(base_input, "/farm/oepul/content_violation_level", "10")
	o6_6.net_premium_min_eur == 2519.1 with input as inp
}

test_warning_becomes_1_percent_from_2027 if {
	o6_6.effective_sanction_percent == 0 with input as patch(base_input, "/farm/oepul/content_violation_level", "warning")
	inp := patch(patch(base_input, "/farm/oepul/content_violation_level", "warning"), "/farm/year", 2027)
	o6_6.effective_sanction_percent == 1 with input as inp
}

test_exclusion_zero_premium if {
	o6_6.net_premium_max_eur == 0 with input as patch(base_input, "/farm/oepul/content_violation_level", "exclusion")
}

test_min_payment_50_eur if {
	inp := with_parcel(json.patch(v7_parcel, [{"op": "replace", "path": "/area_ha", "value": 0.5}]))
	o6_6.below_min_payment with input as inp
	not o6_6.below_min_payment with input as base_input
}

test_not_counted_toward_area_cap if {
	o6_6.counts_toward_area_payment_cap == false with input as base_input
}

test_reduction_order_content_before_modulation if {
	steps := o6_6.reduction_steps
	some i, a in steps
	a == "content_violations"
	some j, b in steps
	b == "modulation"
	i < j
}

test_erosion_protection_followup if {
	"P-V2" in o6_6.erosion_protection_followup_eligible with input as base_input
	"P-V6" in o6_6.erosion_protection_followup_eligible with input as base_input
	not "P-V1" in o6_6.erosion_protection_followup_eligible with input as base_input
}

test_permanent_circumstance_after_establishment if {
	p := json.patch(v2_parcel, [{"op": "add", "path": "/special_circumstance", "value": {"type": "permanent", "occurred_on": "2026-09-01", "reported": true}}])
	"P-V2" in o6_6.permanent_circumstance_premium_possible with input as with_parcel(p)
}

test_harvest_waiver_districts_2026 if {
	o6_6.harvest_obligation_waived_2026 with input as base_input
	inp := patch(base_input, "/farm/region", {"federal_state": "Steiermark", "district": "Weiz"})
	o6_6.harvest_obligation_waived_2026 with input as inp
	inp2 := patch(base_input, "/farm/region", {"federal_state": "Tirol", "district": "Imst"})
	not o6_6.harvest_obligation_waived_2026 with input as inp2
}

test_unharvested_parcel_advice if {
	p := json.patch(v2_parcel, [{"op": "replace", "path": "/operations/main_crop_harvest_share_percent", "value": 50}])
	inp := patch(with_parcel(p), "/farm/region", {"federal_state": "Tirol", "district": "Imst"})
	some a in o6_6.advice with input as inp
	a.rule_id == "O6_6-GEN-OP-UNHARVESTED"
}

test_variant_withdrawal_required_when_not_sown if {
	p := set_cc(v2_parcel, "sowing_date", "2026-08-12")
	some w in o6_6.variant_withdrawal_required with input as with_parcel(p)
	w.parcel_id == "P-V2"
	count(o6_6.variant_withdrawal_required) == 0 with input as with_parcel(set_cc(p, "variant_withdrawn", true))
}
