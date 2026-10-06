package oepul.o6_16_test

import data.oepul.o6_16
import rego.v1

test_eligible_minimal_participant if {
	o6_16.eligible with input as {
		"farm": {"year": 2026, "region": {"federal_state": "Burgenland", "is_eastern_lower_austria_or_tullnerfeld": false, "bentazon_reauthorized": false}},
		"measure": {"requested": true, "first_participation_year": 2024, "participates_cover_intercrop": true, "participates_cover_evergreen": false, "participates_organic": false},
		"land": {"total_arable_area_ha": 10, "groundwater_arable_area_ha": 5.03, "parcels": [{"id": "p1", "kg_number": "32001", "in_groundwater_area": true, "crop_area_ha": 0.2, "crop_category": "cereal", "psm_active_ingredients": [], "field_record_complete": true, "nitrogen_surplus_kg_per_ha": 0, "following_crop_reduction_kg_per_ha": 0, "following_crop_planted_by_11_15": true, "cover_crop_planted_by_11_15": false}]},
		"records": {"farm_planning_completed_by_02_28": true, "farm_balance_completed_by_next_01_31": true, "education_hours": 10, "education_provider_recognized": true, "education_completed_date": "2026-12-31", "water_protection_concept_complete": true, "soil_samples": [{"lab_accredited": true, "draw_date": "2024-01-01"}, {"lab_accredited": true, "draw_date": "2025-01-01"}], "oo_ipm_inspection_or_warning_documented": true, "vienna_extra_education_hours": 0, "pig_feed_recipe_evidence": true, "cultan_field_records_complete": true, "cultan_external_service_evidence": true},
		"options": {"washout_risk": {"requested": false, "parcel_ids": []}, "vienna_humus": {"requested": false, "turning_tillage_other_than_after_maize": false, "recognized_carbon_project_confirmation": false}, "strong_n_reduced_pig_feeding": {"requested": false, "feed_categories": [], "also_claimed_in_liquid_manure_measure": false}, "cultan": {"requested": false, "has_ammonium_depot_injection": false, "external_equipment": false}, "psm_avoidance_surcharge": {"requested": false}},
	}
}

test_nitrogen_threshold_and_reduction if {
	context := {"farm": {"year": 2026, "region": {"federal_state": "Burgenland", "is_eastern_lower_austria_or_tullnerfeld": false}}}
	o6_16.nitrogen_transfer(30) == 24 with input as context
	o6_16.nitrogen_transfer(20) == 0 with input as context
	o6_16.nitrogen_transfer(100) == 80 with input as context
	o6_16.reduction_factor == 0.8 with input as context
}

test_forbidden_psm_detected if {
	violations := o6_16.decision.violations with input as {
		"farm": {"year": 2026, "region": {"federal_state": "Burgenland", "is_eastern_lower_austria_or_tullnerfeld": false, "bentazon_reauthorized": false}},
		"measure": {"requested": true, "first_participation_year": 2024, "participates_cover_intercrop": true, "participates_cover_evergreen": false, "participates_organic": false},
		"land": {"total_arable_area_ha": 10, "groundwater_arable_area_ha": 5, "parcels": [{"id": "p1", "kg_number": "32001", "in_groundwater_area": true, "crop_area_ha": 1, "crop_category": "maize", "psm_active_ingredients": ["Metazachlor"], "field_record_complete": true, "nitrogen_surplus_kg_per_ha": 0, "following_crop_reduction_kg_per_ha": 0, "following_crop_planted_by_11_15": true, "cover_crop_planted_by_11_15": false}]},
		"records": {"farm_planning_completed_by_02_28": true, "farm_balance_completed_by_next_01_31": true, "education_hours": 10, "education_provider_recognized": true, "education_completed_date": "2026-12-31", "water_protection_concept_complete": true, "soil_samples": [{"lab_accredited": true, "draw_date": "2024-01-01"}], "oo_ipm_inspection_or_warning_documented": true, "vienna_extra_education_hours": 0, "pig_feed_recipe_evidence": true, "cultan_field_records_complete": true, "cultan_external_service_evidence": true},
		"options": {"washout_risk": {"requested": false, "parcel_ids": []}, "vienna_humus": {"requested": false, "turning_tillage_other_than_after_maize": false, "recognized_carbon_project_confirmation": false}, "strong_n_reduced_pig_feeding": {"requested": false, "feed_categories": [], "also_claimed_in_liquid_manure_measure": false}, "cultan": {"requested": false, "has_ammonium_depot_injection": false, "external_equipment": false}, "psm_avoidance_surcharge": {"requested": false}},
	}
	"forbidden_plant_protection_active_ingredient" in violations
}

test_bentazon_reauthorization_path if {
	o6_16.forbidden_psm({
		"in_groundwater_area": true,
		"crop_category": "maize",
		"psm_active_ingredients": ["Bentazon"],
	}) with input as {
		"farm": {"year": 2026, "bentazon_reauthorized": true},
	}
}

test_upper_austria_specific_inputs if {
	violations := o6_16.decision.violations with input as {
		"farm": {"year": 2026, "region": {"federal_state": "Oberösterreich", "is_eastern_lower_austria_or_tullnerfeld": false, "bentazon_reauthorized": false}},
		"measure": {"requested": true, "participates_organic": false, "oo_variant_3_cover": true, "oo_chemical_psm_application": true},
		"land": {"groundwater_arable_area_ha": 2, "total_arable_area_ha": 10, "parcels": []},
		"records": {"oo_ipm_inspection_or_warning_documented": false, "soil_samples": []},
		"options": {},
	}
	"upper_austria_variant_3_not_allowed" in violations
	"upper_austria_ipm_precheck_missing" in violations
}

test_pig_gve_average_path if {
	violations := o6_16.decision.violations with input as {
		"farm": {"year": 2026, "region": {"federal_state": "Burgenland", "is_eastern_lower_austria_or_tullnerfeld": false, "bentazon_reauthorized": false}},
		"measure": {"requested": true, "participates_cover_intercrop": true, "participates_cover_evergreen": false, "participates_organic": false},
		"land": {"groundwater_arable_area_ha": 2, "total_arable_area_ha": 10, "parcels": []},
		"livestock": {"pig_gve_average": 5},
		"records": {"farm_planning_completed_by_02_28": true, "farm_balance_completed_by_next_01_31": true, "education_hours": 10, "education_provider_recognized": true, "education_completed_date": "2026-12-31", "water_protection_concept_complete": true, "soil_samples": []},
		"options": {"strong_n_reduced_pig_feeding": {"requested": true, "feed_categories": [], "also_claimed_in_liquid_manure_measure": false}},
	}
	"pig_option_requires_one_gve_per_ha_arable_land" in violations
}
