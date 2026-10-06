package oepul.o6_17

import data.o6_17_kennarten.kennarten
import data.o6_17_rgve_schluessel.rgve_factors
import rego.v1

default eligible := false

contract_years := {2023: 6, 2024: 5, 2025: 4, 2026: 3, 2027: 2, 2028: 1}

eligible if {
	input.oepul.o6_17.participating == true
	input.farm.year >= 2023
	input.farm.year <= 2028
	first_year_access_ok
	combination_ok
	no_unresolved_contract_break
}

first_year_access_ok if {
	input.oepul.o6_17.is_first_participation_year == true
	input.land.grassland_area_ha >= 2
	input.oepul.o6_17.grassland_share_excluding_alpine_percent >= 40
	tierholding
}

first_year_access_ok if {
	input.oepul.o6_17.is_first_participation_year != true
}

combination_ok if {
	input.oepul.o6_17.combination in {"ubb", "bio", "bio_part_farm"}
}

tierholding if {
	input.oepul.o6_17.rgve_total / input.oepul.o6_17.forage_area_ha >= 0.3
}

no_unresolved_contract_break if {
	input.oepul.o6_17.grassland_break_documented != true
}

contract_duration_years := contract_years[input.oepul.o6_17.contract_start_year]

base_eligible_parcels contains parcel_id if {
	some parcel in input.land.parcels
	parcel.land_use == "grassland"
	parcel.slope_percent != null
	parcel.slope_percent < 18
	parcel.constraints.is_contract_nature_area != true
	parcel.o6_17.gloez2_or_gloez4_or_gloez9 != true
	parcel_id := parcel.parcel_id
}

bonus_eligible_parcels contains parcel_id if {
	some parcel in input.land.parcels
	parcel.land_use == "grassland"
	parcel.slope_percent != null
	bonus_slope_qualifies(parcel.slope_percent)
	parcel.o6_17.is_bergmaehder != true
	species_rich(parcel)
	parcel_id := parcel.parcel_id
}

species_rich(parcel) if {
	parcel.o6_17.is_one_cut_meadow == true
}

species_rich(parcel) if {
	count({name |
		some observed in parcel.o6_17.observed_kennarten
		name := observed.name
		kennart_exists(name)
	}) >= 5
}

bonus_slope_qualifies(slope) if {
	slope < 18
}

bonus_slope_qualifies(slope) if {
	input.farm.year >= 2025
	slope >= 18
}

kennart_exists(name) if {
	some item in kennarten
	item.name == name
}

required_soil_samples := ceil(input.oepul.o6_17.soil_basis_grassland_under_18_ha / 5)

bonus_cap_ha := max([2, input.oepul.o6_17.mown_grassland_area_ha * bonus_cap_rate])

bonus_cap_rate := 0.15 if {
	input.farm.year <= 2024
}

bonus_cap_rate := 0.25 if {
	input.farm.year >= 2025
}

base_premium_eur_per_ha := value if {
	score := input.oepul.o6_17.average_grassland_score
	score < 20
	value := 32.4
}

base_premium_eur_per_ha := value if {
	score := input.oepul.o6_17.average_grassland_score
	score >= 20
	score < 30
	value := 54
}

base_premium_eur_per_ha := value if {
	score := input.oepul.o6_17.average_grassland_score
	score >= 30
	score < 40
	value := 75.6
}

base_premium_eur_per_ha := value if {
	input.oepul.o6_17.average_grassland_score >= 40
	value := 108
}

bonus_premium_eur_per_ha := value if {
	input.farm.year == 2023
	input.oepul.o6_17.slope_percent < 18
	value := 150
}

bonus_premium_eur_per_ha := value if {
	input.farm.year == 2024
	input.oepul.o6_17.slope_percent < 18
	value := 262
}

bonus_premium_eur_per_ha := value if {
	input.farm.year >= 2025
	input.oepul.o6_17.slope_percent < 18
	value := 262
}

bonus_premium_eur_per_ha := value if {
	input.farm.year >= 2025
	input.oepul.o6_17.slope_percent >= 18
	value := 162
}

rgve_factor(species, category) := factor if {
	some item in rgve_factors
	item.species == species
	item.category == category
	factor := item.rgve_per_animal
}

premium_multiplier := 1 if {
	input.oepul.o6_17.total_farm_area_ha <= 200
}

premium_multiplier := 0.9 if {
	input.oepul.o6_17.total_farm_area_ha > 200
	input.oepul.o6_17.total_farm_area_ha <= 300
}

premium_multiplier := 0.85 if {
	input.oepul.o6_17.total_farm_area_ha > 300
	input.oepul.o6_17.total_farm_area_ha <= 1000
}

premium_multiplier := 0.75 if {
	input.oepul.o6_17.total_farm_area_ha > 1000
}

violations contains "missing_combination" if {
	not combination_ok
}

violations contains "first_year_minimum_participation" if {
	input.oepul.o6_17.is_first_participation_year == true
	not first_year_access_ok
}

violations contains "grassland_break" if {
	input.oepul.o6_17.grassland_break_documented == true
}

violations contains "soil_samples_missing" if {
	input.oepul.o6_17.soil_samples_submitted < required_soil_samples
}

decision := {
	"eligible": eligible,
	"contract_duration_years": contract_duration_years,
	"base_eligible_parcels": base_eligible_parcels,
	"bonus_eligible_parcels": bonus_eligible_parcels,
	"required_soil_samples": required_soil_samples,
	"bonus_cap_ha": bonus_cap_ha,
	"base_premium_eur_per_ha": base_premium_eur_per_ha,
	"bonus_premium_eur_per_ha": bonus_premium_eur_per_ha,
	"premium_multiplier": premium_multiplier,
	"violations": violations,
}
