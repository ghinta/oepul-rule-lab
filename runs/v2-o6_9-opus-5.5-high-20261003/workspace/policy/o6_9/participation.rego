# Teilnahme, Vertragszeitraum, Fristen, Ausstieg und Übernahme (o6_9)
package oepul.o6_9

# O69-MB-001: Maßnahmenkategorien; stark N-reduzierte Fütterung erst ab Antragsjahr 2025.
measure_categories contains "slurry_application"

measure_categories contains "slurry_separation"

measure_categories contains "n_reduced_pig_feeding" if year >= 2025

# O69-MB-002 / O69-GEN-010: einjähriger Vertrags- und Verpflichtungszeitraum mit automatischer Verlängerung.
contract_period := {
	"start": year_date(year, "01-01"),
	"end": year_date(year, "12-31"),
	"duration": "calendar_year",
	"auto_renewal": auto_renewal,
}

default auto_renewal := true

auto_renewal := false if deregistered_for_year

is_one_year_measure if {
	some m in tables.general_conditions.one_year_measures
	m.code == measure_codes.srl_measure
}

# Eligible application volumes as claimed in the MFA ("MFA-Angaben"), per technique.
claimed_application_volumes[t] := v if {
	some row in tables.application_techniques.eligible
	t := row.technique
	v := object.get(application, ["volumes_m3", t], 0)
}

application_volume_total := sum([v | some t, v in claimed_application_volumes])

# O69-MB-036 / O69-GSP-003: prämienfähige Mengenbeantragung bis 30. November des Förderjahres.
quantity_claim_deadline := year_date(year, tables.deadlines.quantity_claim.month_day)

quantity_claim_timely(obj) if not has_value(obj, "quantity_claim_date")

quantity_claim_timely(obj) if date_on_or_before(obj.quantity_claim_date, quantity_claim_deadline)

claims_application_volume if {
	application_volume_total > 0
	quantity_claim_timely(application)
}

claims_separation_volume if {
	object.get(separation, "separated_volume_m3", 0) > 0
	quantity_claim_timely(separation)
}

participates_pig_feeding if {
	is_true(pig_feeding, "participates")
	year >= 2025
}

# O69-MB-004 / O69-MB-012: Mindestteilnahme – mindestens eine Maßnahmenkategorie je Teilnahmejahr.
minimum_participation_met if claims_application_volume

minimum_participation_met if claims_separation_volume

minimum_participation_met if participates_pig_feeding

# O69-MB-003: Vertrag erlischt, wenn keine Menge beantragt und nicht an der Schweinefütterung teilgenommen wird.
contract_lapsed if not minimum_participation_met

new_measure_application_required_for_next_year if contract_lapsed

# O69-MB-030 / O69-GEN-012 / O69-GSP-002: Maßnahmenantrag bis 31.12. vor Vertragsbeginn.
contract_start_year := object.get(measure, "contract_start_year", year)

measure_application_deadline(start_year) := year_date(start_year - 1, tables.deadlines.measure_application.month_day)

measure_application_timely if {
	has_value(measure, "measure_application_date")
	date_on_or_before(measure.measure_application_date, measure_application_deadline(contract_start_year))
}

# O69-MB-031 / O69-GEN-011 / O69-SRL-010: letzter Einstieg in die Maßnahme mit Förderjahr 2027.
last_entry_measure := [e | some e in tables.deadlines.last_entry; e.scope == "measure"][0]

last_entry_pig_feeding := [e | some e in tables.deadlines.last_entry; e.scope == "n_reduced_pig_feeding"][0]

measure_entry_year_allowed if {
	contract_start_year >= 2023
	contract_start_year <= last_entry_measure.last_contract_year
}

# O69-MB-032: letzter Einstieg in die Schweinefütterung mit Förderjahr 2028, nur bei gültiger Teilnahme an der Maßnahme.
pig_feeding_start_year := object.get(pig_feeding, "start_year", year)

pig_feeding_application_timely if {
	has_value(pig_feeding, "application_date")
	date_on_or_before(pig_feeding.application_date, measure_application_deadline(pig_feeding_start_year))
}

pig_feeding_entry_allowed if {
	pig_feeding_start_year >= last_entry_pig_feeding.first_contract_year
	pig_feeding_start_year <= last_entry_pig_feeding.last_contract_year
	measure_application_timely
	measure_entry_year_allowed
}

# O69-MB-040 / O69-GEN-013: Abmeldung im laufenden Jahr macht die Maßnahme im betroffenen Förderjahr ungültig.
deregistered_for_year if {
	has_value(measure, "deregistration_date")
	date_year(measure.deregistration_date) == year
}

# O69-MB-038: Ausstieg nach Erfüllung des einjährigen Vertragszeitraumes möglich (frühestens ab 1. Jänner des Folgejahres).
earliest_deregistration_date_without_loss := year_date(year + 1, "01-01")

# O69-GEN-014: Ausstieg bis zur Durchführung/Ankündigung einer VOK oder Mitteilung des Ergebnisses einer Verwaltungskontrolle.
exit_blocked_by_control if {
	has_value(measure, "deregistration_date")
	has_value(measure, "control_announced_date")
	date_ns(measure.control_announced_date) <= date_ns(measure.deregistration_date)
}

# O69-GEN-015: Wiedereinstieg nach Ausstieg, Ausschluss oder Nichtabgabe nur mit neuem Maßnahmenantrag.
reentry_requires_new_measure_application if contract_lapsed

reentry_requires_new_measure_application if deregistered_for_year

reentry_requires_new_measure_application if is_true(measure, "excluded_from_measure")

