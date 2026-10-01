package oepul.o6_8_test

import data.oepul.o6_8

# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

base_farm := {
	"farm_id": "F1",
	"year": 2025,
	"region": {"federal_state": "Niederösterreich", "district": "Tulln"},
	"oepul": {
		"participating_measures": ["1A", "6", "8"],
		"options": [],
		"first_participation_year": 2023,
		"applicant": {"legal_form": "natural_person", "public_body_share_percent": 0, "is_active_farmer": true},
		"o6_8": {"contract_start_year": 2023, "application_submitted_date": "2022-12-15"},
	},
}

ms_parcel := {
	"parcel_id": "MS1",
	"area_ha": 5,
	"land_use": "arable",
	"slope_percent": 12,
	"crop": {"crop_category": "maize", "crop_name": "Körnermais"},
	"operations": {"tillage_type": "mulch", "psm_used": true},
	"oepul_o6_8": {
		"codes": ["MS"],
		"main_crop_sowing_date": "2025-04-20",
		"preceding_catch_crop": {"scheme": "oepul2023_zwf", "variant": 4},
		"tillage": {"first_tillage_date": "2025-04-01", "inverting_or_deep_mixing": false, "plant_mulch_on_surface": true},
		"harvest": {"harvested_share_percent": 100},
	},
}

ds_parcel := {
	"parcel_id": "DS1",
	"area_ha": 2,
	"land_use": "arable",
	"crop": {"crop_category": "legume", "crop_name": "Sojabohnen"},
	"operations": {"tillage_type": "no_till"},
	"oepul_o6_8": {
		"codes": ["DS"],
		"preceding_catch_crop": {"scheme": "oepul2023_zwf", "variant": 5},
		"tillage": {"ds_method": "direct_seeding", "full_surface_tillage": false, "slot_seeding": true},
	},
}

ah_parcel := {
	"parcel_id": "AH1",
	"area_ha": 1,
	"land_use": "arable",
	"crop": {"crop_category": "root", "crop_name": "Speisekartoffeln"},
	"operations": {"tillage_type": "reduced"},
	"oepul_o6_8": {
		"codes": ["AH"],
		"potato_ridges": {
			"interval_max_m": 1.5,
			"in_furrows_except_tramlines": true,
			"created_by_planter_or_prompt_ridger": true,
			"distinct_effective_ridges": true,
			"maintained_until_haulm_reduction": true,
		},
	},
}

baw_parcel := {
	"parcel_id": "BAW1",
	"area_ha": 0.4,
	"land_use": "arable",
	"crop": {"crop_category": "fallow", "crop_name": "Grünbrache"},
	"operations": {"psm_used": false, "fertilizer": {"mineral_n_kg_per_ha": 0, "organic_n_kg_per_ha": 0}},
	"oepul_o6_8": {
		"codes": ["BAW"],
		"location": {"kg_nr": "20001"},
		"baw": {
			"erosion_path_area_ha": 0.1,
			"sowing_date": "2024-05-10",
			"winter_hardy_mixture": true,
			"legume_share_percent": 30,
			"establishment_year": 2024,
			"first_declared_year": 2024,
			"last_mowing_or_mulching_year": 2024,
		},
	},
}

us_parcel := {
	"parcel_id": "US1",
	"area_ha": 3,
	"land_use": "arable",
	"crop": {"crop_category": "oilseed", "crop_name": "Sonnenblume"},
	"operations": {"tillage_type": "reduced"},
	"oepul_o6_8": {
		"codes": ["US"],
		"main_crop_sowing_date": "2025-04-15",
		"undersowing": {
			"sowing_date": "2025-05-20",
			"mixture_partner_count": 3,
			"between_rows": true,
			"maintained_until_main_crop_harvest": true,
			"harvested_with_main_crop": false,
		},
	},
}

farm_input(ps) := {"farm": base_farm, "land": {"total_area_ha": 50, "parcels": ps}}

with_farm(inp, path, value) := json.patch(inp, [{"op": "add", "path": path, "value": value}])

patched(p, path, value) := json.patch(p, [{"op": "add", "path": path, "value": value}])

rule_ids(d) := {v.rule_id | some v in d.violations}

# ---------------------------------------------------------------------------
# Happy path and premium rates
# ---------------------------------------------------------------------------

test_all_procedures_compliant_and_premium if {
	d := o6_8.decision with input as farm_input([ms_parcel, ds_parcel, ah_parcel, baw_parcel, us_parcel])
	count(d.violations) == 0
	d.farm_access_ok
	d.parcel_results.MS1.premium_eur == 270
	d.parcel_results.DS1.premium_eur == 172.8
	d.parcel_results.AH1.premium_eur == 162
	d.parcel_results.BAW1.premium_eur == 237.6
	d.parcel_results.US1.premium_eur == 243
	d.premium_gross_eur == 1085.4
	d.modulation_factor == 1
}

