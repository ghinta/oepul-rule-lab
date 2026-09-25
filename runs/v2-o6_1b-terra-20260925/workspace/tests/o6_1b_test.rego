package oepul.o6_1b_test

import rego.v1

test_compliant_organic_farm if {
	decision := data.oepul.o6_1b.decision with input as {
		"farm": {"certifications": {"organic": {"is_certified": true}}},
		"land": {"arable_area_ha": 10},
		"oepul": {"mown_grassland_ha": 0, "fodder_area_ha": 10, "rgve_total": 0, "cereal_maize_ha": 7, "crop_shares": [{"area_ha": 5, "exempt_from_55_percent": false}], "arable_biodiversity_credit_ha": 0.7, "grassland_biodiversity_credit_ha": 0, "biodiversity_parcels": [{"kind": "arable_div", "new_sowing": true, "insect_flowering_partners": 7, "plant_families": 3, "non_insect_percent": 10}], "wild_herb_parcels": [], "pheromone_parcels": [], "education": {"biodiversity_hours": 3, "organic_hours": 5}},
	}
	decision.eligible
}

test_detects_diversification_and_biodiversity_failure if {
	violations := data.oepul.o6_1b.violations with input as {"farm": {"certifications": {"organic": {"is_certified": false}}}, "land": {"arable_area_ha": 10}, "oepul": {"mown_grassland_ha": 0, "cereal_maize_ha": 8, "crop_shares": [{"area_ha": 6, "exempt_from_55_percent": false}], "arable_biodiversity_credit_ha": 0, "grassland_biodiversity_credit_ha": 0, "biodiversity_parcels": [], "wild_herb_parcels": [], "pheromone_parcels": [], "education": {"biodiversity_hours": 0, "organic_hours": 0}}}
	"arable_cereal_maize_share_over_75_percent" in violations
	"arable_biodiversity_under_7_percent" in violations
	"organic_registration_or_control_contract_missing" in violations
}

test_regional_seed_and_trap_checks if {
	violations := data.oepul.o6_1b.violations with input as {"farm": {"certifications": {"organic": {"is_certified": true}}}, "land": {"arable_area_ha": 0}, "oepul": {"mown_grassland_ha": 0, "cereal_maize_ha": 0, "crop_shares": [], "arable_biodiversity_credit_ha": 0, "grassland_biodiversity_credit_ha": 0, "biodiversity_parcels": [{"kind": "grassland_divrs", "species_count": 29, "plant_families": 6, "seed_rate_kg_ha": 19, "max_species_weight_percent": 6, "uses_ecotype_seed": false, "grassland_number": 29, "slope_percent": 18}], "wild_herb_parcels": [{"row_spacing_cm": 19, "has_undersowing": true}], "pheromone_parcels": [{"traps_per_ha": 14, "weeks_at_field": 4, "emptying_count": 1}], "education": {"biodiversity_hours": 3, "organic_hours": 5}}}
	"grassland_divrs_site_invalid" in violations
	"pheromone_traps_under_15_per_ha" in violations
}

test_closed_reference_tables_are_queryable if {
	data.oepul.o6_1b.rgve_per_head("cattle_2_plus") == 1
	data.oepul.o6_1b.rare_variety_tier("Soblus") == "A"
	"Valeriana officinalis subsp. officinalis" in data.oepul.o6_1b.regional_seed_species("arable")
}
