package o6_7.greening_test

import data.o6_7
import data.o6_7.fixtures
import data.o6_7.greening

cc(id, start, end, partners) := {
	"segment_id": id,
	"kind": "catch_crop",
	"start_date": start,
	"end_date": end,
	"removal_method": "tillage_implement",
	"mixture": {"partner_count": partners, "plant_family_count": 2, "frost_killed_share": 0.3},
}

main(id, start, end) := {"segment_id": id, "kind": "main_crop", "start_date": start, "end_date": end}

main_open(id, start) := {"segment_id": id, "kind": "main_crop", "start_date": start}

test_fully_greened_farm_is_compliant if {
	greening.coverage_ok with input as fixtures.base
	count(greening.violations) == 0 with input as fixtures.base
	count(o6_7.violations) == 0 with input as fixtures.base
}

# Beispiel Merkblatt S. 4: Zwischenfrucht erst 40 Tage nach der Ernte -> 40 Tage unbegrünt.
test_example_catch_crop_after_40_days_counts_40_ungreened_days if {
	x := fixtures.parcel("X", 1, [
		main("h1", "2024-10-10", "2025-07-15"),
		cc("zf", "2025-08-24", "2025-10-13", 3),
		main_open("h2", "2025-10-20"),
	])
	inp := fixtures.with_parcel(x, 10)
	count(greening.ungreened.X) == 40 with input as inp
	some gv in greening.gap_violations with input as inp
	gv.gap_days == 40
	gv.max_days == 30
	greening.coverage_ok with input as inp
}

test_example_ungreened_share_over_15_percent_is_violation if {
	x := fixtures.parcel("X", 2, [
		main("h1", "2024-10-10", "2025-07-15"),
		cc("zf", "2025-08-24", "2025-10-13", 3),
		main_open("h2", "2025-10-20"),
	])
	inp := fixtures.with_parcel(x, 10)
	not greening.coverage_ok with input as inp
	"O67-COVER-85" in o6_7.violation_rule_ids with input as inp
}

# Beispiel Merkblatt S. 5: Zwischenfrucht nur 41 Tage -> gesamter Zeitraum unbegrünt.
test_example_catch_crop_41_days_whole_interval_ungreened if {
	x := fixtures.parcel("X", 1, [
		main("h1", "2024-10-10", "2025-07-15"),
		cc("zf", "2025-08-01", "2025-09-11", 3),
		main_open("h2", "2025-09-25"),
	])
	inp := fixtures.with_parcel(x, 10)
	count(greening.ungreened.X) == 72 with input as inp
}

test_main_to_main_within_50_days_is_greened if {
	x := fixtures.parcel("X", 5, [main("h1", "2024-10-10", "2025-07-15"), main_open("h2", "2025-09-03")])
	inp := fixtures.with_parcel(x, 10)
	not greening.ungreened.X with input as inp
	count(greening.gap_violations) == 0 with input as inp
}

test_main_to_main_51_days_is_gap_violation if {
	x := fixtures.parcel("X", 5, [main("h1", "2024-10-10", "2025-07-15"), main_open("h2", "2025-09-04")])
	inp := fixtures.with_parcel(x, 10)
	count(greening.ungreened.X) == 51 with input as inp
	"O67-GAP-MAX-PERIODS" in o6_7.violation_rule_ids with input as inp
}

test_catch_to_main_31_days_is_gap_violation if {
	x := fixtures.parcel("X", 1, [
		main("h1", "2024-10-10", "2025-07-15"),
		cc("zf", "2025-07-20", "2025-09-10", 3),
		main_open("h2", "2025-10-11"),
	])
	inp := fixtures.with_parcel(x, 10)
	count(greening.ungreened.X) == 31 with input as inp
}

test_exactly_15_percent_ungreened_is_allowed if {
	x := fixtures.parcel("X", 3, [main("h1", "2024-10-10", "2025-07-15"), main_open("h2", "2025-09-10")])
	inp := fixtures.farm(2025, [fixtures.good_parcel("A", 17), x])
	greening.max_ungreened_share == 0.15 with input as inp
	greening.coverage_ok with input as inp
}

test_above_15_percent_ungreened_is_violation if {
	x := fixtures.parcel("X", 3.1, [main("h1", "2024-10-10", "2025-07-15"), main_open("h2", "2025-09-10")])
	inp := fixtures.farm(2025, [fixtures.good_parcel("A", 16.9), x])
	not greening.coverage_ok with input as inp
}

test_catch_to_catch_zug_um_zug_is_allowed if {
	x := fixtures.parcel("X", 1, [
		main("h1", "2024-10-10", "2025-07-15"),
		cc("zf1", "2025-07-20", "2025-09-05", 3),
		cc("zf2", "2025-09-05", "2026-03-01", 3),
	])
	inp := fixtures.with_parcel(x, 10)
	not greening.ungreened.X with input as inp
}

test_catch_to_catch_with_gap_is_not_allowed if {
	x := fixtures.parcel("X", 1, [
		main("h1", "2024-10-10", "2025-07-15"),
		cc("zf1", "2025-07-20", "2025-09-05", 3),
		cc("zf2", "2025-09-07", "2026-03-01", 3),
	])
	inp := fixtures.with_parcel(x, 10)
	count(greening.ungreened.X) == 2 with input as inp
}

