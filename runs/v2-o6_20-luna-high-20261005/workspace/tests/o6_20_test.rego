package oepul.o6_20_test

import data.oepul.o6_20
import rego.v1

valid_input := {
	"farm": {
		"year": 2026,
		"livestock": {
			"o6_20": [
				{
					"category": "female_cattle_2_plus",
					"participating": true,
					"animal_count": 2,
					"average_rgve": 1.2,
					"weide_days": 120,
					"optional_150_days": false,
					"all_category_animals_participate": true,
					"weide_period_valid": true,
					"groundfeed_predominantly_grazing": true,
					"grazing_substantial_part_of_day": true,
					"water_access": true,
					"shelter_access": true,
					"weide_diary_complete": true,
					"animals_held_in_austria": true,
				},
				{
					"category": "female_sheep_1_plus",
					"participating": true,
					"animal_count": 6,
					"average_rgve": 0.9,
					"weide_days": 150,
					"optional_150_days": true,
					"all_category_animals_participate": true,
					"weide_period_valid": true,
					"groundfeed_predominantly_grazing": true,
					"grazing_substantial_part_of_day": true,
					"water_access": true,
					"shelter_access": true,
					"weide_diary_complete": true,
					"animals_held_in_austria": true,
					"vis_reporting_complete": true,
				},
			],
		},
	},
	"o6_20_application": {
		"measure_requested": true,
		"application_date_before_31_december": true,
	},
	"context": {
		"drought_2026": false,
		"control_note_acknowledged": true,
	},
}

test_valid_o6_20_decision if {
	result := o6_20.decision with input as valid_input
	result.eligible
	result.total_average_rgve == 2.1
}

test_optional_150_is_stricter if {
	result := o6_20.decision with input as valid_input
	result.categories[_].category == "female_sheep_1_plus"
	result.categories[_].required_weide_days == 150
}

test_all_category_animals_is_required if {
	case_input := {
		"farm": {
			"livestock": {
				"o6_20": [
					{
						"category": "female_cattle_2_plus",
						"participating": true,
						"animal_count": 2,
						"average_rgve": 2,
						"weide_days": 120,
						"all_category_animals_participate": false,
						"weide_period_valid": true,
						"groundfeed_predominantly_grazing": true,
						"grazing_substantial_part_of_day": true,
						"water_access": true,
						"shelter_access": true,
						"weide_diary_complete": true,
						"animals_held_in_austria": true,
					},
				],
			},
		},
	}
	result := o6_20.decision with input as case_input
	result.violations[_].rule_id == "o620-all-category-animals"
}

test_minimum_rgve_violation if {
	case_input := {
		"farm": {
			"year": 2026,
			"livestock": {
				"o6_20": [
					{
						"category": "female_sheep_1_plus",
						"participating": true,
						"animal_count": 1,
						"average_rgve": 0.15,
						"weide_days": 120,
						"all_category_animals_participate": true,
						"weide_period_valid": true,
						"groundfeed_predominantly_grazing": true,
						"grazing_substantial_part_of_day": true,
						"water_access": true,
						"shelter_access": true,
						"weide_diary_complete": true,
						"animals_held_in_austria": true,
						"vis_reporting_complete": true,
					},
				],
			},
		},
	}
	result := o6_20.decision with input as case_input
	result.violations[_].rule_id == "o620-minimum-rgve"
}

test_equids_need_count_correction_when_days_missed if {
	case_input := {
		"farm": {
			"livestock": {
				"o6_20": [
					{
						"category": "equids_small_adult",
						"participating": true,
						"animal_count": 4,
						"average_rgve": 2,
						"weide_days": 100,
						"all_category_animals_participate": true,
						"weide_period_valid": true,
						"groundfeed_predominantly_grazing": true,
						"grazing_substantial_part_of_day": true,
						"water_access": true,
						"shelter_access": true,
						"weide_diary_complete": true,
						"animals_held_in_austria": true,
						"count_correction_done": false,
						"replacement_by_growing_animals": false,
					},
				],
			},
		},
	}
	result := o6_20.decision with input as case_input
	result.violations[_].rule_id == "o620-equid-camel-correction"
}
