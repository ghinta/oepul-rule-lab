package oepul.o6_21_test

import data.oepul.o6_21 as rule
import rego.v1

steer(tag) := {
	"tag": tag, "birth_date": "2021-01-10", "breed": "Fleckvieh", "sex": "male",
	"periods": [{"first_day": "2024-01-01", "last_day": "2024-12-31", "country": "AT"}],
	"withdrawn_for_year": false, "animal_conditions_met": true, "overlap_claims": [],
}

farm(cattle) := {"farm": {"year": 2024, "oepul": {"home_area_ha": 220}}, "o6_21": {
	"cattle": cattle, "categories": ["male_6plus"], "dairy_delivery": false, "compost": {"requested": false},
}}

test_rate_and_modulation if {
	a := object.union(steer("AT1"), {"overlap_claims": ["Tierwohl – Weide", "Almbewirtschaftung"]})
	profile := farm([a, steer("AT2")])
	rule.annual_rgve == 2 with input as profile
	rule.minimum_participation_met with input as profile
	rule.base_amount_eur == 356.4 with input as profile
	amount := rule.modulated_tariff_eur with input as profile
	abs(amount - ((356.4 * 218) / 220)) < 0.000001
}

test_no_missing_register_as_zero if {
	not rule.annual_rgve == 0 with input as {"farm": {"year": 2026}}
	not rule.register_valid with input as farm([steer("x"), steer("x")])
	a := steer("AT1")
	repeated := object.union(a, {"periods": array.concat(a.periods, a.periods)})
	not rule.register_valid with input as farm([repeated])
}

test_tag_withdrawal_and_sale if {
	a := object.union(steer("sold"), {"periods": [{"country": "AT", "first_day": "2024-01-01", "last_day": "2024-06-30"}]})
	b := object.union(steer("withdrawn"), {"withdrawn_for_year": true})
	actual := rule.annual_rgve with input as farm([a, b])
	actual == 182 / 366
	not rule.minimum_participation_met with input as farm([a, b])
}

test_age_transition_and_year_clipping if {
	a := object.union(steer("AT3"), {"birth_date": "2023-09-01", "periods": [{"country": "AT", "first_day": "2023-12-01", "last_day": "2025-02-16"}]})
	result := rule.per_animal_rgve with input as farm([a]) with input.o6_21.categories as ["male_u6", "male_6plus"]
	result.AT3.male_u6 == (60 * 0.4) / 366
	result.AT3.male_6plus == (306 * 0.6) / 366
}

test_dwarf_and_female_upper_limit if {
	rule.rgve_per_head("Zwergzebu", 24) == 0.5
	rule.rgve_per_head("Kerry", 6) == 0.3
	rule.rgve_per_head("Dexter", 0) == 0.2
	rule.breed_class("Dahomey") == "dwarf"
	rule.category("female", 6) == "female_6_24"
	not rule.category("female", 24)
	rule.anniversary("2023-08-31", 6) == rule.day("2024-02-29")
}

test_milk_and_foreign_holdings if {
	a := object.union(steer("heifer"), {"birth_date": "2023-04-01", "sex": "female"})
	b := object.union(steer("abroad"), {"periods": [{"first_day": "2024-01-01", "last_day": "2024-12-31", "country": "DE"}]})
	result := rule.annual_rgve with input as farm([a, b]) with input.o6_21.categories as ["female_6_24", "male_6plus"] with input.o6_21.dairy_delivery as true
	result == 0
	rule.annual_rgve == 0.6 with input as farm([a, b]) with input.o6_21.categories as ["female_6_24"]
}

