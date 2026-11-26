package oepul.o6_22_test

import data.oepul.o6_22 as pig
import rego.v1

surface(area) := {"m2": area, "paved": true, "access": "permanent"}
cohort(w, n) := {"kind": "growing", "weight_kg": w, "count": n}

test_box_of_25_heavy_pigs if {
	p := {"occupants": [cohort(86, 25)], "surfaces": [surface(27.5)], "bedded_lying_area_m2": 11}
	pig.pen_space_ok(p)
	pig.space_required(p) == {"total_m2": 27.5, "lying_m2": 11}
	not pig.pen_space_ok(object.union(p, {"bedded_lying_area_m2": 10.99}))
}

test_all_area_boundaries if {
	every pair in [[8, 0.30], [19.99, 0.30], [20, 0.50], [32, 0.70], [50, 0.90], [84.99, 0.90], [85, 1.10]] {
		pig.space_band(cohort(pair[0], 1)).total_m2 == pair[1]
	}
	not pig.space_band(cohort(7.99, 1))
}

test_sow_and_gilt_mixed_box if {
	p := {"occupants": [{"kind": "sow", "weight_kg": 180, "count": 1}, {"kind": "covered_gilt", "weight_kg": 75, "count": 2}]}
	pig.space_required(p) == {"total_m2": 7, "lying_m2": 3.20}
}

test_only_usable_surfaces if {
	p := {"surfaces": [surface(10), {"m2": 5, "paved": true, "access": "routine_work_only"}, {"m2": 4, "paved": true, "access": "restricted"}, {"m2": 6, "paved": false, "access": "permanent"}], "bedded_lying_area_m2": 6}
	pig.usable_area(p) == 15
	pig.capacity(p, cohort(45, 1)) == 21
	pig.capacity(p, cohort(55, 1)) == 16
	pig.capacity(p, cohort(90, 1)) == 13
}

test_dry_bedding_at_five_percent if {
	p := {"perforation_pct": 5, "absorbent_bedding": true, "dry_bed": true}
	pig.lying_ok(p)
	not pig.lying_ok(object.union(p, {"perforation_pct": 5.01}))
	not pig.lying_ok(object.union(p, {"dry_bed": false}))
}

test_minimal_bedding_needs_extra_straw_or_hay if {
	pig.enrichment_ok({"minimal_bedding": false, "bedding": "hay"})
	not pig.enrichment_ok({"minimal_bedding": true, "bedding": "straw", "permanent_sufficient_material": "grass"})
	pig.enrichment_ok({"minimal_bedding": true, "permanent_sufficient_material": "hay"})
}

test_required_medical_separation if {
	s := {"reason": "injured", "medically_necessary": true, "bedded": true, "days": 10}
	pig.medical_exception(s)
	not pig.medical_exception(object.union(s, {"bedded": false}))
	not pig.medical_exception(object.union(s, {"days": 11}))
	pig.separation_deregistration(object.union(s, {"days": 11}))
}

test_old_barn_derogation_requires_building_work if {
	s := {"served": "2026-03-01", "expected_farrowing": "2026-06-24", "observed": "2026-03-11", "last_build_year": 2012, "standard_needs_construction": true}
	pig.sow_window(s) == false with input.farm.year as 2026
	pig.sow_window(object.union(s, {"standard_needs_construction": false})) with input.farm.year as 2026
	pig.sow_window(object.union(s, {"last_build_year": 2013})) with input.farm.year as 2026
	pig.sow_window(object.union(s, {"observed": "2026-03-29"})) with input.farm.year as 2026
	pig.sow_window(object.union(s, {"observed": "2026-06-18"})) == false with input.farm.year as 2026
}

test_freiland_permit_and_paddocks if {
	o := {"gve": 6, "available_ha": 2, "permit_limit_gve_ha": null}
	pig.outdoor_density_ok(o)
	not pig.outdoor_density_ok(object.union(o, {"available_ha": 1}))
	pig.outdoor_density_ok(object.union(o, {"available_ha": 1, "permit_limit_gve_ha": 6}))
	not pig.outdoor_density_ok(object.union(o, {"permit_limit_gve_ha": 2}))
	not pig.outdoor_density_ok({"gve": 6, "available_ha": 2})
}

test_year_of_continuous_use_and_shelter if {
	pig.outdoor_duration_ok({"first_use": "2024-01-01", "end_exclusive": "2025-01-01"})
	not pig.outdoor_duration_ok({"first_use": "2024-01-01", "end_exclusive": "2025-01-02"})
	o := {"roof": true, "closed_sides": 3, "draft_protected": true, "bedded": true, "all_can_lie": true, "farrowing_or_suckling": false}
	pig.shelter_ok(o)
	not pig.shelter_ok(object.union(o, {"farrowing_or_suckling": true}))
}

test_open_barn_and_outdoor_stations if {
	p := {"building": "open", "roof_over_beds": true, "impervious_floor": true, "drain_to_pit": true, "room_for_entire_herd": true}
	pig.building_ok(p)
	not pig.building_ok(object.union(p, {"drain_to_pit": false}))
	o := {"fence": "double", "stations_separate": true, "feed_roof": true, "feed_base": "paved", "water_base": "regularly_moved"}
	pig.outdoor_fence_ok(o)
	pig.outdoor_stations_ok(o)
	not pig.outdoor_stations_ok(object.union(o, {"water_base": "other"}))
}
