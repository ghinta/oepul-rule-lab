package oepul.o6_15

import rego.v1

# Input extension proposed in rules/profile_changes.json: input.farm.o6_15.
rgve_factor(class) := data.factors[class]

animal_rgve(class, count) := rgve_factor(class) * count

minimum_participation_met if {
	input.farm.o6_15.almbewirtschaftung_participating
	input.farm.o6_15.behirtete_rgve >= 3
}

category_complete if {
	every category in input.farm.o6_15.categories {
		category.all_animals_of_category_herded
	}
}

animal_days_met(animal) if {
	animal.herding_days >= 60
}

alm_days_met(alm) if {
	alm.stocking_days >= 60
}

milk_animal_eligible(animal) if {
	animal.milked_days >= 45
	animal.age_on_july_1_years >= animal.minimum_milk_age_years
	animal.milk_cow_calved_once
}

daily_care_met(alm) if {
	alm.daily_care
	alm.herding_substantial_daytime
	not alm.mere_inspection
	alm.sufficient_water
	alm.animal_care
	alm.treatment_referral
	alm.safety_measures
	alm.site_adapted_grazing
	alm.accommodation_available
}

guardian_dog_eligible(dog) if {
	dog.certified
	dog.days_on_same_alm >= 60
	dog.days_on_same_alm == dog.herded_animals_alping_days
	dog.herd_member_day_and_night
	dog.works_independently
	dog.certificate_on_farm
	dog.liability_insurance
	dog.requested_on_only_one_alm
}

eligible_rgve_per_herder(rgve) := min([rgve, 50])

base_premium(rgve) := (first * 81) + (rest * 27) if {
	capped := eligible_rgve_per_herder(rgve)
	first := min([capped, 20])
	rest := max([capped - 20, 0])
}

milk_premium(total_rgve, milk_rgve) := (first * 151.2) + (rest * 108) if {
	capped_total := eligible_rgve_per_herder(total_rgve)
	capped_milk := min([milk_rgve, capped_total])
	first := min([capped_milk, 20])
	rest := max([capped_milk - 20, 0])
}

herder_premium(herder) := base_premium(herder.rgve) + milk_premium(herder.rgve, herder.milk_rgve)

guardian_dog_premium(dogs) := min([dogs, 5]) * 1200

premium_total := sum([herder_premium(h) |
	some h in input.farm.o6_15.herders
]) + sum([guardian_dog_premium(a.eligible_guardian_dogs) |
	some a in input.farm.o6_15.alms
]) if {
	minimum_participation_met
}

violations contains "missing_almbewirtschaftung_or_3_rgve" if {
	not minimum_participation_met
}

violations contains "category_not_complete" if {
	not category_complete
}

violations contains sprintf("animal_%v_under_60_days", [animal.animal_id]) if {
	some animal in input.farm.o6_15.animals
	not animal_days_met(animal)
}

violations contains sprintf("alm_%v_under_60_stocking_days", [alm.alm_id]) if {
	some alm in input.farm.o6_15.alms
	not alm_days_met(alm)
}
