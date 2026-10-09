package oepul.o6_10

import rego.v1

default eligible := false

default all_requirements_met := false

default premium_eur_per_ha := 0

default surcharge_eur_per_ha := 0

default total_premium_eur := 0

participation := object.get(input, "o6_10", {})
farm := object.get(input, "farm", {})
land := object.get(input, "land", {})
parcels := object.get(land, "parcels", [])
year := object.get(farm, "year", 0)

requested if object.get(participation, "requested", false)

eligible_parcel(p) if {
	category := object.get(object.get(p, "crop", {}), "crop_category", "")
	category in data.eligible_crop_categories
}

measure_data(p) := object.get(p, "o6_10", {})

terrace(p) if object.get(measure_data(p), "is_terrace", false)

area_ha(p) := object.get(p, "area_ha", 0)

eligible_area_ha := sum([area_ha(p) | some p in parcels])

violations contains "minimum_participation_area" if {
	requested
	eligible_area_ha < data.annual_rules.minimum_area_ha
}

violations contains "ineligible_crop_or_land_use" if {
	requested
	some p in parcels
	category := object.get(object.get(p, "crop", {}), "crop_category", "")
	category != ""
	not category in data.eligible_crop_categories
}

violations contains "terrace_slope" if {
	requested
	some p in parcels
	terrace(p)
	slope := object.get(p, "slope_percent", null)
	slope == null
}

violations contains "terrace_slope" if {
	requested
	some p in parcels
	terrace(p)
	slope := object.get(p, "slope_percent", 0)
	slope < 25
}

drought_2026_exception if {
	year == 2026
	object.get(participation, "drought_2026", false)
	object.get(participation, "proper_cover_establishment", false)
}

violations contains "full_year_and_all_alleys_cover" if {
	requested
	some p in parcels
	not terrace(p)
	not object.get(measure_data(p), "full_year_and_all_alleys_cover", false)
	not drought_2026_exception
}

violations contains "minimum_hardy_mixture_partners" if {
	requested
	p := parcels[_]
	not terrace(p)
	object.get(measure_data(p), "preexisting_cover", false) == false
	partners := object.get(measure_data(p), "hardy_mixture_partners", 0)
	partners < data.annual_rules.minimum_hardy_mixture_partners
}

violations contains "insufficient_alternative_planting_cover" if {
	requested
	p := parcels[_]
	not terrace(p)
	object.get(measure_data(p), "alternative_planting_system", false)
	cover := object.get(measure_data(p), "covered_area_percent", 0)
	cover < data.annual_rules.alternative_planting_minimum_cover_percent
}

violations contains "open_stem_area_exceeded" if {
	requested
	p := parcels[_]
	not terrace(p)
	width := object.get(measure_data(p), "open_stem_width_cm", 0)
	category := object.get(object.get(p, "crop", {}), "crop_category", "")
	category == "vineyard"
	width > data.annual_rules.wine_open_stem_area_cm
}

violations contains "open_stem_area_exceeded" if {
	requested
	p := parcels[_]
	not terrace(p)
	width := object.get(measure_data(p), "open_stem_width_cm", 0)
	category := object.get(object.get(p, "crop", {}), "crop_category", "")
	category in ["orchard", "hop"]
	width > data.annual_rules.orchard_hop_open_stem_area_cm
}

violations contains "invalid_cover_culture" if {
	requested
	p := parcels[_]
	cover_type := object.get(measure_data(p), "cover_type", "")
	cover_type in data.invalid_cover_types
}

violations contains "prohibited_grain_or_maize" if {
	requested
	p := parcels[_]
	cover := measure_data(p)
	share := object.get(cover, "grain_or_maize_share_percent", 0)
	share > data.annual_rules.maximum_grain_or_maize_share_percent
	object.get(cover, "oats_or_spring_barley_cover_crop", false) == false
}

violations contains "prohibited_grain_or_maize" if {
	requested
	p := parcels[_]
	cover := measure_data(p)
	object.get(cover, "pure_grain_or_maize", false)
	object.get(cover, "green_cut_rye_under_seed_law", false) == false
	object.get(cover, "oats_or_spring_barley_cover_crop", false) == false
}

violations contains "tillage_destroys_cover" if {
	requested
	p := parcels[_]
	event := object.get(measure_data(p), "tillage", {})
	object.get(event, "destroys_cover", false)
	object.get(event, "followed_by_reseeding", false) == false
}

violations contains "reseeding_deadline" if {
	requested
	p := parcels[_]
	event := object.get(measure_data(p), "reseeding", {})
	object.get(event, "required", false)
	object.get(event, "within_8_weeks", false) == false
}

violations contains "reseeding_deadline" if {
	requested
	p := parcels[_]
	event := object.get(measure_data(p), "reseeding", {})
	object.get(event, "required", false)
	object.get(event, "after_october_1", false)
}

