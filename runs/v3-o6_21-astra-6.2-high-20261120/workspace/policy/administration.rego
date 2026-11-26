package oepul.o6_21

import rego.v1

g := input.farm.oepul

size_met if g.participation_year_number >= 2

size_met if {
	g.participation_year_number == 1
	g.protected_cultivation_at_ha >= 0.5
}

size_met if {
	g.participation_year_number == 1
	g.qualifying_at_ha >= 1.5
}

applicant_ok if {
	g.legal_form in {"natural", "registered_partnership", "legal_person", "association"}
	g.active_farmer
	g.agricultural_activity
	g.own_name_and_account
	g.land_at_disposal
	g.public_entity_or_controlled_subsidiary == false
	g.public_share_pct >= 0
	g.public_share_pct <= 25
	g.equivalent_public_influence == false
}

forage_crop(name) if name in cfg.forage_crops

annex_units(group, category_name, heads) := row.factor * heads if {
	some row in cfg.key_annex_a
	row.group == group
	row.category == category_name
	heads >= 0
}

livestock_density_met if {
	forage := input.land.grassland_area_ha + g.arable_forage_ha
	forage > 0
	g.all_annual_rgve >= 0.3 * forage
}

takeover_reviewable if {
	claim.takeover.event in cfg.takeover_events
	claim.takeover.same_previous_farm
	claim.takeover.online_mfa_submitted
}

max_occupancy(area, weight) := floor(area / max([r.total_m2 | some r in rows])) if {
	area >= 0
	rows := space_rows({"cow": false, "weight_kg": weight})
	count(rows) == 1
}

sanction_percent(y, code) := r.until_2026_percent if {
	some r in cfg.sanctions
	r.code == code
	y >= 2023
	y <= 2026
} else := r.percent if {
	some r in cfg.sanctions
	r.code == code
	y >= 2027
}

repeated_full_cut if g.full_cuts_in_contract >= 2
cut_sequence := cfg.cut_order
payment_deadline := sprintf("%d-06-30", [year + 1])

maximum_advance := g.expected_premium_eur * 0.75 if {
	g.administrative_checks_complete
	g.expected_premium_eur >= 0
}

# Positive findings require the inputs for the particular check.
stable_checks[id] := {"structure_met": stable_structure(s)} if {
	some s in claim.stables
	id := s.id
}

bedded_pens contains p.id if {
	some p in claim.pens
	bedding_ok(p)
}

permitted_events contains idx if {
	some idx, e in claim.housing_events
	housing_mode_ok(e)
}
