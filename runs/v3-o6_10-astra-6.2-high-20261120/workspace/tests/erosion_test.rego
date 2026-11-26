package oepul.o6_10_test

import data.oepul.o6_10 as policy
import rego.v1

vine := {"parcel_id": "W", "area_ha": 0.3, "slope_percent": 25, "crop": {"crop_category": "vineyard", "crop_name": "Wein"}, "oepul": {"excluded_crop_use": false, "in_at": true, "in_mfa": true, "claimed_for_measure": true, "wine_terrace": false, "codes": []}, "operations": {"erosion": {}}}
fruit := object.union(vine, {"parcel_id": "O", "area_ha": 0.2, "crop": {"crop_category": "orchard", "crop_name": "Apfel"}})
profile(y, parcels) := {"farm": {"year": y, "oepul": {"first_year": 2023, "active_measures": [], "organisation_program": false, "as_of": sprintf("%d-12-31", [y])}}, "land": {"parcels": parcels}}
with_cover(p, c) := object.union(p, {"operations": {"erosion": c}})
findings(p, y) := result if result := policy.parcel_findings with input as profile(y, [p])
ids(p, y) := {r.rule_id | some r in findings(p, y)}
quality := {"seedbed": true, "timing": true, "rate": true, "depth": true, "equipment": true, "crops": true}
obs := {"date": "2026-07-31", "special_system_width_impossible": false, "all_alleys_covered": true, "open_strip_cm": 80, "cereal_pct": 40, "maize_pct": 10, "oat_spring_barley_nurse_pct": 0}
observed(p, o) := with_cover(p, {"observations": [o], "events": []})
rate_for(p, y) := r if r := policy.base_rate(p) with input as profile(y, [p])

test_minimum_sum_across_crops if {
	p := object.union(vine, {"oepul": {"in_at": false}})
	policy.measure_area_ha == 0.5 with input as profile(2026, [vine, fruit, p])
	policy.meets_measure_minimum with input as profile(2026, [vine, fruit])
	policy.meets_measure_minimum == false with input as profile(2026, [vine])
}

test_minimum_unresolved_with_missing_evidence if {
	result := policy.assessment with input as profile(2026, [{"crop": {"crop_category": "vineyard"}}])
	not "measure_area_ha" in object.keys(result.access_checks)
}

test_first_farm_thresholds if {
	base := profile(2023, [vine, fruit])
	policy.farm_minimum with input as object.union(base, {"land": {"mfa_protected_ha": 0.5}})
	policy.farm_minimum with input as object.union(base, {"land": {"mfa_qualifying_ha": 1.5}})
	policy.farm_minimum == false with input as object.union(base, {"land": {"mfa_qualifying_ha": 1.49, "mfa_protected_ha": 0.49}})
	policy.farm_minimum with input as profile(2024, [vine])
}

test_legal_fruit_year_and_exclusions if {
	p := object.union(fruit, {"crop": {"crop_name": "Papau"}, "oepul": {"fruit_group": null}})
	policy.measure_area_ha == 0 with input as profile(2024, [p])
	policy.measure_area_ha == 0.2 with input as profile(2025, [p])
	nursery := object.union(vine, {"oepul": {"excluded_crop_use": true}})
	policy.measure_area_ha == 0 with input as profile(2026, [nursery])
}

test_application_and_exit if {
	a := {"previous_active": false, "control_announced_on": null, "onsite_on": null, "administrative_result_on": null, "applied_on": "2026-12-31", "withdrawn_on": null, "annual_mfa_with_units": true}
	policy.contract_route == "new_application" with input as object.union(profile(2027, [vine, fruit]), {"farm": {"oepul": {"contract": a}}})
	not policy.contract_route with input as object.union(profile(2028, [vine, fruit]), {"farm": {"oepul": {"contract": object.union(a, {"applied_on": "2027-12-31"})}}})
	b := object.union(a, {"previous_active": true, "withdrawn_on": "2028-12-31"})
	policy.contract_route == "withdrawn" with input as object.union(profile(2028, [vine, fruit]), {"farm": {"oepul": {"contract": b}}})
	policy.contract_route == "continuation" with input as object.union(profile(2028, [vine, fruit]), {"farm": {"oepul": {"contract": object.union(b, {"withdrawn_on": "2029-01-01"})}}})
}

