package oepul.o6_17.fixtures

# Gemeinsame Testeingaben: Betrieb mit Einstieg 2025, UBB-Teilnahme,
# 6,5 ha Grünland, 2 ha Kleegras und 5 Rindern ab 2 Jahren.

good_survey := {
	"survey_dates": ["2025-05-20", "2025-06-10"],
	"documented": true,
	"sketch_documented": true,
	"first_use_is_mowing": true,
	"sections": [
		{"section_id": "A", "species_found": ["Wiesen-Salbei", "Wiesen-Margerite", "Knautia arvensis", "Hornklee", "Zittergras"]},
		{"section_id": "B", "species_found": ["Salvia pratensis", "Leucanthemum vulgare agg.", "Wiesen-Witwenblume", "Lotus corniculatus", "Briza media", "Wilde Möhre"]},
	],
}

parcel_g1 := {
	"parcel_id": "G1",
	"area_ha": 3.0,
	"land_use": "grassland",
	"slope_percent": 10,
	"grassland_number": 35,
	"grassland_use_type": "maehwiese_3_nutzungen",
	"codes": ["AGL"],
	"oepul_measures": ["1A", "17"],
	"operations": {"cutting_dates": ["2025-06-15"]},
	"o6_17": {"agl_survey": good_survey},
}

parcel_g2 := {
	"parcel_id": "G2",
	"area_ha": 2.5,
	"land_use": "grassland",
	"slope_percent": 25,
	"grassland_number": 45,
	"grassland_use_type": "einmaehdige_wiese",
	"codes": [],
	"oepul_measures": ["1A", "17"],
	"operations": {"cutting_dates": ["2025-07-20"]},
}

parcel_g3 := {
	"parcel_id": "G3",
	"area_ha": 1.0,
	"land_use": "grassland",
	"slope_percent": 5,
	"grassland_number": 15,
	"grassland_use_type": "dauerweide",
	"gloez_ploughing_ban": {"gloez9": true},
	"codes": [],
	"oepul_measures": ["1A", "17"],
	"operations": {"cutting_dates": [], "full_grazing": true},
}

parcel_a1 := {
	"parcel_id": "A1",
	"area_ha": 2.0,
	"land_use": "arable",
	"slope_percent": 4,
	"crop": {"crop_category": "other", "crop_name": "Kleegras"},
	"codes": [],
	"oepul_measures": ["1A"],
}

parcel_a2 := {
	"parcel_id": "A2",
	"area_ha": 1.0,
	"land_use": "arable",
	"slope_percent": 3,
	"crop": {"crop_category": "cereal", "crop_name": "Weizen"},
	"codes": [],
	"oepul_measures": ["1A"],
	"operations": {"harvest": {"harvested_share_percent": 100}},
}

base_input := {
	"farm": {
		"farm_id": "AT-TEST-1",
		"year": 2025,
		"region": {"federal_state": "Salzburg", "district": "Zell am See"},
		"applicant": {"legal_form": "natural_person", "public_body_share_percent": null},
		"oepul": {
			"first_oepul_participation_year": 2023,
			"participating_measures": ["1A", "17"],
			"o6_17": {
				"contract_start_year": 2025,
				"measure_application_date": "2024-11-20",
				"training_courses": [{
					"person_id": "p1",
					"person_role": "applicant",
					"topic": "grassland",
					"hours": 6,
					"course_date": "2024-03-01",
					"provider_recognized": true,
				}],
				"soil_samples": [{
					"sample_id": "S1",
					"sample_date": "2025-04-02",
					"lab_submission_date": "2025-04-05",
					"lab_accredited": true,
					"method": "sgd",
					"parameters": ["ph", "phosphor", "kalium", "humus"],
					"recorded_in_invekos_gis": true,
				}],
			},
		},
	},
	"land": {
		"total_area_ha": 9.5,
		"parcels": [parcel_g1, parcel_g2, parcel_g3, parcel_a1, parcel_a2],
	},
	"livestock": {
		"has_livestock": true,
		"species_groups": [{"species": "cattle", "rgve_category": "rinder_ab_2_jahre", "animal_count": 5, "kept_in_austria": true}],
	},
}

with_o6(patch) := object.union(base_input, {"farm": {"oepul": {"o6_17": object.union(base_input.farm.oepul.o6_17, patch)}}})

with_year(y) := object.union(base_input, {"farm": {"year": y}})

with_parcels(ps) := object.union(base_input, {"land": {"parcels": ps}})
