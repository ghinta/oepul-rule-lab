# o6_4 – Antragstellung, Vertragszeitraum, Flächenänderungen, Umstieg, Ausstieg, höhere Gewalt und Sanktionen
package oepul.o6_4

import rego.v1

# O64-CON-001: Vertragszeitraum je Vertragsbeginn (bis 31.12.2028)
contract_period := cp if {
	some cp in cfg.contract_periods
	cp.start_date == measure_input.contract_start_date
}

contract_failures contains f if {
	is_string(measure_input.contract_start_date)
	not contract_period
	f := {"rule_id": "O64-APP-002", "message": sprintf("Vertragsbeginn %v nicht zulässig (Einstieg nur 01.01.2023, 01.01.2024 oder 01.01.2025)", [measure_input.contract_start_date])}
}

# O64-APP-001: Maßnahmenantrag bis 31.12. vor Vertragsbeginn (keine Fristverschiebung, § 5 Abs. 2 GSP-AV)
application_deadline := sprintf("%d-12-31", [contract_start_year - 1])

application_timely if measure_input.application_date <= application_deadline

contract_failures contains f if {
	is_string(measure_input.application_date)
	is_number(contract_start_year)
	not application_timely
	f := {"rule_id": "O64-APP-001", "message": sprintf("Maßnahmenantrag vom %v nach der Frist %v", [measure_input.application_date, application_deadline])}
}

# O64-APP-002: letzter Einstieg Förderjahr 2025 (Antrag bis 31.12.2024)
contract_failures contains f if {
	is_number(contract_start_year)
	contract_start_year > cfg.measure.last_entry_funding_year
	f := {"rule_id": "O64-APP-002", "message": "Einstieg nach dem Förderjahr 2025 nicht mehr möglich"}
}

contract_missing contains field if {
	some field in ["application_date", "contract_start_date"]
	object.get(measure_input, field, null) == null
}

contract_active if {
	count(contract_failures) == 0
	count(contract_missing) == 0
	contract_start_year <= year
	year <= date_year(cfg.measure.contract_end_date)
}

# O64-APP-003: Umstieg in Naturschutz (18) oder Ergebnisorientierte Bewirtschaftung (19) bis 31.12.2025
conversion := object.get(measure_input, "conversion", null)

conversion_valid if {
	is_object(conversion)
	some t in cfg.conversion_targets
	t.measure_number == conversion.target_measure_number
	conversion.contract_change_date <= t.deadline
}

contract_failures contains f if {
	is_object(conversion)
	not conversion_valid
	f := {"rule_id": "O64-APP-003", "message": "Umstieg nur in Naturschutz oder Ergebnisorientierte Bewirtschaftung mit Vertragswechsel spätestens 31.12.2025 möglich"}
}

converted_parcels contains pid if {
	conversion_valid
	some pid in object.get(conversion, "parcel_ids", [])
}

# O64-GEN-013..016: Ausstieg (Abmeldung) aus der mehrjährigen Maßnahme
exit_date := object.get(measure_input, "exit_date", null)

exit_in_current_year if {
	is_string(exit_date)
	date_year(exit_date) == year
}

exit_blocked_by_control if {
	is_string(exit_date)
	announced := object.get(measure_input, "control_announced_or_notified_date", null)
	is_string(announced)
	announced <= exit_date
}

exit_repayment_required if {
	is_string(exit_date)
	not exit_blocked_by_control
	not conversion_valid
	not object.get(measure_input, "exit_without_repayment_recognized", false)
}

# O64-GEN-019..022: Flächenabgang – Toleranz 5 %, höchstens 5 ha, jedenfalls 0,5 ha
area_decrease_ha := d if {
	prev := measure_input.area_previous_year_ha
	curr := measure_input.area_current_year_ha
	lost := object.get(measure_input, "area_lost_disposal_ha", 0)
	conv := object.get(measure_input, "area_allowed_conversion_ha", 0)
	d := max([0, ((prev - curr) - lost) - conv])
}

area_decrease_tolerance_ha := t if {
	prev := measure_input.area_previous_year_ha
	ac := cfg.area_change
	t := max([ac.decrease_tolerance_min_ha, min([(prev * ac.decrease_tolerance_percent) / 100, ac.decrease_tolerance_max_ha])])
}

area_decrease_repayment_ha := area_decrease_ha if area_decrease_ha > area_decrease_tolerance_ha

