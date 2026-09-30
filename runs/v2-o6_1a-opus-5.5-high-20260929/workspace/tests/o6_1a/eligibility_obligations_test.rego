package oepul.o6_1a.eligibility_obligations_test

import data.oepul.o6_1a
import data.oepul.o6_1a.eligibility
import data.oepul.o6_1a.general_obligations

ids(vs) := {v.rule_id | some v in vs}

base_farm(extra) := object.union({"year": 2026, "oepul": {"measures": ["1A"], "ubb": {"contract_start_year": 2024, "measure_application_date": "2023-12-20"}}}, extra)

# --- Vertragszeitraum / Beantragung ---
test_contract_period_by_start_year if {
	eligibility.contract_period == {"start": "2024-01-01", "years": 5, "end": "2028-12-31"} with input as {"farm": base_farm({})}
	eligibility.contract_period.years == 6 with input as {"farm": {"year": 2023, "oepul": {"ubb": {"contract_start_year": 2023}}}}
}

test_application_after_deadline if {
	inp := {"farm": {"year": 2025, "oepul": {"measures": ["1A"], "ubb": {"contract_start_year": 2025, "measure_application_date": "2025-01-05"}}}}
	"UBB-ANT-001" in ids(eligibility.violations) with input as inp
}

test_no_entry_after_2025 if {
	inp := {"farm": {"year": 2026, "oepul": {"measures": ["1A"], "ubb": {"contract_start_year": 2026, "measure_application_date": "2025-12-01"}}}}
	"UBB-ANT-002" in ids(eligibility.violations) with input as inp
}

# --- Kombination mit Bio / Nichtproduktive Ackerflächen ---
test_bio_combination_excluded if {
	inp := {"farm": {"year": 2026, "oepul": {"measures": ["1A", "1B"], "ubb": {"contract_start_year": 2023}}}}
	"UBB-KOMB-001" in ids(eligibility.violations) with input as inp
	not o6_1a.access_conditions_met with input as inp
}

test_bio_teilbetrieb_allowed if {
	inp := {"farm": {"year": 2026, "oepul": {"measures": ["1A", "1B"], "bio_teilbetrieb_wein_obst_hopfen": true, "ubb": {"contract_start_year": 2023}}}}
	not "UBB-KOMB-001" in ids(eligibility.violations) with input as inp
}

test_nichtproduktive_ackerflaechen_excluded_agroforst_allowed if {
	"UBB-KOMB-002" in ids(eligibility.violations) with input as {"farm": {"year": 2026, "oepul": {"measures": ["1A", "1C_nichtproduktive_ackerflaechen"]}}}
	not "UBB-KOMB-002" in ids(eligibility.violations) with input as {"farm": {"year": 2026, "oepul": {"measures": ["1A", "1C_agroforststreifen"]}}}
}

test_single_area_combination_table if {
	eligibility.single_area_combination("18") == "lse_only"
	eligibility.single_area_combination("23") == "x"
	eligibility.single_area_combination("14") == "none"
}

# --- Förderwerbende Person / Mindestgröße ---
test_public_body_excluded if {
	inp := {"farm": {"year": 2026, "oepul": {"measures": ["1A"], "applicant_type": "legal_person", "public_body_share": 0.3}}}
	"ATB-FWP-001" in ids(eligibility.violations) with input as inp
}

test_minimum_farm_size_first_year if {
	inp := {"farm": {"year": 2025, "oepul": {"first_oepul_year": 2025}}, "land": {"parcels": [{"parcel_id": "A", "area_ha": 1.2, "land_use": "arable"}]}}
	"ATB-MIN-001" in ids(eligibility.violations) with input as inp
	inp2 := {"farm": {"year": 2026, "oepul": {"first_oepul_year": 2025}}, "land": {"parcels": [{"parcel_id": "A", "area_ha": 1.2, "land_use": "arable"}]}}
	not "ATB-MIN-001" in ids(eligibility.violations) with input as inp2
}

test_takeover_deadline_2028_is_april_17 if {
	eligibility.takeover_deadline(2028) == "2028-04-17"
	eligibility.takeover_deadline(2026) == "2026-04-15"
	inp := {"farm": {"year": 2026, "oepul": {"ubb": {"takeover": {"application_date": "2026-04-16", "taken_over_area_ha": 10, "additional_area_ha": 2}}}}}
	"ATB-UEB-001" in ids(eligibility.violations) with input as inp
}

test_takeover_extension_over_50_percent if {
	inp := {"farm": {"year": 2026, "oepul": {"ubb": {"takeover": {"application_date": "2026-03-01", "taken_over_area_ha": 10, "additional_area_ha": 6}}}}}
	"ATB-UEB-002" in ids(eligibility.violations) with input as inp
}

