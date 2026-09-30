package oepul.o6_1a.common_livestock_test

import data.oepul.o6_1a.common
import data.oepul.o6_1a.livestock

approx(a, b) if abs(a - b) < 0.0001

# --- Prämiensätze nach Jahr (UBB-PR-*) ---
test_rate_acker_basis_by_year if {
	common.rate("acker_basis") == 70.0 with input as {"farm": {"year": 2023}}
	common.rate("acker_basis") == 75.6 with input as {"farm": {"year": 2024}}
	common.rate("acker_basis") == 85.0 with input as {"farm": {"year": 2026}}
}

test_rate_new_components_only_from_2025 if {
	not common.rate("pheromonfallen") with input as {"farm": {"year": 2024}}
	common.rate("pheromonfallen") == 150.0 with input as {"farm": {"year": 2025}}
	common.rate("gruenland_altgras") == 150.0 with input as {"farm": {"year": 2027}}
	common.rate("acker_divrs_gruenbrache") == 324.0 with input as {"farm": {"year": 2025}}
}

test_rate_gruenlandzahl_steps if {
	common.rate("gruenland_div_gruenlandzahl") == 54.0 with input as {"farm": {"year": 2024}}
	common.rate("gruenland_div_gruenlandzahl") == 100.0 with input as {"farm": {"year": 2025}}
}

# --- Vollständigkeit der Datentabellen ---
test_tables_complete if {
	count(data.o6_1a.o6_1a_rare_crop_varieties) == 85
	count(data.o6_1a.o6_1a_regional_seed_species_arable) == 74
	count(data.o6_1a.o6_1a_regional_seed_species_grassland) == 68
	count(data.o6_1a.o6_1a_bhg_crops) == 53
	count(data.o6_1a.o6_1a_premium_rates) == 30
}

test_soblus_only_from_2025 if {
	some r in data.o6_1a.o6_1a_rare_crop_varieties
	r.variety == "Soblus"
	r.from_year == 2025
	r.premium_level == "A"
}

# --- Datumsfunktionen ---
test_days_between_divnfz_example if {
	common.days_between("2026-06-24", "2026-08-27") == 64
}

test_shift_date if {
	common.shift_date("2026-06-15", -10) == "2026-06-05"
}

# --- Tierhaltender Betrieb (UBB-TH-001..003) ---
test_livestock_farm_threshold if {
	inp := {
		"farm": {"year": 2026},
		"land": {"parcels": [{"parcel_id": "G", "area_ha": 10, "land_use": "grassland", "crop": {"schlagnutzungsart": "Mähwiese/-weide zwei Nutzungen"}}]},
		"livestock": {"species_groups": [{"species": "cattle", "rgve_category": "rinder_ab_2", "animal_count": 3}]},
	}
	livestock.is_livestock_farm with input as inp
	approx(livestock.stocking_density, 0.3) with input as inp
}

test_not_livestock_farm_below_threshold if {
	inp := {
		"farm": {"year": 2026},
		"land": {"parcels": [{"parcel_id": "G", "area_ha": 10, "land_use": "grassland", "crop": {"schlagnutzungsart": "Mähwiese/-weide zwei Nutzungen"}}]},
		"livestock": {"species_groups": [{"species": "sheep_goats", "rgve_category": "schafe_ab_1", "animal_count": 19}]},
	}
	not livestock.is_livestock_farm with input as inp
}

test_pigs_do_not_count_as_rgve if {
	inp := {
		"farm": {"year": 2026},
		"land": {"parcels": [{"parcel_id": "G", "area_ha": 1, "land_use": "grassland", "crop": {"schlagnutzungsart": "Mähwiese/-weide zwei Nutzungen"}}]},
		"livestock": {"species_groups": [{"species": "pigs", "rgve_category": "zucht_jungsauen_ab_50kg", "animal_count": 50}]},
	}
	not livestock.is_livestock_farm with input as inp
	"zucht_jungsauen_ab_50kg" in livestock.unknown_categories with input as inp
}

test_forage_area_includes_arable_forage if {
	inp := {
		"farm": {"year": 2026},
		"land": {"parcels": [
			{"parcel_id": "G", "area_ha": 2, "land_use": "grassland", "crop": {"schlagnutzungsart": "Mähwiese/-weide zwei Nutzungen"}},
			{"parcel_id": "K", "area_ha": 3, "land_use": "arable", "crop": {"schlagnutzungsart": "Kleegras"}},
			{"parcel_id": "W", "area_ha": 5, "land_use": "arable", "crop": {"schlagnutzungsart": "Winterweizen"}},
		]},
		"livestock": {"species_groups": [{"species": "horses", "rgve_category": "pferde_gross_ab_3", "animal_count": 2}]},
	}
	livestock.forage_area_ha == 5 with input as inp
	approx(livestock.stocking_density, 0.4) with input as inp
}
