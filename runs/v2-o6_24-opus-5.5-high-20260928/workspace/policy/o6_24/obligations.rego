# o6_24 – Förderverpflichtungen und Mindestbewirtschaftung
# Stickstoff-Düngeobergrenzen je Düngeklasse, Ausbringungszeiträume, Betriebsbuch, Ernteverpflichtung, Codierung.
package oepul.o6_24

duenge := data.o6_24.duengeklassen

# --- Düngeklassen: nicht zugeordnete Flächen im Gebiet gelten als Düngeklasse C ---
entry_class(e) := k if {
	k := e.klasse
	k != null
} else := duenge.default_class_for_unassigned_area

# Obergrenze je Teilfläche: aus Eingabe, sonst aus den im Informationsblatt belegten Werten.
entry_limit(p, e) := e.n_limit_kg_per_ha if {
	e.n_limit_kg_per_ha != null
} else := l if {
	some row in duenge.documented_limits
	row.crop_name == crop_name(p)
	row.klasse == entry_class(e)
	l := row.n_limit_kg_per_ha
}

class_entries(p) := object.get(wrrl(p), "duengeklassen", [])

class_entries_complete(p) if {
	count(class_entries(p)) > 0
	every e in class_entries(p) {
		entry_limit(p, e)
	}
}

# Gewichtetes Mittel der Düngeobergrenzen, wenn einem Schlag mehrere Düngeklassen zugeordnet sind.
parcel_n_limit_kg_per_ha(p) := lim if {
	class_entries_complete(p)
	total := sum([e.area_ha | some e in class_entries(p)])
	total > 0
	weighted := [v | some e in class_entries(p); v := entry_limit(p, e) * e.area_ha]
	lim := sum(weighted) / total
}

# Jahreswirksam ausgebrachte N-Menge: explizite Angabe, sonst Summe mineralisch + organisch.
fert(p) := object.get(p, ["operations", "fertilizer"], {})

parcel_applied_n_kg_per_ha(p) := n if {
	n := fert(p).annual_effective_n_kg_per_ha
	n != null
} else := n if {
	vals := [v | some k in ["mineral_n_kg_per_ha", "organic_n_kg_per_ha"]; v := fert(p)[k]; v != null]
	count(vals) > 0
	n := sum(vals)
}

# Parzellen, auf die die Förderverpflichtungen angewendet werden: Ackerflächen im Gebiet, für 24 beantragt,
# ohne Bewilligung zu erhöhten Stickstoffdüngergaben und keine Brache.
obligation_parcels := [p |
	some p in arable_parcels_in_area
	parcel_declared_for_measure(p)
	not parcel_has_increased_n_permit(p)
	not parcel_is_fallow(p)
]

# --- Auflage 4.1 a: maximal zulässige jahreswirksame N-Menge je Düngeklasse ---
violations contains v if {
	some p in obligation_parcels
	applied := parcel_applied_n_kg_per_ha(p)
	lim := parcel_n_limit_kg_per_ha(p)
	applied > lim
	v := {
		"code": "n_limit_exceeded",
		"parcel_id": p.parcel_id,
		"applied_n_kg_per_ha": applied,
		"limit_n_kg_per_ha": round2(lim),
		"rule_id": "O6_24-OBL-N-LIMIT",
	}
}

# --- Auflage 4.1 b: zulässige Zeiträume für die Ausbringung stickstoffhaltiger Düngemittel ---
violations contains v if {
	some p in obligation_parcels
	wrrl(p).n_application_periods_compliant == false
	v := {"code": "n_application_period_violated", "parcel_id": p.parcel_id, "rule_id": "O6_24-OBL-N-PERIODS"}
}

# --- Auflage 4.2: Betriebsbuch gemäß § 5, für alle Schläge (auch ohne Düngung), am Betrieb aufbewahrt ---
violations contains v if {
	some p in arable_parcels_in_area
	parcel_declared_for_measure(p)
	object.get(p, ["operations", "fertilization_records_kept"], null) == false
	v := {"code": "betriebsbuch_parcel_records_missing", "parcel_id": p.parcel_id, "rule_id": "O6_24-OBL-RECORDS"}
}

violations contains v if {
	object.get(input, ["documentation", "o6_24_betriebsbuch_stored_on_farm"], null) == false
	v := {"code": "betriebsbuch_not_stored_on_farm", "parcel_id": null, "rule_id": "O6_24-OBL-RECORDS-STORAGE"}
}

# --- Codierung OPWRRL: Flächen mit Bewilligung zu erhöhten N-Gaben (und Brachen laut SRL) ---
parcel_requires_opwrrl(p) if {
	parcel_is_arable(p)
	parcel_in_area(p)
	parcel_has_increased_n_permit(p)
}

parcel_requires_opwrrl(p) if {
	parcel_is_arable(p)
	parcel_in_area(p)
	parcel_is_fallow(p)
}

opwrrl_coding_required contains p.parcel_id if {
	some p in parcels
	parcel_requires_opwrrl(p)
}

