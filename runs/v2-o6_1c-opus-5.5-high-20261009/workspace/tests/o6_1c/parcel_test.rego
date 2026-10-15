package oepul.o6_1c_test

import data.oepul.o6_1c

# --- Nichtproduktive Ackerflächen -------------------------------------------

test_npa_invalid_establishment if {
	inp := replace("/land/parcels/0/o6_1c/npa/establishment", "maize")
	has_parcel_rule(o6_1c.npa_violations, "O6_1C-NPA-001", "NPA1") with input as inp
}

test_npa_sowing_after_15_may if {
	inp := replace("/land/parcels/0/o6_1c/npa/sowing_date", "2026-05-16")
	has_parcel_rule(o6_1c.npa_violations, "O6_1C-NPA-002", "NPA1") with input as inp
	ok := replace("/land/parcels/0/o6_1c/npa/sowing_date", "2026-05-15")
	not has_rule(o6_1c.npa_violations, "O6_1C-NPA-002") with input as ok
}

test_npa_breaking_before_15_september if {
	inp := replace("/land/parcels/1/o6_1c/npa/breaking_date", "2026-09-10")
	has_parcel_rule(o6_1c.npa_violations, "O6_1C-NPA-003", "NPA2") with input as inp
	ok := replace("/land/parcels/1/o6_1c/npa/breaking_date", "2026-09-15")
	not has_rule(o6_1c.npa_violations, "O6_1C-NPA-003") with input as ok
}

test_npa_breaking_from_1_august_with_catch_crop if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/1/o6_1c/npa/breaking_date", "value": "2026-08-01"},
		{"op": "replace", "path": "/land/parcels/1/o6_1c/npa/follow_crop", "value": "catch_crop"},
	])
	not has_rule(o6_1c.npa_violations, "O6_1C-NPA-003") with input as inp
	early := json.patch(inp, [{"op": "replace", "path": "/land/parcels/1/o6_1c/npa/breaking_date", "value": "2026-07-31"}])
	has_rule(o6_1c.npa_violations, "O6_1C-NPA-003") with input as early
}

test_npa_psm_only_bio_substances_allowed if {
	inp := replace("/land/parcels/0/operations/psm_used", true)
	has_parcel_rule(o6_1c.npa_violations, "O6_1C-NPA-005", "NPA1") with input as inp
	bio := json.patch(inp, [{"op": "replace", "path": "/land/parcels/0/o6_1c/npa/psm_only_bio_permitted_substances", "value": true}])
	not has_rule(o6_1c.npa_violations, "O6_1C-NPA-005") with input as bio
}

test_npa_fertilisation_forbidden if {
	inp := replace("/land/parcels/0/operations/fertilizer/organic_n_kg_per_ha", 20)
	has_parcel_rule(o6_1c.npa_violations, "O6_1C-NPA-005", "NPA1") with input as inp
}

test_npa_removal_only_mechanical if {
	inp := replace("/land/parcels/0/o6_1c/npa/removal_method", "chemical")
	has_parcel_rule(o6_1c.npa_violations, "O6_1C-NPA-006", "NPA1") with input as inp
	ok := replace("/land/parcels/0/o6_1c/npa/removal_method", "incorporation")
	not has_rule(o6_1c.npa_violations, "O6_1C-NPA-006") with input as ok
}

test_npa_minimum_one_cut_every_second_year if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/1/o6_1c/npa/cutting_events", "value": []},
		{"op": "replace", "path": "/land/parcels/1/o6_1c/npa/cut_in_previous_year", "value": false},
	])
	has_parcel_rule(o6_1c.npa_violations, "O6_1C-NPA-007", "NPA2") with input as inp
	ok := json.patch(inp, [{"op": "replace", "path": "/land/parcels/1/o6_1c/npa/cut_in_previous_year", "value": true}])
	not has_rule(o6_1c.npa_violations, "O6_1C-NPA-007") with input as ok
}

