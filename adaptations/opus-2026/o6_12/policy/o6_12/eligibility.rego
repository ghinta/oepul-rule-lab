package oepul.o6_12

# Zugangs- und Fördervoraussetzungen, Förderfähigkeit der Flächen, Kombinationen.

# --- Förderwerbende Person (SRL 1.4, Allg. TNB 5.2) ---------------------------

applicant := object.get(input, ["farm", "applicant"], {})

applicant_type_rule := r if {
	some r in data.o6_12.applicant_types
	r.legal_form == applicant.legal_form
}

applicant_ineligibility_reasons contains "public_body_not_eligible_for_measure_12" if {
	applicant.legal_form == "public_body"
}

applicant_ineligibility_reasons contains "public_body_share_exceeds_25_percent" if {
	applicant_type_rule.max_public_body_share_percent != null
	object.get(applicant, "public_body_share_percent", 0) > applicant_type_rule.max_public_body_share_percent
}

applicant_ineligibility_reasons contains "not_active_farmer" if {
	applicant.is_active_farmer == false
}

applicant_ineligibility_reasons contains "not_farming_in_own_name_and_account" if {
	applicant.farms_in_own_name_and_account == false
}

applicant_ineligibility_reasons contains "unknown_legal_form" if {
	applicant.legal_form
	not applicant_type_rule
}

applicant_eligible if {
	applicant.legal_form
	count(applicant_ineligibility_reasons) == 0
}

# --- Antragstellung und Einstieg (Merkblatt 5, SRL 1.10.5.2, § 33 GSP-AV) ------

application_deadline := contract_period.application_deadline

application_timely if {
	date_on_or_before(o612.application_submitted_date, application_deadline)
}

entry_year_allowed if o612.contract_start_year <= params.last_entry_year

new_entry_possible_for_contract_start(start_year) if {
	start_year <= params.last_entry_year
}

# --- Mindestteilnahmefläche (Merkblatt 3.2, SRL 2.12) --------------------------

wine_fruit_hop_area_ha := sum([p.area_ha | some p in parcels; counts_for_minimum_area(p)])

is_first_commitment_year if year == o612.contract_start_year

first_year_minimum_area_status := "met" if {
	is_first_commitment_year
	wine_fruit_hop_area_ha >= params.first_year_minimum_area_ha
} else := "not_met" if {
	is_first_commitment_year
} else := "met" if {
	o612.first_year_area_ha >= params.first_year_minimum_area_ha
} else := "not_met" if {
	o612.first_year_area_ha < params.first_year_minimum_area_ha
} else := "unknown"

# --- Betriebsmindestgröße im 1. ÖPUL-Teilnahmejahr (SRL 1.6.1) ---------------

min_size := data.o6_12.minimum_farm_size_first_year

is_first_oepul_year if year == object.get(input, ["oepul", "first_participation_year"], -1)

farm_minimum_size_met if not is_first_oepul_year

farm_minimum_size_met if {
	is_first_oepul_year
	object.get(input, ["land", "protected_cultivation_area_ha"], 0) >= min_size.protected_cultivation_min_ha
}

farm_minimum_size_met if {
	is_first_oepul_year
	object.get(input, ["land", "total_area_ha"], 0) >= min_size.agricultural_area_min_ha
}

# --- Betriebliche Kombination mit Biologischer Wirtschaftsweise ----------------

bio_teilbetrieb := object.get(input, ["oepul", "bio_teilbetrieb"], {})

bio_teilbetrieb_arable_grassland if {
	bio_teilbetrieb.is_participating == true
	bio_teilbetrieb.organic_cultural_area == "arable_grassland"
}

bio_combination_conflict if {
	participates
	"1B" in participating_measures
	not bio_teilbetrieb_arable_grassland
}

# --- Zugangsvoraussetzungen gesamt (SRL 1.12.1.1) ------------------------------

access_condition_failures contains "applicant_not_eligible" if {
	participates
	not applicant_eligible
}

access_condition_failures contains "application_not_timely" if {
	participates
	not application_timely
}

access_condition_failures contains "entry_after_last_entry_year" if {
	participates
	not entry_year_allowed
}

access_condition_failures contains "first_year_minimum_area_not_met" if {
	participates
	first_year_minimum_area_status == "not_met"
}

access_condition_failures contains "farm_minimum_size_not_met" if {
	participates
	not farm_minimum_size_met
}

access_condition_failures contains "combination_with_organic_farming_excluded" if {
	bio_combination_conflict
}

# Bei Nichterfüllung im 1. Jahr kommt kein Vertrag zustande; ab dem 2. Jahr keine Prämie im betroffenen Jahr.
access_condition_consequence := "no_contract" if {
	count(access_condition_failures) > 0
	is_first_commitment_year
} else := "no_premium_in_year" if {
	count(access_condition_failures) > 0
} else := "none"

contract_established if {
	participates
	contract_period
	application_timely
	entry_year_allowed
	not access_condition_consequence == "no_contract"
}

# --- Förderfähigkeit der Einzelflächen ----------------------------------------

national_park_without_premium := {n.national_park | some n in data.o6_12.national_park_rules; n.o6_12_premium_possible == false}

