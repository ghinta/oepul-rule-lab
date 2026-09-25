package oepul.o6_1c_test

import data.oepul.o6_1c

# Grundfall: konformer Betrieb 2026 mit zwei NPA-Schlägen und einem Agroforststreifen.
base := {
	"farm": {
		"farm_id": "AT-TEST-1",
		"year": 2026,
		"region": {"federal_state": "Niederösterreich", "district": "Tulln"},
		"applicant": {
			"legal_form": "natural_person",
			"public_body_share_percent": 0,
			"is_active_farmer": true,
			"carries_out_agricultural_activity": true,
			"manages_farm_in_own_name_and_account": true,
		},
		"oepul": {
			"first_participation_year": 2023,
			"mfa_submitted": true,
			"measure_participations": [
				{"measure_code": "1C", "category": "npa", "option": null, "application_date": "2025-11-20", "first_contract_year": 2026, "deregistration_date": null},
				{"measure_code": "1C", "category": "afs", "option": null, "application_date": "2025-11-20", "first_contract_year": 2026, "deregistration_date": null},
				{"measure_code": "6", "category": null, "option": null, "application_date": "2022-12-01", "first_contract_year": 2023, "deregistration_date": null},
			],
		},
	},
	"land": {
		"total_area_ha": 60,
		"arable_area_ha": 50,
		"parcels": [
			{
				"parcel_id": "P1",
				"area_ha": 1,
				"land_use": "arable",
				"schlagnutzungsart": "Grünbrache",
				"oepul_codes": ["NPA"],
				"operations": {"psm_used": false, "fertilizer": {"mineral_n_kg_per_ha": 0, "organic_n_kg_per_ha": 0}},
				"constraints": {"gloez4_buffer_area_ha": 0},
				"npa": {
					"establishment_type": "new_sowing",
					"sowing_date": "2026-04-20",
					"first_npa_declaration_year": 2026,
					"breaking_date": null,
					"follow_up_crop": "none",
					"removal_method": null,
					"maintenance_events": [
						{"date": "2026-06-10", "type": "cleaning_cut", "biomass_removed": false, "biomass_used": false},
						{"date": "2026-08-05", "type": "mulching", "biomass_removed": false, "biomass_used": false},
					],
					"maintenance_in_previous_year": null,
					"grazed": false,
					"used_after_breaking": false,
					"psm_only_bio_active_substances": null,
					"any_fertilization": false,
				},
			},
			{
				"parcel_id": "P2",
				"area_ha": 0.5,
				"land_use": "arable",
				"schlagnutzungsart": "Grünbrache",
				"oepul_codes": ["NPA"],
				"operations": {"psm_used": false},
				"npa": {
					"establishment_type": "retained_green_fallow",
					"first_npa_declaration_year": 2025,
					"breaking_date": null,
					"follow_up_crop": "none",
					"maintenance_events": [{"date": "2026-08-15", "type": "maintenance_mowing", "biomass_removed": false, "biomass_used": false}],
					"maintenance_in_previous_year": false,
					"grazed": false,
					"used_after_breaking": false,
					"any_fertilization": false,
				},
			},
			{
				"parcel_id": "P3",
				"area_ha": 20,
				"land_use": "arable",
				"schlagnutzungsart": "Winterweizen",
				"oepul_codes": [],
				"operations": {"psm_used": true},
			},
		],
		"agroforestry_strips": [{
			"strip_id": "AFS1",
			"area_ha": 0.3,
			"establishment_year": 2024,
			"planting_date": "2024-03-10",
			"schlagnutzungsart": "LSE Agroforststreifen",
			"adjacent_to_arable": true,
			"average_width_m": 5,
			"length_m": 600,
			"tree_count": 90,
			"max_tree_spacing_m": 10,
			"is_special_crop_gspav_25_4": false,
			"long_side_adjacent_to_forest_or_area_landscape_element": false,
			"species": [{"scientific_name": "Juglans regia", "count": 60}, {"scientific_name": "Sorbus domestica", "count": 30}],
			"trees_removed": false,
			"replanting_date": null,
			"care": {"stake_stabilization": true, "browsing_protection": true, "pruning_as_needed": true},
			"herbaceous_permanently_green": true,
			"herbaceous_use": "mulching",
			"fertilizer_used": false,
			"psm_used": false,
			"browsing_protection_agent_used": true,
			"browsing_protection_agent_bio_approved": true,
			"assigned_feldstueck_id": "FS1",
		}],
		"feldstuecke": [{"feldstueck_id": "FS1", "arable_area_ha": 8}],
	},
}

