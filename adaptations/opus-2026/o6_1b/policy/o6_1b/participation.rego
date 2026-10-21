# Teilnahmevoraussetzungen: Vertragszeitraum, Einstieg, Bio-Zertifizierung,
# förderwerbende Person, Betriebsmindestgröße, Teilbetrieb und Maßnahmenkombination.
package oepul.o6_1b

# --- Vertragszeitraum (Kap. 3.1; ATB 5.9; SRL 1.7.1.2) -----------------------------

contract_start_year := object.get(o6_1b_input, "contract_start_year", null)

contract_period_row := row if {
	some row in general.contract_periods
	date_year(row.start) == contract_start_year
}

contract_period_years := contract_period_row.years

contract_end_date := contract_period_row.end

# Antragsjahr liegt innerhalb des Vertragszeitraums
within_contract_period if {
	contract_start_year != null
	year >= contract_start_year
	year <= date_year(general.deadlines.contract_end)
}

# Optionale Zuschläge: Vertragszeitraum ein Kalenderjahr (Kap. 3.1)
optional_supplement_contract_period := {"start": sprintf("%d-01-01", [year]), "end": sprintf("%d-12-31", [year])}

violations contains {"rule_id": "O61B-VZ-003", "message": "Vertragsbeginn nach dem letztmöglichen Einstiegsjahr 2025"} if {
	contract_start_year != null
	contract_start_year > general.deadlines.last_entry_contract_year
}

violations contains {"rule_id": "O61B-VZ-003", "message": "Maßnahmenantrag nicht bis 31.12. vor Vertragsbeginn gestellt"} if {
	contract_start_year != null
	app := object.get(o6_1b_input, "application_date", null)
	app != null
	app > sprintf("%d-12-31", [contract_start_year - 1])
}

# --- Bio-Zertifizierung (Kap. 3.4; SRL 2.1 B Förderverpflichtungen) -----------------

organic := object.get(input, ["farm", "certifications", "organic"], {})

violations contains {"rule_id": "O61B-ZT-001", "message": "Betrieb nicht als biologisch wirtschaftender Betrieb bei der Lebensmittelbehörde registriert"} if {
	object.get(organic, "registered_with_food_authority", false) != true
}

violations contains {"rule_id": "O61B-ZT-001", "message": "Kein Vertrag mit einer anerkannten Bio-Kontrollstelle spätestens ab 1. Jänner des ersten Vertragsjahres"} if {
	contract_start_year != null
	start := object.get(organic, "control_contract_start_date", null)
	not control_contract_started_in_time(start)
}

control_contract_started_in_time(start) if {
	start != null
	start <= sprintf("%d-01-01", [contract_start_year])
}

violations contains {"rule_id": "O61B-ZT-001", "message": "Kontrollvertrag endet vor dem Ende des Vertragszeitraumes"} if {
	end := object.get(organic, "control_contract_end_date", null)
	end != null
	end < general.deadlines.contract_end
}

violations contains {"rule_id": "O61B-ZT-002", "message": "Wechsel der Bio-Kontrollstelle mit zeitlicher Unterbrechung"} if {
	object.get(organic, "control_body_change_without_gap", true) == false
}

# --- Förderwerbende Person (ATB 5.2; SRL 1.4) ---------------------------------------

applicant := object.get(input, ["oepul", "applicant"], {})

violations contains {"rule_id": "O61B-ATB-001", "message": "Personentyp kommt als förderwerbende Person nicht in Betracht"} if {
	pt := object.get(applicant, "person_type", null)
	pt != null
	not pt in lists.applicant_types_eligible
}

violations contains {"rule_id": "O61B-ATB-001", "message": "Beteiligung von Gebietskörperschaften übersteigt 25 %"} if {
	object.get(applicant, "public_body_share_percent", 0) > lists.parameters.public_body_max_share_percent
}

violations contains {"rule_id": "O61B-ATB-002", "message": "Kein aktiver Landwirt bzw. keine Bewirtschaftung im eigenen Namen und auf eigene Rechnung"} if {
	some flag in ["is_active_farmer", "farms_in_own_name", "has_control_over_areas"]
	object.get(applicant, flag, true) == false
}

