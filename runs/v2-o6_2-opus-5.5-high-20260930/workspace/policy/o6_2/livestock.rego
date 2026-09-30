# Tierhaltereigenschaft, RGVE-Besatz und Stickstoffanfall aus der Tierhaltung.
package oepul.o6_2

rgve_key_by_id := {r.id: r | some r in rgve_data.key}

species_groups := object.get(input, ["livestock", "species_groups"], [])

# Nur in Österreich gehaltene Tiere sind anrechenbar.
group_held_in_austria(g) if object.get(g, "held_in_austria", true) == true

group_rgve(g) := g.animal_count * rgve_key_by_id[g.rgve_key_id].rgve_per_head if {
	group_held_in_austria(g)
	rgve_key_by_id[g.rgve_key_id].rgve_per_head != null
	rgve_key_by_id[g.rgve_key_id].species_group in rgve_data.livestock_farm_species_groups
}

total_rgve := sum([r | some g in species_groups; r := group_rgve(g)])

fodder_area_ha := sum([p.area_ha | some p in parcels; is_fodder_area(p)])

stocking_density_rgve_per_ha := total_rgve / fodder_area_ha if fodder_area_ha > 0

is_livestock_farm if {
	stocking_density_rgve_per_ha >= premium_data.livestock_density_threshold_rgve_per_ha
}

livestock_status := "livestock" if {
	is_livestock_farm
} else := "non_livestock"

rgve_band := "ge_1_4" if {
	stocking_density_rgve_per_ha >= premium_data.premium_band_threshold_rgve_per_ha
} else := "lt_1_4"

# Tiergruppen ohne zuordenbaren RGVE-Schlüssel (Datenlücke im Profil).
unmapped_species_groups contains g.species if {
	some g in species_groups
	g.species in {"cattle", "sheep_goats", "horses", "other"}
	not rgve_key_by_id[object.get(g, "rgve_key_id", "")]
}

# Stickstoffanfall aus der Tierhaltung nach Abzug der Stall- und Lagerverluste;
# auf Almen/Gemeinschaftsweiden angefallener N wird abgezogen, Düngerabnahmeverträge
# werden nicht berücksichtigt.
nitrogen := object.get(input, ["livestock", "nitrogen"], {})

n_attributable_kg := object.get(nitrogen, "n_after_stall_storage_losses_kg", 0) - object.get(nitrogen, "n_on_alm_or_community_pasture_kg", 0)

n_per_ha := n_attributable_kg / agricultural_area_ha if agricultural_area_ha > 0

nitrogen_limit_exceeded if n_per_ha > general.nitrogen_max_kg_per_ha
