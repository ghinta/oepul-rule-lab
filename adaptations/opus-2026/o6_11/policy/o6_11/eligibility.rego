# o6_11 policy module
# o6_11 – Zugangs- und Fördervoraussetzungen
#
#   Vertragszeitraum, Antragsfristen, Mindestteilnahmefläche,
#   Betriebsmindestgröße, förderwerbende Personen, Maßnahmenkombination.
package oepul.o6_11

# ---------------------------------------------------------------------------
# Vertragszeitraum (Rule O611-CONTRACT-PERIOD)
# ---------------------------------------------------------------------------
contract_period_row := row if {
	some row in cfg.contract_periods.rows
	row.start_year == contract_start_year
}

contract_end := cfg.contract_periods.contract_end

contract_years := contract_period_row.years

# Rule O611-CONTRACT-PERIOD: Beginn nur 2023, 2024 oder 2025 möglich
contract_start_valid if contract_period_row

# Rule O611-LAST-ENTRY: letzter Einstieg mit Förderjahr 2025
entry_after_last_entry_year if {
	participates
	contract_start_year > cfg.contract_periods.last_entry_year
}

# Rule O611-APPLY-DEADLINE: Beantragung im Maßnahmenantrag bis 31.12. vor Vertragsbeginn
application_deadline := sprintf("%d-12-31", [contract_start_year - 1])

application_in_time if {
	participates
	participation.application_date <= application_deadline
}

application_late if {
	participates
	participation.application_date
	not application_in_time
}

application_date_missing if {
	participates
	not participation.application_date
}

# Antragsjahr innerhalb des Vertragszeitraumes
year_in_contract_period if {
	contract_start_valid
	year >= contract_start_year
	year <= year_of(contract_end)
}

is_first_commitment_year if {
	contract_start_valid
	year == contract_start_year
}

# ---------------------------------------------------------------------------
# Mindestteilnahmefläche 0,5 ha im 1. Verpflichtungsjahr (Rule O611-MIN-AREA)
# ---------------------------------------------------------------------------
minimum_area_ha := sum([parcel_area(p) |
	some p in parcels
	counts_for_minimum_area(p)
])

minimum_area_met if minimum_area_ha >= cfg.contract_periods.first_year_minimum_area_ha

minimum_area_violation if {
	is_first_commitment_year
	not minimum_area_met
}

# ---------------------------------------------------------------------------
# Betriebsmindestgröße im 1. ÖPUL-Teilnahmejahr (Rule O611-GEN-MIN-FARM-SIZE)
# ---------------------------------------------------------------------------
first_oepul_year := object.get(input, ["farm", "oepul", "first_participation_year"], contract_start_year)

farm_size_rule_applies if year == first_oepul_year

farm_min_size_met if {
	object.get(input, ["land", "protected_cultivation_area_ha"], 0) >= cfg.general_conditions.farm_minimum_size.protected_cultivation_min_ha
}

farm_min_size_met if {
	object.get(input, ["land", "total_area_ha"], 0) >= cfg.general_conditions.farm_minimum_size.agricultural_area_min_ha
}

farm_min_size_violation if {
	farm_size_rule_applies
	not farm_min_size_met
}

# ---------------------------------------------------------------------------
# Förderwerbende Personen (Rules O611-GEN-APPLICANT-TYPE,
# O611-GEN-PUBLIC-BODY-EXCL, O611-GEN-ACTIVE-FARMER)
# ---------------------------------------------------------------------------
applicant := object.get(input, ["farm", "applicant"], {})

applicant_type_row := row if {
	some row in cfg.general_conditions.applicant_types
	row.legal_form == applicant.legal_form
}

public_body_exception_for_measure if {
	some row in cfg.general_conditions.public_body_exception_measures
	row.measure_id == measure_id
	year >= row.from_year
	year <= row.to_year
}

applicant_violations contains "unzulässige Rechtsform der förderwerbenden Person" if {
	applicant.legal_form
	not applicant_type_row
}

