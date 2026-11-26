package oepul.o6_4

import data.bergmaehder as tabellen
import rego.v1

# Datumswerte sind lokale Kalendertage im ISO-Format.
valid_date(d) if {
	regex.match(`^[0-9]{4}-[0-9]{2}-[0-9]{2}$`, d)
	time.parse_rfc3339_ns(concat("", [d, "T00:00:00Z"]))
}

year_of(d) := to_number(substring(d, 0, 4)) if valid_date(d)
in_period(y) if y in numbers.range(2023, 2028)

contract_years(y) := tabellen.contracts[sprintf("%d", [y])].years

entry_timely(y, d) := ok if {
	valid_date(d)
	ok := timely_start(y, d)
}

default timely_start(_, _) := false

timely_start(y, d) if {
	y in {2023, 2024, 2025}
	year_of(d) == y - 1
}

switch_permitted(y, d, target) := ok if {
	contract_years(y)
	valid_date(d)
	ok := switch_window(y, d, target)
}

default switch_window(_, _, _) := false

switch_window(y, d, target) if {
	year_of(d) >= y
	d <= "2025-12-31"
	target in tabellen.switches["4"]
}

takeover_deadline(y) := sprintf("%d-04-17", [y]) if y in {2023, 2028}

else := sprintf("%d-04-15", [y]) if in_period(y)

takeover_timely(y, d) := ok if {
	valid_date(d)
	deadline := takeover_deadline(y)
	ok := within_calendar_window(d, y, deadline)
}

default within_calendar_window(_, _, _) := false

within_calendar_window(d, y, deadline) if {
	year_of(d) == y
	d <= deadline
}

takeover_possible(t, y) if {
	takeover_timely(y, t.date)
	t.new_to_measure
	t.submitted_online
	t.ama_approved
	t.transferred_ha > 0
	t.additional_ha >= 0
	t.additional_ha <= 0.5 * t.transferred_ha
}

counts(p, y) := count([d | some d in dates; year_of(d) == y]) if {
	dates := p.operations.cutting_dates
	is_array(dates)
	every d in dates { valid_date(d) }
}

expected_code(p, y) := "BM0" if counts(p, y) == 0

else := tabellen.methods[p.bergmahd.main_method] if counts(p, y) == 1

tariff_eur_ha(y, code) := row.eur_ha if {
	some row in tabellen.rates
	row.code == code
	y >= row.from_year
	y <= row.to_year
}

matrix_cell(a, b) := row.mark if {
	some row in tabellen.matrix
	row.row == a
	row.column == b
}

compatible_payment(q) := ok if {
	is_string(q.measure)
	is_string(q.component)
	ok := allowed_payment(q)
}

default allowed_payment(_) := false

allowed_payment(q) if {
	matrix_cell("4", q.measure) == "x1"
	tabellen.matrix_notes["1"]
	q.component == "punktförmiges Landschaftselement"
}

# Bei einzelnen unbekannten Werten bleibt die Prüfung offen. Eine feststehende
# Verletzung in derselben Liste hat Vorrang vor unbekannten anderen Einträgen.
criterion(p, "flaeche") := p.bergmahd.extensive_meadow
criterion(p, "siedlungsgrenze") := p.bergmahd.above_settlement_limit
criterion(p, "zweck") := p.bergmahd.difficult_management

criterion(p, "hoehe") := a > (0.5 * p.area_ha) if {
	a := p.bergmahd.area_above_1200m_ha
	is_number(a)
	a >= 0
	p.area_ha > 0
	a <= p.area_ha
}

criterion(p, "heimbetrieb") := p.bergmahd.above_home_farm if is_boolean(p.bergmahd.above_home_farm)

else if p.bergmahd.only_alpine_station

criterion(p, "maxmahd") := counts(p, input.farm.year) <= 1
criterion(p, "abtransport") if counts(p, input.farm.year) == 0

else := p.bergmahd.crop_removed if counts(p, input.farm.year) > 0

criterion(p, "haeckseln") := p.bergmahd.shredded == false if is_boolean(p.bergmahd.shredded)

complete_cut(p) := false if counts(p, input.farm.year) == 0

else := false if p.bergmahd.full_cut == false

else := false if p.bergmahd.crop_removed == false

else if {
	counts(p, input.farm.year) > 0
	p.bergmahd.full_cut
	p.bergmahd.crop_removed
}

criterion(p, "zweijahresmahd") if complete_cut(p)

else if {
	p.bergmahd.bound_previous_year
	p.bergmahd.previous_full_cut_removed
}

else := false if {
	p.bergmahd.bound_previous_year
	p.bergmahd.previous_full_cut_removed == false
	complete_cut(p) == false
}

# Im ersten Bindungsjahr ohne belegte Mahd ist das erste Zweijahresfenster offen.

grazing_ok(g, y) := ok if {
	year_of(g.date) == y
	is_boolean(g.aftermath)
	ok := aftermath_in_season(g, y)
} else if {
	year_of(g.date) != y
}

default aftermath_in_season(_, _) := false

aftermath_in_season(g, y) if {
	g.aftermath
	g.date >= sprintf("%d-08-16", [y])
}