violations contains "late_renewal_until_may_15" if {
	requested
	p := parcels[_]
	event := object.get(measure_data(p), "reseeding", {})
	object.get(event, "cleared_after_september_15", false)
	object.get(event, "uncovered_until_may_15", false) == false
}

violations contains "pesticide_on_aisle_cover" if {
	requested
	p := parcels[_]
	object.get(measure_data(p), "pesticide_on_aisle_cover", false)
}

violations contains "non_mechanical_cover_removal" if {
	requested
	p := parcels[_]
	object.get(measure_data(p), "cover_removal_method", "") != ""
	object.get(measure_data(p), "cover_removal_method", "") != "mechanical"
}

violations contains "cover_used_or_removed" if {
	requested
	p := parcels[_]
	md := measure_data(p)
	object.get(md, "cover_used_for_production", false)
	object.get(md, "extensive_sheep_grazing", false) == false
	object.get(md, "temporary_poultry_grazing", false) == false
}

violations contains "operation_program_double_funding" if {
	requested
	object.get(participation, "operation_program_organisms_or_pheromones", false)
	object.get(participation, "organism_or_pheromone_surcharge_requested", false)
}

violations contains "organism_or_pheromone_application" if {
	requested
	object.get(participation, "organism_or_pheromone_surcharge_requested", false)
	object.get(participation, "surcharge_applied_on_at_least_one_plot", false) == false
}

violations contains "organism_or_pheromone_application" if {
	requested
	object.get(participation, "organism_or_pheromone_surcharge_requested", false)
	object.get(participation, "application_replaces_pesticide", false) == false
}

violations contains "records_incomplete" if {
	requested
	object.get(participation, "records", {}) != {}
	records := object.get(participation, "records", {})
	not object.get(records, "farm", false)
}

all_requirements_met if {
	requested
	count(violations) == 0
}

eligible if all_requirements_met

wine_rate(p) := rate if {
	slope := object.get(p, "slope_percent", 0)
	row := data.premium_eur_per_ha_from_2025.wine[_]
	slope >= row.min_slope_inclusive
	row.max_slope_exclusive == null
	rate := row.rate
}

wine_rate(p) := rate if {
	slope := object.get(p, "slope_percent", 0)
	row := data.premium_eur_per_ha_from_2025.wine[_]
	slope >= row.min_slope_inclusive
	row.max_slope_exclusive != null
	slope < row.max_slope_exclusive
	rate := row.rate
}

orchard_rate(p) := rate if {
	slope := object.get(p, "slope_percent", 0)
	row := data.premium_eur_per_ha_from_2025.orchard[_]
	slope >= row.min_slope_inclusive
	row.max_slope_exclusive == null
	rate := row.rate
}

orchard_rate(p) := rate if {
	slope := object.get(p, "slope_percent", 0)
	row := data.premium_eur_per_ha_from_2025.orchard[_]
	slope >= row.min_slope_inclusive
	row.max_slope_exclusive != null
	slope < row.max_slope_exclusive
	rate := row.rate
}

parcel_base_rate(p) := rate if {
	category := object.get(object.get(p, "crop", {}), "crop_category", "")
	category == "vineyard"
	rate := wine_rate(p)
}

parcel_base_rate(p) := rate if {
	category := object.get(object.get(p, "crop", {}), "crop_category", "")
	category == "orchard"
	rate := orchard_rate(p)
}

parcel_base_rate(p) := data.premium_eur_per_ha_from_2025.hop if {
	category := object.get(object.get(p, "crop", {}), "crop_category", "")
	category == "hop"
}

base_total_eur := sum([(area_ha(p) * parcel_base_rate(p)) | some p in parcels])

surcharge_eur_per_ha := data.premium_eur_per_ha_from_2025.organism_or_pheromone_surcharge if {
	object.get(participation, "organism_or_pheromone_surcharge_requested", false)
	object.get(participation, "insecticide_avoidance", false) == false
	object.get(participation, "organic_farming", false) == false
}

reduced_surcharge_applies if object.get(participation, "insecticide_avoidance", false)

reduced_surcharge_applies if object.get(participation, "organic_farming", false)

surcharge_eur_per_ha := data.premium_eur_per_ha_from_2025.organism_or_pheromone_surcharge_reduced if {
	object.get(participation, "organism_or_pheromone_surcharge_requested", false)
	reduced_surcharge_applies
}

premium_eur_per_ha := base_total_eur / eligible_area_ha if {
	eligible
	eligible_area_ha > 0
}

total_premium_eur := base_total_eur + surcharge_total_eur if eligible

surcharge_total_eur := sum([(area_ha(p) * surcharge_eur_per_ha) | some p in parcels])
