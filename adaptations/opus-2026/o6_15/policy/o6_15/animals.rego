# Tierbezogene Bestimmungen: Alpungs-/Behirtungsdauer, Meldefristen, Milchvieh, Anrechnung.
package oepul.o6_15

# ---------------------------------------------------------------------------
# Meldefristen und anerkannte Alpungstage (Kapitel 7 Informationsblatt)
# ---------------------------------------------------------------------------

report_lag_days(a) := reporting_rule(a.species).max_retroactive_alpine_days

# Tiere gelten bei verspäteter Auftriebsmeldung maximal 14 (Rinder) bzw. 7 Tage
# vor dem Meldedatum als gealpt.
effective_drive_up_ns(a) := date_ns(a.drive_up_date) if {
	object.get(a, "report_date_up", null) == null
}

effective_drive_up_ns(a) := max_of(date_ns(a.drive_up_date), date_ns(a.report_date_up) - (report_lag_days(a) * day_ns)) if {
	object.get(a, "report_date_up", null) != null
}

drive_up_reported_late(a) if {
	object.get(a, "report_date_up", null) != null
	days_between(a.drive_up_date, a.report_date_up) > reporting_rule(a.species).drive_up_report_days
}

# Auftriebstag zählt, Abtriebstag zählt nicht; Unterbrechungen zählen nicht.
recognized_days_this_alm(a) := d if {
	object.get(a, "drive_down_date", null) != null
	raw := round((date_ns(a.drive_down_date) - effective_drive_up_ns(a)) / day_ns)
	d := max_of(raw - object.get(a, "interruption_days", 0), 0)
}

# Gesamte Behirtungsdauer auf allen behirteten Almen (bei Weitertrieb)
total_herding_days(a) := a.total_alpine_days_all_herded_alms if {
	object.get(a, "total_alpine_days_all_herded_alms", null) != null
}

total_herding_days(a) := recognized_days_this_alm(a) if {
	object.get(a, "total_alpine_days_all_herded_alms", null) == null
}

meets_min_herding_duration(a) if {
	total_herding_days(a) >= params.min_herding_days_per_animal
}

# Maßgeblich ist der (Erst-)Auftrieb; bei Weitertrieb auf eine andere behirtete Alm
# wird first_drive_up_date herangezogen.
driven_up_by_deadline(a) if {
	date_ns(object.get(a, "first_drive_up_date", a.drive_up_date)) <= month_day_ns(year, params.deadlines.latest_drive_up_month_day)
}

# Abtriebsmeldung: Rinder binnen 14 Tagen, sonstige Tiere binnen 7 Tagen.
# Equiden/Neuweltkamele: keine Nachmeldung nötig, wenn das beim Auftrieb
# angegebene voraussichtliche Abtriebsdatum zutrifft.
drive_down_report_required(a) if {
	a.species in {"equid", "new_world_camelid"}
	object.get(a, "planned_drive_down_date", null) != a.drive_down_date
}

drive_down_report_required(a) if {
	not a.species in {"equid", "new_world_camelid"}
}

drive_down_reported_late(a) if {
	drive_down_report_required(a)
	object.get(a, "drive_down_date", null) != null
	object.get(a, "report_date_down", null) != null
	days_between(a.drive_down_date, a.report_date_down) > reporting_rule(a.species).drive_down_report_days
}

drive_down_report_missing(a) if {
	drive_down_report_required(a)
	object.get(a, "drive_down_date", null) != null
	object.get(a, "report_date_down", null) == null
}

# ---------------------------------------------------------------------------
# Milchvieh (Kapitel 5.2 Informationsblatt, Punkt 2.15 SRL)
# ---------------------------------------------------------------------------

dairy_requirement(species) := r if {
	some r in params.dairy_age_requirements
	r.species == species
}

dairy_age_ok(a) if {
	object.get(a, "birth_date", null) != null
	age_at_least_months(a.birth_date, dairy_requirement(a.species).min_age_months_on_july_1)
}

dairy_age_ok(a) if {
	object.get(a, "birth_date", null) == null
	rgve_row_by_id(animal_rgve_category(a)).min_age_months >= dairy_requirement(a.species).min_age_months_on_july_1
}

dairy_calving_ok(a) if not dairy_requirement(a.species).requires_calved_at_least_once

dairy_calving_ok(a) if {
	dairy_requirement(a.species).requires_calved_at_least_once
	object.get(a, "calved_by_july_1", false) == true
}

is_dairy_qualified(a) if {
	object.get(a, "milked", false) == true
	object.get(a, "milked_days", 0) >= params.min_milking_days
	dairy_age_ok(a)
	dairy_calving_ok(a)
}

# "gemolken"-Kennzeichen: Nachreichung binnen 14 (Rinder) bzw. 7 Tagen nach
# Almauftrieb, bei Schafen/Ziegen nicht nach dem 15. Juli.
milked_flag_timely(a) if object.get(a, "milked_flag_reported_date", null) == null

milked_flag_timely(a) if {
	object.get(a, "milked_flag_reported_date", null) != null
	rule := reporting_rule(a.species)
	rule.milked_flag_late_days_after_drive_up != null
	days_between(a.drive_up_date, a.milked_flag_reported_date) <= rule.milked_flag_late_days_after_drive_up
	not milked_flag_after_july_15(a, rule)
}

milked_flag_after_july_15(a, rule) if {
	rule.milked_flag_not_after_payment_deadline
	date_ns(a.milked_flag_reported_date) > month_day_ns(year, params.deadlines.latest_drive_up_month_day)
}

counts_as_dairy(a) if {
	is_dairy_qualified(a)
	milked_flag_timely(a)
}

# ---------------------------------------------------------------------------
# Teilnahmefähige Tiere und Kategorie-Zuordnung
# ---------------------------------------------------------------------------

category_species(category_id) := c.species if {
	some c in params.herding_categories
	c.id == category_id
}

category_matches_species(a) if a.species in category_species(a.behirtung_category)

animal_in_claimed_category(alm, a) if a.behirtung_category in object.get(alm, "herded_categories", [])

animal_is_herded(a) if object.get(a, "is_herded", true) == true

animal_kept_in_austria(a) if object.get(a, "kept_in_austria", true) == true

eligible_herded_animal(alm, a) if {
	a.species in params.eligible_species
	animal_rgve_factor(a) > 0
	animal_in_claimed_category(alm, a)
	category_matches_species(a)
	animal_is_herded(a)
	animal_kept_in_austria(a)
	driven_up_by_deadline(a)
	meets_min_herding_duration(a)
	recognized_days_this_alm(a) > 0
}

# Anteilige Anrechnung bei Weitertrieb auf andere behirtete Almen
alm_share(a) := min_of(recognized_days_this_alm(a) / total_herding_days(a), 1)

animal_rgve_on_alm(a) := (animal_count(a) * animal_rgve_factor(a)) * alm_share(a)

animal_is_dairy_rgve(alm, a) if {
	eligible_herded_animal(alm, a)
	counts_as_dairy(a)
	a.behirtung_category in {"dairy_cows", "sheep", "goats"}
}