applicant_violations contains "Gebietskörperschaft bzw. deren Einrichtung ist für Maßnahme 11 nicht förderwerbend" if {
	applicant.is_public_body == true
	not public_body_exception_for_measure
}

applicant_violations contains "Beteiligung von Gebietskörperschaften über 25 %" if {
	applicant_type_row.max_public_body_share_percent != null
	object.get(applicant, "public_body_share_percent", 0) > applicant_type_row.max_public_body_share_percent
	not public_body_exception_for_measure
}

applicant_violations contains "kein aktiver Landwirt bzw. keine landwirtschaftliche Tätigkeit" if {
	applicant.is_active_farmer == false
}

applicant_violations contains "Betrieb nicht im eigenen Namen und auf eigene Rechnung bzw. ohne Verfügungsgewalt" if {
	applicant.farms_in_own_name_and_account == false
}

# ---------------------------------------------------------------------------
# Betriebliche Kombination mit „Biologische Wirtschaftsweise“ (Rule O611-COMB-BIO)
# ---------------------------------------------------------------------------
organic_participations := [m | some m in oepul_measures; m.measure_id == "1B"]

# Bio-Teilbetrieb ausschließlich mit Kulturbereich Acker und Grünland
organic_partial_arable_grassland_only(m) if {
	m.is_organic_partial_farm == true
	areas := {a | some a in m.organic_partial_culture_areas}
	areas == {"arable_grassland"}
}

# Betriebliche Ausschlüsse gemäß SRL 1.9.4 (data farm_combination_exclusions)
farm_exclusion_partners contains row.excluded_with if {
	some row in cfg.farm_combination_exclusions
	measure_id in row.measures
}

organic_combination_conflict if {
	participates
	"1B" in farm_exclusion_partners
	some m in organic_participations
	not organic_partial_arable_grassland_only(m)
	not converted_to_organic(m)
}

# Umstieg 11 -> 1B (Rule O611-SWITCH-BIO): die Bio-Teilnahme ersetzt Maßnahme 11
converted_to_organic(m) if {
	m.measure_id == "1B"
	participation.conversion_target == "1B"
}

# Rule O611-SWITCH-BIO: Umstieg in 1B nur bis spätestens 31.12.2025
switch_to_organic_allowed if {
	participation.conversion_target == "1B"
	participation.conversion_application_date <= cfg.contract_periods.switch_to_organic_deadline
	some row in cfg.measure_switch_table.rows
	row.from == measure_id
	"1B" in row.to
}

switch_to_organic_too_late if {
	participation.conversion_target == "1B"
	not switch_to_organic_allowed
}

# Jahr, ab dem Maßnahme 11 wegen Umstieg nicht mehr gilt (Folgejahr der Beantragung)
conversion_effective_year := year_of(participation.conversion_application_date) + 1 if switch_to_organic_allowed

converted_in_or_before_year if {
	switch_to_organic_allowed
	year >= conversion_effective_year
}

# ---------------------------------------------------------------------------
# Kombination auf der Einzelfläche gemäß Anhang L (Rule O611-COMB-PARCEL)
# ---------------------------------------------------------------------------
combination_cell(other) := cell if {
	some cell in cfg.combination_table.cells
	cell.row_measure == measure_id
	cell.column_measure == other
}

parcel_measures(p) := object.get(p, ["oepul", "measures"], [measure_id])

parcel_in_measure(p) if measure_id in parcel_measures(p)

parcel_combination_conflicts contains {"parcel_id": p.parcel_id, "other_measure": other} if {
	some p in parcels
	parcel_in_measure(p)
	some other in parcel_measures(p)
	other != measure_id
	not combination_cell(other)
}

# Fußnote 1): nur betreffend Abgeltung der Landschaftselemente kombinierbar
parcel_combination_limited contains {"parcel_id": p.parcel_id, "other_measure": other, "footnote": cell.footnote} if {
	some p in parcels
	parcel_in_measure(p)
	some other in parcel_measures(p)
	cell := combination_cell(other)
	cell.footnote != null
}
