package oepul.o6_24_test

import data.oepul.o6_24
import rego.v1

# --- Teilnahme und Prämie ---

test_base_case_eligible_parcels_and_premium if {
	o6_24.participation_eligible with input as base_input
	o6_24.eligible_parcels == {"P1", "P2"} with input as base_input
	o6_24.eligible_area_ha == 2.5 with input as base_input
	o6_24.premium_rate_eur_per_ha == 54.0 with input as base_input
	o6_24.gross_premium_eur == 135 with input as base_input
	count(o6_24.commitment_violations) == 0 with input as base_input
}

test_fallow_and_permit_parcels_not_eligible if {
	"Brachfläche (SRL 2.24)" in o6_24.parcel_ineligibility.P3 with input as base_input
	"Bewilligung zu erhöhten Stickstoffdüngergaben (Code OPWRRL)" in o6_24.parcel_ineligibility.P4 with input as base_input
}

test_min_participation_counts_all_arable_in_area if {
	o6_24.wrrl_arable_area_ha == 3.8 with input as base_input
	o6_24.min_participation_met with input as base_input
}

test_min_participation_not_met_contract_lapses if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/1/wrrl/in_area", "value": false},
		{"op": "replace", "path": "/land/parcels/3/wrrl/in_area", "value": false},
	])
	o6_24.wrrl_arable_area_ha == 1.5 with input as inp
	o6_24.contract_lapses_this_year with input as inp
	not o6_24.participation_eligible with input as inp
	o6_24.gross_premium_eur == 0 with input as inp
}

test_premium_rate_2023 if {
	inp := patched([{"op": "replace", "path": "/farm/year", "value": 2023}])
	o6_24.premium_rate_eur_per_ha == 50.0 with input as inp
}

test_application_deadline_missed if {
	inp := patched([{"op": "replace", "path": "/farm/oepul/o6_24/measure_application_date", "value": "2023-01-02"}])
	not o6_24.application_deadline_met with input as inp
	not o6_24.contract_valid with input as inp
}

test_last_entry_2027 if {
	ok := patched([
		{"op": "replace", "path": "/farm/year", "value": 2027},
		{"op": "replace", "path": "/farm/oepul/o6_24/contract_start_year", "value": 2027},
		{"op": "replace", "path": "/farm/oepul/o6_24/measure_application_date", "value": "2026-12-31"},
	])
	o6_24.contract_valid with input as ok
	late := patched([
		{"op": "replace", "path": "/farm/year", "value": 2028},
		{"op": "replace", "path": "/farm/oepul/o6_24/contract_start_year", "value": 2028},
		{"op": "replace", "path": "/farm/oepul/o6_24/measure_application_date", "value": "2027-12-15"},
	])
	not o6_24.entry_year_allowed with input as late
	not o6_24.contract_valid with input as late
}

test_deregistration_in_year_invalidates_measure if {
	inp := patched([{"op": "add", "path": "/farm/oepul/o6_24/deregistration_date", "value": "2026-03-01"}])
	o6_24.deregistered_for_year with input as inp
	o6_24.gross_premium_eur == 0 with input as inp
}

test_exit_only_after_first_contract_year if {
	inp := patched([{"op": "add", "path": "/farm/oepul/o6_24/deregistration_date", "value": "2023-06-01"}])
	o6_24.deregistration_before_first_year_completed with input as inp
}

test_new_application_required_after_lapse if {
	inp := patched([{"op": "add", "path": "/farm/oepul/o6_24/lapsed_in_previous_year", "value": true}])
	o6_24.new_application_required with input as inp
	not o6_24.contract_valid with input as inp
	renewed := patched([
		{"op": "add", "path": "/farm/oepul/o6_24/lapsed_in_previous_year", "value": true},
		{"op": "replace", "path": "/farm/oepul/o6_24/contract_start_year", "value": 2026},
		{"op": "replace", "path": "/farm/oepul/o6_24/measure_application_date", "value": "2025-12-20"},
	])
	o6_24.contract_valid with input as renewed
}

