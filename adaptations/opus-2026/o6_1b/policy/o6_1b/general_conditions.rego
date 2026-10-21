# Allgemeine Rahmenbedingungen mehrjähriger Maßnahmen: Flächenabgang, Flächenzugang,
# Maßnahmenübernahme, Ausstieg, Kürzungsstufen und Auszahlung (ATB 5.8, 6, 7, 8, 9; SRL 1.7, 1.9, 1.10, 1.12).
package oepul.o6_1b

area_changes := object.get(input, ["oepul", "area_changes"], {})

# --- Flächenabgang (ATB 7.1; SRL 1.7.2.3) ------------------------------------------------------

previous_measure_area_ha := object.get(area_changes, "previous_year_measure_area_ha", 0)

# Unschädliche Abgänge: Verlust der Verfügungsgewalt und zulässige Nutzungsumwandlungen
exempt_reduction_ha := object.get(area_changes, "loss_of_control_ha", 0) + object.get(area_changes, "permitted_conversion_ha", 0)

relevant_reduction_ha := clamp0((previous_measure_area_ha - object.get(area_changes, "current_measure_area_ha", previous_measure_area_ha)) - exempt_reduction_ha)

area_loss_tolerance_ha := max2(min2(general.area_loss_tolerance.max_share * previous_measure_area_ha, general.area_loss_tolerance.max_ha), general.area_loss_tolerance.always_allowed_ha)

area_reduction_repayment_ha := relevant_reduction_ha if relevant_reduction_ha > area_loss_tolerance_ha

area_reduction_repayment_ha := 0 if relevant_reduction_ha <= area_loss_tolerance_ha

violations contains {"rule_id": "O61B-ATB-009", "message": sprintf("Flächenreduktion %v ha über der Toleranz %v ha: Rückzahlung für die gesamte Differenzfläche", [round2(relevant_reduction_ha), round2(area_loss_tolerance_ha)])} if {
	area_reduction_repayment_ha > 0
}

# --- Flächenzugang (ATB 7.2; SRL 1.7.2.4) -----------------------------------------------------

measure_area_2025_ha := object.get(area_changes, "measure_area_2025_ha", null)

premium_eligible_measure_area_max_ha := max2(measure_area_2025_ha * (1 + general.area_increase.max_increase_share), measure_area_2025_ha + general.area_increase.always_allowed_ha) if {
	year > general.area_increase.base_year
	measure_area_2025_ha != null
}

area_increase_not_eligible_ha := clamp0(object.get(area_changes, "current_measure_area_ha", 0) - premium_eligible_measure_area_max_ha)

# --- Maßnahmenübernahme (ATB 6.3; SRL 1.7.3.1) ---------------------------------------------

takeover := object.get(o6_1b_input, "takeover", null)

takeover_deadline(y) := sprintf("%d-%s", [y, general.takeover_deadline.years_2023_2028]) if y in {2023, 2028}

takeover_deadline(y) := sprintf("%d-%s", [y, general.takeover_deadline.default]) if not y in {2023, 2028}

violations contains {"rule_id": "O61B-ATB-013", "message": "Maßnahmenübernahme nach der Frist (15.04. bzw. 17.04. in 2023/2028)"} if {
	takeover != null
	takeover.date > takeover_deadline(date_year(takeover.date))
}

violations contains {"rule_id": "O61B-ATB-013", "message": "Maßnahmenübernahme führt zu einer Ausweitung auf andere Flächen um mehr als 50 %"} if {
	takeover != null
	object.get(takeover, "extension_share", 0) > general.tolerances.takeover_max_extension_share
}

# --- Ausstieg / Vertragszeitraum (ATB 6, 7.1; SRL 1.7.2, 1.10.5.3) ----------------------------

exit_info := object.get(o6_1b_input, "exit", null)

repayment_of_all_premiums_required if {
	exit_info != null
	exit_info.date < general.deadlines.contract_end
	object.get(exit_info, "reason", "") != "loss_of_control"
	object.get(exit_info, "reason", "") != "revision_clause"
	object.get(exit_info, "reason", "") != "permanent_circumstances_accepted"
	object.get(exit_info, "reason", "") != "measure_switch"
}

# Abmeldung im laufenden Jahr: Maßnahme im betroffenen Förderjahr nicht mehr gültig
no_premium_current_year_due_to_exit if {
	exit_info != null
	date_year(exit_info.date) == year
}

# --- Nichterfüllung von Zugangsvoraussetzungen (SRL 1.12.1.1) -------------------------------

access_violation_ids := {"O61B-ZT-001", "O61B-ATB-001", "O61B-ATB-002", "O61B-ATB-003", "O61B-VZ-003", "O61B-AN-001", "O61B-AN-002", "O61B-TB-001", "O61B-TB-005"}

access_requirements_failed if {
	some v in violations
	v.rule_id in access_violation_ids
}

access_failure_consequence := "no_contract" if {
	access_requirements_failed
	contract_start_year == year
}

access_failure_consequence := "no_premium_this_year" if {
	access_requirements_failed
	contract_start_year != year
}

# --- Kürzungsstufen (ATB 8.2) ------------------------------------------------------------------

sanction_level := object.get(o6_1b_input, "sanction_level", null)

sanction_reduction_percent := s.reduction_percent if {
	sanction_level != null
	some s in general.sanction_levels
	s.level == sanction_level
	sanction_year_applicable(s)
}

sanction_year_applicable(s) if {
	not s.until_year
	not s.from_year
}

sanction_year_applicable(s) if year <= s.until_year

sanction_year_applicable(s) if year >= s.from_year

exclusion_from_measure if object.get(o6_1b_input, "full_reductions_in_contract_period", 0) >= 2

# --- Auszahlung (ATB 9.1; SRL 1.10.7) -----------------------------------------------------------

payment_deadline := sprintf("%d-%s", [year + 1, general.payment.deadline_month_day])

max_advance_payment := premium_total_modulated * general.payment.advance_max_share