test_takeover_limits if {
	a := {"previously_participating": false, "mfa_online": true, "ama_approved": true, "transferred_ha": 2, "additional_ha": 1, "applied_on": "2028-04-17"}
	policy.takeover_allowed with input as {"farm": {"year": 2028, "oepul": {"takeover": a}}}
	not policy.takeover_allowed with input as {"farm": {"year": 2028, "oepul": {"takeover": object.union(a, {"additional_ha": 1.01})}}}
	not policy.takeover_allowed with input as {"farm": {"year": 2028, "oepul": {"takeover": object.union(a, {"applied_on": "2028-04-18"})}}}
}

test_terrace_section_average_and_crop if {
	o := object.union(obs, {"all_alleys_covered": false})
	p := observed(object.union(vine, {"oepul": {"wine_terrace": true, "section_slope_pct": 25}, "slope_percent": 20}), o)
	ids(p, 2026) == set()
	"o6_10.alleys" in ids(object.union(p, {"oepul": {"section_slope_pct": 24.99}}), 2026)
	"o6_10.alleys" in ids(object.union(p, {"crop": fruit.crop}), 2026)
}

test_bare_strips_and_special_system if {
	ids(observed(vine, obs), 2026) == set()
	"o6_10.width" in ids(observed(vine, object.union(obs, {"open_strip_cm": 81})), 2026)
	ids(observed(fruit, object.union(obs, {"open_strip_cm": 100})), 2026) == set()
	"o6_10.width" in ids(observed(fruit, object.union(obs, {"open_strip_cm": 101})), 2026)
	wide := object.union(obs, {"special_system_width_impossible": true, "covered_pct": 60, "open_strip_cm": 125})
	ids(observed(vine, wide), 2026) == set()
	"o6_10.special_rows" in ids(observed(vine, object.union(wide, {"covered_pct": 59.9})), 2026)
}

test_seed_origin_species_and_companions if {
	ids(with_cover(vine, {"origin": "existing", "winter_hardy_partners": 1}), 2026) == set()
	"o6_10.sowing" in ids(with_cover(vine, {"origin": "sown", "winter_hardy_partners": 2}), 2026)
	ids(with_cover(vine, {"origin": "sown", "winter_hardy_partners": 3}), 2026) == set()
	"o6_10.spontaneous" in ids(with_cover(vine, {"origin": "spontaneous"}), 2026)
	"o6_10.mulch" in ids(with_cover(vine, {"origin": "organic_mulch"}), 2026)
	"o6_10.pure_grain" in ids(with_cover(vine, {"pure_seed": "Mais"}), 2026)
	ids(with_cover(vine, {"pure_seed": "Grünschnittroggen", "authorised_green_rye": true}), 2026) == set()
}

test_mix_is_combined_share_at_each_observation if {
	over := object.union(obs, {"date": "2026-08-03", "maize_pct": 11})
	"o6_10.share" in ids(with_cover(vine, {"observations": [obs, over]}), 2026)
	ids(observed(vine, object.union(over, {"oat_spring_barley_nurse_pct": 1})), 2026) == set()
}

test_drought_independent_causes_and_year if {
	o := object.union(obs, {"maize_pct": 20, "all_alleys_covered": false, "dry_emergence_gap": true, "sowing_quality": quality})
	ids(observed(vine, o), 2026) == {"o6_10.share"}
	relief := object.union(o, {"excess_due_to_volunteer_grain_and_dry_germination": true})
	ids(observed(vine, relief), 2026) == set()
	ids(observed(vine, object.union(relief, {"date": "2025-07-31"})), 2025) == {"o6_10.share", "o6_10.alleys"}
	ids(observed(vine, object.union(relief, {"sowing_quality": {"depth": false}})), 2026) == {"o6_10.share", "o6_10.alleys"}
}