violations contains v if {
	some p in parcels
	parcel_requires_opwrrl(p)
	parcel_declared_for_measure(p)
	not "OPWRRL" in parcel_codes(p)
	not "OP" in parcel_codes(p)
	v := {"code": "opwrrl_code_missing", "parcel_id": p.parcel_id, "rule_id": "O6_24-CODE-OPWRRL"}
}

# --- Leistungsüberschneidung: bei 24 ist für gesetzlich vorgeschriebene Auflagen kein OP-Code nötig ---
op_code_required_for_overlap(kind) if kind == "public_agreement"

op_code_required_for_overlap(kind) if kind == "official_compensation_area"

parcel_overlap(p) := object.get(wrrl(p), "public_funding_overlap", "none")

violations contains v if {
	some p in obligation_parcels
	op_code_required_for_overlap(parcel_overlap(p))
	count({"OP", "OPWRRL"} & parcel_codes(p)) == 0
	v := {"code": "op_code_missing_overlap", "parcel_id": p.parcel_id, "rule_id": "O6_24-GEN-OP-OVERLAP"}
}

# --- Mindestbewirtschaftung Acker (ohne Ackerfutter): Ernte und Verbringen auf >= 85 % des Schlages ---
harvest_share(p) := object.get(p, ["operations", "harvest_share_percent"], null)

parcel_district(p) := object.get(p, "district", input.farm.region.district)

parcel_state(p) := object.get(p, "federal_state", input.farm.region.federal_state)

drought_region_match(p) if {
	some r in data.o6_24.drought_2026.harvest_waiver_regions
	r.federal_state == parcel_state(p)
	r.all_districts == true
}

drought_region_match(p) if {
	some r in data.o6_24.drought_2026.harvest_waiver_regions
	r.federal_state == parcel_state(p)
	parcel_district(p) in {d | some d in r.districts}
}

# Dürre 2026: automatisch höhere Gewalt, wenn kein erntbarer Bestand (Spätsommer-/Herbstkultur).
drought_2026_harvest_waiver(p) if {
	year == data.o6_24.drought_2026.year
	drought_region_match(p)
	p.operations.no_harvestable_stand_due_to_drought == true
	p.crop.usually_harvested_late_summer_or_autumn == true
}

harvest_exempt(p) if drought_2026_harvest_waiver(p)

harvest_exempt(p) if p.operations.force_majeure_recognized == true

harvest_obligation_failed(p) if {
	parcel_is_arable(p)
	not parcel_is_ackerfutter(p)
	not parcel_is_fallow(p)
	harvest_share(p) != null
	harvest_share(p) < thresholds.min_harvest_share_percent
	not harvest_exempt(p)
}

violations contains v if {
	some p in obligation_parcels
	harvest_obligation_failed(p)
	count({"OP", "OPWRRL"} & parcel_codes(p)) == 0
	v := {"code": "harvest_obligation_not_met_without_op_code", "parcel_id": p.parcel_id, "rule_id": "O6_24-GEN-MIN-ARABLE"}
}

# Ackerfutterflächen: mindestens einmal jährlich vollflächige Mahd mit Verbringung oder vollflächige Beweidung.
ackerfutter_use_failed(p) if {
	parcel_is_ackerfutter(p)
	count(object.get(p, ["operations", "cutting_dates"], [])) == 0
	object.get(p, ["operations", "full_area_grazing"], false) != true
	object.get(p, ["operations", "force_majeure_recognized"], false) != true
}

violations contains v if {
	some p in obligation_parcels
	ackerfutter_use_failed(p)
	v := {"code": "ackerfutter_min_use_not_met", "parcel_id": p.parcel_id, "rule_id": "O6_24-GEN-MIN-FORAGE"}
}

parcel_min_management_met(p) if {
	not harvest_obligation_failed(p)
	not ackerfutter_use_failed(p)
}

# --- Fehlende Eingaben, die eine Beurteilung verhindern ---
missing_inputs contains sprintf("land.parcels[%s].wrrl_o6_24.duengeklassen", [p.parcel_id]) if {
	some p in obligation_parcels
	not parcel_n_limit_kg_per_ha(p)
}

missing_inputs contains sprintf("land.parcels[%s].operations.fertilizer", [p.parcel_id]) if {
	some p in obligation_parcels
	not parcel_applied_n_kg_per_ha(p)
}

missing_inputs contains sprintf("land.parcels[%s].wrrl_o6_24.n_application_periods_compliant", [p.parcel_id]) if {
	some p in obligation_parcels
	object.get(wrrl(p), "n_application_periods_compliant", null) == null
}

missing_inputs contains sprintf("land.parcels[%s].operations.harvest_share_percent", [p.parcel_id]) if {
	some p in obligation_parcels
	not parcel_is_ackerfutter(p)
	harvest_share(p) == null
}

missing_inputs contains "farm.applicant" if count(applicant) == 0

missing_inputs contains "participation.o6_24.measure_application_date" if {
	object.get(participation, "measure_application_date", null) == null
}
