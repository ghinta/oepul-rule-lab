package oepul.o6_7_test

import rego.v1

import data.oepul.o6_7

base_input := {
	"farm": {"year": 2026},
	"land": {"arable_area_ha": 2},
	"o6_7": {
		"minimum_green_cover_percent": 90,
		"gaps": [],
		"intercrops": [],
		"field_records": {"complete": true},
		"selected_measures": [],
	},
}

test_eligible_farm_has_no_violations if {
	o6_7.eligible with input as base_input
	violations := o6_7.violations with input as base_input
	count(violations) == 0
}

test_rejects_late_intercrop_and_mineral_n if {
	candidate := object.union(base_input, {"o6_7": object.union(base_input.o6_7, {
		"intercrops": [{
			"established_on": "2026-10-16",
			"duration_days": 41,
			"mixture_partner_count": 1,
			"plant_family_count": 1,
			"predominantly_winter_hardy": false,
			"terminated_on": "2027-02-10",
			"napv_prohibition_end": "2027-02-15",
			"fertilizer_events": [{"kind": "mineral_nitrogen", "date": "2026-10-16"}],
			"plant_protection_events": [],
			"removal_method": "chemical",
			"used_for": "threshing",
		}],
	})})
	violations := o6_7.violations with input as candidate
	count(violations) == 7
}

test_drought_2026_excuses_only_gap_limit if {
	candidate := object.union(base_input, {"o6_7": object.union(base_input.o6_7, {
		"gaps": [{"kind": "harvest_to_main_crop", "days": 65, "drought_2026_exception": true, "prospective_management_credible": true, "established_at_earliest_possible_date": true}],
	})})
	violations := o6_7.violations with input as candidate
	count(violations) == 0
}

test_rejects_incompatible_scheme if {
	candidate := {
		"farm": {"year": 2026},
		"land": {"arable_area_ha": 2},
		"o6_7": {
			"minimum_green_cover_percent": 90,
			"gaps": [],
			"intercrops": [],
			"field_records": {"complete": true},
			"selected_measures": ["o6_6_begruenung_ackerflaechen_zwischenfruchtanbau"],
		},
	}
	violations := o6_7.violations with input as candidate
	violations[_].rule_id == "O67.combination.no-simultaneous-intercrop-scheme"
}
