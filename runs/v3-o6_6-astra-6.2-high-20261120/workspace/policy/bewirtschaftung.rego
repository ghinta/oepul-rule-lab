package oepul.o6_6

import data.zwf_tabellen as tab
import rego.v1

removal_ok(c, y) if {
	c.variant in {1, 2, 3, 4, 5, 6}
	r := c.removal
	r.method in {"tillage_break", "direct_sowing", "mulch_sowing", "strip_sowing"}
	day(r.date) >= day(break_from(c, y))
}

removal_ok(c, y) if {
	variant_row(c.variant, y)
	c.variant <= 6
	c.removal.method == "shred_after_frost"
	c.removal.fully_frozen == true
}

removal_ok(c, y) if {
	variant_row(c.variant, y)
	c.variant <= 5
	count(c.components) > 0
	every s in c.components { s.winter_hardy == false }
	frost_removal(c.removal)
}

frost_removal(r) if {
	r.method == "collapsed"
	r.fully_frozen == true
}

frost_removal(r) if r.method == "rolled_down"

early_cut(e) if {
	e.kind == "chop"
	e.problem_species in tab.problemarten
	e.evidence == true
	e.low_cut == false
	e.cover_retained == true
}

event_reason[i][j] contains "zwf.stickstoff" if {
	c := input.land.parcels[i].operations.cover_crop
	e := c.events[j]
	y := input.farm.year

	e.kind == "mineral_n"
	in_period(c, y, e.date)
}

pesticide(e) if e.kind in {"pesticide", "herbicide", "slug_pellets"}

event_reason[i][j] contains "zwf.psm" if {
	c := input.land.parcels[i].operations.cover_crop
	e := c.events[j]
	y := input.farm.year

	c.variant <= 6
	pesticide(e)
	in_period(c, y, e.date)
}

event_reason[i][j] contains "zwf.psm.folgesaat" if {
	c := input.land.parcels[i].operations.cover_crop
	e := c.events[j]
	y := input.farm.year

	c.variant <= 6
	pesticide(e)
	day(e.date) >= day(break_from(c, y))
	no_prior_removal(c, y, e)
	before_next_sowing(c, e)
}

no_prior_removal(c, _, _) if c.removal.method == "none"

no_prior_removal(c, y, e) if {
	day(c.removal.date) > day(e.date)
	variant_row(c.variant, y)
}

no_prior_removal(c, _, _) if c.removal.method in {"harrow", "shorten_regrowing"}

before_next_sowing(c, _) if c.next_sowing == null
before_next_sowing(c, e) if day(e.date) < day(c.next_sowing)

before_next_sowing(c, e) if {
	e.date == c.next_sowing
	e.after_next_sowing == false
}

event_reason[i][j] contains "zwf.v7.psm" if {
	c := input.land.parcels[i].operations.cover_crop
	e := c.events[j]
	y := input.farm.year

	c.variant == 7
	in_period(c, y, e.date)
	e.kind == "herbicide"
	e.rape_leaves > 4
}

event_reason[i][j] contains "zwf.v7.psm" if {
	c := input.land.parcels[i].operations.cover_crop
	e := c.events[j]
	y := input.farm.year

	c.variant == 7
	in_period(c, y, e.date)
	e.kind == "herbicide"
	e.damages_companion == true
}

event_reason[i][j] contains "zwf.v7.psm" if {
	c := input.land.parcels[i].operations.cover_crop
	e := c.events[j]
	y := input.farm.year

	c.variant == 7
	in_period(c, y, e.date)
	pesticide(e)
	e.approved_for_rape == false
}

event_reason[i][j] contains "zwf.boden" if {
	c := input.land.parcels[i].operations.cover_crop
	e := c.events[j]
	y := input.farm.year

	in_period(c, y, e.date)
	e.kind in {"knife_roller", "destructive_tillage", "plough"}
}

event_reason[i][j] contains "zwf.boden" if {
	c := input.land.parcels[i].operations.cover_crop
	e := c.events[j]
	y := input.farm.year

	in_period(c, y, e.date)
	e.kills_cover == true
	e.kind in {"tillage", "strip_till", "deep_loosening", "roll", "harrow"}
}

care_early(c, y, e) if {
	r := variant_row(c.variant, y)
	is_string(r.care_from)
	e.date < date_in(y, r.care_from)
}

