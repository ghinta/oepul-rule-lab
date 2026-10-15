# o6_4 – zusammengefasste Entscheidung
package oepul.o6_4

import rego.v1

effective_violations contains v if {
	some v in violations
	not excused(v)
}

excused_violations contains v if {
	some v in violations
	excused(v)
}

parcel_results[pid] := r if {
	some pid, p in o6_4_parcels
	r := {
		"area_ha": p.area_ha,
		"is_bergmahd": object.get(parcel_is_bergmahd, pid, false),
		"failures": object.get(parcel_failures, pid, set()),
		"missing_inputs": object.get(parcel_missing, pid, set()),
		"warnings": object.get(parcel_warnings, pid, set()),
		"expected_mowing_code": object.get(expected_mowing_code, pid, null),
		"effective_mowing_code": object.get(effective_code, pid, null),
		"premium_blockers": object.get(premium_blockers, pid, set()),
		"gross_premium_eur": object.get(gross_premium, pid, 0),
		"net_premium_eur": object.get(net_premium, pid, 0),
		"violations": {v | some v in effective_violations; v.parcel_id == pid},
	}
}

decision := {
	"measure": "o6_4",
	"year": year,
	"contract_active": contract_active,
	"contract_failures": contract_failures,
	"contract_missing_inputs": contract_missing,
	"applicant_failures": applicant_failures,
	"farm_premium_blockers": farm_premium_blockers,
	"parcels": parcel_results,
	"violations": effective_violations,
	"excused_violations": excused_violations,
	"content_reduction_percent": content_reduction_percent,
	"modulation_factor": modulation_factor,
	"gross_premium_eur": gross_premium_total,
	"net_premium_eur": net_premium_total,
	"payment_may_be_waived": payment_may_be_waived,
	"exit_repayment_required": exit_repayment_required,
	"area_decrease_repayment_ha": area_decrease_repayment_ha,
	"notices_2026_o6_4_derogation": notices_2026_o6_4_derogation,
}

default contract_active := false

default exit_repayment_required := false

default payment_may_be_waived := false

default area_decrease_repayment_ha := 0
