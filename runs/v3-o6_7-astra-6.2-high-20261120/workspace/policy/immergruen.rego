package oepul.o6_7

import data.ig_tables as t
import rego.v1

effective_kind(c) := "main" if {
	c.kind == "catch"
	c.declared == true
}

else := c.kind

# Dates are local agricultural calendar dates. UTC midnight only encodes their ordinal.
day(d) := time.parse_rfc3339_ns(sprintf("%sT00:00:00Z", [d])) / 86400000000000
year(d) := to_number(substring(d, 0, 4))
date_in(y, md) := sprintf("%04d-%s", [y, md])

between(x, a, b) if {
	x >= a
	x < b
}

minimum_area := input.land.arable_area_ha >= 1.5 if is_number(input.land.arable_area_ha)

first_year_size_ok if input.immergruen.first_opul_year < input.farm.year
first_year_size_ok if input.immergruen.protected_area_at_ha >= 0.5
first_year_size_ok if input.immergruen.qualifying_area_at_ha >= 1.5

entry_timely if {
	y := input.immergruen.entry_year
	y >= 2023
	y <= 2027
	day(input.immergruen.application_date) <= day(date_in(y - 1, "12-31"))
}

incompatible_farm if {
	"6" in input.immergruen.measures
	"7" in input.immergruen.measures
}

start(c) := c.harvest_date if {
	effective_kind(c) == "catch"
	c.undersown == true
}

else := c.start if effective_kind(c) != "catch"

else := c.start if c.undersown == false

# end is the first day outside the standing crop. On hemp and staggered harvests
# derive it from the events instead of the last use or later straw removal.
finish(c) := max(c.partial_harvest_dates) if count(c.partial_harvest_dates) > 0

else := c.seed_harvest_date if c.hemp == true

else := min(ends) if {
	effective_kind(c) == "catch"
	ends := {d | some e in c.events; d := end_event(c, e)}
	count(ends) > 0
}

else := c.end

end_event(c, e) := e.date if removal(c, e) in {"Bodenbearbeitung", "Zerkleinerung", "direkter Übergang"}

else := e.date if {
	e.type == "Mahd mit Abtransport"
	e.low_cut == true
	e.regrowth == false
}

else := min(dates) if {
	removal(c, e) == "abfrostender Bestand"
	dates := {op.date | some op in c.events; op.date >= e.date; bare_trigger(op)} | {d | d := c.next_sowing; is_string(d); d >= e.date}
	count(dates) > 0
}

bare_trigger(e) if e.type in {"Pflanzenschutz", "Mineralstickstoff", "Bodenbearbeitung"}
bare_trigger(e) if e.type in t.implements

pre_entry(c) if year(start(c)) == input.immergruen.first_measure_year - 1
deadline_ok(c) if pre_entry(c)
deadline_ok(c) if start(c) <= date_in(year(start(c)), "10-15")

mixture_year(c) := input.immergruen.first_measure_year if pre_entry(c)

else := year(start(c))

late(c) if start(c) > date_in(year(start(c)), "09-20")

mix_ok(c) if {
	not late(c)
	count({p.species | some p in c.mix}) >= 3
	count({p.family | some p in c.mix}) >= 2
}

mix_ok(c) if {
	late(c)
	count(c.mix) > 0
	every p in c.mix { p.winter_hardy == true }
}

mix_ok(c) if {
	late(c)
	mixture_year(c) >= 2025
	count(c.mix) > 0
	every p in c.mix { is_boolean(p.winter_hardy); is_number(p.percent); p.percent > 0}
	sum([p.percent | some p in c.mix]) == 100
	sum([p.percent | some p in c.mix; p.winter_hardy == false]) < 50
}

seed_evidence_ok(c) if c.partners_visible == true
seed_evidence_ok(c) if c.seed_evidence in {"Rechnung", "Etikett"}

stand_ok(c) if {
	c.proper_establishment == true
	c.full_cover == true
}

stand_ok(c) if {
	year(start(c)) == 2026
	c.proper_establishment == true
	c.drought_patchy == true
}

crop_share_ok(c) if {
	not exclusively_excluded_cereal(c)
	c.cereal_maize_percent >= 0
	c.cereal_maize_percent <= 50
}

