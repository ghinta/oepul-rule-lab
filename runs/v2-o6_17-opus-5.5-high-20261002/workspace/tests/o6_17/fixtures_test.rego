package oepul.o6_17_test

import rego.v1

# Repräsentativer Betrieb: UBB-Teilnahme, Vertragsbeginn 2023, Antragsjahr 2025.
meadow := {
	"parcel_id": "P1",
	"area_ha": 6.0,
	"land_use": "grassland",
	"slope_percent": 10,
	"operations": {"cutting_dates": ["2025-05-20", "2025-07-15"]},
	"oepul": {
		"field_use_type": "maehwiese_weide_drei_und_mehr_nutzungen",
		"grassland_number": 35,
		"codes": [],
		"measures": ["o6_1a", "o6_17"],
		"gloez_conversion_ban": "none",
	},
}

single_cut := {
	"parcel_id": "P2",
	"area_ha": 1.0,
	"land_use": "grassland",
	"slope_percent": 22,
	"operations": {"cutting_dates": ["2025-08-01"]},
	"oepul": {
		"field_use_type": "einmaehdige_wiese",
		"grassland_number": 15,
		"codes": [],
		"measures": ["o6_1a", "o6_17"],
	},
}

clover := {
	"parcel_id": "A1",
	"area_ha": 3.0,
	"land_use": "arable",
	"slope_percent": 5,
	"operations": {"cutting_dates": ["2025-06-01"]},
	"oepul": {"field_use_type": "kleegras", "codes": [], "measures": ["o6_1a"]},
}

base_input := {
	"farm": {
		"farm_id": "F1",
		"year": 2025,
		"applicant": {"legal_form": "natural_person", "is_active_farmer": true},
		"oepul": {
			"first_oepul_year": 2023,
			"measures": [{"measure_id": "o6_1a"}, {"measure_id": "o6_17"}],
			"o6_17": {
				"contract_start_year": 2023,
				"measure_application_date": "2022-12-15",
				"arable_grassland_swap": false,
				"training": {"courses": [{
					"course_date": "2023-02-01",
					"hours": 5,
					"provider_recognized": true,
					"attendee_role": "farm_manager",
				}]},
				"soil_sample_base_mfa2025_grassland_lt18_ha": 6.0,
				"soil_samples": [
					{
						"sample_date": "2024-10-01",
						"lab_submission_date": "2024-10-02",
						"lab_accredited": true,
						"method": "sgd",
						"parameters": ["ph", "p", "k", "humus"],
						"recorded_in_invekos_gis": true,
					},
					{
						"sample_date": "2025-03-01",
						"lab_submission_date": "2025-03-02",
						"lab_accredited": true,
						"method": "euf",
						"parameters": ["ph", "p", "k", "humus"],
						"recorded_in_invekos_gis": true,
					},
				],
			},
		},
	},
	"land": {
		"total_area_ha": 10.0,
		"arable_area_ha": 3.0,
		"grassland_area_ha": 7.0,
		"alpine_pasture_area_ha": 0,
		"parcels": [meadow, single_cut, clover],
	},
	"livestock": {
		"has_livestock": true,
		"species_groups": [{"species": "cattle", "rgve_category": "cattle_ge_2y", "animal_count": 5}],
	},
}

with_year(y) := object.union(base_input, {"farm": object.union(base_input.farm, {"year": y})})

with_measure(patch) := object.union(base_input, {"farm": object.union(base_input.farm, {"oepul": object.union(
	base_input.farm.oepul,
	{"o6_17": object.union(base_input.farm.oepul.o6_17, patch)},
)})})

with_parcels(ps) := object.union(base_input, {"land": object.union(base_input.land, {"parcels": ps})})

parcel_with(p, oepul_patch) := object.union(p, {"oepul": object.union(p.oepul, oepul_patch)})
