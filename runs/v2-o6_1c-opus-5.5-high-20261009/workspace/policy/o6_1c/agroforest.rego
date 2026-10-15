package oepul.o6_1c

# Definition und Förderverpflichtungen der Kategorie "Agroforststreifen".

afs_params := params.agroforest

# O6_1C-APP-005: Bei Teilnahme an der Kategorie müssen alle beantragten
# Agroforststreifen nach den Förderverpflichtungen bewirtschaftet werden.
afs_parcels contains p if {
	some p in parcels
	object.get(p, ["o6_1c", "category"], null) == "agroforest"
}

afs_parcels contains p if {
	"agroforest" in applied_categories
	some p in parcels
	object.get(p, "field_use_type", null) == params.application.agroforest_field_use_type
}

afs(p) := object.get(p, ["o6_1c", "agroforest"], {})

trees_per_100_m(p) := (afs(p).tree_count * 100) / afs(p).length_m if afs(p).length_m > 0

negative_list_names := {lower(row.scientific_name) | some row in data.o6_1c.agroforest_negative_list.rows; row.taxon_rank == "species"}

negative_list_genera := {lower(row.scientific_name) | some row in data.o6_1c.agroforest_negative_list.rows; row.taxon_rank == "genus"}

on_negative_list(species) if lower(species) in negative_list_names

on_negative_list(species) if {
	some genus in negative_list_genera
	startswith(lower(species), genus)
}

afs_woody_species(p) := {s | some s in object.get(afs(p), "woody_species", [])}

# Definitionsmerkmale (O6_1C-AFS-DEF-001 bis -010).
afs_definition_violations contains violation("O6_1C-AFS-DEF-001", p, "Agroforststreifen muss direkt an Ackerflächen angrenzen") if {
	some p in afs_parcels
	afs(p).directly_adjacent_to_arable == false
}

afs_definition_violations contains violation("O6_1C-AFS-DEF-002", p, "Agroforststreifen muss ab dem Jahr 2020 neu angelegt worden sein") if {
	some p in afs_parcels
	afs(p).establishment_year < afs_params.earliest_establishment_year
}

afs_definition_violations contains violation("O6_1C-AFS-DEF-003", p, "Durchschnittliche Breite muss mindestens 2 m und höchstens 10 m betragen") if {
	some p in afs_parcels
	w := afs(p).average_width_m
	not width_in_range(w)
}

width_in_range(w) if {
	w >= afs_params.min_average_width_m
	w <= afs_params.max_average_width_m
}

afs_definition_violations contains violation("O6_1C-AFS-DEF-004", p, "Dichte muss mindestens 10 bis höchstens 25 Bäume pro 100 Laufmeter betragen") if {
	some p in afs_parcels
	d := trees_per_100_m(p)
	not density_in_range(d)
}

density_in_range(d) if {
	d >= afs_params.min_trees_per_100_m
	d <= afs_params.max_trees_per_100_m
}

afs_definition_violations contains violation("O6_1C-AFS-DEF-005", p, "Maximaler Baumabstand von 15 m überschritten") if {
	some p in afs_parcels
	afs(p).max_tree_spacing_m > afs_params.max_tree_spacing_m
}

afs_definition_violations contains violation("O6_1C-AFS-DEF-006", p, "Agroforststreifen darf keiner Spezialkultur gemäß § 25 Abs. 4 GSP-AV entsprechen") if {
	some p in afs_parcels
	afs(p).is_special_crop_gsp_av_25_4 == true
}

afs_definition_violations contains violation("O6_1C-AFS-DEF-008", p, sprintf("Gehölz der Negativliste vorhanden (%s); darf nicht gepflanzt werden bzw. ist bei natürlichem Anflug zu entfernen", [s])) if {
	some p in afs_parcels
	some s in afs_woody_species(p)
	on_negative_list(s)
}

afs_definition_violations contains violation("O6_1C-AFS-DEF-009", p, "Agroforststreifen darf entlang der Längsseite nicht an Wald oder ein flächiges Landschaftselement angrenzen") if {
	some p in afs_parcels
	afs(p).long_side_adjacent_to_forest_or_areal_landscape_element == true
}

afs_definition_violations contains violation("O6_1C-AFS-DEF-010", p, "Agroforststreifen muss sich auf einer Referenzfläche befinden oder unmittelbar an eine solche angrenzen") if {
	some p in afs_parcels
	afs(p).on_or_adjacent_to_reference_area == false
}

# O6_1C-AFS-DEF-007: Pflanzung von Sträuchern zwischen den Bäumen zulässig
# (keine Verletzung); als Information ausgegeben.
afs_shrubs_permitted contains parcel_id(p) if {
	some p in afs_parcels
	afs(p).shrubs_between_trees == true
}

afs_meets_definition(p) if {
	p in afs_parcels
	count({v | some v in afs_definition_violations; v.parcel_id == parcel_id(p)}) == 0
}

