package o6_7.catch_crop_test

import data.o6_7
import data.o6_7.catch_crop
import data.o6_7.fixtures

inp_with(seg) := fixtures.farm(2025, [fixtures.parcel("X", 10, [fixtures.wheat, seg])])

inp_with_year(seg, year, first_contract_year) := object.union(
	fixtures.farm(year, [fixtures.parcel("X", 10, [fixtures.wheat, seg])]),
	{"farm": {"oepul": {"o6_7": {"first_contract_year": first_contract_year}}}},
)

zf(overrides) := object.union(fixtures.good_catch_crop, overrides)

reasons(inp) := r if {
	r := catch_crop.invalid_reasons["X/zf"] with input as inp
}

rule_ids(inp) := ids if {
	vs := catch_crop.violations with input as inp
	ids := {v.rule_id | some v in vs}
}

codes(inp) := cs if {
	vs := catch_crop.violations with input as inp
	cs := {v.code | some v in vs}
}

test_good_catch_crop_is_valid if {
	catch_crop.valid["X/zf"] with input as inp_with(fixtures.good_catch_crop)
	count(catch_crop.violations) == 0 with input as inp_with(fixtures.good_catch_crop)
}

test_sown_after_october_15_is_invalid if {
	s := zf({"start_date": "2025-10-16", "mixture": {"frost_killed_share": 0}})
	"sown_after_october_15" in reasons(inp_with(s))
}

test_sown_on_october_15_winter_hardy_is_valid if {
	s := zf({"start_date": "2025-10-15", "mixture": {"frost_killed_share": 0, "partner_count": 1}})
	catch_crop.valid["X/zf"] with input as inp_with(s)
}

test_early_sowing_requires_three_partners if {
	s := zf({"mixture": {"partner_count": 2}})
	"mixture_partners_insufficient" in reasons(inp_with(s))
}

test_early_sowing_requires_two_families if {
	s := zf({"mixture": {"plant_family_count": 1}})
	"mixture_partners_insufficient" in reasons(inp_with(s))
}

test_late_sowing_2025_mostly_winter_hardy_is_valid_pure_seed if {
	s := zf({"start_date": "2025-09-25", "mixture": {"partner_count": 1, "plant_family_count": 1, "frost_killed_share": 0.4}})
	catch_crop.valid["X/zf"] with input as inp_with(s)
}

test_late_sowing_2025_half_frost_killing_is_invalid if {
	s := zf({"start_date": "2025-09-25", "mixture": {"frost_killed_share": 0.5}})
	"not_winter_hardy_after_september_20" in reasons(inp_with(s))
}

test_late_sowing_2024_must_be_exclusively_winter_hardy if {
	s := {
		"segment_id": "zf",
		"kind": "catch_crop",
		"start_date": "2024-09-25",
		"end_date": "2025-02-20",
		"removal_method": "tillage_implement",
		"mixture": {"partner_count": 3, "plant_family_count": 2, "frost_killed_share": 0.1},
	}
	inp := inp_with_year(s, 2024, 2024)
	"not_winter_hardy_after_september_20" in reasons(inp)
}

test_late_sowing_break_before_february_15_is_invalid if {
	s := zf({"start_date": "2025-09-25", "end_date": "2026-02-14", "mixture": {"frost_killed_share": 0}})
	"broken_before_february_15" in reasons(inp_with(s))
}

test_late_sowing_break_on_february_15_is_valid if {
	s := zf({"start_date": "2025-09-25", "end_date": "2026-02-15", "mixture": {"frost_killed_share": 0}})
	catch_crop.valid["X/zf"] with input as inp_with(s)
}

test_minimum_duration_42_days if {
	s41 := zf({"start_date": "2025-07-25", "end_date": "2025-09-04"})
	"minimum_duration_42_days_not_met" in reasons(inp_with(s41))
	s42 := zf({"start_date": "2025-07-25", "end_date": "2025-09-05"})
	catch_crop.valid["X/zf"] with input as inp_with(s42)
}

test_cereal_share_over_50_percent_is_invalid if {
	s := zf({"mixture": {"cereal_maize_share": 0.6}})
	"cereal_maize_share_over_50_percent" in reasons(inp_with(s))
}

test_green_rye_varieties_exempt_from_cereal_limit if {
	s := zf({"mixture": {"cereal_maize_share": 1, "green_rye_varieties_only": true}})
	catch_crop.valid["X/zf"] with input as inp_with(s)
}

