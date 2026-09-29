# o6_24 – Zugangs- und Teilnahmevoraussetzungen
# Mindestteilnahme, förderwerbende Person, Betriebsmindestgröße, Beantragung.
package oepul.o6_24

# --- Mindestteilnahme: jedes Teilnahmejahr >= 2,00 ha Ackerfläche in der Gebietskulisse ---
default minimum_participation_met := false

minimum_participation_met if arable_area_in_area_ha >= thresholds.min_arable_area_in_area_ha

# --- Förderwerbende Person ---
applicant := object.get(input, ["farm", "applicant"], {})

applicant_legal_form_eligible if applicant.legal_form in {f | some f in cfg.eligible_legal_forms}

public_body_permitted_for_measure if {
	some row in cfg.public_body_permitted_measures
	row.code == measure_code
	valid_for_year(row, year)
}

# Gebietskörperschaften und deren Einrichtungen sind bei Maßnahme 24 nicht förderwerbend.
applicant_is_public_body if applicant.is_public_body == true

# Bestimmender Einfluss: Beteiligung von Gebietskörperschaften > 25 %.
applicant_public_body_share_too_high if {
	applicant.public_body_share_percent > thresholds.max_public_body_share_percent
}

default applicant_eligible := false

applicant_eligible if {
	applicant_legal_form_eligible
	applicant.is_active_farmer == true
	not applicant_excluded_as_public_body
}

applicant_excluded_as_public_body if {
	applicant_is_public_body
	not public_body_permitted_for_measure
}

applicant_excluded_as_public_body if {
	applicant_public_body_share_too_high
	not public_body_permitted_for_measure
}

# --- Betriebsmindestgröße (nur im ersten ÖPUL-Teilnahmejahr) ---
first_participation_year := object.get(input, ["farm", "oepul", "first_participation_year"], null)

is_first_oepul_year if year == first_participation_year

protected_cultivation_area_ha := object.get(input, ["land", "protected_cultivation_area_ha"], 0)

agricultural_area_ha := object.get(input, ["land", "total_area_ha"], 0)

default farm_min_size_met := false

farm_min_size_met if not is_first_oepul_year

farm_min_size_met if {
	is_first_oepul_year
	protected_cultivation_area_ha >= thresholds.first_year_min_protected_cultivation_ha
}

farm_min_size_met if {
	is_first_oepul_year
	agricultural_area_ha >= thresholds.first_year_min_agricultural_area_ha
}

# --- Beantragung: Maßnahmenantrag bis 31.12. vor Vertragsbeginn, letzter Einstieg 2027 ---
contract_start_year := object.get(participation, "contract_start_year", null)

application_deadline(start_year) := date_string(start_year - 1, deadline("measure_application").month, deadline("measure_application").day)

default application_timely := false

application_timely if {
	d := participation.measure_application_date
	date_ns(d) <= date_ns(application_deadline(contract_start_year))
}

default entry_year_allowed := false

entry_year_allowed if contract_start_year <= thresholds.last_entry_contract_year

# Alle Zugangsvoraussetzungen für das Antragsjahr.
default access_conditions_met := false

access_conditions_met if {
	minimum_participation_met
	applicant_eligible
	farm_min_size_met
	application_timely
	entry_year_allowed
}

access_failures contains "minimum_arable_area_in_area_not_met" if not minimum_participation_met

access_failures contains "applicant_not_eligible" if not applicant_eligible

access_failures contains "farm_minimum_size_not_met_first_year" if not farm_min_size_met

access_failures contains "measure_application_not_timely" if not application_timely

access_failures contains "entry_after_last_entry_year" if not entry_year_allowed
