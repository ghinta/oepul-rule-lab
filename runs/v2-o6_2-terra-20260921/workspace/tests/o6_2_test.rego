package oepul.o6_2_test

import data.oepul.o6_2
import rego.v1

base := {
	"farm": {"year": 2026},
	"land": {"parcels": [
		{"parcel_id": "a", "area_ha": 10, "land_use": "arable", "crop": {"crop_name": "Weizen", "crop_category": "cereal"}},
		{"parcel_id": "g", "area_ha": 5, "land_use": "grassland", "crop": {"crop_name": "", "crop_category": "other"}},
	]},
	"o6_2": {
		"ubb_participation": true,
		"eligible_rgve": 3,
		"agricultural_area_ha_austria": 15,
		"livestock_nitrogen_kg_after_stall_storage_losses": 2000,
		"alpine_or_common_pasture_nitrogen_kg": 0,
		"fertilizer_events": [], "psm_events": [], "inventory_items": [],
		"training": {"completed_by_2025_12_31": true},
		"bio_participation": false, "bio_partial_farm_wine_fruit_hops_only": false,
	},
}

test_eligible_and_grassland_low_density_rate if {
	o6_2.eligible with input as base
	o6_2.premium_rate(base.land.parcels[1]) == 75.6 with input as base
}

test_external_nitrogen_is_violation if {
	result := o6_2.violations with input as object.union(base, {"o6_2": object.union(base.o6_2, {"fertilizer_events": [{"is_external": true, "contains_nitrogen": true, "is_farmyard_manure": false, "is_eu_2018_848_compost": false, "is_biogas_slurry_return": false}]})})
	result[_].rule_id == "o6_2.nitrogen.external"
}

test_bio_partial_farm_exception if {
	o6_2.eligible with input as object.union(base, {"o6_2": object.union(base.o6_2, {"bio_participation": true, "bio_partial_farm_wine_fruit_hops_only": true})})
}
