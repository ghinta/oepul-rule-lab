package oepul.o6_22

import rego.v1

tables := data.o6_22_tables
application := input.oepul_22
year := input.farm.year

nonnegative(n) if {
	is_number(n)
	n >= 0
}

day(s) := time.parse_rfc3339_ns(sprintf("%sT00:00:00Z", [s]))

days_between(start, end) := (day(end) - day(start)) / 86400000000000

entry_timely(kind, filed, y) if {
	last := {"category": 2027, "option": 2028}[kind]
	y >= 2023
	y <= last
	day(filed) <= day(sprintf("%d-12-31", [y - 1]))
}

correction_timely(received, filed) if {
	days := days_between(received, filed)
	days >= 0
	days <= 28
}

stock_count(g) := n if {
	application.stock_basis == "average"
	n := g.year_average_count
	nonnegative(n)
}

stock_count(g) := n if {
	application.stock_basis == "april_1"
	application.fluctuating_stock == false
	n := g.animal_count
	nonnegative(n)
}

# Der TGD-Bestand umfasst alle förderbaren Schweine am Betrieb vor Abzug von Teilabmeldungen.
inventory(g) := 0 if {
	g.held_in_austria == false
} else := 0 if {
	g.category in {"breeding_boar", "under_8", "outdoor_wild_boar"}
} else := n if {
	g.held_in_austria == true
	n := decimal_product(stock_count(g), stock_class_by_id[g.category].gve)
}

selected(g) if {
	stock_class_by_id[g.category].category in application.categories
}

net_heads(g) := 0 if {
	g.held_in_austria == false
} else := 0 if {
	g.category in {"breeding_boar", "under_8", "outdoor_wild_boar"}
} else := 0 if {
	is_object(stock_class_by_id[g.category])
	is_array(application.categories)
	not selected(g)
} else := n if {
	selected(g)
	g.held_in_austria == true
	nonnegative(g.withdrawn_count)
	n := decimal_sum([stock_count(g), decimal_product(-1, g.withdrawn_count)])
	n >= 0
}

net_gve(g) := 0 if {
	net_heads(g) == 0
} else := n if {
	n := decimal_product(net_heads(g), stock_class_by_id[g.category].gve)
}

pigs := [g | some g in input.livestock.species_groups; g.species == "pigs"] if {
	is_array(input.livestock.species_groups)
	every g in input.livestock.species_groups { is_string(g.species) }
}

farm_pig_gve := decimal_sum(values) if {
	values := [v | some g in pigs; v := inventory(g)]
	count(values) == count(pigs)
}

participating_gve := decimal_sum(values) if {
	is_array(application.categories)
	every cat in application.categories { cat in {"piglet", "fattening", "sow"} }
	values := [v | some g in pigs; v := net_gve(g)]
	count(values) == count(pigs)
}

minimum_met := participating_gve >= 2

tgd_required := farm_pig_gve > 10

tgd_start(y) := "2023-04-15" if y == 2023

else := sprintf("%d-01-01", [y])

tgd_period_ok if {
	tgd_required == false
}

tgd_period_ok if {
	tgd_required
	t := application.tgd
	t.recognised_for_pigs
	day(t.start) <= day(tgd_start(year))
	day(t.end) >= day(sprintf("%d-12-31", [year]))
}

category_heads(cat) := decimal_sum([net_heads(g) | some g in pigs; stock_class_by_id[g.category].category == cat]) if {
	is_number(participating_gve)
	cat in application.categories
}

category_lapses(cat) if category_heads(cat) == 0

category_gve(cat) := decimal_sum([net_gve(g) | some g in pigs; stock_class_by_id[g.category].category == cat]) if {
	is_number(participating_gve)
	cat in application.categories
}

rate(cat, component, y) := row.eur_gve if {
	some row in tables.rates
	row.category == cat
	row.component == component
	y >= row.start
	y <= row.end
}

tail_ok(cat) if {
	cat in {"piglet", "fattening"}
	category_heads(cat) > 0
	every g in pigs {
		tail_group_ok(g, cat)
	}
}

tail_group_ok(g, cat) if stock_class_by_id[g.category].category != cat

else if net_heads(g) == 0

else if g.participants_uncut_all_year == true

component_applies(_, "base") := true

component_applies(cat, "tail") if {
	cat in application.uncut_categories
	tail_ok(cat)
}

component_applies(_, "feed") if {
	application.feed_option
	feed_ok
}

component_applies(_, "compost") if {
	application.compost_option
	compost_ok
}

# Rechnerische Einzelbeträge aus der bereinigten Tierliste vor Modulation und Sanktionen.
premium_components[cat][component] := amount if {
	minimum_met
	some cat in application.categories
	category_heads(cat) > 0
	some component in {"base", "tail", "feed", "compost"}
	component_applies(cat, component)
	amount := decimal_product(category_gve(cat), rate(cat, component, year))
}

stock_class_by_id[row.id] := row if some row in tables.stock_classes
