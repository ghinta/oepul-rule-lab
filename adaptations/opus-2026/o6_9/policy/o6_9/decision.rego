# Gesamtentscheidung der Maßnahme 9 (o6_9)
package oepul.o6_9

default eligible := false

# Teilnahme gültig, wenn Zugangsvoraussetzungen erfüllt und keine Verstöße festgestellt wurden.
eligible if {
	measure_requested
	count(violations) == 0
}

# O69-SRL-011: bei Nichterfüllung von Förder- bzw. Zugangsvoraussetzungen kommt bei einjährigen Maßnahmen kein Vertrag zustande.
access_requirement_rule_ids := {"O69-MB-003", "O69-MB-030", "O69-MB-031", "O69-GEN-001", "O69-GEN-002", "O69-GEN-003"}

no_valid_contract if {
	some v in violations
	v.rule_id in access_requirement_rule_ids
}

decision := {
	"measure": measure_codes,
	"year": year,
	"eligible": eligible,
	"no_valid_contract": no_valid_contract_flag,
	"contract_period": contract_period,
	"contract_lapsed": contract_lapsed_flag,
	"categories_available": measure_categories,
	"pig_feeding_access_met": pig_feeding_access_flag,
	"premium": premium,
	"payment_schedule": payment_schedule,
	"violations": violations,
	"warnings": warnings,
	"obligations": obligations,
}

default no_valid_contract_flag := false

no_valid_contract_flag if no_valid_contract

default contract_lapsed_flag := false

contract_lapsed_flag if contract_lapsed

default pig_feeding_access_flag := false

pig_feeding_access_flag if pig_feeding_access_met
