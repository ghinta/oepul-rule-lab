package oepul.o6_16

import data.gwa_tables as t
import rego.v1

year := input.farm.year
measure_farm := input.farm.gwa

iso(year_number, month_day) := sprintf("%04d-%s", [year_number, month_day])
date_ns(d) := time.parse_rfc3339_ns(concat("", [d, "T00:00:00Z"]))

within_year(d, y) if {
	date_ns(d)
	startswith(d, sprintf("%04d-", [y]))
}

valid_year(y) if y in numbers.range(2023, 2028)

contract_years(start) := t.contract[sprintf("%d", [start])]

entry_timely(component, start, submitted) if {
	valid_year(start)
	latest := {"basis": 2025, "wien": 2025, "schwein": 2028}[component]
	start <= latest
	date_ns(submitted) <= date_ns(iso(start - 1, "12-31"))
}

combination_met := count({"6", "7"} & {m | some m in measure_farm.measures}) == 1 if is_array(measure_farm.measures)
pig_combination_met := not_member("9-Schweinefütterung", measure_farm.measures)

not_member(x, xs) if {
	is_array(xs)
	not x in xs
}

else := false if x in xs

# KG-Nummer in der Schreibweise des MFA oder fünfstellig mit führender Null.
kg_number(p) := sprintf("%d", [to_number(p.gwa.kg_number)]) if {
	regex.match("^[0-9]{1,5}$", p.gwa.kg_number)
}

zone(p, y) if {
	p.land_use == "arable"
	valid_year(y)
	n := kg_number(p)
	some row in t.cadastre
	row.kg_number == n
	y >= row.from_year
}

state(p, y) := s if {
	zone(p, y)
	some r in t.cadastre
	r.kg_number == kg_number(p)
	s := r.state
}

complete_locations if {
	is_array(input.land.parcels)
	every p in input.land.parcels {
		is_string(p.land_use)
		location_known(p)
	}
}

location_known(p) if p.land_use != "arable"

location_known(p) if {
	p.land_use == "arable"
	kg_number(p)
	is_number(p.area_ha)
	p.area_ha >= 0
}

zone_area := sum([p.area_ha | some p in input.land.parcels; zone(p, year)]) if {
	complete_locations
	valid_year(year)
}

area_requirement := zone_area >= 2 if year == measure_farm.start_year

else if {
	valid_year(year)
	year > measure_farm.start_year
	contract_years(measure_farm.start_year)
}

option_parcel_count(code) := count([p | some p in input.land.parcels; zone(p, year); code in p.gwa.codes]) if {
	code in {"AG", "CUL"}
	complete_locations
	every p in input.land.parcels { is_array(p.gwa.codes) }
}

matrix_cell(a, b) := t.combinations[a][b]

cover_variant(n, y) := row if {
	some row in t.variants
	row.variant == n
	y >= row.from_year
	y <= row.to_year
}

crop_classes(name, y) := {class |
	some class, values in {"Getreide": t.crop_cereals, "kein Getreide": t.crop_not_cereals, "Ackerfutter": t.crop_forage, "Feldgemüse": t.crop_vegetables, "Obst": fruit_names(y)}
	name in values
}

fruit_names(y) := array.concat(t.crop_fruit, t.crop_fruit_2025) if y >= 2025

else := t.crop_fruit

planning_dates(y) := {"plan_due": iso(y, "02-28"), "balance_due": iso(y + 1, "01-31")}

records_required(p) if {
	zone(p, year)
	p.gwa.crop_total_ha > 0.30
}

record_timely(event_date, recorded_date) if {
	elapsed := date_ns(recorded_date) - date_ns(event_date)
	elapsed >= 0
	elapsed <= 14 * 86400000000000
}

balance_region(p) := "Wien" if state(p, year) == "Wien"

else := "übriges Gebiet" if state(p, year) in {"Ktn", "Oö", "Stmk"}

else := p.gwa.balance_region if {
	state(p, year) == "Bgld"
	p.gwa.balance_region in {"Nordburgenland", "Mittelburgenland", "übriges Gebiet"}
}

else := p.gwa.balance_region if {
	state(p, year) == "Nö"
	p.gwa.balance_region in {"Östliches Niederösterreich einschließlich Tullnerfeld", "übriges Gebiet"}
}

