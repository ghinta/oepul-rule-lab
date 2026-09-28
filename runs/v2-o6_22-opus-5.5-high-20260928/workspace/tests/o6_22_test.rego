package oepul.o6_22_test

import data.oepul.o6_22

# ---------------------------------------------------------------------------
# Reference farm (fixture) — fully compliant, premium calculation
# ---------------------------------------------------------------------------

test_reference_farm_has_no_violations if {
	count(o6_22.violations) == 0 with input as base_input
	count(o6_22.group_issues) == 0 with input as base_input
	count(o6_22.missing_inputs) == 0 with input as base_input
}

test_reference_farm_category_gve if {
	o6_22.category_gve == {"jung_mastschweine": 30, "ferkel": 14, "zuchtsauen": 10} with input as base_input
	o6_22.participating_gve == 54 with input as base_input
	o6_22.measure_valid with input as base_input
}

test_reference_farm_premium_2025 if {
	# 30 GVE x (70.2 + 64.8 + 64.8 + 21.6) + 14 GVE x (194.4 + 64.8 + 21.6) + 10 GVE x (86.4 + 64.8 + 21.6)
	o6_22.gross_premium == 12301.2 with input as base_input
	o6_22.net_premium == 12301.2 with input as base_input
}

test_undocked_supplement_not_paid_for_other_categories if {
	comps := o6_22.premium_components with input as base_input
	undocked := {p.measure_category | some p in comps; p.component == "unkupiert"}
	undocked == {"jung_mastschweine"}
}

test_premium_2023_rates_and_no_composting_supplement if {
	inp := patched([{"op": "replace", "path": "/farm/year", "value": 2023}])
	comps := o6_22.premium_components with input as inp
	{p.component | some p in comps} == {"base", "unkupiert"}
	some p in comps
	p.measure_category == "ferkel"
	p.eur_per_gve == 180
}

test_result_document_is_complete if {
	r := o6_22.result with input as base_input
	r.measure == "o6_22"
	r.tgd_required == true
	r.net_premium_eur == 12301.2
}

# ---------------------------------------------------------------------------
# Minimum participation and category lapse
# ---------------------------------------------------------------------------

test_min_participation_below_2_gve if {
	inp := patched([
		{"op": "replace", "path": "/livestock/species_groups", "value": [pig_group("mastschweine_50_80", 5, 70, 10, 4)]},
		{"op": "replace", "path": "/oepul_application/o6_22/category_applications", "value": [{"measure_category": "jung_mastschweine", "applied_on": "2022-12-15", "first_commitment_year": 2023}]},
	])
	o6_22.participating_gve == 1.5 with input as inp
	not o6_22.min_participation_met with input as inp
	"O622-ELIG-01" in rule_ids(o6_22.violations) with input as inp
	o6_22.gross_premium == 0 with input as inp
}

test_min_participation_exactly_2_gve_over_all_categories if {
	inp := patched([
		{"op": "replace", "path": "/livestock/species_groups", "value": [
			pig_group("mastschweine_50_80", 3, 70, 10, 4),
			pig_group("ferkel_20_32", 16, 25, 10, 4),
			pig_group("jungsauen_gedeckt_ab_50", 0, null, 0, 0),
		]},
		{"op": "replace", "path": "/oepul_application/o6_22/category_applications", "value": [
			{"measure_category": "jung_mastschweine", "applied_on": "2022-12-15", "first_commitment_year": 2023},
			{"measure_category": "ferkel", "applied_on": "2022-12-15", "first_commitment_year": 2023},
		]},
	])

	# 3 x 0.30 + 16 x 0.07 = 2.02
	o6_22.participating_gve == 2.02 with input as inp
	o6_22.min_participation_met with input as inp
}

test_average_animal_list_used_when_submitted if {
	inp := patched([{"op": "replace", "path": "/livestock/species_groups/0/average_animal_count", "value": 80}])
	o6_22.category_gve.jung_mastschweine == 24 with input as inp
	inp2 := json.patch(inp, [{"op": "replace", "path": "/livestock/average_animal_list_submitted", "value": false}])
	o6_22.category_gve.jung_mastschweine == 30 with input as inp2
}

test_category_without_animals_lapses if {
	inp := patched([{"op": "replace", "path": "/oepul_application/o6_22/deregistrations", "value": [{"measure_category": "zuchtsauen", "average_count": 20, "notified_immediately": true}]}])
	o6_22.category_contract_lapsed == {"zuchtsauen"} with input as inp
	"O622-APP-07" in rule_ids(o6_22.violations) with input as inp
}

