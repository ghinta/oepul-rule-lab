# Definition und Förderverpflichtungen der Kategorie „Agroforststreifen" (AFS)
# (Informationsblatt 1C Kap. 4.1, 5.2, 6; SRL Punkt 2.1C Definitionen/Förderverpflichtungen).
package oepul.o6_1c

negative_list_names := {lower(n.scientific_name) | some n in data.o6_1c.afs_negative_list}

# Gattungseinträge (z. B. Elaeagnus) erfassen alle Arten dieser Gattung.
negative_list_genera := {lower(n.scientific_name) | some n in data.o6_1c.afs_negative_list; n.taxon_rank == "genus"}

on_negative_list(scientific_name) if lower(scientific_name) in negative_list_names

on_negative_list(scientific_name) if {
	genus := split(lower(scientific_name), " ")[0]
	genus in negative_list_genera
}

trees_per_100_m(s) := (s.tree_count * 100) / s.length_m if s.length_m > 0

negative_species_present(s) := {sp.scientific_name |
	some sp in object.get(s, "species", [])
	on_negative_list(sp.scientific_name)
	object.get(sp, "count", 1) > 0
}

# O61C-DEF-AFS-001..008: geometrische und inhaltliche Mindestkriterien der Definition.
afs_defect(s, "O61C-DEF-AFS-001") if object.get(s, "adjacent_to_arable", false) != true

afs_defect(s, "O61C-DEF-AFS-002") if object.get(s, "establishment_year", 0) < params.afs_min_establishment_year

afs_defect(s, "O61C-DEF-AFS-003") if object.get(s, "average_width_m", 0) < params.afs_min_average_width_m

afs_defect(s, "O61C-DEF-AFS-003") if object.get(s, "average_width_m", 0) > params.afs_max_average_width_m

afs_defect(s, "O61C-DEF-AFS-004") if not trees_per_100_m(s)

afs_defect(s, "O61C-DEF-AFS-004") if trees_per_100_m(s) < params.afs_min_trees_per_100_m

afs_defect(s, "O61C-DEF-AFS-004") if trees_per_100_m(s) > params.afs_max_trees_per_100_m

afs_defect(s, "O61C-DEF-AFS-005") if object.get(s, "max_tree_spacing_m", 0) > params.afs_max_tree_spacing_m

afs_defect(s, "O61C-DEF-AFS-006") if object.get(s, "is_special_crop_gspav_25_4", false) == true

afs_defect(s, "O61C-DEF-AFS-007") if count(negative_species_present(s)) > 0

afs_defect(s, "O61C-DEF-AFS-008") if {
	object.get(s, "long_side_adjacent_to_forest_or_area_landscape_element", false) == true
}

afs_defect_ids := [
	"O61C-DEF-AFS-001", "O61C-DEF-AFS-002", "O61C-DEF-AFS-003", "O61C-DEF-AFS-004",
	"O61C-DEF-AFS-005", "O61C-DEF-AFS-006", "O61C-DEF-AFS-007", "O61C-DEF-AFS-008",
]

afs_definition_defects(s) := {id | some id in afs_defect_ids; afs_defect(s, id)}

afs_meets_definition(s) if count(afs_definition_defects(s)) == 0

afs_violations contains v if {
	some s in agroforestry_strips
	some rid in afs_definition_defects(s)
	v := {"rule_id": rid, "scope": s.strip_id, "message": "Agroforststreifen erfüllt die Definition gemäß Informationsblatt Kap. 4.1 nicht"}
}

afs_violations contains v if {
	some s in agroforestry_strips
	object.get(s, "schlagnutzungsart", null) != params.afs_schlagnutzungsart
	v := {"rule_id": "O61C-APPL-005", "scope": s.strip_id, "message": "Agroforststreifen nicht mit Schlagnutzungsart „LSE Agroforststreifen\" beantragt"}
}

# O61C-AFS-001: Neuanlage bis spätestens 15. Mai des Antragsjahres.
afs_violations contains v if {
	some s in agroforestry_strips
	object.get(s, "establishment_year", 0) == year
	d := object.get(s, "planting_date", null)
	d != null
	d > date_in_year(params.afs_new_planting_deadline_month_day)
	v := {"rule_id": "O61C-AFS-001", "scope": s.strip_id, "message": sprintf("Neuanlage am %s nach dem 15. Mai", [d])}
}

# O61C-AFS-002: Entnahme von Gehölzen nur bei weiterer Einhaltung der Mindestkriterien oder Nachpflanzung bis 15. Mai.
afs_violations contains v if {
	some s in agroforestry_strips
	object.get(s, "trees_removed", false) == true
	d := object.get(s, "replanting_date", null)
	d != null
	d > date_in_year(params.afs_replanting_deadline_month_day)
	v := {"rule_id": "O61C-AFS-002", "scope": s.strip_id, "message": sprintf("Nachpflanzung am %s nach dem 15. Mai", [d])}
}

