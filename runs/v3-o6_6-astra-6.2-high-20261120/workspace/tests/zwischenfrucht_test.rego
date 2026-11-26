package oepul.o6_6_test

import data.oepul.o6_6 as zwf
import rego.v1

cover(v, s) := {"claimed": true, "is_used": true, "variant": v, "sowing_date": s, "undersown": false, "active_sowing": true}
profile(c, y) := {"farm": {"year": y}, "land": {"arable_area_ha": 1.5, "parcels": [{"parcel_id": "A", "land_use": "arable", "operations": {"cover_crop": c}}]}}

has_rule(c, y, rule) if {
	results := zwf.findings with input as profile(c, y)
	{"parcel_id": "A", "rule_id": rule} in results
}

event_fails(c, y, e, id) if has_rule(object.union(c, {"events": [e]}), y, id)

test_historical_v1 if {
	zwf.break_from(cover(1, "2024-07-31"), 2024) == "2024-10-10"
	has_rule(cover(1, "2024-08-01"), 2024, "zwf.variante.1.2023")
}

test_v1_calendar_examples if {
	zwf.break_from(cover(1, "2025-08-10"), 2025) == "2025-10-19"
	zwf.break_from(cover(1, "2026-07-07"), 2026) == "2026-09-15"
	zwf.break_from(cover(1, "2026-06-15"), 2026) == "2026-09-15"
}

test_undersowing_harvest_starts_clock if {
	c := object.union(cover(1, "2026-05-01"), {"undersown": true, "harvest_date": "2026-08-10"})
	zwf.established(c) == "2026-08-10"
	zwf.break_from(c, 2026) == "2026-10-19"
}

test_exact_boundaries_all_variants if {
	rows := [[1, "08-10", "2026-10-19"], [2, "08-05", "2027-02-15"], [3, "08-20", "2026-11-15"], [4, "08-31", "2027-02-15"], [5, "09-20", "2027-03-01"], [6, "10-15", "2027-03-21"], [7, "09-15", "2027-01-31"]]
	every r in rows {
		c := cover(r[0], concat("", ["2026-", r[1]]))
		zwf.break_from(c, 2026) == r[2]
	}
}

test_v3_thresholds if {
	c := object.union(cover(3, "2026-08-20"), {"cereal_maize_pct": 50, "break_date": "2026-11-15"})
	not has_rule(c, 2026, "zwf.getreideanteil")
	not has_rule(c, 2026, "zwf.variante.3.2023")
	has_rule(object.union(c, {"break_date": "2026-11-14"}), 2026, "zwf.variante.3.2023")
	has_rule(object.union(c, {"cereal_maize_pct": 50.01}), 2026, "zwf.getreideanteil")
}

test_unique_partners_and_families if {
	a := {"species": "Erbse", "family": "Fabaceae"}
	b := {"species": "Senf", "family": "Brassicaceae"}
	c := {"species": "Kresse", "family": "Brassicaceae"}
	zwf.mixture_ok({"variant": 3, "components": [a, b, c]}, 2026)
	not zwf.mixture_ok({"variant": 3, "components": [a, b, b]}, 2026)
	not zwf.mixture_ok({"variant": 2, "components": [a, b, c]}, 2026)
}

test_bee_components_and_share if {
	c := cover(1, "2025-08-10")
	zwf.insect_partner({"species": "Wilde Möhre"})
	not zwf.insect_partner({"species": "Gras", "insect_pollinated": false})
	not has_rule(object.union(c, {"non_insect_pct": 9.99}), 2025, "zwf.v1.beimischung")
	has_rule(object.union(c, {"non_insect_pct": 10}), 2025, "zwf.v1.beimischung")
}

test_winter_species_and_seed_provenance if {
	rye := {"species": "Grünschnittroggen", "variety": "V Kruppa József", "winter_hardy": true, "farm_saved": true, "propagation_proof": true}
	zwf.v6_component(rye)
	not zwf.v6_component(object.union(rye, {"propagation_proof": false}))
	zwf.v6_component({"species": "Perko", "winter_hardy": true})
	not zwf.mixture_ok({"variant": 6, "components": [rye, {"species": "Senf", "winter_hardy": true}]}, 2025)
}

