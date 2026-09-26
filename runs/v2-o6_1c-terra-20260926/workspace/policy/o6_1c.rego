package oepul.o6_1c

import rego.v1

# Executable checks use the discover-mode extension input.o6_1c.parcels.
# An omitted field is reported as a missing fact rather than treated as compliant.

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "nonproductive_arable"
	p.area_ha > input.land.arable_area_ha * 0.04
	violation := {"code": "npa_area_cap", "parcel_id": p.parcel_id, "message": "Nonproductive arable area exceeds 4% of arable area."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "nonproductive_arable"
	p.is_gloez4_buffer
	violation := {"code": "npa_gloez4", "parcel_id": p.parcel_id, "message": "GLÖZ 4 buffer area is not eligible as nonproductive arable area."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "nonproductive_arable"
	p.establishment == "new_sowing"
	p.sowing_date > sprintf("%d-05-15", [input.farm.year])
	violation := {"code": "npa_sowing_deadline", "parcel_id": p.parcel_id, "message": "New sowing occurred after 15 May."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "nonproductive_arable"
	p.tillage_date != null
	p.following_crop != "winter_crop"
	p.following_crop != "cover_crop"
	p.tillage_date < sprintf("%d-09-15", [input.farm.year])
	violation := {"code": "npa_tillage_date", "parcel_id": p.parcel_id, "message": "Tillage before 15 September is not allowed without winter crop or cover crop."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "nonproductive_arable"
	p.tillage_date != null
	following_crop_tillage_allowed(p)
	p.tillage_date < sprintf("%d-08-01", [input.farm.year])
	violation := {"code": "npa_early_tillage_date", "parcel_id": p.parcel_id, "message": "Tillage for a following winter crop or cover crop is allowed only from 1 August."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "nonproductive_arable"
	p.fertilizer_used
	violation := {"code": "npa_fertilizer", "parcel_id": p.parcel_id, "message": "Fertilization is prohibited from first declaration until tillage or other declaration."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "nonproductive_arable"
	p.psm_used
	not p.psm_bio848_only
	violation := {"code": "npa_psm", "parcel_id": p.parcel_id, "message": "Plant-protection products must exclusively contain substances permitted under Regulation (EU) 2018/848."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "nonproductive_arable"
	p.removal_method != null
	not p.removal_method == "mulching"
	not p.removal_method == "incorporation"
	violation := {"code": "npa_removal_method", "parcel_id": p.parcel_id, "message": "Removal must use mechanical mulching or incorporation."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "nonproductive_arable"
	p.care_operations_this_year > 2
	violation := {"code": "npa_care_frequency", "parcel_id": p.parcel_id, "message": "No more than two mowing/mulching operations per year are allowed."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "nonproductive_arable"
	p.biomass_removed
	violation := {"code": "npa_biomass_use", "parcel_id": p.parcel_id, "message": "Mown material may not be removed or used."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "nonproductive_arable"
	p.grazed
	violation := {"code": "npa_grazing", "parcel_id": p.parcel_id, "message": "Grazing is not allowed."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "agroforestry_strip"
	p.establishment_year < 2020
	violation := {"code": "af_establishment_year", "parcel_id": p.parcel_id, "message": "An agroforestry strip must have been newly established from 2020."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "agroforestry_strip"
	not p.adjacent_to_arable
	violation := {"code": "af_adjacency", "parcel_id": p.parcel_id, "message": "Agroforestry strip must directly adjoin arable land."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "agroforestry_strip"
	p.average_width_m < 2
	violation := {"code": "af_width_min", "parcel_id": p.parcel_id, "message": "Average width must be at least 2 m."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "agroforestry_strip"
	p.average_width_m > 10
	violation := {"code": "af_width_max", "parcel_id": p.parcel_id, "message": "Average width must be no more than 10 m."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "agroforestry_strip"
	p.trees_per_100m < 10
	violation := {"code": "af_density_min", "parcel_id": p.parcel_id, "message": "At least 10 trees per 100 running metres are required."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "agroforestry_strip"
	p.trees_per_100m > 25
	violation := {"code": "af_density_max", "parcel_id": p.parcel_id, "message": "No more than 25 trees per 100 running metres are allowed."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "agroforestry_strip"
	p.max_tree_spacing_m > 15
	violation := {"code": "af_tree_spacing", "parcel_id": p.parcel_id, "message": "Tree spacing may not exceed 15 m."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "agroforestry_strip"
	p.is_special_crop
	violation := {"code": "af_special_crop", "parcel_id": p.parcel_id, "message": "Agroforestry strip may not be a special crop."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "agroforestry_strip"
	species := p.tree_species[_]
	data.negative_tree_species[_].scientific_name == species
	violation := {"code": "af_negative_species", "parcel_id": p.parcel_id, "message": sprintf("Prohibited tree species: %s.", [species])}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "agroforestry_strip"
	p.new_planting_date != null
	p.new_planting_date > sprintf("%d-05-15", [input.farm.year])
	violation := {"code": "af_planting_deadline", "parcel_id": p.parcel_id, "message": "New establishment or replacement planting occurred after 15 May."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "agroforestry_strip"
	not p.herbaceous_permanently_green
	violation := {"code": "af_green_cover", "parcel_id": p.parcel_id, "message": "Herbaceous area must be permanently green."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "agroforestry_strip"
	p.herbaceous_used
	violation := {"code": "af_herbaceous_use", "parcel_id": p.parcel_id, "message": "Use of the herbaceous area by mowing or grazing is prohibited."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "agroforestry_strip"
	p.fertilizer_used
	violation := {"code": "af_fertilizer", "parcel_id": p.parcel_id, "message": "Fertilizer is prohibited throughout the agroforestry strip."}
}

violations contains violation if {
	p := input.o6_1c.parcels[_]
	p.category == "agroforestry_strip"
	p.psm_used
	not p.repellent_bio848_only
	violation := {"code": "af_psm", "parcel_id": p.parcel_id, "message": "Only animal repellent permitted under Regulation (EU) 2018/848 is allowed."}
}

premium_band(category) := band if {
	band := data.premium_bands_eur_per_ha[_]
	band.category == category
}

following_crop_tillage_allowed(p) if {
	p.following_crop == "winter_crop"
}

following_crop_tillage_allowed(p) if {
	p.following_crop == "cover_crop"
}

modulation_factor(total_area_ha) := factor if {
	first := min([total_area_ha, 200])
	second := max([min([total_area_ha - 200, 100]), 0])
	third := max([min([total_area_ha - 300, 700]), 0])
	fourth := max([total_area_ha - 1000, 0])
	factor := (((first + (second * 0.9)) + (third * 0.85)) + (fourth * 0.75)) / total_area_ha
}