test_reseeding_cutoffs if {
	policy.reseed_due({"kind": "break", "date": "2024-02-29"}) == "2024-04-25"
	policy.reseed_due({"kind": "clearing", "date": "2026-09-15"}) == "2026-10-01"
	policy.reseed_due({"kind": "clearing", "date": "2026-09-16"}) == "2027-05-15"
	policy.reseed_due({"kind": "break", "date": "2026-09-16"}) == "2026-10-01"
}

test_gap_and_overdue if {
	e := {"kind": "clearing", "date": "2025-09-16", "reseeded_on": null}
	o := object.union(obs, {"date": "2026-05-14", "all_alleys_covered": false})
	c := {"events": [e], "observations": [o]}
	ids(with_cover(vine, c), 2026) == {"o6_10.deadline"}
	ids(with_cover(vine, object.union(c, {"events": [object.union(e, {"reseeded_on": "2026-05-15"})]})), 2026) == set()
	ids(with_cover(vine, {"events": [object.union(e, {"reseeded_on": "2026-05-16"})]}), 2026) == {"o6_10.deadline"}
}

test_once_per_year_and_tillage if {
	e := {"kind": "break", "date": "2026-04-01", "reseeded_on": "2026-04-02"}
	c := {"events": [e, object.union(e, {"date": "2026-06-01", "reseeded_on": "2026-06-02"})], "tillage": [{"date": "2026-03-22", "destroyed_cover": true, "followed_by_reestablishment": false}]}
	ids(with_cover(vine, c), 2026) == {"o6_10.renewal", "o6_10.tillage"}
}

test_grazing_use_and_psm if {
	policy.grazing_allowed({"species": "sheep", "extensive_density": true, "main_crop_primary": true})
	policy.grazing_allowed({"species": "poultry", "year_round": false})
	ids(with_cover(vine, {"grazing": [{"species": "poultry", "year_round": true}], "mowings_removed": true, "psm_on_living_alley_cover": true, "nonmechanical_termination": true}), 2026) == {"o6_10.use", "o6_10.grazing", "o6_10.psm", "o6_10.mechanical"}
}

test_records_event_specific if {
	r := {"farm": "B", "field_number": "1", "field_name": "Obstgarten", "area_ha": 1}
	policy.missing_cover_records(r, []) == set()
	policy.missing_cover_records(r, ["clearing", "sowing"]) == {"cleared_on", "sown_on"}
	policy.missing_application_records({"amount": 2, "date": "2026-06-02", "reason": "Schadorganismus", "target": "Regulierung", "type": "Pheromon"}) == {"purchase_receipt"}
}

test_rate_boundaries if {
	every pair in [[0, 216], [24.99, 216], [25, 324], [34.99, 324], [35, 540], [49.99, 540], [50, 864], [75, 864]] {
		rate_for(object.union(vine, {"slope_percent": pair[0]}), 2025) == [pair[1], pair[1]]
	}
	rate_for(vine, 2024) == [270, 330]
	rate_for(fruit, 2026) == [378, 378]
	rate_for(object.union(fruit, {"slope_percent": 10}), 2023) == [180, 220]
	rate_for(object.union(vine, {"crop": {"crop_category": "hop"}, "slope_percent": null}), 2026) == [216, 216]
	not rate_for(object.union(vine, {"slope_percent": null}), 2026)
}

app := {"kind": "pheromone", "date": "2026-05-01", "register_rate_met": true, "replaces_psm": true}
eop := object.union(with_cover(vine, {"applications": [app]}), {"oepul": {"codes": ["EOP"]}})

test_eop_abolition_halving_and_program if {
	base := profile(2026, [eop])
	policy.supplement_rate(eop) == [162, 162] with input as base
	every measures in [["1B"], ["12"], ["1B", "12"]] {
		policy.supplement_rate(eop) == [81, 81] with input as object.union(base, {"farm": {"oepul": {"active_measures": measures}}})
	}
	policy.supplement_parcels == set() with input as object.union(base, {"farm": {"oepul": {"organisation_program": true}}})
	policy.supplement_parcels == set() with input as profile(2026, [with_cover(eop, {"applications": [object.union(app, {"replaces_psm": false})]})])
	policy.supplement_parcels == set() with input as profile(2026, [object.union(eop, {"oepul": {"codes": []}})])
}

