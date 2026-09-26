package oepul.o6_14

# Teilnahmevoraussetzungen, Vertragszeitraum, Antrags- und Einstiegsfristen.

commitment_start_year := object.get(measure_input, "commitment_start_year", null)

contract_period := p if {
	some p in proc.contract_periods
	p.start_year == commitment_start_year
}

contract_end_date := contract_period.end_date

contract_duration_years := contract_period.duration_years

first_commitment_year if year == commitment_start_year

# Massnahmenantrag vor Vertragsbeginn bis 31.12. des Vorjahres.
application_deadline_for(start_year) := deadline_date("measure_application", start_year - 1)

measure_application_timely if {
	is_true(measure_input, "applied")
	on_or_before(measure_input.application_date, application_deadline_for(commitment_start_year))
}

# Letzter Einstieg: Foerderjahr 2025 (Beantragung bis 31.12.2024).
measure_entry_year_allowed if {
	commitment_start_year >= 2023
	commitment_start_year <= last_entry("measure").last_commitment_year
}

takeover := object.get(af, "takeover", {})

takeover_valid if {
	is_true(takeover, "is_takeover")
	on_or_before(takeover.submission_date, deadline_date("measure_takeover", year))
	is_false(takeover, "previously_participating")
	object.get(takeover, "expansion_share", 0) <= 0.5
	is_true(takeover, "approved_by_ama")
}

valid_contract if {
	measure_application_timely
	measure_entry_year_allowed
}

valid_contract if takeover_valid

# --- Foerderwerbende Person ---------------------------------------------------

applicant := object.get(input.farm, "applicant", {})

applicant_type_eligible if {
	some row in proc.eligible_applicant_types
	row.legal_form == applicant.legal_form
	row.public_body_share_limit_pct == null
}

applicant_type_eligible if {
	some row in proc.eligible_applicant_types
	row.legal_form == applicant.legal_form
	row.public_body_share_limit_pct != null
	object.get(applicant, "public_body_share_pct", 0) <= row.public_body_share_limit_pct
}

# --- Mindestteilnahme im ersten Teilnahmejahr --------------------------------

total_alm_area_ha := sum([alm.alm_pasture_area_ha | some alm in alms])

total_participating_rgve := sum([animal_rgve(a) |
	some id, a in animal_by_id
	animal_premium_eligible(id)
])

minimum_participation_met if {
	total_alm_area_ha >= proc.minimum_participation_first_year.alm_pasture_area_ha
	total_participating_rgve >= proc.minimum_participation_first_year.rgve
}

# Betriebsmindestgroesse im ersten OePUL-Teilnahmejahr.
first_oepul_year if year == object.get(object.get(input.farm, "oepul", {}), "first_oepul_year", null)

farm_min_size_met if object.get(object.get(input, "land", {}), "protected_cultivation_area_ha", 0) >= proc.minimum_farm_size_first_oepul_year.protected_cultivation_ha

farm_min_size_met if object.get(object.get(input, "land", {}), "total_area_ha", 0) >= proc.minimum_farm_size_first_oepul_year.agricultural_area_ha

access_violations contains v if {
	not is_true(af, "is_alm_manager")
	v := {"rule_id": "O614-SCOPE-002", "category": "access", "subject": "farm", "message": "Die Massnahme ist von der almbewirtschaftenden Person zu beantragen."}
}

access_violations contains v if {
	not valid_contract
	v := {"rule_id": "O614-APPL-001", "category": "access", "subject": "farm", "message": "Kein gueltiger Vertrag: Massnahmenantrag nicht bis 31.12. vor Vertragsbeginn, Einstiegsjahr nach 2025 oder keine gueltige Massnahmenuebernahme."}
}

access_violations contains v if {
	not applicant_type_eligible
	v := {"rule_id": "O614-ACCESS-005", "category": "access", "subject": "farm", "message": "Rechtsform nicht foerderfaehig oder Beteiligung von Gebietskoerperschaften ueber 25 %."}
}

access_violations contains v if {
	is_false(applicant, "is_active_farmer")
	v := {"rule_id": "O614-ACCESS-006", "category": "access", "subject": "farm", "message": "Aktiver Landwirt / landwirtschaftliche Taetigkeit nicht erfuellt."}
}

access_violations contains v if {
	first_commitment_year
	not minimum_participation_met
	v := {"rule_id": "O614-ACCESS-001", "category": "access", "subject": "farm", "message": sprintf("Mindestteilnahme im ersten Teilnahmejahr nicht erfuellt (%.2f ha, %.2f RGVE; erforderlich je 3,00).", [total_alm_area_ha, total_participating_rgve])}
}

access_violations contains v if {
	first_oepul_year
	not farm_min_size_met
	v := {"rule_id": "O614-ACCESS-007", "category": "access", "subject": "farm", "message": "Betriebsmindestgroesse im ersten OePUL-Teilnahmejahr nicht erreicht."}
}

default access_conditions_met := false

access_conditions_met if count(access_violations) == 0

# Rechtsfolge: im 1. Jahr kein Vertrag, ab dem 2. Verpflichtungsjahr keine
# Praemie im betroffenen Jahr.
access_consequence := "no_contract" if {
	not access_conditions_met
	first_commitment_year
}

