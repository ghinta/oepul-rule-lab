package oepul.o6_13_test

import data.oepul.o6_13 as rule
import rego.v1

use := {"organism": "Raubmilbe", "quantity": 10, "unit": "Stück", "reason": "Schädlingsbefall", "objective": "Pflanzenschutz", "date": "2026-04-20", "purchased": true, "receipt": "R-123", "register_listed": true, "register_rate_compliant": true, "replaces_pesticide": true, "pollination_only": false}

plot := {"parcel_id": "p1", "area_ha": 1.20, "protected": {
	"structure": "fixed_glass", "medium_april_1": "pot", "mfa_use": "GA", "codes": ["NUE"], "uses": [use], "full_area_creditable_treatment": true,
	"surface": {"sales_ha": 0.03, "display_ha": 0.02, "storage_ha": 0.05, "unused_between_ha": 0.05, "aisles_ha": 0.15, "necessary_aisles_ha": 0.10},
	"other_premiums": [], "country": "AT", "national_park": "none", "park_restrictions": false, "active_production": true, "mainly_agricultural": true, "at_disposal": true, "correct_reference": true, "excluded_use": "none", "public_overlap": false, "compulsory_offset": false, "trial_prevents_compliance": false, "year_obligations_continued": true, "measure_op": false, "proper_planting": true, "annual_care": true, "harvested_removed_pct": 85,
}}

farm := {"year": 2026, "oepul13": {"first_oepul_year": 2026, "at_qualifying_mfa_ha": 1.20, "at_protected_mfa_ha": 1.20, "home_mfa_ha": 1.20, "measure_request_date": "2025-12-31", "withdrawal_date": null, "mfa_complete": true, "any_beneficial_use": true, "producer_org_member": false, "legal_form": "natural", "public_control": false, "public_share_pct": 0, "own_name": true, "own_account": true, "active_farmer": true, "agricultural_activity": true}}
profile := {"farm": farm, "land": {"parcels": [plot]}}
changed_plot(patch) := object.union(plot, {"protected": patch})
changed_app(patch) := object.union(profile, {"farm": {"oepul13": patch}})

test_standard_payment if {
	result := rule.standard_premium_eur with input as profile
	result == {"p1": 2160}
}

test_org_program_excludes_even_without_individual_compensation if {
	member := changed_app({"producer_org_member": true, "org_program_compensates_organisms": true})
	rule.standard_premium_eur == {} with input as member
	rule.producer_ok with input as changed_app({"producer_org_member": true, "org_program_compensates_organisms": false})
}

test_date_bounds if {
	rule.timely_entry with input as {"farm": {"year": 2027, "oepul13": {"measure_request_date": "2026-12-31"}}}
	not rule.timely_entry with input as {"farm": {"year": 2027, "oepul13": {"measure_request_date": "2027-01-01"}}}
	not rule.timely_entry with input as {"farm": {"year": 2028, "oepul13": {"measure_request_date": "2027-12-31"}}}
	rule.contract_basis with input as {"farm": {"year": 2028, "oepul13": {"previous_contract_continuable": true}}}
	not rule.contract_basis with input as {"farm": {"year": 2029, "oepul13": {"previous_contract_continuable": true}}}
	not rule.valid_date("2026-02-30")
}

test_withdrawal_dates if {
	every d in ["2026-01-01", "2026-12-31"] {
		rule.standard_premium_eur == {} with input as changed_app({"withdrawal_date": d})
	}
	rule.standard_premium_eur == {"p1": 2160} with input as changed_app({"withdrawal_date": "2027-01-01"})
}

test_contract_lapses if {
	rule.lapse_reason == {"kein NUE im Jahres-MFA"} with input as profile with input.land.parcels as [changed_plot({"codes": []})]
	rule.standard_premium_eur == {} with input as changed_app({"any_beneficial_use": false})
	count(rule.lapse_reason) == 0 with input as {}
}

