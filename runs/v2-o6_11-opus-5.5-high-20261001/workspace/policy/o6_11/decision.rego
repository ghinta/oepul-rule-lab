# o6_11 policy module
# o6_11 – Gesamtentscheidung
# Aggregation aller Verstöße, Hinweise und der Prämienberechnung.
package oepul.o6_11

violations contains {"rule_id": "O611-CONTRACT-PERIOD", "message": "Vertragsbeginn nur am 01.01.2023, 01.01.2024 oder 01.01.2025 möglich"} if {
	participates
	not contract_start_valid
}

violations contains {"rule_id": "O611-LAST-ENTRY", "message": "Letzter Einstieg mit Förderjahr 2025 (Antrag bis 31.12.2024)"} if entry_after_last_entry_year

violations contains {"rule_id": "O611-APPLY-DEADLINE", "message": "Maßnahmenantrag nicht bis 31.12. vor Vertragsbeginn gestellt"} if application_late

violations contains {"rule_id": "O611-MIN-AREA", "message": sprintf("Mindestteilnahmefläche 0,5 ha nicht erreicht (%.2f ha)", [minimum_area_ha])} if minimum_area_violation

violations contains {"rule_id": "O611-GEN-MIN-FARM-SIZE", "message": "Betriebsmindestgröße im 1. ÖPUL-Teilnahmejahr nicht erreicht"} if farm_min_size_violation

violations contains {"rule_id": "O611-GEN-APPLICANT", "message": msg} if {
	some msg in applicant_violations
}

violations contains {"rule_id": "O611-COMB-BIO", "message": "Betriebliche Kombination mit Biologischer Wirtschaftsweise ausgeschlossen (außer Bio-Teilbetrieb Acker/Grünland)"} if organic_combination_conflict

violations contains {"rule_id": "O611-SWITCH-BIO", "message": "Umstieg in Biologische Wirtschaftsweise nur bis 31.12.2025 möglich"} if switch_to_organic_too_late

violations contains {"rule_id": "O611-COMB-PARCEL", "parcel_id": c.parcel_id, "message": sprintf("Maßnahme 11 ist mit Maßnahme %s auf der Einzelfläche nicht kombinierbar", [c.other_measure])} if {
	some c in parcel_combination_conflicts
}

violations contains {"rule_id": herbicide_rule_id(v.zone), "parcel_id": v.parcel_id, "message": sprintf("Herbizideinsatz (%v, Bereich %v) im Vertragszeitraum", [v.product, v.zone])} if {
	some v in herbicide_ban_violations
}

violations contains {"rule_id": "O611-AMEISENSAEURE", "parcel_id": v.parcel_id, "message": "Einsatz von Ameisensäure (nicht genehmigter Wirkstoff)"} if {
	some v in formic_acid_violations
}

violations contains {"rule_id": "O611-PURCHASE-STORAGE", "message": sprintf("%v: %s", [v.product, v.reason])} if {
	some v in purchase_storage_violations
}

violations contains {"rule_id": "O611-PSM-CODE-REQ", "parcel_id": m.parcel_id, "message": sprintf("PSM-Code %s im Mehrfachantrag fehlt", [m.code])} if {
	some m in missing_psm_codes
}

violations contains {"rule_id": "O611-GEN-OP-CODE", "parcel_id": m.parcel_id, "message": sprintf("Code OP bzw. maßnahmenbezogener OP-Code fehlt (Fälle: %v)", [m.cases])} if {
	some m in missing_op_codes
}

violations contains {"rule_id": "O611-GEN-TAKEOVER", "message": msg} if {
	some msg in takeover_violations
}

violations contains {"rule_id": "O611-GEN-CONTROL-REFUSAL", "message": "Verweigerung der Vor-Ort-Kontrolle: Antrag abzulehnen, Verträge zu beenden und rückabzuwickeln"} if inspection_refused

notices contains {"rule_id": "O611-COMB-PARCEL", "parcel_id": c.parcel_id, "message": sprintf("Kombination mit Maßnahme %s nur gemäß Fußnote %s des Anhangs L", [c.other_measure, c.footnote])} if {
	some c in parcel_combination_limited
}

notices contains {"rule_id": "O611-GEN-CAP", "parcel_id": pid, "message": "Prämienobergrenze für Flächenzahlungen überschritten; Prämie wurde anteilig gekürzt"} if {
	some pid in payment_cap_exceeded_parcels
}