patched(ops) := json.patch(base, ops)

ids(inp) := {v.rule_id | some v in o6_1c.violations with input as inp}

# --- Grundfall -----------------------------------------------------------------------

test_base_case_has_no_violations if {
	count(o6_1c.violations) == 0 with input as base
}

test_base_case_contracts_valid if {
	o6_1c.contract_valid_for_category("npa") with input as base
	o6_1c.contract_valid_for_category("afs") with input as base
}

test_base_case_premium_bands if {
	est := o6_1c.premium_estimate with input as base
	est.npa.area_ha == 1.5
	est.npa.min_eur == 525
	est.npa.max_eur == 675
	est.afs.min_eur == 180
	est.afs.max_eur == 240
	est.modulation_factor == 1
	est.total_min_eur == 705
}

test_decision_object_defined if {
	d := o6_1c.decision with input as base
	d.contract_valid.npa == true
	d.included_in_area_payment_cap == false
	d.payment_deadline == "2027-06-30"
}

# --- Angebot, Antrag, Einstieg -------------------------------------------------------

test_not_offered_before_2025 if {
	inp := patched([{"op": "replace", "path": "/farm/year", "value": 2024}])
	not o6_1c.measure_offered_in_year with input as inp
	"O61C-CONTRACT-001" in ids(inp)
}

test_late_application_invalidates_contract if {
	inp := patched([{"op": "replace", "path": "/farm/oepul/measure_participations/0/application_date", "value": "2026-01-05"}])
	"O61C-APPL-001" in ids(inp)
	not o6_1c.contract_valid_for_category("npa") with input as inp
	o6_1c.contract_valid_for_category("afs") with input as inp
}

test_entry_2028_not_allowed if {
	inp := patched([
		{"op": "replace", "path": "/farm/year", "value": 2028},
		{"op": "replace", "path": "/farm/oepul/measure_participations/1/first_contract_year", "value": 2028},
		{"op": "replace", "path": "/farm/oepul/measure_participations/1/application_date", "value": "2027-12-01"},
	])
	"O61C-APPL-002" in ids(inp)
	not o6_1c.contract_valid_for_category("afs") with input as inp
}

test_application_deadline_is_31_december_of_previous_year if {
	o6_1c.application_deadline_for(2027) == "2026-12-31"
}

test_deregistration_in_year_invalidates if {
	inp := patched([{"op": "replace", "path": "/farm/oepul/measure_participations/0/deregistration_date", "value": "2026-07-01"}])
	"O61C-GEN-APPL-004" in ids(inp)
	not o6_1c.contract_valid_for_category("npa") with input as inp
}

test_deregistration_previous_year_requires_new_application if {
	inp := patched([{"op": "replace", "path": "/farm/oepul/measure_participations/0/deregistration_date", "value": "2025-12-15"}])
	"O61C-GEN-APPL-005" in ids(inp)
}

test_missing_mfa_blocks_continuation if {
	inp := patched([{"op": "replace", "path": "/farm/oepul/mfa_submitted", "value": false}])
	not o6_1c.contract_valid_for_category("npa") with input as inp
}

# --- Kombinationsausschluss UBB/BIO ---------------------------------------------------