test_no_n_at_sowing_and_winter_cutoff if {
	c := cover(4, "2026-08-21")
	event_fails(c, 2026, {"date": "2026-08-21", "kind": "mineral_n"}, "zwf.stickstoff")
	event_fails(c, 2026, {"date": "2027-02-14", "kind": "mineral_n"}, "zwf.stickstoff")
	not event_fails(c, 2026, {"date": "2027-02-15", "kind": "mineral_n"}, "zwf.stickstoff")
	event_fails(c, 2026, {"date": "2027-01-01", "kind": "slug_pellets"}, "zwf.psm")
}

test_rape_four_leaf_stage if {
	c := cover(7, "2026-09-15")
	e := {"kind": "herbicide", "date": "2026-10-01", "approved_for_rape": true, "rape_leaves": 4, "damages_companion": false}
	not event_fails(c, 2026, e, "zwf.v7.psm")
	event_fails(c, 2026, object.union(e, {"rape_leaves": 5}), "zwf.v7.psm")
	event_fails(c, 2026, object.union(e, {"damages_companion": true}), "zwf.v7.psm")
	event_fails(c, 2026, object.union(e, {"kind": "mineral_n"}), "zwf.stickstoff")
}

test_psm_after_break if {
	c := object.union(cover(3, "2025-08-20"), {"removal": {"method": "none"}, "next_sowing": "2026-03-01"})
	event_fails(c, 2025, {"kind": "pesticide", "date": "2025-11-16"}, "zwf.psm.folgesaat")
	not event_fails(c, 2025, {"kind": "pesticide", "date": "2026-03-02"}, "zwf.psm.folgesaat")
}

test_weed_exception_requires_proof if {
	c := cover(4, "2026-08-20")
	e := {"date": "2026-10-20", "kind": "chop", "low_cut": false, "problem_species": "Ragweed", "evidence": true, "cover_retained": true}
	not event_fails(c, 2026, e, "zwf.pflege")
	event_fails(c, 2026, object.union(e, {"evidence": false}), "zwf.pflege")
}

test_seedbed_rolling_and_traffic if {
	c := cover(1, "2025-07-20")
	e := {"date": "2025-08-01", "kind": "roll", "traffic": true, "neighbour_crossing": false}
	event_fails(c, 2025, e, "zwf.v1.befahren")
	not event_fails(c, 2025, object.union(e, {"neighbour_crossing": true}), "zwf.v1.befahren")
	not event_fails(c, 2025, {"date": "2025-07-20", "kind": "roll", "seedbed_rolling": true}, "zwf.walzen")
}

test_mechanical_alternatives if {
	c := object.union(cover(5, "2026-09-20"), {"components": [{"winter_hardy": false}], "removal": {"method": "collapsed", "fully_frozen": true}})
	zwf.removal_ok(c, 2026)
	not zwf.removal_ok(object.union(c, {"components": [{"winter_hardy": true}]}), 2026)
	not zwf.removal_ok(object.union(c, {"removal": {"method": "shorten_regrowing"}}), 2026)
}

test_drought_is_not_blanket_waiver if {
	c := object.union(cover(3, "2026-08-21"), {"proper_establishment": true, "drought_gap": true, "drought_volunteers": true, "full_cover": false, "cereal_maize_pct": 71})
	not has_rule(c, 2026, "zwf.deckung")
	not has_rule(c, 2026, "zwf.getreideanteil")
	has_rule(c, 2026, "zwf.variante.3.2023")
	has_rule(c, 2025, "zwf.deckung")
	has_rule(object.union(c, {"proper_establishment": false}), 2026, "zwf.getreideanteil")
}

test_drought_harvest_geography if {
	a := {"country": "AT", "state": "Steiermark", "district": "Weiz", "late_sensitive_crop": true, "drought_no_harvest": true}
	zwf.harvest_relief(a, 2026)
	not zwf.harvest_relief(object.union(a, {"district": "Liezen"}), 2026)
	not zwf.harvest_relief(object.union(a, {"late_sensitive_crop": false}), 2026)
	zwf.harvest_relief(object.union(a, {"state": "Wien"}), 2026)
	not zwf.harvest_relief(a, 2027)
}

