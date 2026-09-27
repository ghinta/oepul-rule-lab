package oepul.o6_18_test

import data.oepul.o6_18
import data.oepul.o6_18.administration
import data.oepul.o6_18.combinations
import data.oepul.o6_18.eligibility
import data.oepul.o6_18.notices_2026
import data.oepul.o6_18.obligations
import data.oepul.o6_18.premium

# Basisbetrieb 2026: Grünland-Schlag mit GA09/GL04/GI07 (DIVSZ) und Ackerstilllegung SA01/SB04 (DIV).
base := {
	"farm": {
		"year": 2026,
		"region": {"federal_state": "Niederösterreich", "district": "Melk"},
		"oepul": {
			"measures": ["18", "1A"],
			"ubb_bio_monitoring_options": [],
			"first_oepul_year": 2023,
			"applicant": {"type": "natural_person", "public_share_percent": 0},
			"naturschutz": {
				"application_date": "2022-11-30",
				"contract_start_year": 2023,
				"regional_plan": {"applied": true, "application_date": "2022-11-30", "participation_confirmation": true},
				"area_previous_year_ha": 3.0,
			},
		},
	},
	"land": {
		"total_area_ha": 50,
		"arable_area_ha": 10,
		"parcels": [
			{
				"parcel_id": "P1",
				"area_ha": 2.0,
				"land_use": "grassland",
				"crop": {"crop_category": "other", "crop_name": "Wiese"},
				"operations": {"psm_used": false, "fertilizer": {"mineral_n_kg_per_ha": 0, "organic_n_kg_per_ha": 0}, "cutting_dates": ["2026-07-20"]},
				"oepul": {"codes": ["NAT", "DIVSZ"], "schlagnutzung": "Einmähdige Wiese", "feldstueck_id": "F1", "feldstueck_area_ha": 2.0},
				"naturschutz": {
					"project_confirmation": {"present": true, "auflagen": ["GA09", "GL04", "GI07"], "earliest_mowing_date": "2026-07-15"},
					"reference_area_present": true,
					"grassland_type": "maehwiese",
				},
			},
			{
				"parcel_id": "P2",
				"area_ha": 1.0,
				"land_use": "arable",
				"crop": {"crop_category": "fallow", "crop_name": "Grünbrache"},
				"operations": {"psm_used": false, "fertilizer": {"mineral_n_kg_per_ha": 0, "organic_n_kg_per_ha": 0}, "cutting_dates": []},
				"oepul": {"codes": ["NAT", "DIV"], "schlagnutzung": "Grünbrache", "feldstueck_id": "F2", "feldstueck_area_ha": 1.0},
				"naturschutz": {
					"project_confirmation": {"present": true, "auflagen": ["SA01", "SB04"]},
					"reference_area_present": true,
					"ackerzahl": 55,
				},
			},
		],
	},
}

patched(ops) := json.patch(base, ops)

rule_ids(vs) := {v.rule_id | some v in vs}

has_violation(inp, rid) if {
	some v in o6_18.violations with input as inp
	v.rule_id == rid
}

# --- Basis ---
test_base_compliant if {
	count(o6_18.violations) == 0 with input as base
}

test_base_premiums if {
	pp := premium.parcel_premium with input as base
	pp.P1 == 1641.6
	pp.P2 == 615.6
	premium.regional_plan_payable == 270 with input as base
	premium.total_premium == 2527.2 with input as base
}

test_decision_document if {
	d := o6_18.decision with input as base
	d.compliant
	d.total_premium_eur == 2527.2
	d.div_countable_parcels == {"P1", "P2"}
}

# --- Zugangsvoraussetzungen ---
test_missing_project_confirmation if {
	inp := patched([{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/present", "value": false}])
	has_violation(inp, "O618-ELIG-001")
	pp := premium.parcel_premium with input as inp
	pp.P1 == 0
}

test_no_nat_parcel if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/0/oepul/codes", "value": []},
		{"op": "replace", "path": "/land/parcels/1/oepul/codes", "value": []},
	])
	has_violation(inp, "O618-ELIG-002")
}

test_alpine_pasture_not_eligible if {
	inp := patched([{"op": "replace", "path": "/land/parcels/0/land_use", "value": "alpine_pasture"}])
	has_violation(inp, "O618-ELIG-003")
}

test_late_application if {
	inp := patched([{"op": "replace", "path": "/farm/oepul/naturschutz/application_date", "value": "2023-01-05"}])
	has_violation(inp, "O618-ELIG-004")
}

