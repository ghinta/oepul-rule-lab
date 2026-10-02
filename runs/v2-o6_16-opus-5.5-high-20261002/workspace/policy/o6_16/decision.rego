# o6_16 – Gesamtergebnis
# Fasst Zugangsvoraussetzungen, Verstöße, offene Verpflichtungen und Prämie zusammen.
package oepul.o6_16

access_rule_ids := {
	"o6_16.access.combination_obligation",
	"o6_16.access.min_area_first_year",
	"o6_16.application.measure_application_deadline",
	"o6_16.application.last_entry_measure",
	"o6_16.general.applicant_public_body",
	"o6_16.general.applicant_type",
	"o6_16.general.min_farm_size",
}

access_violations := {v | some v in violations; v.rule_id in access_rule_ids}

default access_conditions_met := false

access_conditions_met if count(access_violations) == 0

decision := {
	"measure": "o6_16",
	"year": year,
	"access_conditions_met": access_conditions_met,
	"arable_in_area_ha": arable_in_area_ha,
	"violations": violations,
	"obligations": obligations,
	"missing_data": missing_data,
	"premium_components": premium_components,
	"premium_total_before_modulation": premium_total_before_modulation,
	"premium_total": premium_total,
}