crop_share_ok(c) if {
	not exclusively_excluded_cereal(c)
	year(start(c)) == 2026
	c.proper_establishment == true
	c.drought_volunteer_excess == true
	c.cereal_maize_percent > 50
	c.cereal_maize_percent <= 100
}

exclusively_excluded_cereal(c) if {
	count(c.mix) > 0
	every p in c.mix { excluded_cereal_species(p) }
}

excluded_cereal_species(p) if p.species == "Mais"

excluded_cereal_species(p) if {
	"Getreide" in crop_groups(p.species, 2023)
	not approved_green_rye(p)
}

approved_green_rye(p) if {
	p.species == "Grünschnittroggen"
	p.approved_green_rye == true
}

termination_ok(c) if {
	day(finish(c)) - day(start(c)) >= 42
	not late(c)
}

termination_ok(c) if {
	late(c)
	day(finish(c)) - day(start(c)) >= 42
	finish(c) >= date_in(year(start(c)) + 1, "02-15")
}

renewal_ok(a, b) if {
	effective_kind(a) == "catch"
	effective_kind(b) == "catch"
	termination_ok(a)
	termination_ok(b)
	finish(a) == start(b)
	start(b) <= date_in(year(start(b)), "10-15")
}

main_crop(c) if {
	effective_kind(c) == "main"
	c.declared == true
}

catch_valid(c) if {
	effective_kind(c) == "catch"
	c.sown == true
	c.declared == false
	c.threshed == false
	stand_ok(c)
	crop_share_ok(c)
	mix_ok(c)
	deadline_ok(c)
	termination_ok(c)
}

# A catch-crop sequence is bounded by two main crops. Each replacement in
# the intervening run must qualify, and successive catch crops must touch.
qualified(p, i) if main_crop(p.ig.periods[i])

qualified(p, i) if {
	periods := p.ig.periods
	catch_valid(periods[i])
	some l, previous in periods
	l < i
	main_crop(previous)
	some r, following in periods
	r > i
	main_crop(following)
	following.sown == true
	every j in numbers.range(l + 1, r - 1) { catch_valid(periods[j]) }
	not bad_renewal(periods, l, r)
}

bad_renewal(periods, l, r) if {
	some j, c in periods
	j > l
	j + 1 < r
	not renewal_ok(c, periods[j + 1])
}

gap_ok(a, b) if {
	some row in t.gaps
	row.previous == effective_kind(a)
	row.following == effective_kind(b)
	n := day(start(b)) - day(finish(a))
	n >= 0
	n <= row.days
}

gap_ok(a, b) if {
	effective_kind(a) == "main"
	b.kind in {"main", "catch"}
	year(finish(a)) == 2026
	year(start(b)) == 2026
	start(b) >= finish(a)
	b.delay.foreseeable_management == true
	b.delay.reason in {"bodenspezifisch", "phytosanitär", "pflanzenbaulich"}
	b.delay.necessity_evidenced == true
	start(b) == b.delay.earliest_feasible_date
}

green(p, d) if {
	some i, c in p.ig.periods
	between(d, start(c), finish(c))
	qualified(p, i)
}

green(p, d) if {
	some c in p.ig.periods
	c.kind == "fallow"
	between(d, start(c), finish(c))
}

green(p, d) if {
	some c in p.ig.periods
	c.kind == "nature_regrowth"
	p.constraints.is_contract_nature_area == true
	c.project_requires_regrowth == true
	between(d, start(c), finish(c))
	regrowth_credit(c, d)
}

regrowth_credit(c, d) if {
	is_string(c.full_regrowth_date)
	d >= c.full_regrowth_date
}

regrowth_credit(c, _) if {
	n := day(c.full_regrowth_date) - day(start(c))
	n >= 0
	n <= 50
}

green(p, d) if {
	periods := p.ig.periods
	some i, a in periods
	b := periods[i + 1]
	between(d, finish(a), start(b))
	qualified(p, i)
	qualified(p, i + 1)
	gap_ok(a, b)
}

active(p, d) if {
	p.land_use == "arable"
	p.ig.country == "AT"
	between(d, p.ig.control_from, p.ig.control_until)
}

# Test whether the late addition(s) actually caused the threshold crossing.
late_addition(p, d) if {
	p.ig.bare_on_acquisition == true
	a := p.ig.control_from
	a > date_in(year(a), "10-15")
	year(d) == year(a)
	not green(p, d)
}

