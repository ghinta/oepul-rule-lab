package oepul.o6_21

import rego.v1

stable_structure(s) if {
	s.type == "ordinary"
	is_number(s.wind_protected_sides)
	s.wind_protected_sides >= 3
	s.lying_area_roofed
	s.solid_floor
	is_string(s.floor_material)
	s.floor_material != ""
	s.floor_material != "gravel"
	s.floor_material != "clay"
	liquid_handled(s)
}

stable_structure(s) if {
	s.type == "open"
	s.fixed_roof_over_beds
	s.impermeable_surface
	s.drain_to_collection_pit
}

liquid_handled(s) if s.liquid_arises == false
liquid_handled(s) if s.collection_container

usable_area(pen) := sum([part.area_m2 |
	some part in pen.surfaces
	part.paved
	part.access in {"permanent", "routine_work_only"}
]) if {
	is_array(pen.surfaces)
	every part in pen.surfaces {
		is_number(part.area_m2)
		part.area_m2 >= 0
		is_boolean(part.paved)
		part.access in {"permanent", "routine_work_only", "restricted"}
	}
}

# At 500 kg both published labels apply. Compare both totals before deciding.
space_rows(group) := cfg.cow_space if group.cow

else := [r |
	some r in cfg.weight_space
	lower_weight(group.weight_kg, r)
	upper_weight(group.weight_kg, r)
] if {
	group.cow == false
	is_number(group.weight_kg)
	group.weight_kg > 0
}

lower_weight(kg, r) if kg > r.from_kg

lower_weight(kg, r) if {
	r.from_inclusive
	kg == r.from_kg
}

upper_weight(kg, r) if {
	is_number(kg)
	r.through_kg == null
}

upper_weight(kg, r) if {
	is_number(r.through_kg)
	kg <= r.through_kg
}

space_need(pen, field, mode) := sum([value |
	some g in pen.occupants
	values := [r[field] | some r in space_rows(g)]
	value := g.count * bound(values, mode)
]) if {
	field in {"total_m2", "lying_m2"}
	mode in {"lower", "upper"}
	is_array(pen.occupants)
	count(pen.occupants) > 0
	every g in pen.occupants {
		is_number(g.count)
		g.count == floor(g.count)
		g.count > 0
		count(space_rows(g)) > 0
	}
}

bound(xs, "lower") := min(xs)
bound(xs, "upper") := max(xs)

cubicle_space_ok(pen) if {
	pen.suckler_cow_cubicle_system
	pen.legal_total_space
	pen.legal_cubicle_each_over_six_months
	pen.calf_beds_always_accessible_free_lying
	is_number(pen.calf_creep_bedded_m2)
	is_number(pen.calf_required_total_m2)
	pen.calf_creep_bedded_m2 >= 0.4 * pen.calf_required_total_m2
	pen.calf_required_total_m2 >= 0
}

ordinary_space_ok(pen, mode) if {
	usable_area(pen) >= space_need(pen, "total_m2", mode)
	is_number(pen.bedded_lying_m2)
	pen.bedded_lying_m2 >= space_need(pen, "lying_m2", mode)
}

space_assessment(pen) := "erfüllt" if cubicle_space_ok(pen)

else := "erfüllt" if {
	ordinary_space_ok(pen, "upper")
} else := "Grenze 500 kg klären" if {
	ordinary_space_ok(pen, "lower")
	not ordinary_space_ok(pen, "upper")
	pen.suckler_cow_cubicle_system == false
} else := "unterschritten" if {
	pen.suckler_cow_cubicle_system == false
	is_number(usable_area(pen))
	is_number(pen.bedded_lying_m2)
	is_number(space_need(pen, "total_m2", "lower"))
	not ordinary_space_ok(pen, "lower")
}

bedding_ok(pen) if {
	pen.perforation_pct >= 0
	pen.perforation_pct <= 5
	pen.bedding_soft_absorbent
	pen.lying_surface_soft_dry
	bedding_depth_ok(pen)
}

bedding_depth_ok(pen) if {
	pen.lying_base == "soft_depressible"
	pen.bedded
}

bedding_depth_ok(pen) if {
	pen.lying_base == "hard"
	is_number(pen.bedding_depth_cm)
	pen.bedding_depth_cm >= 3
	pen.continuous_rebedding
}

