package oepul.o6_19_test

import data.oepul.o6_19
import rego.v1

p1_patch(path, value) := with_patch([{"op": "add", "path": concat("", ["/land/parcels/0", path]), "value": value}])

test_unmet_binding_indicator_is_obligation_violation if {
	inp := p1_patch("/oepul/ebw/indicators/0/fulfilled", false)
	r := o6_19.parcel_results.P1 with input as inp
	"R-O619-INDICATORS-BINDING" in {v.rule_id | some v in r.obligation_violations}
	r.eligible_area_ha == 2
}

test_additional_indicator_not_binding if {
	r := o6_19.parcel_results.P1 with input as base_input
	count(r.obligation_violations) == 0
}

test_unknown_indicator_code if {
	inp := p1_patch("/oepul/ebw/indicators/0/code", "EBXX99")
	r := o6_19.parcel_results.P1 with input as inp
	"R-O619-INDICATOR-CATALOGUE" in {v.rule_id | some v in r.obligation_violations}
}

test_use_interval_violated if {
	inp := p1_patch("/oepul/ebw/last_use_or_care_year", 2023)
	r := o6_19.parcel_results.P1 with input as inp
	"R-O619-USE-EVERY-SECOND-YEAR" in {v.rule_id | some v in r.eligibility_failures}
	r.eligible_area_ha == 0
}

test_use_interval_previous_year_ok if {
	r := o6_19.parcel_results.P1 with input as base_input
	count(r.eligibility_failures) == 0
}

test_alpine_pasture_not_eligible if {
	inp := p1_patch("/land_use", "alpine_pasture")
	r := o6_19.parcel_results.P1 with input as inp
	"R-O619-ELIG-LAND-USE" in {v.rule_id | some v in r.eligibility_failures}
}

test_management_change_needs_written_amendment if {
	inp := with_patch([
		{"op": "add", "path": "/land/parcels/0/oepul/ebw/management_deviation", "value": true},
		{"op": "add", "path": "/land/parcels/0/oepul/ebw/deviation_agreed_with_coordination_body", "value": true},
	])
	r := o6_19.parcel_results.P1 with input as inp
	"R-O619-MGMT-CHANGE" in {v.rule_id | some v in r.obligation_violations}
	ok := json.patch(inp, [{"op": "add", "path": "/land/parcels/0/oepul/ebw/deviation_confirmation_amended_in_writing", "value": true}])
	r2 := o6_19.parcel_results.P1 with input as ok
	count(r2.obligation_violations) == 0
}

test_missing_reference_area_no_premium if {
	inp := p1_patch("/oepul/ebw/reference_area_present", false)
	r := o6_19.parcel_results.P1 with input as inp
	"R-O619-REFERENCE-AREA" in r.no_premium_reasons
	r.premium_eur == 0
}

test_gloez4_area_deducted if {
	inp := p1_patch("/oepul/gloez4_buffer_area_ha", 0.5)
	r := o6_19.parcel_results.P1 with input as inp
	r.eligible_area_ha == 1.5
}

test_gloez8_deducted_only_until_2024 if {
	inp2024 := with_patch([
		{"op": "replace", "path": "/farm/year", "value": 2024},
		{"op": "add", "path": "/land/parcels/1/oepul/gloez8_set_aside_area_ha", "value": 1.0},
	])
	a := o6_19.parcel_eligible_area.P2 with input as inp2024
	a == 2
	inp2025 := json.patch(inp2024, [{"op": "replace", "path": "/farm/year", "value": 2025}])
	b := o6_19.parcel_eligible_area.P2 with input as inp2025
	b == 3
}

test_npf_until_2024 if {
	inp := with_patch([
		{"op": "replace", "path": "/farm/year", "value": 2024},
		{"op": "replace", "path": "/land/parcels/1/oepul/codes", "value": ["EBW", "NPF"]},
	])
	r := o6_19.parcel_results.P2 with input as inp
	"R-O619-NPF-GLOEZ8" in r.no_premium_reasons
	o6_19.gloez8_creditable_set_aside.P2 with input as inp
	later := json.patch(inp, [{"op": "replace", "path": "/farm/year", "value": 2025}])
	r2 := o6_19.parcel_results.P2 with input as later
	not "R-O619-NPF-GLOEZ8" in r2.no_premium_reasons
}

