package oepul.o6_16_test

import data.oepul.o6_16

# --- Stickstoffübertrag: Beispiele aus Kapitel 4.3 des Informationsblatts ---
test_carryover_example_eferdinger_becken_2024 if {
	o6_16.n_carryover_kg_ha(20, 2024, 0.6) == 12
}

test_carryover_example_eferdinger_becken_2025 if {
	o6_16.n_carryover_kg_ha(20, 2025, 0.6) == 0
}

test_carryover_example_green_fallow_2024_second_step if {
	o6_16.n_carryover_kg_ha(12, 2024, 0.6) == 7.2
	o6_16.n_carryover_kg_ha(7.2, 2024, 0.6) == 0
}

test_carryover_example_tullnerfeld if {
	o6_16.n_carryover_kg_ha(30, 2025, 0.8) == 24
}

test_carryover_example_hail_zollfeld if {
	o6_16.n_carryover_kg_ha(180, 2024, 0.6) == 108
	o6_16.n_carryover_kg_ha(180, 2025, 0.6) == 60
}

test_carryover_example_south_burgenland_notice if {
	o6_16.n_carryover_kg_ha(40, 2026, 0.6) == 24
}

test_reduction_factor_by_zone if {
	w := object.union(parcel_wheat, {"n_reduction_zone": "other"})
	o6_16.parcel_reduction_factor(parcel_wheat) == 0.8 with input as base_input
	o6_16.parcel_reduction_factor(w) == 0.6 with input as with_parcels([w])
}

test_reduction_factor_vienna if {
	w := object.union(parcel_wheat, {"kg_number": "1104", "n_reduction_zone": null})
	o6_16.parcel_reduction_factor(w) == 0.8 with input as with_parcels([w])
}

test_carryover_violation_when_reduction_too_small if {
	w := object.union(parcel_wheat, {"n_balance": {"previous_crop_n_saldo_kg_ha": 50, "following_crop_n_reduction_kg_ha": 30}})
	"O616-NB-001" in rule_ids(o6_16.obligation_violations) with input as with_parcels([w, parcel_maize])
}

test_carryover_ok_when_reduction_sufficient if {
	w := object.union(parcel_wheat, {"n_balance": {"previous_crop_n_saldo_kg_ha": 50, "following_crop_n_reduction_kg_ha": 40}})
	not "O616-NB-001" in rule_ids(o6_16.obligation_violations) with input as with_parcels([w, parcel_maize])
}

test_unused_catch_crop_without_measure_full_carryover if {
	w := object.union(parcel_wheat, {"n_balance": {"previous_crop_n_saldo_kg_ha": 50, "unused_catch_crop": true, "catch_crop_per_measure_6_or_7": false}})
	o6_16.required_carryover(w) == 50 with input as with_parcels([w])
}

test_unused_catch_crop_fertilisation_limit_notice_example if {
	w := object.union(parcel_wheat, {"n_reduction_zone": "other", "n_balance": {"previous_crop_n_saldo_kg_ha": 40, "following_crop_n_reduction_kg_ha": 24, "unused_catch_crop": true, "following_main_crop_n_demand_kg_ha": 60, "unused_catch_crop_n_applied_kg_ha": 40}})
	o6_16.unused_catch_crop_max_n(w) == 36 with input as with_parcels([w])
	"O616-NB-007" in rule_ids(o6_16.obligation_violations) with input as with_parcels([w])
}

test_unused_catch_crop_fertilisation_limit_sheet_example if {
	w := object.union(parcel_wheat, {"n_balance": {"unused_catch_crop": true, "carryover_after_factor_kg_ha": 25, "following_main_crop_n_demand_kg_ha": 60, "unused_catch_crop_n_applied_kg_ha": 35}})
	o6_16.unused_catch_crop_max_n(w) == 35 with input as with_parcels([w])
	not "O616-NB-007" in rule_ids(o6_16.obligation_violations) with input as with_parcels([w])
}

test_reduction_factor_only_once if {
	w := object.union(parcel_wheat, {"n_balance": {"reduction_factor_applications_between_main_crops": 2}})
	"O616-NB-006" in rule_ids(o6_16.obligation_violations) with input as with_parcels([w])
}

test_autumn_cover_required_after_high_surplus if {
	w := object.union(parcel_wheat, {"n_balance": {"previous_crop_n_saldo_kg_ha": 35, "following_crop_n_reduction_kg_ha": 28, "catch_crop_per_measure_6_or_7": false, "follow_crop_sown_by_nov15": false}})
	"O616-NB-005" in rule_ids(o6_16.obligation_violations) with input as with_parcels([w])
}

test_autumn_cover_exempt_late_harvest if {
	w := object.union(parcel_wheat, {"n_balance": {"previous_crop_n_saldo_kg_ha": 35, "following_crop_n_reduction_kg_ha": 28, "catch_crop_per_measure_6_or_7": false, "previous_crop_harvested_after_sep30": true}})
	not "O616-NB-005" in rule_ids(o6_16.obligation_violations) with input as with_parcels([w])
}