material_ok(material) if material.kind == "eigene häusliche Abwässer"

else := false if {
	is_string(material.kind)
	not material.kind in {"Festmist", "eigene häusliche Abwässer"}
}

else := false if {
	material.kind == "Festmist"
	material.original_form == false
}

else := false if {
	material.kind == "Festmist"
	material.needs_based == false
}

else if {
	material.kind == "Festmist"
	material.original_form
	material.needs_based
}

criterion(p, "weide") := false if {
	some g in p.bergmahd.grazing
	grazing_ok(g, input.farm.year) == false
} else if {
	is_array(p.bergmahd.grazing)
	every g in p.bergmahd.grazing { grazing_ok(g, input.farm.year) }
}

criterion(p, "duenger") := false if {
	p.operations.fertilizer.mineral_n_kg_per_ha > 0
	is_number(p.operations.fertilizer.mineral_n_kg_per_ha)
}

else := false if {
	some m in p.bergmahd.materials
	material_ok(m) == false
}

else if {
	is_array(p.bergmahd.materials)
	every m in p.bergmahd.materials { material_ok(m) }
}

criterion(p, "psm") if p.operations.psm_used == false

else := p.bergmahd.only_organic_approved_actives if p.operations.psm_used

criterion(p, "nutzungsart") := p.bergmahd.declared_use == "Bergmähder" if is_string(p.bergmahd.declared_use)
criterion(p, "mahdcode") := p.bergmahd.declared_code == expected_code(p, input.farm.year) if is_string(p.bergmahd.declared_code)

criterion(p, "kombination") := false if {
	some q in p.bergmahd.other_payments
	compatible_payment(q) == false
}

else if {
	is_array(p.bergmahd.other_payments)
	every q in p.bergmahd.other_payments { compatible_payment(q) }
}

criterion(p, "lage") := p.bergmahd.country == "AT" if is_string(p.bergmahd.country)
criterion(p, "produktiv") := p.bergmahd.active_agricultural_use
criterion(p, "ausschluss") := false if p.bergmahd.mfa_identified == false

else := false if p.bergmahd.mainly_agricultural == false

else := false if p.bergmahd.gloez_element

else := false if p.bergmahd.land_category in tabellen.excluded_uses

else if {
	p.bergmahd.mfa_identified
	p.bergmahd.mainly_agricultural
	p.bergmahd.gloez_element == false
	is_string(p.bergmahd.land_category)
	not p.bergmahd.land_category in tabellen.excluded_uses
}

criterion(p, "nationalpark") := false if p.bergmahd.national_park in {"Neusiedlersee", "Donau-Auen"}

else if p.bergmahd.national_park == "kein"

else := p.bergmahd.relevant_park_restrictions == false if {
	is_string(p.bergmahd.national_park)
	is_boolean(p.bergmahd.relevant_park_restrictions)
}

criterion(p, "versuch") := p.bergmahd.trial_prevents_compliance == false if is_boolean(p.bergmahd.trial_prevents_compliance)
criterion(p, "op") := p.bergmahd.op_applies == false if is_boolean(p.bergmahd.op_applies)
criterion(p, "ueberlagerung") := p.bergmahd.public_overlap == false if is_boolean(p.bergmahd.public_overlap)
criterion(p, "ausgleich") := p.bergmahd.official_compensation == false if is_boolean(p.bergmahd.official_compensation)

check_keys := {"flaeche", "siedlungsgrenze", "zweck", "hoehe", "heimbetrieb", "zweijahresmahd", "maxmahd", "abtransport", "haeckseln", "weide", "duenger", "psm", "nutzungsart", "mahdcode", "kombination", "lage", "produktiv", "ausschluss", "nationalpark", "versuch", "op", "ueberlagerung", "ausgleich"}

checked(p, k) := v if {
	v := criterion(p, k)
	is_boolean(v)
} else := null

parcel_checks := {p.parcel_id: {k: checked(p, k) | some k in check_keys} |
	some p in input.land.parcels
	p.bergmahd.enrolled
	in_period(input.farm.year)
}

# Tarifwert vor allgemeiner Förderfähigkeitsprüfung, Flächen- und Prämiengrenzen.
parcel_tariffs := {p.parcel_id: {"code": code, "eur_ha": rate, "eur": p.area_ha * rate} |
	some p in input.land.parcels
	p.bergmahd.enrolled
	p.area_ha > 0
	code := expected_code(p, input.farm.year)
	rate := tariff_eur_ha(input.farm.year, code)
}

# Status der einzelnen Schlagprüfungen; Bemessungsgrundlage und Förderentscheidung
# bleiben auch bei einer Beanstandung getrennt abrufbar.
parcel_review[id] := {"violations": violations, "missing_or_pending": pending, "status": status} if {
	some id, checks in parcel_checks
	violations := {key | some key, value in checks; value == false}
	pending := {key | some key, value in checks; value == null}
	status := review_status(violations, pending)
}

review_status(v, _) := "beanstandet" if count(v) > 0

review_status(v, pending) := "offen" if {
	count(v) == 0
	count(pending) > 0
}

review_status(v, pending) := "erfüllt" if {
	count(v) == 0
	count(pending) == 0
}
