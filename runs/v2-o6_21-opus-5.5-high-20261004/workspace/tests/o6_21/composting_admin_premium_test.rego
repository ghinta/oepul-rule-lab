package oepul.o6_21.composting_admin_premium_test

import data.oepul.o6_21.administration
import data.oepul.o6_21.composting
import data.oepul.o6_21.fixtures
import data.oepul.o6_21.main
import data.oepul.o6_21.premium

# --- Zuschlag Festmistkompostierung ----------------------------------------------------------------

test_supplement_compliant_with_two_turnings_14_days_apart if {
	inp := fixtures.with_supplement(fixtures.base, [fixtures.good_windrow])
	composting.supplement_compliant with input as inp
	premium.supplement_amount == 51.84 with input as inp
}

test_turning_interval_13_days_fails if {
	w := object.union(fixtures.good_windrow, {"turnings": [
		{"date": "2025-05-01", "equipment": "compost_turner"},
		{"date": "2025-05-14", "equipment": "compost_turner"},
	]})
	inp := fixtures.with_supplement(fixtures.base, [w])
	"method_not_met" in composting.windrow_violations.W1 with input as inp
	not composting.supplement_compliant with input as inp
	premium.supplement_amount == 0 with input as inp
}

test_front_loader_turning_does_not_count if {
	w := object.union(fixtures.good_windrow, {"turnings": [
		{"date": "2025-05-01", "equipment": "compost_turner"},
		{"date": "2025-05-20", "equipment": "front_loader"},
	]})
	inp := fixtures.with_supplement(fixtures.base, [w])
	"method_not_met" in composting.windrow_violations.W1 with input as inp
}

test_manure_spreader_counts_only_with_complete_turning if {
	w := object.union(fixtures.good_windrow, {"turnings": [
		{"date": "2025-05-01", "equipment": "manure_spreader_equivalent", "windrow_completely_turned": true},
		{"date": "2025-05-20", "equipment": "manure_spreader_equivalent", "windrow_completely_turned": true},
	]})
	inp := fixtures.with_supplement(fixtures.base, [w])
	count(composting.windrow_violations.W1) == 0 with input as inp
	w2 := object.union(w, {"turnings": [
		{"date": "2025-05-01", "equipment": "manure_spreader_equivalent", "windrow_completely_turned": false},
		{"date": "2025-05-20", "equipment": "manure_spreader_equivalent", "windrow_completely_turned": true},
	]})
	"method_not_met" in composting.windrow_violations.W1 with input as fixtures.with_supplement(fixtures.base, [w2])
}

test_turner_must_be_on_farm_or_documented if {
	inp := json.patch(fixtures.with_supplement(fixtures.base, [fixtures.good_windrow]), [{"op": "replace", "path": "/livestock/solid_manure_composting/compost_turner_on_farm", "value": false}])
	"method_not_met" in composting.windrow_violations.W1 with input as inp
	inp2 := fixtures.set_path(inp, "/livestock/solid_manure_composting/external_turner_use_documented", true)
	count(composting.windrow_violations.W1) == 0 with input as inp2
}

mixed_windrow := {
	"windrow_id": "W1", "method": "mixed_or_layered", "plant_materials": ["straw", "green_cut"],
	"documented_set_up": true,
}

test_mixed_windrow_recognised_from_2025 if {
	inp := fixtures.with_supplement(fixtures.base, [mixed_windrow])
	count(composting.windrow_violations.W1) == 0 with input as inp
	"method_not_met" in composting.windrow_violations.W1 with input as fixtures.with_year(inp, 2024)
}

test_turning_free_with_straw_rich_manure_only_fails if {
	w := {
		"windrow_id": "W1", "method": "turning_free_with_added_material", "added_material_significant": true,
		"composting_process": "hot_rot", "straw_rich_manure_only": true, "documented_set_up": true,
	}
	inp := fixtures.with_supplement(fixtures.base, [w])
	"method_not_met" in composting.windrow_violations.W1 with input as inp
	w2 := object.union(w, {"straw_rich_manure_only": false})
	count(composting.windrow_violations.W1) == 0 with input as fixtures.with_supplement(fixtures.base, [w2])
}