test_autumn_cover_not_exempt_after_arable_forage_ploughing if {
	w := object.union(parcel_wheat, {"n_balance": {"catch_crop_per_measure_6_or_7": false, "previous_crop_harvested_after_sep30": true, "arable_forage_ploughed_before_nov15": true}})
	"O616-NB-005" in rule_ids(o6_16.obligation_violations) with input as with_parcels([w])
}

test_autumn_cover_after_field_vegetables if {
	w := object.union(parcel_wheat, {"n_balance": {"previous_crop_n_saldo_kg_ha": 5, "previous_crop_name": "Karotte", "catch_crop_per_measure_6_or_7": false}})
	"O616-NB-005" in rule_ids(o6_16.obligation_violations) with input as with_parcels([w])
}

test_vegetable_nmin_deduction_at_least_saldo if {
	v := object.union(parcel_wheat, {"crop": {"crop_name": "Kopfsalat"}, "n_balance": {"previous_crop_name": "Kohlrabi", "previous_crop_n_saldo_kg_ha": 18, "following_crop_n_reduction_kg_ha": 0, "vegetable_nmin_analysis_kg_ha": 10, "vegetable_nmin_deduction_kg_ha": 10}})
	o6_16.vegetable_min_deduction(v) == 18 with input as with_parcels([v])
	"O616-NB-009" in rule_ids(o6_16.obligation_violations) with input as with_parcels([v])
}

test_saldo_calculation_within_14_days if {
	w := object.union(parcel_wheat, {"n_balance": {"saldo_calculation_delay_days": 20}})
	"O616-NB-010" in rule_ids(o6_16.obligation_violations) with input as with_parcels([w])
}

test_computed_saldo_grain_maize_example if {
	m := object.union(parcel_maize, {"n_balance": {"crop_n_applied_kg_ha": 195, "uptake_crop": "Mais (CCM, Körnermais)", "uptake_differentiation": "Ertragslage mittel bis hoch 1", "harvest_t_ha": 14}})
	o6_16.computed_n_saldo(m) == 20 with input as with_parcels([m])
}

test_computed_saldo_soybean_uses_demand if {
	s := object.union(parcel_maize, {"n_balance": {"crop_n_applied_kg_ha": 0, "uptake_crop": "Sojabohne", "harvest_t_ha": 3}})
	o6_16.computed_n_saldo(s) == 0 with input as with_parcels([s])
}

test_computed_saldo_soybean_footnote_60 if {
	s := object.union(parcel_maize, {"n_balance": {"crop_n_applied_kg_ha": 60, "uptake_crop": "Sojabohne", "harvest_t_ha": 3, "legume_footnote1": true}})
	o6_16.computed_n_saldo(s) == 0 with input as with_parcels([s])
}

test_computed_saldo_wheat_matrix if {
	w := object.union(parcel_wheat, {"n_balance": {"crop_n_applied_kg_ha": 170, "uptake_crop": "Weizen", "crude_protein_percent_dm": 13.0, "grain_moisture_percent": 14.0, "harvest_t_ha": 8}})
	o6_16.computed_n_saldo(w) == 13.2 with input as with_parcels([w])
}

test_irrigation_n_formula if {
	o6_16.irrigation_n_kg_ha(44.3, 100) == 10
	o6_16.irrigation_n_relevant(44.3, 100)
	not o6_16.irrigation_n_relevant(20, 100)
}

# --- Aufzeichnungen ---
test_fertilization_plan_late if {
	inp := object.union(base_input, {"documentation": {"o6_16": {"fertilization_plan_date": "2026-03-05"}}})
	"O616-REC-002" in rule_ids(o6_16.obligation_violations) with input as inp
}

test_fertilization_balance_late if {
	inp := object.union(base_input, {"documentation": {"o6_16": {"fertilization_balance_date": "2027-02-05"}}})
	"O616-REC-003" in rule_ids(o6_16.obligation_violations) with input as inp
}

test_plot_records_incomplete if {
	w := object.union(parcel_wheat, {"plot_records": {"complete": false}})
	"O616-REC-004" in rule_ids(o6_16.obligation_violations) with input as with_parcels([w, parcel_maize])
}

test_plot_records_not_required_small_crop if {
	small := object.union(parcel_maize, {"area_ha": 0.3, "crop": {"crop_name": "Hirse"}, "plot_records": {"complete": false}})
	not "O616-REC-004" in rule_ids(o6_16.obligation_violations) with input as with_parcels([parcel_wheat, small])
}

test_plot_records_delay if {
	w := object.union(parcel_wheat, {"plot_records": {"complete": true, "max_delay_days": 15}})
	"O616-REC-006" in rule_ids(o6_16.obligation_violations) with input as with_parcels([w])
}

test_plot_records_electronic if {
	inp := object.union(base_input, {"documentation": {"o6_16": {"plot_records_electronic": false}}})
	"O616-REC-005" in rule_ids(o6_16.obligation_violations) with input as inp
}