test_tgd_and_qplus_thresholds if {
	rule.tgd_met with input.o6_21.eligible_cattle_rgve as 10
	rule.tgd_required with input.o6_21.eligible_cattle_rgve as 10.01
	rule.qplus_required with input.o6_21.categories as ["female_u6"]
	not rule.qplus_required with input.o6_21.categories as ["male_6plus"]
	program := {"recognised": true, "start": "2023-04-15", "end": "2023-12-31"}
	rule.program_covers_year(program) with input.farm.year as 2023
	not rule.program_covers_year(object.union(program, {"start": "2023-04-16"})) with input.farm.year as 2023
	not rule.program_covers_year({"recognised": true, "start": "2024-04-15", "end": "2024-12-31"}) with input.farm.year as 2024
}

test_proof_responsibility if {
	"qplus" in rule.proof_outstanding with input.o6_21 as {"categories": ["female_u6"], "qplus": {"ama_requested": true, "transmitted_by_provider": false, "submitted": false}}
	not rule.proof_due({"ama_requested": true, "transmitted_by_provider": true})
}

test_entry_deadlines if {
	rule.entry_timely("category", "2026-12-31", 2027)
	not rule.entry_timely("category", "2027-01-01", 2027)
	not rule.entry_timely("category", "2027-12-01", 2028)
	rule.entry_timely("compost", "2027-12-31", 2028)
	not rule.entry_timely("compost", "2028-01-01", 2028)
}

pen(occupants, area, lying) := {
	"occupants": occupants, "surfaces": [{"area_m2": area, "paved": true, "access": "permanent"}],
	"bedded_lying_m2": lying, "suckler_cow_cubicle_system": false,
}

test_mixed_pen_and_cow_space if {
	p := pen([{"cow": true, "count": 12}, {"cow": false, "count": 12, "weight_kg": 300}], 108, 43.2)
	rule.space_need(p, "lying_m2", "upper") == 43.2
	rule.space_assessment(p) == "erfüllt"
	rule.space_assessment(object.union(p, {"bedded_lying_m2": 43.19})) == "unterschritten"
}

test_all_weight_classes if {
	every pair in [[150, 1.8], [220, 2.5], [350, 3], [499.99, 3.6], [500.01, 4.2]] {
		rule.space_rows({"cow": false, "weight_kg": pair[0]})[0].total_m2 == pair[1]
	}
	rule.max_occupancy(25.5, 501) == 6
	rule.max_occupancy(25.5, 149) == 14
}

test_ambiguous_weight if {
	group := [{"cow": false, "weight_kg": 500, "count": 1}]
	rule.space_assessment(pen(group, 4, 1.6)) == "Grenze 500 kg klären"
	rule.space_assessment(pen(group, 4.2, 1.68)) == "erfüllt"
	rule.space_assessment(pen(group, 3.59, 1.43)) == "unterschritten"
}

test_accessible_area if {
	rule.usable_area({"surfaces": [{"area_m2": 5, "paved": true, "access": "routine_work_only"}, {"area_m2": 8, "paved": true, "access": "restricted"}, {"area_m2": 12, "paved": false, "access": "permanent"}]}) == 5
}

test_bedding_thresholds if {
	p := {"perforation_pct": 5, "bedding_soft_absorbent": true, "lying_surface_soft_dry": true, "lying_base": "hard", "bedding_depth_cm": 3, "continuous_rebedding": true}
	rule.bedding_ok(p)
	not rule.bedding_ok(object.union(p, {"perforation_pct": 5.01}))
	not rule.bedding_ok(object.union(p, {"bedding_depth_cm": 2.99}))
}

test_cubicles if {
	p := {"suckler_cow_cubicle_system": true, "legal_total_space": true, "legal_cubicle_each_over_six_months": true, "calf_beds_always_accessible_free_lying": true, "calf_creep_bedded_m2": 4, "calf_required_total_m2": 10}
	rule.space_assessment(p) == "erfüllt"
	not rule.cubicle_space_ok(object.union(p, {"calf_creep_bedded_m2": 3.99}))
}

test_stall_definitions if {
	p := {"type": "ordinary", "wind_protected_sides": 3, "lying_area_roofed": true, "solid_floor": true, "floor_material": "concrete", "liquid_arises": false}
	rule.stable_structure(p)
	not rule.stable_structure(object.union(p, {"floor_material": "gravel"}))
	rule.stable_structure({"type": "open", "fixed_roof_over_beds": true, "impermeable_surface": true, "drain_to_collection_pit": true})
}

