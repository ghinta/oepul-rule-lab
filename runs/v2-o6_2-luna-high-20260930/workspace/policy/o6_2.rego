package oepul.o6_2

import rego.v1

default eligible_surface := false

default external_n_ok := false

default livestock_n_ok := false

default course_ok := false

default ubb_combination_ok := false

default application_ok := false

default eligible_for_drought_harvest_exception := false

default all_psm_ok := true

default organic_combination_ok := false

default purchase_storage_ok := false

default premium_cap_ok := false

eligible_surface if {
	parcel := input.land.parcels[0]
	parcel.land_use in data.crop_lists.eligible_land_use
	parcel.land_use != "special_crop"
}

eligible_surface if {
	parcel := input.land.parcels[0]
	parcel.land_use == "special_crop"
	parcel.crop.crop_category in data.crop_lists.eligible_special_crop_categories
}

is_ackerfutter(parcel) if {
	parcel.crop.crop_name in data.crop_lists.ackerfutter
}

needs_flach_psm_restriction(parcel) if {
	parcel.land_use == "grassland"
}

needs_flach_psm_restriction(parcel) if {
	parcel.land_use == "arable"
	is_ackerfutter(parcel)
}

fodder_or_grassland(parcel) if {
	is_ackerfutter(parcel)
}

fodder_or_grassland(parcel) if {
	parcel.land_use == "grassland"
}

non_fodder_or_grassland(parcel) if {
	parcel.land_use == "grassland"
}

non_fodder_or_grassland(parcel) if {
	parcel.land_use == "arable"
	not is_ackerfutter(parcel)
}

district_in_exception(location) if {
	location == "all"
}

district_in_exception(location) if {
	location != "all"
	input.region.district in location
}

external_n_ok if {
	input.farm.compliance.external_n_fertilizer_kg == 0
}

livestock_n_ok if {
	input.farm.compliance.livestock_n_kg_per_ha <= 170
}

fertilizer_source_allowed(source) if {
	source in {"external_manure", "permitted_compost", "biogas_return", "non_nitrogen", "domestic_wastewater"}
}

fertilizer_source_prohibited(source) if {
	source in {"other_organic_residue", "sewage_sludge"}
}

purchase_storage_ok if {
	input.farm.compliance.purchase_storage_records_complete
}

organic_combination_ok if {
	not input.program.o6_1b.participates
}

organic_combination_ok if {
	input.program.o6_1b.participates
	input.program.o6_1b.partial_farm
	input.land.parcels[0].crop.crop_category in {"orchard", "vineyard", "hop"}
}

orchard_premium_eligible if {
	input.land.parcels[0].crop.crop_category != "orchard"
}

orchard_premium_eligible if {
	input.land.parcels[0].crop.crop_category == "orchard"
	input.land.parcels[0].crop.planting_material_quality in {"grafted", "high_quality_grafted"}
}

animal_rgve(animal) := value if {
	some entry in data.rgve_key.entries
	entry.id == animal.category
	value := animal.animal_count * entry.rgve
}

total_rgve := value if {
	values := [animal_rgve(animal) | some animal in input.livestock.species_groups]
	value := sum(values)
}

rgve_per_forage_ha := value if {
	input.farm.forage_area_ha > 0
	value := total_rgve / input.farm.forage_area_ha
}

animal_holding if {
	rgge := rgve_per_forage_ha
	rgge >= 0.3
}

premium_tier := "not_animal_holding" if {
	not animal_holding
}

premium_tier := "animal_holding_below_1_40" if {
	animal_holding
	rgge := rgve_per_forage_ha
	rgge < 1.4
}

premium_tier := "animal_holding_at_least_1_40" if {
	animal_holding
	rgge := rgve_per_forage_ha
	rgge >= 1.4
}

premium_rate(parcel) := 0 if {
	input.application_year >= 2023
	input.application_year <= 2028
	parcel.land_use in {"arable", "grassland"}
	fodder_or_grassland(parcel)
	premium_tier == "not_animal_holding"
}

premium_rate(parcel) := 70 if {
	input.application_year == 2023
	parcel.land_use in {"arable", "grassland"}
	fodder_or_grassland(parcel)
	premium_tier == "animal_holding_below_1_40"
}

premium_rate(parcel) := 75.6 if {
	input.application_year >= 2024
	input.application_year <= 2028
	parcel.land_use in {"arable", "grassland"}
	fodder_or_grassland(parcel)
	premium_tier == "animal_holding_below_1_40"
}

premium_rate(parcel) := 60 if {
	input.application_year == 2023
	parcel.land_use in {"arable", "grassland"}
	non_fodder_or_grassland(parcel)
	premium_tier == "animal_holding_at_least_1_40"
}

