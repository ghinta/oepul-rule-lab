package oepul.o6_16

import data as reference
import rego.v1

default eligible := false

premium_value(component) := value if {
	some row in reference.premium_eur_per_ha_from_2024
	row.component == component
	value := row.value
}

area_catalog_contains_kg(kg_number) if {
	some entry in reference.area_catalog.entries
	entry.kg_number == kg_number
}

high_reduction_zone if input.farm.region.federal_state == "Wien"
high_reduction_zone if input.farm.region.federal_state == "Burgenland"
high_reduction_zone if input.farm.region.is_eastern_lower_austria_or_tullnerfeld

reduction_factor := 0.8 if high_reduction_zone
reduction_factor := 0.6 if not high_reduction_zone

nitrogen_threshold := 20 if input.farm.year >= 2025
nitrogen_threshold := 10 if input.farm.year < 2025

nitrogen_transfer(surplus) := transfer if {
	surplus > nitrogen_threshold
	uncapped := surplus * reduction_factor
	input.farm.year >= 2025
	transfer := min([uncapped, 100 * reduction_factor])
}

nitrogen_transfer(surplus) := transfer if {
	surplus > nitrogen_threshold
	input.farm.year < 2025
	transfer := surplus * reduction_factor
}

nitrogen_transfer(surplus) := 0 if surplus <= nitrogen_threshold

required_soil_samples := ceil(input.land.groundwater_arable_area_ha / 5)

parcel_requires_field_record(parcel) if {
	parcel.in_groundwater_area
	parcel.crop_area_ha > 0.30
}

forbidden_psm(parcel) if {
	parcel.in_groundwater_area
	parcel.crop_category in {"sorghum", "sudangrass", "maize", "oilseed", "root"}
	some active in parcel.psm_active_ingredients
	some forbidden in reference.forbidden_active_ingredients
	forbidden != "Bentazon (bei Wiederzulassung)"
	active == forbidden
}

forbidden_psm(parcel) if {
	parcel.in_groundwater_area
	parcel.crop_category in {"sorghum", "sudangrass", "maize", "oilseed", "root"}
	input.farm.year >= 2025
	input.farm.bentazon_reauthorized
	some active in parcel.psm_active_ingredients
	some forbidden in reference.forbidden_active_ingredients
	forbidden == "Bentazon (bei Wiederzulassung)"
	active == "Bentazon"
}

violation[msg] if {
	input.measure.requested
	input.measure.first_participation_year == input.farm.year
	input.land.groundwater_arable_area_ha < 2
	msg := "first_participation_requires_2_ha_in_annex_g"
}

violation[msg] if {
	input.measure.requested
	not input.measure.participates_cover_intercrop
	not input.measure.participates_cover_evergreen
	msg := "combination_with_cover_measure_required"
}

violation[msg] if {
	input.measure.requested
	some parcel in input.land.parcels
	parcel.in_groundwater_area
	not area_catalog_contains_kg(parcel.kg_number)
	msg := "parcel_not_in_annex_g_catalog"
}

violation[msg] if {
	input.measure.requested
	not input.records.farm_planning_completed_by_02_28
	msg := "farm_nutrient_plan_missing_or_late"
}

violation[msg] if {
	input.measure.requested
	not input.records.farm_balance_completed_by_next_01_31
	msg := "farm_nutrient_balance_missing_or_late"
}

violation[msg] if {
	input.measure.requested
	some parcel in input.land.parcels
	parcel_requires_field_record(parcel)
	not parcel.field_record_complete
	msg := "field_nutrient_record_missing"
}

violation[msg] if {
	input.measure.requested
	input.records.education_hours < 10
	msg := "ten_hours_training_required"
}

violation[msg] if {
	input.measure.requested
	not input.records.education_provider_recognized
	msg := "training_provider_not_recognized"
}

violation[msg] if {
	input.measure.requested
	input.records.education_completed_date > "2026-12-31"
	msg := "training_deadline_2026_12_31_missed"
}

violation[msg] if {
	input.measure.requested
	not input.records.water_protection_concept_complete
	msg := "water_protection_concept_missing"
}