test_drought_2026_volunteer_cereal_over_50_percent_tolerated if {
	s := {
		"segment_id": "zf",
		"kind": "catch_crop",
		"start_date": "2026-08-01",
		"end_date": "2027-02-20",
		"removal_method": "tillage_implement",
		"proper_sowing": true,
		"full_coverage_achieved": false,
		"mixture": {"partner_count": 3, "plant_family_count": 2, "frost_killed_share": 0.3, "cereal_maize_share": 0.7, "cereal_excess_from_volunteer": true},
	}
	inp := fixtures.farm(2026, [fixtures.parcel("X", 10, [{"segment_id": "ww", "kind": "main_crop", "start_date": "2025-10-10", "end_date": "2026-07-15"}, s])])
	catch_crop.valid["X/zf"] with input as inp
}

test_insufficient_coverage_without_drought_relief_is_invalid if {
	s := zf({"full_coverage_achieved": false})
	"no_full_coverage" in reasons(inp_with(s))
}

test_volunteer_only_is_invalid if {
	s := zf({"mixture": {"is_volunteer_only": true}})
	"volunteer_only" in reasons(inp_with(s))
}

test_undersown_frost_killing_mix_after_early_october_harvest_invalid if {
	s := {
		"segment_id": "zf",
		"kind": "catch_crop",
		"is_undersown": true,
		"start_date": "2025-06-01",
		"undersown_host_harvest_date": "2025-10-05",
		"end_date": "2026-03-01",
		"removal_method": "tillage_implement",
		"mixture": {"partner_count": 3, "plant_family_count": 2, "frost_killed_share": 1},
	}
	inp := fixtures.farm(2025, [fixtures.parcel("X", 10, [{"segment_id": "k", "kind": "main_crop", "start_date": "2025-04-01", "end_date": "2025-10-05"}, s])])
	"not_winter_hardy_after_september_20" in reasons(inp)
}

test_declared_catch_crop_is_reclassified_as_main_crop if {
	s := zf({"declared_in_mfa": true})
	inp := inp_with(s)
	"X/zf" in o6_7.decision.catch_crops_reclassified_as_main_crop with input as inp
	not catch_crop.catch_crop_segments["X/zf"] with input as inp
}

test_threshed_catch_crop_is_invalid_and_violation if {
	s := zf({"threshed": true})
	"threshed" in reasons(inp_with(s))
	"O67-CC-NO-THRESHING" in rule_ids(inp_with(s))
}

test_first_entry_pre_contract_sowing_date_not_relevant if {
	s := {
		"segment_id": "zf",
		"kind": "catch_crop",
		"start_date": "2024-10-25",
		"end_date": "2025-03-01",
		"removal_method": "tillage_implement",
		"mixture": {"partner_count": 3, "plant_family_count": 2, "frost_killed_share": 0},
	}
	inp := inp_with_year(s, 2025, 2025)
	catch_crop.valid["X/zf"] with input as inp
}

test_first_entry_pre_contract_mixture_must_comply if {
	s := {
		"segment_id": "zf",
		"kind": "catch_crop",
		"start_date": "2024-10-25",
		"end_date": "2025-03-01",
		"removal_method": "tillage_implement",
		"mixture": {"partner_count": 1, "plant_family_count": 1, "frost_killed_share": 0.8},
	}
	inp := inp_with_year(s, 2025, 2025)
	"pre_contract_mixture_not_compliant" in reasons(inp)
}

test_mineral_n_during_ban_is_violation if {
	s := zf({"mineral_n_dates": ["2025-09-01"], "nitrate_ban_end_date": "2026-02-15"})
	"O67-CC-MINERAL-N-BAN" in rule_ids(inp_with(s))
}

test_mineral_n_after_ban_end_is_allowed if {
	s := zf({"mineral_n_dates": ["2026-02-18"], "nitrate_ban_end_date": "2026-02-15"})
	not "O67-CC-MINERAL-N-BAN" in rule_ids(inp_with(s))
}

test_combined_fertilisation_at_sowing_is_violation if {
	s := zf({"combined_n_fertilisation_at_sowing": true})
	"O67-CC-COMBINED-FERTILISATION" in rule_ids(inp_with(s))
}

test_psm_during_greening_is_violation if {
	s := zf({"psm_dates": ["2025-09-15"]})
	"O67-CC-PSM-BAN" in rule_ids(inp_with(s))
}

test_psm_after_mechanical_removal_is_allowed if {
	s := zf({"psm_dates": ["2026-03-01"]})
	not "O67-CC-PSM-BAN" in rule_ids(inp_with(s))
}

