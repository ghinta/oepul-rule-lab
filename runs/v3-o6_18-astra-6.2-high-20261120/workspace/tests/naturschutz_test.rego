package oepul.o6_18_test

import data.oepul.o6_18 as nat
import rego.v1

parcel(n) := {"parcel_id": "P1", "land_use": "grassland", "area_ha": 1, "constraints": {"is_contract_nature_area": true}, "nature": n}
profile(p, y) := {"land": {"parcels": [p]}, "farm": {"year": y, "nature": {"measures": ["18", "1A"], "monitoring": []}}}

test_last_contract_day if {
	nat.timely_entry("NAT", 2025, "2024-12-31")
	not nat.timely_entry("NAT", 2025, "2025-01-01")
	not nat.timely_entry("NAT", 2026, "2025-01-01")
	nat.contract_years(2023) == 6
	nat.contract_years(2025) == 4
	nat.timely_entry("Regionaler Naturschutzplan", 2028, "2027-12-31")
	not nat.timely_entry("NAT", 2025, "2024-02-30")
}

test_general_minimum_first_year_and_later if {
	nat.minimum_size with input.farm as {"year": 2026, "nature": {"first_opul_year": 2026, "protected_cultivation_at_ha": 0.5}}
	not nat.minimum_size with input.farm as {"year": 2026, "nature": {"first_opul_year": 2026, "protected_cultivation_at_ha": 0.49, "qualifying_first_year_at_ha": 1.49}}
	nat.minimum_size with input.farm as {"year": 2026, "nature": {"first_opul_year": 2025}}
}

test_setaside_floor_and_share if {
	nat.eligible_setaside_ha(3, 6) == 2
	nat.eligible_setaside_ha(1.2, 4) == 1.2
	nat.eligible_setaside_ha(7, 20) == 5
}

test_change_and_takeover if {
	nat.takeover_window(2028, "2028-04-17")
	not nat.takeover_window(2027, "2027-04-16")
	nat.takeover_extent(4, 2)
	not nat.takeover_extent(4, 2.01)
	nat.switch_allowed("18", "19", 2026, "2025-12-31")
	not nat.switch_allowed("K20", "18", 2025, "2024-12-31")
}

test_loss_is_entire_difference if {
	nat.repayable_loss_ha(2, 0.5) == 0
	nat.repayable_loss_ha(2, 0.51) == 0.51
	nat.repayable_loss_ha(140, 5) == 0
	nat.repayable_loss_ha(140, 5.1) == 5.1
}

test_addition_not_per_year_and_bound_land if {
	nat.eligible_addition_ha(2025, 8, 40, 2) == 42
	nat.eligible_addition_ha(2026, 8, 8, 2) == 7
	nat.eligible_addition_ha(2027, 20, 22, 2) == 12
}

test_plan_once_even_with_ebw if {
	nat.regional_plan_rate == 270 with input.farm as {"year": 2026, "nature": {"measures": ["18", "19"], "plan_claimed": true, "plan_confirmed_year": 2026, "plan_withdrawn": false}}
	not nat.regional_plan_rate with input.farm as {"year": 2026, "nature": {"plan_claimed": true, "plan_confirmed_year": 2025, "plan_withdrawn": false}}
}

test_alias_and_transition if {
	nat.project_term("GE01", 2024) == nat.project_term("BC01", 2024)
	nat.project_term("GG03", 2024).eur_per_ha == 145.8
	nat.project_term("GG03", 2025).eur_per_ha == 291.6
	not nat.project_term("GA21", 2024)
	nat.project_term("GA21", 2025).eur_per_ha == 205.2
	not nat.project_term("GA01", 2023)
}

test_table_rates_and_supplements if {
	nat.code_rate(parcel({"arable_score": 50}), "SA01", 2024) == 540
	nat.code_rate(parcel({"arable_score": 50.1}), "SA01", 2024) == 615.6
	nat.code_rate(parcel({}), "GM01", 2025) == 108 with input.farm.nature.measures as ["3", "18"]
	not nat.code_rate(parcel({}), "SA01", 2024)
}