notices contains {"rule_id": "O611-GEN-MIN-PAYOUT", "message": "Auszahlungsbetrag bis 50 Euro – von der Gewährung kann abgesehen werden"} if {
	participates
	payout_may_be_withheld
}

notices contains {"rule_id": "O611-GEN-EXIT-REPAYMENT", "message": "Ausstieg vor Ende des Vertragszeitraumes: bereits gewährte Prämien sind zurückzuzahlen"} if exit_repayment_required

notices contains {"rule_id": "O611-GEN-MISSED-PAYMENT-CLAIM", "message": "Zahlungsantrag mehr als 1 Jahr versäumt: Verpflichtung endet, bisherige Prämien sind zurückzuzahlen"} if payment_claim_overdue

notices contains {"rule_id": "O611-GEN-FORCE-MAJEURE", "message": "Besonderer Umstand nicht gemeldet: Rückforderung kann nicht abgewendet werden"} if count(unreported_circumstances) > 0

notices contains {"rule_id": "O611-PSM-CODE-2026-ABOLISHED", "message": "Ab Antragsjahr 2026 ist keine PSM-Codierung im Mehrfachantrag mehr erforderlich"} if {
	participates
	not psm_coding_required_year
}

parcel_results[p.parcel_id] := {
	"wine_fruit_hop_area": wfh_parcel_bool(p),
	"herbicide_ban_applies": herbicide_ban_parcel_bool(p),
	"premium_eligible": parcel_premium_eligible_bool(p),
	"no_premium_reasons": parcel_no_premium_reasons(p),
	"premium_gross_eur": object.get(parcel_premium, p.parcel_id, 0),
	"premium_payable_eur": object.get(parcel_payable, p.parcel_id, 0),
} if {
	some p in parcels
}

herbicide_ban_parcel_bool(p) if herbicide_ban_parcel(p)

herbicide_ban_parcel_bool(p) := false if not herbicide_ban_parcel(p)

parcel_premium_eligible_bool(p) if parcel_premium_eligible(p)

parcel_premium_eligible_bool(p) := false if not parcel_premium_eligible(p)

compliant if {
	participates
	count(violations) == 0
}

decision := {
	"measure": "o6_11",
	"year": year,
	"participates": participates_bool,
	"contract_valid": contract_valid_bool,
	"compliant": compliant_bool,
	"access_condition_failures": access_condition_failures,
	"premium_withheld_reasons": premium_withheld_reasons,
	"premium_eligible_area_ha": premium_eligible_area_ha,
	"premium_before_modulation_eur": premium_before_modulation,
	"modulation_factor": modulation_factor,
	"premium_after_sanction_eur": premium_after_sanction,
	"premium_after_modulation_eur": premium_after_modulation,
	"advance_payment_max_eur": advance_payment_max_eur,
	"reduction_order": reduction_order,
	"sanction_reduction_percent": sanction_reduction_percent,
	"premium_payable_eur": premium_payable,
	"exit_repayment_required": exit_repayment_required_bool,
	"violations": violations,
	"notices": notices,
	"parcels": parcel_results,
}

compliant_bool if compliant

compliant_bool := false if not compliant

exit_repayment_required_bool if exit_repayment_required

exit_repayment_required_bool := false if not exit_repayment_required

participates_bool if participates

participates_bool := false if not participates

contract_valid_bool if {
	participates
	not no_contract
}

contract_valid_bool := false if not participates

contract_valid_bool := false if no_contract

wfh_parcel_bool(p) if is_wfh_parcel(p)

wfh_parcel_bool(p) := false if not is_wfh_parcel(p)

# Zaunbereich (Rule O611-FENCE) bzw. Stammbehandlung (Rule O611-STAMM)
herbicide_rule_id(zone) := "O611-FENCE" if zone == "fence_line"

herbicide_rule_id(zone) := "O611-STAMM" if zone == "stem"

herbicide_rule_id(zone) := "O611-HERB-BAN" if not zone in {"fence_line", "stem"}

# Rule O611-GEN-CONDITIONALITY: volle Förderung nur bei Einhaltung der Konditionalität
notices contains {"rule_id": "O611-GEN-CONDITIONALITY", "message": "Konditionalität nicht eingehalten: Kürzungen gemäß Art. 83 bis 89 VO (EU) 2021/2116"} if {
	participates
	object.get(input, ["farm", "oepul", "conditionality_compliant"], true) == false
}
