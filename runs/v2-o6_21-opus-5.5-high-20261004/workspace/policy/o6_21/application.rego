# Beantragung, Vertragszeitraum, Verlängerung, Ausstieg und Übernahme (o6_21).
package oepul.o6_21.application

import data.oepul.o6_21.lib

mi := lib.measure_input

year := lib.year

categories := object.get(mi, "categories", [])

exits := object.get(mi, "exits", [])

# O6_21-APP-01: Maßnahmenantrag bis spätestens 31.12. vor dem ersten Verpflichtungsjahr.
application_timely(entry) if {
	lib.parse_date(entry.applied_on) <= lib.year_end_ns(entry.first_year - 1)
}

# O6_21-APP-07: verspätete Wiederbeantragung nach Erlöschen nur mit Korrektur und gesondertem Ersuchen,
# wirksam nur bei Anerkennung durch die AMA.
application_timely(entry) if {
	object.get(entry, "late_reentry_correction_submitted", false)
	object.get(entry, "late_reentry_written_request_submitted", false)
	object.get(entry, "late_reentry_accepted", false)
}

# O6_21-APP-03: letzter Einstieg in Kategorien mit Förderjahr 2027.
within_last_entry_categories(entry) if {
	entry.first_year <= lib.deadlines.last_contract_start_year_categories
}

# O6_21-APP-04: letzter Einstieg in den optionalen Zuschlag mit Förderjahr 2028.
within_last_entry_supplement(entry) if {
	entry.first_year <= lib.deadlines.last_contract_start_year_supplement
}

not_lapsed(entry) if {
	object.get(entry, "lapsed_after_year", null) == null
}

not_lapsed(entry) if {
	lapsed := object.get(entry, "lapsed_after_year", null)
	lapsed != null
	year <= lapsed
}

# O6_21-EXIT-04: Ausstieg nur bis zur Ankündigung bzw. Durchführung einer Vor-Ort-Kontrolle
# oder Mitteilung des Ergebnisses einer Verwaltungskontrolle.
exit_effective(_) if {
	not mi.control_announced_on
}

exit_effective(e) if {
	lib.parse_date(e.declared_on) < lib.parse_date(mi.control_announced_on)
}

# O6_21-EXIT-02: Eine im Zeitraum 1.1.–31.12. durchgeführte Abmeldung macht die Maßnahme
# (bzw. Kategorie/Zuschlag) für dieses Förderjahr ungültig.
exited_scope_for(entry, _, _) if {
	some e in exits
	exit_effective(e)
	e.scope == "measure"
	lib.parse_date(e.declared_on) > lib.parse_date(entry.applied_on)
	lib.date_year(e.declared_on) <= year
}

exited_scope_for(entry, "category", cat_id) if {
	some e in exits
	exit_effective(e)
	e.scope == "category"
	e.category_id == cat_id
	lib.parse_date(e.declared_on) > lib.parse_date(entry.applied_on)
	lib.date_year(e.declared_on) <= year
}

exited_scope_for(entry, "supplement", _) if {
	some e in exits
	exit_effective(e)
	e.scope == "supplement"
	lib.parse_date(e.declared_on) > lib.parse_date(entry.applied_on)
	lib.date_year(e.declared_on) <= year
}

# Gültige Kategorie im Förderjahr (automatische Verlängerung, solange nicht abgemeldet oder erloschen).
category_valid(cat_id) if {
	some entry in categories
	entry.category_id == cat_id
	application_timely(entry)
	within_last_entry_categories(entry)
	entry.first_year <= year
	not_lapsed(entry)
	not exited_scope_for(entry, "category", cat_id)
}

valid_categories contains cat_id if {
	some c in lib.tables.animal_categories
	cat_id := c.category_id
	category_valid(cat_id)
}

applied_categories contains entry.category_id if {
	some entry in categories
}

late_or_invalid_category_applications contains entry.category_id if {
	some entry in categories
	not application_timely(entry)
}

category_applications_after_last_entry contains entry.category_id if {
	some entry in categories
	not within_last_entry_categories(entry)
}

supplement := object.get(mi, "composting_supplement", null)

supplement_valid if {
	supplement != null
	application_timely(supplement)
	within_last_entry_supplement(supplement)
	supplement.first_year <= year
	not_lapsed(supplement)
	not exited_scope_for(supplement, "supplement", null)
	count(valid_categories) > 0
}

# O6_21-APP-08: Ausstieg aus der Maßnahme erst nach Erfüllung des einjährigen Vertragszeitraumes;
# eine Abmeldung im laufenden Jahr bewirkt die Ungültigkeit für dieses Jahr.
exits_invalidating_current_year contains e if {
	some e in exits
	exit_effective(e)
	lib.date_year(e.declared_on) == year
}

exits_ineffective_after_control contains e if {
	some e in exits
	not exit_effective(e)
}

# O6_21-TAKE-01: Maßnahmenübernahme nur in Einzelfällen bei Betriebsauflösung, -teilung oder -zusammenlegung;
# Tiere und Flächen müssen vom selben Vorbetrieb stammen.
takeover := object.get(mi, "takeover", {"is_takeover": false})

takeover_allowed if {
	takeover.is_takeover
	some r in lib.tables.takeover_allowed_reasons
	r.reason == takeover.reason
	takeover.animals_and_areas_from_same_previous_holding
}

takeover_violation if {
	takeover.is_takeover
	not takeover_allowed
}

# O6_21-APP-01 / O6_21-CONTRACT-01: Vertragsjahr ist das Kalenderjahr.
commitment_period := {
	"from": sprintf("%d-01-01", [year]),
	"to": sprintf("%d-12-31", [year]),
}

# O6_21-APP-05: Ersetzte (ausgelaufene) Kategorien bleiben ohne Abmeldung nach dem 31.12. gültig
# und müssen weiterhin eingehalten werden.
replaced_categories_still_binding contains entry.category_id if {
	some entry in categories
	object.get(entry, "replaced_by_category_id", null) != null
	category_valid(entry.category_id)
}
