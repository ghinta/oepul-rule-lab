# Teilnahme- und Zugangsvoraussetzungen, Maßnahmenkombination, Beantragung.
package oepul.o6_2

# Zugangsvoraussetzung: zeitgleiche Teilnahme an UBB (1A).
participates_ubb if "1A" in participating_measures

bio_partial_wine_fruit_hop if {
	object.get(oepul, ["bio_partial_farm", "is_partial_farm"], false) == true
	object.get(oepul, ["bio_partial_farm", "bio_culture_area"], null) == "wine_fruit_hop"
}

# Betriebliche Kombination mit Biologischer Wirtschaftsweise (1B) ausgeschlossen,
# ausgenommen Bio-Teilbetrieb mit Kulturbereich Wein, Obst und Hopfen.
bio_combination_conflict if {
	"1B" in participating_measures
	not bio_partial_wine_fruit_hop
}

contract_start_year := object.get(o6_2_state, "contract_start_year", null)

first_commitment_year if year == contract_start_year

access_condition_failures contains "O6_2-ACC-UBB-001" if not participates_ubb

access_condition_failures contains "O6_2-COMB-BIO-001" if bio_combination_conflict

# Förderwerbende Person: Gebietskörperschaften und Einrichtungen mit
# bestimmendem Einfluss (> 25 %) sind in dieser Maßnahme ausgeschlossen.
applicant_type := object.get(oepul, "applicant_type", "natural_person")

applicant_ineligible if applicant_type == "public_body"

applicant_ineligible if {
	applicant_type in {"legal_person", "association"}
	object.get(oepul, "public_body_share_percent", 0) > general.public_body_max_share_percent
}

access_condition_failures contains "O6_2-GEN-APPLICANT-001" if applicant_ineligible

# Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr.
protected_cultivation_area_ha := sum([p.area_ha |
	some p in parcels
	parcel_in_austria(p)
	is_protected_cultivation(p)
])

is_protected_cultivation(p) if object.get(p, "land_use_code", "") == "GA"

is_protected_cultivation(p) if object.get(p, ["crop", "non_eligible_type"], "") == "protected_cultivation"

minimum_farm_size_met if {
	protected_cultivation_area_ha >= general.minimum_farm_size_first_year.protected_cultivation_ha
}

minimum_farm_size_met if {
	sum([p.area_ha | some p in parcels; parcel_in_austria(p)]) >= general.minimum_farm_size_first_year.agricultural_area_ha
}

first_oepul_year if year == object.get(oepul, "first_oepul_participation_year", null)

access_condition_failures contains "O6_2-GEN-MINSIZE-001" if {
	first_oepul_year
	not minimum_farm_size_met
}

# Beantragung: Maßnahmenantrag bis 31.12. vor Vertragsbeginn, letzter Einstieg 2025.
application_date := object.get(o6_2_state, "application_date", null)

valid_contract_start if {
	some cp in general.contract_periods
	cp.start_year == contract_start_year
}

application_timely if {
	valid_contract_start
	application_date != null
	application_date <= sprintf("%d-12-31", [contract_start_year - 1])
	application_date <= general.last_application_date
}

contract_failures contains "O6_2-APP-DEADLINE-001" if not application_timely

contract_failures contains "O6_2-APP-LASTENTRY-001" if {
	contract_start_year != null
	contract_start_year > general.last_entry_year
}

# Folgen nicht erfüllter Zugangsvoraussetzungen (SRL 1.12.1.1):
# im 1. Jahr kommt kein Vertrag zustande, ab dem 2. Jahr keine Prämie im Jahr.
no_contract_due_to_access if {
	first_commitment_year
	count(access_condition_failures) > 0
}

no_premium_this_year_due_to_access if {
	not first_commitment_year
	count(access_condition_failures) > 0
}

contract_valid if {
	count(contract_failures) == 0
	not no_contract_due_to_access
}

# Einzelflächenkombination gemäß Anhang L.
combination_marker(code) := row.marker if {
	some row in combos.single_area_combination_row
	row.measure_code == code
}

single_area_combinable(code) if combination_marker(code) in {"x", "a"}

single_area_premium_reduction(code) if combination_marker(code) == "a"

# Maßnahmen auf einer Parzelle, die prämienmäßig nicht mit o6_2 kombinierbar sind.
parcel_combination_conflicts(p) := {c |
	some c in object.get(p, "parcel_measures", [])
	c != "2"
	not single_area_combinable(c)
}
