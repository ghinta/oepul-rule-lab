package oepul.o6_19_test

import data.oepul.o6_19
import rego.v1

test_base_parcels_creditable if {
	ids := o6_19.creditable_bdf_ids with input as base_input
	ids == {"P1", "P2"}
}

test_no_ubb_bio_no_crediting if {
	inp := with_patch([{"op": "replace", "path": "/oepul/participation/ubb", "value": false}])
	ids := o6_19.creditable_bdf_ids with input as inp
	count(ids) == 0
	res1 := o6_19.parcel_results.P1 with input as inp
	"no_ubb_or_bio_participation" in res1.biodiversity_crediting_issues
}

test_bio_participation_allows_crediting if {
	inp := with_patch([
		{"op": "replace", "path": "/oepul/participation/ubb", "value": false},
		{"op": "replace", "path": "/oepul/participation/bio", "value": true},
	])
	"P1" in o6_19.creditable_bdf_ids with input as inp
}

test_habitat_not_listed if {
	inp := with_patch([{"op": "replace", "path": "/land/parcels/0/oepul/ebw/chapter7_habitat", "value": "Intensivwiese"}])
	res2 := o6_19.parcel_results.P1 with input as inp
	"habitat_not_in_chapter7_list" in res2.biodiversity_crediting_issues
}

test_usage_type_restricted_per_habitat_group if {
	# einmähdiger Lebensraum: zwei Nutzungen nicht zulässig
	one := with_patch([{"op": "replace", "path": "/land/parcels/0/oepul/usage_type", "value": "Mähwiese/-weide zwei Nutzungen"}])
	res3 := o6_19.parcel_results.P1 with input as one
	"usage_type_not_allowed_for_habitat" in res3.biodiversity_crediting_issues

	# ein- oder zweimähdiger Lebensraum: zwei Nutzungen zulässig
	two := json.patch(one, [{"op": "replace", "path": "/land/parcels/0/oepul/ebw/chapter7_habitat", "value": "Wachtelkönig-Lebensraum"}])
	"P1" in o6_19.creditable_bdf_ids with input as two
}

test_arable_set_aside_needs_gruenbrache_and_div if {
	inp := with_patch([{"op": "replace", "path": "/land/parcels/1/oepul/usage_type", "value": "Sonstige Ackerfläche"}])
	not "P2" in o6_19.creditable_bdf_ids with input as inp
	res4 := o6_19.parcel_results.P2 with input as inp
	"set_aside_requires_gruenbrache_and_div" in res4.biodiversity_crediting_issues
	divsz := with_patch([{"op": "replace", "path": "/land/parcels/1/oepul/codes", "value": ["EBW", "DIVSZ"]}])
	not "P2" in o6_19.creditable_bdf_ids with input as divsz
}

test_managed_arable_not_creditable if {
	inp := with_patch([{"op": "replace", "path": "/land/parcels/1/oepul/ebw/is_arable_set_aside", "value": false}])
	res5 := o6_19.parcel_results.P2 with input as inp
	"arable_only_set_aside_creditable" in res5.biodiversity_crediting_issues
}

test_field_piece_015_rule if {
	inp := with_patch([
		{"op": "add", "path": "/oepul/o6_19/all_oepul_area_ebw_eligible", "value": true},
		{"op": "replace", "path": "/land/parcels/0/oepul/codes", "value": ["EBW"]},
		{"op": "replace", "path": "/land/parcels/0/oepul/field_piece_area_ha", "value": 6.0},
	])
	v := o6_19.field_piece_bdf_violations with input as inp
	count(v) == 1
	fixed := json.patch(inp, [{"op": "add", "path": "/land/parcels/-", "value": {
		"parcel_id": "P3", "area_ha": 0.15, "land_use": "grassland",
		"oepul": {"codes": ["DIVSZ"], "field_piece_id": "FS1", "field_piece_area_ha": 6.0},
	}}])
	v2 := o6_19.field_piece_bdf_violations with input as fixed
	count(v2) == 0
}

test_field_piece_rule_only_whole_farm_case if {
	inp := with_patch([
		{"op": "replace", "path": "/land/parcels/0/oepul/codes", "value": ["EBW"]},
		{"op": "replace", "path": "/land/parcels/0/oepul/field_piece_area_ha", "value": 6.0},
	])
	v := o6_19.field_piece_bdf_violations with input as inp
	count(v) == 0
}