test_matrix_and_modulation if {
	policy.combination("10", "1A").footnote == 1
	policy.combination("10", "12").footnote == 3
	policy.combination("10", "11").mark == "x"
	policy.combination("10", "18").mark == ""
	policy.modulation_factor(220) == 218 / 220
	policy.modulation_factor(1100) == 960 / 1100
}

test_caps_sanction_dates if {
	policy.cap_total("allgemein", 2024, {"10": 270, "1B": 1350}) == 1570
	policy.cap_total("allgemein", 2025, {"10": 324, "1B": 1200}) == 1300
	policy.sanction_options(2027).Verwarnungsstufe == 1
	policy.sanction_options(2026).Verwarnungsstufe == 0
}

test_parcel_exclusion_does_not_waive_management if {
	p := object.union(with_cover(eop, {"nonmechanical_termination": true}), {"oepul": {"national_park": "Donau-Auen"}})
	r := policy.assessment with input as profile(2026, [p])
	count(r.tariff_components_before_adjustments) == 0
	"o6_10.park" in ids(p, 2026)
	"o6_10.mechanical" in ids(p, 2026)
}

test_arable_notice_extension if {
	not policy.arable_drought_region("Steiermark", "Weiz", "2026-08-05")
	policy.arable_drought_region("Steiermark", "Weiz", "2026-08-12")
	policy.arable_drought_region("Wien", "Wien", "2026-08-05")
}

test_access_before_tariff_calculation if {
	base := profile(2026, [vine, fruit])
	r := policy.assessment with input as profile(2026, [vine])
	r.access_status == "excluded"
	r.tariff_components_before_adjustments == set()
	"o6_10.minimum" in r.access_findings
	policy.access_status == "unresolved" with input as base
	a := {"kind": "individual", "active_farmer": true, "agricultural_activity": true, "disposal_rights": true, "own_name_and_account": true, "public_share_pct": 0, "equivalent_or_indirect_public_control": false}
	ct := {"previous_active": true, "annual_mfa_with_units": true, "withdrawn_on": null, "ama_approved": true}
	complete := object.union(base, {"farm": {"oepul": {"applicant": a, "contract": ct}}})
	policy.access_status == "confirmed" with input as complete
	policy.access_status == "excluded" with input as object.union(complete, {"farm": {"oepul": {"contract": {"ama_approved": false}}}})
}

test_proven_minimum_with_unclassified_cultivar if {
	unknown := object.union(fruit, {"crop": {"crop_name": "Hofselektion"}})
	base := profile(2026, [vine, fruit, unknown])
	not policy.measure_area_ha with input as base
	policy.meets_measure_minimum with input as base
	not policy.meets_measure_minimum == false with input as profile(2026, [unknown])
}

test_control_dates_and_withdrawal if {
	a := {"withdrawn_on": "2026-06-20", "control_announced_on": null, "onsite_on": null, "administrative_result_on": null}
	base := {"farm": {"year": 2026}}
	policy.withdrawal_timing(a) == "clear" with input as base
	every key in ["control_announced_on", "onsite_on", "administrative_result_on"] {
		policy.withdrawal_timing(object.union(a, {key: "2026-06-20"})) == "unresolved" with input as base
		policy.withdrawal_timing(object.union(a, {key: "2026-06-21"})) == "clear" with input as base
		policy.contract_route == "withdrawal_after_control" with input as object.union(base, {"farm": {"oepul": {"contract": object.union(a, {key: "2026-06-19"})}}})
	}
}

test_partial_organic_exception_and_incompatible_parcel if {
	p := object.union(vine, {"oepul": {"same_area_measures": ["18", "1A", "K20"]}})
	base := profile(2024, [p])
	every partial, expected in {"yes": 0, "no": 1} {
		r := policy.assessment with input as object.union(base, {"farm": {"oepul": {"active_measures": ["1B", "12"], "partial_organic": partial == "yes"}}})
		count(r.farm_combination_conflicts) == expected
		{v.other | some v in r.parcel_combination_conflicts} == {"18", "K20"}
	}
}

