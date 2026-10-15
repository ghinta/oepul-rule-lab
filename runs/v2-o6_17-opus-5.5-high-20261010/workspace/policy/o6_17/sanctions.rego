package oepul.o6_17.sanctions

# Kürzungen, Rückforderungen und Vertragszeitraum (Allgemeine
# Teilnahmebedingungen 6, 7.1, 8.2; SRL 1.7.2, 1.12; GSP-AV § 48).

import data.oepul.o6_17.common

fw := data.o6_17_tables.general_framework

findings := object.get(common.o6, "findings", [])

stage_row(stage) := r if {
	some r in fw.sanction_stages
	r.stage == stage
}

# Wiederholter Verstoß gegen dieselbe Förderverpflichtung: +1 Stufe je Wiederholung.
effective_stage(f) := min([7, f.base_stage + object.get(f, "prior_occurrences_same_obligation", 0)])

stage_percent(stage) := stage_row(stage).reduction_percent_from_2027 if {
	common.year >= 2027
} else := stage_row(stage).reduction_percent_until_2026

finding_percent(f) := stage_percent(effective_stage(f))

# Einmalig zu erfüllende Auflagen (Weiterbildung, Bodenproben) werden im Jahr
# der Feststellung geahndet.
one_off_obligations := {"o6_17.obligation.training_5h_grassland", "o6_17.obligation.soil_samples_per_5ha"}

sanction_year(f) := object.get(f, "detection_year", common.year) if f.obligation_id in one_off_obligations

else := common.year

finding_lines := [line |
	some f in findings
	line := {
		"obligation_id": f.obligation_id,
		"effective_stage": effective_stage(f),
		"reduction_percent": finding_percent(f),
		"sanction_year": sanction_year(f),
	}
]

# Kumulation durch Addition, begrenzt auf 100 % der Jahresprämie.
total_reduction_percent := min([100, sum([l.reduction_percent | some l in finding_lines])])

previous_full_reductions := object.get(common.o6, "previous_full_reductions_in_period", 0)

current_full_reduction := 1 if total_reduction_percent == 100

else := 0

# Zweimalige 100 %-Kürzung im Vertragszeitraum: Ausschluss und Rückforderung.
excluded_from_measure if previous_full_reductions + current_full_reduction >= 2

on_site_findings := [f | some f in findings; object.get(f, "detected_by", "") == "on_site"]

serious_case_may_reach_100 if count(on_site_findings) > 3

serious_case_may_reach_100 if {
	some f in findings
	object.get(f, "serious", false) == true
}

# ---------------------------------------------------------------------------
# Vorzeitiger Ausstieg aus der mehrjährigen Maßnahme

early_exit if {
	is_string(common.exit_date)
	common.exit_date < fw.contract_end_date
	object.get(common.o6, "exit_reason", "voluntary") == "voluntary"
}

repayment_of_all_premiums_since_start if early_exit

repayment_of_all_premiums_since_start if excluded_from_measure

# ---------------------------------------------------------------------------
# Flächenabgang während des Vertragszeitraums

previous_year_area := object.get(common.o6, "committed_area_previous_year_ha", 0)

exempt_reduction_reasons := {"loss_of_control", "conversion_to_alpine_pasture", "conversion_to_landscape_element_hedge_or_agroforestry"}

area_reductions := object.get(common.o6, "area_reductions", [])

relevant_reduction_ha := sum([r.area_ha | some r in area_reductions; not r.reason in exempt_reduction_reasons])

allowed_reduction_ha := max([
	min([previous_year_area * fw.area_reduction_tolerance.max_share, fw.area_reduction_tolerance.max_ha]),
	fw.area_reduction_tolerance.always_allowed_ha,
])

# Bei Überschreitung: Rückzahlung für die gesamte Differenzfläche.
repayment_area_ha := relevant_reduction_ha if relevant_reduction_ha > allowed_reduction_ha

else := 0

# ---------------------------------------------------------------------------
# Nicht beantragte Maßnahme/Fläche in einem Folgejahr

missed_payment_application if object.get(common.o6, "payment_application_missing", false) == true

# Verpflichtung bleibt aufrecht, für das Jahr erfolgt keine Zahlung.
no_payment_for_year_due_to_missed_application if missed_payment_application

# Kein Nachreichen binnen 1 Jahr: Verpflichtung endet, Rückzahlung aller Prämien.
commitment_ends_due_to_missed_application if {
	missed_payment_application
	object.get(common.o6, "late_payment_application_within_one_year", false) == false
}

repayment_of_all_premiums_since_start if commitment_ends_due_to_missed_application

summary := {
	"finding_lines": finding_lines,
	"total_reduction_percent": total_reduction_percent,
	"excluded_from_measure": excluded_from_measure,
	"serious_case_may_reach_100": serious_case_may_reach_100,
	"early_exit": early_exit,
	"repayment_of_all_premiums_since_start": repayment_of_all_premiums_since_start,
	"allowed_reduction_ha": allowed_reduction_ha,
	"repayment_area_ha": repayment_area_ha,
	"no_payment_for_year_due_to_missed_application": no_payment_for_year_due_to_missed_application,
	"commitment_ends_due_to_missed_application": commitment_ends_due_to_missed_application,
}

default no_payment_for_year_due_to_missed_application := false

default excluded_from_measure := false

default serious_case_may_reach_100 := false

default early_exit := false

default repayment_of_all_premiums_since_start := false

default commitment_ends_due_to_missed_application := false
