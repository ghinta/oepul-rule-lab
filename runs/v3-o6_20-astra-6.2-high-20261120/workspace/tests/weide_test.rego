package oepul.o6_20_test

import data.oepul.o6_20 as w
import rego.v1

season := {"start": "2026-04-01", "end": "2026-10-31"}
stay := object.union(season, {"farm_id": "A", "country": "AT"})
cow := {"id": "r1", "species": "cattle", "sex": "female", "breed": "Fleckvieh", "birth_date": "2022-06-01", "stays": [stay], "grazing": [season], "interruptions": [], "withdrawn_categories": [], "alpine": true, "coupled": true}
second := object.union(cow, {"id": "r2", "alpine": false, "coupled": false})
base := {"farm": {"farm_id": "A", "year": 2026, "weide_categories": [{"category": "cow", "bonus": true}]}, "livestock": {"weide_animals": [cow, second], "weide_count_claims": []}, "land": {"home_mfa_ha": 220}}

test_two_rgve_half_base_only if {
	w.total_rgve == 2 with input as base
	w.farm_minimum with input as base
	w.gross_band == {"min": 92, "max": 138} with input as base
	out := w.modulated_band with input as base
	round(out.min * 100) == 9116
}

test_threshold_not_per_category if {
	bull := object.union(second, {"sex": "male"})
	f := object.union(base.farm, {"weide_categories": [{"category": "bull", "bonus": false}, {"category": "cow", "bonus": true}]})
	w.farm_minimum with input as base with input.farm as f with input.livestock.weide_animals as [cow, bull]
}

test_below_minimum_no_gross_band if {
	not w.farm_minimum with input as base with input.livestock.weide_animals as [cow]
	not w.gross_band with input as base with input.livestock.weide_animals as [cow]
}

test_period_clipping_and_no_double_count if {
	a := object.union(cow, {"grazing": [{"start": "2026-03-01", "end": "2026-04-10"}, {"start": "2026-04-05", "end": "2026-04-15"}], "interruptions": [{"start": "2026-04-06", "end": "2026-04-08"}]})
	days := w.grazing_days(a, "cow") with input as base
	count(days) == 12
}

test_minimum_grazing_exact_and_one_short if {
	a := object.union(cow, {"grazing": [{"start": "2026-04-01", "end": "2026-07-29"}]})
	x := [{"category": "cow", "bonus": false}]
	w.individual_rgve(a, "cow") == 1 with input as base with input.farm.weide_categories as x
	a2 := object.union(a, {"interruptions": [{"start": "2026-06-20", "end": "2026-06-20"}]})
	not w.individual_rgve(a2, "cow") with input as base with input.farm.weide_categories as x
	not w.individual_rgve(a, "cow") with input as base
}

test_new_heifers_source_example if {
	a := object.union(cow, {"birth_date": "2025-04-09", "stays": [object.union(stay, {"start": "2026-04-10"})]})
	x := [{"category": "heifer", "bonus": false}]
	v := w.individual_rgve(a, "heifer") with input as base with input.farm.weide_categories as x
	round((v * 5) * 100) == 287
}

test_half_year_and_two_year_boundary if {
	a := object.union(cow, {"birth_date": "2024-06-10"})
	not w.category(a, w.day("2024-12-09"))
	w.category(a, w.day("2024-12-10")) == "heifer"
	w.category(a, w.day("2026-06-09")) == "heifer"
	w.category(a, w.day("2026-06-10")) == "cow"
}

test_female_category_transition_same_animal if {
	a := object.union(cow, {"birth_date": "2024-07-10", "stays": [object.union(stay, {"start": "2026-04-20", "end": "2026-09-20"})]})
	xs := [{"category": "heifer", "bonus": true}, {"category": "cow", "bonus": true}]
	every c in {"cow", "heifer"} { w.presence_ok(c) with input as base with input.farm.weide_categories as xs with input.livestock.weide_animals as [a] }
	not w.presence_ok("cow") with input as base with input.livestock.weide_animals as [a]
}

