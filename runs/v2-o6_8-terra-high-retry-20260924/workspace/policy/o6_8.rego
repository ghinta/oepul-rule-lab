package oepul.o6_8

import rego.v1

# Evaluation input extends the canonical profile with farm.oepul and
# land.parcels[].erosion_protection as proposed in rules/profile_changes.json.

eligible_crop(code, crop_name) if {
	data.eligible_crops[code][_] == crop_name
	not underseed_from_2025_only(crop_name)
}

eligible_crop("US", crop_name) if {
	data.eligible_crops.US_from_2025[_] == crop_name
	input.farm.year >= 2025
}

underseed_from_2025_only(crop_name) if {
	data.eligible_crops.US_from_2025[_] == crop_name
}

premium_rate(code) := rate if {
	input.farm.year == 2023
	rate := data.premium_eur_per_ha["2023"][code]
}

premium_rate(code) := rate if {
	input.farm.year >= 2024
	rate := data.premium_eur_per_ha.from_2024[code]
}

erosion_path_kg(kg_number) if {
	data.erosion_path_cadastral_communities[_].cadastral_community_number == kg_number
}

drought_harvest_exception if {
	input.farm.year == 2026
	data.drought_2026_harvest_exception.all_districts_federal_states[_] == input.farm.region.federal_state
}

drought_harvest_exception if {
	input.farm.year == 2026
	data.drought_2026_harvest_exception.districts[_] == input.farm.region.district
}

underseed_drought_exception(parcel) if {
	input.farm.year == 2026
	parcel.erosion_protection.code == "US"
	parcel.erosion_protection.underseed.ordinarily_established
	parcel.erosion_protection.underseed.mixture_partner_count >= 3
}

eligible_parcel(parcel) if {
	parcel.land_use == "arable"
	code := parcel.erosion_protection.code
	eligible_crop(code, parcel.erosion_protection.declared_crop)
	not violation_for_parcel(parcel)
}

violation_for_parcel(parcel) if {
	code := parcel.erosion_protection.code
	not eligible_crop(code, parcel.erosion_protection.declared_crop)
}

violation_for_parcel(parcel) if {
	code := parcel.erosion_protection.code
	code == "MS"
	not parcel.erosion_protection.preceding_cover_crop.qualifying_variant
}

violation_for_parcel(parcel) if {
	code := parcel.erosion_protection.code
	code == "MS"
	parcel.erosion_protection.soil_working.is_inverting_or_deep_mixing
}

violation_for_parcel(parcel) if {
	code := parcel.erosion_protection.code
	code == "MS"
	parcel.erosion_protection.soil_working.weeks_first_working_to_sowing > 4
}

violation_for_parcel(parcel) if {
	code := parcel.erosion_protection.code
	code == "DS"
	not parcel.erosion_protection.preceding_cover_crop.qualifying_variant
}

violation_for_parcel(parcel) if {
	parcel.erosion_protection.code == "AH"
	parcel.erosion_protection.ridges.spacing_m > 2
}

violation_for_parcel(parcel) if {
	parcel.erosion_protection.code == "AH"
	not parcel.erosion_protection.ridges.maintained_until_haulm_reduction
}

violation_for_parcel(parcel) if {
	parcel.erosion_protection.code == "BAW"
	parcel.erosion_protection.erosion_path_share < 0.25
}

violation_for_parcel(parcel) if {
	parcel.erosion_protection.code == "BAW"
	not erosion_path_kg(parcel.erosion_protection.cadastral_community_number)
}

violation_for_parcel(parcel) if {
	parcel.erosion_protection.code == "BAW"
	parcel.erosion_protection.baw.is_new_sowing
	parcel.erosion_protection.baw.sowing_date > sprintf("%d-05-15", [input.farm.year])
}

violation_for_parcel(parcel) if {
	parcel.erosion_protection.code == "BAW"
	parcel.erosion_protection.baw.is_new_sowing
	parcel.erosion_protection.baw.legume_share_percent >= 50
}

violation_for_parcel(parcel) if {
	parcel.erosion_protection.code == "BAW"
	parcel.erosion_protection.baw.psm_or_fertilizer_used_since_first_declaration
}

violation_for_parcel(parcel) if {
	parcel.erosion_protection.code == "US"
	parcel.erosion_protection.underseed.mixture_partner_count < 3
}

violation_for_parcel(parcel) if {
	parcel.erosion_protection.code == "US"
	parcel.erosion_protection.underseed.sowing_date > parcel.erosion_protection.underseed.latest_permitted_date
}

violation_for_parcel(parcel) if {
	parcel.erosion_protection.code == "US"
	parcel.erosion_protection.underseed.soil_working_or_herbicide_after_sowing
}

violation_for_parcel(parcel) if {
	parcel.erosion_protection.code == "US"
	not parcel.erosion_protection.underseed.maintained_until_main_crop_harvest
}

violation_for_parcel(parcel) if {
	parcel.erosion_protection.code == "US"
	parcel.erosion_protection.underseed.harvested_with_main_crop
}

violations contains violation if {
	parcel := input.land.parcels[_]
	violation_for_parcel(parcel)
	violation := {"rule": "O68.parcel-conditions", "parcel_id": parcel.parcel_id, "message": "Eine verfahrensbezogene Förderbedingung ist nicht erfüllt."}
}

violations contains violation if {
	sum([parcel.area_ha | parcel := input.land.parcels[_]; eligible_parcel(parcel)]) < 0.10
	violation := {"rule": "O68.minimum-area", "message": "Jährliche Mindestteilnahmefläche von 0,10 ha nicht erreicht."}
}

eligible_area_ha := sum([parcel.area_ha | parcel := input.land.parcels[_]; eligible_parcel(parcel)])

gross_premium_eur := sum([amount |
	parcel := input.land.parcels[_]
	eligible_parcel(parcel)
	rate := premium_rate(parcel.erosion_protection.code)
	amount := parcel.area_ha * rate
])