test_ubb_blocks_npa_but_not_afs if {
	inp := patched([{"op": "add", "path": "/farm/oepul/measure_participations/-", "value": {"measure_code": "1A", "category": null, "option": null, "application_date": "2022-12-01", "first_contract_year": 2023, "deregistration_date": null}}])
	"O61C-APPL-003" in ids(inp)
	not o6_1c.contract_valid_for_category("npa") with input as inp
	o6_1c.contract_valid_for_category("afs") with input as inp
}

test_bio_partial_farm_wine_fruit_hop_does_not_block_npa if {
	inp := patched([{"op": "add", "path": "/farm/oepul/measure_participations/-", "value": {"measure_code": "1B", "category": null, "option": "teilbetrieb_wein_obst_hopfen", "application_date": "2022-12-01", "first_contract_year": 2023, "deregistration_date": null}}])
	not "O61C-APPL-003" in ids(inp)
	o6_1c.contract_valid_for_category("npa") with input as inp
}

test_full_bio_blocks_npa if {
	inp := patched([{"op": "add", "path": "/farm/oepul/measure_participations/-", "value": {"measure_code": "1B", "category": null, "option": null, "application_date": "2022-12-01", "first_contract_year": 2023, "deregistration_date": null}}])
	"O61C-APPL-003" in ids(inp)
}

# --- Förderwerbende, Mindestgröße -----------------------------------------------------

test_public_body_allowed_for_1c_from_2025 if {
	inp := patched([{"op": "replace", "path": "/farm/applicant/legal_form", "value": "public_body"}])
	o6_1c.applicant_eligible with input as inp
}

test_legal_person_public_share_irrelevant_for_1c if {
	inp := patched([
		{"op": "replace", "path": "/farm/applicant/legal_form", "value": "legal_person"},
		{"op": "replace", "path": "/farm/applicant/public_body_share_percent", "value": 60},
	])
	o6_1c.applicant_eligible with input as inp
}

test_inactive_farmer_not_eligible if {
	inp := patched([{"op": "replace", "path": "/farm/applicant/is_active_farmer", "value": false}])
	"O61C-GEN-APPL-010" in ids(inp)
	o6_1c.no_contract_due_to_access_conditions with input as inp
}

test_min_farm_size_first_year if {
	small := patched([
		{"op": "replace", "path": "/farm/oepul/first_participation_year", "value": 2026},
		{"op": "replace", "path": "/land/total_area_ha", "value": 1.2},
	])

	# 1,2 ha + 0,3 ha Agroforststreifen = 1,5 ha
	o6_1c.min_farm_size_met with input as small

	# 1,0 ha + 0,3 ha Agroforststreifen = 1,3 ha < 1,5 ha
	too_small := json.patch(small, [{"op": "replace", "path": "/land/total_area_ha", "value": 1.0}])
	not o6_1c.min_farm_size_met with input as too_small
	"O61C-GEN-APPL-011" in ids(too_small)
}

test_min_farm_size_not_required_after_first_year if {
	inp := patched([{"op": "replace", "path": "/land/total_area_ha", "value": 0.2}])
	o6_1c.min_farm_size_met with input as inp
}

# --- NPA-Verpflichtungen --------------------------------------------------------------

test_npa_late_sowing if {
	inp := patched([{"op": "replace", "path": "/land/parcels/0/npa/sowing_date", "value": "2026-05-16"}])
	"O61C-NPA-003" in ids(inp)
}

test_npa_autumn_sowing_previous_year_ok if {
	inp := patched([{"op": "replace", "path": "/land/parcels/0/npa/sowing_date", "value": "2025-10-01"}])
	not "O61C-NPA-003" in ids(inp)
}

test_npa_breaking_before_15_september if {
	inp := patched([{"op": "replace", "path": "/land/parcels/1/npa/breaking_date", "value": "2026-09-10"}])
	"O61C-NPA-004" in ids(inp)
}

test_npa_breaking_august_with_winter_crop_ok if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/1/npa/breaking_date", "value": "2026-08-01"},
		{"op": "replace", "path": "/land/parcels/1/npa/follow_up_crop", "value": "winter_crop"},
	])
	not "O61C-NPA-004" in ids(inp)
}

