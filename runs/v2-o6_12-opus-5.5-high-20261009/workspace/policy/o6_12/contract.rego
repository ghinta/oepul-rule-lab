package oepul.o6_12

# Vertragszeitraum, Ausstieg, Maßnahmenwechsel, Flächenänderungen, Übernahme, höhere Gewalt
# und Sonderregelungen 2026.

rebzikade := data.o6_12.rebzikade_2026

# --- Rückzahlungsfreier Ausstieg wegen Amerikanischer Rebzikade (Hinweis 12.06.2026) --

rebzikade_exit_conditions_unmet contains "exit_not_requested" if not exit_requested

rebzikade_exit_conditions_unmet contains "reason_not_rebzikade" if {
	exit_requested
	exit_obj.reason != "rebzikade_2026"
}

rebzikade_exit_conditions_unmet contains "before_application_year_2026" if {
	exit_requested
	to_number(substring(exit_obj.request_date, 0, 4)) < rebzikade.exit_available_from_application_year
}

rebzikade_exit_conditions_unmet contains "farm_has_no_vineyard" if {
	exit_requested
	not has_vineyard
}

rebzikade_exit_conditions_unmet contains "not_submitted_via_force_majeure_form" if {
	exit_requested
	not exit_obj.submitted_via_force_majeure_form == true
}

rebzikade_exit_conditions_unmet contains "control_reason_not_stated" if {
	exit_requested
	not exit_obj.rebzikade_reason_stated == true
}

rebzikade_exit_conditions_unmet contains "not_approved" if {
	exit_requested
	exit_obj.approved == false
}

rebzikade_exit_without_repayment if {
	participates
	count(rebzikade_exit_conditions_unmet) == 0
}

rebzikade_exit_year := to_number(substring(exit_obj.request_date, 0, 4)) if rebzikade_exit_without_repayment

# Ende des ursprünglichen Vertragszeitraums mit Beginn der einzelbetrieblichen Meldung.
contract_end_date := exit_obj.request_date if rebzikade_exit_without_repayment

else := params.contract_end_date

# --- Regulärer Ausstieg (Allg. TNB 6, 7.1; SRL 1.7.2) --------------------------

bio_switch := object.get(o612, "switch_to_bio", {})

bio_switch_without_repayment if {
	bio_switch.requested == true
	date_on_or_before(bio_switch.application_date, data.o6_12.measure_switches[0].latest_contract_change)
}

# Abmeldung während des Jahres: Maßnahme im betroffenen Förderjahr nicht mehr gültig.
exit_in_current_year if {
	exit_requested
	to_number(substring(exit_obj.request_date, 0, 4)) == year
}

# Ausstieg ist bis zur Ankündigung/Durchführung einer Vor-Ort-Kontrolle bzw. Mitteilung einer Verwaltungskontrolle möglich.
exit_timely if {
	exit_requested
	not o612.control_announced_date
}

exit_timely if {
	exit_requested
	date_ns(exit_obj.request_date) < date_ns(o612.control_announced_date)
}

regular_exit_before_contract_end if {
	exit_requested
	not rebzikade_exit_without_repayment
	date_ns(exit_obj.request_date) < date_ns(params.contract_end_date)
	not bio_switch_without_repayment
}

# Rückforderung der bisher gewährten Maßnahmenprämien bis Vertragsbeginn.
repayment_required_reasons contains "exit_before_contract_end" if regular_exit_before_contract_end

repayment_required_reasons contains "payment_application_missing_over_one_year" if {
	participates
	o612.payment_application_missing_over_one_year == true
}

repayment_required_reasons contains "excluded_after_second_full_reduction" if excluded_from_measure

repayment_required_reasons contains "control_refused" if {
	participates
	o612.control_refused == true
}

# Nach Ausstieg, Ausschluss oder einjähriger Nichtabgabe: Wiedereinstieg nur mit neuem Maßnahmenantrag;
# bei Maßnahme 12 war der letzte Einstieg mit Förderjahr 2025 möglich.
reentry_possible if {
	new_entry_possible_for_contract_start(year + 1)
}

# --- Jährlicher Zahlungsantrag (SRL 1.10.5.3) ----------------------------------

annual_payment_application_missing if {
	participates
	year > o612.contract_start_year
	o612.annual_application_submitted == false
}

# Verpflichtung bleibt aufrecht, für das Jahr erfolgt keine Zahlung.
commitment_continues_without_payment if {
	annual_payment_application_missing
	not o612.payment_application_missing_over_one_year == true
}

# --- Flächenänderungen (SRL 1.7.2.3 - 1.7.2.5) --------------------------------

tolerance := data.o6_12.area_reduction_tolerance

area_reduction_tolerance_ha(previous_ha) := max([min([tolerance.max_share_of_previous_year_area * previous_ha, tolerance.max_ha_per_year]), tolerance.always_allowed_ha_per_year])

area_reduction_ha := max([o612.previous_year_area_ha - eligible_area_ha, 0])

general_area_reduction_within_tolerance if {
	area_reduction_ha <= area_reduction_tolerance_ha(o612.previous_year_area_ha)
}

# Bei Maßnahme 12 sind die Flächen an die jährlich verfügbaren Wein-, Obst- und Hopfenflächen gebunden.
area_reduction_repayment_required if {
	not params.premium_area_bound_annually
	o612.area_reduction_cause != "loss_of_control"
	not general_area_reduction_within_tolerance
}

area_variation_permitted if params.premium_area_bound_annually