test_individual_housing_boundaries if {
	m := {"mode": "individual", "medical_necessity": true, "ill_or_injured": true, "duration_days": 10, "bedded": true}
	rule.housing_mode_ok(m)
	not rule.housing_mode_ok(object.union(m, {"duration_days": 11}))
	calf := {"mode": "individual", "bedded": true, "age_days_at_end": 20, "calf_social_contact": true, "meets_thvo": true}
	rule.housing_mode_ok(calf)
	not rule.housing_mode_ok(object.union(calf, {"age_days_at_end": 21}))
}

test_long_isolation_changes_annual_basis if {
	e := {"tag": "AT1", "mode": "individual", "participating_category": true, "medical_necessity": true, "ill_or_injured": true, "duration_days": 11}
	rule.annual_rgve == 1 with input as farm([steer("AT1"), steer("AT2")]) with input.o6_21.housing_events as [e]
}

test_stall_plans_and_grazing if {
	rule.plans_required with input.farm.year as 2024
	not rule.plans_required with input.farm.year as 2025
	rule.housing_mode_ok({"mode": "alpine", "compliant_home_stall": true, "actual_stabling_in_year": true})
	not rule.housing_mode_ok({"mode": "pasture", "compliant_home_stall": true, "actual_stabling_in_year": false})
}

turn(date) := {"date": date, "device": "turner", "on_farm_equipment": true}

test_compost_turning if {
	rule.heap_ok({"turns": [turn("2025-12-20"), turn("2026-01-03")]})
	not rule.heap_ok({"turns": [turn("2025-12-20"), turn("2026-01-02")]})
	not rule.turn_ok({"device": "front_loader", "on_farm_equipment": true})
	rule.turn_ok({"device": "spreader", "fully_turned": true, "equivalent_result": true, "external_use_documented": true})
}

test_mixed_heap_from_2025_only if {
	h := {"mixed_or_layered": true, "significant_added_field_or_woody_material": true, "composting_process": true}
	rule.heap_ok(h) with input.farm.year as 2025
	not rule.heap_ok(h) with input.farm.year as 2024
	not rule.heap_ok(object.union(h, {"significant_added_field_or_woody_material": false})) with input.farm.year as 2025
}

test_compost_supplement if {
	c := {"requested": true, "heaps": [{"turns": [turn("2024-05-01"), turn("2024-05-15")]}], "all_species_manure_on_farm_in_heaps": true, "compost_barn": false, "nitrate_rules_met": true, "records_complete": true}
	rule.compost_amount_eur == 43.2 with input as farm([steer("AT1"), steer("AT2")]) with input.o6_21.compost as c
	not rule.compost_ok with input.o6_21.compost as object.union(c, {"compost_barn": true})
}

test_controls_payments_and_entry_area if {
	rule.sanction_percent(2026, "warning") == 0
	rule.sanction_percent(2027, "warning") == 1
	rule.size_met with input.farm.oepul as {"participation_year_number": 1, "protected_cultivation_at_ha": 0.5}
	not rule.size_met with input.farm.oepul as {"participation_year_number": 1, "qualifying_at_ha": 1.49}
	rule.size_met with input.farm.oepul as {"participation_year_number": 2}
	rule.maximum_advance == 75 with input.farm.oepul as {"administrative_checks_complete": true, "expected_premium_eur": 100}
}

test_no_premium_for_empty_category if {
	result := rule.expired_categories with input as farm([])
	result == {"male_6plus"}
}

test_evidenced_deficiency_in_occupied_pen if {
	p := object.union(pen([{"cow": false, "weight_kg": 510, "count": 2}], 8, 3.36), {"id": "Box A"})
	e := {"tag": "AT1", "mode": "group", "bedded": true, "participating_category": true, "pen_id": "Box A"}
	actual := rule.assessment with input as farm([steer("AT1"), steer("AT2")]) with input.o6_21.pens as [p] with input.o6_21.housing_events as [e]
	actual.abzumeldende_ohrmarken == {"AT1"}
	actual.jahresdurchschnitt_rgve == 1
}

