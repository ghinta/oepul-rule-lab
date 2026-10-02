package oepul.o6_17_test

import rego.v1

import data.oepul.o6_17

# --- Vertragszeitraum -------------------------------------------------------

test_contract_period_2023_six_years if {
	o6_17.contract_years == 6 with input as base_input
	o6_17.contract_end == "2028-12-31" with input as base_input
}

test_contract_period_2025_four_years if {
	o6_17.contract_years == 4 with input as with_measure({"contract_start_year": 2025, "measure_application_date": "2024-12-31"})
}

test_entry_2026_not_possible if {
	inp := with_measure({"contract_start_year": 2026, "measure_application_date": "2025-12-01"})
	not o6_17.valid_entry_year with input as inp
	some v in o6_17.access_violations with input as inp
	v.rule_id == "O617-APP-LAST-ENTRY"
}

test_application_deadline_missed if {
	inp := with_measure({"contract_start_year": 2025, "measure_application_date": "2025-01-05"})
	some v in o6_17.access_violations with input as inp
	v.rule_id == "O617-APP-DEADLINE"
}

test_application_deadline_met if {
	o6_17.application_timely with input as with_measure({"contract_start_year": 2025, "measure_application_date": "2024-12-31"})
}

test_agl_contract_period_calendar_year if {
	o6_17.agl_contract_period == {"start": "2025-01-01", "end": "2025-12-31"} with input as base_input
}

# --- Kombinationsverpflichtung --------------------------------------------

test_combination_with_ubb_met if {
	o6_17.combination_requirement_met with input as base_input
}

test_combination_with_bio_met if {
	inp := object.union(base_input, {"farm": object.union(base_input.farm, {"oepul": object.union(base_input.farm.oepul, {"measures": [{"measure_id": "o6_1b", "is_bio_partial_farm": true}]})})})
	o6_17.combination_requirement_met with input as inp
}

test_combination_missing_is_access_violation if {
	inp := object.union(base_input, {"farm": object.union(base_input.farm, {"oepul": object.union(base_input.farm.oepul, {"measures": [{"measure_id": "o6_17"}]})})})
	some v in o6_17.access_violations with input as inp
	v.rule_id == "O617-ACC-COMBINATION"
	o6_17.no_premium_due_to_access with input as inp
	not o6_17.premium_payable with input as inp
}

# --- Mindestteilnahme / tierhaltender Betrieb (erstes Jahr) ------------------

first_year := with_year(2023)

test_first_year_all_access_conditions_met if {
	o6_17.is_first_commitment_year with input as first_year
	o6_17.access_conditions_met with input as first_year
	o6_17.contract_concluded with input as first_year
}

test_grassland_share_computed if {
	o6_17.grassland_share == 0.7 with input as base_input
}

test_min_grassland_area_violation_first_year if {
	inp := object.union(first_year, {"land": object.union(first_year.land, {"grassland_area_ha": 1.9})})
	some v in o6_17.access_violations with input as inp
	v.rule_id == "O617-ACC-MIN-GRASSLAND"
	not o6_17.contract_concluded with input as inp
}

test_min_grassland_not_required_in_later_years if {
	inp := object.union(base_input, {"land": object.union(base_input.land, {"grassland_area_ha": 1.5})})
	not o6_17.is_first_commitment_year with input as inp
	count({v | some v in o6_17.access_violations; v.rule_id == "O617-ACC-MIN-GRASSLAND"}) == 0 with input as inp
}

test_grassland_share_excludes_alpine_pasture if {
	inp := object.union(first_year, {"land": object.union(first_year.land, {"total_area_ha": 30.0, "alpine_pasture_area_ha": 15.0, "grassland_area_ha": 6.0})})
	o6_17.grassland_share == 0.4 with input as inp
	o6_17.grassland_share_met with input as inp
}

test_grassland_share_below_40_percent if {
	inp := object.union(first_year, {"land": object.union(first_year.land, {"total_area_ha": 20.0, "grassland_area_ha": 7.0})})
	some v in o6_17.access_violations with input as inp
	v.rule_id == "O617-ACC-GRASSLAND-SHARE"
}

test_rgve_and_feed_area if {
	o6_17.rgve_total == 5 with input as base_input

	# Futterfläche = Grünland (6 + 1) + Kleegras (3)
	o6_17.feed_area_ha == 10 with input as base_input
	o6_17.livestock_density == 0.5 with input as base_input
	o6_17.is_livestock_farm with input as base_input
}

test_livestock_threshold_not_met if {
	inp := object.union(first_year, {"livestock": {"has_livestock": true, "species_groups": [{"species": "sheep_goats", "rgve_category": "sheep_ge_1y", "animal_count": 19}]}})

	# 19 * 0,15 = 2,85 RGVE / 10 ha = 0,285 < 0,30
	not o6_17.is_livestock_farm with input as inp
	some v in o6_17.access_violations with input as inp
	v.rule_id == "O617-ACC-LIVESTOCK"
}

test_livestock_threshold_exactly_met if {
	inp := object.union(first_year, {"livestock": {"has_livestock": true, "species_groups": [{"species": "sheep_goats", "rgve_category": "sheep_ge_1y", "animal_count": 20}]}})
	o6_17.is_livestock_farm with input as inp
}

test_pigs_do_not_count_as_rgve if {
	inp := object.union(base_input, {"livestock": {"has_livestock": true, "species_groups": [{"species": "pigs", "rgve_category": "pigs_breeding_sows_ge_50kg", "animal_count": 100}]}})
	o6_17.rgve_total == 0 with input as inp
	not o6_17.is_livestock_farm with input as inp
}

test_animals_abroad_not_counted if {
	inp := object.union(base_input, {"livestock": {"has_livestock": true, "species_groups": [{"species": "cattle", "rgve_category": "cattle_ge_2y", "animal_count": 5, "kept_in_austria": false}]}})
	o6_17.rgve_total == 0 with input as inp
}

test_rgve_key_horses_and_camelids if {
	inp := object.union(base_input, {"livestock": {"has_livestock": true, "species_groups": [
		{"species": "horses", "rgve_category": "horse_large_adult_ge_3y", "animal_count": 2},
		{"species": "other", "rgve_category": "new_world_camelids_ge_1y", "animal_count": 4},
	]}})
	o6_17.rgve_total == 2.6 with input as inp
}

test_sonstige_gruenlandflaechen_not_feed_area if {
	other := object.union(single_cut, {"parcel_id": "S1", "oepul": {"field_use_type": "sonstige_gruenlandflaechen"}})
	o6_17.feed_area_ha == 10 with input as with_parcels([meadow, single_cut, clover, other])
}