# O6_1C-AFS-001: Neuanlage bis spätestens 15. Mai des Antragsjahres.
afs_commitment_violations contains violation("O6_1C-AFS-001", p, "Neuanlage des Agroforststreifens bis spätestens 15. Mai des Antragsjahres") if {
	some p in afs_parcels
	afs(p).establishment == "new_planting"
	afs(p).planting_date > date_of(year, afs_params.latest_planting_mmdd)
}

# O6_1C-AFS-002: Entnahme von Gehölzen nur, wenn Mindestkriterien weiter
# eingehalten werden oder Nachpflanzung bis 15. Mai.
timely_replanting(p) if {
	rd := object.get(afs(p), "replanting_date", null)
	rd != null
	rd <= date_of(year, afs_params.latest_replanting_mmdd)
}

afs_commitment_violations contains violation("O6_1C-AFS-002", p, "Gehölzentnahme ohne Einhaltung der Mindestkriterien und ohne Nachpflanzung bis 15. Mai") if {
	some p in afs_parcels
	afs(p).woody_plants_removed == true
	not afs_meets_definition(p)
	not timely_replanting(p)
}

# O6_1C-AFS-003: Pflege – Pflanzpfahl, Verbissschutz, bedarfsgerechte Pflegeschnitte.
afs_commitment_violations contains violation("O6_1C-AFS-003", p, sprintf("Unbedingt erforderliche Pflegemaßnahme fehlt: %s", [k])) if {
	some p in afs_parcels
	some k in ["staking", "browsing_protection", "pruning_as_needed"]
	object.get(afs(p), ["care", k], true) == false
}

# O6_1C-AFS-004: Krautiger Bereich dauerhaft begrünt.
afs_commitment_violations contains violation("O6_1C-AFS-004", p, "Der krautige Bereich ist dauerhaft zu begrünen") if {
	some p in afs_parcels
	afs(p).herbaceous_area_permanently_green == false
}

# O6_1C-AFS-005: Keine Nutzung des krautigen Bereichs (Mahd oder Weide);
# Pflegemahd ohne Abtransport oder Häckseln erlaubt.
afs_commitment_violations contains violation("O6_1C-AFS-005", p, "Nutzung des krautigen Bereichs (Mahd mit Abtransport oder Weide) ist nicht zulässig") if {
	some p in afs_parcels
	afs(p).herbaceous_area_use in {"mowing_with_removal", "grazing"}
}

# O6_1C-AFS-006: Dünge- und Pflanzenschutzmittelverbot auf der gesamten Fläche;
# nur Bio-zugelassener Verbissschutz zulässig.
afs_commitment_violations contains violation("O6_1C-AFS-006", p, "Einsatz von Düngemitteln auf dem Agroforststreifen verboten") if {
	some p in afs_parcels
	afs(p).fertilizer_used == true
}

afs_commitment_violations contains violation("O6_1C-AFS-006", p, "Einsatz von Pflanzenschutzmitteln auf dem Agroforststreifen verboten") if {
	some p in afs_parcels
	afs(p).psm_used == true
}

afs_commitment_violations contains violation("O6_1C-AFS-006", p, "Nur gemäß VO (EU) 2018/848 zugelassener Verbissschutz zulässig") if {
	some p in afs_parcels
	afs(p).browsing_protection_agent_used == true
	not afs(p).browsing_protection_agent_bio_approved == true
}

# O6_1C-APP-004: Beantragung als Schlagnutzungsart "LSE Agroforststreifen".
afs_commitment_violations contains violation("O6_1C-APP-004", p, "Agroforststreifen sind mit der Schlagnutzungsart LSE Agroforststreifen zu beantragen") if {
	some p in afs_parcels
	object.get(p, "field_use_type", null) != params.application.agroforest_field_use_type
}

# O6_1C-AFS-007: Dem Feldstück zugeordnete Agroforststreifen werden bei UBB/BIO
# für die 0,15 ha Biodiversitätsflächen auf Ackerfeldstücken > 5 ha angerechnet
# (nicht jedoch für die 7-%-Grenze).
afs_area_by_field_piece[fp] := a if {
	some fp in ({object.get(afs(p), "assigned_field_piece_id", null) | some p in afs_parcels} - {null})
	a := sum([object.get(q, "area_ha", 0) |
		some q in afs_parcels
		object.get(afs(q), "assigned_field_piece_id", null) == fp
		afs_meets_definition(q)
	])
}

ubb_bio_creditable_afs_area_by_field_piece[fp] := a if {
	some fp, a in afs_area_by_field_piece
	some piece in object.get(input, ["land", "field_pieces"], [])
	piece.field_piece_id == fp
	piece.arable_area_ha > params.general.ubb_bio_field_piece_threshold_ha
}

afs_counts_towards_ubb_bio_seven_percent := false

# O6_1C-AFS-008: Umwandlung von Flächen mehrjähriger Maßnahmen in LSE
# Agroforststreifen ist ein zulässiger Flächenabgang (keine Rückzahlung).
conversion_permitted(from_use, to_use) if {
	some row in data.o6_1c.permitted_land_use_conversions.rows
	row.to == to_use
	some f in row.from
	f in {"*", from_use}
}
