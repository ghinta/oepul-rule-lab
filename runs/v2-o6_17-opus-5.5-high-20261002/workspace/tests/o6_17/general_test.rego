package oepul.o6_17_test

import rego.v1

import data.oepul.o6_17

# --- Förderwerbende Personen --------------------------------------------------

with_applicant(a) := object.union(base_input, {"farm": object.union(base_input.farm, {"applicant": a})})

test_natural_person_eligible if {
	o6_17.applicant_eligible with input as base_input
}

test_legal_person_public_share_above_25_ineligible if {
	inp := with_applicant({"legal_form": "legal_person", "public_body_share_percent": 30, "is_active_farmer": true})
	not o6_17.applicant_eligible with input as inp
	some v in o6_17.general_violations with input as inp
	v.rule_id == "GEN-APPLICANT"
}

test_legal_person_public_share_25_eligible if {
	o6_17.applicant_eligible with input as with_applicant({"legal_form": "legal_person", "public_body_share_percent": 25, "is_active_farmer": true})
}

test_public_body_ineligible_for_o6_17 if {
	not o6_17.applicant_eligible with input as with_applicant({"legal_form": "public_body", "is_active_farmer": true})
}

test_not_active_farmer_ineligible if {
	not o6_17.applicant_eligible with input as with_applicant({"legal_form": "natural_person", "is_active_farmer": false})
}

# --- Betriebsmindestgröße -----------------------------------------------------

test_farm_min_size_first_oepul_year if {
	inp := object.union(with_year(2023), {"land": object.union(base_input.land, {"total_area_ha": 1.4})})
	some v in o6_17.general_violations with input as inp
	v.rule_id == "GEN-FARM-MIN-SIZE"
}

test_farm_min_size_protected_cultivation if {
	inp := object.union(with_year(2023), {"land": object.union(base_input.land, {"total_area_ha": 0.6, "protected_cultivation_area_ha": 0.5})})
	o6_17.farm_min_size_met with input as inp
}

# --- Mindestbewirtschaftung ---------------------------------------------------

test_unmown_meadow_violates_minimum_management if {
	p := object.union(meadow, {"operations": {"cutting_dates": []}})
	some v in o6_17.general_violations with input as with_parcels([p, single_cut, clover])
	v.rule_id == "GEN-MIN-MANAGEMENT-GRASSLAND"
}

test_grazed_meadow_meets_minimum_management if {
	p := object.union(parcel_with(meadow, {"grazed_fully": true}), {"operations": {"cutting_dates": []}})
	o6_17.minimum_management_met(p)
}

test_bergmaehder_every_two_years if {
	berg := object.union(parcel_with(single_cut, {"field_use_type": "bergmaehder", "last_mowing_year": 2024}), {"operations": {"cutting_dates": []}})
	o6_17.minimum_management_met(berg) with input as base_input
	berg_old := parcel_with(berg, {"last_mowing_year": 2023})
	not o6_17.minimum_management_met(berg_old) with input as base_input
}

# --- Flächenabgang ------------------------------------------------------------

test_area_reduction_tolerance_min_0_5_ha if {
	inp := with_measure({"measure_area_previous_year_ha": 6.0, "measure_area_current_year_ha": 5.6})
	o6_17.area_reduction_tolerance_ha == 0.5 with input as inp
	not o6_17.area_reduction_repayment_required with input as inp
}

test_area_reduction_tolerance_5_percent if {
	inp := with_measure({"measure_area_previous_year_ha": 40.0, "measure_area_current_year_ha": 37.5})
	o6_17.area_reduction_tolerance_ha == 2 with input as inp
	o6_17.area_reduction_repayment_required with input as inp
	o6_17.area_reduction_repayment_area_ha == 2.5 with input as inp
}

test_area_reduction_tolerance_max_5_ha if {
	o6_17.area_reduction_tolerance_ha == 5 with input as with_measure({"measure_area_previous_year_ha": 200.0, "measure_area_current_year_ha": 196.0})
}

test_loss_of_disposal_not_counted if {
	inp := with_measure({"measure_area_previous_year_ha": 40.0, "measure_area_current_year_ha": 30.0, "area_reduction_loss_of_disposal_ha": 9.0})
	not o6_17.area_reduction_repayment_required with input as inp
}

# --- Ausstieg / Übernahme -----------------------------------------------------

test_early_exit_requires_repayment if {
	o6_17.early_exit_repayment_required with input as with_measure({"exit_year": 2026})
}

test_takeover_deadline_and_expansion if {
	inp := with_measure({"takeover": {"application_date": "2025-04-15", "taken_over_area_ha": 10.0, "expansion_to_other_area_ha": 5.0}})
	o6_17.takeover_permitted with input as inp
	late := with_measure({"takeover": {"application_date": "2025-04-16", "taken_over_area_ha": 10.0, "expansion_to_other_area_ha": 5.0}})
	not o6_17.takeover_permitted with input as late
	too_big := with_measure({"takeover": {"application_date": "2025-04-01", "taken_over_area_ha": 10.0, "expansion_to_other_area_ha": 5.5}})
	not o6_17.takeover_permitted with input as too_big
}

test_takeover_deadline_2028_is_17_april if {
	o6_17.takeover_deadline(2028) == "2028-04-17"
	o6_17.takeover_deadline(2026) == "2026-04-15"
}

# --- Sanktionen ---------------------------------------------------------------

test_sanction_warning_becomes_1_percent_from_2027 if {
	o6_17.sanction_share("warning", 2026) == 0
	o6_17.sanction_share("warning", 2027) == 0.01
	o6_17.sanction_share("reduction_25", 2025) == 0.25
}

test_exclusion_after_two_full_reductions if {
	o6_17.exclusion_required with input as with_measure({"full_reductions_in_contract_period": 2})
	not o6_17.exclusion_required with input as with_measure({"full_reductions_in_contract_period": 1})
}