test_conversion_to_bio_until_2025 if {
	eligibility.conversion_to_bio_without_repayment with input as {"farm": {"year": 2025, "oepul": {"ubb": {"conversion_to_bio_date": "2025-12-31"}}}}
	not eligibility.conversion_to_bio_without_repayment with input as {"farm": {"year": 2026, "oepul": {"ubb": {"conversion_to_bio_date": "2026-12-31"}}}}
}

# --- Grünlanderhaltung (UBB-GLE) ---
test_grassland_conversion_tolerance if {
	inp := {"farm": {"year": 2026, "oepul": {"ubb": {"grassland_conservation": {"first_year_grassland_ha": 20, "ploughed_previous_year_ha": 0.5, "current_grassland_ha": 19.4}}}}}
	"UBB-GLE-001" in ids(general_obligations.violations) with input as inp
	inp2 := {"farm": {"year": 2026, "oepul": {"ubb": {"grassland_conservation": {"first_year_grassland_ha": 20, "ploughed_previous_year_ha": 0, "current_grassland_ha": 19.0}}}}}
	not "UBB-GLE-001" in ids(general_obligations.violations) with input as inp2
}

test_inter_farm_swap_not_creditable if {
	inp := {"farm": {"year": 2026, "oepul": {"ubb": {"grassland_conservation": {"first_year_grassland_ha": 20, "current_grassland_ha": 20, "inter_farm_swap_gain_ha": 1.5}}}}}
	"UBB-GLE-001" in ids(general_obligations.violations) with input as inp
}

# --- Anbaudiversifizierung (UBB-AD) ---
arable(id, a, species) := {"parcel_id": id, "area_ha": a, "land_use": "arable", "crop": {"schlagnutzungsart": species, "botanical_species": species}}

test_cereal_maize_max_75 if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [arable("1", 4, "Weizen"), arable("2", 4, "Mais"), arable("3", 2, "Raps")]}}
	"UBB-AD-001" in ids(general_obligations.violations) with input as inp
}

test_single_crop_max_55 if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [arable("1", 6, "Weizen"), arable("2", 4, "Raps")]}}
	"UBB-AD-002" in ids(general_obligations.violations) with input as inp
}

test_diversification_not_applicable_up_to_5_ha if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [arable("1", 5, "Weizen")]}}
	count(general_obligations.violations) == 0 with input as inp
}

test_forage_and_fallow_exempt_from_55 if {
	inp := {"farm": {"year": 2025}, "land": {"parcels": [arable("1", 7, "Kleegras"), arable("2", 3, "Weizen")]}}
	not "UBB-AD-002" in ids(general_obligations.violations) with input as inp
	inp2 := {"farm": {"year": 2025}, "land": {"parcels": [arable("1", 7, "Grünbrache"), arable("2", 3, "Weizen")]}}
	not "UBB-AD-002" in ids(general_obligations.violations) with input as inp2
	inp3 := {"farm": {"year": 2024}, "land": {"parcels": [arable("1", 7, "Grünbrache"), arable("2", 3, "Weizen")]}}
	"UBB-AD-002" in ids(general_obligations.violations) with input as inp3
}

test_mixture_under_50_percent_cereal_not_cereal if {
	p := {"parcel_id": "1", "area_ha": 8, "land_use": "arable", "crop": {"schlagnutzungsart": "Erbsen-Getreide Gemenge", "botanical_species": "Gerste", "cereal_share_percent": 40}}
	inp := {"farm": {"year": 2026}, "land": {"parcels": [p, arable("2", 2, "Raps")]}}
	not "UBB-AD-001" in ids(general_obligations.violations) with input as inp
}

# --- Weiterbildung (UBB-WB) ---
test_training_three_hours if {
	ok := {"farm": {"year": 2026, "oepul": {"measures": ["1A"], "ubb": {"training": {"courses": [
		{"date": "2022-03-01", "hours": 2, "provider_recognized": true, "biodiversity_relevant": true},
		{"date": "2025-11-30", "hours": 1, "provider_recognized": true, "biodiversity_relevant": true, "attendee": "involved_person"},
	]}}}}}
	not "UBB-WB-001" in ids(general_obligations.violations) with input as ok
}

test_training_before_2022_and_double_credit_not_counted if {
	bad := {"farm": {"year": 2026, "oepul": {"measures": ["1A"], "ubb": {"training": {"courses": [
		{"date": "2021-12-01", "hours": 3, "provider_recognized": true, "biodiversity_relevant": true},
		{"date": "2024-01-10", "hours": 3, "provider_recognized": true, "biodiversity_relevant": true, "credited_to_other_obligation": true},
	]}}}}}
	"UBB-WB-001" in ids(general_obligations.violations) with input as bad
}
