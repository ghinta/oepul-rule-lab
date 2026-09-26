# Maßnahme 12 – Vertragszeitraum, Beantragung, Ausstieg, Maßnahmenwechsel, Übernahme und
# Flächenänderungen.
package oepul.o6_12

# --- Vertragszeitraum (MB 3.1, AT 5.9, SRL 1.7.1.2) ---
contract_period := row if {
	some row in data.o6_12.o6_12_contract_periods
	row.start_year == commitment_start_year
}

contract_start_valid if contract_period

contract_active_in_year if {
	contract_start_valid
	commitment_start_year <= application_year
	application_year <= year_of(contract_period.end_date)
}

# Letzter Einstieg: Förderjahr 2025 (Beantragung bis 31.12.2024).
contract_findings contains "entry_after_last_entry_year" if {
	participates
	commitment_start_year > measure.last_entry_year
}

contract_findings contains "invalid_commitment_start_year" if {
	participates
	not contract_start_valid
}

# Beantragung im Maßnahmenantrag bis 31.12. vor Vertragsbeginn (MB 5, SRL 1.10.5.2).
application_deadline := sprintf("%d-12-31", [commitment_start_year - 1])

contract_findings contains "measure_application_after_deadline" if {
	participates
	participation_12.application_date > application_deadline
}

# --- Ausstieg (AT 6, SRL 1.10.5.3, 1.7.2) ---
exit_date := object.get(participation_12, "exit_date", null)

exited if exit_date != null

# Ausstieg im laufenden Jahr: Maßnahme im betroffenen Förderjahr nicht mehr gültig.
exit_in_current_year if {
	exited
	year_of(exit_date) == application_year
}

controls := object.get(oepul, ["controls"], {})

# Ausstieg nur bis zur Ankündigung/Durchführung einer VOK bzw. Mitteilung der Verwaltungskontrolle.
exit_blocked_by_control if {
	exited
	controls.on_site_control_announced_or_done == true
}

exit_blocked_by_control if {
	exited
	controls.admin_control_result_notified == true
}

exit_before_contract_end if {
	exited
	exit_date < contract_period.end_date
}

# Rückzahlungsfreie Ausnahmen vom Grundsatz der Rückforderung.
repayment_free_exit_reason contains "leafhopper_exit_2026" if leafhopper_exit_approved

repayment_free_exit_reason contains "switch_to_organic" if switch_valid

repayment_free_exit_reason contains "revision_clause_refused" if {
	object.get(o6_12_input, ["revision_clause_consent_refused"], false) == true
}

repayment_free_exit_reason contains "permanent_circumstances_recognised" if {
	object.get(o6_12_input, ["permanent_circumstances_recognised"], false) == true
}

exit_consequence := "repayment_of_premiums_since_contract_start" if {
	exit_before_contract_end
	count(repayment_free_exit_reason) == 0
}

exit_consequence := "no_repayment" if {
	exit_before_contract_end
	count(repayment_free_exit_reason) > 0
}

# Wiedereinstieg nur mit neuem Maßnahmenantrag; nach dem letzten Einstiegsjahr nicht mehr möglich.
reentry_possible if {
	exited
	application_year < measure.last_entry_year
}

default reentry_possible := false

# --- Maßnahmenwechsel in Biologische Wirtschaftsweise (MB 5, AT 6.2, SRL 1.7.3.2) ---
switch := object.get(o6_12_input, ["switch_to_organic"], {})

switch_valid if {
	switch.requested == true
	switch.effective_date <= measure.switch_to_organic_latest_date
	some row in data.o6_12.oepul_measure_switches
	row.from == measure.code
	measure.switch_to_organic_target_measure in row.to
}

contract_findings contains "switch_to_organic_after_deadline" if {
	switch.requested == true
	switch.effective_date > measure.switch_to_organic_latest_date
}

# --- Maßnahmenübernahme (AT 6.3, SRL 1.7.3.1) ---
takeover := object.get(o6_12_input, ["takeover"], {})

