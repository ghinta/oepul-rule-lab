package oepul.general_test

import data.oepul.o6_11 as m
import rego.v1

test_modulation if {
	m.modulation_factor(200) == 1
	round(10000 * m.modulation_factor(220)) == 9909
	m.modulation_factor(300) * 300 == 290
	round(m.modulation_factor(1100) * 1100) == 960
	not m.modulation_factor(0)
}

test_same_parcel_matrix if {
	m.combination("11", "1A").mark == "x 1)"
	m.combination("11", "1B").mark == ""
	every other in {"2", "10", "12"} { m.combination("11", other).mark == "x" }
	m.combination("12", "10").mark == "x 3)"
	m.combination("11", "10").notes == {}
}

test_minimum_farm_size if {
	m.farm_size_ok with input.farm as {"year": 2023, "opul": {"first_year": 2023, "protected_at_ha": 0.5, "qualifying_at_ha": 0.5}}
	not m.farm_size_ok with input.farm as {"year": 2023, "opul": {"first_year": 2023, "protected_at_ha": 0, "qualifying_at_ha": 1.49}}
	m.farm_size_ok with input.farm as {"year": 2024, "opul": {"first_year": 2023}}
}

test_public_influence_boundary if {
	a := {"form": "legal", "public_share_pct": 25, "public_entity_or_controlled": false, "own_name": true, "own_account": true, "controls_land": true, "active_farmer": true, "agricultural_activity": true}
	m.applicant_ok with input.farm.applicant as a
	not m.applicant_ok with input.farm.applicant as object.union(a, {"public_share_pct": 25.01})
}

test_recovery_whole_difference if {
	m.annual_loss_review(8, 0.5).recoverable_area_ha == 0
	m.annual_loss_review(100, 5.01).recoverable_area_ha == 5.01
	m.loss_tolerance(1000) == 5
}

test_takeover_deadline_and_fifty_percent if {
	a := {"filed": "2028-04-17", "previously_participating": false, "submitted_online": true, "ama_approved": true, "transferred_ha": 1, "extra_ha": 0.5}
	m.takeover_ok with input.farm as {"year": 2028, "o6_11": {"takeover": a}}
	not m.takeover_ok with input.farm as {"year": 2028, "o6_11": {"takeover": object.union(a, {"extra_ha": 0.501})}}
	not m.takeover_ok with input.farm as {"year": 2027, "o6_11": {"takeover": object.union(a, {"filed": "2027-04-17"})}}
}

test_sanctions if {
	m.sanction("warning", 2026, 0).percent == 0
	m.sanction("warning", 2027, 0).percent == 1
	m.sanction("100", 2026, 1).exclusion_and_recovery
	m.sanction("100", 2026, 0).exclusion_and_recovery == false
}

test_cap_scope_changes if {
	p := [{"measure": "11", "eur_ha": 270}, {"measure": "other", "eur_ha": 1030}, {"measure": "10", "eur_ha": 210}]
	m.capped_parcel_sum("general", 2024, p) == 1510
	m.capped_parcel_sum("general", 2025, p) == 1300
}

test_park_and_op if {
	p := {"parcel_id": "p", "mfa": {"national_park": "Donau-Auen", "codes": ["OPBIO"]}}
	r := m.parcel_exclusions with input.land.parcels as [p]
	r.p == {"Nationalpark"}
}

test_drought_scope if {
	p := {"land_use": "arable", "mfa": {"country": "AT", "federal_state": "Steiermark", "district": "Weiz"}, "operations": {"drought": {"late_summer_or_autumn_harvest": true, "sensitive_crop": true, "no_harvestable_stand": true}}}
	m.drought_harvest_relief(p, 2026)
	not m.drought_harvest_relief(object.union(p, {"land_use": "special_crop"}), 2026)
	not m.drought_harvest_relief(object.union(p, {"mfa": {"district": "Leoben"}}), 2026)
}

test_payment_dates_and_limits if {
	m.payment_due(2028) == "2029-06-30"
	m.maximum_advance(200, true) == 150
	not m.maximum_advance(200, false)
	m.small_payment_discretion(50)
	not m.small_payment_discretion(50.01)
}

test_op_scope_and_general_obligations if {
	p := {"parcel_id": "s", "mfa": {"country": "AT"}, "crop": {"crop_category": "vineyard"}, "commitment_change": {"reason": "third_party_fault"}}
	r := m.required_op_markings with input as {"land": {"parcels": [p]}, "farm": {"year": 2026, "o6_11": {"first_year": 2023, "active": true}}}
	r.s == {"OP für Maßnahme 11"}
}

test_procedural_windows if {
	p := {"inspection_announced_or_started": false, "admin_result_received": false, "payment_notice_received": false, "inspection_objection": false}
	m.ordinary_exit_window_open with input.farm.opul_procedure as p
	m.combination_correction_open with input.farm.opul_procedure as p
	not m.combination_correction_open with input.farm.opul_procedure as object.union(p, {"inspection_objection": true})
}

test_trial_requires_documents_and_vf if {
	p := {"parcel_id": "t", "mfa": {"approved_trial_prevents_compliance": true, "codes": []}, "commitment_change": {"area_documented": false}}
	r := m.trial_documentation_findings with input.land.parcels as [p]
	{f.missing | some f in r} == {"VF", "area_documented"}
}

test_matrix_footnotes if {
	m.combination_terms("11", "1A", []).basis == "nur Landschaftselemente"
	m.combination_terms("11", "10", ["10_organisms"]).basis == "auf der Einzelfläche kombinierbar"
	m.combination_terms("12", "10", ["10_organisms"]).supplement_factor == 0.5
	m.combination_terms("13", "11", ["13_pot_substrate"]).compatible == false
	m.combination_terms("16", "1B", ["16_psm_waiver"]).compatible == false
	m.combination_terms("16", "8", ["16_vienna"]).compatible == false
}