test_npa_breaking_july_with_catch_crop_violation if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/1/npa/breaking_date", "value": "2026-07-31"},
		{"op": "replace", "path": "/land/parcels/1/npa/follow_up_crop", "value": "catch_crop"},
	])
	"O61C-NPA-004" in ids(inp)
}

test_npa_use_after_breaking if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/1/npa/breaking_date", "value": "2026-09-20"},
		{"op": "replace", "path": "/land/parcels/1/npa/used_after_breaking", "value": true},
	])
	"O61C-NPA-005" in ids(inp)
}

test_npa_psm_only_bio_allowed if {
	bio := patched([
		{"op": "replace", "path": "/land/parcels/1/operations/psm_used", "value": true},
		{"op": "add", "path": "/land/parcels/1/npa/psm_only_bio_active_substances", "value": true},
	])
	not "O61C-NPA-006" in ids(bio)
	conv := json.patch(bio, [{"op": "replace", "path": "/land/parcels/1/npa/psm_only_bio_active_substances", "value": false}])
	"O61C-NPA-006" in ids(conv)
}

test_npa_fertilization_forbidden if {
	inp := patched([{"op": "replace", "path": "/land/parcels/0/operations/fertilizer/organic_n_kg_per_ha", "value": 20}])
	"O61C-NPA-007" in ids(inp)
}

test_npa_chemical_removal_forbidden if {
	inp := patched([{"op": "replace", "path": "/land/parcels/0/npa/removal_method", "value": "chemical"}])
	"O61C-NPA-008" in ids(inp)
	ok := patched([{"op": "replace", "path": "/land/parcels/0/npa/removal_method", "value": "incorporation"}])
	not "O61C-NPA-008" in ids(ok)
}

test_npa_max_two_cuts_cleaning_cut_not_counted if {
	two_plus_cleaning := patched([{"op": "add", "path": "/land/parcels/0/npa/maintenance_events/-", "value": {"date": "2026-09-01", "type": "maintenance_mowing"}}])
	not "O61C-NPA-009" in ids(two_plus_cleaning)
	three := json.patch(two_plus_cleaning, [{"op": "add", "path": "/land/parcels/0/npa/maintenance_events/-", "value": {"date": "2026-10-01", "type": "mulching"}}])
	"O61C-NPA-009" in ids(three)
}

test_npa_min_every_second_year if {
	inp := patched([{"op": "replace", "path": "/land/parcels/1/npa/maintenance_events", "value": []}])
	"O61C-NPA-010" in ids(inp)
	ok := json.patch(inp, [{"op": "replace", "path": "/land/parcels/1/npa/maintenance_in_previous_year", "value": true}])
	not "O61C-NPA-010" in ids(ok)
}

test_npa_cleaning_cut_on_existing_fallow_not_allowed if {
	inp := patched([{"op": "add", "path": "/land/parcels/1/npa/maintenance_events/-", "value": {"date": "2026-05-20", "type": "cleaning_cut"}}])
	"O61C-NPA-011" in ids(inp)
}

test_npa_cleaning_cut_after_resowing_existing_fallow_allowed if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/1/npa/first_npa_declaration_year", "value": 2026},
		{"op": "add", "path": "/land/parcels/1/npa/resown_after_breaking_existing_fallow", "value": true},
		{"op": "add", "path": "/land/parcels/1/npa/maintenance_events/-", "value": {"date": "2026-05-20", "type": "cleaning_cut"}},
	])
	not "O61C-NPA-011" in ids(inp)
}

test_npa_fifty_percent_early_cut_limit if {
	# P1 (1 ha) wird am 20.06. gehäckselt = 66,7 % der NPA-Fläche vor dem 1. August.
	inp := patched([{"op": "replace", "path": "/land/parcels/0/npa/maintenance_events/1/date", "value": "2026-06-20"}])
	o6_1c.npa_early_cut_area_ha == 1 with input as inp
	o6_1c.npa_early_cut_share_exceeded with input as inp
	"O61C-NPA-012" in ids(inp)
}

