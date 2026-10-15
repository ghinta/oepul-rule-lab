# Bodennahe Ausbringung flüssiger Wirtschaftsdünger und Biogasgülle (o6_9)
package oepul.o6_9

eligible_technique_ids := {row.technique | some row in tables.application_techniques.eligible}

excluded_device_ids := {row.technique | some row in tables.application_techniques.excluded}

eligible_manure_type_ids := {row.manure_type | some row in tables.manure_definitions.eligible_manure_types}

allowed_biogas_feedstocks := {row.feedstock | some row in tables.manure_definitions.biogas_feedstocks}

biogas := object.get(application, "biogas_slurry", {})

application_records := object.get(application, "records", [])

# O69-MB-014: förderbar sind ausschließlich Schleppschlauch, Schleppschuh und Injektionsverfahren.
eligible_technique(t) if t in eligible_technique_ids

# O69-MB-015: Schwenkverteiler und Prallteller auf Düsenbalken werden nicht anerkannt.
excluded_devices_used := {d | some d in object.get(application, "devices_used", []); d in excluded_device_ids}

# O69-MB-007: förderbarer Wirtschaftsdünger sind Gülle, Jauche und Biogasgülle (auch mit Wasser versetzt).
non_eligible_manure_types := {m | some m in object.get(application, "manure_types", []); not m in eligible_manure_type_ids}

# O69-MB-010 / O69-MB-009: Biogasgülle nur förderbar, wenn ausschließlich definierte Ausgangsprodukte vergoren wurden.
biogas_used if object.get(biogas, "volume_m3", 0) > 0

biogas_non_defined_feedstocks := {f | some f in object.get(biogas, "feedstocks", []); not f in allowed_biogas_feedstocks}

biogas_slurry_eligible if {
	biogas_used
	count(biogas_non_defined_feedstocks) == 0
	not is_true(biogas, "contains_non_defined_components")
}

# Gesamte Biogasgülle scheidet aus, sobald ein nicht der Definition entsprechender Anteil enthalten ist.
ineligible_biogas_volume := object.get(biogas, "volume_m3", 0) if {
	biogas_used
	not biogas_slurry_eligible
}

ineligible_biogas_volume := 0 if not biogas_used

ineligible_biogas_volume := 0 if biogas_slurry_eligible

# O69-MB-008: eingeleitetes Regenwasser ist nicht förderbar; O69-MB-011: aufgemischter Festmist ist nicht förderbar.
ineligible_application_volume := (object.get(application, "rainwater_volume_m3", 0) + object.get(application, "solid_manure_with_water_volume_m3", 0)) + ineligible_biogas_volume

eligible_application_volume_raw := max2(application_volume_total - ineligible_application_volume, 0)

# O69-MB-016: chronologische, schlagbezogene Aufzeichnungen über Menge, Art, Zeitpunkt und Verfahren.
required_record_fields := ["parcel_ids", "date", "manure_type", "volume_m3", "technique"]

record_incomplete(r) if {
	some f in required_record_fields
	object.get(r, f, null) == null
}

record_incomplete(r) if count(object.get(r, "parcel_ids", [])) == 0

incomplete_records := [i | some i, r in application_records; record_incomplete(r)]

records_chronological if count(application_records) <= 1

records_chronological if {
	count(application_records) > 1
	every i in numbers.range(1, count(application_records) - 1) {
		date_ns(application_records[i - 1].date) <= date_ns(application_records[i].date)
	}
}

# O69-MB-017: Zusammenfassen mehrerer Schläge nur bei gleicher Kultur, Menge, Datum und Ausbringungsart; Schlaggrößen addieren.
parcel_area(pid) := a if {
	some p in parcels
	p.parcel_id == pid
	a := p.area_ha
}

aggregated_record_invalid(r) if {
	count(r.parcel_ids) > 1
	count({c | some c in object.get(r, "crops", [])}) != 1
}

aggregated_record_invalid(r) if {
	count(r.parcel_ids) > 1
	has_value(r, "area_ha")
	areas := [parcel_area(pid) | some pid in r.parcel_ids]
	count(areas) == count(r.parcel_ids)
	abs(sum(areas) - r.area_ha) > 0.0001
}

invalid_aggregated_records := [i | some i, r in application_records; aggregated_record_invalid(r)]

# Abgleich: beantragte Menge je Verfahren darf die aufgezeichnete Menge nicht übersteigen (O69-GEN-021).
recorded_volume_by_technique[t] := s if {
	some t in eligible_technique_ids
	s := sum([r.volume_m3 | some r in application_records; r.technique == t])
}

