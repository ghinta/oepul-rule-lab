# Eigenschaft als tierhaltender Betrieb (Merkblatt Kap. 4 und 8, SRL 1.5.4/1.5.5, Anhang A).
package o6_3

# O6_3-LH-03: RGVE-Umrechnungsfaktor je Tierkategorie laut RGVE-Schlüssel.
rgve_factor(category) := row.rgve_per_head if {
	some row in data.o6_3.rgve_key.rows
	row.category_id == category
}

# GEN-LH-01: Durchschnittsbestand (Rinderdatenbank bzw. Durchschnittstierliste) vor Stichtagsbestand.
group_head_count(g) := g.average_count if {
	is_number(object.get(g, "average_count", null))
} else := object.get(g, "animal_count", 0)

# O6_3-LH-02 / GEN-LOC-01: nur raufutterverzehrende Tiere der zulässigen Arten, im Inland gehalten.
rgve_group(g) if {
	object.get(g, "kept_in_austria", true) == true
	rgve_factor(object.get(g, "rgve_category", ""))
}

group_rgve(g) := group_head_count(g) * rgve_factor(g.rgve_category)

total_rgve := sum([group_rgve(g) | some g in species_groups; rgve_group(g)])

# O6_3-LH-04 / O6_3-LH-05 / O6_3-LH-06: Futterfläche = Grünland + Ackerfutterflächen (ohne Zweitkultur).
counts_as_forage_area(p) if p.land_use == "grassland"

counts_as_forage_area(p) if {
	p.land_use == "arable"
	forage_crop_type(p) in density_forage_crop_ids
	not is_second_crop(p)
}

forage_area_ha := sum([p.area_ha | some p in parcels; counts_as_forage_area(p)])

livestock_density := total_rgve / forage_area_ha if forage_area_ha > 0

# O6_3-LH-02: tierhaltender Betrieb ab 0,30 RGVE/ha Futterfläche.
is_livestock_farm if livestock_density >= params.livestock_density_threshold_rgve_per_ha

livestock_status := "tierhaltend" if {
	is_livestock_farm
} else := "nicht_tierhaltend"