test_compost_barn_gets_no_supplement if {
	inp := fixtures.set_path(fixtures.with_supplement(fixtures.base, [fixtures.good_windrow]), "/livestock/solid_manure_composting/is_compost_barn", true)
	"compost_barn" in composting.supplement_violations with input as inp
}

test_not_all_manure_composted_fails if {
	inp := json.patch(fixtures.with_supplement(fixtures.base, [fixtures.good_windrow]), [{"op": "replace", "path": "/livestock/solid_manure_composting/all_solid_manure_composted_on_farm", "value": false}])
	"not_all_solid_manure_composted" in composting.supplement_violations with input as inp
	{"rule_id": "O6_21-COMP-01", "code": "not_all_solid_manure_composted"} in main.violations with input as inp
}

test_napv_unpaved_windrow_must_be_covered if {
	w := object.union(fixtures.good_windrow, {
		"on_unpaved_area": true, "covered": false, "distance_to_surface_water_m": 30,
		"risk_of_seepage_to_water": false, "waterlogged_soil": false, "groundwater_depth_m": 2,
	})
	inp := fixtures.with_supplement(fixtures.base, [w])
	"napv_storage_not_met" in composting.windrow_violations.W1 with input as inp
	w2 := object.union(w, {"covered": true})
	count(composting.windrow_violations.W1) == 0 with input as fixtures.with_supplement(fixtures.base, [w2])
}

test_napv_surface_water_distance_25m if {
	w := object.union(fixtures.good_windrow, {
		"on_unpaved_area": true, "covered": true, "distance_to_surface_water_m": 24,
		"risk_of_seepage_to_water": false, "waterlogged_soil": false, "groundwater_depth_m": 2,
	})
	"napv_storage_not_met" in composting.windrow_violations.W1 with input as fixtures.with_supplement(fixtures.base, [w])
}

test_missing_compost_documentation_fails if {
	w := object.union(fixtures.good_windrow, {"documented_turnings": false})
	"documentation_missing" in composting.windrow_violations.W1 with input as fixtures.with_supplement(fixtures.base, [w])
	inp := json.patch(fixtures.with_supplement(fixtures.base, [fixtures.good_windrow]), [{"op": "replace", "path": "/livestock/solid_manure_composting/documented_application_or_transfer", "value": false}])
	"application_or_transfer_not_documented" in composting.supplement_violations with input as inp
}

# --- Sanktionen -------------------------------------------------------------------------------------

with_stages(stages, prev) := fixtures.with_measure(fixtures.base, {
	"categories": [{"category_id": "male_ge_half_year", "applied_on": "2023-12-10", "first_year": 2024}],
	"content_violation_stages": stages,
	"previous_full_reductions_in_period": prev,
})

test_sanctions_cumulate_by_addition if {
	inp := with_stages([3, 4], 0)
	administration.content_reduction_percent == 15 with input as inp

	# 2,4 RGVE × 194,4 = 466,56 € × 85 %
	premium.after_sanctions == 396.58 with input as inp
}

test_sanctions_capped_at_100_percent if {
	administration.content_reduction_percent == 100 with input as with_stages([6, 6, 5], 0)
}

test_warning_without_reduction_before_2027 if {
	administration.content_reduction_percent == 0 with input as with_stages([1], 0)
}

test_warning_replaced_by_1_percent_from_2027 if {
	inp := fixtures.with_year(with_stages([1], 0), 2027)
	administration.content_reduction_percent == 1 with input as json.patch(inp, [{"op": "replace", "path": "/farm/programmes/animal_health_service_cattle", "value": fixtures.full_year(2027)}])
}

test_second_100_percent_reduction_excludes if {
	inp := with_stages([7], 1)
	administration.exclusion_from_measure with input as inp
	premium.net_amount == 0 with input as inp
	{"rule_id": "O6_21-SANC-03", "code": "exclusion_and_recovery"} in main.notices with input as inp
}

# --- Höhere Gewalt, Kontrolle, Förderwerber --------------------------------------------------------

