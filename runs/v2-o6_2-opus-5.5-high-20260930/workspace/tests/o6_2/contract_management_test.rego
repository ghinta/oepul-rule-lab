package oepul.o6_2_test

import data.oepul.o6_2

test_contract_period_lookup if {
	cp := o6_2.contract_period with input as base_input
	cp.duration_years == 5
	cp.contract_end == "2028-12-31"
}

test_voluntary_exit_requires_repayment if {
	inp := with_oepul("o6_2/exit", {"exit_date": "2026-01-01", "reason": "voluntary"})
	o6_2.repayment_of_all_premiums_required with input as inp
}

test_loss_of_control_exit_no_repayment if {
	inp := with_oepul("o6_2/exit", {"exit_date": "2026-01-01", "reason": "loss_of_control"})
	not o6_2.repayment_of_all_premiums_required with input as inp
}

test_switch_to_bio_until_2025_no_repayment if {
	inp := json.patch(base_input, [
		{"op": "add", "path": "/farm/oepul/o6_2/exit", "value": {"exit_date": "2025-12-31", "reason": "voluntary"}},
		{"op": "add", "path": "/farm/oepul/o6_2/switched_to_bio_date", "value": "2025-12-31"},
	])
	not o6_2.repayment_of_all_premiums_required with input as inp
	late := json.patch(inp, [{"op": "replace", "path": "/farm/oepul/o6_2/switched_to_bio_date", "value": "2026-12-31"}])
	o6_2.repayment_of_all_premiums_required with input as late
}

test_farm_transfer_continues_contract if {
	inp := with_oepul("o6_2/exit", {"exit_date": null, "reason": "farm_transfer"})
	o6_2.farm_transfer_continues_contract with input as inp
	not o6_2.repayment_of_all_premiums_required with input as inp
}

test_area_decrease_tolerance if {
	# 40 ha Vorjahr: 5 % = 2 ha
	inp := json.patch(base_input, [
		{"op": "add", "path": "/farm/oepul/o6_2/previous_year_committed_area_ha", "value": 40},
		{"op": "add", "path": "/farm/oepul/o6_2/area_reduction_ha", "value": 2},
	])
	tol := o6_2.area_decrease_tolerance_ha with input as inp
	tol == 2
	rep := o6_2.area_decrease_repayment_ha with input as inp
	rep == 0
	over := json.patch(inp, [{"op": "replace", "path": "/farm/oepul/o6_2/area_reduction_ha", "value": 2.5}])
	rep_over := o6_2.area_decrease_repayment_ha with input as over
	rep_over == 2.5
}

test_area_decrease_tolerance_min_and_max if {
	small := json.patch(base_input, [{"op": "add", "path": "/farm/oepul/o6_2/previous_year_committed_area_ha", "value": 4}])
	tol_small := o6_2.area_decrease_tolerance_ha with input as small
	tol_small == 0.5
	big := json.patch(base_input, [{"op": "add", "path": "/farm/oepul/o6_2/previous_year_committed_area_ha", "value": 400}])
	tol_big := o6_2.area_decrease_tolerance_ha with input as big
	tol_big == 5
}

test_allowed_conversions if {
	o6_2.conversion_allowed("A", "G")
	o6_2.conversion_allowed("WI", "D")
	o6_2.conversion_allowed("G", "L")
	o6_2.conversion_allowed("A", "LSE_MEHRNUTZENHECKE")
	not o6_2.conversion_allowed("G", "A")
}

test_takeover_deadlines if {
	o6_2.takeover_deadline(2026) == "2026-04-15"
	o6_2.takeover_deadline(2028) == "2028-04-17"
	ok := with_oepul("o6_2/takeover", {"takeover_date": "2026-04-15", "taker_previously_participating": false, "extension_percent": 50})
	o6_2.takeover_valid with input as ok
	late := with_oepul("o6_2/takeover", {"takeover_date": "2026-04-16", "taker_previously_participating": false, "extension_percent": 10})
	not o6_2.takeover_valid with input as late
	ext := with_oepul("o6_2/takeover", {"takeover_date": "2026-04-01", "taker_previously_participating": false, "extension_percent": 60})
	not o6_2.takeover_valid with input as ext
}

test_transfer_without_continuation_requires_op if {
	inp := with_parcel(0, "transferred_during_year_without_continuation", true)
	pids := o6_2.parcels_requiring_op_code with input as inp
	"A1" in pids
}

