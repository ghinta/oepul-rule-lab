package oepul.o6_18

import data.naturschutz as tables
import rego.v1

year := input.farm.year
contract := input.farm.nature
program_year if year in numbers.range(2023, 2028)

contract_years(start) := tables.contract_years[sprintf("%d", [start])]

valid_date(d) if {
	regex.match("^[0-9]{4}-[0-9]{2}-[0-9]{2}$", d)
	time.parse_rfc3339_ns(concat("", [d, "T00:00:00Z"]))
}

timely_entry(kind, start, filed) if {
	last := {"NAT": 2025, "Regionaler Naturschutzplan": 2028}[kind]
	start >= 2023
	start <= last
	valid_date(filed)
	filed <= sprintf("%04d-12-31", [start - 1])
}

switch_allowed(source, target, effective_year, filed) if {
	some row in tables.switches
	[row.from, row.to] == [source, target]
	effective_year >= 2023
	effective_year <= row.last_contract_year
	valid_date(filed)
	filed <= sprintf("%04d-12-31", [effective_year - 1])
}

takeover_day(y) := 17 if y in {2023, 2028}

else := 15

takeover_window(y, filed) if {
	valid_date(filed)
	filed >= sprintf("%04d-01-01", [y])
	filed <= sprintf("%04d-04-%02d", [y, takeover_day(y)])
}

takeover_extent(prior, other_area) if {
	prior > 0
	other_area >= 0
	other_area <= prior * 0.5
}

applicant_form_ok(a) if a.legal_form in {"natural_person", "registered_partnership"}

applicant_form_ok(a) if {
	a.legal_form in {"legal_entity", "association"}
	is_number(a.public_share_percent)
	a.public_share_percent >= 0
	a.public_share_percent <= 25
}

applicant_eligible if {
	a := input.farm.applicant
	applicant_form_ok(a)
	a.public_authority_or_institution == false
	a.own_name
	a.own_account
	a.controls_claimed_land
	a.active_farmer
	a.agricultural_activity
}

minimum_size if year > contract.first_opul_year

minimum_size if {
	year == contract.first_opul_year
	is_number(contract.protected_cultivation_at_ha)
	contract.protected_cultivation_at_ha >= 0.5
}

minimum_size if {
	year == contract.first_opul_year
	is_number(contract.qualifying_first_year_at_ha)
	contract.qualifying_first_year_at_ha >= 1.5
}

regional_plan_rate := tables.plan_rates[sprintf("%d", [year])] if {
	some m in contract.measures
	m in {"18", "19"}
	contract.plan_claimed
	contract.plan_confirmed_year == year
	contract.plan_withdrawn == false
}

nat(p) if p.constraints.is_contract_nature_area == true
nat(p) if "NAT" in p.nature.mfa_codes

annual_minimum if {
	some p in input.land.parcels
	nat(p)
	p.nature.managed_as_required
}

has_ubb_bio if {
	some m in contract.measures
	m in {"1A", "1B"}
}

has_code(p, c) if c in p.nature.project_codes

project_term(c, y) := row if {
	some row in tables.project_terms
	c in row.codes
	y >= row.from_year
	y <= row.to_year
}

project_terms[p.parcel_id] := {c: row | some c in p.nature.project_codes; row := project_term(c, year)} if {
	some p in input.land.parcels
	nat(p)
	is_array(p.nature.project_codes)
}

phenology_species(code) := tables.phenology_species[code]

natura_rate(code, y) := tables.natura_rates[code] if {
	y >= 2024
	y <= 2028
}

monitoring_rate(name, y) := tables.monitoring_rates[name] if {
	y >= 2024
	y <= 2028
}

habitat_match(p) if {
	some t in p.nature.habitat_types
	t in tables.habitat_types
}

habitat_match(p) if {
	some species in p.nature.habitat_species
	some row in tables.habitat_species
	species in {row.name, row.scientific}
}

habitat_eligible(p) if {
	p.nature.habitat_reported_by_state
	p.nature.habitat_in_ama_gis
	habitat_match(p)
}

supplement(p, "SA01") := 75.6 if {
	is_number(p.nature.arable_score)
	p.nature.arable_score > 50
}

supplement(p, "SA01") := 0 if {
	is_number(p.nature.arable_score)
	p.nature.arable_score <= 50
}

supplement(_, "GM01") := 108 if "3" in contract.measures

