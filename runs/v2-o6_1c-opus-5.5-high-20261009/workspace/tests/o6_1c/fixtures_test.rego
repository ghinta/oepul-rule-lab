package oepul.o6_1c_test

# Basis-Eingabe: konformer Betrieb mit zwei NPA-Schlägen und einem Agroforststreifen.
base_input := {
	"farm": {
		"year": 2026,
		"applicant": {
			"type": "natural_person",
			"is_active_farmer": true,
			"carries_out_agricultural_activity": true,
			"public_body_share_percent": 0,
		},
		"oepul": {
			"first_participation_year": 2023,
			"participating_measures": ["o6_6"],
			"bio_participation_type": null,
			"o6_1c": {
				"categories": ["npa", "agroforest"],
				"first_contract_year": 2026,
				"application_date": "2025-12-10",
				"deregistration_date": null,
				"multiple_application_submitted": true,
				"commitment_year_completed": true,
				"findings": [],
				"force_majeure_claims": [],
			},
		},
	},
	"land": {
		"total_area_ha": 50,
		"arable_area_ha": 40,
		"protected_cultivation_area_ha": 0,
		"field_pieces": [{"field_piece_id": "FS1", "arable_area_ha": 8}],
		"parcels": [
			{
				"parcel_id": "NPA1",
				"area_ha": 0.8,
				"land_use": "arable",
				"field_use_type": "Grünbrache",
				"oepul_codes": ["NPA"],
				"other_oepul_measures": [],
				"operations": {"psm_used": false, "fertilizer": {"mineral_n_kg_per_ha": 0, "organic_n_kg_per_ha": 0}},
				"o6_1c": {
					"category": "npa",
					"npa": {
						"establishment": "new_sowing",
						"existing_green_fallow_broken_and_resown": false,
						"sowing_date": "2026-04-20",
						"first_application_year": 2026,
						"psm_only_bio_permitted_substances": false,
						"fertilizer_applied": false,
						"breaking_date": null,
						"follow_crop": "none",
						"used_after_breaking": false,
						"removal_method": "none",
						"cutting_events": [
							{"date": "2026-06-10", "type": "cleaning_cut", "biomass_removed": false},
							{"date": "2026-08-15", "type": "mulching", "biomass_removed": false},
						],
						"cut_in_previous_year": false,
						"grazed": false,
						"gloez4_buffer_area_ha": 0,
						"credited_to_other_obligations": [],
					},
				},
			},
			{
				"parcel_id": "NPA2",
				"area_ha": 0.8,
				"land_use": "arable",
				"field_use_type": "Grünbrache",
				"oepul_codes": ["NPA"],
				"other_oepul_measures": [],
				"operations": {"psm_used": false, "fertilizer": {"mineral_n_kg_per_ha": 0, "organic_n_kg_per_ha": 0}},
				"o6_1c": {
					"category": "npa",
					"npa": {
						"establishment": "retained_existing",
						"existing_green_fallow_broken_and_resown": false,
						"sowing_date": null,
						"first_application_year": 2025,
						"psm_only_bio_permitted_substances": false,
						"fertilizer_applied": false,
						"breaking_date": null,
						"follow_crop": "none",
						"used_after_breaking": false,
						"removal_method": "none",
						"cutting_events": [{"date": "2026-06-20", "type": "care_mowing", "biomass_removed": false}],
						"cut_in_previous_year": true,
						"grazed": false,
						"gloez4_buffer_area_ha": 0,
						"credited_to_other_obligations": [],
					},
				},
			},
			{
				"parcel_id": "AFS1",
				"area_ha": 0.3,
				"land_use": "arable",
				"field_use_type": "LSE Agroforststreifen",
				"oepul_codes": [],
				"other_oepul_measures": [],
				"o6_1c": {
					"category": "agroforest",
					"agroforest": {
						"establishment": "retained_existing",
						"establishment_year": 2021,
						"planting_date": "2021-03-15",
						"directly_adjacent_to_arable": true,
						"average_width_m": 5,
						"length_m": 600,
						"tree_count": 90,
						"max_tree_spacing_m": 8,
						"woody_species": ["Juglans regia", "Prunus avium", "Corylus avellana"],
						"shrubs_between_trees": true,
						"is_special_crop_gsp_av_25_4": false,
						"long_side_adjacent_to_forest_or_areal_landscape_element": false,
						"on_or_adjacent_to_reference_area": true,
						"woody_plants_removed": false,
						"replanting_date": null,
						"care": {"staking": true, "browsing_protection": true, "pruning_as_needed": true},
						"herbaceous_area_permanently_green": true,
						"herbaceous_area_use": "care_mowing",
						"fertilizer_used": false,
						"psm_used": false,
						"browsing_protection_agent_used": false,
						"browsing_protection_agent_bio_approved": false,
						"assigned_field_piece_id": "FS1",
					},
				},
			},
		],
	},
}

patched(ops) := json.patch(base_input, ops)

replace(path, value) := patched([{"op": "replace", "path": path, "value": value}])

add_field(path, value) := patched([{"op": "add", "path": path, "value": value}])

has_rule(vs, rule_id) if {
	some v in vs
	v.rule_id == rule_id
}

has_parcel_rule(vs, rule_id, pid) if {
	some v in vs
	v.rule_id == rule_id
	v.parcel_id == pid
}

approx(a, b) if abs(a - b) < 0.0001
