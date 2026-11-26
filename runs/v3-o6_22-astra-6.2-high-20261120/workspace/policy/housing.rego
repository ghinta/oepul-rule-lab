package oepul.o6_22

import rego.v1

liquid_ok(p) if p.liquid_waste_arises == false
liquid_ok(p) if p.liquid_waste_collectable

building_ok(p) if {
	p.building == "standard"
	is_number(p.draft_protected_sides)
	p.draft_protected_sides >= 3
	p.roof_over_beds
	p.solid_floor_other_than_gravel_or_clay
	liquid_ok(p)
}

building_ok(p) if {
	p.building == "open"
	p.roof_over_beds
	p.impervious_floor
	p.drain_to_pit
	p.room_for_entire_herd
}

usable_segment(s) if {
	s.paved
	s.access in {"permanent", "routine_work_only"}
}

usable_area(p) := decimal_sum([s.m2 | some s in p.surfaces; usable_segment(s)]) if {
	is_array(p.surfaces)
	every s in p.surfaces {
		nonnegative(s.m2)
		is_boolean(s.paved)
		s.access in {"permanent", "routine_work_only", "restricted"}
	}
}

inside_band(weight, r) if {
	r.max_exclusive_kg == null
	weight >= r.min_kg
}

inside_band(weight, r) if {
	is_number(r.max_exclusive_kg)
	weight >= r.min_kg
	weight < r.max_exclusive_kg
}

space_band(c) := r if {
	some r in tables.space
	r.kind == c.kind
	is_number(c.weight_kg)
	inside_band(c.weight_kg, r)
}

space_required(p) := {"total_m2": decimal_sum(total), "lying_m2": decimal_sum(lying)} if {
	is_array(p.occupants)
	count(p.occupants) > 0
	every c in p.occupants {
		nonnegative(c.count)
		c.count == floor(c.count)
		is_object(space_band(c))
	}
	total := [area | some c in p.occupants; area := decimal_product(c.count, space_band(c).total_m2)]
	lying := [area | some c in p.occupants; area := decimal_product(c.count, space_band(c).lying_m2)]
}

pen_space_ok(p) if {
	req := space_required(p)
	usable_area(p) >= req.total_m2
	p.bedded_lying_area_m2 >= req.lying_m2
	is_number(p.bedded_lying_area_m2)
}

capacity(p, c) := floor(min([usable_area(p) / r.total_m2, p.bedded_lying_area_m2 / r.lying_m2])) if {
	r := space_band(c)
	nonnegative(p.bedded_lying_area_m2)
}

lying_ok(p) if {
	nonnegative(p.perforation_pct)
	p.perforation_pct <= 5
	p.absorbent_bedding
	p.dry_bed
}

enrichment_ok(p) if {
	p.minimal_bedding == false
	p.bedding in {"straw", "hay"}
}

enrichment_ok(p) if {
	p.minimal_bedding == false
	p.permanent_sufficient_material in {"grass", "straw", "hay"}
}

enrichment_ok(p) if {
	p.minimal_bedding
	p.permanent_sufficient_material in {"straw", "hay"}
}

plan_required := year <= 2024 if year >= 2023

medical_exception(g) if {
	g.reason in {"sick", "injured"}
	g.medically_necessary
	g.bedded
	nonnegative(g.days)
	g.days <= 10
}

separation_deregistration(g) if {
	g.reason in {"sick", "injured"}
	is_number(g.days)
	g.days > 10
}

legacy_window(s) if {
	year <= 2033
	s.last_build_year < 2013
	is_number(s.last_build_year)
	s.standard_needs_construction
}

sow_offsets(s) := [28, 7] if legacy_window(s)

else := [10, 5] if {
	is_number(s.last_build_year)
	s.last_build_year >= 2013
} else := [10, 5] if s.standard_needs_construction == false

else := [10, 5] if year > 2033

sow_window(s) := active if {
	offsets := sow_offsets(s)
	elapsed := days_between(s.served, s.observed)
	remaining := days_between(s.observed, s.expected_farrowing)
	active := [elapsed >= offsets[0], remaining >= offsets[1]] == [true, true]
}

group_ok(g) if g.group_housed
group_ok(g) if medical_exception(g.separation)

group_ok(g) if {
	g.kind in {"sow", "covered_gilt"}
	sow_window(g.sow_period) == false
}

outdoor_density_ok(o) if {
	o.permit_limit_gve_ha == null
	nonnegative(o.gve)
	nonnegative(o.available_ha)
	o.available_ha > 0
	o.gve <= decimal_product(4, o.available_ha)
}

outdoor_density_ok(o) if {
	nonnegative(o.permit_limit_gve_ha)
	nonnegative(o.gve)
	nonnegative(o.available_ha)
	o.available_ha > 0
	o.gve <= decimal_product(o.permit_limit_gve_ha, o.available_ha)
}

outdoor_fence_ok(o) if o.fence in {"double", "solid_founded_tight"}

outdoor_stations_ok(o) if {
	o.stations_separate
	o.feed_roof
	o.feed_base in {"paved", "regularly_moved"}
	o.water_base in {"paved", "regularly_moved"}
}

hut_ok(o) if o.farrowing_or_suckling == false
hut_ok(o) if o.farrowing_huts

shelter_ok(o) if {
	o.roof
	is_number(o.closed_sides)
	o.closed_sides >= 3
	o.draft_protected
	o.bedded
	o.all_can_lie
	hut_ok(o)
}

outdoor_duration_ok(o) if {
	start := day(o.first_use)
	end := day(o.end_exclusive)
	end > start
	end <= time.add_date(start, 1, 0, 0)
}