test_no_pooling_concurrent_cattle_days if {
	a := object.union(cow, {"stays": [object.union(stay, {"end": "2026-06-15"})]})
	not w.presence_ok("cow") with input as base with input.livestock.weide_animals as [a, object.union(a, {"id": "other"})]
}

test_structure_and_country if {
	a := object.union(cow, {"stays": [object.union(stay, {"end": "2026-05-31"}), object.union(stay, {"start": "2026-06-01", "farm_id": "B"}), object.union(stay, {"country": "DE"})]})
	days := w.registered_days(a, "cow") with input as base
	count(days) == 61
}

test_sheep_late_report if {
	a := object.union(cow, {"species": "goat", "stays": [object.union(stay, {"start": "2026-06-06", "reported_on": "2026-06-23"})]})
	d := w.registered_days(a, "doe") with input as base
	min(d) == w.day("2026-06-16")
	count(d) == 138
	v := w.individual_rgve(a, "doe") with input as base with input.farm.weide_categories as [{"category": "doe", "bonus": false}]
	round((v * 2) * 100) == 19
}

test_sheep_age_report_and_seven_day_limit if {
	w.credit_start("2026-05-03", "2026-05-10") == w.day("2026-05-03")
	w.credit_start("2026-05-03", "2026-05-11") == w.day("2026-05-04")
	w.movement_deadline("2026-10-30") == w.day("2026-10-31") with input as base
	not w.movement_deadline("2026-11-01") with input as base
}

test_cattle_exit_prorated_only_if_out_with_group if {
	a := object.union(cow, {"stays": [object.union(stay, {"end": "2026-05-31"})], "short_reason_by_category": {"cow": "registered_departure"}, "group_grazing": {"cow": [season]}})
	v := w.individual_rgve(a, "cow") with input as base
	round(v * 214) == 61
	missed := object.union(a, {"interruptions": [{"start": "2026-04-02", "end": "2026-04-02"}]})
	not w.individual_rgve(missed, "cow") with input as base
}

test_withdrawn_cattle_never_paid if {
	a := object.union(cow, {"withdrawn_categories": ["cow"]})
	not w.individual_rgve(a, "cow") with input as base
}

test_rgve_classes if {
	every b in {"Dahomey", "Dexter", "Kerry", "Zwergzebu"} { w.factor(object.union(cow, {"breed": b}), w.day("2026-04-01")) == 0.5 }
	a := {"species": "equid", "breed_height_m": 1.48, "breed_adult_kg": 300, "birth_date": "2023-05-01"}
	w.factor(a, w.day("2026-04-30")) == 0.3
	w.factor(a, w.day("2026-05-01")) == 0.5
	w.factor(object.union(a, {"breed_adult_kg": 301}), w.day("2026-05-01")) == 1
	w.factor(object.union(a, {"breed_height_m": 1.49}), w.day("2026-04-30")) == 0.6
}

test_replacement_combined_days_no_expansion if {
	x := [{"category": "camelid", "bonus": true}]
	a := object.union(cow, {"species": "camelid", "stays": [object.union(stay, {"end": "2026-06-30"})], "departure_reason": "sale"})
	b := object.union(second, {"species": "camelid", "birth_date": "2025-07-01"})
	line := {"category": "camelid", "band": "camelid_12", "slots": [[a.id, b.id]], "filed_on": "2026-04-15", "applied_count": 1}
	w.payable_count(line) == 1 with input as base with input.farm.weide_categories as x with input.livestock.weide_animals as [a, b] with input.livestock.weide_count_claims as [line]
	not w.replacement_ok(object.union(a, {"departure_reason": "other"}), b, "camelid") with input as base
	not w.payable_count(object.union(line, {"filed_on": "2026-04-16"})) with input as base
}

