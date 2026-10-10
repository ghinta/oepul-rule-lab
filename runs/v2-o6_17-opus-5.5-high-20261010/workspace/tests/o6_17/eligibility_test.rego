package oepul.o6_17.eligibility_test

import data.oepul.o6_17.eligibility
import data.oepul.o6_17.fixtures
import data.oepul.o6_17.livestock

test_base_farm_meets_access_requirements if {
	eligibility.access_requirements_met with input as fixtures.base_input
	eligibility.consequence == "none" with input as fixtures.base_input
}

test_combination_requires_ubb_or_bio if {
	inp := object.union(fixtures.base_input, {"farm": {"oepul": {"participating_measures": ["17", "3"]}}})
	"combination_ubb_bio_missing" in eligibility.access_failures with input as inp
	eligibility.consequence == "no_contract" with input as inp
}

test_bio_teilbetrieb_fulfils_combination if {
	inp := object.union(fixtures.base_input, {"farm": {"oepul": {"participating_measures": ["1B_TB", "17"]}}})
	eligibility.combination_fulfilled with input as inp
}

test_missing_combination_in_later_year_only_blocks_premium if {
	inp := object.union(fixtures.with_year(2026), {"farm": {"oepul": {"participating_measures": ["17"]}}})
	eligibility.consequence == "no_premium_in_application_year" with input as inp
}

test_min_grassland_2ha_only_first_year if {
	small := [object.union(fixtures.parcel_g1, {"area_ha": 1.5}), fixtures.parcel_a1]
	inp := fixtures.with_parcels(small)
	"min_grassland_2ha_first_year" in eligibility.access_failures with input as inp
	later := object.union(inp, {"farm": {"year": 2026}})
	not "min_grassland_2ha_first_year" in eligibility.access_failures with input as later
}

test_grassland_share_below_40_percent_first_year if {
	big_arable := object.union(fixtures.parcel_a2, {"area_ha": 12.0})
	inp := fixtures.with_parcels([fixtures.parcel_g1, fixtures.parcel_g2, fixtures.parcel_a1, big_arable])
	"grassland_share_40_percent_first_year" in eligibility.access_failures with input as inp
}

test_alpine_pasture_excluded_from_grassland_share if {
	alm := {"parcel_id": "L1", "area_ha": 50.0, "land_use": "alpine_pasture"}
	inp := fixtures.with_parcels([fixtures.parcel_g1, fixtures.parcel_g2, fixtures.parcel_a1, alm])
	eligibility.grassland_share_ok with input as inp
}

test_livestock_holding_threshold if {
	few := object.union(fixtures.base_input, {"livestock": {"species_groups": [{"rgve_category": "rinder_ab_2_jahre", "animal_count": 2}]}})
	livestock.rgve_total == 2 with input as few
	not livestock.is_livestock_holding with input as few
	"livestock_holding_first_year" in eligibility.access_failures with input as few
}

test_livestock_abroad_not_counted if {
	abroad := object.union(fixtures.base_input, {"livestock": {"species_groups": [{"rgve_category": "rinder_ab_2_jahre", "animal_count": 5, "kept_in_austria": false}]}})
	livestock.rgve_total == 0 with input as abroad
}

test_rgve_key_sheep_and_horses if {
	mixed := object.union(fixtures.base_input, {"livestock": {"species_groups": [
		{"rgve_category": "schafe_ab_1_jahr", "animal_count": 10},
		{"rgve_category": "pferde_gross_ab_3_jahre", "animal_count": 2},
		{"rgve_category": "neuweltkamele_wild_unter_1_jahr", "animal_count": 10},
	]}})
	livestock.rgve_total == 4.2 with input as mixed
}

test_arable_fodder_counts_as_fodder_area if {
	livestock.fodder_area_ha == 8.5 with input as fixtures.base_input
}

test_late_measure_application if {
	inp := fixtures.with_o6({"measure_application_date": "2025-01-10"})
	"measure_application_late" in eligibility.access_failures with input as inp
}

test_entry_after_2025_not_possible if {
	inp := object.union(fixtures.with_o6({"contract_start_year": 2026, "measure_application_date": "2025-12-01"}), {"farm": {"year": 2026}})
	"invalid_contract_start_year" in eligibility.access_failures with input as inp
}

test_public_body_not_eligible if {
	inp := object.union(fixtures.base_input, {"farm": {"applicant": {"legal_form": "public_body"}}})
	"applicant_not_eligible" in eligibility.access_failures with input as inp
	inp2 := object.union(fixtures.base_input, {"farm": {"applicant": {"legal_form": "legal_person", "public_body_share_percent": 30}}})
	"applicant_not_eligible" in eligibility.access_failures with input as inp2
}

test_farm_minimum_size_first_oepul_year if {
	tiny := object.union(fixtures.with_parcels([object.union(fixtures.parcel_g1, {"area_ha": 1.2})]), {"farm": {"oepul": {"first_oepul_participation_year": 2025}}})
	"farm_minimum_size_first_oepul_year" in eligibility.access_failures with input as tiny
}
