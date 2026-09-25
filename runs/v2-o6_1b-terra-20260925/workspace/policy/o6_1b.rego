package oepul.o6_1b

import rego.v1

# Executable checks deliberately consume the oepul extension proposed in
# profile_changes.json; absent observations produce "unknown", not approval.
default decision := {"eligible": false, "violations": ["missing_oepul_observations"]}

required_arable_biodiversity := input.land.arable_area_ha * 0.07 if {
	input.land.arable_area_ha > 2
}

required_arable_biodiversity := 0 if {
	input.land.arable_area_ha <= 2
}

required_grassland_biodiversity := input.oepul.mown_grassland_ha * 0.07 if {
	input.oepul.mown_grassland_ha > 2
}

required_grassland_biodiversity := 0 if {
	input.oepul.mown_grassland_ha <= 2
}

is_livestock_holder if {
	input.oepul.rgve_total / input.oepul.fodder_area_ha >= 0.30
}

# Closed tables are data, rather than hard-coded rule text.  Callers can use
# these helpers when translating declared animal and variety records.
rgve_per_head(class) := data.rgve_per_head[class] if {
	data.rgve_per_head[class]
}

rare_variety_tier(variety) := entry.tier if {
	some entry in data.rare_varieties
	entry.variety == variety
}

regional_seed_species(kind) := data.regional_seed_species[kind] if {
	data.regional_seed_species[kind]
}

violations contains "organic_registration_or_control_contract_missing" if {
	not input.farm.certifications.organic.is_certified
}

violations contains "arable_cereal_maize_share_over_75_percent" if {
	input.land.arable_area_ha > 5
	input.oepul.cereal_maize_ha / input.land.arable_area_ha > 0.75
}

violations contains "arable_single_crop_share_over_55_percent" if {
	input.land.arable_area_ha > 5
	some crop in input.oepul.crop_shares
	not crop.exempt_from_55_percent
	crop.area_ha / input.land.arable_area_ha > 0.55
}

violations contains "arable_biodiversity_under_7_percent" if {
	input.oepul.arable_biodiversity_credit_ha < required_arable_biodiversity
}

violations contains "grassland_biodiversity_under_7_percent" if {
	input.oepul.grassland_biodiversity_credit_ha < required_grassland_biodiversity
}

violations contains "arable_div_seed_mixture_invalid" if {
	some p in input.oepul.biodiversity_parcels
	p.kind == "arable_div"
	p.new_sowing
	p.insect_flowering_partners < 7
}

violations contains "arable_div_seed_families_invalid" if {
	some p in input.oepul.biodiversity_parcels
	p.kind == "arable_div"
	p.new_sowing
	p.plant_families < 3
}

violations contains "arable_div_non_insect_partners_over_10_percent" if {
	some p in input.oepul.biodiversity_parcels
	p.kind == "arable_div"
	p.new_sowing
	p.non_insect_percent > 10
}

violations contains "arable_divrs_seed_mixture_invalid" if {
	some p in input.oepul.biodiversity_parcels
	p.kind == "arable_divrs"
	p.species_count < 30
}

violations contains "regional_seed_family_count_invalid" if {
	some p in input.oepul.biodiversity_parcels
	p.kind in {"arable_divrs", "grassland_divrs"}
	p.plant_families < 7
}

violations contains "regional_seed_rate_invalid" if {
	some p in input.oepul.biodiversity_parcels
	p.kind in {"arable_divrs", "grassland_divrs"}
	p.seed_rate_kg_ha < 20
}

violations contains "regional_seed_single_species_over_5_percent" if {
	some p in input.oepul.biodiversity_parcels
	p.kind in {"arable_divrs", "grassland_divrs"}
	not p.uses_ecotype_seed
	p.max_species_weight_percent > 5
}

violations contains "grassland_divrs_site_invalid" if {
	some p in input.oepul.biodiversity_parcels
	p.kind == "grassland_divrs"
	p.grassland_number < 30
}

violations contains "grassland_divrs_slope_invalid" if {
	some p in input.oepul.biodiversity_parcels
	p.kind == "grassland_divrs"
	p.slope_percent >= 18
}

violations contains "wild_herb_breeding_area_invalid" if {
	some p in input.oepul.wild_herb_parcels
	p.row_spacing_cm < 20
}

violations contains "wild_herb_breeding_area_undersowing" if {
	some p in input.oepul.wild_herb_parcels
	p.has_undersowing
}

violations contains "pheromone_traps_under_15_per_ha" if {
	some p in input.oepul.pheromone_parcels
	p.traps_per_ha < 15
}

violations contains "pheromone_traps_under_5_weeks" if {
	some p in input.oepul.pheromone_parcels
	p.weeks_at_field < 5
}

violations contains "pheromone_traps_not_emptied_twice" if {
	some p in input.oepul.pheromone_parcels
	p.emptying_count < 2
}

violations contains "education_biodiversity_under_3_hours" if {
	input.oepul.education.biodiversity_hours < 3
}

violations contains "education_organic_under_5_hours" if {
	input.oepul.education.organic_hours < 5
}

decision := {"eligible": true, "violations": []} if {
	input.oepul
	count(violations) == 0
}

premium_rates_2026 := {
	"arable_base_eur_ha": 235,
	"grassland_non_livestock_eur_ha": 75.6,
	"grassland_livestock_under_1_4_eur_ha": 232.2,
	"grassland_livestock_1_4_or_more_eur_ha": 221.4,
	"arable_biodiversity_extra_eur_ha": 324,
	"arable_number_50_eur_ha": 140,
	"grassland_number_30_eur_ha": 100,
	"regional_arable_mown_eur_ha": 424,
	"regional_arable_mulched_eur_ha": 324,
	"regional_grassland_eur_ha": 424,
	"rare_variety_a_eur_ha": 129.6,
	"rare_variety_b_eur_ha": 270,
	"pheromone_traps_eur_ha": 150,
	"transaction_cost_eur_farm": 400,
	"circular_economy_eur_ha": 40,
}
