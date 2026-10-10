# Weiterbildung, Gewässerschutzkonzept und Bodenuntersuchung (Kapitel 4.4, 4.5, 4.9 Informationsblatt; SRL 2.16).
package oepul.o6_16

import data.o6_16 as d

one_off_deadline := "2026-12-31"

credit_start := "2022-01-01"

one_off_obligations_due if year >= 2026

training_courses := object.get(doc16, ["training", "courses"], [])

# Anrechenbar: Kurse ab 01.01.2022 bis 31.12.2026 eines anerkannten Bildungsanbieters, keine Doppelanrechnung
course_creditable(c) if {
	c.date >= credit_start
	c.date <= one_off_deadline
	object.get(c, "provider_recognized", false) == true
	object.get(c, "counted_for_other_commitment", false) != true
	object.get(c, "counted_for_other_farm", false) != true
	object.get(c, "attendee_role", "farm_manager") in {"applicant", "farm_manager", "involved_person"}
}

creditable_training_hours := sum([c.hours |
	some c in training_courses
	course_creditable(c)
	object.get(c, "wien_additional", false) != true
])

wien_additional_training_hours := sum([c.hours |
	some c in training_courses
	course_creditable(c)
	object.get(c, "wien_additional", false) == true
])

obligation_violations contains v if {
	one_off_obligations_due
	creditable_training_hours < 10
	v := {
		"rule_id": "O616-TRN-001",
		"message": sprintf("Nur %v anrechenbare Weiterbildungsstunden bis 31.12.2026 (mind. 10 Stunden)", [creditable_training_hours]),
	}
}

# Verlässt die geschulte Person vor dem 31.12.2026 den Betrieb, ist ein Kurs bis dahin nachzuholen
obligation_violations contains v if {
	left := object.get(doc16, ["training", "trained_person_left_date"], null)
	left != null
	left < one_off_deadline
	object.get(doc16, ["training", "replacement_course_completed"], false) != true
	one_off_obligations_due
	v := {
		"rule_id": "O616-TRN-004",
		"message": "Geschulte Person hat den Betrieb vor dem 31.12.2026 verlassen; Kurs wurde nicht nachgeholt",
	}
}

obligation_violations contains v if {
	object.get(doc16, ["training", "confirmation_submitted_on_request"], true) == false
	v := {
		"rule_id": "O616-TRN-005",
		"message": "Kursbesuchsbestätigung nach Aufforderung nicht an die AMA übermittelt",
	}
}

# Betriebsbezogenes Gewässerschutzkonzept einmalig bis 31.12.2026
obligation_violations contains v if {
	one_off_obligations_due
	not water_protection_concept_on_time
	v := {
		"rule_id": "O616-TRN-002",
		"message": "Betriebsbezogenes Gewässerschutzkonzept nicht bis 31.12.2026 erstellt",
	}
}

water_protection_concept_on_time if {
	c := object.get(doc16, "water_protection_concept_date", null)
	c != null
	c <= one_off_deadline
}

# Zuschlag Wien: zusätzlich 3 Stunden Bildung und Beratung bis 31.12.2026
obligation_violations contains v if {
	wien_option_applied
	one_off_obligations_due
	wien_additional_training_hours < 3
	v := {
		"rule_id": "O616-WIEN-004",
		"message": "Zuschlag Wien: zusätzliche 3 Stunden Bildung/Beratung (Bodenproben, Humusaufbau, pfluglose Bodenbearbeitung) fehlen",
	}
}

# --- Bodenuntersuchung: pro angefangene 5 ha Ackerfläche (MFA 2026) in der Gebietskulisse mind. 1 Probe ---
soil_basis_area_ha := object.get(o16, "gwa_arable_area_mfa_2026_ha", gwa_arable_area_ha)

soil_samples_required_for(area_ha) := ceil_div(area_ha, 5)

soil_samples_required := soil_samples_required_for(soil_basis_area_ha)

wien_basis_area_ha := object.get(o16, "wien_arable_area_mfa_2026_ha", wien_arable_area_ha)

# Zuschlag Wien: doppelt so viele Proben, d. h. mind. 2 Proben je angefangene 5 ha im Gebiet Wien
wien_soil_samples_required := 2 * soil_samples_required_for(wien_basis_area_ha)

soil_samples := object.get(doc16, "soil_samples", [])

required_parameters := {x | some x in d.soil_sample_parameters}

sample_creditable(s) if {
	s.sample_date >= credit_start
	s.lab_submission_date <= one_off_deadline
	object.get(s, "accredited_lab", false) == true
	params := {x | some x in object.get(s, "parameters", [])}
	count(required_parameters - params) == 0
	object.get(s, "n_parameter", "") in {"mineral_n", "mineralisable_n"}
	object.get(s, "method", "") in {"sgd", "euf"}
	object.get(s, "taken_over_with_parcel", false) != true
}

creditable_soil_samples := count([s | some s in soil_samples; sample_creditable(s)])

creditable_wien_soil_samples := count([s |
	some s in soil_samples
	sample_creditable(s)
	object.get(s, "in_wien_area", false) == true
])

obligation_violations contains v if {
	one_off_obligations_due
	creditable_soil_samples < soil_samples_required
	v := {
		"rule_id": "O616-SOIL-001",
		"message": sprintf("%v anrechenbare Bodenproben, erforderlich %v", [creditable_soil_samples, soil_samples_required]),
	}
}

obligation_violations contains v if {
	some s in soil_samples
	sample_creditable(s)
	object.get(s, "entered_in_invekos_gis", false) != true
	v := {
		"rule_id": "O616-SOIL-003",
		"message": sprintf("Ergebnis der Bodenprobe %v nicht im INVEKOS-GIS erfasst", [object.get(s, "sample_id", "?")]),
	}
}

obligation_violations contains v if {
	wien_option_applied
	creditable_wien_soil_samples < wien_soil_samples_required
	in_contract_period
	year == 2028
	v := {
		"rule_id": "O616-WIEN-005",
		"message": sprintf("Zuschlag Wien: %v Bodenproben im Gebiet Wien, erforderlich %v", [creditable_wien_soil_samples, wien_soil_samples_required]),
	}
}
