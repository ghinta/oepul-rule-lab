package oepul.o6_1c

# Beantragung, Vertragszeitraum, Verlängerung und Abmeldung.

first_contract_year := application.first_contract_year

# O6_1C-APP-001: Beantragung vor Vertragsbeginn bis 31.12. des Vorjahres.
application_deadline := date_of(first_contract_year - 1, params.application.measure_application_deadline_mmdd)

application_violations contains farm_violation("O6_1C-APP-001", sprintf("Maßnahmenantrag muss bis %s eingelangt sein", [application_deadline])) if {
	application.application_date > application_deadline
}

application_violations contains farm_violation("O6_1C-APP-001", "Kategorie muss im Maßnahmenantrag des Mehrfachantrages beantragt werden") if {
	count(applied_categories) == 0
}

# O6_1C-APP-002: Letzter Einstieg mit Förderjahr 2027.
application_violations contains farm_violation("O6_1C-APP-002", "Letzter Einstieg ist mit dem Förderjahr 2027 möglich (Beantragung bis 31.12.2026)") if {
	first_contract_year > params.application.last_entry_year
}

# O6_1C-CONTRACT-001: Vertrags- und Verpflichtungszeitraum = Kalenderjahr.
commitment_period := {
	"start": date_of(year, "01-01"),
	"end": date_of(year, "12-31"),
}

# O6_1C-CONTRACT-002: automatische Verlängerung, wenn nicht abgemeldet.
deregistration_date := object.get(application, "deregistration_date", null)

contract_extended_into_year if {
	first_contract_year < year
	not contract_ended_before_year
}

contract_ended_before_year if {
	deregistration_date != null
	deregistration_date < date_of(year, "01-01")
}

# O6_1C-APP-007: Abmeldung zwischen 1.1. und 31.12. -> Maßnahme im
# betroffenen Förderjahr nicht mehr gültig.
deregistered_in_year if {
	deregistration_date != null
	deregistration_date >= commitment_period.start
	deregistration_date <= commitment_period.end
}

# O6_1C-APP-010: Wiedereinstieg nach Ausstieg, Ausschluss oder einjähriger
# Nichtabgabe des Mehrfachantrages nur mit neuerlichem Maßnahmenantrag.
application_violations contains farm_violation("O6_1C-APP-010", "Wiedereinstieg nur mit neuerlichem Maßnahmenantrag möglich") if {
	application.reentry_after_exit_or_exclusion == true
	not application.new_measure_application_submitted == true
}

# O6_1C-APP-011: Weiterführung durch Abgabe des Mehrfachantrages mit
# förderrelevanten Flächen.
continuation_requested if {
	contract_extended_into_year
	application.multiple_application_submitted == true
	count(npa_parcels | afs_parcels) > 0
}

application_violations contains farm_violation("O6_1C-APP-011", "Weiterführung erfordert die Abgabe des Mehrfachantrages mit förderrelevanten Flächen") if {
	contract_extended_into_year
	not continuation_requested
}

# O6_1C-APP-012: Maßnahmenübernahme bis 15.04. (2023 und 2028: 17.04.),
# Ausweitung auf andere Flächen höchstens 50 %.
takeover_deadline(y) := date_of(y, params.application.takeover_deadline_mmdd_2023_2028) if y in {2023, 2028}

takeover_deadline(y) := date_of(y, params.application.takeover_deadline_mmdd) if not y in {2023, 2028}

takeover := object.get(application, "takeover", null)

application_violations contains farm_violation("O6_1C-APP-012", sprintf("Maßnahmenübernahme nur bis %s möglich", [takeover_deadline(year)])) if {
	takeover != null
	takeover.date > takeover_deadline(year)
}

application_violations contains farm_violation("O6_1C-APP-012", "Maßnahmenübernahme darf nicht zu einer Ausweitung auf andere Flächen um mehr als 50 % führen") if {
	takeover != null
	takeover.additional_area_ha > params.application.takeover_max_extension_share * takeover.taken_over_area_ha
}

# O6_1C-APP-006: Feldstücksliste (Lage, Ausmaß, Schlagnutzung, Codes) bis
# spätestens 15. April des Antragsjahres.
field_list_deadline := date_of(year, params.application.field_list_deadline_mmdd)

application_violations contains farm_violation("O6_1C-APP-006", sprintf("Feldstücksliste des Mehrfachantrages ist bis %s einzureichen", [field_list_deadline])) if {
	application.field_list_submission_date > field_list_deadline
}
