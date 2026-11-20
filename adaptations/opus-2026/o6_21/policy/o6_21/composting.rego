# Optionaler Zuschlag Festmistkompostierung (o6_21, Kapitel 6.4; SRL 2.21; NAPV § 6).
package oepul.o6_21.composting

import data.oepul.o6_21.application
import data.oepul.o6_21.lib

cfg := lib.tables.composting

comp := object.get(input, ["livestock", "solid_manure_composting"], {})

windrows := object.get(comp, "windrows", [])

equipment_row(equip) := row if {
	some row in lib.tables.turning_equipment
	row.equipment == equip
}

# O6_21-COMP-03: Frontlader zählt nicht als Umsetzen; Miststreuer/adäquate Geräte nur bei vollständigem Umsetzen.
counting_turning(t) if {
	row := equipment_row(t.equipment)
	row.counts_for_turning
	not row.requires_complete_turning
}

counting_turning(t) if {
	row := equipment_row(t.equipment)
	row.counts_for_turning
	row.requires_complete_turning
	object.get(t, "windrow_completely_turned", false)
}

counting_turning_dates(w) := sort([t.date |
	some t in object.get(w, "turnings", [])
	counting_turning(t)
])

# O6_21-COMP-02: mindestens zweimaliges Umsetzen im Abstand von mindestens 14 Tagen.
turning_requirement_met(w) if {
	dates := counting_turning_dates(w)
	count(dates) >= cfg.min_turnings
	some i, j
	i < j
	lib.days_between(dates[i], dates[j]) >= cfg.min_turning_interval_days
}

# O6_21-COMP-04: Kompostwender am Betrieb vorhanden oder überbetrieblicher Einsatz belegt.
turner_available if comp.compost_turner_on_farm

turner_available if comp.external_turner_use_documented

turner_used(w) if {
	some t in object.get(w, "turnings", [])
	t.equipment == "compost_turner"
}

turner_availability_ok(w) if not turner_used(w)

turner_availability_ok(w) if {
	turner_used(w)
	turner_available
}

# O6_21-COMP-02: Standardmiete mit Umsetzen.
windrow_method_ok(w) if {
	w.method == "turned"
	turning_requirement_met(w)
	turner_availability_ok(w)
}

# O6_21-COMP-05: ab Antragsjahr 2025 Mischung/Schichtung aus Festmist und Material der Feldproduktion
# bzw. Strauch-/Astschnitt; kein Umsetzen erforderlich.
windrow_method_ok(w) if {
	w.method == "mixed_or_layered"
	lib.year >= cfg.mixed_windrows_from_year
	some m in object.get(w, "plant_materials", [])
	some row in lib.tables.mixed_windrow_plant_materials
	row.material == m
}

# O6_21-COMP-06: wendefreie Kompostierung – Beimengung organischen Materials in nennenswertem Ausmaß,
# Kompostierungsverfahren; strohreicher Mist allein genügt nicht.
windrow_method_ok(w) if {
	w.method == "turning_free_with_added_material"
	object.get(w, "added_material_significant", false)
	object.get(w, "composting_process", null) != null
	not object.get(w, "straw_rich_manure_only", false)
}

# O6_21-COMP-08: NAPV – Lagerung zur Kompostierung auf unbefestigten Flächen nur bei abgedeckter Miete
# und Einhaltung von § 6 Abs. 7 Z 2, 4, 5 und 6.
napv_ok(w) if not object.get(w, "on_unpaved_area", false)

napv_ok(w) if {
	w.on_unpaved_area
	w.covered
	w.distance_to_surface_water_m >= 25
	not w.risk_of_seepage_to_water
	not w.waterlogged_soil
	w.groundwater_depth_m > 1
}

# O6_21-COMP-07: Dokumentation von Anlage und Umsetzen der Kompostmiete.
windrow_documented(w) if {
	w.documented_set_up
	w.method != "turned"
}

windrow_documented(w) if {
	w.documented_set_up
	w.method == "turned"
	w.documented_turnings
}

windrow_violations[w.windrow_id] := v if {
	some w in windrows
	v := {code | some code in windrow_codes; windrow_failed(w, code)}
}

windrow_codes := {"method_not_met", "napv_storage_not_met", "documentation_missing"}

windrow_failed(w, "method_not_met") if not windrow_method_ok(w)

windrow_failed(w, "napv_storage_not_met") if not napv_ok(w)

windrow_failed(w, "documentation_missing") if not windrow_documented(w)

supplement_codes := {
	"not_all_solid_manure_composted",
	"compost_barn",
	"no_windrows",
	"windrow_noncompliant",
	"application_or_transfer_not_documented",
}

# O6_21-COMP-01: gesamter am Betrieb anfallender Festmist (unabhängig von der Tierart) zu Kompostmieten am Betrieb.
supplement_failed("not_all_solid_manure_composted") if not comp.all_solid_manure_composted_on_farm

# O6_21-COMP-09: Kompostställe erhalten keinen Zuschlag.
supplement_failed("compost_barn") if object.get(comp, "is_compost_barn", false)

supplement_failed("no_windrows") if count(windrows) == 0

supplement_failed("windrow_noncompliant") if {
	some _, v in windrow_violations
	count(v) > 0
}

# O6_21-COMP-07: Ausbringung des Komposts bzw. Abgabe an Dritte dokumentieren.
supplement_failed("application_or_transfer_not_documented") if {
	not comp.documented_application_or_transfer
}

supplement_violations := {code | some code in supplement_codes; supplement_failed(code)}

supplement_compliant if {
	application.supplement_valid
	count(supplement_violations) == 0
}