# Flächenzugänge unterliegen bei Maßnahme 12 keiner Prämienbeschränkung.
area_additions_fully_eligible if not params.subject_to_area_addition_limit

# --- Maßnahmenübernahme (SRL 1.7.3.1, Allg. TNB 6.3) ---------------------------

takeover := object.get(o612, "takeover", {})

takeover_deadline(yr) := sprintf("%d-%s", [yr, data.o6_12.takeover_rules.deadline_month_day_special_years]) if {
	yr in {y | some y in data.o6_12.takeover_rules.special_years}
}

takeover_deadline(yr) := sprintf("%d-%s", [yr, data.o6_12.takeover_rules.deadline_month_day]) if {
	not yr in {y | some y in data.o6_12.takeover_rules.special_years}
}

takeover_issues contains "submitted_after_deadline" if {
	takeover.is_takeover == true
	not date_on_or_before(takeover.submission_date, takeover_deadline(year))
}

takeover_issues contains "extension_exceeds_50_percent" if {
	takeover.is_takeover == true
	takeover.additional_area_ha > data.o6_12.takeover_rules.max_extension_share_of_taken_over_area * takeover.taken_over_area_ha
}

takeover_issues contains "taker_already_participating" if {
	takeover.is_takeover == true
	takeover.taker_previously_participating == true
}

takeover_issues contains "not_approved_by_ama" if {
	takeover.is_takeover == true
	takeover.approved_by_ama == false
}

takeover_valid if {
	takeover.is_takeover == true
	count(takeover_issues) == 0
}

# --- Betriebsübertragung (SRL 1.7.2.2, § 14 Abs. 2 GSP-AV) ----------------------

farm_transfer := object.get(o612, "farm_transfer", {})

farm_transfer_issues contains "commitment_not_continued" if {
	farm_transfer.occurred == true
	farm_transfer.successor_continues_commitment == false
}

farm_transfer_issues contains "notification_later_than_4_weeks" if {
	farm_transfer.occurred == true
	date_ns(farm_transfer.notification_date) > time.add_date(date_ns(farm_transfer.effective_date), 0, 0, 28)
}

# --- Höhere Gewalt (§ 6 GSP-AV, SRL 1.7.4.1) ------------------------------------

force_majeure := object.get(o612, "force_majeure", {})

force_majeure_case_recognised if {
	some c in data.o6_12.force_majeure_cases
	c.case_id == force_majeure.case_id
}

force_majeure_claim_timely if {
	date_ns(force_majeure.claim_date) <= time.add_date(date_ns(force_majeure.able_to_notify_date), 0, 0, 7 * data.o6_12.force_majeure_rules.notification_weeks)
}

force_majeure_premium_retained if {
	force_majeure_case_recognised
	force_majeure_claim_timely
	force_majeure.documented == true
}

# Behördlich angeordnete Bekämpfung von Pflanzenkrankheiten gilt als höhere Gewalt (§ 6 Abs. 1 Z 5 GSP-AV).
official_disease_order_is_force_majeure if force_majeure.case_id == "official_disease_order"

# --- Dauerhafte / vorübergehende Umstände (SRL 1.7.4.2, 1.7.4.3) ------------------

circumstance := object.get(o612, "circumstance", {})

circumstance_no_repayment if {
	circumstance.type in {"permanent", "temporary"}
	circumstance.beyond_control == true
	circumstance.notified == true
}

permanent_circumstance_premium_in_event_year if {
	circumstance.type == "permanent"
	circumstance_no_repayment
	date_ns(circumstance.event_date) > date_ns(sprintf("%s-04-15", [substring(circumstance.event_date, 0, 4)]))
}

permanent_circumstance_premium_in_event_year if {
	circumstance.type == "permanent"
	circumstance_no_repayment
	force_majeure_premium_retained
}

temporary_circumstance_premium_in_year if {
	circumstance.type == "temporary"
	circumstance_no_repayment
	circumstance.conditions_met_on_changed_areas == true
}

temporary_circumstance_premium_in_year if {
	circumstance.type == "temporary"
	circumstance_no_repayment
	force_majeure_premium_retained
}

# --- Revisionsklausel (SRL 1.7.5) ----------------------------------------------

revision_clause_exit_without_repayment if o612.contract_adjustment_refused == true

# --- Aufbewahrung (§ 16 GSP-AV) -------------------------------------------------

records_retention_until := sprintf("%d-12-31", [to_number(substring(contract_end_date, 0, 4)) + 4])

# --- Dürre 2026: automatische Anerkennung Ernteverpflichtung nur für Ackerkulturen --

drought_district_listed(state, district) if {
	some d in data.o6_12.drought_2026_harvest_districts
	d.federal_state == state
	d.district in {"*", district}
}

drought_2026_automatic_harvest_exemption(p) if {
	year == 2026
	p.land_use_code == "A"
	drought_district_listed(input.farm.region.federal_state, input.farm.region.district)
}

# Für Wein-, Obst- und Hopfenflächen der Maßnahme 12 greift die automatische Anerkennung nicht;
# eine nicht erfüllte Ernteverpflichtung erfordert ein einzelbetriebliches Ansuchen.
individual_force_majeure_claim_needed contains p.parcel_id if {
	participates
	some p in parcels
	is_wine_fruit_hop_parcel(p)
	object.get(p, ["minimum_management", "harvested"], true) == false
	not drought_2026_automatic_harvest_exemption(p)
}