test_farm_min_size_first_year if {
	inp := with_patch([
		{"op": "replace", "path": "/oepul/first_oepul_participation_year", "value": 2026},
		{"op": "replace", "path": "/land/total_area_ha", "value": 1.2},
	])
	"R-O619-GEN-FARM-MIN-SIZE" in rule_ids(o6_19.general_violations) with input as inp
	ga := json.patch(inp, [{"op": "add", "path": "/oepul/protected_cultivation_area_ha", "value": 0.5}])
	not "R-O619-GEN-FARM-MIN-SIZE" in rule_ids(o6_19.general_violations) with input as ga
}

test_public_body_excluded if {
	inp := with_patch([{"op": "replace", "path": "/oepul/applicant", "value": {"type": "public_body"}}])
	"R-O619-GEN-APPLICANT" in rule_ids(o6_19.general_violations) with input as inp
	share := with_patch([{"op": "replace", "path": "/oepul/applicant", "value": {"type": "legal_person", "public_body_share_percent": 30}}])
	"R-O619-GEN-APPLICANT" in rule_ids(o6_19.general_violations) with input as share
	ok := with_patch([{"op": "replace", "path": "/oepul/applicant", "value": {"type": "legal_person", "public_body_share_percent": 25}}])
	not "R-O619-GEN-APPLICANT" in rule_ids(o6_19.general_violations) with input as ok
}

test_control_refusal if {
	inp := with_patch([{"op": "add", "path": "/oepul/control_refused", "value": true}])
	"R-O619-GEN-CONTROL-REFUSAL" in rule_ids(o6_19.general_violations) with input as inp
}

test_area_decrease_tolerance if {
	# Vorjahr 6 ha, aktuell 5 ha: Toleranz max(min(0,3; 5); 0,5) = 0,5 ha -> 1 ha Rückzahlungsfläche
	inp := with_patch([{"op": "replace", "path": "/oepul/o6_19/previous_year_ebw_area_ha", "value": 6.0}])
	a := o6_19.area_decrease_repayment_area_ha with input as inp
	a == 1
	small := with_patch([{"op": "replace", "path": "/oepul/o6_19/previous_year_ebw_area_ha", "value": 5.4}])
	b := o6_19.area_decrease_repayment_area_ha with input as small
	b == 0
	exempt := json.patch(inp, [{"op": "add", "path": "/oepul/o6_19/area_decrease_exempt_ha", "value": 1.0}])
	c := o6_19.area_decrease_repayment_area_ha with input as exempt
	c == 0
}

test_early_exit_repayment if {
	inp := with_patch([{"op": "add", "path": "/oepul/o6_19/exited_before_contract_end", "value": true}])
	o6_19.repayment_of_past_premiums_required with input as inp
}

test_deregistration_invalidates_year if {
	inp := with_patch([{"op": "add", "path": "/oepul/o6_19/deregistered_in_year", "value": true}])
	d := o6_19.decision with input as inp
	d.eligible == false
}

test_measure_switch_deadline if {
	ok := with_patch([{"op": "add", "path": "/oepul/o6_19/switch", "value": {"from": "19", "to": "18", "effective_date": "2025-12-31"}}])
	o6_19.switch_allowed with input as ok
	late := with_patch([{"op": "add", "path": "/oepul/o6_19/switch", "value": {"from": "19", "to": "18", "effective_date": "2026-01-01"}}])
	not o6_19.switch_allowed with input as late
	berg := with_patch([{"op": "add", "path": "/oepul/o6_19/switch", "value": {"from": "4", "to": "19", "effective_date": "2025-01-01"}}])
	o6_19.switch_allowed with input as berg
	ubb := with_patch([{"op": "add", "path": "/oepul/o6_19/switch", "value": {"from": "1A", "to": "19", "effective_date": "2025-01-01"}}])
	not o6_19.switch_allowed with input as ubb
}