access_consequence := "no_premium_this_year" if {
	not access_conditions_met
	not first_commitment_year
}

access_consequence := "none" if access_conditions_met

# --- Zuschlaege: Einstieg ---------------------------------------------------

deadline_violations contains v if {
	nata_applied
	nata_start := object.get(nata_input, "commitment_start_year", commitment_start_year)
	nata_start > last_entry("nature_conservation_supplement").last_commitment_year
	v := {"rule_id": "O614-APPL-002", "category": "deadline", "subject": "nature_conservation_supplement", "message": "Letzter Einstieg in den Zuschlag Naturschutz auf der Alm ist das Foerderjahr 2025."}
}

deadline_violations contains v if {
	nata_applied
	nata_start := object.get(nata_input, "commitment_start_year", commitment_start_year)
	not on_or_before(nata_input.application_date, application_deadline_for(nata_start))
	v := {"rule_id": "O614-APPL-001", "category": "deadline", "subject": "nature_conservation_supplement", "message": "Zuschlag Naturschutz auf der Alm nicht bis 31.12. vor Vertragsbeginn beantragt."}
}

deadline_violations contains v if {
	awp_applied
	first := object.get(awp_input, "first_application_year", year)
	not awp_entry_year_allowed(first)
	v := {"rule_id": "O614-APPL-003", "category": "deadline", "subject": "grazing_plan_supplement", "message": "Zuschlag Almweideplan nur fuer Foerderjahre 2025 bis 2028 beantragbar."}
}

deadline_violations contains v if {
	awp_applied
	first := object.get(awp_input, "first_application_year", year)
	not on_or_before(awp_input.application_date, application_deadline_for(first))
	v := {"rule_id": "O614-APPL-001", "category": "deadline", "subject": "grazing_plan_supplement", "message": "Zuschlag Almweideplan nicht bis 31.12. vor dem Foerderjahr im Massnahmenantrag beantragt."}
}

awp_entry_year_allowed(y) if {
	y >= last_entry("grazing_plan_supplement").first_commitment_year
	y <= last_entry("grazing_plan_supplement").last_commitment_year
}

# Feldstuecksliste bis 15.04. (2023/2028: 17.04.).
deadline_violations contains v if {
	some alm in alms
	alm.field_list_submission_date
	after(alm.field_list_submission_date, deadline_date("field_list_area_application", year))
	v := {"rule_id": "O614-APPL-004", "category": "deadline", "subject": alm.alm_id, "message": "Almweideflaechen nicht fristgerecht in der Feldstuecksliste beantragt."}
}

# Alm/Gemeinschaftsweide-Auftriebsliste (Zahlungsantrag) bis 15.07.
drive_up_list_required(alm) if not cattle_only_alm(alm.alm_id)

drive_up_list_required(alm) if alm_access_level[alm.alm_id] != 1

drive_up_list_required(_) if participates_in("tierwohl_behirtung")

drive_up_list_required(alm) if awp_increased_intensity(alm)

deadline_violations contains v if {
	some alm in alms
	drive_up_list_required(alm)
	not alm.drive_up_list_submission_date
	v := {"rule_id": "O614-APPL-005", "category": "deadline", "subject": alm.alm_id, "message": "Alm/Gemeinschaftsweide-Auftriebsliste (Zahlungsantrag) fehlt."}
}

deadline_violations contains v if {
	some alm in alms
	drive_up_list_required(alm)
	alm.drive_up_list_submission_date
	after(alm.drive_up_list_submission_date, deadline_date("drive_up_list", year))
	v := {"rule_id": "O614-APPL-005", "category": "deadline", "subject": alm.alm_id, "message": "Alm/Gemeinschaftsweide-Auftriebsliste nach dem 15.07. (2023/2028: 17.07.) eingereicht."}
}

# NATA-Codierung aller Schlaege bis 15.04. (2023/2028: 17.04.).
deadline_violations contains v if {
	some alm in alms
	nata_alm(alm)
	some plot in object.get(alm, "plots", [])
	not "NATA" in object.get(plot, "codes", [])
	v := {"rule_id": "O614-APPL-015", "category": "deadline", "subject": plot.plot_id, "message": "Schlag der Naturschutz-Alm nicht mit Code NATA gekennzeichnet."}
}

deadline_violations contains v if {
	some alm in alms
	nata_alm(alm)
	alm.nata_coding_date
	after(alm.nata_coding_date, deadline_date("nata_coding", year))
	v := {"rule_id": "O614-APPL-015", "category": "deadline", "subject": alm.alm_id, "message": "NATA-Codierung nach dem 15.04. (2023/2028: 17.04.)."}
}

deadline_violations contains v if {
	some alm in alms
	awp_increased_intensity(alm)
	drive_up_list_required(alm)
	is_false(object.get(alm, "grazing_plan", {}), "increased_intensity_declared_in_drive_up_list")
	v := {"rule_id": "O614-APPL-007", "category": "deadline", "subject": alm.alm_id, "message": "Almweideplan mit Auftrieb bis 2,40 RGVE/ha ist in der Auftriebsliste zu beantragen."}
}