event_reason[i][j] contains "zwf.pflege" if {
	c := input.land.parcels[i].operations.cover_crop
	e := c.events[j]
	y := input.farm.year

	e.kind in {"chop", "mulch", "maintenance_mow"}
	in_period(c, y, e.date)
	care_early(c, y, e)
	not early_cut(e)
}

event_reason[i][j] contains "zwf.pflege" if {
	c := input.land.parcels[i].operations.cover_crop
	e := c.events[j]
	y := input.farm.year

	e.kind in {"chop", "mulch", "maintenance_mow"}
	in_period(c, y, e.date)
	e.frozen == false
	not early_cut(e)
	some field in {"regrowth", "erosion_protection", "nitrate_retention", "cover_retained"}
	e[field] == false
}

event_reason[i][j] contains "zwf.abgefroren" if {
	c := input.land.parcels[i].operations.cover_crop
	e := c.events[j]
	y := input.farm.year

	in_period(c, y, e.date)
	e.kind == "chop"
	e.low_cut == true
	e.frozen == false
}

event_reason[i][j] contains "zwf.walzen" if {
	c := input.land.parcels[i].operations.cover_crop
	e := c.events[j]
	y := input.farm.year

	in_period(c, y, e.date)
	e.kind == "roll"
	care_early(c, y, e)
	not immediate_roll(c, e)
}

immediate_roll(c, e) if {
	e.date == established(c)
	e.seedbed_rolling == true
}

event_reason[i][j] contains "zwf.walzen" if {
	c := input.land.parcels[i].operations.cover_crop
	e := c.events[j]
	y := input.farm.year

	in_period(c, y, e.date)
	e.kind == "roll"
	e.cover_retained == false
	not immediate_roll(c, e)
}

event_reason[i][j] contains "zwf.einsaat" if {
	c := input.land.parcels[i].operations.cover_crop
	e := c.events[j]
	y := input.farm.year

	in_period(c, y, e.date)
	e.kind == "additional_sowing"
	some field in {"winter_hardy", "coulter_only"}
	e[field] == false
}

event_reason[i][j] contains "zwf.striptill" if {
	c := input.land.parcels[i].operations.cover_crop
	e := c.events[j]
	y := input.farm.year

	in_period(c, y, e.date)
	e.kind == "strip_till"
	e.full_width == true
}

event_reason[i][j] contains "zwf.striptill" if {
	c := input.land.parcels[i].operations.cover_crop
	e := c.events[j]
	y := input.farm.year

	in_period(c, y, e.date)
	e.kind == "strip_till"
	e.cover_retained == false
}

event_reason[i][j] contains "zwf.tiefenlockerung" if {
	c := input.land.parcels[i].operations.cover_crop
	e := c.events[j]
	y := input.farm.year

	in_period(c, y, e.date)
	e.kind == "deep_loosening"
	e.cover_retained == false
}

event_reason[i][j] contains "zwf.nutzung" if {
	c := input.land.parcels[i].operations.cover_crop
	e := c.events[j]
	y := input.farm.year

	in_period(c, y, e.date)
	e.kind in {"mow_remove", "graze"}
	some field in {"regrowth", "cover_retained"}
	e[field] == false
}

event_reason[i][j] contains "zwf.drusch" if {
	c := input.land.parcels[i].operations.cover_crop
	e := c.events[j]

	e.kind == "thresh_cover"
	day(e.date) >= day(established(c))
}

event_reason[i][j] contains "zwf.v1.befahren" if {
	c := input.land.parcels[i].operations.cover_crop
	e := c.events[j]
	y := input.farm.year

	c.variant == 1
	r := variant_row(1, y)
	in_period(c, y, e.date)
	e.date <= date_in(y, r.no_traffic_through)
	e.traffic == true
	e.neighbour_crossing == false
}

event_findings contains {"parcel_id": p.parcel_id, "date": e.date, "kind": e.kind, "rule_id": rule} if {
	some i, p in input.land.parcels
	c := p.operations.cover_crop
	some j, e in c.events
	c.claimed == true
	some rule in event_reason[i][j]
}

no_prior_removal(c, y, _) if {
	c.removal.assessed == true
	not removal_ok(c, y)
}
