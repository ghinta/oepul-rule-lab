package oepul.o6_6_test

import data.oepul.o6_6 as policy
import rego.v1

test_variant_2_valid if {
	decision := policy.decision with input as {
		"o6_6": {
			"application_year": 2026,
			"variant": 2,
			"sow_date": "2026-08-01",
			"break_date": "2027-02-15",
			"area_ha": 2,
			"arable_area_ha": 2,
			"land_use": "arable",
			"active_sowing": true,
			"full_coverage": true,
			"mixing_partner_count": 7,
			"plant_family_count": 3,
			"mineral_n_applied": false,
			"psm_applied": false,
			"mechanical_removal": true,
			"removal_done": true,
			"harvested_share": 1,
			"measure_application_date": "2025-12-31",
			"variant_application_date": "2026-08-31",
			"participates_immergruen": false,
		},
	}
	decision.eligible == true
	count(decision.violations) == 0
}

test_variant_1_2025_requires_seventy_days if {
	decision := policy.decision with input as {
		"o6_6": {
			"application_year": 2025,
			"variant": 1,
			"sow_date": "2025-08-10",
			"break_date": "2025-09-15",
			"days_between_sowing_and_break": 36,
			"area_ha": 2,
			"arable_area_ha": 2,
			"land_use": "arable",
			"full_coverage": true,
			"active_sowing": true,
			"mixing_partner_count": 5,
			"plant_family_count": 2,
			"insect_pollinated_partner_count": 5,
			"non_insect_pollinated_share": 0,
			"mineral_n_applied": false,
			"psm_applied": false,
			"mechanical_removal": true,
			"removal_done": true,
		},
	}
	violation_code(decision.violations, "INVALID_VARIANT_DATE")
}

test_variant_6_closed_crop_list if {
	decision := policy.decision with input as {
		"o6_6": {
			"application_year": 2026,
			"variant": 6,
			"sow_date": "2026-10-15",
			"break_date": "2027-03-21",
			"area_ha": 2,
			"arable_area_ha": 2,
			"land_use": "arable",
			"full_coverage": true,
			"active_sowing": true,
			"mixture_crops": ["Senf"],
			"mineral_n_applied": false,
			"psm_applied": false,
			"mechanical_removal": true,
			"removal_done": true,
		},
	}
	violation_code(decision.violations, "INVALID_VARIANT_6_CROPS")
}

test_variant_7_herbicide_restriction if {
	decision := policy.decision with input as {
		"o6_6": {
			"application_year": 2026,
			"variant": 7,
			"sow_date": "2026-09-15",
			"break_date": "2027-01-31",
			"area_ha": 2,
			"arable_area_ha": 2,
			"land_use": "arable",
			"crop": "winter_rape",
			"full_coverage": true,
			"active_sowing": true,
			"mixing_partner_count": 3,
			"plant_family_count": 2,
			"mineral_n_applied": false,
			"psm_applied": false,
			"herbicide_after_four_leaf_stage": true,
		},
	}
	violation_code(decision.violations, "VARIANT_7_HERBICIDE")
}

test_drought_2026_full_coverage_exception if {
	decision := policy.decision with input as {
		"o6_6": {
			"application_year": 2026,
			"variant": 3,
			"sow_date": "2026-08-20",
			"break_date": "2026-11-15",
			"area_ha": 2,
			"arable_area_ha": 2,
			"land_use": "arable",
			"active_sowing": true,
			"proper_installation": true,
			"full_coverage": false,
			"mixing_partner_count": 3,
			"plant_family_count": 2,
			"mineral_n_applied": false,
			"psm_applied": false,
			"mechanical_removal": true,
			"removal_done": true,
		},
	}
	not violation_code(decision.violations, "NOT_FULL_COVER")
}

violation_code(items, code) if {
	item := items[_]
	item.code == code
}
