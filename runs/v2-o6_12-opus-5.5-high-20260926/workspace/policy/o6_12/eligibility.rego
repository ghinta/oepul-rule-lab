# Maßnahme 12 – Zugangs- und Fördervoraussetzungen: Förderwerbende Person, Betriebsmindestgröße, Mindestteilnahmefläche und Förderfähigkeit von Schlägen.
package oepul.o6_12

applicant := object.get(input, ["farm", "applicant"], {})

# --- Förderwerbende Personen (SRL 1.4, AT 5.2) ---
applicant_type_row := row if {
	some row in data.o6_12.oepul_eligible_applicant_types
	row.person_type == applicant.person_type
}

public_body_exception_applies if {
	some row in data.o6_12.oepul_public_body_exception_measures
	row.measure_code == measure.code
	row.year_from <= application_year
	object.get(row, "year_to", null) == null
}

public_body_exception_applies if {
	some row in data.o6_12.oepul_public_body_exception_measures
	row.measure_code == measure.code
	row.year_from <= application_year
	row.year_to >= application_year
}

applicant_findings contains "applicant_type_not_eligible" if {
	applicant.person_type
	not applicant_type_row
	not public_body_exception_applies
}

applicant_findings contains "public_body_share_above_25_percent" if {
	max_share := applicant_type_row.max_public_body_share_percent
	max_share != null
	object.get(applicant, "public_body_share_percent", 0) > max_share
	not public_body_exception_applies
}

applicant_findings contains "not_active_farmer" if {
	applicant.is_active_farmer == false
}

applicant_findings contains "no_agricultural_activity" if {
	applicant.performs_agricultural_activity == false
}

applicant_findings contains "not_farming_in_own_name_and_account" if {
	applicant.farms_in_own_name_and_account == false
}

applicant_eligible if count(applicant_findings) == 0

# --- Betriebsmindestgröße im 1. ÖPUL-Teilnahmejahr (SRL 1.6.1, AT 5.3) ---
first_oepul_year := object.get(oepul, ["first_participation_year"], null)

farm_min_size_required if first_oepul_year == application_year

farm_min_size_met if {
	object.get(input, ["land", "protected_cultivation_area_ha"], 0) >= general.farm_min_protected_cultivation_ha
}

farm_min_size_met if {
	input.land.total_area_ha >= general.farm_min_agricultural_area_ha
}

farm_min_size_ok if not farm_min_size_required

farm_min_size_ok if {
	farm_min_size_required
	farm_min_size_met
}

# --- Mindestteilnahmefläche 0,50 ha WOH im 1. Verpflichtungsjahr (SRL 2.12, MB 3.2) ---
first_commitment_year_is_current if commitment_start_year == application_year

min_participation_ok if not first_commitment_year_is_current

min_participation_ok if {
	first_commitment_year_is_current
	woh_area_ha >= measure.min_participation_area_first_year_ha
}

# --- Zugangsvoraussetzungen gesamt ---
access_requirements_met if {
	applicant_eligible
	farm_min_size_ok
	min_participation_ok
}

# Folge nicht erfüllter Zugangsvoraussetzungen (SRL 1.12.1.1).
access_failure_consequence := "no_contract" if {
	not access_requirements_met
	first_commitment_year_is_current
}

access_failure_consequence := "no_premium_current_year" if {
	not access_requirements_met
	not first_commitment_year_is_current
}

# --- Förderfähigkeit der Einzelschläge ---
parcel_ineligible contains [p.parcel_id, "not_wine_fruit_hop_area"] if {
	some p in parcels
	not is_woh_parcel(p)
}

parcel_ineligible contains [p.parcel_id, "use_type_not_premium_eligible"] if {
	some p in parcels
	is_woh_parcel(p)
	not type_info(p).premium_eligible
}

parcel_ineligible contains [p.parcel_id, "fruit_crop_not_in_oepul_fruit_list"] if {
	some p in parcels
	fruit_crop_not_listed(p)
}

parcel_ineligible contains [p.parcel_id, "fruit_not_grafted_planting_material"] if {
	some p in parcels
	woh_type(p) == "fruit"
	object.get(p, ["crop", "fruit_grafted"], null) == false
}

parcel_ineligible contains [p.parcel_id, "op_code_set"] if {
	some p in parcels
	some code in parcel_op_codes(p)
	code == "OP"
}

parcel_ineligible contains [p.parcel_id, "measure_specific_op_code_set"] if {
	some p in parcels
	object.get(p, ["oepul", "measure_op_code_o6_12"], false) == true
}

parcel_ineligible contains [p.parcel_id, "located_outside_austria"] if {
	some p in parcels
	object.get(p, ["location", "in_austria"], true) == false
}

parcel_ineligible contains [p.parcel_id, "national_park_without_area_premiums"] if {
	some p in parcels
	np := object.get(p, ["location", "national_park"], null)
	some row in data.o6_12.oepul_national_park_rules
	row.national_park == np
	row.area_premiums_granted == false
	not measure.code in row.exempt_measures
}

parcel_ineligible contains [p.parcel_id, "scientific_trial_area_vf"] if {
	some p in parcels
	object.get(p, ["oepul", "trial_area_vf"], false) == true
}

parcel_ineligible contains [p.parcel_id, "gloez_landscape_element"] if {
	some p in parcels
	object.get(p, ["oepul", "is_gloez_landscape_element"], false) == true
}

parcel_ineligible contains [p.parcel_id, "not_declared_for_measure"] if {
	some p in parcels
	object.get(p, ["oepul", "declared_for_o6_12"], true) == false
}

parcel_ineligible contains [p.parcel_id, "transferred_without_continuation"] if {
	some p in parcels
	object.get(p, ["oepul", "transferred_during_year"], false) == true
	object.get(p, ["oepul", "successor_continues_commitment"], false) == false
}

parcel_ineligible contains [p.parcel_id, "minimum_management_not_met"] if {
	some p in parcels
	some key in ["proper_planting", "annual_care", "harvest_and_removal"]
	object.get(p, ["operations", "minimum_management", key], true) == false
}

parcel_ineligible contains [p.parcel_id, "not_actively_farmed"] if {
	some p in parcels
	object.get(p, ["operations", "actively_farmed"], true) == false
}

parcel_ineligible_reasons := {pid: reasons |
	some p in parcels
	pid := p.parcel_id
	reasons := {r | some [id, r] in parcel_ineligible; id == pid}
}

premium_eligible_parcel(p) if {
	is_woh_parcel(p)
	count(parcel_ineligible_reasons[p.parcel_id]) == 0
}

premium_eligible_parcel_ids contains p.parcel_id if {
	some p in parcels
	premium_eligible_parcel(p)
}
