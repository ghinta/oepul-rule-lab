package oepul.o6_6

import rego.v1

# Befunde beziehen sich auf konkret beantragte Schläge. Mehrere eigenständige
# Verstöße auf einem Schlag bleiben einzeln sichtbar.
findings contains {"parcel_id": p.parcel_id, "rule_id": key} if {
	some p in input.land.parcels
	p.operations.cover_crop.claimed == true
	some key in parcel_rules[p.parcel_id]
}

findings contains {"parcel_id": item.parcel_id, "rule_id": item.rule_id} if {
	some item in event_findings
}

variant_key(c, y) := sprintf("zwf.variante.%d.%d", [c.variant, r.first_year]) if {
	r := variant_row(c.variant, y)
}

parcel_rules[p.parcel_id] contains "zwf.acker.schlag" if {
	some p in input.land.parcels

	p.land_use != "arable"
}

parcel_rules[p.parcel_id] contains "zwf.zwischenfrucht" if {
	some p in input.land.parcels
	c := p.operations.cover_crop

	c.variant <= 6
	c.between_main_crops == false
}

parcel_rules[p.parcel_id] contains "zwf.zwischenfrucht" if {
	some p in input.land.parcels
	c := p.operations.cover_crop

	c.active_sowing == false
}

parcel_rules[p.parcel_id] contains "zwf.hauptfrucht.mfa" if {
	some p in input.land.parcels
	c := p.operations.cover_crop

	c.main_crop_declared == true
}

parcel_rules[p.parcel_id] contains "zwf.anlage" if {
	some p in input.land.parcels
	c := p.operations.cover_crop

	c.proper_establishment == false
}

parcel_rules[p.parcel_id] contains "zwf.deckung" if {
	some p in input.land.parcels
	c := p.operations.cover_crop
	y := input.farm.year

	c.full_cover == false
	not cover_relief(c, y)
}

parcel_rules[p.parcel_id] contains "zwf.getreideanteil" if {
	some p in input.land.parcels
	c := p.operations.cover_crop
	y := input.farm.year

	is_number(c.cereal_maize_pct)
	c.cereal_maize_pct > 50
	not rye_exception(c)
	not cereal_relief(c, y)
}

parcel_rules[p.parcel_id] contains "zwf.saatgutbeleg" if {
	some p in input.land.parcels
	c := p.operations.cover_crop

	c.partners_visible == false
	c.seed_evidence == "none"
}

parcel_rules[p.parcel_id] contains variant_key(c, y) if {
	some p in input.land.parcels
	c := p.operations.cover_crop
	y := input.farm.year

	r := variant_row(c.variant, y)
	date := established(c)
	day(date) > day(date_in(y, r.sow_by))
}

parcel_rules[p.parcel_id] contains variant_key(c, y) if {
	some p in input.land.parcels
	c := p.operations.cover_crop
	y := input.farm.year

	date := established(c)
	day(date) < day(date_in(y, "01-01"))
}

parcel_rules[p.parcel_id] contains variant_key(c, y) if {
	some p in input.land.parcels
	c := p.operations.cover_crop
	y := input.farm.year

	day(c.break_date) < day(break_from(c, y))
}

parcel_rules[p.parcel_id] contains variant_key(c, y) if {
	some p in input.land.parcels
	c := p.operations.cover_crop
	y := input.farm.year

	is_array(c.components)
	c.mixture_assessed == true
	not mixture_ok(c, y)
}

parcel_rules[p.parcel_id] contains "zwf.v1.beimischung" if {
	some p in input.land.parcels
	c := p.operations.cover_crop

	c.variant == 1
	is_number(c.non_insect_pct)
	c.non_insect_pct >= 10
}

parcel_rules[p.parcel_id] contains "zwf.v1.herbst" if {
	some p in input.land.parcels
	c := p.operations.cover_crop

	c.variant == 1
	some field in {"autumn_winter_crop", "next_crop_claimed"}
	c[field] == false
}

parcel_rules[p.parcel_id] contains "zwf.v6.arten" if {
	some p in input.land.parcels
	c := p.operations.cover_crop

	c.variant == 6
	c.mixture_assessed == true
	some s in c.components
	not v6_component(s)
}

parcel_rules[p.parcel_id] contains "zwf.v7.raps" if {
	some p in input.land.parcels
	c := p.operations.cover_crop

	c.variant == 7
	c.in_winter_rape_rows == false
}

parcel_rules[p.parcel_id] contains "zwf.npf" if {
	some p in input.land.parcels
	c := p.operations.cover_crop
	y := input.farm.year

	y == 2024
	c.variant in {1, 2, 3, 4, 5, 6}
	c.npf == true
}

parcel_rules[p.parcel_id] contains "zwf.gwa.ooe" if {
	some p in input.land.parcels
	c := p.operations.cover_crop

	"16" in input.farm.zwf.measures
	p.agrar.gwa_area == true
	p.agrar.state == "Oberösterreich"
	c.variant == 3
}

