# Tests der schlagbezogenen Förderbedingungen von o6_6.
package oepul.o6_6_test

import data.oepul.o6_6

test_compliant_base_has_no_violations if {
	count(o6_6.parcel_violations) == 0 with input as base_input
	count(o6_6.farm_violations) == 0 with input as base_input
	o6_6.decision.farm_premium_eligible with input as base_input
}

test_variant_not_offered_in_year if {
	"O6_6-VARIANT-VALID" in violation_ids(with_parcel(set_cc(v2_parcel, "variant", 8)))
}

test_non_arable_parcel_ineligible if {
	p := json.patch(v2_parcel, [{"op": "replace", "path": "/land_use", "value": "grassland"}])
	"O6_6-ARABLE-ONLY" in violation_ids(with_parcel(p))
}

test_npf_2024_not_fundable if {
	inp := json.patch(with_parcel(set_cc(v2_parcel, "is_npf_gloez8", true)), [{"op": "replace", "path": "/farm/year", "value": 2024}])
	"O6_6-NPF-2024" in violation_ids(inp)
}

test_npf_flag_irrelevant_in_2026 if {
	not "O6_6-NPF-2024" in violation_ids(with_parcel(set_cc(v2_parcel, "is_npf_gloez8", true)))
}

test_v2_sowing_after_deadline if {
	"O6_6-SOWING-DEADLINE" in violation_ids(with_parcel(set_cc(v2_parcel, "sowing_date", "2026-08-06")))
}

test_v2_sowing_on_deadline_ok if {
	not "O6_6-SOWING-DEADLINE" in violation_ids(with_parcel(set_cc(v2_parcel, "sowing_date", "2026-08-05")))
}

test_v1_2025_deadline_10_august if {
	not "O6_6-SOWING-DEADLINE" in violation_ids(with_parcel(set_cc(set_cc(v1_parcel, "sowing_date", "2026-08-10"), "termination_date", "2026-10-19")))
	"O6_6-SOWING-DEADLINE" in violation_ids(with_parcel(set_cc(v1_parcel, "sowing_date", "2026-08-11")))
}

test_v1_2024_deadline_31_july if {
	p := set_cc(set_cc(v1_parcel, "sowing_date", "2024-08-01"), "termination_date", "2024-10-10")
	inp := json.patch(with_parcel(p), [{"op": "replace", "path": "/farm/year", "value": 2024}])
	"O6_6-SOWING-DEADLINE" in violation_ids(inp)
}

test_undersowing_uses_harvest_date if {
	p := set_cc(set_cc(set_cc(v2_parcel, "establishment", "undersowing"), "sowing_date", "2026-04-01"), "preceding_main_crop_harvest_date", "2026-08-10")
	"O6_6-SOWING-DEADLINE" in violation_ids(with_parcel(p))
}

test_no_active_establishment if {
	p := json.remove(v2_parcel, ["/operations/cover_crop/sowing_date"])
	"O6_6-DEF-ACTIVE-ESTABLISHMENT" in violation_ids(with_parcel(p))
}

test_volunteer_not_cover_crop if {
	"O6_6-INADMISSIBLE-VOLUNTEER-SELF-GREENING" in violation_ids(with_parcel(set_cc(v2_parcel, "only_volunteer_or_self_seeded", true)))
}

test_cereal_share_above_50 if {
	"O6_6-INADMISSIBLE-CEREAL-MAIZE" in violation_ids(with_parcel(set_cc(v2_parcel, "cereal_maize_share_percent", 51)))
}

test_cereal_share_50_ok if {
	not "O6_6-INADMISSIBLE-CEREAL-MAIZE" in violation_ids(with_parcel(set_cc(v2_parcel, "cereal_maize_share_percent", 50)))
}

test_pure_cereal_maize_stand if {
	"O6_6-INADMISSIBLE-CEREAL-MAIZE" in violation_ids(with_parcel(set_cc(v2_parcel, "species", ["Hafer", "Silomais"])))
}

test_drought_2026_volunteer_cereal_excused if {
	p := set_cc(set_cc(v2_parcel, "cereal_maize_share_percent", 70), "cereal_share_from_volunteer", true)
	not "O6_6-INADMISSIBLE-CEREAL-MAIZE" in violation_ids(with_parcel(p))
}

