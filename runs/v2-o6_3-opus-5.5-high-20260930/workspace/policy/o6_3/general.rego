# Allgemeine Teilnahmebedingungen und Sonderrichtlinie – für die Heuwirtschaft maßgebliche Abwicklungsregeln.
package o6_3

# O6_3-CP-01: Vertragszeitraum abhängig vom Vertragsbeginn, jedenfalls bis 31.12.2028.
contract_period := row if {
	some row in data.o6_3.contract_periods.rows
	row.start_year == contract_start_year
}

contract_end_year := 2028

within_contract_period if {
	is_number(contract_start_year)
	contract_start_year <= year
	year <= contract_end_year
}

# GEN-AREA-DEC-01: Toleranz für Flächenabgänge (5 %, max. 5 ha, jedenfalls 0,5 ha pro Jahr).
previous_year_grassland_ha := object.get(area_change, "previous_year_grassland_measure_area_ha", null)

tolerated_exempt_decrease_ha := object.get(area_change, "decrease_loss_of_disposal_ha", 0) + object.get(area_change, "decrease_permitted_conversion_ha", 0)

allowed_decrease_ha(prev) := max([
	min([prev * params.area_decrease_tolerance.max_share, params.area_decrease_tolerance.max_ha]),
	params.area_decrease_tolerance.always_allowed_ha,
])

current_grassland_measure_ha := object.get(area_change, "current_grassland_measure_area_ha", premium_grassland_area_ha)

relevant_decrease_ha := (previous_year_grassland_ha - current_grassland_measure_ha) - tolerated_exempt_decrease_ha if {
	is_number(previous_year_grassland_ha)
}

# Überschreitung: Rückzahlung für die gesamten Differenzflächen.
area_decrease_repayment_ha := relevant_decrease_ha if {
	relevant_decrease_ha > allowed_decrease_ha(previous_year_grassland_ha)
}

area_decrease_repayment_required if area_decrease_repayment_ha > 0

# GEN-EXIT-02 / SRL-ZA-01: vorzeitiger Ausstieg aus der mehrjährigen Maßnahme.
is_multi_year_measure if "o6_3" in data.o6_3.measure_lists.multi_year_measures

exit_input := object.get(o6_3_input, "exit", {})

exited_without_recognition if {
	is_multi_year_measure
	object.get(exit_input, "exited", false) == true
	object.get(exit_input, "exit_year", 9999) <= contract_end_year
	not object.get(exit_input, "force_majeure_or_exceptional_circumstances_recognised", false) == true
}

full_recovery_required if exited_without_recognition

full_recovery_required if object.get(o6_3_input, "payment_application_missing_over_one_year", false) == true

# SRL-ZA-01: fehlender Zahlungsantrag in einem Folgejahr – Verpflichtung bleibt, keine Zahlung.
no_payment_missing_application if object.get(o6_3_input, "payment_application_submitted", true) == false

# GEN-TAKEOVER-01: Maßnahmenübernahme bis 15.04. (2023 und 2028: 17.04.), Ausweitung max. 50 %.
takeover := object.get(o6_3_input, "takeover", {})

takeover_deadline(y) := sprintf("%d-%s", [y, params.takeover.deadline_month_day_2023_2028]) if {
	y in {2023, 2028}
} else := sprintf("%d-%s", [y, params.takeover.deadline_month_day])

takeover_issues contains "GEN-TAKEOVER-01" if {
	object.get(takeover, "is_takeover", false) == true
	object.get(takeover, "takeover_date", "9999-12-31") > takeover_deadline(year)
}

takeover_issues contains "GEN-TAKEOVER-01" if {
	object.get(takeover, "is_takeover", false) == true
	object.get(takeover, "extension_share", 0) > params.takeover.max_extension_share
}

takeover_issues contains "GEN-TAKEOVER-01" if {
	object.get(takeover, "is_takeover", false) == true
	object.get(takeover, "taker_already_participating", false) == true
}

# GEN-SANC-01: Kürzungsstufen; ab 2027 statt Verwarnung 1 % Einbehalt.
sanction_share(level, y) := s if {
	level == "warning"
	y >= params.warning_replaced_by_retention_from_year
	s := params.warning_retention_share
} else := s if {
	some l in data.o6_3.sanctions.levels
	l.level == level
	s := l.reduction_share
}

hundred_percent_reductions := object.get(o6_3_input, "hundred_percent_reductions_in_contract_period", 0)

excluded_from_measure if hundred_percent_reductions >= 2

# SRL-VOK-01: Verweigerung der Kontrolle führt zur Ablehnung und Rückabwicklung.
control_refused if object.get(input, ["farm", "oepul", "control_refused"], false) == true

# GEN-PAY-01: Auszahlung bis 30.06. des Folgejahres, Vorschuss max. 75 %.
payment_deadline := sprintf("%d-06-30", [year + 1])

max_advance_payment_eur := round((premium_after_modulation_eur * params.payment.advance_max_share) * 100) / 100

# GEN-LH-01: jährlicher Wechsel der Tierhaltereigenschaft; O6_3-PREM-03: keine Rückforderung für Vorjahre.
recovery_for_prior_years_due_to_livestock_change := false
