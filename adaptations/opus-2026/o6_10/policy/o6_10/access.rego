# o6_10 – Zugangsvoraussetzungen, Vertragszustandekommen und Vertragsgültigkeit
package oepul.o6_10

applicant := object.get(input, ["farm", "applicant"], {})

# --- Beantragung (O610-APP-DEADLINE, O610-APP-LAST-ENTRY) --------------------------

application_date := d if {
	d := object.get(o610, "measure_application_date", null)
	d != null
}

# Vertragsbeginn = 1.1. des Folgejahres der fristgerechten Beantragung (bis 31.12.)
contract_start_year := year_of(application_date) + 1

applied_via_measure_application if {
	contract_start_year <= params.last_entry_funding_year
	contract_start_year <= year
}

# --- Maßnahmenübernahme (O610-GEN-TAKEOVER) ----------------------------------------

takeover := object.get(o610, "takeover", {})

takeover_deadline_md := params.takeover_deadline_month_day_2023_2028 if {
	year in {2023, 2028}
}

else := params.takeover_deadline_month_day

takeover_valid if {
	object.get(takeover, "is_takeover", false) == true
	date_ns(takeover.request_date) <= md_ns(year, takeover_deadline_md)
	year_of(takeover.request_date) == year
	object.get(takeover, "farm_already_participating", false) == false
	object.get(takeover, "additional_area_ha", 0) <= (object.get(takeover, "taken_over_area_ha", 0) * params.takeover_max_extension_percent) / 100
}

takeover_rejections contains {"rule_id": "O610-GEN-TAKEOVER", "reason": msg} if {
	object.get(takeover, "is_takeover", false) == true
	not takeover_valid
	msg := "Maßnahmenübernahme unzulässig (Frist 15.04./17.04., bisher nicht teilnehmender Betrieb, Ausweitung höchstens 50 %)"
}

has_commitment_basis if applied_via_measure_application

has_commitment_basis if takeover_valid

# --- Abmeldung / Ausstieg (O610-EXIT-TIMING, O610-GEN-EXIT-CONTROL-LIMIT, O610-GEN-REENTRY) ---

deregistration_date := d if {
	d := object.get(o610, "deregistration_date", null)
	d != null
}

control_announced_date := d if {
	d := object.get(o610, "on_site_control_announced_date", null)
	d != null
}

# Ausstieg nach Ankündigung/Durchführung einer Vor-Ort-Kontrolle desselben Jahres ist nicht mehr möglich
deregistration_blocked if {
	year_of(control_announced_date) == year_of(deregistration_date)
	date_ns(deregistration_date) >= date_ns(control_announced_date)
}

# Neuerliche Beantragung nach der Abmeldung (Wiedereinstieg) hebt die Abmeldung für Folgejahre auf
reentered_after_deregistration if {
	date_ns(application_date) > date_ns(deregistration_date)
}

deregistered_for_year if {
	not deregistration_blocked
	not reentered_after_deregistration
	year_of(deregistration_date) <= year
}

# --- Förderwerbende Person (O610-GEN-APPLICANT-TYPES, O610-GEN-PUBLIC-AUTHORITY-10) ----

eligible_person_types := {t.person_type | some t in defs.eligible_applicant_types}

public_body if applicant.person_type == "territorial_authority"

public_body if object.get(applicant, "public_authority_share_percent", 0) > params.public_authority_max_share_percent

public_body_allowed_for_measure_10 if {
	some e in defs.public_authority_exception_measures
	e.measure == params.measure_code
	e.from_year <= year
	year <= e.to_year
}

access_violations contains {
	"rule_id": "O610-GEN-PUBLIC-AUTHORITY-10",
	"reason": "Gebietskörperschaften bzw. Einrichtungen mit mehr als 25 % Beteiligung von Gebietskörperschaften sind ab dem Antragsjahr 2025 nicht förderwerbend",
} if {
	public_body
	not public_body_allowed_for_measure_10
}

access_violations contains {
	"rule_id": "O610-GEN-APPLICANT-TYPES",
	"reason": sprintf("Personentyp '%s' ist keine zulässige förderwerbende Person", [object.get(applicant, "person_type", "unbekannt")]),
} if {
	not public_body
	not object.get(applicant, "person_type", "natural_person") in eligible_person_types
}

access_violations contains {
	"rule_id": "O610-GEN-APPLICANT-OWN-ACCOUNT",
	"reason": sprintf("Voraussetzung '%s' der förderwerbenden Person nicht erfüllt", [field]),
} if {
	some field in ["is_active_farmer", "farms_in_own_name_and_account"]
	object.get(applicant, field, true) == false
}

# --- Mindestteilnahmefläche (O610-MIN-AREA, O610-CONTRACT-LAPSE-MIN-AREA) -----------

access_violations contains {
	"rule_id": "O610-MIN-AREA",
	"reason": sprintf("Nur %.2f ha Wein-, Obst- oder Hopfenflächen; Mindestteilnahmefläche 0,50 ha", [vfh_area_ha]),
} if {
	vfh_area_ha < params.min_participation_area_ha
}

# --- Betriebsmindestgröße im ersten ÖPUL-Jahr (O610-GEN-FARM-MIN-SIZE) --------------

first_oepul_year if object.get(input, ["farm", "oepul", "first_oepul_participation_year"], null) == year

access_violations contains {
	"rule_id": "O610-GEN-FARM-MIN-SIZE",
	"reason": "Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr (1,50 ha bzw. 0,50 ha geschützter Anbau) nicht erreicht",
} if {
	first_oepul_year
	object.get(input, ["land", "total_area_ha"], 0) < params.farm_min_size_first_year_ha
	object.get(input, ["land", "protected_cultivation_area_ha"], 0) < params.farm_min_size_first_year_protected_cultivation_ha
}

# --- Programmende ------------------------------------------------------------------

access_violations contains {
	"rule_id": "O610-CONTRACT-PERIOD",
	"reason": "Antragsjahr außerhalb der Programmlaufzeit 2023 bis 2028",
} if {
	not year in numbers.range(2023, 2028)
}

# --- Mehrfachantrag als Zahlungsantrag (O610-GEN-PREAPPLICATION) --------------------

payment_application_missing if object.get(o610, "multiple_application_submitted", true) == false

# --- Ergebnis: Vertrag/Teilnahme im Antragsjahr -------------------------------------

default contract_valid := false

contract_valid if {
	has_commitment_basis
	not deregistered_for_year
	count(access_violations) == 0
}

contract_status := "no_application" if {
	not has_commitment_basis
	count(takeover_rejections) == 0
}

else := "takeover_rejected" if {
	not has_commitment_basis
}

else := "deregistered" if {
	deregistered_for_year
}

else := "lapsed_access_conditions_not_met" if {
	count(access_violations) > 0
}

else := "valid"

# O610-EXIT-AFTER-1Y: Ausstieg frühestens nach Erfüllung des einjährigen Vertragszeitraums
default exit_possible_from_year := null

exit_possible_from_year := contract_start_year + 1 if applied_via_measure_application
