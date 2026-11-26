package oepul.o6_11_test

import data.oepul.o6_11 as m
import rego.v1

field(id, cat, name, ha) := {"parcel_id": id, "area_ha": ha, "mfa": {"country": "AT", "use": name}, "crop": {"crop_category": cat, "crop_name": name, "quality_stock": true}}
holding(y, parcels) := {"farm": {"year": y, "o6_11": {"active": true, "first_year": 2025}}, "land": {"parcels": parcels}}
wine := field("w", "vineyard", "Wein", 0.2)
nuts := field("n", "orchard", "Walnuss", 0.3)
nursery := field("r", "vineyard", "Rebschule", 10)
event(k, typ, broadcast) := {"code_class": k, "register_types": typ, "status": "applied", "broadcast": broadcast}
with_events(p, events) := object.union(p, {"operations": {"psm_events": events}})

test_contract_table if {
	m.contract_years(2023) == 6
	m.contract_years(2024) == 5
	m.contract_years(2025) == 4
	not m.contract_years(2026)
}

test_entry_boundary if {
	m.entry_timely(2025, "2024-12-31")
	m.entry_timely(2025, "2025-01-01") == false
	not m.entry_timely(2026, "2025-12-31")
	not m.entry_timely(2025, "2024-02-30")
}

test_first_year_sum if m.first_year_area_ok with input as holding(2025, [wine, nuts, nursery])

test_nursery_excluded if {
	v := m.first_year_area_ok with input as holding(2025, [wine, nursery])
	v == false
}

test_foreign_land_excluded if {
	p := object.union(nuts, {"mfa": {"country": "DE"}})
	v := m.first_year_area_ok with input as holding(2025, [p, wine])
	v == false
}

test_no_first_year_retest if not m.first_year_area_ok with input as holding(2026, [wine])
test_schnittwein if m.crop_group(field("s", "other", "Schnittweingarten", 1), 2025) == "vineyard"

test_fruit_change if {
	p := field("f", "orchard", "Felsenbirne", 1)
	m.tariff(p, 2024) == 0
	m.tariff(p, 2025) == 270
}

test_unknown_fruit_requires_input if {
	p := field("f", "orchard", "unbestimmte Sorte", 1)
	not m.classified(p, 2025)
	r := m.needs_evidence with input as holding(2025, [p])
	{"parcel_id": "f", "field": "crop / fruit_group"} in r
}

test_scope_includes_unpaid_nuts_and_fence if {
	p := with_events(nuts, [object.union(event("synthetic_herbicide", ["Herbizid"], false), {"site": "fence"})])
	r := m.herbicide_findings with input as holding(2026, [p])
	count(r) == 1
	m.tariff(p, 2026) == 0
}

test_effect_type_even_stem_treatment if {
	e := object.union(event("synthetic_other", ["Herbizid"], false), {"site": "trunk"})
	r := m.herbicide_findings with input as holding(2026, [with_events(wine, [e]), with_events(nursery, [e])])
	count(r) == 1
}

test_no_herbicide_inference_from_psm_used if {
	p := object.union(wine, {"operations": {"psm_used": true}})
	r := m.herbicide_findings with input as holding(2026, [p])
	count(r) == 0
	n := m.needs_evidence with input as holding(2026, [p])
	{"parcel_id": "w", "field": "operations.psm_events"} in n
}

test_formic_on_arable if {
	p := object.union(field("a", "cereal", "Roggen", 2), {"operations": {"field_production": true, "psm_events": [{"status": "applied", "ingredients": ["Formylsäure"]}]}})
	r := m.formic_findings with input as holding(2026, [p])
	count(r) == 1
}

test_codes_mixed_and_separate_herbicide if {
	p := with_events(wine, [event("bio", [], true), event("synthetic_other", [], true), event("synthetic_herbicide", ["Herbizid"], true)])
	m.required_codes(p, 2025) == {"PSMCS", "PSMCSH"}
	m.required_codes(p, 2026) == set()
}

test_codes_spot if {
	p := with_events(wine, [event("bio", [], true), event("synthetic_other", [], false)])
	m.required_codes(p, 2024) == {"PSMBIO"}
}

test_cancelled_code if {
	p := object.union(with_events(wine, [object.union(event("bio", [], true), {"status": "cancelled"})]), {"mfa": {"codes": ["PSMBIO"]}})
	r := m.coding_actions with input as holding(2025, [p])
	count(r) == 1
}

