package policy.o6_5_test

import data.policy.o6_5 as policy
import rego.v1

test_eligible_with_one_valid_cow if {
	policy.eligible with input as {
		"farm": {"year": 2025},
		"livestock": {"animals": [{
			"species": "cattle",
			"breed": "Murbodner",
			"animal_type": "cow",
			"purebred": true,
			"approved_breeding_program": true,
			"regular_breeding_use": true,
			"purebred_mating": true,
			"breeding_facts": {"calved_by_stichtag": true},
			"held_from": "2025-04-01",
			"held_to": "2025-12-31",
		}]},
	}
}

test_male_age_and_admission_requirement if {
	policy.category_requirements_satisfied({
		"animal_type": "bull",
		"breeding_facts": {"age_months_at_stichtag": 10, "admitted_to_breeding_year": 2025},
	}) with input as {"farm": {"year": 2025}}
}

test_stallion_over_five_needs_recent_offspring if {
	policy.category_requirements_satisfied({
		"animal_type": "stallion",
		"breeding_facts": {"age_years_at_may31": 6, "live_born_offspring_last_two_years": [{"year": 2025}]},
		"purebred_mating": true,
	}) with input as {"farm": {"year": 2025}}
}

test_2026_holding_deadline_is_august if {
	policy.holding_valid({"held_from": "2026-04-01", "held_to": "2026-08-31"}) with input as {"farm": {"year": 2026}}
}

test_2026_replacement_report_after_august_not_required if {
	not policy.replacement_report_required({"species": "pig"}, {"event_type": "replacement", "event_date": "2026-09-01"}) with input as {"farm": {"year": 2026}}
}

test_non_cattle_movement_report_within_seven_days if {
	policy.movement_report_timely({"species": "sheep"}, {"event_type": "departure", "event_date": "2025-06-01", "reported_within_days": 7}) with input as {"farm": {"year": 2025}}
}

test_premium_uses_breed_tier_gep_and_milk_control if {
	amount := policy.premium({
		"species": "cattle",
		"breed": "Murbodner",
		"animal_type": "cow",
		"breeding_facts": {"milk_control": true},
	}) with input as {"farm": {"year": 2024}}
	amount > 334.799
	amount < 334.801
}

test_premium_uses_latest_rate_year if {
	amount := policy.premium({
		"species": "cattle",
		"breed": "Murbodner",
		"animal_type": "cow",
		"breeding_facts": {"milk_control": false},
	}) with input as {"farm": {"year": 2025}}
	amount > 248.399
	amount < 248.401
}

test_short_documented_stay_needs_no_transfer_notice if {
	policy.transfer_notice_not_required({"species": "sheep"}, {"event_type": "temporary_transfer", "duration_days": 10, "documented": true})
}

test_application_deadline_and_latest_entry if {
	policy.application_on_time with input as {"farm": {"year": 2026, "application_date": "2025-12-31"}}
	policy.latest_entry_allowed with input as {"farm": {"year": 2027}}
}
