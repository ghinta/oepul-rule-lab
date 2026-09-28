# Optionaler Zuschlag Festmistkompostierung (Kapitel 6.4 Informationsblatt, Punkt 2.21 SRL).
package oepul.o6_21

import rego.v1

comp_cfg := data.o6_21.composting

composting := object.get(o6_21_input, "composting", {})

windrows := object.get(composting, "windrows", [])

device_cfg(id) := d if {
	some d in comp_cfg.turning_devices
	d.id == id
}

method_cfg(id) := m if {
	some m in comp_cfg.windrow_methods
	m.id == id
}

turning_dates_ns(w) := sort([date_ns(d) | some d in object.get(w, "turning_dates", [])])

# O6_21-COMP-002: mindestens zweimaliges Umsetzen in einem Abstand von mindestens 14 Tagen.
turnings_sufficient(w) if {
	ds := turning_dates_ns(w)
	count(ds) >= comp_cfg.min_turnings
	some i, j
	ds[i]
	ds[j]
	i < j
	(ds[j] - ds[i]) / day_ns >= comp_cfg.min_interval_days_between_turnings
}

# O6_21-COMP-004 / O6_21-COMP-005: Kompostwender oder gleichwertiges Gerät, kein Frontlader.
turning_device_ok(w) if {
	d := device_cfg(w.turning_device)
	d.accepted == true
	not d.requires_full_turnover_proof
}

turning_device_ok(w) if {
	d := device_cfg(w.turning_device)
	d.accepted == true
	d.requires_full_turnover_proof
	w.full_turnover_ensured == true
}

# O6_21-COMP-003: Kompostwender am Betrieb oder überbetrieblicher Einsatz belegt.
device_availability_ok(w) if w.device_on_farm == true

device_availability_ok(w) if w.external_use_documented == true

has_plant_material(w) if {
	some m in object.get(w, "plant_materials", [])
	some cfg in comp_cfg.mixed_windrow_plant_materials
	cfg.id == m
}

composting_violations contains {"rule_id": "O6_21-COMP-001", "reason": "nicht der gesamte am Betrieb anfallende Festmist wird am Betrieb zu Kompostmieten aufgesetzt"} if {
	composting_supplement_applied
	not composting.all_solid_manure_in_windrows_on_farm == true
}

composting_violations contains {"rule_id": "O6_21-COMP-001", "reason": "keine Kompostmiete erfasst"} if {
	composting_supplement_applied
	count(windrows) == 0
}

composting_violations contains {"rule_id": "O6_21-COMP-002", "windrow_id": w.windrow_id, "reason": "weniger als zwei Umsetzvorgänge im Abstand von mindestens 14 Tagen"} if {
	composting_supplement_applied
	some w in windrows
	w.method == "turned"
	not turnings_sufficient(w)
}

composting_violations contains {"rule_id": rid, "windrow_id": w.windrow_id, "reason": "Umsetzgerät nicht zulässig oder vollständige Umsetzung nicht gewährleistet"} if {
	composting_supplement_applied
	some w in windrows
	w.method == "turned"
	not turning_device_ok(w)
	rid := device_rule(w)
}

device_rule(w) := "O6_21-COMP-004" if w.turning_device == "front_loader"

else := "O6_21-COMP-005"

composting_violations contains {"rule_id": "O6_21-COMP-003", "windrow_id": w.windrow_id, "reason": "Umsetzgerät weder am Betrieb vorhanden noch überbetriebliche Verwendung belegt"} if {
	composting_supplement_applied
	some w in windrows
	w.method == "turned"
	not device_availability_ok(w)
}

# O6_21-COMP-006: gemischte/geschichtete Mieten erst ab Antragsjahr 2025 anerkannt.
composting_violations contains {"rule_id": "O6_21-COMP-006", "windrow_id": w.windrow_id, "reason": "Misch-/Schichtmiete ohne Umsetzen vor dem Antragsjahr 2025 bzw. ohne Material der Feldproduktion/Strauch- oder Astmaterial"} if {
	composting_supplement_applied
	some w in windrows
	w.method == "mixed_layered"
	not mixed_windrow_ok(w)
}

mixed_windrow_ok(w) if {
	measure_year >= method_cfg("mixed_layered").from_year
	has_plant_material(w)
}

# O6_21-COMP-007 / O6_21-COMP-008: wendefreie Kompostierung nur mit Beimengung und Kompostierungsverfahren.
composting_violations contains {"rule_id": "O6_21-COMP-007", "windrow_id": w.windrow_id, "reason": "wendefreie Miete ohne nennenswerte Beimengung organischen Materials oder ohne Kompostierungsverfahren"} if {
	composting_supplement_applied
	some w in windrows
	w.method == "turn_free_with_admixture"
	not turn_free_ok(w)
}

turn_free_ok(w) if {
	w.organic_material_admixture_substantial == true
	w.composting_process_applied == true
	not w.straw_rich_manure_only == true
}

composting_violations contains {"rule_id": "O6_21-COMP-008", "windrow_id": w.windrow_id, "reason": "strohreicher Mist allein erfüllt nicht die Voraussetzungen der wendefreien Kompostierung"} if {
	composting_supplement_applied
	some w in windrows
	w.method == "turn_free_with_admixture"
	w.straw_rich_manure_only == true
}

composting_violations contains {"rule_id": "O6_21-COMP-001", "windrow_id": w.windrow_id, "reason": "unbekannte Kompostierungsmethode"} if {
	composting_supplement_applied
	some w in windrows
	not method_cfg(w.method)
}

# O6_21-COMP-009: Dokumentation der Anlage, des Umsetzens und des Ausbringens bzw. der Abgabe.
composting_violations contains {"rule_id": "O6_21-COMP-009", "reason": "Dokumentation der Kompostierung unvollständig"} if {
	composting_supplement_applied
	some item in comp_cfg.documentation_items
	not item in {i | some i in object.get(composting, "documented_items", [])}
}

# O6_21-COMP-011: Vorgaben der Nitrat-Aktionsprogramm-Verordnung bei der Anlage von Kompostmieten.
composting_violations contains {"rule_id": "O6_21-COMP-011", "reason": "Vorgaben der Nitrat-Aktionsprogramm-Verordnung nicht eingehalten"} if {
	composting_supplement_applied
	composting.napv_compliant == false
}

# O6_21-COMP-012: kein Zuschlag für Kompostställe.
composting_violations contains {"rule_id": "O6_21-COMP-012", "reason": "Kompoststall - Zuschlag nicht gewährbar"} if {
	composting_supplement_applied
	composting.compost_barn == true
}

default composting_supplement_eligible := false

composting_supplement_eligible if {
	composting_supplement_applied
	count(composting_violations) == 0
}
