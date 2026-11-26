package oepul.o6_12_test

import data.oepul.o6_12 as m
import rego.v1

pay := {"active": true, "declared": true, "identified": true, "mainly_agricultural": true, "planted": true, "annual_care": true, "harvest_removed": true, "full_year": true, "term_possible": true, "public_overlap": false, "trial_noncompliance": false, "national_park": "", "park_restrictions": false, "op_for_measure": false, "codes": []}
wine := {"parcel_id": "W", "area_ha": 0.3, "country": "AT", "state": "Steiermark", "use_name": "Wein", "crop": {"crop_category": "vineyard", "crop_name": null}, "payment": pay, "operations": {"psm_events": []}}
orchard := object.union(wine, {"parcel_id": "O", "area_ha": 0.2, "use_name": "Obst", "crop": {"crop_category": "orchard", "crop_name": "Apfel"}, "orchard_quality": true, "ungrafted_tree": false})
co := {"start_year": 2025, "first_participation_year": 2025, "application_date": "2024-12-31", "status": "active"}
base := {"farm": {"year": 2025, "first_oepul_year": 2025, "bio_measure_scope": "none", "o6_12": co}, "land": {"parcels": [wine, orchard], "protected_at_ha": 0, "qualifying_at_ha": 1.5}}
ev := {"date": "2025-06-13", "status": "applied", "effect_types": ["Insektizid"], "synthetic": true, "bio_permitted": false, "area_wide": true, "order": {"applies": false}}
ordered := {"applies": true, "active_ingredient_authorized": true, "pest": "Amerikanische Rebzikade", "in_designated_area": true, "synthetic_required": false, "bio_available": true, "documented": true}
event26(o) := object.union(ev, {"date": "2026-06-15", "order": o})
parcel_with(events) := object.union(wine, {"operations": {"psm_events": events}})
profile(y, status, parcels) := object.union(base, {"farm": object.union(base.farm, {"year": y, "o6_12": object.union(co, status)}), "land": object.union(base.land, {"parcels": parcels})})

test_threshold_summed_across_crops if {
	m.covered_ha == 0.5 with input as base
	m.measure_size_ok with input as base
	not m.measure_size_ok with input as profile(2025, {}, [wine])
	m.measure_size_ok with input as profile(2026, {}, [wine])
}

test_area_and_farm_gates_independent if {
	m.farm_size_ok with input as base
	not m.farm_size_ok with input as base with input.land.qualifying_at_ha as 1.49
	m.farm_size_ok with input as base with input.land.qualifying_at_ha as 0.5 with input.land.protected_at_ha as 0.5
}

test_original_term_all_entries if {
	every y in {2023, 2024, 2025} { term := m.contract_term with input.farm.o6_12.start_year as y; term.years == 2029 - y; term.end == "2028-12-31"}
}

test_regular_deadline if {
	m.entry_timely with input as base
	not m.entry_timely with input as base with input.farm.o6_12.application_date as "2025-01-01"
	not m.entry_timely with input as base with input.farm.o6_12.start_year as 2026
}

test_vineyard_definitions if {
	cut := object.union(wine, {"crop": {"crop_category": "other", "crop_name": null}, "use_name": "Schnittweingarten"})
	m.crop_group(cut) == "vineyard"
	m.crop_group(object.union(wine, {"use_name": "Rebschule"})) == "outside"
	m.crop_group(object.union(wine, {"country": "IT"})) == "outside"
}

test_fruit_expansion_and_varieties if {
	p := object.union(orchard, {"crop": {"crop_category": "orchard", "crop_name": "Papau"}})
	m.crop_group(p) == "outside" with input.farm.year as 2024
	m.crop_group(p) == "orchard" with input.farm.year as 2025
	q := object.union(orchard, {"crop": {"crop_category": "orchard", "crop_name": "Gala"}})
	not m.crop_group(q) with input as base
	m.crop_group(object.union(q, {"crop": {"oepul_group": "Apfel"}})) == "orchard" with input as base
}

