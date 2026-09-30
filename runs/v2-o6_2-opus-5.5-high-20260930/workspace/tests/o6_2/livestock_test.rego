package oepul.o6_2_test

import data.oepul.o6_2

test_rgve_and_density_base if {
	r1 := o6_2.total_rgve with input as base_input
	r1 == 20
	r2 := o6_2.fodder_area_ha with input as base_input
	r2 == 20
	r3 := o6_2.stocking_density_rgve_per_ha with input as base_input
	r3 == 1
	o6_2.is_livestock_farm with input as base_input
	r4 := o6_2.rgve_band with input as base_input
	r4 == "lt_1_4"
}

test_livestock_threshold_exactly_0_3 if {
	# 6 RGVE auf 20 ha = 0,30 RGVE/ha -> tierhaltend
	inp := json.patch(base_input, [{"op": "replace", "path": "/livestock/species_groups/0/animal_count", "value": 6}])
	o6_2.is_livestock_farm with input as inp
}

test_below_threshold_non_livestock if {
	# 10 Schafe ab 1 Jahr = 1,5 RGVE auf 20 ha = 0,075 RGVE/ha
	inp := json.patch(base_input, [{"op": "replace", "path": "/livestock/species_groups/0", "value": {"species": "sheep_goats", "rgve_key_id": "sheep_ge_1y", "animal_count": 10}}])
	not o6_2.is_livestock_farm with input as inp
	r5 := o6_2.livestock_status with input as inp
	r5 == "non_livestock"
}

test_band_ge_1_4 if {
	inp := json.patch(base_input, [{"op": "replace", "path": "/livestock/species_groups/0/animal_count", "value": 28}])
	r6 := o6_2.rgve_band with input as inp
	r6 == "ge_1_4"
}

test_large_horse_and_dwarf_cattle_factors if {
	inp := json.patch(base_input, [{"op": "replace", "path": "/livestock/species_groups", "value": [
		{"species": "horses", "rgve_key_id": "horses_large_ge_3y", "animal_count": 2},
		{"species": "cattle", "rgve_key_id": "dwarf_cattle_ge_2y", "animal_count": 4},
		{"species": "other", "rgve_key_id": "red_deer_ge_1y", "animal_count": 4},
	]}])
	r7 := o6_2.total_rgve with input as inp
	r7 == 5
}

test_pigs_do_not_count_as_rgve if {
	inp := json.patch(base_input, [{"op": "add", "path": "/livestock/species_groups/-", "value": {"species": "pigs", "rgve_key_id": "pigs_young_fattening_ge_32kg", "animal_count": 100}}])
	r8 := o6_2.total_rgve with input as inp
	r8 == 20
}

test_animals_abroad_not_counted if {
	inp := json.patch(base_input, [{"op": "replace", "path": "/livestock/species_groups/0/held_in_austria", "value": false}])
	r9 := o6_2.total_rgve with input as inp
	r9 == 0
	not o6_2.is_livestock_farm with input as inp
}

test_second_crop_forage_not_in_fodder_area if {
	inp := with_parcel(1, "crop/forage_as_second_crop", true)
	r10 := o6_2.fodder_area_ha with input as inp
	r10 == 15
}

test_unmapped_species_reported if {
	inp := json.patch(base_input, [{"op": "remove", "path": "/livestock/species_groups/0/rgve_key_id"}])
	"cattle" in o6_2.unmapped_species_groups with input as inp
}

test_nitrogen_per_ha_with_alm_deduction if {
	inp := json.patch(base_input, [{"op": "replace", "path": "/livestock/nitrogen", "value": {"n_after_stall_storage_losses_kg": 6000, "n_on_alm_or_community_pasture_kg": 1200, "manure_offtake_contract_n_kg": 3000}}])
	r11 := o6_2.n_per_ha with input as inp
	r11 == 160
	not o6_2.nitrogen_limit_exceeded with input as inp
}

test_nitrogen_limit_exceeded_offtake_contracts_ignored if {
	inp := json.patch(base_input, [{"op": "replace", "path": "/livestock/nitrogen", "value": {"n_after_stall_storage_losses_kg": 5400, "n_on_alm_or_community_pasture_kg": 0, "manure_offtake_contract_n_kg": 3000}}])
	o6_2.nitrogen_limit_exceeded with input as inp
	vs := o6_2.violations with input as inp
	some v in vs
	v.rule_id == "O6_2-OBL-N-LIMIT-001"
}
