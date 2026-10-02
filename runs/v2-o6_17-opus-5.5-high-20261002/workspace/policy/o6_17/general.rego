# o6_17 – allgemeine ÖPUL-Teilnahmebedingungen
#
#   Förderwerbende Personen, Betriebsmindestgröße, Mindestbewirtschaftung,
#   Flächenabgang/-zugang, Maßnahmenübernahme, Sanktionsstufen, Auszahlung
#   (Allg. Teilnahmebedingungen 2026-04; SRL Allgemeiner Teil 1.4-1.12).
package oepul.o6_17

import rego.v1

general := tables.general_tables

applicant := object.get(input, ["farm", "applicant"], {})

oepul := object.get(input, ["farm", "oepul"], {})

# ---------------------------------------------------------------------------
# Förderwerbende Personen (Allg. 5.2; SRL 1.4)
# ---------------------------------------------------------------------------

applicant_types := {a.code: a | some a in tables.lists.applicant_types}

# o6_17 ist keine der Ausnahmemaßnahmen für Gebietskörperschaften.
o6_17_public_body_exception if {
	some m in tables.lists.public_body_exception_measures
	m.measure_id == "o6_17"
}

applicant_eligible if {
	t := applicant_types[applicant.legal_form]
	t.public_body_share_limited == false
	object.get(applicant, "is_active_farmer", false) == true
}

applicant_eligible if {
	t := applicant_types[applicant.legal_form]
	t.public_body_share_limited == true
	object.get(applicant, "public_body_share_percent", 0) <= tables.thresholds.public_body_max_share_percent
	object.get(applicant, "is_active_farmer", false) == true
}

# Gebietskörperschaften nur bei Ausnahmemaßnahmen (o6_17 ist keine solche).
applicant_eligible if {
	applicant.legal_form == "public_body"
	o6_17_public_body_exception
}

general_violations contains {
	"rule_id": "GEN-APPLICANT",
	"message": "Förderwerbende Person nicht teilnahmeberechtigt (Rechtsform, Beteiligung von Gebietskörperschaften > 25 % oder kein aktiver Landwirt).",
} if {
	applicant.legal_form
	not applicant_eligible
}

# ---------------------------------------------------------------------------
# Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr (Allg. 5.3; SRL 1.6.1)
# ---------------------------------------------------------------------------

is_first_oepul_year if year == object.get(oepul, "first_oepul_year", null)

farm_min_size_met if object.get(input, ["land", "protected_cultivation_area_ha"], 0) >= tables.thresholds.farm_min_protected_cultivation_ha

farm_min_size_met if {
	total := object.get(input, ["land", "total_area_ha"], 0) + object.get(input, ["land", "protected_cultivation_area_ha"], 0)
	total >= tables.thresholds.farm_min_size_ha
}

general_violations contains {
	"rule_id": "GEN-FARM-MIN-SIZE",
	"message": "Betriebsmindestgröße im ersten ÖPUL-Jahr nicht erreicht (1,50 ha LN bzw. 0,50 ha geschützter Anbau).",
} if {
	is_first_oepul_year
	not farm_min_size_met
}

# ---------------------------------------------------------------------------
# Mindestbewirtschaftung auf Grünland- und Ackerfutterflächen (Allg. 5.4; SRL 1.6.3.3)
# ---------------------------------------------------------------------------

minimum_management_met(p) if parcel_field_use(p) in {"sonstige_gruenlandflaechen", "gruenlandbrache"}

minimum_management_met(p) if {
	parcel_field_use(p) != "bergmaehder"
	parcel_used_this_year(p)
}

minimum_management_met(p) if {
	parcel_field_use(p) == "bergmaehder"
	last := object.get(p, ["oepul", "last_mowing_year"], null)
	is_number(last)
	year - last < 2
}

general_violations contains {
	"rule_id": "GEN-MIN-MANAGEMENT-GRASSLAND",
	"parcel_id": p.parcel_id,
	"message": "Mindestbewirtschaftung nicht erfüllt (jährliche vollflächige Mahd mit Verbringung oder Beweidung; Bergmähder mind. alle 2 Jahre).",
} if {
	some p in parcels
	is_feed_parcel(p)
	not minimum_management_met(p)
}

# ---------------------------------------------------------------------------
# Flächenabgang während des Vertragszeitraums (Allg. 7.1; SRL 1.7.2.3)
# ---------------------------------------------------------------------------

tolerance := general.area_reduction_tolerance

area_reduction_tolerance_ha := max([
	min([tolerance.max_share * measure.measure_area_previous_year_ha, tolerance.max_ha]),
	tolerance.min_ha_always,
]) if {
	is_number(object.get(measure, "measure_area_previous_year_ha", null))
}

relevant_area_reduction_ha := max([
	0,
	((measure.measure_area_previous_year_ha - measure.measure_area_current_year_ha) - object.get(measure, "area_reduction_loss_of_disposal_ha", 0)) - object.get(measure, "area_reduction_permitted_conversion_ha", 0),
]) if {
	is_number(object.get(measure, "measure_area_previous_year_ha", null))
	is_number(object.get(measure, "measure_area_current_year_ha", null))
}

area_reduction_repayment_required if relevant_area_reduction_ha > area_reduction_tolerance_ha

# Rückzahlung für die gesamte Differenzfläche bei Überschreitung.
area_reduction_repayment_area_ha := relevant_area_reduction_ha if area_reduction_repayment_required

# ---------------------------------------------------------------------------
# Ausstieg vor Ende des Vertragszeitraums (Allg. 6; SRL 1.7.2, 1.10.5.3)
# ---------------------------------------------------------------------------

exit_year := object.get(measure, "exit_year", null)

early_exit_repayment_required if {
	is_number(exit_year)
	exit_year <= 2028
	object.get(measure, "exit_without_repayment_approved", false) == false
}

# ---------------------------------------------------------------------------
# Maßnahmenübernahme (Allg. 6.3; SRL 1.7.3.1)
# ---------------------------------------------------------------------------

takeover := object.get(measure, "takeover", {})

takeover_deadline(y) := sprintf("%d-%s", [y, tables.thresholds.takeover_deadline_2023_2028]) if y in {2023, 2028}

else := sprintf("%d-%s", [y, tables.thresholds.takeover_deadline])

takeover_permitted if {
	takeover.application_date <= takeover_deadline(year)
	object.get(takeover, "taker_previously_participating", false) == false
	takeover.expansion_to_other_area_ha <= tables.thresholds.takeover_max_expansion_share * takeover.taken_over_area_ha
}

# ---------------------------------------------------------------------------
# Sanktionen (Allg. 8.2; SRL 1.12.1.3)
# ---------------------------------------------------------------------------

sanction_share(stage, y) := s.reduction_share_until_2026 if {
	some s in general.sanction_stages
	s.stage == stage
	y < 2027
}

sanction_share(stage, y) := s.reduction_share_from_2027 if {
	some s in general.sanction_stages
	s.stage == stage
	y >= 2027
}

exclusion_required if object.get(measure, "full_reductions_in_contract_period", 0) >= 2

# ---------------------------------------------------------------------------
# Auszahlung (Allg. 9.1; SRL 1.10.7)
# ---------------------------------------------------------------------------

payment_deadline := sprintf("%d-%s", [year + 1, tables.thresholds.payment_deadline])

advance_payment_max_eur := premium_after_modulation_eur * tables.thresholds.advance_payment_max_share

payment_may_be_withheld if premium_after_modulation_eur <= tables.thresholds.payment_min_amount_eur
