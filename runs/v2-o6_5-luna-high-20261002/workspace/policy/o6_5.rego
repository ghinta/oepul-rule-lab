package policy.o6_5

import rego.v1

default eligible := false

eligible if count(eligible_animals) >= 1

eligible_animals contains animal if {
	some animal in input.livestock.animals
	animal_eligible(animal)
	holding_valid(animal)
}

animal_eligible(animal) if {
	animal.purebred == true
	animal.approved_breeding_program == true
	animal.regular_breeding_use == true
	breed_record(animal)
	category_requirements_satisfied(animal)
}

breed_record(animal) := record if {
	some i
	record := data.breeds[i]
	record.species == animal.species
	record.breed == animal.breed
}

breed_has_gep(animal) if {
	record := breed_record(animal)
	record.special_gep == true
}

category_requirements_satisfied(animal) if {
	animal.animal_type == "cow"
	animal.breeding_facts.calved_by_stichtag == true
	animal.purebred_mating == true
}

category_requirements_satisfied(animal) if {
	animal.animal_type == "mare"
	animal.breeding_facts.foaled_by_may31 == true
	animal.breeding_facts.next_foaling_within_3_5_years == true
	animal.purebred_mating == true
}

category_requirements_satisfied(animal) if {
	animal.animal_type == "ewe"
	animal.breeding_facts.lambed_by_stichtag == true
	animal.purebred_mating == true
}

category_requirements_satisfied(animal) if {
	animal.animal_type == "doe"
	animal.breeding_facts.kidded_by_stichtag == true
	animal.purebred_mating == true
}

category_requirements_satisfied(animal) if {
	animal.animal_type == "sow"
	animal.breeding_facts.purebred_farroted_by_stichtag == true
	animal.breeding_facts.every_second_litter_purebred == true
	animal.purebred_mating == true
}

category_requirements_satisfied(animal) if {
	animal.animal_type == "bull"
	animal.breeding_facts.age_months_at_stichtag >= 10
	annual_breeding_requirement_satisfied(animal)
}

category_requirements_satisfied(animal) if {
	animal.animal_type == "ram"
	animal.breeding_facts.age_months_at_stichtag >= 6
	annual_breeding_requirement_satisfied(animal)
}

category_requirements_satisfied(animal) if {
	animal.animal_type == "buck"
	animal.breeding_facts.age_months_at_stichtag >= 5
	annual_breeding_requirement_satisfied(animal)
}

category_requirements_satisfied(animal) if {
	animal.animal_type == "boar"
	animal.breeding_facts.age_months_at_stichtag >= 6
	annual_breeding_requirement_satisfied(animal)
}

annual_breeding_requirement_satisfied(animal) if animal.breeding_facts.breeding_year == input.farm.year
annual_breeding_requirement_satisfied(animal) if animal.breeding_facts.admitted_to_breeding_year == input.farm.year

category_requirements_satisfied(animal) if {
	animal.animal_type == "stallion"
	animal.breeding_facts.age_years_at_may31 >= 2
	animal.purebred_mating == true
	stallion_old_animal_requirement_satisfied(animal)
}

stallion_old_animal_requirement_satisfied(animal) if animal.breeding_facts.age_years_at_may31 <= 5

stallion_old_animal_requirement_satisfied(animal) if {
	animal.breeding_facts.age_years_at_may31 > 5
	count(animal.breeding_facts.live_born_offspring_last_two_years) >= 1
}

holding_deadline := "2026-08-31" if input.farm.year == 2026
holding_deadline := sprintf("%d-12-31", [input.farm.year]) if input.farm.year != 2026

holding_valid(animal) if {
	animal.held_from <= sprintf("%d-04-01", [input.farm.year])
	animal.held_to >= holding_deadline
}

movement_report_required(animal, event) if {
	animal.species != "cattle"
	event.event_type == "departure"
	event.event_date <= sprintf("%d-12-31", [input.farm.year])
}

movement_report_timely(animal, event) if {
	movement_report_required(animal, event)
	event.reported_within_days <= 7
}

temporary_stay_is_not_departure(_, event) if {
	event.event_type == "temporary_transfer"
	event.temporary_stay == true
	event.control_remains_with_applicant == true
}

replacement_required(animal, event) if {
	animal.species != "cattle"
	event.event_type == "replacement"
	event.event_date <= holding_deadline
	event.days_until_replacement <= 35
}

replacement_report_required(animal, event) if {
	animal.species != "cattle"
	event.event_type == "replacement"
	event.event_date <= holding_deadline
}

replacement_report_timely(animal, event) if {
	replacement_report_required(animal, event)
	event.reported_within_days <= 7
}

replacement_same_breed(event) if event.original_breed == event.replacement_breed

replacement_lower_premium_applies(event) if {
	event.original_sex == "female"
	event.replacement_sex == "male"
}

replacement_lower_premium_applies(event) if {
	event.original_milk_control == true
	event.replacement_milk_control == false
}

breeding_station_transfer_allowed(event) if {
	event.purpose == "breeding_station"
	event.duration_months <= 6
}

male_breeding_transfer_allowed(event) if {
	event.purpose == "temporary_breeding_use"
	event.animal_sex == "male"
	event.duration_months <= 3
}

transfer_notice_required(animal, event) if {
	animal.species != "cattle"
	event.event_type == "temporary_transfer"
	event.duration_days > 10
}

transfer_notice_not_required(_, event) if {
	event.event_type == "temporary_transfer"
	event.duration_days <= 10
	event.documented == true
}

cattle_database_replaces_reports(animal) if animal.species == "cattle"

premium(animal) := amount if {
	breed := breed_record(animal)
	pt := breed.premium_tier
	kind := premium_animal_type(animal.animal_type)
	record := latest_premium_record(kind, pt)
	gep := gep_amount(record, breed)
	milk := milk_amount(record, animal)
	amount := (record.base + gep) + milk
}

gep_amount(record, breed) := record.gep if breed.special_gep == true
gep_amount(_, breed) := 0 if not breed.special_gep == true
milk_amount(record, animal) := record.milk_control if animal.breeding_facts.milk_control == true
milk_amount(_, animal) := 0 if not animal.breeding_facts.milk_control == true

premium_animal_type(type) := "ewe_or_doe" if type in {"ewe", "doe"}
premium_animal_type(type) := "ram_or_buck" if type in {"ram", "buck"}
premium_animal_type(type) := type if not type in {"ewe", "doe", "ram", "buck"}

latest_premium_record(kind, tier) := record if {
	records := [r | some r in data.premiums_eur_per_animal; r.animal_type == kind; r.premium_tier == tier; r.year_from <= input.farm.year]
	latest_year := max({r.year_from | r := records[_]})
	record := records[_]
	record.year_from == latest_year
}

premium_rows := data.premiums_eur_per_animal

contract_year_valid if {
	input.farm.year >= 2023
	input.farm.year <= 2028
}

application_on_time if {
	input.farm.application_date <= sprintf("%d-12-31", [input.farm.year - 1])
}

latest_entry_allowed if input.farm.year <= 2027
