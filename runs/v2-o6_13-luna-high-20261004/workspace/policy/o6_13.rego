package oepul.o6_13

import rego.v1

default eligible := false

farm := object.get(input, "farm", {})
land := object.get(input, "land", {})
application := object.get(farm, "measure_application", {})
parcels := object.get(land, "parcels", [])
region := object.get(farm, "region", {})

default application_deadline_met := false

default entry_year_valid := false

default operation_program_exclusion := false

default minimum_business_size_met := false

default all_selected_parcels_valid := false

default contract_active := false

default premium_per_ha := 0

default modulation_factor := 1

selected_parcels := [p | p := parcels[_]; object.get(object.get(p, "measure_application", {}), "requested", false) == true]

eligible_selected_parcels := [p |
	p := selected_parcels[_]
	parcel_is_eligible(p)
]

selected_area_ha := sum([p.area_ha | p := eligible_selected_parcels[_]])

parcel_is_eligible(p) if {
	pc := object.get(p, "protected_cultivation", {})
	pc.is_protected_cultivation == true
	pc.active_production == true
	pc.structure_type in data.o6_13_reference_data.eligible_structure_types
	pc.cultivation_medium in data.o6_13_reference_data.eligible_cultivation_media
	pc.area_role in data.o6_13_reference_data.eligible_area_roles
	not excluded_area_role(pc.area_role)
	aisle_scope_valid(pc)
	object.get(object.get(p, "measure_application", {}), "code", "") == "NUE"
	land_use_matches(p)
}

excluded_area_role(role) if {
	role in data.o6_13_reference_data.excluded_area_roles
}

aisle_scope_valid(pc) if {
	pc.area_role != "necessary_aisle"
}

aisle_scope_valid(pc) if {
	pc.area_role == "necessary_aisle"
	object.get(pc, "aisle_necessary", false) == true
}

land_use_matches(p) if {
	pc := object.get(p, "protected_cultivation", {})
	medium := object.get(pc, "classification_medium_april_1", pc.cultivation_medium)
	p.land_use == data.o6_13_reference_data.eligible_land_use_by_medium[medium]
}

application_deadline_met if {
	year := application.contract_year
	application.submitted_by <= sprintf("%d-12-31", [year - 1])
}

entry_year_valid if {
	application.contract_year >= 2023
	application.contract_year <= data.o6_13_reference_data.maximum_entry_year
}

operation_program_exclusion if {
	program := object.get(farm, "operation_program", {})
	program.member == true
	program.organism_use_compensated == true
}

minimum_business_size_met if {
	object.get(application, "first_participation", false) == false
}

minimum_business_size_met if {
	object.get(application, "first_participation", false) == true
	selected_area_ha >= data.o6_13_reference_data.minimum_participation_area_ha
}

minimum_business_size_met if {
	object.get(application, "first_participation", false) == true
	protected_area_ha := sum([p.area_ha | p := parcels[_]; object.get(object.get(p, "protected_cultivation", {}), "is_protected_cultivation", false) == true])
	agricultural_area_ha := ((object.get(land, "arable_area_ha", 0) + object.get(land, "grassland_area_ha", 0)) + object.get(land, "special_crops_area_ha", 0)) + object.get(land, "alpine_pasture_area_ha", 0)
	protected_area_ha < data.o6_13_reference_data.minimum_participation_area_ha
	agricultural_area_ha + sum([p.area_ha | p := parcels[_]; p.land_use == "special_crop"; object.get(object.get(p, "protected_cultivation", {}), "is_protected_cultivation", false) == true]) >= data.o6_13_reference_data.general_alternative_area_ha
}

harvest_requirement_met(p) if {
	object.get(object.get(p, "measure_application", {}), "harvested_percent", 0) >= data.o6_13_reference_data.harvest_minimum_percent
	object.get(object.get(p, "measure_application", {}), "proper_cultivation", false) == true
	object.get(object.get(p, "measure_application", {}), "proper_annual_care", false) == true
}

harvest_requirement_met(p) if {
	application.contract_year == 2026
	application.drought_no_harvestable_stock == true
	region_in_drought_scope
	object.get(object.get(p, "measure_application", {}), "crop_is_late_summer_or_autumn", false) == true
	object.get(object.get(p, "measure_application", {}), "proper_cultivation", false) == true
	object.get(object.get(p, "measure_application", {}), "proper_annual_care", false) == true
}

region_in_drought_scope if {
	districts := data.o6_13_reference_data.drought_2026_automatic_higher_force_districts[region.federal_state]
	districts[_] == "all"
}

region_in_drought_scope if {
	districts := data.o6_13_reference_data.drought_2026_automatic_higher_force_districts[region.federal_state]
	districts[_] == region.district
}

record_complete(p) if {
	record := object.get(p, "organism_application", {})
	record.organism_type != ""
	record.quantity > 0
	record.ages_register_entry == true
	record.application_rate_compliant == true
	record.replaces_plant_protection_use == true
	record.purchase_evidence == true
	record.reason != ""
	record.goal != ""
	record.date != ""
	record.is_pollinator_only != true
}

all_selected_parcels_valid if {
	count(selected_parcels) > 0
	count(eligible_selected_parcels) == count(selected_parcels)
	[true | p := selected_parcels[_]; harvest_requirement_met(p)] == [true | _ := selected_parcels[_]]
	[true | p := selected_parcels[_]; record_complete(p)] == [true | _ := selected_parcels[_]]
	[true | p := selected_parcels[_]; object.get(object.get(p, "measure_application", {}), "other_premium", false) != true] == [true | _ := selected_parcels[_]]
}

contract_active if {
	application.contract_year == input.farm.year
	count(eligible_selected_parcels) > 0
}

eligible if {
	application.requested == true
	region.country == "AT"
	entry_year_valid
	application_deadline_met
	not operation_program_exclusion
	minimum_business_size_met
	all_selected_parcels_valid
	contract_active
}

premium_per_ha := data.o6_13_reference_data.premium_eur_per_ha["2023"] if {
	application.contract_year == 2023
}

premium_per_ha := data.o6_13_reference_data.premium_eur_per_ha.from_2024 if {
	application.contract_year >= 2024
}

modulation_factor := 1 if {
	area := object.get(land, "total_area_ha", 0)
	area <= 200
}

modulation_factor := (200 + ((area - 200) * 0.9)) / area if {
	area := object.get(land, "total_area_ha", 0)
	area > 200
	area <= 300
}

modulation_factor := ((200 + (100 * 0.9)) + ((area - 300) * 0.85)) / area if {
	area := object.get(land, "total_area_ha", 0)
	area > 300
	area <= 1000
}

modulation_factor := (((200 + (100 * 0.9)) + (700 * 0.85)) + ((area - 1000) * 0.75)) / area if {
	area := object.get(land, "total_area_ha", 0)
	area > 1000
}

premium_eur := (premium_per_ha * selected_area_ha) * modulation_factor if {
	eligible
}

default premium_eur := 0

decision := {
	"eligible": eligible,
	"contract_active": contract_active,
	"selected_area_ha": selected_area_ha,
	"premium_eur_per_ha": premium_per_ha,
	"modulation_factor": modulation_factor,
	"premium_eur": premium_eur,
	"entry_year_valid": entry_year_valid,
	"minimum_business_size_met": minimum_business_size_met,
	"application_deadline_met": application_deadline_met,
	"operation_program_exclusion": operation_program_exclusion,
}
