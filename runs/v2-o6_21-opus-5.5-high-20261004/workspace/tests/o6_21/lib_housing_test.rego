package oepul.o6_21.lib_housing_test

import data.oepul.o6_21.fixtures
import data.oepul.o6_21.housing
import data.oepul.o6_21.lib

# --- Modulation (ATB 9.3 Beispiel: 220 ha → 99,09 %) -------------------------------------------

test_modulation_example_220_ha if {
	lib.r4(lib.modulation_factor(220)) == 0.9909
}

test_modulation_below_200_ha_is_full if {
	lib.modulation_factor(150) == 1
}

test_modulation_all_bands if {
	# 200*1 + 100*0.9 + 700*0.85 + 200*0.75 = 1035 → 1035/1200
	lib.r4(lib.modulation_factor(1200)) == 0.8625
}

# --- Tabellenzugriffe ----------------------------------------------------------------------------

test_weight_class_boundaries if {
	lib.space_row_for_weight(150).weight_class == "up_to_150kg"
	lib.space_row_for_weight(151).weight_class == "up_to_220kg"
	lib.space_row_for_weight(350).weight_class == "up_to_350kg"
	lib.space_row_for_weight(500).weight_class == "up_to_500kg"
	lib.space_row_for_weight(501).weight_class == "over_500kg"
}

test_lying_area_is_40_percent_of_total_in_table if {
	every row in data.o6_21.space_requirements {
		lib.r4(row.total_area_m2_per_animal * 0.4) == row.lying_area_m2_per_animal
	}
}

test_rgve_key_values if {
	lib.rgve_factor("lt_half_year", false) == 0.4
	lib.rgve_factor("half_to_2_years", false) == 0.6
	lib.rgve_factor("ge_2_years", false) == 1.0
	lib.rgve_factor("lt_half_year", true) == 0.2
	lib.rgve_factor("half_to_2_years", true) == 0.3
	lib.rgve_factor("ge_2_years", true) == 0.5
}

test_premium_rates_by_year if {
	lib.rate("standard", 2023) == 180.0
	lib.rate("standard", 2024) == 194.4
	lib.rate("standard", 2028) == 194.4
	lib.rate("reduced_overlap", 2023) == 150.0
	lib.rate("reduced_overlap", 2026) == 162.0
	lib.rate("supplement_solid_manure_composting", 2023) == 20.0
	lib.rate("supplement_solid_manure_composting", 2025) == 21.6
}

# --- Platzbedarf (Beispiele Informationsblatt Kapitel 6.3.1) -------------------------------------

test_example_five_bulls_over_500kg if {
	animals := [fixtures.bull(sprintf("AT%d", [i]), 600) | some i in numbers.range(1, 5)]
	inp := fixtures.with_animals(fixtures.base, animals)
	housing.required_total_area("B1") == 21 with input as inp
	housing.required_bedded_area("B1") == 8.4 with input as inp
}

cow(tag) := {
	"ear_tag": tag, "sex": "female", "birth_date": "2018-03-01", "on_farm_from": "2018-03-01",
	"on_farm_until": null, "is_cow": true, "stall_compartment_id": "B1",
}

young(tag, sex, w) := {
	"ear_tag": tag, "sex": sex, "birth_date": "2024-06-01", "on_farm_from": "2024-06-01",
	"on_farm_until": null, "current_weight_kg": w, "stall_compartment_id": "B1",
}

mixed_group(w) := array.concat(
	[cow(sprintf("C%d", [i])) | some i in numbers.range(1, 12)],
	array.concat(
		[young(sprintf("F%d", [i]), "female", w) | some i in numbers.range(1, 6)],
		[young(sprintf("M%d", [i]), "male", w) | some i in numbers.range(1, 6)],
	),
)

test_example_mixed_group_with_suckler_cows_300kg if {
	inp := fixtures.with_animals(fixtures.base, mixed_group(300))
	housing.required_total_area("B1") == 108 with input as inp
	housing.required_bedded_area("B1") == 43.2 with input as inp
	housing.table_lying_area("B1") == 43.2 with input as inp
}

