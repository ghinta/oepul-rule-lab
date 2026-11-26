package oepul.o6_10

import rego.v1

# Tarifauskünfte vor Modulation, Obergrenze und Sanktionen.
tariff_year(y) if {
	y >= 2023
	y <= 2028
}

slope_match(row, _) if row.slope_from == null

slope_match(row, s) if {
	is_number(s)
	row.slope_from != null
	s >= row.slope_from
	row.slope_below == null
}

slope_match(row, s) if {
	is_number(s)
	row.slope_from != null
	is_number(row.slope_below)
	s >= row.slope_from
	s < row.slope_below
}

amounts(row, y) := row.band if y <= 2024

else := [row.fixed, row.fixed]

base_rate(p) := amounts(row, input.farm.year) if {
	tariff_year(input.farm.year)
	some row in t.rates
	row.component == "base"
	row.crop == crop_group(p)
	slope_match(row, object.get(p, "slope_percent", null))
}

qualifying_application(a) if {
	a.kind in {"organism", "pheromone"}
	year_of(a.date) == input.farm.year
	a.replaces_psm
	a.register_rate_met
}

supplement_parcels contains p.parcel_id if {
	some p in input.land.parcels
	p.oepul.in_mfa
	p.oepul.in_at
	p.oepul.claimed_for_measure
	crop_group(p)
	"EOP" in p.oepul.codes
	input.farm.oepul.organisation_program == false
	some a in p.operations.erosion.applications
	qualifying_application(a)
}

supplement_factor := 0.5 if {
	some m in input.farm.oepul.active_measures
	m in {"1B", "1B-Teilbetrieb", "12"}
} else := 1 if is_array(input.farm.oepul.active_measures)

supplement_rate(p) := [r[0] * supplement_factor, r[1] * supplement_factor] if {
	tariff_year(input.farm.year)
	p.parcel_id in supplement_parcels
	some row in t.rates
	row.component == "eop"
	row.crop == crop_group(p)
	r := amounts(row, input.farm.year)
}

combination(row, column) := cell if {
	some cell in t.combinations
	cell.row == row
	cell.column == column
}

combination_note(n) := t.matrix_notes[n - 1] if n in {1, 2, 3, 4}

# Gewichteter Faktor für die Heimfläche. Keine Rundung von Zwischenergebnissen.
tier_area(ha, row) := max([0, ha - row.start]) if row.end == null

else := max([0, min([ha, row.end]) - row.start])

modulation_factor(ha) := sum([amount | some row in t.modulation; amount := tier_area(ha, row) * row.factor]) / ha if {
	is_number(ha)
	ha > 0
}

home_modulation := modulation_factor(input.land.mfa_home_ha)

cap_terms(group, y) := row if {
	some row in t.caps
	row.group == group
	y >= row.first_year
	y <= row.last_year
}

cap_total(group, y, rates) := min([sum(included), cap.eur_ha]) + sum(excluded) if {
	cap := cap_terms(group, y)
	included := [amount | some m, amount in rates; not m in cap.excluded]
	excluded := [amount | some m, amount in rates; m in cap.excluded]
}

deduction_order := t.deductions
sanction_options(y) := {s.stage: s.through_2026 | some s in t.sanctions} if y < 2027

else := {s.stage: s.from_2027 | some s in t.sanctions}

switch_targets(origin, y) := row.destinations if {
	some row in t.switches
	row.origin == origin
	y >= 2023
	y <= row.last_year
}

arable_drought_region(state, district, as_of) if {
	year_of(as_of) == 2026
	some row in t.arable_regions
	row.state == state
	row.district in {"*", district}
	row.notice <= as_of
}

payment_parameters.home_modulation := home_modulation
payment_parameters.transfer_due := sprintf("%d-06-30", [input.farm.year + 1]) if tariff_year(input.farm.year)

payment_parameters.advance_max_eur := expected * 0.75 if {
	input.farm.oepul.payment.administrative_checks_completed
	expected := input.farm.oepul.payment.expected_eur
	is_number(expected)
	expected >= 0
}

payment_parameters.waiver_possible := amount <= 50 if {
	amount := input.farm.oepul.payment.calculated_eur
	is_number(amount)
	amount >= 0
}

# Vollständige, bereits modulierte Beträge je Maßnahme einschließlich
# umgelegter LSE. Mehrere Komponenten einer Maßnahme werden summiert.
payment_parameters.parcel_caps[p.parcel_id] := cap_total(group, input.farm.year, rates) if {
	some p in input.land.parcels
	group := p.oepul.payment_cap_group
	rows := p.oepul.modulated_eur_ha_by_measure
	is_array(rows)
	every row in rows {
		is_string(row.measure)
		is_number(row.eur_ha)
		row.eur_ha >= 0
	}
	rates := {m: sum([r.eur_ha | some r in rows; r.measure == m]) | some row in rows; m := row.measure}
}