supplement(_, "GM01") := 0 if {
	is_array(contract.measures)
	not "3" in contract.measures
}

supplement(p, c) := amt if {
	c in {"HG01", "HG02"}
	habitat_eligible(p)
	is_number(p.nature.protected_layer_percent)
	p.nature.protected_layer_percent >= 0
	p.nature.protected_layer_percent <= 100
	amt := habitat_bonus(p.nature.protected_layer_percent)
}

habitat_bonus(pct) := 108 if pct >= 50

else := 0

supplement(_, c) := 0 if not c in {"SA01", "GM01", "HG01", "HG02"}

code_rate(p, c, y) := rate if {
	not startswith(c, "K")
	rate := project_term(c, y).eur_per_ha + supplement(p, c)
}

# Tarifsumme für zugewiesene Positionen, vor Flächengrenzen, Modulation und Kürzungen.
parcel_base_rate[p.parcel_id] := sum(rates) if {
	some p in input.land.parcels
	nat(p)
	p.land_use in {"arable", "grassland"}
	codes := {c | some c in p.nature.project_codes}
	count(codes) > 0
	rates := [code_rate(p, c, year) | some c in codes]
	count(rates) == count(codes)
}

net_area(p, y) := area if {
	p.land_use == "arable"
	p.area_ha >= 0
	overlap := p.nature.gloez4_buffer_ha
	overlap >= 0

	# GLÖZ 8 als zusätzliche Fläche außerhalb des bereits gezählten Pufferstreifens.
	historical := gloez8(p, y)
	area := (p.area_ha - overlap) - historical
	area >= 0
}

net_area(p, _) := p.area_ha if {
	p.land_use == "grassland"
	p.area_ha >= 0
}

gloez8(p, y) := p.nature.gloez8_outside_buffer_ha if {
	y <= 2024
	p.nature.gloez8_outside_buffer_ha >= 0
}

gloez8(_, y) := 0 if y > 2024

eligible_setaside_ha(available, arable) := min([available, max([2, arable * 0.25])]) if {
	available >= 0
	arable >= available
}

eligible_addition_ha(y, base, new_area, already_bound) := new_area + already_bound if {
	y in {2024, 2025}
	min([base, new_area, already_bound]) >= 0
}

eligible_addition_ha(y, base, new_area, already_bound) := min([new_area, max([5, base * 0.5])]) + already_bound if {
	y in {2026, 2027, 2028}
	min([base, new_area, already_bound]) >= 0
}

repayable_loss_ha(previous, loss) := loss if {
	previous >= loss
	loss > max([0.5, min([5, previous * 0.05])])
}

repayable_loss_ha(previous, loss) := 0 if {
	previous >= loss
	loss >= 0
	loss <= max([0.5, min([5, previous * 0.05])])
}

area_ceiling(y) := row.eur_per_ha if {
	some row in tables.area_caps
	row.group == "18/19"
	y >= row.from_year
	y <= row.to_year
}

band_end(b, h) := min([b.upper, h]) if is_number(b.upper)

else := h

modulation_factor(ha) := sum(weighted) / ha if {
	is_number(ha)
	ha > 0
	weighted := [value | some b in tables.modulation; value := max([0, band_end(b, ha) - b.lower]) * b.factor]
}

sanction_schedule(y) := row if {
	some row in tables.sanctions
	y >= row.from_year
	y <= row.to_year
}

crop_groups(name, y) := {row.group | some row in tables.crop_groups; row.name == name; row.from_year <= y}

livestock_factor(category) := row if {
	some row in tables.livestock_factors
	category == row.category
}

animal_holding(rgve, grass, fodder) if {
	min([rgve, grass, fodder]) >= 0
	grass + fodder > 0
	rgve >= (grass + fodder) * 0.30
}

matrix_cell(first, second) := tables.measure_matrix[first][second]
matrix_note(n) := tables.measure_matrix_notes[n]
div_variant(code) := tables.div_variants[code]
ne01_crop_list := tables.ne01_crops
premium_combination(other, _) if matrix_cell("18", other) == "x"

premium_combination(other, subject) if {
	matrix_cell("18", other) == "x 1)"
	subject == "punktförmiges Landschaftselement"
}

chapter(c) := "A" if startswith(c, "T")

else := substring(trim_prefix(c, "N2"), 0, 1)

