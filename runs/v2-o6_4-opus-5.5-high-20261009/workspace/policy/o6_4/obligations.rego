# o6_4 – Förderbedingungen (Mahd, Beweidung, Düngung, Pflanzenschutz, Codierung)
# Prüft die jährlichen Bewirtschaftungsauflagen auf allen o6_4-Schlägen, auch in BM0-Jahren.
package oepul.o6_4

import rego.v1

mowing_events_of(p) := events_in_year(object.get(parcel_ops(p), "mowing_events", []))

# O64-OBL-001: Mahd zählt nur bei vollflächiger Mahd mit Verbringung des Mähgutes
qualifying_mowing(e) if {
	object.get(e, "full_area", false) == true
	object.get(e, "cut_material_removed", false) == true
	object.get(e, "mulched", false) == false
}

qualifying_mowings(p) := [e |
	some e in mowing_events_of(p)
	qualifying_mowing(e)
]

qualifying_mowing_this_year[pid] if {
	some pid, p in o6_4_parcels
	count(qualifying_mowings(p)) > 0
}

# Jahre mit vollflächiger Mahd (Historie + laufendes Jahr)
history_mowing_years(p) := {y | some y in object.get(mountain_meadow(p), "full_mowing_years", [])}

full_mowing_years(pid, p) := history_mowing_years(p) | {year} if {
	qualifying_mowing_this_year[pid]
} else := history_mowing_years(p)

# O64-OBL-001: zumindest jedes zweite Jahr vollflächige Mahd inkl. Verbringung (Jahresendbetrachtung)
violations contains v if {
	some pid, p in o6_4_parcels
	is_number(contract_start_year)
	year > contract_start_year
	years := full_mowing_years(pid, p)
	not year in years
	not (year - 1) in years
	v := {"rule_id": "O64-OBL-001", "parcel_id": pid, "message": "keine vollflächige Mahd mit Verbringung des Mähgutes im laufenden und im Vorjahr"}
}

# O64-OBL-002: maximal eine Mahd pro Jahr
violations contains v if {
	some pid, p in o6_4_parcels
	n := count(mowing_events_of(p))
	n > cfg.mowing_rules.max_mowings_per_year
	v := {"rule_id": "O64-OBL-002", "parcel_id": pid, "message": sprintf("%v Mahden im Jahr (maximal 1 zulässig)", [n])}
}

# O64-OBL-003: Mähen und Liegenlassen bzw. Häckseln unzulässig
violations contains v if {
	some pid, p in o6_4_parcels
	some e in mowing_events_of(p)
	object.get(e, "mulched", false) == true
	v := {"rule_id": "O64-OBL-003", "parcel_id": pid, "message": sprintf("Fläche am %v gehäckselt – unzulässig", [e.date])}
}

violations contains v if {
	some pid, p in o6_4_parcels
	some e in mowing_events_of(p)
	object.get(e, "mulched", false) == false
	object.get(e, "cut_material_removed", true) == false
	v := {"rule_id": "O64-OBL-003", "parcel_id": pid, "message": sprintf("Mähgut der Mahd am %v nicht verbracht (liegen gelassen) – unzulässig", [e.date])}
}

# O64-OBL-004/005: Beweidung verboten, Nachweide ab 16. August jährlich zulässig
violations contains v if {
	some pid, p in o6_4_parcels
	some g in object.get(parcel_ops(p), "grazing_events", [])
	date_year(g.start_date) == year
	month_day(g.start_date) < cfg.mowing_rules.post_grazing_earliest_month_day
	v := {"rule_id": "O64-OBL-004", "parcel_id": pid, "message": sprintf("Beweidung ab %v vor dem 16. August – unzulässig", [g.start_date])}
}

post_grazing_allowed(d) if month_day(d) >= cfg.mowing_rules.post_grazing_earliest_month_day

# O64-OBL-006..009: Düngemittel, Klärschlamm, Kalk; Ausnahme Festmist (ursprüngliche Form) und häusliche Abwässer
fertilizer_rule_id("lime") := "O64-OBL-008"

fertilizer_rule_id("solid_manure_dissolved") := "O64-OBL-007"

fertilizer_rule_id(t) := "O64-OBL-006" if not t in {"lime", "solid_manure_dissolved"}

