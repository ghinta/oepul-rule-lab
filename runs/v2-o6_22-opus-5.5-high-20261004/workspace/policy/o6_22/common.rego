# METADATA
# title: ÖPUL 2023 – Tierwohl – Schweinehaltung (o6_22) – gemeinsame Hilfsregeln
# description: >-
#   Datenzugriff, Kategoriezuordnung, GVE-Ermittlung und Datumshilfen für die
#   Maßnahme "Tierwohl – Schweinehaltung" (SRL 2.22, Intervention 70-19).
package oepul.o6_22

params := data.o6_22.parameters

categories := data.o6_22.categories

space := data.o6_22.space_requirements

rates := data.o6_22.premium_rates

lists := data.o6_22.lists

general := data.o6_22.general_conditions

year := input.farm.year

measure_input := object.get(input, ["farm", "oepul_measures", "o6_22"], {})

applications := object.get(measure_input, "applications", [])

mfa := object.get(input, ["farm", "mfa"], {})

pig_farm := object.get(input, ["livestock", "pig_farm"], {})

# Alle Schweinegruppen des Betriebs (Tierliste-Positionen).
pig_groups := [g |
	some g in object.get(input, ["livestock", "species_groups"], [])
	g.species == "pigs"
]

r2(x) := round(x * 100) / 100

r4(x) := round(x * 10000) / 10000

# Datumshilfen (ISO-Datum "YYYY-MM-DD").
date_ns(d) := time.parse_ns("2006-01-02", d)

days_between(a, b) := (date_ns(b) - date_ns(a)) / 86400000000000

year_date(y, mm_dd) := sprintf("%d-%s", [y, mm_dd])

# O622-CAT-001 / O622-CAT-002: Tierliste-Kategorie -> Maßnahmenkategorie und GVE-Faktor.
tierliste_category(id) := row if {
	some row in categories.tierliste_categories
	row.id == id
}

measure_category_ids := {c.id | some c in categories.measure_categories}

measure_category_row(id) := row if {
	some row in categories.measure_categories
	row.id == id
}

group_tierliste_id(g) := object.get(g, "pig_tierliste_category", null)

group_measure_category(g) := tierliste_category(group_tierliste_id(g)).measure_category

group_gve_factor(g) := tierliste_category(group_tierliste_id(g)).gve_per_head

# O622-CAT-005: Zuchteber ab 50 kg sind nicht prämienfähig.
non_eligible_tierliste_ids := {c.id | some c in categories.non_eligible_tierliste_categories}

# O622-FREE-009: Wildschweine in Freilandhaltung sind nicht förderbar.
is_wild_boar(g) if object.get(g, ["pig_welfare", "is_wild_boar"], false) == true

# O622-GEN-001: Geförderte Tiere müssen in Österreich gehalten werden.
kept_in_austria(g) if object.get(g, ["pig_welfare", "kept_in_austria"], true) == true

group_eligible(g) if {
	tierliste_category(group_tierliste_id(g))
	not is_wild_boar(g)
	kept_in_austria(g)
}

# O622-ELIG-002: Stichtag 1. April oder Jahresdurchschnitt laut Durchschnittstierliste.
uses_average_list if object.get(mfa, "uses_average_animal_list", false) == true

count_basis(g) := g.average_animal_count if {
	uses_average_list
	is_number(object.get(g, "average_animal_count", null))
}

count_basis(g) := object.get(g, "animal_count", 0) if not uses_average_list

count_basis(g) := object.get(g, "animal_count", 0) if {
	uses_average_list
	not is_number(object.get(g, "average_animal_count", null))
}

deregistered_count(g) := object.get(g, "deregistered_average_count", 0)

# O622-PREM-002: beantragte Stückzahl abzüglich abgemeldeter Tiere.
eligible_head_count(g) := max([0, count_basis(g) - deregistered_count(g)]) if group_eligible(g)

eligible_head_count(g) := 0 if not group_eligible(g)

group_gve_declared(g) := r4(count_basis(g) * group_gve_factor(g)) if group_eligible(g)

group_gve_declared(g) := 0 if not group_eligible(g)

group_gve_eligible(g) := r4(eligible_head_count(g) * group_gve_factor(g)) if group_eligible(g)

group_gve_eligible(g) := 0 if not group_eligible(g)

# Kennung einer Gruppe für Meldungen.
group_label(i, g) := object.get(g, "group_id", sprintf("group_%d", [i]))

application_code_row(code) := row if {
	some row in lists.application_codes
	row.code == code
}