# ---------------------------------------------------------------------------
# Applications, entry deadlines, withdrawals
# ---------------------------------------------------------------------------

test_late_category_application_invalid if {
	inp := patched([{"op": "replace", "path": "/oepul_application/o6_22/category_applications/1", "value": {"measure_category": "ferkel", "applied_on": "2025-01-05", "first_commitment_year": 2025}}])
	not "ferkel" in o6_22.active_categories with input as inp
	"O622-APP-01" in rule_ids(o6_22.violations) with input as inp
}

test_last_category_entry_2027 if {
	ok := {"measure_category": "ferkel", "applied_on": "2026-12-31", "first_commitment_year": 2027}
	late := {"measure_category": "ferkel", "applied_on": "2027-12-31", "first_commitment_year": 2028}
	o6_22.category_application_valid(ok)
	not o6_22.category_application_valid(late)
}

test_last_supplement_entry_2028 if {
	ok := {"supplement": "gvo_frei_eiweiss", "measure_category": null, "applied_on": "2027-12-31", "first_commitment_year": 2028}
	late := {"supplement": "gvo_frei_eiweiss", "measure_category": null, "applied_on": "2028-12-31", "first_commitment_year": 2029}
	o6_22.supplement_application_valid(ok)
	not o6_22.supplement_application_valid(late)
}

test_composting_supplement_not_before_2025 if {
	s := {"supplement": "festmistkompostierung", "measure_category": null, "applied_on": "2023-12-01", "first_commitment_year": 2024}
	not o6_22.supplement_application_valid(s)
}

test_undocked_supplement_not_offered_for_sows if {
	s := {"supplement": "unkupiert", "measure_category": "zuchtsauen", "applied_on": "2022-12-01", "first_commitment_year": 2023}
	not o6_22.supplement_application_valid(s)
}

test_withdrawal_during_year_invalidates_year if {
	inp := patched([{"op": "replace", "path": "/oepul_application/o6_22/withdrawals", "value": [{"scope": "measure", "measure_category": null, "supplement": null, "notified_on": "2025-06-01"}]}])
	count(o6_22.active_categories) == 0 with input as inp
	o6_22.gross_premium == 0 with input as inp
	inp_prev := json.patch(inp, [{"op": "replace", "path": "/farm/year", "value": 2024}])
	count(o6_22.active_categories) == 3 with input as inp_prev
}

test_category_withdrawal_only_affects_that_category if {
	inp := patched([{"op": "replace", "path": "/oepul_application/o6_22/withdrawals", "value": [{"scope": "category", "measure_category": "ferkel", "supplement": null, "notified_on": "2025-01-10"}]}])
	o6_22.active_categories == {"jung_mastschweine", "zuchtsauen"} with input as inp
}

test_supplement_withdrawal if {
	inp := patched([{"op": "replace", "path": "/oepul_application/o6_22/withdrawals", "value": [{"scope": "supplement", "measure_category": null, "supplement": "gvo_frei_eiweiss", "notified_on": "2025-01-10"}]}])
	comps := o6_22.premium_components with input as inp
	not "gvo_frei_eiweiss" in {p.component | some p in comps}
}

test_reentry_after_withdrawal_with_new_application if {
	inp := patched([
		{"op": "replace", "path": "/oepul_application/o6_22/withdrawals", "value": [{"scope": "category", "measure_category": "ferkel", "supplement": null, "notified_on": "2024-02-01"}]},
		{"op": "add", "path": "/oepul_application/o6_22/category_applications/-", "value": {"measure_category": "ferkel", "applied_on": "2024-12-20", "first_commitment_year": 2025}},
	])
	"ferkel" in o6_22.active_categories with input as inp
}

# ---------------------------------------------------------------------------
# Space allowance, lying area, stall conditions
# ---------------------------------------------------------------------------

test_info_sheet_example_25_pigs_over_85_kg if {
	g := pig_group("mastschweine_80_110", 25, 100, 27.5, 11)
	o6_22.required_total_area(g) == 27.5
	o6_22.required_littered_lying_area(g) == 11
}

test_occupancy_plan_example_15_m2 if {
	o6_22.max_animals_in_compartment(15, 40) == 21
	o6_22.max_animals_in_compartment(15, 60) == 16
	o6_22.max_animals_in_compartment(15, 90) == 13
}

test_weight_class_boundaries if {
	o6_22.fattening_requirement(20).total_area_m2_per_animal == 0.3
	o6_22.fattening_requirement(20.5).total_area_m2_per_animal == 0.5
	o6_22.fattening_requirement(32).total_area_m2_per_animal == 0.5
	o6_22.fattening_requirement(50).total_area_m2_per_animal == 0.7
	o6_22.fattening_requirement(84.9).total_area_m2_per_animal == 0.9
	o6_22.fattening_requirement(85).total_area_m2_per_animal == 1.1
}

