# Vertragszeitraum, Beantragung, Ausstieg und Übernahme (Informationsblatt Kap. 3.1, 7, 8;
# Allgemeine Teilnahmebedingungen 5.8, 5.9, 6, 6.3; SRL 1.7.1.1, 1.7.3.1, 1.10.5).
package oepul.o6_20.application

import data.oepul.o6_20.common

params := common.params

gc := data.o6_20.general_conditions

tw := common.tw

year := common.year

# --- Einstieg / Vertragsbeginn ---------------------------------------------

new_entry if object.get(tw, "participation_start_year", year) == year

entry_year_allowed if year <= params.last_entry_funding_year

violations contains v if {
	new_entry
	not entry_year_allowed
	v := {
		"rule_id": "o6_20.application.last_entry",
		"severity": "contract_invalid",
		"message": sprintf("Einstieg für Förderjahr %d nicht mehr möglich (letzter Einstieg Förderjahr %d)", [year, params.last_entry_funding_year]),
	}
}

# Auch der Einstieg in einzelne Kategorien ist letztmals mit dem Förderjahr 2027 möglich.
violations contains v if {
	some c in common.categories
	object.get(c, "first_year", object.get(tw, "participation_start_year", year)) > params.last_entry_funding_year
	v := {
		"rule_id": "o6_20.application.last_entry",
		"severity": "category_invalid",
		"category_code": c.category_code,
		"message": sprintf("Einstieg in die Kategorie nach Förderjahr %d nicht möglich", [params.last_entry_funding_year]),
	}
}

application_in_time(d, funding_year) if {
	common.is_date(d)
	d <= common.measure_application_deadline(funding_year)
}

violations contains v if {
	new_entry
	not application_in_time(object.get(tw, "measure_application_date", null), year)
	v := {
		"rule_id": "o6_20.application.measure_application_deadline",
		"severity": "contract_invalid",
		"message": sprintf("Maßnahmenantrag nicht bis %v gestellt", [common.measure_application_deadline(year)]),
	}
}

# Neu hinzukommende Kategorien benötigen ebenfalls einen Maßnahmenantrag bis 31.12. des Vorjahres.
violations contains v if {
	some c in common.categories
	object.get(c, "first_year", object.get(tw, "participation_start_year", year)) == year
	not new_entry
	not application_in_time(object.get(c, "application_date", null), year)
	not late_reapplication_accepted(c)
	v := {
		"rule_id": "o6_20.application.measure_application_deadline",
		"severity": "category_invalid",
		"category_code": c.category_code,
		"message": sprintf("Kategorie nicht bis %v im Maßnahmenantrag beantragt", [common.measure_application_deadline(year)]),
	}
}

# Nach Erlöschen einer Kategorie: Neubeantragung, verspätet nur mit Korrektur und schriftlichem Ersuchen.
late_reapplication_accepted(c) if {
	object.get(c, "reapplied_by_correction", false) == true
	object.get(c, "written_request_submitted", false) == true
}

violations contains v if {
	some c in common.categories
	object.get(c, "contract_lapsed_previous_year", false) == true
	not application_in_time(object.get(c, "application_date", null), year)
	not late_reapplication_accepted(c)
	v := {
		"rule_id": "o6_20.application.category_reentry",
		"severity": "category_invalid",
		"category_code": c.category_code,
		"message": "Vertrag der Kategorie im Vorjahr erloschen – neuer Maßnahmenantrag bzw. Korrektur samt schriftlichem Ersuchen erforderlich",
	}
}

# --- Optionaler Zuschlag 150 Weidetage -----------------------------------------

violations contains v if {
	some c in common.categories
	object.get(c, "supplement_150_applied", false) == true
	not supplement_application_in_time(c)
	v := {
		"rule_id": "o6_20.application.supplement_150_deadline",
		"severity": "no_supplement",
		"category_code": c.category_code,
		"message": sprintf("Zuschlag 150 Weidetage nicht bis %v in der Beilage beantragt", [common.beilage_deadline(year)]),
	}
}

supplement_application_in_time(c) if {
	d := object.get(c, "supplement_150_application_date", null)
	common.is_date(d)
	d <= common.beilage_deadline(year)
}

violations contains v if {
	some c in common.categories
	object.get(c, "supplement_150_applied", false) == true
	year > params.last_supplement_funding_year
	v := {
		"rule_id": "o6_20.application.supplement_150_deadline",
		"severity": "no_supplement",
		"category_code": c.category_code,
		"message": "Zuschlag nur bis einschließlich Förderjahr 2028 beantragbar",
	}
}

# --- Schafe und Ziegen: Einzeltierbeantragung zum Stichtag 1. April ---------------

sheep_goat(a) if common.regime(a.category_code) == "sheep_goat"