late_addition(p, d) if {
	p.ig.bare_on_acquisition == true
	a := p.ig.control_from
	a > date_in(year(a), "10-15")
	year(d) == year(a) + 1
	p.ig.prior_acquisition_exception == true
	awaiting_cultivation(p.ig, d)
	not green(p, d)
}

awaiting_cultivation(g, _) if g.first_following_cultivation == null

awaiting_cultivation(g, d) if {
	is_string(g.first_following_cultivation)
	d < g.first_following_cultivation
}

area_on(d) := sum([p.area_ha | some p in input.land.parcels; active(p, d)])
bare_on(d) := sum([p.area_ha | some p in input.land.parcels; active(p, d); not green(p, d)])
added_on(d) := sum([p.area_ha | some p in input.land.parcels; active(p, d); late_addition(p, d)])

excluded_acquisition(p, d) if {
	late_addition(p, d)
	total := area_on(d)
	bare := bare_on(d)
	added := added_on(d)
	100 * bare > 15 * total
	100 * (bare - added) <= 15 * (total - added)
}

# Evaluate all change dates plus 1 January. Areas and statuses are constant
# between adjacent boundaries. Harvest and destruction days belong to gaps.
boundaries contains date_in(input.farm.year, "01-01")

boundaries contains d if {
	some p in input.land.parcels
	some d in [p.ig.control_from, p.ig.control_until]
	year(d) == input.farm.year
}

boundaries contains d if {
	some p in input.land.parcels
	some c in p.ig.periods
	some d in [start(c), finish(c)]
	year(d) == input.farm.year
}

boundaries contains d if {
	some p in input.land.parcels
	some c in p.ig.periods
	d := c.full_regrowth_date
	year(d) == input.farm.year
}

boundaries contains d if {
	some p in input.land.parcels
	d := p.ig.first_following_cultivation
	year(d) == input.farm.year
}

area_result(d) := {"date": d, "assessed_ha": total, "bare_ha": bare, "excluded_ha": exc, "meets_85_percent": (100 * bare) <= (15 * total)} if {
	valid_timeline
	exc := sum([p.area_ha | some p in input.land.parcels; active(p, d); excluded_acquisition(p, d)])
	total := area_on(d) - exc
	total > 0
	bare := bare_on(d) - exc
}

cover_failures contains r if {
	some d in boundaries
	r := area_result(d)
	r.meets_85_percent == false
}

annual_cover_ok := count(cover_failures) == 0 if {
	valid_timeline
	count(boundaries) > 0
	every d in boundaries { is_object(area_result(d)) }
}

care_ok(c, e) if {
	e.type in {"Häckseln", "Mulchen", "Pflegemahd"}
	e.low_cut == false
	e.regrowth == true
	e.erosion_protection == true
	e.nitrogen_retention == true
	e.cover_retained_or_recovers == true
	care_timing_ok(c, e)
}

care_ok(c, e) if {
	e.type == "Walzen"
	e.cover_retained == true
	e.soil_disturbed == false
	care_timing_ok(c, e)
}

care_ok(c, e) if {
	e.type == "Saatbett anwalzen"
	e.immediate_reconsolidation == true
	e.date == start(c)
}

care_timing_ok(c, _) if c.overwinters == false

care_timing_ok(c, e) if {
	c.overwinters == true
	e.date > date_in(year(start(c)), "10-31")
}

care_timing_ok(_, e) if {
	e.type == "Häckseln"
	e.low_cut == false
	e.weed in t.weeds
	e.containment_needed == true
	e.proof_retained == true
}

removal(c, e) := "Bodenbearbeitung" if {
	e.type in t.implements
	e.after_cover_period == true
}

else := "Zerkleinerung" if {
	e.type in {"bodennah häckseln", "anders zerkleinern"}
	e.fully_frozen == true
}

else := "direkter Übergang" if {
	e.type in t.direct_sowing
	e.after_cover_period == true
}

else := "abfrostender Bestand" if {
	count(c.mix) > 0
	every p in c.mix { p.winter_hardy == false }
	frozen_or_rolled(e)
}

else := "keine Beseitigung" if e.type == "Striegeln"