test_april_deadlines_and_last_entry if {
	w.april_deadline(2023) == "2023-04-17"
	w.april_deadline(2026) == "2026-04-15"
	w.april_deadline(2028) == "2028-04-17"
	w.entry_on_time(2027, "2026-12-31")
	not w.entry_on_time(2027, "2027-01-01")
	not w.entry_on_time(2028, "2027-12-31")
}

test_birth_exception if {
	w.birth_group_ok(160, 10, true, true)
	not w.birth_group_ok(159, 10, true, true)
	not w.birth_group_ok(130, 10, false, false)
}

test_shelter_rapid_transfer_and_feed if {
	p := {"weide_participating": true, "water_availability": true, "shelter": false, "rapid_return": true, "forage_predominantly_grazed": false, "substantial_day_or_night": true}
	f := w.welfare_findings with input.livestock.species_groups as [{"housing": {"pasture": p}}]
	f == {{"group": 0, "obligation": "forage_predominantly_grazed"}}
}

test_modulation_all_tiers if {
	w.modulation(200) == 1
	round(w.modulation(220) * 10000) == 9909
	round(w.modulation(1200) * 1200) == 1035
}

test_general_access if {
	w.area_ok with input.farm.oepul_participation_year as 1 with input.land.protected_at_ha as 0.5
	not w.area_ok with input.farm.oepul_participation_year as 1 with input.land.qualifying_at_ha as 1.49
	w.area_ok with input.farm.oepul_participation_year as 2
	w.applicant_form_ok("territorial_authority")
	w.sanction_rate(2026, "warning") == 0
	w.sanction_rate(2027, "warning") == 1
}

test_drought_scope if {
	w.harvest_area_exception(2026, "Steiermark", "Weiz", true, true)
	not w.harvest_area_exception(2026, "Steiermark", "Liezen", true, true)
	not w.harvest_area_exception(2027, "Burgenland", "Eisenstadt", true, true)
	w.required_days(true) == 150
}

test_assessment_renewal_and_withdrawal if {
	x := {"category": "cow", "bonus": true, "bonus_filed_on": "2026-04-15", "eligible_previous_year": true, "renewal": true, "payment_application_filed": true, "withdrawal_on": null}
	app := {"form": "territorial_authority", "active_farmer": true, "agricultural_activity": true, "own_account": true, "own_name": true, "land_control": true}
	f := object.union(base.farm, {"applicant": app, "oepul_participation_year": 2, "weide_categories": [x]})
	z := w.assessment with input as base with input.farm as f
	z.rgve == 2
	z.minimum_met
	withdrawn := object.union(x, {"withdrawal_on": "2026-12-31"})
	z2 := w.assessment with input as base with input.farm as f with input.farm.weide_categories as [withdrawn]
	z2.rgve == 0
	z2.modulated_range_before_sanctions_eur.min == 0
}

test_bonus_late_or_removed_preserves_base if {
	x := {"category": "cow", "bonus": true, "bonus_filed_on": "2026-04-16", "renewal": true, "eligible_previous_year": true, "withdrawal_on": null, "payment_application_filed": true}
	xs := w.effective_claims with input as base with input.farm.weide_categories as [x]
	count(xs) == 1
	xs[0].bonus == false
	w.effective_bonus(object.union(x, {"bonus_filed_on": "2026-04-05", "bonus_removed": true})) == false with input as base
}

test_qualifying_female_across_categories_without_separate_notice if {
	a := object.union(cow, {"birth_date": "2024-07-18"})
	xs := [{"category": "heifer", "bonus": true}, {"category": "cow", "bonus": true}]
	v := w.individual_rgve(a, "heifer") with input as base with input.farm.weide_categories as xs
	round((v * 214) * 10) == 648
	u := w.individual_rgve(a, "cow") with input as base with input.farm.weide_categories as xs
	round(u * 214) == 106
}