volume_not_documented[t] := claimed - recorded if {
	count(application_records) > 0
	some t, claimed in claimed_application_volumes
	recorded := recorded_volume_by_technique[t]
	claimed > recorded
}

# O69-MB-013: Ausbringung auf Acker- oder Grünlandflächen des Betriebes.
records_on_non_farm_or_ineligible_land := [i |
	some i, r in application_records
	some pid in object.get(r, "parcel_ids", [])
	not parcel_is_farm_arable_or_grassland(pid)
]

parcel_is_farm_arable_or_grassland(pid) if {
	some p in parcels
	p.parcel_id == pid
	p.land_use in {"arable", "grassland"}
}

violations contains {"rule_id": "O69-MB-014", "message": sprintf("Aufzeichnung %d: Ausbringungstechnik nicht förderbar", [i])} if {
	some i, r in application_records
	not eligible_technique(r.technique)
}

violations contains {"rule_id": "O69-MB-015", "message": sprintf("Nicht anerkanntes Ausbringungsgerät verwendet: %v", [d])} if {
	some d in excluded_devices_used
}

violations contains {"rule_id": "O69-MB-007", "message": sprintf("Nicht förderbarer Wirtschaftsdünger: %v", [m])} if {
	some m in non_eligible_manure_types
}

violations contains {"rule_id": "O69-MB-010", "message": "Biogasgülle enthält nicht der Definition entsprechende Bestandteile – gesamte Biogasgülle nicht förderfähig"} if {
	biogas_used
	not biogas_slurry_eligible
}

violations contains {"rule_id": "O69-MB-020", "message": "Für die Biogasgülle fehlen geeignete Nachweise über die Ausgangsprodukte"} if {
	biogas_used
	not is_true(biogas, "feedstock_proof_available")
}

violations contains {"rule_id": "O69-MB-011", "message": "Mit Wasser versetzter und aufgemischter Festmist ist nicht förderbar"} if {
	object.get(application, "solid_manure_with_water_volume_m3", 0) > 0
}

violations contains {"rule_id": "O69-MB-008", "message": "In die Güllegrube eingeleitetes Regenwasser ist nicht förderbar"} if {
	object.get(application, "rainwater_volume_m3", 0) > 0
}

violations contains {"rule_id": "O69-MB-016", "message": "Schlagbezogene Ausbringungsaufzeichnungen fehlen"} if {
	application_volume_total > 0
	count(application_records) == 0
}

violations contains {"rule_id": "O69-MB-016", "message": sprintf("Aufzeichnung %d unvollständig (Schlag, Datum, Art, Menge, Verfahren)", [i])} if {
	some i in incomplete_records
}

violations contains {"rule_id": "O69-MB-016", "message": "Ausbringungsaufzeichnungen sind nicht chronologisch geführt"} if {
	count(application_records) > 1
	count(incomplete_records) == 0
	not records_chronological
}

violations contains {"rule_id": "O69-MB-017", "message": sprintf("Aufzeichnung %d: unzulässige Zusammenfassung mehrerer Schläge", [i])} if {
	some i in invalid_aggregated_records
}

violations contains {"rule_id": "O69-GEN-021", "message": sprintf("Beantragte Menge (%v) übersteigt aufgezeichnete Menge um %v m³", [t, d])} if {
	some t, d in volume_not_documented
}

violations contains {"rule_id": "O69-MB-013", "message": sprintf("Aufzeichnung %d: Ausbringung nicht auf Acker- oder Grünlandfläche des Betriebes", [i])} if {
	some i in records_on_non_farm_or_ineligible_land
}

violations contains {"rule_id": "O69-MB-018", "message": "Ausbringung durch betriebsfremde Geräte ohne Rechnung oder gleichwertige Unterlagen"} if {
	is_true(application, "contractor_used")
	not is_true(application, "contractor_invoice_available")
}

violations contains {"rule_id": "O69-MB-019", "message": "Gemeinschaftlich angeschafftes Güllefass: Gerät nicht kontrollierbar oder Rechnung nicht an teilnehmende Betriebe ausgestellt"} if {
	shared := object.get(application, "shared_equipment", {})
	is_true(shared, "used")
	shared_equipment_conditions_unmet(shared)
}

shared_equipment_conditions_unmet(shared) if not is_true(shared, "available_or_controllable")

shared_equipment_conditions_unmet(shared) if not is_true(shared, "invoice_issued_to_participants")
