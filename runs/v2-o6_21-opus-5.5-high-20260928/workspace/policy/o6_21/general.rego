# Allgemeine Teilnahmebedingungen und Allgemeiner Teil der SRL, soweit für o6_21 maßgeblich.
package oepul.o6_21

import rego.v1

gen := data.o6_21.general_conditions

applicant := object.get(input, ["farm", "applicant"], {})

applicant_type_cfg(t) := cfg if {
	some cfg in gen.applicant_types
	cfg.id == t
}

# O6_21-GEN-001: förderwerbende Personen; Gebietskörperschaften (und Beteiligung > 25 %) ausgeschlossen,
# o6_21 ist keine Ausnahmemaßnahme.
general_violations contains {"rule_id": "O6_21-GEN-001", "reason": "keine zulässige förderwerbende Person"} if {
	not applicant_type_cfg(applicant.type).eligible == true
}

general_violations contains {"rule_id": "O6_21-GEN-001", "reason": "Beteiligung von Gebietskörperschaften über 25 %"} if {
	applicant_type_cfg(applicant.type).public_share_limit_applies == true
	applicant.public_body_share_percent > gen.public_body_max_share_percent
}

# O6_21-GEN-002: aktiver Landwirt und landwirtschaftliche Tätigkeit.
general_violations contains {"rule_id": "O6_21-GEN-002", "reason": "kein aktiver Landwirt bzw. keine landwirtschaftliche Tätigkeit"} if {
	not applicant.is_active_farmer == true
}

general_violations contains {"rule_id": "O6_21-GEN-002", "reason": "kein aktiver Landwirt bzw. keine landwirtschaftliche Tätigkeit"} if {
	not applicant.agricultural_activity == true
}

# O6_21-GEN-004: Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr.
first_oepul_year if input.farm.oepul_first_participation_year == measure_year

farm_minimum_size_met if {
	object.get(input, ["land", "protected_cultivation_area_ha"], 0) >= gen.farm_minimum_size_first_year.protected_cultivation_min_ha
}

farm_minimum_size_met if {
	input.land.total_area_ha >= gen.farm_minimum_size_first_year.agricultural_area_min_ha
}

general_violations contains {"rule_id": "O6_21-GEN-004", "reason": "Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr nicht erreicht"} if {
	first_oepul_year
	not farm_minimum_size_met
}

# O6_21-GEN-012: Verweigerung der Kontrolle - Antrag abgelehnt, Verträge beendet.
inspection_refused if {
	input.oepul.controls.inspection_refused == true
	not input.oepul.controls.force_majeure_or_exceptional == true
}

general_violations contains {"rule_id": "O6_21-GEN-012", "reason": "Vor-Ort-Kontrolle verhindert bzw. Auskunft verweigert"} if {
	inspection_refused
}

# O6_21-GEN-010: Betriebsgrößenmodulation nach Gesamtfläche des Betriebes.
bracket_upper(b, area) := area if b.to_ha_inclusive == null

bracket_upper(b, area) := min([area, b.to_ha_inclusive]) if is_number(b.to_ha_inclusive)

bracket_weighted(b, area) := max([0, bracket_upper(b, area) - b.from_ha_exclusive]) * b.payout_share

modulation_factor(area) := 1 if area <= 0

modulation_factor(area) := f if {
	area > 0
	f := sum([bracket_weighted(b, area) | some b in gen.modulation_brackets]) / area
}

# O6_21-GEN-015: Sanktionsstufen; ab 2027 Einbehalt von 1 % statt Verwarnung.
sanction_reduction_percent(stage_id, year) := s.from_2027_retention_percent if {
	some s in gen.sanction_stages
	s.id == stage_id
	stage_id == "warning"
	year >= gen.warning_replaced_by_retention_from_year
} else := s.reduction_percent if {
	some s in gen.sanction_stages
	s.id == stage_id
}

# O6_21-GEN-015: Ausschluss bei zweimaliger 100 %-Kürzung im Vertragszeitraum.
exclusion_from_measure(reductions_100_in_contract_period) if reductions_100_in_contract_period >= 2

# O6_21-GEN-011: Auszahlung bis 30. Juni des Folgejahres, Teilzahlung max. 75 %, Bagatellgrenze 50 Euro.
payment_deadline := sprintf("%d-%s", [measure_year + 1, params.payment_deadline_month_day_following_year])

max_advance_payment(amount) := amount * params.max_advance_payment_share

payout_may_be_withheld(amount) if amount <= params.minimum_payout_eur

# O6_21-GEN-020: tierhaltender Betrieb (mind. 0,30 RGVE/ha Futterfläche) - für o6_21 nicht prämienbestimmend.
livestock_holding_farm(total_rgve, forage_area_ha) if {
	forage_area_ha > 0
	total_rgve / forage_area_ha >= gen.livestock_holding_farm_min_rgve_per_ha_forage
}