test_example_mixed_group_heavier_than_350kg if {
	inp := fixtures.with_animals(fixtures.base, mixed_group(400))
	housing.required_total_area("B1") == 115.2 with input as inp
	housing.required_bedded_area("B1") == 46.08 with input as inp
}

test_insufficient_usable_area_flagged if {
	inp := fixtures.with_compartments(fixtures.base, [fixtures.compartment("B1", 16.0, 6.72)])
	"usable_area_insufficient" in housing.compartment_violations.B1 with input as inp
}

test_insufficient_bedded_area_flagged if {
	inp := fixtures.with_compartments(fixtures.base, [fixtures.compartment("B1", 16.8, 6.5)])
	"bedded_lying_area_insufficient" in housing.compartment_violations.B1 with input as inp
}

test_compliant_base_compartment if {
	count(housing.compartment_violations.B1) == 0 with input as fixtures.base
}

test_departed_animals_not_counted_for_occupancy if {
	gone := object.union(fixtures.bull("AT9", 600), {"on_farm_until": "2025-03-01"})
	inp := fixtures.with_animals(fixtures.base, [fixtures.bull("AT1", 520), gone])
	housing.required_total_area("B1") == 4.2 with input as inp
}

# --- Belegungsplan (Beispiel 25,50 m²) -----------------------------------------------------------

test_occupancy_plan_example_25_5_m2 if {
	plan := housing.max_occupancy(25.5)
	plan.over_500kg == 6
	plan.up_to_500kg == 7
	plan.up_to_350kg == 8
	plan.up_to_220kg == 10
	plan.up_to_150kg == 14
}

test_stall_sketch_required_until_2024 if {
	inp := fixtures.with_year(fixtures.base, 2024)
	housing.stall_sketch_missing with input as inp
}

test_stall_sketch_not_required_from_2025 if {
	not housing.stall_sketch_required with input as fixtures.base
	not housing.stall_sketch_missing with input as fixtures.base
}

# --- Liegefläche und Einstreu ----------------------------------------------------------------------

test_perforation_above_5_percent_not_closed if {
	c := object.union(fixtures.compartment("B1", 16.8, 6.72), {"lying_area_perforation_percent": 6})
	inp := fixtures.with_compartments(fixtures.base, [c])
	"lying_area_not_closed" in housing.compartment_violations.B1 with input as inp
}

test_perforation_5_percent_counts_as_closed if {
	c := object.union(fixtures.compartment("B1", 16.8, 6.72), {"lying_area_perforation_percent": 5})
	inp := fixtures.with_compartments(fixtures.base, [c])
	not "lying_area_not_closed" in housing.compartment_violations.B1 with input as inp
}

test_hard_surface_requires_3cm_bedding if {
	c := object.union(fixtures.compartment("B1", 16.8, 6.72), {"lying_surface_material": "hard_rubber", "bedding_depth_cm": 2})
	inp := fixtures.with_compartments(fixtures.base, [c])
	"bedding_insufficient" in housing.compartment_violations.B1 with input as inp
	c3 := object.union(c, {"bedding_depth_cm": 3})
	inp3 := fixtures.with_compartments(fixtures.base, [c3])
	not "bedding_insufficient" in housing.compartment_violations.B1 with input as inp3
}

test_soft_rubber_needs_no_minimum_depth if {
	c := object.union(fixtures.compartment("B1", 16.8, 6.72), {"lying_surface_material": "soft_rubber_or_plastic", "bedding_depth_cm": 0.5})
	inp := fixtures.with_compartments(fixtures.base, [c])
	not "bedding_insufficient" in housing.compartment_violations.B1 with input as inp
}

test_partial_areas_closed_off_flagged if {
	c := object.union(fixtures.compartment("B1", 16.8, 6.72), {"partial_areas_closed_except_routine_work": true})
	inp := fixtures.with_compartments(fixtures.base, [c])
	"partial_areas_closed_off" in housing.compartment_violations.B1 with input as inp
}

