# Vertragszeitraum, Beantragung, Einstieg, Maßnahmenwechsel, Übernahme und Ausstieg
# (Maßnahmenblatt Kap. 3.1, 5; Allgemeine Bedingungen 5.8, 5.9, 6, 6.2, 6.3, 7; SRL 1.7, 1.10.5).
package oepul.o6_4

contract_periods := data.o6_4.contract_periods

# O6_4-CONTRACT-001: Vertragszeitraum je Vertragsbeginn (mindestens 4 Jahre, bis 31.12.2028).
contract_period_for_start(start_date) := r if {
	some r in contract_periods.rows
	r.start_date == start_date
}

# O6_4-APP-002: letzter Einstieg mit Förderjahr 2025.
entry_year_allowed(start_year) if {
	some r in contract_periods.rows
	r.start_year == start_year
	start_year <= contract_periods.last_entry_year
}

# O6_4-APP-001 / GEN-APP-001: Beantragung im Maßnahmenantrag bis spätestens 31.12. vor Vertragsbeginn.
application_timely(application_date, start_date) if {
	date_ns(application_date) < date_ns(start_date)
	date_parts(start_date)[1] == 1
	date_parts(start_date)[2] == 1
	date_parts(application_date)[0] == date_parts(start_date)[0] - 1
}

application_timely(application_date, start_date) if {
	date_ns(application_date) < date_ns(start_date)
	date_parts(start_date)[1] == 1
	date_parts(start_date)[2] == 1
	date_parts(application_date)[0] < date_parts(start_date)[0] - 1
}

default application_status := {"contract_valid": false, "reasons": ["no_measure_record"]}

application_status := {"contract_valid": count(application_problems) == 0, "reasons": sort([x | some x in application_problems])} if {
	measure_record
}

application_problems contains "O6_4-APP-001" if {
	not application_timely(measure_record.measure_application_date, measure_record.contract_start_date)
}

application_problems contains "O6_4-APP-002" if {
	not entry_year_allowed(date_parts(measure_record.contract_start_date)[0])
}

application_problems contains "GEN-APPL-001" if not applicant_eligible

application_problems contains "GEN-MIN-001" if not minimum_farm_size_met

contract_end_date := contract_periods.contract_end_date

# GEN-DUR-001: Verpflichtungsdauer umfasst das gesamte Kalenderjahr.
commitment_period(yr) := {"from": sprintf("%d-01-01", [yr]), "to": sprintf("%d-12-31", [yr])}

# O6_4-APP-003 / GEN-SWITCH-001: Umstieg in Naturschutz (o6_18) oder Ergebnisorientierte Bewirtschaftung (o6_19)
# mit einzelnen oder allen Flächen bis spätestens 31.12.2025, ohne Rückzahlungsverpflichtung.
switch_allowed(target, switch_date) if {
	some r in params.measure_switch.rows
	r.from == measure_id
	target in r.to
	date_ns(switch_date) <= date_ns(params.measure_switch.latest_switch_date)
}

# GEN-TAKEOVER-001: Maßnahmenübernahme bis 15.04. (2023 und 2028: 17.04.) des Übernahmejahres,
# Ausweitung auf andere Flächen höchstens um 50 %.
takeover_deadline(yr) := sprintf("%d-04-%02d", [yr, params.takeover.deadline_day_in_exception_years]) if {
	yr in {y | some y in params.takeover.deadline_day_exception_years}
} else := sprintf("%d-04-%02d", [yr, params.takeover.deadline_day])

takeover_allowed(takeover_date, expansion_share) if {
	yr := date_parts(takeover_date)[0]
	date_ns(takeover_date) <= date_ns(takeover_deadline(yr))
	expansion_share <= params.takeover.max_expansion_share
}

# GEN-EXIT-001: Ausstieg aus mehrjähriger Maßnahme vor Ende des Vertragszeitraumes → Rückforderung
# bereits gewährter Maßnahmenprämien (ausgenommen Maßnahmenwechsel, Verlust der Verfügungsgewalt,
# höhere Gewalt/dauerhafte Umstände, Revisionsklausel).
repayment_exemption_reasons := {
	"measure_switch_to_higher_value",
	"loss_of_control_over_area",
	"force_majeure_or_permanent_circumstances",
	"revision_clause_refusal",
}

early_exit_repayment_required if {
	exit_date := measure_record.exit_date
	exit_date != null
	date_ns(exit_date) < date_ns(contract_end_date)
	not object.get(measure_record, "exit_reason", null) in repayment_exemption_reasons
}

# GEN-EXIT-002: Abmeldung zwischen 1.1. und 31.12. → Maßnahme im betroffenen Förderjahr nicht mehr gültig.
measure_valid_in_year(yr) if {
	measure_record
	not deregistered_in_year(yr)
}

deregistered_in_year(yr) if date_parts(measure_record.exit_date)[0] == yr

# SRL-NONAPP-001: Nichtbeantragung ab dem 2. Verpflichtungsjahr – Verpflichtung bleibt, keine Zahlung;
# nicht binnen 1 Jahr nachgeholt → Verpflichtung endet, bisher gewährte Prämien sind zurückzuzahlen.
non_application_consequence(submitted_late_within_one_year) := "commitment_remains_no_payment" if {
	submitted_late_within_one_year == true
} else := "commitment_ends_full_repayment"