test_npa_fifty_percent_limit_respected if {
	# P2 (0,5 ha) wird am 20.06. gemäht = 33,3 %; der gültige Reinigungsschnitt auf P1 zählt nicht.
	inp := patched([{"op": "replace", "path": "/land/parcels/1/npa/maintenance_events/0/date", "value": "2026-06-20"}])
	o6_1c.npa_early_cut_area_ha == 0.5 with input as inp
	not o6_1c.npa_early_cut_share_exceeded with input as inp
	not "O61C-NPA-012" in ids(inp)
}

test_npa_biomass_removal_and_grazing_forbidden if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/1/npa/maintenance_events/0/biomass_removed", "value": true},
		{"op": "replace", "path": "/land/parcels/1/npa/grazed", "value": true},
	])
	"O61C-NPA-013" in ids(inp)
	"O61C-NPA-014" in ids(inp)
}

test_npa_code_and_schlagnutzungsart_required if {
	inp := patched([{"op": "replace", "path": "/land/parcels/1/schlagnutzungsart", "value": "Winterweizen"}])
	"O61C-APPL-004" in ids(inp)
	est := o6_1c.premium_estimate with input as inp
	est.npa.area_ha == 1
}

test_npa_not_combinable_with_other_measure if {
	inp := patched([{"op": "add", "path": "/land/parcels/1/oepul_status", "value": {"other_measure_premium_codes": ["6"]}}])
	"O61C-PREM-004" in ids(inp)
}

# --- NPA-Prämie ------------------------------------------------------------------------

test_npa_cap_four_percent_of_arable if {
	inp := patched([{"op": "replace", "path": "/land/parcels/0/area_ha", "value": 3}])
	o6_1c.npa_area_cap_ha == 2 with input as inp
	est := o6_1c.premium_estimate with input as inp
	est.npa.area_ha == 2
	est.npa.min_eur == 700
	est.npa.max_eur == 900
}

test_npa_gloez4_part_not_eligible if {
	inp := patched([{"op": "replace", "path": "/land/parcels/0/constraints/gloez4_buffer_area_ha", "value": 0.4}])
	est := o6_1c.premium_estimate with input as inp
	est.npa.area_ha == 1.1
}

test_npa_premium_zero_when_ubb_participant if {
	inp := patched([{"op": "add", "path": "/farm/oepul/measure_participations/-", "value": {"measure_code": "1A", "application_date": "2022-12-01", "first_contract_year": 2023}}])
	est := o6_1c.premium_estimate with input as inp
	est.npa.area_ha == 0
	est.afs.area_ha == 0.3
}

test_op_code_parcel_gets_no_premium if {
	inp := patched([{"op": "replace", "path": "/land/parcels/0/oepul_codes", "value": ["NPA", "OP"]}])
	est := o6_1c.premium_estimate with input as inp
	est.npa.area_ha == 0.5
}

test_op_code_required_if_overlapping_public_funding if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/oepul_status", "value": {"overlapping_public_funding": true}}])
	"O61C-GEN-ELIG-004" in ids(inp)
	est := o6_1c.premium_estimate with input as inp
	est.npa.area_ha == 0.5
}

test_national_park_neusiedlersee_no_premium if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/oepul_status", "value": {"national_park": "Neusiedlersee"}}])
	est := o6_1c.premium_estimate with input as inp
	est.npa.area_ha == 0.5
	other := patched([{"op": "add", "path": "/land/parcels/0/oepul_status", "value": {"national_park": "Thayatal"}}])
	est2 := o6_1c.premium_estimate with input as other
	est2.npa.area_ha == 1.5
}

test_area_outside_austria_no_premium if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/oepul_status", "value": {"in_austria": false}}])
	est := o6_1c.premium_estimate with input as inp
	est.npa.area_ha == 0.5
}