test_2023_and_higher_modulation_bands if {
	rule.rates == {"from_year": 2023, "through_year": 2023, "basic": 180, "reduced": 150, "compost": 20} with input.farm.year as 2023
	rule.modulation_factor(1300) == (((200 + 90) + 595) + 225) / 1300
}

test_context_does_not_extend_cattle_deadlines if {
	not rule.combination_cell("21", "20")
	rule.combination_cell("1B", "16").entry == "a"
	rule.combination_cell("1A", "18").entry == "x 1)"
	rule.combination_cell("1C", "1A").entry == ""
	rule.drought_harvest_waiver({"state": "Steiermark", "district": "Weiz", "drought_no_harvest": true, "normally_late_summer_or_autumn": true}, 2026)
	not rule.drought_harvest_waiver({"state": "Steiermark", "district": "Liezen", "drought_no_harvest": true, "normally_late_summer_or_autumn": true}, 2026)
}

test_general_tables_and_takeover if {
	rule.crop_groups("Felsenbirne", 2024) == set()
	rule.crop_groups("Felsenbirne", 2025) == {"Obst"}
	rule.annex_units("Schafe", "Schafe ab 1 Jahr", 10) == 1.5
	rule.takeover_reviewable with input.o6_21.takeover as {"event": "Betriebsteilung", "same_previous_farm": true, "online_mfa_submitted": true}
	not rule.takeover_reviewable with input.o6_21.takeover as {"event": "Betriebsteilung", "same_previous_farm": false, "online_mfa_submitted": true}
	rule.farm_conflict("6", "7", true)
	not rule.farm_conflict("2", "1B", true)
}

test_program_missing_or_late_and_mfa_lapse if {
	not rule.membership_status({})
	rule.membership_status({"recognised": false}) == "nicht erfüllt"
	rule.membership_status({"recognised": true, "start": "2026-01-02", "end": "2026-12-31"}) == "nicht erfüllt" with input.farm.year as 2026
	"Online-Korrektur und schriftliches Ersuchen erforderlich" in rule.contract_effects with input.farm.year as 2026 with input.o6_21 as {"previous_status": "category_empty", "immediate_reentry": true, "reentry_application_date": "2026-01-12"}
}

test_historical_pen_plan_scope if {
	p := {"id": "K1", "participating_categories": ["male_u6"]}
	missing := rule.plan_missing with input.farm.year as 2024 with input.o6_21.pens as [p] with input.documentation.o6_21_pen_plans as []
	missing == {{"pen_id": "K1", "category": "male_u6"}}
	rule.plan_missing == set() with input.farm.year as 2025 with input.o6_21.pens as [p] with input.documentation.o6_21_pen_plans as []
}

test_threshold_across_categories if {
	m := object.union(steer("M"), {"birth_date": "2023-12-31"})
	old := steer("O")
	h := object.union(steer("H"), {"sex": "female", "birth_date": "2023-07-01"})
	profile := farm([m, old, h])
	rule.minimum_participation_met with input as profile with input.o6_21.categories as ["male_u6", "male_6plus", "female_6_24"]
	not rule.minimum_participation_met with input as profile with input.o6_21.categories as ["male_u6", "male_6plus"]
}

test_held_back_surface_flagged_even_when_remaining_area_sufficient if {
	rest := pen([{"cow": false, "weight_kg": 501, "count": 1}], 10, 3)
	p := object.union(rest, {"id": "K2", "surfaces": array.concat(rest.surfaces, [{"area_m2": 2, "paved": true, "access": "restricted"}])})
	rule.space_assessment(p) == "erfüllt"
	"K2" in rule.restricted_pens with input.o6_21.pens as [p]
}
