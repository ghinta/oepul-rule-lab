# Gemeinsame Testdaten (Basisbetrieb) für die Tests der Maßnahme o6_1b.
package oepul.o6_1b_test

base_organic := {
	"is_certified": true,
	"registered_with_food_authority": true,
	"control_contract_start_date": "2022-11-01",
	"control_contract_end_date": null,
	"control_body_change_without_gap": true,
}

base_courses := [
	{"hours": 3, "topic": "biodiversity", "date": "2023-02-01", "provider_recognized": true},
	{"hours": 5, "topic": "organic", "date": "2024-02-01", "provider_recognized": true},
]

# Basisbetrieb ohne Verstöße: 20 ha Acker (davon 1,5 ha DIV), 10 ha gemähtes Grünland (1 ha DIVSZ)
base_parcels := [
	{"parcel_id": "A1", "field_piece_id": "F1", "area_ha": 8.5, "land_use": "arable", "schlagnutzungsart": "Winterweizen", "crop": {"crop_name": "Winterweizen"}},
	{
		"parcel_id": "A2", "field_piece_id": "F1", "area_ha": 1.5, "land_use": "arable", "schlagnutzungsart": "Grünbrache",
		"crop": {"crop_name": "Grünbrache"}, "oepul_codes": ["DIV"],
		"constraints": {"biodiversity_area": {"first_declared_year": 2025, "is_new_sowing": true, "seed_mixture": {"insect_pollinated_partners": 8, "plant_families": 4, "non_insect_share_percent": 5}}},
		"operations": {"use_events": [{"date": "2026-08-10", "type": "mow", "removed": true}]},
	},
	{"parcel_id": "A3", "field_piece_id": "F2", "area_ha": 5, "land_use": "arable", "schlagnutzungsart": "Kleegras", "crop": {"crop_name": "Kleegras"}},
	{"parcel_id": "A4", "field_piece_id": "F2", "area_ha": 5, "land_use": "arable", "schlagnutzungsart": "Körnermais", "crop": {"crop_name": "Körnermais"}},
	{"parcel_id": "G1", "field_piece_id": "G1", "area_ha": 9, "land_use": "grassland", "schlagnutzungsart": "Mähwiese/-weide drei und mehr Nutzungen", "is_mown": true},
	{
		"parcel_id": "G2", "field_piece_id": "G2", "area_ha": 1, "land_use": "grassland", "schlagnutzungsart": "Mähwiese/-weide zwei Nutzungen",
		"is_mown": true, "oepul_codes": ["DIVSZ"],
		"constraints": {"biodiversity_area": {"comparable_second_cut_date": "2026-06-20", "year_complete": true}},
		"operations": {"use_events": [{"date": "2026-06-22", "type": "mow", "removed": true}]},
	},
]

base_input := {
	"farm": {
		"year": 2026,
		"region": {"federal_state": "Niederösterreich", "district": "Tulln"},
		"certifications": {"organic": base_organic},
	},
	"land": {
		"total_area_ha": 30,
		"field_pieces": [
			{"field_piece_id": "F1", "land_use": "arable", "area_ha": 10},
			{"field_piece_id": "F2", "land_use": "arable", "area_ha": 10, "gloez_lse_area_ha": 0.2},
		],
		"parcels": base_parcels,
	},
	"livestock": {"species_groups": [{"species": "cattle", "rgve_key": "cattle_ge_2", "animal_count": 10, "is_certified_organic": true}]},
	"oepul": {
		"applicant": {"person_type": "natural_person", "public_body_share_percent": 0},
		"first_participation_year": 2023,
		"participating_measures": ["o6_1b"],
		"o6_1b": {"contract_start_year": 2023, "application_date": "2022-12-15", "training": {"courses": base_courses}},
	},
}

# Ersetzt Werte per JSON-Patch
with_patch(ops) := json.patch(base_input, ops)

# Eingabe mit eigenen Schlägen
with_parcels(ps) := json.patch(base_input, [{"op": "replace", "path": "/land/parcels", "value": ps}])

arable(id, a, crop) := {"parcel_id": id, "area_ha": a, "land_use": "arable", "schlagnutzungsart": crop, "crop": {"crop_name": crop}}

div_arable(id, a, extra_codes) := {
	"parcel_id": id, "area_ha": a, "land_use": "arable", "schlagnutzungsart": "Grünbrache",
	"crop": {"crop_name": "Grünbrache"}, "oepul_codes": array.concat(["DIV"], extra_codes),
	"constraints": {"biodiversity_area": {"first_declared_year": 2025, "is_new_sowing": true, "seed_mixture": {"insect_pollinated_partners": 8, "plant_families": 4, "non_insect_share_percent": 5}}},
}

ids(vs) := {v.rule_id | some v in vs}

approx(a, b) if abs(a - b) < 0.0001