test_rates_2023 if {
	o6_8.rate("MS", 2023) == 50.0
	o6_8.rate("DS", 2023) == 80.0
	o6_8.rate("AH", 2023) == 150.0
	o6_8.rate("BAW", 2023) == 550.0
	o6_8.rate("US", 2023) == 75.0
	o6_8.rate("US_BIO", 2023) == 15.0
}

test_rates_from_2024 if {
	o6_8.rate("MS", 2026) == 54.0
	o6_8.rate("DS", 2024) == 86.4
	o6_8.rate("AH", 2028) == 162.0
	o6_8.rate("BAW", 2024) == 594.0
	o6_8.rate("US", 2025) == 81.0
	o6_8.rate("US_BIO", 2025) == 16.2
}

test_us_bio_surcharge if {
	inp := with_farm(farm_input([us_parcel]), "/farm/oepul/participating_measures", ["1B", "8"])
	d := o6_8.decision with input as inp
	d.parcel_results.US1.us_bio_surcharge_eur == 48.6
	d.parcel_results.US1.premium_eur == 291.6
}

# ---------------------------------------------------------------------------
# Contract, application and access conditions
# ---------------------------------------------------------------------------

test_contract_durations if {
	o6_8.contract_duration_years(2023) == 6
	o6_8.contract_duration_years(2024) == 5
	o6_8.contract_duration_years(2025) == 4
}

test_contract_start_2026_not_allowed if {
	inp := with_farm(farm_input([ms_parcel]), "/farm/oepul/o6_8", {"contract_start_year": 2026, "application_submitted_date": "2025-12-01"})
	d := o6_8.decision with input as inp
	"o6_8.contract.duration" in rule_ids(d)
	"o6_8.application.last_entry_2025" in rule_ids(d)
	not d.farm_access_ok
	d.premium_gross_eur == 0
}

test_application_after_deadline if {
	inp := with_farm(farm_input([ms_parcel]), "/farm/oepul/o6_8", {"contract_start_year": 2024, "application_submitted_date": "2024-01-05"})
	d := o6_8.decision with input as inp
	"o6_8.application.deadline_31_dec" in rule_ids(d)
}

test_access_failure_consequence_first_year if {
	o6_8.access_failure_consequence == "no_contract" with input as with_farm(farm_input([]), "/farm/year", 2023)
	o6_8.access_failure_consequence == "no_premium_for_year" with input as farm_input([])
}

test_min_participation_not_met if {
	small := patched(us_parcel, "/area_ha", 0.05)
	d := o6_8.decision with input as farm_input([small])
	"o6_8.min_participation.area_0_10_ha" in rule_ids(d)
	d.premium_gross_eur == 0
}

test_min_participation_exactly_0_10 if {
	small := patched(us_parcel, "/area_ha", 0.1)
	d := o6_8.decision with input as farm_input([small])
	d.min_participation_met
}

test_combination_obligation_missing if {
	inp := with_farm(farm_input([ms_parcel, us_parcel]), "/farm/oepul/participating_measures", ["8"])
	d := o6_8.decision with input as inp
	"o6_8.combination.ms_ds_requires_catch_crop_measure" in rule_ids(d)
	d.parcel_results.MS1.premium_eur == 0
	d.parcel_results.US1.premium_eur == 243
}

test_combination_obligation_not_for_us_only if {
	inp := with_farm(farm_input([us_parcel]), "/farm/oepul/participating_measures", ["8"])
	d := o6_8.decision with input as inp
	not d.combination_obligation_applies
	count(d.violations) == 0
}

test_combination_obligation_met_by_immergruen if {
	ims := patched(ms_parcel, "/oepul_o6_8/preceding_catch_crop", {"scheme": "oepul2023_immergruen", "overwintering": true})
	inp := with_farm(farm_input([ims]), "/farm/oepul/participating_measures", ["7", "8"])
	d := o6_8.decision with input as inp
	d.combination_obligation_met
	count(d.violations) == 0
}

test_applicant_public_body_share_too_high if {
	inp := with_farm(farm_input([us_parcel]), "/farm/oepul/applicant", {"legal_form": "legal_person", "public_body_share_percent": 30, "is_active_farmer": true})
	d := o6_8.decision with input as inp
	"gen.applicant.eligible_persons" in rule_ids(d)
	d.premium_gross_eur == 0
}

test_public_body_not_exempt_for_o6_8 if {
	not o6_8.public_body_exempt_for_o6_8
}

test_min_farm_size_first_year if {
	inp := json.patch(farm_input([us_parcel]), [
		{"op": "add", "path": "/farm/oepul/first_participation_year", "value": 2025},
		{"op": "add", "path": "/land/total_area_ha", "value": 1.2},
	])
	d := o6_8.decision with input as inp
	"gen.min_farm_size.first_year" in rule_ids(d)
}

