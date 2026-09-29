package oepul.o6_20

import rego.v1

# Input shape: input.o6_20.categories is an array of requested category records.
# A record supplies id, avg_rgve, grazing_days, all_animals_grazed,
# forage_mostly_grazed, substantial_day_grazing, water_access, shelter_access,
# diary_complete, and optional_150_days. It deliberately models the evidence
# that the canonical profile does not yet contain.

required_days(category) := 150 if category.optional_150_days
required_days(category) := 120 if not category.optional_150_days

total_requested_rgve := sum([category.avg_rgve | category := input.o6_20.categories[_]; category.requested])

minimum_participation_met if total_requested_rgve >= 2

category_violations contains {"category": category.id, "code": "minimum_grazing_days", "required": needed, "actual": category.grazing_days} if {
	category := input.o6_20.categories[_]
	category.requested
	needed := required_days(category)
	category.grazing_days < needed
}

category_violations contains {"category": category.id, "code": "all_animals", "required": true} if {
	category := input.o6_20.categories[_]
	category.requested
	not category.all_animals_grazed
}

category_violations contains {"category": category.id, "code": "forage_from_grazing", "required": true} if {
	category := input.o6_20.categories[_]
	category.requested
	not category.forage_mostly_grazed
}

category_violations contains {"category": category.id, "code": "substantial_day_grazing", "required": true} if {
	category := input.o6_20.categories[_]
	category.requested
	not category.substantial_day_grazing
}

category_violations contains {"category": category.id, "code": "water_access", "required": true} if {
	category := input.o6_20.categories[_]
	category.requested
	not category.water_access
}

category_violations contains {"category": category.id, "code": "shelter_or_rapid_stabling", "required": true} if {
	category := input.o6_20.categories[_]
	category.requested
	not category.shelter_access
}

category_violations contains {"category": category.id, "code": "grazing_diary", "required": true} if {
	category := input.o6_20.categories[_]
	category.requested
	not category.diary_complete
}

violations contains {"code": "minimum_rgve", "required": 2, "actual": total_requested_rgve} if {
	not minimum_participation_met
}

violations contains violation if {
	violation := category_violations[_]
}

eligible if {
	minimum_participation_met
	count(violations) == 0
}

rgve_factor(key) := factor.rgve if {
	factor := data.o6_20.gve_factors[_]
	factor.key == key
}
