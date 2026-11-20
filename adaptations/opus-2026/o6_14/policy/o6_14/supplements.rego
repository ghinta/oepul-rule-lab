package oepul.o6_14

# Optionale Zuschlaege "Naturschutz auf der Alm" (NATA) und "Almweideplan".

# --- Naturschutz auf der Alm -----------------------------------------------------

project_confirmation_all_plots(alm) if {
	plots := object.get(alm, "plots", [])
	count(plots) > 0
	every plot in plots {
		is_true(plot, "project_confirmation")
	}
}

nature(alm) := object.get(alm, "nature_conservation", {})

nata_forbidden_fertilised_habitats := {"moor", "wetland", "calcareous_grassland", "siliceous_grassland"}

nata_violations contains v if {
	some alm in alms
	nata_alm(alm)
	not project_confirmation_all_plots(alm)
	v := {"rule_id": "O614-ACCESS-004", "category": "access", "subject": alm.alm_id, "message": "Zuschlag Naturschutz auf der Alm erfordert eine Projektbestaetigung fuer alle Feldstuecke der Alm."}
}

nata_violations contains v if {
	some alm in alms
	nata_alm(alm)
	is_false(nature(alm), "project_requirements_met")
	v := {"rule_id": "O614-NATA-001", "category": "obligation", "subject": alm.alm_id, "message": "Bewirtschaftungsauflagen gemaess Projektbestaetigung nicht auf allen Feldstuecken eingehalten."}
}

nata_violations contains v if {
	some alm in alms
	nata_alm(alm)
	some h in object.get(nature(alm), "fertilised_habitats", [])
	h in nata_forbidden_fertilised_habitats
	v := {"rule_id": "O614-NATA-003", "category": "obligation", "subject": alm.alm_id, "message": sprintf("Duengung in %s verboten (Ausnahme nur Borstgrasrasen).", [h])}
}

nata_violations contains v if {
	some alm in alms
	nata_alm(alm)
	some key in ["terrain_correction", "new_drainage"]
	is_true(nature(alm), key)
	v := {"rule_id": "O614-NATA-004", "category": "obligation", "subject": alm.alm_id, "message": sprintf("Unzulaessige Massnahme: %s.", [key])}
}

nata_violations contains v if {
	some alm in alms
	nata_alm(alm)
	is_true(nature(alm), "drainage_upgraded")
	not is_true(nature(alm), "drainage_upgrade_consent")
	v := {"rule_id": "O614-NATA-004", "category": "obligation", "subject": alm.alm_id, "message": "Bestehende Drainagen nur im Einvernehmen mit der Naturschutzstelle des Landes ertuechtigen."}
}

nata_violations contains v if {
	some alm in alms
	nata_alm(alm)
	is_true(nature(alm), "watering_point_in_wetland_or_spring")
	v := {"rule_id": "O614-NATA-005", "category": "obligation", "subject": alm.alm_id, "message": "Traenkestellen duerfen nicht in Feuchtflaechen oder Quellfluren errichtet werden."}
}

nata_violations contains v if {
	some alm in alms
	nata_alm(alm)
	some m in nata_measures(alm)
	not valid_nata_code(m.code)
	v := {"rule_id": "O614-NATA-011", "category": "obligation", "subject": alm.alm_id, "message": sprintf("Unbekannter Auflagencode %s gemaess Anhang E.", [m.code])}
}

valid_nata_code(code) if {
	some r in rates.nature_conservation_measure_codes
	r.code == code
}

nata_course := object.get(nata_input, "course", {})

nata_course_valid if {
	is_true(nata_course, "completed")
	nata_course.hours >= proc.nature_conservation_course.min_hours
	on_or_before(nata_course.completion_date, proc.nature_conservation_course.deadline)
	on_or_before(proc.nature_conservation_course.creditable_from, nata_course.completion_date)
	is_true(nata_course, "provider_recognized")
	is_true(nata_course, "content_nature_conservation_related")
	nata_course.attendee_role in {"alm_manager", "herder", "significantly_involved_person"}
	not is_true(nata_course, "credited_to_other_farm")
	not is_true(nata_course, "double_counted")
	not trained_person_left_without_replacement
}

trained_person_left_without_replacement if {
	is_true(nata_course, "trained_person_left_date_known")
	on_or_before(nata_course.trained_person_left_date, proc.nature_conservation_course.deadline)
	not is_true(nata_course, "replacement_course_completed")
}

