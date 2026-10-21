# Optionale Zuschläge: Humusaufbau und Erosionsschutz in Wien (4.9), stark stickstoffreduzierte Fütterung von
# Schweinen (4.10) und Cultan-Düngung (4.11).
package oepul.o6_16

import data.o6_16 as d

# --- Wien: keine wendende Bodenbearbeitung im Vertragszeitraum (ausgenommen nach Mais) ---
obligation_violations contains v if {
	wien_option_applied
	some p in wien_area_parcels
	object.get(p, ["operations", "tillage_type"], "unknown") == "plough"
	object.get(p, ["operations", "inversion_tillage_after_maize"], false) != true
	v := {
		"rule_id": "O616-WIEN-002",
		"parcel_id": p.parcel_id,
		"message": "Wendende Bodenbearbeitung im Gebiet Wien (nicht nach Mais) bei Zuschlag Humusaufbau und Erosionsschutz",
	}
}

obligation_violations contains v if {
	wien_option_applied
	object.get(wien_option, "project_data_provided_on_request", true) == false
	v := {
		"rule_id": "O616-WIEN-003",
		"message": "Daten zur Flächenbewirtschaftung bzw. Bodenproben nicht an die Projektbeauftragten übermittelt",
	}
}

# --- Schweinefütterung: Rohproteingrenzen je kg Ration (88 % TM) bei allen am Betrieb gehaltenen Schweinen ---
cp_limit(cat) := r if {
	some r in d.pig_crude_protein_limits
	r.category == cat
}

pig_group_cp_compliant(g) if {
	lim := cp_limit(g.category)
	lim.average_or_phase_alternative
	object.get(g, ["feeding", "mode"], "average") == "average"
	g.feeding.crude_protein_average_g_per_kg <= lim.average_max_g_per_kg_88dm
}

pig_group_cp_compliant(g) if {
	lim := cp_limit(g.category)
	lim.average_or_phase_alternative
	g.feeding.mode == "phase"
	g.feeding.crude_protein_max_g_per_kg <= lim.phase_max_g_per_kg_88dm
}

pig_group_cp_compliant(g) if {
	lim := cp_limit(g.category)
	not lim.average_or_phase_alternative
	lim.average_max_g_per_kg_88dm != null
	g.feeding.crude_protein_average_g_per_kg <= lim.average_max_g_per_kg_88dm
}

pig_group_cp_compliant(g) if {
	lim := cp_limit(g.category)
	not lim.average_or_phase_alternative
	lim.average_max_g_per_kg_88dm == null
	g.feeding.crude_protein_max_g_per_kg <= lim.phase_max_g_per_kg_88dm
}

obligation_violations contains v if {
	pig_option_applied
	some g in pig_groups
	not pig_group_cp_compliant(g)
	v := {
		"rule_id": "O616-PIG-003",
		"message": sprintf("Rohproteingrenze für Kategorie %v nicht eingehalten bzw. nicht belegt", [g.category]),
	}
}

obligation_violations contains v if {
	pig_option_applied
	object.get(doc16, "pig_feeding_recipes_documented", false) != true
	v := {
		"rule_id": "O616-PIG-004",
		"message": "Kein Nachweis der stark stickstoffreduzierten Fütterung über Rezepturen (Rohprotein je kg bei 88 % TM)",
	}
}

obligation_violations contains v if {
	pig_option_applied
	some g in pig_groups
	object.get(g, ["feeding", "mode"], "average") == "phase"
	object.get(doc16, "phase_feeding_plausible", false) != true
	v := {
		"rule_id": "O616-PIG-005",
		"message": "Phasenfütterung technisch nicht plausibel gemacht (z. B. Silobeschriftung, Fütterungstechnik)",
	}
}

# --- Cultan-Düngung: mind. eine Düngergabe als Ammoniumdepot per Injektion (Nagelradverfahren) ---
cultan_applications(p) := [a |
	some a in fertilizer_applications(p)
	object.get(a, "method", "") == "cultan_injection"
]

obligation_violations contains v if {
	some p in cul_parcels
	count(cultan_applications(p)) == 0
	v := {
		"rule_id": "O616-CUL-002",
		"parcel_id": p.parcel_id,
		"message": "Keine Düngergabe als Ammoniumdepot im Cultan-Nagelradverfahren",
	}
}

obligation_violations contains v if {
	some p in cul_parcels
	some a in cultan_applications(p)
	not cultan_record_complete(a)
	v := {
		"rule_id": "O616-CUL-003",
		"parcel_id": p.parcel_id,
		"message": "Schlagbezogene Aufzeichnung (Art, Menge, Zeitpunkt) der Cultan-Injektion unvollständig",
	}
}

cultan_record_complete(a) if {
	object.get(a, "fertilizer_type", null) != null
	object.get(a, "amount_kg_ha", null) != null
	object.get(a, "date", null) != null
}

obligation_violations contains v if {
	some p in cul_parcels
	some a in cultan_applications(p)
	object.get(a, "by_contractor", false) == true
	object.get(a, "contractor_invoice", false) != true
	v := {
		"rule_id": "O616-CUL-004",
		"parcel_id": p.parcel_id,
		"message": "Ausbringung durch betriebsfremde Geräte ohne Rechnung oder gleichwertigen Nachweis",
	}
}
