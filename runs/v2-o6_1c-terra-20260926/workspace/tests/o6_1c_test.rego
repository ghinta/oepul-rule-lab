package oepul.o6_1c_test

import data.oepul.o6_1c
import rego.v1

valid_input := {
	"farm": {"year": 2026},
	"land": {"arable_area_ha": 100},
	"o6_1c": {"parcels": [
		{"parcel_id": "N1", "category": "nonproductive_arable", "area_ha": 3, "is_gloez4_buffer": false, "establishment": "existing", "tillage_date": null, "following_crop": null, "fertilizer_used": false, "psm_used": false, "psm_bio848_only": false, "removal_method": null, "care_operations_this_year": 1, "biomass_removed": false, "grazed": false},
		{"parcel_id": "A1", "category": "agroforestry_strip", "establishment_year": 2020, "adjacent_to_arable": true, "average_width_m": 5, "trees_per_100m": 15, "max_tree_spacing_m": 10, "is_special_crop": false, "tree_species": ["Quercus robur"], "new_planting_date": null, "herbaceous_permanently_green": true, "herbaceous_used": false, "fertilizer_used": false, "psm_used": false, "repellent_bio848_only": false},
	]},
}

test_valid_input_has_no_violations if {
	vs := o6_1c.violations with input as valid_input
	count(vs) == 0
}

test_nonproductive_area_cap if {
	bad := object.union(valid_input, {"o6_1c": {"parcels": [object.union(valid_input.o6_1c.parcels[0], {"area_ha": 5})]}})
	vs := o6_1c.violations with input as bad
	some v in vs
	v.code == "npa_area_cap"
}

test_prohibited_tree_is_detected if {
	bad_af := object.union(valid_input.o6_1c.parcels[1], {"tree_species": ["Ailanthus altissima"]})
	bad := object.union(valid_input, {"o6_1c": {"parcels": [bad_af]}})
	vs := o6_1c.violations with input as bad
	some v in vs
	v.code == "af_negative_species"
}

test_modulation_factor if {
	o6_1c.modulation_factor(220) == 218 / 220
}
