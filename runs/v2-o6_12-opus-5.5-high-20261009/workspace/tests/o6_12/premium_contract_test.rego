package oepul.o6_12_test

import data.oepul.o6_12

test_premium_rates_by_year if {
	o6_12.rate_for("vineyard", 2023) == 250.0
	o6_12.rate_for("orchard", 2024) == 270.0
	o6_12.rate_for("hop", 2028) == 270.0
}

test_gross_premium_and_payment if {
	o6_12.gross_premium_eur == 810.0 with input as base_input
	o6_12.premium_granted with input as base_input
	o6_12.payment_estimate_eur == 810.0 with input as base_input
	o6_12.decision.payment_estimate_eur == 810.0 with input as base_input
	o6_12.payment_deadline == "2027-06-30" with input as base_input
	o6_12.advance_payment_max_eur == 607.5 with input as base_input
}

test_modulation_example_220_ha if {
	f := o6_12.modulation_factor(220)
	f > 0.9909
	f < 0.991
	o6_12.modulation_factor(150) == 1
	o6_12.modulation_factor(1100) == (((200 + (100 * 0.9)) + (700 * 0.85)) + (100 * 0.75)) / 1100
}

test_minimum_payment_waiver if {
	small := object.union(vineyard, {"area_ha": 0.15})
	inp := with_parcels([small])
	o6_12.payment_estimate_eur == 40.5 with input as inp
	o6_12.payment_may_be_waived with input as inp
}

test_overdeclaration_sanction if {
	inp := with_o612({"declared_area_ha": 3.0, "determined_area_ha": 2.5})
	o6_12.overdeclaration_sanctioned with input as inp
	o6_12.premium_basis_area_ha == 1.75 with input as inp
	inp2 := with_o612({"declared_area_ha": 3.0, "determined_area_ha": 2.95})
	not o6_12.overdeclaration_sanctioned with input as inp2
	o6_12.premium_basis_area_ha == 2.95 with input as inp2
}

test_area_cap_excess if {
	p := object.union(vineyard, {"other_area_payments_eur_per_ha": 1100})
	inp := with_parcels([p])
	o6_12.parcel_cap_excess_eur_per_ha.W1 == 70 with input as inp
}

test_rebzikade_exit_2026 if {
	inp := with_o612({"exit": {"requested": true, "request_date": "2026-06-20", "reason": "rebzikade_2026", "submitted_via_force_majeure_form": true, "rebzikade_reason_stated": true}})
	o6_12.rebzikade_exit_without_repayment with input as inp
	"rebzikade_exit_in_year" in o6_12.premium_blocking_reasons with input as inp
	count(o6_12.repayment_required_reasons) == 0 with input as inp
	o6_12.contract_end_date == "2026-06-20" with input as inp
	o6_12.payment_estimate_eur == 0 with input as inp
}

test_rebzikade_exit_allows_chemical_insecticide_after_exit if {
	before := object.union(app("insecticide", true, false), {"date": "2026-06-01"})
	after := object.union(app("insecticide", true, false), {"date": "2026-07-01"})
	p := object.union(vineyard, {"psm_applications": [before, after]})
	inp := json.patch(with_parcels([p]), [{"op": "add", "path": "/oepul/o6_12/exit", "value": {"requested": true, "request_date": "2026-06-20", "reason": "rebzikade_2026", "submitted_via_force_majeure_form": true, "rebzikade_reason_stated": true}}])
	o6_12.prohibited_insecticide_applications == {{"parcel_id": "W1", "date": "2026-06-01", "product": "X"}} with input as inp
}

test_rebzikade_exit_requires_vineyard_and_form if {
	inp := json.patch(with_parcels([orchard]), [{"op": "add", "path": "/oepul/o6_12/exit", "value": {"requested": true, "request_date": "2026-06-20", "reason": "rebzikade_2026", "submitted_via_force_majeure_form": false, "rebzikade_reason_stated": true}}])
	"farm_has_no_vineyard" in o6_12.rebzikade_exit_conditions_unmet with input as inp
	"not_submitted_via_force_majeure_form" in o6_12.rebzikade_exit_conditions_unmet with input as inp
	"exit_before_contract_end" in o6_12.repayment_required_reasons with input as inp
}