regional_percent(region) := {"Nordburgenland": 80, "Mittelburgenland": 80, "Östliches Niederösterreich einschließlich Tullnerfeld": 80, "Wien": 80, "übriges Gebiet": 60}[region]

carryover(y, balance, region) := amount if {
	valid_year(y)
	is_number(balance)
	percent := regional_percent(region)
	basis := chargeable(y, balance)
	amount := (basis * percent) / 100
}

chargeable(y, b) := 0 if {
	y <= 2024
	b <= 10
}

else := b if y <= 2024

else := 0 if b <= 20

else := min([100, b])

used_cover_balance(fertilizer, credited, uptake) := (fertilizer + credited) - uptake
unused_cover_limit(next_demand, credit) := max([0, next_demand - credit])
vegetable_deduction(nmin, credit) := max([nmin, credit])

forage_break(p) if {
	p.gwa.previous_crop in t.crop_forage
	before_november_break(p)
}

before_november_break(p) if {
	within_year(p.gwa.break_date, year)
	p.gwa.break_date < iso(year, "11-15")
}

autumn_trigger(p) if p.gwa.previous_balance > 30

autumn_trigger(p) if {
	p.area_ha > 0.3
	p.gwa.previous_crop in t.crop_vegetables
}

autumn_trigger(p) if {
	p.area_ha > 0.3
	p.gwa.previous_crop in {"Kürbis", "Ölkürbis"}
}

autumn_trigger(p) if {
	p.gwa.previous_crop in {"Ackerbrache", "Grünbrache"}
	before_november_break(p)
}

autumn_trigger(p) if forage_break(p)
early_or_unharvested(p) if p.gwa.previous_harvest == null

early_or_unharvested(p) if {
	within_year(p.gwa.previous_harvest, year)
	p.gwa.previous_harvest <= iso(year, "09-30")
}

autumn_required(p) if {
	zone(p, year)
	forage_break(p)
}

autumn_required(p) if {
	zone(p, year)
	autumn_trigger(p)
	early_or_unharvested(p)
}

samples_required(ha) := ceil(ha / 5) if ha >= 0
vienna_samples_required(ha) := 2 * ceil(ha / 5) if ha >= 0

sample_valid(s) if {
	s.farm_id == input.farm.farm_id
	s.arable_sample
	date_ns(s.taken) >= date_ns("2022-01-01")
	date_ns(s.sent) >= date_ns(s.taken)
	date_ns(s.sent) <= date_ns("2026-12-31")
	s.accredited
	s.method in {"Richtlinien für die sachgerechte Düngung", "EUF"}
	every a in {"P", "K", "pH", "Humus"} { a in s.parameters }
	some n in {"N nachlieferbar", "N mineralisch"}
	n in s.parameters
}

valid_attendee(c) if c.role == "förderwerbende Person"

valid_attendee(c) if {
	c.role == "maßgeblich tätig und eingebunden"
	c.business_need
}

person_retained(c) if c.left_on == null
person_retained(c) if date_ns(c.left_on) > date_ns("2026-12-31")

training_hours(purpose, person) := sum([c.hours |
	some c in measure_farm.courses
	c.purpose == purpose
	c.person_id == person
	c.accredited
	c.subject_eligible
	c.credited_once
	valid_attendee(c)
	person_retained(c)
	c.hours >= 0
	date_ns(c.date) >= date_ns("2022-01-01")
	date_ns(c.date) <= date_ns("2026-12-31")
]) if {
	is_array(measure_farm.courses)
	purpose in {"Basis", "Wien"}
	not unresolved_departure(purpose, person)
}

unresolved_departure(purpose, person) if {
	some c in measure_farm.courses
	c.purpose == purpose
	c.person_id == person
	c.left_on == "2026-12-31"
}

banned_substances(p) := {s | some s in p.gwa.applied_substances; banned_active(s, p)} if {
	zone(p, year)
	crop_key(p.crop.crop_name) in object.keys(t.psm_crops)
	is_array(p.gwa.applied_substances)
	substance_result_available(p)
}

substance_result_available(p) if bentazon_status_known(p)

substance_result_available(p) if {
	some s in p.gwa.applied_substances
	t.substances[s] == "immer"
}

bentazon_status_known(p) if not "Bentazon" in p.gwa.applied_substances
bentazon_status_known(p) if is_boolean(p.gwa.bentazon_readmitted)

banned_active(s, _) if t.substances[s] == "immer"

