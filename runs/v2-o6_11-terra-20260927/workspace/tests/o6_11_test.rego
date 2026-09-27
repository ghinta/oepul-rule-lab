package oepul.o6_11_test

import rego.v1

test_eligible_vineyard_without_herbicide if {
	result := data.oepul.o6_11.eligible with input as sample_input
	result
	data.oepul.o6_11.gross_premium_eur with input as sample_input == 270
}

test_detects_herbicide_and_scope_violation if {
	bad := object.union(sample_input, {"land": object.union(sample_input.land, {"parcels": [
		sample_input.land.parcels[0],
		{"parcel_id": "p2", "area_ha": 0.2, "crop": {"crop_category": "orchard", "crop_name": "Apfel"}, "operations": {"psm_used": true, "plant_protection_applications": [{"effect_type": "Herbizid"}]}, "o6_11": {"enrolled": false}},
	]})})
	not data.oepul.o6_11.eligible with input as bad
	violations := data.oepul.o6_11.violations with input as bad
	violations[_].code == "complete_scope"
	violations[_].code == "herbicide_use"
}

sample_input := {
	"farm": {"year": 2026},
	"land": {"total_area_ha": 1, "parcels": [{"parcel_id": "p1", "area_ha": 1, "crop": {"crop_category": "vineyard", "crop_name": "Grüner Veltliner"}, "operations": {"psm_used": false, "plant_protection_applications": []}, "o6_11": {"enrolled": true}}]},
	"o6_11": {"participation": {"requested": true, "contract_start_year": 2025, "first_commitment_year_area_ha": 1, "incompatible_bio_combination": false}, "inventory": {"has_prohibited_herbicide_purchase": false, "has_prohibited_herbicide_storage": false}},
}