test_min_farm_size_protected_cultivation if {
	inp := json.patch(farm_input([us_parcel]), [
		{"op": "add", "path": "/farm/oepul/first_participation_year", "value": 2025},
		{"op": "add", "path": "/land/total_area_ha", "value": 1.2},
		{"op": "add", "path": "/land/protected_cultivation_area_ha", "value": 0.5},
	])
	d := o6_8.decision with input as inp
	not "gen.min_farm_size.first_year" in rule_ids(d)
}

# ---------------------------------------------------------------------------
# Mulchsaat / Direktsaat / Strip-Till
# ---------------------------------------------------------------------------

test_ms_tillage_window_exceeded if {
	p := patched(ms_parcel, "/oepul_o6_8/tillage/first_tillage_date", "2025-03-20")
	d := o6_8.decision with input as farm_input([p])
	"o6_8.ms.max_4_weeks_tillage_to_sowing" in rule_ids(d)
}

test_ms_tillage_window_exactly_28_days if {
	p := patched(ms_parcel, "/oepul_o6_8/tillage/first_tillage_date", "2025-03-23")
	d := o6_8.decision with input as farm_input([p])
	not "o6_8.ms.max_4_weeks_tillage_to_sowing" in rule_ids(d)
}

test_ms_plough_not_allowed if {
	p := patched(ms_parcel, "/operations/tillage_type", "plough")
	d := o6_8.decision with input as farm_input([p])
	"o6_8.ms.no_inverting_tillage" in rule_ids(d)
	d.parcel_results.MS1.premium_eur == 0
}

test_ms_deep_loosening_with_cover_ok if {
	p := patched(ms_parcel, "/oepul_o6_8/tillage", {"first_tillage_date": "2025-04-01", "deep_loosening": true, "deep_loosening_cover_preserved": true})
	d := o6_8.decision with input as farm_input([p])
	not "o6_8.ms.deep_loosening_cover_preserved" in rule_ids(d)
}

test_ms_deep_loosening_destroying_cover if {
	p := patched(ms_parcel, "/oepul_o6_8/tillage", {"first_tillage_date": "2025-04-01", "deep_loosening": true, "deep_loosening_cover_preserved": false})
	d := o6_8.decision with input as farm_input([p])
	"o6_8.ms.deep_loosening_cover_preserved" in rule_ids(d)
}

test_ms_no_mulch_on_surface if {
	p := patched(ms_parcel, "/oepul_o6_8/tillage/plant_mulch_on_surface", false)
	d := o6_8.decision with input as farm_input([p])
	"o6_8.ms.definition_flat_non_inverting" in rule_ids(d)
}

test_preceding_variant_3_not_valid if {
	p := patched(ms_parcel, "/oepul_o6_8/preceding_catch_crop", {"scheme": "oepul2023_zwf", "variant": 3})
	d := o6_8.decision with input as farm_input([p])
	"o6_8.ms_ds.preceding_catch_crop" in rule_ids(d)
}

test_preceding_oepul2015_only_2023 if {
	p := patched(ms_parcel, "/oepul_o6_8/preceding_catch_crop", {"scheme": "oepul2015_zwf", "variant": 4})
	d25 := o6_8.decision with input as farm_input([p])
	"o6_8.ms_ds.preceding_catch_crop" in rule_ids(d25)
	p23 := json.patch(p, [
		{"op": "add", "path": "/oepul_o6_8/main_crop_sowing_date", "value": "2023-04-20"},
		{"op": "add", "path": "/oepul_o6_8/tillage/first_tillage_date", "value": "2023-04-01"},
	])
	d23 := o6_8.decision with input as with_farm(farm_input([p23]), "/farm/year", 2023)
	not "o6_8.ms_ds.preceding_catch_crop" in rule_ids(d23)
}

test_preceding_gloez8_npf_only_2025 if {
	p := patched(ms_parcel, "/oepul_o6_8/preceding_catch_crop", {"scheme": "gloez8_npf", "variant": 2})
	d25 := o6_8.decision with input as farm_input([p])
	not "o6_8.ms_ds.preceding_catch_crop" in rule_ids(d25)
	d26 := o6_8.decision with input as with_farm(farm_input([p]), "/farm/year", 2026)
	"o6_8.ms_ds.preceding_catch_crop" in rule_ids(d26)
}

test_immergruen_requires_overwintering if {
	p := patched(ms_parcel, "/oepul_o6_8/preceding_catch_crop", {"scheme": "oepul2023_immergruen", "overwintering": false})
	inp := with_farm(farm_input([p]), "/farm/oepul/participating_measures", ["7", "8"])
	d := o6_8.decision with input as inp
	"o6_8.ms_ds.preceding_catch_crop" in rule_ids(d)
}

test_switch_from_immergruen_to_zwf_blocks_ms if {
	p := patched(ms_parcel, "/oepul_o6_8/preceding_catch_crop", {"scheme": "oepul2023_immergruen", "overwintering": true})
	inp := with_farm(farm_input([p]), "/farm/oepul/participating_measures", ["6", "8"])
	d := o6_8.decision with input as inp
	"o6_8.ms_ds.preceding_catch_crop" in rule_ids(d)
}

