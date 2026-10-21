# title: o6_5 – Förderwerbende Person, Beantragung, Vertrag und Ausstieg
# description: >-
#   Allgemeine Fördervoraussetzungen (förderwerbende Person, Betriebsmindestgröße,
#   Kontrollduldung) und maßnahmenbezogene Vertragsregeln (Antragsfrist, letzter
#   Einstieg, Wiedereinstieg, Abmeldung, Maßnahmenübernahme, Mindestteilnahme).
package oepul.o6_5

allowed_legal_forms := {f.legal_form | some f in data.o6_5.applicant_legal_forms}

# O6_5-GEN-APPLICANT-LEGAL-FORM
applicant_failures contains "O6_5-GEN-APPLICANT-LEGAL-FORM" if {
	not applicant.legal_form in allowed_legal_forms
}

# O6_5-GEN-PUBLIC-BODY-EXCLUDED: Gebietskörperschaften und Einrichtungen mit
# bestimmendem Einfluss (> 25 %) sind bei o6_5 nicht förderwerbend.
applicant_failures contains "O6_5-GEN-PUBLIC-BODY-EXCLUDED" if {
	applicant.is_public_body == true
	not public_body_exempt_measure("o6_5")
}

applicant_failures contains "O6_5-GEN-PUBLIC-BODY-EXCLUDED" if {
	applicant.public_body_share_percent > params.public_body_max_share_percent
	not public_body_exempt_measure("o6_5")
}

public_body_exempt_measure(m) if {
	some e in data.o6_5.public_body_exempt_measures
	e.measure == m
	e.from_year <= year
	exempt_until_ok(e)
}

exempt_until_ok(e) if e.to_year == null

exempt_until_ok(e) if year <= e.to_year

# O6_5-GEN-ACTIVE-FARMER
applicant_failures contains "O6_5-GEN-ACTIVE-FARMER" if {
	not applicant.is_active_farmer == true
}

applicant_failures contains "O6_5-GEN-ACTIVE-FARMER" if {
	not applicant.performs_agricultural_activity == true
}

# O6_5-GEN-MIN-FARM-SIZE: nur im ersten ÖPUL-Teilnahmejahr.
first_oepul_year := object.get(input, ["oepul_participation", "first_oepul_year"], null)

applicant_failures contains "O6_5-GEN-MIN-FARM-SIZE" if {
	first_oepul_year == year
	not min_farm_size_ok
}

min_farm_size_ok if {
	object.get(input, ["land", "protected_cultivation_area_ha"], 0) >= params.min_protected_cultivation_area_first_year_ha
}

min_farm_size_ok if total_area_ha >= params.min_farm_area_first_year_ha

# O6_5-CTRL-REFUSAL: Verweigerung/Verhinderung der Vor-Ort-Kontrolle (außer höhere Gewalt).
applicant_failures contains "O6_5-CTRL-REFUSAL" if {
	object.get(input, ["documentation", "inspection_refused"], false) == true
	not object.get(input, ["documentation", "inspection_refusal_force_majeure"], false) == true
}

start_year := val(participation, "participation_start_year")

# O6_5-APP-DEADLINE: Maßnahmenantrag bis 31.12. vor Vertragsbeginn.
application_timely if {
	is_number(start_year)
	d := val(participation, "measure_application_date")
	d != null
	parse_date(d) <= date_of(start_year - 1, params.application_deadline_md)
}

contract_failures contains "O6_5-APP-DEADLINE" if not application_timely

# O6_5-APP-LAST-ENTRY: letzter Einstieg mit Förderjahr 2027.
contract_failures contains "O6_5-APP-LAST-ENTRY" if {
	is_number(start_year)
	start_year > params.last_entry_year
}

contract_failures contains "O6_5-CON-NOT-STARTED" if {
	is_number(start_year)
	start_year > year
}

# O6_5-CON-REENTRY-AFTER-LAPSE: nach Erlöschen neuer fristgerechter Maßnahmenantrag
# oder Korrektur zum vorhergehenden Maßnahmenantrag plus schriftliches Ersuchen.
contract_failures contains "O6_5-CON-REENTRY-AFTER-LAPSE" if {
	participation.previous_year_contract_lapsed == true
	not reentry_ok
}

reentry_ok if {
	d := val(participation, "reapplication_date")
	d != null
	parse_date(d) <= date_of(year - 1, params.application_deadline_md)
	year <= params.last_entry_year
}

reentry_ok if {
	participation.late_reentry_correction == true
	participation.written_request_submitted == true
	year <= params.last_entry_year
}

# O6_5-EXIT-DEREGISTRATION-TIMING: Abmeldung im Förderjahr -> Maßnahme im Förderjahr
# nicht mehr gültig; Abmeldung in einem Vorjahr -> ausgestiegen.
deregistration_effective if {
	d := val(participation, "deregistration_date")
	d != null
	not deregistration_after_inspection_notice
}

# O6_5-GEN-EXIT-UNTIL-INSPECTION: Ausstieg nur bis zur Durchführung/Ankündigung einer
# Vor-Ort-Kontrolle bzw. Mitteilung des Ergebnisses einer Verwaltungskontrolle.
deregistration_after_inspection_notice if {
	d := val(participation, "deregistration_date")
	n := val(participation, "inspection_notice_date")
	d != null
	n != null
	parse_date(d) >= parse_date(n)
}

deregistered_for_year if {
	deregistration_effective
	parse_date(participation.deregistration_date) <= date_of(year, "12-31")
}

contract_failures contains "O6_5-EXIT-DEREGISTRATION-TIMING" if deregistered_for_year

# O6_5-GEN-TAKEOVER: Maßnahmenübernahme nur in Einzelfällen (Betriebsauflösung,
# -teilung, -zusammenlegung); Tiere und Flächen vom selben Vorbetrieb.
restricted_takeover_reasons := {r.reason | some r in data.o6_5.restricted_takeover_reasons}

contract_failures contains "O6_5-GEN-TAKEOVER" if {
	participation.takeover.is_takeover == true
	not takeover_ok
}

takeover_ok if {
	participation.takeover.reason in restricted_takeover_reasons
	participation.takeover.animals_and_land_from_same_predecessor == true
}

# O6_5-MIN-PARTICIPATION / O6_5-GEN-ACCESS-NONCOMPLIANCE-NO-CONTRACT
contract_failures contains "O6_5-MIN-PARTICIPATION" if not minimum_participation_met

access_requirements_met if {
	count(applicant_failures) == 0
	count(contract_failures) == 0
}

# O6_5-CON-LAPSE: Vertrag erlischt, wenn die Mindestteilnahme nicht erfüllt ist.
contract_lapses if not minimum_participation_met

# O6_5-CON-AUTO-RENEWAL: automatische Verlängerung um ein Förderjahr ohne Abmeldung.
contract_renews_next_year if {
	access_requirements_met
	not contract_lapses
	not val(participation, "deregistration_date") != null
}
