package oepul.o6_19

import rego.v1

default eligible := false

eligible if {
	input.measure.id == "o6_19"
	input.measure.requested == true
	input.measure.project_confirmation.present == true
	input.measure.project_confirmation.reference_area_present == true
	input.measure.contract_end_year == 2028
	input.measure.commitment_years == required_commitment_years
	input.measure.commitment_end_date == "2028-12-31"
	first_year_area_ok
	all_project_indicators_met
	input.measure.project_confirmation.indicator_observation_database_current == true
	input.measure.project_confirmation.regular_care_every_second_year == true
	training_ok
}

first_year_area_ok if {
	input.measure.first_commitment_year == false
}

first_year_area_ok if {
	input.measure.first_commitment_year == true
	input.measure.eligible_area_ha >= 1
}

all_project_indicators_met if {
	count(input.measure.project_confirmation.parcels) == 0
}

all_project_indicators_met if {
	count(input.measure.project_confirmation.parcels) > 0
	not some_project_indicator_failed
}

some_project_indicator_failed if {
	some parcel in input.measure.project_confirmation.parcels
	parcel.mandatory_indicators_met == false
}

training_ok if {
	input.measure.application_year > 2026
}

training_ok if {
	input.measure.application_year <= 2026
	input.measure.training.regional_network_meeting_by_2026_12_31 == true
	input.measure.training.participant_is_farm_person == true
	input.measure.training.not_double_counted == true
}

contract_years := {2023: 6, 2024: 5, 2025: 4}

required_commitment_years := contract_years[input.measure.start_year]

regional_plan_surcharge_eur := 250 if {
	input.measure.application_year == 2023
	input.measure.regional_nature_conservation_plan.requested == true
	input.measure.regional_nature_conservation_plan.annual_confirmation_present == true
}

regional_plan_surcharge_eur := 270 if {
	input.measure.application_year >= 2024
	input.measure.regional_nature_conservation_plan.requested == true
	input.measure.regional_nature_conservation_plan.annual_confirmation_present == true
}

regional_plan_surcharge_eur := 0 if {
	input.measure.regional_nature_conservation_plan.requested != true
}

regional_plan_surcharge_eur := 0 if {
	input.measure.regional_nature_conservation_plan.requested == true
	input.measure.regional_nature_conservation_plan.annual_confirmation_present != true
}

regional_plan_once_per_farm if {
	input.measure.regional_nature_conservation_plan.requested == true
	input.measure.regional_nature_conservation_plan.also_naturschutz == true
	input.measure.regional_nature_conservation_plan.awards_this_year == 1
}

fallow_area_max_ha := max([input.measure.arable_area_ha * 0.25, 2]) if {
	input.measure.arable_area_ha >= 0
}

premium_rate_eur_per_ha := data.premium_rates_eur_per_ha[input.measure.premium.land_use][input.measure.premium.habitat][input.measure.premium.conservation_status][input.measure.premium.difficulty_index] if {
	input.measure.premium.land_use == "wiesen"
	input.measure.premium.conservation_status in {"A", "B", "C"}
	input.measure.premium.difficulty_index in {0, 1, 2}
}

premium_rate_eur_per_ha := data.premium_rates_eur_per_ha[input.measure.premium.land_use][input.measure.premium.habitat][input.measure.premium.conservation_status] if {
	input.measure.premium.land_use == "weiden"
	input.measure.premium.conservation_status in {"A", "B", "C"}
}

premium_rate_eur_per_ha := data.premium_rates_eur_per_ha[input.measure.premium.land_use][input.measure.premium.habitat][input.measure.premium.conservation_status] if {
	input.measure.premium.land_use == "acker"
	input.measure.premium.conservation_status in {"A", "B", "C"}
}

ebba01_allowed if {
	input.measure.surcharges.ebba01.requested == true
	input.measure.surcharges.ebba01.reason_documented == true
	input.measure.surcharges.ebba01.reason_qualifies == true
	input.measure.surcharges.ebba01.awards_on_area == 0
}

ebba02_allowed if {
	input.measure.application_year >= 2025
	input.measure.surcharges.ebba02.requested == true
	input.measure.surcharges.ebba02.very_good_conservation_status == true
	input.measure.surcharges.ebba02.reason_documented == true
}

ebhg_allowed if {
	input.measure.surcharges.ebhg.requested == true
	input.measure.surcharges.ebhg.protection_layer_share >= 0.5
}

field_combination_allowed if {
	input.measure.other_measure in {"natura_2000", "ubb_landscape_element", "bio_landscape_element"}
}

field_combination_allowed if {
	input.measure.other_measure == "none"
}

field_combination_allowed if {
	input.measure.other_measure == "naturschutz"
	input.measure.combination_scope == "farm"
}

accession_premium_share := 1 if {
	input.measure.application_year in {2024, 2025}
}

accession_premium_share := 0.5 if {
	input.measure.application_year > 2025
}

accession_premium_allowed_area_ha := max([input.measure.area_2025_ha * accession_premium_share, 5]) if {
	input.measure.application_year > 2025
}

accession_premium_allowed_area_ha := input.measure.accession_area_ha if {
	input.measure.application_year in {2024, 2025}
}

modulation_factor := 1 if {
	input.measure.total_farm_area_ha <= 200
}

modulation_factor := (200 + (0.9 * (input.measure.total_farm_area_ha - 200))) / input.measure.total_farm_area_ha if {
	input.measure.total_farm_area_ha > 200
	input.measure.total_farm_area_ha <= 300
}

modulation_factor := ((200 + 90) + (0.85 * (input.measure.total_farm_area_ha - 300))) / input.measure.total_farm_area_ha if {
	input.measure.total_farm_area_ha > 300
	input.measure.total_farm_area_ha <= 1000
}

modulation_factor := (((200 + 90) + 595) + (0.75 * (input.measure.total_farm_area_ha - 1000))) / input.measure.total_farm_area_ha if {
	input.measure.total_farm_area_ha > 1000
}

drought_2026_project_confirmation_overrides if {
	input.measure.application_year == 2026
	input.measure.drought_2026.affected_biodiversity_area_in_ebw == true
}

drought_2026_project_confirmation_overrides := false if {
	input.measure.application_year != 2026
}

drought_2026_ebw_use_allowed if {
	input.measure.application_year == 2026
	input.measure.drought_2026.affected_biodiversity_area_in_ebw == true
	input.measure.drought_2026.proposed_use_follows_project_confirmation == true
}

violation[msg] if {
	input.measure.project_confirmation.present != true
	msg := "missing_project_confirmation"
}

violation[msg] if {
	input.measure.first_commitment_year == true
	input.measure.eligible_area_ha < 1
	msg := "first_year_area_below_1_ha"
}

violation[msg] if {
	input.measure.project_confirmation.indicator_observation_database_current != true
	msg := "indicator_observation_database_missing_or_stale"
}

violation[msg] if {
	input.measure.project_confirmation.regular_care_every_second_year != true
	msg := "regular_care_every_second_year_not_demonstrated"
}