else := "keine Beseitigung" if {
	e.type == "Einkürzen"
	e.regrowth == true
}

frozen_or_rolled(e) if {
	e.type == "niedergebrochen"
	e.fully_frozen == true
}

frozen_or_rolled(e) if e.type == "niedergewalzt"

operation_violations contains {"parcel": p.parcel_id, "date": e.date, "rule": "IG-stickstoff"} if {
	some p in input.land.parcels
	some c in p.ig.periods
	effective_kind(c) == "catch"
	some e in c.events
	e.type == "Mineralstickstoff"
	e.date >= start(c)
	e.date <= c.napv_ban_end
}

operation_violations contains {"parcel": p.parcel_id, "date": e.date, "rule": "IG-psm"} if {
	some p in input.land.parcels
	some c in p.ig.periods
	effective_kind(c) == "catch"
	some e in c.events
	e.type == "Pflanzenschutz"
	e.date >= start(c)
	psm_barred(c, e)
}

psm_barred(c, e) if {
	c.mechanically_removed == true
	e.date < finish(c)
}

psm_barred(c, e) if {
	c.mechanically_removed == true
	e.date == finish(c)
	e.after_removal == false
}

psm_barred(c, e) if {
	c.mechanically_removed == false
	e.date < c.next_sowing
}

psm_barred(c, e) if {
	c.mechanically_removed == false
	e.date == c.next_sowing
	e.after_sowing == false
}

operation_violations contains {"parcel": p.parcel_id, "date": e.date, "rule": "IG-boden"} if {
	some p in input.land.parcels
	some c in p.ig.periods
	effective_kind(c) == "catch"
	some e in c.events
	between(e.date, start(c), finish(c))
	damaging(e)
}

damaging(e) if e.type == "Messerwalze"

damaging(e) if {
	e.type == "Bodenbearbeitung"
	e.damages_cover == true
}

damaging(e) if {
	e.type in {"Strip-Till-Vorbereitung", "Tiefenlockerung", "Untergrundlockerung"}
	e.cover_retained == false
}

damaging(e) if {
	e.type == "Strip-Till-Vorbereitung"
	e.full_width == true
}

records_ok(p) if {
	input.documentation.field_records_complete == true
	p.ig.record_from <= date_in(input.farm.year, "01-01")
	p.ig.record_until >= date_in(input.farm.year, "12-31")
	every c in p.ig.periods { recorded_period(p, c) }
}

recorded_period(p, c) if {
	c.kind in {"catch", "main"}
	every pair in expected_events(c) { recorded_if_in_year(p, pair) }
}

recorded_period(_, c) if c.kind in {"fallow", "bare", "GI", "other_arable", "nature_regrowth", "self"}
expected_events(c) := [[t.record_events[0], finish(c)], [t.record_events[3], start(c)]] if effective_kind(c) == "main"

else := [[t.record_events[1], start(c)], [t.record_events[2], finish(c)]] if effective_kind(c) == "catch"

recorded_if_in_year(_, pair) if year(pair[1]) != input.farm.year

recorded_if_in_year(p, pair) if {
	some e in p.ig.records
	[e.type, e.date] == pair
}

crop_groups(name, y) := {row.group | some row in t.crops; crop_name_matches(row, name); y >= row.from_year}

open_end(y, last) if {
	last == null
	is_number(y)
}

open_end(y, last) if {
	is_number(last)
	y <= last
}

maintenance_exempt(p) if {
	some row in t.exemptions
	input.farm.year >= row.first
	some u in p.ig.scheme_uses
	u.measure == row.measure
	u.use == row.use
	open_end(input.farm.year, row.last)
}

harvest_waiver(p) if {
	input.farm.year == 2026
	p.land_use == "arable"
	p.ig.country == "AT"
	p.ig.late_summer_autumn_crop == true
	p.ig.drought_no_harvestable_stand == true
	some row in t.harvest_districts
	row.state == p.ig.state
	district_matches(row, p.ig)
}

district_matches(row, _) if row.district == "*"
district_matches(row, g) if row.district == g.district

harvest_ok(p) if {
	p.ig.harvested_and_removed_percent >= 85
	p.ig.harvested_and_removed_percent <= 100
}