combination_issues contains [p.parcel_id, a, b] if {
	some p in input.land.parcels
	nat(p)
	some a in p.nature.project_codes
	some b in p.nature.project_codes
	a < b
	tables.chapter_matrix[chapter(a)][chapter(b)] == false
}

combination_issues contains [p.parcel_id, "AA06", c] if {
	some p in input.land.parcels
	nat(p)
	has_code(p, "AA06")
	some c in {"AC01", "AC03"}
	has_code(p, c)
}

combination_issues contains [p.parcel_id, c, "SA01 erforderlich"] if {
	some p in input.land.parcels
	nat(p)
	some c in p.nature.project_codes
	startswith(c, "SB")
	not has_code(p, "SA01")
}

combination_issues contains [p.parcel_id, c, "GE-Auflage erforderlich"] if {
	some p in input.land.parcels
	nat(p)
	some c in p.nature.project_codes
	c in {"GF01", "GF02"}
	not has_ge(p)
}

has_ge(p) if {
	some c in p.nature.project_codes
	c in {"GE01", "GE02", "GE03"}
}

div_credit(p) if {
	has_ubb_bio
	p.land_use == "grassland"
	p.nature.declared_use in tables.grass_uses
	every code in {"DIVSZ", "NAT"} { code in p.nature.mfa_codes }
	some c in p.nature.project_codes
	c in tables.div_grass_codes
}

div_credit(p) if {
	has_ubb_bio
	p.land_use == "arable"
	p.nature.declared_use == "Grünbrache"
	every code in {"DIV", "NAT"} { code in p.nature.mfa_codes }
	has_code(p, "SA01")
	some c in p.nature.project_codes
	c in tables.div_fallow_care
}

div_requirement(relevant_ha) := relevant_ha * 0.07 if relevant_ha > 2

else := 0 if relevant_ha >= 0

field_div_minimum(holding_ha, field_ha) := 0.15 if {
	holding_ha >= 10
	field_ha > 5
}

else := 0 if min([holding_ha, field_ha]) >= 0

requires_monitor(p, "Schnittzeit nach Phänologie") if {
	some code in p.nature.project_codes
	code in {"GL06", "GL15", "GL25"}
}

requires_monitor(p, "Großtrappe") if {
	some code in p.nature.project_codes
	substring(code, 0, 2) in {"TA", "TB"}
}

required_monitor(p) := {o | some o in {"Großtrappe", "Schnittzeit nach Phänologie"}; requires_monitor(p, o)}

monitoring_issues contains [p.parcel_id, option] if {
	some p in input.land.parcels
	nat(p)
	some option in required_monitor(p)
	is_array(contract.measures)
	is_array(contract.monitoring)
	not monitor_present(option)
}

monitor_present(option) if {
	has_ubb_bio
	option in contract.monitoring
}

monitor_qualifier("Großtrappe") if {
	some p in input.land.parcels
	nat(p)
	has_code(p, "TA01")
}

monitor_qualifier("Schnittzeit nach Phänologie") if {
	some p in input.land.parcels
	nat(p)
	"Schnittzeit nach Phänologie" in required_monitor(p)
}

monitoring_issues contains ["Betrieb", option] if {
	some option in contract.monitoring
	option in {"Großtrappe", "Schnittzeit nach Phänologie"}
	is_array(input.land.parcels)
	every p in input.land.parcels { is_array(p.nature.project_codes) }
	not monitor_qualifier(option)
}

drought_area(state, district) if {
	some r in tables.drought_districts
	r.state == state
	r.district in {"alle Bezirke", district}
}

drought_harvest(p) if {
	year == 2026
	p.land_use == "arable"
	p.nature.usual_late_summer_or_autumn_harvest
	p.nature.heat_drought_sensitive
	p.nature.no_harvestable_crop_due_to_drought
	drought_area(p.nature.federal_state, p.nature.district)
}

harvest_exception_ruled_out(_) if {
	program_year
	year != 2026
}

harvest_exception_ruled_out(p) if {
	year == 2026
	false in [object.get(p.nature, "no_harvestable_crop_due_to_drought", null), object.get(p.nature, "heat_drought_sensitive", null), object.get(p.nature, "usual_late_summer_or_autumn_harvest", null)]
}

harvest_exception_ruled_out(p) if {
	year == 2026
	is_string(p.nature.federal_state)
	is_string(p.nature.district)
	not drought_area(p.nature.federal_state, p.nature.district)
}