parcel_rules[p.parcel_id] contains "zwf.antrag.spaet" if {
	some p in input.land.parcels
	c := p.operations.cover_crop
	y := input.farm.year

	c.change_kind in {"new", "extend", "switch"}
	day(c.change_date)
	not change_ok(c, y)
}

parcel_rules[p.parcel_id] contains "zwf.inland" if {
	some p in input.land.parcels

	is_string(p.agrar.country)
	p.agrar.country != "AT"
}

parcel_rules[p.parcel_id] contains "zwf.nationalpark" if {
	some p in input.land.parcels

	p.agrar.national_park in {"Neusiedlersee", "Donau-Auen"}
}

parcel_rules[p.parcel_id] contains "zwf.nationalpark" if {
	some p in input.land.parcels

	p.agrar.park_restrictions == true
}

parcel_rules[p.parcel_id] contains "zwf.ausschluss" if {
	some p in input.land.parcels

	p.agrar.correctly_identified == false
}

parcel_rules[p.parcel_id] contains "zwf.ausschluss" if {
	some p in input.land.parcels

	p.agrar.excluded_land == true
}

parcel_rules[p.parcel_id] contains "zwf.code.op" if {
	some p in input.land.parcels

	some code in p.agrar.codes
	code in {"OP", "OPZWF"}
}

parcel_rules[p.parcel_id] contains "zwf.versuch" if {
	some p in input.land.parcels

	"VF" in p.agrar.codes
}

parcel_rules[p.parcel_id] contains "zwf.code.ueberlappung" if {
	some p in input.land.parcels

	p.agrar.public_overlap == true
}

parcel_rules[p.parcel_id] contains "zwf.beseitigung" if {
	some p in input.land.parcels
	c := p.operations.cover_crop
	y := input.farm.year

	c.variant in {1, 2, 3, 4, 5, 6}
	c.removal.assessed == true
	not removal_ok(c, y)
}

parcel_rules[p.parcel_id] contains "zwf.nachfolge" if {
	some p in input.land.parcels
	c := p.operations.cover_crop

	c.transfer.successor_complies == false
}

parcel_rules[p.parcel_id] contains "zwf.matrix" if {
	some p in input.land.parcels

	some m in p.agrar.measures
	m != "6"
	combination_cell("6", m).zeichen == ""
}

parcel_rules[p.parcel_id] contains "zwf.matrix.fn4" if {
	some p in input.land.parcels

	some m in p.agrar.codes
	m in {"BAW", "AG"}
}

parcel_rules[p.parcel_id] contains "zwf.ausschluss.gloez" if {
	some p in input.land.parcels

	p.agrar.exclusion_type in {"GLÖZ-Landschaftselement", "überwiegend außerlandwirtschaftlich"}
}

parcel_rules[p.parcel_id] contains "zwf.wahl" if {
	some p in input.land.parcels
	c := p.operations.cover_crop
	is_number(c.variant)
	not c.variant in {1, 2, 3, 4, 5, 6, 7}
}

parcel_rules[p.parcel_id] contains "zwf.k20.kombination" if {
	some p in input.land.parcels
	"K20" in p.agrar.codes
	input.farm.year in {2023, 2024}
}

parcel_rules[p.parcel_id] contains "zwf.betrieb" if {
	some p in input.land.parcels
	p.agrar.disposal_right == false
}

parcel_rules[p.parcel_id] contains "zwf.ausstieg.jahr" if {
	some p in input.land.parcels
	f := input.farm
	c := p.operations.cover_crop
	startswith(f.zwf.exit_date, sprintf("%04d-", [f.year + 1]))
	day(f.zwf.exit_date)
	break_from(c, f.year)
	not exit_window_ok(c, f.year, f.zwf.exit_date)
}

parcel_rules[p.parcel_id] contains "zwf.v6.nachbau" if {
	some p in input.land.parcels
	c := p.operations.cover_crop
	c.variant == 6
	some s in c.components
	s.species == "Grünschnittroggen"
	s.farm_saved == true
	s.propagation_proof == false
}

corrections contains {"parcel_id": p.parcel_id, "rule_id": "zwf.antrag.streichen", "action": "umgehend streichen oder betroffenen Teil reduzieren"} if {
	some p in input.land.parcels
	c := p.operations.cover_crop
	c.claimed == true
	c.conditions_unattainable == true
}

corrections contains {"parcel_id": p.parcel_id, "rule_id": "zwf.hauptfrucht.mfa", "action": "Begrünungsvariante streichen"} if {
	some p in input.land.parcels
	c := p.operations.cover_crop
	c.claimed == true
	c.main_crop_declared == true
}

corrections contains {"parcel_id": p.parcel_id, "rule_id": "zwf.nachfolge", "action": "Variante abmelden"} if {
	some p in input.land.parcels
	c := p.operations.cover_crop
	c.claimed == true
	c.transfer.successor_complies == false
}

parcel_rules[p.parcel_id] contains "zwf.gwa.wien" if {
	some p in input.land.parcels
	p.agrar.state == "Wien"
	"16:Humusaufbau und Erosionsschutz in Wien" in p.agrar.measures
	some e in p.operations.cover_crop.events
	e.inversion_tillage == true
	e.after_maize == false
}