harvest_ok(p) if harvest_waiver(p)
harvest_ok(p) if maintenance_exempt(p)

payment_exclusions(p) := {id | some id in {"IG-k20-kombination", "IG-npf", "IG-op", "IG-nationalpark", "IG-keine-praemie", "IG-versuch"}; excluded_for(p, id)}

excluded_for(p, "IG-npf") if {
	input.farm.year == 2024
	p.ig.npf in t.npf
}

excluded_for(p, "IG-op") if {
	some code in p.ig.codes
	code == "OP"
}

excluded_for(p, "IG-op") if "7" in p.ig.excluded_measures
excluded_for(p, "IG-nationalpark") if p.ig.national_park in {"Neusiedlersee", "Donau-Auen"}
excluded_for(p, "IG-nationalpark") if p.ig.park_restrictions == true
excluded_for(p, "IG-keine-praemie") if p.ig.excluded_use == true
excluded_for(p, "IG-versuch") if "VF" in p.ig.codes

excluded_for(p, "IG-k20-kombination") if {
	input.farm.year <= 2024
	some u in p.ig.scheme_uses
	u.measure == "K20"
}

takeover_limits if {
	x := input.immergruen.takeover
	deadline := takeover_deadline(input.farm.year)
	year(x.date) == input.farm.year
	x.date <= deadline
	x.previous_area_ha > 0
	x.expansion_ha >= 0
	2 * x.expansion_ha <= x.previous_area_ha
}

takeover_deadline(y) := date_in(y, "04-17") if y in {2023, 2028}

else := date_in(y, "04-15")

# Lookup returns explicit blank cells as well as marked ones. Special facts
# determine the effect of conditional footnotes for this payment unit.
combination(r, c, options) := result if {
	some row in t.combinations
	row.row == r
	row.column == c
	result := combination_effect(row, options)
}

combination_effect(row, o) := "keine Kombination" if blocked_pair(row, o)

else := "nur Landschaftselemente" if limited_to_lse(row, o)

else := "mit Prämienabschlag" if discounted(row, o)

else := "kombinierbar"

blocked_pair(row, _) if row.mark == ""
blocked_pair(_, o) if "Topf-/Substratkultur" in o

blocked_pair(row, o) if {
	{row.row, row.column} == {"8", "16"}
	"Humusaufbau Wien" in o
}

blocked_pair(row, o) if {
	{row.row, row.column} == {"1B", "16"}
	"PSM-Verzicht" in o
}

blocked_pair(row, o) if {
	special_strip(row, o)
	count({row.row, row.column} & {"1A", "1B"}) == 0
}

special_strip(row, o) if {
	"BAW" in o
	"8" in {row.row, row.column}
}

special_strip(row, o) if {
	"AG" in o
	"16" in {row.row, row.column}
}

limited_to_lse(row, _) if 1 in row.footnotes

limited_to_lse(row, o) if {
	special_strip(row, o)
	count({row.row, row.column} & {"1A", "1B"}) > 0
}

discounted(row, _) if row.mark == "a"

discounted(row, o) if {
	3 in row.footnotes
	"Einsatz von Organismen" in o
}

groundwater_kg(code) if {
	some row in t.groundwater_cadastre
	row.kg == code
}

sanction_stages := [r | some r in t.sanctions; input.farm.year >= r.first; open_end(input.farm.year, r.last)]
cap_rows := [r | some r in t.caps; input.farm.year >= r.first; open_end(input.farm.year, r.last)]

contract_table(y) := r if {
	some r in t.contracts
	r.start == y
}

upgrade_targets(measure, y) := {r.following | some r in t.upgrades; r.previous == measure; open_end(y, r.last_previous_year)}

band_area(area, row) := max([0, area - row.lower]) if row.upper == null

else := max([0, min([area, row.upper]) - row.lower])

modulation_factor := sum([weighted | some row in t.modulation; weighted := band_area(area, row) * row.factor]) / area if {
	area := input.immergruen.home_area_ha
	area > 0
}

premium_band := {"min_eur_ha": r.min_eur_ha, "max_eur_ha": r.max_eur_ha, "min_modulated_eur": (ha * r.min_eur_ha) * modulation_factor, "max_modulated_eur": (ha * r.max_eur_ha) * modulation_factor} if {
	some r in t.premium
	input.farm.year >= r.from_year
	ha := payable_ha
	ha >= 0
}

