package oepul.o6_16_test

# Basis-Fixture: Betrieb in Niederösterreich, Einstieg 2023, Antragsjahr 2026, 10 ha Ackerfläche in der Gebietskulisse
# (KG 20001 Absdorf gemäß Anhang G) und 3 ha außerhalb.
parcel_wheat := {
	"parcel_id": "P1",
	"area_ha": 6.0,
	"land_use": "arable",
	"kg_number": "20001",
	"n_reduction_zone": "eastern_lower_austria_incl_tullnerfeld",
	"codes": [],
	"crop": {"crop_category": "cereal", "crop_name": "Winterweizen"},
	"operations": {"tillage_type": "reduced", "psm_used": false, "harvested_share": 1, "psm_applications": [], "fertilizer_applications": []},
	"plot_records": {"complete": true, "max_delay_days": 5},
	"n_balance": {
		"following_crop_application_year": 2026,
		"previous_crop_n_saldo_kg_ha": 15,
		"following_crop_n_reduction_kg_ha": 0,
		"catch_crop_per_measure_6_or_7": true,
	},
}

parcel_maize := {
	"parcel_id": "P2",
	"area_ha": 4.0,
	"land_use": "arable",
	"kg_number": "20001",
	"n_reduction_zone": "eastern_lower_austria_incl_tullnerfeld",
	"codes": [],
	"crop": {"crop_category": "maize", "crop_name": "Mais"},
	"operations": {"tillage_type": "reduced", "psm_used": true, "harvested_share": 1, "psm_applications": [{"date": "2026-05-10", "product_type": "chemical_synthetic", "active_substances": ["Mesotrione"]}], "fertilizer_applications": []},
	"plot_records": {"complete": true, "max_delay_days": 3},
	"n_balance": {"following_crop_application_year": 2026},
}

parcel_outside := {
	"parcel_id": "P3",
	"area_ha": 3.0,
	"land_use": "arable",
	"kg_number": "99999",
	"codes": [],
	"crop": {"crop_category": "cereal", "crop_name": "Gerste"},
	"operations": {"tillage_type": "plough", "psm_used": false, "harvested_share": 1},
}

base_input := {
	"farm": {
		"farm_id": "F1",
		"year": 2026,
		"region": {"federal_state": "Niederösterreich", "district": "Tulln", "water_protection_zone": false},
		"applicant": {"legal_form": "natural_person", "is_public_body": false, "active_farmer": true},
		"oepul": {
			"first_oepul_participation_year": 2023,
			"participating_measures": ["1A", "6"],
			"o6_16": {
				"commitment_start_year": 2023,
				"measure_application_date": "2022-11-20",
			},
		},
	},
	"land": {
		"total_area_ha": 13.0,
		"arable_area_ha": 13.0,
		"parcels": [parcel_wheat, parcel_maize, parcel_outside],
	},
	"livestock": {"has_livestock": false, "species_groups": []},
	"documentation": {"o6_16": {
		"fertilization_plan_date": "2026-02-10",
		"fertilization_balance_date": "2027-01-20",
		"napv_fertilization_rules_complied": true,
		"plot_records_electronic": true,
		"water_protection_concept_date": "2026-03-01",
		"training": {"courses": [
			{"date": "2023-02-01", "hours": 6, "provider_recognized": true, "attendee_role": "farm_manager"},
			{"date": "2024-01-15", "hours": 4, "provider_recognized": true, "attendee_role": "farm_manager"},
		]},
		"soil_samples": [
			{"sample_id": "S1", "sample_date": "2024-11-17", "lab_submission_date": "2024-11-18", "accredited_lab": true, "parameters": ["N", "P", "K", "pH", "humus"], "n_parameter": "mineral_n", "method": "sgd", "entered_in_invekos_gis": true},
			{"sample_id": "S2", "sample_date": "2025-03-01", "lab_submission_date": "2025-03-02", "accredited_lab": true, "parameters": ["N", "P", "K", "pH", "humus"], "n_parameter": "mineralisable_n", "method": "euf", "entered_in_invekos_gis": true},
		],
	}},
}

with_parcels(ps) := object.union(base_input, {"land": {"parcels": ps}})

with_year(inp, y) := object.union(inp, {"farm": {"year": y}})

rule_ids(vs) := {v.rule_id | some v in vs}
