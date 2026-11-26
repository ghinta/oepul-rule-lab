package oepul.o6_2

import rego.v1

takeover_deadline := sprintf("%d-04-17", [year]) if year in {2023, 2028}

else := sprintf("%d-04-15", [year]) if {
	year >= 2024
	year <= 2027
}

takeover_ok if {
	r := app.takeover
	valid_date(r.date)
	r.date >= sprintf("%d-01-01", [year])
	r.date <= takeover_deadline
	r.previously_participating == false
	r.online_mfa
	r.ama_approved
	r.acquired_committed_ha > 0
	is_number(r.acquired_committed_ha)
	r.extension_ha >= 0
	r.extension_ha <= 0.5 * r.acquired_committed_ha
}

loss_tolerance := max([0.5, min([5, 0.05 * input.land.commitment.previous_year_ha])]) if {
	input.land.commitment.previous_year_ha >= 0
}

# Veränderung bereits bereinigt um Verlust der Verfügung und zulässige Umwandlungen.
repayable_loss_ha := lost if {
	lost := input.land.commitment.relevant_loss_ha
	lost > loss_tolerance
}

else := 0 if {
	lost := input.land.commitment.relevant_loss_ha
	lost >= 0
	lost <= loss_tolerance
}

conversion_allowed(old, new, measure_id) if {
	some row in t.conversions
	row.previous == old
	row.current == new
	is_string(measure_id)
}

conversion_allowed(_, new, measure_id) if {
	new == "LSE Mehrnutzenhecke"
	measure_id in {"1A", "1B"}
}

conversion_allowed(_, new, measure_id) if {
	new == "LSE Agroforststreifen"
	measure_id == "1C"
}

# Prämienfähiges Ausmaß der Zugänge insgesamt im Bewertungsjahr, vor anderen Abzügen.
payable_access_ha := new + transferred if {
	year in {2024, 2025}
	new := input.land.commitment.new_ha
	transferred := input.land.commitment.precommitted_ha
	min([new, transferred]) >= 0
}

else := min([new, cap]) + transferred if {
	year >= 2026
	year <= 2028
	a := input.land.commitment
	new := a.new_ha
	transferred := a.precommitted_ha
	min([new, transferred, a.base_2025_ha]) >= 0
	cap := max([5, 0.5 * a.base_2025_ha])
}

in_region(p, r) if {
	r.state == p.mfa.state
	r.district == "alle Bezirke"
}

in_region(p, r) if {
	r.state == p.mfa.state
	r.district == p.mfa.district
}

drought_waiver(p) if {
	year == 2026
	p.mfa.country == "AT"
	p.land_use == "arable"
	p.operations.harvest.typical_late_summer_or_autumn
	p.operations.harvest.no_harvestable_stand_due_to_drought
	some r in t.drought_regions
	in_region(p, r)
}

harvest_requirement_met(p) if drought_waiver(p)
harvest_requirement_met(p) if p.operations.harvest.individual_force_majeure_approved

harvest_requirement_met(p) if {
	p.operations.harvest.harvested_and_removed_pct >= 85
	p.operations.harvest.harvested_and_removed_pct <= 100
}

arable_management_ok(p) if {
	tariff_group(p) == "arable"
	p.operations.harvest.proper_sowing
	p.operations.harvest.annual_care
	harvest_requirement_met(p)
}

div_variant(code) := row.requirements if {
	some row in t.div_variants
	row.code == code
}

div_change(old, new, date) if {
	valid_date(date)
	startswith(date, "2026-")
	date > "2026-04-15"
	some row in t.div_changes
	row.from == old
	row.to == new
	date <= concat("", ["2026-", row.deadline])
}

cap_rule(group) := row if {
	some row in t.caps
	row.group == group
	row.year_from <= year
	row.year_to >= year
}

band_ha(area, row) := max([0, area - row.from_ha]) if row.to_ha == null

else := max([0, min([area, row.to_ha]) - row.from_ha])

modulation := weighted / area if {
	area := input.land.home_modulation_ha
	area > 0
	weighted := sum([value | some row in t.modulation; value := band_ha(area, row) * row.factor])
}

sanction_percent(level) := row.until_2026 if {
	some row in t.sanctions
	row.level == level
	year >= 2023
	year <= 2026
}

sanction_percent(level) := row.from_2027 if {
	some row in t.sanctions
	row.level == level
	year >= 2027
	year <= 2028
}

repeat_exclusion if input.documentation.full_reductions_this_contract >= 2
payment_deadline := sprintf("%d-06-30", [year + 1])

advance_limit := input.farm.payment.expected_eur * 0.75 if {
	input.farm.payment.administrative_checks_complete
	input.farm.payment.expected_eur >= 0
}

# Tarifwert anhand der bereits festgestellten förderfähigen Hektar.
# Offene Prüfungen, Kürzungen und andere Maßnahmen werden hier nicht geschätzt.
amount_before_adjustments[p.parcel_id] := (p.mfa.eligible_o6_2_ha * tenths_per_ha) / 10 if {
	some p in input.land.parcels
	p.mfa.country == "AT"
	p.mfa.claimed_o6_2
	p.mfa.eligible_o6_2_ha >= 0
	p.mfa.eligible_o6_2_ha <= p.area_ha
	not has_exclusion(p.parcel_id)

	# Die amtlichen Sätze haben genau eine Dezimalstelle.
	tenths_per_ha := round(rate(p) * 10)
}

has_exclusion(id) if some _reason in parcel_exclusions[id]

partner16_rate := groundwater_base(row.eur_per_ha) if {
	some row in t.partner16_rates
	row.component == "Basis"
	row.from_year <= year
	year <= row.through_year
}

partner23_rate(code) := row.eur_per_ha if {
	some row in t.partner23_rates
	row.code == code
	year >= 2024
	year <= 2028
	combination_cell("2", "23") == "x"
}

nature_chapter_cell(left, right) := row.cells[right] if {
	some row in t.nature_chapter_matrix
	row.chapter == left
}