nature_fallow(p) if {
	nat(p)
	p.nature.declared_use == "Grünbrache"
}

harvest_issues contains p.parcel_id if {
	some p in input.land.parcels
	nat(p)
	p.land_use == "arable"
	p.nature.general_harvest_duty
	not nature_fallow(p)
	is_number(p.nature.harvested_and_removed_percent)
	p.nature.harvested_and_removed_percent < 85
	p.nature.individual_force_majeure_accepted == false
	harvest_exception_ruled_out(p)
}

earliest_use(p, ordinal, confirmed) := min([confirmed, "2026-08-12"]) if {
	nat(p)
	year == 2026
	ordinal in {1, 2}
	valid_date(confirmed)
	startswith(confirmed, "2026-")
} else := confirmed if valid_date(confirmed)

diary_issues contains [p.parcel_id, "Tagesaktuelle Aufzeichnung"] if {
	some p in input.land.parcels
	nat(p)
	p.nature.grazing_required
	p.nature.diary_current == false
}

diary_issues contains [p.parcel_id, "Einzelaufzeichnung erforderlich"] if {
	some p in input.land.parcels
	nat(p)
	p.nature.grazing_required
	p.nature.diary_grouped
	false in [object.get(p.nature, "same_grazing", null), object.get(p.nature, "recognisable_unit", null)]
}

diary_issues contains [p.parcel_id, field] if {
	some p in input.land.parcels
	nat(p)
	p.nature.grazing_required
	some entry in p.nature.grazing_diary
	some field in {"animal_group", "field", "start", "end", "animal_interruptions"}
	object.get(entry, field, null) in {null, ""}
}

diary_issues contains [p.parcel_id, "Weidetagebuch fehlt"] if {
	some p in input.land.parcels
	nat(p)
	p.nature.grazing_required
	count(p.nature.grazing_diary) == 0
}

parcel_issues contains [p.parcel_id, "NAT.projekt"] if {
	some p in input.land.parcels
	nat(p)
	p.nature.project_confirmed == false
}

parcel_issues contains [p.parcel_id, "NAT.referenz"] if {
	some p in input.land.parcels
	nat(p)
	p.nature.gis_reference == false
}

parcel_issues contains [p.parcel_id, "NAT.natcode"] if {
	some p in input.land.parcels
	nat(p)
	is_array(p.nature.mfa_codes)
	not "NAT" in p.nature.mfa_codes
}

parcel_issues contains [p.parcel_id, "NAT.flaechen"] if {
	some p in input.land.parcels
	nat(p)
	is_string(p.land_use)
	not p.land_use in {"arable", "grassland"}
}

parcel_issues contains [p.parcel_id, "NAT.pflege"] if {
	some p in input.land.parcels
	nat(p)
	p.nature.care_or_use_count_two_years == 0
}

parcel_issues contains [p.parcel_id, "NAT.nutzungen"] if {
	some p in input.land.parcels
	nat(p)
	p.land_use == "grassland"
	is_number(p.nature.annual_uses)
	p.nature.annual_uses > 3
}

parcel_issues contains [p.parcel_id, "NAT.entsteinung"] if {
	some p in input.land.parcels
	nat(p)
	p.nature.mechanical_stone_removal
}

parcel_issues contains [p.parcel_id, "NAT.gelaende"] if {
	some p in input.land.parcels
	nat(p)
	p.nature.terrain_correction
}

parcel_issues contains [p.parcel_id, "NAT.ablagerung"] if {
	some p in input.land.parcels
	nat(p)
	p.nature.deposits
}

parcel_issues contains [p.parcel_id, "NAT.aufschuettung"] if {
	some p in input.land.parcels
	nat(p)
	p.nature.filling
}

parcel_issues contains [p.parcel_id, "NAT.entwaesserung"] if {
	some p in input.land.parcels
	nat(p)
	p.nature.new_drainage
}

parcel_issues contains [p.parcel_id, "NAT.siloballen"] if {
	some p in input.land.parcels
	nat(p)
	p.nature.silage_bales_stored
}

parcel_issues contains [p.parcel_id, "NAT.saat"] if {
	some p in input.land.parcels
	nat(p)
	p.land_use == "grassland"
	p.nature.sown_or_reseeded
	false in [object.get(p.nature, "damage_repair", null), object.get(p.nature, "prior_written_state_approval", null)]
}

