# o6_4 – Teilnahmefähige Flächen und förderwerbende Personen
# Bergmahd-Definition, Seehöhe, Dauersiedlungsgrenze, Ausschlüsse und Zugangsvoraussetzungen.
package oepul.o6_4

import rego.v1

# O64-ELIG-001 / O64-COD-001: nur Bergmahdflächen mit Schlagnutzungsart „Bergmähder"
parcel_failures[pid] contains f if {
	some pid, p in o6_4_parcels
	object.get(mountain_meadow(p), "declared_as_bergmaehder", null) == false
	f := {"rule_id": "O64-ELIG-001", "message": "Schlag ist nicht mit der Schlagnutzungsart „Bergmähder“ beantragt"}
}

# O64-ELIG-002: über der örtlichen Dauersiedlungsgrenze
parcel_failures[pid] contains f if {
	some pid, p in o6_4_parcels
	object.get(mountain_meadow(p), "above_permanent_settlement_limit", null) == false
	f := {"rule_id": "O64-ELIG-002", "message": "Fläche liegt nicht über der örtlichen Dauersiedlungsgrenze"}
}

# O64-ELIG-003: mehr als die Hälfte der Schlagfläche über 1.200 m Seehöhe
parcel_failures[pid] contains f if {
	some pid, p in o6_4_parcels
	share := object.get(mountain_meadow(p), "share_above_1200m_percent", null)
	is_number(share)
	share <= cfg.eligibility_thresholds.min_share_above_1200m_percent_exclusive
	f := {"rule_id": "O64-ELIG-003", "message": sprintf("nur %v %% der Schlagfläche über 1.200 m Seehöhe (erforderlich: mehr als 50 %%)", [share])}
}

# O64-ELIG-004: über der Seehöhe des Heimbetriebes; Ausnahme Almbetriebe
parcel_failures[pid] contains f if {
	some pid, p in o6_4_parcels
	not is_alm_operation
	object.get(mountain_meadow(p), "above_home_farm_elevation", null) == false
	f := {"rule_id": "O64-ELIG-004", "message": "Bergmahdfläche liegt nicht über der Seehöhe des Heimbetriebes"}
}

is_alm_operation if object.get(input, ["farm", "is_alm_operation"], false) == true

# O64-ELIG-005: grenzt in der Regel nicht unmittelbar an eigene Heimbetriebsflächen (Indiz, kein Ausschluss)
parcel_warnings[pid] contains w if {
	some pid, p in o6_4_parcels
	object.get(mountain_meadow(p), "adjacent_to_home_farm_land", false) == true
	w := {"rule_id": "O64-ELIG-005", "message": "Fläche grenzt unmittelbar an Heimbetriebsflächen – Einstufung als Bergmahd prüfen (Regelfall: nicht angrenzend)"}
}

# Fehlende Eingaben für die Bergmahd-Definition
eligibility_fields := [
	"declared_as_bergmaehder",
	"above_permanent_settlement_limit",
	"share_above_1200m_percent",
	"above_home_farm_elevation",
]

parcel_missing[pid] contains field if {
	some pid, p in o6_4_parcels
	some field in definition_missing(p)
}

field_exempt("above_home_farm_elevation") if is_alm_operation

# O64-ELIG-001..004: Schlag erfüllt die Bergmahd-Definition
definition_missing(p) := {field |
	some field in eligibility_fields
	not field_exempt(field)
	object.get(mountain_meadow(p), field, null) == null
}

parcel_is_bergmahd[pid] if {
	some pid, p in o6_4_parcels
	count(object.get(parcel_failures, pid, set())) == 0
	count(definition_missing(p)) == 0
}

# O64-GEN-006: nicht förderfähige Flächen (Nationalparks, OP-/VF-Code, sonstige Ausschlüsse)
parcel_premium_exclusions[pid] contains f if {
	some pid, p in o6_4_parcels
	np := object.get(parcel_oepul(p), "national_park", null)
	some park in cfg.national_parks
	park.key == np
	park.oepul_area_premium_possible == false
	f := {"rule_id": "O64-GEN-006", "message": sprintf("Fläche im Nationalpark %v – keine flächenbezogene ÖPUL-Prämie", [park.name])}
}

