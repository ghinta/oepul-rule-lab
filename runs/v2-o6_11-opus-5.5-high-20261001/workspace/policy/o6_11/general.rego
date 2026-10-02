# o6_11 policy module
# o6_11 – Allgemeine Bestimmungen der Abwicklung
#
#   Ausstieg und Rückforderung, Flächenab- und -zugänge, Maßnahmenübernahme,
#   besondere Umstände, Kontrollen, Zahlungsantrag und Sanktionen.
package oepul.o6_11

oepul := object.get(input, ["farm", "oepul"], {})

# ---------------------------------------------------------------------------
# Zugangsvoraussetzungen (Rule O611-GEN-ACCESS-FAIL)
# 1. Jahr: kein Vertrag; ab 2. Jahr: keine Prämie im betroffenen Jahr
# ---------------------------------------------------------------------------
access_condition_failures contains "Vertragsbeginn außerhalb 2023–2025" if {
	participates
	not contract_start_valid
}

access_condition_failures contains "Maßnahmenantrag nicht bis 31.12. vor Vertragsbeginn" if application_late

access_condition_failures contains "Mindestteilnahmefläche 0,5 ha im 1. Verpflichtungsjahr nicht erreicht" if minimum_area_violation

access_condition_failures contains "Betriebsmindestgröße im 1. ÖPUL-Jahr nicht erreicht" if farm_min_size_violation

access_condition_failures contains msg if {
	some msg in applicant_violations
}

access_condition_failures contains "unzulässige betriebliche Kombination mit Biologischer Wirtschaftsweise" if organic_combination_conflict

access_conditions_failed if count(access_condition_failures) > 0

# kein Vertrag kommt zustande (Nichterfüllung im 1. Verpflichtungsjahr)
no_contract if {
	access_conditions_failed
	is_first_commitment_year
}

no_contract if {
	participates
	not contract_start_valid
}

# ---------------------------------------------------------------------------
# Ausstieg (Rules O611-GEN-WITHDRAWAL-YEAR, O611-GEN-EXIT-REPAYMENT)
# ---------------------------------------------------------------------------
exit_year := year_of(participation.exit_date) if participation.exit_date

exit_type := object.get(participation, "exit_type", "voluntary")

exited_in_or_before_year if {
	exit_year
	exit_year <= year
}

# Ausstiegsarten ohne Rückforderung gemäß SRL 1.7.2.1, 1.7.4.2, 1.7.5, 1.7.3.2
repayment_free_exit_types := {
	"loss_of_control",
	"permanent_special_circumstance",
	"revision_clause_refusal",
}

exit_before_contract_end if {
	exit_year
	exit_year <= year_of(contract_end)
}

exit_repayment_required if {
	is_multi_year_measure
	exit_before_contract_end
	not exit_type in repayment_free_exit_types
	not switch_to_organic_allowed
}

# Rule O611-GEN-MISSED-PAYMENT-CLAIM: kein Zahlungsantrag im Folgejahr
payment_claim_missing if {
	participates
	not is_first_commitment_year
	participation.payment_claim_submitted == false
}

payment_claim_overdue if {
	payment_claim_missing
	participation.payment_claim_overdue_more_than_one_year == true
}

commitment_ended_by_missing_claim if payment_claim_overdue

# ---------------------------------------------------------------------------
# Kontrollen (Rule O611-GEN-CONTROL-REFUSAL)
# ---------------------------------------------------------------------------
inspection_refused if {
	oepul.on_site_inspection_refused == true
	not oepul.on_site_inspection_refusal_force_majeure == true
}

# ---------------------------------------------------------------------------
# Ausschluss bei zweimaliger 100 %-Kürzung (Rule O611-GEN-SANCTION-LEVELS)
# ---------------------------------------------------------------------------
excluded_from_measure if {
	some row in cfg.sanctions.levels
	row.level == "exclusion"
	object.get(oepul, "full_reduction_count_in_contract_period", 0) >= row.trigger_full_reductions_in_contract_period
}

excluded_from_measure if sanction_level == "exclusion"

# Mehrjährige Maßnahme gemäß SRL 1.7.1.2 (Rule O611-CONTRACT-PERIOD)
is_multi_year_measure if measure_id in cfg.general_conditions.multi_year_measures

# ---------------------------------------------------------------------------
# Besondere flächen- und bewirtschaftungsverändernde Umstände
# (Rules O611-GEN-FORCE-MAJEURE, O611-GEN-PERMANENT-CIRCUMSTANCE,
# O611-GEN-TEMPORARY-CIRCUMSTANCE)
# ---------------------------------------------------------------------------
special_circumstances := object.get(oepul, "special_circumstances", [])

circumstance_in_year(c) if year_of(c.occurrence_date) == year

premium_cutoff_date := sprintf("%d-%s", [year, cfg.general_conditions.special_circumstance_premium_cutoff_month_day])

