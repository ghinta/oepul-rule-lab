# Gemeinsame Test-Fixtures für o6_16 (Betrieb in Niederösterreich, Tullnerfeld, Antragsjahr 2026)
package oepul.o6_16_test

maize_parcel := {
	"parcel_id": "P1",
	"area_ha": 12,
	"land_use": "arable",
	"cadastral_community_number": "20123",
	"n_reduction_zone": "oestliches_niederoesterreich_inkl_tullnerfeld",
	"crop": {"crop_category": "maize", "crop_name": "Körnermais"},
	"previous_crop": {"crop_category": "cereal", "crop_name": "Winterweizen", "harvest_date": "2025-07-15", "n_saldo_kg_ha": 30},
	"n_management": {"follow_crop_n_requirement_kg_ha": 160, "follow_crop_n_fertilization_kg_ha": 136, "reduction_factor_applications": 1, "offtake_basis": "n_requirement"},
	"operations": {
		"tillage_type": "reduced",
		"cover_crop": {"is_used": false, "sowing_date": null},
		"psm_used": false,
		"fertilizer": {"mineral_n_kg_per_ha": 100, "organic_n_kg_per_ha": 36},
		"cutting_dates": [],
		"psm_applications": [],
		"fertilizer_applications": [],
	},
	"oepul": {"codes": [], "usage_type": "Körnermais", "o6_8_practices": [], "in_protection_or_conservation_zone": false},
	"harvest": {"harvested_share": 1.0},
}

wheat_parcel := {
	"parcel_id": "P2",
	"area_ha": 8,
	"land_use": "arable",
	"cadastral_community_number": "20147",
	"n_reduction_zone": "oestliches_niederoesterreich_inkl_tullnerfeld",
	"crop": {"crop_category": "cereal", "crop_name": "Winterweizen"},
	"previous_crop": {"crop_category": "oilseed", "crop_name": "Winterraps", "harvest_date": "2025-07-05", "n_saldo_kg_ha": 10},
	"operations": {
		"tillage_type": "plough",
		"cover_crop": {"is_used": true, "sowing_date": "2025-08-01"},
		"psm_used": false,
		"fertilizer": {"mineral_n_kg_per_ha": 120, "organic_n_kg_per_ha": 0},
		"cutting_dates": [],
	},
	"oepul": {"codes": [], "usage_type": "Winterweizen"},
	"harvest": {"harvested_share": 1.0},
}

outside_parcel := {
	"parcel_id": "P3",
	"area_ha": 2,
	"land_use": "arable",
	"cadastral_community_number": "99999",
	"crop": {"crop_category": "cereal", "crop_name": "Wintergerste"},
	"operations": {"tillage_type": "plough", "cover_crop": {"is_used": false, "sowing_date": null}, "psm_used": true, "cutting_dates": []},
	"oepul": {"codes": []},
}

soil_sample(id) := {
	"sample_id": id,
	"sampling_date": "2024-09-10",
	"lab_submission_date": "2024-09-12",
	"lab_accredited": true,
	"parameters": ["N", "P", "K", "pH", "humus"],
	"n_method": "mineralischer_stickstoff",
	"analysis_method": "richtlinien_sachgerechte_duengung",
	"entered_in_invekos_gis": true,
	"area": "gebiet",
}

base_input := {
	"farm": {
		"farm_id": "AT-TEST-1",
		"year": 2026,
		"region": {"federal_state": "Niederösterreich", "district": "Tulln"},
		"applicant": {"legal_form": "natuerliche_person", "public_body_share_percent": 0},
		"oepul": {
			"first_oepul_participation_year": 2023,
			"participating_measures": ["o6_16", "o6_6", "o6_1a"],
			"o6_16": {
				"contract_start_year": 2023,
				"measure_application_date": "2022-11-20",
				"premium_area_2025_ha": 20,
				"premium_area_previous_year_ha": 20,
				"farm_records": {"fertilization_plan_date": "2026-02-10", "farm_balance_completed_date": null, "napv_compliant": true},
				"field_records": {"electronic": true, "max_completion_delay_days": 7, "content_complete": true},
				"training_courses": [{"course_id": "K1", "date": "2024-01-15", "hours": 10, "topics": ["grundwasserschutz"], "provider_recognized": true}],
				"water_protection_concept_date": "2025-03-01",
				"soil_samples": [soil_sample("S1"), soil_sample("S2"), soil_sample("S3"), soil_sample("S4")],
			},
		},
	},
	"land": {
		"total_area_ha": 25,
		"arable_area_ha": 22,
		"parcels": [maize_parcel, wheat_parcel, outside_parcel],
	},
	"livestock": {"has_livestock": false, "species_groups": []},
	"documentation": {"nutrient_balance_complete": true, "field_records_complete": true},
}

# Hilfsfunktion: Profil mit geänderten Feldern der o6_16-Teilnahme
with_o16(patch) := object.union(base_input, {"farm": {"oepul": {"o6_16": patch}}})

with_parcels(ps) := object.union(base_input, {"land": {"parcels": ps}})

with_year(inp, yr) := object.union(inp, {"farm": {"year": yr}})

rule_ids(vs) := {v.rule_id | some v in vs}

approx(a, b) if abs(a - b) < 0.0001
