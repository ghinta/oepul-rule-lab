# Testdaten für System Immergrün (o6_7).
package o6_7.fixtures

good_catch_crop := {
	"segment_id": "zf",
	"kind": "catch_crop",
	"start_date": "2025-07-25",
	"end_date": "2026-02-20",
	"removal_method": "tillage_implement",
	"mixture": {
		"partner_count": 3,
		"plant_family_count": 2,
		"frost_killed_share": 0.5,
		"cereal_maize_share": 0,
	},
}

wheat := {
	"segment_id": "ww",
	"kind": "main_crop",
	"start_date": "2024-10-10",
	"end_date": "2025-07-15",
	"declared_in_mfa": true,
}

parcel(pid, area, segments) := {
	"parcel_id": pid,
	"area_ha": area,
	"land_use": "arable",
	"usage_category": "main_crop",
	"harvested_share": 1,
	"greening": {"segments": segments},
}

good_parcel(pid, area) := parcel(pid, area, [wheat, good_catch_crop])

farm(year, parcels) := {
	"farm": {
		"year": year,
		"region": {"federal_state": "Oberösterreich", "district": "Linz-Land"},
		"applicant": {"legal_form": "natural_person", "is_active_farmer": true},
		"oepul": {
			"first_participation_year": 2023,
			"participations": [{"measure_code": "7"}],
			"o6_7": {"application_date": "2023-12-15", "first_contract_year": 2024},
		},
	},
	"land": {
		"total_area_ha": sum([p.area_ha | some p in parcels]),
		"parcels": parcels,
	},
	"documentation": {"field_records_complete": true},
}

base := farm(2025, [good_parcel("A", 10), good_parcel("B", 10)])

# Eingabe mit einem zusätzlichen Schlag X und den Standardschlägen A und B.
with_parcel(extra, base_area) := farm(2025, [good_parcel("A", base_area), extra])
