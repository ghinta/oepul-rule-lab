# o6_16 – Teilnahmevoraussetzungen, Vertragszeitraum und Beantragung
package oepul.o6_16

# ---------------------------------------------------------------------------
# 3.1 Vertragszeitraum
# ---------------------------------------------------------------------------

contract_period_years(start_year) := row.years if {
	some row in params.contract_period.rows
	row.start_year == start_year
}

contract_end_date := params.contract_period.end_date

# Die Option AG sowie die Zuschläge Schweinefütterung und Cultan laufen je ein Kalenderjahr.
component_contract_is_one_year(component) if component in {c | some c in params.contract_period.one_year_components}

# Der Zuschlag stark stickstoffreduzierte Fütterung verlängert sich automatisch, wenn er nicht abgemeldet wird.
pig_feeding_auto_renewed if {
	option_applied("n_reduced_pig_feeding")
	object.get(o16, ["n_reduced_pig_feeding", "deregistered"], false) == false
}

# ---------------------------------------------------------------------------
# 3.2 Kombinationsverpflichtung
# ---------------------------------------------------------------------------

combination_obligation_met if {
	some m in params.combination_obligation_measures
	participates(m)
}

violations contains {
	"rule_id": "o6_16.access.combination_obligation",
	"parcel_id": null,
	"message": "Zeitgleiche Teilnahme an o6_6 (Zwischenfruchtanbau) oder o6_7 (System Immergrün) fehlt.",
} if {
	participates_o6_16
	not combination_obligation_met
}

participates_o6_16 if participates("o6_16")

participates_o6_16 if is_number(object.get(o16, "contract_start_year", null))

# ---------------------------------------------------------------------------
# 3.3 Mindestteilnahme
# ---------------------------------------------------------------------------

min_area_first_year_met if arable_in_area_ha >= params.min_area_first_year_ha

violations contains {
	"rule_id": "o6_16.access.min_area_first_year",
	"parcel_id": null,
	"message": sprintf("Im ersten Teilnahmejahr nur %v ha Ackerfläche in der Gebietskulisse (mindestens 2,00 ha).", [arable_in_area_ha]),
} if {
	first_participation_year
	not min_area_first_year_met
}

# Schweine-GVE gemäß Anhang A (Jahresdurchschnitt)
pig_gve_factor := {row.code: row.gve_per_head |
	some row in data.o6_16.gve_schluessel_anhang_a.rows
	row.group == "schweine"
}

pig_group_gve(sg) := sg.gve if {
	is_number(object.get(sg, "gve", null))
} else := sg.animal_count * pig_gve_factor[sg.category]

pig_groups := [sg | some sg in object.get(input, ["livestock", "species_groups"], []); sg.species == "pigs"]

pig_gve_total := sum([g | some sg in pig_groups; g := pig_group_gve(sg)])

pig_gve_per_ha_arable := pig_gve_total / farm_arable_ha if farm_arable_ha > 0

pig_feeding_min_density_met if pig_gve_per_ha_arable >= params.pig_feeding_min_gve_per_ha_arable

violations contains {
	"rule_id": "o6_16.access.pig_feeding_min_density",
	"parcel_id": null,
	"message": "Zuschlag stark stickstoffreduzierte Fütterung: weniger als 1,00 GVE Schweine je ha Ackerfläche im Jahresdurchschnitt.",
} if {
	option_applied("n_reduced_pig_feeding")
	not pig_feeding_min_density_met
}

missing_data contains {"rule_id": "o6_16.access.pig_feeding_min_density", "path": "livestock.species_groups[].gve", "reason": "Schweinegruppe ohne GVE und ohne Kategorie gemäß Anhang A"} if {
	option_applied("n_reduced_pig_feeding")
	some sg in pig_groups
	not pig_group_gve(sg)
}

# Optionen AG und Cultan: mindestens ein Schlag
violations contains {
	"rule_id": "o6_16.access.option_min_one_parcel",
	"parcel_id": null,
	"message": sprintf("Option %v beantragt, aber kein entsprechend codierter Schlag vorhanden.", [name]),
} if {
	some name in ["leaching_risk_area", "cultan"]
	option_applied(name)
	count(option_parcels(name)) < params.options_min_parcels[name]
}

option_parcels("leaching_risk_area") := ag_parcels

option_parcels("cultan") := cul_parcels

# ---------------------------------------------------------------------------
# 5 Beantragung
# ---------------------------------------------------------------------------

application_deadline_for_start(start_year) := md_date(start_year - 1, params.application.measure_application_deadline_month_day)

application_in_time(application_date, start_year) if date_le(application_date, application_deadline_for_start(start_year))