test_drought_cereal_not_excused_2025 if {
	p := set_cc(set_cc(v2_parcel, "cereal_maize_share_percent", 70), "cereal_share_from_volunteer", true)
	inp := json.patch(with_parcel(p), [{"op": "replace", "path": "/farm/year", "value": 2025}])
	"O6_6-INADMISSIBLE-CEREAL-MAIZE" in violation_ids(inp)
}

test_full_coverage_missing_2025 if {
	inp := json.patch(with_parcel(set_cc(v2_parcel, "full_coverage_achieved", false)), [{"op": "replace", "path": "/farm/year", "value": 2025}])
	"O6_6-FULL-COVERAGE" in violation_ids(inp)
}

test_full_coverage_drought_2026_excused if {
	not "O6_6-FULL-COVERAGE" in violation_ids(with_parcel(set_cc(v2_parcel, "full_coverage_achieved", false)))
}

test_full_coverage_2026_not_excused_without_proper_establishment if {
	p := set_cc(set_cc(v2_parcel, "full_coverage_achieved", false), "properly_established", false)
	"O6_6-FULL-COVERAGE" in violation_ids(with_parcel(p))
}

test_seed_proof_required if {
	"O6_6-SEED-PROOF" in violation_ids(with_parcel(set_cc(v2_parcel, "partners_visible_in_field", false)))
	not "O6_6-SEED-PROOF" in violation_ids(with_parcel(set_cc(set_cc(v2_parcel, "partners_visible_in_field", false), "seed_proof_available", true)))
}

test_v2_needs_7_partners_3_families if {
	ids := violation_ids(with_parcel(set_cc(set_cc(v2_parcel, "mixture_partner_count", 6), "plant_family_count", 2)))
	"O6_6-MIXING-PARTNERS" in ids
	"O6_6-PLANT-FAMILIES" in ids
}

test_v4_needs_3_partners if {
	p := set_cc(set_cc(set_cc(v2_parcel, "variant", 4), "mixture_partner_count", 2), "sowing_date", "2026-08-30")
	"O6_6-MIXING-PARTNERS" in violation_ids(with_parcel(p))
	not "O6_6-MIXING-PARTNERS" in violation_ids(with_parcel(set_cc(p, "mixture_partner_count", 3)))
}

test_v1_insect_pollinated_from_species_list if {
	p := set_cc(v1_parcel, "species", ["Phazelia", "Buchweizen", "Sonnenblume", "Kresse", "Weidelgras"])
	"O6_6-V1-INSECT-POLLINATED" in violation_ids(with_parcel(p))
}

test_v1_insect_pollinated_count_input_overrides if {
	p := set_cc(set_cc(v1_parcel, "species", ["Weidelgras"]), "insect_pollinated_partner_count", 5)
	not "O6_6-V1-INSECT-POLLINATED" in violation_ids(with_parcel(p))
}

test_v1_non_insect_share_limit if {
	"O6_6-V1-NON-INSECT-SHARE" in violation_ids(with_parcel(set_cc(v1_parcel, "non_insect_pollinated_share_percent", 10)))
	not "O6_6-V1-NON-INSECT-SHARE" in violation_ids(with_parcel(set_cc(v1_parcel, "non_insect_pollinated_share_percent", 9.9)))
}

test_v6_disallowed_species if {
	"O6_6-V6-SPECIES" in violation_ids(with_parcel(set_cc(v6_parcel, "species", ["Grünschnittroggen", "Senf"])))
}

test_v6_unknown_green_rye_variety if {
	"O6_6-V6-GREEN-RYE-VARIETIES" in violation_ids(with_parcel(set_cc(v6_parcel, "green_rye_varieties", ["Unbekannt"])))
	not "O6_6-V6-GREEN-RYE-VARIETIES" in violation_ids(with_parcel(set_cc(v6_parcel, "green_rye_varieties", ["V Kruppa József"])))
}

test_v6_farm_saved_seed_needs_proof if {
	"O6_6-V6-FARM-SAVED-SEED" in violation_ids(with_parcel(set_cc(v6_parcel, "farm_saved_seed_used", true)))
	not "O6_6-V6-FARM-SAVED-SEED" in violation_ids(with_parcel(set_cc(set_cc(v6_parcel, "farm_saved_seed_used", true), "farm_saved_seed_proof", true)))
}

