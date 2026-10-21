# Teilnahme-, Zugangs- und Förderfähigkeitsvoraussetzungen (o6_23).
package oepul.o6_23

# ---------------------------------------------------------------------------
# Maßnahmentyp und Vertragszeitraum
# ---------------------------------------------------------------------------

# Einjährige Maßnahme (SRL 1.7.1.1, Allg. Teilnahmebedingungen 5.9).
is_one_year_measure if {
	some m in params.one_year_measures
	m.measure == measure_code
}

# Flächenzugänge unterliegen keiner Prämienbeschränkung, weil o6_23 nicht in der
# Liste der beschränkten Maßnahmen steht (Allg. Teilnahmebedingungen 7.2).
area_increase_restricted if {
	some m in params.area_increase_restricted_measures
	m.measure == measure_code
}

contract_start_year := object.get(o6_23_input, "contract_start_year", null)

# Spätester Vertragsbeginn 01.01.2027 (Beantragung bis 31.12.2026).
entry_year_allowed if {
	is_number(contract_start_year)
	contract_start_year >= params.measure.first_srl_year
	contract_start_year <= params.measure.last_entry_year
}

# Maßnahmenantrag bis 31.12. vor dem ersten Verpflichtungsjahr.
application_timely if {
	is_number(contract_start_year)
	app := object.get(o6_23_input, "measure_application_date", null)
	is_string(app)
	date_ns(app) <= year_end_ns(contract_start_year - 1)
}

# Automatische Verlängerung um ein weiteres Förderjahr, solange nicht abgemeldet.
contract_active_in_year if {
	entry_year_allowed
	application_timely
	year >= contract_start_year
	year <= params.measure.srl_period_end_year
	not deregistered_effective_for_year
}

deregistration_date := object.get(o6_23_input, "deregistration_date", null)

# Abmeldung im Zeitraum 1. Jänner bis 31. Dezember: Maßnahme im betroffenen
# Förderjahr nicht mehr gültig.
deregistered_effective_for_year if {
	is_string(deregistration_date)
	deregistration_effective
	date_ns(deregistration_date) <= year_end_ns(year)
}

# Ausstieg ist bis zur Durchführung/Ankündigung einer Vor-Ort-Kontrolle bzw. bis
# zur Mitteilung des Ergebnisses einer Verwaltungskontrolle möglich.
deregistration_effective if {
	is_string(deregistration_date)
	not deregistration_after_control_notice
}

deregistration_after_control_notice if {
	is_string(deregistration_date)
	notice := object.get(o6_23_input, "control_notice_date", null)
	is_string(notice)
	date_ns(deregistration_date) >= date_ns(notice)
}

# Wiedereinstieg nach Ausstieg nur mit neuerlichem Maßnahmenantrag.
reentry_requires_new_application if {
	is_string(deregistration_date)
	date_ns(deregistration_date) < year_start_ns(year)
}

# ---------------------------------------------------------------------------
# Förderwerbende Person
# ---------------------------------------------------------------------------

applicant := object.get(input, ["farm", "applicant"], {})

eligible_legal_forms := {f.legal_form | some f in params.applicant.eligible_legal_forms}

public_body_exempt_measures := {m.measure | some m in params.applicant.public_body_exempt_measures}

applicant_failures contains "legal_form_not_eligible" if {
	lf := object.get(applicant, "legal_form", null)
	lf != null
	not lf in eligible_legal_forms
}

# Gebietskörperschaften sind bei o6_23 nicht förderwerbend (nicht in der Ausnahmeliste).
applicant_failures contains "public_body_not_eligible_for_o6_23" if {
	object.get(applicant, "legal_form", null) == "public_body"
	not measure_code in public_body_exempt_measures
}

applicant_failures contains "public_body_share_above_25_percent" if {
	lf := object.get(applicant, "legal_form", null)
	some f in params.applicant.eligible_legal_forms
	f.legal_form == lf
	f.public_body_share_limited
	object.get(applicant, "public_body_share_percent", 0) > params.applicant.public_body_max_share_percent
}

applicant_failures contains "not_active_farmer" if {
	object.get(applicant, "is_active_farmer", true) == false
}

applicant_failures contains "no_agricultural_activity" if {
	object.get(applicant, "performs_agricultural_activity", true) == false
}

applicant_failures contains "not_own_name_and_account" if {
	object.get(applicant, "farms_in_own_name_and_account", true) == false
}

applicant_eligible if count(applicant_failures) == 0

# ---------------------------------------------------------------------------
# Betriebsmindestgröße (nur im ersten ÖPUL-Teilnahmejahr)
# ---------------------------------------------------------------------------

first_participation_year := object.get(input, ["farm", "oepul", "first_participation_year"], null)

is_first_participation_year if first_participation_year == year

minimum_farm_size_met if not is_first_participation_year

minimum_farm_size_met if {
	is_first_participation_year
	object.get(input, ["land", "total_area_ha"], 0) >= params.minimum_farm_size.agricultural_area_min_ha
}

minimum_farm_size_met if {
	is_first_participation_year
	object.get(input, ["land", "protected_cultivation_area_ha"], 0) >= params.minimum_farm_size.protected_cultivation_min_ha
}

# ---------------------------------------------------------------------------
# Schlagbezogene Zugangs- und Förderfähigkeitsvoraussetzungen
# ---------------------------------------------------------------------------

parcel_access_failures(p) := {r | some r in parcel_access_failure_reasons(p)}

