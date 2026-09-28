# Gesamtentscheidung für die Maßnahme „Tierwohl – Stallhaltung Rinder“ (o6_21).
package oepul.o6_21

import rego.v1

access_violations contains {"rule_id": "O6_21-ACC-001", "reason": "Mindestteilnahme von 2,00 RGVE im Jahresdurchschnitt nicht erreicht - Vertrag erlischt"} if {
	count(applied_categories) > 0
	not minimum_participation_met
}

notification_violations contains {"rule_id": "O6_21-NOTIF-001", "ear_tag": ear, "reason": "Nichteinhaltung der Stallhaltung nicht umgehend ohrmarkenbezogen abgemeldet"} if {
	some ear in unreported_noncompliance
}

violations := (((((((access_violations | application_violations) | general_violations) | program_violations) | farm_violations) | notification_violations) | documentation_violations) | composting_violations) | {{"rule_id": b.rule_id, "ear_tag": b.ear_tag, "reason": b.reason} | some b in animal_breaches; b.ear_tag in deregistration_required}

decision := {
	"measure": "o6_21",
	"year": measure_year,
	"applied_categories": applied_categories,
	"excluded_categories": category_excluded,
	"lapsed_categories": category_contract_lapsed,
	"category_rgve": category_rgve,
	"total_participating_rgve": total_participating_rgve,
	"minimum_participation_met": minimum_participation_met,
	"measure_payable": measure_payable,
	"animal_health_service_required": animal_health_service_required,
	"deregistration_required": deregistration_required,
	"unreported_noncompliance": unreported_noncompliance,
	"excluded_animals": animal_excluded,
	"stall_sketch_required": stall_sketch_required,
	"composting_supplement_eligible": composting_supplement_eligible,
	"violations": violations,
	"premium": {
		"rates": rate_row,
		"base_premium_eur": round2(base_premium_eur),
		"composting_supplement_eur": round2(composting_supplement_eur),
		"gross_premium_eur": round2(gross_premium_eur),
		"modulation_factor": applied_modulation_factor,
		"net_premium_eur": round2(net_premium_eur),
		"payment_deadline": payment_deadline,
		"max_advance_payment_eur": round2(max_advance_payment(net_premium_eur)),
		"payout_may_be_withheld": payout_withheld_flag,
	},
}

default payout_withheld_flag := false

payout_withheld_flag if payout_may_be_withheld(net_premium_eur)
