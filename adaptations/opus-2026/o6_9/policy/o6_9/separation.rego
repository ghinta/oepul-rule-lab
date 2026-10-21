# Gülleseparation von am Betrieb angefallener Rindergülle (o6_9)
package oepul.o6_9

separation_records := object.get(separation, "records", [])

separated_volume_claimed := object.get(separation, "separated_volume_m3", 0)

# O69-MB-021 / O69-MB-022: nur am Betrieb durch Rinderhaltung angefallene, tatsächlich separierte Gülle ist förderbar.
separation_ineligible_volume := object.get(separation, "external_cattle_slurry_m3", 0) + object.get(separation, "non_cattle_slurry_m3", 0)

eligible_separation_volume_raw := max2(separated_volume_claimed - separation_ineligible_volume, 0)

# O69-MB-043 / O69-SRL-006: Rinder-GVE aus der Rinderdatenbank, unabhängig vom Aufstallungssystem.
cattle_gve := measure.cattle_gve_annual_average if has_value(measure, "cattle_gve_annual_average")

cattle_gve := sum([species_group_gve(g, "rgve") | some g in species_groups; g.species == "cattle"]) if {
	not has_value(measure, "cattle_gve_annual_average")
}

# GVE einer Tiergruppe: angegebener GVE-Wert, sonst Stückzahl (Jahresdurchschnitt) x Faktor gemäß Anhang A.
species_group_gve(g, _) := g.gve if has_value(g, "gve")

species_group_gve(g, column) := animal_count_for_gve(g) * gve_factor(g.species, g.category, column) if {
	not has_value(g, "gve")
}

animal_count_for_gve(g) := g.annual_average_count if has_value(g, "annual_average_count")

animal_count_for_gve(g) := object.get(g, "animal_count", 0) if not has_value(g, "annual_average_count")

gve_factor(species, category, column) := f if {
	some row in tables.gve_key.rows
	row.species == species
	row.category == category
	f := row[column]
	f != null
}

separation_cap_m3 := tables.premium_rates.caps.separation_m3_per_cattle_gve * cattle_gve

violations contains {"rule_id": "O69-MB-021", "message": "Gülleseparation muss mittels mechanischer Einrichtung in feste und flüssige Phase erfolgen"} if {
	separated_volume_claimed > 0
	is_false(separation, "mechanical_separation")
}

violations contains {"rule_id": "O69-MB-022", "message": "Betriebsfremde Rindergülle bzw. Nicht-Rindergülle ist bei der Gülleseparation nicht förderbar"} if {
	separation_ineligible_volume > 0
}

violations contains {"rule_id": "O69-MB-023", "message": "Aufzeichnungen über Datum und Menge der Gülleseparierung fehlen oder sind unvollständig"} if {
	separated_volume_claimed > 0
	count(separation_records) == 0
}

violations contains {"rule_id": "O69-MB-023", "message": sprintf("Separationsaufzeichnung %d ohne Datum oder Menge", [i])} if {
	some i, r in separation_records
	separation_record_incomplete(r)
}

separation_record_incomplete(r) if not has_value(r, "date")

separation_record_incomplete(r) if not has_value(r, "volume_m3")

violations contains {"rule_id": "O69-GEN-021", "message": "Beantragte separierte Menge übersteigt die aufgezeichnete Menge"} if {
	count(separation_records) > 0
	separated_volume_claimed > sum([object.get(r, "volume_m3", 0) | some r in separation_records])
}

violations contains {"rule_id": "O69-MB-024", "message": "Einsatz betriebsfremder Separationsgeräte ohne Rechnung oder geeignete Unterlagen"} if {
	is_true(separation, "contractor_used")
	not is_true(separation, "contractor_invoice_available")
}

violations contains {"rule_id": "O69-MB-025", "message": "Gemeinschaftlich angeschaffter Separator: nicht kontrollierbar oder Rechnung nicht an teilnehmende Betriebe ausgestellt"} if {
	shared := object.get(separation, "shared_equipment", {})
	is_true(shared, "used")
	shared_equipment_conditions_unmet(shared)
}