test_takeover_rules if {
	y2028 := with_patch([
		{"op": "replace", "path": "/farm/year", "value": 2028},
		{"op": "add", "path": "/oepul/o6_19/takeover", "value": {"date": "2028-04-17", "expansion_share": 0.3}},
	])
	o6_19.takeover_allowed with input as y2028
	y2027 := with_patch([
		{"op": "replace", "path": "/farm/year", "value": 2027},
		{"op": "add", "path": "/oepul/o6_19/takeover", "value": {"date": "2027-04-16", "expansion_share": 0.3}},
	])
	not o6_19.takeover_allowed with input as y2027
	rnp := with_patch([{"op": "add", "path": "/oepul/o6_19/takeover", "value": {"date": "2026-04-01", "expansion_share": 0.1, "includes_regional_plan": true}}])
	not o6_19.takeover_allowed with input as rnp
	too_big := with_patch([{"op": "add", "path": "/oepul/o6_19/takeover", "value": {"date": "2026-04-01", "expansion_share": 0.6}}])
	not o6_19.takeover_allowed with input as too_big
}

test_gruenbrache_min_management_exempt if {
	o6_19.min_management_criteria_exempt.P2 with input as base_input
	not o6_19.min_management_criteria_exempt.P1 with input as base_input
}

test_transfer_requires_op_code if {
	inp := with_patch([{"op": "add", "path": "/land/parcels/0/oepul/transferred_during_year", "value": true}])
	o6_19.transfer_requires_op_code.P1 with input as inp
}

test_circumstances if {
	perm := with_patch([{"op": "add", "path": "/oepul/o6_19/circumstance", "value": {"kind": "permanent", "occurred_date": "2026-05-02", "outside_control": true, "reported_in_time": true}}])
	o6_19.premium_in_circumstance_year with input as perm
	o6_19.no_repayment_due_to_circumstance with input as perm
	early := with_patch([{"op": "add", "path": "/oepul/o6_19/circumstance", "value": {"kind": "permanent", "occurred_date": "2026-03-01"}}])
	not o6_19.premium_in_circumstance_year with input as early
}

test_payment_timing if {
	d := o6_19.payment_deadline with input as base_input
	d == "2027-06-30"
	a := o6_19.max_advance_payment_eur with input as base_input
	a == 3886.2
}

test_notice_2026_bdf_projektbestaetigung if {
	inp := with_patch([{"op": "add", "path": "/land/parcels/1/oepul/ebw/use_2026", "value": {"third_use": true}}])
	f := o6_19.notice_2026_findings with input as inp
	count(f) == 1
	o6_19.drought_bdf_exception_available.P2 == false with input as base_input
	o6_19.nat_release_applies_to_ebw == false with input as base_input
}

test_notice_2026_harvest_areas if {
	harvest := {"no_harvestable_stand_due_to_drought": true, "late_summer_or_autumn_crop": true, "obligation_not_met_due_to_drought": true}
	bgld := with_patch([{"op": "add", "path": "/land/parcels/1/oepul/harvest_2026", "value": harvest}])
	o6_19.harvest_obligation_waived.P2 with input as bgld
	graz := json.patch(bgld, [{"op": "replace", "path": "/farm/region", "value": {"federal_state": "Steiermark", "district": "Graz-Umgebung"}}])
	o6_19.harvest_obligation_waived.P2 with input as graz
	liezen := json.patch(bgld, [{"op": "replace", "path": "/farm/region", "value": {"federal_state": "Steiermark", "district": "Liezen"}}])
	not o6_19.harvest_obligation_waived.P2 with input as liezen
	o6_19.force_majeure_application_required.P2 with input as liezen
	y2025 := json.patch(bgld, [{"op": "replace", "path": "/farm/year", "value": 2025}])
	not o6_19.harvest_obligation_waived.P2 with input as y2025
}

test_data_tables_complete if {
	groups := data.oepul_o6_19.creditable_habitats.groups
	count(groups[0].habitats) == 35
	count(groups[1].habitats) == 46
	r := data.oepul_o6_19.premium_rates
	count(r.wiesen) == 18
	count(r.weiden) == 7
	count(r.voegel) == 3
	count(r.acker) == 4
	count({i.code | some i in data.oepul_o6_19.indicators.catalogue}) == 100
	count(data.oepul_o6_19.ebba_reasons.reasons) == 15
}