test_april_and_structures if {
	every med in ["pot", "container", "substrate"] { rule.expected_use(changed_plot({"medium_april_1": med})) == "GA" }
	rule.expected_use(changed_plot({"medium_april_1": "soil"})) == "A"
	not rule.use_ok(changed_plot({"medium_april_1": "soil"}))
	every kind in ["fixed_glass", "fixed_plastic", "fixed_foil", "unfixed_foil_tunnel"] { rule.structure_ok(changed_plot({"structure": kind})) }
	not rule.structure_ok(changed_plot({"structure": "open"}))
}

test_net_area if {
	rule.net_area(plot) == 1
	not rule.net_area(changed_plot({"surface": {"necessary_aisles_ha": 0.16}}))
	not rule.net_area(changed_plot({"surface": {"storage_ha": -0.1}}))
}

test_register_and_substitution if {
	rule.creditable(use)
	every flag in ["register_listed", "register_rate_compliant", "replaces_pesticide"] {
		not rule.creditable(object.union(use, {flag: false}))
	}
	not rule.creditable(object.union(use, {"pollination_only": true}))
	not rule.creditable(object.union(use, {"register_dose": {"actual": 6, "minimum": 1, "maximum": 5, "unit": "Stück/m²"}}))
	rule.creditable(object.union(use, {"register_dose": {"actual": 5, "minimum": 1, "maximum": 5, "unit": "Stück/m²"}}))
}

test_no_bees_only_or_partial_coverage if {
	bees := changed_plot({"uses": [object.union(use, {"pollination_only": true, "replaces_pesticide": false})]})
	not rule.annual_minimum with input as profile with input.land.parcels as [bees]
	rule.standard_premium_eur == {} with input as profile with input.land.parcels as [changed_plot({"full_area_creditable_treatment": false})]
}

test_each_record_required if {
	every k in ["organism", "quantity", "unit", "date", "reason", "objective", "receipt"] {
		not rule.records_ok(changed_plot({"uses": [object.remove(use, {k})]})) with input as profile
	}
	rule.records_ok(changed_plot({"uses": [object.union(use, {"purchased": false, "receipt": null})]})) with input as profile
	not rule.records_ok(changed_plot({"uses": [object.union(use, {"date": "2025-05-01"})]})) with input as profile
}

test_sizes if {
	rule.size_ok with input as changed_app({"at_protected_mfa_ha": 0.5, "at_qualifying_mfa_ha": 0.5})
	rule.size_ok with input as changed_app({"at_protected_mfa_ha": 0.49, "at_qualifying_mfa_ha": 1.5})
	not rule.size_ok with input as changed_app({"at_protected_mfa_ha": 0.49, "at_qualifying_mfa_ha": 1.49})
	rule.size_ok with input as changed_app({"first_oepul_year": 2025, "at_protected_mfa_ha": 0.1, "at_qualifying_mfa_ha": 0.1})
}

test_no_stacking_and_no_cross_parcel_exclusion if {
	covered := changed_plot({"other_premiums": ["1B"]})
	rule.combination_conflicts(covered) == {"1B"}
	not rule.combination_ok(covered)
	rule.matrix_cell("13", "1B") == ""
	rule.matrix_cell("1B", "16") == "a"
	rule.matrix_cell("18", "1A") == "x 1)"
	other := object.union(covered, {"parcel_id": "p2"})
	rule.standard_premium_eur == {"p1": 2160} with input as profile with input.land.parcels as [plot, other]
}

test_arable_and_caps if {
	p := changed_plot({"medium_april_1": "soil", "mfa_use": "A"})
	rule.standard_premium_eur == {"p1": 2160} with input as profile with input.land.parcels as [p]
	every u in ["A", "GA"] {
		rule.rate(u, 2023) == 2000
		rule.rate(u, 2024) == 2160
	}
	rule.cap(2023) == 2000
	rule.cap(2024) == 2160
	not rule.rate("G", 2026)
}

test_modulation_boundaries if {
	rule.modulation(200) == 1
	round(10000 * rule.modulation(220)) == 9909
	rule.modulation(300) == 290 / 300
	rule.modulation(1000) == 885 / 1000
	rule.modulation(1100) == 960 / 1100
	not rule.modulation(0)
}