test_op_and_vf_codes if {
	op := with_patch([{"op": "replace", "path": "/land/parcels/0/oepul/codes", "value": ["EBW", "OP"]}])
	res1 := o6_19.parcel_results.P1 with input as op
	"R-O619-GEN-OP-CODE" in res1.no_premium_reasons
	vf := with_patch([{"op": "replace", "path": "/land/parcels/0/oepul/codes", "value": ["EBW", "VF"]}])
	res2 := o6_19.parcel_results.P1 with input as vf
	"R-O619-GEN-TRIAL-AREA" in res2.no_premium_reasons
}

test_national_parks if {
	neusiedl := p1_patch("/oepul/national_park", "Neusiedlersee")
	res3 := o6_19.parcel_results.P1 with input as neusiedl
	"R-O619-GEN-NATIONAL-PARK" in res3.no_premium_reasons
	other_no_req := with_patch([
		{"op": "add", "path": "/land/parcels/0/oepul/national_park", "value": "Hohe Tauern"},
		{"op": "add", "path": "/land/parcels/0/oepul/national_park_relevant_requirements", "value": false},
	])
	res4 := o6_19.parcel_results.P1 with input as other_no_req
	not "R-O619-GEN-NATIONAL-PARK" in res4.no_premium_reasons
}

test_parcel_not_in_austria if {
	inp := p1_patch("/oepul/located_in_austria", false)
	res5 := o6_19.parcel_results.P1 with input as inp
	"R-O619-GEN-LOCATION-AT" in res5.no_premium_reasons
}

test_combination_conflicts if {
	bad := p1_patch("/oepul/other_measure_premium_claims", [{"measure": "1A", "component": "area_premium"}, {"measure": "23", "component": "area_premium"}])
	c := o6_19.parcel_results.P1.combination_conflicts with input as bad
	c == {"1A"}
	ok := p1_patch("/oepul/other_measure_premium_claims", [{"measure": "1B", "component": "landscape_elements"}, {"measure": "23", "component": "area_premium"}])
	c2 := o6_19.parcel_results.P1.combination_conflicts with input as ok
	count(c2) == 0
}

test_rate_lookup_tables if {
	r1 := o6_19.base_rate({"premium_table": "wiesen", "premium_habitat": "Trockenrasen", "conservation_status": "A", "difficulty": "schwer"}) with input as base_input
	r1 == 1210
	r2 := o6_19.base_rate({"premium_table": "weiden", "premium_habitat": "Weidehalbtrockenrasen", "conservation_status": "C"}) with input as base_input
	r2 == 696.6
	r3 := o6_19.base_rate({"premium_table": "acker", "premium_habitat": "Intensiv bewirtschafteter Acker mit Tierziel", "conservation_status": "B"}) with input as base_input
	r3 == 280.8
	not o6_19.base_rate({"premium_table": "wiesen", "premium_habitat": "Lärchenwiese", "conservation_status": "A", "difficulty": "leicht"}) with input as base_input
	not o6_19.base_rate({"premium_table": "acker", "premium_habitat": "Artenarme Ackerbrache", "conservation_status": "A"}) with input as base_input
}

test_braunkehlchen_rate_by_year if {
	e := {"premium_table": "voegel", "premium_habitat": "Braunkehlchen", "conservation_status": "A"}
	r2024 := o6_19.base_rate(e) with input as with_patch([{"op": "replace", "path": "/farm/year", "value": 2024}])
	r2024 == 837
	r2025 := o6_19.base_rate(e) with input as with_patch([{"op": "replace", "path": "/farm/year", "value": 2025}])
	r2025 == 1053
}

test_no_rates_for_2023 if {
	inp := with_patch([{"op": "replace", "path": "/farm/year", "value": 2023}])
	not o6_19.base_rate({"premium_table": "weiden", "premium_habitat": "Frische Magerweide", "conservation_status": "A"}) with input as inp
}

