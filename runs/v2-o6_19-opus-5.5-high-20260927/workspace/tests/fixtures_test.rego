# Testfixture: Betrieb mit zwei EBW-Schlägen (Grünland DIVSZ, Ackerstilllegung DIV) im Förderjahr 2026.
package oepul.o6_19_test

import rego.v1

base_input := {
	"farm": {
		"farm_id": "T-1",
		"year": 2026,
		"region": {"federal_state": "Burgenland", "district": "Neusiedl am See"},
	},
	"land": {
		"total_area_ha": 50,
		"arable_area_ha": 20,
		"grassland_area_ha": 30,
		"parcels": [
			{
				"parcel_id": "P1",
				"area_ha": 2.0,
				"land_use": "grassland",
				"oepul": {
					"codes": ["EBW", "DIVSZ"],
					"usage_type": "einmähdige Wiese",
					"field_piece_id": "FS1",
					"field_piece_area_ha": 2.0,
					"ebw": {
						"in_project_confirmation": true,
						"reference_area_present": true,
						"premium_table": "wiesen",
						"premium_habitat": "Pfeifengras-Streuwiese",
						"conservation_status": "B",
						"difficulty": "mittel",
						"chapter7_habitat": "Basenreiche Pfeifengras-Streuwiese",
						"indicators": [
							{"code": "EBGE03", "binding": true, "fulfilled": true},
							{"code": "EBGI01", "binding": false, "fulfilled": false},
						],
						"indicators_recorded": true,
						"requires_regular_care": true,
						"last_use_or_care_year": 2025,
						"surcharge_codes": ["EBBA01"],
						"ebba_reason_id": "erschwertes_trocknen",
					},
				},
			},
			{
				"parcel_id": "P2",
				"area_ha": 3.0,
				"land_use": "arable",
				"oepul": {
					"codes": ["EBW", "DIV"],
					"usage_type": "Grünbrache",
					"field_piece_id": "FS2",
					"field_piece_area_ha": 3.0,
					"ebw": {
						"in_project_confirmation": true,
						"reference_area_present": true,
						"premium_table": "acker",
						"premium_habitat": "Artenreiche Ackerbrache",
						"conservation_status": "A",
						"is_arable_set_aside": true,
						"indicators": [{"code": "EBAB01", "binding": true, "fulfilled": true}],
						"indicators_recorded": true,
						"requires_regular_care": true,
						"last_use_or_care_year": 2026,
					},
				},
			},
		],
	},
	"oepul": {
		"first_oepul_participation_year": 2023,
		"applicant": {"type": "natural_person", "active_farmer": true},
		"participation": {"ubb": true, "bio": false, "naturschutz": false},
		"o6_19": {
			"contract_start_year": 2024,
			"measure_application_date": "2023-12-15",
			"project_confirmation_present": true,
			"ebw_area_2025_ha": 5.0,
			"previous_year_ebw_area_ha": 5.0,
			"training": {"attended": true, "attendance_date": "2025-03-01", "attendee_role": "farm_manager"},
			"regional_plan": {
				"applied": true,
				"application_date": "2023-11-30",
				"first_year": 2024,
				"participation_confirmation_present": true,
			},
		},
	},
}

with_patch(ops) := json.patch(base_input, ops)
