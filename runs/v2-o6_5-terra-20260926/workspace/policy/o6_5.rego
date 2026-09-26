package oepul.o6_5

import rego.v1

# Returned messages document determinate eligibility failures for the supplied animal records.
errors contains msg if {
	animal := input.livestock.breeding_animals[_]
	not eligible_breed(animal.breed)
	msg := sprintf("Animal %s is not an eligible breed in Annex D.", [animal.animal_id])
}

errors contains msg if {
	animal := input.livestock.breeding_animals[_]
	animal.purebred != true
	msg := sprintf("Animal %s is not recorded as purebred.", [animal.animal_id])
}

errors contains msg if {
	animal := input.livestock.breeding_animals[_]
	animal.zuchtbook_registered != true
	msg := sprintf("Animal %s lacks Zuchtbuch registration.", [animal.animal_id])
}

errors contains msg if {
	input.farm.year != 2026
	animal := input.livestock.breeding_animals[_]
	animal.held_from_april_1 != true
	msg := sprintf("Animal %s was not held from 1 April.", [animal.animal_id])
}

errors contains msg if {
	input.farm.year != 2026
	animal := input.livestock.breeding_animals[_]
	animal.held_through_december_31 != true
	msg := sprintf("Animal %s was not held through 31 December.", [animal.animal_id])
}

errors contains msg if {
	input.farm.year == 2026
	animal := input.livestock.breeding_animals[_]
	animal.held_through_august_31 != true
	msg := sprintf("Animal %s was not held through the 2026 drought end date, 31 August.", [animal.animal_id])
}

eligible_breed(breed) if data.breeds[_].breed == breed

eligible if {
	count(input.livestock.breeding_animals) >= 1
	count(errors) == 0
}

premium(animal) := amount if {
	row := data.breeds[_]
	row.breed == animal.breed
	schedule := premium_schedule(input.farm.year)
	base := schedule[animal.category][row.premium_tier]
	gep := gep_amount(schedule, row)
	mlk := milk_amount(schedule, animal)
	amount := (base + gep) + mlk
}

gep_amount(schedule, row) := object.get(schedule, "gep", 0) if row.special_gep
gep_amount(_, row) := 0 if not row.special_gep

milk_amount(schedule, animal) := object.get(schedule, "milk_recording_cow", 0) if {
	animal.category == "cow"
	animal.milk_recording == true
}

milk_amount(_, animal) := 0 if {
	animal.category != "cow"
}

milk_amount(_, animal) := 0 if {
	animal.category == "cow"
	animal.milk_recording != true
}

premium_schedule(year) := data.premiums_eur_per_animal["2023"] if year == 2023
premium_schedule(year) := data.premiums_eur_per_animal["2024_plus"] if year >= 2024
