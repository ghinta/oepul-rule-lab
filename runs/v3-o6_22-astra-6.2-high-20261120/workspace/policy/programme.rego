package oepul.o6_22

import rego.v1

legal_form_ok(a) if a.legal_form in {"natural_person", "registered_partnership"}

legal_form_ok(a) if {
	a.legal_form in {"legal_person", "association"}
	nonnegative(a.public_share_pct)
	a.public_share_pct <= 25
}

applicant_ok if {
	a := application.applicant
	legal_form_ok(a)
	a.public_body_or_institution == false
	a.equivalent_public_control == false
	a.controlled_subsidiary == false
	a.own_name
	a.own_account
	a.control_of_claimed_land
	a.active_farmer
	a.agriculturally_active
}

farm_size_ok if application.first_opul_year == false

farm_size_ok if {
	application.first_opul_year
	nonnegative(application.protected_cultivation_at_ha)
	application.protected_cultivation_at_ha >= 0.5
}

farm_size_ok if {
	application.first_opul_year
	nonnegative(application.qualifying_at_ha)
	application.qualifying_at_ha >= 1.5
}

transfer_reviewable(t) if {
	t.reason in {"dissolution", "division", "merger"}
	t.same_predecessor_land_animals
	t.mfa_online_filed
}

listed_crop(group, name, y) if {
	group in {"cereals", "fruit", "vegetables", "forage"}
	some r in tables[group]
	r.label == name
	y >= r.first_year
}

switch_listed(source, target, y) if {
	some r in tables.switches
	r.source == source
	r.target == target
	y >= 2023
	y <= r.last_year
}

area_cap(scope, y) := r if {
	some r in tables.area_caps
	r.scope == scope
	y >= r.start
	y <= r.end
}

drought_location(p) if {
	some r in tables.drought_districts
	r.state == p.state
	r.district in {"alle Bezirke", p.district}
}

harvest_exception(p) if {
	year == 2026
	drought_location(p)
	p.arable
	p.normal_harvest in {"late_summer", "autumn"}
	p.no_harvest_due_to_drought
}

band_end(b, h) := h if b.end == null

else := min([b.end, h])

modulation_factor(h) := 1 if h == 0

else := factor if {
	nonnegative(h)
	h > 0
	weighted := [amount | some b in tables.modulation; amount := max([0, band_end(b, h) - b.start]) * b.fraction]
	factor := sum(weighted) / h
}

sanction(level, y) := r.before_2027 if {
	some r in tables.sanctions
	r.level == level
	y < 2027
} else := r.from_2027 if {
	some r in tables.sanctions
	r.level == level
	y >= 2027
}

# Zu jedem Abteil nur die aus den vorliegenden Angaben bestätigten Einzelprüfungen.
pen_findings[i] contains "space" if {
	some i, p in application.pens
	pen_space_ok(p)
}

pen_findings[i] contains "enrichment" if {
	some i, p in application.pens
	enrichment_ok(p)
}

pen_findings[i] contains "building" if {
	some i, p in application.pens
	building_ok(p)
}

pen_findings[i] contains "lying" if {
	some i, p in application.pens
	lying_ok(p)
}

pen_findings[i] contains "group" if {
	some i, p in application.pens
	group_ok(p)
}

outdoor_findings[i] contains "density" if {
	some i, o in application.outdoors
	outdoor_density_ok(o)
}

outdoor_findings[i] contains "fence" if {
	some i, o in application.outdoors
	outdoor_fence_ok(o)
}

outdoor_findings[i] contains "stations" if {
	some i, o in application.outdoors
	outdoor_stations_ok(o)
}

outdoor_findings[i] contains "shelter" if {
	some i, o in application.outdoors
	shelter_ok(o)
}

outdoor_findings[i] contains "duration" if {
	some i, o in application.outdoors
	outdoor_duration_ok(o)
}

rgve_factor(class_code) := r.factor if {
	some r in tables.annex_a
	r.class_code == class_code
	r.unit == "RGVE"
}

livestock_status(rgve, forage_ha) := ratio >= 0.30 if {
	nonnegative(rgve)
	nonnegative(forage_ha)
	forage_ha > 0
	ratio := rgve / forage_ha
}

sanction_consequence(level, year_of_finding, full_cuts_in_contract) := {"exclude": true, "recover_contract_premiums": true} if {
	level == 100
	is_number(full_cuts_in_contract)
	full_cuts_in_contract >= 2
	is_number(year_of_finding)
} else := {"cut_percent": sanction(level, year_of_finding)} if {
	nonnegative(full_cuts_in_contract)
}

home_area := input.land.total_area_ha - input.land.alpine_pasture_area_ha if {
	nonnegative(input.land.total_area_ha)
	nonnegative(input.land.alpine_pasture_area_ha)
	input.land.total_area_ha >= input.land.alpine_pasture_area_ha
}

modulated_components[cat][component] := amount if {
	some cat, components in premium_components
	some component, raw in components
	amount := raw * modulation_factor(home_area)
}

programme_list_contains(list, code, y) if {
	list in {"annual_measures", "multiannual_measures", "public_exceptions", "takeover_cases"}
	some r in tables[list]
	r.code == code
	y >= object.get(r, "start", 2023)
	y <= object.get(r, "end", 2028)
}