takeover_deadline := sprintf("%d-%s", [application_year, general.takeover_deadline_month_day_2023_2028]) if {
	application_year in {2023, 2028}
}

takeover_deadline := sprintf("%d-%s", [application_year, general.takeover_deadline_month_day]) if {
	not application_year in {2023, 2028}
}

takeover_findings contains "takeover_after_deadline" if {
	takeover.requested == true
	takeover.date > takeover_deadline
}

takeover_findings contains "taker_already_participating" if {
	takeover.requested == true
	takeover.taker_previously_participating == true
}

takeover_findings contains "takeover_expansion_above_50_percent" if {
	takeover.requested == true
	takeover.expansion_percent > general.takeover_max_expansion_percent
}

takeover_findings contains "takeover_not_approved_by_ama" if {
	takeover.requested == true
	takeover.ama_approved == false
}

takeover_valid if {
	takeover.requested == true
	count(takeover_findings) == 0
}

# --- Flächenänderungen ---
# Maßnahme 12: Flächen sind an die jährlich verfügbaren WOH-Flächen gebunden (SRL 1.7.2.5).
area_bound_annually if {
	some row in data.o6_12.oepul_area_bound_annually_measures
	row.measure_code == measure.code
}

# Keine Beschränkung des prämienfähigen Flächenzugangs für Maßnahme 12 (SRL 1.7.2.4).
area_addition_restricted if {
	some row in data.o6_12.oepul_area_addition_restricted_measures
	row.measure_code == measure.code
}

default area_addition_restricted := false

# Toleranz für Flächenverringerungen (SRL 1.7.2.3): 5 %, max. 5 ha, jedenfalls 0,5 ha.
area_reduction_tolerance_ha(previous_area) := max([
	min([(previous_area * general.area_reduction_tolerance_percent) / 100, general.area_reduction_tolerance_max_ha]),
	general.area_reduction_tolerance_min_ha,
])

area_change := object.get(o6_12_input, ["area_change"], {})

area_reduction_ha := area_change.previous_year_area_ha - area_change.current_area_ha

# Nur relevant, wenn die Reduktion nicht auf Verlust der Verfügungsgewalt oder zulässige
# Nutzungsumwandlung zurückgeht und die Maßnahme nicht jährlich flächengebunden ist.
area_reduction_repayment_ha := area_reduction_ha if {
	not area_bound_annually
	area_change.loss_of_disposal_right == false
	area_change.permitted_conversion == false
	area_reduction_ha > area_reduction_tolerance_ha(area_change.previous_year_area_ha)
}

# --- Zahlungsantrag (SRL 1.10.5.3) ---
payment_application := object.get(oepul, ["payment_application"], {})

payment_application_consequence := "commitment_continues_no_payment" if {
	payment_application.submitted == false
	not commitment_start_year == application_year
	object.get(payment_application, "years_overdue", 0) <= general.late_payment_application_max_years
}

payment_application_consequence := "commitment_ends_repayment" if {
	payment_application.submitted == false
	object.get(payment_application, "years_overdue", 0) > general.late_payment_application_max_years
}

# --- Kontrollen (SRL 1.11.1.2) ---
inspection_refused if {
	controls.inspection_refused == true
	not object.get(oepul, ["force_majeure", "recognised"], false)
}

# --- Klassifikation als mehrjährige Maßnahme (SRL 1.7.1.2) ---
is_multi_year_measure if {
	some row in data.o6_12.oepul_multi_year_measures
	row.measure_code == measure.code
}

# Maßnahme 12 ist nicht auf Übernahmen in Einzelfällen beschränkt (AT 6.3).
takeover_restricted_to_single_cases if {
	some row in data.o6_12.oepul_takeover_single_case_only
	contains(row.item, sprintf("(%s)", [measure.code]))
}

default takeover_restricted_to_single_cases := false
