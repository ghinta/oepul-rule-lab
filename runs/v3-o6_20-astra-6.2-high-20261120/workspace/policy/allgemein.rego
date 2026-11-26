package oepul.o6_20

import data.weide_tables as t
import rego.v1

applicant_form_ok(form) if form in {"natural_person", "registered_partnership", "legal_person", "association", "territorial_authority", "public_institution"}

operator_ok if {
	a := input.farm.applicant
	applicant_form_ok(a.form)
	a.own_name
	a.own_account
	a.land_control
	a.active_farmer
	a.agricultural_activity
}

area_ok if input.farm.oepul_participation_year > 1

area_ok if {
	input.farm.oepul_participation_year == 1
	input.land.protected_at_ha >= 0.50
	is_number(input.land.protected_at_ha)
}

area_ok if {
	input.farm.oepul_participation_year == 1
	input.land.qualifying_at_ha >= 1.50
	is_number(input.land.qualifying_at_ha)
}

forage_crop(name) if name in t.forage_crops

livestock_density_ok(annual_rgve, forage_ha) if {
	forage_ha > 0
	annual_rgve >= 0.30 * forage_ha
}

annex_value(group, category_label, unit) := row.value if {
	some row in t.annex_a
	row.group == group
	row.category == category_label
	row.unit == unit
}

takeover_possible(x) if {
	x.reason in {"dissolution", "division", "merger"}
	x.animal_predecessor == x.land_predecessor
	is_string(x.animal_predecessor)
	x.animal_predecessor != ""
	x.approved
	x.filed_online
}

sanction_rate(y, "warning") := t.sanctions.warning_before_2027 if y < 2027

else := t.sanctions.warning_from_2027

sanction_rate(_, level) := n if {
	startswith(level, "cut_")
	n := t.sanctions[level]
}

ordered_reductions(applicable) := [stage | some stage in t.reduction_order; stage in applicable]

advance_limit(expected, checked) := 0.75 * expected if {
	checked == true
	expected >= 0
}

modulation(ha) := 1 if ha == 0

else := sum(weighted) / ha if {
	ha > 0
	weighted := [value | some r in t.modulation; value := max([0, tier_end(ha, r.upper) - r.lower]) * r.share]
}

tier_end(ha, null) := ha
tier_end(ha, end) := min([ha, end]) if is_number(end)

variant_change(from, to, date) if {
	some row in t.div_switch
	row.from == from
	row.to == to
	parts := split(date, "-")
	date > concat("", [parts[0], "-04-15"])
	day(date) <= day(concat("", [parts[0], "-", row.last]))
}

harvest_area_exception(y, state, district, late_crop, drought_no_harvest) if {
	y == 2026
	late_crop == true
	drought_no_harvest == true
	some row in t.harvest_regions
	row.state == state
	row.district in {district, "*"}
}

crop_group(name, year) := row.group if {
	some row in t.crops
	row.name == name
	year >= row.from_year
}

contract_term(measure, start_year) := 1 if {
	measure in t.annual_measures
	start_year >= 2023
	start_year <= 2027
} else := term.years if {
	measure in t.multiannual_measures
	some term in t.multiannual_terms
	term.start_year == start_year
}

switch_allowed(old, new, date) if {
	some r in t.switches
	r.source == old
	r.target == new
	day(date) <= day(year_date(r.last_entry_year, "12-31"))
}

area_loss_tolerance(previous_ha) := max([0.50, min([5, 0.05 * previous_ha])]) if previous_ha >= 0

hectare_cap(group, y) := row if {
	some row in t.hectare_caps
	row.group == group
	y >= row.from_year
	y <= row.through_year
}

parcel_combination(a, b) := {"mark": r.mark, "footnotes": notes} if {
	some r in t.parcel_matrix
	r.row == a
	r.column == b
	notes := {n: text |
		some n, text in t.matrix_footnotes
		matrix_footnote_applies(n, r)
	}
}

matrix_footnote_applies(n, r) if n == sprintf("%v", [r.cell_footnote])
matrix_footnote_applies("2", r) if "13" in {r.row, r.column}
matrix_footnote_applies("4", r) if {r.row, r.column} & {"8", "16"} != set()

div_requirements(code) := row if {
	some row in t.div_grassland
	row.code == code
}

project_pasture(code, annual_rgve_ha, date, first, last, extra_fertilizer, psm) if {
	some row in t.project_grazing
	row.code == code
	annual_rgve_ha >= 0
	annual_rgve_ha <= row.maximum_rgve_ha_year
	day(first) <= day(date)
	day(date) <= day(last)
	extra_fertilizer == row.additional_fertilizer_allowed
	psm == row.psm_allowed
}
