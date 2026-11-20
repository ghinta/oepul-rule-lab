# METADATA
# title: ÖPUL 2023 – Bodennahe Ausbringung flüssiger Wirtschaftsdünger und Gülleseparation (o6_9)
# description: >-
#   Gemeinsame Eingaben, Tabellenzugriffe und Datumsfunktionen der Maßnahme 9
#   (GSP-AV Intervention 70-08). Alle Fachtabellen liegen unter data.o6_9.
package oepul.o6_9

# Tabellen aus data/o6_9/*.json
tables := data.o6_9

# O69-GSP-001: Maßnahme 9 entspricht der Fördermaßnahme 70-08 der GSP-AV.
measure_codes := {"srl_measure": "9", "gsp_av_intervention": "70-08", "information_sheet": "o6_9"}

measure := object.get(input, ["oepul_measures", "o6_9"], {})

year := object.get(input, ["farm", "year"], 0)

application := object.get(measure, "slurry_application", {})

separation := object.get(measure, "slurry_separation", {})

pig_feeding := object.get(measure, "n_reduced_pig_feeding", {})

parcels := object.get(input, ["land", "parcels"], [])

species_groups := object.get(input, ["livestock", "species_groups"], [])

arable_area_ha := object.get(input, ["land", "arable_area_ha"], 0)

total_area_ha := object.get(input, ["land", "total_area_ha"], 0)

# Datumswerte werden als "YYYY-MM-DD" erwartet.
date_ns(d) := time.parse_ns("2006-01-02", d)

date_on_or_before(d, limit) if date_ns(d) <= date_ns(limit)

date_year(d) := y if {
	[y, _, _] := time.date(date_ns(d))
}

month_day(d) := substring(d, 5, 5)

year_date(y, md) := sprintf("%d-%s", [y, md])

has_value(obj, key) if object.get(obj, key, null) != null

is_true(obj, key) if object.get(obj, key, false) == true

is_false(obj, key) if object.get(obj, key, true) == false

round2(x) := round(x * 100) / 100

min2(a, b) := a if a <= b

min2(a, b) := b if b < a

max2(a, b) := a if a >= b

max2(a, b) := b if b > a