fm_input(reported_on) := fixtures.with_measure(fixtures.base, {
	"categories": [{"category_id": "male_ge_half_year", "applied_on": "2023-12-10", "first_year": 2024}],
	"force_majeure_events": [{"event_id": "FM1", "case_id": "official_disease_orders", "able_to_report_from": "2025-03-01", "reported_on": reported_on, "documented": true}],
})

test_force_majeure_within_three_weeks if {
	"FM1" in administration.recognised_force_majeure_events with input as fm_input("2025-03-22")
}

test_force_majeure_late_after_three_weeks if {
	not "FM1" in administration.recognised_force_majeure_events with input as fm_input("2025-03-23")
	"FM1" in administration.late_force_majeure_events with input as fm_input("2025-03-23")
}

test_control_refusal_blocks_premium if {
	inp := fixtures.set_path(fixtures.base, "/oepul_measures/o6_21/control_refused", true)
	premium.net_amount == 0 with input as inp
	{"rule_id": "O6_21-CTRL-01", "code": "control_refused"} in main.violations with input as inp
}

test_public_body_excluded if {
	inp := fixtures.set_path(fixtures.base, "/farm/applicant/is_public_body", true)
	"public_body_excluded" in administration.applicant_issues with input as inp
	premium.net_amount == 0 with input as inp
}

test_legal_person_public_share_above_25_percent if {
	inp := json.patch(fixtures.base, [
		{"op": "replace", "path": "/farm/applicant/person_type", "value": "legal_person"},
		{"op": "add", "path": "/farm/applicant/public_body_share_percent", "value": 30},
	])
	"public_body_share_above_25_percent" in administration.applicant_issues with input as inp
	inp25 := fixtures.set_path(inp, "/farm/applicant/public_body_share_percent", 25)
	not "public_body_share_above_25_percent" in administration.applicant_issues with input as inp25
}

test_records_retention_and_payment_window if {
	administration.records_retention_until == "2029-12-31" with input as fixtures.base
	administration.payment_window == {"not_before": "2025-12-01", "until": "2026-06-30"} with input as fixtures.base
}

test_farm_transfer_notification_four_weeks if {
	inp := fixtures.set_path(fixtures.base, "/oepul_measures/o6_21/farm_transfer", {"effective_on": "2025-03-01", "notified_on": "2025-03-30"})
	administration.farm_transfer_notification_late with input as inp
	inp2 := fixtures.set_path(fixtures.base, "/oepul_measures/o6_21/farm_transfer", {"effective_on": "2025-03-01", "notified_on": "2025-03-29"})
	not administration.farm_transfer_notification_late with input as inp2
}

test_recovery_waiver_thresholds if {
	administration.recovery_may_be_waived(100, false)
	not administration.recovery_may_be_waived(100.01, false)
	administration.recovery_may_be_waived(50, true)
	not administration.recovery_may_be_waived(51, true)
}

# --- Prämie gesamt ----------------------------------------------------------------------------------

test_base_premium if {
	premium.animal_premium_total == 466.56 with input as fixtures.base
	premium.net_amount == 466.56 with input as fixtures.base
	administration.max_advance_payment(466.56) == 349.92
}

test_modulation_applied_to_premium if {
	inp := json.patch(fixtures.base, [{"op": "replace", "path": "/land/total_area_ha", "value": 220}])

	# 466,56 € × 0,990909…
	premium.net_amount == 462.32 with input as inp
}

test_payout_of_50_eur_or_less_may_be_withheld if {
	inp := json.patch(fixtures.base, [{"op": "replace", "path": "/farm/year", "value": 2025}])
	not premium.payout_may_be_withheld with input as inp

	# 95 % Kürzung: 466,56 € × 5 % = 23,33 €
	small := with_stages([6, 5, 4, 4], 0)
	premium.net_amount == 23.33 with input as small
	premium.payout_may_be_withheld with input as small
	{"rule_id": "O6_21-PAY-01", "code": "payout_may_be_withheld_below_50_eur"} in main.notices with input as small
}

test_decision_object_complete if {
	d := main.decision with input as fixtures.with_supplement(fixtures.base, [fixtures.good_windrow])
	d.eligible
	d.supplement_valid
	d.supplement_compliant
	d.premium.net_amount == 518.4
	count(d.violations) == 0
}
