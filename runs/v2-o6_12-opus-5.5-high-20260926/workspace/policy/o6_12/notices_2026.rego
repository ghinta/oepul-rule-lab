# Maßnahme 12 – Sonderregelungen 2026: rückzahlungsfreier Ausstieg wegen Amerikanischer
# Rebzikade, Bekämpfung in verordneten Gebieten sowie Meldung höherer Gewalt (Trockenheit).
package oepul.o6_12

leafhopper_exit := object.get(o6_12_input, ["leafhopper_exit"], {})

leafhopper_exit_request_date := leafhopper_exit.request_date

leafhopper_exit_findings contains "exit_before_2026_not_covered" if {
	leafhopper_exit.requested == true
	year_of(leafhopper_exit.request_date) < measure.leafhopper_repayment_free_exit_from_year
}

leafhopper_exit_findings contains "farm_has_no_wine_area" if {
	leafhopper_exit.requested == true
	not farm_has_wine_area
}

leafhopper_exit_findings contains "reason_leafhopper_not_stated" if {
	leafhopper_exit.requested == true
	object.get(leafhopper_exit, "reason_leafhopper_stated", false) == false
}

leafhopper_exit_findings contains "not_submitted_via_force_majeure_form" if {
	leafhopper_exit.requested == true
	object.get(leafhopper_exit, "submitted_via_eama_force_majeure_form", false) == false
}

leafhopper_exit_eligible if {
	participates
	leafhopper_exit.requested == true
	count(leafhopper_exit_findings) == 0
}

leafhopper_exit_approved if {
	leafhopper_exit_eligible
	object.get(leafhopper_exit, "approved", true) != false
}

default leafhopper_exit_approved := false

# Vertragszeitraum endet mit Beginn der einzelbetrieblichen Meldung.
contract_end_after_leafhopper_exit := leafhopper_exit_request_date if leafhopper_exit_approved

# --- Verordnete Bekämpfung in festgelegten Gebieten (ST, B, NÖ) ---
designated_area_orders contains o if {
	some o in authority_orders
	o.federal_state in measure.leafhopper_order_states
	o.in_designated_area == true
}

# Verbleib ohne Prämieneinbußen, wenn CS-Wirkstoff angeordnet bzw. keine Bio-Wirkstoffe verfügbar.
designated_area_chemical_synthetic_permitted if {
	some o in designated_area_orders
	order_covers_chemical_synthetic(o)
}

# Übermittlung der Anordnung an die AMA ab 2026 nicht erforderlich (Codierung entfallen).
authority_order_submission_to_ama_required if psm_coding_required

default authority_order_submission_to_ama_required := false

# --- Höhere Gewalt (SRL 1.7.4.1; Notice Trockenheit 2026) ---
force_majeure := object.get(oepul, ["force_majeure"], {})

force_majeure_claim_required if {
	force_majeure.obligations_not_met_due_to_drought == true
	object.get(force_majeure, "claim_submitted", false) == false
}
