package oepul.o6_16_test

import data.oepul.o6_16

# Anhang G: vollständige Katastralgemeindeliste
test_annex_g_row_count if {
	count(data.o6_16.gebietskulisse_anhang_g.rows) == 1566
}

test_annex_g_lookup if {
	o6_16.kg_in_area("20123")
	o6_16.kulisse_kg["20123"] == "niederoesterreich"
	o6_16.kulisse_kg["51106"] == "oberoesterreich"
	o6_16.kulisse_kg["1104"] == "wien"
	o6_16.kulisse_kg["32001"] == "burgenland"
	not o6_16.kg_in_area("99999")
}

test_offered_states if {
	o6_16.state_offered("kaernten")
	not o6_16.state_offered("tirol")
	not o6_16.state_offered("salzburg")
}

test_base_case_no_violations if {
	vs := o6_16.violations with input as base_input
	count(vs) == 0
	o6_16.access_conditions_met with input as base_input
}

test_combination_obligation_missing if {
	inp := object.union(base_input, {"farm": {"oepul": {"participating_measures": ["o6_16", "o6_1a"]}}})
	"o6_16.access.combination_obligation" in rule_ids(o6_16.violations) with input as inp
	not o6_16.access_conditions_met with input as inp
}

test_combination_with_system_immergruen if {
	inp := object.union(base_input, {"farm": {"oepul": {"participating_measures": ["o6_16", "o6_7"]}}})
	not "o6_16.access.combination_obligation" in rule_ids(o6_16.violations) with input as inp
}

test_min_area_first_year_violated if {
	small := object.union(maize_parcel, {"area_ha": 1.5})
	inp := with_year(object.union(with_parcels([small, outside_parcel]), {"farm": {"oepul": {"o6_16": {"contract_start_year": 2025, "measure_application_date": "2024-12-20"}}}}), 2025)
	"o6_16.access.min_area_first_year" in rule_ids(o6_16.violations) with input as inp
}

test_min_area_not_required_in_following_years if {
	small := object.union(maize_parcel, {"area_ha": 1.5})
	inp := with_parcels([small, outside_parcel])
	not "o6_16.access.min_area_first_year" in rule_ids(o6_16.violations) with input as inp
}

test_min_area_exactly_two_ha_first_year if {
	p := object.union(maize_parcel, {"area_ha": 2.0})
	inp := with_year(object.union(with_parcels([p]), {"farm": {"oepul": {"o6_16": {"contract_start_year": 2025, "measure_application_date": "2024-12-20"}}}}), 2025)
	not "o6_16.access.min_area_first_year" in rule_ids(o6_16.violations) with input as inp
}

test_contract_period_table if {
	o6_16.contract_period_years(2023) == 6
	o6_16.contract_period_years(2024) == 5
	o6_16.contract_period_years(2025) == 4
	o6_16.contract_end_date == "2028-12-31"
}

test_one_year_components if {
	o6_16.component_contract_is_one_year("cultan")
	o6_16.component_contract_is_one_year("leaching_risk_area")
	not o6_16.component_contract_is_one_year("humus_erosion_vienna")
}

test_application_deadline if {
	o6_16.application_in_time("2024-12-31", 2025)
	not o6_16.application_in_time("2025-01-02", 2025)
	inp := with_o16({"measure_application_date": "2023-01-05"})
	"o6_16.application.measure_application_deadline" in rule_ids(o6_16.violations) with input as inp
}

test_last_entry_2025 if {
	inp := with_o16({"contract_start_year": 2026, "measure_application_date": "2025-12-01"})
	"o6_16.application.last_entry_measure" in rule_ids(o6_16.violations) with input as inp
}

test_ag_and_cultan_need_no_measure_application if {
	not o6_16.requires_measure_application("leaching_risk_area")
	not o6_16.requires_measure_application("cultan")
	o6_16.requires_measure_application("n_reduced_pig_feeding")
}

pig_group(n) := {
	"species": "pigs",
	"category": "jung_mastschweine_ab_32kg",
	"animal_count": n,
	"gve": null,
	"feeding": {"feeding_category": "jung_mast_jungsau_ungedeckt", "crude_protein_avg_g_per_kg": 155, "phase_feeding": false, "recipe_evidence_available": true},
}

pig_input(n) := object.union(
	with_o16({"n_reduced_pig_feeding": {"applied": true, "application_date": "2025-11-30", "start_year": 2026}}),
	{"livestock": {"has_livestock": true, "species_groups": [pig_group(n)]}},
)

test_pig_gve_from_annex_a if {
	g := o6_16.pig_gve_total with input as pig_input(100)
	approx(g, 30)
}

test_pig_density_met if {
	# 100 Mastschweine x 0,3 GVE = 30 GVE / 22 ha Ackerfläche = 1,36 GVE/ha
	o6_16.pig_feeding_min_density_met with input as pig_input(100)
	not "o6_16.access.pig_feeding_min_density" in rule_ids(o6_16.violations) with input as pig_input(100)
}

test_pig_density_not_met if {
	# 50 x 0,3 = 15 GVE / 22 ha = 0,68 GVE/ha
	"o6_16.access.pig_feeding_min_density" in rule_ids(o6_16.violations) with input as pig_input(50)
}

test_pig_feeding_excluded_with_o6_9 if {
	inp := object.union(pig_input(100), {"farm": {"oepul": {"participating_measures": ["o6_16", "o6_6", "o6_9", "o6_9_n_reduced_pig_feeding"]}}})
	"o6_16.application.pig_feeding_not_with_o6_9" in rule_ids(o6_16.violations) with input as inp
}

test_pig_feeding_last_entry if {
	inp := object.union(pig_input(100), {"farm": {"oepul": {"o6_16": {"n_reduced_pig_feeding": {"start_year": 2029, "application_date": "2028-12-01"}}}}})
	"o6_16.application.pig_feeding_application" in rule_ids(o6_16.violations) with input as inp
}

test_pig_feeding_auto_renewal if {
	o6_16.pig_feeding_auto_renewed with input as pig_input(100)
	inp := object.union(pig_input(100), {"farm": {"oepul": {"o6_16": {"n_reduced_pig_feeding": {"deregistered": true}}}}})
	not o6_16.pig_feeding_auto_renewed with input as inp
}

test_option_requires_parcel if {
	inp := with_o16({"cultan": {"applied": true}})
	"o6_16.access.option_min_one_parcel" in rule_ids(o6_16.violations) with input as inp
}
