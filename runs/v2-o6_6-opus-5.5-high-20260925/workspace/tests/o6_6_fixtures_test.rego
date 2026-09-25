# Testfixtures für o6_6: ein regelkonformer Betrieb im Antragsjahr 2026.
package oepul.o6_6_test

v2_parcel := {
	"parcel_id": "P-V2",
	"area_ha": 10,
	"land_use": "arable",
	"crop": {"crop_category": "cereal", "crop_name": "Winterweizen"},
	"is_in_austria": true,
	"oepul_codes": [],
	"oepul_measures": ["6", "1A"],
	"operations": {
		"main_crop_harvest_share_percent": 100,
		"cover_crop": {
			"is_used": true,
			"variant": 2,
			"variant_applied_on": "2026-04-10",
			"establishment": "sowing",
			"sowing_date": "2026-08-01",
			"mixture_partner_count": 7,
			"plant_family_count": 3,
			"species": ["Phazelia", "Senf", "Ölrettich", "Erbse", "Sonnenblume", "Buchweizen", "Alexandrinerklee"],
			"cereal_maize_share_percent": 0,
			"only_volunteer_or_self_seeded": false,
			"full_coverage_achieved": true,
			"properly_established": true,
			"partners_visible_in_field": true,
			"winter_hardiness": "mixed",
			"termination_date": "2027-02-20",
			"termination_method": "cultivator",
			"declared_as_main_crop_next_mfa": false,
			"events": [
				{"type": "rolling", "date": "2026-08-01", "immediately_after_sowing": true},
				{"type": "farm_manure_application", "date": "2026-09-10"},
				{"type": "care_mowing", "date": "2026-11-05", "coverage_maintained": true, "regrowth_expected": true},
				{"type": "mineral_n_fertilization", "date": "2027-03-10"},
			],
			"following_main_crop": {"crop_name": "Körnermais", "actively_established": true, "sowing_date": "2027-04-20", "sowing_method": "mulch", "declared_in_next_mfa": true},
		},
	},
}

v1_parcel := {
	"parcel_id": "P-V1",
	"area_ha": 2,
	"land_use": "arable",
	"crop": {"crop_category": "cereal", "crop_name": "Wintergerste"},
	"operations": {"cover_crop": {
		"is_used": true,
		"variant": 1,
		"variant_applied_on": "2026-08-20",
		"establishment": "sowing",
		"sowing_date": "2026-07-07",
		"mixture_partner_count": 5,
		"plant_family_count": 3,
		"species": ["Phazelia", "Buchweizen", "Sonnenblume", "Kresse", "Ringelblume"],
		"non_insect_pollinated_share_percent": 0,
		"full_coverage_achieved": true,
		"winter_hardiness": "frost_killed",
		"termination_date": "2026-09-15",
		"termination_method": "plough",
		"events": [{"type": "driving", "date": "2026-08-20", "crossing_only": true}],
		"following_main_crop": {"crop_name": "Winterweizen", "actively_established": true, "sowing_date": "2026-10-05", "sowing_method": "conventional", "declared_in_next_mfa": true},
	}},
}

v6_parcel := {
	"parcel_id": "P-V6",
	"area_ha": 3,
	"land_use": "arable",
	"crop": {"crop_category": "maize", "crop_name": "Silomais"},
	"operations": {"cover_crop": {
		"is_used": true,
		"variant": 6,
		"variant_applied_on": "2026-09-25",
		"establishment": "sowing",
		"sowing_date": "2026-10-10",
		"mixture_partner_count": 2,
		"plant_family_count": 2,
		"species": ["Grünschnittroggen", "Zottelwicke"],
		"green_rye_varieties": ["Lunator"],
		"full_coverage_achieved": true,
		"winter_hardiness": "winter_hardy",
		"termination_date": "2027-03-25",
		"termination_method": "plough",
		"following_main_crop": {"crop_name": "Hirse", "actively_established": true, "sowing_date": "2027-05-10", "sowing_method": "direct", "declared_in_next_mfa": true},
	}},
}

v7_parcel := {
	"parcel_id": "P-V7",
	"area_ha": 5,
	"land_use": "arable",
	"crop": {"crop_category": "oilseed", "crop_name": "Winterraps"},
	"operations": {"cover_crop": {
		"is_used": true,
		"variant": 7,
		"variant_applied_on": "2026-09-01",
		"establishment": "companion_sowing_in_winter_rape",
		"sowing_date": "2026-08-25",
		"mixture_partner_count": 3,
		"plant_family_count": 2,
		"full_coverage_achieved": true,
		"rape_four_leaf_stage_date": "2026-09-20",
		"termination_date": "2027-07-15",
		"events": [
			{"type": "herbicide_application", "date": "2026-09-10", "impairs_companion_crop": false},
			{"type": "psm_application", "date": "2026-10-15"},
		],
		"following_main_crop": {"crop_name": "Winterweizen", "actively_established": true, "sowing_date": "2027-10-01", "declared_in_next_mfa": true},
	}},
}

base_input := {
	"farm": {
		"farm_id": "AT-1",
		"year": 2026,
		"region": {"federal_state": "Niederösterreich", "district": "Tulln"},
		"applicant": {"legal_form": "natural_person", "is_active_farmer": true},
		"oepul": {
			"first_participation_year": 2023,
			"content_violation_level": "none",
			"measures": [
				{"measure_code": "6", "applied_on": "2022-12-15", "contract_start_year": 2023},
				{"measure_code": "1A", "applied_on": "2022-12-15", "contract_start_year": 2023},
			],
		},
	},
	"land": {
		"total_area_ha": 40,
		"arable_area_ha": 35,
		"parcels": [v2_parcel, v1_parcel, v6_parcel, v7_parcel],
	},
}

# Ersetzt einen Schlag im Basisinput.
with_parcel(p) := json.patch(base_input, [{"op": "replace", "path": "/land/parcels", "value": [p]}])

# Setzt ein Feld der Begrünung des Schlags.
set_cc(p, field, value) := json.patch(p, [{"op": "add", "path": sprintf("/operations/cover_crop/%s", [field]), "value": value}])

violation_ids(inp) := {v.rule_id | some v in data.oepul.o6_6.parcel_violations with input as inp}

farm_violation_ids(inp) := {v.rule_id | some v in data.oepul.o6_6.farm_violations with input as inp}