test_small_payout_may_be_waived if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/0/area_ha", "value": 0.05},
		{"op": "replace", "path": "/land/parcels/1/area_ha", "value": 0.05},
		{"op": "replace", "path": "/land/agroforestry_strips", "value": []},
	])
	o6_1c.payment_may_be_waived with input as inp
	not o6_1c.payment_may_be_waived with input as base
}

# --- Agroforststreifen ------------------------------------------------------------------

test_afs_width_out_of_range if {
	inp := patched([{"op": "replace", "path": "/land/agroforestry_strips/0/average_width_m", "value": 12}])
	"O61C-DEF-AFS-003" in ids(inp)
	est := o6_1c.premium_estimate with input as inp
	est.afs.area_ha == 0
}

test_afs_density_bounds if {
	o6_1c.trees_per_100_m({"tree_count": 90, "length_m": 600}) == 15
	low := patched([{"op": "replace", "path": "/land/agroforestry_strips/0/tree_count", "value": 50}])
	"O61C-DEF-AFS-004" in ids(low)
	high := patched([{"op": "replace", "path": "/land/agroforestry_strips/0/tree_count", "value": 160}])
	"O61C-DEF-AFS-004" in ids(high)
}

test_afs_spacing_and_establishment_year if {
	inp := patched([
		{"op": "replace", "path": "/land/agroforestry_strips/0/max_tree_spacing_m", "value": 16},
		{"op": "replace", "path": "/land/agroforestry_strips/0/establishment_year", "value": 2019},
	])
	"O61C-DEF-AFS-005" in ids(inp)
	"O61C-DEF-AFS-002" in ids(inp)
}

test_afs_negative_list_species_and_genus if {
	o6_1c.on_negative_list("Robinia pseudoacacia")
	o6_1c.on_negative_list("Elaeagnus angustifolia")
	not o6_1c.on_negative_list("Juglans regia")
	inp := patched([{"op": "add", "path": "/land/agroforestry_strips/0/species/-", "value": {"scientific_name": "Ailanthus altissima", "count": 1}}])
	"O61C-DEF-AFS-007" in ids(inp)
}

test_afs_adjacency_and_special_crop if {
	inp := patched([
		{"op": "replace", "path": "/land/agroforestry_strips/0/adjacent_to_arable", "value": false},
		{"op": "replace", "path": "/land/agroforestry_strips/0/long_side_adjacent_to_forest_or_area_landscape_element", "value": true},
		{"op": "replace", "path": "/land/agroforestry_strips/0/is_special_crop_gspav_25_4", "value": true},
	])
	"O61C-DEF-AFS-001" in ids(inp)
	"O61C-DEF-AFS-006" in ids(inp)
	"O61C-DEF-AFS-008" in ids(inp)
}

test_afs_new_planting_after_15_may if {
	inp := patched([
		{"op": "replace", "path": "/land/agroforestry_strips/0/establishment_year", "value": 2026},
		{"op": "replace", "path": "/land/agroforestry_strips/0/planting_date", "value": "2026-05-20"},
	])
	"O61C-AFS-001" in ids(inp)
}

test_afs_replanting_deadline if {
	inp := patched([
		{"op": "replace", "path": "/land/agroforestry_strips/0/trees_removed", "value": true},
		{"op": "replace", "path": "/land/agroforestry_strips/0/replanting_date", "value": "2026-06-01"},
	])
	"O61C-AFS-002" in ids(inp)
	ok := patched([{"op": "replace", "path": "/land/agroforestry_strips/0/trees_removed", "value": true}])
	not "O61C-AFS-002" in ids(ok)
}

test_afs_care_and_herbaceous_rules if {
	inp := patched([
		{"op": "replace", "path": "/land/agroforestry_strips/0/care/browsing_protection", "value": false},
		{"op": "replace", "path": "/land/agroforestry_strips/0/herbaceous_permanently_green", "value": false},
		{"op": "replace", "path": "/land/agroforestry_strips/0/herbaceous_use", "value": "grazing"},
	])
	"O61C-AFS-003" in ids(inp)
	"O61C-AFS-004" in ids(inp)
	"O61C-AFS-005" in ids(inp)
}

