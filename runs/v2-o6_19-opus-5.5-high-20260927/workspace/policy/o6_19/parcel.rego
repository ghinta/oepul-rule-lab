# Schlagbezogene Förderfähigkeit und Bewirtschaftungsauflagen der EBW.
package oepul.o6_19

import rego.v1

# R-O619-ELIG-LAND-USE: nur Acker- und Grünlandflächen (ohne Almen).
parcel_land_use_eligible(p) if p.land_use in params.eligible_land_uses

# R-O619-PROJECT-CONFIRMATION-PARCEL: Schlag muss in der Projektbestätigung ausgewählt sein.
parcel_in_project_confirmation(p) if parcel_ebw(p).in_project_confirmation == true

# R-O619-REFERENCE-AREA: für die Auszahlung ist eine EBW-Referenzfläche erforderlich.
parcel_reference_area_present(p) if parcel_ebw(p).reference_area_present == true

# R-O619-USE-EVERY-SECOND-YEAR: pflegebedürftige Flächen zumindest jedes zweite Jahr nutzen oder pflegen.
parcel_use_interval_ok(p) if not parcel_ebw(p).requires_regular_care == true

parcel_use_interval_ok(p) if {
	parcel_ebw(p).requires_regular_care == true
	year - parcel_ebw(p).last_use_or_care_year < params.use_or_care_interval_years
}

# R-O619-INDICATORS-BINDING: festgelegte Indikatoren sind zu erreichen; Zusatzindikatoren sind nicht bindend.
parcel_binding_indicators(p) := [i |
	some i in object.get(parcel_ebw(p), "indicators", [])
	not i.binding == false
]

parcel_unmet_binding_indicators(p) := {i.code |
	some i in parcel_binding_indicators(p)
	not i.fulfilled == true
}

# R-O619-INDICATOR-CATALOGUE: Indikatorcodes stammen aus Anhang K.
indicator_codes := {i.code | some i in tables.indicators.catalogue}

parcel_unknown_indicator_codes(p) := {i.code |
	some i in object.get(parcel_ebw(p), "indicators", [])
	not i.code in indicator_codes
}

# R-O619-INDICATORS-RECORDING: Indikatoren laufend beobachten und in der Datenbank erfassen.
parcel_indicators_recorded(p) if parcel_ebw(p).indicators_recorded == true

# R-O619-MGMT-CHANGE: Abänderung der Bewirtschaftung nur nach Rücksprache und schriftlicher Abänderung.
parcel_management_change_ok(p) if not parcel_ebw(p).management_deviation == true

parcel_management_change_ok(p) if {
	parcel_ebw(p).management_deviation == true
	parcel_ebw(p).deviation_agreed_with_coordination_body == true
	parcel_ebw(p).deviation_confirmation_amended_in_writing == true
}

# R-O619-SETASIDE-CAP: Kennzeichen Ackerstilllegung (für Obergrenze und DIV-Anrechnung).
parcel_is_set_aside(p) if parcel_ebw(p).is_arable_set_aside == true

check_list(checks) := [{"rule_id": c.rule_id, "message": c.message} |
	some c in checks
	c.ok == false
]

# Förderfähigkeit des Schlages (Fläche wird ohne Erfüllung nicht prämienfähig).
parcel_eligibility_failures[pid] := found if {
	some pid, p in ebw_parcels
	found := {v | some v in check_list([
		{"ok": parcel_land_use_eligible_b(p), "rule_id": "R-O619-ELIG-LAND-USE", "message": "Nur Acker- und Grünlandflächen ohne Almen sind förderfähig."},
		{"ok": parcel_in_project_confirmation_b(p), "rule_id": "R-O619-PROJECT-CONFIRMATION-PARCEL", "message": "Schlag ist nicht in der Projektbestätigung enthalten."},
		{"ok": parcel_use_interval_ok_b(p), "rule_id": "R-O619-USE-EVERY-SECOND-YEAR", "message": "Pflegebedürftige Fläche wurde nicht zumindest jedes zweite Jahr genutzt oder gepflegt."},
		{"ok": parcel_ecological_value_ok_b(p), "rule_id": "R-O619-K-LOW-VALUE-EXCLUDED", "message": "Ökologischer Wert der Fläche zu niedrig für die Aufnahme in die EBW."},
	])}
}