reduction_order := t.reduction_order

applicant_ok if {
	a := input.immergruen.applicant
	a.active_farmer == true
	a.agricultural_activity == true
	a.own_name == true
	a.own_account == true
	a.disposal_right == true
	legal_form_ok(a)
}

legal_form_ok(a) if a.legal_form in {"natürliche Person", "juristische Person", "Personenvereinigung"}

legal_form_ok(a) if {
	a.legal_form == "Personengesellschaft"
	a.registered == true
}

legal_form_ok(a) if a.public_body == true

withdrawn_this_year if year(input.immergruen.contract.withdrawal_date) == input.farm.year
requires_fresh_application if input.immergruen.contract.exclusion == true
requires_fresh_application if input.immergruen.contract.last_mfa_year < input.farm.year - 1
requires_fresh_application if year(input.immergruen.contract.withdrawal_date) < input.farm.year

full_payment_conditionality if {
	input.immergruen.conditionality.requirements_met == true
	input.immergruen.conditionality.social_requirements_met == true
}

sanction_outcome := {"action": "Ausschluss und Rückforderung"} if input.immergruen.sanction.full_cuts_in_contract >= 2

else := {"action": "Einbehalt", "percent": 1} if {
	input.immergruen.sanction.assessed_stage == "niedrigste"
	input.farm.year >= 2027
}

else := {"action": "Verwarnung", "percent": 0} if {
	input.immergruen.sanction.assessed_stage == "niedrigste"
	input.farm.year < 2027
}

# Identifiable violations, not a presumption about an event for which
# facts are missing. An event can lead to more than one finding.
operation_violations contains {"parcel": p.parcel_id, "date": e.date, "rule": "IG-nutzung"} if {
	some p in input.land.parcels
	some c in p.ig.periods
	effective_kind(c) == "catch"
	some e in c.events
	e.type in {"Mahd mit Abtransport", "Beweidung"}
	between(e.date, start(c), finish(c))
	use_failed(e)
}

use_failed(e) if e.regrowth == false
use_failed(e) if e.cover_retained == false

operation_violations contains {"parcel": p.parcel_id, "date": e.date, "rule": "IG-oktoberpflege"} if {
	some p in input.land.parcels
	some c in p.ig.periods
	effective_kind(c) == "catch"
	c.overwinters == true
	some e in c.events
	between(e.date, start(c), finish(c))
	e.type in {"Häckseln", "Mulchen", "Pflegemahd", "Walzen"}
	e.date <= date_in(year(start(c)), "10-31")
	not care_timing_ok(c, e)
}

# Applications with insufficient parcel history do not yield an annual approval.
valid_timeline if {
	input.immergruen.timeline_complete == true
	is_array(input.land.parcels)
	every p in input.land.parcels { parcel_timeline_ok(p) }
}

parcel_timeline_ok(p) if p.land_use != "arable"

parcel_timeline_ok(p) if {
	is_string(p.ig.country)
	p.ig.country != "AT"
}

parcel_timeline_ok(p) if {
	p.ig.country == "AT"
	is_number(p.area_ha)
	p.area_ha > 0
	day(p.ig.control_until) > day(p.ig.control_from)
	is_array(p.ig.periods)
	every c in p.ig.periods {
		day(finish(c)) > day(start(c))
		c.kind in {"main", "catch", "fallow", "bare", "self", "GI", "other_arable", "nature_regrowth"}
	}
	not overlapping(p.ig.periods)
}

overlapping(periods) if {
	some i, a in periods
	b := periods[i + 1]
	start(b) < finish(a)
}

public_body_measures(y) := {r.measure | some r in t.public_body; y >= r.first; open_end(y, r.last)}

livestock_factor(group, category) := r if {
	some r in t.livestock
	r.group == group
	r.category == category
}

div_variant(code) := r.rule if {
	some r in t.div
	r.code == code
}

contract_family(name) := r.family if {
	some r in t.contract_families
	r.measure == name
}

annual_units(name) if name in t.annual_units
exceptional_takeovers(name) if name in t.exceptional_takeovers
restricted_growth(name) if name in t.restricted_growth
multiannual_loss_tolerance(prior) := max([0.5, min([5, prior * 0.05])]) if prior >= 0