test_pending_and_approved_exit if {
	m.exit_available with input as profile(2026, {}, [wine])
	not m.exit_available with input as profile(2026, {}, [orchard])
	not m.exit_available with input as base
	pending := profile(2026, {"status": "exit_pending"}, [wine, orchard])
	not m.exit_effect with input as pending
	m.parcel_base_eur(orchard) == 54 with input as pending
	approved := profile(2026, {"status": "exit_approved", "exit_notification_date": "2026-06-14"}, [wine, orchard])
	m.exit_effect.terminated_from == "2026-06-14" with input as approved
	m.parcel_base_eur(orchard) == 0 with input as approved
	m.bound_on("2026-06-13") with input as approved
	not m.bound_on("2026-06-14") with input as approved
}

test_use_before_exit_still_checked if {
	p := parcel_with([object.union(ev, {"date": "2026-06-13"}), object.union(ev, {"date": "2026-06-15"})])
	results := m.application_findings with input as profile(2026, {"status": "exit_approved", "exit_notification_date": "2026-06-14"}, [p])
	count(results) == 1
	some finding in results
	finding.status == "Verstoß"
	finding.event == 0
}

test_order_location_and_choice if {
	required := event26(object.union(ordered, {"synthetic_required": true}))
	unavailable := event26(object.union(ordered, {"bio_available": false}))
	for_bio := event26(ordered)
	m.application_status(wine, for_bio) == "Verstoß" with input.farm.year as 2026
	m.application_status(wine, required) == "angeordneter Einsatz zulässig" with input.farm.year as 2026
	m.application_status(wine, unavailable) == "angeordneter Einsatz zulässig" with input.farm.year as 2026
	m.application_status(object.union(wine, {"state": "Wien"}), required) == "Verstoß" with input.farm.year as 2026
	wrong_area := event26(object.union(ordered, {"in_designated_area": false, "synthetic_required": true}))
	m.application_status(wine, wrong_area) == "Verstoß" with input.farm.year as 2026
	wrong_substance := event26(object.union(ordered, {"active_ingredient_authorized": false, "synthetic_required": true}))
	m.application_status(wine, wrong_substance) == "Verstoß" with input.farm.year as 2026
}

test_general_official_order_before_2026 if {
	event := object.union(ev, {"order": ordered})
	m.application_status(wine, event) == "angeordneter Einsatz zulässig" with input.farm.year as 2025
}

test_psm_effect_and_bio if {
	m.application_status(wine, object.union(ev, {"effect_types": ["Fungizid"]})) == "kein Insektizid"
	m.application_status(wine, object.union(ev, {"bio_permitted": true})) == "Bio-Mittel zulässig"
	m.application_status(wine, object.union(ev, {"effect_types": ["Akarizid", "Insektizid"]})) == "Verstoß"
	m.application_status(wine, {}) == "Sachverhalt unvollständig"
}

test_coding_mixed_and_ordered if {
	bio := object.union(ev, {"bio_permitted": true, "synthetic": false})
	other := object.union(ev, {"effect_types": ["Fungizid"]})
	p := parcel_with([bio, other, ev])
	m.minimum_codes(p) == {"PSMCS", "PSMCSI"} with input as base
	m.minimum_codes(parcel_with([bio])) == {"PSMBIO"} with input as base
	m.minimum_codes(parcel_with([object.union(ev, {"area_wide": false})])) == set() with input as base
	m.minimum_codes(p) == set() with input as profile(2026, {}, [p])
}

test_order_submission_changes if {
	a := parcel_with([object.union(ev, {"order": ordered})])
	b := parcel_with([event26(ordered)])
	old := m.order_duties with input as profile(2025, {}, [a])
	new := m.order_duties with input as profile(2026, {}, [b])
	some x in old
	x.ama_submission == "eAMA Eingaben / andere Eingaben"
	some y in new
	y.ama_submission == "keine Übermittlung"
}

test_planned_use_not_actual if {
	p := parcel_with([object.union(ev, {"status": "cancelled"})])
	i := profile(2025, {}, [p])
	count(m.application_findings) == 0 with input as i
	m.minimum_codes(p) == set() with input as i
	acts := m.coding_actions with input as i
	some a in acts
	contains(a.action, "streichen")
}

test_other_crop_stock_exception if {
	s := {"bio_permitted": false, "legal_other_crop": true, "plausible_amount": true, "records": true}
	m.stock_status(s) == "zulässig"
	every k in {"legal_other_crop", "plausible_amount", "records"} { m.stock_status(object.union(s, {k: false})) == "Verstoß" }
	m.stock_status({"bio_permitted": false, "legal_other_crop": true}) == "Sachverhalt unvollständig"
}

