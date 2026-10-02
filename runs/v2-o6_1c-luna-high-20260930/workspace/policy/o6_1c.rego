package policy.o6_1c

import rego.v1

default eligible := false

measure_declared if input.measure.id == "o6_1c"

eligible if {
	measure_declared
	input.farm.year >= 2025
	input.farm.region.nUTS != ""
}

npa_parcels := [p |
	some p in input.land.parcels
	p.measure_category == "nonproductive_arable"
]

agro_parcels := [p |
	some p in input.land.parcels
	p.measure_category == "agroforestry_strip"
]

agro_species_names contains name if {
	some p in agro_parcels
	some tree in p.agroforestry.trees
	name := tree.scientific_name
}

agro_species_names contains name if {
	some p in agro_parcels
	some name in p.agroforestry.natural_ingress_species
}

negative_species contains item if {
	item := data.o6_1c_agroforst_negative_list.agroforst_negative_list[_]
	agro_species_names[item.scientific_name]
}

nonproductive_area_ha := sum([p.area_ha | some p in npa_parcels])

npa_area_limit_ha := input.land.arable_area_ha * 0.04

npa_area_within_limit if nonproductive_area_ha <= npa_area_limit_ha

npa_sowing_deadline_ok[p] if {
	p := npa_parcels[_]
	p.npa.sowing_date != null
	p.npa.sowing_date <= sprintf("%d-05-15", [input.farm.year])
}

npa_break_early_allowed[p] if {
	p := npa_parcels[_]
	p.npa.following_crop in {"wintering", "cover_crop"}
}

npa_chemical_prohibition if {
	some p in npa_parcels
	p.operations.psm_used == true
}

npa_mineral_fertilizer_used if {
	some p in npa_parcels
	p.operations.fertilizer.mineral_n_kg_per_ha != null
	p.operations.fertilizer.mineral_n_kg_per_ha > 0
}

npa_organic_fertilizer_used if {
	some p in npa_parcels
	p.operations.fertilizer.organic_n_kg_per_ha != null
	p.operations.fertilizer.organic_n_kg_per_ha > 0
}

npa_fertilizer_prohibition if {
	npa_mineral_fertilizer_used
}

npa_fertilizer_prohibition if {
	npa_organic_fertilizer_used
}

npa_mechanical_clearance_only if {
	some p in npa_parcels
	p.npa.clearance_method != "mechanical"
}

npa_grazing_prohibited if {
	some p in npa_parcels
	p.npa.grazing == true
}

npa_care_frequency_ok[p] if {
	p := npa_parcels[_]
	p.npa.care_events_last_two_years >= 1
	p.npa.care_events_current_year <= 2
}

npa_august_share_ok if {
	input.measure.npa_area_with_care_before_august_ha <= nonproductive_area_ha * 0.5
}

agro_dimensions_ok[p] if {
	p := agro_parcels[_]
	p.agroforestry.average_width_m >= 2
	p.agroforestry.average_width_m <= 10
	p.agroforestry.trees_per_100m >= 10
	p.agroforestry.trees_per_100m <= 25
	p.agroforestry.max_tree_distance_m <= 15
}

agro_establishment_deadline_ok[p] if {
	p := agro_parcels[_]
	p.agroforestry.establishment_date != null
	p.agroforestry.establishment_date <= sprintf("%d-05-15", [input.farm.year])
}

agro_perimeter_ok[p] if {
	p := agro_parcels[_]
	p.agroforestry.long_side_adjacent_to_forest == false
	p.agroforestry.long_side_adjacent_to_landscape_element == false
}

agro_inputs_prohibited if {
	some p in agro_parcels
	p.operations.psm_used == true
}

agro_mineral_fertilizer_used if {
	some p in agro_parcels
	p.operations.fertilizer.mineral_n_kg_per_ha != null
	p.operations.fertilizer.mineral_n_kg_per_ha > 0
}

agro_organic_fertilizer_used if {
	some p in agro_parcels
	p.operations.fertilizer.organic_n_kg_per_ha != null
	p.operations.fertilizer.organic_n_kg_per_ha > 0
}

agro_inputs_prohibited if {
	agro_mineral_fertilizer_used
}

agro_inputs_prohibited if {
	agro_organic_fertilizer_used
}

required_category_selection if {
	some p in npa_parcels
}

required_category_selection if {
	some p in agro_parcels
}

annual_contract if {
	input.measure.contract_start == sprintf("%d-01-01", [input.farm.year])
	input.measure.contract_end == sprintf("%d-12-31", [input.farm.year])
}

premium_band[parcel_id] := band if {
	some p in input.land.parcels
	parcel_id := p.parcel_id
	p.measure_category == "nonproductive_arable"
	band := {"min_eur_per_ha": 350, "max_eur_per_ha": 450}
}

premium_band[parcel_id] := band if {
	some p in input.land.parcels
	parcel_id := p.parcel_id
	p.measure_category == "agroforestry_strip"
	band := {"min_eur_per_ha": 600, "max_eur_per_ha": 800}
}

decisions contains {"code": "NPA_AREA_LIMIT", "status": "pass"} if npa_area_within_limit
decisions contains {"code": "NPA_AREA_LIMIT", "status": "fail"} if not npa_area_within_limit

decisions contains {"code": "NPA_CHEMICAL_INPUTS", "status": "fail"} if npa_chemical_prohibition
decisions contains {"code": "NPA_FERTILIZER", "status": "fail"} if npa_fertilizer_prohibition
decisions contains {"code": "NPA_CLEARANCE", "status": "fail"} if npa_mechanical_clearance_only
decisions contains {"code": "NPA_GRAZING", "status": "fail"} if npa_grazing_prohibited
decisions contains {"code": "AGRO_SPECIES", "status": "fail"} if count(negative_species) > 0

npa_care_violation if {
	some p in npa_parcels
	not npa_care_frequency_ok[p]
}

decisions contains {"code": "NPA_CARE_FREQUENCY", "status": "fail"} if npa_care_violation

agro_dimension_violation if {
	some p in agro_parcels
	not agro_dimensions_ok[p]
}

agro_perimeter_violation if {
	some p in agro_parcels
	not agro_perimeter_ok[p]
}

decisions contains {"code": "AGRO_DIMENSIONS", "status": "fail"} if agro_dimension_violation
decisions contains {"code": "AGRO_PERIMETER", "status": "fail"} if agro_perimeter_violation

data_source := "data/o6_1c_agroforst_negative_list.json"

combination_row := data.o6_1c_combination_row

npa_combination_violations contains other_measure if {
	some p in npa_parcels
	some other_measure in p.combination.other_measure_ids
	combination_row.row_values[other_measure] == false
}

decisions contains {"code": "NPA_COMBINATION", "status": "fail"} if count(npa_combination_violations) > 0

combination_data_source := "data/o6_1c_combination_row.json"
