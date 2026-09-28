# Beantragung, Vertragszeitraum, Ausstieg, Stallskizze (Kapitel 3.1, 6.3.2, 7, 8 Informationsblatt; 1.7, 1.10 SRL).
package oepul.o6_21

import rego.v1

applications := object.get(o6_21_input, "applications", [])

supplement_id := "festmistkompostierung"

# O6_21-APP-001: Beantragung im Maßnahmenantrag bis 31. Dezember vor Vertragsbeginn.
application_deadline_ns(first_year) := date_ns(sprintf("%d-%s", [first_year - 1, params.application_deadline_month_day]))

application_timely(app) if date_ns(app.submitted_date) <= application_deadline_ns(app.first_year)

# O6_21-APP-005: verspätete Wiederbeantragung nach Erlöschen - Korrektur plus schriftliches Ersuchen.
application_timely(app) if {
	app.late_reapplication_after_lapse == true
	app.written_request_to_ama == true
}

# O6_21-APP-002 / O6_21-GEN-007: letzter Einstieg Kategorien 2027, Zuschlag 2028.
last_entry_year(item) := params.last_entry_year_supplement if item == supplement_id

else := params.last_entry_year_categories

application_violations contains {"rule_id": "O6_21-APP-001", "item": app.item, "reason": "Maßnahmenantrag nicht bis 31. Dezember vor Vertragsbeginn gestellt"} if {
	some app in applications
	not application_timely(app)
}

application_violations contains {"rule_id": "O6_21-APP-002", "item": app.item, "reason": "Einstieg nach dem letzten möglichen Förderjahr"} if {
	some app in applications
	app.first_year > last_entry_year(app.item)
}

application_violations contains {"rule_id": "O6_21-CAT-001", "item": c, "reason": "keine zulässige Tierkategorie der Maßnahme"} if {
	some c in unknown_applied_categories
}

application_violations contains {"rule_id": "O6_21-ACC-003", "item": c, "reason": "Betrieb mit Milchanlieferung von der Kategorie weibliche Rinder ab ½ bis unter 2 Jahre ausgeschlossen"} if {
	some c in category_excluded
	categories_by_id[c].excluded_for_milk_delivering_farms == true
}

# Gültiger Vertrag für ein Element (Kategorie oder Zuschlag) im Förderjahr.
contract_valid(item) if {
	some app in applications
	app.item == item
	application_timely(app)
	app.first_year <= measure_year
	app.first_year <= last_entry_year(item)
	not exited_during_year(item)
	not measure_exited_during_year
}

# O6_21-APP-006: Zuschlag Festmistkompostierung erfordert Maßnahmenantrag.
application_violations contains {"rule_id": "O6_21-APP-006", "item": supplement_id, "reason": "Zuschlag ohne gültigen Maßnahmenantrag"} if {
	composting_supplement_applied
	not contract_valid(supplement_id)
}

application_violations contains {"rule_id": "O6_21-APP-001", "item": c, "reason": "Kategorie ohne gültigen Vertrag für das Förderjahr"} if {
	some c in applied_categories
	not c in unknown_applied_categories
	not contract_valid(c)
}

# ---------------------------------------------------------------------------
# Ausstieg (O6_21-EXIT-001 bis O6_21-EXIT-005)
# ---------------------------------------------------------------------------

exits := object.get(o6_21_input, "exits", [])

exit_in_year(e) if {
	d := date_ns(e.date)
	d >= year_start_ns
	d < year_end_excl_ns
}

# O6_21-EXIT-003: Abmeldung im Zeitraum 1.1.-31.12. - Maßnahme (bzw. Element) im Förderjahr nicht mehr gültig.
measure_exited_during_year if {
	some e in exits
	e.item == "measure"
	exit_in_year(e)
}

exited_during_year(item) if {
	some e in exits
	e.item == item
	exit_in_year(e)
}

# O6_21-EXIT-005: Ausstieg nur bis zur Ankündigung/Durchführung einer Vor-Ort-Kontrolle bzw. Mitteilung einer Verwaltungskontrolle.
application_violations contains {"rule_id": "O6_21-EXIT-005", "item": e.item, "reason": "Ausstieg nach Ankündigung/Durchführung einer Vor-Ort-Kontrolle oder Mitteilung des Verwaltungskontrollergebnisses"} if {
	some e in exits
	e.after_control_announcement_or_result == true
}

# ---------------------------------------------------------------------------
# Stallskizze und Belegungsplan (O6_21-SKETCH-001 / O6_21-SKETCH-004)
# ---------------------------------------------------------------------------

default stall_sketch_required := false

stall_sketch_required if {
	measure_year <= params.stall_sketch_required_until_year
	count(applied_categories) > 0
}

application_violations contains {"rule_id": "O6_21-SKETCH-001", "item": "stall_sketch", "reason": "Stallskizze bzw. Belegungsplan liegt am Betrieb nicht auf (bis Antragsjahr 2024 erforderlich)"} if {
	stall_sketch_required
	not sketch_complete
}

sketch_complete if {
	o6_21_input.stall_sketch_available == true
	o6_21_input.occupancy_plan_available == true
}

# ---------------------------------------------------------------------------
# Maßnahmenübernahme (O6_21-GEN-008)
# ---------------------------------------------------------------------------

takeover_admissible if {
	t := o6_21_input.takeover
	t.reason in data.o6_21.general_conditions.takeover_admissible_reasons
	t.animals_and_areas_from_same_predecessor == true
}

application_violations contains {"rule_id": "O6_21-GEN-008", "item": "takeover", "reason": "Maßnahmenübernahme nur bei Betriebsauflösung, -teilung oder -zusammenlegung mit Tieren und Flächen desselben Vorbetriebs"} if {
	is_object(o6_21_input.takeover)
	not takeover_admissible
}

# ---------------------------------------------------------------------------
# Meldepflichten (O6_21-NOTIF-001 / O6_21-NOTIF-005)
# ---------------------------------------------------------------------------

# O6_21-NOTIF-005: Abgänge über die Rinderdatenbank (Schlachtung, Verkauf ...) sind nicht gesondert zu melden.
no_ama_notification_needed(a) if a.exit_reason in data.o6_21.notifications.rdb_exit_reasons_without_ama_notification