test_entry_after_2025_not_possible if {
	inp := patched([
		{"op": "replace", "path": "/farm/oepul/naturschutz/contract_start_year", "value": 2026},
		{"op": "replace", "path": "/farm/oepul/naturschutz/application_date", "value": "2025-12-01"},
	])
	has_violation(inp, "O618-ELIG-005")
}

test_contract_duration if {
	eligibility.contract_duration_years == 6 with input as base
	inp := patched([{"op": "replace", "path": "/farm/oepul/naturschutz/contract_start_year", "value": 2025}])
	eligibility.contract_duration_years == 4 with input as inp
}

test_missing_reference_area_blocks_payment if {
	inp := patched([{"op": "replace", "path": "/land/parcels/1/naturschutz/reference_area_present", "value": false}])
	pp := premium.parcel_premium with input as inp
	pp.P2 == 0
}

test_regional_plan_without_confirmation if {
	inp := patched([{"op": "replace", "path": "/farm/oepul/naturschutz/regional_plan/participation_confirmation", "value": false}])
	has_violation(inp, "O618-ELIG-009")
	premium.regional_plan_payable == 0 with input as inp
}

test_regional_plan_once_with_ebw if {
	inp := patched([{"op": "add", "path": "/farm/oepul/naturschutz/regional_plan/granted_via_ebw", "value": true}])
	premium.regional_plan_payable == 0 with input as inp
}

test_regional_plan_last_entry if {
	inp := patched([{"op": "replace", "path": "/farm/oepul/naturschutz/regional_plan/application_date", "value": "2028-01-10"}])
	has_violation(inp, "O618-ELIG-010")
}

test_unknown_auflage if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen/-", "value": "ZZ99"}])
	has_violation(inp, "O618-ELIG-014")
}

test_auflage_valid_from_2025 if {
	inp := patched([
		{"op": "replace", "path": "/farm/year", "value": 2024},
		{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen", "value": ["GA21"]},
	])
	has_violation(inp, "O618-ELIG-014")
}

test_k20_codes_only_until_2024 if {
	inp := patched([{"op": "replace", "path": "/land/parcels/1/naturschutz/project_confirmation/auflagen", "value": ["KA01"]}])
	has_violation(inp, "O618-ELIG-014")
}

test_plot_size_gd02 if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen/-", "value": "GD02"}])
	has_violation(inp, "O618-ELIG-017")
}

test_gg_only_bergmahd if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen/-", "value": "GG01"}])
	has_violation(inp, "O618-ELIG-015")
	inp2 := json.patch(inp, [{"op": "add", "path": "/land/parcels/0/naturschutz/is_bergmahd", "value": true}])
	not has_violation(inp2, "O618-ELIG-015")
}

test_min_farm_size_first_year if {
	inp := patched([
		{"op": "replace", "path": "/farm/oepul/first_oepul_year", "value": 2026},
		{"op": "replace", "path": "/land/total_area_ha", "value": 1.2},
	])
	has_violation(inp, "O618-ELIG-012")
}

test_public_body_excluded if {
	inp := patched([{"op": "replace", "path": "/farm/oepul/applicant/public_share_percent", "value": 30}])
	has_violation(inp, "O618-ELIG-013")
}

# --- Allgemeine Auflagen ---
test_max_three_uses if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/0/operations/cutting_dates", "value": ["2026-07-20", "2026-08-30", "2026-09-30"]},
		{"op": "add", "path": "/land/parcels/0/naturschutz/grazing_periods", "value": [{"start": "2026-10-05", "end": "2026-10-20", "animals": []}]},
	])
	has_violation(inp, "O618-OBL-002")
}

test_use_every_two_years if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/0/operations/cutting_dates", "value": []},
		{"op": "add", "path": "/land/parcels/0/naturschutz/year_completed", "value": true},
		{"op": "add", "path": "/land/parcels/0/naturschutz/use_or_care_years", "value": [2023]},
	])
	has_violation(inp, "O618-OBL-001")
	inp2 := json.patch(inp, [{"op": "replace", "path": "/land/parcels/0/naturschutz/use_or_care_years", "value": [2025]}])
	not has_violation(inp2, "O618-OBL-001")
}

test_prohibited_activities if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/naturschutz/activities", "value": {"silage_bale_storage": true, "new_drainage": true, "terrain_correction": true}}])
	ids := rule_ids(o6_18.violations) with input as inp
	{"O618-OBL-003", "O618-OBL-004", "O618-OBL-005"} - ids == set()
}

