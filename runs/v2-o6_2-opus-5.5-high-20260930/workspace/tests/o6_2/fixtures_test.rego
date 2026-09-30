package oepul.o6_2_test

# Basisbetrieb: tierhaltend, UBB-Teilnahme, Vertragsbeginn 2024, Jahr 2026.
base_parcels := [
	{
		"parcel_id": "A1",
		"area_ha": 10,
		"land_use": "arable",
		"land_use_code": "A",
		"crop": {"crop_category": "cereal", "crop_name": "Weizen"},
		"operations": {"psm_used": true, "psm_applications": [{"application_mode": "broadcast", "organic_approved_only": false}], "fertilizer": {"mineral_n_kg_per_ha": null, "organic_n_kg_per_ha": 60, "inputs": [{"input_id": "slurry_guelle", "external_origin": false}]}, "cutting_dates": [], "harvested_share_percent": 100},
		"oepul_codes": [],
	},
	{
		"parcel_id": "F1",
		"area_ha": 5,
		"land_use": "arable",
		"land_use_code": "A",
		"crop": {"crop_category": "other", "crop_name": "Kleegras"},
		"operations": {"psm_used": false, "fertilizer": {"mineral_n_kg_per_ha": null, "organic_n_kg_per_ha": 40}, "cutting_dates": ["2026-05-20", "2026-07-01"]},
		"oepul_codes": [],
	},
	{
		"parcel_id": "G1",
		"area_ha": 15,
		"land_use": "grassland",
		"land_use_code": "G",
		"crop": {"crop_category": "other", "crop_name": "Mähwiese"},
		"operations": {"psm_used": false, "fertilizer": {"mineral_n_kg_per_ha": null, "organic_n_kg_per_ha": 50}, "cutting_dates": ["2026-05-15"]},
		"oepul_codes": [],
	},
]

# 20 Rinder ab 2 Jahre = 20 RGVE auf 20 ha Futterfläche = 1,0 RGVE/ha.
base_livestock := {
	"has_livestock": true,
	"species_groups": [{"species": "cattle", "category": "Milchkühe", "rgve_key_id": "cattle_ge_2y", "animal_count": 20, "gve": 20, "held_in_austria": true}],
	"nitrogen": {"n_after_stall_storage_losses_kg": 2400, "n_on_alm_or_community_pasture_kg": 0},
}

base_oepul := {
	"applicant_type": "natural_person",
	"first_oepul_participation_year": 2023,
	"participating_measures": ["1A", "2"],
	"o6_2": {"application_date": "2023-11-30", "contract_start_year": 2024, "payment_application_submitted": true},
	"trainings": [{"topic": "nitrogen_fertilisation", "hours": 3, "date": "2024-02-10", "provider_recognized": true, "attendee_role": "applicant"}],
	"operating_supplies": [],
}

base_input := {
	"farm": {
		"farm_id": "AT-TEST-1",
		"year": 2026,
		"region": {"federal_state": "Tirol", "district": "Innsbruck-Land"},
		"oepul": base_oepul,
	},
	"land": {"total_area_ha": 30, "parcels": base_parcels},
	"livestock": base_livestock,
}

with_year(y) := json.patch(base_input, [{"op": "replace", "path": "/farm/year", "value": y}])

with_oepul(path, value) := json.patch(base_input, [{"op": "add", "path": concat("", ["/farm/oepul/", path]), "value": value}])

with_parcel(idx, path, value) := json.patch(base_input, [{"op": "add", "path": sprintf("/land/parcels/%d/%s", [idx, path]), "value": value}])
