# Modul:
#   o6_17 – Eigenschaft als tierhaltender Betrieb (RGVE je Hektar Futterfläche)
package oepul.o6_17

species_groups := object.get(input, ["livestock", "species_groups"], [])

# RGVE-Schlüssel (Merkblatt Kapitel 11 / SRL Anhang A / § 21 Abs. 4 GSP-AV)
rgve_row(g) := row if {
	some row in cfg.rgve_key.rgve_conversion
	row.key == object.get(g, "rgve_category", "")
	row.counts_for_livestock_status == true
}

# Nur im Inland gehaltene Tiere sind anrechenbar (SRL 1.4.2.2)
kept_in_austria(g) if object.get(g, "kept_in_austria", true) == true

rgve_total := sum([n | some g in species_groups; kept_in_austria(g); row := rgve_row(g); n := g.animal_count * row.rgve_per_head])

# Futterfläche = Summe der Grünland- und Ackerfutterflächen
forage_area_ha := grassland_area_ha + arable_forage_area_ha

livestock_density_rgve_per_ha := rgve_total / forage_area_ha if forage_area_ha > 0

is_livestock_farm if livestock_density_rgve_per_ha >= cfg.rgve_key.livestock_density_threshold_rgve_per_ha