test_opwrrl_code_missing_is_violation if {
	inp := patched([{"op": "replace", "path": "/land/parcels/3/oepul/codes", "value": []}])
	"P4" in o6_24.opwrrl_code_missing with input as inp
	some v in o6_24.commitment_violations with input as inp
	v.rule_id == "o6_24.apply.opwrrl_code"
}

# --- Stickstoff-Höchstmengen ---

test_weighted_limit_example_measure_sheet if {
	# Maßnahmenblatt: 144 x 0,70 + 108 x 0,30 = 133,2 (Blatt: 133 kg)
	o6_24.n_limit_kg_per_ha.P1 == 133.2 with input as base_input
}

test_unassigned_area_defaults_to_class_c if {
	o6_24.n_limit_kg_per_ha.P2 == 130 with input as base_input
	inp := patched([{"op": "add", "path": "/land/parcels/1/wrrl/fertilization_classes", "value": [{"class": "F", "area_ha": 0.5}]}])

	# 0,5 ha F (182) + 1,0 ha C (130) -> 147,33
	o6_24.n_limit_kg_per_ha.P2 == 147.33 with input as inp
}

test_vegetable_limit_group_columns if {
	inp := patched([{"op": "add", "path": "/land/parcels/3/wrrl/fertilization_classes", "value": [{"class": "E", "area_ha": 0.8}]}])
	o6_24.n_limit_kg_per_ha.P4 == 380 with input as inp
	o6_24.n_limit_kg_per_ha.P4 == 310 with input as base_input
}

test_n_limit_exceeded_including_previous_crop_credit if {
	inp := patched([{"op": "replace", "path": "/land/parcels/0/wrrl/n_applications/1/n_effective_kg_per_ha", "value": 70}])
	o6_24.n_accounted_kg_per_ha.P1 == 140 with input as inp
	o6_24.n_limit_exceeded.P1 with input as inp
	some v in o6_24.commitment_violations with input as inp
	v.rule_id == "o6_24.fert.n_limit"
	v.parcel_id == "P1"
}

test_irrigation_nitrogen_counts_towards_limit if {
	inp := patched([{"op": "add", "path": "/land/parcels/1/wrrl/irrigation_n_kg_per_ha", "value": 15}])
	o6_24.n_limit_exceeded.P2 with input as inp
}

ten_percent := {
	"claimed": true,
	"winter_hardy_cover_directly_after_main_crop": true,
	"cover_fertilized": false,
	"cover_same_field_and_area": true,
	"cover_contains_legumes": false,
	"cover_removed_only_before_spring_sowing": true,
	"written_notice_before_fertilization": true,
}

test_ten_percent_increase_valid if {
	inp := patched([{"op": "add", "path": "/land/parcels/1/wrrl/increase_10pct", "value": ten_percent}])
	o6_24.n_limit_kg_per_ha.P2 == 143 with input as inp
}

test_ten_percent_increase_invalid_with_legumes if {
	bad := object.union(ten_percent, {"cover_contains_legumes": true})
	inp := patched([
		{"op": "add", "path": "/land/parcels/1/wrrl/increase_10pct", "value": bad},
		{"op": "replace", "path": "/land/parcels/1/wrrl/n_applications/1/n_effective_kg_per_ha", "value": 60},
	])
	o6_24.n_limit_kg_per_ha.P2 == 130 with input as inp
	o6_24.increase_10pct_not_valid.P2 == {"cover_contains_legumes"} with input as inp
	some v in o6_24.commitment_violations with input as inp
	v.rule_id == "o6_24.fert.increase_10pct_conditions"
}

test_ten_percent_not_for_vegetables if {
	inp := patched([{"op": "add", "path": "/land/parcels/3/wrrl/increase_10pct", "value": ten_percent}])
	o6_24.n_limit_kg_per_ha.P4 == 310 with input as inp
}

test_separate_plot_required_when_fertilizing_by_class if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/wrrl/fertilize_subareas_by_class", "value": true}])
	o6_24.separate_plot_required.P1 with input as inp
}

test_crop_without_table_value_refers_to_napv if {
	inp := patched([{"op": "replace", "path": "/land/parcels/1/wrrl/gwsp_crop", "value": "Buchweizen"}])
	o6_24.napv_limit_required.P2 with input as inp
	not o6_24.n_limit_kg_per_ha.P2 with input as inp
}