test_deadlines_and_reductions if {
	c := {"variant": 3, "change_date": "2026-08-31", "change_kind": "new"}
	zwf.change_ok(c, 2026)
	not zwf.change_ok(object.union(c, {"change_date": "2026-09-01"}), 2026)
	zwf.change_ok(object.union(c, {"change_date": "2026-09-01", "change_kind": "reduce"}), 2026)
	zwf.change_ok({"variant": 6, "change_date": "2026-09-30", "change_kind": "new"}, 2026)
	zwf.entry_ok({"application_date": "2026-12-31"}, 2027)
	not zwf.entry_ok({"application_date": "2026-12-31"}, 2028)
}

test_annual_contract_conditions if {
	f := {"claimed_parcels": 1, "prior_contract": true, "annual_mfa": true, "exit_date": null}
	zwf.contract_status == "automatische Verlängerung beantragt" with input as {"land": {"arable_area_ha": 1.5}, "farm": {"year": 2026, "zwf": f}}
	zwf.contract_status == "erloschen" with input as {"land": {"arable_area_ha": 1.49}, "farm": {"year": 2026, "zwf": f}}
	zwf.contract_status == "erloschen" with input as {"land": {"arable_area_ha": 2}, "farm": {"zwf": {"claimed_parcels": 0, "prior_contract": true}}}
}

test_transfer_boundaries if {
	t := {"prior_ha": 2, "additional_ha": 1, "date": "2028-04-17", "previously_participating": false}
	zwf.takeover_limits_ok(t, 2028)
	not zwf.takeover_limits_ok(object.union(t, {"additional_ha": 1.01}), 2028)
	zwf.equivalent_lease({"variant": 4, "transfer": {"date": "2027-01-01", "lease_to_evergreen": true}}, 2026)
	not zwf.equivalent_lease({"variant": 7, "transfer": {"date": "2027-01-01", "lease_to_evergreen": true}}, 2026)
}

test_matrix_and_special_exclusions if {
	zwf.combination_cell("6", "16").zeichen == "x"
	zwf.combination_cell("6", "7").zeichen == ""
	zwf.combination_cell("1A", "4").fussnoten == [1]
	zwf.combination_cell("1B", "16").zeichen == "a"
	has_rule(object.union(cover(6, "2024-10-15"), {"npf": true}), 2024, "zwf.npf")
}

test_modulation_and_premium if {
	zwf.modulation(220) == 218 / 220
	zwf.modulation(1001) == (((200 + 90) + 595) + 0.75) / 1001
	zwf.premium_band(7, 2026, 2, 200) == {"min_eur": 162, "max_eur": 198}
	zwf.premium_band(1, 2026, 2, 220).min_eur == 360 * (218 / 220)
}

test_general_tables if {
	zwf.sanction(0, 2026) == "Verwarnung"
	zwf.sanction(0, 2027) == 1
	"6" in zwf.cap_row("Regelfall", 2025).ausgenommen
	"getreide" in zwf.crop_classes("Emmer", 2026)
	"obst" in zwf.crop_classes("Papau", 2025)
	not "obst" in zwf.crop_classes("Papau", 2024)
	zwf.listed_kg("1803").bl == "Wien"
}

test_missing_input_is_not_a_violation_or_approval if {
	zwf.findings == set() with input as {}
	not zwf.contract_status with input as {}
	not zwf.established({"undersown": true})
}

test_public_authority_and_active_farming if {
	base := {"legal_form": "public_body", "active_farmer": true, "agricultural_activity": true, "own_name": true, "own_account": true}
	not "zwf.betrieb" in zwf.farm_findings with input as {"farm": {"zwf": {"applicant": base}}}
	"zwf.betrieb" in zwf.farm_findings with input as {"farm": {"zwf": {"applicant": object.union(base, {"own_account": false})}}}
}

test_applicant_and_parcel_findings_in_same_assessment if {
	base := profile(cover(3, "2026-08-21"), 2026)
	applicant := {"legal_form": "other_ineligible", "own_account": false}
	result := zwf.assessment with input as object.union(base, {"farm": {"zwf": {"applicant": applicant}}})
	"zwf.person" in result.betriebsbefunde
	"zwf.betrieb" in result.betriebsbefunde
	result.schlagbefunde == {{"parcel_id": "A", "rule_id": "zwf.variante.3.2023"}}
}

test_withdrawal_after_winter if {
	not zwf.exit_window_ok(cover(2, "2025-08-05"), 2025, "2026-01-01")
	zwf.exit_window_ok(cover(2, "2025-08-05"), 2025, "2026-02-16")
}