parcel_issues contains [p.parcel_id, "NAT.weideduengung"] if {
	some p in input.land.parcels
	nat(p)
	p.nature.pasture
	p.nature.mown_pasture == false
	p.nature.additional_fertilizer
}

parcel_issues contains [p.parcel_id, "NAT.klaerschlamm"] if {
	some p in input.land.parcels
	nat(p)
	true in [object.get(p.nature, "sludge", null), object.get(p.nature, "sludge_compost", null)]
}

parcel_issues contains [p.parcel_id, "NAT.aenderung"] if {
	some p in input.land.parcels
	nat(p)
	p.nature.management_changed
	false in [object.get(p.nature, "prior_consultation", null), object.get(p.nature, "written_amendment_before_change", null)]
}

parcel_issues contains [p.parcel_id, "NAT.nachweide"] if {
	some p in input.land.parcels
	nat(p)
	p.nature.mountain_hay_meadow
	p.nature.aftermath_grazed
	p.nature.aftermath_authorised == false
}

parcel_issues contains [p.parcel_id, "NAT.op"] if {
	some p in input.land.parcels
	nat(p)
	some c in p.nature.mfa_codes
	c in {"OP", "OPNAT"}
}

parcel_issues contains [p.parcel_id, "NAT.versuch"] if {
	some p in input.land.parcels
	nat(p)
	"VF" in p.nature.mfa_codes
}

parcel_issues contains [p.parcel_id, "NAT.inland"] if {
	some p in input.land.parcels
	nat(p)
	is_string(p.nature.country)
	p.nature.country != "AT"
}

parcel_issues contains [p.parcel_id, "NAT.nationalpark"] if {
	some p in input.land.parcels
	nat(p)
	p.nature.national_park in {"Neusiedlersee", "Donau-Auen"}
}

parcel_issues contains [p.parcel_id, "NAT.nationalpark"] if {
	some p in input.land.parcels
	nat(p)
	p.nature.relevant_park_restrictions
}

reduction_order := tables.reduction_order

observation(p, "area_ha") := p.area_ha
observation(p, "mowings") := count(p.operations.cutting_dates) if is_array(p.operations.cutting_dates)
observation(p, name) := p.nature.annual_observations[name] if not name in {"area_ha", "mowings"}

outside_limit(value, r) if {
	is_number(r.min)
	value < r.min
}

outside_limit(value, r) if {
	is_number(r.max)
	value > r.max
}

outside_limit(value, r) if {
	r.exclusive_min
	value == r.min
}

outside_limit(value, r) if {
	r.exclusive_max
	value == r.max
}

project_issues contains [p.parcel_id, r.code, r.observation] if {
	some p in input.land.parcels
	nat(p)
	some r in tables.annual_limits
	has_code(p, r.code)
	project_term(r.code, year)
	value := observation(p, r.observation)
	is_number(value)
	outside_limit(value, r)
}

operation(p, "pesticides_used") if p.operations.psm_used
operation(p, "additional_fertilizer") if p.nature.additional_fertilizer
operation(p, "fertilized") if p.operations.fertilizer.mineral_n_kg_per_ha > 0
operation(p, "fertilized") if p.operations.fertilizer.organic_n_kg_per_ha > 0
operation(p, name) if name in p.nature.performed_operations

project_issues contains [p.parcel_id, c, name] if {
	some p in input.land.parcels
	nat(p)
	some c in p.nature.project_codes
	project_term(c, year)
	some name in tables.prohibited_operations[c]
	operation(p, name)
}

project_issues contains [p.parcel_id, c, "Düngerart"] if {
	some p in input.land.parcels
	nat(p)
	some c in p.nature.project_codes
	c in {"GI02", "GI03", "GI04", "GI11", "GI12", "GI13", "GI22", "GI23", "BB03", "AC03"}
	some f in p.nature.applied_fertilizers
	f.kind != "Festmist"
	is_string(f.kind)
}

project_issues contains [p.parcel_id, "SA01", "Ackerstilllegung"] if {
	some p in input.land.parcels
	nat(p)
	has_code(p, "SA01")
	p.land_use != "arable"
}

