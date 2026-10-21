package oepul.o6_14

# Maximaler Viehbesatz je Alm (2,00 / 1,50 NATA / 2,40 Almweideplan) und
# Mindestbestossungsdauer je Alm.

alm_stocking_rgve[alm_id] := x if {
	some alm_id, _ in alm_by_id
	x := sum([stocking_rgve_share(id, alm_id) |
		some id, _ in animal_by_id
		counts_for_stocking(id)
	])
}

# Auslaendische angrenzende Almflaechen entlasten den Viehbesatz nur bei
# jaehrlicher gesonderter Meldung mit Nachweis.
foreign_relief_ha(alm) := object.get(alm, "foreign_adjacent_area_ha", 0) if is_true(alm, "foreign_area_report_submitted")

foreign_relief_ha(alm) := 0 if not is_true(alm, "foreign_area_report_submitted")

stocking_area_ha(alm) := alm.alm_pasture_area_ha + foreign_relief_ha(alm)

alm_stocking_density[alm_id] := alm_stocking_rgve[alm_id] / stocking_area_ha(alm) if {
	some alm_id, alm in alm_by_id
	stocking_area_ha(alm) > 0
}

awp_increased_intensity(alm) if {
	awp_applied
	year >= 2025
	gp := object.get(alm, "grazing_plan", {})
	is_true(gp, "increased_intensity_applied")
	is_true(gp, "increased_intensity_justified_in_plan")
}

nata_alm(alm) if {
	nata_applied
	is_true(object.get(alm, "nature_conservation", {}), "participates")
}

max_stocking_limit(alm) := 1.5 if nata_alm(alm)

max_stocking_limit(alm) := 2.4 if {
	not nata_alm(alm)
	awp_increased_intensity(alm)
}

max_stocking_limit(alm) := 2.0 if {
	not nata_alm(alm)
	not awp_increased_intensity(alm)
}

alm_max_stocking_limit[alm_id] := max_stocking_limit(alm) if some alm_id, alm in alm_by_id

overstocked(alm_id) if alm_stocking_density[alm_id] > alm_max_stocking_limit[alm_id]

alm_min_occupancy_met(alm_id) if alm_occupied_days[alm_id] >= min_grazing_days
