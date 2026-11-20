# Förderwerbende Personen, höhere Gewalt, Kontrollen, Sanktionen, Aufbewahrung und Auszahlung (o6_21).
package oepul.o6_21.administration

import data.oepul.o6_21.lib

mi := lib.measure_input

applicant := object.get(input, ["farm", "applicant"], {})

# --- Förderwerbende Personen (SRL 1.4, ATB 5.2) -------------------------------------------------

applicant_type_row := row if {
	some row in lib.tables.applicant_types
	row.person_type == applicant.person_type
}

# O6_21-APPL-01: zulässige Rechtsformen; juristische Personen/Personenvereinigungen nur bis 25 % Beteiligung
# von Gebietskörperschaften.
applicant_issue("person_type_not_eligible") if not applicant_type_row

applicant_issue("public_body_share_above_25_percent") if {
	applicant_type_row.max_public_body_share_percent != null
	object.get(applicant, "public_body_share_percent", 0) > applicant_type_row.max_public_body_share_percent
}

# O6_21-APPL-02: Gebietskörperschaften sind bei dieser Maßnahme ausgeschlossen (keine Ausnahme für Maßnahme 21).
applicant_issue("public_body_excluded") if {
	object.get(applicant, "is_public_body", false)
	not public_body_exception_for_measure
}

public_body_exception_for_measure if {
	some m in lib.tables.public_body_eligible_measures
	m.srl_number == "21"
}

# O6_21-APPL-03: aktiver Landwirt, landwirtschaftliche Tätigkeit, Betrieb im eigenen Namen und auf eigene Rechnung.
applicant_issue("not_active_farmer") if not object.get(applicant, "is_active_farmer", false)

applicant_issue("farm_not_managed_in_own_name") if {
	not object.get(applicant, "manages_farm_in_own_name_and_account", false)
}

applicant_issues := {code |
	some code in {
		"person_type_not_eligible",
		"public_body_share_above_25_percent",
		"public_body_excluded",
		"not_active_farmer",
		"farm_not_managed_in_own_name",
	}
	applicant_issue(code)
}

# --- Höhere Gewalt (GSP-AV § 6, § 7) -------------------------------------------------------------

# O6_21-FM-01: Geltendmachung binnen drei Wochen ab dem Zeitpunkt, ab dem dies möglich ist, mit Unterlagen.
recognised_force_majeure_events contains ev.event_id if {
	some ev in object.get(mi, "force_majeure_events", [])
	ev.reported_on != null
	lib.days_between(ev.able_to_report_from, ev.reported_on) <= lib.deadlines.force_majeure_notification_days
	ev.documented
}

late_force_majeure_events contains ev.event_id if {
	some ev in object.get(mi, "force_majeure_events", [])
	ev.reported_on != null
	lib.days_between(ev.able_to_report_from, ev.reported_on) > lib.deadlines.force_majeure_notification_days
}

# O6_21-FM-03: natürliche Umstände (z. B. Tod durch Krankheit/Unfall) – keine Verwaltungssanktion bei
# schriftlicher Meldung binnen drei Wochen nach Feststellung der Reduzierung.
natural_circumstance_sanction_waived contains ev.event_id if {
	some ev in object.get(mi, "natural_circumstance_events", [])
	lib.days_between(ev.reduction_found_on, ev.reported_on) <= lib.deadlines.natural_circumstances_notification_days
}

# --- Kontrollen (SRL 1.11) -------------------------------------------------------------------------

# O6_21-CTRL-01: Verweigerung/Verhinderung der Vor-Ort-Kontrolle (ohne höhere Gewalt) führt zur Ablehnung,
# keine Prämie im laufenden Jahr, Beendigung und Rückabwicklung der Verträge.
control_refused if {
	object.get(mi, "control_refused", false)
	not object.get(mi, "control_refusal_due_to_force_majeure", false)
}

# --- Sanktionen (SRL 1.12, GSP-AV § 48, ATB 8.2) -------------------------------------------------

stage_row(stage) := row if {
	some row in lib.tables.sanction_stages
	row.stage == stage
}

# O6_21-SANC-02: ab 2027 statt Verwarnung Einbehalt von 1 % der Maßnahmenprämie.
stage_percent(stage) := lib.tables.sanction_rules.warning_withholding_percent_from_2027 if {
	stage == 1
	lib.year >= lib.tables.sanction_rules.warning_replaced_from_year
}

stage_percent(stage) := stage_row(stage).reduction_percent if {
	stage != 1
}

stage_percent(stage) := 0 if {
	stage == 1
	lib.year < lib.tables.sanction_rules.warning_replaced_from_year
}

violation_stages := object.get(mi, "content_violation_stages", [])

# O6_21-SANC-01: Kumulation durch Addition der Prozentsätze, Obergrenze 100 % der Jahresprämie.
content_reduction_percent := min([lib.tables.sanction_rules.max_cumulated_reduction_percent, sum([stage_percent(s) | some s in violation_stages])])

# O6_21-SANC-03: zweimalige 100 %-Kürzung im Vertragszeitraum → Ausschluss und Rückforderung.
full_reductions_total := object.get(mi, "previous_full_reductions_in_period", 0) + count([1 | content_reduction_percent == 100])

exclusion_from_measure if full_reductions_total >= lib.tables.sanction_rules.full_reductions_for_exclusion

# --- Aufbewahrung, Auszahlung (GSP-AV § 16, § 52; SRL 1.10.7) -------------------------------------

# O6_21-REC-01: Aufbewahrung vier Jahre vom Ende des Kalenderjahres, auf das sich die Zahlungen beziehen.
records_retention_until := sprintf("%d-12-31", [lib.year + lib.deadlines.record_retention_years_after_year_end])

# O6_21-PAY-03: Auszahlung bis 30. Juni des Folgejahres, Zahlungen nicht vor dem 1. Dezember des Antragsjahres.
payment_window := {
	"not_before": sprintf("%d-%s", [lib.year, lib.tables.payment.payments_not_before_month_day_application_year]),
	"until": sprintf("%d-%s", [lib.year + 1, lib.tables.payment.payment_deadline_month_day_following_year]),
}

# O6_21-PAY-04: Vorauszahlung max. 75 % nach Abschluss der Verwaltungskontrolle.
max_advance_payment(amount) := lib.r2(amount * lib.tables.payment.advance_payment_max_share)

# O6_21-REC-02: Betriebsübertragung binnen vier Wochen ab Wirksamkeit anzuzeigen.
farm_transfer_notification_late if {
	t := object.get(mi, "farm_transfer", null)
	t != null
	lib.days_between(t.effective_on, t.notified_on) > lib.deadlines.farm_transfer_notification_days
}

# O6_21-PAY-05: Rückforderung binnen vier Wochen; Absehen von Wiedereinziehung bis 100 € (Zinsen allein bis 50 €).
recovery_may_be_waived(amount, interest_only) if {
	not interest_only
	amount <= lib.tables.payment.recovery_waiver_max_eur
}

recovery_may_be_waived(amount, interest_only) if {
	interest_only
	amount <= lib.tables.payment.recovery_waiver_interest_only_max_eur
}
