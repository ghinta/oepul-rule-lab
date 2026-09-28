# Meldepflichten (Informationsblatt Kap. 6; SRL 2.20.5).
package oepul.o6_20.reporting

import data.oepul.o6_20.common

params := common.params

period_start := common.grazing_period_start(common.year)

reports_until := common.md_date(common.year, params.sheep_goat_movement_reports_until_month_day)

# --- Rinder -------------------------------------------------------------------

# Nach Erreichen der Mindestweidetage aller Kategorien müssen hineinwachsende Tiere nicht mehr ausgetrieben werden.
obligation_satisfied_before_entry(a) if {
	c := common.category_entry(a.category_code)
	common.is_date(object.get(c, "min_days_reached_date", null))
	common.is_date(object.get(a, "category_entry_date", null))
	a.category_entry_date > c.min_days_reached_date
}

cattle_report_required(a) if {
	common.regime(a.category_code) == "cattle"
	common.is_date(object.get(a, "non_compliance_known_date", null))
	not obligation_satisfied_before_entry(a)
}

violations contains v if {
	some a in common.animals
	cattle_report_required(a)
	not common.is_date(object.get(a, "non_compliance_report_date", null))
	v := {
		"rule_id": "o6_20.reporting.cattle_deregistration",
		"severity": "sanction_risk",
		"category_code": a.category_code,
		"animal_id": a.animal_id,
		"message": "Rind erreicht die Mindestweidedauer nicht: ohrmarkenbezogene Abmeldung auf eama.at fehlt",
	}
}

review_items contains r if {
	some a in common.animals
	cattle_report_required(a)
	common.is_date(object.get(a, "non_compliance_report_date", null))
	a.non_compliance_report_date > a.non_compliance_known_date
	r := {
		"rule_id": "o6_20.reporting.cattle_deregistration",
		"animal_id": a.animal_id,
		"message": sprintf("Abmeldung am %v, Umstand bekannt seit %v – Meldung hat unmittelbar zu erfolgen", [a.non_compliance_report_date, a.non_compliance_known_date]),
	}
}

# --- Schafe und Ziegen: Zu- und Abgänge ------------------------------------

sheep_goat(a) if common.regime(a.category_code) == "sheep_goat"

movement_reportable(d) if {
	d > period_start
	d <= reports_until
}

violations contains v if {
	some a in common.animals
	sheep_goat(a)
	some kind in [["present_from", "arrival_report_date", "Zugang"], ["departure_date", "departure_report_date", "Abgang"]]
	event := object.get(a, kind[0], null)
	common.is_date(event)
	movement_reportable(event)
	not reported_in_time(a, event, kind[1])
	v := {
		"rule_id": "o6_20.reporting.sheep_goat_movements",
		"severity": "sanction_risk",
		"category_code": a.category_code,
		"animal_id": a.animal_id,
		"message": sprintf("%s vom %v nicht innerhalb von %d Tagen gemeldet", [kind[2], event, params.sheep_goat_movement_report_days]),
	}
}

reported_in_time(a, event, report_field) if {
	report := object.get(a, report_field, null)
	common.is_date(report)
	common.days_between(event, report) <= params.sheep_goat_movement_report_days
}

# Almauftrieb/Gemeinschaftsweide/Zinsweide ist kein Abgang; Abgangsmeldung oder Löschung führt zum Verlust.
violations contains v if {
	some a in common.animals
	sheep_goat(a)
	object.get(a, "departure_reported_while_on_alm", false) == true
	v := {
		"rule_id": "o6_20.reporting.sheep_goat_alm_not_departure",
		"severity": "no_premium",
		"category_code": a.category_code,
		"animal_id": a.animal_id,
		"message": "Vorübergehender Alm-/Gemeinschaftsweide-/Zinsweideaufenthalt als Abgang gemeldet oder gelöscht – Tier wird nicht angerechnet",
	}
}

# Nicht teilnehmende Schafe/Ziegen, die am Betrieb verbleiben, sind aus der Beilage zu löschen.
violations contains v if {
	some a in common.animals
	sheep_goat(a)
	object.get(a, "participating", true) == false
	object.get(a, "deleted_from_list", false) == false
	not common.is_date(object.get(a, "departure_date", null))
	v := {
		"rule_id": "o6_20.reporting.sheep_goat_non_participation",
		"severity": "correction_required",
		"category_code": a.category_code,
		"animal_id": a.animal_id,
		"message": "Nicht teilnehmendes Tier verbleibt am Betrieb und ist aus der Beilage „Tierwohl – Weide/Stallhaltung“ zu löschen",
	}
}

# Weideverpflichtung ausschließlich über Alpung: Beantragung auch am Heimbetrieb erforderlich.
violations contains v if {
	some c in common.categories
	common.regime(c.category_code) == "sheep_goat"
	object.get(c, "alm_only_fulfilment", false) == true
	object.get(c, "applied_at_home_farm", true) == false
	v := {
		"rule_id": "o6_20.reporting.sheep_goat_alm_only",
		"severity": "no_premium",
		"category_code": c.category_code,
		"message": "Weideverpflichtung ausschließlich über Alpung: Tiere müssen zusätzlich am Heimbetrieb beantragt werden",
	}
}

# --- Equiden und Neuweltkamele --------------------------------------------

violations contains v if {
	some c in common.categories
	common.regime(c.category_code) == "equid_camelid"
	some e in object.get(c, "count_entries", [])
	object.get(e, "compliant_count", e.applied_count) < e.applied_count
	object.get(e, "count_corrected", false) == false
	v := {
		"rule_id": "o6_20.reporting.equid_camelid_count_correction",
		"severity": "correction_required",
		"category_code": c.category_code,
		"message": sprintf("Beantragte Anzahl %d, tatsächlich %d Tiere mit Mindestweidetagen (%v) – Korrektur erforderlich", [e.applied_count, object.get(e, "compliant_count", e.applied_count), e.rgve_class]),
	}
}

# --- VIS, Tierliste, UELN -----------------------------------------------------

violations contains v if {
	count(common.categories) > 0
	some item in [
		["vis_reporting_complete", "o6_20.reporting.vis", "Meldungen an das VIS (TKZVO 2009) unvollständig"],
		["equids_ueln_identified", "o6_20.reporting.vis", "Equiden ohne UELN-Identifizierung bzw. Meldung an Equidendatenbank/VIS"],
		["animal_list_complete", "o6_20.application.animal_list", "Tierliste des Mehrfachantrages (Stichtag 1. April bzw. Jahresdurchschnitt) unvollständig"],
	]
	object.get(common.tw, item[0], true) == false
	v := {
		"rule_id": item[1],
		"severity": "sanction_risk",
		"message": item[2],
	}
}
