package oepul.o6_9

import rego.v1

default result := {
	"eligible": false,
	"violations": [],
	"warnings": [],
	"premium": 0,
}

measure_active if {
	input.measure == "o6_9"
}

participating_category(category) if {
	input.participation.categories[_] == category
}

has_minimum_participation if {
	input.participation.application_m3 > 0
}

has_minimum_participation if {
	input.participation.separated_m3 > 0
}

has_minimum_participation if {
	participating_category("pig_feeding")
}

application_method_allowed if {
	input.application.method in {"trailing_hose", "trailing_shoe", "injection"}
}

application_land_allowed if {
	input.application.land_use in {"arable", "grassland"}
}

eligible_manure if {
	input.application.manure_type in {"slurry", "urine"}
	not input.application.injected_rainwater
	not input.application.is_water_mixed_solid_manure
}

eligible_manure if {
	input.application.manure_type == "biogas_slurry"
	not input.application.biogas_has_excluded_input
}

application_compliant if {
	application_method_allowed
	application_land_allowed
	eligible_manure
}

separation_compliant if {
	input.separation.origin == "own_cattle"
	input.separation.mechanical_phase_separation
	input.separation.separated_m3 > 0
}

pig_threshold_compliant if {
	input.pig_feeding.gve_pigs_annual_average / input.farm.arable_area_ha >= 1
}

pig_feed_compliant if {
	participating_category("pig_feeding")
	pig_threshold_compliant
	input.pig_feeding.all_pigs_compliant
	input.pig_feeding.proof_available
}

pig_feed_compliant if {
	not participating_category("pig_feeding")
}

application_records_compliant if {
	input.application.records_complete
	"amount_m3" in input.application.records_include
	"manure_type" in input.application.records_include
	"date" in input.application.records_include
	"method" in input.application.records_include
	"parcel" in input.application.records_include
}

separation_records_compliant if {
	input.separation.records_complete
	"date" in input.separation.records_include
	"separated_liquid_m3" in input.separation.records_include
}

application_deadline_compliant if {
	input.application.requested_by_december_31
}

pig_entry_allowed if {
	not participating_category("pig_feeding")
}

pig_entry_allowed if {
	participating_category("pig_feeding")
	input.farm.year >= 2025
	input.farm.year <= 2028
	input.participation.base_measure_valid
}

measure_entry_allowed if {
	input.farm.year >= 2023
	input.farm.year <= 2027
	input.participation.measure_requested_by_december_31
}

combination_allowed if {
	not participating_category("pig_feeding")
}

combination_allowed if {
	participating_category("pig_feeding")
	not input.participation.groundwater_protection_pig_bonus
}

default application_premium := 0

application_premium := amount * rate if {
	amount := min([input.application.requested_m3, 50 * input.calculation.eligible_fertilizable_area_ha])
	rate := max([r.rate_eur_per_m3 | r := data.premium_rates[_]; r.category == "application"; r.method == input.application.method; r.from_year <= input.farm.year])
}

default separation_premium := 0

separation_premium := amount * rate if {
	amount := min([input.separation.requested_m3, 20 * input.calculation.cattle_gve])
	rate := max([r.rate_eur_per_m3 | r := data.premium_rates[_]; r.category == "separation"; r.from_year <= input.farm.year])
}

default pig_premium := 0

pig_premium := 54 * input.calculation.arable_area_ha if {
	participating_category("pig_feeding")
	pig_feed_compliant
	input.farm.year >= 2025
}

violation contains "measure_not_active" if {
	not measure_active
}

violation contains "minimum_participation_missing" if {
	measure_active
	not has_minimum_participation
}

violation contains "application_requirements_not_met" if {
	input.participation.application_m3 > 0
	not application_compliant
}

violation contains "application_records_missing" if {
	input.participation.application_m3 > 0
	not application_records_compliant
}

violation contains "separation_requirements_not_met" if {
	input.participation.separated_m3 > 0
	not separation_compliant
}

violation contains "separation_records_missing" if {
	input.participation.separated_m3 > 0
	not separation_records_compliant
}

violation contains "pig_threshold_or_proof_not_met" if {
	participating_category("pig_feeding")
	not pig_feed_compliant
}

violation contains "application_deadline_not_met" if {
	input.participation.application_m3 > 0
	not application_deadline_compliant
}

violation contains "pig_entry_not_allowed" if {
	not pig_entry_allowed
}

violation contains "measure_entry_not_allowed" if {
	not measure_entry_allowed
}

violation contains "incompatible_pig_bonus" if {
	not combination_allowed
}

application_requirements_ok if {
	input.participation.application_m3 == 0
}

application_requirements_ok if {
	input.participation.application_m3 > 0
	application_compliant
}

separation_requirements_ok if {
	input.participation.separated_m3 == 0
}

separation_requirements_ok if {
	input.participation.separated_m3 > 0
	separation_compliant
}

default eligible := false

eligible if {
	measure_active
	has_minimum_participation
	application_requirements_ok
	separation_requirements_ok
	pig_feed_compliant
	pig_entry_allowed
	measure_entry_allowed
	combination_allowed
}

result := {
	"eligible": eligible,
	"violations": sort([v | violation[v]]),
	"warnings": [
		"The application premium is capped at 50 m3 per eligible fertilizable hectare.",
		"The separation premium is capped at 20 m3 per cattle GVE and year.",
	],
	"premium": (application_premium + separation_premium) + pig_premium,
}