test_combination_levels if {
	m.bio_combination_ok with input.farm.bio_measure_scope as "partial_arable_grassland"
	not m.bio_combination_ok with input.farm.bio_measure_scope as "partial_wine_fruit_hop"
	not m.bio_combination_ok with input.farm.bio_measure_scope as "whole_farm"
	m.parcel_combination("1A", "Grundprämie") == "nur Landschaftselemente"
	m.parcel_combination("1A", "Landschaftselemente") == "kombinierbar"
	m.parcel_combination("1B", "Grundprämie") == "nicht kombinierbar"
	m.parcel_combination("10", "Organismen/Pheromone") == "kombinierbar mit 50 % Zuschlagsabschlag"
	m.organism_bonus(2025).minimum_eur_ha == 81
}

test_takeover_april_and_area if {
	t := {"date": "2028-04-17", "taken_ha": 1, "additional_ha": 0.5, "previously_participating": false, "ama_approved": true}
	m.takeover_ok with input as profile(2028, {"takeover": t}, [])
	not m.takeover_ok with input as profile(2028, {"takeover": object.union(t, {"additional_ha": 0.51})}, [])
	not m.takeover_ok with input as profile(2026, {"takeover": object.union(t, {"date": "2026-04-16"})}, [])
}

test_rates_and_nonpayment if {
	every group in {"orchard", "hop", "vineyard"} { m.rate_per_ha(group, 2023) == 250; m.rate_per_ha(group, 2024) == 270}
	m.parcel_base_eur(wine) == 81 with input as base
	m.parcel_base_eur(object.union(wine, {"use_name": "Sonstige Weinflächen"})) == 0 with input as base
	m.parcel_base_eur(object.union(orchard, {"ungrafted_tree": true})) == 0 with input as base
	m.parcel_base_eur(object.union(wine, {"payment": {"codes": ["OP"]}})) == 0 with input as base
	m.parcel_base_eur(object.union(wine, {"payment": {"national_park": "Donau-Auen"}})) == 0 with input as base
}

test_modulation_and_caps if {
	m.modulation_factor(200) == 1
	m.modulation_factor(220) == 218 / 220
	m.modulation_factor(1100) == 960 / 1100
	p := {"combined_payments": [{"measure": "12", "eur_ha_after_modulation": 270}, {"measure": "10", "eur_ha_after_modulation": 1080}]}
	m.capped_sum_per_ha(p, "standard") == 270 with input.farm.year as 2024
	m.capped_sum_per_ha(p, "standard") == 1300 with input.farm.year as 2025
}

test_sanctions_and_tolerance if {
	m.sanction_consequence("warning", 2026) == 0
	m.sanction_consequence("warning", 2027) == 1
	is_string(m.sanction_consequence("second_100", 2025))
	m.loss_tolerance(1) == 0.5
	m.loss_tolerance(80) == 4
	m.loss_tolerance(200) == 5
}

test_drought_applies_only_to_affected_arable_crop if {
	p := {"land_use": "arable", "state": "Steiermark", "district": "Weiz", "drought": {"late_summer_or_autumn": true, "heat_sensitive": true, "no_harvestable_stand": true, "assessment_date": "2026-08-12"}}
	m.drought_harvest_waiver(p) with input.farm.year as 2026
	not m.drought_harvest_waiver(object.union(p, {"drought": {"assessment_date": "2026-08-11"}})) with input.farm.year as 2026
	not m.drought_harvest_waiver(object.union(p, {"land_use": "special_crop"})) with input.farm.year as 2026
}

test_assessment_missing_information if {
	a := m.assessment with input as {"farm": {"year": 2026}, "land": {"parcels": [{"parcel_id": "unknown"}]}}
	a.entry_checks.applicant == null
	a.parcel_results[0].area_base_before_farm_checks_eur == null
	a.parcel_results[0].required_psm_codes == set()
}

test_farm_assessment_and_noneligible_bio if {
	a := {"active_farmer": true, "agricultural_activity": true, "own_name_and_account": true, "disposal_right": true, "public_percent": 25, "public_control": false, "legal_form": "legal_person"}
	m.screened_base_eur == 135 with input as base with input.farm.applicant as a
	m.screened_base_eur == 0 with input as base with input.farm.applicant as object.union(a, {"public_percent": 25.01})
	m.screened_base_eur == 0 with input as base with input.farm.bio_measure_scope as "whole_farm"
	m.regular_entry_checks_pass with input as base with input.farm.applicant as a
}

