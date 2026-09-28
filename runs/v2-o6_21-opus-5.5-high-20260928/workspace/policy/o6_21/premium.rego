# Prämienberechnung (Kapitel 9, 10 Informationsblatt; Höhe der Förderung Punkt 2.21 SRL; Modulation 1.9.2.2 SRL).
package oepul.o6_21

import rego.v1

# O6_21-PREM-001 / O6_21-PREM-004: Prämiensätze nach Förderjahr.
rate_row := r if {
	some r in data.o6_21.premium_rates
	r.year_from <= measure_year
	rate_row_upper_ok(r)
}

rate_row_upper_ok(r) if r.year_to == null

rate_row_upper_ok(r) if measure_year <= r.year_to

# O6_21-PREM-002 / O6_21-COMB-004: reduzierter Satz bei Alm, Tierwohl – Weide oder gekoppelter Almstützung.
reduced_rate_applies(a) if {
	some t in data.o6_21.reduced_rate_triggers
	object.get(object.get(a, "other_support", {}), t.input_flag, false) == true
}

reduced_flag(a) if reduced_rate_applies(a)

else := false

animal_rate(a) := rate_row.reduced_eur_per_rgve if reduced_rate_applies(a)

else := rate_row.standard_eur_per_rgve

category_payable(c) if {
	c in applied_categories
	not c in category_excluded
	contract_valid(c)
}

animal_premium_lines contains line if {
	some c in applied_categories
	category_payable(c)
	cat := categories_by_id[c]
	some a in cattle
	participating(a, c)
	r := animal_category_rgve(a, cat)
	rate := animal_rate(a)
	line := {
		"ear_tag": a.ear_tag,
		"category": c,
		"rgve": r,
		"rate_eur_per_rgve": rate,
		"reduced_rate": reduced_flag(a),
		"amount_eur": r * rate,
	}
}

# Voraussetzung für jegliche Prämie der Maßnahme im Förderjahr.
default measure_payable := false

measure_payable if {
	count(applied_categories) > 0
	minimum_participation_met
	not measure_exited_during_year
	not inspection_refused
	count(general_violations) == 0
}

payable_rgve := sum([l.rgve | some l in animal_premium_lines])

base_premium_eur := sum([l.amount_eur | some l in animal_premium_lines]) if measure_payable

else := 0

# O6_21-PREM-001 / O6_21-COMP-*: Zuschlag je RGVE in der Maßnahme.
composting_supplement_eur := payable_rgve * rate_row.composting_supplement_eur_per_rgve if {
	measure_payable
	composting_supplement_eligible
	contract_valid(supplement_id)
} else := 0

gross_premium_eur := base_premium_eur + composting_supplement_eur

total_area_ha := object.get(input, ["land", "total_area_ha"], 0)

# O6_21-GEN-010: Modulation.
applied_modulation_factor := modulation_factor(total_area_ha)

net_premium_eur := gross_premium_eur * applied_modulation_factor