premium_rate(parcel) := 64.8 if {
	input.application_year >= 2024
	input.application_year <= 2028
	parcel.land_use in {"arable", "grassland"}
	non_fodder_or_grassland(parcel)
	premium_tier == "animal_holding_at_least_1_40"
}

premium_rate(parcel) := 60 if {
	input.application_year == 2023
	parcel.land_use in {"arable", "grassland"}
	fodder_or_grassland(parcel)
	premium_tier == "animal_holding_at_least_1_40"
}

premium_rate(parcel) := 64.8 if {
	input.application_year >= 2024
	input.application_year <= 2028
	parcel.land_use in {"arable", "grassland"}
	fodder_or_grassland(parcel)
	premium_tier == "animal_holding_at_least_1_40"
}

premium_rate(parcel) := 60 if {
	input.application_year == 2023
	parcel.land_use == "arable"
	not is_ackerfutter(parcel)
}

premium_rate(parcel) := 64.8 if {
	input.application_year >= 2024
	input.application_year <= 2028
	parcel.land_use == "arable"
	not is_ackerfutter(parcel)
}

premium_rate(parcel) := 60 if {
	input.application_year == 2023
	parcel.land_use == "special_crop"
	parcel.crop.crop_category in {"orchard", "vineyard", "hop"}
}

premium_rate(parcel) := 64.8 if {
	input.application_year >= 2024
	input.application_year <= 2028
	parcel.land_use == "special_crop"
	parcel.crop.crop_category in {"orchard", "vineyard", "hop"}
}

course_ok if {
	input.farm.training.hours >= 3
	input.farm.training.completed_by <= "2025-12-31"
	input.farm.training.course_date >= "2022-01-01"
	input.farm.training.provider_approved
	input.farm.training.double_counted == false
}

ubb_combination_ok if {
	input.program.o6_2.participates
	input.program.o6_1a.participates
}

application_ok if {
	input.program.o6_2.participates
	input.program.o6_2.application_date <= sprintf("%d-12-31", [input.program.o6_2.application_year - 1])
	input.program.o6_2.application_year >= 2023
	input.program.o6_2.application_year <= 2025
}

psm_application_allowed(application) if {
	application.bio_allowed
}

psm_application_allowed(application) if {
	application.individual_plant_treatment
}

parcel_psm_ok(parcel) if {
	not needs_flach_psm_restriction(parcel)
}

parcel_psm_ok(parcel) if {
	needs_flach_psm_restriction(parcel)
	not parcel.operations.psm_used
}

parcel_psm_ok(parcel) if {
	needs_flach_psm_restriction(parcel)
	parcel.operations.seed_treatment == false
	applications := parcel.operations.psm_applications
	count(applications) > 0
	not disallowed_application(applications)
}

disallowed_application(applications) if {
	some application in applications
	not psm_application_allowed(application)
}

all_psm_ok if {
	all_ok := [parcel_psm_ok(parcel) | some parcel in input.land.parcels]
	every ok in all_ok { ok }
}

eligible_for_drought_harvest_exception if {
	input.application_year == 2026
	input.region.federal_state in object.keys(data.drought_2026.automatic_higher_force_states)
	location := data.drought_2026.automatic_higher_force_states[input.region.federal_state]
	district_in_exception(location)
	parcel := input.land.parcels[0]
	parcel.land_use == "arable"
	parcel.late_summer_or_autumn_harvest_crop
	parcel.no_harvestable_stand_due_to_drought
}

premium_cap_ok if {
	parcel := input.land.parcels[0]
	parcel.combined_area_payments_eur_per_ha <= 1300
}

modulation_factor := 1 if {
	input.land.total_area_ha <= 200
}

modulation_factor := 0.9 if {
	input.land.total_area_ha > 200
	input.land.total_area_ha <= 300
}

modulation_factor := 0.85 if {
	input.land.total_area_ha > 300
	input.land.total_area_ha <= 1000
}

modulation_factor := 0.75 if {
	input.land.total_area_ha > 1000
}

decision := {
	"eligible_surface": eligible_surface,
	"external_n_ok": external_n_ok,
	"livestock_n_ok": livestock_n_ok,
	"all_psm_ok": all_psm_ok,
	"course_ok": course_ok,
	"ubb_combination_ok": ubb_combination_ok,
	"application_ok": application_ok,
	"organic_combination_ok": organic_combination_ok,
	"purchase_storage_ok": purchase_storage_ok,
	"premium_cap_ok": premium_cap_ok,
	"modulation_factor": modulation_factor,
	"premium_tier": premium_tier,
	"drought_harvest_exception": eligible_for_drought_harvest_exception,
}
