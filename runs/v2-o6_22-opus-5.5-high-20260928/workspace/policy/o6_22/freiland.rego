# Tierwohl – Schweinehaltung (o6_22): free-range husbandry on unpaved areas.
package oepul.o6_22

freiland_groups := {i: g | some i, g in participating_groups; freiland_kept(g)}

# Rule: O622-FREE-01 (stocking limit per water-law permit, otherwise 4 GVE/ha)
freiland_stocking_limit(g) := pasture(g).water_permit_max_gve_per_ha if {
	is_number(object.get(pasture(g), "water_permit_max_gve_per_ha", null))
} else := params.freiland_default_max_gve_per_ha

# Rule: O622-FREE-01 (with paddock rotation the whole area available over the holding period counts)
freiland_area_ha(g) := pasture(g).rotation_total_area_ha if {
	is_number(object.get(pasture(g), "rotation_total_area_ha", null))
	pasture(g).rotation_total_area_ha > 0
} else := pasture(g).pasture_area_ha

freiland_stocking_gve_per_ha(g) := r2(present_gve(g) / freiland_area_ha(g)) if freiland_area_ha(g) > 0

# Rule: O622-FREE-04 (litter in the shelter not required for empty and pregnant sows)
shelter_litter_required(g) if not is_sow_group(g)

shelter_litter_required(g) if {
	is_sow_group(g)
	object.get(welfare(g), "sow_phase", null) != "empty_or_pregnant"
}

# Rule: O622-FREE-01
group_issues contains {"group": i, "rule_id": "O622-FREE-01", "reason": "freiland_stocking_density_exceeded"} if {
	some i, g in freiland_groups
	freiland_stocking_gve_per_ha(g) > freiland_stocking_limit(g)
}

# Rule: O622-FREE-08 (continuous use of the same unpaved area max. one year)
group_issues contains {"group": i, "rule_id": "O622-FREE-08", "reason": "freiland_continuous_use_over_one_year"} if {
	some i, g in freiland_groups
	pasture(g).continuous_use_months > params.freiland_max_continuous_use_months
}

# Rule: O622-FREE-02 (double fence or founded, tight enclosure against wild boar contact)
group_issues contains {"group": i, "rule_id": "O622-FREE-02", "reason": "freiland_enclosure_insufficient"} if {
	some i, g in freiland_groups
	pasture(g).double_fence_or_solid_enclosure == false
}

# Rule: O622-FREE-03 (feeding place and drinker separated)
group_issues contains {"group": i, "rule_id": "O622-FREE-03", "reason": "freiland_feed_and_water_not_separated"} if {
	some i, g in freiland_groups
	pasture(g).feeding_and_watering_separated == false
}

# Rule: O622-FREE-03 (paved ground or regular relocation)
group_issues contains {"group": i, "rule_id": "O622-FREE-03", "reason": "freiland_feed_and_water_not_paved_or_relocated"} if {
	some i, g in freiland_groups
	pasture(g).feeding_and_watering_paved_or_relocated == false
}

# Rule: O622-FREE-03 (roofed feeding place)
group_issues contains {"group": i, "rule_id": "O622-FREE-03", "reason": "freiland_feeding_place_not_roofed"} if {
	some i, g in freiland_groups
	pasture(g).feeding_place_roofed == false
}

# Rule: O622-FREE-04 (roofed, three-sided closed shelter in which all animals can lie)
group_issues contains {"group": i, "rule_id": "O622-FREE-04", "reason": "freiland_shelter_insufficient"} if {
	some i, g in freiland_groups
	some field in ["shelter_roofed", "shelter_three_sided_closed", "shelter_all_animals_lie_simultaneously"]
	pasture(g)[field] == false
}

# Rule: O622-FREE-04 (littered shelter)
group_issues contains {"group": i, "rule_id": "O622-FREE-04", "reason": "freiland_shelter_not_littered"} if {
	some i, g in freiland_groups
	shelter_litter_required(g)
	pasture(g).shelter_littered == false
}

# Rule: O622-FREE-04 / O622-DEF-STALL-04 (farrowing huts for breeding sows)
group_issues contains {"group": i, "rule_id": "O622-FREE-04", "reason": "freiland_farrowing_huts_missing"} if {
	some i, g in freiland_groups
	is_sow_group(g)
	object.get(welfare(g), "sow_phase", null) != "empty_or_pregnant"
	pasture(g).farrowing_huts_available == false
}

# Rule: O622-FREE-07 (wild boars are not eligible and must be deregistered)
group_issues contains {"group": i, "rule_id": "O622-FREE-07", "reason": "wild_boar_not_eligible"} if {
	some i, g in participating_groups
	g.is_wild_boar == true
}

# Rule: O622-FREE-06 (continuous free-range documentation per plot)
violations contains {
	"rule_id": "O622-FREE-06",
	"severity": "obligation",
	"message": sprintf("Group %v: free-range documentation (start/end of grazing period and animals per plot) incomplete", [i]),
} if {
	some i, g in freiland_groups
	pasture(g).documentation_per_plot_complete == false
}

# Rule: O622-APP-08 (unpaved free-range areas declared as 'Sonstige Acker-/Grünlandflächen')
violations contains {
	"rule_id": "O622-APP-08",
	"severity": "obligation",
	"message": sprintf("Group %v: unpaved free-range area must be declared with land-use type 'Sonstige Ackerflächen' or 'Sonstige Grünlandflächen'", [i]),
} if {
	some i, g in freiland_groups
	pasture(g).unpaved_area_declared_as_other_land == false
}

missing_inputs contains sprintf("livestock.species_groups[%v].housing.pasture.pasture_area_ha", [i]) if {
	some i, g in freiland_groups
	not is_number(object.get(pasture(g), "pasture_area_ha", null))
	not is_number(object.get(pasture(g), "rotation_total_area_ha", null))
}