test_fallback_weight_uses_tierliste_upper_bound if {
	g := object.remove(pig_group("mastschweine_80_110", 10, null, 11, 4.4), ["average_live_weight_kg"])
	o6_22.required_total_area(g) == 11
}

test_sow_space_requirements if {
	sau := pig_group("aeltere_sauen_nicht_gedeckt_ab_50", 10, null, 30, 13)
	o6_22.required_total_area(sau) == 30
	o6_22.required_littered_lying_area(sau) == 13
	jungsau := pig_group("jungsauen_gedeckt_ab_50", 10, null, 20, 9.5)
	o6_22.required_total_area(jungsau) == 20
	o6_22.required_littered_lying_area(jungsau) == 9.5
}

test_insufficient_total_area_requires_deregistration if {
	inp := patched([{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/stall_area_m2", "value": 85}])
	"insufficient_usable_total_area" in issue_reasons(o6_22.group_issues) with input as inp
	o6_22.required_deregistration_count.jung_mastschweine == 100 with input as inp
	"O622-REPORT-01" in rule_ids(o6_22.violations) with input as inp
}

test_paved_run_counts_only_with_permanent_access if {
	inp := patched([
		{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/stall_area_m2", "value": 70},
		{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/paved_outdoor_run_area_m2", "value": 25},
		{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/outdoor_run_permanently_accessible", "value": true},
	])
	count(o6_22.group_issues) == 0 with input as inp
	inp_locked := json.patch(inp, [{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/outdoor_run_permanently_accessible", "value": false}])
	"insufficient_usable_total_area" in issue_reasons(o6_22.group_issues) with input as inp_locked
}

test_littered_lying_area_below_40_percent if {
	inp := patched([{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/lying_area_m2", "value": 35}])
	"insufficient_littered_lying_area" in issue_reasons(o6_22.group_issues) with input as inp
}

test_full_slatted_floor_and_perforation if {
	inp := patched([
		{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/floor_type", "value": "full_slatted"},
		{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/lying_area_perforation_percent", "value": 6},
	])
	reasons := issue_reasons(o6_22.group_issues) with input as inp
	"full_slatted_floor" in reasons
	"lying_area_perforation_above_5_percent" in reasons
}

test_perforation_of_5_percent_counts_as_solid if {
	inp := patched([{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/lying_area_perforation_percent", "value": 5}])
	count(o6_22.group_issues) == 0 with input as inp
}

test_minimal_litter_requires_additional_straw_or_hay if {
	inp := patched([
		{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/minimal_litter", "value": true},
		{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/enrichment_material", "value": "none"},
	])
	"insufficient_enrichment_material" in issue_reasons(o6_22.group_issues) with input as inp
	inp_rack := json.patch(inp, [{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/enrichment_material", "value": "hay"}])
	count(o6_22.group_issues) == 0 with input as inp_rack
}

test_stall_definition_three_sides if {
	inp := patched([{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/enclosed_sides", "value": 2}])
	"stall_definition_not_met" in issue_reasons(o6_22.group_issues) with input as inp
}

test_open_stall_requires_liquid_tight_floor if {
	inp := patched([
		{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/is_open_stall", "value": true},
		{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/enclosed_sides", "value": 1},
		{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/floor_liquid_tight", "value": true},
		{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/seepage_drain_to_pit", "value": true},
	])
	count(o6_22.group_issues) == 0 with input as inp
	inp_bad := json.patch(inp, [{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/floor_liquid_tight", "value": false}])
	"stall_definition_not_met" in issue_reasons(o6_22.group_issues) with input as inp_bad
}

test_not_compliant_over_whole_fattening_period if {
	inp := patched([{"op": "replace", "path": "/livestock/species_groups/0/pig_welfare/compliant_throughout_holding_period", "value": false}])
	"not_compliant_throughout_holding_period" in issue_reasons(o6_22.group_issues) with input as inp
}

# ---------------------------------------------------------------------------
# Group housing and single housing of sick animals
# ---------------------------------------------------------------------------

test_single_housing_sick_up_to_10_days_ok if {
	inp := patched([
		{"op": "replace", "path": "/livestock/species_groups/0/pig_welfare/group_housing", "value": false},
		{"op": "replace", "path": "/livestock/species_groups/0/pig_welfare/single_housing", "value": {"reason": "illness_or_injury", "max_days": 10, "littered": true, "documented": true}},
	])
	count(o6_22.group_issues) == 0 with input as inp
	count(o6_22.violations) == 0 with input as inp
}

test_single_housing_over_10_days if {
	inp := patched([{"op": "replace", "path": "/livestock/species_groups/0/pig_welfare/single_housing", "value": {"reason": "illness_or_injury", "max_days": 11, "littered": true, "documented": true}}])
	"single_housing_over_10_days" in issue_reasons(o6_22.group_issues) with input as inp
}

test_single_housing_documentation_missing if {
	inp := patched([{"op": "replace", "path": "/livestock/species_groups/0/pig_welfare/single_housing", "value": {"reason": "illness_or_injury", "max_days": 5, "littered": true, "documented": false}}])
	"O622-STALL-GROUP-04" in rule_ids(o6_22.violations) with input as inp
}

test_no_group_housing if {
	inp := patched([{"op": "replace", "path": "/livestock/species_groups/2/pig_welfare/group_housing", "value": false}])
	"no_group_housing" in issue_reasons(o6_22.group_issues) with input as inp
}

# ---------------------------------------------------------------------------
# Deregistration (Meldepflichten)
# ---------------------------------------------------------------------------

test_info_sheet_example_24_pigs_moved_to_old_stall if {
	old := json.patch(pig_group("mastschweine_50_80", 24, 70, 15, 0), [{"op": "replace", "path": "/housing/stall/floor_type", "value": "full_slatted"}])
	inp := patched([{"op": "add", "path": "/livestock/species_groups/-", "value": old}])
	o6_22.required_deregistration_count.jung_mastschweine == 24 with input as inp
	"O622-REPORT-01" in rule_ids(o6_22.violations) with input as inp
	inp_ok := json.patch(inp, [{"op": "replace", "path": "/oepul_application/o6_22/deregistrations", "value": [{"measure_category": "jung_mastschweine", "average_count": 24, "notified_immediately": true}]}])
	not "O622-REPORT-01" in rule_ids(o6_22.violations) with input as inp_ok
	o6_22.category_gve.jung_mastschweine == 30 with input as inp_ok
}

test_deregistration_not_immediate if {
	inp := patched([{"op": "replace", "path": "/oepul_application/o6_22/deregistrations", "value": [{"measure_category": "ferkel", "average_count": 10, "notified_immediately": false}]}])
	"O622-REPORT-01" in rule_ids(o6_22.violations) with input as inp
}

test_zuchteber_not_eligible if {
	boar := pig_group("zuchteber_ab_50", 2, 200, 10, 5)
	inp := patched([{"op": "add", "path": "/livestock/species_groups/-", "value": boar}])
	o6_22.participating_gve == 54 with input as inp
}

test_animals_outside_austria_not_counted if {
	inp := patched([{"op": "replace", "path": "/livestock/species_groups/0/kept_in_austria", "value": false}])
	o6_22.category_gve.jung_mastschweine == 0 with input as inp
	o6_22.category_contract_lapsed == {"jung_mastschweine"} with input as inp
	"O622-GEN-LOC-01" in rule_ids(o6_22.violations) with input as inp
}

# ---------------------------------------------------------------------------
# Free-range husbandry
# ---------------------------------------------------------------------------

freiland_group(n, area_ha, rotation_ha) := json.patch(pig_group("mastschweine_80_110", n, 90, 0, 0), [{"op": "replace", "path": "/housing", "value": {
	"housing_type": "pasture",
	"stall": null,
	"pasture": {
		"pasture_area_ha": area_ha,
		"rotation_total_area_ha": rotation_ha,
		"water_permit_max_gve_per_ha": null,
		"continuous_use_months": 6,
		"double_fence_or_solid_enclosure": true,
		"feeding_and_watering_separated": true,
		"feeding_and_watering_paved_or_relocated": true,
		"feeding_place_roofed": true,
		"shelter_roofed": true,
		"shelter_three_sided_closed": true,
		"shelter_littered": true,
		"shelter_all_animals_lie_simultaneously": true,
		"farrowing_huts_available": null,
		"documentation_per_plot_complete": true,
		"unpaved_area_declared_as_other_land": true,
	},
}}])

test_info_sheet_example_freiland_rotation_3_gve_per_ha if {
	g := freiland_group(20, 1, 2)
	o6_22.freiland_stocking_gve_per_ha(g) == 3
	inp := patched([{"op": "replace", "path": "/livestock/species_groups/0", "value": g}])
	count(o6_22.group_issues) == 0 with input as inp
}

test_freiland_stocking_exceeded_without_rotation if {
	g := freiland_group(20, 1, null)
	inp := patched([{"op": "replace", "path": "/livestock/species_groups/0", "value": g}])
	"freiland_stocking_density_exceeded" in issue_reasons(o6_22.group_issues) with input as inp
}

test_freiland_water_permit_limit_prevails if {
	g := json.patch(freiland_group(20, 2, null), [{"op": "replace", "path": "/housing/pasture/water_permit_max_gve_per_ha", "value": 2.5}])
	o6_22.freiland_stocking_limit(g) == 2.5
	inp := patched([{"op": "replace", "path": "/livestock/species_groups/0", "value": g}])
	"freiland_stocking_density_exceeded" in issue_reasons(o6_22.group_issues) with input as inp
}

test_freiland_conditions if {
	g := json.patch(freiland_group(10, 2, null), [
		{"op": "replace", "path": "/housing/pasture/double_fence_or_solid_enclosure", "value": false},
		{"op": "replace", "path": "/housing/pasture/continuous_use_months", "value": 13},
		{"op": "replace", "path": "/housing/pasture/feeding_place_roofed", "value": false},
		{"op": "replace", "path": "/housing/pasture/documentation_per_plot_complete", "value": false},
	])
	inp := patched([{"op": "replace", "path": "/livestock/species_groups/0", "value": g}])
	reasons := issue_reasons(o6_22.group_issues) with input as inp
	"freiland_enclosure_insufficient" in reasons
	"freiland_continuous_use_over_one_year" in reasons
	"freiland_feeding_place_not_roofed" in reasons
	"O622-FREE-06" in rule_ids(o6_22.violations) with input as inp
}

test_freiland_empty_sows_need_no_litter_in_shelter if {
	sows := json.patch(freiland_group(10, 2, null), [
		{"op": "replace", "path": "/tierliste_category", "value": "aeltere_sauen_nicht_gedeckt_ab_50"},
		{"op": "replace", "path": "/housing/pasture/shelter_littered", "value": false},
		{"op": "replace", "path": "/pig_welfare/sow_phase", "value": "empty_or_pregnant"},
	])
	inp := patched([{"op": "replace", "path": "/livestock/species_groups/2", "value": sows}])
	count(o6_22.group_issues) == 0 with input as inp
	farrowing := json.patch(sows, [
		{"op": "replace", "path": "/pig_welfare/sow_phase", "value": "farrowing_or_suckling"},
		{"op": "replace", "path": "/housing/pasture/farrowing_huts_available", "value": false},
	])
	inp2 := patched([{"op": "replace", "path": "/livestock/species_groups/2", "value": farrowing}])
	reasons := issue_reasons(o6_22.group_issues) with input as inp2
	"freiland_shelter_not_littered" in reasons
	"freiland_farrowing_huts_missing" in reasons
}

test_wild_boar_not_eligible if {
	inp := patched([{"op": "replace", "path": "/livestock/species_groups/0/is_wild_boar", "value": true}])
	"wild_boar_not_eligible" in issue_reasons(o6_22.group_issues) with input as inp
}

test_mixed_housing_checks_stall_and_freiland if {
	g := json.patch(freiland_group(10, 2, null), [
		{"op": "replace", "path": "/housing/housing_type", "value": "mixed"},
		{"op": "replace", "path": "/housing/stall", "value": stall_ok(5, 2)},
	])
	inp := patched([{"op": "replace", "path": "/livestock/species_groups/0", "value": g}])
	"insufficient_usable_total_area" in issue_reasons(o6_22.group_issues) with input as inp
}

# ---------------------------------------------------------------------------
# Animal health service (TGD), documentation, VIS
# ---------------------------------------------------------------------------

test_tgd_required_above_10_gve if {
	inp := patched([{"op": "replace", "path": "/oepul_application/o6_22/animal_health_service", "value": {"participating": false, "from": null, "to": null, "proof_available": null}}])
	o6_22.farm_eligible_pig_gve == 54 with input as inp
	"O622-TGD-01" in rule_ids(o6_22.violations) with input as inp
}

test_tgd_not_required_at_10_gve if {
	inp := patched([
		{"op": "replace", "path": "/livestock/species_groups", "value": [pig_group("mastschweine_50_80", 33, 70, 40, 16)]},
		{"op": "replace", "path": "/oepul_application/o6_22/animal_health_service", "value": {"participating": false, "from": null, "to": null, "proof_available": null}},
	])
	not o6_22.tgd_required with input as inp
	not "O622-TGD-01" in rule_ids(o6_22.violations) with input as inp
}

test_tgd_2023_from_15_april_sufficient if {
	inp := patched([
		{"op": "replace", "path": "/farm/year", "value": 2023},
		{"op": "replace", "path": "/oepul_application/o6_22/animal_health_service", "value": {"participating": true, "from": "2023-04-15", "to": "2023-12-31", "proof_available": true}},
	])
	o6_22.tgd_ok with input as inp
	inp_2024 := json.patch(inp, [
		{"op": "replace", "path": "/farm/year", "value": 2024},
		{"op": "replace", "path": "/oepul_application/o6_22/animal_health_service/from", "value": "2024-04-15"},
		{"op": "replace", "path": "/oepul_application/o6_22/animal_health_service/to", "value": "2024-12-31"},
	])
	not o6_22.tgd_ok with input as inp_2024
}

test_stall_sketch_required_until_2024_only if {
	inp := patched([{"op": "replace", "path": "/farm/year", "value": 2024}])
	"O622-DOC-SKETCH-01" in rule_ids(o6_22.violations) with input as inp
	not "O622-DOC-SKETCH-01" in rule_ids(o6_22.violations) with input as base_input
}

test_vis_reporting_incomplete if {
	inp := patched([{"op": "replace", "path": "/oepul_application/o6_22/vis_reporting_complete", "value": false}])
	"O622-VIS-01" in rule_ids(o6_22.violations) with input as inp
}

# ---------------------------------------------------------------------------
# Supplements
# ---------------------------------------------------------------------------

test_undocked_supplement_violated_by_docked_participating_group if {
	inp := patched([{"op": "replace", "path": "/livestock/species_groups/0/tail_docked", "value": true}])
	"O622-SUP-UNK-02" in rule_ids(o6_22.violations) with input as inp
}

test_undocked_supplement_ignores_deregistered_conventional_group if {
	conventional := json.patch(pig_group("mastschweine_50_80", 50, 70, 30, 0), [
		{"op": "replace", "path": "/housing/stall/floor_type", "value": "full_slatted"},
		{"op": "replace", "path": "/tail_docked", "value": true},
	])
	inp := patched([
		{"op": "add", "path": "/livestock/species_groups/-", "value": conventional},
		{"op": "replace", "path": "/oepul_application/o6_22/deregistrations", "value": [{"measure_category": "jung_mastschweine", "average_count": 50, "notified_immediately": true}]},
	])
	not "O622-SUP-UNK-02" in rule_ids(o6_22.violations) with input as inp
	not "O622-REPORT-01" in rule_ids(o6_22.violations) with input as inp
}

test_gvo_supplement_other_species_fed_gmo_feed if {
	inp := patched([{"op": "replace", "path": "/oepul_application/o6_22/gvo_free_protein_feed/non_compliant_protein_feed_stored_or_fed", "value": true}])
	"O622-SUP-GVO-01" in rule_ids(o6_22.violations) with input as inp
}

test_gvo_supplement_missing_proofs if {
	inp := patched([{"op": "replace", "path": "/oepul_application/o6_22/gvo_free_protein_feed/purchase_proofs_available", "value": false}])
	"O622-SUP-GVO-03" in rule_ids(o6_22.violations) with input as inp
}

test_protein_feed_definition if {
	o6_22.is_protein_feed({"crude_protein_percent_dm": 44, "is_roughage": false})
	not o6_22.is_protein_feed({"crude_protein_percent_dm": 20, "is_roughage": false})
	not o6_22.is_protein_feed({"crude_protein_percent_dm": 22, "is_roughage": true})
	o6_22.feed_origin_ok({"origin_continent": "europe"})
	not o6_22.feed_origin_ok({"origin_continent": "south_america"})
}

test_composting_turn_interval_below_14_days if {
	inp := patched([{"op": "replace", "path": "/oepul_application/o6_22/solid_manure_composting/windrows/0/turn_dates", "value": ["2025-05-01", "2025-05-10"]}])
	"O622-SUP-COMP-01" in rule_ids(o6_22.violations) with input as inp
}

test_composting_front_loader_not_eligible if {
	inp := patched([{"op": "replace", "path": "/oepul_application/o6_22/solid_manure_composting/windrows/0/turning_equipment", "value": "front_loader"}])
	"O622-SUP-COMP-01" in rule_ids(o6_22.violations) with input as inp
}

test_composting_manure_spreader_needs_complete_turning if {
	inp := patched([
		{"op": "replace", "path": "/oepul_application/o6_22/solid_manure_composting/windrows/0/turning_equipment", "value": "manure_spreader"},
		{"op": "replace", "path": "/oepul_application/o6_22/solid_manure_composting/windrows/0/complete_turning", "value": false},
	])
	"O622-SUP-COMP-01" in rule_ids(o6_22.violations) with input as inp
}

test_composting_unturned_with_additives if {
	w := {
		"windrow_id": "M2", "method": "unturned_with_additives", "turn_dates": [],
		"turning_equipment": "none", "complete_turning": null, "equipment_owned_or_use_documented": null,
		"plant_material_share_percent": 50, "composting_process_applied": true, "straw_rich_manure_only": false,
	}
	o6_22.windrow_ok(w)
	not o6_22.windrow_ok(json.patch(w, [{"op": "replace", "path": "/composting_process_applied", "value": false}]))
	not o6_22.windrow_ok(json.patch(w, [{"op": "replace", "path": "/straw_rich_manure_only", "value": true}]))
}

test_composting_mixed_windrow_needs_no_turning if {
	w := {"windrow_id": "M3", "method": "mixed_or_layered", "turn_dates": [], "plant_material_share_percent": 30}
	o6_22.windrow_ok(w)
}

test_compost_barn_excluded_from_supplement if {
	inp := patched([{"op": "replace", "path": "/oepul_application/o6_22/solid_manure_composting/compost_stall_system", "value": true}])
	"O622-SUP-COMP-08" in rule_ids(o6_22.violations) with input as inp
	comps := o6_22.premium_components with input as inp
	not "festmistkompostierung" in {p.component | some p in comps}
}

# ---------------------------------------------------------------------------
# Premium table consistency, modulation, sanctions, payment
# ---------------------------------------------------------------------------

test_impulse_increase_matches_2024_rates if {
	rows := data.o6_22.premium_rates.rows
	every r23 in [r | some r in rows; r.valid_to_year == 2023] {
		some r24 in rows
		r24.measure_category == r23.measure_category
		r24.component == r23.component
		r24.valid_from_year == 2024
		o6_22.impulse_rate(r23.eur_per_gve) == r24.eur_per_gve
	}
}

test_rate_lookup if {
	o6_22.rate("ferkel", "base", 2023) == 180
	o6_22.rate("ferkel", "base", 2026) == 194.4
	o6_22.rate("ferkel", "unkupiert", 2024) == 270
	o6_22.rate("zuchtsauen", "festmistkompostierung", 2025) == 21.6
	not o6_22.rate("zuchtsauen", "unkupiert", 2025)
	not o6_22.rate("ferkel", "festmistkompostierung", 2024)
}

test_tierliste_factor_equals_measure_category_factor if {
	every row in [r | some r in data.o6_22.animal_categories.tierliste; r.premium_eligible] {
		row.gve_per_head == o6_22.measure_categories[row.measure_category].gve_per_head
	}
}

test_fattening_lying_area_is_40_percent_of_total if {
	every row in data.o6_22.space_requirements.fattening {
		round((row.total_area_m2_per_animal * 0.4) * 100) == round(row.lying_area_m2_per_animal * 100)
	}
}

test_modulation_example_220_ha if {
	round(o6_22.modulation_factor(220) * 10000) == 9909
	o6_22.modulation_factor(150) == 1

	# (200 x 1.0 + 100 x 0.9 + 700 x 0.85 + 500 x 0.75) / 1500 = 0.84
	round(o6_22.modulation_factor(1500) * 10000) == 8400
}

test_modulation_applied_to_premium if {
	inp := patched([{"op": "replace", "path": "/land/total_area_ha", "value": 220}])
	o6_22.net_premium == round(((12301.2 * 218) / 220) * 100) / 100 with input as inp
}

test_sanction_stages if {
	o6_22.sanction_reduction_percent("verwarnung", 2026) == 0
	o6_22.sanction_reduction_percent("verwarnung", 2027) == 1
	o6_22.sanction_reduction_percent("kuerzung_25", 2025) == 25
	o6_22.exclusion_triggered(2)
	not o6_22.exclusion_triggered(1)
}

test_payment_rules if {
	o6_22.payout_may_be_waived(50)
	not o6_22.payout_may_be_waived(50.01)
	o6_22.max_advance_payment(1000) == 750
	o6_22.payout_deadline(2025) == "2026-06-30"
}

# ---------------------------------------------------------------------------
# General participation conditions
# ---------------------------------------------------------------------------

test_public_body_excluded_for_o6_22 if {
	inp := patched([{"op": "replace", "path": "/farm/applicant/public_body_share_percent", "value": 30}])
	"public_body_share_above_25_percent" in o6_22.applicant_issues with input as inp
	not o6_22.measure_valid with input as inp
	o6_22.public_body_allowed("o6_20", 2025)
	o6_22.public_body_allowed("o6_10", 2024)
	not o6_22.public_body_allowed("o6_10", 2025)
	not o6_22.public_body_allowed("o6_22", 2025)
}

test_inactive_farmer_excluded if {
	inp := patched([{"op": "replace", "path": "/farm/applicant/is_active_farmer", "value": false}])
	"O622-GEN-APPL-01" in rule_ids(o6_22.violations) with input as inp
	o6_22.gross_premium == 0 with input as inp
}

test_min_farm_size_first_year if {
	inp := patched([
		{"op": "replace", "path": "/farm/oepul/first_participation_year", "value": 2025},
		{"op": "replace", "path": "/land/total_area_ha", "value": 1.2},
	])
	"O622-GEN-MINSIZE-01" in rule_ids(o6_22.violations) with input as inp
	inp_second := json.patch(inp, [{"op": "replace", "path": "/farm/oepul/first_participation_year", "value": 2024}])
	not "O622-GEN-MINSIZE-01" in rule_ids(o6_22.violations) with input as inp_second
	inp_ga := json.patch(inp, [{"op": "replace", "path": "/land/protected_cultivation_area_ha", "value": 0.5}])
	not "O622-GEN-MINSIZE-01" in rule_ids(o6_22.violations) with input as inp_ga
}

test_control_refusal_rejects_application if {
	inp := patched([{"op": "replace", "path": "/farm/oepul/control_refused", "value": true}])
	o6_22.gross_premium == 0 with input as inp
	"O622-GEN-CONTROL-01" in rule_ids(o6_22.violations) with input as inp
}

test_takeover_only_in_single_cases if {
	inp := patched([{"op": "replace", "path": "/oepul_application/o6_22/takeover", "value": {"is_takeover": true, "reason": "other", "animals_and_areas_from_same_previous_farm": true}}])
	"O622-GEN-TAKEOVER-01" in rule_ids(o6_22.violations) with input as inp
	inp_ok := json.patch(inp, [{"op": "replace", "path": "/oepul_application/o6_22/takeover/reason", "value": "division"}])
	not "O622-GEN-TAKEOVER-01" in rule_ids(o6_22.violations) with input as inp_ok
}

test_combinations if {
	o6_22.combination_allowed("o6_22", "o6_20")
	o6_22.combination_allowed("o6_22", "o6_1b")
	not o6_22.combination_allowed("o6_6", "o6_7")
	not o6_22.combination_allowed("o6_1b", "o6_1a")
}

test_measure_switch_not_available_for_o6_22 if {
	o6_22.switch_allowed("Naturschutz", "Ergebnisorientierte Bewirtschaftung")
	not o6_22.switch_allowed("Tierwohl – Schweinehaltung", "Biologische Wirtschaftsweise")
}

test_missing_inputs_reported if {
	inp := patched([{"op": "remove", "path": "/livestock/species_groups/0/housing/stall/stall_area_m2"}])
	"livestock.species_groups[0].housing.stall.stall_area_m2" in o6_22.missing_inputs with input as inp
}

# ---------------------------------------------------------------------------
# Sow group-housing window (1. THVO)
# ---------------------------------------------------------------------------

test_sow_group_housing_window_new_stalls if {
	o6_22.sow_group_housing_required(10, 5, "neu_oder_umbau_seit_2013")
	not o6_22.sow_group_housing_required(9, 20, "neu_oder_umbau_seit_2013")
	not o6_22.sow_group_housing_required(40, 4, "neu_oder_umbau_seit_2013")
}

test_sow_group_housing_window_transitional if {
	not o6_22.sow_group_housing_required(20, 10, "uebergang_bestand_bis_2033")
	o6_22.sow_group_housing_required(28, 7, "uebergang_bestand_bis_2033")
}

test_sow_transitional_regime_only_if_construction_needed if {
	o6_22.applicable_sow_regime(true, false, 2026) == "uebergang_bestand_bis_2033"
	o6_22.applicable_sow_regime(true, true, 2026) == "neu_oder_umbau_seit_2013"
	o6_22.applicable_sow_regime(true, false, 2034) == "neu_oder_umbau_seit_2013"
	o6_22.applicable_sow_regime(false, false, 2026) == "neu_oder_umbau_seit_2013"
}

test_unmated_gilts_count_as_fattening_pigs if {
	o6_22.category_of({"tierliste_category": "jungsauen_nicht_gedeckt_ab_50"}) == "jung_mastschweine"
	o6_22.category_of({"tierliste_category": "jungsauen_gedeckt_ab_50"}) == "zuchtsauen"
}