test_exceptions_and_application_lists if {
	policy.requires_option_application("16", "Humusaufbau und Erosionsschutz in Wien")
	not policy.requires_option_application("10", "EOP")
	policy.management_exemption("K20", "K20", 2024)
	not policy.management_exemption("K20", "K20", 2025)
	not policy.management_exemption("BAW", "10", 2026)
	policy.catch_crop_variant(1, 2024).sow_by == "07-31"
	policy.catch_crop_variant(1, 2026).sow_by == "08-10"
	policy.catch_crop_variant(2, 2026).sow_by == "08-05"
}

test_missing_and_negative_supplement_evidence if {
	p := object.union(vine, {"oepul": {"codes": ["EOP"]}})
	not "o6_10.substitute" in policy.access_findings with input as profile(2026, [p])
	not "o6_10.substitute" in policy.access_findings with input as profile(2026, [with_cover(p, {"applications": [{"kind": "pheromone"}]})])
	"o6_10.substitute" in policy.access_findings with input as profile(2026, [with_cover(p, {"applications": []})])
}

test_reseed_records_from_actual_events if {
	r := {"field_number": "4", "field_name": "Ried", "area_ha": 0.3, "farm": "Hof"}
	e := {"kind": "clearing", "date": "2025-09-16", "reseeded_on": "2026-05-15"}
	f := policy.record_findings with input as profile(2026, [with_cover(vine, {"cover_record": r, "events": [e]})])
	f == {{"rule_id": "o6_10.records", "parcel_id": "W", "missing": {"sown_on"}}}
}

test_public_influence_boundaries if {
	a := {"kind": "legal_person", "equivalent_or_indirect_public_control": false, "public_share_pct": 25}
	policy.permitted_form(a) with input as profile(2025, [])
	not policy.permitted_form(object.union(a, {"public_share_pct": 25.01})) with input as profile(2025, [])
	policy.permitted_form(object.union(a, {"kind": "public", "public_share_pct": 100})) with input as profile(2024, [])
	not policy.permitted_form(object.union(a, {"equivalent_or_indirect_public_control": true})) with input as profile(2026, [])
}

test_cap_after_modulation_and_payment_parameters if {
	rows := [{"measure": "10", "eur_ha": 324}, {"measure": "10", "eur_ha": 81}, {"measure": "1B", "eur_ha": 990}]
	p := object.union(vine, {"oepul": {"payment_cap_group": "allgemein", "modulated_eur_ha_by_measure": rows}})
	base := object.union(profile(2026, [p]), {"farm": {"oepul": {"payment": {"administrative_checks_completed": true, "expected_eur": 1000, "calculated_eur": 50}}}})
	r := policy.assessment with input as base
	r.payment_parameters.parcel_caps.W == 1300
	r.payment_parameters.waiver_possible
	r.payment_parameters.advance_max_eur == 750
	r.payment_parameters.transfer_due == "2027-06-30"
}

test_documented_trial_code_and_rye_unknown if {
	p := object.union(vine, {"oepul": {"codes": ["VF"]}})
	"o6_10.trial" in ids(p, 2026)
	not "o6_10.pure_grain" in ids(with_cover(vine, {"pure_seed": "Grünschnittroggen"}), 2026)
	"o6_10.pure_grain" in ids(with_cover(vine, {"pure_seed": "Grünschnittroggen", "authorised_green_rye": false}), 2026)
}

test_unverifiable_control_and_explicit_refusal if {
	base := profile(2026, [vine, fruit])
	blocked := object.union(base, {"farm": {"oepul": {"control": {"onsite_prevented": true, "force_majeure_or_exceptional": false}}}})
	r := policy.assessment with input as blocked
	r.access_status == "excluded"
	r.tariff_components_before_adjustments == set()
	some f in r.administrative_findings
	f.rule_id == "o6_10.refusal"
	policy.administrative_findings == set() with input as object.union(blocked, {"farm": {"oepul": {"control": {"force_majeure_or_exceptional": true}}}})
}

