# title: o6_5 – Gesamtentscheidung
# description: Zusammenfassung aller Teilergebnisse der Maßnahme o6_5.
package oepul.o6_5

slot_eligible_flag(a) if slot_eligible(a)

else := false

base_ok_flag(a) if base_ok(a)

else := false

payable_slot_premium(a) := slot_premium(a) if slot_eligible(a)

else := 0

animal_results[a.animal_id] := result if {
	some a in applied_animals
	result := {
		"role": "applied",
		"eligible": slot_eligible_flag(a),
		"failures": failures_of(a.animal_id),
		"premium_eur": payable_slot_premium(a),
		"replaced_by": used_replacements(a),
	}
}

animal_results[a.animal_id] := result if {
	some a in replacement_animals
	result := {
		"role": "replacement",
		"eligible": base_ok_flag(a),
		"failures": failures_of(a.animal_id),
		"premium_eur": 0,
		"replaces": a.replaces_animal_id,
	}
}

access_requirements_met_flag if access_requirements_met

else := false

minimum_participation_met_flag if minimum_participation_met

else := false

contract_lapses_flag if contract_lapses

else := false

contract_renews_next_year_flag if contract_renews_next_year

else := false

payout_may_be_waived_flag if payout_may_be_waived

else := false

decision := {
	"measure": "o6_5",
	"year": year,
	"access_requirements_met": access_requirements_met_flag,
	"applicant_failures": applicant_failures,
	"contract_failures": contract_failures,
	"minimum_participation_met": minimum_participation_met_flag,
	"contract_lapses": contract_lapses_flag,
	"contract_renews_next_year": contract_renews_next_year_flag,
	"holding_period_end": holding_end_md,
	"eligible_animal_ids": eligible_slot_ids,
	"animal_results": animal_results,
	"rate_period": rate_period,
	"premium_total_eur": premium_total_eur,
	"reduction_percent": reduction_percent,
	"modulation_factor": modulation_factor,
	"payout_eur": payout_eur,
	"payout_may_be_waived": payout_may_be_waived_flag,
	"max_advance_payment_eur": max_advance_payment_eur,
	"payment_deadline": payment_deadline,
	"findings": findings,
}