violation[msg] if {
	input.measure.requested
	count(input.records.soil_samples) < required_soil_samples
	msg := "insufficient_soil_samples"
}

violation[msg] if {
	input.measure.requested
	some sample in input.records.soil_samples
	sample.lab_accredited == false
	msg := "soil_sample_lab_not_accredited"
}

violation[msg] if {
	input.measure.requested
	some sample in input.records.soil_samples
	sample.draw_date < "2022-01-01"
	msg := "soil_sample_too_old"
}

violation[msg] if {
	input.measure.requested
	some parcel in input.land.parcels
	forbidden_psm(parcel)
	msg := "forbidden_plant_protection_active_ingredient"
}

violation[msg] if {
	input.measure.requested
	input.farm.region.federal_state == "Oberösterreich"
	input.measure.oo_variant_3_cover
	msg := "upper_austria_variant_3_not_allowed"
}

violation[msg] if {
	input.measure.requested
	input.farm.region.federal_state == "Oberösterreich"
	input.measure.oo_chemical_psm_application
	not input.records.oo_ipm_inspection_or_warning_documented
	msg := "upper_austria_ipm_precheck_missing"
}

violation[msg] if {
	input.measure.requested
	some parcel in input.land.parcels
	parcel.in_groundwater_area
	parcel.nitrogen_surplus_kg_per_ha > 30
	not parcel.following_crop_planted_by_11_15
	not parcel.cover_crop_planted_by_11_15
	msg := "following_crop_or_cover_due_by_11_15"
}

violation[msg] if {
	input.measure.requested
	some parcel in input.land.parcels
	parcel.in_groundwater_area
	nitrogen_transfer(parcel.nitrogen_surplus_kg_per_ha) > 0
	parcel.following_crop_reduction_kg_per_ha < nitrogen_transfer(parcel.nitrogen_surplus_kg_per_ha)
	msg := "following_crop_nitrogen_reduction_insufficient"
}

violation[msg] if {
	input.options.washout_risk.requested
	count(input.options.washout_risk.parcel_ids) == 0
	msg := "washout_option_requires_at_least_one_parcel"
}

violation[msg] if {
	input.options.washout_risk.requested
	some parcel in input.land.parcels
	parcel.id in input.options.washout_risk.parcel_ids
	parcel.average_ackerzahl > 40
	msg := "washout_option_average_ackerzahl_over_40"
}

violation[msg] if {
	input.options.washout_risk.requested
	some parcel in input.land.parcels
	parcel.id in input.options.washout_risk.parcel_ids
	parcel.washout_cover_new_sown
	parcel.washout_cover_contains_legumes
	msg := "washout_new_cover_must_be_without_legumes"
}

violation[msg] if {
	input.options.washout_risk.requested
	some parcel in input.land.parcels
	parcel.id in input.options.washout_risk.parcel_ids
	parcel.washout_psm_or_fertilizer_used
	msg := "washout_option_psm_and_fertilizer_prohibited"
}

violation[msg] if {
	input.options.washout_risk.requested
	some parcel in input.land.parcels
	parcel.id in input.options.washout_risk.parcel_ids
	not parcel.washout_mown_or_chopped_every_two_years
	msg := "washout_option_maintenance_missing"
}

violation[msg] if {
	input.options.washout_risk.requested
	some parcel in input.land.parcels
	parcel.id in input.options.washout_risk.parcel_ids
	parcel.washout_grazed_or_threshed
	msg := "washout_option_grazing_and_threshing_prohibited"
}

violation[msg] if {
	input.options.washout_risk.requested
	some parcel in input.land.parcels
	parcel.id in input.options.washout_risk.parcel_ids
	parcel.washout_years_since_start < 2
	parcel.washout_broken_up
	msg := "washout_option_breakup_too_early"
}

violation[msg] if {
	input.options.vienna_humus.requested
	input.farm.region.federal_state != "Wien"
	msg := "vienna_humus_option_requires_vienna_area"
}

violation[msg] if {
	input.options.vienna_humus.requested
	input.options.vienna_humus.turning_tillage_other_than_after_maize
	msg := "vienna_humus_option_turning_tillage_prohibited"
}

