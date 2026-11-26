package oepul.o6_15

import data.behirtung as tables
import rego.v1

size_ok if record.general.participation_year > 1

size_ok if {
	record.general.participation_year == 1
	record.general.protected_at_ha >= 0.5
}

size_ok if {
	record.general.participation_year == 1
	record.general.qualifying_at_ha >= 1.5
}

public_share_ok(_, limit) if limit == null

public_share_ok(g, limit) if {
	is_number(limit)
	g.public_share_pct >= 0
	g.public_share_pct <= limit
}

applicant_ok if {
	g := record.general
	g.public_body_or_institution == false
	g.equivalent_public_influence == false
	g.controlled_by_excluded_entity == false
	some row in tables.applicants
	row.form == g.legal_form
	public_share_ok(g, row.public_share_cap)
	g.own_name
	g.own_account
	g.disposal_over_land
	g.active_farmer
	g.agricultural_activity
}

transfer_possible if {
	t := record.transfer
	t.event in tables.transfer_events
	t.animal_predecessor == t.land_predecessor
	t.online_application
}

sanction_effect(assessment, prior_full_cuts) := {"percent": pct, "exclusion_and_recovery": exclude} if {
	some row in tables.sanctions
	assessment == row.assessment
	year_ok
	pct := sanction_pct(row)
	exclude := count({1 | pct == 100; prior_full_cuts >= 1}) == 1
}

sanction_pct(row) := row.from_2027 if year >= 2027

else := row.until_2026

drought_request_possible if {
	year == 2026
	record.drought_prevents_obligation
}

district_matches(row, parcel) if {
	row.district == "alle Bezirke"
	row.state == parcel.state
}

district_matches(row, parcel) if {
	row.district == parcel.district
	row.state == parcel.state
}

harvest_exempt(parcel) if {
	year == 2026
	parcel.land_use == "arable"
	parcel.usual_late_harvest
	parcel.heat_and_drought_affected
	parcel.no_harvestable_crop_due_to_drought
	some row in tables.drought_districts
	district_matches(row, parcel)
}

crop_class(name) := row.class if {
	some row in tables.crop_classes
	lower(name) == lower(row.crop)
	year >= row.from_year
}

switch_allowed(source, target, when) if {
	some row in tables.switches
	source == row.from
	target == row.to
	day(when) <= day(sprintf("%d-12-31", [row.until_year]))
}

area_cap(group) := row if {
	some row in tables.area_caps
	group == row.group
	year >= row.from_year
	year <= row.to_year
}

combination_cell(first, second) := {"mark": cell.mark, "notes": notes} if {
	some cell in tables.combination_cells
	first == cell.row
	second == cell.column
	notes := [n | some n in tables.combination_notes; note_applies(n.id, cell, first, second)]
}

note_applies(id, c, _, _) if {
	id == 1
	endswith(c.mark, "1)")
}

note_applies(id, c, _, _) if {
	id == 3
	endswith(c.mark, "3)")
}

note_applies(id, _, a, b) if {
	id == 2
	"13" in {a, b}
}

note_applies(id, _, a, b) if {
	id == 4
	count({a, b} & {"8", "16"}) > 0
}

general_key(category) := row if {
	some row in tables.general_gve
	row.category == category
}

nature_rate(code, pct) := row.eur_ha if {
	year >= 2024
	some row in tables.nature_rates
	row.code == code
	pct > row.above_pct
	pct <= row.through_pct
}

reduction_order := tables.reduction_order
restricted_accession(measure) if measure in tables.restricted_accessions

public_exception(measure) if {
	some r in tables.public_exceptions
	r.measure == measure
	year >= r.first
	year <= r.last
}

partner_rate(condition) := r.eur_ha if {
	some r in tables.partner_rates
	r.condition == condition
	year >= r.from_year
	year <= r.to_year
}

contract_period(measure, start) := {"start": start, "end": start, "years": 1} if {
	some r in tables.contract_periods
	r.measure == measure
	r.annual
	start >= 2023
	start <= 2028
}

contract_period(measure, start) := span if {
	some r in tables.contract_periods
	r.measure == measure
	r.annual == false
	some span in tables.multi_year_starts
	span.start == start
}

tierhaltend if {
	g := record.general
	forage := input.land.grassland_area_ha + g.arable_forage_ha
	forage > 0
	g.average_domestic_rgve >= 0.30 * forage
}

tolerated_loss(previous_area) := max([0.5, min([0.05 * previous_area, 5])]) if previous_area >= 0
payment_deadline := sprintf("%d-06-30", [year + 1]) if year_ok

advance_limit(expected) := expected * 0.75 if {
	expected >= 0
	record.administration.checks_completed
}