test_reseeding_requires_approval if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/naturschutz/activities", "value": {"reseeding": {"performed": true, "reason": "wildschaden", "written_approval": false}}}])
	has_violation(inp, "O618-OBL-006")
	inp2 := json.patch(inp, [{"op": "replace", "path": "/land/parcels/0/naturschutz/activities/reseeding/written_approval", "value": true}])
	not has_violation(inp2, "O618-OBL-006")
}

test_no_fertilizing_on_pasture if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/0/naturschutz/grassland_type", "value": "weide"},
		{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen", "value": ["GA09"]},
		{"op": "add", "path": "/land/parcels/0/naturschutz/fertilization_events", "value": [{"date": "2026-04-01", "type": "guelle"}]},
	])
	has_violation(inp, "O618-OBL-007")
}

test_sewage_sludge_banned if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/naturschutz/fertilization_events", "value": [{"date": "2026-09-10", "type": "klaerschlamm"}]}])
	has_violation(inp, "O618-OBL-008")
}

test_deviation_needs_written_amendment if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/naturschutz/project_confirmation/management_deviates", "value": true}])
	has_violation(inp, "O618-OBL-010")
}

# --- Bewirtschaftungsauflagen (Anhang I) ---
test_mowing_before_earliest_date if {
	inp := patched([
		{"op": "replace", "path": "/farm/year", "value": 2025},
		{"op": "replace", "path": "/land/parcels/0/operations/cutting_dates", "value": ["2025-07-01"]},
		{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/earliest_mowing_date", "value": "2025-07-15"},
	])
	has_violation(inp, "O618-OBL-011A")
}

test_drought_release_2026_from_12_august if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/0/operations/cutting_dates", "value": ["2026-08-15"]},
		{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/earliest_mowing_date", "value": "2026-09-01"},
	])
	not has_violation(inp, "O618-OBL-011A")
	inp2 := json.patch(inp, [{"op": "replace", "path": "/land/parcels/0/operations/cutting_dates", "value": ["2026-08-10"]}])
	has_violation(inp2, "O618-OBL-011A")
}

test_required_mowing_count if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen", "value": ["GA04"]},
		{"op": "add", "path": "/land/parcels/0/naturschutz/year_completed", "value": true},
	])
	has_violation(inp, "O618-OBL-011B")
}

test_fertilization_ban if {
	inp := patched([{"op": "replace", "path": "/land/parcels/0/operations/fertilizer/organic_n_kg_per_ha", "value": 20}])
	has_violation(inp, "O618-OBL-011C")
}

test_solid_manure_only if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen", "value": ["GA09", "GI04"]},
		{"op": "add", "path": "/land/parcels/0/naturschutz/fertilization_events", "value": [{"date": "2026-04-01", "type": "guelle"}]},
	])
	has_violation(inp, "O618-OBL-011D")
}

test_farm_manure_from_september if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen", "value": ["GA04", "GI24"]},
		{"op": "add", "path": "/land/parcels/0/naturschutz/fertilization_events", "value": [{"date": "2026-08-20", "type": "festmist"}]},
	])
	has_violation(inp, "O618-OBL-011E")
}

test_psm_ban_and_tc01_exception if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/1/naturschutz/project_confirmation/auflagen", "value": ["AA04"]},
		{"op": "replace", "path": "/land/parcels/1/operations/psm_used", "value": true},
	])
	has_violation(inp, "O618-OBL-011F")
	inp2 := json.patch(inp, [
		{"op": "replace", "path": "/land/parcels/1/naturschutz/project_confirmation/auflagen", "value": ["TC01"]},
		{"op": "add", "path": "/land/parcels/1/naturschutz/psm_only_eu_organic_approved", "value": true},
	])
	not has_violation(inp2, "O618-OBL-011F")
}

test_maize_ban if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/1/naturschutz/project_confirmation/auflagen", "value": ["TD01"]},
		{"op": "replace", "path": "/land/parcels/1/crop/crop_category", "value": "maize"},
	])
	has_violation(inp, "O618-OBL-011G")
}