test_ds_full_surface_tillage if {
	p := patched(ds_parcel, "/oepul_o6_8/tillage/full_surface_tillage", true)
	d := o6_8.decision with input as farm_input([p])
	"o6_8.ds.definition_direct_seeding" in rule_ids(d)
}

test_strip_till_ok_and_breach if {
	st := patched(ds_parcel, "/oepul_o6_8/tillage", {"ds_method": "strip_till", "strip_only_in_seed_row": true, "cover_residues_retained_between_strips": true})
	d1 := o6_8.decision with input as farm_input([st])
	count(d1.violations) == 0
	st2 := patched(st, "/oepul_o6_8/tillage/cover_residues_retained_between_strips", false)
	d2 := o6_8.decision with input as farm_input([st2])
	"o6_8.ds.definition_strip_till" in rule_ids(d2)
}

test_potatoes_only_mulch_seeding if {
	p := json.patch(ds_parcel, [{"op": "add", "path": "/crop/crop_name", "value": "Speisekartoffeln"}])
	d := o6_8.decision with input as farm_input([p])
	"o6_8.crops.ms_ds_list" in rule_ids(d)
	o6_8.potato_only_ms(p)
}

test_ms_on_wheat_not_eligible if {
	p := patched(ms_parcel, "/crop/crop_name", "Winterweichweizen")
	d := o6_8.decision with input as farm_input([p])
	"o6_8.crops.ms_ds_list" in rule_ids(d)
}

test_ms_us_combination_allowed if {
	p := json.patch(ms_parcel, [
		{"op": "add", "path": "/oepul_o6_8/codes", "value": ["MS", "US"]},
		{"op": "add", "path": "/oepul_o6_8/undersowing", "value": {"sowing_date": "2025-06-01", "mixture_partner_count": 4, "between_rows": true}},
	])
	d := o6_8.decision with input as farm_input([p])
	count(d.violations) == 0
	count(d.unlisted_code_combinations) == 0
	d.parcel_results.MS1.premium_eur == 675
}

test_ms_ah_not_combinable if {
	p := json.patch(ah_parcel, [
		{"op": "add", "path": "/oepul_o6_8/codes", "value": ["MS", "AH"]},
		{"op": "add", "path": "/oepul_o6_8/preceding_catch_crop", "value": {"scheme": "oepul2023_zwf", "variant": 6}},
	])
	d := o6_8.decision with input as farm_input([p])
	"o6_8.premium.ms_ds_ah_not_combinable" in rule_ids(d)
	d.parcel_results.AH1.premium_eur == 0
}

test_vienna_humus_option_blocks_ms if {
	p := patched(ms_parcel, "/oepul_o6_8/location", {"federal_state": "Wien", "district": "Donaustadt"})
	inp := json.patch(farm_input([p, us_parcel]), [
		{"op": "add", "path": "/farm/oepul/options", "value": ["16_humus_wien"]},
		{"op": "add", "path": "/farm/oepul/participating_measures", "value": ["1A", "6", "8", "16"]},
	])
	d := o6_8.decision with input as inp
	d.parcel_results.MS1.premium_eur == 0
	"MS" in d.parcel_results.MS1.compliant_codes
}

# ---------------------------------------------------------------------------
# Anhäufungen bei Kartoffeln
# ---------------------------------------------------------------------------

test_ah_interval_too_large if {
	p := patched(ah_parcel, "/oepul_o6_8/potato_ridges/interval_max_m", 2.5)
	d := o6_8.decision with input as farm_input([p])
	"o6_8.ah.ridges_max_2m" in rule_ids(d)
}

test_ah_seed_potato_row_omission if {
	seed := json.patch(ah_parcel, [
		{"op": "add", "path": "/crop/crop_name", "value": "Saatkartoffeln"},
		{"op": "add", "path": "/oepul_o6_8/potato_ridges/every_4th_row_omitted", "value": true},
		{"op": "add", "path": "/oepul_o6_8/potato_ridges/omission_necessary_weed_control_or_safety", "value": true},
	])
	d1 := o6_8.decision with input as farm_input([seed])
	count(d1.violations) == 0
	table := patched(ah_parcel, "/oepul_o6_8/potato_ridges/every_4th_row_omitted", true)
	d2 := o6_8.decision with input as farm_input([table])
	"o6_8.ah.seed_potato_every_4th_row" in rule_ids(d2)
}

test_ah_not_maintained if {
	p := patched(ah_parcel, "/oepul_o6_8/potato_ridges/maintained_until_haulm_reduction", false)
	d := o6_8.decision with input as farm_input([p])
	"o6_8.ah.maintain_until_haulm_reduction" in rule_ids(d)
}

test_ah_on_maize_not_eligible if {
	p := patched(ah_parcel, "/crop/crop_name", "Körnermais")
	d := o6_8.decision with input as farm_input([p])
	"o6_8.crops.ah_list" in rule_ids(d)
}