test_npa_max_two_cuts_cleaning_cut_not_counted if {
	inp := replace("/land/parcels/0/o6_1c/npa/cutting_events", [
		{"date": "2026-06-01", "type": "cleaning_cut", "biomass_removed": false},
		{"date": "2026-08-10", "type": "mulching", "biomass_removed": false},
		{"date": "2026-10-10", "type": "care_mowing", "biomass_removed": false},
	])
	not has_rule(o6_1c.npa_violations, "O6_1C-NPA-008") with input as inp
	three := replace("/land/parcels/0/o6_1c/npa/cutting_events", [
		{"date": "2026-08-02", "type": "mulching", "biomass_removed": false},
		{"date": "2026-09-10", "type": "mulching", "biomass_removed": false},
		{"date": "2026-10-10", "type": "care_mowing", "biomass_removed": false},
	])
	has_parcel_rule(o6_1c.npa_violations, "O6_1C-NPA-008", "NPA1") with input as three
}

test_npa_no_removal_of_cuttings_no_grazing if {
	inp := replace("/land/parcels/0/o6_1c/npa/cutting_events/1/biomass_removed", true)
	has_parcel_rule(o6_1c.npa_violations, "O6_1C-NPA-009", "NPA1") with input as inp
	grazed := replace("/land/parcels/1/o6_1c/npa/grazed", true)
	has_parcel_rule(o6_1c.npa_violations, "O6_1C-NPA-009", "NPA2") with input as grazed
}

test_npa_fifty_percent_not_before_1_august if {
	inp := replace("/land/parcels/0/o6_1c/npa/cutting_events/1/date", "2026-07-15")
	has_rule(o6_1c.farm_npa_violations, "O6_1C-NPA-010") with input as inp
	count(o6_1c.farm_npa_violations) == 0 with input as base_input
}

test_npa_cleaning_cut_not_allowed_on_existing_fallow if {
	inp := replace("/land/parcels/1/o6_1c/npa/cutting_events", [{"date": "2026-05-20", "type": "cleaning_cut", "biomass_removed": false}])
	has_parcel_rule(o6_1c.npa_violations, "O6_1C-NPA-012", "NPA2") with input as inp
	resown := json.patch(inp, [
		{"op": "replace", "path": "/land/parcels/1/o6_1c/npa/existing_green_fallow_broken_and_resown", "value": true},
		{"op": "replace", "path": "/land/parcels/1/o6_1c/npa/first_application_year", "value": 2026},
	])
	not has_rule(o6_1c.npa_violations, "O6_1C-NPA-012") with input as resown
}

test_npa_cleaning_cut_only_first_year if {
	inp := replace("/land/parcels/0/o6_1c/npa/first_application_year", 2025)
	has_parcel_rule(o6_1c.npa_violations, "O6_1C-NPA-012", "NPA1") with input as inp
}

test_npa_use_ban_after_breaking if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/1/o6_1c/npa/breaking_date", "value": "2026-09-20"},
		{"op": "replace", "path": "/land/parcels/1/o6_1c/npa/used_after_breaking", "value": true},
	])
	has_parcel_rule(o6_1c.npa_violations, "O6_1C-NPA-013", "NPA2") with input as inp
}

test_npa_not_combinable_on_single_area if {
	inp := replace("/land/parcels/0/other_oepul_measures", ["o6_6"])
	has_parcel_rule(o6_1c.npa_violations, "O6_1C-NPA-015", "NPA1") with input as inp
	not o6_1c.combinable_on_single_area("1C", "6")
	o6_1c.combinable_on_single_area("6", "1A")
}

test_npa_not_creditable_to_other_obligations if {
	inp := replace("/land/parcels/0/o6_1c/npa/credited_to_other_obligations", ["o6_1a_biodiversity"])
	has_parcel_rule(o6_1c.npa_violations, "O6_1C-NPA-015", "NPA1") with input as inp
}

test_npa_field_use_type_and_code if {
	inp := replace("/land/parcels/0/oepul_codes", [])
	has_parcel_rule(o6_1c.npa_violations, "O6_1C-APP-003", "NPA1") with input as inp
	wrong := replace("/land/parcels/0/field_use_type", "Silomais")
	has_parcel_rule(o6_1c.npa_violations, "O6_1C-APP-003", "NPA1") with input as wrong
}

