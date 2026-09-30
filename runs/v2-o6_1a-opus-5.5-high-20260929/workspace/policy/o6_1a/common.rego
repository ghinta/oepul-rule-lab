# METADATA
# title: UBB (o6_1a) – gemeinsame Hilfsfunktionen
# description: Flächenaggregation, Codes, Prämiensätze und Datumsfunktionen für die Maßnahme UBB.
package oepul.o6_1a.common

tables := data.o6_1a

year := object.get(input, ["farm", "year"], 0)

measures := {m | some m in object.get(input, ["farm", "oepul", "measures"], [])}

participates(m) if m in measures

ubb := object.get(input, ["farm", "oepul", "ubb"], {})

parcels := object.get(input, ["land", "parcels"], [])

parcel_id(p) := object.get(p, "parcel_id", "unbekannt")

area(p) := object.get(p, "area_ha", 0)

codes(p) := {c | some c in object.get(p, "codes", [])}

has_code(p, c) if c in codes(p)

conditions(p) := {c | some c in object.get(p, "project_conditions", [])}

schlagnutzungsart(p) := object.get(p, ["crop", "schlagnutzungsart"], "")

crop_name(p) := object.get(p, ["crop", "crop_name"], "")

area_kind(p) := object.get(p, "area_kind", "agricultural")

field_piece(p) := object.get(p, "field_piece_id", parcel_id(p))

# Ackerfläche als Berechnungsbasis: GLÖZ-Landschaftselemente, Mehrnutzenhecken und
# Agroforststreifen zählen nicht dazu.
is_arable(p) if {
	p.land_use == "arable"
	area_kind(p) == "agricultural"
}

is_grassland(p) if {
	p.land_use == "grassland"
	area_kind(p) == "agricultural"
}

is_bergmaehder(p) if schlagnutzungsart(p) == "Bergmähder"

# Gemähte Grünlandfläche ohne Bergmähder.
is_mown_grassland(p) if {
	is_grassland(p)
	schlagnutzungsart(p) in {s | some s in tables.o6_1a_mown_grassland_schlagnutzungsarten}
}

arable_parcels := [p | some p in parcels; is_arable(p)]

grassland_parcels := [p | some p in parcels; is_grassland(p)]

mown_grassland_parcels := [p | some p in parcels; is_mown_grassland(p)]

arable_area_ha := sum([area(p) | some p in arable_parcels])

grassland_area_ha := sum([area(p) | some p in grassland_parcels])

mown_grassland_area_ha := sum([area(p) | some p in mown_grassland_parcels])

# Ackerfutterflächen (Futtergräser, Wechselwiese, Kleegras, Klee, Luzerne, Sonstiges Feldfutter, Ackerweide).
is_arable_forage(p) if {
	is_arable(p)
	crop_label(p) in {c | some c in tables.o6_1a_arable_forage}
}

# Schlagnutzungsart vorrangig, sonst Kulturname.
crop_label(p) := schlagnutzungsart(p) if schlagnutzungsart(p) != ""

crop_label(p) := crop_name(p) if schlagnutzungsart(p) == ""

forage_area_ha := grassland_area_ha + sum([area(p) | some p in arable_parcels; is_arable_forage(p)])

# Biodiversitätscodes
arable_div_codes := {"DIV", "DIVRS"}

grassland_div_codes := {"DIVSZ", "DIVNFZ", "DIVAGF", "DIVRS"}

is_arable_div(p) if {
	is_arable(p)
	some c in arable_div_codes
	has_code(p, c)
}

is_grassland_div(p) if {
	is_grassland(p)
	some c in grassland_div_codes
	has_code(p, c)
}

# Biodiversitätsflächen, die aus anderen Maßnahmen angerechnet werden.
credited_from_other_measure(p) if {
	is_arable_div(p)
	some c in tables.o6_1a_div_credit_other_measure_codes_arable
	has_code(p, c)
}

credited_from_other_measure(p) if {
	is_grassland_div(p)
	some c in tables.o6_1a_div_credit_other_measure_codes_grassland
	has_code(p, c)
}

is_gloez4(p) if has_code(p, "GLOEZ4")

# Keine UBB-Prämie auf Schlägen mit OP, OPUBB oder VF sowie in Nationalparks mit Auflagen.
no_premium(p) if {
	some c in tables.o6_1a_no_premium_codes
	has_code(p, c)
}

no_premium(p) if {
	object.get(p, "national_park", null) in {n | some n in tables.o6_1a_national_parks_no_premium}
}

no_premium(p) if {
	object.get(p, "national_park", null) != null
	object.get(p, "national_park_relevant_restrictions", false) == true
}

# Prämiensatz nach Komponente und Antragsjahr.
rate(component) := r if {
	some entry in tables.o6_1a_premium_rates
	entry.component == component
	some band in entry.rates
	in_band(band, year)
	r := band.rate
}

default rate_or_zero(_) := 0

rate_or_zero(component) := rate(component)

in_band(band, y) if {
	band.from_year <= y
	band.to_year == null
}

in_band(band, y) if {
	band.from_year <= y
	y <= band.to_year
}

limits := tables.o6_1a_premium_limits

# Datumsfunktionen (ISO-Datum JJJJ-MM-TT)
ns_per_day := ((24 * 60) * 60) * 1000000000

days_between(from, to) := (time.parse_ns("2006-01-02", to) - time.parse_ns("2006-01-02", from)) / ns_per_day

month_day(d) := substring(d, 5, 5)

shift_date(d, days) := time.format([time.add_date(time.parse_ns("2006-01-02", d), 0, 0, days), "UTC", "2006-01-02"])

later_date(a, b) := a if a >= b

later_date(a, b) := b if b > a

earlier_date(a, b) := a if a <= b

earlier_date(a, b) := b if b < a

date_year(d) := to_number(substring(d, 0, 4))

min_of(a, b) := a if a <= b

min_of(a, b) := b if b < a

max_of(a, b) := a if a >= b

max_of(a, b) := b if b > a

round2(x) := round(x * 100) / 100

# Toleranz für Gleitkommavergleiche von Flächen und Anteilen.
eps := 0.000001
