package o6_1a

import rego.v1

contract_end := "2028-12-31"

arable_minimum_ok if {
	input.land.arable_area_ha <= 2
}

arable_minimum_ok if {
	input.land.arable_area_ha > 2
	input.documentation.arable_div_ha >= 0.07 * input.land.arable_area_ha
}

grassland_minimum_ok if {
	input.land.grassland_area_ha <= 2
}

grassland_minimum_ok if {
	input.land.grassland_area_ha > 2
	input.documentation.grassland_div_ha >= 0.07 * input.land.grassland_area_ha
}

arable_fieldpiece_ok if {
	input.land.arable_area_ha < 10
}

arable_fieldpiece_ok if {
	input.land.arable_area_ha >= 10
	every fieldpiece in input.documentation.arable_fieldpieces {
		arable_fieldpiece_satisfied(fieldpiece)
	}
}

arable_fieldpiece_satisfied(fieldpiece) if {
	fieldpiece.area_ha <= 5
}

arable_fieldpiece_satisfied(fieldpiece) if {
	fieldpiece.area_ha > 5
	fieldpiece.div_plus_eligible_ha >= 0.15
}

grassland_fieldpiece_ok if {
	input.land.grassland_area_ha < 10
}

grassland_fieldpiece_ok if {
	input.land.grassland_area_ha >= 10
	every fieldpiece in input.documentation.grassland_fieldpieces {
		grassland_fieldpiece_satisfied(fieldpiece)
	}
}

grassland_fieldpiece_satisfied(fieldpiece) if {
	fieldpiece.mown_area_ha <= 5
}

grassland_fieldpiece_satisfied(fieldpiece) if {
	fieldpiece.mown_area_ha > 5
	fieldpiece.div_plus_eligible_ha >= 0.15
}

arable_maintenance_ok if {
	input.farm.year < 2025
	input.documentation.arable_uses_in_two_years >= 1
	input.documentation.arable_uses_this_year <= 2
	input.documentation.arable_grazing == false
	input.documentation.arable_threshing == false
}

arable_maintenance_ok if {
	input.farm.year >= 2025
	input.documentation.arable_uses_in_two_years >= 1
	input.documentation.arable_uses_this_year <= 2
	input.documentation.arable_threshing == false
	input.documentation.arable_grazing == false
}

arable_maintenance_ok if {
	input.farm.year >= 2025
	input.documentation.arable_uses_in_two_years >= 1
	input.documentation.arable_uses_this_year <= 2
	input.documentation.arable_threshing == false
	input.documentation.arable_grazing == true
	input.documentation.arable_first_grazing_date >= "08-01"
}

arable_inputs_ok if {
	input.documentation.arable_psm_used == false
	input.documentation.arable_fertilizer_used == false
	input.documentation.arable_removal_method == "mechanical"
}

grassland_nfz_ok if {
	input.documentation.grassland_fallow_days >= 63
	input.documentation.grassland_vehicle_entry_during_fallow == false
	input.documentation.grassland_fertilization_during_fallow == false
	input.documentation.grassland_second_use == true
}

regional_seed_ok if {
	input.documentation.regional_seed_species_count >= 30
	input.documentation.regional_seed_plant_families >= 7
	input.documentation.regional_seed_rate_kg_per_ha >= 20
	input.documentation.regional_seed_max_species_weight_share <= 0.05
	input.documentation.regional_origin_proven == true
}

regional_grassland_seed_ok if {
	input.documentation.regional_grassland_number >= 30
	input.land.parcels[0].slope_percent < 18
	regional_seed_ok
}

wild_bird_ok if {
	input.documentation.wild_bird_cereal == true
	input.documentation.wild_bird_row_spacing_cm >= 20
	input.documentation.wild_bird_undersown == false
	input.documentation.wild_bird_protected_period_compliant == true
}

pheromone_ok if {
	input.farm.year >= 2025
	input.documentation.pheromone_traps_per_ha >= 15
	input.documentation.pheromone_days_after_sowing <= 14
	input.documentation.pheromone_field_days >= 35
	input.documentation.pheromone_emptyings >= 2
	input.documentation.pheromone_records_complete == true
}

modulation_factor := 1 if {
	input.land.total_area_ha <= 200
}

modulation_factor := (200 + ((input.land.total_area_ha - 200) * 0.9)) / input.land.total_area_ha if {
	input.land.total_area_ha > 200
	input.land.total_area_ha <= 300
}

modulation_factor := ((200 + (100 * 0.9)) + ((input.land.total_area_ha - 300) * 0.85)) / input.land.total_area_ha if {
	input.land.total_area_ha > 300
	input.land.total_area_ha <= 1000
}

modulation_factor := (((200 + (100 * 0.9)) + (700 * 0.85)) + ((input.land.total_area_ha - 1000) * 0.75)) / input.land.total_area_ha if {
	input.land.total_area_ha > 1000
}

arable_base_premium := data.premium_rates_eur_per_ha.arable_base["2023"] if {
	input.farm.year == 2023
}

arable_base_premium := data.premium_rates_eur_per_ha.arable_base["2024"] if {
	input.farm.year == 2024
}

arable_base_premium := data.premium_rates_eur_per_ha.arable_base["2025_plus"] if {
	input.farm.year >= 2025
}

grassland_base_premium := data.premium_rates_eur_per_ha.grassland_base_livestock["2024_plus"] if {
	input.farm.year >= 2024
	input.documentation.livestock_status == "livestock"
}

grassland_base_premium := data.premium_rates_eur_per_ha.grassland_base_non_livestock["2024_plus"] if {
	input.farm.year >= 2024
	input.documentation.livestock_status == "non_livestock"
}

drought_third_use_allowed if {
	input.farm.year == 2026
	input.documentation.drought_2026.third_use == true
	input.documentation.drought_2026.relief_code in {"OPUBB", "OPBIO"}
}

deny contains "arable_7_percent" if {
	not arable_minimum_ok
}

deny contains "grassland_7_percent" if {
	not grassland_minimum_ok
}

deny contains "arable_fieldpiece_0_15_ha" if {
	not arable_fieldpiece_ok
}

deny contains "grassland_fieldpiece_0_15_ha" if {
	not grassland_fieldpiece_ok
}

deny contains "arable_maintenance" if {
	not arable_maintenance_ok
}

deny contains "arable_inputs" if {
	not arable_inputs_ok
}

deny contains "grassland_nfz" if {
	input.land.parcels[0].biodiversity_management.variant == "DIVNFZ"
	not grassland_nfz_ok
}

deny contains "regional_seed" if {
	input.documentation.regional_seed == true
	not regional_seed_ok
}

deny contains "pheromone" if {
	input.documentation.pheromone == true
	not pheromone_ok
}

decision := {
	"eligible": count(deny) == 0,
	"deny": deny,
	"contract_end": contract_end,
}