test_npa_excluded_from_grassland_conversion if {
	"NPA1" in o6_1c.excluded_from_grassland_conversion with input as base_input
}

# --- Agroforststreifen ------------------------------------------------------

test_afs_definition_width if {
	inp := replace("/land/parcels/2/o6_1c/agroforest/average_width_m", 12)
	has_parcel_rule(o6_1c.afs_definition_violations, "O6_1C-AFS-DEF-003", "AFS1") with input as inp
	approx(o6_1c.afs_eligible_area_ha, 0) with input as inp
	narrow := replace("/land/parcels/2/o6_1c/agroforest/average_width_m", 1.5)
	has_rule(o6_1c.afs_definition_violations, "O6_1C-AFS-DEF-003") with input as narrow
}

test_afs_definition_density if {
	dense := replace("/land/parcels/2/o6_1c/agroforest/tree_count", 180)
	has_rule(o6_1c.afs_definition_violations, "O6_1C-AFS-DEF-004") with input as dense
	sparse := replace("/land/parcels/2/o6_1c/agroforest/tree_count", 50)
	has_rule(o6_1c.afs_definition_violations, "O6_1C-AFS-DEF-004") with input as sparse
	edge := replace("/land/parcels/2/o6_1c/agroforest/tree_count", 60)
	not has_rule(o6_1c.afs_definition_violations, "O6_1C-AFS-DEF-004") with input as edge
}

test_afs_definition_spacing_adjacency_year if {
	spacing := replace("/land/parcels/2/o6_1c/agroforest/max_tree_spacing_m", 16)
	has_rule(o6_1c.afs_definition_violations, "O6_1C-AFS-DEF-005") with input as spacing
	adj := replace("/land/parcels/2/o6_1c/agroforest/directly_adjacent_to_arable", false)
	has_rule(o6_1c.afs_definition_violations, "O6_1C-AFS-DEF-001") with input as adj
	old := replace("/land/parcels/2/o6_1c/agroforest/establishment_year", 2019)
	has_rule(o6_1c.afs_definition_violations, "O6_1C-AFS-DEF-002") with input as old
	special := replace("/land/parcels/2/o6_1c/agroforest/is_special_crop_gsp_av_25_4", true)
	has_rule(o6_1c.afs_definition_violations, "O6_1C-AFS-DEF-006") with input as special
	forest := replace("/land/parcels/2/o6_1c/agroforest/long_side_adjacent_to_forest_or_areal_landscape_element", true)
	has_rule(o6_1c.afs_definition_violations, "O6_1C-AFS-DEF-009") with input as forest
	ref := replace("/land/parcels/2/o6_1c/agroforest/on_or_adjacent_to_reference_area", false)
	has_rule(o6_1c.afs_definition_violations, "O6_1C-AFS-DEF-010") with input as ref
}

test_afs_negative_list_species_and_genus if {
	robinia := replace("/land/parcels/2/o6_1c/agroforest/woody_species", ["Juglans regia", "Robinia pseudoacacia"])
	has_rule(o6_1c.afs_definition_violations, "O6_1C-AFS-DEF-008") with input as robinia
	elaeagnus := replace("/land/parcels/2/o6_1c/agroforest/woody_species", ["Elaeagnus angustifolia"])
	has_rule(o6_1c.afs_definition_violations, "O6_1C-AFS-DEF-008") with input as elaeagnus
	count(data.o6_1c.agroforest_negative_list.rows) == 14
}

test_afs_shrubs_allowed if {
	"AFS1" in o6_1c.afs_shrubs_permitted with input as base_input
	count(o6_1c.afs_definition_violations) == 0 with input as base_input
}

test_afs_new_planting_deadline if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/2/o6_1c/agroforest/establishment", "value": "new_planting"},
		{"op": "replace", "path": "/land/parcels/2/o6_1c/agroforest/establishment_year", "value": 2026},
		{"op": "replace", "path": "/land/parcels/2/o6_1c/agroforest/planting_date", "value": "2026-05-20"},
	])
	has_parcel_rule(o6_1c.afs_commitment_violations, "O6_1C-AFS-001", "AFS1") with input as inp
}

