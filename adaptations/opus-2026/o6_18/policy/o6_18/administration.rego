# METADATA
# title: ÖPUL 2023 Naturschutz (18) – Vertragsabwicklung, Flächenänderungen, Ausstieg, Sanktionen
package oepul.o6_18.administration

import data.oepul.o6_18.lib

p := lib.params

y := lib.year

nat := lib.nat

current_area := sum([lib.area(parcel) | some parcel in lib.nat_parcels])

# O618-ADM-001: Toleranz für Flächenverringerung (5 %, max. 5 ha, jedenfalls 0,50 ha) auf Basis Vorjahresfläche.
previous_area := object.get(nat, "area_previous_year_ha", null)

tolerated_decrease_ha := lib.max2(lib.min2(p.area_decrease_tolerance.max_share * previous_area, p.area_decrease_tolerance.max_ha), p.area_decrease_tolerance.always_allowed_ha) if previous_area != null

# O618-ADM-002: Verlust der Verfügungsgewalt (Übertragung an andere Person) und zulässige Umwandlungen führen zu keiner Rückzahlung.
exempt_decrease_ha := object.get(nat, "area_lost_disposal_right_ha", 0) + object.get(nat, "area_permitted_conversion_ha", 0)

relevant_decrease_ha := lib.max2(0, (previous_area - current_area) - exempt_decrease_ha) if previous_area != null

repayment_area_ha := relevant_decrease_ha if {
	relevant_decrease_ha > tolerated_decrease_ha
}

repayment_area_ha := 0 if {
	relevant_decrease_ha <= tolerated_decrease_ha
}

findings contains f if {
	repayment_area_ha > 0
	f := {"rule_id": "O618-ADM-001", "message": sprintf("Flächenverringerung %.2f ha über Toleranz %.2f ha – Rückzahlung für gesamte Differenzfläche", [relevant_decrease_ha, tolerated_decrease_ha])}
}

# O618-ADM-003: Wechsel der bewirtschaftenden Person – Flächen sind weiterzuführen, Nachfolger tritt dem Vertrag bei.
findings contains f if {
	object.get(nat, "operator_change", false)
	f := {"rule_id": "O618-ADM-003", "message": "Bewirtschafterwechsel: Verpflichtung weiterführen, Nachfolger tritt Fördervertrag bei (solidarische Haftung)"}
}

exit := object.get(nat, "exit", {})

# O618-ADM-004: Ausstieg vor Ende des Vertragszeitraumes führt zur Rückforderung bereits gewährter Prämien.
repayment_of_granted_premiums if {
	object.get(exit, "exited", false)
	object.get(exit, "exit_year", 2029) <= 2028
	not repayment_waived
}

# O618-ADM-013/014: Keine Rückforderung bei gemeldeten dauerhaften Umständen, höherer Gewalt oder Ablehnung einer Vertragsanpassung (Revisionsklausel).
repayment_waived if object.get(exit, "revision_clause_refusal", false)

repayment_waived if {
	object.get(exit, "permanent_circumstance", false)
	object.get(exit, "reported_in_time", false)
}

repayment_waived if object.get(exit, "force_majeure_recognised", false)

premium_in_event_year if {
	object.get(exit, "permanent_circumstance", false)
	object.get(exit, "event_date", "9999-12-31") > sprintf("%d-04-15", [y])
}

premium_in_event_year if object.get(exit, "force_majeure_recognised", false)

# O618-ADM-005: Abmeldung im laufenden Jahr – Maßnahme im betroffenen Förderjahr nicht mehr gültig; Ausstieg bis zur Ankündigung einer VOK.
measure_valid_this_year if not deregistered_this_year

deregistered_this_year if object.get(exit, "exit_year", 0) == y

findings contains f if {
	object.get(exit, "exited", false)
	object.get(exit, "on_site_control_announced_before_exit", false)
	f := {"rule_id": "O618-ADM-005", "message": "Ausstieg nach Ankündigung/Durchführung einer Vor-Ort-Kontrolle nicht mehr möglich"}
}

