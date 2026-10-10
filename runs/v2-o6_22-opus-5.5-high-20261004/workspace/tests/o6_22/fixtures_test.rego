package oepul.o6_22_test

# Konformer Referenzbetrieb (Antragsjahr 2025) mit allen drei Kategorien und
# allen drei Zuschlägen.
base_input := {
	"farm": {
		"year": 2025,
		"first_oepul_participation_year": 2023,
		"applicant": {
			"type": "natural_person",
			"is_active_farmer": true,
			"public_authority_share_percent": 0,
		},
		"mfa": {
			"tierliste_submitted_on": "2025-04-10",
			"uses_average_animal_list": true,
			"stock_fluctuates": true,
			"average_list_corrections": [],
		},
		"oepul_measures": {"o6_22": {
			"applications": [
				{"code": "ferkel", "applied_on": "2022-12-01", "first_year": 2023, "withdrawn_on": null},
				{"code": "mastschweine", "applied_on": "2024-12-10", "first_year": 2025, "withdrawn_on": null},
				{"code": "zuchtsauen", "applied_on": "2023-11-20", "first_year": 2024, "withdrawn_on": null},
				{"code": "unkupiert_mastschweine", "applied_on": "2024-12-10", "first_year": 2025, "withdrawn_on": null},
				{"code": "gvo_frei", "applied_on": "2023-11-20", "first_year": 2024, "withdrawn_on": null},
				{"code": "festmistkompostierung", "applied_on": "2024-11-30", "first_year": 2025, "withdrawn_on": null},
			],
			"takeover": {"is_takeover": false},
		}},
	},
	"land": {
		"total_area_ha": 50,
		"parcels": [{
			"parcel_id": "P1",
			"area_ha": 50,
			"land_use": "arable",
			"pig_free_range_run": false,
			"mfa_land_use_type": "Ackerland",
		}],
	},
	"livestock": {
		"has_livestock": true,
		"pig_farm": {
			"animal_health_service": {
				"participates": true,
				"participation_from": "2025-01-01",
				"participation_to": "2025-12-31",
			},
			"vis_reports_complete": true,
			"documentation": {"stall_sketch_and_occupancy_plan": false},
			"protein_feed": {
				"non_compliant_protein_feed_stored_or_fed": false,
				"feeds": [
					{
						"name": "Sojaextraktionsschrot Donau",
						"type": "single_component",
						"typical_crude_protein_percent_dm": 48,
						"is_roughage": false,
						"gmo_free": true,
						"origin_continent": "europe",
						"produced_on_farm": false,
						"proof_documents_available": true,
					},
					{
						"name": "Luzernecobs",
						"type": "single_component",
						"typical_crude_protein_percent_dm": 21,
						"is_roughage": true,
						"gmo_free": false,
						"origin_continent": "other",
						"produced_on_farm": false,
						"proof_documents_available": false,
					},
				],
			},
			"manure_composting": {
				"all_solid_manure_composted_on_farm": true,
				"is_compost_barn": false,
				"records_complete": true,
				"heaps_on_unpaved_ground": false,
				"heaps": [{
					"heap_id": "M1",
					"turn_dates": ["2025-05-01", "2025-05-20"],
					"turning_device": "compost_turner",
					"device_on_farm_or_use_documented": true,
					"heap_fully_turned": true,
					"mixed_with_plant_material": false,
				}],
			},
		},
		"species_groups": [
			{
				"group_id": "mast",
				"species": "pigs",
				"pig_tierliste_category": "mastschweine_80_110",
				"animal_count": 100,
				"average_animal_count": 100,
				"deregistered_average_count": 0,
				"housing": {
					"housing_type": "stall",
					"stall": {
						"structure": {
							"open_stall_system": false,
							"three_sided_enclosure_or_windbreak": true,
							"lying_area_roofed": true,
							"paved_floor": true,
							"liquid_manure_collectable": true,
							"space_for_all_animals": true,
						},
						"pens": [{
							"pen_id": "A1",
							"animal_count": 25,
							"average_weight_kg": 95,
							"usable_total_area_m2": 27.5,
							"littered_lying_area_m2": 11,
							"lying_area_perforation_percent": 0,
							"lying_area_littered_and_dry": true,
							"bedding_material": "stroh_getreide",
							"minimal_bedding": false,
							"group_housed": true,
						}],
					},
				},
				"pig_welfare": {
					"kept_in_austria": true,
					"participating_animals_all_undocked_full_year": true,
					"continuous_compliance_from_eligible_weight": true,
					"non_compliant_average_count": 0,
					"single_housing_events": [],
				},
			},
			{
				"group_id": "ferkel",
				"species": "pigs",
				"pig_tierliste_category": "ferkel_8_20",
				"animal_count": 200,
				"average_animal_count": 200,
				"deregistered_average_count": 0,
				"housing": {
					"housing_type": "stall",
					"stall": {
						"structure": {
							"open_stall_system": false,
							"three_sided_enclosure_or_windbreak": true,
							"lying_area_roofed": true,
							"paved_floor": true,
							"liquid_manure_collectable": true,
						},
						"pens": [{
							"pen_id": "F1",
							"animal_count": 200,
							"average_weight_kg": 15,
							"usable_total_area_m2": 60,
							"littered_lying_area_m2": 24,
							"lying_area_perforation_percent": 3,
							"lying_area_littered_and_dry": true,
							"bedding_material": "saegespaene",
							"enrichment_permanently_available": true,
							"enrichment_material": "stroh",
							"group_housed": true,
						}],
					},
				},
				"pig_welfare": {
					"kept_in_austria": true,
					"continuous_compliance_from_eligible_weight": true,
				},
			},
			{
				"group_id": "sauen",
				"species": "pigs",
				"pig_tierliste_category": "aeltere_sauen_gedeckt_ab_50",
				"animal_count": 20,
				"average_animal_count": 20,
				"deregistered_average_count": 0,
				"housing": {
					"housing_type": "stall",
					"stall": {
						"structure": {
							"open_stall_system": true,
							"lying_area_roofed": true,
							"liquid_tight_paved": true,
							"seepage_to_collection_pit": true,
						},
						"pens": [
							{
								"pen_id": "S1",
								"sow_counts": {"zuchtsau": 20},
								"usable_total_area_m2": 60,
								"littered_lying_area_m2": 26,
								"lying_area_perforation_percent": 0,
								"lying_area_littered_and_dry": true,
								"bedding_material": "stroh_getreide",
								"group_housed": true,
							},
							{
								"pen_id": "ABF",
								"sow_counts": {"zuchtsau": 4},
								"usable_total_area_m2": 4,
								"littered_lying_area_m2": 0,
								"lying_area_perforation_percent": 40,
								"lying_area_littered_and_dry": false,
								"bedding_material": "none",
								"group_housed": false,
								"outside_group_housing_obligation": true,
							},
						],
					},
					"sow_group_housing": {
						"stall_built_or_rebuilt_since_2013": true,
						"sufficient_group_space_without_construction": true,
						"group_from_day_after_mating": 10,
						"group_until_days_before_farrowing": 5,
					},
				},
				"pig_welfare": {"kept_in_austria": true},
			},
		],
	},
}

