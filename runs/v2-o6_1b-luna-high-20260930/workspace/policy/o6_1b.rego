package o6_1b

import rego.v1

default eligible := false

default bio_certification_valid := false

default contract_duration_valid := false

default farm_size_valid := false

default animal_rules_valid := false

default arable_diversification_valid := false

default arable_biodiversity_minimum_valid := false

default grassland_biodiversity_minimum_valid := false

default arable_field_biodiversity_valid := true

default grassland_field_biodiversity_valid := true

default arable_biodiversity_management_valid := false

default grassland_biodiversity_management_valid := false

default regional_seed_valid := false

default monitoring_valid := false

default pheromone_valid := false

default circular_arable_valid := false

default circular_grassland_valid := false

arable_div_codes := data.o6_1b_eligible_lists.bio_div_codes
grassland_div_codes := data.o6_1b_eligible_lists.grassland_div_codes

regional_arable_species := {item.name | item := data.o6_1b_autochthone_species.regional_arable[_]}
regional_grassland_species := {item.name | item := data.o6_1b_autochthone_species.regional_grassland[_]}

rare_crop_listed if {
	input.crop.variety == data.o6_1b_rare_crop_varieties.varieties[_].variety
}

rgve_factor := factor if {
	factor := data.o6_1b_rgve[input.livestock.category]
}

arable_base_premium := data.o6_1b_premiums.years[sprintf("%v", [year])].arable_base
grassland_non_livestock_premium := data.o6_1b_premiums.years[sprintf("%v", [year])].grassland_base_non_livestock
transaction_cost_premium := data.o6_1b_premiums.years[sprintf("%v", [year])].transaction_costs

year := object.get(input, "year", 2026)

bio_certification_valid if {
	input.certifications.organic.is_certified == true
	input.certifications.organic.control_body != null
}

contract_duration_valid if {
	input.contract.start_year >= 2023
	input.contract.start_year <= 2025
	input.contract.end_date == "2028-12-31"
}

farm_size_valid if {
	input.first_participation_year != year
}

farm_size_valid if {
	input.first_participation_year == year
	input.land.protected_cultivation_area_ha >= 0.5
}

farm_size_valid if {
	input.first_participation_year == year
	input.land.total_area_ha >= 1.5
}

animal_rules_valid if {
	input.livestock.has_livestock == false
}

animal_rules_valid if {
	input.livestock.uncertified_fattening_pigs <= 2
	input.livestock.uncertified_chickens <= 10
	input.livestock.conventional_equines_only != true
}

animal_rules_valid if {
	input.livestock.conventional_equines_only == true
	input.livestock.biological_equines == 0
}

arable_diversification_valid if {
	input.land.arable_area_ha <= 5
}

arable_diversification_valid if {
	input.land.arable_area_ha > 5
	input.land.grain_and_maize_share <= 0.75
	input.land.max_crop_share <= 0.55
}

arable_biodiversity_minimum_valid if {
	input.land.arable_area_ha <= 2
}

arable_biodiversity_minimum_valid if {
	input.land.arable_area_ha > 2
	input.land.arable_biodiversity_area_ha >= input.land.arable_area_ha * 0.07
}

arable_biodiversity_minimum_valid if {
	input.land.arable_area_ha > 2
	input.land.arable_area_ha < 10
	input.land.arable_biodiversity_area_ha + input.land.grassland_biodiversity_area_for_arable_ha >= (input.land.arable_area_ha + input.land.mowed_grassland_area_ha) * 0.07
}

grassland_biodiversity_minimum_valid if {
	input.land.mowed_grassland_area_ha <= 2
}

grassland_biodiversity_minimum_valid if {
	input.land.mowed_grassland_area_ha > 2
	input.land.grassland_biodiversity_area_ha >= input.land.mowed_grassland_area_ha * 0.07
}

arable_field_biodiversity_valid if {
	input.land.arable_area_ha < 10
}

arable_field_biodiversity_valid if {
	input.land.arable_area_ha >= 10
	input.land.arable_fields_with_more_than_5ha_are_valid == true
}

grassland_field_biodiversity_valid if {
	input.land.mowed_grassland_area_ha < 10
}

grassland_field_biodiversity_valid if {
	input.land.mowed_grassland_area_ha >= 10
	input.land.grassland_fields_with_more_than_5ha_are_valid == true
}

arable_biodiversity_management_valid if {
	input.biodiversity.arable.sown_date <= sprintf("%v-05-15", [year])
	input.biodiversity.arable.insect_pollinated_partners >= 7
	input.biodiversity.arable.plant_families >= 3
	input.biodiversity.arable.non_insect_pollinated_share <= 0.10
	input.biodiversity.arable.minimum_duration_years >= 2
	input.biodiversity.arable.fertilizer_used == false
}

arable_biodiversity_management_valid if {
	input.biodiversity.arable.exempt_from_new_sowing == true
	input.biodiversity.arable.minimum_duration_years >= 2
	input.biodiversity.arable.fertilizer_used == false
}

grassland_biodiversity_management_valid if {
	input.biodiversity.grassland.variant in data.o6_1b_eligible_lists.grassland_div_codes
	input.biodiversity.grassland.annual_mowing_with_removal == true
}

