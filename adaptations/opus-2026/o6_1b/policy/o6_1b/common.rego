# Gemeinsame Hilfsregeln für die ÖPUL-Maßnahme "Biologische Wirtschaftsweise" (o6_1b).
# Quellen: Informationsblatt o6_1b (Stand April 2026), Allgemeine Teilnahmebedingungen
# (Stand April 2026), Sonderrichtlinie ÖPUL 2023 inkl. Anhänge.
package oepul.o6_1b

cfg := data.o6_1b

lists := data.o6_1b.lists

general := data.o6_1b.general

year := input.farm.year

o6_1b_input := object.get(input, ["oepul", "o6_1b"], {})

participating_measures := {m | some m in object.get(input, ["oepul", "participating_measures"], [])}

parcels := object.get(input, ["land", "parcels"], [])

field_pieces := object.get(input, ["land", "field_pieces"], [])

# --- Prämiensätze (data/o6_1b/rates.json) --------------------------------------

rate_for_year(id, y) := v.eur if {
	some row in cfg.rates.rows
	row.id == id
	some v in row.values
	v.from_year <= y
	within_to_year(v.to_year, y)
}

within_to_year(to, _) if to == null

within_to_year(to, y) if {
	to != null
	y <= to
}

rate(id) := rate_for_year(id, year)

# Liefert 0, wenn der Zuschlag im Antragsjahr (noch) nicht angeboten wird.
rate_or_zero(id) := rate(id)

rate_or_zero(id) := 0 if not rate_offered(id)

rate_offered(id) if rate(id)

caps := cfg.rates.caps

# --- Datumshilfen -----------------------------------------------------------------

# "MM-DD" eines ISO-Datums (YYYY-MM-DD)
md(d) := substring(d, 5, 5)

date_year(d) := to_number(substring(d, 0, 4))

date_ns(d) := time.parse_ns("2006-01-02", d)

# Kalendertage von a nach b (b - a)
days_between(a, b) := round((date_ns(b) - date_ns(a)) / 86400000000000)

add_days(d, n) := substring(time.format([time.add_date(date_ns(d), 0, 0, n), "UTC", "2006-01-02"]), 0, 10)

# --- Schlag-Hilfen -----------------------------------------------------------------

area(p) := object.get(p, "area_ha", 0)

codes(p) := {c | some c in object.get(p, "oepul_codes", [])}

has_code(p, c) if c in codes(p)

land_use_type(p) := object.get(p, "schlagnutzungsart", "")

crop_name(p) := object.get(p, ["crop", "crop_name"], "")

div_info(p) := object.get(p, ["constraints", "biodiversity_area"], {})

use_events(p) := object.get(p, ["operations", "use_events"], [])

fertilizer_applications(p) := object.get(p, ["operations", "fertilizer_applications"], [])

# Schläge, die für die Maßnahme ausgeschlossen sind (Kap. 3.2)
excluded_land_use(p) if land_use_type(p) in lists.excluded_land_use_type_keys

# Maßnahmenbezogener Nichtprämien-Code OP bzw. OPBIO
opted_out(p) if has_code(p, "OP")

opted_out(p) if has_code(p, "OPBIO")

# GLÖZ-Landschaftselemente, Mehrnutzenhecken, Agroforststreifen zählen nicht zur Ackerfläche
arable_basis_excluded(p) if land_use_type(p) in {"GLÖZ-Landschaftselement", "LSE Mehrnutzenhecke", "Agroforststreifen"}

is_arable(p) if {
	p.land_use == "arable"
	not arable_basis_excluded(p)
}

is_grassland(p) if p.land_use == "grassland"

is_special_crop(p) if p.land_use == "special_crop"

is_bergmaehder(p) if object.get(p, "is_bergmaehder", false) == true

is_mown_grassland(p) if {
	is_grassland(p)
	object.get(p, "is_mown", false) == true
	not is_bergmaehder(p)
}

arable_area_ha := sum([area(p) | some p in parcels; is_arable(p)])

grassland_area_ha := sum([area(p) | some p in parcels; is_grassland(p)])

mown_grassland_area_ha := sum([area(p) | some p in parcels; is_mown_grassland(p)])

# Anteil sicher berechnen
share(part, whole) := part / whole if whole > 0

share(_, whole) := 0 if whole <= 0

min2(a, b) := a if a <= b

min2(a, b) := b if a > b

max2(a, b) := a if a >= b

max2(a, b) := b if a < b

clamp0(x) := max2(x, 0)

# Aufrundung auf die nächste ganze Zahl (für "je angefangene 3 ha")
ceil_int(x) := ceil(x)

# Rundung auf zwei Nachkommastellen (für Meldungstexte)
round2(x) := round(x * 100) / 100
