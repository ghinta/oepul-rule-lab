# Zugangsvoraussetzungen, Beantragung und allgemeine Teilnahmebedingungen.
package o6_3

# O6_3-COMB-01: zeitgleiche Teilnahme an UBB, BIO oder BIO-Teilbetrieb.
companion_measures := {m | some m in data.o6_3.combination_table.required_companion_measures_o6_3}

combination_obligation_met if {
	some m in participating_measures
	m in companion_measures
}

# SRL-COMB-02: UBB und BIO schließen einander betrieblich aus (ausgenommen Bio-Teilbetrieb).
farm_level_exclusion_violations contains ex if {
	some ex in data.o6_3.combination_table.farm_level_exclusions
	ex.measure_a in participating_measures
	ex.measure_b in participating_measures
	not bio_teilbetrieb_exception(ex)
}

bio_teilbetrieb_exception(ex) if {
	ex.exception == "Bio-Teilbetrieb"
	"o6_1b_teilbetrieb" in participating_measures
}

# O6_3-MIN-01: Mähwiesen und Mähweiden (ohne Streuwiesen/Bergmähder), inkl. Naturschutz-Flächen.
min_participation_area_ha := sum([p.area_ha |
	some p in parcels
	p.land_use == "grassland"
	grassland_type(p) in min_area_grassland_types
])

min_participation_area_met if min_participation_area_ha >= params.min_mown_grassland_first_year_ha

# O6_3-MIN-01 / O6_3-LH-01 / SRL-ACC-01: im ersten Verpflichtungsjahr zu erfüllende Zugangsvoraussetzungen.
access_requirement_failures contains "O6_3-COMB-01" if not combination_obligation_met

access_requirement_failures contains "SRL-COMB-02" if count(farm_level_exclusion_violations) > 0

access_requirement_failures contains "O6_3-MIN-01" if {
	is_first_contract_year
	not min_participation_area_met
}

access_requirement_failures contains "O6_3-LH-01" if {
	is_first_contract_year
	not is_livestock_farm
}

access_requirement_failures contains "GEN-MIN-01" if {
	is_first_oepul_year
	not farm_min_size_met
}

access_requirement_failures contains "GEN-ELIG-01" if not applicant_eligible

access_requirement_failures contains "O6_3-APP-01" if {
	is_first_contract_year
	not application_timely
}

access_requirement_failures contains "O6_3-APP-02" if {
	is_number(contract_start_year)
	contract_start_year > data.o6_3.contract_periods.measure_last_entry_year
}

access_requirements_met if count(access_requirement_failures) == 0

# SRL-ACC-01: Folgen fehlender Zugangsvoraussetzungen.
contract_established if {
	is_first_contract_year
	access_requirements_met
}

no_contract_first_year if {
	is_first_contract_year
	not access_requirements_met
}

no_premium_access_failure_later_year if {
	not is_first_contract_year
	not access_requirements_met
}

# GEN-MIN-01: Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr.
is_first_oepul_year if year == object.get(input, ["farm", "oepul", "first_participation_year"], null)

protected_cultivation_ha := object.get(input, ["land", "protected_cultivation_area_ha"], 0)

farm_min_size_met if protected_cultivation_ha >= params.farm_min_size_first_oepul_year.protected_cultivation_ha

farm_min_size_met if {
	sum([p.area_ha | some p in parcels]) + protected_cultivation_ha >= params.farm_min_size_first_oepul_year.agricultural_area_ha
}

# GEN-ELIG-01: förderwerbende Personen; Gebietskörperschaften sind bei Heuwirtschaft nicht zulässig.
applicant := object.get(input, ["farm", "applicant"], {})

applicant_eligible if {
	object.get(applicant, "legal_form", "natural_person") in {"natural_person", "registered_partnership"}
	not public_body_dominated
	object.get(applicant, "is_active_farmer", true) == true
}

applicant_eligible if {
	object.get(applicant, "legal_form", "") in {"legal_entity", "association"}
	not public_body_dominated
	object.get(applicant, "is_active_farmer", true) == true
}

public_body_dominated if object.get(applicant, "is_public_body", false) == true

public_body_dominated if object.get(applicant, "public_body_share_percent", 0) > params.public_body_max_share_percent

# O6_3-APP-01: Maßnahmenantrag bis 31.12. vor Vertragsbeginn.
application_date := object.get(o6_3_input, "measure_application_date", null)

application_timely if {
	is_string(application_date)
	is_number(contract_start_year)
	application_date <= sprintf("%d-12-31", [contract_start_year - 1])
}

# O6_3-APP-03 / O6_3-APP-04 / O6_3-CP-02: einjährige Option „Verzicht auf Mähaufbereiter“.
option_input := object.get(o6_3_input, "option_no_mower_conditioner", {})

option_requested if object.get(option_input, "applied", false) == true

option_active if {
	option_requested
	object.get(option_input, "marked_in_mfa_details", false) == true
	year <= data.o6_3.contract_periods.option_no_mower_conditioner.last_entry_year
}

option_application_issues contains "O6_3-APP-03" if {
	option_requested
	not object.get(option_input, "marked_in_mfa_details", false) == true
}

option_application_issues contains "O6_3-APP-04" if {
	option_requested
	year > data.o6_3.contract_periods.option_no_mower_conditioner.last_entry_year
}