test_habitat_at_half if {
	p := parcel({"habitat_reported_by_state": true, "habitat_in_ama_gis": true, "habitat_species": ["Ziesel"], "protected_layer_percent": 50})
	nat.code_rate(p, "HG01", 2026) == 108
	not nat.habitat_eligible(parcel({"habitat_reported_by_state": true, "habitat_in_ama_gis": false, "habitat_types": ["6410"]}))
}

test_zero_unknown_and_equal_rates if {
	p := parcel({"project_codes": ["GI07", "NW12"]})
	nat.parcel_base_rate.P1 == 183.6 with input as profile(p, 2025)
	q := parcel({"project_codes": ["GA01", "GI23"]})
	nat.parcel_base_rate.P1 == 324 with input as profile(q, 2025)
	q2 := parcel({"project_codes": ["GA01", "UNKNOWN"]})
	not nat.parcel_base_rate.P1 with input as profile(q2, 2025)
}

test_gloez_subareas if {
	p := {"land_use": "arable", "area_ha": 4, "nature": {"gloez4_buffer_ha": 0.3, "gloez8_outside_buffer_ha": 0.8}}
	nat.net_area(p, 2024) == 2.9
	nat.net_area(p, 2025) == 3.7
}

test_limits_and_modulation if {
	nat.area_ceiling(2023) == 1300
	nat.area_ceiling(2024) == 1500
	nat.modulation_factor(220) == 218 / 220
	nat.modulation_factor(1100) == 960 / 1100
}

test_chapter_and_measure_cells if {
	p := parcel({"project_codes": ["SA01", "HG02", "TA01"]})
	pairs := nat.combination_issues with input as profile(p, 2026)
	["P1", "HG02", "SA01"] in pairs
	["P1", "SA01", "TA01"] in pairs
	nat.premium_combination("23", "Flächenprämie")
	nat.premium_combination("1A", "punktförmiges Landschaftselement")
	not nat.premium_combination("1A", "Flächenprämie")
	not nat.premium_combination("19", "Flächenprämie")
}

test_required_partner if {
	p := parcel({"project_codes": ["SB02", "GF02", "AC01", "AA06"]})
	issues := nat.combination_issues with input as profile(p, 2026)
	["P1", "SB02", "SA01 erforderlich"] in issues
	["P1", "GF02", "GE-Auflage erforderlich"] in issues
	["P1", "AA06", "AC01"] in issues
}

test_grass_div_credit if {
	p := parcel({"project_codes": ["GL36"], "declared_use": "Streuwiese", "mfa_codes": ["NAT", "DIVSZ"]})
	nat.div_credit(p) with input as profile(p, 2025)
	not nat.div_credit(p) with input.farm.nature.measures as ["18"]
	q := parcel({"project_codes": ["GL38"], "declared_use": "Streuwiese", "mfa_codes": ["NAT", "DIVSZ"]})
	not nat.div_credit(q) with input as profile(q, 2025)
}

test_arable_div_and_field_threshold if {
	p := {"land_use": "arable", "nature": {"project_codes": ["SA01", "SB02"], "declared_use": "Grünbrache", "mfa_codes": ["NAT", "DIV"]}}
	nat.div_credit(p) with input.farm.nature.measures as ["1B", "18"]
	nat.div_requirement(2) == 0
	nat.field_div_minimum(9.99, 7) == 0
	nat.field_div_minimum(10, 5) == 0
	nat.field_div_minimum(10, 5.01) == 0.15
}

test_project_violation_and_permitted_repair if {
	p := parcel({"sown_or_reseeded": true, "damage_repair": true, "prior_written_state_approval": true, "annual_uses": 4, "new_drainage": true, "care_or_use_count_two_years": 0})
	out := nat.parcel_issues with input as profile(p, 2026)
	["P1", "NAT.nutzungen"] in out
	["P1", "NAT.entwaesserung"] in out
	["P1", "NAT.pflege"] in out
	not ["P1", "NAT.saat"] in out
}