test_ah_renewal_permitted if {
	o6_8.ah_renewal_permitted("weed_control")
	o6_8.ah_renewal_permitted("rain_event")
	not o6_8.ah_renewal_permitted("harvest")
}

# ---------------------------------------------------------------------------
# Begrünte Abflusswege
# ---------------------------------------------------------------------------

test_anhang_f_lookup if {
	o6_8.kg_in_anhang_f("31001")
	o6_8.kg_in_anhang_f("61075")
	not o6_8.kg_in_anhang_f("01001")
	count(o6_8.anhang_f_kg_nrs) == 1952
}

test_baw_outside_anhang_f if {
	p := patched(baw_parcel, "/oepul_o6_8/location/kg_nr", "99999")
	d := o6_8.decision with input as farm_input([p])
	"o6_8.baw.anhang_f_area" in rule_ids(d)
}

test_baw_quarter_share if {
	p := patched(baw_parcel, "/area_ha", 0.5)
	d := o6_8.decision with input as farm_input([p])
	"o6_8.baw.erosion_path_quarter_share" in rule_ids(d)
	some n in d.application_notices
	n.rule_id == "o6_8.baw.max_four_times_erosion_path"
}

test_baw_max_area_example if {
	o6_8.baw_max_area_ha(0.1) == 0.4
}

test_baw_gloez4_part_excluded if {
	p := patched(baw_parcel, "/oepul_o6_8/baw/gloez4_buffer_area_ha", 0.1)
	d := o6_8.decision with input as farm_input([p])
	d.parcel_results.BAW1.premium_eur == 178.2
}

test_baw_late_sowing if {
	p := patched(baw_parcel, "/oepul_o6_8/baw/sowing_date", "2024-05-20")
	d := o6_8.decision with input as farm_input([p])
	"o6_8.baw.sowing_by_15_may" in rule_ids(d)
}

test_baw_legume_share_new_sowing if {
	p := patched(baw_parcel, "/oepul_o6_8/baw/legume_share_percent", 50)
	d := o6_8.decision with input as farm_input([p])
	"o6_8.baw.sowing_by_15_may" in rule_ids(d)
}

test_baw_existing_stand_high_legume_ok if {
	p := patched(baw_parcel, "/oepul_o6_8/baw", {
		"erosion_path_area_ha": 0.1, "existing_stand_retained": true, "existing_stand_type": "feldfutter",
		"legume_share_percent": 70, "first_declared_year": 2024, "last_mowing_or_mulching_year": 2025,
	})
	d := o6_8.decision with input as farm_input([p])
	count(d.violations) == 0
}

test_baw_ploughing_too_early if {
	p := patched(baw_parcel, "/oepul_o6_8/baw/ploughing_date", "2025-09-01")
	d := o6_8.decision with input as farm_input([p])
	"o6_8.baw.ploughing_earliest_15_sep_year2" in rule_ids(d)
	p2 := patched(baw_parcel, "/oepul_o6_8/baw/ploughing_date", "2025-09-15")
	d2 := o6_8.decision with input as farm_input([p2])
	not "o6_8.baw.ploughing_earliest_15_sep_year2" in rule_ids(d2)
}

test_baw_transfer_consequence if {
	o6_8.baw_transfer_consequence("transferring_holder") == "loss_of_disposal_no_repayment"
	o6_8.baw_transfer_consequence("successor_continuing_in_place") == "establishment_year_of_previous_holder_applies"
}

test_baw_fertilizer_forbidden if {
	p := patched(baw_parcel, "/operations/fertilizer/organic_n_kg_per_ha", 20)
	d := o6_8.decision with input as farm_input([p])
	"o6_8.baw.no_psm_no_fertilizer" in rule_ids(d)
}

test_baw_mowing_gap if {
	p := patched(baw_parcel, "/oepul_o6_8/baw/first_declared_year", 2023)
	p2 := patched(p, "/oepul_o6_8/baw/last_mowing_or_mulching_year", 2023)
	d := o6_8.decision with input as farm_input([p2])
	"o6_8.baw.mow_or_mulch_every_second_year" in rule_ids(d)
}

test_baw_grazing_forbidden if {
	p := patched(baw_parcel, "/oepul_o6_8/baw/grazed", true)
	d := o6_8.decision with input as farm_input([p])
	"o6_8.baw.no_grazing_no_threshing" in rule_ids(d)
}

test_baw_grassland_2020 if {
	p := patched(baw_parcel, "/oepul_o6_8/baw/grassland_in_mfa_2020", true)
	d := o6_8.decision with input as farm_input([p])
	"o6_8.baw.not_eligible_grassland_2020" in rule_ids(d)
}

test_baw_kleegras_new_sowing_not_possible if {
	p := patched(baw_parcel, "/crop/crop_name", "Kleegras")
	d := o6_8.decision with input as farm_input([p])
	"o6_8.crops.baw_list" in rule_ids(d)
}