regional_seed_valid if {
	input.biodiversity.regional_seed.kind in {"arable", "grassland"}
	input.biodiversity.regional_seed.species_count >= 30
	input.biodiversity.regional_seed.family_count >= 7
	input.biodiversity.regional_seed.seed_rate_kg_ha >= 20
	input.biodiversity.regional_seed.max_single_species_share <= 0.05
	input.biodiversity.regional_seed.regional_origin_documented == true
	input.biodiversity.regional_seed.sown_date <= sprintf("%v-05-15", [year])
}

regional_seed_valid if {
	input.biodiversity.regional_seed.ecotype_seed == true
	input.biodiversity.regional_seed.species_count >= 30
	input.biodiversity.regional_seed.family_count >= 7
	input.biodiversity.regional_seed.seed_rate_kg_ha >= 20
	input.biodiversity.regional_seed.regional_origin_documented == true
}

monitoring_valid if {
	input.monitoring.participation_confirmation == true
	input.monitoring.introductory_event_completed == true
	input.monitoring.data_submitted_annually == true
}

monitoring_valid if {
	input.monitoring.program == "biodiversity"
	input.monitoring.participation_confirmation == true
	input.monitoring.data_submitted_annually == true
}

monitoring_valid if {
	input.monitoring.program == "great_bustard"
	input.monitoring.participation_confirmation == true
	input.monitoring.nature_measure == true
	input.monitoring.ta01_on_at_least_one_parcel == true
}

monitoring_valid if {
	input.monitoring.program == "phenology"
	input.monitoring.participation_confirmation == true
	input.monitoring.nature_measure == true
	input.monitoring.has_gl06_gl15_or_gl25 == true
}

pheromone_valid if {
	year >= 2025
	input.pheromone_traps.is_sugar_beet_or_previous_sugar_beet_parcel == true
	input.pheromone_traps.traps_per_ha >= 15
	input.pheromone_traps.days_on_field >= 35
	input.pheromone_traps.emptyings_during_minimum_period >= 2
	input.pheromone_traps.records_complete == true
}

circular_arable_valid if {
	year >= 2025
	input.land.circular_arable_share > 0.15
	input.livestock.average_rgve_per_forage_ha < 1.4
	input.land.circular_arable_crop_is_eligible == true
}

circular_grassland_valid if {
	year >= 2025
	input.land.circular_grassland_share > 0.08
	input.livestock.is_forage_eating_livestock_farm == true
	input.livestock.average_rgve_per_forage_ha < 1.4
}

eligible if {
	bio_certification_valid
	contract_duration_valid
	farm_size_valid
	animal_rules_valid
	arable_diversification_valid
	arable_biodiversity_minimum_valid
	grassland_biodiversity_minimum_valid
	arable_field_biodiversity_valid
	grassland_field_biodiversity_valid
}

arable_biodiversity_deadline_valid if {
	input.biodiversity.arable.use_date >= sprintf("%v-08-01", [year])
}

arable_biodiversity_deadline_valid if {
	input.biodiversity.arable.unrestricted_share <= 0.25
}

arable_biodiversity_deadline_valid if {
	input.biodiversity.arable.invasive_species_share > 0.25
	input.biodiversity.arable.invasive_species_evidence == true
}

grassland_variant_valid if {
	input.biodiversity.grassland.variant == "DIVSZ"
	input.biodiversity.grassland.first_use_date >= "06-15"
	input.biodiversity.grassland.mowing_with_removal == true
}

grassland_variant_valid if {
	input.biodiversity.grassland.variant == "DIVNFZ"
	input.biodiversity.grassland.dormant_days >= 63
	input.biodiversity.grassland.second_use_in_year == true
}

grassland_variant_valid if {
	input.biodiversity.grassland.variant == "DIVAGF"
	input.biodiversity.grassland.last_use_date <= "08-15"
	input.biodiversity.grassland.mowing_with_removal == true
}

grassland_variant_valid if {
	input.biodiversity.grassland.variant == "DIVRS"
	input.biodiversity.grassland.first_use_date >= "07-15"
	input.biodiversity.grassland.max_uses_per_year <= 2
	input.biodiversity.grassland.mowing_with_removal == true
	input.biodiversity.grassland.fertilizer_only_manure_or_compost == true
}

management_code_for_2026_exception := code if {
	input.year == 2026
	input.biodiversity.early_use_before_august == true
	code := "OPBIO"
}

management_code_for_2026_exception := code if {
	input.year == 2026
	input.biodiversity.third_arable_use == true
	code := "OPBIO"
}

management_code_for_2026_exception := code if {
	input.year == 2026
	input.biodiversity.early_use_before_august != true
	input.biodiversity.third_arable_use != true
	code := null
}

premium_cap_factor := factor if {
	input.land.total_area_ha <= 200
	factor := 1.0
}

premium_cap_factor := factor if {
	input.land.total_area_ha > 200
	input.land.total_area_ha <= 300
	factor := (200 + ((input.land.total_area_ha - 200) * 0.9)) / input.land.total_area_ha
}

premium_cap_factor := factor if {
	input.land.total_area_ha > 300
	input.land.total_area_ha <= 1000
	factor := ((200 + (100 * 0.9)) + ((input.land.total_area_ha - 300) * 0.85)) / input.land.total_area_ha
}

premium_cap_factor := factor if {
	input.land.total_area_ha > 1000
	factor := (((200 + (100 * 0.9)) + (700 * 0.85)) + ((input.land.total_area_ha - 1000) * 0.75)) / input.land.total_area_ha
}

premium_cap_factor := 1.0 if not input.land.total_area_ha