parcel_exclusions[p.parcel_id] contains "not_wine_fruit_hop_area" if {
	some p in parcels
	not crop_category(p) in measure_crop_categories
}

parcel_exclusions[p.parcel_id] contains "ineligible_usage_type" if {
	some p in parcels
	usage_type(p) in ineligible_usage_types
}

parcel_exclusions[p.parcel_id] contains "land_use_code_not_permanent_crop" if {
	some p in parcels
	p.land_use_code
	not p.land_use_code in eligible_land_use_codes
}

parcel_exclusions[p.parcel_id] contains "vineyard_not_in_vineyard_register" if {
	some p in parcels
	crop_category(p) == "vineyard"
	p.in_vineyard_register == false
}

parcel_exclusions[p.parcel_id] contains "fruit_crop_not_listed" if {
	some p in parcels
	crop_category(p) == "orchard"
	not object.get(p, ["crop", "crop_name"], "") in listed_fruit_crops(year)
}

parcel_exclusions[p.parcel_id] contains "ungrafted_fruit_planting_material" if {
	some p in parcels
	crop_category(p) == "orchard"
	p.crop.grafted_planting_material == false
}

parcel_exclusions[p.parcel_id] contains "code_op" if {
	some p in parcels
	"OP" in parcel_codes(p)
}

parcel_exclusions[p.parcel_id] contains "code_vf_experimental_area" if {
	some p in parcels
	"VF" in parcel_codes(p)
}

parcel_exclusions[p.parcel_id] contains "measure_specific_op_code" if {
	some p in parcels
	"12" in object.get(p, "measure_op_exclusions", [])
}

parcel_exclusions[p.parcel_id] contains "not_declared_for_measure" if {
	some p in parcels
	not "12" in object.get(p, "declared_measures", [])
}

parcel_exclusions[p.parcel_id] contains "national_park_without_premium" if {
	some p in parcels
	object.get(p, "national_park", null) in national_park_without_premium
}

parcel_exclusions[p.parcel_id] contains "outside_austria" if {
	some p in parcels
	object.get(p, "country", "AT") != "AT"
}

parcel_exclusions[p.parcel_id] contains "gloez_landscape_element" if {
	some p in parcels
	p.is_gloez_landscape_element == true
}

parcel_exclusions[p.parcel_id] contains "not_mainly_agricultural_use" if {
	some p in parcels
	p.mainly_agricultural_use == false
}

parcel_exclusions[p.parcel_id] contains "non_agricultural_use_exceeds_14_days" if {
	some p in parcels
	object.get(p, "non_agricultural_use_days", 0) > 14
}

parcel_exclusions[p.parcel_id] contains "below_minimum_parcel_size_50_m2" if {
	some p in parcels
	p.area_ha * 10000 < 50
}

parcel_exclusions[p.parcel_id] contains "minimum_management_not_met" if {
	some p in parcels
	some k in ["properly_planted", "annual_care", "harvested"]
	object.get(p, ["minimum_management", k], true) == false
}

parcel_exclusions[p.parcel_id] contains "overlap_with_other_public_funding" if {
	some p in parcels
	p.other_public_funding_same_service == true
}

parcel_exclusions[p.parcel_id] contains "commitment_not_fulfilled_whole_year" if {
	some p in parcels
	p.commitment_fulfilled_whole_year == false
}

eligible_parcel_ids := {p.parcel_id |
	some p in parcels
	crop_category(p) in measure_crop_categories
	not parcel_exclusions[p.parcel_id]
}

eligible_area_ha := sum([p.area_ha | some p in parcels; p.parcel_id in eligible_parcel_ids])

# Obstflächen mit unveredeltem Pflanzgut sind mit dem Code OP zu beantragen.
op_code_required_parcels contains p.parcel_id if {
	some p in parcels
	crop_category(p) == "orchard"
	p.crop.grafted_planting_material == false
	not "OP" in parcel_codes(p)
}

# Ernteverpflichtung nicht erfüllt -> verpflichtende Vergabe des Codes OP.
op_code_required_parcels contains p.parcel_id if {
	some p in parcels
	is_wine_fruit_hop_parcel(p)
	object.get(p, ["minimum_management", "harvested"], true) == false
	not "OP" in parcel_codes(p)
	not "12" in object.get(p, "measure_op_exclusions", [])
}

# --- Kombination auf der Einzelfläche (Anhang L) ------------------------------

combination_cell(measure_id) := c if {
	some c in data.o6_12.combination_anhang_l.cells
	c.measure_id == measure_id
}

parcel_combination_conflicts[p.parcel_id] contains m if {
	some p in parcels
	p.parcel_id in eligible_parcel_ids
	some m in object.get(p, "declared_measures", [])
	m != "12"
	combination_cell(m).combinable_on_parcel == false
}

parcel_combination_landscape_element_only[p.parcel_id] contains m if {
	some p in parcels
	p.parcel_id in eligible_parcel_ids
	some m in object.get(p, "declared_measures", [])
	combination_cell(m).only_landscape_elements == true
}

# Optionaler Zuschlag "Einsatz von Organismen oder Pheromonen" (Maßnahme 10) wird bei Teilnahme an 12 um 50 % reduziert.
o6_10_organism_supplement_factor := 0.5 if participates

else := 1.0