test_v6_green_rye_not_cereal_violation if {
	not "O6_6-INADMISSIBLE-CEREAL-MAIZE" in violation_ids(with_parcel(set_cc(v6_parcel, "species", ["Grünschnittroggen"])))
}

test_v7_only_winter_rape if {
	p := json.patch(v7_parcel, [{"op": "replace", "path": "/crop/crop_name", "value": "Winterweizen"}])
	"O6_6-V7-WINTER-RAPE" in violation_ids(with_parcel(p))
}

test_declared_as_main_crop_next_mfa if {
	"O6_6-NOT-MAIN-CROP-NEXT-MFA" in violation_ids(with_parcel(set_cc(v2_parcel, "declared_as_main_crop_next_mfa", true)))
}

test_no_following_main_crop if {
	p := json.patch(v2_parcel, [{"op": "replace", "path": "/operations/cover_crop/following_main_crop/actively_established", "value": false}])
	"O6_6-DEF-FOLLOWING-MAIN-CROP" in violation_ids(with_parcel(p))
}

test_threshing_not_cover_crop if {
	p := set_cc(v2_parcel, "events", [{"type": "threshing", "date": "2026-10-20"}])
	"O6_6-NO-THRESHING" in violation_ids(with_parcel(p))
}

test_mineral_n_in_period if {
	p := set_cc(v2_parcel, "events", [{"type": "mineral_n_fertilization", "date": "2026-08-01"}])
	"O6_6-NO-MINERAL-N" in violation_ids(with_parcel(p))
}

test_mineral_n_after_period_ok if {
	p := set_cc(v2_parcel, "events", [{"type": "mineral_n_fertilization", "date": "2027-02-15"}])
	not "O6_6-NO-MINERAL-N" in violation_ids(with_parcel(p))
}

test_v7_mineral_n_banned if {
	p := set_cc(v7_parcel, "events", [{"type": "mineral_n_fertilization", "date": "2026-10-01"}])
	"O6_6-NO-MINERAL-N" in violation_ids(with_parcel(p))
}

test_psm_in_period if {
	p := set_cc(v2_parcel, "events", [{"type": "psm_application", "date": "2026-09-01"}])
	"O6_6-NO-PSM" in violation_ids(with_parcel(p))
}

test_v7_other_psm_allowed if {
	not "O6_6-NO-PSM" in violation_ids(with_parcel(v7_parcel))
}

test_v7_herbicide_after_four_leaf if {
	p := set_cc(v7_parcel, "events", [{"type": "herbicide_application", "date": "2026-09-25"}])
	"O6_6-V7-HERBICIDE" in violation_ids(with_parcel(p))
}

test_v7_herbicide_before_four_leaf_impairing if {
	p := set_cc(v7_parcel, "events", [{"type": "herbicide_application", "date": "2026-09-05", "impairs_companion_crop": true}])
	"O6_6-V7-HERBICIDE" in violation_ids(with_parcel(p))
}

test_v7_missing_four_leaf_date_reported if {
	p := json.remove(v7_parcel, ["/operations/cover_crop/rape_four_leaf_stage_date"])
	some m in o6_6.missing_inputs with input as with_parcel(p)
	m.rule_id == "O6_6-V7-HERBICIDE"
}

test_psm_after_period_without_mechanical_removal if {
	p := set_cc(set_cc(v2_parcel, "termination_date", "2027-04-01"), "events", [{"type": "herbicide_application", "date": "2027-03-01"}])
	"O6_6-PSM-AFTER-NONMECH" in violation_ids(with_parcel(p))
}

test_psm_after_mechanical_removal_ok if {
	p := set_cc(v2_parcel, "events", [{"type": "herbicide_application", "date": "2027-03-01"}])
	not "O6_6-PSM-AFTER-NONMECH" in violation_ids(with_parcel(p))
}

test_tillage_in_period if {
	p := set_cc(v2_parcel, "events", [{"type": "knife_roller", "date": "2026-12-01"}])
	"O6_6-NO-TILLAGE" in violation_ids(with_parcel(p))
}

