package oepul.o6_2_test

import data.oepul.o6_2
import rego.v1

base := {
	"year": 2026,
	"application_year": 2026,
	"program": {
		"o6_2": {"participates": true, "application_year": 2025, "application_date": "2024-12-31"},
		"o6_1a": {"participates": true},
		"o6_1b": {"participates": false, "partial_farm": false},
	},
	"farm": {
		"forage_area_ha": 10,
		"compliance": {"external_n_fertilizer_kg": 0, "livestock_n_kg_per_ha": 170},
		"training": {"hours": 3, "completed_by": "2025-12-31", "course_date": "2022-01-01", "provider_approved": true, "double_counted": false},
	},
	"livestock": {"species_groups": [{"category": "cattle_from_two_years", "animal_count": 5}]},
	"region": {"federal_state": "Burgenland", "district": "Eisenstadt"},
	"land": {"parcels": [], "total_area_ha": 100},
}

with_parcel(parcel) := object.union(base, {"land": object.union(base.land, {"parcels": [parcel]})})

test_rgve_animal_holding if {
	test_input := with_parcel({"land_use": "grassland", "crop": {"crop_category": "other", "crop_name": null}})
	result := o6_2.decision with input as test_input
	result.premium_tier == "animal_holding_below_1_40"
}

test_non_animal_fodder_has_zero_premium if {
	test_input := object.union(base, {
		"farm": object.union(base.farm, {"forage_area_ha": 20}),
		"livestock": {"species_groups": []},
		"land": object.union(base.land, {"parcels": [{"land_use": "grassland", "crop": {"crop_category": "other", "crop_name": null}}]}),
	})
	o6_2.premium_rate(test_input.land.parcels[0]) == 0 with input as test_input
}

test_arable_non_fodder_rate_2026 if {
	test_input := with_parcel({"land_use": "arable", "crop": {"crop_category": "cereal", "crop_name": "Weizen"}})
	o6_2.premium_rate(test_input.land.parcels[0]) == 64.8 with input as test_input
}

test_fodder_rate_below_140_2026 if {
	test_input := with_parcel({"land_use": "arable", "crop": {"crop_category": "legume", "crop_name": "Kleegras"}})
	o6_2.premium_rate(test_input.land.parcels[0]) == 75.6 with input as test_input
}

test_banned_flach_psm_fails if {
	parcel := {"land_use": "grassland", "crop": {"crop_category": "other", "crop_name": null}, "operations": {"psm_used": true, "seed_treatment": false, "psm_applications": [{"bio_allowed": false, "individual_plant_treatment": false}]}}
	not o6_2.parcel_psm_ok(parcel)
}

test_bio_psm_is_allowed if {
	parcel := {"land_use": "grassland", "crop": {"crop_category": "other", "crop_name": null}, "operations": {"psm_used": true, "seed_treatment": false, "psm_applications": [{"bio_allowed": true, "individual_plant_treatment": false}]}}
	o6_2.parcel_psm_ok(parcel)
}

test_drought_exception_for_listed_2026_district if {
	test_input := with_parcel({"land_use": "arable", "late_summer_or_autumn_harvest_crop": true, "no_harvestable_stand_due_to_drought": true})
	o6_2.eligible_for_drought_harvest_exception with input as test_input
}

test_drought_exception_requires_late_crop if {
	test_input := with_parcel({"land_use": "arable", "late_summer_or_autumn_harvest_crop": false, "no_harvestable_stand_due_to_drought": true})
	not o6_2.eligible_for_drought_harvest_exception with input as test_input
}

test_course_and_application_and_combination if {
	result := o6_2.decision with input as base
	result.course_ok
	result.application_ok
	result.ubb_combination_ok
}

test_fertilizer_exceptions if {
	o6_2.fertilizer_source_allowed("external_manure")
	o6_2.fertilizer_source_allowed("permitted_compost")
	o6_2.fertilizer_source_allowed("non_nitrogen")
	not o6_2.fertilizer_source_allowed("sewage_sludge")
	o6_2.fertilizer_source_prohibited("other_organic_residue")
}

test_partial_farm_bio_combination if {
	test_input := object.union(
		with_parcel({"crop": {"crop_category": "vineyard"}}),
		{"program": object.union(base.program, {"o6_1b": {"participates": true, "partial_farm": true}})},
	)
	o6_2.organic_combination_ok with input as test_input
}

test_orchard_material_and_cap if {
	test_input := with_parcel({"crop": {"crop_category": "orchard", "planting_material_quality": "grafted"}, "combined_area_payments_eur_per_ha": 1300})
	o6_2.orchard_premium_eligible with input as test_input
	o6_2.premium_cap_ok with input as test_input
}

test_modulation_bands if {
	test_input := object.union(base, {"land": {"parcels": [], "total_area_ha": 250}})
	o6_2.modulation_factor == 0.9 with input as test_input
}
