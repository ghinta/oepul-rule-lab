# Stark stickstoffreduzierte Fütterung von Schweinen ab dem Antragsjahr 2025 (o6_9)
package oepul.o6_9

cp_limits := tables.pig_crude_protein_limits

rations := object.get(pig_feeding, "rations", [])

held_ration_categories := {c | some c in object.get(pig_feeding, "held_categories", [])}

fattening_categories := {c | some c in cp_limits.fattening_group_categories}

# O69-MB-005 / O69-MB-006 / O69-SRL-002: mindestens 1,00 GVE Schweine im Jahresdurchschnitt je ha Ackerfläche (ohne Abzüge).
pig_gve := pig_feeding.pig_gve_annual_average if has_value(pig_feeding, "pig_gve_annual_average")

pig_gve := sum([species_group_gve(g, "gve") | some g in species_groups; g.species == "pigs"]) if {
	not has_value(pig_feeding, "pig_gve_annual_average")
}

pig_gve_per_arable_ha := pig_gve / arable_area_ha if arable_area_ha > 0

pig_feeding_access_met if pig_gve_per_arable_ha >= 1.0

# O69-MB-026: Rohproteingrenzen je kg Ration (88 % TM) gemäß Tabelle.
cp_limit(category) := row.max_crude_protein_g_per_kg_88dm if {
	some row in cp_limits.rows
	row.animal_category == category
}

ration_value(category) := r.crude_protein_g_per_kg_88dm if {
	some r in rations
	r.animal_category == category
}

non_fattening_ration_exceeded contains category if {
	some r in rations
	category := r.animal_category
	not category in fattening_categories
	r.crude_protein_g_per_kg_88dm > cp_limit(category)
}

# O69-MB-027: Mastgruppe – entweder Durchschnittswert (max. 157 g) oder Phasenfütterung je Gewichtsabschnitt.
fattening_average_compliant if {
	has_value(pig_feeding, "fattening_average_crude_protein_g_per_kg_88dm")
	pig_feeding.fattening_average_crude_protein_g_per_kg_88dm <= cp_limits.fattening_group_average_max_g
}

held_fattening_categories := held_ration_categories & fattening_categories

fattening_phase_compliant if {
	count(held_fattening_categories) > 0
	every c in held_fattening_categories {
		ration_value(c) <= cp_limit(c)
	}
}

fattening_group_compliant if count(held_fattening_categories) == 0

fattening_group_compliant if fattening_average_compliant

fattening_group_compliant if fattening_phase_compliant

uses_phase_feeding if {
	count(held_fattening_categories) > 0
	not fattening_average_compliant
	fattening_phase_compliant
}

# Alle am Betrieb gehaltenen Schweine (nicht Mastgruppe) benötigen eine dokumentierte Ration.
missing_rations contains c if {
	some c in held_ration_categories
	not c in fattening_categories
	not ration_value(c)
}

# O69-MB-028: Berechnungsgrundlage Futtermitteluntersuchung, Standardwerte Fachliteratur oder Herstellerangabe.
valid_protein_value_bases := {"feed_analysis", "standard_literature_value", "manufacturer_declaration"}

invalid_protein_basis contains r.animal_category if {
	some r in rations
	not object.get(r, "protein_value_basis", "") in valid_protein_value_bases
}

pig_feeding_compliant if {
	count(non_fattening_ration_exceeded) == 0
	fattening_group_compliant
	count(missing_rations) == 0
}

# O69-MB-033 / O69-SRL-008: keine gleichzeitige Teilnahme an Kategorie (9) und Zuschlag (16).
pig_feeding_combination_conflict if {
	participates_pig_feeding
	is_true(measure, "participates_gwa_n_reduced_feeding_topup")
}

pig_feeding_premium_eligible if {
	participates_pig_feeding
	pig_feeding_access_met
	pig_feeding_compliant
	not pig_feeding_combination_conflict
}

violations contains {"rule_id": "O69-MB-005", "message": sprintf("Weniger als 1,00 GVE Schweine je ha Ackerfläche (%v)", [round2(pig_gve_per_arable_ha)])} if {
	participates_pig_feeding
	not pig_feeding_access_met
	pig_gve_per_arable_ha
}

violations contains {"rule_id": "O69-MB-005", "message": "GVE Schweine je ha Ackerfläche nicht ermittelbar (Ackerfläche fehlt)"} if {
	participates_pig_feeding
	not pig_gve_per_arable_ha
}

violations contains {"rule_id": "O69-MB-026", "message": sprintf("Rohproteingrenze überschritten: %v", [c])} if {
	participates_pig_feeding
	some c in non_fattening_ration_exceeded
}

violations contains {"rule_id": "O69-MB-027", "message": "Mastgruppe: weder Durchschnittswert (max. 157 g) noch Phasengrenzen eingehalten"} if {
	participates_pig_feeding
	not fattening_group_compliant
}

violations contains {"rule_id": "O69-MB-026", "message": sprintf("Keine Ration für gehaltene Tierkategorie dokumentiert: %v", [c])} if {
	participates_pig_feeding
	some c in missing_rations
}

violations contains {"rule_id": "O69-MB-028", "message": sprintf("Unzulässige Grundlage für Rohproteingehalt: %v", [c])} if {
	participates_pig_feeding
	some c in invalid_protein_basis
}

violations contains {"rule_id": "O69-MB-029", "message": "Kein Nachweis über Rezepturen mit Rohproteingehalt je kg Futtermittel (88 % TM)"} if {
	participates_pig_feeding
	not is_true(pig_feeding, "recipe_evidence_available")
}

violations contains {"rule_id": "O69-MB-029", "message": "Phasenfütterung nicht als technisch möglich und tatsächlich durchgeführt plausibilisiert"} if {
	participates_pig_feeding
	uses_phase_feeding
	not is_true(pig_feeding, "phase_feeding_plausible")
}

violations contains {"rule_id": "O69-MB-033", "message": "Gleichzeitige Teilnahme an 'Stark stickstoffreduzierte Fütterung von Schweinen' (9) und dem gleichlautenden Zuschlag (16) nicht möglich"} if {
	pig_feeding_combination_conflict
}

violations contains {"rule_id": "O69-MB-001", "message": "Stark stickstoffreduzierte Fütterung von Schweinen erst ab Antragsjahr 2025 möglich"} if {
	is_true(pig_feeding, "participates")
	year < 2025
}
