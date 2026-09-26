# Maßnahme 12 – Gesamtentscheidung: sammelt Verstöße und liefert ein Ergebnisobjekt.
package oepul.o6_12

violations contains {"rule_id": "o6_12.gen.applicant_eligibility", "detail": f} if {
	participates
	some f in applicant_findings
}

violations contains {"rule_id": "o6_12.gen.farm_min_size_first_year", "detail": "farm_min_size_not_met"} if {
	participates
	not farm_min_size_ok
}

violations contains {"rule_id": "o6_12.elig.min_participation_area_first_year", "detail": "woh_area_below_0_5_ha"} if {
	participates
	not min_participation_ok
}

violations contains {"rule_id": "o6_12.oblig.insecticide_ban", "detail": v} if {
	some v in prohibited_insecticide_use
}

violations contains {"rule_id": "o6_12.oblig.authority_order_documentation", "detail": pest} if {
	some pest in authority_order_documentation_missing
}

violations contains {"rule_id": "o6_12.notice2026.designated_area_organic_only", "detail": v} if {
	some v in authority_order_organic_only_breach
}

violations contains {"rule_id": "o6_12.oblig.purchase_storage_ban", "detail": product} if {
	some product in purchase_storage_violation
}

violations contains {"rule_id": "o6_12.psm.psmcsi_required", "detail": v} if {
	some v in psm_code_missing
	v.code == "PSMCSI"
}

violations contains {"rule_id": "o6_12.psm.coding_until_2025", "detail": v} if {
	some v in psm_code_missing
	v.code != "PSMCSI"
}

violations contains {"rule_id": "o6_12.psm.authority_order_upload", "detail": pest} if {
	some pest in authority_order_upload_missing
}

violations contains {"rule_id": "o6_12.psm.advance_coding_correction", "detail": v} if {
	some v in psm_code_without_application
}

violations contains {"rule_id": "o6_12.gen.minimum_management_special_crops", "detail": pid} if {
	some pid in minimum_management_breach
}

violations contains {"rule_id": "o6_12.contract.contract_period", "detail": f} if {
	some f in contract_findings
}

violations contains {"rule_id": "o6_12.comb.no_farm_combination_with_organic", "detail": "organic_measure_1B_without_arable_grassland_partial_farm"} if {
	organic_combination_conflict
}

violations contains {"rule_id": "o6_12.comb.anhang_l_single_area", "detail": {"parcel_id": pid, "measure": other}} if {
	some [pid, other] in parcel_combination_not_permitted
}

violations contains {"rule_id": "o6_12.gen.takeover", "detail": f} if {
	some f in takeover_findings
}

violations contains {"rule_id": "o6_12.gen.exit_timing", "detail": "exit_after_control_announcement"} if {
	exit_blocked_by_control
}

decision := {
	"measure": measure.code,
	"application_year": application_year,
	"participates": participates,
	"woh_area_ha": woh_area_ha,
	"premium_eligible_parcels": premium_eligible_parcel_ids,
	"premium_blocked_reasons": premium_blocked_reason,
	"gross_premium_eur": gross_premium_eur,
	"sanction_reduction_percent": effective_reduction_percent,
	"modulation_factor": modulation_factor,
	"net_premium_eur": net_premium_eur,
	"psm_coding_required": psm_coding_required,
	"leafhopper_exit_approved": leafhopper_exit_approved,
	"violations": violations,
}