test_afs_removal_requires_criteria_or_replanting if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/2/o6_1c/agroforest/woody_plants_removed", "value": true},
		{"op": "replace", "path": "/land/parcels/2/o6_1c/agroforest/tree_count", "value": 40},
	])
	has_parcel_rule(o6_1c.afs_commitment_violations, "O6_1C-AFS-002", "AFS1") with input as inp
	replanted := json.patch(inp, [{"op": "replace", "path": "/land/parcels/2/o6_1c/agroforest/replanting_date", "value": "2026-04-30"}])
	not has_rule(o6_1c.afs_commitment_violations, "O6_1C-AFS-002") with input as replanted
	still_ok := replace("/land/parcels/2/o6_1c/agroforest/woody_plants_removed", true)
	not has_rule(o6_1c.afs_commitment_violations, "O6_1C-AFS-002") with input as still_ok
}

test_afs_care_measures if {
	inp := replace("/land/parcels/2/o6_1c/agroforest/care/browsing_protection", false)
	has_parcel_rule(o6_1c.afs_commitment_violations, "O6_1C-AFS-003", "AFS1") with input as inp
}

test_afs_herbaceous_area if {
	bare := replace("/land/parcels/2/o6_1c/agroforest/herbaceous_area_permanently_green", false)
	has_rule(o6_1c.afs_commitment_violations, "O6_1C-AFS-004") with input as bare
	grazing := replace("/land/parcels/2/o6_1c/agroforest/herbaceous_area_use", "grazing")
	has_rule(o6_1c.afs_commitment_violations, "O6_1C-AFS-005") with input as grazing
	mulch := replace("/land/parcels/2/o6_1c/agroforest/herbaceous_area_use", "mulching")
	not has_rule(o6_1c.afs_commitment_violations, "O6_1C-AFS-005") with input as mulch
}

test_afs_fertiliser_psm_browsing_agent if {
	fert := replace("/land/parcels/2/o6_1c/agroforest/fertilizer_used", true)
	has_rule(o6_1c.afs_commitment_violations, "O6_1C-AFS-006") with input as fert
	agent := replace("/land/parcels/2/o6_1c/agroforest/browsing_protection_agent_used", true)
	has_rule(o6_1c.afs_commitment_violations, "O6_1C-AFS-006") with input as agent
	bio := json.patch(agent, [{"op": "replace", "path": "/land/parcels/2/o6_1c/agroforest/browsing_protection_agent_bio_approved", "value": true}])
	not has_rule(o6_1c.afs_commitment_violations, "O6_1C-AFS-006") with input as bio
}

test_afs_all_applied_strips_bound_by_commitments if {
	# LSE Agroforststreifen ohne explizite Kategorie wird bei Teilnahme miterfasst.
	inp := json.patch(base_input, [{"op": "add", "path": "/land/parcels/-", "value": {
		"parcel_id": "AFS2", "area_ha": 0.2, "field_use_type": "LSE Agroforststreifen",
		"o6_1c": {"agroforest": {"fertilizer_used": true}},
	}}])
	has_parcel_rule(o6_1c.afs_commitment_violations, "O6_1C-AFS-006", "AFS2") with input as inp
}

test_afs_field_use_type if {
	inp := replace("/land/parcels/2/field_use_type", "Hecke")
	has_parcel_rule(o6_1c.afs_commitment_violations, "O6_1C-APP-004", "AFS1") with input as inp
}

test_afs_credit_for_ubb_bio_field_piece if {
	c := o6_1c.ubb_bio_creditable_afs_area_by_field_piece with input as base_input
	approx(c.FS1, 0.3)
	o6_1c.afs_counts_towards_ubb_bio_seven_percent == false
}

test_conversion_into_lse_agroforest_permitted if {
	o6_1c.conversion_permitted("A", "LSE Agroforststreifen")
	o6_1c.conversion_permitted("G", "L")
	not o6_1c.conversion_permitted("G", "A")
}

