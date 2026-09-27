# Vertrag, Beantragung, Kombinationsverpflichtung, Mindestteilnahme, Ausstieg,
# Maßnahmenübernahme sowie allgemeine Teilnahmebedingungen.
package oepul.o6_15

participation := object.get(input, "oepul_participation", {})

measure_record(measure_id) := m if {
	some m in object.get(participation, "measures", [])
	m.measure_id == measure_id
}

default o6_15_record := {}

o6_15_record := measure_record("o6_15")

# ---------------------------------------------------------------------------
# Kombinationsverpflichtung: zeitgleiche Teilnahme an Almbewirtschaftung
# ---------------------------------------------------------------------------

default combination_obligation_met := false

combination_obligation_met if {
	every required in params.required_combination_measures {
		object.get(measure_record(required), "participating_in_year", false) == true
	}
}

# ---------------------------------------------------------------------------
# Mindestteilnahme 3,00 behirtete RGVE je Förderjahr
# ---------------------------------------------------------------------------

default min_participation_met := false

min_participation_met if farm_herded_rgve >= params.min_herded_rgve_per_year

# ---------------------------------------------------------------------------
# Beantragung (Maßnahmenantrag bis 31.12. vor Vertragsbeginn, letzter Einstieg 2027)
# ---------------------------------------------------------------------------

measure_application_deadline_for(contract_year) := month_day_ns(contract_year - 1, params.deadlines.measure_application_month_day_previous_year)

default entry_year_allowed := false

entry_year_allowed if o6_15_record.contract_start_year <= params.deadlines.last_entry_contract_year

default measure_application_timely := false

measure_application_timely if {
	date_ns(o6_15_record.application_date) <= measure_application_deadline_for(o6_15_record.contract_start_year)
}

is_new_entry if o6_15_record.contract_start_year == year

# Nach Erlöschen des Vertrags ist ein neuer fristgerechter Maßnahmenantrag nötig;
# bei abgelaufener Frist: Korrektur zum vorhergehenden Maßnahmenantrag plus
# gesondertes schriftliches Ersuchen an die AMA.
default reentry_after_expiry_ok := false

reentry_after_expiry_ok if {
	object.get(o6_15_record, "previous_contract_expired", false) == true
	object.get(o6_15_record, "reapplied_after_expiry", false) == true
	measure_application_timely
}

reentry_after_expiry_ok if {
	object.get(o6_15_record, "previous_contract_expired", false) == true
	object.get(o6_15_record, "late_correction_of_previous_measure_application", false) == true
	object.get(o6_15_record, "written_request_to_ama_submitted", false) == true
}

reentry_requires_ama_recognition if {
	object.get(o6_15_record, "previous_contract_expired", false) == true
	object.get(o6_15_record, "late_correction_of_previous_measure_application", false) == true
	object.get(o6_15_record, "written_request_to_ama_submitted", false) == true
}

default contract_concluded := false

# Erstbeantragung
contract_concluded if {
	is_new_entry
	object.get(o6_15_record, "previous_contract_expired", false) == false
	measure_application_timely
	entry_year_allowed
}

# Automatische Verlängerung um ein weiteres Förderjahr, sofern nicht abgemeldet
contract_concluded if {
	o6_15_record.contract_start_year < year
	object.get(o6_15_record, "previous_contract_expired", false) == false
	object.get(o6_15_record, "deregistered_before_year", false) == false
}

# Wiedereinstieg nach Erlöschen
contract_concluded if {
	reentry_after_expiry_ok
	year <= params.deadlines.last_entry_contract_year
}

# Abmeldung im laufenden Jahr: Maßnahme im betroffenen Förderjahr nicht mehr gültig
deregistered_in_year if object.get(o6_15_record, "deregistered_in_year", false) == true

# Vertrag erlischt, wenn Mindestteilnahme oder Kombinationsverpflichtung nicht eingehalten
contract_expires if not min_participation_met

contract_expires if not combination_obligation_met

contract_status := "not_concluded" if not contract_concluded

contract_status := "deregistered" if {
	contract_concluded
	deregistered_in_year
}

contract_status := "expired" if {
	contract_concluded
	not deregistered_in_year
	contract_expires
}

contract_status := "valid" if {
	contract_concluded
	not deregistered_in_year
	not contract_expires
}