test_grazing_ban_nw09 if {
	inp := patched([
		{"op": "add", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen/-", "value": "NW09"},
		{"op": "add", "path": "/land/parcels/0/naturschutz/grazing_periods", "value": [{"start": "2026-09-01", "end": "2026-09-10", "animals": []}]},
	])
	has_violation(inp, "O618-OBL-011H")
}

test_grazing_before_first_cut_gb01 if {
	inp := patched([
		{"op": "add", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen/-", "value": "GB01"},
		{"op": "add", "path": "/land/parcels/0/naturschutz/grazing_periods", "value": [{"start": "2026-05-01", "end": "2026-05-10", "animals": []}]},
	])
	has_violation(inp, "O618-OBL-011I")
}

weide_input(animals) := patched([
	{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen", "value": ["WA03"]},
	{"op": "replace", "path": "/land/parcels/0/naturschutz/grassland_type", "value": "weide"},
	{"op": "replace", "path": "/land/parcels/0/operations/cutting_dates", "value": []},
	{"op": "replace", "path": "/land/parcels/0/oepul/codes", "value": ["NAT"]},
	{"op": "add", "path": "/land/parcels/0/naturschutz/grazing_diary", "value": {"kept": true, "daily_current": true}},
	{"op": "add", "path": "/land/parcels/0/naturschutz/grazing_periods", "value": [{"start": "2026-06-01", "end": "2026-08-29", "animals": animals}]},
])

test_stocking_rate_wa03 if {
	# 4 Rinder ab 2 Jahre x 90 Tage / 365 / 2 ha = 0,49 RGVE/ha -> zulässig
	not has_violation(weide_input([{"annex_a_key": "rinder_ab_2_j", "count": 4}]), "O618-OBL-011K")

	# 6 Rinder -> 0,74 RGVE/ha -> Verstoß
	has_violation(weide_input([{"annex_a_key": "rinder_ab_2_j", "count": 6}]), "O618-OBL-011K")
}

test_grazing_diary_required if {
	inp := json.patch(weide_input([]), [{"op": "replace", "path": "/land/parcels/0/naturschutz/grazing_diary/kept", "value": false}])
	has_violation(inp, "O618-OBL-009")
}

test_gn03_nine_weeks if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen", "value": ["GA04", "GN03"]},
		{"op": "replace", "path": "/land/parcels/0/operations/cutting_dates", "value": ["2026-06-01", "2026-07-20"]},
	])
	has_violation(inp, "O618-OBL-011L")
}

