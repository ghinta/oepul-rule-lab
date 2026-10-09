package opul.o6_15

import rego.v1

allowed_categories := {"Milchkühe", "Sonstige Rinder", "Schafe", "Ziegen", "Equiden", "Neuweltkamele"}
allowed_species := {"cattle", "sheep", "goat", "equine", "camelid"}

default annual_contract_valid := false

annual_contract_valid if {
	input.farm.year >= 2023
	input.farm.year <= 2028
	input.farm.o6_15_application_date <= sprintf("%d-12-31", [input.farm.year - 1])
}

default participation_valid := false

participation_valid if {
	input.farm.participates_almbewirtschaftung
	behirtete_rgve >= 3
	count(herded_groups) > 0
	all_animals_are_eligible
	all_requested_categories_allowed
}

all_requested_categories_allowed if {
	every group in herded_groups {
		group.category in allowed_categories
	}
}

all_animals_are_eligible if {
	every group in input.livestock.species_groups {
		group.species in allowed_species
	}
}

milk_cow_category_valid if {
	some group in input.livestock.species_groups
	group.category == "Milchkühe"
	group.age_years >= 2
	group.calvings >= 1
	group.milked_days_on_alms >= 45
}

milk_sheep_or_goat_category_valid if {
	some group in input.livestock.species_groups
	group.category in {"Schafe", "Ziegen"}
	group.age_years >= 1
	group.milked_days_on_alms >= 45
}

default sixty_day_requirement_valid := false

sixty_day_requirement_valid if {
	every group in herded_groups {
		group.herding_days >= 60
	}
	every parcel in input.land.parcels {
		alm_stocking_valid(parcel)
	}
}

alm_stocking_valid(parcel) if {
	not parcel.is_alm
}

alm_stocking_valid(parcel) if {
	parcel.is_alm
	parcel.stocking_days >= 60
}

default care_requirement_valid := false

care_requirement_valid if {
	every parcel in input.land.parcels {
		care_valid(parcel)
	}
}

care_valid(parcel) if {
	not parcel.is_alm
}

care_valid(parcel) if {
	parcel.is_alm
	parcel.care.daily_care
	parcel.care.care_essential_part_of_day
	parcel.care.water_available
	parcel.care.animal_care
	parcel.care.disease_and_injury_treatment
	parcel.care.security_measures
}

default grazing_management_valid := false

grazing_management_valid if {
	every parcel in input.land.parcels {
		grazing_valid(parcel)
	}
}

grazing_valid(parcel) if {
	not parcel.is_alm
}

grazing_valid(parcel) if {
	parcel.is_alm
	parcel.grazing_management.site_adapted_grazing
	parcel.grazing_management.subarea_rotation_or_fencing
}

default accommodation_valid := false

accommodation_valid if {
	every parcel in input.land.parcels {
		accommodation_valid_for_parcel(parcel)
	}
}

accommodation_valid_for_parcel(parcel) if {
	not parcel.is_alm
}

accommodation_valid_for_parcel(parcel) if {
	parcel.is_alm
	parcel.accommodation_available
}

default herd_protection_dog_valid := false

herd_protection_dog_valid if {
	input.livestock.herd_protection_dog.requested
	input.livestock.herd_protection_dog.days_on_single_alm >= 60
	input.livestock.herd_protection_dog.days_on_single_alm >= input.livestock.herd_protection_dog.herded_animals_total_days
	input.livestock.herd_protection_dog.certificate_recognized
	input.livestock.herd_protection_dog.liability_insurance
	input.livestock.herd_protection_dog.permanent_herd_member
	input.livestock.herd_protection_dog.day_and_night_with_herd
	input.livestock.herd_protection_dog.works_without_direct_commands
	input.livestock.herd_protection_dog.dogs_on_alm <= 5
}

default reporting_valid := false

reporting_valid if {
	input.farm.o6_15_payment_application_date <= payment_deadline
	every group in input.livestock.species_groups {
		report_valid(group)
	}
}

report_valid(group) if {
	not group.report
}

report_valid(group) if {
	group.report.days_after_event <= group.report.deadline_days
}

default exit_valid := false

exit_valid if {
	input.farm.o6_15_exit.requested
	input.farm.o6_15_exit.exit_effective_date >= sprintf("%d-01-01", [input.farm.year + 1])
}

default drought_higher_force_possible := false

drought_higher_force_possible if {
	input.farm.year == 2026
	input.farm.o6_15_drought.drought_prevented_obligation
	input.farm.o6_15_drought.higher_force_application_submitted
}

herded_groups := [group | some group in input.livestock.species_groups; group.herded]

behirtete_rgve := total if {
	total := sum([group.gve | some group in herded_groups])
}

milchvieh_rgve := total if {
	total := sum([group.gve | some group in herded_groups; milk_category(group.category); group.milked_days_on_alms >= 45])
}

milk_category(category) if {
	category == "Milchkühe"
}

milk_category(category) if {
	category == "Schafe"
}

milk_category(category) if {
	category == "Ziegen"
}

premium_rate := rate if {
	some rate in data.rates
	rate.from_year <= input.farm.year
	rate.to_year == null
}

premium_rate := rate if {
	some rate in data.rates
	rate.from_year <= input.farm.year
	rate.to_year != null
	input.farm.year <= rate.to_year
}

payment_deadline := sprintf("%d-07-17", [input.farm.year]) if {
	input.farm.year == 2023
}

payment_deadline := sprintf("%d-07-17", [input.farm.year]) if {
	input.farm.year == 2028
}

payment_deadline := sprintf("%d-07-15", [input.farm.year]) if {
	input.farm.year != 2023
	input.farm.year != 2028
}

first_twenty_rgve := min([20, behirtete_rgve])
after_twenty_rgve := max([behirtete_rgve - 20, 0])
milchvieh_first_twenty := min([20, milchvieh_rgve])
milchvieh_after_twenty := max([milchvieh_rgve - 20, 0])
base_premium := (first_twenty_rgve * premium_rate.first_20_rgve) + (after_twenty_rgve * premium_rate.after_20_rgve)
milk_premium := (milchvieh_first_twenty * premium_rate.milk_first_20_rgve) + (milchvieh_after_twenty * premium_rate.milk_after_20_rgve)
dog_premium := input.livestock.herd_protection_dog.dogs_on_alm * premium_rate.dog
premium_eur := (base_premium + milk_premium) + dog_premium

rgve_lookup(species, category) := value if {
	some entry in data.entries
	entry.species == species
	entry.category == category
	value := entry.rgve
}

rgve_key_complete if {
	count(data.entries) == 25
}