# O64-GEN-023: Flächenzugang – 2024/2025 zur Gänze, danach max. 50 % auf Basis 2025, jedenfalls 5 ha
area_increase_limit_ha := lim if {
	year > cfg.area_change.increase_base_year
	base := measure_input.area_2025_ha
	inc := max([(base * cfg.area_change.increase_max_percent) / 100, cfg.area_change.increase_min_ha])
	lim := (base + inc) + object.get(measure_input, "area_additions_previously_committed_ha", 0)
}

# O64-GEN-018: Maßnahmenübernahme bis 15.04. (2023 und 2028: 17.04.), Ausweitung max. 50 %
takeover := object.get(measure_input, "takeover", null)

takeover_deadline(y) := sprintf("%d-%v", [y, cfg.takeover.deadline_month_day_2023_2028]) if {
	y in {cfg.takeover.special_year_first, cfg.takeover.special_year_last}
} else := sprintf("%d-%v", [y, cfg.takeover.deadline_month_day])

takeover_failures contains f if {
	is_object(takeover)
	takeover.date > takeover_deadline(date_year(takeover.date))
	f := {"rule_id": "O64-GEN-018", "message": "Maßnahmenübernahme nach dem 15. April (2023/2028: 17. April)"}
}

takeover_failures contains f if {
	is_object(takeover)
	takeover.taker_previously_participating == true
	f := {"rule_id": "O64-GEN-018", "message": "Übernahme nur durch einen bisher nicht an der Maßnahme teilnehmenden Betrieb"}
}

takeover_failures contains f if {
	is_object(takeover)
	takeover.extension_area_ha > (takeover.taken_over_area_ha * cfg.area_change.takeover_max_extension_percent) / 100
	f := {"rule_id": "O64-GEN-018", "message": "Ausweitung auf andere Flächen um mehr als 50 %"}
}

# O64-GEN-030/031: höhere Gewalt – Meldung binnen 3 Wochen, belegt
fm_claims := object.get(input, ["oepul", "force_majeure_claims"], [])

fm_claim_recognized(c) if {
	object.get(c, "documented", false) == true
	deadline_ns := time.add_date(time.parse_ns("2006-01-02", c.able_to_report_date), 0, 0, 7 * cfg.deadlines.force_majeure_notification_weeks)
	time.parse_ns("2006-01-02", c.reported_date) <= deadline_ns
}

fm_claim_recognized(c) if object.get(c, "automatically_recognized", false) == true

excused(v) if {
	some c in fm_claims
	fm_claim_recognized(c)
	v.parcel_id in object.get(c, "parcel_ids", [])
}

# O64-GEN-025/026: Sanktionsstufen bei inhaltlichen Verstößen
level_percent(0) := 1 if year >= 2027

level_percent(0) := 0 if year < 2027

level_percent(l) := pct if {
	l > 0
	some s in cfg.sanction_levels
	s.level == l
	pct := s.reduction_percent
}

finding_percent(f) := level_percent(min([6, f.level + object.get(f, "prior_occurrences_same_obligation", 0)]))

content_reduction_percent := min([
	cfg.sanction_rules.max_cumulated_reduction_percent,
	sum([finding_percent(f) | some f in object.get(measure_input, "assessed_findings", [])]),
])

excluded_from_measure if {
	object.get(measure_input, "full_reductions_in_period", 0) >= cfg.sanction_rules.exclusion_after_full_reductions
}

# O64-GEN-032: Verweigerung der Vor-Ort-Kontrolle
control_refused if object.get(measure_input, "on_site_control_refused", false) == true

# O64-GEN-034: verabsäumter Zahlungsantrag
payment_claim_missing if object.get(measure_input, "payment_claim_submitted", true) == false

payment_claim_obligation_ended if {
	payment_claim_missing
	object.get(measure_input, "payment_claim_overdue_more_than_one_year", false) == true
}

# O64-GEN-035: Übererklärung > 3 % oder > 2 ha → Kürzung um das 1,5fache der Differenz
over_declaration_sanction_ha := s if {
	declared := measure_input.declared_area_ha
	determined := measure_input.determined_area_ha
	diff := declared - determined
	diff > 0
	over_declaration_relevant(diff, determined)
	s := cfg.sanction_rules.over_declaration_factor * diff
}

over_declaration_relevant(diff, determined) if diff > (determined * cfg.sanction_rules.over_declaration_threshold_percent) / 100

over_declaration_relevant(diff, _) if diff > cfg.sanction_rules.over_declaration_threshold_ha

# O64-2026-001: keine o6_4-spezifische Ausnahmeregelung in den AMA-Hinweisen 2026
notices_2026_o6_4_derogation := false
