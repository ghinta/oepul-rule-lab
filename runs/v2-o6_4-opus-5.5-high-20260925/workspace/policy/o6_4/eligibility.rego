# Teilnahmefähige Flächen (Maßnahmenblatt Kap. 3.2, SRL 2.4 Zugangsvoraussetzungen).
package oepul.o6_4

# O6_4-ELIG-001: Teilnahme ausschließlich mit Bergmahdflächen (Schlagnutzungsart „Bergmähder").
eligibility_failure contains [pid, "O6_4-ELIG-001"] if {
	some pid, p in enrolled_parcels
	not object.get(p, ["mountain_meadow", "declared_as_mountain_meadow"], false) == true
}

# O6_4-ELIG-002: mehr als die Hälfte der Schlagfläche über 1.200 m Seehöhe.
eligibility_failure contains [pid, "O6_4-ELIG-002"] if {
	some pid, p in enrolled_parcels
	not majority_above_1200m(p)
}

majority_above_1200m(p) if p.mountain_meadow.share_above_1200m_percent > 50

# O6_4-ELIG-003: extensive Mähfläche über der örtlichen Dauersiedlungsgrenze.
eligibility_failure contains [pid, "O6_4-ELIG-003"] if {
	some pid, p in enrolled_parcels
	not object.get(p, ["mountain_meadow", "above_local_permanent_settlement_limit"], false) == true
}

# O6_4-ELIG-004: über der Seehöhe des Heimbetriebes; bei Almbetrieben auch unter der Almbetriebsstätte zulässig.
eligibility_failure contains [pid, "O6_4-ELIG-004"] if {
	some pid, p in enrolled_parcels
	not above_home_farm_or_alpine_exception(p)
}

above_home_farm_or_alpine_exception(p) if {
	p.mountain_meadow.parcel_altitude_m > participation.home_farm_altitude_m
}

above_home_farm_or_alpine_exception(_) if participation.is_alpine_farm_operation == true

# GEN-LOC-001: geförderte Flächen müssen in Österreich liegen.
eligibility_failure contains [pid, "GEN-LOC-001"] if {
	some pid, p in enrolled_parcels
	object.get(p, "located_in_austria", true) == false
}

# GEN-ELIG-002: nicht förderfähige Flächenkategorien (geschlossene Liste in data).
non_eligible_category_keys := {r.key | some r in params.non_eligible_area_categories.rows}

eligibility_failure contains [pid, "GEN-ELIG-002"] if {
	some pid, p in enrolled_parcels
	some k in object.get(p, "non_eligible_categories", [])
	k in non_eligible_category_keys
	k != "national_park"
}

# O6_4-ELIG-005: Bergmähder grenzen in der Regel nicht an Heimbetriebsflächen – nur Prüfhinweis.
advisory contains {"rule_id": "O6_4-ELIG-005", "parcel_id": pid, "message": "Bergmahdfläche grenzt unmittelbar an Heimbetriebsflächen – Einstufung als Bergmahd prüfen"} if {
	some pid, p in enrolled_parcels
	p.mountain_meadow.adjacent_to_home_farm_areas == true
}

parcel_failures(pid) := {rid | some [id, rid] in eligibility_failure; id == pid}

parcel_eligible(pid) if {
	enrolled_parcels[pid]
	count(parcel_failures(pid)) == 0
}

eligibility[pid] := {
	"eligible": count(parcel_failures(pid)) == 0,
	"failed_rules": sort([r | some r in parcel_failures(pid)]),
} if {
	some pid, _ in enrolled_parcels
}