fertilizer_type_allowed(t) if {
	some ft in cfg.fertilizer_types
	ft.type == t
	ft.allowed == true
}

violations contains v if {
	some pid, p in o6_4_parcels
	some a in events_in_year(object.get(parcel_ops(p), "fertilizer_applications", []))
	not fertilizer_type_allowed(a.type)
	v := {"rule_id": fertilizer_rule_id(a.type), "parcel_id": pid, "message": sprintf("Ausbringung von %v am %v – unzulässig", [a.type, a.date])}
}

violations contains v if {
	some pid, p in o6_4_parcels
	some a in events_in_year(object.get(parcel_ops(p), "fertilizer_applications", []))
	a.type == "solid_manure"
	object.get(a, "demand_based", true) == false
	v := {"rule_id": "O64-OBL-007", "parcel_id": pid, "message": sprintf("Festmistausbringung am %v nicht bedarfsgerecht", [a.date])}
}

# Kurzangaben im Profil: Mineraldünger-N > 0 ist auf o6_4-Flächen jedenfalls unzulässig
violations contains v if {
	some pid, p in o6_4_parcels
	n := object.get(parcel_ops(p), ["fertilizer", "mineral_n_kg_per_ha"], null)
	is_number(n)
	n > 0
	v := {"rule_id": "O64-OBL-006", "parcel_id": pid, "message": "mineralische Stickstoffdüngung angegeben – unzulässig"}
}

# O64-OBL-010: Pflanzenschutzmittel nur mit Wirkstoffen gemäß VO (EU) 2018/848
violations contains v if {
	some pid, p in o6_4_parcels
	some a in events_in_year(object.get(parcel_ops(p), "psm_applications", []))
	object.get(a, "only_eu_2018_848_substances", false) == false
	v := {"rule_id": "O64-OBL-010", "parcel_id": pid, "message": sprintf("Pflanzenschutzmittel %v enthält nicht ausschließlich gemäß VO (EU) 2018/848 zulässige Wirkstoffe", [object.get(a, "product", "unbekannt")])}
}

parcel_warnings[pid] contains w if {
	some pid, p in o6_4_parcels
	object.get(parcel_ops(p), "psm_used", false) == true
	count(object.get(parcel_ops(p), "psm_applications", [])) == 0
	w := {"rule_id": "O64-OBL-010", "message": "PSM-Einsatz angegeben, aber keine Angaben zur Bio-Zulässigkeit der Wirkstoffe"}
}

# O64-COD-002/003/005: erwarteter Mähcode aus dem Hauptmähverfahren
expected_mowing_code[pid] := code if {
	some pid, p in o6_4_parcels
	ms := qualifying_mowings(p)
	count(ms) > 0
	ranks := [cfg.mowing_method_rank[e.method] | some e in ms]
	best := min(ranks)
	some e in ms
	cfg.mowing_method_rank[e.method] == best
	code := cfg.mowing_method_to_code[e.method]
}

expected_mowing_code[pid] := "BM0" if {
	some pid, p in o6_4_parcels
	object.get(parcel_ops(p), "mowing_events", null) != null
	count(qualifying_mowings(p)) == 0
}

declared_mowing_code(p) := object.get(mountain_meadow(p), "declared_mowing_code", null)

parcel_warnings[pid] contains w if {
	some pid, p in o6_4_parcels
	some e in mowing_events_of(p)
	not cfg.mowing_method_to_code[object.get(e, "method", "")]
	w := {"rule_id": "O64-COD-002", "message": sprintf("Mähverfahren der Mahd am %v fehlt oder ist unbekannt", [e.date])}
}

violations contains v if {
	some pid, p in o6_4_parcels
	declared := declared_mowing_code(p)
	declared != null
	expected := expected_mowing_code[pid]
	declared != expected
	v := {"rule_id": rule_for_code(expected), "parcel_id": pid, "message": sprintf("beantragter Code %v entspricht nicht der Bewirtschaftung (%v)", [declared, expected])}
}

rule_for_code("BM0") := "O64-COD-003"

rule_for_code(c) := "O64-COD-002" if c != "BM0"

parcel_missing[pid] contains "declared_mowing_code" if {
	some pid, p in o6_4_parcels
	declared_mowing_code(p) == null
}