test_monitoring_and_diary if {
	p := parcel({"project_codes": ["GL06", "TB01"], "grazing_required": true, "diary_current": false, "diary_grouped": true, "same_grazing": true, "recognisable_unit": false})
	count(nat.monitoring_issues) == 2 with input as profile(p, 2026)
	count(nat.diary_issues) == 2 with input as profile(p, 2026)
}

test_august_exception_only_first_two if {
	p := parcel({})
	nat.earliest_use(p, 1, "2026-09-01") == "2026-08-12" with input.farm.year as 2026
	nat.earliest_use(p, 2, "2026-08-08") == "2026-08-08" with input.farm.year as 2026
	nat.earliest_use(p, 3, "2026-09-01") == "2026-09-01" with input.farm.year as 2026
	nat.earliest_use(p, 1, "2025-09-01") == "2025-09-01" with input.farm.year as 2025
}

test_drought_crop_and_district if {
	p := {"land_use": "arable", "nature": {"federal_state": "Steiermark", "district": "Weiz", "usual_late_summer_or_autumn_harvest": true, "heat_drought_sensitive": true, "no_harvestable_crop_due_to_drought": true}}
	nat.drought_harvest(p) with input.farm.year as 2026
	not nat.drought_harvest(p) with input.farm.year as 2025
	not nat.drought_area("Steiermark", "Liezen")
	nat.drought_area("Wien", "Donaustadt")
}

test_open_and_closed_annex_bounds if {
	p := parcel({"project_codes": ["GA04", "WA03"], "annual_observations": {"mowings_with_removal": 1, "rgve_per_ha_year": 0.5}})
	out := nat.project_issues with input as profile(p, 2025)
	out == {["P1", "GA04", "mowings_with_removal"]}
}

test_sanction_transition if {
	nat.sanction_schedule(2026).levels[0] == "Verwarnung"
	nat.sanction_schedule(2027).levels[0] == 1
}

test_timing_uses_actual_confirmation_and_event_order if {
	p := parcel({
		"project_codes": ["GL38"], "project_parameters": [{"code": "GL38", "parameter": "$1", "value": "2026"}, {"code": "GL38", "parameter": "$4", "value": "09-01"}],
		"operation_log": [{"kind": "Mahd", "date": "2026-08-11", "operation_ordinal": 1, "use_ordinal": 1}],
	})
	issues := nat.timing_issues with input as profile(p, 2026)
	["P1", "GL38", "Mahd", "2026-08-11"] in issues
	q := parcel(object.union(p.nature, {"operation_log": [{"kind": "Mahd", "date": "2026-08-12", "operation_ordinal": 1, "use_ordinal": 1}]}))
	count(nat.timing_issues) == 0 with input as profile(q, 2026)
}

test_drought_does_not_waive_project_prohibition if {
	p := parcel({
		"project_codes": ["AA03"], "project_parameters": [{"code": "AA03", "parameter": "$1", "value": "08-01"}, {"code": "AA03", "parameter": "$2", "value": "09-01"}],
		"operation_log": [{"kind": "Befahren", "date": "2026-09-01", "operation_ordinal": 1}],
	})
	issues := nat.timing_issues with input as profile(p, 2026)
	["P1", "AA03", "Befahren", "2026-09-01"] in issues
}

test_missing_project_parameter_is_visible if {
	p := parcel({"project_codes": ["GA13"], "project_parameters": []})
	missing := nat.information_needed with input as profile(p, 2025)
	["P1", "GA13", "$1"] in missing
}

test_banned_operation_and_partial_data if {
	p := object.union(parcel({"project_codes": ["AA04"]}), {"operations": {"psm_used": true}})
	out := nat.assessment with input as profile(p, 2026)
	["P1", "AA04", "pesticides_used"] in out.project_issues
	not ["P1", "NAT.projekt"] in out.parcel_issues
	["P1", "project_confirmed"] in out.information_needed
}

test_div_switch_dates if {
	nat.div_switch("DIVSZ", "DIVNFZ", "2026-06-15")
	not nat.div_switch("DIVSZ", "DIVNFZ", "2026-06-16")
	not nat.div_switch("DIVNFZ", "DIVSZ", "2026-05-01")
}

