# ÖPUL 2023 – Wasserrahmenrichtlinie – Landwirtschaft (o6_24) – gemeinsame Hilfsregeln
# Eingabezugriffe und Hilfsfunktionen für die Maßnahme 24.
package oepul.o6_24

measure_code := "24"

cfg := data.o6_24.general

thresholds := cfg.thresholds

year := input.farm.year

parcels := object.get(input, ["land", "parcels"], [])

participation := object.get(input, ["participation", "o6_24"], {})

# Maßnahmenbezogene Parzellenangaben (vorgeschlagene Profilerweiterung land.parcels[].wrrl_o6_24).
wrrl(p) := object.get(p, "wrrl_o6_24", {})

parcel_codes(p) := {c | some c in object.get(p, "oepul_codes", [])}

parcel_measures(p) := {m | some m in object.get(p, "measures", [])}

parcel_is_arable(p) if p.land_use == "arable"

parcel_in_area(p) if wrrl(p).in_area == true

parcel_is_fallow(p) if p.crop.crop_category == "fallow"

parcel_has_increased_n_permit(p) if wrrl(p).increased_n_permit == true

parcel_declared_for_measure(p) if measure_code in parcel_measures(p)

crop_name(p) := object.get(p, ["crop", "crop_name"], "")

parcel_is_ackerfutter(p) if crop_name(p) in {c | some c in cfg.ackerfutter_crops}

# Arable parcels inside the Gebietskulisse "Grundwasserschutzprogramm Graz bis Bad Radkersburg 2018".
arable_parcels_in_area := [p |
	some p in parcels
	parcel_is_arable(p)
	parcel_in_area(p)
]

arable_area_in_area_ha := sum([p.area_ha | some p in arable_parcels_in_area])

# Year-dependent lookup: row valid for year y (to_year null = open ended).
valid_for_year(row, y) if {
	row.from_year <= y
	row.to_year == null
}

valid_for_year(row, y) if {
	row.from_year <= y
	row.to_year != null
	y <= row.to_year
}

# Fristenzeile aus data.o6_24.general.deadlines.
deadline(id) := row if {
	some row in cfg.deadlines
	row.id == id
}

round2(x) := round(x * 100) / 100

date_ns(d) := time.parse_ns("2006-01-02", d)

date_string(y, m, d) := sprintf("%04d-%02d-%02d", [y, m, d])
