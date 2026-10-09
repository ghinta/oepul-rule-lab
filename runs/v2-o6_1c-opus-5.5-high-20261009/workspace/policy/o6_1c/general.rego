package oepul.o6_1c

# Allgemeine Förderfähigkeit von Flächen (Allgemeine Teilnahmebedingungen,
# SRL ÖPUL 2023 Punkt 1.6/1.7, GSP-AV §§ 27-31).

measure_parcels := npa_parcels | afs_parcels

# O6_1C-GEN-001: Nationalparks.
national_park_row(name) := row if {
	some row in data.o6_1c.national_parks.rows
	row.name == name
}

national_park_excluded(p) if {
	np := object.get(p, "national_park", {})
	np.in_national_park == true
	np.relevant_management_restrictions == true
}

national_park_excluded(p) if {
	np := object.get(p, "national_park", {})
	np.in_national_park == true
	only_for := national_park_row(np.name).area_premiums_only_for
	only_for != null
	not measure_id in {m | some m in only_for}
}

national_park_excluded(p) if {
	np := object.get(p, "national_park", {})
	np.in_national_park == true
	measure_id in {m | some m in national_park_row(np.name).not_eligible_measures}
}

parcel_exclusions contains {"parcel_id": parcel_id(p), "rule_id": "O6_1C-GEN-001"} if {
	some p in measure_parcels
	national_park_excluded(p)
}

# O6_1C-GEN-002: Code OP – im jeweiligen Förderjahr keine ÖPUL-Prämie.
op_coded(p) if "OP" in parcel_codes(p)

parcel_exclusions contains {"parcel_id": parcel_id(p), "rule_id": "O6_1C-GEN-002"} if {
	some p in measure_parcels
	op_coded(p)
}

# O6_1C-GEN-003: Versuchsflächen (Code VF) – keine Prämie im laufenden Jahr.
parcel_exclusions contains {"parcel_id": parcel_id(p), "rule_id": "O6_1C-GEN-003"} if {
	some p in measure_parcels
	"VF" in parcel_codes(p)
}

# O6_1C-GEN-004: Unterjährige Weitergabe nur bei Weiterführung durch den
# übernehmenden Betrieb; sonst Code OP und keine Prämie.
parcel_exclusions contains {"parcel_id": parcel_id(p), "rule_id": "O6_1C-GEN-004"} if {
	some p in measure_parcels
	object.get(p, ["transfer", "transferred_during_year"], false) == true
	not object.get(p, ["transfer", "successor_continues_commitment"], false) == true
}

general_violations contains violation("O6_1C-GEN-004", p, "Unterjährig weitergegebene Fläche ohne Weiterführung durch den Nachfolgebetrieb ist mit Code OP zu versehen") if {
	some p in measure_parcels
	object.get(p, ["transfer", "transferred_during_year"], false) == true
	not object.get(p, ["transfer", "successor_continues_commitment"], false) == true
	not op_coded(p)
}

# O6_1C-GEN-005: Leistungsüberschneidung mit anderem Titel der öffentlichen
# Hand bzw. gesetzlich/behördlich vorgeschriebene Auflagen -> nicht förderbar (Code OP).
overlap(p) if object.get(p, "public_funding_overlap", false) == true

overlap(p) if object.get(p, "statutory_requirement_overlap", false) == true

parcel_exclusions contains {"parcel_id": parcel_id(p), "rule_id": "O6_1C-GEN-005"} if {
	some p in measure_parcels
	overlap(p)
}

general_violations contains violation("O6_1C-GEN-005", p, "Bei Leistungsüberschneidung bzw. behördlich vorgeschriebenen Auflagen ist der Code OP zu vergeben") if {
	some p in measure_parcels
	overlap(p)
	not op_coded(p)
}

# O6_1C-GEN-006: Reines Fremdverschulden -> maßnahmenbezogener OP-Code,
# keine Prämie auf der betroffenen Schlagfläche.
parcel_exclusions contains {"parcel_id": parcel_id(p), "rule_id": "O6_1C-GEN-006"} if {
	some p in measure_parcels
	object.get(p, "third_party_fault_noncompliance", false) == true
}

# O6_1C-GEN-007: Mindestgröße förderfähiger Flächen 50 m².
parcel_exclusions contains {"parcel_id": parcel_id(p), "rule_id": "O6_1C-GEN-007"} if {
	some p in measure_parcels
	object.get(p, "area_ha", 0) * 10000 < params.general.minimum_eligible_area_m2
}

# O6_1C-ELIG-005: Geförderte Flächen müssen in Österreich liegen.
parcel_exclusions contains {"parcel_id": parcel_id(p), "rule_id": "O6_1C-ELIG-005"} if {
	some p in measure_parcels
	object.get(p, "in_austria", true) == false
}

# O6_1C-GEN-008: Nicht förderfähige Flächenarten (Ausnahme Grünbrachen in o6_1c).
non_eligible_type(t) if {
	some row in data.o6_1c.non_eligible_area_types.rows
	row.type == t
	not measure_id in {m | some m in row.exception_measures}
}

parcel_exclusions contains {"parcel_id": parcel_id(p), "rule_id": "O6_1C-GEN-008"} if {
	some p in measure_parcels
	some t in object.get(p, "non_eligible_area_types", [])
	non_eligible_type(t)
}

# O6_1C-GEN-009: Nicht für die Maßnahme angegebene oder falsch identifizierte
# Flächen sind nicht förderfähig.
parcel_exclusions contains {"parcel_id": parcel_id(p), "rule_id": "O6_1C-GEN-009"} if {
	some p in measure_parcels
	object.get(p, "correctly_identified", true) == false
}

excluded_parcel_ids := {e.parcel_id | some e in parcel_exclusions}

eligible(p) if not parcel_id(p) in excluded_parcel_ids

# O6_1C-NPA-018: NPA und Agroforststreifen sind von den
# Mindestbewirtschaftungskriterien (Ernte, Gründecke) ausgenommen.
minimum_management_exempt if {
	some row in data.o6_1c.minimum_management_exempt_areas.rows
	measure_id in {m | some m in row.measures}
}