# O618-ADM-006: Wiedereinstieg nach Ausstieg/Ausschluss/Nichtabgabe nur mit neuerlichem Maßnahmenantrag.
reentry_requires_new_application if object.get(exit, "exited", false)

reentry_requires_new_application if object.get(nat, "excluded", false)

reentry_requires_new_application if object.get(nat, "mfa_not_submitted_previous_year", false)

# O618-ADM-007: Maßnahmenwechsel NAT -> EBW bis spätestens 31.12.2025; Umwandlungen in NAT laut Tabelle.
switch := object.get(nat, "switch_to_ebw", {})

violations contains v if {
	object.get(switch, "requested", false)
	object.get(switch, "switch_date", "") > p.switch_to_ebw_until
	v := {"rule_id": "O618-ADM-007", "message": "Umstieg in Ergebnisorientierte Bewirtschaftung nur bis 31.12.2025"}
}

switch_into_nat_allowed(from_id, date) if {
	some row in data.o6_18.measure_switch_table.rows
	row.from_id == from_id
	"18" in row.to
	date <= row.until
}

# O618-ADM-008: Maßnahmenübernahme bis 15.04. (2023/2028: 17.04.), Ausweitung max. 50 %; Regionaler Naturschutzplan nur bei Betriebsauflösung/-teilung/-zusammenlegung.
takeover := object.get(nat, "takeover", {})

takeover_deadline := sprintf("%d-%v", [y, p.takeover.deadline_exception_years[sprintf("%d", [y])]])

takeover_deadline := sprintf("%d-%v", [y, p.takeover.deadline_month_day]) if {
	not p.takeover.deadline_exception_years[sprintf("%d", [y])]
}

violations contains v if {
	object.get(takeover, "requested", false)
	object.get(takeover, "date", "") > takeover_deadline
	v := {"rule_id": "O618-ADM-008", "message": sprintf("Maßnahmenübernahme nach Frist %v", [takeover_deadline])}
}

violations contains v if {
	object.get(takeover, "requested", false)
	taken := object.get(takeover, "taken_over_area_ha", 0)
	taken > 0
	object.get(takeover, "expansion_area_ha", 0) > p.takeover.max_expansion_share * taken
	v := {"rule_id": "O618-ADM-008", "message": "Maßnahmenübernahme führt zu Ausweitung auf andere Flächen um mehr als 50 %"}
}

violations contains v if {
	object.get(takeover, "includes_regional_plan", false)
	not object.get(takeover, "reason", null) in p.takeover.regional_plan_only_on
	v := {"rule_id": "O618-ADM-008", "message": "Übernahme des Zuschlags Regionaler Naturschutzplan nur bei Betriebsauflösung, -teilung oder -zusammenlegung"}
}

# O618-ADM-009: Sanktionsstufen; ab 2027 Einbehalt 1 % statt Verwarnung; Ausschluss bei zweimaliger 100 %-Kürzung.
sanction_share(level) := row.reduction_share if {
	some row in p.sanction_levels
	row.level == level
	object.get(row, "from_year", 0) <= y
	y <= object.get(row, "until_year", 9999)
}

sanction_share("warning") := 0.01 if y >= 2027

excluded if object.get(nat, "hundred_percent_reductions_in_contract_period", 0) >= 2

findings contains f if {
	excluded
	f := {"rule_id": "O618-ADM-009", "message": "Ausschluss aus der Maßnahme und Rückforderung der im Vertragszeitraum gewährten Prämien (zweimalige 100 %-Kürzung)"}
}

# O618-ADM-010: Nichterfüllung von Zugangsvoraussetzungen: im 1. Jahr kein Vertrag; ab 2. Jahr keine Prämie im betroffenen Jahr.
access_failure_consequence := "no_contract" if {
	object.get(nat, "access_requirements_failed", false)
	y == nat.contract_start_year
}

