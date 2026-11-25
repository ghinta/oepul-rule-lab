# Allgemeine ÖPUL-Teilnahmebedingungen (Merkblatt Stand April 2026, SRL Allgemeiner Teil), soweit für EBW relevant.
package oepul.o6_19

import rego.v1

oepul := object.get(input, "oepul", {})

applicant := object.get(oepul, "applicant", {})

# R-O619-GEN-FARM-MIN-SIZE: im 1. ÖPUL-Teilnahmejahr mind. 1,50 ha LN oder 0,50 ha geschützter Anbau.
is_first_oepul_year if oepul.first_oepul_participation_year == year

farm_min_size_met if num(input.land.total_area_ha) >= general_tables.farm_min_size.agricultural_area_ha

farm_min_size_met if num(object.get(oepul, "protected_cultivation_area_ha", 0)) >= general_tables.farm_min_size.protected_cultivation_ha

general_violations contains {"rule_id": "R-O619-GEN-FARM-MIN-SIZE", "message": "Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr nicht erreicht."} if {
	is_first_oepul_year
	not farm_min_size_met
}

# R-O619-GEN-APPLICANT: Gebietskörperschaften ausgeschlossen (EBW nicht unter den Ausnahmen); Beteiligung > 25 % schädlich.
general_violations contains {"rule_id": "R-O619-GEN-APPLICANT", "message": "Gebietskörperschaften und deren Einrichtungen kommen für EBW nicht als förderwerbende Personen in Betracht."} if {
	applicant.type == "public_body"
	not params.measure_code in general_tables.public_body_exception_measures
}

general_violations contains {"rule_id": "R-O619-GEN-APPLICANT", "message": "Beteiligung von Gebietskörperschaften übersteigt 25 %."} if {
	applicant.type in {"legal_person", "association"}
	num(object.get(applicant, "public_body_share_percent", 0)) > general_tables.public_body_max_share_percent
}

general_violations contains {"rule_id": "R-O619-GEN-APPLICANT", "message": "Förderwerbende Person muss aktive Landwirtin bzw. aktiver Landwirt sein."} if applicant.active_farmer == false

# R-O619-GEN-CONTROL-REFUSAL: Verweigerung/Verhinderung der Vor-Ort-Kontrolle -> Ablehnung, keine Prämie, Vertragsbeendigung.
general_violations contains {"rule_id": "R-O619-GEN-CONTROL-REFUSAL", "message": "Kontrolle verweigert oder verhindert: Antrag abzulehnen, Verträge beendet und rückabgewickelt."} if {
	oepul.control_refused == true
	not oepul.force_majeure_recognised == true
}

# R-O619-GEN-AREA-DECREASE: zulässige Verringerung max(min(5 %, 5 ha), 0,5 ha) bezogen auf die Vorjahresfläche.
previous_year_area := object.get(ebw, "previous_year_ebw_area_ha", null)

current_ebw_committed_area := sum([num(p.area_ha) | some _, p in ebw_parcels])

area_decrease_ha := max([0, (previous_year_area - current_ebw_committed_area) - num(object.get(ebw, "area_decrease_exempt_ha", 0))]) if is_number(previous_year_area)

area_decrease_tolerance_ha := max([
	min([(previous_year_area * general_tables.area_decrease_tolerance.percent) / 100, general_tables.area_decrease_tolerance.max_ha]),
	general_tables.area_decrease_tolerance.min_ha,
]) if {
	is_number(previous_year_area)
}

# Bei Überschreitung besteht für die gesamte Differenzfläche Rückzahlungspflicht.
area_decrease_repayment_area_ha := area_decrease_ha if area_decrease_ha > area_decrease_tolerance_ha

default area_decrease_repayment_area_ha := 0

# R-O619-GEN-EARLY-EXIT: Ausstieg vor Vertragsende -> Rückforderung bereits gewährter Maßnahmenprämien.
repayment_of_past_premiums_required if ebw.exited_before_contract_end == true

repayment_of_past_premiums_required if excluded_from_measure