# Dauerhafte Umstände: im Eintrittsjahr keine Prämie, außer höhere Gewalt
# oder Eintritt nach dem 15.04.
permanent_circumstance_blocks_premium(c) if {
	c.type == "permanent"
	circumstance_in_year(c)
	not c.force_majeure == true
	c.occurrence_date <= premium_cutoff_date
}

# Vorübergehende Umstände: im Jahr der Nichteinhaltung keine Prämie, außer
# höhere Gewalt oder alle Bedingungen auf den geänderten Flächen eingehalten
temporary_circumstance_blocks_premium(c) if {
	c.type == "temporary"
	circumstance_in_year(c)
	not c.force_majeure == true
	not c.all_conditions_met_on_changed_areas == true
}

# Rückforderung entfällt nur bei fristgerechter Meldung
circumstance_repayment_waived(c) if {
	c.type in {"permanent", "temporary", "force_majeure"}
	c.reported == true
}

unreported_circumstances contains c if {
	some c in special_circumstances
	not circumstance_repayment_waived(c)
}

# ---------------------------------------------------------------------------
# Prämie im Antragsjahr ausgeschlossen
# ---------------------------------------------------------------------------
premium_withheld_reasons contains "Ausstieg/Abmeldung im Antragsjahr" if exited_in_or_before_year

premium_withheld_reasons contains "Umstieg in Biologische Wirtschaftsweise wirksam" if converted_in_or_before_year

premium_withheld_reasons contains "Zahlungsantrag nicht gestellt" if payment_claim_missing

premium_withheld_reasons contains "Verweigerung der Vor-Ort-Kontrolle" if inspection_refused

premium_withheld_reasons contains "Ausschluss aus der Maßnahme" if excluded_from_measure

premium_withheld_reasons contains "dauerhafter flächen-/bewirtschaftungsverändernder Umstand" if {
	some c in special_circumstances
	permanent_circumstance_blocks_premium(c)
}

premium_withheld_reasons contains "vorübergehender flächen-/bewirtschaftungsverändernder Umstand" if {
	some c in special_circumstances
	temporary_circumstance_blocks_premium(c)
}

premium_withheld_for_year if count(premium_withheld_reasons) > 0

# ---------------------------------------------------------------------------
# Flächenabgang (Rules O611-GEN-ANNUAL-AREA-FLEX, O611-GEN-AREA-REDUCTION-TOLERANCE)
# ---------------------------------------------------------------------------
annual_area_flexible if {
	some row in cfg.general_conditions.annual_area_flexible_measures
	row.measure_id == measure_id
}

area_reduction_tolerance_ha(previous_area) := max([
	cfg.general_conditions.area_reduction_tolerance.always_allowed_ha,
	min([
		(previous_area * cfg.general_conditions.area_reduction_tolerance.max_percent_of_previous_year) / 100,
		cfg.general_conditions.area_reduction_tolerance.max_ha,
	]),
])

previous_year_area := object.get(oepul, "previous_year_measure_area_ha", null)

area_reduction_ha := previous_year_area - premium_eligible_area_ha if previous_year_area != null

# Für Maßnahme 11 ist die Fläche an die jährlich verfügbare Fläche gebunden:
# Flächenverringerungen lösen keine Rückzahlung aus.
area_reduction_repayment_required if {
	not annual_area_flexible
	area_reduction_ha > area_reduction_tolerance_ha(previous_year_area)
}

# Rule O611-GEN-AREA-ADDITION-UNRESTRICTED
area_addition_restricted if measure_id in cfg.general_conditions.area_addition_restricted_measures

# ---------------------------------------------------------------------------
# Maßnahmenübernahme (Rule O611-GEN-TAKEOVER)
# ---------------------------------------------------------------------------
takeover := oepul.takeover

takeover_year := year_of(takeover.takeover_date)

takeover_deadline := sprintf("%d-%s", [takeover_year, cfg.general_conditions.takeover.deadline_month_day_2023_2028]) if {
	takeover_year in cfg.general_conditions.takeover.special_years
}

takeover_deadline := sprintf("%d-%s", [takeover_year, cfg.general_conditions.takeover.deadline_month_day]) if {
	not takeover_year in cfg.general_conditions.takeover.special_years
}

takeover_violations contains "Übernahme nach dem 15.04. (2023/2028: 17.04.)" if {
	takeover.takeover_date > takeover_deadline
}

takeover_violations contains "übernehmender Betrieb nahm bereits an der Maßnahme teil" if {
	takeover.taking_farm_previously_in_measure == true
}

takeover_violations contains "Ausweitung auf andere Flächen um mehr als 50 %" if {
	takeover.taken_over_area_ha > 0
	(takeover.expansion_area_ha * 100) / takeover.taken_over_area_ha > cfg.general_conditions.takeover.max_expansion_percent
}

takeover_valid if {
	takeover.takeover_date
	count(takeover_violations) == 0
}