dry := changed_plot({"mfa_use": "A", "medium_april_1": "soil", "state": "Steiermark", "district": "Weiz", "drought_no_harvestable_crop": true, "heat_drought_sensitive": true, "usual_late_summer_autumn_harvest": true, "harvested_removed_pct": 0})

test_2026_drought if {
	rule.harvest_ok(dry) with input as profile
	rule.standard_premium_eur == {"p1": 2160} with input as profile with input.land.parcels as [dry]
	every patch in [{"mfa_use": "GA"}, {"district": "Liezen"}, {"usual_late_summer_autumn_harvest": false}, {"drought_no_harvestable_crop": false}, {"heat_drought_sensitive": false}] {
		not rule.harvest_ok(object.union(dry, {"protected": patch})) with input as profile
	}
	not rule.drought_relief(dry) with input.farm.year as 2025
	rule.drought_relief(object.union(dry, {"protected": {"state": "Burgenland", "district": "Güssing"}})) with input.farm.year as 2026
	rule.harvest_ok(changed_plot({"harvested_removed_pct": 0, "harvest_exception_recognised": true}))
	not rule.harvest_ok(changed_plot({"harvested_removed_pct": 84.99})) with input as profile
}

test_op_park_trial if {
	every patch in [{"national_park": "Donau-Auen"}, {"national_park": "Neusiedlersee"}, {"codes": ["NUE", "OP"]}, {"codes": ["NUE", "VF"]}, {"measure_op": true}, {"public_overlap": true}, {"country": "DE"}, {"correct_reference": false}, {"trial_prevents_compliance": true}] {
		not rule.general_land_ok(changed_plot(patch))
	}
}

test_takeover if {
	t := {"date": "2028-04-17", "previously_not_participating": true, "online_mfa_approved": true, "source_contract_active": true, "transferred_ha": 2, "additional_ha": 1}
	rule.takeover_basis with input.farm.year as 2028 with input.farm.oepul13.takeover as t
	not rule.takeover_basis with input.farm.year as 2028 with input.farm.oepul13.takeover as object.union(t, {"date": "2028-04-18"})
	not rule.takeover_basis with input.farm.year as 2028 with input.farm.oepul13.takeover as object.union(t, {"additional_ha": 1.01})
}

test_sanction_and_payment if {
	rule.sanction(2026, "warning", 0) == {"action": "warn", "percent": 0}
	rule.sanction(2027, "warning", 0) == {"action": "withhold", "percent": 1}
	rule.sanction(2026, "100", 2) == {"action": "exclude_and_recover"}
	rule.payment_deadline(2026) == "2027-06-30"
	rule.advance_limit(2000) == 1500 with input.farm.oepul13.administrative_checks_complete as true
}

test_public_share if {
	rule.applicant_ok with input as changed_app({"legal_form": "association", "public_share_pct": 25})
	not rule.applicant_ok with input as changed_app({"legal_form": "association", "public_share_pct": 25.01})
	not rule.applicant_ok with input as changed_app({"legal_form": "legal_person", "public_control": true})
}

test_table_classifications if {
	"Obst" in rule.crop_groups("Papau", 2025)
	count(rule.crop_groups("Papau", 2024)) == 0
	rule.switch_allowed("8-BAW", "18", 2025)
	not rule.switch_allowed("13", "18", 2025)
	not rule.growth_limited("13")
	rule.measure_class("13") == {"annual"}
	rule.livestock_factor("Rinder", "Rinder ab 2 Jahre") == 1
}

test_missing_information if {
	rule.standard_premium_eur == {} with input as {}
	rule.standard_premium_eur == {} with input as profile with input.land.parcels as [object.remove(plot, {"protected"})]
	rule.standard_premium_eur == {} with input as profile with input.farm.oepul13 as object.remove(farm.oepul13, {"withdrawal_date"})
}

