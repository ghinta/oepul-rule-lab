package oepul.o6_14

import rego.v1

# Input shape is described by the discover-mode profile changes.  A missing fact
# deliberately produces an unresolved result instead of an invented decision.
rgve_factor(category) := data.rgve_factors[category]

eligible_species := {"cattle", "sheep", "goats", "equids", "new_world_camelids"}

eligible_animal(animal) if {
	eligible_species[animal.species]
	animal.days_total >= 60
}

eligible_rgve(animal) := animal.count * rgve_factor(animal.category) if {
	eligible_animal(animal)
}

stocking_rgve(alp) := sum([eligible_rgve(a) | some a in alp.animals])

stocking_density(alp) := stocking_rgve(alp) / alp.area_ha if alp.area_ha > 0

stocking_limit(alp) := 2.4 if {
	alp.weideplan_intensification_approved
}

stocking_limit(alp) := 1.5 if {
	alp.nature_supplement
	not alp.weideplan_intensification_approved
}

stocking_limit(alp) := 2.0 if {
	not alp.nature_supplement
	not alp.weideplan_intensification_approved
}

stocking_compliant(alp) if stocking_density(alp) <= stocking_limit(alp)

eligible_premium_area(alp) := min([alp.area_ha, stocking_rgve(alp)])

base_rate(alp) := data.base_eur_per_ha[alp.access_stage]

base_premium(alp) := eligible_premium_area(alp) * base_rate(alp) if {
	stocking_compliant(alp)
}

weideplan_premium(alp) := min([eligible_premium_area(alp), 20]) * data.weideplan_eur_per_ha_first_20 if {
	alp.weideplan
	not alp.nature_supplement
	stocking_compliant(alp)
}

initial_participation_compliant(farm) if {
	sum([a.area_ha | some a in farm.alpine_pastures]) >= 3
	sum([stocking_rgve(a) | some a in farm.alpine_pastures]) >= 3
}

violations contains {"id": "o6_14.stocking", "alp_id": alp.id} if {
	some alp in input.alpine_pastures
	not stocking_compliant(alp)
}

violations contains {"id": "o6_14.nature_weideplan_incompatible", "alp_id": alp.id} if {
	some alp in input.alpine_pastures
	alp.nature_supplement
	alp.weideplan
}