# A split payment unit has its own parcel_id. Include only declared domestic
# arable hectares whose payment facts have been assessed.
assessed_claim_area := sum([p.ig.claimed_ha |
	some p in input.land.parcels
	p.land_use == "arable"
	p.ig.country == "AT"
	count(payment_exclusions(p)) == 0
]) if {
	input.immergruen.payment_units_complete == true
	is_array(input.land.parcels)
	every p in input.land.parcels { claim_data_ok(p) }
}

claim_data_ok(p) if p.land_use != "arable"

claim_data_ok(p) if {
	is_string(p.ig.country)
	p.ig.country != "AT"
}

claim_data_ok(p) if {
	p.ig.country == "AT"
	is_number(p.ig.claimed_ha)
	p.ig.claimed_ha >= 0
	p.ig.claimed_ha <= p.area_ha
}

payable_ha := assessed_claim_area if input.immergruen.payment_units_complete == true

else := input.immergruen.payable_area_ha if object.get(input.immergruen, "payment_units_complete", false) == false

public_contract_barriers contains "IG-mindestacker" if minimum_area == false
public_contract_barriers contains "IG-ausschluss-6" if incompatible_farm
public_contract_barriers contains "IG-wirkung-abmeldung" if withdrawn_this_year

# Return the scope of each independent decision. An omitted value has not
# been established from the supplied input.
assessment["access_barriers"] := public_contract_barriers
assessment["annual_minimum_area_ok"] := minimum_area
assessment["year_round_cover_ok"] := annual_cover_ok
assessment["cover_failures"] := cover_failures if valid_timeline
assessment["operation_findings"] := operation_violations if is_array(input.land.parcels)
assessment["conditional_premium_band"] := premium_band
assessment["parcel_payment_exclusions"] := {p.parcel_id: payment_exclusions(p) | some p in input.land.parcels; p.land_use == "arable"} if is_array(input.land.parcels)
assessment["parcel_combinations"] := {p.parcel_id: lookup | some p in input.land.parcels; is_array(p.ig.combined_measures); lookup := {m: combination("7", m, p.ig.combination_options) | some m in p.ig.combined_measures}}

# Contract gates are distinct from management compliance and payment.
contract_status := "erloschen: jährliche Mindestackerfläche unterschritten" if minimum_area == false

else := "im Förderjahr abgemeldet" if withdrawn_this_year

else := "betriebsweit ausgeschlossene Kombination" if incompatible_farm

else := "neuer Maßnahmenantrag erforderlich" if {
	requires_fresh_application
	input.immergruen.contract.new_application_submitted == false
}

else := "Vorjahresvertrag mit Jahres-MFA fortgeführt" if {
	minimum_area
	input.immergruen.contract.prior_contract == true
	input.immergruen.contract.last_mfa_year == input.farm.year
	input.immergruen.contract.withdrawal_date == null
	input.immergruen.contract.exclusion == false
	"7" in input.immergruen.measures
	not incompatible_farm
}

assessment["contract_status"] := contract_status

# Only a known fact that conflicts with the obligation produces a finding.
parcel_findings contains {"parcel": p.parcel_id, "rule": "IG-nachweis"} if {
	some p in input.land.parcels
	some c in p.ig.periods
	effective_kind(c) == "catch"
	not late(c)
	c.partners_visible == false
	not seed_evidence_ok(c)
}

parcel_findings contains {"parcel": p.parcel_id, "rule": "IG-drusch"} if {
	some p in input.land.parcels
	some c in p.ig.periods
	c.kind == "catch"
	c.threshed == true
	c.declared == false
}

assessment["parcel_findings"] := parcel_findings if is_array(input.land.parcels)

combination_details(r, c, options) := {"row": r, "column": c, "status": combination(r, c, options), "source_mark": cell.mark, "footnotes": notes} if {
	some cell in t.combinations
	cell.row == r
	cell.column == c
	cell_notes := {n | some n in cell.footnotes}
	label_notes := {n | some label in t.combination_labels; label.measure in {r, c}; some n in label.notes}
	numbers_used := cell_notes | label_notes
	notes := [note | some note in t.combination_notes; note.number in numbers_used]
}