test_deep_loosening_needs_cover_preserved if {
	p := set_cc(v2_parcel, "events", [{"type": "deep_loosening", "date": "2026-09-01", "cover_preserved": false}])
	"O6_6-DEEP-LOOSENING-STRIP-TILL" in violation_ids(with_parcel(p))
	q := set_cc(v2_parcel, "events", [{"type": "strip_till_preparation", "date": "2026-09-01", "cover_preserved": true, "full_surface": false}])
	not "O6_6-DEEP-LOOSENING-STRIP-TILL" in violation_ids(with_parcel(q))
}

test_additional_sowing_drill_only if {
	p := set_cc(v2_parcel, "events", [{"type": "additional_sowing_winter_hardy", "date": "2026-09-01", "only_drill_coulters": false}])
	"O6_6-ADDITIONAL-SOWING" in violation_ids(with_parcel(p))
}

test_care_mowing_before_1_november_v2 if {
	p := set_cc(v2_parcel, "events", [{"type": "care_mowing", "date": "2026-10-31", "coverage_maintained": true, "regrowth_expected": true}])
	"O6_6-CARE-DATES" in violation_ids(with_parcel(p))
}

test_care_chopping_v1_from_15_september if {
	p := set_cc(set_cc(v1_parcel, "termination_date", "2026-10-01"), "events", [{"type": "care_chopping", "date": "2026-09-15", "coverage_maintained": true, "regrowth_expected": true}])
	not "O6_6-CARE-DATES" in violation_ids(with_parcel(p))
	q := set_cc(set_cc(v1_parcel, "termination_date", "2026-10-01"), "events", [{"type": "care_chopping", "date": "2026-09-14", "coverage_maintained": true, "regrowth_expected": true}])
	"O6_6-CARE-DATES" in violation_ids(with_parcel(q))
}

test_problem_weed_early_chopping_allowed if {
	base := set_cc(set_cc(v2_parcel, "problem_weeds", ["Ragweed"]), "problem_weed_evidence_kept", true)
	p := set_cc(base, "events", [{"type": "care_chopping", "date": "2026-09-01", "ground_level": false, "coverage_maintained": true, "regrowth_expected": true}])
	not "O6_6-CARE-DATES" in violation_ids(with_parcel(p))
	q := set_cc(base, "events", [{"type": "care_chopping", "date": "2026-09-01", "ground_level": true, "coverage_maintained": true, "regrowth_expected": true}])
	"O6_6-CARE-DATES" in violation_ids(with_parcel(q))
}

test_care_without_coverage if {
	p := set_cc(v2_parcel, "events", [{"type": "care_chopping", "date": "2026-11-10", "coverage_maintained": false}])
	"O6_6-CARE-CONDITIONS" in violation_ids(with_parcel(p))
}

test_ground_level_chopping_requires_frost if {
	p := set_cc(v2_parcel, "events", [{"type": "ground_level_chopping", "date": "2026-12-10"}])
	"O6_6-GROUND-CHOPPING-FROST" in violation_ids(with_parcel(p))
	q := set_cc(v2_parcel, "events", [{"type": "ground_level_chopping", "date": "2026-12-10", "plants_fully_frost_killed": true}])
	not "O6_6-GROUND-CHOPPING-FROST" in violation_ids(with_parcel(q))
}

test_rolling_rules if {
	p := set_cc(v2_parcel, "events", [{"type": "rolling", "date": "2026-09-20"}])
	"O6_6-ROLLING" in violation_ids(with_parcel(p))
	q := set_cc(v2_parcel, "events", [{"type": "rolling", "date": "2026-09-20", "on_frozen_ground": true, "coverage_maintained": true}])
	not "O6_6-ROLLING" in violation_ids(with_parcel(q))
	r := set_cc(v2_parcel, "events", [{"type": "rolling", "date": "2026-11-02"}])
	not "O6_6-ROLLING" in violation_ids(with_parcel(r))
}

test_use_requires_regrowth if {
	p := set_cc(v2_parcel, "events", [{"type": "grazing", "date": "2026-10-01", "coverage_maintained": true, "regrowth_expected": false}])
	"O6_6-USE" in violation_ids(with_parcel(p))
	q := set_cc(v2_parcel, "events", [{"type": "use_mowing_removal", "date": "2026-10-01", "coverage_maintained": true, "regrowth_expected": true}])
	not "O6_6-USE" in violation_ids(with_parcel(q))
}