reentry_requires_new_measure_application if is_true(measure, "multiple_application_not_submitted_previous_year")

# O69-GEN-018 / O69-GEN-019: Maßnahmenübernahme nur in Einzelfällen (Betriebsauflösung, -teilung, -zusammenlegung).
takeover := object.get(measure, "takeover", {})

takeover_deadline(y) := year_date(y, tables.deadlines.measure_takeover.exception_years[sprintf("%d", [y])])

takeover_deadline(y) := year_date(y, tables.deadlines.measure_takeover.month_day) if {
	not tables.deadlines.measure_takeover.exception_years[sprintf("%d", [y])]
}

takeover_allowed if {
	is_true(takeover, "is_takeover")
	takeover.reason in tables.general_conditions.single_case_takeover_reasons
	is_true(takeover, "animals_and_areas_same_previous_farm")
	date_on_or_before(takeover.date, takeover_deadline(year))
}

# Verstöße der Teilnahme- und Fristenregeln
violations contains {"rule_id": "O69-MB-030", "message": "Maßnahmenantrag fehlt oder wurde nicht bis 31. Dezember vor Vertragsbeginn gestellt"} if {
	measure_requested
	not measure_application_timely
}

violations contains {"rule_id": "O69-MB-031", "message": "Einstieg in die Maßnahme nach dem Förderjahr 2027 nicht mehr möglich"} if {
	measure_requested
	not measure_entry_year_allowed
}

violations contains {"rule_id": "O69-MB-032", "message": "Einstieg in die stark stickstoffreduzierte Fütterung von Schweinen nicht zulässig oder nicht fristgerecht beantragt"} if {
	is_true(pig_feeding, "participates")
	not pig_feeding_entry_allowed
}

violations contains {"rule_id": "O69-MB-032", "message": "Maßnahmenkategorie Schweinefütterung nicht fristgerecht bis 31. Dezember vor Teilnahmebeginn beantragt"} if {
	is_true(pig_feeding, "participates")
	not pig_feeding_application_timely
}

violations contains {"rule_id": "O69-MB-003", "message": "Keine Menge beantragt und keine Teilnahme an der Schweinefütterung – Vertrag erlischt"} if {
	measure_requested
	contract_lapsed
}

violations contains {"rule_id": "O69-MB-036", "message": "Bodennah ausgebrachte Mengen nach dem 30. November beantragt – nicht prämienfähig"} if {
	application_volume_total > 0
	not quantity_claim_timely(application)
}

violations contains {"rule_id": "O69-MB-036", "message": "Separierte Güllemenge nach dem 30. November beantragt – nicht prämienfähig"} if {
	object.get(separation, "separated_volume_m3", 0) > 0
	not quantity_claim_timely(separation)
}

violations contains {"rule_id": "O69-MB-040", "message": "Abmeldung im laufenden Förderjahr – Maßnahme im betroffenen Förderjahr nicht gültig"} if {
	deregistered_for_year
}

violations contains {"rule_id": "O69-GEN-014", "message": "Ausstieg nach Ankündigung/Durchführung einer Kontrolle ist nicht mehr möglich"} if {
	exit_blocked_by_control
}

violations contains {"rule_id": "O69-GEN-018", "message": "Maßnahmenübernahme nur in Einzelfällen bei Betriebsauflösung, -teilung oder -zusammenlegung fristgerecht und mit Tieren und Flächen desselben Vorbetriebs möglich"} if {
	is_true(takeover, "is_takeover")
	not takeover_allowed
}

# O69-GSP-004: Fristende am Wochenende/Feiertag verschiebt sich nicht für Maßnahmenantrag (31.12.) und Mengenbeantragung (30.11.).
default deadline_weekend_extension_applies := false

deadline_weekend_extension_applies if tables.deadlines.measure_application.weekend_extension == true

deadline_weekend_extension_applies if tables.deadlines.quantity_claim.weekend_extension == true

# O69-GSP-005: Änderungen nach Ablauf der Fristen nur ohne Prämienerhöhung, vor Hinweis auf Verstoß bzw. VOK-Ankündigung.
post_deadline_correction_allowed(change) if {
	not is_true(change, "increases_premium")
	not is_true(change, "after_control_notice_or_finding")
	is_true(change, "still_verifiable")
}

# O69-SRL-012: Revisionsklausel – Ablehnung einer Vertragsanpassung beendet den Vertrag ohne Rückforderung für die Vergangenheit.
revision_clause_contract_ended if is_true(measure, "revision_adaptation_refused")

revision_clause_repayment_for_past := false if revision_clause_contract_ended

# O69-MB-037: Abgabe des Mehrfachantrages bis 15. April (2023 und 2028: 17. April).
multiple_application_deadline(y) := year_date(y, tables.deadlines.multiple_application.exception_years[sprintf("%d", [y])])

multiple_application_deadline(y) := year_date(y, tables.deadlines.multiple_application.month_day) if {
	not tables.deadlines.multiple_application.exception_years[sprintf("%d", [y])]
}

# O69-GEN-009: förderfähig nur, wenn die Verpflichtungen während der gesamten Verpflichtungsdauer erfüllt werden.
default commitment_fulfilled_whole_year := true

commitment_fulfilled_whole_year := false if is_false(measure, "obligations_fulfilled_whole_year")

# O69-GEN-033: Betriebsübertragung nach Einreichung des MFA – Beihilfe an den Übergeber, sofern Bedingungen im übertragenen Betrieb erfüllt.
farm_transfer_payment_recipient := "transferor" if {
	is_true(measure, "farm_transferred_after_mfa")
	is_true(measure, "all_conditions_met_in_transferred_farm")
}
