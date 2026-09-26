package oepul.o6_14

# Allgemeine Bedingungen mit Bezug zur Almbewirtschaftung: Kombinationen,
# Vertragseinhaltung, Rueckforderung, Sanktionen, hoehere Gewalt, 2026-Hinweise.

# --- Kombinationen -----------------------------------------------------------

# Anhang L: Zeile 14 enthaelt keine Eintraege -> auf der Einzelflaeche mit keiner
# der gelisteten Flaechenmassnahmen praemienmaessig kombinierbar.
single_area_combinable_with(code) if {
	some row in combos.annex_l_row_14
	row.measure_code == code
	row.combinable_on_single_area == true
}

combination_violations contains v if {
	some alm in alms
	some plot in object.get(alm, "plots", [])
	some code in object.get(plot, "other_area_measures", [])
	not single_area_combinable_with(code)
	v := {"rule_id": "O614-GEN-015", "category": "combination", "subject": plot.plot_id, "message": sprintf("Almbewirtschaftung ist auf der Einzelflaeche nicht mit Massnahme %s kombinierbar (Anhang L).", [code])}
}

# Tierwohl - Behirtung setzt die Teilnahme an der Almbewirtschaftung voraus.
combination_violations contains v if {
	participates_in("tierwohl_behirtung")
	not is_true(measure_input, "applied")
	not takeover_valid
	v := {"rule_id": "O614-GEN-018", "category": "combination", "subject": "farm", "message": "Tierwohl - Behirtung erfordert die Teilnahme an der Massnahme Almbewirtschaftung."}
}

# Tierwohl - Stallhaltung Rinder: reduzierter Satz bei gleichzeitiger
# tierbezogener Beantragung in der Almbewirtschaftung.
stallhaltung_rinder_rate_eur_per_rgve(animal_id) := row.reduced_eur_per_rgve if {
	some row in combos.related_measure_effects
	row.measure_code == "21"
	animal_by_id[animal_id].species == "cattle"
	count(stays(animal_by_id[animal_id])) > 0
}

stallhaltung_rinder_rate_eur_per_rgve(animal_id) := row.standard_eur_per_rgve if {
	some row in combos.related_measure_effects
	row.measure_code == "21"
	not applied_in_alm(animal_id)
}

applied_in_alm(animal_id) if {
	animal_by_id[animal_id].species == "cattle"
	count(stays(animal_by_id[animal_id])) > 0
}

# --- Vertragseinhaltung / Ausstieg ---------------------------------------------

exit := object.get(af, "exit", {})

# Vorzeitiger Ausstieg aus der mehrjaehrigen Massnahme bzw. NATA fuehrt zur
# Rueckforderung, ausser bei Verlust der Verfuegungsgewalt, Revisionsklausel,
# hoeherer Gewalt oder anerkannten dauerhaften Umstaenden.
repayment_exempt_reasons := {"loss_of_control", "revision_clause", "force_majeure", "permanent_circumstance_reported"}

repayment_required if {
	is_true(exit, "exited")
	date_ns(exit.exit_date) < date_ns(contract_end_date)
	not exit.reason in repayment_exempt_reasons
}

# Betriebsuebertragung: Nachfolger tritt dem Vertrag bei, keine Rueckforderung.
operator_change_continues_contract if is_true(exit, "operator_change")

# Almflaechen und Tiere sind an die jaehrlich verfuegbaren Flaechen/Tiere
# gebunden (Punkt 1.7.2.5) - keine Flaechenabgangs-/Zugangsbeschraenkung.
area_bound_to_annual_availability := true

# Zahlungsantrag in einem Folgejahr nicht abgegeben.
missing_payment_claim_consequence := "commitment_continues_no_payment" if {
	is_true(measure_input, "payment_claim_missing")
	not is_true(measure_input, "payment_claim_missing_over_one_year")
}

missing_payment_claim_consequence := "commitment_ends_full_repayment" if is_true(measure_input, "payment_claim_missing_over_one_year")

# --- Hoehere Gewalt / Umstaende ---------------------------------------------

circumstance := object.get(af, "circumstance", {})

# Dauerhafte flaechen- oder bewirtschaftungsverandernde Umstaende: Praemie im
# Eintrittsjahr moeglich, wenn der Eintritt nach dem Almauftrieb erfolgt.
permanent_circumstance_premium_possible if {
	circumstance.type == "permanent"
	is_true(circumstance, "reported")
	first_up := min([first_drive_up_date(a) | some a in animals; count(stays(a)) > 0])
	after(circumstance.occurrence_date, first_up)
}

permanent_circumstance_premium_possible if {
	circumstance.type == "permanent"
	is_true(circumstance, "reported")
	is_true(circumstance, "force_majeure")
}

# Duerre 2026: Ansuchen auf hoehere Gewalt z. B. bei fehlender
# Wasserversorgung auf Almen (einzelbetrieblich ueber eAMA "Eingaben").
drought_2026_force_majeure_possible if {
	year == 2026
	is_true(circumstance, "drought_prevents_compliance")
}

drought_2026_force_majeure_recognised if {
	drought_2026_force_majeure_possible
	is_true(circumstance, "force_majeure_application_submitted")
}

# --- Sanktionsschema -----------------------------------------------------------

sanction_stage_share(stage, y) := s.reduction_share if {
	some s in proc.sanction_stages
	s.stage == stage
	stage_year_ok(s, y)
}

stage_year_ok(s, y) if {
	y <= object.get(s, "year_to", 9999)
	y >= object.get(s, "year_from", 0)
}

# Reihenfolge der Mehrfachkuerzungen (Punkt 1.12.2 SRL).
multiple_reduction_order := proc.multiple_reduction_order

reduction_step_index(step) := i if {
	some i, s in proc.multiple_reduction_order
	s == step
}

# Allgemeine Flaechenabgangstoleranz mehrjaehriger Massnahmen: 5 % der
# Vorjahresflaeche, hoechstens 5 ha, jedenfalls 0,50 ha. Fuer die
# Almbewirtschaftung nicht angewendet (area_bound_to_annual_availability).
area_reduction_allowed_ha(prev_ha) := max([
	proc.area_reduction_tolerance.always_allowed_ha,
	min([prev_ha * proc.area_reduction_tolerance.max_share, proc.area_reduction_tolerance.max_ha]),
])

# Kombinierbarkeit der optionalen Zuschlaege.
supplements_combinable(a, b) if {
	not supplement_exclusion(a, b)
	not supplement_exclusion(b, a)
}

supplement_exclusion(a, b) if {
	some row in combos.supplement_exclusions
	row.supplement_a == a
	row.supplement_b == b
	row.combinable == false
}

# Einzelgehoelze werden bei Anhang-E-Flaechenanteilen mit 100 m2 angerechnet.
isolated_trees_area_ha(n) := (n * rates.isolated_tree_counted_area_m2) / 10000

exclusion_from_measure if object.get(object.get(af, "sanction_history", {}), "full_reductions_in_contract_period", 0) >= 2

refused_control if is_true(object.get(af, "control", {}), "refused")

# --- Gesamtergebnis ----------------------------------------------------------------

all_violations := violations | combination_violations

decision := {
	"measure": "o6_14",
	"year": year,
	"access_conditions_met": access_conditions_met,
	"access_consequence": access_consequence,
	"obligations_met": obligations_met,
	"violations": all_violations,
	"animal_notices": animal_notices,
	"premium": premium_summary,
	"contract_end_date": contract_end_or_null,
	"control_refused": refused_control_value,
}

refused_control_value if refused_control

refused_control_value := false if not refused_control

contract_end_or_null := contract_end_date

default contract_end_or_null := null
