package oepul.o6_19

import rego.v1

test_eligible_complete_application if {
	eligible with input as {"oepul": {"o6_19": {"start_year": 2025, "application_submitted_by_dec_31": true, "participation_year": 1, "current_year": 2026, "training": {"completed_by_2026_12_31": true}, "regional_plan": {"requested": false, "annual_confirmation_present": false}, "parcels": [{"parcel_id": "P1", "area_ha": 1, "code_ebw": true, "reference_area_present": true, "land_use": "grassland", "years_since_last_use_or_care": 2, "project_confirmation": {"present": true, "requires_regular_care": true, "indicators": [{"additional": false, "observed": true}]}}]}}}
}

test_missing_project_confirmation_denied if {
	denials["Projektbestätigung fehlt für Schlag P1"] with input as {"oepul": {"o6_19": {"application_submitted_by_dec_31": true, "participation_year": 2, "current_year": 2026, "training": {"completed_by_2026_12_31": true}, "regional_plan": {"requested": false, "annual_confirmation_present": false}, "parcels": [{"parcel_id": "P1", "project_confirmation": {"present": false}}]}}}
}

test_wiesen_premium_table if {
	premium_per_ha({"premium": {"land_use": "wiese", "habitat": "Frische Magerwiese", "conservation_status": "B", "difficulty_index": 1}}) == 961.2
}

test_fallow_cap if {
	fallow_eligible_area_ha == 2 with input as {"oepul": {"o6_19": {"arable_fallow_area_ha": 3, "total_arable_area_ha": 4}}}
}

test_modulation if {
	modulation_factor == 109 / 110 with input as {"oepul": {"o6_19": {"total_farm_area_ha": 220}}}
}
