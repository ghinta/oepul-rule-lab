# Tierwohl – Schweinehaltung (o6_22): shared data accessors, input accessors and
# animal-category helpers. Source traceability: see rules/rules.json and
# rules/citations.json (rule IDs are referenced in the comments below).
package oepul.o6_22

params := data.o6_22.parameters

space := data.o6_22.space_requirements

general := data.oepul_general.general

lists := data.o6_22.lists

year := input.farm.year

app := object.get(input, ["oepul_application", "o6_22"], {})

oepul_farm := object.get(input, ["farm", "oepul"], {})

r2(x) := round(x * 100) / 100

year_of(date) := to_number(substring(date, 0, 4))

year_start(y) := sprintf("%d-01-01", [y])

year_end(y) := sprintf("%d-12-31", [y])

ns_per_day := 86400000000000

days_between(from_date, to_date) := (time.parse_ns("2006-01-02", to_date) - time.parse_ns("2006-01-02", from_date)) / ns_per_day

# Rule: O622-CAT-01 / O622-CAT-02 (Tierliste categories and their measure categories)
tierliste := {row.code: row | some row in data.o6_22.animal_categories.tierliste}

# Rule: O622-CAT-01 (three measure categories)
measure_categories := {row.code: row | some row in data.o6_22.animal_categories.measure_categories}

# Rule: O622-GVE-01 (GVE factor per Tierliste category, chapter 10 / Anhang A)
gve_factor(tierliste_code) := tierliste[tierliste_code].gve_per_head

# Rule: O622-GEN-LOC-01 (only animals kept in Austria may be listed and counted)
listed_pig_groups := {i: g |
	some i, g in object.get(input, ["livestock", "species_groups"], [])
	g.species == "pigs"
	object.get(g, "kept_in_austria", true) != false
}

# Rule: O622-CAT-02 / O622-APP-05 / O622-SOW-ALL-01 (Zuchteber not eligible; unmated gilts count as Jung-/Mastschweine)
category_groups := {i: g |
	some i, g in listed_pig_groups
	tierliste[g.tierliste_category].premium_eligible == true
}

category_of(g) := tierliste[g.tierliste_category].measure_category

# Rule: O622-GEN-STOCK-01 / O622-ELIG-02 / O622-APP-04 (Stichtag 1 April or annual average from Durchschnittstierliste)
group_count(g) := g.average_animal_count if {
	object.get(input, ["livestock", "average_animal_list_submitted"], false) == true
	is_number(object.get(g, "average_animal_count", null))
} else := g.animal_count

group_gve(g) := group_count(g) * gve_factor(g.tierliste_category)

# GVE of the animals currently present in a group (used for stocking density).
present_gve(g) := g.animal_count * gve_factor(g.tierliste_category)

housing_type(g) := object.get(g, ["housing", "housing_type"], "unknown")

stall(g) := object.get(g, ["housing", "stall"], {})

pasture(g) := object.get(g, ["housing", "pasture"], {})

welfare(g) := object.get(g, "pig_welfare", {})

# Rule: O622-STALL-01 (stall housing incl. combined stall/free-range housing)
stall_kept(g) if housing_type(g) in {"stall", "mixed"}

# Rule: O622-FREE-05 (free-range housing incl. combined housing)
freiland_kept(g) if housing_type(g) in {"pasture", "mixed"}

is_sow_group(g) if measure_categories[category_of(g)].space_table == "sows"