# Inhaltliche Förderverpflichtungen (Verstöße führen zu Kürzungen gemäß Sanktionsschema).
parcel_obligation_violations[pid] := found if {
	some pid, p in ebw_parcels
	found := {v | some v in check_list([
		{"ok": count(parcel_unmet_binding_indicators(p)) == 0, "rule_id": "R-O619-INDICATORS-BINDING", "message": sprintf("Festgelegte Indikatoren nicht erreicht: %v", [sort(parcel_unmet_binding_indicators(p))])},
		{"ok": parcel_indicators_recorded_b(p), "rule_id": "R-O619-INDICATORS-RECORDING", "message": "Indikatoren wurden nicht laufend beobachtet und in der Datenbank erfasst."},
		{"ok": parcel_management_change_ok_b(p), "rule_id": "R-O619-MGMT-CHANGE", "message": "Bewirtschaftungsänderung ohne Rücksprache und schriftliche Abänderung der Projektbestätigung."},
		{"ok": count(parcel_unknown_indicator_codes(p)) == 0, "rule_id": "R-O619-INDICATOR-CATALOGUE", "message": sprintf("Indikatorcodes nicht in Anhang K: %v", [sort(parcel_unknown_indicator_codes(p))])},
	])}
}

parcel_ecological_value_ok_b(p) if parcel_ecological_value_ok(p)

default parcel_ecological_value_ok_b(_) := false

parcel_in_project_confirmation_b(p) if parcel_in_project_confirmation(p)

default parcel_in_project_confirmation_b(_) := false

parcel_indicators_recorded_b(p) if parcel_indicators_recorded(p)

default parcel_indicators_recorded_b(_) := false

parcel_land_use_eligible_b(p) if parcel_land_use_eligible(p)

default parcel_land_use_eligible_b(_) := false

parcel_management_change_ok_b(p) if parcel_management_change_ok(p)

default parcel_management_change_ok_b(_) := false

parcel_use_interval_ok_b(p) if parcel_use_interval_ok(p)

default parcel_use_interval_ok_b(_) := false

parcel_violations[pid] := parcel_eligibility_failures[pid] | parcel_obligation_violations[pid] if some pid in ebw_parcel_ids

# R-O619-GLOEZ4-GLOEZ8-EXCLUSION: GLÖZ-4-Pufferstreifen und (bis 2024) GLÖZ-8-Stilllegungen nicht förderbar.
parcel_gloez_excluded_area(p) := get_num(p, ["oepul", "gloez4_buffer_area_ha"]) + get_num(p, ["oepul", "gloez8_set_aside_area_ha"]) if {
	year <= params.gloez8_exclusion_last_year
}

parcel_gloez_excluded_area(p) := get_num(p, ["oepul", "gloez4_buffer_area_ha"]) if {
	year > params.gloez8_exclusion_last_year
}

# R-O619-NPF-GLOEZ8: bis 2024 mit NPF codierte EBW-Stilllegungen zählen für GLÖZ 8, aber keine ÖPUL-Prämie.
no_premium_reasons[pid] contains "R-O619-NPF-GLOEZ8" if {
	some pid, p in ebw_parcels
	has_code(p, "NPF")
	year <= params.npf_last_year
}

# R-O619-GEN-OP-CODE / R-O619-GEN-TRIAL-AREA: Code OP bzw. VF -> keine Prämie im Förderjahr.
no_premium_reasons[pid] contains "R-O619-GEN-OP-CODE" if {
	some pid, p in ebw_parcels
	has_code(p, "OP")
}

no_premium_reasons[pid] contains "R-O619-GEN-TRIAL-AREA" if {
	some pid, p in ebw_parcels
	has_code(p, "VF")
}

# R-O619-GEN-NATIONAL-PARK: Nationalparkflächen ohne Prämie (außer ohne relevante Auflagen); Neusiedlersee/Donau-Auen generell keine.
no_premium_reasons[pid] contains "R-O619-GEN-NATIONAL-PARK" if {
	some pid, p in ebw_parcels
	np := object.get(p, ["oepul", "national_park"], null)
	is_string(np)
	np in general_tables.national_parks_no_area_premium
}

