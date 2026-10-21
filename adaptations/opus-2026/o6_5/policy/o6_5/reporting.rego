# title: o6_5 – Melde- und Kennzeichnungspflichten
# description: >-
#   Meldungen an die AMA (Abgang, Nachbesetzung, Weitergabe zwecks Zuchteinsatz)
#   für Pferde, Schafe, Ziegen und Schweine sowie VIS-/UELN-Pflichten. Verstöße
#   werden als findings ausgegeben; sie können bei Kontrollen zu Beanstandungen
#   führen, entziehen dem Tier aber nicht unmittelbar die Förderbarkeit.
package oepul.o6_5

# O6_5-REP-DEPARTURE-7-DAYS: Abgang binnen 7 Tagen online an die AMA melden
# (Rinder: Meldung an die Rinderdatenbank ersetzt die Meldung, O6_5-REP-CATTLE-AUTO).
findings contains {"rule_id": "O6_5-REP-DEPARTURE-7-DAYS", "animal_id": a.animal_id, "severity": "reporting"} if {
	some a in animals
	category_meta[a.animal_category]
	not is_cattle(a)
	d := departure_date_ns(a)
	d >= holding_start_ns
	d <= movement_reports_until_ns
	not reported_within(val(a.departure, "reported_date"), d, params.report_deadline_days)
}

# O6_5-2026-REPLACEMENT-REPORT-WAIVER: Meldungen zu Tierbewegungen bis Jahresende weiterhin.
movement_reports_until_ns := date_of(year, year_override.movement_reports_required_until_md) if {
	year_override.movement_reports_required_until_md
} else := date_of(year, "12-31")

# O6_5-REP-REPLACEMENT-7-DAYS: Nachbesetzung binnen 7 Tagen ab Nachbesetzung melden.
findings contains {"rule_id": "O6_5-REP-REPLACEMENT-7-DAYS", "animal_id": r.animal_id, "severity": "reporting"} if {
	some r in replacement_animals
	category_meta[r.animal_category]
	not is_cattle(r)
	val(r, "replacement_date") != null
	rd := parse_date(r.replacement_date)
	not replacement_report_waived(rd)
	not reported_within(val(r, "replacement_reported_date"), rd, params.report_deadline_days)
}

# O6_5-2026-REPLACEMENT-REPORT-WAIVER: 2026 keine Nachbesetzungsmeldung nach dem 31.08.
replacement_report_waived(rd) if {
	md := year_override.replacement_report_not_required_after_md
	rd > date_of(year, md)
}

# O6_5-REP-PRIOR-TRANSFER-REPORT: vor Weitergabe (Zuchtstation, Zuchteinsatz) Meldung
# des Zuchteinsatzes an die AMA; entfällt bei belegtem Aufenthalt bis 10 Tage.
findings contains {"rule_id": "O6_5-REP-PRIOR-TRANSFER-REPORT", "animal_id": a.animal_id, "severity": "reporting"} if {
	some a in animals
	category_meta[a.animal_category]
	not is_cattle(a)
	some t in object.get(a, "temporary_absences", [])
	t.type in {"breeding_station", "male_breeding_use_other_farm"}
	not short_documented_absence(t)
	not t.reported_before_transfer == true
}

# O6_5-APP-HORSE-UELN: bei Pferden UELN im Feld "Kennzeichnung" angeben.
findings contains {"rule_id": "O6_5-APP-HORSE-UELN", "animal_id": a.animal_id, "severity": "application"} if {
	some a in animals
	category_meta[a.animal_category]
	species_of(a) == "horses"
	not is_replacement(a)
	not a.ueln_in_application == true
}

# O6_5-OBL-VIS-SHEEP-GOATS: Schaf- und Ziegenhaltende melden Zu- und Abgänge an das VIS.
findings contains {"rule_id": "O6_5-OBL-VIS-SHEEP-GOATS", "animal_id": null, "severity": "identification"} if {
	some a in animals
	category_meta[a.animal_category]
	species_of(a) in {"sheep", "goats"}
	not input.documentation.vis_reports_complete == true
}

# O6_5-OBL-EQUIDE-UELN: Equiden mit UELN identifizieren und an Equidendatenbank und VIS melden.
findings contains {"rule_id": "O6_5-OBL-EQUIDE-UELN", "animal_id": a.animal_id, "severity": "identification"} if {
	some a in animals
	category_meta[a.animal_category]
	species_of(a) == "horses"
	not equide_identified(a)
}

equide_identified(a) if {
	val(a, "identification") != null
	a.equine_database_and_vis_reported == true
}

# O6_5-GEN-EXIT-UNTIL-INSPECTION: Abmeldung nach Ankündigung einer Vor-Ort-Kontrolle unwirksam.
findings contains {"rule_id": "O6_5-GEN-EXIT-UNTIL-INSPECTION", "animal_id": null, "severity": "contract"} if {
	deregistration_after_inspection_notice
}

# O6_5-GEN-SANCTION-STAGES: unbekannte Kürzungsstufe im Input.
findings contains {"rule_id": "O6_5-GEN-SANCTION-STAGES", "animal_id": null, "severity": "input"} if {
	sanction_stage != "none"
	not sanction_stage_row
}