violations contains v if {
	some a in common.animals
	common.sheep_goat_late_individual_application(a)
	v := {
		"rule_id": "o6_20.application.sheep_goat_individual",
		"severity": "no_premium",
		"category_code": a.category_code,
		"animal_id": a.animal_id,
		"message": sprintf("Einzeltierbeantragung nach Frist %v", [common.beilage_deadline(year)]),
	}
}

violations contains v if {
	some a in common.animals
	sheep_goat(a)
	some field in ["ear_tag", "sex", "birth_date"]
	not object.get(a, field, null)
	v := {
		"rule_id": "o6_20.application.sheep_goat_individual",
		"severity": "input_error",
		"category_code": a.category_code,
		"animal_id": a.animal_id,
		"message": sprintf("Einzeltierbeantragung ohne Angabe %s", [field]),
	}
}

# --- Equiden und Neuweltkamele: Stückzahl bis 15. April, danach keine Ausweitung --

violations contains v if {
	some c in common.categories
	common.regime(c.category_code) == "equid_camelid"
	some e in object.get(c, "count_entries", [])
	object.get(e, "count_increased_after_deadline", false) == true
	v := {
		"rule_id": "o6_20.application.equid_camelid_count",
		"severity": "no_premium",
		"category_code": c.category_code,
		"message": sprintf("Ausweitung der Stückzahl nach %v nicht zulässig", [common.beilage_deadline(year)]),
	}
}

# --- Ausstieg / Abmeldung ------------------------------------------------------

deregistered_in_year if {
	d := object.get(tw, "deregistration_date", null)
	common.is_date(d)
	d >= common.md_date(year, "01-01")
	d <= common.md_date(year, "12-31")
}

violations contains v if {
	deregistered_in_year
	v := {
		"rule_id": "o6_20.exit.deregistration",
		"severity": "contract_invalid",
		"message": "Abmeldung innerhalb des Förderjahres – Maßnahme im betroffenen Förderjahr nicht mehr gültig",
	}
}

category_deregistered_in_year(c) if {
	d := object.get(c, "deregistration_date", null)
	common.is_date(d)
	d >= common.md_date(year, "01-01")
	d <= common.md_date(year, "12-31")
}

violations contains v if {
	some c in common.categories
	category_deregistered_in_year(c)
	v := {
		"rule_id": "o6_20.exit.deregistration",
		"severity": "category_invalid",
		"category_code": c.category_code,
		"message": "Kategorie innerhalb des Förderjahres abgemeldet – für das Förderjahr nicht mehr gültig",
	}
}

review_items contains r if {
	some event in gc.exit_blocking_events
	object.get(tw, ["exit_context", event], false) == true
	object.get(tw, "deregistration_date", null) != null
	r := {
		"rule_id": "o6_20.exit.timing_controls",
		"message": sprintf("Ausstieg nur bis zur Durchführung/Ankündigung einer Vor-Ort-Kontrolle bzw. Mitteilung einer Verwaltungskontrolle möglich (%s)", [event]),
	}
}

# Ersetzte (ausgelaufene) Kategorie muss nach dem 31.12. abgemeldet werden, sonst gelten die Auflagen weiter.
violations contains v if {
	some c in common.categories
	object.get(c, "replaced_by_other_category", false) == true
	not common.is_date(object.get(c, "deregistration_date", null))
	v := {
		"rule_id": "o6_20.application.category_replacement",
		"severity": "obligation_continues",
		"category_code": c.category_code,
		"message": "Ersetzte Kategorie nicht abgemeldet – Maßnahme ist für alle gültigen Kategorien einzuhalten",
	}
}

# --- Maßnahmenübernahme ------------------------------------------------------

takeover := object.get(tw, "takeover", {})

violations contains v if {
	object.get(takeover, "is_takeover", false) == true
	not object.get(takeover, "reason", null) in gc.takeover_permitted_reasons
	v := {
		"rule_id": "o6_20.gen.takeover",
		"severity": "contract_invalid",
		"message": "Übernahme von „Tierwohl – Weide“ nur im Einzelfall bei Betriebsauflösung, -teilung oder -zusammenlegung",
	}
}

violations contains v if {
	object.get(takeover, "is_takeover", false) == true
	object.get(takeover, "animals_and_areas_from_same_previous_farm", true) == false
	v := {
		"rule_id": "o6_20.gen.takeover",
		"severity": "contract_invalid",
		"message": "Bei Übernahme tierbezogener Maßnahmen müssen Tiere und Flächen vom selben Vorbetrieb stammen",
	}
}

# --- Einjährige Maßnahme, automatische Verlängerung ------------------------------

one_year_measure if "Tierwohl – Weide" in gc.one_year_measures

auto_renewal := false if deregistered_in_year

else := true

contract_period := {
	"start": common.md_date(year, "01-01"),
	"end": common.md_date(year, "12-31"),
	"one_year_measure": one_year_measure,
	"auto_renewal": auto_renewal,
}
