package oepul.o6_12_test

import data.oepul.o6_12
import rego.v1

base := {
	"farm": {
		"year": 2024,
		"region": {"federal_state": "Niederösterreich"},
		"measures": {
			"o6_12": {
				"participating": true,
				"first_participation_year": 2024,
				"contract_start_year": 2024,
				"premium_target_type": "vineyard",
				"quality_planting_material_ok": true,
				"sonstige_target_land_use": false,
				"biological_farming_participation": false,
				"area_wide_psm_application": false,
				"chemical_synthetic_insecticide_used": false,
			},
		},
	},
	"land": {
		"parcels": [
			{
				"parcel_id": "W1",
				"area_ha": 0.6,
				"land_use": "vineyard",
				"crop": {"crop_category": "vineyard", "crop_name": "Schnittweingarten"},
				"operations": {
					"insecticide_use": false,
					"insecticide_is_bio_permitted": false,
					"insecticide_authority_order": false,
					"insecticide_authority_documented": false,
					"insecticide_purchase_or_storage": false,
					"insecticide_in_other_culture": false,
					"insecticide_purchase_storage_plausible": true,
				},
			},
		],
	},
}

test_minimum_area_and_rate if {
	o6_12.minimum_participation_met with input as base
	o6_12.premium_rate_eur_per_ha == 270.0 with input as base
}

test_unauthorized_insecticide_is_violation if {
	bad_operations := object.union(base.land.parcels[0].operations, {"insecticide_use": true})
	bad_parcel := object.union(base.land.parcels[0], {"operations": bad_operations})
	bad_land := object.union(base.land, {"parcels": [bad_parcel]})
	bad := object.union(base, {"land": bad_land})
	"W1" in o6_12.insecticide_violation with input as bad
}

test_bio_permitted_insecticide_is_allowed if {
	allowed_operations := object.union(base.land.parcels[0].operations, {"insecticide_use": true, "insecticide_is_bio_permitted": true})
	allowed_parcel := object.union(base.land.parcels[0], {"operations": allowed_operations})
	allowed_land := object.union(base.land, {"parcels": [allowed_parcel]})
	allowed_bio := object.union(base, {"land": allowed_land})
	violations := o6_12.insecticide_violation with input as allowed_bio
	count(violations) == 0
}

test_early_exit_without_repayment if {
	measure_year := object.union(base.farm.measures.o6_12, {"early_exit_reason": "american_rebzikade_control", "early_exit_approved": true})
	measures_year := object.union(base.farm.measures, {"o6_12": measure_year})
	farm_year := object.union(base.farm, {"measures": measures_year})
	case_approved := object.union(base, {"farm": object.union(farm_year, {"year": 2026})})
	o6_12.early_exit_2026_without_repayment with input as case_approved
	o6_12.early_exit_premium_2026 == 0.0 with input as case_approved
}

test_psm_reporting_ends_in_2026 if {
	case_2026 := object.union(base, {"farm": object.union(base.farm, {"year": 2026})})
	not o6_12.reporting_code_required with input as case_2026
	o6_12.reporting_not_required with input as case_2026
}

test_bio_combination_allowed_only_for_part_farm_arable_grassland if {
	measure_bio := object.union(base.farm.measures.o6_12, {"biological_farming_participation": true})
	measures_bio := object.union(base.farm.measures, {"o6_12": measure_bio})
	farm_bio := object.union(base.farm, {"measures": measures_bio})
	case_bio := object.union(base, {"farm": farm_bio})
	not o6_12.combination_allowed with input as case_bio
	measure_bio_part := object.union(measure_bio, {"biological_farming_scope": "part_farm_arable_grassland"})
	measures_bio_part := object.union(base.farm.measures, {"o6_12": measure_bio_part})
	farm_bio_part := object.union(base.farm, {"measures": measures_bio_part})
	case_bio_part := object.union(base, {"farm": farm_bio_part})
	o6_12.combination_allowed with input as case_bio_part
}

test_obst_reference_table_controls_orchard_scope if {
	orchard := object.union(base.land.parcels[0], {
		"parcel_id": "O1",
		"land_use": "orchard",
		"crop": {"crop_category": "orchard", "crop_name": "Apfel"},
	})
	valid_land := object.union(base.land, {"parcels": [orchard]})
	valid := object.union(base, {"land": valid_land})
	valid_targets := o6_12.target_parcels with input as valid
	count(valid_targets) == 1

	unknown_orchard := object.union(orchard, {"crop": {"crop_category": "orchard", "crop_name": "Kakao"}})
	unknown_land := object.union(base.land, {"parcels": [unknown_orchard]})
	unknown := object.union(base, {"land": unknown_land})
	unknown_targets := o6_12.target_parcels with input as unknown
	count(unknown_targets) == 0
}