parcel_access_failure_reasons(p) := array.concat(
	array.concat(access_base_failures(p), access_grassland_failures(p)),
	access_eligibility_failures(p),
)

access_base_failures(p) := [r |
	some r in ["no_project_confirmation", "not_in_natura2000_or_high_nature_value_area", "no_premium_relevant_code"]
	access_base_failed(p, r)
]

access_base_failed(p, "no_project_confirmation") if object.get(n2(p), "project_confirmation_present", false) != true

access_base_failed(p, "not_in_natura2000_or_high_nature_value_area") if {
	object.get(n2(p), "in_natura2000_or_high_nature_value_area", true) == false
}

access_base_failed(p, "no_premium_relevant_code") if count(parcel_codes(p)) == 0

access_grassland_failures(p) := [r |
	some r in ["not_grassland", "grassland_type_not_eligible"]
	access_grassland_failed(p, r)
]

access_grassland_failed(p, "not_grassland") if object.get(p, "land_use", "") != "grassland"

# Nur Mähwiesen und Mähweiden (ohne Dauerweiden und Hutweiden).
access_grassland_failed(p, "grassland_type_not_eligible") if {
	not object.get(n2(p), "grassland_type", "") in eligible_grassland_types
}

access_eligibility_failures(p) := [r |
	some r in [
		"located_outside_austria", "not_actively_farmed", "other_area",
		"gloez_landscape_element", "not_mainly_agricultural", "experimental_area_vf",
		"short_rotation_or_nursery", "op_code_set", "transfer_without_continuation",
	]
	access_eligibility_failed(p, r)
]

access_eligibility_failed(p, "located_outside_austria") if object.get(parcel_eligibility(p), "located_in_austria", true) == false

access_eligibility_failed(p, "not_actively_farmed") if object.get(parcel_eligibility(p), "actively_farmed", true) == false

access_eligibility_failed(p, "other_area") if object.get(parcel_eligibility(p), "is_other_area", false) == true

access_eligibility_failed(p, "gloez_landscape_element") if object.get(parcel_eligibility(p), "is_gloez_landscape_element", false) == true

access_eligibility_failed(p, "not_mainly_agricultural") if object.get(parcel_eligibility(p), "mainly_agricultural_use", true) == false

access_eligibility_failed(p, "experimental_area_vf") if object.get(parcel_eligibility(p), "is_experimental_area_vf", false) == true

access_eligibility_failed(p, "short_rotation_or_nursery") if object.get(parcel_eligibility(p), "is_short_rotation_or_nursery", false) == true

# Code OP (allgemein) oder maßnahmenbezogener OP-Code für o6_23: keine Prämie.
access_eligibility_failed(p, "op_code_set") if {
	some c in object.get(parcel_oepul(p), "op_codes", [])
	c in blocking_op_codes
}

# Unterjährige Weitergabe ohne Weiterführung bis Jahresende: keine Prämie (OP-Code).
access_eligibility_failed(p, "transfer_without_continuation") if {
	object.get(parcel_oepul(p), "transferred_during_year", false) == true
	object.get(parcel_oepul(p), "successor_continues_until_year_end", false) != true
}

# Annahme: maßnahmenbezogener OP-Code für o6_23 lautet "OPN2" (vgl. OPBIO, OPUBB).
blocking_op_codes := {"OP", "OPN2"}

# Nationalparkflächen sind für o6_23 prämienfähig (Ausnahme von 5.5.1 / SRL 1.6.2.2).
national_park_premium_allowed(p) if {
	object.get(n2(p), "in_national_park", false) == true
	measure_code in {m | some m in params.national_parks.measures_premium_eligible_in_all_national_parks}
}

# Gesetzlich vorgeschriebene Auflagen führen bei o6_23 nicht zu einer
# Leistungsüberschneidung (keine OP-Codierung erforderlich, SRL 1.6.2.3).
statutory_requirements_compensable if {
	some c in params.op_code_cases
	c.case == "overlap_other_public_title"
	measure_code in {"23", "24"}
}

default parcel_access_ok(_) := false

parcel_access_ok(p) if count(parcel_access_failures(p)) == 0

eligible_parcels contains p if {
	some p in n2_parcels
	parcel_access_ok(p)
}

# Projektbestätigung vorhanden, aber Schlag nicht mit N2 gekennzeichnet: nicht beantragt.
parcels_with_confirmation_without_n2_code contains p.parcel_id if {
	some p in parcels
	count(object.get(n2(p), "project_confirmation_codes", [])) > 0
	object.get(n2(p), "n2_code_marked", false) != true
}

# ---------------------------------------------------------------------------
# Maßnahmenübernahme (SRL 1.7.3.1, Allg. Teilnahmebedingungen 6.3)
# ---------------------------------------------------------------------------

takeover := object.get(o6_23_input, "takeover", null)

takeover_deadline(y) := sprintf("%d-%s", [y, e.month_day]) if {
	some e in params.takeover.deadline_exceptions
	e.year == y
} else := sprintf("%d-%s", [y, params.takeover.deadline_month_day])

takeover_failures contains "takeover_after_deadline" if {
	is_object(takeover)
	date_ns(takeover.application_date) > date_ns(takeover_deadline(year))
}

takeover_failures contains "takeover_expansion_above_50_percent" if {
	is_object(takeover)
	takeover.additional_area_ha > params.takeover.max_expansion_share * takeover.taken_over_area_ha
}

takeover_allowed if {
	is_object(takeover)
	count(takeover_failures) == 0
}