patched(ops) := json.patch(base_input, ops)

violation_ids(inp) := {v.rule_id | some v in data.oepul.o6_22.violations with input as inp}

# Einzelne Schweinegruppe für Freilandtests (20 Mastschweine = 6 GVE).
free_range_group(fr) := {
	"group_id": "frei",
	"species": "pigs",
	"pig_tierliste_category": "mastschweine_50_80",
	"animal_count": 20,
	"average_animal_count": 20,
	"deregistered_average_count": 0,
	"housing": {"housing_type": "pasture", "free_range": fr},
	"pig_welfare": {"kept_in_austria": true, "participating_animals_all_undocked_full_year": true},
}

compliant_free_range := {
	"unpaved_area_ha": 1,
	"rotational_paddocks": true,
	"rotational_total_area_ha": 2,
	"water_permit_max_gve_per_ha": null,
	"continuous_use_months": 10,
	"double_fence_or_solid_enclosure": true,
	"feed_and_water_separated": true,
	"feed_and_water_paved_or_moved_regularly": true,
	"feeding_place_roofed": true,
	"shelter_roofed_three_sided_littered": true,
	"shelter_all_animals_lie_simultaneously": true,
	"records_complete": true,
}

with_free_range(fr) := patched([{"op": "add", "path": "/livestock/species_groups/-", "value": free_range_group(fr)}])