test_bergmahd_nachweide_requires_auflage if {
	inp := patched([
		{"op": "add", "path": "/land/parcels/0/naturschutz/is_bergmahd", "value": true},
		{"op": "add", "path": "/land/parcels/0/naturschutz/grazing_periods", "value": [{"start": "2026-08-20", "end": "2026-09-10", "animals": []}]},
	])
	has_violation(inp, "O618-OBL-012")
	inp2 := json.patch(inp, [{"op": "add", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen/-", "value": "NW04"}])
	not has_violation(inp2, "O618-OBL-012")
}

arable_harvest_input(state, district) := patched([
	{"op": "replace", "path": "/farm/region", "value": {"federal_state": state, "district": district}},
	{"op": "replace", "path": "/land/parcels/1/naturschutz/project_confirmation/auflagen", "value": ["AA04"]},
	{"op": "replace", "path": "/land/parcels/1/oepul/codes", "value": ["NAT"]},
	{"op": "add", "path": "/land/parcels/1/naturschutz/harvest_share", "value": 0.4},
	{"op": "add", "path": "/land/parcels/1/naturschutz/drought_no_harvestable_crop", "value": true},
])

test_harvest_obligation_drought_2026 if {
	not has_violation(arable_harvest_input("Niederösterreich", "Melk"), "O618-OBL-014")
	not has_violation(arable_harvest_input("Steiermark", "Leibnitz"), "O618-OBL-014")
	has_violation(arable_harvest_input("Tirol", "Innsbruck-Land"), "O618-OBL-014")
	fm := notices_2026.force_majeure_application_required with input as arable_harvest_input("Tirol", "Innsbruck-Land")
	"P2" in fm
}

test_minimum_criteria_exempt_gruenbrache if {
	ex := obligations.minimum_criteria_exempt with input as base
	ex == {"P2"}
}

# --- Kombinationen ---
test_annex_j_chapters_not_combinable if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen/-", "value": "WA01"}])
	has_violation(inp, "O618-KOMB-001")
}

test_annex_j_landscape_elements_combinable if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen/-", "value": "LA01"}])
	not has_violation(inp, "O618-KOMB-001")
}

test_annex_j_habitat_not_with_set_aside if {
	inp := patched([
		{"op": "add", "path": "/land/parcels/1/naturschutz/project_confirmation/auflagen/-", "value": "HG02"},
		{"op": "add", "path": "/land/parcels/1/naturschutz/habitat_layer_registered", "value": true},
	])
	has_violation(inp, "O618-KOMB-001")
}

test_sb_requires_sa01 if {
	inp := patched([{"op": "replace", "path": "/land/parcels/1/naturschutz/project_confirmation/auflagen", "value": ["SB04"]}])
	has_violation(inp, "O618-KOMB-002")
}

test_gf_requires_ge if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen/-", "value": "GF01"}])
	has_violation(inp, "O618-KOMB-002")
	inp2 := json.patch(inp, [{"op": "add", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen/-", "value": "GE03"}])
	not has_violation(inp2, "O618-KOMB-002")
}

test_aa06_excludes_ac01 if {
	inp := patched([{"op": "replace", "path": "/land/parcels/1/naturschutz/project_confirmation/auflagen", "value": ["AA06", "AC01"]}])
	has_violation(inp, "O618-KOMB-003")
}

test_phenology_requires_monitoring if {
	inp := patched([{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen", "value": ["GA09", "GL06"]}])
	has_violation(inp, "O618-KOMB-004")
	inp2 := json.patch(inp, [{"op": "replace", "path": "/farm/oepul/ubb_bio_monitoring_options", "value": ["schnittzeit_phaenologie"]}])
	not has_violation(inp2, "O618-KOMB-004")
}

test_grosstrappe_requires_ubb_bio if {
	inp := patched([
		{"op": "replace", "path": "/farm/oepul/measures", "value": ["18"]},
		{"op": "replace", "path": "/land/parcels/1/naturschutz/project_confirmation/auflagen", "value": ["TA01"]},
		{"op": "replace", "path": "/land/parcels/1/oepul/codes", "value": ["NAT"]},
		{"op": "replace", "path": "/land/parcels/0/oepul/codes", "value": ["NAT"]},
	])
	has_violation(inp, "O618-KOMB-005")
}

test_monitoring_option_requires_nat_auflage if {
	inp := patched([{"op": "replace", "path": "/farm/oepul/ubb_bio_monitoring_options", "value": ["grosstrappe"]}])
	has_violation(inp, "O618-KOMB-017")
}

test_div_not_countable_without_eligible_auflage if {
	inp := patched([{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen", "value": ["GA04"]}])
	has_violation(inp, "O618-KOMB-008")
	dc := combinations.div_countable with input as inp
	not "P1" in dc
}

test_div_requires_ubb_or_bio if {
	inp := patched([{"op": "replace", "path": "/farm/oepul/measures", "value": ["18"]}])
	dc := combinations.div_countable with input as inp
	count(dc) == 0
}

test_feldstueck_over_5ha_needs_div if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/0/oepul/feldstueck_area_ha", "value": 6.0},
		{"op": "replace", "path": "/land/parcels/0/oepul/codes", "value": ["NAT"]},
		{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen", "value": ["GA04"]},
	])
	has_violation(inp, "O618-KOMB-009")
}

test_single_area_combination if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/oepul/other_area_measures", "value": ["3"]}])
	has_violation(inp, "O618-KOMB-010")
	inp2 := patched([{"op": "add", "path": "/land/parcels/0/oepul/other_area_measures", "value": ["23"]}])
	not has_violation(inp2, "O618-KOMB-010")
}

test_ubb_only_landscape_elements if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/oepul/other_area_measures", "value": ["1A"]}])
	has_violation(inp, "O618-KOMB-010")
}

test_npf_no_premium_until_2024 if {
	inp := patched([
		{"op": "replace", "path": "/farm/year", "value": 2024},
		{"op": "replace", "path": "/land/parcels/1/oepul/codes", "value": ["NAT", "NPF"]},
		{"op": "replace", "path": "/land/parcels/0/operations/cutting_dates", "value": ["2024-07-20"]},
		{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/earliest_mowing_date", "value": "2024-07-15"},
	])
	pp := premium.parcel_premium with input as inp
	pp.P2 == 0
}

test_npf_not_after_2024 if {
	inp := patched([{"op": "replace", "path": "/land/parcels/1/oepul/codes", "value": ["NAT", "NPF"]}])
	has_violation(inp, "O618-KOMB-014")
}

# --- Prämie ---
test_set_aside_cap if {
	inp := patched([
		{"op": "replace", "path": "/land/arable_area_ha", "value": 4},
		{"op": "replace", "path": "/land/parcels/1/area_ha", "value": 3.0},
	])

	# Obergrenze max(25 % x 4 ha, 2 ha) = 2 ha -> Faktor 2/3 -> 2 ha x 615,6 €/ha
	pp := premium.parcel_premium with input as inp
	pp.P2 == 1231.2
}

test_modulation_factor if {
	inp := patched([{"op": "replace", "path": "/land/total_area_ha", "value": 250}])
	premium.modulation_factor == 0.98 with input as inp
}

test_payment_cap_per_ha if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen", "value": ["GA11", "GL37", "GI07"]},
		{"op": "add", "path": "/land/parcels/0/oepul/other_area_payments_eur_per_ha", "value": 100},
	])

	# 756 + 540 + 183,6 = 1.479,6 €/ha; Obergrenze 1.500 - 100 = 1.400 €/ha
	pp := premium.parcel_premium with input as inp
	pp.P1 == 2800
}

test_op_code_no_premium if {
	inp := patched([{"op": "replace", "path": "/land/parcels/0/oepul/codes", "value": ["NAT", "OP"]}])
	pp := premium.parcel_premium with input as inp
	pp.P1 == 0
}

test_national_park_donau_auen if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/oepul/national_park", "value": "Donau-Auen"}])
	pp := premium.parcel_premium with input as inp
	pp.P1 == 0
}

test_gloez4_area_not_eligible if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/oepul/gloez4_buffer_area_ha", "value": 0.5}])
	pp := premium.parcel_premium with input as inp
	pp.P1 == 1231.2
}

test_heuwirtschaft_surcharge_gm01 if {
	inp := patched([
		{"op": "replace", "path": "/farm/oepul/measures", "value": ["18", "1A", "3"]},
		{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen", "value": ["GA09", "GM01"]},
	])
	pp := premium.parcel_premium with input as inp
	pp.P1 == 1036.8
}

test_year_2023_rates_missing if {
	inp := patched([{"op": "replace", "path": "/farm/year", "value": 2023}])
	d := o6_18.decision with input as inp
	d.total_premium_eur == null
	some f in d.findings
	f.rule_id == "O618-PREM-012"
}

test_rate_gg03_year_specific if {
	premium.base_rate({"naturschutz": {"project_confirmation": {"auflagen": ["GG03"]}}}) == 145.8 with input as patched([{"op": "replace", "path": "/farm/year", "value": 2024}])
	premium.base_rate({"naturschutz": {"project_confirmation": {"auflagen": ["GG03"]}}}) == 291.6 with input as base
}

test_area_access_limit if {
	inp := patched([
		{"op": "replace", "path": "/farm/year", "value": 2027},
		{"op": "replace", "path": "/land/parcels/0/area_ha", "value": 20.0},
		{"op": "replace", "path": "/land/parcels/0/operations/cutting_dates", "value": ["2027-07-20"]},
		{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/earliest_mowing_date", "value": "2027-07-15"},
		{"op": "add", "path": "/farm/oepul/naturschutz/area_2025_ha", "value": 10.0},
	])

	# Grenze 10 + max(5, 5) = 15 ha von 21 ha
	premium.access_factor == 15 / 21 with input as inp
}

test_min_payout_flag if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels", "value": [object.union(base.land.parcels[0], {"area_ha": 0.05, "naturschutz": object.union(base.land.parcels[0].naturschutz, {"project_confirmation": {"present": true, "auflagen": ["GL01"], "earliest_mowing_date": "2026-07-15"}})})]},
		{"op": "replace", "path": "/farm/oepul/naturschutz/regional_plan/applied", "value": false},
	])
	premium.payment_may_be_withheld with input as inp
}