test_regular_exit_requires_repayment if {
	inp := with_o612({"exit": {"requested": true, "request_date": "2026-03-01", "reason": "regular"}})
	"exit_before_contract_end" in o6_12.repayment_required_reasons with input as inp
	"deregistered_in_year" in o6_12.premium_blocking_reasons with input as inp
	not o6_12.reentry_possible with input as inp
}

test_bio_switch_until_2025_without_repayment if {
	inp := with_o612({
		"switch_to_bio": {"requested": true, "application_date": "2025-12-20"},
		"exit": {"requested": true, "request_date": "2025-12-20", "reason": "regular"},
	})
	o6_12.bio_switch_without_repayment with input as inp
	count(o6_12.repayment_required_reasons) == 0 with input as inp
	inp2 := with_o612({"switch_to_bio": {"requested": true, "application_date": "2026-01-05"}})
	not o6_12.bio_switch_without_repayment with input as inp2
}

test_area_reduction_tolerance if {
	o6_12.area_reduction_tolerance_ha(4) == 0.5
	o6_12.area_reduction_tolerance_ha(40) == 2
	o6_12.area_reduction_tolerance_ha(200) == 5
	inp := with_o612({"previous_year_area_ha": 6.0})
	o6_12.area_variation_permitted with input as inp
	not o6_12.area_reduction_repayment_required with input as inp
	o6_12.area_additions_fully_eligible with input as inp
}

test_takeover_rules if {
	inp := with_o612({"takeover": {"is_takeover": true, "submission_date": "2026-04-16", "taken_over_area_ha": 2, "additional_area_ha": 1.5, "approved_by_ama": true}})
	o6_12.takeover_issues == {"submitted_after_deadline", "extension_exceeds_50_percent"} with input as inp
	inp2 := json.patch(with_o612({"takeover": {"is_takeover": true, "submission_date": "2028-04-17", "taken_over_area_ha": 2, "additional_area_ha": 1, "approved_by_ama": true}}), [{"op": "replace", "path": "/farm/year", "value": 2028}])
	o6_12.takeover_valid with input as inp2
}

test_force_majeure_three_weeks if {
	inp := with_o612({"force_majeure": {"case_id": "official_disease_order", "able_to_notify_date": "2026-06-01", "claim_date": "2026-06-22", "documented": true}})
	o6_12.force_majeure_premium_retained with input as inp
	o6_12.official_disease_order_is_force_majeure with input as inp
	inp2 := with_o612({"force_majeure": {"case_id": "official_disease_order", "able_to_notify_date": "2026-06-01", "claim_date": "2026-06-23", "documented": true}})
	not o6_12.force_majeure_premium_retained with input as inp2
}

test_permanent_circumstance_after_15_april if {
	inp := with_o612({"circumstance": {"type": "permanent", "beyond_control": true, "notified": true, "event_date": "2026-05-02"}})
	o6_12.circumstance_no_repayment with input as inp
	o6_12.permanent_circumstance_premium_in_event_year with input as inp
	inp2 := with_o612({"circumstance": {"type": "permanent", "beyond_control": true, "notified": true, "event_date": "2026-03-02"}})
	not o6_12.permanent_circumstance_premium_in_event_year with input as inp2
}

test_annual_payment_application_missing if {
	inp := with_o612({"annual_application_submitted": false})
	o6_12.commitment_continues_without_payment with input as inp
	"annual_payment_application_missing" in o6_12.premium_blocking_reasons with input as inp
	inp2 := with_o612({"annual_application_submitted": false, "payment_application_missing_over_one_year": true})
	"payment_application_missing_over_one_year" in o6_12.repayment_required_reasons with input as inp2
}

test_records_retention if {
	o6_12.records_retention_until == "2032-12-31" with input as base_input
}

test_drought_exemption_only_arable if {
	o6_12.drought_2026_automatic_harvest_exemption(arable) with input as base_input
	not o6_12.drought_2026_automatic_harvest_exemption(vineyard) with input as base_input
}
