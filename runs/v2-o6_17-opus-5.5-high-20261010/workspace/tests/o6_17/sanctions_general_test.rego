package oepul.o6_17.sanctions_general_test

import data.oepul.o6_17
import data.oepul.o6_17.common
import data.oepul.o6_17.fixtures
import data.oepul.o6_17.general
import data.oepul.o6_17.sanctions

rule_ids(vs) := {v.rule_id | some v in vs}

test_sanction_stage_escalation_and_cumulation if {
	inp := fixtures.with_o6({"findings": [
		{"obligation_id": "o6_17.obligation.no_grassland_ploughing", "base_stage": 4, "prior_occurrences_same_obligation": 1},
		{"obligation_id": "o6_17.agl.survey_and_documentation", "base_stage": 3},
	]})
	sanctions.total_reduction_percent == 30 with input as inp
}

test_sanction_capped_at_100_and_exclusion if {
	inp := fixtures.with_o6({"previous_full_reductions_in_period": 1, "findings": [
		{"obligation_id": "a", "base_stage": 7},
		{"obligation_id": "b", "base_stage": 6},
	]})
	sanctions.total_reduction_percent == 100 with input as inp
	sanctions.excluded_from_measure with input as inp
	sanctions.repayment_of_all_premiums_since_start with input as inp
}

test_warning_becomes_one_percent_from_2027 if {
	f := {"findings": [{"obligation_id": "a", "base_stage": 1}]}
	sanctions.total_reduction_percent == 0 with input as object.union(fixtures.with_o6(f), {"farm": {"year": 2026}})
	sanctions.total_reduction_percent == 1 with input as object.union(fixtures.with_o6(f), {"farm": {"year": 2027}})
}

test_one_off_obligation_sanctioned_in_detection_year if {
	inp := fixtures.with_o6({"findings": [{"obligation_id": "o6_17.obligation.soil_samples_per_5ha", "base_stage": 3, "detection_year": 2027}]})
	some l in sanctions.finding_lines with input as inp
	l.sanction_year == 2027
}

test_early_exit_requires_repayment if {
	inp := fixtures.with_o6({"exit_date": "2026-03-01"})
	sanctions.early_exit with input as inp
	sanctions.repayment_of_all_premiums_since_start with input as inp
	not common.contract_active with input as object.union(inp, {"farm": {"year": 2026}})
}

test_area_reduction_tolerance if {
	small := fixtures.with_o6({"committed_area_previous_year_ha": 20, "area_reductions": [{"area_ha": 0.8, "reason": "land_use_abandoned"}]})
	sanctions.allowed_reduction_ha == 1 with input as small
	sanctions.repayment_area_ha == 0 with input as small
	large := fixtures.with_o6({"committed_area_previous_year_ha": 200, "area_reductions": [{"area_ha": 6.0, "reason": "code_removed"}]})
	sanctions.allowed_reduction_ha == 5 with input as large
	sanctions.repayment_area_ha == 6.0 with input as large
	exempt := fixtures.with_o6({"committed_area_previous_year_ha": 10, "area_reductions": [{"area_ha": 4.0, "reason": "loss_of_control"}]})
	sanctions.repayment_area_ha == 0 with input as exempt
}

test_missed_payment_application if {
	inp := fixtures.with_o6({"payment_application_missing": true, "late_payment_application_within_one_year": true})
	sanctions.no_payment_for_year_due_to_missed_application with input as inp
	not sanctions.commitment_ends_due_to_missed_application with input as inp
	ends := fixtures.with_o6({"payment_application_missing": true, "late_payment_application_within_one_year": false})
	sanctions.repayment_of_all_premiums_since_start with input as ends
}

test_force_majeure_three_weeks if {
	inp := object.union(fixtures.base_input, {"farm": {"oepul": {"force_majeure_claims": [
		{"claim_id": "c1", "case_id": "behoerdliche_anordnung", "able_to_notify_date": "2025-05-01", "notification_date": "2025-05-22"},
		{"claim_id": "c2", "case_id": "dauerhafte_abtretung", "area_ha": 0.2, "able_to_notify_date": "2025-05-01", "notification_date": "2025-05-02"},
		{"claim_id": "c3", "case_id": "tod_tier", "able_to_notify_date": "2025-05-01", "notification_date": "2025-05-23"},
	]}}})
	general.force_majeure_recognisable == {"c1"} with input as inp
	general.late_force_majeure_claims == {"c3"} with input as inp
}