test_control_refusal_not_eligible if {
	inp := with_oepul("on_site_control_refused", true)
	not o6_2.eligible with input as inp
}

test_sanction_percent_function if {
	o6_2.sanction_percent_for("warning", 2026) == 0
	o6_2.sanction_percent_for("warning", 2027) == 1
	o6_2.sanction_percent_for("reduction_25", 2027) == 25
}

test_harvest_below_85_excludes_parcel if {
	inp := with_parcel(0, "operations/harvested_share_percent", 70)
	excl := o6_2.parcel_exclusions with input as inp
	["A1", "minimum_management_not_met"] in excl
}

test_drought_2026_exemption_in_listed_district if {
	inp := json.patch(base_input, [
		{"op": "replace", "path": "/farm/region", "value": {"federal_state": "Niederösterreich", "district": "Mistelbach"}},
		{"op": "replace", "path": "/land/parcels/0/crop", "value": {"crop_category": "maize", "crop_name": "Körnermais", "usually_harvested_late_summer_or_autumn": true}},
		{"op": "replace", "path": "/land/parcels/0/operations/harvested_share_percent", "value": 0},
		{"op": "add", "path": "/land/parcels/0/operations/no_harvestable_crop_due_to_drought", "value": true},
	])
	excl := o6_2.parcel_exclusions with input as inp
	not ["A1", "minimum_management_not_met"] in excl
	fm := o6_2.force_majeure_application_required with input as inp
	not "A1" in fm
}

test_drought_2026_styria_extension if {
	inp := json.patch(base_input, [
		{"op": "replace", "path": "/farm/region", "value": {"federal_state": "Steiermark", "district": "Leibnitz"}},
		{"op": "replace", "path": "/land/parcels/0/crop", "value": {"crop_category": "oilseed", "crop_name": "Sojabohne", "usually_harvested_late_summer_or_autumn": true}},
		{"op": "replace", "path": "/land/parcels/0/operations/harvested_share_percent", "value": 0},
		{"op": "add", "path": "/land/parcels/0/operations/no_harvestable_crop_due_to_drought", "value": true},
	])
	o6_2.drought_harvest_exemption(inp.land.parcels[0]) with input as inp
}

test_drought_outside_district_requires_application if {
	inp := json.patch(base_input, [
		{"op": "replace", "path": "/land/parcels/0/crop", "value": {"crop_category": "maize", "crop_name": "Körnermais", "usually_harvested_late_summer_or_autumn": true}},
		{"op": "replace", "path": "/land/parcels/0/operations/harvested_share_percent", "value": 0},
		{"op": "add", "path": "/land/parcels/0/operations/no_harvestable_crop_due_to_drought", "value": true},
	])
	fm := o6_2.force_majeure_application_required with input as inp
	"A1" in fm
	excl := o6_2.parcel_exclusions with input as inp
	["A1", "minimum_management_not_met"] in excl
}

test_drought_exemption_only_2026 if {
	inp := json.patch(base_input, [
		{"op": "replace", "path": "/farm/year", "value": 2025},
		{"op": "replace", "path": "/farm/region", "value": {"federal_state": "Burgenland", "district": "Neusiedl am See"}},
		{"op": "replace", "path": "/land/parcels/0/crop", "value": {"crop_category": "maize", "crop_name": "Körnermais", "usually_harvested_late_summer_or_autumn": true}},
		{"op": "add", "path": "/land/parcels/0/operations/no_harvestable_crop_due_to_drought", "value": true},
	])
	not o6_2.drought_harvest_exemption(inp.land.parcels[0]) with input as inp
}

test_grassland_without_use_excluded if {
	inp := json.patch(base_input, [
		{"op": "replace", "path": "/land/parcels/2/operations/cutting_dates", "value": []},
		{"op": "add", "path": "/land/parcels/2/operations/full_area_grazing", "value": false},
	])
	excl := o6_2.parcel_exclusions with input as inp
	["G1", "minimum_management_not_met"] in excl
	grazed := json.patch(inp, [{"op": "replace", "path": "/land/parcels/2/operations/full_area_grazing", "value": true}])
	excl_g := o6_2.parcel_exclusions with input as grazed
	not ["G1", "minimum_management_not_met"] in excl_g
}

test_decision_base if {
	d := o6_2.decision with input as base_input
	d.eligible == true
	d.livestock_farm == true
	d.rgve_band == "lt_1_4"
	abs(d.net_premium_eur - 2160) < 0.001
	d.repayment_of_all_premiums_required == false
}
