package oepul.o6_24_test

import rego.v1

# Basisbetrieb im Leibnitzer Feld (Gebietskulisse GWSP Graz bis Bad Radkersburg 2018).
base_input := {
	"farm": {
		"farm_id": "AT-TEST-1",
		"year": 2026,
		"region": {"federal_state": "Steiermark", "district": "Leibnitz", "municipality": "Wagna"},
		"applicant": {"legal_form": "natural_person", "is_active_farmer": true},
		"oepul": {
			"first_participation_year": 2023,
			"o6_24": {
				"measure_application_submitted": true,
				"measure_application_date": "2022-12-15",
				"contract_start_year": 2023,
				"multiple_application_submitted": true,
			},
		},
	},
	"land": {
		"total_area_ha": 3.8,
		"parcels": [
			{
				"parcel_id": "P1",
				"area_ha": 1.0,
				"land_use": "arable",
				"crop": {"crop_category": "cereal", "crop_name": "Weizen"},
				"oepul": {"measures": ["24", "1A"], "codes": []},
				"wrrl": {
					"in_area": true,
					"gwsp_crop": "Weizen",
					"gwsp_period_crop": "Winterweizen, Triticale",
					"fertilization_classes": [{"class": "D", "area_ha": 0.7}, {"class": "B", "area_ha": 0.3}],
					"sowing_date": "2025-10-10",
					"n_requirement_kg_per_ha": 140,
					"previous_crop_n_credit_kg_per_ha": 10,
					"n_applications": [
						{"date": "2026-03-01", "fertilizer_type": "mineral", "amount": 220, "n_effective_kg_per_ha": 60, "recorded_date": "2026-03-03"},
						{"date": "2026-04-15", "fertilizer_type": "mineral", "amount": 185, "n_effective_kg_per_ha": 50, "recorded_date": "2026-04-16"},
					],
				},
			},
			{
				"parcel_id": "P2",
				"area_ha": 1.5,
				"land_use": "arable",
				"crop": {"crop_category": "maize", "crop_name": "Körnermais"},
				"oepul": {"measures": ["24"], "codes": []},
				"wrrl": {
					"in_area": true,
					"gwsp_crop": "Mais (CCM, Körnermais)",
					"sowing_date": "2026-04-15",
					"n_requirement_kg_per_ha": 160,
					"previous_crop_n_credit_kg_per_ha": 0,
					"n_applications": [
						{"date": "2026-04-10", "fertilizer_type": "slurry", "amount": 25, "n_effective_kg_per_ha": 80},
						{"date": "2026-06-01", "fertilizer_type": "mineral", "amount": 150, "n_effective_kg_per_ha": 40},
					],
				},
			},
			{
				"parcel_id": "P3",
				"area_ha": 0.5,
				"land_use": "arable",
				"crop": {"crop_category": "fallow", "crop_name": "Grünbrache"},
				"oepul": {"measures": ["24"], "codes": []},
				"wrrl": {"in_area": true},
			},
			{
				"parcel_id": "P4",
				"area_ha": 0.8,
				"land_use": "arable",
				"crop": {"crop_category": "vegetable", "crop_name": "Karfiol"},
				"oepul": {"measures": ["24"], "codes": ["OPWRRL"]},
				"wrrl": {
					"in_area": true,
					"increased_n_permit": true,
					"gwsp_crop": "Karfiol",
					"sowing_date": "2026-04-20",
					"n_requirement_kg_per_ha": 250,
					"previous_crop_n_credit_kg_per_ha": 0,
					"nmin_test_date": "2026-04-01",
					"n_applications": [{"date": "2026-04-18", "fertilizer_type": "mineral", "amount": 300, "n_effective_kg_per_ha": 80}],
				},
			},
		],
	},
	"documentation": {"wrrl_records": {
		"farm_book_kept": true,
		"kept_at_farm": true,
		"records_for_all_plots": true,
		"retention_years": 7,
		"annual_fields_recorded": ["total_agricultural_area", "manure_n_produced", "manure_n_transferred", "manure_n_applied_own", "plot_register"],
	}},
}

patched(ops) := json.patch(base_input, ops)
