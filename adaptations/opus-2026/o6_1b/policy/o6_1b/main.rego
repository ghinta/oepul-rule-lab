# Gesamtergebnis der Prüfung für die Maßnahme "Biologische Wirtschaftsweise" (o6_1b).
package oepul.o6_1b

violation_rule_ids := {v.rule_id | some v in violations}

compliant if count(violations) == 0

result := {
	"measure": "o6_1b",
	"year": year,
	"compliant": count(violations) == 0,
	"violations": violations,
	"livestock": {
		"total_rgve": total_rgve,
		"forage_area_ha": forage_area_ha,
		"rgve_per_ha": rgve_per_ha,
		"category": livestock_category,
	},
	"areas": {
		"arable_ha": arable_area_ha,
		"grassland_ha": grassland_area_ha,
		"mown_grassland_ha": mown_grassland_area_ha,
		"arable_div_credit_ha": arable_div_credit_ha,
		"arable_div_required_ha": arable_div_required_ha,
		"grassland_div_credit_ha": grassland_div_credit_ha,
		"grassland_div_required_ha": grassland_div_required_ha,
	},
	"premiums": premium_components,
	"premium_total_gross": premium_total_gross,
	"modulation_factor": modulation_factor,
	"premium_total_modulated": premium_total_modulated,
}