housing_mode_ok(e) if {
	e.mode == "group"
	e.bedded
}

housing_mode_ok(e) if {
	e.mode == "individual"
	e.bedded
	e.medical_necessity
	e.ill_or_injured
	e.duration_days >= 1
	e.duration_days <= 10
}

housing_mode_ok(e) if {
	e.mode == "individual"
	e.bedded
	e.age_days_at_end >= 0
	e.age_days_at_end < 21
	e.calf_social_contact
	e.meets_thvo
}

housing_mode_ok(e) if {
	e.mode in {"pasture", "alpine"}
	e.compliant_home_stall
	e.actual_stabling_in_year
}

medical_records_due(e) if {
	e.mode == "individual"
	e.medical_necessity
	e.ill_or_injured
}

animal_withdrawal_due contains e.tag if {
	some e in claim.housing_events
	e.participating_category
	e.conditions_unattainable
}

animal_withdrawal_due contains e.tag if {
	some e in claim.housing_events
	e.participating_category
	medical_records_due(e)
	is_number(e.duration_days)
	e.duration_days > 10
}

pen_space[id] := status if {
	some pen in claim.pens
	id := pen.id
	status := space_assessment(pen)
}

plans_required := year <= 2024 if year >= 2023

compost_ok if {
	c := claim.compost
	c.requested
	c.all_species_manure_on_farm_in_heaps
	c.compost_barn == false
	c.nitrate_rules_met
	c.records_complete
	count(c.heaps) > 0
	every heap in c.heaps { heap_ok(heap) }
}

heap_ok(h) if {
	some i, j
	a := h.turns[i]
	b := h.turns[j]
	day(b.date) - day(a.date) >= 14
	turn_ok(a)
	turn_ok(b)
}

heap_ok(h) if {
	year >= 2025
	h.mixed_or_layered
	h.significant_added_field_or_woody_material
	h.composting_process
}

turn_ok(t) if {
	equipment_ok(t)
	t.on_farm_equipment
}

turn_ok(t) if {
	equipment_ok(t)
	t.external_use_documented
}

equipment_ok(t) if t.device == "turner"

equipment_ok(t) if {
	t.device in {"spreader", "other"}
	t.fully_turned
	t.equivalent_result
}

# An evidenced deficiency in a linked occupied pen applies to the affected tag.
animal_withdrawal_due contains e.tag if {
	some e in claim.housing_events
	e.participating_category
	e.mode in {"group", "individual"}
	some p in claim.pens
	p.id == e.pen_id
	space_assessment(p) == "unterschritten"
}

animal_withdrawal_due contains e.tag if {
	some e in claim.housing_events
	e.participating_category
	e.mode in {"group", "individual"}
	e.bedded == false
}

animal_withdrawal_due contains e.tag if {
	some e in claim.housing_events
	e.participating_category
	e.mode in {"tethered", "fully_slatted"}
}

animal_withdrawal_due contains e.tag if {
	some e in claim.housing_events
	e.participating_category
	e.mode == "individual"
	e.age_days_at_end >= 21
	e.medical_necessity == false
}

medical_records_missing contains e.tag if {
	some e in claim.housing_events
	e.participating_category
	medical_records_due(e)
	e.medical_reason_and_duration_recorded == false
}

# Even sufficient remaining space does not permit locking part of the pen.
restricted_pens contains p.id if {
	some p in claim.pens
	some part in p.surfaces
	part.access == "restricted"
}

animal_withdrawal_due contains e.tag if {
	some e in claim.housing_events
	e.participating_category
	e.mode in {"pasture", "alpine"}
	e.actual_stabling_in_year == false
	e.compliant_home_stall == false
}

plan_missing contains {"pen_id": p.id, "category": c} if {
	plans_required
	some p in claim.pens
	some c in p.participating_categories
	is_array(input.documentation.o6_21_pen_plans)
	not documented_pen(p.id, c)
}

documented_pen(id, c) if {
	some plan in input.documentation.o6_21_pen_plans
	plan.pen_id == id
	plan.category == c
	plan.kept_on_farm
	plan.dimensions_recorded
	plan.area_m2 > 0
	plan.max_head_count >= 1
}
