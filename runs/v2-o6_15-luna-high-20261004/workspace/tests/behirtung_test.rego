package opul.o6_15

import rego.v1

test_participation_requires_almbewirtschaftung if {
	not participation_valid with input as {
		"farm": {"participates_almbewirtschaftung": false, "year": 2026},
		"livestock": {"species_groups": [{"species": "sheep", "category": "Schafe", "gve": 3, "herded": true}]},
	}
}

test_participation_requires_three_rgve if {
	not participation_valid with input as {
		"farm": {"participates_almbewirtschaftung": true, "year": 2026},
		"livestock": {"species_groups": [{"species": "sheep", "category": "Schafe", "gve": 2.99, "herded": true}]},
	}
}

test_milk_cow_definition if {
	milk_cow_category_valid with input as {
		"livestock": {"species_groups": [{
			"species": "cattle",
			"category": "Milchkühe",
			"age_years": 2,
			"calvings": 1,
			"milked_days_on_alms": 45,
		}]},
	}
}

test_sixty_day_boundary if {
	sixty_day_requirement_valid with input as {
		"land": {"parcels": [{"is_alm": true, "stocking_days": 60}]},
		"livestock": {"species_groups": [{"herded": true, "herding_days": 60}]},
	}
}

test_sixty_day_failure if {
	not sixty_day_requirement_valid with input as {
		"land": {"parcels": [{"is_alm": true, "stocking_days": 60}]},
		"livestock": {"species_groups": [{"herded": true, "herding_days": 59}]},
	}
}

test_dog_requires_single_alm_minimum if {
	not herd_protection_dog_valid with input as {
		"livestock": {"herd_protection_dog": {
			"requested": true,
			"days_on_single_alm": 40,
			"herded_animals_total_days": 80,
			"certificate_recognized": true,
			"liability_insurance": true,
			"permanent_herd_member": true,
			"day_and_night_with_herd": true,
			"works_without_direct_commands": true,
			"dogs_on_alm": 1,
		}},
	}
}

test_dog_valid_and_limited_to_five if {
	herd_protection_dog_valid with input as {
		"livestock": {"herd_protection_dog": {
			"requested": true,
			"days_on_single_alm": 65,
			"herded_animals_total_days": 65,
			"certificate_recognized": true,
			"liability_insurance": true,
			"permanent_herd_member": true,
			"day_and_night_with_herd": true,
			"works_without_direct_commands": true,
			"dogs_on_alm": 5,
		}},
	}
}

test_rgve_lookup if {
	rgve_lookup("sheep", "1_year_or_older") == 0.15
}

test_rgve_data_complete if {
	rgve_key_complete
}

test_premium_boundary if {
	premium_eur == 1620 with input as {
		"farm": {"year": 2026},
		"livestock": {
			"species_groups": [{"gve": 20, "herded": true, "category": "Sonstige Rinder"}],
			"herd_protection_dog": {"dogs_on_alm": 0},
		},
	}
}

test_special_payment_deadline if {
	payment_deadline == "2028-07-17" with input as {"farm": {"year": 2028}}
}