violations contains {
	"rule_id": "o6_16.application.measure_application_deadline",
	"parcel_id": null,
	"message": "Maßnahmenantrag nicht bis 31.12. vor Vertragsbeginn gestellt.",
} if {
	is_date(o16.measure_application_date)
	not application_in_time(o16.measure_application_date, contract_start_year)
}

violations contains {
	"rule_id": "o6_16.application.last_entry_measure",
	"parcel_id": null,
	"message": "Einstieg in die Maßnahme nach dem Förderjahr 2025 nicht mehr möglich.",
} if {
	contract_start_year > params.application.last_entry_year_measure
}

violations contains {
	"rule_id": "o6_16.application.humus_vienna_application",
	"parcel_id": null,
	"message": "Zuschlag Humusaufbau und Erosionsschutz in Wien: Einstieg nur bis Förderjahr 2025 mit Maßnahmenantrag bis 31.12. des Vorjahres.",
} if {
	option_applied("humus_erosion_vienna")
	start := object.get(o16, ["humus_erosion_vienna", "start_year"], contract_start_year)
	humus_vienna_application_invalid(start)
}

humus_vienna_application_invalid(start) if start > params.application.last_entry_year_humus_vienna

humus_vienna_application_invalid(start) if {
	d := o16.humus_erosion_vienna.application_date
	is_date(d)
	not application_in_time(d, start)
}

violations contains {
	"rule_id": "o6_16.application.pig_feeding_application",
	"parcel_id": null,
	"message": "Zuschlag stark stickstoffreduzierte Fütterung: Einstieg spätestens Förderjahr 2028, Maßnahmenantrag bis 31.12. des Vorjahres (spätestens 31.12.2027).",
} if {
	option_applied("n_reduced_pig_feeding")
	start := object.get(o16, ["n_reduced_pig_feeding", "start_year"], year)
	pig_feeding_application_invalid(start)
}

pig_feeding_application_invalid(start) if start > params.application.last_entry_year_pig_feeding

pig_feeding_application_invalid(start) if {
	d := o16.n_reduced_pig_feeding.application_date
	is_date(d)
	not application_in_time(d, start)
}

violations contains {
	"rule_id": "o6_16.application.pig_feeding_not_with_o6_9",
	"parcel_id": null,
	"message": "Zuschlag stark stickstoffreduzierte Fütterung nicht gleichzeitig mit der gleichlautenden Kategorie der Maßnahme o6_9 möglich.",
} if {
	option_applied("n_reduced_pig_feeding")
	participates(params.pig_feeding_excluded_with)
}

# AG-Schläge: zulässige Schlagnutzungsarten
violations contains {
	"rule_id": "o6_16.application.ag_usage_type",
	"parcel_id": p.parcel_id,
	"message": "AG-Schlag muss als Grünbrache, Futtergräser, Sonstiges Feldfutter oder Wechselwiese beantragt werden.",
} if {
	some p in ag_parcels
	not object.get(p, ["oepul", "usage_type"], "") in {u | some u in params.application.ag_allowed_usage_types}
}

# AG + DIV nur bei Teilnahme an UBB oder BIO und nur als Grünbrache oder Sonstiges Feldfutter
violations contains {
	"rule_id": "o6_16.application.ag_div_double_coding",
	"parcel_id": p.parcel_id,
	"message": "AG-Schlag mit DIV-Code nur bei Teilnahme an UBB (o6_1a) oder BIO (o6_1b) und Schlagnutzung Grünbrache oder Sonstiges Feldfutter.",
} if {
	some p in ag_parcels
	has_code(p, "DIV")
	not ag_div_allowed(p)
}

ag_div_allowed(p) if {
	some m in params.application.ag_div_measures
	participates(m)
	object.get(p, ["oepul", "usage_type"], "") in {u | some u in params.application.ag_div_allowed_usage_types}
}

# AG + NPF bis 2024: Anrechnung GLÖZ 8, aber keine ÖPUL-Prämie
ag_npf_no_premium(p) if {
	is_ag(p)
	has_code(p, "NPF")
	year <= params.application.npf_until_year
}

# Umwandlung von AG-Flächen in Naturschutz/EBW bis 31.12.2025 (Maßnahmenantrag)
ag_conversion_possible(target, application_date) if {
	target in {t | some t in params.application.ag_conversion_targets}
	date_le(application_date, params.application.ag_conversion_deadline)
}

# Keine Maßnahmenantragspflicht vor Vertragsbeginn für AG und Cultan
requires_measure_application(component) if component in {c | some c in params.application.components_requiring_measure_application}
