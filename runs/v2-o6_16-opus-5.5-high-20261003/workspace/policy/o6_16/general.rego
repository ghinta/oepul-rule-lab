# Allgemeine Teilnahmebedingungen (Informationsblatt Stand April 2026), SRL Allgemeiner Teil und GSP-AV, soweit
# für die Maßnahme 16 entscheidungs- oder berechnungsrelevant.
package oepul.o6_16

import data.o6_16 as d

# --- Flächenabgang: Toleranz 5 %, max. 5,00 ha, jedenfalls 0,50 ha pro Jahr ---
area_reduction_tolerance_ha(prev_area) := max_of(min_of(0.05 * prev_area, 5.0), 0.5)

area_reduction_ha := max_of(0, object.get(o16, "area_previous_year_ha", 0) - object.get(o16, "area_current_year_ha", object.get(o16, "area_previous_year_ha", 0)))

# Verlust der Verfügungsgewalt (Übertragung an anderen Betrieb) zählt nicht als rückzahlungspflichtige Verringerung
area_reduction_relevant_ha := max_of(0, area_reduction_ha - object.get(o16, "area_lost_disposal_right_ha", 0))

obligation_violations contains v if {
	area_reduction_relevant_ha > area_reduction_tolerance_ha(object.get(o16, "area_previous_year_ha", 0))
	v := {
		"rule_id": "O616-GEN-006",
		"message": sprintf("Flächenverringerung um %v ha über der Toleranz; Rückzahlung für die gesamte Differenzfläche", [area_reduction_relevant_ha]),
	}
}

repayment_area_ha := area_reduction_relevant_ha if {
	area_reduction_relevant_ha > area_reduction_tolerance_ha(object.get(o16, "area_previous_year_ha", 0))
}

# --- Mindestbewirtschaftung auf Ackerflächen: Ernte und Verbringen auf zumindest 85 % des Schlages ---
obligation_violations contains v if {
	some p in base_parcels
	not arable_forage_crop(p)
	share := object.get(p, ["operations", "harvested_share"], 1)
	share < 0.85
	not harvest_obligation_waived(p)
	not "OP" in parcel_codes(p)
	v := {
		"rule_id": "O616-GEN-004",
		"parcel_id": p.parcel_id,
		"message": "Ernte und Verbringen des Erntegutes auf weniger als 85 % des Schlages",
	}
}

# --- Verpflichtungsdauer ganzes Kalenderjahr: unterjährige Weitergabe nur bei Weiterführung durch Übernehmer ---
obligation_violations contains v if {
	some p in area_parcels
	object.get(p, "transferred_during_year", false) == true
	object.get(p, "successor_continues_commitment", false) != true
	not parcel_has_op_code(p)
	v := {
		"rule_id": "O616-GEN-005",
		"parcel_id": p.parcel_id,
		"message": "Unterjährig weitergegebene Fläche ohne Weiterführung durch den Übernehmer ist mit Code OP zu versehen",
	}
}

# --- Maßnahmenübernahme: bis 15.04. (2023 und 2028: 17.04.), Ausweitung max. 50 % ---
takeover_deadline(y) := sprintf("%d-04-17", [y]) if y in {2023, 2028}

takeover_deadline(y) := sprintf("%d-04-15", [y]) if not y in {2023, 2028}

takeover_allowed(t) if {
	t.date <= takeover_deadline(date_year(t.date))
	t.extension_to_other_area_ha <= 0.5 * t.taken_over_area_ha
	t.taker_previously_participating == false
}

# Zuschlag Schweinefütterung: Übernahme nur bei Betriebsauflösung, -teilung oder -zusammenlegung
takeover_allowed_pig_option(t) if {
	takeover_allowed(t)
	t.reason in {"farm_dissolution", "farm_division", "farm_merger"}
}

# --- Ausstieg vor Ende des Vertragszeitraums: Rückforderung aller Maßnahmenprämien ---
early_exit_repayment if {
	object.get(o16, "exit_year", null) != null
	o16.exit_year < 2028
	object.get(o16, "exit_due_to_revision_clause", false) != true
	object.get(o16, "exit_due_to_force_majeure", false) != true
}

# Abmeldung im laufenden Jahr: Maßnahme im betroffenen Förderjahr nicht mehr gültig
deregistration_invalidates_current_year(dereg_date) if date_year(dereg_date) == year

# --- Sanktionen bei Nichteinhaltung inhaltlicher Förderverpflichtungen (§ 48 GSP-AV) ---
sanction_percent(stage, y) := s.reduction_percent_until_2026 if {
	y <= 2026
	some s in d.sanction_stages
	s.stage == stage
}

sanction_percent(stage, y) := s.reduction_percent_from_2027 if {
	y >= 2027
	some s in d.sanction_stages
	s.stage == stage
}

# Wiederholter Verstoß gegen dieselbe Verpflichtung: Erhöhung um eine Stufe je Wiederholung (max. Stufe 7)
escalated_stage(base_stage, occurrence) := min_of(7, base_stage + (occurrence - 1))

# Kumulation mehrerer Verstöße, begrenzt mit 100 %
cumulated_sanction_percent(percents) := min_of(100, sum(percents))

# Zweimalige 100-%-Kürzung im Vertragszeitraum: Ausschluss und Rückforderung
exclusion_from_measure if count([s | some s in object.get(o16, "sanction_history_percent", []); s == 100]) >= 2

# --- Höhere Gewalt (§ 6 GSP-AV): Meldung binnen drei Wochen ab Möglichkeit ---
force_majeure_claim_timely(able_date, claim_date) if {
	delta := time.parse_ns("2006-01-02", claim_date) - time.parse_ns("2006-01-02", able_date)
	delta >= 0
	delta <= ((21 * 24) * 3600) * 1000000000
}

# --- Fristende an Wochenende/Feiertag (§ 5 GSP-AV); nicht für den Maßnahmenantrag (31.12.) ---
deadline_shift_excluded := {"measure_application", "catch_crop_variants_1_3", "catch_crop_variants_4_7", "slurry_quantity", "post_deadline_corrections"}

deadline_shift_applicable(deadline_kind) if not deadline_kind in deadline_shift_excluded

# --- Nationalparkflächen: keine Prämie, Verpflichtungen bleiben aufrecht ---
national_park_parcels := [p.parcel_id | some p in area_parcels; parcel_in_national_park(p)]
