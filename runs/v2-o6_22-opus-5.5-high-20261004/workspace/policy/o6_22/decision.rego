# Modul: o6_22 – Gesamtentscheidung
# Fasst Teilnahme, Verstöße, Zuschläge und Prämie zusammen.
package oepul.o6_22

compliant if count(violations) == 0

decision := {
	"measure": "o6_22",
	"intervention": params.gsp_intervention_code,
	"year": year,
	"active_categories": active_categories,
	"lapsed_categories": lapsed_categories,
	"participating_gve": participating_gve,
	"min_participation_met": min_participation_met,
	"measure_payable": measure_payable,
	"animal_health_service_required": animal_health_service_required,
	"compliant": compliant,
	"violations": violations,
	"warnings": warnings,
	"premium_before_modulation_eur": premium_before_modulation,
	"modulation_factor": modulation_factor(farm_area_ha),
	"premium_after_modulation_eur": premium_after_modulation,
	"below_minimum_payment": below_minimum_payment,
}

default min_participation_met := false

default measure_payable := false

default animal_health_service_required := false

default compliant := false

default below_minimum_payment := false
