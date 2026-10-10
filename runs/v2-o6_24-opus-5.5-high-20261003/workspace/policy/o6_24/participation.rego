package oepul.o6_24

import rego.v1

# Teilnahmevoraussetzungen, Vertragszeitraum, Beantragung und Ausstieg
# (Maßnahmenblatt o6_24 Kap. 3, 5, 6; SRL 1.7.1.1, 1.10.5, 2.24;
# Allgemeine Teilnahmebedingungen 5.9, 6).

premium_data := data.o6_24.o6_24_praemie

# Bewirtschaftete Ackerfläche in der Gebietskulisse (inklusive Flächen mit
# Bewilligung zu erhöhten Stickstoffgaben und Brachen; siehe Annahmen).
wrrl_arable_area_ha := sum([p.area_ha | some p in area_arable_parcels])

# Maßnahmenblatt 3.2 / SRL 2.24: mindestens 2,00 ha Ackerfläche in der Gebietskulisse.
min_participation_met if wrrl_arable_area_ha >= premium_data.min_participation_arable_ha

# Maßnahmenblatt 3.1 / 5: Bei Unterschreiten der Mindestteilnahme erlischt der Vertrag.
contract_lapses_this_year if not min_participation_met

application_date := object.get(o624, "measure_application_date", null)

contract_start_year := object.get(o624, "contract_start_year", null)

# Maßnahmenblatt 5: Beantragung vor Vertragsbeginn bis spätestens 31. Dezember des Vorjahres.
application_deadline_met if {
	is_string(application_date)
	is_number(contract_start_year)
	application_date <= sprintf("%d-12-31", [contract_start_year - 1])
}

# Maßnahmenblatt 5 / Allgemeine Teilnahmebedingungen 5.9: letzter Einstieg Förderjahr 2027.
entry_year_allowed if {
	is_number(contract_start_year)
	contract_start_year <= premium_data.last_entry_year
}

deregistration_date := object.get(o624, "deregistration_date", null)

# Maßnahmenblatt 6: Abmeldung im laufenden Jahr -> Maßnahme im betroffenen Förderjahr nicht mehr gültig.
deregistered_for_year if {
	is_string(deregistration_date)
	year_of(deregistration_date) <= farm_year
}

# Maßnahmenblatt 6: Ausstieg erst nach Erfüllung des einjährigen Vertragszeitraumes.
exit_allowed_in_year(y) if {
	is_number(contract_start_year)
	y > contract_start_year
}

deregistration_before_first_year_completed if {
	is_string(deregistration_date)
	not exit_allowed_in_year(year_of(deregistration_date))
}

# Maßnahmenblatt 5 Achtung / SRL 1.10.5.3: Nach Erlöschen (Mindestteilnahme verfehlt),
# Ausstieg, Ausschluss oder einjähriger Nichtabgabe des Mehrfachantrages ist ein
# neuer fristgerechter Maßnahmenantrag erforderlich.
new_application_required if {
	object.get(o624, "lapsed_in_previous_year", false) == true
	contract_start_year < farm_year
}

new_application_required if {
	object.get(o624, "mfa_not_submitted_previous_year", false) == true
	contract_start_year < farm_year
}

new_application_required if {
	object.get(o624, "excluded_previously", false) == true
	contract_start_year < farm_year
}

# Allgemeine Teilnahmebedingungen 6 / SRL 1.10.5.2: automatische Verlängerung einjähriger
# Maßnahmen, Weiterführung durch Abgabe des Mehrfachantrages.
contract_valid if {
	object.get(o624, "measure_application_submitted", false) == true
	application_deadline_met
	entry_year_allowed
	contract_start_year <= farm_year
	not deregistered_for_year
	not new_application_required
}

mfa_submitted if object.get(o624, "multiple_application_submitted", false) == true

# SRL 1.12.1.1: bei einjährigen Maßnahmen kommt bei Nichterfüllung von Förder-
# bzw. Zugangsvoraussetzungen kein Vertrag zustande.
participation_eligible if {
	contract_valid
	mfa_submitted
	min_participation_met
	applicant_eligible
	minimum_farm_size_met
}

participation_reasons contains "Maßnahmenantrag fehlt oder nicht fristgerecht (31.12. des Vorjahres)" if {
	not application_deadline_met
}

participation_reasons contains "Einstieg nach dem Förderjahr 2027 nicht möglich" if {
	not entry_year_allowed
}

participation_reasons contains "Maßnahme im Förderjahr abgemeldet" if deregistered_for_year

participation_reasons contains "neuer Maßnahmenantrag erforderlich (Vertrag erloschen bzw. Ausstieg/Ausschluss/Nichtabgabe MFA)" if {
	new_application_required
}

participation_reasons contains "Mehrfachantrag mit förderrelevanten Flächen nicht abgegeben" if not mfa_submitted

participation_reasons contains "Mindestteilnahme von 2,00 ha Ackerfläche in der Gebietskulisse nicht erreicht – Vertrag erlischt" if {
	not min_participation_met
}

participation_reasons contains "förderwerbende Person nicht teilnahmeberechtigt" if not applicant_eligible

participation_reasons contains "Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr nicht erreicht" if {
	not minimum_farm_size_met
}

# Allgemeine Teilnahmebedingungen 6.3 / SRL 1.7.3.1: Maßnahmenübernahme durch anderen Betrieb.
takeover_deadline_md := "04-17" if {
	farm_year in {2023, 2028}
} else := "04-15"

takeover_allowed if {
	t := object.get(o624, "takeover", null)
	is_object(t)
	month_day(t.request_date) <= takeover_deadline_md
	year_of(t.request_date) == farm_year
	t.taking_over_farm_previously_participating == false
	t.expansion_share <= 0.5
}
