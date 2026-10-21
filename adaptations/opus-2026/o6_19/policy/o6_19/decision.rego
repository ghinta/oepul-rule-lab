# Zusammenfassende Entscheidung für einen Betrieb und ein Förderjahr.
package oepul.o6_19

import rego.v1

parcel_results[pid] := {
	"eligibility_failures": parcel_eligibility_failures[pid],
	"obligation_violations": parcel_obligation_violations[pid],
	"no_premium_reasons": parcel_reasons(pid),
	"eligible_area_ha": parcel_eligible_area[pid],
	"premium_area_ha": object.get(parcel_premium_area, pid, 0),
	"rate_eur_per_ha": object.get(parcel_rate, pid, null),
	"rate_after_reductions_eur_per_ha": object.get(parcel_rate_after_reductions, pid, null),
	"premium_eur": object.get(parcel_premium_eur, pid, 0),
	"rate_issues": object.get(rate_issues, pid, set()),
	"combination_conflicts": object.get(combination_conflicts, pid, set()),
	"creditable_as_biodiversity_area": pid in creditable_bdf_ids,
	"biodiversity_crediting_issues": object.get(bdf_crediting_issues, pid, set()),
	"project_confirmation_design_issues": object.get(pb_design_issues, pid, set()),
} if {
	some pid in ebw_parcel_ids
}

violations := (participation_violations | general_violations) | {v |
	some pid in ebw_parcel_ids
	some x in parcel_violations[pid]
	v := object.union(x, {"parcel_id": pid})
}

eligible if {
	access_consequence == "none"
	count(general_violations) == 0
	not excluded_from_measure
	measure_valid_this_year
}

default eligible := false

decision := {
	"measure": "o6_19",
	"year": year,
	"eligible": eligible,
	"access_consequence": access_consequence,
	"contract_period": object.get({"cp": contract_period}, "cp", null),
	"violations": violations,
	"field_piece_bdf_violations": field_piece_bdf_violations,
	"parcels": parcel_results,
	"set_aside_factor": set_aside_factor,
	"access_increase_factor": access_increase_factor,
	"modulation_factor": modulation_factor,
	"sanction_reduction_percent": sanction_reduction_percent,
	"area_premium_eur": area_premium_eur,
	"regional_plan_surcharge_eur": regional_plan_surcharge_after_reductions,
	"measure_premium_eur": measure_premium_eur,
	"payment_may_be_withheld": payment_may_be_withheld,
	"area_decrease_repayment_area_ha": area_decrease_repayment_area_ha,
	"repayment_of_past_premiums_required": repayment_of_past_premiums_required,
	"notice_2026_findings": notice_2026_findings,
}

default payment_may_be_withheld := false

default repayment_of_past_premiums_required := false

default excluded_from_measure := false

default measure_valid_this_year := false