test_house_spans_plots if {
	e := object.union(use, {"event_id": "A"})
	p := changed_plot({"uses": [e]})
	p2 := object.union(p, {"parcel_id": "p2"})
	parts := [{"parcel_id": "p1", "credited_events": ["A"], "full_area_creditable_treatment": true}, {"parcel_id": "p2", "credited_events": ["A"], "full_area_creditable_treatment": true}]
	unit := {"unit_id": "Haus-1", "structure": "fixed_glass", "parts": parts}
	rule.annual_minimum with input as profile with input.land as {"parcels": [p, p2], "protected_units": [unit]}
	not rule.annual_minimum with input as profile with input.land as {"parcels": [p], "protected_units": [unit]}
	not rule.annual_minimum with input as profile with input.land as {"parcels": [p], "protected_units": []}
}

test_partial_stages_and_exceptions if {
	rule.public_exception("10", 2024)
	not rule.public_exception("10", 2025)
	not rule.public_exception("13", 2026)
	rule.exit_window_open with input.farm.oepul13 as {"inspection_announced_or_started": false, "admin_result_communicated": false}
	not rule.exit_window_open with input.farm.oepul13 as {"inspection_announced_or_started": true, "admin_result_communicated": false}
	not rule.timely_entry with input.farm as {"year": 2023, "oepul13": {"measure_request_date": "2022-11-01"}}
	rule.timely_entry with input.farm as {"year": 2023, "oepul13": {"measure_request_date": "2022-11-02"}}
	rule.small_payment_discretion(50)
	not rule.small_payment_discretion(50.01)
}

test_farm_evidence_and_actions if {
	rule.full_conditionality with input.farm.oepul13 as {"conditionality_met": true, "social_conditionality_met": true}
	rule.breach_action(changed_plot({"breach_cause": "third_party_only"})).code == "maßnahmenbezogener OP"
	count(rule.op_reasons(dry)) == 0 with input as profile
	"Erntepflicht verfehlt" in rule.op_reasons(changed_plot({"harvested_removed_pct": 84, "harvest_exception_recognised": false})) with input as profile
	rule.trial_record_complete(changed_plot({"trial_prevents_compliance": true, "codes": ["VF"], "trial": {"approval_document": "A-123", "description": "Versuch", "location": "Parzelle Nord", "area_ha": 0.1}}))
}

test_size_components_follow_year_and_location if {
	rows := [
		{"code": "A", "area_m2": 4500, "country": "AT", "protected_cultivation": true},
		{"code": "GA", "area_m2": 400, "country": "AT", "protected_cultivation": true},
		{"code": "A", "area_m2": 20000, "country": "DE", "protected_cultivation": true},
		{"code": "Agroforststreifen", "area_m2": 10100, "country": "AT"},
		{"code": "NF-K20", "area_m2": 100, "country": "AT"},
	]
	rule.qualifying_size_ha == 1.5 with input as profile with input.land.mfa_area_components as rows
	rule.protected_size_ha == 0.49 with input as profile with input.land.mfa_area_components as rows
	rule.size_ok with input as profile with input.land.mfa_area_components as rows
	rule.qualifying_size_ha == 0.5 with input as profile with input.farm.year as 2024 with input.land.mfa_area_components as rows
	not rule.size_ok with input as profile with input.land.mfa_area_components as []
}

test_ancillary_classifications if {
	not rule.area_exception("Agroforststreifen", "1C", 2024)
	rule.area_exception("Agroforststreifen", "1C", 2025)
	rule.excluded_land_label("Sonstige Flächen im geschützten Anbau")
	rule.non_cereal_mixture({"crop": {"is_mixture": true, "cereal_share_pct": 49.99}})
	not rule.non_cereal_mixture({"crop": {"is_mixture": true, "cereal_share_pct": 50}})
	not rule.arable_fodder({"crop": {"crop_name": "Ackerweide", "exclusively_grazed": false}}) with input as profile
	rule.arable_fodder({"crop": {"crop_name": "Ackerweide", "exclusively_grazed": true}}) with input as profile
}
