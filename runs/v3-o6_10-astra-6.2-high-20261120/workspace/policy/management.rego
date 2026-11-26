package oepul.o6_10

import rego.v1

# The event date is the actual event triggering re-establishment.
reseed_due(e) := sprintf("%d-05-15", [year_of(e.date) + 1]) if {
	e.kind == "clearing"
	e.date > sprintf("%d-09-15", [year_of(e.date)])
} else := substring(time.format(min({date_ns(e.date) + (56 * 86400000000000), date_ns(sprintf("%d-10-01", [year_of(e.date)]))})), 0, 10) if {
	e.kind in {"break", "clearing", "planting"}
}

covered_by_deadline(c, day) if {
	some e in c.events
	e.date <= day
	day <= reseed_due(e)
	e.reseeded_on == null
}

covered_by_deadline(c, day) if {
	some e in c.events
	e.date <= day
	day < e.reseeded_on
	day <= reseed_due(e)
}

proper_sowing(q) if {
	q.seedbed
	q.timing
	q.rate
	q.depth
	q.equipment
	q.crops
}

drought_cover(p, o) if {
	input.farm.year == 2026
	year_of(o.date) == 2026
	p.oepul.in_at
	proper_sowing(o.sowing_quality)
	o.dry_emergence_gap
}

drought_grain(p, o) if {
	input.farm.year == 2026
	year_of(o.date) == 2026
	p.oepul.in_at
	proper_sowing(o.sowing_quality)
	o.excess_due_to_volunteer_grain_and_dry_germination
}

grazing_allowed(g) if {
	g.species == "sheep"
	g.extensive_density
	g.main_crop_primary
}

grazing_allowed(g) if {
	g.species == "poultry"
	g.year_round == false
}

requires_cover(p) if crop_group(p) in {"orchard", "hop"}

requires_cover(p) if {
	crop_group(p) == "vineyard"
	p.oepul.wine_terrace == false
}

requires_cover(p) if {
	crop_group(p) == "vineyard"
	p.oepul.wine_terrace
	is_number(p.oepul.section_slope_pct)
	p.oepul.section_slope_pct < 25
}

# point-in-time observations across the year, including peak cereal/maize share
observation(p, o) if {
	requires_cover(p)
	year_of(o.date) == input.farm.year
	not covered_by_deadline(p.operations.erosion, o.date)
}

width_limit(p) := 80 if crop_group(p) == "vineyard"

else := 100 if crop_group(p) in {"hop", "orchard"}

cover_issue[p.parcel_id] contains "alleys" if {
	some p in input.land.parcels
	some o in p.operations.erosion.observations
	observation(p, o)
	o.special_system_width_impossible == false
	o.all_alleys_covered == false
	not drought_cover(p, o)
}

cover_issue[p.parcel_id] contains "width" if {
	some p in input.land.parcels
	some o in p.operations.erosion.observations
	observation(p, o)
	o.special_system_width_impossible == false
	is_number(o.open_strip_cm)
	o.open_strip_cm > width_limit(p)
}

cover_issue[p.parcel_id] contains "special_rows" if {
	some p in input.land.parcels
	some o in p.operations.erosion.observations
	observation(p, o)
	o.special_system_width_impossible
	is_number(o.covered_pct)
	o.covered_pct < 60
	not drought_cover(p, o)
}

cover_issue[p.parcel_id] contains "sowing" if {
	some p in input.land.parcels
	requires_cover(p)
	c := p.operations.erosion
	c.origin == "sown"
	is_number(c.winter_hardy_partners)
	c.winter_hardy_partners < 3
}

cover_issue[p.parcel_id] contains "mulch" if {
	some p in input.land.parcels
	requires_cover(p)
	p.operations.erosion.origin == "organic_mulch"
}

cover_issue[p.parcel_id] contains "spontaneous" if {
	some p in input.land.parcels
	requires_cover(p)
	p.operations.erosion.origin == "spontaneous"
}

cover_issue[p.parcel_id] contains "pure_grain" if {
	some p in input.land.parcels
	requires_cover(p)
	c := p.operations.erosion
	is_cereal(c.pure_seed)
	lower(c.pure_seed) != "grünschnittroggen"
}

cover_issue[p.parcel_id] contains "pure_grain" if {
	some p in input.land.parcels
	requires_cover(p)
	c := p.operations.erosion
	lower(c.pure_seed) == "grünschnittroggen"
	c.authorised_green_rye == false
}

cover_issue[p.parcel_id] contains "pure_grain" if {
	some p in input.land.parcels
	requires_cover(p)
	lower(p.operations.erosion.pure_seed) == "mais"
}

# Percentages are absolute shares of the stand at the same observation.
cover_issue[p.parcel_id] contains "share" if {
	some p in input.land.parcels
	some o in p.operations.erosion.observations
	requires_cover(p)
	year_of(o.date) == input.farm.year
	(o.cereal_pct + o.maize_pct) - o.oat_spring_barley_nurse_pct > 50
	not drought_grain(p, o)
}

cover_issue[p.parcel_id] contains "tillage" if {
	some p in input.land.parcels
	requires_cover(p)
	some e in p.operations.erosion.tillage
	year_of(e.date) == input.farm.year
	e.destroyed_cover
	e.followed_by_reestablishment == false
}

cover_issue[p.parcel_id] contains "renewal" if {
	some p in input.land.parcels
	requires_cover(p)
	count([1 | some e in p.operations.erosion.events; e.kind == "break"; year_of(e.date) == input.farm.year]) > 1
}

