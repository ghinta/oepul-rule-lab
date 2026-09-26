package oepul.o6_14_test

import data.oepul.o6_14

test_annex_l_no_single_area_combination if {
	a := object.union(alm("A", 20), {"plots": [{"plot_id": "A-1", "codes": [], "other_area_measures": ["1A"]}]})
	v := o6_14.combination_violations with input as mk_input(2026, [a], [])
	some x in v
	x.rule_id == "O614-GEN-015"
}

test_behirtung_requires_almbewirtschaftung if {
	base := with_af(mk_input(2026, [alm("A", 20)], []), {"measure": {"applied": false}})
	inp := object.union(base, {"farm": object.union(base.farm, {"oepul": {"first_oepul_year": 2023, "participating_measures": ["tierwohl_behirtung"]}})})
	v := o6_14.combination_violations with input as inp
	some x in v
	x.rule_id == "O614-GEN-018"
}

test_stallhaltung_rinder_reduced_rate if {
	inp := mk_input(2026, [alm("A", 20)], [cattle("c", "2024-01-01", 1, [stay("A", "2026-06-01", "2026-09-01")])])
	o6_14.stallhaltung_rinder_rate_eur_per_rgve("c") == 162 with input as inp
}

test_exit_before_end_requires_repayment if {
	inp := with_af(mk_input(2026, [alm("A", 20)], []), {"exit": {"exited": true, "exit_date": "2026-01-01", "reason": "voluntary"}})
	o6_14.repayment_required with input as inp
}

test_exit_loss_of_control_no_repayment if {
	inp := with_af(mk_input(2026, [alm("A", 20)], []), {"exit": {"exited": true, "exit_date": "2026-01-01", "reason": "loss_of_control"}})
	not o6_14.repayment_required with input as inp
}

test_missing_payment_claim_consequences if {
	inp := with_af(mk_input(2026, [alm("A", 20)], []), {"measure": object.union(base_measure, {"payment_claim_missing": true})})
	o6_14.missing_payment_claim_consequence == "commitment_continues_no_payment" with input as inp
	inp2 := with_af(mk_input(2026, [alm("A", 20)], []), {"measure": object.union(base_measure, {"payment_claim_missing": true, "payment_claim_missing_over_one_year": true})})
	o6_14.missing_payment_claim_consequence == "commitment_ends_full_repayment" with input as inp2
}

test_permanent_circumstance_after_drive_up_premium_possible if {
	inp := with_af(mk_input(2026, [alm("A", 20)], [cattle("c", "2019-01-01", 5, [stay("A", "2026-06-01", "2026-09-01")])]), {"circumstance": {"type": "permanent", "reported": true, "occurrence_date": "2026-07-01"}})
	o6_14.permanent_circumstance_premium_possible with input as inp
}

test_permanent_circumstance_before_drive_up_no_premium if {
	inp := with_af(mk_input(2026, [alm("A", 20)], [cattle("c", "2019-01-01", 5, [stay("A", "2026-06-01", "2026-09-01")])]), {"circumstance": {"type": "permanent", "reported": true, "occurrence_date": "2026-05-01"}})
	not o6_14.permanent_circumstance_premium_possible with input as inp
}

test_drought_2026_force_majeure if {
	inp := with_af(mk_input(2026, [alm("A", 20)], []), {"circumstance": {"drought_prevents_compliance": true, "force_majeure_application_submitted": true}})
	o6_14.drought_2026_force_majeure_recognised with input as inp
}

test_drought_rule_only_2026 if {
	inp := with_af(mk_input(2025, [alm("A", 20)], []), {"circumstance": {"drought_prevents_compliance": true, "force_majeure_application_submitted": true}})
	not o6_14.drought_2026_force_majeure_possible with input as inp
}

test_sanction_warning_until_2026_retention_2027 if {
	o6_14.sanction_stage_share(1, 2026) == 0
	o6_14.sanction_stage_share(1, 2027) == 0.01
	o6_14.sanction_stage_share(5, 2027) == 0.25
}

test_exclusion_after_two_full_reductions if {
	inp := with_af(mk_input(2026, [alm("A", 20)], []), {"sanction_history": {"full_reductions_in_contract_period": 2}})
	o6_14.exclusion_from_measure with input as inp
}

test_decision_document_complete if {
	d := o6_14.decision with input as example_stocking_2
	d.measure == "o6_14"
	d.contract_end_date == "2028-12-31"
	d.access_conditions_met == true
	d.obligations_met == false
}

test_area_reduction_tolerance if {
	o6_14.area_reduction_allowed_ha(4) == 0.5
	o6_14.area_reduction_allowed_ha(40) == 2
	o6_14.area_reduction_allowed_ha(400) == 5
}

test_multiple_reduction_order if {
	o6_14.reduction_step_index("Modulation des Prämienausmaßes gemäß Punkt 1.9.2.2") < o6_14.reduction_step_index("Zugangskürzung gemäß Punkt 1.7.2.4")
	count(o6_14.multiple_reduction_order) == 11
}

test_supplements_not_combinable if {
	not o6_14.supplements_combinable("nature_conservation", "grazing_plan")
}

test_isolated_trees_area if {
	o6_14.isolated_trees_area_ha(5) == 0.05
}
