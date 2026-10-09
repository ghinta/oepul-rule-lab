package oepul.o6_7_test

import data.oepul.o6_7
import rego.v1

base_input := {
	"farm": {"year": 2025, "region": {"federal_state": "Niederösterreich", "district": "Amstetten"}},
	"land": {"arable_area_ha": 10, "parcels": [{
		"parcel_id": "A1",
		"operations": {
			"cover_crop": {
				"is_used": true,
				"active_planting_day_of_year": 250,
				"duration_days": 60,
				"mixture_partners": [{"plant_family": "legume"}, {"plant_family": "brassica"}, {"plant_family": "grass"}],
				"winter_hardy_share_percent": 80,
				"turnover_day_of_year": 80,
				"gap_days": {"main_harvest_to_intercrop": 20, "intercrop_turnover_to_main_sowing": 20, "main_harvest_to_main_sowing": 40},
				"mechanical_removal": true,
				"tillage_kills_cover": false,
				"threshed": false,
			},
			"fertilizer": {"mineral_n_kg_per_ha": 0},
			"psm_used": false,
		},
	}]},
	"measure": {"o6_7": {"participating": true, "cover_share_percent": 100, "harvest_share_percent": 100, "field_records_complete": true, "measure_6_participating": false}},
}

low_area_input := object.union(base_input, {"land": object.union(base_input.land, {"arable_area_ha": 1.4})})
n_input := object.union(base_input, {"land": object.union(base_input.land, {"parcels": [object.union(base_input.land.parcels[0], {"operations": object.union(base_input.land.parcels[0].operations, {"fertilizer": {"mineral_n_kg_per_ha": 20}, "psm_used": true})})]})})
late_mixture_input := object.union(base_input, {"land": object.union(base_input.land, {"parcels": [object.union(base_input.land.parcels[0], {"operations": object.union(base_input.land.parcels[0].operations, {"cover_crop": object.union(base_input.land.parcels[0].operations.cover_crop, {"mixture_partners": [{"plant_family": "legume"}]})})})]})})
drought_cover_input := object.union(base_input, {"farm": object.union(base_input.farm, {"year": 2026}), "measure": {"o6_7": object.union(base_input.measure.o6_7, {"cover_share_percent": 60, "proper_establishment": true, "field_emergence_full_cover": false})}})
drought_harvest_input := object.union(base_input, {"farm": object.union(base_input.farm, {"year": 2026}), "measure": {"o6_7": object.union(base_input.measure.o6_7, {"harvest_share_percent": 50, "drought_no_harvestable_stand": true})}})
measure_six_input := object.union(base_input, {"measure": {"o6_7": object.union(base_input.measure.o6_7, {"measure_6_participating": true})}})
hardiness_input := object.union(base_input, {"land": object.union(base_input.land, {"parcels": [object.union(base_input.land.parcels[0], {"operations": object.union(base_input.land.parcels[0].operations, {"cover_crop": object.union(base_input.land.parcels[0].operations.cover_crop, {"active_planting_day_of_year": 270, "winter_hardy_share_percent": 40})})})]})})
gloez8_input := object.union(base_input, {"farm": object.union(base_input.farm, {"year": 2024}), "land": object.union(base_input.land, {"parcels": [object.union(base_input.land.parcels[0], {"gloez8_variant": "1_NPF"})]})})
drought_gap_input := object.union(base_input, {"farm": object.union(base_input.farm, {"year": 2026}), "measure": {"o6_7": object.union(base_input.measure.o6_7, {"credible_forward_management": true, "planting_conditions_unavailable": true})}, "land": object.union(base_input.land, {"parcels": [object.union(base_input.land.parcels[0], {"operations": object.union(base_input.land.parcels[0].operations, {"cover_crop": object.union(base_input.land.parcels[0].operations.cover_crop, {"gap_days": {"main_harvest_to_intercrop": 40, "intercrop_turnover_to_main_sowing": 40, "main_harvest_to_main_sowing": 60}})})})]})})
drought_late_planting_input := object.union(drought_gap_input, {"land": object.union(drought_gap_input.land, {"parcels": [object.union(drought_gap_input.land.parcels[0], {"operations": object.union(drought_gap_input.land.parcels[0].operations, {"cover_crop": object.union(drought_gap_input.land.parcels[0].operations.cover_crop, {"active_planting_day_of_year": 290})})})]})})

test_compliant_profile if {
	result := o6_7.compliance with input as base_input
	result.measure == "o6_7"
	result.eligible == true
	count(result.violations) == 0
	result.premium_band_eur_per_ha == {"minimum": 70, "maximum": 90}
}

test_minimum_area_violation if {
	result := o6_7.compliance with input as low_area_input
	result.eligible == false
	result.violations[_].rule_id == "O6_7_MIN_AREA"
}

test_nitrogen_and_psm_violation if {
	result := o6_7.compliance with input as n_input
	result.violations[_].rule_id == "O6_7_MINERAL_N"
	result.violations[_].rule_id == "O6_7_PSM"
}

test_late_mixture_violation if {
	result := o6_7.compliance with input as late_mixture_input
	result.violations[_].rule_id == "O6_7_MIXTURE"
}

test_drought_cover_exception if {
	result := o6_7.compliance with input as drought_cover_input
	result.eligible == true
	result.green_cover_exception_applies == true
}

test_drought_harvest_exception if {
	result := o6_7.compliance with input as drought_harvest_input
	result.harvest_exception_applies == true
	count(result.violations) == 0
}

test_measure_six_conflict if {
	result := o6_7.compliance with input as measure_six_input
	result.violations[_].rule_id == "O6_7_MEASURE_6_CONFLICT"
}

test_after_september_requires_hardiness if {
	result := o6_7.compliance with input as hardiness_input
	result.violations[_].rule_id == "O6_7_WINTER_HARDINESS"
}

test_gloez8_2024_exclusion if {
	result := o6_7.compliance with input as gloez8_input
	result.violations[_].rule_id == "O6_7_GLOEZ8_2024_EXCLUSION"
}

test_drought_gap_exception_does_not_waive_absolute_end_date if {
	result := o6_7.compliance with input as drought_gap_input
	result.late_planting_exception_applies == true
	count([v | v := result.violations[_]; v.rule_id == "O6_7_GAP_LIMIT"]) == 0
}

test_drought_late_planting_still_has_absolute_limit if {
	result := o6_7.compliance with input as drought_late_planting_input
	result.violations[_].rule_id == "O6_7_INTERCROP_LATEST_PLANTING"
}
