package oepul.o6_19_test

import data.oepul.o6_19
import rego.v1

base_measure := {
	"id": "o6_19",
	"requested": true,
	"application_year": 2025,
	"start_year": 2025,
	"commitment_years": 4,
	"commitment_end_date": "2028-12-31",
	"contract_end_year": 2028,
	"first_commitment_year": true,
	"eligible_area_ha": 1.2,
	"arable_area_ha": 10,
	"area_2025_ha": 10,
	"accession_area_ha": 3,
	"total_farm_area_ha": 220,
	"project_confirmation": {
		"present": true,
		"reference_area_present": true,
		"regular_care_every_second_year": true,
		"indicator_observation_database_current": true,
		"parcels": [{"mandatory_indicators_met": true}],
	},
	"training": {
		"regional_network_meeting_by_2026_12_31": true,
		"participant_is_farm_person": true,
		"not_double_counted": true,
	},
	"regional_nature_conservation_plan": {
		"requested": true,
		"annual_confirmation_present": true,
		"also_naturschutz": true,
		"awards_this_year": 1,
	},
	"premium": {
		"land_use": "wiesen",
		"habitat": "Feuchte bis nasse Fettwiese",
		"conservation_status": "A",
		"difficulty_index": 1,
	},
	"surcharges": {
		"ebba01": {"requested": true, "reason_documented": true, "reason_qualifies": true, "awards_on_area": 0},
		"ebba02": {"requested": true, "very_good_conservation_status": true, "reason_documented": true},
		"ebhg": {"requested": true, "protection_layer_share": 0.5},
	},
	"other_measure": "none",
	"combination_scope": "field",
}

test_eligibility_and_contract if {
	o6_19.eligible with input as {"measure": base_measure}
}

test_first_year_minimum_fails if {
	not o6_19.eligible with input as {"measure": object.union(base_measure, {"eligible_area_ha": 0.99})}
	o6_19.violation.first_year_area_below_1_ha with input as {"measure": object.union(base_measure, {"eligible_area_ha": 0.99})}
}

test_indicator_catalog_and_premium_table_are_data_backed if {
	count(data.indicator_catalog) >= 80
	data.indicator_catalog[_].code == "EBGT18"
	o6_19.premium_rate_eur_per_ha == 896.4 with input as {"measure": base_measure}
}

test_regional_plan_once_and_rate if {
	o6_19.regional_plan_surcharge_eur == 270 with input as {"measure": base_measure}
	o6_19.regional_plan_once_per_farm with input as {"measure": base_measure}
}

test_fallow_cap_is_at_least_two_hectares if {
	o6_19.fallow_area_max_ha == 2.5 with input as {"measure": base_measure}
}

test_accession_and_modulation if {
	o6_19.accession_premium_allowed_area_ha == 3 with input as {"measure": base_measure}
	o6_19.modulation_factor with input as {"measure": base_measure}
}

test_allowed_combinations if {
	o6_19.field_combination_allowed with input as {"measure": object.union(base_measure, {"other_measure": "natura_2000"})}
	not o6_19.field_combination_allowed with input as {"measure": object.union(base_measure, {"other_measure": "ubb"})}
}

test_drought_does_not_override_project_confirmation if {
	o6_19.drought_2026_project_confirmation_overrides with input as {"measure": object.union(base_measure, {"application_year": 2026, "drought_2026": {"affected_biodiversity_area_in_ebw": true}})}
	o6_19.drought_2026_ebw_use_allowed with input as {"measure": object.union(base_measure, {"application_year": 2026, "drought_2026": {"affected_biodiversity_area_in_ebw": true, "proposed_use_follows_project_confirmation": true}})}
}

test_ebba_and_ebhg_constraints if {
	o6_19.ebba01_allowed with input as {"measure": base_measure}
	o6_19.ebba02_allowed with input as {"measure": base_measure}
	o6_19.ebhg_allowed with input as {"measure": base_measure}
}
