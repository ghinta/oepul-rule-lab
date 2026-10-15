package oepul.o6_17.livestock

# Eigenschaft als tierhaltender Betrieb (Informationsblatt Kapitel 4 und 11,
# SRL 1.5.4/1.5.5, Anhang A).

import data.oepul.o6_17.common

key := data.o6_17_tables.rgve_key

categories := {c.id: c | some c in key.categories}

fodder_crops := {c | some c in data.o6_17_tables.obligation_lists.arable_fodder_crops}

species_groups := object.get(input, ["livestock", "species_groups"], [])

# Nur in Österreich gehaltene Tiere sind anrechenbar.
counted_groups := [g |
	some g in species_groups
	object.get(g, "kept_in_austria", true) != false
]

known_category(g) if categories[g.rgve_category]

group_rgve(g) := g.animal_count * categories[g.rgve_category].rgve_per_head

unknown_rgve_categories contains c if {
	some g in counted_groups
	not known_category(g)
	c := object.get(g, "rgve_category", "fehlt")
}

rgve_total := common.round3(sum([group_rgve(g) | some g in counted_groups; known_category(g)]))

is_arable_fodder(p) if {
	p.land_use == "arable"
	common.normalize(object.get(p, ["crop", "crop_name"], "")) in fodder_crops
}

is_fodder_area(p) if p.land_use == "grassland"

is_fodder_area(p) if is_arable_fodder(p)

# Futterfläche = Summe der Grünland- und Ackerfutterflächen (alle beantragten
# Futterflächen, auch in Naturschutz oder Bergmähder eingebrachte).
fodder_area_ha := sum([p.area_ha | some p in common.parcels; is_fodder_area(p)])

rgve_per_ha_fodder_area := rgve_total / fodder_area_ha if fodder_area_ha > 0

is_livestock_holding if rgve_per_ha_fodder_area >= key.livestock_holding_min_rgve_per_ha_fodder_area

default is_livestock_holding := false