test_closed_lists_and_matrix if {
	w.crop_group("Pak Choi", 2026) == "Feldgemüse"
	not w.crop_group("Papau", 2024)
	w.crop_group("Papau", 2025) == "Obst"
	w.parcel_combination("1B", "16").mark == "a"
	w.parcel_combination("4", "1A").footnotes["1"]
	not w.parcel_combination("20", "14")
	w.hectare_cap("13", 2024).eur_ha == 2160
	w.contract_term("20", 2027) == 1
	w.contract_term("1A", 2024) == 5
	w.switch_allowed("2", "1B", "2025-12-31")
	not w.switch_allowed("20", "1B", "2025-12-31")
}

test_overlap_at_replacement if {
	a := object.union(cow, {"species": "camelid", "stays": [object.union(stay, {"end": "2026-06-30"})], "departure_reason": "death"})
	b := object.union(second, {"species": "camelid", "birth_date": "2025-06-01"})
	w.replacement_ok(a, b, "camelid") with input as base
	not w.after_predecessor(["r1", "r2"], 1, w.day("2026-06-30"), "camelid") with input as base with input.livestock.weide_animals as [a, b]
	w.after_predecessor(["r1", "r2"], 1, w.day("2026-07-01"), "camelid") with input as base with input.livestock.weide_animals as [a, b]
}

test_drought_and_diary if {
	w.drought_review with input.farm.year as 2026 with input.farm.weide_drought as {"affected": true, "on_site_control": true}
	not w.drought_review with input.farm.year as 2027 with input.farm.weide_drought as {"affected": true, "on_site_control": true}
	e := {"group": "alle", "places": ["A", "B"], "start": "2026-04-01", "end": "2026-09-30", "significant_changes": [{"date": "2026-04-20", "recorded_on": "2026-04-21"}], "interruptions": []}
	f := w.diary_findings with input.documentation.weide_diary as [e]
	f == {{"entry": 0, "field": "change_recorded_on"}}
}

test_movement_and_vis_independent if {
	a := {"species": "goat", "type": "sale", "date": "2026-06-06", "reported_on": "2026-06-15", "animal_id": "Z1", "vis_reported": false, "alpine_or_common": true}
	f := w.movement_findings with input as base with input.livestock.weide_movements as [a]
	{"animal": "Z1", "action": "verspaetete_Beilagenmeldung", "deadline": "2026-06-13"} in f
	{"animal": "Z1", "action": "Abtrieb_automatisch"} in f
	{"animal": "Z1", "action": "VIS_Tierbewegung_melden"} in w.vis_findings with input as base with input.livestock.weide_movements as [a]
	pasture := object.union(a, {"type": "pasture", "temporary_pasture": true, "control_retained_or_temporary_care": true})
	w.movement_action(pasture) == "nur_Weidetagebuch" with input as base
}

test_sanction_and_prepayment if {
	w.sanction_effect(2027, "warning", 0).reduction_percent == 1
	w.sanction_effect(2026, "cut_100", 2).reclaim_contract_premiums
	w.advance_limit(100, true) == 75
	not w.advance_limit(100, false)
}

test_site_obligations_scoped_to_project_code if {
	w.div_requirements("DIVNFZ").rest_after_first_use_days == 63
	w.div_requirements("DIVNFZ").drought_2026_rest_with_op_days == 49
	w.project_pasture("WA03", 0.5, "2026-06-20", "2026-06-20", "2026-08-31", false, false)
	not w.project_pasture("WA03", 0.51, "2026-06-20", "2026-06-20", "2026-08-31", false, false)
	not w.project_pasture("WA01", 0.8, "2026-06-19", "2026-06-20", "2026-08-31", false, false)
}

test_general_density_does_not_replace_measure_minimum if {
	w.livestock_density_ok(1.5, 5)
	not w.farm_minimum with input as base with input.livestock.weide_animals as [cow]
}