test_complete_program_matrices if {
	count(data.naturschutz.project_terms) == 334
	count(data.naturschutz.habitat_species) == 38
	every _, row in data.naturschutz.measure_matrix { count(row) == 21 }
	every a, row in data.naturschutz.chapter_matrix {
		count(row) == 8
		every b, cell in row { data.naturschutz.chapter_matrix[b][a] == cell }
	}
}

test_combined_setaside_uses_national_reference_and_gloez if {
	arable := {"parcel_id": "A", "land_use": "arable", "area_ha": 4, "nature": {"mfa_codes": ["NAT"], "project_codes": ["SA01", "SB02"], "gis_reference": true, "project_confirmed": true, "gloez4_buffer_ha": 0.5}}
	nat.calculated_setaside_limit_ha == 2 with input as {"farm": {"year": 2026}, "land": {"arable_area_ha": 8, "parcels": [arable]}}
}

test_applicant_public_share if {
	a := {"legal_form": "association", "public_share_percent": 25, "public_authority_or_institution": false, "own_name": true, "own_account": true, "controls_claimed_land": true, "active_farmer": true, "agricultural_activity": true}
	nat.applicant_eligible with input.farm.applicant as a
	not nat.applicant_eligible with input.farm.applicant as object.union(a, {"public_share_percent": 25.01})
}

test_drought_missing_values_do_not_fail_harvest if {
	p := object.union(parcel({"general_harvest_duty": true, "harvested_and_removed_percent": 70, "individual_force_majeure_accepted": false}), {"land_use": "arable"})
	count(nat.harvest_issues) == 0 with input as profile(p, 2026)
	count(nat.harvest_issues) == 1 with input as profile(p, 2025)
}

test_farm_minimum_distinguishes_absence_from_unknown if {
	a := {"farm": {"year": 2026, "nature": {"measures": ["18"]}}, "land": {"parcels": []}}
	["NAT.minschlag"] == sort(nat.farm_issues) with input as a
	p := parcel({})
	not "NAT.minschlag" in nat.farm_issues with input as profile(p, 2026)
}

test_payment_cap_including_point_elements if {
	nat.capped_area_amount(2023, 1.5, 1350) == 1950
	nat.capped_area_amount(2026, 2, 1550) == 3000
	nat.capped_area_amount(2026, 1.5, 1200) == 1800
}

test_groups_and_annex_matrix_footnotes if {
	"kein Getreide" in nat.crop_groups("Hirse", 2026)
	not "Obst" in nat.crop_groups("Papau", 2024)
	"Obst" in nat.crop_groups("Papau", 2025)
	nat.exceptional_takeover_only("Optionaler Zuschlag „Regionaler Naturschutzplan“ im Rahmen der Maßnahmen „Naturschutz“ oder „Ergebnisorientierte Bewirtschaftung“")
	nat.matrix_cell("18", "1B") == "x 1)"
}

test_parameter_limits_and_phytosanitary_exception if {
	p := parcel({"project_codes": ["NW05", "NO02"], "annual_observations": {"simultaneous_gve_ha": 1.1, "tree_count": 4}, "project_parameters": [{"code": "NW05", "parameter": "$", "value": "1"}, {"code": "NO02", "parameter": "$1", "value": "5"}], "official_phytosanitary_order": true})
	issues := nat.project_issues with input as profile(p, 2026)
	issues == {["P1", "NW05", "simultaneous_gve_ha"]}
}

test_nine_weeks_and_drought_scope if {
	p := parcel({"project_codes": ["GN03"], "uses": [{"ordinal": 1, "date": "2026-07-01"}, {"ordinal": 2, "date": "2026-09-01"}]})
	count(nat.project_issues) == 1 with input as profile(p, 2026)
	q := parcel({"project_codes": ["GN03"], "uses": [{"ordinal": 1, "date": "2026-07-01"}, {"ordinal": 2, "date": "2026-09-02"}]})
	count(nat.project_issues) == 0 with input as profile(q, 2026)
}

test_wet_area_floor_and_percent if {
	nat.wet_area_limit(0.1) == 0.05
	nat.wet_area_limit(1) == 0.15
	nat.wet_area_limit(0.02) == 0.02
}
