# ÖPUL 2023 – Vorbeugender Grundwasserschutz – Acker (o6_16) – gemeinsame Hilfsregeln
# Parameter, Gebietskulisse (Anhang G), Flächen- und Datumshilfen.
package oepul.o6_16

params := data.o6_16.o6_16_params

general := data.o6_16.oepul_general

notices := data.o6_16.notices_2026

year := input.farm.year

parcels := object.get(input, ["land", "parcels"], [])

o16 := object.get(input, ["farm", "oepul", "o6_16"], {})

measures := {m | some m in object.get(input, ["farm", "oepul", "participating_measures"], [])}

participates(m) if m in measures

# ---------------------------------------------------------------------------
# Gebietskulisse gemäß Anhang G (Katastralgemeinden)
# ---------------------------------------------------------------------------

kulisse_kg := {row.kg_nr: row.bundesland_code | some row in data.o6_16.gebietskulisse_anhang_g.rows}

kg_in_area(kg) if {
	_ = kulisse_kg[kg]
}

in_area(p) if kg_in_area(object.get(p, "cadastral_community_number", null))

area_state(p) := kulisse_kg[object.get(p, "cadastral_community_number", null)]

in_vienna_area(p) if area_state(p) == "wien"

in_upper_austria_area(p) if area_state(p) == "oberoesterreich"

state_offered(state) if state in {s | some s in params.federal_states_offered}

# ---------------------------------------------------------------------------
# Schlagmerkmale
# ---------------------------------------------------------------------------

is_arable(p) if p.land_use == "arable"

codes(p) := {c | some c in object.get(p, ["oepul", "codes"], [])}

has_code(p, c) if c in codes(p)

is_ag(p) if has_code(p, "AG")

is_op(p) if has_code(p, "OP")

is_op(p) if has_code(p, general.op_code_o6_16)

crop_name(p) := object.get(p, ["crop", "crop_name"], "")

crop_category(p) := object.get(p, ["crop", "crop_category"], "")

name_in(name, names) if {
	is_string(name)
	some n in names
	lower(n) == lower(name)
}

is_arable_forage_name(name) if name_in(name, general.definitions.ackerfutter)

is_arable_forage(p) if is_arable_forage_name(crop_name(p))

is_maize(p) if crop_category(p) == "maize"

is_maize(p) if name_in(crop_name(p), ["Mais", "Körnermais", "Silomais", "Corn-Cob-Mix", "Zuckermais", "Saatmaisvermehrung"])

# Ackerflächen in der Gebietskulisse (alle Schläge, inkl. AG)
arable_in_area := [p | some p in parcels; is_arable(p); in_area(p)]

arable_in_area_ha := sum([p.area_ha | some p in arable_in_area])

# Prämienfähige Ackerflächen in der Gebietskulisse ohne AG- und OP-Schläge
basis_parcels := [p | some p in arable_in_area; not is_ag(p); not is_op(p)]

basis_parcels_ha := sum([p.area_ha | some p in basis_parcels])

vienna_arable := [p | some p in arable_in_area; in_vienna_area(p)]

vienna_arable_ha := sum([p.area_ha | some p in vienna_arable])

farm_arable_ha := input.land.arable_area_ha if {
	is_number(input.land.arable_area_ha)
} else := sum([p.area_ha | some p in parcels; is_arable(p)])

# ---------------------------------------------------------------------------
# Datumshilfen (ISO-Datum YYYY-MM-DD)
# ---------------------------------------------------------------------------

date_ns(d) := time.parse_rfc3339_ns(sprintf("%sT00:00:00Z", [d]))

date_le(a, b) if date_ns(a) <= date_ns(b)

date_lt(a, b) if date_ns(a) < date_ns(b)

md_date(yr, md) := sprintf("%d-%s", [yr, md])

date_year(d) := to_number(substring(d, 0, 4))

month_day(d) := substring(d, 5, 5)

is_date(d) if {
	is_string(d)
	regex.match(`^\d{4}-\d{2}-\d{2}$`, d)
}

# Teilnahmejahr (1 = erstes Verpflichtungsjahr)
contract_start_year := o16.contract_start_year

first_participation_year if contract_start_year == year

option_applied(name) if object.get(o16, [name, "applied"], false) == true

# Schläge der Optionen
ag_parcels := [p | some p in parcels; is_ag(p)]

cul_parcels := [p | some p in parcels; has_code(p, params.cultan.code)]
