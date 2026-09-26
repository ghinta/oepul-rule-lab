package oepul.o6_14_test

import data.oepul.o6_14

# --- RGVE-Schluessel / Altersstichtag 1. Juli --------------------------------

rgve_of(animal) := r if {
	r := o6_14.rgve_per_head(animal) with input as mk_input(2026, [], [])
}

test_rgve_cattle_young if {
	rgve_of({"species": "cattle", "birth_date": "2025-01-15"}) == 0.6
}

test_rgve_cattle_calf if {
	rgve_of({"species": "cattle", "birth_date": "2026-02-01"}) == 0.4
}

test_rgve_cattle_adult if {
	rgve_of({"species": "cattle", "birth_date": "2024-07-01"}) == 1
}

test_rgve_dwarf_cattle_breed if {
	rgve_of({"species": "cattle", "breed": "Dexter", "birth_date": "2020-01-01"}) == 0.5
}

test_rgve_sheep_exactly_one_year_at_reference if {
	rgve_of({"species": "sheep", "birth_date": "2025-07-01"}) == 0.15
}

test_rgve_goat_young if {
	rgve_of({"species": "goat", "birth_date": "2025-07-02"}) == 0.07
}

test_rgve_equine_large_young if {
	rgve_of({"species": "equine", "equine_size_class": "large", "birth_date": "2024-09-01"}) == 0.6
}

test_rgve_equine_small_foal if {
	rgve_of({"species": "equine", "equine_size_class": "small", "birth_date": "2026-02-01"}) == 0.2
}

test_rgve_equine_small_adult if {
	rgve_of({"species": "equine", "equine_size_class": "small", "birth_date": "2020-02-01"}) == 0.5
}

test_rgve_camelid_young if {
	rgve_of({"species": "new_world_camelid", "birth_date": "2025-08-01"}) == 0.07
}

test_rgve_explicit_category_override if {
	rgve_of({"species": "cattle", "rgve_category_id": "cattle_ge_2y", "birth_date": "2026-01-01"}) == 1
}

test_pig_not_eligible_species if {
	notices := o6_14.animal_notices with input as mk_input(2026, [alm("A", 10)], [{"animal_id": "pig", "species": "pigs", "birth_date": "2024-01-01", "stays": [stay("A", "2026-06-01", "2026-09-01")]}])
	some n in notices
	n.rule_id == "O614-ANIMAL-001"
}

# --- Alpungstage und Anrechnung ------------------------------------------------

test_drive_down_day_not_counted if {
	o6_14.total_actual_days.cows == 120 with input as example_stocking_1
}

test_sheep_report_within_7_days_counts_from_drive_up if {
	inp := mk_input(2026, [alm("A", 10)], [sheep("s1", "2023-01-01", 1, [{"alm_id": "A", "drive_up_date": "2026-06-15", "drive_up_report_date": "2026-06-22", "drive_down_date": "2026-08-24", "drive_down_report_date": "2026-08-25"}])])
	o6_14.total_credited_days.s1 == 70 with input as inp
}

late_cattle := mk_input(2026, [alm("A", 10)], [cattle("c1", "2020-01-01", 1, [{"alm_id": "A", "drive_up_date": "2026-06-20", "drive_up_report_date": "2026-07-10", "drive_down_date": "2026-08-30", "drive_down_report_date": "2026-09-01"}])])

test_cattle_late_report_credits_14_days_before_report if {
	o6_14.total_actual_days.c1 == 71 with input as late_cattle
	o6_14.total_credited_days.c1 == 65 with input as late_cattle
}

test_cattle_late_report_flagged if {
	v := o6_14.reporting_violations with input as late_cattle
	some x in v
	x.rule_id == "O614-GRAZE-006"
}

test_very_late_report_below_60_days_no_premium if {
	inp := mk_input(2026, [alm("A", 10)], [cattle("c1", "2020-01-01", 1, [{"alm_id": "A", "drive_up_date": "2026-06-20", "drive_up_report_date": "2026-08-01", "drive_down_date": "2026-08-30", "drive_down_report_date": "2026-09-01"}])])
	not o6_14.animal_premium_eligible("c1") with input as inp
}