afs_violations contains v if {
	some s in agroforestry_strips
	object.get(s, "trees_removed", false) == true
	object.get(s, "replanting_date", null) == null
	not afs_meets_definition(s)
	v := {"rule_id": "O61C-AFS-002", "scope": s.strip_id, "message": "Gehölzentnahme ohne Einhaltung der Mindestkriterien und ohne Nachpflanzung"}
}

# O61C-AFS-003: erforderliche Pflegemaßnahmen (Pflanzpfahl, Verbissschutz, bedarfsgerechte Pflegeschnitte).
required_care_measures := ["stake_stabilization", "browsing_protection", "pruning_as_needed"]

afs_violations contains v if {
	some s in agroforestry_strips
	some c in required_care_measures
	object.get(s, ["care", c], false) != true
	v := {"rule_id": "O61C-AFS-003", "scope": s.strip_id, "message": sprintf("Pflegemaßnahme %s nicht erfüllt", [c])}
}

# O61C-AFS-004: krautiger Bereich dauerhaft begrünt.
afs_violations contains v if {
	some s in agroforestry_strips
	object.get(s, "herbaceous_permanently_green", false) != true
	v := {"rule_id": "O61C-AFS-004", "scope": s.strip_id, "message": "Krautiger Bereich nicht dauerhaft begrünt"}
}

# O61C-AFS-005: keine Nutzung (Mahd mit Abtransport oder Weide) des krautigen Bereichs; Pflegemahd/Häckseln erlaubt.
permitted_herbaceous_treatments := {"none", "maintenance_mowing", "mulching"}

afs_violations contains v if {
	some s in agroforestry_strips
	u := object.get(s, "herbaceous_use", "none")
	not u in permitted_herbaceous_treatments
	v := {"rule_id": "O61C-AFS-005", "scope": s.strip_id, "message": sprintf("Unzulässige Nutzung des krautigen Bereichs: %v", [u])}
}

# O61C-AFS-006: Dünge- und Pflanzenschutzmittelverbot auf der gesamten Fläche; nur bio-zugelassener Verbissschutz.
afs_violations contains v if {
	some s in agroforestry_strips
	object.get(s, "fertilizer_used", false) == true
	v := {"rule_id": "O61C-AFS-006", "scope": s.strip_id, "message": "Düngung auf Agroforststreifen verboten"}
}

afs_violations contains v if {
	some s in agroforestry_strips
	object.get(s, "psm_used", false) == true
	v := {"rule_id": "O61C-AFS-006", "scope": s.strip_id, "message": "Pflanzenschutzmittel auf Agroforststreifen verboten"}
}

afs_violations contains v if {
	some s in agroforestry_strips
	object.get(s, "browsing_protection_agent_used", false) == true
	object.get(s, "browsing_protection_agent_bio_approved", false) != true
	v := {"rule_id": "O61C-AFS-006", "scope": s.strip_id, "message": "Verbissschutzmittel nicht gemäß Verordnung (EU) 2018/848 zugelassen"}
}

afs_violations contains v if {
	some s in agroforestry_strips
	some other in object.get(parcel_status(s), "other_measure_premium_codes", [])
	not combinable_on_single_area(params.measure_code, other)
	v := {"rule_id": "O61C-COMB-002", "scope": s.strip_id, "message": sprintf("Agroforststreifen laut Anhang L nicht mit Maßnahme %v auf der Einzelfläche kombinierbar", [other])}
}

# O61C-APPL-006: Bei Teilnahme an der Kategorie müssen alle beantragten Agroforststreifen die Verpflichtungen erfüllen.
default afs_all_strips_compliant := false

afs_all_strips_compliant if {
	count(agroforestry_strips) > 0
	count({v | some v in afs_violations}) == 0
}

# O61C-APPL-007: dem Feldstück zugeordnete Agroforststreifen werden bei UBB/BIO auf die 0,15 ha
# Biodiversitätsflächen auf Ackerfeldstücken > 5 ha angerechnet (nicht auf die 7 %-Grenze).
default ubb_or_bio_participant := false

ubb_or_bio_participant if participates("1A")

ubb_or_bio_participant if participates("1B")

afs_credit_15a_by_feldstueck[fid] := credited if {
	ubb_or_bio_participant
	arable_area_ha >= params.ubb_bio_feldstueck_rule_min_arable_area_ha
	some f in feldstuecke
	fid := f.feldstueck_id
	f.arable_area_ha > params.ubb_bio_feldstueck_threshold_ha
	credited := sum([object.get(s, "area_ha", 0) |
		some s in agroforestry_strips
		object.get(s, "assigned_feldstueck_id", null) == fid
	])
}

afs_counts_toward_7_percent := false