# Kurspflicht besteht ab dem Jahr, in dem die Frist 31.12.2025 abgelaufen ist
# bzw. der Kurs bereits absolviert sein muss.
nata_violations contains v if {
	nata_applied
	year >= 2025
	not nata_course_valid
	v := {"rule_id": "O614-NATA-006", "category": "obligation", "subject": "nature_conservation_supplement", "message": "Fachspezifischer Kurs (mind. 4 Stunden, anerkannter Bildungsanbieter, ab 01.01.2022, bis 31.12.2025) nicht nachgewiesen."}
}

nata_violations contains v if {
	nata_applied
	awp_applied
	not supplements_combinable("grazing_plan", "nature_conservation")
	v := {"rule_id": "O614-AWP-008", "category": "combination", "subject": "farm", "message": "Zuschlag Almweideplan ist nicht mit dem Zuschlag Naturschutz auf der Alm kombinierbar."}
}

# --- Almweideplan -----------------------------------------------------------

awp_course := object.get(awp_input, "course", {})

awp_plan := object.get(awp_input, "plan", {})

awp_first_year := object.get(awp_input, "first_application_year", year)

awp_course_valid if {
	is_true(awp_course, "completed")
	awp_course.hours >= proc.grazing_plan_course.min_hours
	on_or_before(proc.grazing_plan_course.creditable_from, awp_course.completion_date)
	on_or_before(awp_course.completion_date, deadline_date("grazing_plan_course", awp_first_year))
	is_true(awp_course, "provider_recognized")
	is_true(awp_course, "covers_required_topics")
	awp_course.attendee_role in {"farm_manager", "alm_manager", "significantly_involved_person"}
	not is_true(awp_course, "credited_to_other_farm")
	not is_true(awp_course, "double_counted")
}

awp_plan_contents := [
	"covers_all_alms",
	"assessment_site_yield",
	"assessment_ecological_value",
	"development_goals_and_management_needs",
	"grazing_and_steering_measures_per_plot",
	"created_with_or_communicated_to_involved_persons",
]

awp_obligation_violations contains v if {
	awp_applied
	not awp_course_valid
	v := {"rule_id": "O614-AWP-002", "category": "obligation", "subject": "grazing_plan_supplement", "message": "Bildungsveranstaltung Almweideplan (mind. 4 Stunden, ab 01.10.2024, bis 15.07. des ersten Jahres) nicht nachgewiesen."}
}

awp_obligation_violations contains v if {
	awp_applied
	not awp_plan.created_date
	v := {"rule_id": "O614-AWP-003", "category": "obligation", "subject": "grazing_plan_supplement", "message": "Almweideplan nicht erstellt."}
}

awp_obligation_violations contains v if {
	awp_applied
	awp_plan.created_date
	after(awp_plan.created_date, deadline_date("grazing_plan_creation", year))
	v := {"rule_id": "O614-AWP-003", "category": "obligation", "subject": "grazing_plan_supplement", "message": "Almweideplan nicht bis 15.07. des Teilnahmejahres erstellt."}
}

awp_obligation_violations contains v if {
	awp_applied
	some key in awp_plan_contents
	not is_true(awp_plan, key)
	v := {"rule_id": "O614-AWP-004", "category": "obligation", "subject": "grazing_plan_supplement", "message": sprintf("Almweideplan unvollstaendig: %s.", [key])}
}

awp_obligation_violations contains v if {
	awp_applied
	year > awp_first_year
	not is_true(awp_plan, "annual_review_documented")
	v := {"rule_id": "O614-AWP-005", "category": "obligation", "subject": "grazing_plan_supplement", "message": "Ab dem zweiten Teilnahmejahr jaehrliche dokumentierte Ueberpruefung des Almweideplans erforderlich."}
}

awp_obligation_violations contains v if {
	awp_applied
	some alm in alms
	gp := object.get(alm, "grazing_plan", {})
	is_true(gp, "increased_intensity_applied")
	not is_true(gp, "increased_intensity_justified_in_plan")
	v := {"rule_id": "O614-AWP-006", "category": "obligation", "subject": alm.alm_id, "message": "Verstaerkte Weideintensitaet (bis 2,40 RGVE/ha) erfordert eine Begruendung im Almweideplan."}
}

awp_violations := awp_obligation_violations

# Almweideplan: einjaehriger Vertragszeitraum, automatische Verlaengerung.
awp_active_next_year if {
	awp_applied
	not is_true(awp_input, "deregistered")
	year + 1 <= last_entry("grazing_plan_supplement").last_commitment_year
}

awp_takeover_allowed(context) if {
	some row in combos.takeover_only_in_individual_cases
	row.item == "grazing_plan_supplement"
	context in row.allowed_contexts
}