test_baw_npf_until_2024_no_premium if {
	p := patched(baw_parcel, "/oepul_o6_8/baw/npf_code", true)
	d := o6_8.decision with input as with_farm(farm_input([p, us_parcel]), "/farm/year", 2024)
	d.parcel_results.BAW1.premium_eur == 0
}

test_baw_other_measure_conflict if {
	p := patched(baw_parcel, "/oepul_o6_8/other_measures_on_parcel", ["16"])
	d := o6_8.decision with input as farm_input([p])
	"o6_8.premium.baw_no_other_measure" in rule_ids(d)
	p2 := patched(baw_parcel, "/oepul_o6_8/other_measures_on_parcel", ["1A_LSE"])
	d2 := o6_8.decision with input as farm_input([p2])
	count(d2.violations) == 0
}

test_baw_div_credit if {
	p := patched(baw_parcel, "/oepul_o6_8/baw/div_code", true)
	d := o6_8.decision with input as farm_input([p])
	not "o6_8.baw.counts_as_div_ubb_bio" in rule_ids(d)
	inp := with_farm(farm_input([p]), "/farm/oepul/participating_measures", ["8"])
	d2 := o6_8.decision with input as inp
	"o6_8.baw.counts_as_div_ubb_bio" in rule_ids(d2)
}

test_baw_conversion_deadline if {
	o6_8.baw_conversion_allowed("18", "2025-12-31")
	o6_8.baw_conversion_allowed("19", "2024-11-30")
	not o6_8.baw_conversion_allowed("18", "2026-01-15")
	not o6_8.baw_conversion_allowed("1B", "2024-11-30")
}

# ---------------------------------------------------------------------------
# Untersaat
# ---------------------------------------------------------------------------

test_us_maize_only_from_2025 if {
	p := patched(us_parcel, "/crop/crop_name", "Körnermais")
	d25 := o6_8.decision with input as farm_input([p])
	not "o6_8.crops.us_list" in rule_ids(d25)
	p24 := json.patch(p, [
		{"op": "add", "path": "/oepul_o6_8/main_crop_sowing_date", "value": "2024-04-15"},
		{"op": "add", "path": "/oepul_o6_8/undersowing/sowing_date", "value": "2024-05-20"},
	])
	d24 := o6_8.decision with input as with_farm(farm_input([p24]), "/farm/year", 2024)
	"o6_8.crops.us_list" in rule_ids(d24)
}

test_us_two_partners if {
	p := patched(us_parcel, "/oepul_o6_8/undersowing/mixture_partner_count", 2)
	d := o6_8.decision with input as farm_input([p])
	"o6_8.us.min_3_mixture_partners" in rule_ids(d)
}

test_us_later_than_8_weeks if {
	p := patched(us_parcel, "/oepul_o6_8/undersowing/sowing_date", "2025-06-15")
	d := o6_8.decision with input as farm_input([p])
	"o6_8.us.sowing_within_8_weeks_latest_30_june" in rule_ids(d)
}

test_us_after_30_june if {
	p := json.patch(us_parcel, [
		{"op": "add", "path": "/oepul_o6_8/main_crop_sowing_date", "value": "2025-05-20"},
		{"op": "add", "path": "/oepul_o6_8/undersowing/sowing_date", "value": "2025-07-02"},
	])
	d := o6_8.decision with input as farm_input([p])
	"o6_8.us.sowing_within_8_weeks_latest_30_june" in rule_ids(d)
}

test_us_winter_field_bean_30_april if {
	p := json.patch(us_parcel, [
		{"op": "add", "path": "/crop/crop_name", "value": "Winterackerbohnen"},
		{"op": "add", "path": "/oepul_o6_8/main_crop_sowing_date", "value": "2025-03-20"},
		{"op": "add", "path": "/oepul_o6_8/undersowing/sowing_date", "value": "2025-05-05"},
	])
	d := o6_8.decision with input as farm_input([p])
	"o6_8.us.sowing_within_8_weeks_latest_30_june" in rule_ids(d)
}

test_us_harrowing_forbidden if {
	p := patched(us_parcel, "/oepul_o6_8/undersowing/harrowing_after_sowing", true)
	d := o6_8.decision with input as farm_input([p])
	"o6_8.us.no_tillage_no_herbicide_after_sowing" in rule_ids(d)
}

test_us_harvested_with_main_crop if {
	p := patched(us_parcel, "/oepul_o6_8/undersowing/harvested_with_main_crop", true)
	d := o6_8.decision with input as farm_input([p])
	"o6_8.us.maintain_until_harvest_not_harvested" in rule_ids(d)
}

test_us_seed_proof_required if {
	p := patched(us_parcel, "/oepul_o6_8/undersowing/partners_visible_in_field", false)
	d := o6_8.decision with input as farm_input([p])
	"o6_8.us.seed_proof_if_not_visible" in rule_ids(d)
	p2 := patched(p, "/oepul_o6_8/undersowing/seed_proof_available", true)
	d2 := o6_8.decision with input as farm_input([p2])
	not "o6_8.us.seed_proof_if_not_visible" in rule_ids(d2)
}

