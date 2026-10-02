package oepul.o6_8_test

import data.oepul.o6_8
import rego.v1

test_baw_is_eligible_and_capped if {
	result := o6_8.baw_eligible with input as {
		"farm": {"year": 2026, "region": {"federal_state": "Burgenland", "district": "Güssing"}},
		"land": {"parcels": [{
			"parcel_id": "p1",
			"area_ha": 0.4,
			"land_use": "arable",
			"country": "AT",
			"crop": {"crop_name": "Grünbrache"},
			"application_codes": ["BAW"],
			"erosion": {"erosion_entry_path_share": 0.25, "erosion_entry_path_area_ha": 0.1, "erosion_entry_path_kg_number": "31001"},
		}]},
	}
	result.p1 == true
	cap := o6_8.baw_area_cap_satisfied with input as {
		"land": {"parcels": [{"parcel_id": "p1", "area_ha": 0.4, "application_codes": ["BAW"], "erosion": {"erosion_entry_path_area_ha": 0.1}}]},
	}
	cap.p1 == true
}

test_ms_requires_measure_six_or_seven if {
	violations := o6_8.violations with input as {
		"farm": {"year": 2026, "oepul": {"measure_applications": []}},
		"land": {"parcels": [{"parcel_id": "p1", "area_ha": 0.2, "land_use": "arable", "country": "AT", "crop": {"crop_name": "Körnermais"}, "application_codes": ["MS"]}]},
	}
	{"parcel_id": "p1", "rule_id": "O68-003", "reason": "MS/DS requires measure 6 or 7"} in violations
}

test_ms_and_ah_are_not_combinable if {
	violations := o6_8.violations with input as {
		"farm": {"year": 2026, "oepul": {"measure_applications": [{"measure_id": "o6_6", "active": true}]}},
		"land": {"parcels": [{"parcel_id": "p1", "area_ha": 0.2, "land_use": "arable", "country": "AT", "crop": {"crop_name": "Frühkartoffeln"}, "application_codes": ["MS", "AH"]}]},
	}
	{"parcel_id": "p1", "rule_id": "O68-024", "reason": "MS/DS and AH cannot be combined"} in violations
}

test_premium_rates_from_2024 if {
	rates := o6_8.premium_eur_per_ha with input as {"farm": {"year": 2026}}
	rates.MS == 54
	rates.DS == 86.4
	rates.AH == 162
	rates.BAW == 594
	rates.US == 81
	rates.US_BIO_SURCHARGE == 16.2
}

test_drought_2026_us_coverage_exception if {
	exceptions := o6_8.us_coverage_exception_2026 with input as {
		"farm": {"year": 2026},
		"land": {"parcels": [{"parcel_id": "p1", "application_codes": ["US"], "erosion": {"undersow_orderly_with_required_partners": true}}]},
	}
	exceptions.p1 == true
}

test_drought_2026_harvest_exception_district if {
	exceptions := o6_8.harvest_exception_2026 with input as {
		"farm": {"year": 2026, "region": {"federal_state": "Steiermark", "district": "Weiz"}},
		"land": {"parcels": [{"parcel_id": "p1", "operations": {"harvestable_stand": false}}]},
	}
	exceptions.p1 == true
}
