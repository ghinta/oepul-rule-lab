# RGVE-Schlüssel (Kapitel 10 Informationsblatt, Anhang A SRL) und anteilige RGVE im Weidezeitraum.
package oepul.o6_20.rgve

import data.oepul.o6_20.common

key := {r.rgve_class: r | some r in data.o6_20.rgve_key.measure_sheet}

factor(class) := key[class].rgve

class_allowed(code, class) if class in common.category_defs[code].allowed_rgve_classes

period_start := common.grazing_period_start(common.year)

period_end_exclusive := common.grazing_period_end_exclusive(common.year)

# Verspätete Zugangsmeldung bei Schafen/Ziegen: nur 7 Weidetage vor dem Meldedatum werden berücksichtigt.
late_report_start(a) := common.add_days(a.arrival_report_date, 0 - common.params.sheep_goat_late_report_credit_days) if {
	common.regime(a.category_code) == "sheep_goat"
	common.is_date(a.present_from)
	common.is_date(a.arrival_report_date)
	a.present_from > period_start
	common.days_between(a.present_from, a.arrival_report_date) > common.params.sheep_goat_movement_report_days
}

late_arrival_report(a) if late_report_start(a)

# Zählbeginn (inklusive): spätestes Datum aus Weidebeginn, Zugang, Hineinwachsen, verspäteter Meldung.
animal_start(a) := max(array.concat(
	array.concat(
		[period_start],
		[d |
			some f in ["present_from", "category_entry_date"]
			d := object.get(a, f, null)
			common.is_date(d)
		],
	),
	[d |
		some d in [late_report_start(a)]
	],
))

# Zählende (exklusive): Weideende, Abgangstag, Hinauswachsen, Betriebsstrukturwechsel.
animal_end_exclusive(a) := min(array.concat(
	[period_end_exclusive],
	[d |
		some f in ["departure_date", "category_exit_date", "structure_change_date"]
		d := object.get(a, f, null)
		common.is_date(d)
	],
))

animal_days(a) := max([0, common.days_between(animal_start(a), animal_end_exclusive(a))])

animal_rgve(a) := (animal_days(a) / common.params.grazing_period.length_days) * factor(a.rgve_class)

# Prämienfähigkeit eines Einzeltiers.
animal_excluded(a) if object.get(a, "reported_non_compliant", false) == true

animal_excluded(a) if object.get(a, "deleted_from_list", false) == true

animal_excluded(a) if object.get(a, "held_in_austria", true) == false

animal_excluded(a) if not class_allowed(a.category_code, a.rgve_class)

animal_excluded(a) if object.get(a, "departure_reported_while_on_alm", false) == true

animal_excluded(a) if {
	object.get(a, "departure_reason", null) in {"sale", "death", "slaughter"}
	object.get(a, "grazed_with_category_until_departure", true) == false
}

animal_excluded(a) if common.sheep_goat_late_individual_application(a)

animal_premium_eligible(a) if not animal_excluded(a)

animals_rgve(code) := sum([animal_rgve(a) |
	some a in common.animals
	a.category_code == code
	animal_premium_eligible(a)
])

coupled_support_animals_rgve(code) := sum([animal_rgve(a) |
	some a in common.animals
	a.category_code == code
	animal_premium_eligible(a)
	object.get(a, "coupled_alpine_support_applied", false) == true
])

# Equiden und Neuweltkamele: Beantragung über die Stückzahl; prämienfähig ist höchstens die tatsächliche Anzahl.
count_entry_eligible_count(e) := min([e.applied_count, object.get(e, "compliant_count", e.applied_count)])

count_rgve(code) := sum([r |
	some e in object.get(common.category_entry(code), "count_entries", [])
	class_allowed(code, e.rgve_class)
	r := count_entry_eligible_count(e) * factor(e.rgve_class)
])

declared_rgve(code) := c.average_rgve if {
	c := common.category_entry(code)
	is_number(object.get(c, "average_rgve", null))
}

category_rgve(code) := declared_rgve(code)

category_rgve(code) := animals_rgve(code) + count_rgve(code) if not declared_rgve(code)

category_coupled_rgve(code) := c.coupled_alpine_support_rgve if {
	c := common.category_entry(code)
	is_number(object.get(c, "coupled_alpine_support_rgve", null))
} else := coupled_support_animals_rgve(code)

total_rgve := sum([category_rgve(code) | some code in common.applied_category_codes; common.category_defs[code]])