banned_active(s, p) if {
	t.substances[s] == "bei Wiederzulassung"
	p.gwa.bentazon_readmitted
}

psm_code(y, bio, chemical) := null if y >= 2026

else := t.psm_codes.chemisch_synthetisch if chemical == true

else := t.psm_codes.bio if {
	chemical == false
	bio == true
}

else := null if {
	bio == false
	chemical == false
}

maize(c) if c in {"Mais", "Saatmaisvermehrung", "Zuckermais", "Körnermais", "Silomais"}
crop_key(c) := "Mais" if c in {"Körnermais", "Silomais"}

else := c

closed_period(p, d) if {
	state(p, year) == "Oö"
	not p.crop.crop_name in t.crop_forage
	is_string(p.crop.crop_name)
	date_ns(d)
	md := substring(d, 5, 5)
	in_winter(md, p.crop.crop_name)
}

in_winter(md, _) if md >= "10-15"
in_winter(md, _) if md <= "02-15"

in_winter(md, c) if {
	maize(c)
	md <= "03-21"
}

split_required(p, n_kg_ha, delayed) if {
	state(p, year) == "Oö"
	n_kg_ha > 80
	delayed == false
}

variant3_prohibited(p) if {
	state(p, year) == "Oö"
	p.gwa.cover_variant == 3
}

ag_site(p) if {
	zone(p, year)
	p.gwa.soil_score <= 40
	is_number(p.gwa.soil_score)
	p.gwa.grassland_2020 == false
	p.gwa.gloez4 == false
	not historical_setaside(p)
	gloez8_known(p)
}

historical_setaside(p) if {
	year <= 2024
	p.gwa.gloez8
}

gloez8_known(_) if year >= 2025
gloez8_known(p) if is_boolean(p.gwa.gloez8)

ag_use(p) if {
	"AG" in p.gwa.codes
	p.crop.crop_name in object.keys(t.ag_uses)
}

ag_div_use(p) if {
	ag_use(p)
	"DIV" in p.gwa.codes
	t.ag_uses[p.crop.crop_name]
	some m in {"1A", "1B"}
	m in measure_farm.measures
}

ag_establishment(p) if p.gwa.retained_cover in {"Grünbrache", "Ackerfutter"}

ag_establishment(p) if {
	within_year(p.operations.cover_crop.sowing_date, p.gwa.ag_established_year)
	p.operations.cover_crop.sowing_date <= iso(p.gwa.ag_established_year, "05-15")
	p.gwa.winterhard_mix
	p.gwa.contains_legumes == false
}

ag_earliest_plough(established_year) := iso(established_year + 1, "09-15")

vienna_tillage_prohibited(p) if {
	state(p, year) == "Wien"
	measure_farm.vienna_option
	p.operations.tillage_type == "plough"
	is_string(p.gwa.previous_crop)
	not maize(p.gwa.previous_crop)
}

cultan_application(p) if {
	year >= 2025
	zone(p, year)
	"CUL" in p.gwa.codes
	is_array(p.gwa.cultan_events)
	count(p.gwa.cultan_events) > 0
	every e in p.gwa.cultan_events { cultan_record(e) }
}

cultan_record(e) if {
	e.spike_wheel_injection
	e.ammonium_depot
	within_year(e.date, year)
	e.amount > 0
	is_string(e.fertilizer)
	e.fertilizer != ""
	equipment_documented(e)
}

equipment_documented(e) if e.external_equipment == false

equipment_documented(e) if {
	e.external_equipment
	e.service_evidence
}

gve_factor(category) := t.gve[category].factor

pig_density_met := hundredths >= (100 * input.land.arable_area_ha) if {
	input.land.arable_area_ha > 0
	groups := input.livestock.species_groups
	is_array(groups)
	every g in groups { known_stock(g) }
	hundredths := sum([total | some g in groups; g.species == "pigs"; total := g.annual_mean_at * round(100 * gve_factor(g.category))])
}

known_stock(g) if g.species != "pigs"

known_stock(g) if {
	g.species == "pigs"
	t.gve[g.category].unit == "GVE"
	is_number(g.annual_mean_at)
	g.annual_mean_at >= 0
}

tierhalter(rgve, grass, forage) if {
	grass + forage > 0
	rgve >= (30 * (grass + forage)) / 100
}

protein_met(category, method, grams) if {
	grams >= 0
	grams <= t.protein[category][method]
}