# --- Allgemeine Flächenförderfähigkeit -------------------------------------

test_national_park_neusiedlersee_excluded if {
	inp := add_field("/land/parcels/0/national_park", {"in_national_park": true, "name": "Neusiedlersee", "relevant_management_restrictions": false})
	{"parcel_id": "NPA1", "rule_id": "O6_1C-GEN-001"} in o6_1c.parcel_exclusions with input as inp
	approx(o6_1c.npa_eligible_area_ha, 0.8) with input as inp
}

test_national_park_without_restrictions_eligible if {
	inp := add_field("/land/parcels/0/national_park", {"in_national_park": true, "name": "Thayatal", "relevant_management_restrictions": false})
	count(o6_1c.parcel_exclusions) == 0 with input as inp
}

test_op_and_vf_codes_exclude if {
	op := replace("/land/parcels/2/oepul_codes", ["OP"])
	{"parcel_id": "AFS1", "rule_id": "O6_1C-GEN-002"} in o6_1c.parcel_exclusions with input as op
	vf := replace("/land/parcels/2/oepul_codes", ["VF"])
	{"parcel_id": "AFS1", "rule_id": "O6_1C-GEN-003"} in o6_1c.parcel_exclusions with input as vf
}

test_transfer_without_successor_requires_op if {
	inp := add_field("/land/parcels/0/transfer", {"transferred_during_year": true, "successor_continues_commitment": false})
	has_parcel_rule(o6_1c.general_violations, "O6_1C-GEN-004", "NPA1") with input as inp
	ok := add_field("/land/parcels/0/transfer", {"transferred_during_year": true, "successor_continues_commitment": true})
	count(o6_1c.parcel_exclusions) == 0 with input as ok
}

test_public_funding_overlap if {
	inp := add_field("/land/parcels/0/public_funding_overlap", true)
	has_parcel_rule(o6_1c.general_violations, "O6_1C-GEN-005", "NPA1") with input as inp
}

test_minimum_area_50_m2 if {
	inp := replace("/land/parcels/2/area_ha", 0.004)
	{"parcel_id": "AFS1", "rule_id": "O6_1C-GEN-007"} in o6_1c.parcel_exclusions with input as inp
}

test_parcel_outside_austria if {
	inp := add_field("/land/parcels/0/in_austria", false)
	{"parcel_id": "NPA1", "rule_id": "O6_1C-ELIG-005"} in o6_1c.parcel_exclusions with input as inp
}

test_green_fallow_not_excluded_as_inactive_area if {
	inp := add_field("/land/parcels/0/non_eligible_area_types", ["not_actively_managed"])
	count(o6_1c.parcel_exclusions) == 0 with input as inp
	gloez := add_field("/land/parcels/0/non_eligible_area_types", ["gloez_landscape_element"])
	{"parcel_id": "NPA1", "rule_id": "O6_1C-GEN-008"} in o6_1c.parcel_exclusions with input as gloez
}

test_minimum_management_exempt if {
	o6_1c.minimum_management_exempt
}

test_annex_l_matrix_complete if {
	count(data.o6_1c.annex_l_combination.cells) == 420
	count([c | some c in data.o6_1c.annex_l_combination.cells; c.row == "1C"; c.combinable]) == 0
	count([c | some c in data.o6_1c.annex_l_combination.cells; c.col == "1C"; c.combinable]) == 0
}

test_annex_l_combination_assessment_with_footnotes if {
	o6_1c.combination_assessment("1C", "1A") == {"combinable": false, "premium_deduction": false, "restriction": null}
	a := o6_1c.combination_assessment("1A", "4")
	a.combinable == true
	a.restriction == "Kombinierbar nur betreffend Abgeltung der Landschaftselemente"
	b := o6_1c.combination_assessment("1B", "16")
	b.premium_deduction == true
	c := o6_1c.combination_assessment("10", "1B")
	startswith(c.restriction, "Im Fall des optionalen Zuschlages")
	count(data.o6_1c.annex_l_combination.footnotes) == 4
}
