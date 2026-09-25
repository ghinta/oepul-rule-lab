# Common helpers and input accessors for ÖPUL measure o6_9
# "Bodennahe Ausbringung flüssiger Wirtschaftsdünger und Gülleseparation".
package oepul.o6_9

params := data.o6_9.measure_parameters

general := data.o6_9.general_conditions

year := input.farm.year

parcels := object.get(input, ["land", "parcels"], [])

species_groups := object.get(input, ["livestock", "species_groups"], [])

applications := object.get(input, "oepul_applications", [])

manure := object.get(input, "manure_management", {})

evidence := object.get(manure, "evidence", {})

documentation := object.get(input, "documentation", {})

year_end(y) := sprintf("%d-12-31", [y])

dated(y, mmdd) := sprintf("%d-%s", [y, mmdd])

round2(x) := round(x * 100) / 100

number_or_zero(x) := x if is_number(x)

else := 0

# Parcels outside Austria are neither funded nor counted (SRL 1.4.2.1).
parcel_in_austria(p) if object.get(p, "in_austria", true) != false

# Animals kept outside Austria are not counted (SRL 1.4.2.2).
kept_in_austria(g) if object.get(g, "kept_in_austria", true) != false

parcel_index := {p.parcel_id: p | some p in parcels}

# GVE factor from Annex A: pigs use the GVE column, all other species the RGVE column.
gve_key_factor(category_id) := f if {
	some row in data.o6_9.gve_key
	row.category_id == category_id
	row.species == "pigs"
	f := row.gve
}

gve_key_factor(category_id) := f if {
	some row in data.o6_9.gve_key
	row.category_id == category_id
	row.species != "pigs"
	f := row.rgve
}

# Annual-average GVE of a livestock group: explicit annual average, else
# Annex A factor times average head count, else the profile GVE value.
gve_of(g) := x if {
	x := g.gve_annual_average
	is_number(x)
} else := x if {
	f := gve_key_factor(g.gve_key_category)
	x := round((f * number_or_zero(object.get(g, "average_animal_count", object.get(g, "animal_count", 0)))) * 1000000) / 1000000
} else := x if {
	x := g.gve
	is_number(x)
} else := 0

cattle_gve := sum([gve_of(g) |
	some g in species_groups
	g.species == "cattle"
	kept_in_austria(g)
])

pig_gve := sum([gve_of(g) |
	some g in species_groups
	g.species == "pigs"
	kept_in_austria(g)
])

total_area_ha := number_or_zero(object.get(input, ["land", "total_area_ha"], 0))