test_v1_driving_ban if {
	p := set_cc(v1_parcel, "events", [{"type": "driving", "date": "2026-09-14"}])
	"O6_6-V1-DRIVING-BAN" in violation_ids(with_parcel(p))
	q := set_cc(v1_parcel, "events", [{"type": "driving", "date": "2026-09-15"}])
	not "O6_6-V1-DRIVING-BAN" in violation_ids(with_parcel(q))
}

test_v1_follow_up_crop_required if {
	p := json.patch(v1_parcel, [{"op": "replace", "path": "/operations/cover_crop/following_main_crop/sowing_date", "value": "2027-03-10"}])
	"O6_6-V1-FOLLOW-UP-CROP" in violation_ids(with_parcel(p))
}

test_v1_70_days_rule if {
	# Anlage 10.08. -> frühester Umbruch 19.10.
	p := set_cc(set_cc(v1_parcel, "sowing_date", "2026-08-10"), "termination_date", "2026-10-18")
	"O6_6-PERIOD-END" in violation_ids(with_parcel(p))
	q := set_cc(set_cc(v1_parcel, "sowing_date", "2026-08-10"), "termination_date", "2026-10-19")
	not "O6_6-PERIOD-END" in violation_ids(with_parcel(q))
}

test_v1_not_before_15_september if {
	p := set_cc(set_cc(v1_parcel, "sowing_date", "2026-06-20"), "termination_date", "2026-09-14")
	"O6_6-PERIOD-END" in violation_ids(with_parcel(p))
}

test_v1_2024_fixed_10_october if {
	p := set_cc(set_cc(v1_parcel, "sowing_date", "2024-07-20"), "termination_date", "2024-10-09")
	inp := json.patch(with_parcel(p), [{"op": "replace", "path": "/farm/year", "value": 2024}])
	"O6_6-PERIOD-END" in violation_ids(inp)
}

test_v2_early_termination if {
	"O6_6-PERIOD-END" in violation_ids(with_parcel(set_cc(v2_parcel, "termination_date", "2027-02-14")))
}

test_non_mechanical_removal if {
	"O6_6-MECH-REMOVAL" in violation_ids(with_parcel(set_cc(v2_parcel, "termination_method", "harrowing")))
	"O6_6-MECH-REMOVAL" in violation_ids(with_parcel(set_cc(v2_parcel, "termination_method", "herbicide")))
}

test_frost_killed_removal_only_for_frost_killed_mixtures if {
	"O6_6-MECH-REMOVAL" in violation_ids(with_parcel(set_cc(v2_parcel, "termination_method", "frost_killed_and_collapsed")))
	p := set_cc(set_cc(v2_parcel, "termination_method", "rolled_down"), "winter_hardiness", "frost_killed")
	not "O6_6-MECH-REMOVAL" in violation_ids(with_parcel(p))
}

test_frost_killed_removal_not_for_v6 if {
	p := set_cc(set_cc(v6_parcel, "termination_method", "frost_killed_and_collapsed"), "winter_hardiness", "frost_killed")
	"O6_6-MECH-REMOVAL" in violation_ids(with_parcel(p))
}

test_gw_ooe_no_variant_3 if {
	p := json.patch(set_cc(set_cc(v2_parcel, "variant", 3), "termination_date", "2026-11-20"), [{"op": "add", "path": "/constraints", "value": {"groundwater_protection_area_ooe": true}}])
	inp := json.patch(with_parcel(p), [{"op": "add", "path": "/farm/oepul/measures/-", "value": {"measure_code": "16", "applied_on": "2022-12-01", "contract_start_year": 2023}}])
	"O6_6-SRL-GW-OOE-NO-V3" in violation_ids(inp)
}

test_combination_conflict_with_measure_18 if {
	p := json.patch(v2_parcel, [{"op": "replace", "path": "/oepul_measures", "value": ["6", "18"]}])
	some c in o6_6.combination_conflicts with input as with_parcel(p)
	c.measure == "18"
}

test_combination_with_8_ok if {
	p := json.patch(v2_parcel, [{"op": "replace", "path": "/oepul_measures", "value": ["6", "8", "16"]}])
	count(o6_6.combination_conflicts) == 0 with input as with_parcel(p)
}