parcel_premium_exclusions[pid] contains f if {
	some pid, p in o6_4_parcels
	"OP" in object.get(parcel_oepul(p), "codes", [])
	f := {"rule_id": "O64-GEN-007", "message": "Schlag mit Code OP – keine ÖPUL-Prämie im Förderjahr"}
}

# maßnahmenbezogener OP-Code (Bezeichnung für o6_4 in den Quellen nicht genannt, daher als Flag)
parcel_premium_exclusions[pid] contains f if {
	some pid, p in o6_4_parcels
	object.get(parcel_oepul(p), "measure_specific_op_code_o6_4", false) == true
	f := {"rule_id": "O64-GEN-007", "message": "maßnahmenbezogener OP-Code für o6_4 – keine Prämie für diese Maßnahme"}
}

parcel_premium_exclusions[pid] contains f if {
	some pid, p in o6_4_parcels
	"VF" in object.get(parcel_oepul(p), "codes", [])
	f := {"rule_id": "O64-GEN-006", "message": "Versuchsfläche (Code VF) – im laufenden Antragsjahr keine Prämie"}
}

parcel_premium_exclusions[pid] contains f if {
	some pid, p in o6_4_parcels
	some key in object.get(parcel_oepul(p), "non_eligible_reasons", [])
	some ne in cfg.non_eligible_areas
	ne.key == key
	f := {"rule_id": "O64-GEN-006", "message": sprintf("nicht förderfähige Fläche: %v", [ne.label])}
}

# O64-ELIG-010: Mindestgröße einer förderfähigen Fläche 50 m²
parcel_premium_exclusions[pid] contains f if {
	some pid, p in o6_4_parcels
	p.area_ha < 0.005
	f := {"rule_id": "O64-ELIG-010", "message": "förderfähige Fläche unter 50 m²"}
}

# O64-GEN-002: förderwerbende Person
applicant := object.get(input, ["farm", "applicant"], {})

applicant_failures contains f if {
	applicant.legal_form == "public_body"
	f := {"rule_id": "O64-GEN-002", "message": "Gebietskörperschaften und deren Einrichtungen sind bei dieser Maßnahme nicht förderwerbend"}
}

applicant_failures contains f if {
	some t in cfg.applicant_types
	t.type == applicant.legal_form
	is_number(t.max_public_body_share_percent)
	applicant.public_body_share_percent > t.max_public_body_share_percent
	f := {"rule_id": "O64-GEN-002", "message": "Beteiligung von Gebietskörperschaften über 25 %"}
}

applicant_failures contains f if {
	applicant.is_active_farmer == false
	f := {"rule_id": "O64-GEN-003", "message": "Kein aktiver Landwirt"}
}

applicant_failures contains f if {
	applicant.manages_in_own_name_and_account == false
	f := {"rule_id": "O64-GEN-003", "message": "Betrieb wird nicht im eigenen Namen und auf eigene Rechnung bewirtschaftet"}
}

applicant_failures contains f if {
	applicant.has_disposal_over_areas == false
	f := {"rule_id": "O64-GEN-003", "message": "keine Verfügungsgewalt über die beantragten Flächen"}
}

# O64-GEN-004: Betriebsmindestgröße nur im ersten ÖPUL-Teilnahmejahr
first_participation_year := object.get(input, ["oepul", "first_participation_year"], null)

farm_minimum_size_met if {
	object.get(input, ["land", "protected_cultivation_area_ha"], 0) >= cfg.farm_minimum_size.protected_cultivation_ha
}

farm_minimum_size_met if {
	object.get(input, ["land", "total_area_ha"], 0) >= cfg.farm_minimum_size.agricultural_area_ha
}

farm_minimum_size_required if first_participation_year == year

applicant_failures contains f if {
	farm_minimum_size_required
	not farm_minimum_size_met
	f := {"rule_id": "O64-GEN-004", "message": "Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr nicht erreicht (0,50 ha geschützter Anbau oder 1,50 ha landwirtschaftliche Fläche)"}
}

applicant_eligible if count(applicant_failures) == 0

# O64-ELIG-006..008: keine Kombinationspflicht, keine Gesamtteilnahme, keine Mindestteilnahmefläche
combination_obligation := cfg.measure.combination_obligation

all_bergmaehder_required := cfg.measure.all_farm_bergmaehder_required

minimum_participation_area_ha := cfg.measure.minimum_participation_area_ha
