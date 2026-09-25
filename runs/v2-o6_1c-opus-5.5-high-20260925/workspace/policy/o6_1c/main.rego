# Aggregierte Entscheidung für die Maßnahme 1C „Nichtproduktive Ackerflächen und Agroforststreifen".
package oepul.o6_1c

violations := (((participation_violations | npa_violations) | afs_violations) | eligibility_violations) | notice_violations

# Eigene Menge für allfällige Hinweis-Verstöße (derzeit keine 1C-spezifischen Pflichten aus den 2026-Hinweisen).
notice_violations := set()

violation_rule_ids := {v.rule_id | some v in violations}

default contract_valid_npa := false

contract_valid_npa if contract_valid_for_category("npa")

default contract_valid_afs := false

contract_valid_afs if contract_valid_for_category("afs")

decision := {
	"measure": "o6_1c",
	"year": year,
	"measure_offered": measure_offered_in_year,
	"contract_valid": {
		"npa": contract_valid_npa,
		"afs": contract_valid_afs,
	},
	"npa_blocked_by_ubb_or_bio": ubb_or_bio_conflict,
	"applicant_eligible": applicant_eligible,
	"min_farm_size_met": min_farm_size_met,
	"premium_estimate": premium_estimate,
	"npa_area_cap_ha": npa_area_cap_ha,
	"payment_may_be_waived": payment_may_be_waived,
	"included_in_area_payment_cap": included_in_area_payment_cap,
	"payment_deadline": payment_deadline,
	"combinable_measures_on_single_area": combinable_measures_1c,
	"afs_credit_15a_by_feldstueck": afs_credit_15a_by_feldstueck,
	"violations": violations,
	"application_rejected_control_refused": application_rejected_control_refused,
	"excluded_from_measure": excluded_from_measure,
}