test_rebzikade_scope_and_null_obst_group if {
	e := event26(object.union(ordered, {"synthetic_required": true}))
	m.application_status(orchard, e) == "Verstoß" with input.farm.year as 2026
	p := object.union(orchard, {"crop": {"oepul_group": null}})
	m.crop_group(p) == "orchard" with input.farm.year as 2026
}

test_incomplete_legacy_psm_data if {
	p := parcel_with([{"date": "2025-03-12", "status": "applied", "area_wide": true}])
	m.codes_or_null(p) == null with input as base
}

test_order_proof_and_no_duplicate_upload if {
	old := parcel_with([object.union(ev, {"order": object.union(ordered, {"uploaded": false, "documented": false})})])
	new := parcel_with([event26(object.union(ordered, {"uploaded": false, "documented": false}))])
	count(m.document_findings) == 2 with input as profile(2025, {}, [old])
	count(m.document_findings) == 1 with input as profile(2026, {}, [new])
}

test_walnut_and_park_duties if {
	p := object.union(orchard, {"crop": {"crop_name": "Walnuss"}, "ungrafted_tree": true})
	"Walnüsse mit OP beantragen" in m.parcel_actions(p) with input as base
	park := object.union(parcel_with([ev]), {"payment": {"national_park": "Donau-Auen"}})
	i := profile(2025, {}, [park])
	m.parcel_base_eur(park) == 0 with input as i
	results := m.application_findings with input as i
	some f in results
	f.status == "Verstoß"
}

test_switch_deadline_and_recovery_area if {
	m.switch_timely with input as profile(2025, {"switch_target": "1B", "switch_date": "2025-12-31"}, [])
	not m.switch_timely with input as profile(2025, {"switch_target": "1B", "switch_date": "2026-01-01"}, [])
	t := {"exception_applies": false, "fixed_parcel_obligation": true, "reduction_ha": 1.01, "prior_committed_ha": 20}
	m.reclaim_difference_ha == 1.01 with input.farm.payment_assessment as t
	m.reclaim_difference_ha == 0 with input.farm.payment_assessment as object.union(t, {"reduction_ha": 1})
	m.reclaim_difference_ha == 0 with input.farm.payment_assessment as object.union(t, {"fixed_parcel_obligation": false})
}

test_pending_application_no_entitlement_to_advance if {
	p := {"administrative_checks_closed": false, "expected_payment_eur": 800}
	m.advance_max_eur == 0 with input.farm.payment_assessment as p
	m.advance_max_eur == 600 with input.farm.payment_assessment as object.union(p, {"administrative_checks_closed": true})
	m.payment_deadline(2026) == "2027-06-30"
}

test_erosion_and_gve_table_boundaries if {
	m.erosion_rate("vineyard", 35, 2025).from_2025 == 540
	m.erosion_rate("orchard", 24.99, 2025).from_2025 == 216
	m.gve_factor("Rinder ab 2 Jahre", null) == 1
	m.combination_partner("16").footnote == 4
}

test_active_contract_exit_only_for_wine if {
	pure := profile(2026, {"status": "exit_approved", "exit_notification_date": "2026-06-13"}, [orchard])
	not m.exit_effect with input as pure
	m.exit_effect.no_recovery_for_short_term with input as pure with input.farm.o6_12.wine_at_notification as true
}

test_actions_depend_on_each_parcel_payment if {
	trial := object.union(wine, {"payment": object.union(pay, {"trial_noncompliance": true})})
	overlap := object.union(orchard, {"payment": object.union(pay, {"public_overlap": true})})
	result := m.assessment with input as profile(2026, {}, [trial, overlap, wine])
	result.parcel_results[0].actions == {"VF im MFA setzen und Versuch dokumentieren"}
	result.parcel_results[1].actions == {"OP oder maßnahmenbezogenen OP-Code setzen"}
	result.parcel_results[2].actions == set()
}

test_home_modulation_without_takeover if {
	m.home_modulation == 218 / 220 with input as {"farm": {"payment_assessment": {"home_area_ha": 220}}}
}