project_issues contains [p.parcel_id, c, "Mahd vor Nutzungstermin", cut] if {
	some p in input.land.parcels
	nat(p)
	some term in p.nature.use_terms
	c := term.code
	has_code(p, c)
	ordinal := term.ordinal
	ordinal >= 1
	valid_date(term.earliest)
	startswith(term.earliest, sprintf("%04d-", [year]))
	some event in p.nature.uses
	event.ordinal == ordinal
	event.kind == term.kind
	cut := event.date
	valid_date(cut)
	startswith(cut, sprintf("%04d-", [year]))
	cut < earliest_use(p, ordinal, term.earliest)
}

# Befunde bezeichnen einzelne nachgewiesene Abweichungen. Fehlende Tatsachen
# sind keine Negativnachweise. Tarifsummen sind weder Bescheid noch Auszahlung.
assessment := {
	"parcel_issues": parcel_issues,
	"farm_issues": farm_issues,
	"project_issues": project_issues,
	"combination_issues": combination_issues,
	"monitoring_issues": monitoring_issues,
	"diary_issues": diary_issues,
	"harvest_issues": harvest_issues,
	"assigned_terms": project_terms,
	"timing_issues": timing_issues,
	"information_needed": information_needed,
	"tariff_subtotals_eur_per_ha": parcel_base_rate,
}

div_switch(source, target, date) if {
	valid_date(date)
	suffix := substring(date, 5, 5)
	suffix > "04-15"
	some row in tables.div_switches
	[row.from, row.to] == [source, target]
	suffix <= row.through
}

# Die Reihenfolge der Nutzungen am Schlag und die Zählung je Vorgang können
# voneinander abweichen (z. B. Mahd nach Beweidung).
parameter(p, c, name) := value if {
	some par in p.nature.project_parameters
	[par.code, par.parameter] == [c, name]
	value := par.value
}

window_date(p, c, key, y) := d if {
	startswith(key, "$")
	val := parameter(p, c, key)
	d := as_date(val, y)
} else := d if {
	is_string(key)
	not startswith(key, "$")
	d := as_date(key, y)
}

as_date(v, y) := v if {
	valid_date(v)
	startswith(v, sprintf("%04d-", [y]))
}

else := d if {
	regex.match("^[0-9]{2}-[0-9]{2}$", v)
	d := sprintf("%04d-%s", [y, v])
	valid_date(d)
}

term_year_applies(_, r) if r.years == null

term_year_applies(p, r) if {
	some key in r.years
	to_number(parameter(p, r.code, key)) == year
}

matches_operation(r, e) if r.operation == e.kind

matches_operation(r, e) if {
	r.operation == "Nutzung"
	e.kind in {"Mahd", "Beweidung", "Nutzung"}
}

matches_operation(r, e) if {
	r.operation == "Bewirtschaftung"
	e.management_operation
}

matches_ordinal(r, _) if r.ordinal == null

matches_ordinal(r, e) if {
	r.operation == "Nutzung"
	r.ordinal == e.use_ordinal
}

matches_ordinal(r, e) if {
	r.operation != "Nutzung"
	r.ordinal == e.operation_ordinal
}

# Der August-Erlass betrifft festgelegte Nutzungstermine. Er hebt keine
# Bearbeitungsverbote, Düngefristen oder Schonzeiträume anderer Maßnahmen auf.
effective_start(p, r, e, d) := earliest_use(p, e.use_ordinal, d) if {
	r.operation in {"Nutzung", "Mahd"}
	startswith(r.earliest, "$")
	e.use_ordinal in {1, 2}
} else := d

window_violation(p, r, e) if {
	r.forbidden_window == false
	d := window_date(p, r.code, r.earliest, year)
	e.date < effective_start(p, r, e, d)
}

window_violation(p, r, e) if {
	r.forbidden_window == false
	d := window_date(p, r.code, r.latest, year)
	e.date > d
}

window_violation(p, r, e) if {
	r.strict_latest
	e.date == window_date(p, r.code, r.latest, year)
}

window_violation(p, r, e) if {
	r.forbidden_window
	e.date >= window_date(p, r.code, r.earliest, year)
	e.date <= window_date(p, r.code, r.latest, year)
}

timing_issues contains [p.parcel_id, r.code, e.kind, e.date] if {
	some p in input.land.parcels
	nat(p)
	some r in tables.operation_windows
	has_code(p, r.code)
	project_term(r.code, year)
	term_year_applies(p, r)
	some e in p.nature.operation_log
	matches_operation(r, e)
	matches_ordinal(r, e)
	valid_date(e.date)
	startswith(e.date, sprintf("%04d-", [year]))
	window_violation(p, r, e)
}