test_estimate_only_for_accepted_hectares if {
	c := object.union(cover(6, "2024-10-12"), {"accepted_ha": 1})
	f := {"year": 2024, "zwf": {"home_area_ha": 15}}
	p := {"parcel_id": "Test", "land_use": "arable", "area_ha": 2, "operations": {"cover_crop": c}}
	out := zwf.assessment with input as {"farm": f, "land": {"arable_area_ha": 15, "parcels": [p]}}
	out.praemienband_festgestellte_flaeche.Test == {"min_eur": 108, "max_eur": 132}
	blocked := object.union(p, {"operations": {"cover_crop": object.union(c, {"npf": true})}})
	res := zwf.assessment with input as {"farm": f, "land": {"arable_area_ha": 15, "parcels": [blocked]}}
	res.praemienband_festgestellte_flaeche == {}
}

test_v7_end_day_flagged_for_review if {
	c := object.union(cover(7, "2026-09-01"), {"events": [{"date": "2027-01-31", "kind": "herbicide", "rape_leaves": 8}]})
	out := zwf.assessment with input as profile(c, 2026)
	{"parcel_id": "A", "rule_id": "zwf.v7.ende", "date": "2027-01-31"} in out.fachlich_offen
}

test_unharvested_main_crop_op_exemption if {
	c := cover(3, "2026-08-20")
	p := {"agrar": {"harvest_removed_pct": 84.99}, "operations": {"cover_crop": c}}
	startswith(zwf.harvest_status(p, 2025), "flächenbezogene OP-Codes")
	zwf.harvest_status(object.union(p, {"agrar": {"harvest_removed_pct": 85}}), 2025) == "Erntekriterium erfüllt"
}

test_o6_16_variant_3_is_regional if {
	c := cover(3, "2025-08-01")
	p := {"parcel_id": "S", "operations": {"cover_crop": c}, "agrar": {"state": "Oberösterreich", "gwa_area": true}}
	f := {"year": 2025, "zwf": {"measures": ["6", "16"]}}
	out := zwf.assessment with input as {"farm": f, "land": {"parcels": [p]}}
	{"parcel_id": "S", "rule_id": "zwf.gwa.ooe"} in out.schlagbefunde
	not zwf.insect_partner({"family": "Poaceae", "insect_pollinated": true})
}

test_neighbouring_public_measures_and_exclusions if {
	zwf.public_exception("6", 2026)
	zwf.applicant_form_ok({"legal_form": "public_institution"}, 2025)
	not zwf.public_exception("10", 2026)
	zwf.minimum_management_exception("BAW", "8", 2026)
	not zwf.minimum_management_exception("BAW", "6", 2026)
}

test_mfa_corrections_are_parcel_specific if {
	c := object.union(cover(4, "2026-08-31"), {"conditions_unattainable": true})
	out := zwf.assessment with input as profile(c, 2026)
	count(out.korrekturen) == 1
	some item in out.korrekturen
	item.rule_id == "zwf.antrag.streichen"
	item.parcel_id == "A"
}

test_2028_renewal_vs_entry if {
	f := {"year": 2028, "zwf": {"prior_contract": true, "new_entry": false, "annual_mfa": true, "exit_date": null, "claimed_parcels": 1}}
	zwf.contract_status == "automatische Verlängerung beantragt" with input as {"farm": f, "land": {"arable_area_ha": 1.5}}
	not zwf.entry_ok({"application_date": "2027-12-31"}, 2028)
}

test_change_between_deadline_groups if {
	c := object.union(cover(5, "2026-09-20"), {"previous_variant": 2, "change_kind": "switch", "change_date": "2026-09-05"})
	res := zwf.assessment with input as profile(c, 2026)
	{"parcel_id": "A", "rule_id": "zwf.antrag.spaet", "date": "2026-09-05"} in res.fachlich_offen
}

test_header_footnotes_survive_empty_cells if {
	with_gwa := zwf.combination_details("6", "16")
	with_gwa.zelle.zeichen == "x"
	with_gwa.hinweise[0].nr == 4
	with_protected_crops := zwf.combination_details("6", "13")
	with_protected_crops.zelle.zeichen == ""
	with_protected_crops.hinweise[0].nr == 2
}
