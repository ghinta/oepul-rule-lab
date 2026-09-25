package oepul.o6_1b_test

import data.oepul.o6_1b

changes(obj) := with_patch([{"op": "add", "path": "/oepul/area_changes", "value": obj}])

test_area_loss_tolerance if {
	# 100 ha Vorjahr: Toleranz 5 ha
	o6_1b.area_loss_tolerance_ha == 5 with input as changes({"previous_year_measure_area_ha": 100, "current_measure_area_ha": 96})
	not "O61B-ATB-009" in ids(o6_1b.violations) with input as changes({"previous_year_measure_area_ha": 100, "current_measure_area_ha": 96})

	# 300 ha: 5 % wären 15 ha, jedoch höchstens 5 ha
	"O61B-ATB-009" in ids(o6_1b.violations) with input as changes({"previous_year_measure_area_ha": 300, "current_measure_area_ha": 294})
	o6_1b.area_reduction_repayment_ha == 6 with input as changes({"previous_year_measure_area_ha": 300, "current_measure_area_ha": 294})

	# 6 ha: jedenfalls 0,5 ha zulässig
	not "O61B-ATB-009" in ids(o6_1b.violations) with input as changes({"previous_year_measure_area_ha": 6, "current_measure_area_ha": 5.5})

	# Verlust der Verfügungsgewalt ist unschädlich
	not "O61B-ATB-009" in ids(o6_1b.violations) with input as changes({"previous_year_measure_area_ha": 100, "current_measure_area_ha": 80, "loss_of_control_ha": 18})
}

test_area_increase_limit_after_2025 if {
	o6_1b.premium_eligible_measure_area_max_ha == 30 with input as changes({"measure_area_2025_ha": 20, "current_measure_area_ha": 35})
	o6_1b.area_increase_not_eligible_ha == 5 with input as changes({"measure_area_2025_ha": 20, "current_measure_area_ha": 35})

	# Vergrößerung um 5 ha jedenfalls zulässig
	o6_1b.premium_eligible_measure_area_max_ha == 9 with input as changes({"measure_area_2025_ha": 4, "current_measure_area_ha": 9})
	inp25 := json.patch(changes({"measure_area_2025_ha": 20, "current_measure_area_ha": 35}), [{"op": "replace", "path": "/farm/year", "value": 2025}])
	not o6_1b.premium_eligible_measure_area_max_ha with input as inp25
}

test_takeover_deadline if {
	late := with_patch([{"op": "add", "path": "/oepul/o6_1b/takeover", "value": {"date": "2026-04-16", "extension_share": 0.2}}])
	"O61B-ATB-013" in ids(o6_1b.violations) with input as late
	ok2028 := with_patch([{"op": "add", "path": "/oepul/o6_1b/takeover", "value": {"date": "2028-04-17", "extension_share": 0.2}}])
	not "O61B-ATB-013" in ids(o6_1b.violations) with input as ok2028
	too_big := with_patch([{"op": "add", "path": "/oepul/o6_1b/takeover", "value": {"date": "2026-04-01", "extension_share": 0.6}}])
	"O61B-ATB-013" in ids(o6_1b.violations) with input as too_big
}

test_exit_repayment if {
	o6_1b.repayment_of_all_premiums_required with input as with_patch([{"op": "add", "path": "/oepul/o6_1b/exit", "value": {"date": "2026-05-01", "reason": "voluntary"}}])
	not o6_1b.repayment_of_all_premiums_required with input as with_patch([{"op": "add", "path": "/oepul/o6_1b/exit", "value": {"date": "2026-05-01", "reason": "loss_of_control"}}])
	o6_1b.no_premium_current_year_due_to_exit with input as with_patch([{"op": "add", "path": "/oepul/o6_1b/exit", "value": {"date": "2026-05-01", "reason": "voluntary"}}])
}

test_sanction_levels if {
	o6_1b.sanction_reduction_percent == 0 with input as with_patch([{"op": "add", "path": "/oepul/o6_1b/sanction_level", "value": 0}])
	inp27 := json.patch(with_patch([{"op": "add", "path": "/oepul/o6_1b/sanction_level", "value": 0}]), [{"op": "replace", "path": "/farm/year", "value": 2027}])
	o6_1b.sanction_reduction_percent == 1 with input as inp27
	o6_1b.sanction_reduction_percent == 25 with input as with_patch([{"op": "add", "path": "/oepul/o6_1b/sanction_level", "value": 4}])
	o6_1b.exclusion_from_measure with input as with_patch([{"op": "add", "path": "/oepul/o6_1b/full_reductions_in_contract_period", "value": 2}])
}

test_payment_deadline_and_advance if {
	o6_1b.payment_deadline == "2027-06-30" with input as base_input
	total := o6_1b.premium_total_modulated with input as base_input
	adv := o6_1b.max_advance_payment with input as base_input
	approx(adv, total * 0.75)
}

test_min_payout if {
	tiny := json.patch(with_parcels([{"parcel_id": "O1", "area_ha": 0.05, "land_use": "special_crop", "schlagnutzungsart": "Wein", "crop": {"crop_name": "Wein", "crop_category": "vineyard"}}]), [
		{"op": "replace", "path": "/farm/year", "value": 2024},
		{"op": "replace", "path": "/land/total_area_ha", "value": 0.05},
	])
	o6_1b.payout_may_be_withheld with input as tiny
	not o6_1b.payout_may_be_withheld with input as base_input
}

test_area_payment_cap if {
	p := object.union(arable("A5", 2, "Winterweizen"), {"oepul_area_payment_eur_per_ha": 1400})
	inp := json.patch(base_input, [{"op": "add", "path": "/land/parcels/-", "value": p}])
	{"parcel_id": "A5", "cap_eur_per_ha": 1300} in o6_1b.capped_parcels with input as inp
	pn := object.union(arable("A6", 2, "Winterweizen"), {"oepul_codes": ["NAT"], "oepul_area_payment_eur_per_ha": 1400})
	inp2 := json.patch(base_input, [{"op": "add", "path": "/land/parcels/-", "value": pn}])
	count(o6_1b.capped_parcels) == 0 with input as inp2
}

test_measure_switch_into_organic if {
	o6_1b.measure_switch_without_repayment with input as with_patch([{"op": "add", "path": "/oepul/o6_1b/switched_from", "value": "o6_1a"}, {"op": "add", "path": "/oepul/o6_1b/switch_date", "value": "2024-12-31"}])
	not o6_1b.measure_switch_without_repayment with input as with_patch([{"op": "add", "path": "/oepul/o6_1b/switched_from", "value": "o6_1a"}, {"op": "add", "path": "/oepul/o6_1b/switch_date", "value": "2026-01-01"}])
}

test_result_document if {
	r := o6_1b.result with input as base_input
	r.compliant == true
	r.measure == "o6_1b"
	r.livestock.category == "livestock_lt_1_4"
}