# --- Abwicklung ---
test_area_decrease_tolerance if {
	administration.repayment_area_ha == 0 with input as base
	inp := patched([{"op": "replace", "path": "/farm/oepul/naturschutz/area_previous_year_ha", "value": 12.0}])
	administration.repayment_area_ha == 9 with input as inp
}

test_area_decrease_lost_disposal_right if {
	inp := patched([
		{"op": "replace", "path": "/farm/oepul/naturschutz/area_previous_year_ha", "value": 12.0},
		{"op": "add", "path": "/farm/oepul/naturschutz/area_lost_disposal_right_ha", "value": 9.0},
	])
	administration.repayment_area_ha == 0 with input as inp
}

test_exit_repayment if {
	inp := patched([{"op": "add", "path": "/farm/oepul/naturschutz/exit", "value": {"exited": true, "exit_year": 2026}}])
	administration.repayment_of_granted_premiums with input as inp
	not administration.measure_valid_this_year with input as inp
	inp2 := json.patch(inp, [{"op": "add", "path": "/farm/oepul/naturschutz/exit/revision_clause_refusal", "value": true}])
	not administration.repayment_of_granted_premiums with input as inp2
}

test_switch_to_ebw_deadline if {
	inp := patched([{"op": "add", "path": "/farm/oepul/naturschutz/switch_to_ebw", "value": {"requested": true, "switch_date": "2026-12-31"}}])
	some v in o6_18.violations with input as inp
	v.rule_id == "O618-ADM-007"
}

