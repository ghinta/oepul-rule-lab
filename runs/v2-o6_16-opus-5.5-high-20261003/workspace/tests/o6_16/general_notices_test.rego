package oepul.o6_16_test

import data.oepul.o6_16

# --- Flächenabgang ---
test_area_reduction_tolerance if {
	o6_16.area_reduction_tolerance_ha(100) == 5
	o6_16.area_reduction_tolerance_ha(5) == 0.5
	o6_16.area_reduction_tolerance_ha(200) == 5
	o6_16.area_reduction_tolerance_ha(40) == 2
}

test_area_reduction_over_tolerance_repayment if {
	inp := object.union(base_input, {"farm": {"oepul": {"o6_16": {"area_previous_year_ha": 20, "area_current_year_ha": 18}}}})
	"O616-GEN-006" in rule_ids(o6_16.obligation_violations) with input as inp
	o6_16.repayment_area_ha == 2 with input as inp
}

test_area_reduction_loss_of_disposal_right_exempt if {
	inp := object.union(base_input, {"farm": {"oepul": {"o6_16": {"area_previous_year_ha": 20, "area_current_year_ha": 18, "area_lost_disposal_right_ha": 2}}}})
	not "O616-GEN-006" in rule_ids(o6_16.obligation_violations) with input as inp
}

# --- Mindestbewirtschaftung und Dürre 2026 ---
test_harvest_obligation_85_percent if {
	m := object.union(parcel_maize, {"operations": {"harvested_share": 0.5}})
	inp := object.union(with_parcels([parcel_wheat, m]), {"farm": {"region": {"district": "Melk"}}})
	"O616-GEN-004" in rule_ids(o6_16.obligation_violations) with input as with_year(inp, 2025)
}

test_drought_2026_harvest_waiver_listed_district if {
	m := object.union(parcel_maize, {"crop": {"usually_harvested_late_summer_or_autumn": true}, "operations": {"harvested_share": 0, "no_harvestable_stand_due_to_drought": true}})
	inp := with_parcels([parcel_wheat, m])
	o6_16.harvest_obligation_waived(m) with input as inp
	not "O616-GEN-004" in rule_ids(o6_16.obligation_violations) with input as inp
}

test_drought_2026_waiver_styria_extension if {
	m := object.union(parcel_maize, {"federal_state": "Steiermark", "district": "Leibnitz", "crop": {"usually_harvested_late_summer_or_autumn": true}, "operations": {"no_harvestable_stand_due_to_drought": true}})
	o6_16.harvest_obligation_waived(m) with input as with_parcels([m])
}

test_drought_2026_no_waiver_outside_list if {
	m := object.union(parcel_maize, {"federal_state": "Kärnten", "district": "Klagenfurt Land", "crop": {"usually_harvested_late_summer_or_autumn": true}, "operations": {"no_harvestable_stand_due_to_drought": true}})
	not o6_16.harvest_obligation_waived(m) with input as with_parcels([m])
	o6_16.harvest_waiver_requires_individual_claim(m) with input as with_parcels([m])
}

test_drought_waiver_only_2026 if {
	m := object.union(parcel_maize, {"crop": {"usually_harvested_late_summer_or_autumn": true}, "operations": {"no_harvestable_stand_due_to_drought": true}})
	not o6_16.harvest_obligation_waived(m) with input as with_year(with_parcels([m]), 2025)
}

test_immergruen_2026_deadlines if {
	o6_16.immergruen_2026_catch_crop_deadline("frost_killed") == "2026-09-20"
	o6_16.immergruen_2026_catch_crop_deadline("predominantly_winter_hardy") == "2026-10-15"
}

# --- Weitergabe von Flächen ---
test_transfer_without_continuation_requires_op if {
	w := object.union(parcel_wheat, {"transferred_during_year": true})
	"O616-GEN-005" in rule_ids(o6_16.obligation_violations) with input as with_parcels([w, parcel_maize])
	x := object.union(parcel_wheat, {"transferred_during_year": true, "codes": ["OP"]})
	not "O616-GEN-005" in rule_ids(o6_16.obligation_violations) with input as with_parcels([x, parcel_maize])
}

# --- Maßnahmenübernahme ---
test_takeover_deadlines if {
	o6_16.takeover_deadline(2026) == "2026-04-15"
	o6_16.takeover_deadline(2028) == "2028-04-17"
}

test_takeover_allowed_and_expansion_limit if {
	o6_16.takeover_allowed({"date": "2026-04-10", "extension_to_other_area_ha": 2, "taken_over_area_ha": 10, "taker_previously_participating": false})
	not o6_16.takeover_allowed({"date": "2026-04-16", "extension_to_other_area_ha": 2, "taken_over_area_ha": 10, "taker_previously_participating": false})
	not o6_16.takeover_allowed({"date": "2026-04-10", "extension_to_other_area_ha": 6, "taken_over_area_ha": 10, "taker_previously_participating": false})
}

test_takeover_pig_option_only_on_restructuring if {
	t := {"date": "2026-04-10", "extension_to_other_area_ha": 0, "taken_over_area_ha": 10, "taker_previously_participating": false, "reason": "lease"}
	not o6_16.takeover_allowed_pig_option(t)
	o6_16.takeover_allowed_pig_option(object.union(t, {"reason": "farm_division"}))
}

# --- Ausstieg, Sanktionen, höhere Gewalt, Fristen ---
test_early_exit_repayment if {
	inp := object.union(base_input, {"farm": {"oepul": {"o6_16": {"exit_year": 2026}}}})
	o6_16.early_exit_repayment with input as inp
	inp2 := object.union(base_input, {"farm": {"oepul": {"o6_16": {"exit_year": 2026, "exit_due_to_revision_clause": true}}}})
	not o6_16.early_exit_repayment with input as inp2
}

test_sanction_stages if {
	o6_16.sanction_percent(1, 2026) == 0
	o6_16.sanction_percent(1, 2027) == 1
	o6_16.sanction_percent(5, 2026) == 25
	o6_16.escalated_stage(3, 2) == 4
	o6_16.escalated_stage(7, 3) == 7
	o6_16.cumulated_sanction_percent([50, 25, 50]) == 100
}

test_exclusion_after_two_full_cuts if {
	inp := object.union(base_input, {"farm": {"oepul": {"o6_16": {"sanction_history_percent": [100, 25, 100]}}}})
	o6_16.exclusion_from_measure with input as inp
}

test_force_majeure_three_weeks if {
	o6_16.force_majeure_claim_timely("2026-07-01", "2026-07-22")
	not o6_16.force_majeure_claim_timely("2026-07-01", "2026-07-23")
}

test_deadline_shift_not_for_measure_application if {
	not o6_16.deadline_shift_applicable("measure_application")
	o6_16.deadline_shift_applicable("force_majeure_notification")
}

test_contract_period if {
	o6_16.contract_period.years == 6 with input as base_input
	o6_16.in_contract_period with input as base_input
}

test_records_retention if {
	o6_16.records_retention_until == "2032-12-31"
}

test_national_park_parcel_no_premium if {
	w := object.union(parcel_wheat, {"in_national_park": true})
	p := o6_16.premium with input as with_parcels([w, parcel_maize])
	p.components.base == 216
}

test_annex_g_lookup if {
	o6_16.parcel_in_area(parcel_wheat)
	not o6_16.parcel_in_area(parcel_outside)
	count(o6_16.annex_g_kg_numbers) == 1565
}