# R-O619-GEN-PAYMENT-CLAIM-MISSING: verabsäumter Zahlungsantrag > 1 Jahr -> Verpflichtung endet, Rückzahlung.
repayment_of_past_premiums_required if ebw.payment_claim_missing_over_one_year == true

# R-O619-GEN-DEREGISTRATION: Abmeldung im laufenden Jahr -> Maßnahme im betroffenen Förderjahr nicht mehr gültig.
measure_valid_this_year if not ebw.deregistered_in_year == true

# R-O619-GEN-SWITCH: Umwandlung EBW <-> Naturschutz (und in EBW aus 4, 8-BAW, 16-AG) bis spätestens 31.12.2025 ohne Rückzahlung.
switch_request := object.get(ebw, "switch", null)

switch_allowed if {
	some s in general_tables.measure_switches
	s.from == switch_request.from
	switch_request.to in s.to
	date_lte(switch_request.effective_date, general_tables.measure_switch_deadline)
}

# R-O619-GEN-TAKEOVER: Übernahme bis 15.04. (2023/2028: 17.04.), Ausweitung max. 50 %, Regionaler Naturschutzplan nur in Einzelfällen.
takeover := object.get(ebw, "takeover", null)

takeover_deadline(y) := sprintf("%d-%s", [y, general_tables.takeover.deadline_mm_dd_2023_2028]) if y in {2023, 2028}

takeover_deadline(y) := sprintf("%d-%s", [y, general_tables.takeover.deadline_mm_dd]) if not y in {2023, 2028}

takeover_allowed if {
	is_object(takeover)
	date_lte(takeover.date, takeover_deadline(year))
	num(takeover.expansion_share) <= general_tables.takeover.max_expansion_share
	not takeover.includes_regional_plan == true
}

takeover_allowed if {
	is_object(takeover)
	date_lte(takeover.date, takeover_deadline(year))
	num(takeover.expansion_share) <= general_tables.takeover.max_expansion_share
	takeover.includes_regional_plan == true
	takeover.farm_dissolution_split_or_merger == true
}

# R-O619-GEN-MIN-MGMT-EXEMPT: EBW-Grünbrachen sind von den Mindestbewirtschaftungskriterien ausgenommen.
min_management_criteria_exempt[pid] if {
	some pid, p in ebw_parcels
	parcel_usage_type(p) == params.set_aside_usage_type
}

# R-O619-GEN-TRANSFER: unterjährige Weitergabe nur bei Weiterführung durch den Übernehmer, sonst Code OP / keine Prämie.
transfer_requires_op_code[pid] if {
	some pid, p in ebw_parcels
	object.get(p, ["oepul", "transferred_during_year"], false) == true
	not object.get(p, ["oepul", "successor_continues_commitment"], false) == true
	not has_code(p, "OP")
}

# R-O619-GEN-FORCE-MAJEURE: dauerhafte/vorübergehende Umstände -> keine Rückforderung bei rechtzeitiger Meldung.
circumstance := object.get(ebw, "circumstance", null)

no_repayment_due_to_circumstance if {
	is_object(circumstance)
	circumstance.outside_control == true
	circumstance.reported_in_time == true
}

premium_in_circumstance_year if {
	is_object(circumstance)
	circumstance.kind == "force_majeure"
}

premium_in_circumstance_year if {
	is_object(circumstance)
	circumstance.kind == "permanent"
	date_lte(sprintf("%d-04-16", [year]), circumstance.occurred_date)
}

premium_in_circumstance_year if {
	is_object(circumstance)
	circumstance.kind == "temporary"
	circumstance.conditions_met_on_changed_areas == true
}

# R-O619-GEN-PAYMENT-TIMING: Auszahlung bis 30.06. des Folgejahres, Vorschuss max. 75 %.
payment_deadline := sprintf("%d-%s", [year + 1, general_tables.payment_deadline_mm_dd_following_year])

max_advance_payment_eur := round2(measure_premium_eur * general_tables.advance_payment_max_share)
