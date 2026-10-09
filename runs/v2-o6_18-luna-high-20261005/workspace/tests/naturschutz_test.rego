package oepul.o6_18_test

import data.oepul.o6_18
import rego.v1

test_valid_ga09_parcel if {
	result := o6_18.decision with input as {
		"farm": {"year": 2026},
		"land": {"total_area_ha": 20, "parcels": [{"land_use": "grassland", "project_confirmation": true, "naturschutz_codes": [{"code": "GA09"}]}]},
		"application": {"measure": "o6_18", "nat_code": true, "nature_reference_area": true},
	}
	result.eligible
	result.violations == []
	result.premium_eur_ha == 410.4
}

test_missing_project_confirmation_fails if {
	result := o6_18.decision with input as {
		"land": {"parcels": [{"land_use": "grassland", "naturschutz_codes": [{"code": "GA09"}]}]},
		"application": {"measure": "o6_18", "nat_code": true, "nature_reference_area": true},
	}
	"project_confirmation_required" in result.violations
	not result.eligible
}

test_gl06_requires_monitoring if {
	result := o6_18.decision with input as {
		"land": {"parcels": [{"land_use": "grassland", "project_confirmation": true, "naturschutz_codes": [{"code": "GL06"}]}]},
		"application": {"measure": "o6_18", "nat_code": true, "nature_reference_area": true},
	}
	"phenology_monitoring_required" in result.violations
}

test_incompatible_chapters_fail if {
	result := o6_18.decision with input as {
		"land": {"parcels": [{"land_use": "grassland", "project_confirmation": true, "naturschutz_codes": [{"code": "GA09"}, {"code": "WA01"}]}]},
		"application": {"measure": "o6_18", "nat_code": true, "nature_reference_area": true},
	}
	"incompatible_annex_j_chapters" in result.violations
}

test_2026_naturschutz_date_exception if {
	result := o6_18.decision with input as {
		"farm": {"year": 2026},
		"land": {"parcels": [{"land_use": "grassland", "project_confirmation": true, "naturschutz_codes": [{"code": "GA09"}]}]},
		"application": {"measure": "o6_18", "nat_code": true, "nature_reference_area": true, "naturschutz_date_exception": true, "use_date": "2026-08-12"},
	}
	result.eligible
}

test_2026_automatic_higher_force_uses_state_data if {
	result := o6_18.decision with input as {
		"farm": {"year": 2026, "region": {"federal_state": "Burgenland", "district": "Eisenstadt-Umgebung"}},
		"land": {"parcels": [{"land_use": "arable", "harvested_percent": 50, "project_confirmation": true, "naturschutz_codes": [{"code": "GA09"}]}]},
		"application": {"measure": "o6_18", "nat_code": true, "nature_reference_area": true, "drought_no_harvestable_stock": true},
	}
	not "harvest_requirement" in result.violations
}

test_2026_automatic_higher_force_rejects_unlisted_state if {
	result := o6_18.decision with input as {
		"farm": {"year": 2026, "region": {"federal_state": "Tirol", "district": "Innsbruck-Land"}},
		"land": {"parcels": [{"land_use": "arable", "harvested_percent": 50, "project_confirmation": true, "naturschutz_codes": [{"code": "GA09"}]}]},
		"application": {"measure": "o6_18", "nat_code": true, "nature_reference_area": true, "drought_no_harvestable_stock": true},
	}
	"harvest_requirement" in result.violations
}

test_2026_early_arable_use_requires_data_code if {
	result := o6_18.decision with input as {
		"farm": {"year": 2026},
		"land": {"parcels": [{"land_use": "arable", "project_confirmation": true, "naturschutz_codes": [{"code": "GA09"}]}]},
		"application": {"measure": "o6_18", "nat_code": true, "nature_reference_area": true, "early_arable_biodiversity_use": true},
	}
	"early_arable_use_requires_op_code" in result.violations
}