access_failure_consequence := "no_premium_this_year" if {
	object.get(nat, "access_requirements_failed", false)
	y > nat.contract_start_year
}

# O618-ADM-011: Verweigerung der Vor-Ort-Kontrolle – Antrag abgelehnt, Verträge beendet und rückabgewickelt.
findings contains f if {
	object.get(nat, "refused_on_site_control", false)
	not object.get(nat, "refusal_force_majeure", false)
	f := {"rule_id": "O618-ADM-011", "message": "Kontrollverweigerung: keine Prämie im laufenden Jahr, Verträge beendet und rückabgewickelt"}
}

# O618-ADM-012: Nicht beantragte Folgejahre – Verpflichtung bleibt, keine Zahlung; nach > 1 Jahr endet sie mit Rückzahlung.
missed := object.get(nat, "payment_claim_missed_since_year", null)

payment_claim_consequence := "obligation_remains_no_payment" if {
	missed != null
	y - missed < p.late_payment_claim_limit_years
}

payment_claim_consequence := "obligation_ends_full_repayment" if {
	missed != null
	y - missed >= p.late_payment_claim_limit_years
}

# O618-ADM-015: Nichterfüllung durch reines Fremdverschulden: maßnahmenbezogener OP-Code, keine Prämie am Schlag; sonst Code löschen oder Selbstanzeige.
violations contains v if {
	some parcel in lib.nat_parcels
	object.get(parcel, ["naturschutz", "noncompliance", "occurred"], false)
	object.get(parcel, ["naturschutz", "noncompliance", "third_party_fault"], false)
	not lib.has_code(parcel, "OPNAT")
	not lib.has_code(parcel, "OP")
	v := {"rule_id": "O618-ADM-015", "message": sprintf("Schlag %v: Fremdverschulden – maßnahmenbezogenen OP-Code vergeben", [parcel.parcel_id])}
}

violations contains v if {
	some parcel in lib.nat_parcels
	object.get(parcel, ["naturschutz", "noncompliance", "occurred"], false)
	not object.get(parcel, ["naturschutz", "noncompliance", "third_party_fault"], false)
	not object.get(parcel, ["naturschutz", "noncompliance", "self_reported"], false)
	v := {"rule_id": "O618-ADM-015", "message": sprintf("Schlag %v: Verstoß ohne Fremdverschulden – NAT-Code löschen oder Selbstanzeige", [parcel.parcel_id])}
}

# O618-ADM-017: Unterjährige Weitergabe nur prämienfähig, wenn Nachfolger die Auflagen bis Jahresende weiterführt (sonst OP-Code).
violations contains v if {
	some parcel in lib.nat_parcels
	object.get(parcel, ["oepul", "transferred_during_year"], false)
	not object.get(parcel, ["oepul", "successor_continues_until_year_end"], false)
	not lib.has_code(parcel, "OP")
	not lib.has_code(parcel, "OPNAT")
	v := {"rule_id": "O618-ADM-017", "message": sprintf("Schlag %v: unterjährige Weitergabe ohne Weiterführung – OP-Code erforderlich", [parcel.parcel_id])}
}

# O618-ADM-018: Unmögliche Maßnahmenkombinationen bis zur Auszahlungsmitteilung korrigierbar (ohne VOK-Beanstandung).
combination_correction_possible if {
	not object.get(nat, "payment_notice_received", false)
	not object.get(nat, "on_site_control_objection", false)
}

# O618-ADM-021: Versuchsflächen (Code VF) – schriftliche Genehmigung, Dokumentation, keine Prämie im laufenden Jahr.
violations contains v if {
	some parcel in lib.nat_parcels
	lib.has_code(parcel, "VF")
	not object.get(parcel, ["oepul", "trial_written_approval"], false)
	v := {"rule_id": "O618-ADM-021", "message": sprintf("Schlag %v: Versuchsfläche ohne schriftliche Genehmigung", [parcel.parcel_id])}
}