# --- Betriebsmindestgröße im 1. ÖPUL-Teilnahmejahr (ATB 5.3; SRL 1.6.1) --------------

first_oepul_year := object.get(input, ["oepul", "first_participation_year"], null)

protected_cultivation_ha := sum([area(p) | some p in parcels; land_use_type(p) == "GA"])

minimum_size_area_ha := sum([area(p) | some p in parcels; p.land_use in {"arable", "grassland", "special_crop", "alpine_pasture"}])

meets_minimum_farm_size if protected_cultivation_ha >= general.min_farm_size_first_year.protected_cultivation_ha

meets_minimum_farm_size if minimum_size_area_ha >= general.min_farm_size_first_year.agricultural_area_ha

violations contains {"rule_id": "O61B-ATB-003", "message": "Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr nicht erreicht"} if {
	first_oepul_year == year
	not meets_minimum_farm_size
}

# --- Biologischer Teilbetrieb (Kap. 3.3; SRL 2.1 B Option Teilbetrieb) ----------------

partial_farm := object.get(o6_1b_input, "partial_farm", {})

is_partial_farm if object.get(partial_farm, "is_partial", false) == true

partial_organic_area := object.get(partial_farm, "organic_culture_area", null)

violations contains {"rule_id": "O61B-TB-001", "message": "Teilbetrieb ohne eigenständige Betriebsanlagen und Nutzflächen bzw. ohne getrennte Lagerung der Betriebsmittel"} if {
	is_partial_farm
	some flag in ["separate_facilities_and_land", "separate_input_storage"]
	object.get(partial_farm, flag, false) != true
}

violations contains {"rule_id": "O61B-TB-002", "message": "Teilbetrieb: biologischer Kulturbereich muss 'arable_grassland' oder 'wine_fruit_hops' sein"} if {
	is_partial_farm
	not partial_organic_area in {"arable_grassland", "wine_fruit_hops"}
}

violations contains {"rule_id": "O61B-TB-005", "message": "Option Teilbetrieb nicht im Maßnahmenantrag beantragt"} if {
	is_partial_farm
	object.get(partial_farm, "applied_in_measure_application", false) != true
}

# Alle biologisch bewirtschafteten Schläge des Teilbetriebs sind mit BIO zu codieren (Kap. 10, 3.2)
organic_culture_land_uses := lists.culture_areas[partial_organic_area]

violations contains {"rule_id": "O61B-FL-004", "message": sprintf("Schlag %s des biologischen Kulturbereichs ohne Code BIO", [p.parcel_id])} if {
	is_partial_farm
	some p in parcels
	p.land_use in organic_culture_land_uses
	not excluded_land_use(p)
	not has_code(p, "BIO")
}

# Tierhaltung ist an den Kulturbereich Grünland/Ackerland gebunden (Kap. 3.3)
livestock_must_be_organic if not is_partial_farm

livestock_must_be_organic if {
	is_partial_farm
	partial_organic_area == "arable_grassland"
}

# --- Maßnahmenkombination (Kap. 10; SRL 1.9.4 und 2.1 B Höhe der Förderung) ----------

violations contains {"rule_id": "O61B-AN-001", "message": sprintf("Betriebliche Kombination mit %s ausgeschlossen", [m.label])} if {
	some m in lists.excluded_combination_measures
	m.partial_farm_exception == "mutual_culture_area"
	m.measure in participating_measures
	not is_partial_farm
}

violations contains {"rule_id": "O61B-AN-002", "message": "Teilnahme an 'Nichtproduktive Ackerflächen' nur bei Bio-Teilbetrieb mit Kulturbereich Wein, Obst und Hopfen möglich"} if {
	"o6_1c_nonproductive" in participating_measures
	not partial_farm_wine_fruit_hops
}

partial_farm_wine_fruit_hops if {
	is_partial_farm
	partial_organic_area == "wine_fruit_hops"
}

# --- Maßnahmenwechsel in die Biologische Wirtschaftsweise (ATB 6.2; SRL 1.7.3.2) -----

measure_switch := object.get(o6_1b_input, "switched_from", null)

measure_switch_without_repayment if {
	measure_switch in general.measure_switch_into_o6_1b_from
	object.get(o6_1b_input, "switch_date", "9999-12-31") <= general.deadlines.measure_switch_latest
}