# Identify the failed stand condition even where the rest of the holding
# keeps the farm above 85 percent. A finding does not select a sanction.
catch_condition(c, "IG-anlage") if not deadline_ok(c)
catch_condition(c, "IG-zwischenfrucht") if c.sown == false
catch_condition(c, "IG-saat") if not stand_ok(c)
catch_condition(c, "IG-getreide") if not crop_share_ok(c)

catch_condition(c, "IG-mischung-frueh") if {
	not late(c)
	not mix_ok(c)
}

catch_condition(c, "IG-mischung-spaet") if {
	late(c)
	not mix_ok(c)
}

catch_condition(c, "IG-februar") if {
	late(c)
	finish(c) < date_in(year(start(c)) + 1, "02-15")
}

catch_condition(c, "IG-dauer") if day(finish(c)) - day(start(c)) < 42

parcel_findings contains {"parcel": p.parcel_id, "start": start(c), "rule": id} if {
	valid_timeline
	some p in input.land.parcels
	p.land_use == "arable"
	p.ig.country == "AT"
	some c in p.ig.periods
	effective_kind(c) == "catch"
	start(c) <= date_in(input.farm.year, "12-31")
	finish(c) > date_in(input.farm.year, "01-01")
	some id in {"IG-anlage", "IG-zwischenfrucht", "IG-saat", "IG-getreide", "IG-mischung-frueh", "IG-mischung-spaet", "IG-februar", "IG-dauer"}
	catch_condition(c, id)
}

# For measure 16 this only decides the area and combination prerequisites.
groundwater_entry_area := sum([p.area_ha |
	some p in input.land.parcels
	p.land_use == "arable"
	p.ig.country == "AT"
	p.ig.in_current_groundwater_map == true
	groundwater_kg(p.ig.kg)
]) if {
	input.immergruen.first_groundwater_year == input.farm.year
	input.immergruen.groundwater_areas_complete == true
}

groundwater_entry_ok if {
	groundwater_entry_area >= 2
	count({m | some m in input.immergruen.measures} & {"6", "7"}) > 0
}

groundwater_autumn_required(p) if {
	"16" in input.immergruen.measures
	p.ig.in_current_groundwater_map == true
	p.ig.previous_fodder_broken == true
	p.ig.break_date < date_in(input.farm.year, "11-15")
}

groundwater_autumn_required(p) if {
	"16" in input.immergruen.measures
	p.ig.in_current_groundwater_map == true
	is_string(p.ig.previous_harvest)
	year(p.ig.previous_harvest) == input.farm.year
	p.ig.previous_harvest <= date_in(input.farm.year, "09-30")
	groundwater_trigger(p)
}

groundwater_trigger(p) if p.ig.n_surplus_kg_ha > 30

groundwater_trigger(p) if {
	p.area_ha > 0.3
	"Feldgemüse" in crop_groups(p.ig.previous_crop, input.farm.year)
}

groundwater_trigger(p) if {
	p.area_ha > 0.3
	p.ig.previous_crop == "Kürbis"
}

groundwater_trigger(p) if {
	p.ig.previous_arable_fallow_broken == true
	p.ig.break_date < date_in(input.farm.year, "11-15")
}

crop_name_matches(row, name) if row.name == name
crop_name_matches(row, name) if name in row.aliases

groundwater_autumn_required(p) if {
	"16" in input.immergruen.measures
	p.ig.in_current_groundwater_map == true
	p.ig.previous_harvest == null
	p.ig.previous_arable_fallow_broken == true
	year(p.ig.break_date) == input.farm.year
	p.ig.break_date < date_in(input.farm.year, "11-15")
}

erosion_method_ok(m) if {
	m.method == "Mulchsaat"
	m.following_crop_erosion_prone == true
	m.shallow_noninverting == true
	m.surface_mulch == true
	m.deep_mixing == false
	days := day(m.sowing) - day(m.first_tillage)
	days >= 0
	days <= 28
}

erosion_method_ok(m) if {
	m.method == "Direktsaat"
	m.following_crop_erosion_prone == true
	m.slit_drilling == true
	m.full_width == false
}

erosion_method_ok(m) if {
	m.method == "Strip-Till"
	m.following_crop_erosion_prone == true
	m.strip_only == true
	m.residue_between_strips == true
}