test_afs_inputs_forbidden if {
	inp := patched([
		{"op": "replace", "path": "/land/agroforestry_strips/0/fertilizer_used", "value": true},
		{"op": "replace", "path": "/land/agroforestry_strips/0/browsing_protection_agent_bio_approved", "value": false},
	])
	"O61C-AFS-006" in ids(inp)
	not o6_1c.afs_all_strips_compliant with input as inp
	o6_1c.afs_all_strips_compliant with input as base
}

test_afs_schlagnutzungsart_required if {
	inp := patched([{"op": "replace", "path": "/land/agroforestry_strips/0/schlagnutzungsart", "value": "Hecke"}])
	"O61C-APPL-005" in ids(inp)
}

test_afs_credit_toward_15a_for_ubb if {
	inp := patched([
		{"op": "add", "path": "/farm/oepul/measure_participations/-", "value": {"measure_code": "1A", "application_date": "2022-12-01", "first_contract_year": 2023}},
		{"op": "replace", "path": "/land/feldstuecke/0/arable_area_ha", "value": 6},
	])
	credit := o6_1c.afs_credit_15a_by_feldstueck with input as inp
	credit.FS1 == 0.3
	o6_1c.afs_counts_toward_7_percent == false
	no_ubb := o6_1c.afs_credit_15a_by_feldstueck with input as base
	count(no_ubb) == 0
}

# --- Kombination, Modulation, Obergrenze, Sanktionen, allgemeine Regeln ------------------

test_anhang_l_1c_not_combinable if {
	count(o6_1c.combinable_measures_1c) == 0
	not o6_1c.combinable_on_single_area("1C", "1A")
	o6_1c.combinable_on_single_area("1A", "2")
	o6_1c.combinable_on_single_area("2", "1A")
	not o6_1c.combinable_on_single_area("1A", "1B")
}

test_modulation_example_220_ha if {
	f := o6_1c.modulation_factor(220)
	f > 0.9909
	f < 0.9910
	o6_1c.modulation_factor(150) == 1
	o6_1c.modulated_amount_ha(1200) == ((200 + 90) + 595) + 150
}

test_area_payment_cap_excludes_1c_from_2025 if {
	not o6_1c.included_in_area_payment_cap with input as base
	inp := patched([{"op": "replace", "path": "/farm/year", "value": 2024}])
	o6_1c.included_in_area_payment_cap with input as inp
}

test_sanction_warning_becomes_retention_2027 if {
	o6_1c.sanction_share("warning") == 0 with input as base
	o6_1c.sanction_share("reduction_25") == 0.25 with input as base
	inp := patched([{"op": "replace", "path": "/farm/year", "value": 2027}])
	o6_1c.sanction_share("warning") == 0.01 with input as inp
}

test_exclusion_after_two_full_reductions if {
	inp := patched([{"op": "add", "path": "/farm/oepul/full_reductions_in_contract_period", "value": 2}])
	o6_1c.excluded_from_measure with input as inp
	not o6_1c.excluded_from_measure with input as base
}

test_reduction_order if {
	o6_1c.reduction_order[0] == "over_declaration_area"
	o6_1c.reduction_order[6] == "modulation"
	count(o6_1c.reduction_order) == 11
}

test_one_year_measure_and_no_conversion if {
	o6_1c.is_one_year_measure
	not o6_1c.measure_conversion_possible
	not o6_1c.area_increase_restricted
	not o6_1c.takeover_individual_case_only
	o6_1c.conversion_to_afs_is_allowed_reduction
}