test_drive_up_after_15_july_not_recognised if {
	inp := mk_input(2026, [alm("A", 10)], [cattle("c1", "2020-01-01", 1, [stay("A", "2026-07-16", "2026-10-01")])])
	not o6_14.animal_premium_eligible("c1") with input as inp
	notices := o6_14.animal_notices with input as inp
	some n in notices
	n.rule_id == "O614-APPL-010"
}

test_interruptions_not_counted_but_summed if {
	inp := mk_input(2026, [alm("A", 10)], [cattle("c1", "2020-01-01", 1, [stay("A", "2026-06-01", "2026-07-01"), stay("A", "2026-07-10", "2026-08-09")])])
	o6_14.total_actual_days.c1 == 60 with input as inp
	o6_14.alm_occupied_days.A == 60 with input as inp
}

test_consecutive_animals_reach_alm_occupancy if {
	inp := mk_input(2026, [alm("A", 10)], [
		cattle("c1", "2020-01-01", 1, [stay("A", "2026-06-01", "2026-07-01"), stay("B", "2026-07-01", "2026-08-01")]),
		cattle("c2", "2020-01-01", 1, [stay("A", "2026-07-01", "2026-07-31"), stay("B", "2026-06-01", "2026-07-01")]),
	])
	o6_14.alm_occupied_days.A == 60 with input as inp
	o6_14.alm_min_occupancy_met("A") with input as inp
}

test_alm_below_60_days_violation if {
	inp := mk_input(2026, [alm("A", 10)], [cattle("c1", "2020-01-01", 5, [stay("A", "2026-06-01", "2026-07-20")])])
	v := o6_14.obligation_violations with input as inp
	some x in v
	x.rule_id == "O614-GRAZE-001"
	o6_14.alm_premium_area_ha.A == 0 with input as inp
}

test_presence_non_compliance_no_premium_and_report if {
	inp := mk_input(2026, [alm("A", 10)], [object.union(cattle("c1", "2020-01-01", 1, [stay("A", "2026-06-01", "2026-09-01")]), {"presence_compliant": false, "non_compliance_reported": false})])
	not o6_14.animal_premium_eligible("c1") with input as inp
	v := o6_14.reporting_violations with input as inp
	some x in v
	x.rule_id == "O614-GRAZE-008"
}

# --- Maximaler Viehbesatz: Beispiele Kapitel 5.2 ---------------------------------

test_example1_calves_not_counted if {
	approx(o6_14.alm_stocking_rgve.A, 18) with input as example_stocking_1
	approx(o6_14.alm_stocking_density.A, 1.8) with input as example_stocking_1
	not o6_14.overstocked("A") with input as example_stocking_1
}

test_example2_alm_a_overstocked if {
	approx(o6_14.alm_stocking_rgve.A, 21.83) with input as example_stocking_2
	approx(o6_14.alm_stocking_density.A, 2.18) with input as example_stocking_2
	o6_14.overstocked("A") with input as example_stocking_2
}

test_example2_alm_b_ok if {
	approx(o6_14.alm_stocking_rgve.B, 3.82) with input as example_stocking_2
	approx(o6_14.alm_stocking_density.B, 1.09) with input as example_stocking_2
	not o6_14.overstocked("B") with input as example_stocking_2
}

test_overstock_violation_reported if {
	v := o6_14.obligation_violations with input as example_stocking_2
	some x in v
	x.rule_id == "O614-STOCK-001"
	x.subject == "A"
}

test_born_after_1_july_excluded_from_stocking if {
	inp := mk_input(2026, [alm("A", 10)], [cattle("calf", "2026-07-05", 1, [stay("A", "2026-07-06", "2026-09-30")])])
	o6_14.alm_stocking_rgve.A == 0 with input as inp
}

test_foreign_area_relief_with_report if {
	a := object.union(alm("A", 10), {"foreign_adjacent_area_ha": 2, "foreign_area_report_submitted": true})
	inp := mk_input(2026, [a], [cattle("cows", "2019-01-01", 22, [stay("A", "2026-06-01", "2026-09-01")])])
	not o6_14.overstocked("A") with input as inp
}

test_foreign_area_no_relief_without_report if {
	a := object.union(alm("A", 10), {"foreign_adjacent_area_ha": 2, "foreign_area_report_submitted": false})
	inp := mk_input(2026, [a], [cattle("cows", "2019-01-01", 22, [stay("A", "2026-06-01", "2026-09-01")])])
	o6_14.overstocked("A") with input as inp
}