test_ebba02_rules if {
	e2024 := with_patch([
		{"op": "replace", "path": "/farm/year", "value": 2024},
		{"op": "replace", "path": "/land/parcels/0/oepul/ebw/surcharge_codes", "value": ["EBBA02"]},
		{"op": "replace", "path": "/land/parcels/0/oepul/ebw/conservation_status", "value": "A"},
	])
	res6 := o6_19.parcel_results.P1 with input as e2024
	"ebba_not_admissible" in res6.rate_issues
	e2025 := json.patch(e2024, [
		{"op": "replace", "path": "/farm/year", "value": 2025},
		{"op": "replace", "path": "/land/parcels/0/oepul/ebw/difficulty", "value": "leicht"},
	])

	# 1.296,0 + 162,0
	r := o6_19.parcel_rate.P1 with input as e2025
	r == 1458
	status_b := json.patch(e2025, [{"op": "replace", "path": "/land/parcels/0/oepul/ebw/conservation_status", "value": "B"}])
	res7 := o6_19.parcel_results.P1 with input as status_b
	"ebba_not_admissible" in res7.rate_issues
}

test_ebba_only_once if {
	inp := p1_patch("/oepul/ebw/surcharge_codes", ["EBBA01", "EBBA02"])
	res8 := o6_19.parcel_results.P1 with input as inp
	"ebba_not_admissible" in res8.rate_issues
}

test_ebba_reason_constraints if {
	small := with_patch([
		{"op": "replace", "path": "/land/parcels/0/oepul/ebw/ebba_reason_id", "value": "kleinflaechigkeit"},
		{"op": "replace", "path": "/land/parcels/0/oepul/ebw/difficulty", "value": "leicht"},
	])
	res9 := o6_19.parcel_results.P1 with input as small
	"ebba_not_admissible" in res9.rate_issues
	ok := json.patch(small, [{"op": "replace", "path": "/land/parcels/0/area_ha", "value": 0.3}])
	res10 := o6_19.parcel_results.P1 with input as ok
	not "ebba_not_admissible" in res10.rate_issues
	neo := p1_patch("/oepul/ebw/ebba_reason_id", "neophytenbekaempfung")
	issues := o6_19.ebba_reason_issues(object.union(neo.land.parcels[0].oepul.ebw, {"parcel_area_ha": 2})) with input as neo
	"required_indicator_missing" in issues
}

test_ebba_tierziel_exclusion if {
	e := {
		"premium_table": "voegel", "premium_habitat": "Wachtelkönig", "conservation_status": "A",
		"ebba_reason_id": "tierziel", "indicators": [{"code": "EBGT18"}], "parcel_area_ha": 1,
	}
	"animal_indicator_excluded_for_habitat" in o6_19.ebba_reason_issues(e) with input as base_input
	e2 := object.union(e, {"indicators": [{"code": "EBGT18"}, {"code": "EBGT09"}]})
	not "animal_indicator_excluded_for_habitat" in o6_19.ebba_reason_issues(e2) with input as base_input
}

test_ebhg_surcharge if {
	inp := with_patch([
		{"op": "add", "path": "/land/parcels/1/oepul/ebw/surcharge_codes", "value": ["EBHG02"]},
		{"op": "add", "path": "/land/parcels/1/oepul/ebw/schutzgut_layer_share_percent", "value": 60},
		{"op": "add", "path": "/land/parcels/1/oepul/ebw/habitat_area_reported_in_gis", "value": true},
	])
	r := o6_19.parcel_rate.P2 with input as inp
	r == 745.2
	low := json.patch(inp, [{"op": "replace", "path": "/land/parcels/1/oepul/ebw/schutzgut_layer_share_percent", "value": 40}])
	r2 := o6_19.parcel_rate.P2 with input as low
	r2 == 637.2
}

test_set_aside_cap if {
	inp := with_patch([{"op": "replace", "path": "/land/arable_area_ha", "value": 4}])
	f := o6_19.set_aside_factor with input as inp

	# max(25 % von 4 ha, 2 ha) = 2 ha bei 3 ha Stilllegung
	f == 2 / 3
	a := o6_19.parcel_premium_area.P2 with input as inp
	a == 2
}

