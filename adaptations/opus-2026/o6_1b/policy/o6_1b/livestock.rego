# Tierhaltung: RGVE-Schlüssel, Eigenschaft als tierhaltender Betrieb, Bio-Tierhaltung,
# Eigenbedarfstiere und Equiden (Kap. 4, 5.1, 12; ATB 5.7; SRL 1.5.4, 1.5.5, Anhang A).
package oepul.o6_1b

species_groups := object.get(input, ["livestock", "species_groups"], [])

rgve_factor(key) := f.rgve if {
	some f in data.o6_1b.rgve_key.rgve_factors
	f.key == key
}

is_conventional_equid(g) if {
	g.species == "horses"
	object.get(g, "is_conventional", false) == true
}

# Konventionelle Equiden werden für die Einstufung als tierhaltender Betrieb nicht berücksichtigt.
counted_rgve_group(g) if {
	_ := rgve_factor(object.get(g, "rgve_key", ""))
	not is_conventional_equid(g)
	object.get(g, "kept_in_austria", true) == true
}

group_rgve(g) := object.get(g, "animal_count", 0) * rgve_factor(g.rgve_key)

total_rgve := sum([group_rgve(g) | some g in species_groups; counted_rgve_group(g)])

# Futterfläche = Grünland + Ackerfutterflächen (inkl. Flächen in Naturschutz / Bergmähdern)
is_arable_forage(p) if {
	p.land_use == "arable"
	land_use_type(p) in lists.arable_forage
}

is_arable_forage(p) if {
	p.land_use == "arable"
	crop_name(p) in lists.arable_forage
}

forage_area_ha := sum([area(p) | some p in parcels; is_forage_parcel(p)])

is_forage_parcel(p) if is_grassland(p)

is_forage_parcel(p) if {
	not is_grassland(p)
	is_arable_forage(p)
}

rgve_per_ha := share(total_rgve, forage_area_ha)

is_livestock_farm if {
	forage_area_ha > 0
	rgve_per_ha >= data.o6_1b.rgve_key.thresholds.livestock_farm_min_rgve_per_ha
}

livestock_category := "non_livestock" if not is_livestock_farm

livestock_category := "livestock_lt_1_4" if {
	is_livestock_farm
	rgve_per_ha < caps.grassland_base_rgve_threshold
}

livestock_category := "livestock_ge_1_4" if {
	is_livestock_farm
	rgve_per_ha >= caps.grassland_base_rgve_threshold
}

stocking_below_1_4 if rgve_per_ha < caps.kreislauf_max_rgve_per_ha_exclusive

# --- Bio-Tierhaltung (Kap. 5.1; SRL 2.1 B) -------------------------------------------

is_own_use_exception(g) if {
	object.get(g, "own_use", false) == true
	g.species == "pigs"
	object.get(g, "category", "") == "fattening_pig"
}

is_own_use_exception(g) if {
	object.get(g, "own_use", false) == true
	g.species == "poultry"
	object.get(g, "category", "") == "chicken"
}

own_use_count(species) := sum([object.get(g, "animal_count", 0) |
	some g in species_groups
	is_own_use_exception(g)
	g.species == species
])

violations contains {"rule_id": "O61B-BV-003", "message": "Mehr als 2 nicht zertifizierte Mastschweine für den Eigenbedarf"} if {
	own_use_count("pigs") > general.own_use_animals.max_fattening_pigs
}

violations contains {"rule_id": "O61B-BV-003", "message": "Mehr als 10 nicht zertifizierte Hühner für den Eigenbedarf"} if {
	own_use_count("poultry") > general.own_use_animals.max_chickens
}

violations contains {"rule_id": "O61B-BV-003", "message": sprintf("Eigenbedarfsregelung gilt nicht für Tierart/Kategorie %s/%s", [g.species, object.get(g, "category", "")])} if {
	some g in species_groups
	object.get(g, "own_use", false) == true
	not is_own_use_exception(g)
}

violations contains {"rule_id": "O61B-BV-002", "message": sprintf("Nicht biologisch gehaltene Nutztiere (%s) – konventioneller Tierhaltungs-Teilbetrieb unzulässig", [g.species])} if {
	livestock_must_be_organic
	some g in species_groups
	object.get(g, "animal_count", 0) > 0
	object.get(g, "is_certified_organic", true) == false
	not is_own_use_exception(g)
	not is_conventional_equid(g)
}

violations contains {"rule_id": "O61B-BV-004", "message": "Gleichzeitige Haltung konventioneller und biologischer Equiden unzulässig"} if {
	some g1 in species_groups
	is_conventional_equid(g1)
	some g2 in species_groups
	g2.species == "horses"
	object.get(g2, "is_conventional", false) == false
	object.get(g2, "animal_count", 0) > 0
}

violations contains {"rule_id": "O61B-BV-007", "message": "Konventionelle Equiden: Kreuz bei 'Konventionelle Pferdehaltung' in der Beilage MFA-Angaben fehlt"} if {
	some g in species_groups
	is_conventional_equid(g)
	object.get(o6_1b_input, "conventional_horse_declared_in_mfa", false) != true
}

# Tierbestand in Österreich (ATB 5.6; SRL 1.4.2.2)
violations contains {"rule_id": "O61B-ATB-008", "message": "Außerhalb Österreichs gehaltene Tiere sind nicht anrechenbar"} if {
	some g in species_groups
	object.get(g, "kept_in_austria", true) == false
	_ := rgve_factor(object.get(g, "rgve_key", ""))
}
