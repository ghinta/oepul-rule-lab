package oepul.o6_22

import rego.v1

# Input is extended in discover mode through oepul_o6_22. Each participation
# carries eligible animals, their housing evidence, and requested supplements.
gve_for_animals(animals) := total if {
	total := sum([(animal.head_count * data.gve_per_head[animal.gve_key]) | some animal in animals])
}

minimum_gve_met if {
	gve_for_animals(input.oepul_o6_22.animals) >= 2
}

category_is_eligible(category) if {
	category in data.eligible_categories
}

space_row(weight_kg) := row if {
	weight_kg <= 20
	row := data.stall_space[0]
}

space_row(weight_kg) := row if {
	weight_kg > 20
	weight_kg <= 32
	row := data.stall_space[1]
}

space_row(weight_kg) := row if {
	weight_kg > 32
	weight_kg <= 50
	row := data.stall_space[2]
}

space_row(weight_kg) := row if {
	weight_kg > 50
	weight_kg <= 85
	row := data.stall_space[3]
}

space_row(weight_kg) := row if {
	row := data.stall_space[4]
	weight_kg > row.min_kg
}

stall_space_compliant(pen) if {
	row := space_row(pen.average_weight_kg)
	pen.total_area_m2 >= pen.head_count * row.total_m2
	pen.bedded_lying_area_m2 >= pen.head_count * row.lying_m2
	pen.planar_lying_area_m2 >= pen.head_count * row.lying_m2
	pen.perforation_percent <= 5
}

sow_pen_compliant(pen) if {
	some row in data.stall_space
	row.class == pen.category
	pen.total_area_m2 >= pen.head_count * row.total_m2
	pen.bedded_lying_area_m2 >= pen.head_count * row.lying_m2
	pen.planar_lying_area_m2 >= pen.head_count * row.lying_m2
	pen.perforation_percent <= 5
}

freeland_compliant(site) if {
	site.water_permit_max_gve == null
	site.gve <= site.unpaved_area_ha * 4
	site.double_fence_or_dense_enclosure
	site.feed_and_water_separated
	site.feed_site_roofed
	site.feed_or_water_hardened_or_moved
	site.three_sided_roofed_bedded_lie_area
	site.all_animals_can_lie_simultaneously
	site.continuous_use_days <= 366
}

freeland_compliant(site) if {
	site.water_permit_max_gve != null
	site.gve <= site.water_permit_max_gve
	site.double_fence_or_dense_enclosure
	site.feed_and_water_separated
	site.feed_site_roofed
	site.feed_or_water_hardened_or_moved
	site.three_sided_roofed_bedded_lie_area
	site.all_animals_can_lie_simultaneously
	site.continuous_use_days <= 366
}

gmo_supplement_compliant if {
	input.oepul_o6_22.supplements.gmo_free_european_protein
	input.oepul_o6_22.all_farm_animals_gmo_free_european_protein
	not input.oepul_o6_22.nonconforming_protein_stored_or_fed
	input.oepul_o6_22.purchased_protein_evidence_complete
}

manure_compost_supplement_compliant if {
	input.farm.year >= 2025
	input.oepul_o6_22.supplements.manure_composting
	input.oepul_o6_22.all_farm_solid_manure_composted
	input.oepul_o6_22.compost_records_complete
	input.oepul_o6_22.compost_method == "mixed_or_layered_organic_material"
}

manure_compost_supplement_compliant if {
	input.farm.year >= 2025
	input.oepul_o6_22.supplements.manure_composting
	input.oepul_o6_22.all_farm_solid_manure_composted
	input.oepul_o6_22.compost_records_complete
	input.oepul_o6_22.compost_method == "turned_windrow"
	input.oepul_o6_22.compost_turn_count >= 2
	input.oepul_o6_22.minimum_days_between_turns >= 14
	input.oepul_o6_22.turning_equipment_complete
}

violations contains {"code": "minimum_gve", "message": "At least 2.00 GVE across requested pig categories is required."} if {
	not minimum_gve_met
}

violations contains {"code": "animal_year", "message": "Eligible animals must meet the category conditions from 1 January through 31 December."} if {
	some animal in input.oepul_o6_22.animals
	not animal.conditions_met_full_calendar_year
}

violations contains {"code": "category", "message": "A requested category is not an eligible o6_22 category."} if {
	some animal in input.oepul_o6_22.animals
	not category_is_eligible(animal.category)
}

violations contains {"code": "uncut", "message": "The uncut-tail supplement requires every participating piglet or young/fattening pig in that category to be uncut all year."} if {
	input.oepul_o6_22.supplements.uncut_tails
	some animal in input.oepul_o6_22.animals
	animal.category in {"piglets_8_32", "young_fattening_32_plus"}
	not animal.all_tails_uncut_full_calendar_year
}

eligible if {
	minimum_gve_met
	count(violations) == 0
}
