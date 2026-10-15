package oepul.o6_12_test

import data.oepul.o6_12

test_further_parcel_exclusions if {
	le := object.union(vineyard, {"parcel_id": "E1", "is_gloez_landscape_element": true})
	nonag := object.union(vineyard, {"parcel_id": "E2", "mainly_agricultural_use": false})
	days := object.union(vineyard, {"parcel_id": "E3", "non_agricultural_use_days": 15})
	tiny := object.union(vineyard, {"parcel_id": "E4", "area_ha": 0.004})
	vf := object.union(vineyard, {"parcel_id": "E5", "oepul_codes": ["VF"]})
	op12 := object.union(vineyard, {"parcel_id": "E6", "measure_op_exclusions": ["12"]})
	overlap := object.union(vineyard, {"parcel_id": "E7", "other_public_funding_same_service": true})
	partyear := object.union(vineyard, {"parcel_id": "E8", "commitment_fulfilled_whole_year": false})
	wrongcode := object.union(vineyard, {"parcel_id": "E9", "land_use_code": "A"})
	days_ok := object.union(vineyard, {"parcel_id": "E10", "non_agricultural_use_days": 14})
	inp := with_parcels([le, nonag, days, tiny, vf, op12, overlap, partyear, wrongcode, days_ok])
	o6_12.eligible_parcel_ids == {"E10"} with input as inp
	"gloez_landscape_element" in o6_12.parcel_exclusions.E1 with input as inp
	"not_mainly_agricultural_use" in o6_12.parcel_exclusions.E2 with input as inp
	"non_agricultural_use_exceeds_14_days" in o6_12.parcel_exclusions.E3 with input as inp
	"below_minimum_parcel_size_50_m2" in o6_12.parcel_exclusions.E4 with input as inp
	"code_vf_experimental_area" in o6_12.parcel_exclusions.E5 with input as inp
	"measure_specific_op_code" in o6_12.parcel_exclusions.E6 with input as inp
	"overlap_with_other_public_funding" in o6_12.parcel_exclusions.E7 with input as inp
	"commitment_not_fulfilled_whole_year" in o6_12.parcel_exclusions.E8 with input as inp
	"land_use_code_not_permanent_crop" in o6_12.parcel_exclusions.E9 with input as inp
}

test_not_active_farmer_and_unknown_legal_form if {
	inp := json.patch(base_input, [{"op": "replace", "path": "/farm/applicant/is_active_farmer", "value": false}])
	"not_active_farmer" in o6_12.applicant_ineligibility_reasons with input as inp
	inp2 := json.patch(base_input, [{"op": "replace", "path": "/farm/applicant/legal_form", "value": "foundation"}])
	"unknown_legal_form" in o6_12.applicant_ineligibility_reasons with input as inp2
}

test_access_failure_in_later_year_only_blocks_premium if {
	inp := json.patch(base_input, [{"op": "replace", "path": "/oepul/participating_measures", "value": ["1B", "12"]}])
	o6_12.access_condition_consequence == "no_premium_in_year" with input as inp
	"access_conditions_not_met" in o6_12.premium_blocking_reasons with input as inp
	o6_12.contract_established with input as inp
}

test_first_year_status_from_recorded_area if {
	inp := with_o612({"first_year_area_ha": 0.4})
	o6_12.first_year_minimum_area_status == "not_met" with input as inp
	inp2 := json.patch(base_input, [{"op": "remove", "path": "/oepul/o6_12/first_year_area_ha"}])
	o6_12.first_year_minimum_area_status == "unknown" with input as inp2
}

test_exit_timely_relative_to_control_announcement if {
	inp := with_o612({"exit": {"requested": true, "request_date": "2026-05-01", "reason": "regular"}, "control_announced_date": "2026-04-20"})
	not o6_12.exit_timely with input as inp
	inp2 := with_o612({"exit": {"requested": true, "request_date": "2026-04-01", "reason": "regular"}, "control_announced_date": "2026-04-20"})
	o6_12.exit_timely with input as inp2
	inp3 := with_o612({"exit": {"requested": true, "request_date": "2026-04-01", "reason": "regular"}})
	o6_12.exit_timely with input as inp3
}

test_rebzikade_exit_before_2026_not_possible if {
	inp := with_o612({"exit": {"requested": true, "request_date": "2025-09-01", "reason": "rebzikade_2026", "submitted_via_force_majeure_form": true, "rebzikade_reason_stated": true}})
	"before_application_year_2026" in o6_12.rebzikade_exit_conditions_unmet with input as inp
	inp2 := with_o612({"exit": {"requested": true, "request_date": "2026-09-01", "reason": "rebzikade_2026", "submitted_via_force_majeure_form": true, "rebzikade_reason_stated": true, "approved": false}})
	"not_approved" in o6_12.rebzikade_exit_conditions_unmet with input as inp2
	inp3 := json.patch(with_o612({"exit": {"requested": true, "request_date": "2026-09-01", "reason": "rebzikade_2026", "submitted_via_force_majeure_form": true, "rebzikade_reason_stated": true}}), [{"op": "replace", "path": "/farm/year", "value": 2027}])
	"rebzikade_exit_in_previous_year" in o6_12.premium_blocking_reasons with input as inp3
}

test_control_refused if {
	inp := with_o612({"control_refused": true})
	"control_refused" in o6_12.premium_blocking_reasons with input as inp
	"control_refused" in o6_12.repayment_required_reasons with input as inp
}