no_premium_reasons[pid] contains "R-O619-GEN-NATIONAL-PARK" if {
	some pid, p in ebw_parcels
	np := object.get(p, ["oepul", "national_park"], null)
	is_string(np)
	not np in general_tables.national_parks_no_area_premium
	object.get(p, ["oepul", "national_park_relevant_requirements"], true) == true
}

# R-O619-GEN-LOCATION-AT: nur Flächen in Österreich.
no_premium_reasons[pid] contains "R-O619-GEN-LOCATION-AT" if {
	some pid, p in ebw_parcels
	object.get(p, ["oepul", "located_in_austria"], true) == false
}

# R-O619-REFERENCE-AREA
no_premium_reasons[pid] contains "R-O619-REFERENCE-AREA" if {
	some pid, p in ebw_parcels
	not parcel_reference_area_present(p)
}

# R-O619-COMBINATION-SAME-AREA: auf der Einzelfläche nur mit Natura 2000 (23) sowie LSE-Abgeltung UBB/BIO kombinierbar.
parcel_forbidden_combinations(p) := {c.measure |
	some c in object.get(p, ["oepul", "other_measure_premium_claims"], [])
	not combination_allowed(c)
}

combination_allowed(c) if {
	some m in params.combinable_measures_same_area
	m.measure == c.measure
	"all" in m.components
}

combination_allowed(c) if {
	some m in params.combinable_measures_same_area
	m.measure == c.measure
	c.component in m.components
}

# Die Kombinationssperre betrifft die Prämie der anderen Maßnahme auf derselben Einzelfläche;
# sie wird als Konflikt ausgewiesen, ohne die EBW-Prämie automatisch zu streichen.
combination_conflicts[pid] := conflicts if {
	some pid, p in ebw_parcels
	conflicts := parcel_forbidden_combinations(p)
	count(conflicts) > 0
}

# Förderfähige Fläche je Schlag (vor Stilllegungs-Obergrenze und Flächenzugangsbeschränkung).
parcel_eligible_area[pid] := a if {
	some pid, p in ebw_parcels
	count(parcel_eligibility_failures[pid]) == 0
	count(parcel_reasons(pid)) == 0
	a := max([0, num(p.area_ha) - parcel_gloez_excluded_area(p)])
}

parcel_eligible_area[pid] := 0 if {
	some pid, p in ebw_parcels
	not parcel_clean(pid, p)
}

parcel_reasons(pid) := object.get(no_premium_reasons, pid, set())

parcel_clean(pid, _) if {
	count(parcel_eligibility_failures[pid]) == 0
	count(parcel_reasons(pid)) == 0
}

# R-O619-K-LOW-VALUE-EXCLUDED: Flächen mit zu geringem ökologischem Wert können nicht in die EBW aufgenommen werden.
parcel_ecological_value_ok(p) if not parcel_ebw(p).ecological_value_too_low == true

# Vorgaben aus Anhang K zur Erstellung der Projektbestätigung (Einstufung, Schlagbildung, Indikatorwahl).
indicator_category(code) := {i.category | some i in tables.indicators.catalogue; i.code == code}

# R-O619-K-HABITAT-CLASSIFICATION: Grünlandbrachen erhalten den Ziel-Lebensraumtyp mit Erhaltungszustand C (selten B).
pb_design_issues[pid] contains "fallow_conservation_status_must_be_c_or_b" if {
	some pid, p in ebw_parcels
	parcel_ebw(p).is_grassland_fallow == true
	not parcel_ebw(p).conservation_status in {"B", "C"}
}

# R-O619-K-DOMINANT-HABITAT: getrennte Schläge je Lebensraumtyp nur bei mindestens 0,1 ha.
pb_design_issues[pid] contains "habitat_split_parcel_below_0_1_ha" if {
	some pid, p in ebw_parcels
	parcel_ebw(p).split_by_habitat_type == true
	num(p.area_ha) < 0.1
}

# R-O619-K-ARABLE-AS-GRASSLAND: als Grünland bewirtschaftete Ackerflächen erhalten Indikatoren des Grünlandtyps.
pb_design_issues[pid] contains "arable_managed_as_grassland_needs_grassland_indicators" if {
	some pid, p in ebw_parcels
	parcel_ebw(p).managed_as_grassland == true
	some i in object.get(parcel_ebw(p), "indicators", [])
	"acker_lebensraum" in indicator_category(i.code)
}
