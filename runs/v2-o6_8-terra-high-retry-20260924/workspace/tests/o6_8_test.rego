package oepul.o6_8_test

import data.oepul.o6_8
import rego.v1

base_input := {
	"farm": {"year": 2026, "region": {"federal_state": "Niederösterreich", "district": "Amstetten"}},
	"land": {"parcels": [{
		"parcel_id": "p1", "area_ha": 1.0, "land_use": "arable",
		"erosion_protection": {"code": "US", "declared_crop": "Körnermais", "underseed": {"mixture_partner_count": 3, "sowing_date": "2026-06-20", "latest_permitted_date": "2026-06-30", "soil_working_or_herbicide_after_sowing": false, "maintained_until_main_crop_harvest": true, "harvested_with_main_crop": false, "ordinarily_established": true}},
	}]},
}

test_underseed_2026_eligible if {
	area := o6_8.eligible_area_ha with input as base_input
	area == 1
	rate := o6_8.premium_rate("US") with input as base_input
	rate == 81
}

test_underseed_maize_not_eligible_before_2025 if {
	not o6_8.eligible_crop("US", "Körnermais") with input as object.union(base_input, {"farm": {"year": 2024, "region": {"federal_state": "Niederösterreich", "district": "Amstetten"}}})
}

test_potato_only_ms if {
	not o6_8.eligible_crop("DS", "Speisekartoffeln") with input as base_input
	o6_8.eligible_crop("MS", "Speisekartoffeln") with input as base_input
}

test_baw_path_is_known if {
	o6_8.erosion_path_kg(31001)
	not o6_8.erosion_path_kg(99999)
}

test_harvest_drought_exception_for_amstetten if {
	o6_8.drought_harvest_exception with input as base_input
}

test_underseed_violation_for_two_partners if {
	two_partner_input := object.union(base_input, {"land": {"parcels": [{"parcel_id": "p1", "area_ha": 1.0, "land_use": "arable", "erosion_protection": {"code": "US", "declared_crop": "Körnermais", "underseed": {"mixture_partner_count": 2, "sowing_date": "2026-06-20", "latest_permitted_date": "2026-06-30", "soil_working_or_herbicide_after_sowing": false, "maintained_until_main_crop_harvest": true, "harvested_with_main_crop": false, "ordinarily_established": true}}}]}})
	violations := o6_8.violations with input as two_partner_input
	count(violations) > 0
}