test_store_other_crop_and_purchase if {
	rows := [{"id": "A", "action": "storage", "lawful_other_crop": true, "plausible": true, "documented": true}, {"id": "B", "action": "purchase", "lawful_other_crop": false}, {"id": "C", "action": "storage", "lawful_other_crop": true, "documented": false}, {"id": "D", "action": "storage", "lawful_other_crop": true}]
	h := object.union(holding(2026, []), {"farm": {"o6_11": {"herbicide_transactions": rows}}})
	r := m.stock_findings with input as h
	{f.id | some f in r} == {"B", "C"}
	needed := m.stock_evidence_needed with input as h
	"D" in needed
}

test_bio_and_switch if {
	m.bio_compatible with input.farm.o6_11.bio_participation as "partial_arable_grassland"
	v := m.bio_compatible with input.farm.o6_11.bio_participation as "whole_farm"
	v == false
	m.switch_timely("1B", "2025-12-31")
	m.switch_timely("1B", "2026-01-01") == false
	not m.switch_timely("12", "2025-12-01")
}

test_rate_by_year_and_type if {
	every p in [wine, field("o", "orchard", "Apfel", 1), field("h", "hop", "Hopfen", 2)] { m.tariff(p, 2023) == 250; m.tariff(p, 2024) == 270}
}

test_unproductive_and_walnut if {
	m.tariff(nuts, 2026) == 0
	m.tariff(object.union(wine, {"mfa": {"use": "Sonstige Weinflächen"}}), 2025) == 0
	m.tariff(object.union(field("a", "orchard", "Apfel", 2), {"crop": {"quality_stock": false}}), 2025) == 0
}

test_2026_notice_does_not_waive_herbicides if {
	h := object.union(holding(2026, [with_events(wine, [event("synthetic_herbicide", ["Herbizid"], true)])]), {"farm": {"region": {"federal_state": "Steiermark"}}})
	r := m.herbicide_findings with input as h
	count(r) == 1
}

test_parcel_not_aggregated_by_equal_area if {
	h := holding(2025, [wine, object.union(wine, {"parcel_id": "w2", "area_ha": 0.3})])
	m.first_year_area_ok with input as h
}

test_walnuts_mfa_label_count_but_no_payment if {
	p := field("n", "orchard", "Walnüsse", 0.5)
	m.first_year_area_ok with input as holding(2025, [p])
	m.tariff(p, 2025) == 0
}

test_ungrafted_tree_op if {
	p := object.union(field("a", "orchard", "Apfel", 0.5), {"crop": {"ungrafted_tree": true}})
	m.tariff(p, 2025) == 0
	r := m.required_op_markings with input as holding(2025, [p])
	r.a == {"OP"}
}

test_parcel_amount_requires_affirmative_facts if {
	a := object.union(wine, {"mfa": {"claimed_11": true, "correctly_identified": true, "active_production": true, "mainly_agricultural": true, "gaec_feature": false, "approved_trial_prevents_compliance": false, "op_for_11": false, "codes": [], "national_park": "none"}, "operations": {"properly_planted": true, "annual_care": true, "harvested": true, "harvest_removed": true}})
	b := object.union(a, {"parcel_id": "b", "mfa": {"codes": ["OP"]}})
	h := object.union(holding(2025, [a, b, object.union(wine, {"parcel_id": "unknown"})]), {"farm": {"opul_procedure": {"conditions_met_through_year": true}}})
	amounts := m.parcel_amounts_before_farm_checks with input as h
	amounts == {"w": 54, "b": 0}
}

test_contract_switch_and_claims_on_same_parcel if {
	parcel := object.union(wine, {"mfa": {"claimed_11": true}})
	farm_input := object.union(holding(2025, [parcel]), {"farm": {
		"o6_11": {"switch_target": "1B", "switch_filed": "2025-12-31"},
		"opul_combinations": [
			{"parcel_id": "w", "measure": "12"},
			{"parcel_id": "w", "measure": "11"},
			{"parcel_id": "other", "measure": "10"},
		],
	}})
	m.switch_application_timely with input as farm_input
	observed := m.observed_combinations with input as farm_input
	observed == {{"parcel_id": "w", "other_measure": "12", "matrix": m.combination("11", "12")}}
}
