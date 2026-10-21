package oepul.o6_1c

# Kürzungen, Sanktionen, Flächenabweichungen und höhere Gewalt.

stages := data.o6_1c.sanction_stages

stage_row(stage) := row if {
	some row in stages.rows
	row.stage == stage
}

# O6_1C-SANC-001: Sanktionsstufen; ab 2027 Einbehalt 1 % statt Verwarnung.
stage_percent(stage, y) := stage_row(stage).reduction_percent_from_2027 if y >= stages.warning_replaced_from_year

stage_percent(stage, y) := stage_row(stage).reduction_percent if y < stages.warning_replaced_from_year

# O6_1C-SANC-003: Mehrmaliger Verstoß bei derselben Förderverpflichtung erhöht
# die Stufe ab dem zweiten Verstoß um eine Stufe usw.; Kumulation durch Addition,
# höchstens 100 % der Jahresprämie.
effective_stage(f) := min_of(7, f.stage + max_of(0, object.get(f, "repeat_index", 1) - 1))

findings := object.get(application, "findings", [])

sanction_percent_total := min_of(
	stages.max_cumulative_percent,
	sum([stage_percent(effective_stage(f), year) | some f in findings]),
)

# O6_1C-SANC-002: Zweimal 100 %-Kürzung in der Förderperiode -> Ausschluss
# und Rückforderung der im Vertragszeitraum gewährten Prämie.
full_cuts_in_period := object.get(application, "full_cuts_in_period", 0) + count([f | some f in findings; effective_stage(f) == 7])

excluded_from_measure if full_cuts_in_period >= stages.exclusion_after_full_cuts_in_period

# O6_1C-SANC-004: Übererklärung (§§ 42, 46 GSP-AV).
area_basis(declared, determined) := determined - (params.general.overdeclaration_penalty_multiplier * (declared - determined)) if {
	declared > determined
	overdeclaration_material(declared, determined)
}

area_basis(declared, determined) := determined if {
	declared > determined
	not overdeclaration_material(declared, determined)
}

area_basis(declared, determined) := declared if declared <= determined

overdeclaration_material(declared, determined) if {
	declared - determined > params.general.overdeclaration_tolerance_share * determined
}

overdeclaration_material(declared, determined) if {
	declared - determined > params.general.overdeclaration_tolerance_ha
}

sanctioned_area_basis_ha(declared, determined) := max_of(0, area_basis(declared, determined))

# O6_1C-SANC-006: Verweigerung/Verhinderung der Vor-Ort-Kontrolle ohne höhere
# Gewalt -> Antrag abgelehnt, keine Prämie, Verträge beendet.
application_rejected_for_control_refusal if {
	application.on_site_control_refused == true
	not application.control_refusal_due_to_force_majeure == true
}

# O6_1C-FM-001: Höhere Gewalt binnen drei Wochen (21 Tage) ab Möglichkeit
# geltend zu machen.
ns_per_day := ((24 * 60) * 60) * 1000000000

days_between(d1, d2) := (time.parse_ns("2006-01-02", d2) - time.parse_ns("2006-01-02", d1)) / ns_per_day

force_majeure_claim_timely(claim) if {
	days_between(claim.able_to_notify_date, claim.notification_date) <= params.general.force_majeure_notification_days
}

force_majeure_case_listed(case_id) if {
	some row in data.o6_1c.force_majeure_cases.rows
	row.id == case_id
}

force_majeure_claims := object.get(application, "force_majeure_claims", [])

recognisable_force_majeure_claims contains c if {
	some c in force_majeure_claims
	force_majeure_claim_timely(c)
}

late_force_majeure_claims contains c if {
	some c in force_majeure_claims
	not force_majeure_claim_timely(c)
}

# O6_1C-SANC-007: Reihenfolge bei Mehrfachkürzungen (SRL 1.12.2).
reduction_order := [row.step | some row in data.o6_1c.multiple_reduction_order.rows]
