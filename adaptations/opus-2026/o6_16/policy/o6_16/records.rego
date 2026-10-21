# Betriebs- und schlagbezogene Aufzeichnungen (Kapitel 4.1, 4.2 Informationsblatt; SRL 2.16; NAPV § 8 Abs. 1, § 9 Abs. 6).
package oepul.o6_16

# --- Betriebliche Aufzeichnungen: Düngeplanung bis 28.02., Düngebilanzierung bis 31.01. des Folgejahres ---
fertilization_plan_deadline := sprintf("%d-02-28", [year])

fertilization_balance_deadline := sprintf("%d-01-31", [year + 1])

obligation_violations contains v if {
	plan := object.get(doc16, "fertilization_plan_date", null)
	not plan_on_time(plan)
	v := {
		"rule_id": "O616-REC-002",
		"message": sprintf("Voraussichtliche Düngeplanung nicht bis %v angelegt", [fertilization_plan_deadline]),
	}
}

plan_on_time(plan) if {
	plan != null
	plan <= fertilization_plan_deadline
}

obligation_violations contains v if {
	bal := object.get(doc16, "fertilization_balance_date", null)
	bal != null
	bal > fertilization_balance_deadline
	v := {
		"rule_id": "O616-REC-003",
		"message": sprintf("Betriebliche Düngebilanzierung nicht bis %v abgeschlossen", [fertilization_balance_deadline]),
	}
}

# Düngevorgaben der NAPV auf allen bewirtschafteten Flächen; Aufzeichnungen gemäß § 8 Abs. 1 NAPV
obligation_violations contains v if {
	object.get(doc16, "napv_fertilization_rules_complied", true) == false
	v := {
		"rule_id": "O616-REC-001",
		"message": "Düngevorgaben der Nitrat-Aktionsprogramm-Verordnung nicht auf allen Flächen eingehalten",
	}
}

obligation_violations contains v if {
	object.get(doc16, "farm_records_napv_8_1_complete", true) == false
	v := {
		"rule_id": "O616-REC-001",
		"message": "Betriebliche Aufzeichnungen gemäß § 8 Abs. 1 NAPV unvollständig",
	}
}

# --- Schlagbezogene Aufzeichnungen (§ 9 Abs. 6 NAPV) für Ackerflächen in der Gebietskulisse ---
crop_area_in_gwa(crop) := sum([p.area_ha | some p in area_parcels; parcel_crop_name(p) == crop])

# Keine schlagbezogenen Aufzeichnungen bei Kulturen mit max. 0,30 ha je Kultur
plot_records_required(p) if {
	parcel_in_area(p)
	crop_area_in_gwa(parcel_crop_name(p)) > 0.3
}

obligation_violations contains v if {
	some p in area_parcels
	plot_records_required(p)
	object.get(p, ["plot_records", "complete"], false) != true
	v := {
		"rule_id": "O616-REC-004",
		"parcel_id": p.parcel_id,
		"message": "Schlagbezogene Aufzeichnungen (Schlag, Düngemittel, Bewässerung, Anbau/Ernte, Erntemenge mit Wiegebelegen, N-Saldo) unvollständig",
	}
}

obligation_violations contains v if {
	count([p | some p in area_parcels; plot_records_required(p)]) > 0
	object.get(doc16, "plot_records_electronic", false) != true
	v := {
		"rule_id": "O616-REC-005",
		"message": "Schlagbezogene Aufzeichnungen sind elektronisch zu führen",
	}
}

obligation_violations contains v if {
	some p in area_parcels
	plot_records_required(p)
	delay := object.get(p, ["plot_records", "max_delay_days"], 0)
	delay > 14
	v := {
		"rule_id": "O616-REC-006",
		"parcel_id": p.parcel_id,
		"message": sprintf("Aufzeichnung erst %v Tage nach Ausbringung/Anbau/Bewässerung/Ernte (max. 14 Tage)", [delay]),
	}
}

obligation_violations contains v if {
	object.get(doc16, "plot_records_provided_on_request", true) == false
	v := {
		"rule_id": "O616-REC-007",
		"message": "Aufzeichnungen wurden dem BMLUK im Bedarfsfall nicht zur Verfügung gestellt",
	}
}

obligation_violations contains v if {
	object.get(doc16, "records_kept_on_farm", true) == false
	v := {
		"rule_id": "O616-N26-001",
		"message": "Aufzeichnungen sind am Betrieb aufzubewahren (Hinweis AMA 25.08.2026)",
	}
}

# Aufbewahrung förderrelevanter Unterlagen bei mehrjährigen INVEKOS-Maßnahmen: vier Jahre ab Ende des Vertragszeitraums
records_retention_until := "2032-12-31"