test_late_unvegetated_acquisition_excluded_from_base if {
	x := {
		"parcel_id": "X",
		"area_ha": 5,
		"land_use": "arable",
		"usage_category": "main_crop",
		"acquisition": {"acquired_date": "2025-11-02", "unvegetated_at_acquisition": true},
		"greening": {"segments": [main("h1", "2025-04-01", "2025-10-20")]},
	}
	inp := fixtures.with_parcel(x, 10)
	greening.base_area_ha == 10 with input as inp
	greening.coverage_ok with input as inp
}

test_acquisition_before_october_16_not_excluded if {
	x := {
		"parcel_id": "X",
		"area_ha": 5,
		"land_use": "arable",
		"usage_category": "main_crop",
		"acquisition": {"acquired_date": "2025-10-15", "unvegetated_at_acquisition": true},
		"greening": {"segments": [main("h1", "2025-04-01", "2025-10-20")]},
	}
	inp := fixtures.with_parcel(x, 10)
	greening.base_area_ha == 15 with input as inp
	not greening.coverage_ok with input as inp
}

test_other_arable_land_is_always_ungreened if {
	x := {"parcel_id": "X", "area_ha": 1, "land_use": "arable", "usage_category": "other_arable"}
	inp := fixtures.with_parcel(x, 10)
	count(greening.ungreened.X) == 365 with input as inp
	greening.coverage_ok with input as inp
}

test_gi_period_is_ungreened if {
	x := object.union(fixtures.good_parcel("X", 1), {"gi_periods": [{"start_date": "2025-03-01", "end_date": "2025-03-10"}]})
	inp := fixtures.with_parcel(x, 10)
	count(greening.ungreened.X) == 10 with input as inp
}

test_green_fallow_counts_as_greened if {
	x := fixtures.parcel("X", 5, [{"segment_id": "gb", "kind": "green_fallow", "start_date": "2023-04-01"}])
	inp := fixtures.with_parcel(x, 10)
	not greening.ungreened.X with input as inp
}

test_nat_self_greening_over_50_days_ungreened if {
	x := fixtures.parcel("X", 1, [{
		"segment_id": "nat",
		"kind": "nat_self_greening",
		"start_date": "2023-01-01",
		"tillage_date": "2025-04-01",
		"full_regreening_date": "2025-06-01",
	}])
	inp := fixtures.with_parcel(x, 10)
	count(greening.ungreened.X) == 61 with input as inp
	"O67-NAT-SELF-GREENING" in o6_7.violation_rule_ids with input as inp
}

test_nat_self_greening_within_50_days_is_valid_main_crop if {
	x := fixtures.parcel("X", 1, [{
		"segment_id": "nat",
		"kind": "nat_self_greening",
		"start_date": "2023-01-01",
		"tillage_date": "2025-04-01",
		"full_regreening_date": "2025-05-15",
	}])
	inp := fixtures.with_parcel(x, 10)
	not greening.ungreened.X with input as inp
}

test_open_trailing_gap_beyond_50_days_is_ungreened if {
	x := fixtures.parcel("X", 1, [main("h1", "2024-10-10", "2025-10-01")])
	inp := fixtures.with_parcel(x, 10)
	count(greening.ungreened.X) == 42 with input as inp
}

test_leading_period_without_culture_is_ungreened if {
	x := fixtures.parcel("X", 1, [main_open("mais", "2025-04-20")])
	inp := fixtures.with_parcel(x, 10)
	count(greening.ungreened.X) == 109 with input as inp
}

drought_input(flag) := fixtures.farm(2026, [
	fixtures.parcel("A", 10, [
		main("ww", "2025-10-10", "2026-07-15"),
		cc("zfa", "2026-07-25", "2027-02-20", 3),
	]),
	fixtures.parcel("X", 5, [
		main("h1", "2025-10-10", "2026-07-10"),
		object.union(cc("zf", "2026-08-20", "2027-02-20", 3), {"drought_2026_late_sowing_justified": flag}),
	]),
])

test_drought_2026_justified_late_catch_crop_no_gap if {
	count(greening.gap_violations) == 0 with input as drought_input(true)
	greening.coverage_ok with input as drought_input(true)
}

test_drought_2026_unjustified_late_catch_crop_is_gap if {
	count(greening.gap_violations) == 1 with input as drought_input(false)
}

test_undersown_catch_crop_starts_at_host_harvest if {
	x := fixtures.parcel("X", 1, [
		main("mais", "2025-04-20", "2025-09-10"),
		{
			"segment_id": "us",
			"kind": "catch_crop",
			"is_undersown": true,
			"start_date": "2025-06-01",
			"undersown_host_harvest_date": "2025-09-10",
			"end_date": "2026-03-01",
			"removal_method": "direct_or_mulch_or_striptill_sowing",
			"mixture": {"partner_count": 3, "plant_family_count": 2, "frost_killed_share": 0.2},
		},
	])
	inp := fixtures.farm(2025, [fixtures.good_parcel("A", 10), x])
	count(greening.ungreened.X) == 109 with input as inp
}