test_takeover_deadlines if {
	o6_1c.takeover_deadline(2026) == "2026-04-15"
	o6_1c.takeover_deadline(2028) == "2028-04-17"
	inp := patched([{"op": "add", "path": "/farm/oepul/takeovers", "value": [{"measure_code": "1C", "date": "2026-05-01", "taken_over_area_ha": 1, "extension_to_other_area_ha": 0.8}]}])
	"O61C-GEN-TAKE-001" in ids(inp)
}

test_area_reduction_tolerance if {
	o6_1c.area_reduction_tolerance_ha(4) == 0.5
	o6_1c.area_reduction_tolerance_ha(40) == 2
	o6_1c.area_reduction_tolerance_ha(200) == 5
}

test_control_refusal_rejects_application if {
	inp := patched([{"op": "add", "path": "/farm/oepul/onsite_control_refused", "value": true}])
	o6_1c.application_rejected_control_refused with input as inp
}

test_exit_blocked_after_control_announcement if {
	inp := patched([{"op": "add", "path": "/farm/oepul/onsite_control_announced_date", "value": "2026-06-01"}])
	o6_1c.exit_possible("2026-05-31") with input as inp
	not o6_1c.exit_possible("2026-06-02") with input as inp
}

test_permanent_circumstance_premium_rule if {
	o6_1c.premium_possible_in_year_of_permanent_circumstance("2026-05-01", false) with input as base
	not o6_1c.premium_possible_in_year_of_permanent_circumstance("2026-03-01", false) with input as base
	o6_1c.premium_possible_in_year_of_permanent_circumstance("2026-03-01", true) with input as base
	o6_1c.premium_possible_in_year_of_temporary_circumstance(false, true)
	not o6_1c.premium_possible_in_year_of_temporary_circumstance(false, false)
}

test_min_management_exemption_and_self_greening if {
	o6_1c.exempt_from_min_management
	o6_1c.self_greening_allowed_for_npa
}

test_crop_group_definitions if {
	"cereal" in o6_1c.crop_groups("Dinkel") with input as base
	o6_1c.is_not_cereal("Hirse")
	"field_vegetable" in o6_1c.crop_groups("Zuckermais") with input as base
	"fruit" in o6_1c.crop_groups("Papau") with input as base
	inp := patched([{"op": "replace", "path": "/farm/year", "value": 2024}])
	not "fruit" in o6_1c.crop_groups("Papau") with input as inp
	not o6_1c.cereal_mixture_is_cereal(0.4)
}

# --- 2026-Hinweise --------------------------------------------------------------------

test_drought_2026_districts if {
	o6_1c.farm_in_drought_2026_relief_area with input as base
	o6_1c.drought_2026_harvest_relief_district("Burgenland", "Oberwart") with input as base
	o6_1c.drought_2026_harvest_relief_district("Steiermark", "Leibnitz") with input as base
	not o6_1c.drought_2026_harvest_relief_district("Steiermark", "Liezen") with input as base
	inp := patched([{"op": "replace", "path": "/farm/year", "value": 2025}])
	not o6_1c.farm_in_drought_2026_relief_area with input as inp
}

test_biodiversity_relief_not_for_npa if {
	not o6_1c.biodiversity_relief_2026_applies_to_npa
	o6_1c.npa_creditable_to_other_obligations == false
	contains(o6_1c.force_majeure_channel, "Eingaben")
}

# --- Robustheit: unverändertes Profil ohne 1C-Erweiterungen -----------------------------

test_decision_defined_for_minimal_profile if {
	minimal := {"farm": {"year": 2026}, "land": {"total_area_ha": 30, "arable_area_ha": 25, "parcels": [{"parcel_id": "X", "area_ha": 25, "land_use": "arable"}]}}
	d := o6_1c.decision with input as minimal
	d.contract_valid.npa == false
	d.contract_valid.afs == false
	d.premium_estimate.total_min_eur == 0
	count(d.violations) == 0
}

test_1c_not_multi_year_and_options_until_2028 if {
	not o6_1c.is_multi_year_measure
	not o6_1c.is_annually_variable_area_measure
	o6_1c.one_year_options_until_year == 2028
}