cover_issue[p.parcel_id] contains "deadline" if {
	some p in input.land.parcels
	requires_cover(p)
	some e in p.operations.erosion.events
	due := reseed_due(e)
	year_of(due) == input.farm.year
	is_string(e.reseeded_on)
	e.reseeded_on > due
}

cover_issue[p.parcel_id] contains "deadline" if {
	some p in input.land.parcels
	requires_cover(p)
	some e in p.operations.erosion.events
	due := reseed_due(e)
	year_of(due) == input.farm.year
	e.reseeded_on == null
	input.farm.oepul.as_of > due
}

cover_issue[p.parcel_id] contains "use" if {
	some p in input.land.parcels
	p.operations.erosion.mowings_removed == true
}

cover_issue[p.parcel_id] contains "use" if {
	some p in input.land.parcels
	p.operations.erosion.other_use == true
}

cover_issue[p.parcel_id] contains "grazing" if {
	some p in input.land.parcels
	some g in p.operations.erosion.grazing
	not g.species in {"sheep", "poultry"}
	is_string(g.species)
}

cover_issue[p.parcel_id] contains "grazing" if {
	some p in input.land.parcels
	some g in p.operations.erosion.grazing
	g.species == "sheep"
	false in [object.get(g, "extensive_density", null), object.get(g, "main_crop_primary", null)]
}

cover_issue[p.parcel_id] contains "grazing" if {
	some p in input.land.parcels
	some g in p.operations.erosion.grazing
	g.species == "poultry"
	g.year_round
}

cover_issue[p.parcel_id] contains "psm" if {
	some p in input.land.parcels
	p.operations.erosion.psm_on_living_alley_cover == true
}

cover_issue[p.parcel_id] contains "mechanical" if {
	some p in input.land.parcels
	p.operations.erosion.nonmechanical_termination == true
}

missing_cover_records(record, events) := {row.field |
	some row in t.cover_record_fields
	row.event in array.concat(["all"], events)
	not filled(record, row.field)
}

filled(record, key) if {
	v := record[key]
	v != null
	v != ""
	v != false
}

missing_application_records(a) := {f | some f in t.application_record_fields; not filled(a, f)}

park_block(p) if p.oepul.national_park in {"Neusiedlersee", "Donau-Auen"}
park_block(p) if p.oepul.park_relevant_restrictions == true

land_issue[p.parcel_id] contains "park" if {
	some p in input.land.parcels
	park_block(p)
}

land_issue[p.parcel_id] contains "cultivation" if {
	some p in input.land.parcels
	some key in {"proper_planting", "annual_care", "harvest_removed"}
	p.oepul[key] == false
}

land_issue[p.parcel_id] contains "ineligible" if {
	some p in input.land.parcels
	some key in {"correct_reference", "claimed_for_measure", "active_production", "mainly_agricultural"}
	p.oepul[key] == false
}

land_issue[p.parcel_id] contains "ineligible" if {
	some p in input.land.parcels
	p.oepul.land_exclusion in {"other_area", "gloez_element", "palm_catkins", "short_rotation", "nursery", "energy_wood"}
}

land_issue[p.parcel_id] contains "trial" if {
	some p in input.land.parcels
	"VF" in p.oepul.codes
}

land_issue[p.parcel_id] contains "trial" if {
	some p in input.land.parcels
	p.oepul.trial_prevents_compliance == true
}

land_issue[p.parcel_id] contains "op" if {
	some p in input.land.parcels
	"OP" in p.oepul.codes
}

land_issue[p.parcel_id] contains "op" if {
	some p in input.land.parcels
	p.oepul.measure_specific_op == true
}

land_issue[p.parcel_id] contains "stock" if {
	some p in input.land.parcels
	p.crop.crop_category == "orchard"
	p.oepul.quality_planting_stock == false
}

parcel_findings contains {"parcel_id": p.parcel_id, "rule_id": concat("", ["o6_10.", key])} if {
	some p in input.land.parcels
	p.oepul.in_at
	crop_group(p)
	some key in cover_issue[p.parcel_id]
}

parcel_findings contains {"parcel_id": p.parcel_id, "rule_id": concat("", ["o6_10.", key])} if {
	some p in input.land.parcels
	p.oepul.in_at
	crop_group(p)
	some key in land_issue[p.parcel_id]
}

# Die Feststellung ist an den konkreten Bestandsmangel und die Beobachtung gebunden.
automatic_force_majeure contains {"parcel_id": p.parcel_id, "date": o.date, "rule_id": "o6_10.drought_cover", "individual_report_required": false} if {
	some p in input.land.parcels
	some o in p.operations.erosion.observations
	observation(p, o)
	cover_gap(o)
	drought_cover(p, o)
}

cover_gap(o) if {
	o.special_system_width_impossible == false
	o.all_alleys_covered == false
}

cover_gap(o) if {
	o.special_system_width_impossible
	is_number(o.covered_pct)
	o.covered_pct < 60
}

automatic_force_majeure contains {"parcel_id": p.parcel_id, "date": o.date, "rule_id": "o6_10.drought_grain", "individual_report_required": false} if {
	some p in input.land.parcels
	requires_cover(p)
	some o in p.operations.erosion.observations
	(o.cereal_pct + o.maize_pct) - o.oat_spring_barley_nurse_pct > 50
	drought_grain(p, o)
}