test_switch_into_nat_table if {
	administration.switch_into_nat_allowed("4", "2025-12-31")
	not administration.switch_into_nat_allowed("K20", "2025-01-01")
}

test_takeover_deadline_2028 if {
	inp := patched([
		{"op": "replace", "path": "/farm/year", "value": 2028},
		{"op": "replace", "path": "/land/parcels/0/operations/cutting_dates", "value": ["2028-07-20"]},
		{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/earliest_mowing_date", "value": "2028-07-15"},
		{"op": "add", "path": "/farm/oepul/naturschutz/takeover", "value": {"requested": true, "date": "2028-04-16", "taken_over_area_ha": 2, "expansion_area_ha": 0}},
	])
	administration.takeover_deadline == "2028-04-17" with input as inp
	count([v | some v in o6_18.violations with input as inp; v.rule_id == "O618-ADM-008"]) == 0
}

test_takeover_expansion_limit if {
	inp := patched([{"op": "add", "path": "/farm/oepul/naturschutz/takeover", "value": {"requested": true, "date": "2026-04-01", "taken_over_area_ha": 2, "expansion_area_ha": 1.5}}])
	some v in o6_18.violations with input as inp
	v.rule_id == "O618-ADM-008"
}

test_sanctions if {
	administration.sanction_share("warning") == 0 with input as base
	inp := patched([{"op": "replace", "path": "/farm/year", "value": 2027}])
	administration.sanction_share("warning") == 0.01 with input as inp
	inp2 := patched([{"op": "add", "path": "/farm/oepul/naturschutz/hundred_percent_reductions_in_contract_period", "value": 2}])
	administration.excluded with input as inp2
}

test_access_failure_consequence if {
	inp := patched([{"op": "add", "path": "/farm/oepul/naturschutz/access_requirements_failed", "value": true}])
	administration.access_failure_consequence == "no_premium_this_year" with input as inp
}

test_third_party_fault_requires_op_code if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/naturschutz/noncompliance", "value": {"occurred": true, "third_party_fault": true}}])
	some v in o6_18.violations with input as inp
	v.rule_id == "O618-ADM-015"
}

# --- 2026-Hinweise ---
test_drought_div_exception_not_for_nat if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/naturschutz/drought_div_exception_used", "value": true}])
	has_violation(inp, "O618-N26-002")
}

test_third_use_nat_div_arable_2026 if {
	inp := patched([{"op": "replace", "path": "/land/parcels/1/operations/cutting_dates", "value": ["2026-06-01", "2026-07-01", "2026-08-15"]}])
	has_violation(inp, "O618-N26-003")
}

# --- Weitere Auflagen ---
test_fertilization_only_in_allowed_years if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen", "value": ["GA04", "GI12"]},
		{"op": "add", "path": "/land/parcels/0/naturschutz/project_confirmation/fertilization_allowed_years", "value": [2025, 2027]},
		{"op": "add", "path": "/land/parcels/0/naturschutz/fertilization_events", "value": [{"date": "2026-04-01", "type": "festmist"}]},
	])
	has_violation(inp, "O618-OBL-011S")
}

test_no_grazing_after_last_cut_nw11 if {
	inp := patched([
		{"op": "add", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen/-", "value": "NW11"},
		{"op": "add", "path": "/land/parcels/0/naturschutz/grazing_periods", "value": [{"start": "2026-09-01", "end": "2026-09-20", "animals": []}]},
	])
	has_violation(inp, "O618-OBL-011J")
}

test_second_use_date_gn02 if {
	inp := patched([
		{"op": "replace", "path": "/farm/year", "value": 2025},
		{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen", "value": ["GA04", "GN02"]},
		{"op": "add", "path": "/land/parcels/0/naturschutz/project_confirmation/second_use_earliest_date", "value": "2025-09-01"},
		{"op": "replace", "path": "/land/parcels/0/operations/cutting_dates", "value": ["2025-06-10", "2025-08-20"]},
	])
	has_violation(inp, "O618-OBL-011M")
}

test_early_first_mowing_gk02 if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen", "value": ["GA04", "GK02"]},
		{"op": "add", "path": "/land/parcels/0/naturschutz/project_confirmation/first_mowing_before_date", "value": "2026-05-20"},
		{"op": "replace", "path": "/land/parcels/0/operations/cutting_dates", "value": ["2026-06-01", "2026-08-01"]},
	])
	has_violation(inp, "O618-OBL-011N")
}

