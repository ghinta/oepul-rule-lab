package oepul.o6_15_test

import data.oepul.o6_15
import rego.v1

test_rgve_key if {
	o6_15.animal_rgve("sheep_1_plus", 20) == 3
	o6_15.animal_rgve("equid_large_3_plus", 2) == 2
}

test_premium_tiers_and_cap if {
	o6_15.base_premium(50) == 2430
	o6_15.base_premium(95) == 2430
	o6_15.milk_premium(50, 40) == 5184
	o6_15.guardian_dog_premium(7) == 6000
}

test_minimum_participation if {
	o6_15.minimum_participation_met with input as {
		"farm": {"o6_15": {"almbewirtschaftung_participating": true, "behirtete_rgve": 3}},
	}
}

test_under_threshold_is_violation if {
	"missing_almbewirtschaftung_or_3_rgve" in o6_15.violations with input as {
		"farm": {"o6_15": {"almbewirtschaftung_participating": true, "behirtete_rgve": 2, "categories": [], "animals": [], "alms": []}},
	}
}

test_animal_duration_and_guardian_dog if {
	o6_15.animal_days_met({"herding_days": 60})
	not o6_15.animal_days_met({"herding_days": 59})
	o6_15.guardian_dog_eligible({
		"certified": true,
		"days_on_same_alm": 60,
		"herded_animals_alping_days": 60,
		"herd_member_day_and_night": true,
		"works_independently": true,
		"certificate_on_farm": true,
		"liability_insurance": true,
		"requested_on_only_one_alm": true,
	})
}
