package oepul.o6_10_test

import data.oepul.o6_10
import rego.v1

base_input := {
	"farm": {"year": 2026},
	"o6_10": {"participates_in_insecticide_waiver_or_organic": false, "requests_organisms_or_pheromones_surcharge": false, "operation_programme_compensates_organisms_or_pheromones": false},
	"land": {"parcels": [{"parcel_id": "V1", "area_ha": 0.6, "slope_percent": 30, "crop": {"crop_category": "vineyard"}, "o6_10": {"is_terrace": false, "cover": {"is_year_round_and_full": true, "open_trunk_strip_cm": 70, "non_single_row_or_wide_system": false, "covered_percent": 100, "is_organic_mulch_or_self_greening": false, "cereal_maize_percent": 20, "oat_or_summer_barley_as_nurse_crop": false, "psm_on_cover_used": false}}}]},
}

test_vineyard_rate_2025 if {
	rate := o6_10.premium_rate(base_input.land.parcels[0]) with input as base_input
	rate == {"from_year": 2025, "to_year": null, "crop": "vineyard", "slope_min": 25, "slope_max_exclusive": 35, "fixed": 324}
}

test_small_area_is_violation if {
	some v in o6_10.violations with input as object.union(base_input, {"land": {"parcels": [object.union(base_input.land.parcels[0], {"area_ha": 0.49})]}})
	v.rule_id == "O610.002"
}

test_plant_protection_is_violation if {
	bad := object.union(base_input.land.parcels[0], {"o6_10": {"is_terrace": false, "cover": {"is_year_round_and_full": true, "open_trunk_strip_cm": 70, "non_single_row_or_wide_system": false, "covered_percent": 100, "is_organic_mulch_or_self_greening": false, "cereal_maize_percent": 20, "oat_or_summer_barley_as_nurse_crop": false, "psm_on_cover_used": true}}})
	some v in o6_10.violations with input as object.union(base_input, {"land": {"parcels": [bad]}})
	v.rule_id == "O610.019"
}

test_surcharge_discount if {
	amount := o6_10.discounted_surcharge_rate with input as object.union(base_input, {"o6_10": {"participates_in_insecticide_waiver_or_organic": true, "requests_organisms_or_pheromones_surcharge": true, "operation_programme_compensates_organisms_or_pheromones": false}})
	amount == 81
}

test_2026_drought_exception_suppresses_cover_violation if {
	drought_parcel := object.union(base_input.land.parcels[0], {"o6_10": {"is_terrace": false, "cover": {"is_year_round_and_full": false, "open_trunk_strip_cm": 70, "non_single_row_or_wide_system": false, "covered_percent": 40, "is_organic_mulch_or_self_greening": false, "cereal_maize_percent": 20, "oat_or_summer_barley_as_nurse_crop": false, "psm_on_cover_used": false, "ordinarily_established": true, "drought_prevents_full_cover": true, "drought_caused_volunteer_cereal_excess": false}}})
	vs := [v | v := o6_10.violations[_]; v.rule_id == "O610.007"] with input as object.union(base_input, {"land": {"parcels": [drought_parcel]}})
	count(vs) == 0
}
