package oepul.o6_12_test

# Repräsentativer Weinbau-/Obstbaubetrieb im 3. Teilnahmejahr (Vertragsbeginn 2024).

vineyard := {
	"parcel_id": "W1",
	"area_ha": 2.0,
	"land_use": "special_crop",
	"land_use_code": "WI",
	"crop": {"crop_category": "vineyard", "crop_name": "Grüner Veltliner", "usage_type": "regular"},
	"in_vineyard_register": true,
	"country": "AT",
	"oepul_codes": [],
	"declared_measures": ["12", "11"],
	"psm_applications": [],
	"minimum_management": {"properly_planted": true, "annual_care": true, "harvested": true},
}

orchard := {
	"parcel_id": "O1",
	"area_ha": 1.0,
	"land_use": "special_crop",
	"land_use_code": "S",
	"crop": {"crop_category": "orchard", "crop_name": "Apfel", "usage_type": "regular", "grafted_planting_material": true},
	"country": "AT",
	"oepul_codes": [],
	"declared_measures": ["12"],
	"psm_applications": [],
	"minimum_management": {"properly_planted": true, "annual_care": true, "harvested": true},
}

arable := {
	"parcel_id": "A1",
	"area_ha": 5.0,
	"land_use": "arable",
	"land_use_code": "A",
	"crop": {"crop_category": "cereal", "crop_name": "Weizen"},
	"country": "AT",
	"oepul_codes": [],
	"declared_measures": [],
	"psm_applications": [],
}

base_input := {
	"farm": {
		"year": 2026,
		"region": {"federal_state": "Niederösterreich", "district": "Mistelbach"},
		"applicant": {"legal_form": "natural_person", "is_active_farmer": true, "farms_in_own_name_and_account": true},
	},
	"land": {"total_area_ha": 8.0, "parcels": [vineyard, orchard, arable]},
	"oepul": {
		"first_participation_year": 2023,
		"participating_measures": ["1A", "11", "12"],
		"o6_12": {
			"participating": true,
			"application_submitted_date": "2023-12-15",
			"contract_start_year": 2024,
			"first_year_area_ha": 3.0,
			"annual_application_submitted": true,
		},
	},
}

with_parcels(ps) := json.patch(base_input, [{"op": "replace", "path": "/land/parcels", "value": ps}])

with_o612(patch) := object.union(base_input, {"oepul": object.union(base_input.oepul, {"o6_12": object.union(base_input.oepul.o6_12, patch)})})

with_year(yr) := json.patch(base_input, [{"op": "replace", "path": "/farm/year", "value": yr}])