test_area_increase_limit if {
	inp := with_patch([{"op": "replace", "path": "/oepul/o6_19/ebw_area_2025_ha", "value": 1.0}])

	# erlaubt: 1 + max(0,5; 5) = 6 ha > 5 ha -> kein Abzug
	f := o6_19.access_increase_factor with input as inp
	f == 1
	big := with_patch([
		{"op": "replace", "path": "/oepul/o6_19/ebw_area_2025_ha", "value": 0.5},
		{"op": "replace", "path": "/land/parcels/0/area_ha", "value": 8.0},
	])

	# erlaubt 5,5 ha bei 11 ha
	f2 := o6_19.access_increase_factor with input as big
	f2 == 0.5
}

test_modulation_example_220_ha if {
	inp := with_patch([{"op": "replace", "path": "/land/total_area_ha", "value": 220}])
	f := o6_19.modulation_factor with input as inp
	round(f * 10000) == 9909
}

test_premium_cap_with_other_payments if {
	inp := p1_patch("/oepul/other_area_payments_eur_per_ha", 200)
	r := o6_19.parcel_rate_after_reductions.P1 with input as inp
	r == 1300
}

test_sanction_stages if {
	s5 := with_patch([{"op": "add", "path": "/oepul/o6_19/sanctions", "value": {"stage": 2}}])
	p := o6_19.sanction_reduction_percent with input as s5
	p == 5
	w2026 := with_patch([{"op": "add", "path": "/oepul/o6_19/sanctions", "value": {"stage": 0}}])
	o6_19.sanction_reduction_percent == 0 with input as w2026
	w2027 := json.patch(w2026, [{"op": "replace", "path": "/farm/year", "value": 2027}])
	o6_19.sanction_reduction_percent == 1 with input as w2027
}

test_two_full_reductions_exclude if {
	inp := with_patch([{"op": "add", "path": "/oepul/o6_19/sanctions", "value": {"stage": 6, "count_100_percent": 2}}])
	d := o6_19.decision with input as inp
	d.measure_premium_eur == 0
	d.repayment_of_past_premiums_required == true
	d.eligible == false
}

test_payment_may_be_withheld if {
	inp := with_patch([
		{"op": "replace", "path": "/land/parcels/0/area_ha", "value": 0.01},
		{"op": "replace", "path": "/land/parcels/1/area_ha", "value": 0.01},
		{"op": "replace", "path": "/oepul/o6_19/regional_plan/applied", "value": false},
	])
	o6_19.payment_may_be_withheld with input as inp
}

test_low_ecological_value_excluded if {
	inp := p1_patch("/oepul/ebw/ecological_value_too_low", true)
	r := o6_19.parcel_results.P1 with input as inp
	"R-O619-K-LOW-VALUE-EXCLUDED" in {v.rule_id | some v in r.eligibility_failures}
	r.eligible_area_ha == 0
}

test_pb_design_issues if {
	inp := with_patch([
		{"op": "add", "path": "/land/parcels/0/oepul/ebw/is_grassland_fallow", "value": true},
		{"op": "replace", "path": "/land/parcels/0/oepul/ebw/conservation_status", "value": "A"},
		{"op": "add", "path": "/land/parcels/1/oepul/ebw/managed_as_grassland", "value": true},
	])
	r1 := o6_19.parcel_results.P1 with input as inp
	"fallow_conservation_status_must_be_c_or_b" in r1.project_confirmation_design_issues
	r2 := o6_19.parcel_results.P2 with input as inp
	"arable_managed_as_grassland_needs_grassland_indicators" in r2.project_confirmation_design_issues
	small := with_patch([
		{"op": "add", "path": "/land/parcels/0/oepul/ebw/split_by_habitat_type", "value": true},
		{"op": "replace", "path": "/land/parcels/0/area_ha", "value": 0.05},
	])
	r3 := o6_19.parcel_results.P1 with input as small
	"habitat_split_parcel_below_0_1_ha" in r3.project_confirmation_design_issues
}

test_farm_level_constants if {
	o6_19.additional_measure_required == false
	"18" in o6_19.farm_level_combinable_measures
}
