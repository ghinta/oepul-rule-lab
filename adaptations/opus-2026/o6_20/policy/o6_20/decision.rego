# Gesamtentscheidung "Tierwohl – Weide" (o6_20).
package oepul.o6_20.decision

import data.oepul.o6_20.application
import data.oepul.o6_20.eligibility
import data.oepul.o6_20.general
import data.oepul.o6_20.notices_2026
import data.oepul.o6_20.obligations
import data.oepul.o6_20.premium
import data.oepul.o6_20.reporting

violations := premium.all_violations

review_items := ((eligibility.review_items | reporting.review_items) | application.review_items) | (notices_2026.review_items | general.review_items)

missing_inputs := eligibility.missing_inputs | obligations.missing_inputs

rule_ids_triggered := {v.rule_id | some v in violations}

result := {
	"measure": "o6_20",
	"contract_valid": premium.is_contract_valid,
	"contract_period": application.contract_period,
	"premium": premium.summary,
	"violations": violations,
	"review_items": review_items,
	"missing_inputs": missing_inputs,
}
