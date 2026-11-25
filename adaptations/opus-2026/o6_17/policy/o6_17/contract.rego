# Modul:
#   o6_17 – Vertragszeitraum, Flächenänderungen, Übernahme, Sanktionen und Abwicklung
package oepul.o6_17

gen := cfg.general

contract_duration_years := contract_period_row.duration_years

contract_end_date := gen.contract_end_date

# ---------------------------------------------------------------------------
# Flächenabgang: Toleranz jährlich 5 %, höchstens 5 ha, jedenfalls 0,5 ha (Bezug: Vorjahresfläche)
# ---------------------------------------------------------------------------
reduction_cfg := gen.area_reduction_tolerance

area_reduction_tolerance_ha := max([
	min([reduction_cfg.max_share_per_year * o617.previous_year_committed_area_ha, reduction_cfg.max_ha_per_year]),
	reduction_cfg.always_allowed_ha_per_year,
])

area_reduction_ha := max([
	0,
	(o617.previous_year_committed_area_ha - o617.committed_area_ha) - object.get(o617, "reduction_exempt_ha", 0),
])

area_reduction_repayment_required if area_reduction_ha > area_reduction_tolerance_ha

# Rückzahlungspflicht für die gesamten mit der Maßnahme belegten Differenzflächen
area_reduction_repayment_area_ha := area_reduction_ha if area_reduction_repayment_required

# ---------------------------------------------------------------------------
# Vorzeitiger Ausstieg aus der mehrjährigen Maßnahme
# ---------------------------------------------------------------------------
repayment_free_exit_reasons := {"loss_of_control", "force_majeure", "permanent_circumstances", "revision_clause"}

early_exit if {
	d := object.get(o617, "exit_date", null)
	is_string(d)
	d < contract_end_date
}

early_exit_repayment_required if {
	early_exit
	not object.get(o617, "exit_reason", "") in repayment_free_exit_reasons
}

# ---------------------------------------------------------------------------
# Maßnahmenübernahme (bis 15.04., 2023 und 2028 bis 17.04.; Ausweitung max. 50 %)
# ---------------------------------------------------------------------------
takeover := object.get(o617, "takeover", null)

takeover_deadline(y) := sprintf("%d-%s", [y, gen.measure_takeover.deadline_mmdd_special_years]) if y in {s | some s in gen.measure_takeover.special_years}

takeover_deadline(y) := sprintf("%d-%s", [y, gen.measure_takeover.deadline_mmdd]) if not y in {s | some s in gen.measure_takeover.special_years}

takeover_permitted if {
	is_object(takeover)
	takeover.date <= takeover_deadline(to_number(substring(takeover.date, 0, 4)))
	object.get(takeover, "expansion_share", 0) <= gen.measure_takeover.max_expansion_share
	object.get(takeover, "taker_already_participating", false) == false
}

# ---------------------------------------------------------------------------
# Inhaltliche Sanktionen (§ 48 GSP-AV, Stufenschema)
# ---------------------------------------------------------------------------
findings := object.get(o617, "findings", [])

findings_this_year := [f | some f in findings; f.year == application_year]

escalated_stage(f) := min([f.base_stage + object.get(f, "prior_occurrences_same_obligation", 0), 7])

stage_percent(stage) := row.reduction_percent_until_2026 if {
	application_year < 2027
	some row in gen.sanction_stages
	row.stage == stage
}

stage_percent(stage) := row.reduction_percent_from_2027 if {
	application_year >= 2027
	some row in gen.sanction_stages
	row.stage == stage
}

content_reduction_percent := min([100, sum([stage_percent(escalated_stage(f)) | some f in findings_this_year])])

full_reduction_this_year if content_reduction_percent == 100

full_reductions_in_period := object.get(o617, "previous_full_reductions", 0) + 1 if full_reduction_this_year

full_reductions_in_period := object.get(o617, "previous_full_reductions", 0) if not full_reduction_this_year

exclusion_from_measure if full_reductions_in_period >= gen.exclusion_after_full_reductions

# ---------------------------------------------------------------------------
# Übererklärung (§ 46 GSP-AV)
# ---------------------------------------------------------------------------
declared_area_ha := base_premium_area_ha

determined_area_ha := sum([object.get(p, "determined_area_ha", p.area_ha) | some p in parcels; base_premium_eligible(p)])

overdeclaration_ha := max([0, declared_area_ha - determined_area_ha])

overdeclaration_sanction_applies if overdeclaration_ha > gen.overdeclaration.threshold_share * determined_area_ha

overdeclaration_sanction_applies if overdeclaration_ha > gen.overdeclaration.threshold_ha

overdeclaration_payment_basis_ha := max([0, determined_area_ha - (gen.overdeclaration.penalty_factor * overdeclaration_ha)]) if overdeclaration_sanction_applies

overdeclaration_payment_basis_ha := determined_area_ha if not overdeclaration_sanction_applies

# ---------------------------------------------------------------------------
# Höhere Gewalt: Geltendmachung binnen drei Wochen (§ 6 Abs. 2 GSP-AV)
# ---------------------------------------------------------------------------
force_majeure_events := object.get(o617, "force_majeure_events", [])

force_majeure_notified_in_time(ev) if {
	able_ns := time.parse_ns("2006-01-02", ev.able_to_notify_date)
	notified_ns := time.parse_ns("2006-01-02", ev.notification_date)
	notified_ns - able_ns <= ((gen.force_majeure_notification_days * 24) * 3600) * 1000000000
}

violations contains v if {
	some ev in force_majeure_events
	not force_majeure_notified_in_time(ev)
	v := {"rule_id": "O6_17-GSPAV-6-FORCE-MAJEURE-NOTICE", "parcel_id": null, "message": "Höhere Gewalt nicht binnen drei Wochen geltend gemacht"}
}

# ---------------------------------------------------------------------------
# Gesamtentscheidung
# ---------------------------------------------------------------------------
default first_participation_year := false

default is_livestock_farm := false

# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------
decision := {
	"measure": "o6_17",
	"application_year": application_year,
	"first_participation_year": first_participation_year,
	"access_violations": access_violations,
	"violations": violations,
	"is_livestock_farm": is_livestock_farm,
	"premium_total_eur": premium_total_eur,
	"modulation_factor": modulation_factor,
	"soil_samples_required": [n | n := soil_samples_required],
}