test_irrigation_and_silage_bans if {
	inp := patched([
		{"op": "add", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen/-", "value": "NA06"},
		{"op": "add", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen/-", "value": "NA22"},
		{"op": "add", "path": "/land/parcels/0/naturschutz/irrigation_used", "value": true},
		{"op": "add", "path": "/land/parcels/0/naturschutz/silage_produced", "value": true},
	])
	has_violation(inp, "O618-OBL-011O")
	has_violation(inp, "O618-OBL-011P")
}

test_grazing_window_wa03 if {
	inp := json.patch(weide_input([]), [{"op": "add", "path": "/land/parcels/0/naturschutz/project_confirmation/grazing_window_start", "value": "2026-06-15"}])
	has_violation(inp, "O618-OBL-011Q")
}

test_drainage_maintenance_gc01 if {
	inp := patched([
		{"op": "add", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen/-", "value": "GC03"},
		{"op": "add", "path": "/land/parcels/0/naturschutz/activities", "value": {"drainage_maintenance": true}},
	])
	has_violation(inp, "O618-OBL-011U")
}

test_combined_grazing_records if {
	inp := json.patch(weide_input([]), [{"op": "add", "path": "/land/parcels/0/naturschutz/grazing_diary/combined_with_other_plots", "value": true}])
	has_violation(inp, "O618-OBL-013")
}

test_habitat_requires_layer if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen/-", "value": "HG01"}])
	has_violation(inp, "O618-ELIG-016")
}

test_hg_surcharge if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/auflagen", "value": ["GA09", "HG01"]},
		{"op": "add", "path": "/land/parcels/0/naturschutz/habitat_layer_registered", "value": true},
		{"op": "add", "path": "/land/parcels/0/naturschutz/schutzgut_layer_share", "value": 0.6},
	])

	# (410,4 + 0 + 108) x 2 ha
	pp := premium.parcel_premium with input as inp
	pp.P1 == 1036.8
}

test_k20_not_combinable if {
	inp := patched([
		{"op": "replace", "path": "/farm/year", "value": 2024},
		{"op": "replace", "path": "/land/parcels/0/operations/cutting_dates", "value": ["2024-07-20"]},
		{"op": "replace", "path": "/land/parcels/0/naturschutz/project_confirmation/earliest_mowing_date", "value": "2024-07-15"},
		{"op": "replace", "path": "/land/parcels/1/naturschutz/project_confirmation/auflagen", "value": ["KA01"]},
		{"op": "add", "path": "/land/parcels/1/oepul/other_area_measures", "value": ["23"]},
	])
	has_violation(inp, "O618-KOMB-015")
}

test_missed_payment_claim if {
	inp := patched([{"op": "add", "path": "/farm/oepul/naturschutz/payment_claim_missed_since_year", "value": 2024}])
	administration.payment_claim_consequence == "obligation_ends_full_repayment" with input as inp
	inp2 := patched([{"op": "add", "path": "/farm/oepul/naturschutz/payment_claim_missed_since_year", "value": 2026}])
	administration.payment_claim_consequence == "obligation_remains_no_payment" with input as inp2
}

test_trial_area_needs_approval if {
	inp := patched([{"op": "replace", "path": "/land/parcels/0/oepul/codes", "value": ["NAT", "DIVSZ", "VF"]}])
	some v in o6_18.violations with input as inp
	v.rule_id == "O618-ADM-021"
	pp := premium.parcel_premium with input as inp
	pp.P1 == 0
}

test_drought_district_lists if {
	notices_2026.harvest_exemption_district with input as patched([{"op": "replace", "path": "/farm/region", "value": {"federal_state": "Wien", "district": "Favoriten"}}])
	not notices_2026.harvest_exemption_district with input as patched([{"op": "replace", "path": "/farm/region", "value": {"federal_state": "Steiermark", "district": "Liezen"}}])
}