# ---------------------------------------------------------------------------
# Zahlungsantrag: Alm/Gemeinschaftsweide-Auftriebsliste bis 15. Juli
# (2023 und 2028: 17. Juli)
# ---------------------------------------------------------------------------

payment_application_deadline := month_day_ns(year, md) if {
	md := object.get(params.deadlines.payment_application_exception_years, sprintf("%d", [year]), params.deadlines.payment_application_month_day)
}

default payment_application_timely := false

payment_application_timely if {
	date_ns(herding_application.payment_application_submission_date) <= payment_application_deadline
}

# ---------------------------------------------------------------------------
# Optionaler Zuschlag Herdenschutzhunde: letzter Einstieg 2028
# ---------------------------------------------------------------------------

default dog_supplement_entry_ok := false

dog_supplement_entry_ok if {
	start := object.get(herding_application, "dog_supplement_start_year", year)
	start <= params.deadlines.dog_supplement_last_entry_year
	not dog_supplement_application_late(start)
}

dog_supplement_application_late(start) if {
	object.get(herding_application, "dog_supplement_application_date", null) != null
	date_ns(herding_application.dog_supplement_application_date) > measure_application_deadline_for(start)
}

# ---------------------------------------------------------------------------
# Ausstieg bzw. Abmeldung (Kapitel 8)
# ---------------------------------------------------------------------------

# Ausstieg nach Erfüllung des einjährigen Vertragszeitraums möglich; die Abmeldung
# wirkt erst ab 1. Jänner des Folgejahres, wenn die Auflagen bis 31.12. erfüllt werden.
exit_effective_year(deregistration_date) := y + 1 if {
	y := time.date(date_ns(deregistration_date))[0]
	y == year
	not deregistered_in_year
}

exit_effective_year(deregistration_date) := y if {
	y := time.date(date_ns(deregistration_date))[0]
	deregistered_in_year
}

# ---------------------------------------------------------------------------
# Maßnahmenübernahme nur bei Betriebsauflösung, -teilung oder -zusammenlegung
# ---------------------------------------------------------------------------

takeover := object.get(o6_15_record, "takeover", {})

default takeover_allowed := false

takeover_allowed if {
	takeover.reason in params.takeover_only_on_restructuring.allowed_reasons
	object.get(takeover, "animals_and_areas_from_same_predecessor", false) == true
}

# ---------------------------------------------------------------------------
# Förderwerbende Person (Allgemeine Teilnahmebedingungen 5.2, SRL 1.4)
# ---------------------------------------------------------------------------

applicant := object.get(object.get(input, "farm", {}), "applicant", {})

applicant_form(id) := f if {
	some f in params.applicant_forms
	f.id == id
}

default applicant_eligible := false

applicant_eligible if {
	form := applicant_form(applicant.legal_form)
	form.eligible
	form.max_public_body_share_percent == null
	applicant_base_ok
}

applicant_eligible if {
	form := applicant_form(applicant.legal_form)
	form.eligible
	form.max_public_body_share_percent != null
	object.get(applicant, "public_body_share_percent", 0) <= form.max_public_body_share_percent
	applicant_base_ok
}

applicant_base_ok if {
	object.get(applicant, "is_active_farmer", false) == true
	object.get(applicant, "is_alm_operator", false) == true
}

# ---------------------------------------------------------------------------
# Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr
# ---------------------------------------------------------------------------

default min_farm_size_met := false

min_farm_size_met if object.get(participation, "first_oepul_year", 0) != year

min_farm_size_met if {
	object.get(participation, "first_oepul_year", 0) == year
	object.get(land, "total_area_ha", 0) >= params.minimum_farm_size_first_year.agricultural_area_min_ha
}

min_farm_size_met if {
	object.get(participation, "first_oepul_year", 0) == year
	object.get(land, "protected_cultivation_area_ha", 0) >= params.minimum_farm_size_first_year.protected_cultivation_min_ha
}

land := object.get(input, "land", {})

# ---------------------------------------------------------------------------
# Kontrollen: Verweigerung führt zur Ablehnung
# ---------------------------------------------------------------------------

control_refused if {
	object.get(object.get(input, "documentation", {}), "on_site_control_refused", false) == true
	object.get(object.get(input, "documentation", {}), "control_refusal_force_majeure", false) == false
}