test_us_full_coverage_waived_2026 if {
	p := json.patch(us_parcel, [
		{"op": "add", "path": "/oepul_o6_8/main_crop_sowing_date", "value": "2026-04-15"},
		{"op": "add", "path": "/oepul_o6_8/undersowing/sowing_date", "value": "2026-05-20"},
		{"op": "add", "path": "/oepul_o6_8/undersowing/full_coverage_achieved", "value": false},
	])
	d26 := o6_8.decision with input as with_farm(farm_input([p]), "/farm/year", 2026)
	not "o6_8.us.full_coverage" in rule_ids(d26)
	p25 := patched(us_parcel, "/oepul_o6_8/undersowing/full_coverage_achieved", false)
	d25 := o6_8.decision with input as farm_input([p25])
	"o6_8.us.full_coverage" in rule_ids(d25)
}

test_us_as_catch_crop if {
	p := patched(us_parcel, "/oepul_o6_8/undersowing/main_crop_harvest_date", "2025-09-10")
	o6_8.us_can_count_as_catch_crop(p, "2025-09-20")
	not o6_8.us_can_count_as_catch_crop(p, "2025-08-31")
}

# ---------------------------------------------------------------------------
# General conditions
# ---------------------------------------------------------------------------

test_modulation_example_220_ha if {
	f := o6_8.modulation_factor(220)
	f > 0.99090
	f < 0.99091
}

test_modulation_brackets if {
	o6_8.modulation_factor(150) == 1
	o6_8.modulation_factor(300) == (200 + (100 * 0.9)) / 300
	o6_8.modulation_factor(1200) == (((200 + 90) + (700 * 0.85)) + (200 * 0.75)) / 1200
}

test_area_reduction_tolerance if {
	o6_8.area_reduction_tolerance_ha(4) == 0.5
	o6_8.area_reduction_tolerance_ha(40) == 2
	o6_8.area_reduction_tolerance_ha(200) == 5
}

test_o6_8_area_annually_variable if {
	o6_8.area_annually_variable
	not o6_8.area_reduction_repayment_applies(40, 10)
	not o6_8.area_increase_premium_restricted
}

test_takeover_deadline if {
	o6_8.takeover_deadline(2025) == "2025-04-15"
	o6_8.takeover_deadline(2028) == "2028-04-17"
	o6_8.takeover_allowed("2025-04-10", 10, 5)
	not o6_8.takeover_allowed("2025-04-10", 10, 6)
	not o6_8.takeover_allowed("2025-04-16", 10, 1)
}

test_payment_rules if {
	o6_8.payment_deadline(2025) == "2026-06-30"
	o6_8.max_advance_payment_eur(1000) == 750
	o6_8.payout_may_be_withheld(50)
	not o6_8.payout_may_be_withheld(50.01)
}

test_area_cap if {
	o6_8.area_cap_eur_per_ha(2023) == 1200
	o6_8.area_cap_eur_per_ha(2025) == 1300
	p := patched(baw_parcel, "/oepul_o6_8/other_area_payments_eur_per_ha", 800)
	d := o6_8.decision with input as farm_input([p])
	d.parcel_results.BAW1.area_cap_exceeded
}

test_sanction_stages if {
	o6_8.sanction_stage(1, 2026).type == "warning"
	o6_8.sanction_stage(1, 2027).type == "retention"
	o6_8.sanction_stage(1, 2027).percent == 1
	o6_8.sanction_stage(5, 2025).percent == 25
}

test_early_exit_repayment if {
	o6_8.early_exit_repayment_required with input as with_farm(farm_input([]), "/farm/oepul/o6_8/exit_year", 2026)
	not o6_8.early_exit_repayment_required with input as json.patch(farm_input([]), [
		{"op": "add", "path": "/farm/oepul/o6_8/exit_year", "value": 2026},
		{"op": "add", "path": "/farm/oepul/o6_8/exit_reason", "value": "revision_clause"},
	])
}

test_missing_payment_application if {
	inp := with_farm(farm_input([]), "/farm/oepul/o6_8/payment_application_submitted", false)
	o6_8.missing_payment_application_no_premium with input as inp
	o6_8.missing_payment_application_ends_commitment with input as inp
	inp2 := with_farm(inp, "/farm/oepul/o6_8/late_payment_application_within_one_year", true)
	not o6_8.missing_payment_application_ends_commitment with input as inp2
}

test_op_code_no_premium if {
	p := patched(us_parcel, "/oepul_o6_8/op_codes", ["OPEROA"])
	d := o6_8.decision with input as farm_input([p, ms_parcel])
	d.parcel_results.US1.premium_eur == 0
	"op_code" in d.parcel_results.US1.exclusions
}