# Zusätzliche Nachschlagetabellen der allgemeinen Teilnahmebedingungen.
listed_long_term(name) if name in tables.long_term_measures
listed_annual(name) if name in tables.annual_measures
annually_variable_units(name) if name in tables.annual_units_measures
exception_for_public_authority(name) if name in tables.public_authority_exceptions
exceptional_takeover_only(name) if name in tables.restricted_takeovers
limited_area_addition(name) if name in tables.restricted_additions
specific_management_exception(name) if name in tables.minimum_management_exceptions
dwarf_cattle(breed) if breed in tables.dwarf_cattle

parcel_issues contains [p.parcel_id, "NAT.sonstige"] if {
	some p in input.land.parcels
	nat(p)
	p.nature.declared_use in tables.noneligible_other_uses
}

# Unbewertbare Sachverhalte separat ausgeben. Das Feld "project_codes"
# bezeichnet die vollständige Liste für den jeweiligen Schlag.
information_needed contains [p.parcel_id, field] if {
	some p in input.land.parcels
	nat(p)
	some field in {"project_confirmed", "gis_reference", "project_codes", "mfa_codes"}
	object.get(object.get(p, "nature", {}), field, null) == null
}

information_needed contains [p.parcel_id, c, "kein Tabellensatz für Antragsjahr"] if {
	some p in input.land.parcels
	nat(p)
	some c in p.nature.project_codes
	not project_term(c, year)
}

regional_plan_continues if {
	program_year
	contract.plan_previous_year
	contract.plan_withdrawn == false
	contract.plan_confirmed_year == year
}

eligible_fallow_component[p.parcel_id] := net_area(p, year) if {
	some p in input.land.parcels
	p.land_use == "arable"
	"NAT" in p.nature.mfa_codes
	p.nature.gis_reference
	p.nature.project_confirmed
	has_code(p, "SA01")
}

calculated_setaside_limit_ha := eligible_setaside_ha(sum([ha | some _, ha in eligible_fallow_component]), input.land.arable_area_ha) if {
	is_array(input.land.parcels)
	every p in input.land.parcels {
		fallow_area_accounted(p)
	}
}

fallow_area_accounted(p) if not nat(p)

fallow_area_accounted(p) if {
	nat(p)
	p.land_use != "arable"
}

fallow_area_accounted(p) if {
	nat(p)
	is_array(p.nature.project_codes)
	not has_code(p, "SA01")
}

fallow_area_accounted(p) if eligible_fallow_component[p.parcel_id] >= 0

information_needed contains [p.parcel_id, c, key] if {
	some p in input.land.parcels
	nat(p)
	some c in p.nature.project_codes
	row := project_term(c, year)
	some key in regex.find_n("\\$[0-9A-Z]*", row.obligation, -1)
	not parameter(p, c, key)
}

farm_issues contains "NAT.mindestgroesse" if {
	program_year
	year == contract.first_opul_year
	is_number(contract.protected_cultivation_at_ha)
	is_number(contract.qualifying_first_year_at_ha)
	not minimum_size
}

farm_issues contains "NAT.minschlag" if {
	program_year
	"18" in contract.measures
	is_array(input.land.parcels)
	every p in input.land.parcels {
		parcel_minimum_known(p)
	}
	not annual_minimum
}

parcel_minimum_known(p) if {
	nat(p)
	is_boolean(p.nature.managed_as_required)
}

parcel_minimum_known(p) if {
	p.constraints.is_contract_nature_area == false
	not nat(p)
}

farm_issues contains "NAT.bestaetigung" if {
	contract.plan_claimed
	is_number(contract.plan_confirmed_year)
	contract.plan_confirmed_year != year
}

farm_issues contains "NAT.gebietskoerperschaft" if {
	"18" in contract.measures
	input.farm.applicant.public_authority_or_institution
}

farm_issues contains "NAT.personen" if {
	"18" in contract.measures
	a := input.farm.applicant
	a.legal_form in {"association", "legal_entity"}
	is_number(a.public_share_percent)
	a.public_share_percent > 25
}

