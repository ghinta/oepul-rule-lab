package oepul.o6_21

import rego.v1

# Reference queries for co-claimed land measures. Their results do not enter cattle RGVE.
programme := data.o6_programmkontext

crop_groups(name, y) := {r.group | some r in programme.crop_groups; r.crop == name; y >= r.from_year}

area_ceiling(group, y) := r if {
	some r in programme.area_ceiling
	r.group == group
	y >= r.from_year
	y <= r.through_year
}

contract_term(code) := r.period if {
	some r in programme.contracts
	r.measure == code
}

duration_of(start) := r if {
	some r in programme.multiyear_periods
	r.start == start
}

switch_allowed(src, dst, y) if {
	some r in programme.contract_switch
	r.source == src
	r.target == dst
	y >= 2023
	y <= r.last_source_year
}

combination_cell(src, dst) := {"entry": row.cells[dst], "footnotes": programme.combination_notes} if {
	some row in programme.area_combinations
	row.measure == src
}

allowed_area_loss(prior_ha) := max([0.5, min([5, prior_ha * 0.05])]) if prior_ha >= 0

div_option(code) := r.regular_use if {
	some r in programme.div_options
	r.code == code
}

drought_harvest_waiver(parcel, y) if {
	y == 2026
	parcel.drought_no_harvest
	parcel.normally_late_summer_or_autumn
	some area in programme.drought_districts
	area.state == parcel.state
	area.district in {"alle Bezirke", parcel.district}
}

structural_takeover_activity(code) := r.activity if {
	some r in programme.takeover_activities
	code in split(r.measure, "/")
}

public_exception(code, y) if {
	some r in programme.public_entity_exceptions
	r.measure == code
	y >= r.from_year
	y <= r.through_year
}

annually_variable(unit) if unit in programme.annually_variable_units

management_exception(code, area, y) if {
	some r in programme.minimum_management_exemptions
	code in split(r.measure, "/")
	area == r.area
	y >= 2023
	y <= r.through_year
	contract_available(code, y)
}

contract_available(code, y) if {
	code != "1C"
	y >= 2023
}

contract_available("1C", y) if y >= 2025

permitted_access_ha(code, base_2025, y) := max([5, base_2025 * 0.5]) if {
	code in programme.area_gain_limit
	y >= 2026
	y <= 2028
	base_2025 >= 0
}

farm_conflict(first, second, bio_part) if {
	some r in programme.farm_conflicts
	{first, second} == {r.first, r.second}
	not applicable_bio_exception(r, bio_part)
}

applicable_bio_exception(r, part) if {
	part == true
	r.bio_part_farm_exception
}

harvest_exempt_parcels contains p.parcel_id if {
	some p in input.land.parcels
	drought_harvest_waiver(p.harvest_exception_2026, year)
}

assessed_sanction_pct := sanction_percent(year, g.sanction_level)
