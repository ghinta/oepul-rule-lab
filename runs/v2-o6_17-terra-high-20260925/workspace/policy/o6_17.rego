package oepul.o6_17

import rego.v1

# Input is input.o6_17. Missing evidence is reported separately from a negative finding.

rgve_factor(animal_key) := factor if {
	row := data.rgve_factors[_]
	row.animal_key == animal_key
	factor := row.rgve
}

total_rgve := sum([(animal.count * rgve_factor(animal.animal_key)) | animal := input.o6_17.animals[_]])

is_tierhalter if {
	input.o6_17.fodder_area_ha > 0
	total_rgve / input.o6_17.fodder_area_ha >= 0.30
}

in_year(row, year) if {
	year >= row.from_year
	row.to_year == null
}

in_year(row, year) if {
	year >= row.from_year
	row.to_year != null
	year <= row.to_year
}

base_rate(grassland_number, year) := rate if {
	row := data.base_premiums_eur_per_ha[_]
	in_year(row, year)
	row.min_grassland_number == null
	grassland_number < row.max_exclusive
	rate := row.eur_per_ha
}

base_rate(grassland_number, year) := rate if {
	row := data.base_premiums_eur_per_ha[_]
	in_year(row, year)
	row.min_grassland_number != null
	grassland_number >= row.min_grassland_number
	row.max_exclusive != null
	grassland_number < row.max_exclusive
	rate := row.eur_per_ha
}

base_rate(grassland_number, year) := rate if {
	row := data.base_premiums_eur_per_ha[_]
	in_year(row, year)
	row.min_grassland_number != null
	grassland_number >= row.min_grassland_number
	row.max_exclusive == null
	rate := row.eur_per_ha
}

base_eligible(parcel) if {
	parcel.is_grassland
	parcel.slope_percent < 18
	not parcel.gloez_umbrechungsverbot
}

agl_species_count(parcel) := count({species | species = parcel.indicator_species[_]; data.indicator_species[_].name == species})

agl_qualified(parcel) if {
	parcel.agl_requested
	parcel.mowed
	not parcel.is_bergmaehder
	parcel.annual_cuts == 1
}

agl_qualified(parcel) if {
	parcel.agl_requested
	parcel.mowed
	not parcel.is_bergmaehder
	parcel.annual_cuts >= 2
	agl_species_count(parcel) >= 5
	parcel.first_use_type == "mowing"
	parcel.field_visit_documented
}

agl_rate(parcel, year) := rate if {
	row := data.agl_premiums_eur_per_ha[_]
	in_year(row, year)
	row.slope_band == "under_18"
	parcel.slope_percent < 18
	rate := row.eur_per_ha
}

agl_rate(parcel, year) := rate if {
	row := data.agl_premiums_eur_per_ha[_]
	in_year(row, year)
	row.slope_band == "at_least_18"
	parcel.slope_percent >= 18
	rate := row.eur_per_ha
}

agl_cap_ha := cap if {
	input.o6_17.application_year <= 2024
	cap := max([2.0, input.o6_17.mowed_grassland_ha * 0.15])
}

agl_cap_ha := cap if {
	input.o6_17.application_year >= 2025
	cap := max([2.0, input.o6_17.mowed_grassland_ha * 0.25])
}

base_payment_eur := sum([(parcel.area_ha * base_rate(parcel.grassland_number, input.o6_17.application_year)) | parcel := input.o6_17.parcels[_]; base_eligible(parcel)])

agl_requested_ha := sum([parcel.area_ha | parcel = input.o6_17.parcels[_]; agl_qualified(parcel); agl_rate(parcel, input.o6_17.application_year)])

# The claimant/AMA must determine allocation when qualified AGL area exceeds the cap;
# this total is the maximum payable amount assuming highest eligible per-ha rate first.
default agl_payment_ceiling_eur := null

agl_payment_ceiling_eur := sum(sort([(parcel.area_ha * agl_rate(parcel, input.o6_17.application_year)) | parcel := input.o6_17.parcels[_]; agl_qualified(parcel)])) if {
	agl_requested_ha <= agl_cap_ha
}

violations contains "missing_required_combination_ubb_or_bio" if {
	not input.o6_17.participates_ubb
	not input.o6_17.participates_bio
}

violations contains "first_year_grassland_below_2ha" if {
	input.o6_17.first_commitment_year
	input.o6_17.first_year_grassland_ha < 2
}

violations contains "first_year_grassland_share_below_40_percent" if {
	input.o6_17.first_commitment_year
	input.o6_17.first_year_agricultural_area_excl_alpine_ha > 0
	input.o6_17.first_year_grassland_ha / input.o6_17.first_year_agricultural_area_excl_alpine_ha < 0.40
}

violations contains "first_year_not_tierhaltend" if {
	input.o6_17.first_commitment_year
	not is_tierhalter
}

violations contains sprintf("greenland_ploughing_not_exception:%s", [parcel.parcel_id]) if {
	parcel := input.o6_17.parcels[_]
	operation := parcel.operations[_]
	operation.kind == "ploughing"
	not operation.pest_sanitation_documented
	not operation.regional_biodiversity_seed_mix
}

violations contains "training_not_completed_by_2025-12-31" if {
	input.o6_17.application_year >= 2025
	not input.o6_17.training.completed_by_2025_12_31
}

violations contains "training_less_than_5_hours" if {
	input.o6_17.training.completed_by_2025_12_31
	input.o6_17.training.hours < 5
}

violations contains "training_provider_not_recognized" if {
	input.o6_17.training.completed_by_2025_12_31
	not input.o6_17.training.provider_recognized
}

required_soil_samples := ceil(input.o6_17.eligible_grassland_under_18_ha_maa_2025 / 5)

violations contains "soil_samples_below_required_number" if {
	input.o6_17.application_year >= 2025
	input.o6_17.soil_samples.valid_count < required_soil_samples
}

violations contains "soil_samples_not_submitted_by_2025-12-31" if {
	input.o6_17.application_year >= 2025
	not input.o6_17.soil_samples.submitted_by_2025_12_31
}

violations contains "soil_results_not_recorded_in_ama_database" if {
	input.o6_17.application_year >= 2025
	not input.o6_17.soil_samples.results_recorded_in_ama_database
}

incomplete_evidence contains "agl_documentation_missing" if {
	parcel := input.o6_17.parcels[_]
	parcel.agl_requested
	parcel.annual_cuts >= 2
	not parcel.field_visit_documented
}

incomplete_evidence contains "soil_sample_parameters_or_accreditation_missing" if {
	input.o6_17.application_year >= 2025
	not input.o6_17.soil_samples.all_ph_p_k_humus
	not input.o6_17.soil_samples.accredited_laboratory
}

evaluation := {
	"measure": "o6_17",
	"tierhaltend": is_tierhalter,
	"rgve": total_rgve,
	"required_soil_samples": required_soil_samples,
	"base_payment_eur": base_payment_eur,
	"agl_requested_ha": agl_requested_ha,
	"agl_cap_ha": agl_cap_ha,
	"agl_payment_ceiling_eur": agl_payment_ceiling_eur,
	"violations": sort(violations),
	"incomplete_evidence": sort(incomplete_evidence),
}