test_national_park_neusiedlersee if {
	p := patched(us_parcel, "/oepul_o6_8/location", {"federal_state": "Burgenland", "national_park": "Neusiedlersee"})
	d := o6_8.decision with input as farm_input([p, ms_parcel])
	"national_park" in d.parcel_results.US1.exclusions
}

test_trial_area_vf if {
	p := patched(us_parcel, "/oepul_o6_8/trial_area_vf", true)
	d := o6_8.decision with input as farm_input([p, ms_parcel])
	d.parcel_results.US1.premium_eur == 0
}

test_harvest_obligation_breach_requires_op if {
	p := patched(ms_parcel, "/oepul_o6_8/harvest/harvested_share_percent", 60)
	d := o6_8.decision with input as farm_input([p, us_parcel])
	"gen.op_code.mandatory" in rule_ids(d)
	d.parcel_results.MS1.premium_eur == 0
}

test_harvest_obligation_drought_2026_waiver if {
	p := json.patch(ms_parcel, [
		{"op": "add", "path": "/oepul_o6_8/main_crop_sowing_date", "value": "2026-04-20"},
		{"op": "add", "path": "/oepul_o6_8/tillage/first_tillage_date", "value": "2026-04-01"},
		{"op": "add", "path": "/oepul_o6_8/harvest", "value": {
			"harvested_share_percent": 0,
			"no_harvestable_stand_due_to_drought": true,
			"late_summer_or_autumn_harvest_crop": true,
		}},
	])
	d := o6_8.decision with input as with_farm(farm_input([p]), "/farm/year", 2026)
	count(d.violations) == 0
	d.parcel_results.MS1.premium_eur == 270
}

test_drought_area_styria_extension if {
	p := patched(ms_parcel, "/oepul_o6_8/location", {"federal_state": "Steiermark", "district": "Leibnitz"})
	o6_8.drought_waiver_area(p) with input as farm_input([])
	p2 := patched(ms_parcel, "/oepul_o6_8/location", {"federal_state": "Steiermark", "district": "Liezen"})
	not o6_8.drought_waiver_area(p2) with input as farm_input([])
	p3 := patched(ms_parcel, "/oepul_o6_8/location", {"federal_state": "Burgenland", "district": "Oberwart"})
	o6_8.drought_waiver_area(p3) with input as farm_input([])
}

test_force_majeure_application_outside_area if {
	p := json.patch(ms_parcel, [
		{"op": "add", "path": "/oepul_o6_8/location", "value": {"federal_state": "Tirol", "district": "Innsbruck-Land"}},
		{"op": "add", "path": "/oepul_o6_8/harvest", "value": {"harvested_share_percent": 0, "harvest_prevented_by_force_majeure": true}},
	])
	d := o6_8.decision with input as with_farm(farm_input([p]), "/farm/year", 2025)
	"n2026.harvest_obligation_individual_application" in rule_ids(d)
}

test_anhang_l_combinations if {
	o6_8.combinable_on_parcel("8", "6")
	o6_8.combinable_on_parcel("8", "1B")
	not o6_8.combinable_on_parcel("8", "18")
	o6_8.combination_with_discount("16", "1B")
	o6_8.combinable_only_for_landscape_elements("1A", "18")
}

test_anhang_l_violation_for_naturschutz if {
	p := patched(us_parcel, "/oepul_o6_8/other_measures_on_parcel", ["18"])
	d := o6_8.decision with input as farm_input([p])
	"o6_8.combination.anhang_l" in rule_ids(d)
}

test_ubb_bio_steep_parcel_effect if {
	steep := json.patch(ms_parcel, [{"op": "add", "path": "/oepul_o6_8/codes", "value": []}])
	o6_8.ubb_arable_basic_premium_effect(steep) == "no_basic_premium" with input as farm_input([steep])
	inp := with_farm(farm_input([steep]), "/farm/oepul/participating_measures", ["1B"])
	o6_8.bio_arable_basic_premium_effect(steep) == "basic_premium_reduced_50_percent" with input as inp
	o6_8.bio_arable_basic_premium_effect(steep) == "no_basic_premium" with input as with_farm(inp, "/farm/year", 2024)
	not o6_8.steep_erosion_prone_without_procedure(ms_parcel) with input as farm_input([ms_parcel])
}

test_unknown_code if {
	p := patched(us_parcel, "/oepul_o6_8/codes", ["XY"])
	d := o6_8.decision with input as farm_input([p, ms_parcel])
	"o6_8.application.codes_required" in rule_ids(d)
}

test_definitions_lists if {
	"Sorghum" in o6_8.definitions.nicht_getreide
	"Grünschnittroggen" in o6_8.definitions.getreide
	"Zuckermais" in o6_8.definitions.feldgemuese
	"Kleegras" in o6_8.definitions.ackerfutter
}

test_min_management_category if {
	o6_8.min_management_category(baw_parcel) == "exempt_baw"
	o6_8.min_management_category(ms_parcel) == "arable"
	o6_8.min_management_category(patched(us_parcel, "/crop/crop_name", "Luzerne")) == "fodder"
}