rate(component, y) := r.eur_ha if {
	some r in t.rates
	r.component == component
	r.from_year <= y
	y <= r.to_year
}

base_rate(p) := rate("basis_halb", year) if {
	zone(p, year)
	plain_parcel(p)
	some m in {"1B", "2"}
	m in measure_farm.measures
} else := rate("basis", year) if {
	zone(p, year)
	plain_parcel(p)
	is_array(measure_farm.measures)
	not "1B" in measure_farm.measures
	not "2" in measure_farm.measures
}

plain_parcel(p) if {
	is_array(p.gwa.codes)
	not "AG" in p.gwa.codes
	not "OP" in p.gwa.codes
	not "OPGWA" in p.gwa.codes
	not "VF" in p.gwa.codes
}

psm_rate(p) := rate(component, year) if {
	zone(p, year)
	plain_parcel(p)
	is_array(measure_farm.measures)
	not "1B" in measure_farm.measures
	p.gwa.protection_or_conservation_zone == false
	component := t.psm_crops[crop_key(p.crop.crop_name)]
}

pig_rate(p) := rate("schwein_alt", year) if {
	year <= 2024
	zone(p, year)
	plain_parcel(p)
	measure_farm.pig_option
	pig_combination_met
	pig_density_met
} else := rate("schwein_neu", year) if {
	year >= 2025
	p.land_use == "arable"
	p.gwa.in_austria
	plain_parcel(p)
	measure_farm.pig_option
	pig_combination_met
	pig_density_met
}

ooe_rate(p) := rate("ooe", year) if {
	state(p, year) == "Oö"
	plain_parcel(p)
	measure_farm.land_funds_timely
}

education_amount(ha, y) := min([10, ha]) * rate("beratung", y) if ha >= 0

ag_amount(eligible_ha, total_arable, y) := min([eligible_ha, total_arable / 5]) * rate("ag", y) if {
	eligible_ha >= 0
	total_arable >= 0
}

area_cap(category, y) := t.caps[category][sprintf("%d", [min([y, 2025])])] if valid_year(y)
band_end(b, ha) := ha if b.upper == null

else := min([ha, b.upper])

modulation_factor(ha) := sum([weighted | some b in t.modulation; weighted := max([0, band_end(b, ha) - b.lower]) * b.share]) / ha if ha > 0
sanction_levels(y) := t.sanctions.bis_2026 if y <= 2026

else := t.sanctions.ab_2027

loss_tolerance(previous_ha) := max([0.5, min([5, previous_ha / 20])]) if previous_ha >= 0
addition_limit(base_2025_ha) := max([5, base_2025_ha * 0.5]) if base_2025_ha >= 0
transfer_deadline(y) := iso(y, "04-17") if y in {2023, 2028}

else := iso(y, "04-15")

switch_allowed(current, next, d) if {
	date_ns(d) <= date_ns("2025-12-31")
	next in t.switches[current]
	current != "K20"
}

switch_allowed(current, next, d) if {
	current == "K20"
	next in t.switches[current]
	date_ns(d) <= date_ns("2024-12-31")
}

applicant_form_met if {
	measure_farm.applicant_form in {"natürliche Person", "eingetragene Personengesellschaft"}
	measure_farm.public_body == false
}

applicant_form_met if {
	measure_farm.applicant_form in {"juristische Person", "Personenvereinigung"}
	is_number(measure_farm.public_share_percent)
	measure_farm.public_share_percent <= 25
	measure_farm.public_body == false
}

farm_size_met if year > measure_farm.first_oepul_year

farm_size_met if {
	year == measure_farm.first_oepul_year
	measure_farm.protected_cultivation_at_ha >= 0.5
}

farm_size_met if {
	year == measure_farm.first_oepul_year
	measure_farm.eligible_at_ha >= 1.5
}

drought_exemption(p) if {
	year == 2026
	p.land_use == "arable"
	p.gwa.no_harvestable_crop_due_to_drought
	p.gwa.usual_late_summer_or_autumn_harvest
	some region in t.drought_2026
	region.state == p.gwa.state
	district_matches(region.district, p)
}

district_matches(d, _) if d == "alle Bezirke"
district_matches(d, p) if d == p.gwa.district
harvest_met(p) if drought_exemption(p)

harvest_met(p) if {
	p.gwa.harvested_and_removed_percent >= 85
	p.gwa.harvested_and_removed_percent <= 100
}