test_psm_before_following_sowing_without_mechanical_removal if {
	s := zf({"removal_method": "harrowing", "psm_dates": ["2026-02-25"], "following_main_crop_sowing_date": "2026-03-10"})
	"O67-CC-PSM-AFTER-NON-MECHANICAL" in rule_ids(inp_with(s))
	"no_mechanical_removal" in codes(inp_with(s))
}

test_frost_collapse_requires_only_frost_killing_components if {
	s := zf({"removal_method": "frost_killed_and_collapsed", "fully_frost_killed": true})
	"removal_requires_only_frost_killing_components" in codes(inp_with(s))
}

test_ground_near_chopping_after_frost_requires_full_frost_kill if {
	s := zf({"removal_method": "ground_near_chopping_after_frost"})
	"removal_requires_complete_frost_kill" in codes(inp_with(s))
}

test_tillage_during_greening_is_violation if {
	s := zf({"operations": [{"type": "tillage", "date": "2025-10-01"}]})
	"O67-CC-TILLAGE-BAN" in rule_ids(inp_with(s))
}

test_knife_roller_during_greening_is_violation if {
	s := zf({"operations": [{"type": "knife_roller", "date": "2025-11-10"}]})
	"O67-CC-TILLAGE-BAN" in rule_ids(inp_with(s))
}

test_permitted_operations_are_no_violation if {
	s := zf({"operations": [
		{"type": "reconsolidation_rolling", "date": "2025-07-26", "cover_maintained": true},
		{"type": "deep_loosening", "date": "2025-09-10", "cover_maintained": true},
		{"type": "strip_till_preparation", "date": "2025-09-12", "cover_maintained": true, "whole_area": false},
		{"type": "harrowing_in_seed", "date": "2025-09-15"},
		{"type": "grazing", "date": "2025-10-10", "cover_maintained": true, "regrowth_expected": true},
		{"type": "chopping", "date": "2025-11-05", "cover_maintained": true, "regrowth_expected": true},
	]})
	count(catch_crop.violations) == 0 with input as inp_with(s)
}

test_chopping_overwintering_before_november_is_violation if {
	s := zf({"operations": [{"type": "chopping", "date": "2025-10-31", "cover_maintained": true, "regrowth_expected": true}]})
	"O67-CC-CARE-BEFORE-NOV" in rule_ids(inp_with(s))
}

test_rolling_overwintering_before_november_is_violation if {
	s := zf({"operations": [{"type": "rolling", "date": "2025-10-20", "cover_maintained": true}]})
	"O67-CC-CARE-BEFORE-NOV" in rule_ids(inp_with(s))
}

test_problem_weed_early_chopping_with_evidence_allowed if {
	s := zf({"operations": [{
		"type": "chopping", "date": "2025-09-20", "ground_near": false,
		"problem_weed": "Ragweed", "evidence_kept": true,
		"cover_maintained": true, "regrowth_expected": true,
	}]})
	count(catch_crop.violations) == 0 with input as inp_with(s)
}

test_problem_weed_early_chopping_without_evidence_is_violation if {
	s := zf({"operations": [{
		"type": "chopping", "date": "2025-09-20", "ground_near": false,
		"problem_weed": "Stechapfel", "evidence_kept": false,
		"cover_maintained": true, "regrowth_expected": true,
	}]})
	"O67-CC-PROBLEM-WEED-EVIDENCE" in rule_ids(inp_with(s))
}

test_ground_near_chopping_before_frost_kill_is_violation if {
	s := zf({"operations": [{"type": "chopping", "date": "2025-11-20", "ground_near": true, "fully_frost_killed": false}]})
	"O67-CC-GROUND-NEAR-CHOPPING" in rule_ids(inp_with(s))
}

test_use_without_regrowth_is_violation if {
	s := zf({"operations": [{"type": "mowing_with_removal", "date": "2025-10-01", "cover_maintained": true, "regrowth_expected": false}]})
	"O67-CC-CARE-CONDITIONS" in rule_ids(inp_with(s))
}

test_strip_till_full_area_is_violation if {
	s := zf({"operations": [{"type": "strip_till_preparation", "date": "2025-09-12", "whole_area": true}]})
	"strip_till_preparation_full_area" in codes(inp_with(s))
}

test_seed_proof_required_when_partners_not_visible if {
	s := zf({"mixture": {"partners_visible_in_field": false, "seed_proof_available": false}})
	"O67-CC-SEED-PROOF" in rule_ids(inp_with(s))
	ok := zf({"mixture": {"partners_visible_in_field": false, "seed_proof_available": true}})
	not "O67-CC-SEED-PROOF" in rule_ids(inp_with(ok))
}
