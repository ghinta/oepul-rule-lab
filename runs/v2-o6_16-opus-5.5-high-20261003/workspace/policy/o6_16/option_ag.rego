# Option „Bewirtschaftung auswaschungsgefährdeter Ackerflächen“ (Code AG; Kapitel 4.8, 5, 6 Informationsblatt; SRL 2.16).
package oepul.o6_16

import data.o6_16 as d

ag(p) := object.get(p, "ag_option", {})

ag_permitted_land_use_set := {r.land_use | some r in d.ag_permitted_land_uses}

ag_div_land_use_set := {r.land_use | some r in d.ag_permitted_land_uses; r.div_combinable}

ag_first_year(p) := object.get(ag(p), "first_declared_year", year)

# Anlagejahr ggf. betriebsübergreifend (lagegenaue Weiterführung durch Folgebetrieb)
ag_establishment_year(p) := object.get(ag(p), "previous_holder_establishment_year", ag_first_year(p))

ag_earliest_ploughing_date(p) := sprintf("%d-09-15", [ag_establishment_year(p) + 1])

ag_issue(p, "Ackerfläche nicht in der Gebietskulisse") if not parcel_in_area(p)

ag_issue(p, "durchschnittliche Ackerzahl über 40") if {
	object.get(p, "average_arable_index", null) != null
	p.average_arable_index > 40
}

ag_issue(p, "im Mehrfachantrag 2020 als Grünland beantragt") if object.get(p, "grassland_in_mfa_2020", false) == true

ag_issue(p, "begrünte Fläche im Rahmen von GLÖZ 4") if object.get(p, "gloez4_buffer_strip", false) == true

ag_issue(p, "stillgelegte Fläche im Rahmen von GLÖZ 8 (bis 2024)") if {
	year <= 2024
	object.get(p, "gloez8_fallow", false) == true
}

ag_issue(p, "unzulässige Schlagnutzungsart (Grünbrache, Futtergräser, Sonstiges Feldfutter, Wechselwiese)") if {
	not parcel_crop_name(p) in ag_permitted_land_use_set
}

ag_issue(p, "AG mit DIV nur als Grünbrache oder Sonstiges Feldfutter") if {
	"DIV" in parcel_codes(p)
	not parcel_crop_name(p) in ag_div_land_use_set
}

ag_issue(p, "AG mit DIV nur bei Teilnahme an UBB (1A) oder BIO (1B)") if {
	"DIV" in parcel_codes(p)
	not participates("1A")
	not participates("1B")
}

ag_issue_messages := [
	"Ackerfläche nicht in der Gebietskulisse",
	"durchschnittliche Ackerzahl über 40",
	"im Mehrfachantrag 2020 als Grünland beantragt",
	"begrünte Fläche im Rahmen von GLÖZ 4",
	"stillgelegte Fläche im Rahmen von GLÖZ 8 (bis 2024)",
	"unzulässige Schlagnutzungsart (Grünbrache, Futtergräser, Sonstiges Feldfutter, Wechselwiese)",
	"AG mit DIV nur als Grünbrache oder Sonstiges Feldfutter",
	"AG mit DIV nur bei Teilnahme an UBB (1A) oder BIO (1B)",
]

ag_issues contains v if {
	some p in ag_parcels
	some msg in ag_issue_messages
	ag_issue(p, msg)
	v := {"rule_id": "O616-AG-001", "parcel_id": p.parcel_id, "message": msg}
}

ag_parcel_has_issue(p) if {
	some msg in ag_issue_messages
	ag_issue(p, msg)
}

ag_parcel_eligible(p) if {
	is_ag_parcel(p)
	not ag_parcel_has_issue(p)
}

# AG + NPF bis einschließlich 2024: Anrechnung für GLÖZ 8, aber keine ÖPUL-Prämie
ag_npf_no_premium(p) if {
	year <= 2024
	is_ag_parcel(p)
	"NPF" in parcel_codes(p)
}

# --- Förderverpflichtungen ---
obligation_violations contains v if {
	some p in ag_parcels
	not ag_sowing_ok(p)
	v := {
		"rule_id": "O616-AG-002",
		"parcel_id": p.parcel_id,
		"message": "Keine Einsaat einer winterharten Begrünungsmischung ohne Leguminosen bis 15.05. und kein bestehender Grünbrache-/Ackerfutterbestand",
	}
}

ag_sowing_ok(p) if object.get(ag(p), "existing_stand_retained", false) == true

ag_sowing_ok(p) if {
	sow := object.get(ag(p), "sowing_date", null)
	sow != null
	sow <= sprintf("%d-05-15", [ag_first_year(p)])
	object.get(ag(p), "winter_hardy_mix", false) == true
	object.get(ag(p), "mix_contains_legumes", true) == false
}

obligation_violations contains v if {
	some p in ag_parcels
	pl := object.get(ag(p), "ploughing_date", null)
	pl != null
	pl < ag_earliest_ploughing_date(p)
	v := {
		"rule_id": "O616-AG-003",
		"parcel_id": p.parcel_id,
		"message": sprintf("Umbruch am %v vor dem frühestmöglichen Termin %v", [pl, ag_earliest_ploughing_date(p)]),
	}
}

obligation_violations contains v if {
	some p in ag_parcels
	object.get(ag(p), "fertilizer_or_psm_used", false) == true
	v := {
		"rule_id": "O616-AG-004",
		"parcel_id": p.parcel_id,
		"message": "Pflanzenschutz- oder Düngemitteleinsatz auf auswaschungsgefährdeter Ackerfläche",
	}
}

# Mahd oder Häckseln mind. 1 x jedes zweite Jahr
obligation_violations contains v if {
	some p in ag_parcels
	years := {y | some y in object.get(ag(p), "mowing_or_mulching_years", [])}
	year > ag_first_year(p)
	not year in years
	not (year - 1) in years
	v := {
		"rule_id": "O616-AG-005",
		"parcel_id": p.parcel_id,
		"message": "Keine Mahd bzw. kein Häckseln im laufenden oder vorangegangenen Jahr",
	}
}

obligation_violations contains v if {
	some p in ag_parcels
	some prohibited in ["grazing", "threshing"]
	object.get(ag(p), prohibited, false) == true
	v := {
		"rule_id": "O616-AG-006",
		"parcel_id": p.parcel_id,
		"message": sprintf("Unzulässige Nutzung auf AG-Fläche: %v", [prohibited]),
	}
}

obligation_violations contains v if {
	some p in ag_parcels
	object.get(ag(p), "cover_maintained", true) == false
	v := {
		"rule_id": "O616-AG-006",
		"parcel_id": p.parcel_id,
		"message": "Begrünung auf AG-Fläche nicht erhalten",
	}
}

# Umwandlung von AG-Flächen in „Naturschutz“ oder „Ergebnisorientierte Bewirtschaftung“ bis 31.12.2025
ag_conversion_allowed(target, application_date) if {
	target in {"18", "19"}
	application_date <= "2025-12-31"
}

# Prämienfähige AG-Fläche: max. 20 % der Ackerfläche des Betriebes
ag_eligible_area_ha := sum([p.area_ha | some p in ag_parcels; ag_parcel_eligible(p); not ag_npf_no_premium(p); not parcel_has_op_code(p)])

ag_premium_area_ha := min_of(ag_eligible_area_ha, 0.2 * total_arable_area_ha)