# Auf dem Schlag umgelegte berücksichtigungsfähige LSE-Zahlungen sind in
# der Summe der modulierten Flächenzahlungen einzuschließen (1.12.2).
capped_area_amount(y, eligible_ha, modulated_sum_eur_per_ha) := eligible_ha * min([area_ceiling(y), modulated_sum_eur_per_ha]) if {
	is_number(eligible_ha)
	eligible_ha >= 0
	is_number(modulated_sum_eur_per_ha)
	modulated_sum_eur_per_ha >= 0
}

# Maßgeblich ist die gesamte Verringerung nach Abzug zulässiger Ausnahmen.
repayment_area_from_profile := repayable_loss_ha(contract.previous_nat_ha, contract.nonexempt_lost_ha)
addition_area_from_profile := eligible_addition_ha(year, contract.measure_area_2025_ha, contract.new_nat_ha, contract.received_already_bound_ha)
modulation_from_profile := modulation_factor(contract.home_area_ha)

wet_area_limit(ha) := min([ha, max([0.05, ha * 0.15])]) if {
	is_number(ha)
	ha >= 0
}

project_issues contains [p.parcel_id, "NV05", "unbewirtschaftete Feuchtstelle"] if {
	some p in input.land.parcels
	nat(p)
	has_code(p, "NV05")
	project_term("NV05", year)
	p.nature.exceptional_year_high_groundwater_all_year
	is_number(p.nature.unmanaged_wet_ha)
	p.nature.unmanaged_wet_ha > wet_area_limit(p.area_ha)
}

project_issues contains [p.parcel_id, c, field] if {
	some p in input.land.parcels
	nat(p)
	some c, field in {"NA01": "new_wetland_m2", "NG02": "stored_deadwood_m2"}
	has_code(p, c)
	is_number(p.nature[field])
	p.nature[field] >= {"NA01": 100, "NG02": 50}[c]
}

limit_applies(_, c) if c != "NO02"
limit_applies(p, "NO02") if p.nature.official_phytosanitary_order == false
violates_parameter("max", v, threshold) if v > threshold
violates_parameter("min", v, threshold) if v < threshold

project_issues contains [p.parcel_id, r.code, r.observation] if {
	some p in input.land.parcels
	nat(p)
	some r in tables.parameter_limits
	has_code(p, r.code)
	project_term(r.code, year)
	limit_applies(p, r.code)
	v := observation(p, r.observation)
	is_number(v)
	limit := to_number(parameter(p, r.code, r.parameter))
	violates_parameter(r.comparison, v, limit)
}

project_issues contains [p.parcel_id, c, "Düngejahr", f.date] if {
	some p in input.land.parcels
	nat(p)
	some c in p.nature.project_codes
	c in {"GI11", "GI12", "GI13", "ND13"}
	some f in p.nature.applied_fertilizers
	valid_date(f.date)
	startswith(f.date, sprintf("%04d-", [year]))
	base := to_number(parameter(p, c, fertilizer_start_key(c)))
	(year - base) % 2 != 0
}

fertilizer_start_key("ND13") := "$1"
fertilizer_start_key(c) := "$" if c in {"GI11", "GI12", "GI13"}

project_issues contains [p.parcel_id, c, "Düngezeitpunkt", f.date] if {
	some p in input.land.parcels
	nat(p)
	some c in p.nature.project_codes
	c in {"GI22", "GI23"}
	some f in p.nature.applied_fertilizers
	valid_date(f.date)
	startswith(f.date, sprintf("%04d-", [year]))
	fertilizer_date_excluded(p, c, f.date)
}

fertilizer_date_excluded(_, _, d) if substring(d, 5, 5) < "09-01"

fertilizer_date_excluded(p, c, _) if {
	a := to_number(parameter(p, c, "$1"))
	b := to_number(parameter(p, c, "$2"))
	not year in {a, b}
}

project_issues contains [p.parcel_id, "GN03", "Abstand unter neun Wochen"] if {
	some p in input.land.parcels
	nat(p)
	has_code(p, "GN03")
	some first in p.nature.uses
	first.ordinal == 1
	some second in p.nature.uses
	second.ordinal == 2
	every event in [first, second] { valid_date(event.date); startswith(event.date, sprintf("%04d-", [year]))}
	second_ns := time.parse_rfc3339_ns(concat("", [second.date, "T00:00:00Z"]))
	first_ns := time.parse_rfc3339_ns(concat("", [first.date, "T00:00:00Z"]))
	second_ns - first_ns < (63 * 86400) * 1000000000
}
