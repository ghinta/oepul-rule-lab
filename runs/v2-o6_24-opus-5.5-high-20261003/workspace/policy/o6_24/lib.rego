package oepul.o6_24

import rego.v1

# Gemeinsame Hilfsfunktionen und Eingabezugriffe für die Maßnahme o6_24
# "Wasserrahmenrichtlinie – Landwirtschaft".

ns_per_day := 86400000000000

measure_code := "24"

farm_year := object.get(input, ["farm", "year"], 0)

parcels := object.get(input, ["land", "parcels"], [])

oepul := object.get(input, ["farm", "oepul"], {})

o624 := object.get(oepul, "o6_24", {})

# Datum im Format YYYY-MM-DD -> Tage zwischen a und b (b - a).
days_between(a, b) := (time.parse_ns("2006-01-02", b) - time.parse_ns("2006-01-02", a)) / ns_per_day

# Monat-Tag-Anteil eines ISO-Datums ("MM-DD").
month_day(d) := substring(d, 5, 5)

year_of(d) := to_number(substring(d, 0, 4))

md_in_window(d, from_md, to_md) if {
	month_day(d) >= from_md
	month_day(d) <= to_md
}

wrrl_of(p) := object.get(p, "wrrl", {})

codes_of(p) := object.get(p, ["oepul", "codes"], [])

measures_of(p) := object.get(p, ["oepul", "measures"], [])

management_of(p) := object.get(p, "management", {})

applications_of(p) := object.get(wrrl_of(p), "n_applications", [])

crop_name_of(p) := object.get(wrrl_of(p), "gwsp_crop", object.get(p, ["crop", "crop_name"], null))

# Ackerflächen in der Gebietskulisse des Grundwasserschutzprogramms Graz bis Bad Radkersburg 2018.
area_arable_parcels[p.parcel_id] := p if {
	some p in parcels
	p.land_use == "arable"
	object.get(wrrl_of(p), "in_area", false) == true
}

is_fallow(p) if p.crop.crop_category == "fallow"

is_fallow(p) if object.get(p, ["crop", "crop_name"], "") in {"Grünbrache", "Brache"}

# Ackerfutterflächen im Sinne des ÖPUL 2023 (geschlossene Liste).
is_arable_forage(p) if object.get(p, ["crop", "crop_name"], "") in {x | some x in data.o6_24.oepul_definitionen.ackerfutter}

# Feldgemüse gemäß Tab. 3 der Anlage 3.
is_vegetable_tab3(p) if data.o6_24.gwsp_n_limits_gemuese.rows[crop_name_of(p)]

is_arable_tab2(p) if data.o6_24.gwsp_n_limits_acker.rows[crop_name_of(p)]
