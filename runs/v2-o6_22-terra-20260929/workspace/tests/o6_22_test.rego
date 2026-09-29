package oepul.o6_22_test

import data.oepul.o6_22
import rego.v1

test_gve_and_space_table if {
	o6_22.gve_for_animals([{"head_count": 7, "gve_key": "piglet_8_20"}, {"head_count": 7, "gve_key": "young_32_50"}]) > 2.5
	o6_22.stall_space_compliant({"average_weight_kg": 50, "head_count": 10, "total_area_m2": 7, "bedded_lying_area_m2": 2.8, "planar_lying_area_m2": 2.8, "perforation_percent": 5})
}

test_freeland_without_permit if {
	o6_22.freeland_compliant({"water_permit_max_gve": null, "gve": 6, "unpaved_area_ha": 2, "double_fence_or_dense_enclosure": true, "feed_and_water_separated": true, "feed_site_roofed": true, "feed_or_water_hardened_or_moved": true, "three_sided_roofed_bedded_lie_area": true, "all_animals_can_lie_simultaneously": true, "continuous_use_days": 365})
}

test_gmo_supplement if {
	o6_22.gmo_supplement_compliant with input as {"oepul_o6_22": {"supplements": {"gmo_free_european_protein": true}, "all_farm_animals_gmo_free_european_protein": true, "nonconforming_protein_stored_or_fed": false, "purchased_protein_evidence_complete": true}}
}

test_manure_supplement if {
	o6_22.manure_compost_supplement_compliant with input as {"farm": {"year": 2025}, "oepul_o6_22": {"supplements": {"manure_composting": true}, "all_farm_solid_manure_composted": true, "compost_records_complete": true, "compost_method": "turned_windrow", "compost_turn_count": 2, "minimum_days_between_turns": 14, "turning_equipment_complete": true}}
}