test_farm_transfer if {
	inp := with_o612({"farm_transfer": {"occurred": true, "effective_date": "2026-03-01", "notification_date": "2026-04-15", "successor_continues_commitment": false}})
	o6_12.farm_transfer_issues == {"commitment_not_continued", "notification_later_than_4_weeks"} with input as inp
	inp2 := with_o612({"farm_transfer": {"occurred": true, "effective_date": "2026-03-01", "notification_date": "2026-03-29", "successor_continues_commitment": true}})
	count(o6_12.farm_transfer_issues) == 0 with input as inp2
}

test_takeover_not_approved_and_previous_participant if {
	inp := with_o612({"takeover": {"is_takeover": true, "submission_date": "2026-04-10", "taken_over_area_ha": 2, "additional_area_ha": 0, "approved_by_ama": false, "taker_previously_participating": true}})
	o6_12.takeover_issues == {"not_approved_by_ama", "taker_already_participating"} with input as inp
}

test_temporary_circumstance if {
	inp := with_o612({"circumstance": {"type": "temporary", "beyond_control": true, "notified": true, "event_date": "2026-02-01", "conditions_met_on_changed_areas": true}})
	o6_12.temporary_circumstance_premium_in_year with input as inp
	inp2 := with_o612({
		"circumstance": {"type": "temporary", "beyond_control": true, "notified": true, "event_date": "2026-02-01", "conditions_met_on_changed_areas": false},
		"force_majeure": {"case_id": "official_disease_order", "able_to_notify_date": "2026-02-01", "claim_date": "2026-02-10", "documented": true},
	})
	o6_12.temporary_circumstance_premium_in_year with input as inp2
	inp3 := with_o612({
		"circumstance": {"type": "permanent", "beyond_control": true, "notified": true, "event_date": "2026-02-01"},
		"force_majeure": {"case_id": "permanent_cession_public", "able_to_notify_date": "2026-02-01", "claim_date": "2026-02-10", "documented": true},
	})
	o6_12.permanent_circumstance_premium_in_event_year with input as inp3
}

test_revision_clause if {
	o6_12.revision_clause_exit_without_repayment with input as with_o612({"contract_adjustment_refused": true})
}

test_underdeclaration_threshold if {
	inp := json.patch(base_input, [{"op": "add", "path": "/oepul/undeclared_parcels_area_ha", "value": 0.3}])
	o6_12.underdeclaration_reduction_possible with input as inp
	inp2 := json.patch(base_input, [{"op": "add", "path": "/oepul/undeclared_parcels_area_ha", "value": 0.2}])
	not o6_12.underdeclaration_reduction_possible with input as inp2
}

test_serious_violation_allows_full_reduction if {
	o6_12.full_reduction_possible with input as with_o612({"violations": [{"obligation_id": "x", "level": 2, "detected_by": "administrative", "serious": true}]})
}

test_not_participating_blocks_premium if {
	inp := with_o612({"participating": false})
	"not_participating" in o6_12.premium_blocking_reasons with input as inp
	o6_12.payment_estimate_eur == 0 with input as inp
}

test_year_outside_contract_period if {
	inp := with_year(2029)
	"year_outside_contract_period" in o6_12.premium_blocking_reasons with input as inp
}

test_area_reduction_repayment_general_rule_with_fixed_area if {
	inp := with_o612({"previous_year_area_ha": 10.0, "area_reduction_cause": "land_use_change"})
	o6_12.area_reduction_ha == 7 with input as inp
	not o6_12.general_area_reduction_within_tolerance with input as inp
	not o6_12.area_reduction_repayment_required with input as inp
	o6_12.area_reduction_repayment_required with input as inp with data.o6_12.measure_parameters.premium_area_bound_annually as false
}

test_stock_under_authority_order_allowed if {
	inp := with_o612({
		"authority_orders": [{"order_id": "BH-9", "chemical_synthetic_explicitly_ordered": true, "documented_on_farm": true}],
		"insecticide_stock": [{"product_name": "Ordered", "is_insecticide": true, "eu_2018_848_permitted": false, "authority_order_id": "BH-9"}],
	})
	count(o6_12.prohibited_insecticide_stock) == 0 with input as inp
}

test_authority_order_missing_registration if {
	a := object.union(app("insecticide", true, false), {"authority_order_id": "UNKNOWN", "substance_approved_by_order": true})
	p := object.union(vineyard, {"psm_applications": [a]})
	inp := with_parcels([p])
	o6_12.authority_order_documentation_missing == {"UNKNOWN"} with input as inp
	count(o6_12.prohibited_insecticide_applications) == 1 with input as inp
}

test_authority_order_no_bio_available if {
	a := object.union(app("insecticide", true, false), {"authority_order_id": "BH-4", "substance_approved_by_order": true})
	b := object.union(app("insecticide", false, true), {"authority_order_id": "BH-4", "substance_approved_by_order": true})
	p := object.union(vineyard, {"psm_applications": [a, b]})
	inp := json.patch(with_parcels([p]), [{"op": "add", "path": "/oepul/o6_12/authority_orders", "value": [{"order_id": "BH-4", "chemical_synthetic_explicitly_ordered": false, "bio_substances_available": false, "documented_on_farm": true}]}])
	count(o6_12.prohibited_insecticide_applications) == 0 with input as inp
}