test_individual_document_deadline_inclusive if {
	base := profile(2026, [vine])
	docs := [{"id": "A", "effective_due_on": "2026-06-15", "received_on": null}, {"id": "B", "effective_due_on": "2026-06-14", "received_on": "2026-06-15"}, {"id": "C", "effective_due_on": "2026-06-15", "received_on": "2026-06-15"}]
	r := policy.administrative_findings with input as object.union(base, {"farm": {"oepul": {"as_of": "2026-06-16", "requested_evidence": docs}}})
	{f.document | some f in r} == {"A", "B"}
}

test_transfer_exclusion_and_trial_evidence if {
	p := object.union(vine, {"oepul": {"transferred_during_year": true, "transferee_continued_to_year_end": false}})
	r := policy.assessment with input as profile(2026, [p, fruit])
	"o6_10.transfer" in {f.rule_id | some f in r.parcel_findings}
	not "W" in {f.parcel_id | some f in r.tariff_components_before_adjustments}
	q := object.union(vine, {"oepul": {"trial_prevents_compliance": true, "trial_documentation": {"area": false, "location": true}}})
	fs := policy.administrative_findings with input as profile(2026, [q])
	{"rule_id": "o6_10.trial", "parcel_id": "W", "missing": {"area"}} in fs
	{"rule_id": "o6_10.trial", "parcel_id": "W", "outcome": "code_VF_required"} in fs
}

test_permanent_event_on_15_april if {
	c := {"event_on": "2026-04-15", "kind": "permanent", "outside_control": true, "compliance_impossible": true, "reported_as_required": true, "force_majeure_or_exceptional": false, "cover_sown_on": null}
	p := object.union(vine, {"oepul": {"changed_circumstances": c}})
	r := policy.circumstance_review with input as profile(2026, [p])
	{f.outcome | some f in r} == {"early_termination_without_recovery_may_be_granted"}
	q := object.union(p, {"oepul": {"changed_circumstances": {"event_on": "2026-04-16"}}})
	rr := policy.circumstance_review with input as profile(2026, [q])
	count(rr) == 2
}

test_automatic_relief_reports_both_causes if {
	o := object.union(obs, {"all_alleys_covered": false, "dry_emergence_gap": true, "cereal_pct": 60, "sowing_quality": quality, "excess_due_to_volunteer_grain_and_dry_germination": true})
	r := policy.assessment with input as profile(2026, [observed(vine, o), fruit])
	{f.rule_id | some f in r.automatic_force_majeure; f.individual_report_required == false} == {"o6_10.drought_cover", "o6_10.drought_grain"}
}

test_partial_bio_supplement if {
	policy.supplement_rate(eop) == [81, 81] with input as object.union(profile(2026, [eop]), {"farm": {"oepul": {"active_measures": ["1B-Teilbetrieb"]}}})
}

test_mfa_application_on_programme_start if {
	a := {"applied_on": "2022-11-02", "withdrawn_on": null, "previous_active": false, "annual_mfa_with_units": true}
	b := object.union(profile(2023, [vine, fruit]), {"farm": {"oepul": {"contract": a}}})
	policy.contract_route == "new_application" with input as b
	not policy.contract_route == "new_application" with input as object.union(b, {"farm": {"oepul": {"contract": {"applied_on": "2022-11-01"}}}})
}

test_late_entry_and_alternative_route if {
	a := {"previous_active": false, "applied_on": "2026-01-01", "withdrawn_on": null, "annual_mfa_with_units": true}
	b := object.union(profile(2026, [vine, fruit]), {"farm": {"oepul": {"contract": object.union(a, {"takeover_requested": false})}}})
	policy.access_status == "excluded" with input as b
	policy.access_checks.ordinary_entry_timely == false with input as b
	tk := {"previously_participating": false, "mfa_online": true, "ama_approved": true, "transferred_ha": 0.5, "additional_ha": 0, "applied_on": "2026-04-15"}
	policy.contract_route == "takeover" with input as object.union(b, {"farm": {"oepul": {"takeover": tk}}})
	policy.restricted_takeover("9")
	not policy.restricted_takeover("10")
}

test_individual_form_without_capital_participation if {
	policy.permitted_form({"kind": "individual"}) with input as profile(2026, [])
}