# --- Düngetermine ---

test_application_before_maize_window if {
	inp := patched([{"op": "replace", "path": "/land/parcels/1/wrrl/n_applications/0/date", "value": "2026-03-20"}])
	o6_24.applications_outside_period.P2 == {"2026-03-20"} with input as inp
}

test_compost_exempt_from_period_table if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/1/wrrl/n_applications/0/date", "value": "2026-03-20"},
		{"op": "replace", "path": "/land/parcels/1/wrrl/n_applications/0/fertilizer_type", "value": "compost"},
	])
	not o6_24.applications_outside_period.P2 with input as inp
}

test_winter_wheat_until_end_of_august if {
	ok := patched([{"op": "replace", "path": "/land/parcels/0/wrrl/n_applications/1/date", "value": "2026-08-31"}])
	not o6_24.applications_outside_period.P1 with input as ok
	late := patched([{"op": "replace", "path": "/land/parcels/0/wrrl/n_applications/1/date", "value": "2026-09-01"}])
	o6_24.applications_outside_period.P1 == {"2026-09-01"} with input as late
}

test_ambiguous_wheat_uses_fallback_row if {
	inp := patched([
		{"op": "remove", "path": "/land/parcels/0/wrrl/gwsp_period_crop"},
		{"op": "replace", "path": "/land/parcels/0/wrrl/n_applications/1/date", "value": "2026-08-15"},
	])
	o6_24.period_row_assumed.P1 with input as inp
	o6_24.applications_outside_period.P1 == {"2026-08-15"} with input as inp
}

winter_barley_ops(n, sow) := [
	{"op": "replace", "path": "/land/parcels/1/wrrl/gwsp_crop", "value": "Wintergerste"},
	{"op": "replace", "path": "/land/parcels/1/wrrl/sowing_date", "value": sow},
	{"op": "replace", "path": "/land/parcels/1/wrrl/n_applications", "value": [{"date": "2026-09-10", "fertilizer_type": "mineral", "amount": 90, "n_effective_kg_per_ha": n}]},
	{"op": "add", "path": "/land/parcels/1/wrrl/winter_barley_special", "value": {
		"legume_free_cover_or_n_consuming_crop_after_harvest": true,
		"cover_removed_only_before_spring_sowing": true,
		"written_notice_before_fertilization": true,
	}},
]

test_winter_barley_special_rule_allows_autumn_fertilization if {
	inp := patched(winter_barley_ops(25, "2026-09-14"))
	not o6_24.applications_outside_period.P2 with input as inp
}

test_winter_barley_special_rule_max_30kg if {
	inp := patched(winter_barley_ops(35, "2026-09-14"))
	o6_24.winter_barley_special_conditions_violated(input.land.parcels[1]) == {"n_over_30kg"} with input as inp
	o6_24.applications_outside_period.P2 == {"2026-09-10"} with input as inp
}

test_winter_barley_special_rule_sowing_within_6_days if {
	inp := patched(winter_barley_ops(25, "2026-09-20"))
	o6_24.applications_outside_period.P2 == {"2026-09-10"} with input as inp
}

test_soy_fertilization_requires_reason if {
	inp := patched([{"op": "replace", "path": "/land/parcels/1/wrrl/gwsp_crop", "value": "Sojabohne"}])
	o6_24.soy_fertilization_not_justified.P2 with input as inp
	ok := patched([
		{"op": "replace", "path": "/land/parcels/1/wrrl/gwsp_crop", "value": "Sojabohne"},
		{"op": "add", "path": "/land/parcels/1/wrrl/soy_fertilization_reason", "value": "first_cultivation"},
	])
	not o6_24.soy_fertilization_not_justified.P2 with input as ok
}

test_fallow_fertilization_requires_permit if {
	inp := patched([{"op": "add", "path": "/land/parcels/2/wrrl/n_applications", "value": [{"date": "2026-05-01", "fertilizer_type": "slurry", "amount": 10, "n_effective_kg_per_ha": 30}]}])
	o6_24.fallow_or_cover_fertilized.P3 with input as inp
	"Düngung von Begrünungen oder brachliegenden Flächen" in o6_24.gwsp_permit_required_reasons.P3 with input as inp
}