test_takeover_deadline_and_expansion if {
	ok := fixtures.with_o6({"takeover": {"application_date": "2026-04-15", "taken_over_area_ha": 10, "expansion_to_other_area_ha": 5}})
	general.takeover_valid with input as object.union(ok, {"farm": {"year": 2026}})
	late := fixtures.with_o6({"takeover": {"application_date": "2026-04-16", "taken_over_area_ha": 10, "expansion_to_other_area_ha": 6}})
	general.takeover_problems == {"deadline_missed", "expansion_over_50_percent"} with input as object.union(late, {"farm": {"year": 2026}})
	general.takeover_deadline == "2028-04-17" with input as fixtures.with_year(2028)
}

test_no_conversion_from_o6_17 if {
	not general.conversion_from_o6_17_possible with input as fixtures.base_input
}

test_intra_year_transfer_requires_op_code if {
	g := object.union(fixtures.parcel_g1, {"o6_17": {"transferred_during_year": true, "recipient_continues_commitment": false}})
	inp := fixtures.with_parcels([g, fixtures.parcel_g2, fixtures.parcel_a1])
	"o6_17.general.intra_year_transfer_op_code" in rule_ids(general.violations) with input as inp
}

test_minimum_management_grassland if {
	g := object.union(fixtures.parcel_g1, {"operations": {"cutting_dates": [], "season_completed": true}})
	inp := fixtures.with_parcels([g, fixtures.parcel_a1])
	"o6_17.general.minimum_management_grassland" in rule_ids(general.violations) with input as inp
	b := {"parcel_id": "B1", "area_ha": 1, "land_use": "grassland", "grassland_use_type": "bergmaehder", "operations": {"last_full_mowing_year": 2023}}
	"o6_17.general.minimum_management_bergmaehder" in rule_ids(general.violations) with input as fixtures.with_parcels([b])
}

test_drought_2026_harvest_relief if {
	a := object.union(fixtures.parcel_a2, {"district": "Mistelbach", "federal_state": "Niederösterreich", "operations": {"harvest": {"harvested_share_percent": 0, "no_harvestable_crop_due_to_drought": true}}})
	inp := object.union(fixtures.with_parcels([fixtures.parcel_g1, a]), {"farm": {"year": 2026}})
	general.parcels_with_harvest_relief_2026 == {"A2"} with input as inp
	not "o6_17.general.harvest_obligation_arable" in rule_ids(general.violations) with input as inp
	elsewhere := object.union(a, {"district": "Zell am See", "federal_state": "Salzburg"})
	inp2 := object.union(fixtures.with_parcels([fixtures.parcel_g1, elsewhere]), {"farm": {"year": 2026}})
	"o6_17.general.harvest_obligation_arable" in rule_ids(general.violations) with input as inp2
}

test_drought_relief_steiermark_from_12_august if {
	a := object.union(fixtures.parcel_a2, {"district": "Weiz", "federal_state": "Steiermark", "operations": {"harvest": {"harvested_share_percent": 10, "no_harvestable_crop_due_to_drought": true}}})
	inp := object.union(fixtures.with_parcels([a]), {"farm": {"year": 2026}})
	general.harvest_relief_2026(a) with input as inp
}

test_related_training_obligations_for_bio if {
	inp := object.union(fixtures.base_input, {"farm": {"oepul": {"participating_measures": ["1B", "17"]}}})
	{"measure": "1B", "topic": "organic", "min_hours": 5} in general.related_training_obligations with input as inp
}

test_decision_document_complete if {
	d := o6_17.decision with input as fixtures.base_input
	d.access_requirements_met
	d.premium.total_premium_eur == 659.89
	count(d.violations) == 0
}