violation[msg] if {
	input.options.vienna_humus.requested
	not input.options.vienna_humus.recognized_carbon_project_confirmation
	msg := "vienna_humus_project_confirmation_missing"
}

violation[msg] if {
	input.options.vienna_humus.requested
	input.records.vienna_extra_education_hours < 3
	msg := "vienna_humus_extra_three_hours_missing"
}

violation[msg] if {
	input.options.vienna_humus.requested
	count(input.records.soil_samples) < 2 * required_soil_samples
	msg := "vienna_humus_requires_double_soil_samples"
}

pig_feed_limit(category) := row if {
	some row in reference.pig_feed_limits_g_per_kg_dm_88_percent
	row.category == category
}

pig_feed_compliant(feed) if {
	limit := pig_feed_limit(feed.category)
	feed.average_g_per_kg <= limit.average_max
}

pig_feed_compliant(feed) if {
	feed.category == "young_fattening_pigs_and_unmated_gilts_32_to_60_kg"
	limit := pig_feed_limit(feed.category)
	feed.phase_g_per_kg <= limit.phase_max
}

violation[msg] if {
	input.options.strong_n_reduced_pig_feeding.requested
	input.livestock.pig_gve_average / input.land.total_arable_area_ha < 1
	msg := "pig_option_requires_one_gve_per_ha_arable_land"
}

violation[msg] if {
	input.options.strong_n_reduced_pig_feeding.requested
	some feed in input.options.strong_n_reduced_pig_feeding.feed_categories
	not pig_feed_compliant(feed)
	msg := "pig_feed_raw_protein_limit_exceeded"
}

violation[msg] if {
	input.options.strong_n_reduced_pig_feeding.requested
	not input.records.pig_feed_recipe_evidence
	msg := "pig_feed_recipe_evidence_missing"
}

violation[msg] if {
	input.options.cultan.requested
	input.farm.year < 2025
	msg := "cultan_option_only_from_2025"
}

violation[msg] if {
	input.options.cultan.requested
	not input.options.cultan.has_ammonium_depot_injection
	msg := "cultan_ammonium_depot_injection_required"
}

violation[msg] if {
	input.options.cultan.requested
	not input.records.cultan_field_records_complete
	msg := "cultan_field_records_missing"
}

violation[msg] if {
	input.options.cultan.requested
	input.options.cultan.external_equipment
	not input.records.cultan_external_service_evidence
	msg := "cultan_external_equipment_evidence_missing"
}

violation[msg] if {
	input.options.psm_avoidance_surcharge.requested
	input.measure.participates_organic
	msg := "psm_avoidance_surcharge_not_combinable_with_organic"
}

violation[msg] if {
	input.options.washout_risk.requested
	some parcel in input.land.parcels
	parcel.id in input.options.washout_risk.parcel_ids
	parcel.has_base_premium
	msg := "washout_option_area_receives_no_base_premium"
}

violation[msg] if {
	input.options.strong_n_reduced_pig_feeding.requested
	input.options.strong_n_reduced_pig_feeding.also_claimed_in_liquid_manure_measure
	msg := "pig_option_double_claim_not_allowed"
}

base_premium_rate := premium_value("base_with_organic_or_input_restriction") if input.measure.participates_organic
base_premium_rate := premium_value("base_without_organic_or_input_restriction") if not input.measure.participates_organic

premium_components := components if {
	components := array.concat([{"component": "base", "eur_per_ha": base_premium_rate}], [
		{"component": "education_first_10_ha", "eur_per_ha": premium_value("education_first_10_ha")},
	])
}

eligible if {
	input.measure.requested
	count(violation) == 0
}

decision := {
	"eligible": eligible,
	"violations": sort([message | violation[message]]),
	"required_soil_samples": required_soil_samples,
	"nitrogen_reduction_factor": reduction_factor,
	"premium_components_from_2024": premium_components,
	"annex_g_catalog_matches": count([entry | some entry in reference.area_catalog.entries; some parcel in input.land.parcels; entry.kg_number == parcel.kg_number]),
}
