package oepul.o6_22_test

# Compliant reference farm for application year 2025: three measure categories,
# all three supplements, stall housing only.
stall_ok(area, lying) := {
	"stall_id": "S",
	"stall_area_m2": area,
	"lying_area_m2": lying,
	"floor_type": "part_slatted",
	"bedding_type": "straw",
	"daylight_percentage": null,
	"has_outdoor_area": false,
	"ventilation_type": "natural",
	"paved_outdoor_run_area_m2": null,
	"outdoor_run_permanently_accessible": null,
	"lying_area_perforation_percent": 0,
	"lying_area_dry": true,
	"litter_material": "straw",
	"minimal_litter": false,
	"enrichment_material": "straw",
	"enclosed_sides": 4,
	"lying_area_roofed": true,
	"floor_paved": true,
	"liquid_manure_container": true,
	"is_open_stall": false,
	"floor_liquid_tight": null,
	"seepage_drain_to_pit": null,
}

welfare_ok := {
	"group_housing": true,
	"single_housing": {"reason": null, "max_days": null, "littered": null, "documented": null},
	"compliant_throughout_holding_period": true,
	"sow_phase": null,
}

pig_group(cat, n, weight, area, lying) := {
	"species": "pigs",
	"category": cat,
	"tierliste_category": cat,
	"animal_count": n,
	"average_animal_count": n,
	"average_live_weight_kg": weight,
	"gve": null,
	"kept_in_austria": true,
	"is_wild_boar": false,
	"tail_docked": false,
	"housing": {"housing_type": "stall", "stall": stall_ok(area, lying), "pasture": null},
	"pig_welfare": welfare_ok,
}

base_input := {
	"farm": {
		"farm_id": "AT-TEST",
		"year": 2025,
		"applicant": {
			"legal_form": "natural_person",
			"is_public_body": false,
			"public_body_share_percent": 0,
			"is_active_farmer": true,
			"carries_out_agricultural_activity": true,
			"farm_managed_in_own_name_and_account": true,
		},
		"oepul": {"first_participation_year": 2023, "control_refused": false},
	},
	"land": {"total_area_ha": 50, "protected_cultivation_area_ha": 0},
	"livestock": {
		"has_livestock": true,
		"average_animal_list_submitted": true,
		"species_groups": [
			pig_group("mastschweine_50_80", 100, 70, 100, 40),
			pig_group("ferkel_8_20", 200, 15, 70, 25),
			pig_group("aeltere_sauen_gedeckt_ab_50", 20, null, 65, 27),
		],
	},
	"oepul_application": {"o6_22": {
		"category_applications": [
			{"measure_category": "jung_mastschweine", "applied_on": "2022-12-15", "first_commitment_year": 2023},
			{"measure_category": "ferkel", "applied_on": "2022-12-15", "first_commitment_year": 2023},
			{"measure_category": "zuchtsauen", "applied_on": "2022-12-15", "first_commitment_year": 2023},
		],
		"supplement_applications": [
			{"supplement": "unkupiert", "measure_category": "jung_mastschweine", "applied_on": "2022-12-15", "first_commitment_year": 2023},
			{"supplement": "gvo_frei_eiweiss", "measure_category": null, "applied_on": "2023-12-01", "first_commitment_year": 2024},
			{"supplement": "festmistkompostierung", "measure_category": null, "applied_on": "2024-12-01", "first_commitment_year": 2025},
		],
		"withdrawals": [],
		"deregistrations": [],
		"animal_health_service": {"participating": true, "from": "2020-01-01", "to": "2030-12-31", "proof_available": true},
		"stall_sketch_and_occupancy_plan_available": null,
		"vis_reporting_complete": true,
		"gvo_free_protein_feed": {
			"all_protein_feed_gvo_free_european": true,
			"non_compliant_protein_feed_stored_or_fed": false,
			"purchase_proofs_available": true,
		},
		"solid_manure_composting": {
			"all_solid_manure_composted_on_farm": true,
			"windrows": [{
				"windrow_id": "M1",
				"method": "turned",
				"turn_dates": ["2025-05-01", "2025-05-20"],
				"turning_equipment": "compost_turner",
				"complete_turning": true,
				"equipment_owned_or_use_documented": true,
				"plant_material_share_percent": null,
				"composting_process_applied": null,
				"straw_rich_manure_only": false,
			}],
			"documentation_complete": true,
			"nitrate_action_programme_compliant": true,
			"compost_stall_system": false,
		},
		"takeover": {"is_takeover": false, "reason": null, "animals_and_areas_from_same_previous_farm": null},
	}},
}

patched(ops) := json.patch(base_input, ops)

rule_ids(v) := {x.rule_id | some x in v}

issue_reasons(issues) := {x.reason | some x in issues}
