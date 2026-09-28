package oepul.o6_12_test

import data.oepul.o6_12
import rego.v1

base_input := {
	"farm": {"year": 2026, "organic_whole_farm": false},
	"land": {"total_area_ha": 10, "parcels": [
		{"parcel_id": "v1", "area_ha": 0.6, "crop": {"crop_category": "vineyard"}, "operations": {"insecticide_applications": []}},
	]},
	"insecticide_inventory": [],
}

test_minimum_area_and_premium if {
	o6_12.minimum_participation_met with input as base_input
	o6_12.premium_for_parcel(base_input.land.parcels[0]) == 162 with input as base_input
	o6_12.modulation_factor(220) == 0.9
}

test_forbidden_insecticide_fails_waiver if {
	altered := object.union(base_input, {"land": {"total_area_ha": 10, "parcels": [
		{"parcel_id": "v1", "area_ha": 0.6, "crop": {"crop_category": "vineyard"}, "operations": {"insecticide_applications": [{"ages_effect_type": "Insektizid", "bio_2018_848_permitted": false, "officially_ordered": false}]}},
	]}})
	not o6_12.farmwide_insecticide_waiver_met with input as altered
}

test_ordered_application_needs_both_records if {
	o6_12.official_order_exception_met({"officially_ordered": true, "officially_authorised_active_ingredient": true, "official_order_documented": true, "application_documented": true})
	not o6_12.official_order_exception_met({"officially_ordered": true, "officially_authorised_active_ingredient": true, "official_order_documented": false, "application_documented": true})
}

test_year_specific_code if {
	o6_12.psm_code_required({"chemical_synthetic": true, "ages_effect_type": "Insektizid"}) == "PSMCSI" with input as object.union(base_input, {"farm": {"year": 2025}})
	o6_12.psm_coding_not_required with input as base_input
}

test_erosion_supplement_reduction if {
	o6_12.erosion_organism_supplement_factor == 0.5 with input as object.union(base_input, {"farm": {"year": 2026, "organic_whole_farm": false, "participations": [{"measure": "o6_12"}], "erosionschutz_organism_supplement": true}})
}
