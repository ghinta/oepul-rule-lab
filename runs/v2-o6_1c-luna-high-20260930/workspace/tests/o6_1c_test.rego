package policy.o6_1c_test

import data.policy.o6_1c as o6_1c
import rego.v1

test_npa_limit_passes if {
	test_input := {
		"farm": {"year": 2026, "region": {"nUTS": "AT11"}},
		"measure": {"id": "o6_1c", "npa_area_with_care_before_august_ha": 0.4},
		"land": {"arable_area_ha": 10, "parcels": [{"parcel_id": "p1", "area_ha": 0.3, "measure_category": "nonproductive_arable"}]},
	}
	o6_1c.eligible with input as test_input
	o6_1c.npa_area_within_limit with input as test_input
}

test_npa_limit_fails if {
	test_input := {
		"farm": {"year": 2026, "region": {"nUTS": "AT11"}},
		"measure": {"id": "o6_1c", "npa_area_with_care_before_august_ha": 0},
		"land": {"arable_area_ha": 5, "parcels": [{"parcel_id": "p1", "area_ha": 0.3, "measure_category": "nonproductive_arable"}]},
	}
	not o6_1c.npa_area_within_limit with input as test_input
}

test_agroforst_negative_species_and_dimensions if {
	test_input := {
		"farm": {"year": 2026, "region": {"nUTS": "AT11"}},
		"measure": {"id": "o6_1c"},
		"land": {"arable_area_ha": 10, "parcels": [{
			"parcel_id": "p2",
			"area_ha": 0.2,
			"measure_category": "agroforestry_strip",
			"agroforestry": {
				"average_width_m": 12,
				"trees_per_100m": 30,
				"max_tree_distance_m": 20,
				"long_side_adjacent_to_forest": false,
				"long_side_adjacent_to_landscape_element": false,
				"trees": [{"scientific_name": "Robinia pseudoacacia"}],
			},
		}]},
	}
	negative := o6_1c.negative_species with input as test_input
	count(negative) == 1
	decision := o6_1c.decisions[_] with input as test_input
	decision.code == "AGRO_SPECIES"
	decision.status == "fail"
}

test_agroforst_natural_ingress_negative_species if {
	test_input := {
		"land": {"parcels": [{
			"parcel_id": "p3",
			"measure_category": "agroforestry_strip",
			"agroforestry": {
				"trees": [],
				"natural_ingress_species": ["Ailanthus altissima"],
			},
		}]},
	}
	negative := o6_1c.negative_species with input as test_input
	count(negative) == 1
}

test_premium_bands if {
	test_input := {
		"land": {"parcels": [
			{"parcel_id": "npa", "measure_category": "nonproductive_arable"},
			{"parcel_id": "agro", "measure_category": "agroforestry_strip"},
		]},
	}
	npa_band := o6_1c.premium_band.npa with input as test_input
	agro_band := o6_1c.premium_band.agro with input as test_input
	npa_band == {"min_eur_per_ha": 350, "max_eur_per_ha": 450}
	agro_band == {"min_eur_per_ha": 600, "max_eur_per_ha": 800}
}

test_combination_row_is_enforced if {
	test_input := {
		"land": {"parcels": [{
			"parcel_id": "npa",
			"measure_category": "nonproductive_arable",
			"combination": {"other_measure_ids": ["o6_1a"]},
		}]},
	}
	violation := o6_1c.npa_combination_violations[_] with input as test_input
	violation == "o6_1a"
	decision := o6_1c.decisions[_] with input as test_input
	decision == {"code": "NPA_COMBINATION", "status": "fail"}
}