test_no_group_housing_flagged if {
	c := object.union(fixtures.compartment("B1", 16.8, 6.72), {"group_housing": false})
	inp := fixtures.with_compartments(fixtures.base, [c])
	"no_group_housing" in housing.compartment_violations.B1 with input as inp
}

# --- Stalldefinition --------------------------------------------------------------------------------

test_gravel_floor_is_not_a_stall if {
	c := object.union(fixtures.compartment("B1", 16.8, 6.72), {"building": object.union(fixtures.paved_building, {"floor_material": "gravel"})})
	inp := fixtures.with_compartments(fixtures.base, [c])
	"stall_definition_not_met" in housing.compartment_violations.B1 with input as inp
}

test_two_sided_enclosure_is_not_a_stall if {
	c := object.union(fixtures.compartment("B1", 16.8, 6.72), {"building": object.union(fixtures.paved_building, {"enclosed_sides_count": 2})})
	inp := fixtures.with_compartments(fixtures.base, [c])
	"stall_definition_not_met" in housing.compartment_violations.B1 with input as inp
}

test_liquid_excreta_require_container if {
	b := object.union(fixtures.paved_building, {"liquid_excreta_occur": true, "liquid_excreta_collectable": false})
	c := object.union(fixtures.compartment("B1", 16.8, 6.72), {"building": b})
	inp := fixtures.with_compartments(fixtures.base, [c])
	"stall_definition_not_met" in housing.compartment_violations.B1 with input as inp
}

test_open_stall_system_recognised if {
	b := {
		"is_open_stall_system": true, "solid_roof_over_lying_area": true,
		"surfaces_liquid_tight": true, "seepage_drain_to_collection_pit": true,
	}
	c := json.patch(fixtures.compartment("B1", 16.8, 6.72), [{"op": "replace", "path": "/building", "value": b}])
	inp := fixtures.with_compartments(fixtures.base, [c])
	not "stall_definition_not_met" in housing.compartment_violations.B1 with input as inp
}

test_open_stall_without_seepage_drain_rejected if {
	b := {
		"is_open_stall_system": true, "solid_roof_over_lying_area": true,
		"surfaces_liquid_tight": true, "seepage_drain_to_collection_pit": false,
	}
	c := json.patch(fixtures.compartment("B1", 16.8, 6.72), [{"op": "replace", "path": "/building", "value": b}])
	inp := fixtures.with_compartments(fixtures.base, [c])
	"stall_definition_not_met" in housing.compartment_violations.B1 with input as inp
}

# --- Mutterkuh-Liegeboxenlaufstall -------------------------------------------------------------------

suckler_compartment(creep) := object.union(fixtures.compartment("B1", 1, 0), {"suckler_cubicle_housing": {
	"applies": true,
	"meets_animal_welfare_act_space": true,
	"each_animal_over_6_months_has_legal_cubicle": true,
	"calves_have_additional_free_lying_place": true,
	"calf_creep_bedded_area_m2": creep,
}})

calf(tag) := {
	"ear_tag": tag, "sex": "male", "birth_date": "2025-10-01", "on_farm_from": "2025-10-01",
	"on_farm_until": null, "current_weight_kg": 120, "stall_compartment_id": "B1",
}

test_suckler_cubicle_exception_with_calf_creep if {
	inp := fixtures.with_compartments(
		fixtures.with_animals(fixtures.base, [cow("C1"), cow("C2"), calf("K1"), calf("K2")]),
		[suckler_compartment(1.44)],
	)

	# 2 Kälber bis 150 kg: 2 × 1,8 m² = 3,6 m² Gesamtfläche, davon 40 % = 1,44 m² eingestreut
	count(housing.compartment_violations.B1) == 0 with input as inp
}

test_suckler_calf_creep_too_small if {
	inp := fixtures.with_compartments(
		fixtures.with_animals(fixtures.base, [cow("C1"), calf("K1"), calf("K2")]),
		[suckler_compartment(1.4)],
	)
	"bedded_lying_area_insufficient" in housing.compartment_violations.B1 with input as inp
}
