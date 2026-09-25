# Gemeinsame Hilfsregeln für die ÖPUL-Maßnahme „Bewirtschaftung von Bergmähdern" (o6_4).
package oepul.o6_4

measure_id := "o6_4"

params := data.o6_4.general_parameters

year := input.farm.year

bm_code_set := {c.code | some c in data.o6_4.mowing_codes.codes}

mowing_year_codes := {c.code | some c in data.o6_4.mowing_codes.codes; c.mowing_year}

# Schläge, die im Mehrfachantrag der Maßnahme o6_4 zugeordnet sind.
enrolled_parcels[pid] := p if {
	some p in input.land.parcels
	some m in object.get(p, "oepul_measure_participation", [])
	m.measure_id == measure_id
	pid := p.parcel_id
}

# Betriebsbezogener Maßnahmendatensatz (Vertragsbeginn, Antragsdatum, Flächenhistorie ...).
measure_record := r if {
	some r in object.get(input.farm, ["oepul_participation", "measures"], [])
	r.measure_id == measure_id
}

default participation := {}

participation := object.get(input.farm, "oepul_participation", {})

date_ns(d) := time.parse_ns("2006-01-02", d)

date_parts(d) := time.date(date_ns(d))

# Datum (Monat, Tag) liegt vor dem gegebenen Kalendertag.
before_month_day(d, month, _) if date_parts(d)[1] < month

before_month_day(d, month, day) if {
	date_parts(d)[1] == month
	date_parts(d)[2] < day
}

cutting_dates_in_year(p, yr) := [d |
	some d in object.get(p, ["operations", "cutting_dates"], [])
	date_parts(d)[0] == yr
]

mowing_count(p) := count(cutting_dates_in_year(p, year))

mowed_this_year(p) if mowing_count(p) > 0

mowing_info(p) := object.get(p, ["operations", "mowing"], {})

# Vollflächige Mahd inklusive Verbringung des Mähgutes im laufenden Jahr.
valid_full_mowing_this_year(p) if {
	mowed_this_year(p)
	mowing_info(p).full_area == true
	mowing_info(p).mown_material_removed == true
	not mowing_info(p).mulched == true
	not mowing_info(p).mown_material_left_lying == true
}

mowed_previous_year(p) if count(cutting_dates_in_year(p, year - 1)) > 0

mowed_previous_year(p) if mowing_info(p).mowed_previous_year == true

parcel_bm_codes(p) := {c | some c in object.get(p, "oepul_codes", []); c in bm_code_set}

# Eindeutiger BM-Code des Schlages (undefiniert, wenn keiner oder mehrere angegeben sind).
parcel_bm_code(p) := c if {
	codes := parcel_bm_codes(p)
	count(codes) == 1
	some c in codes
}

code_method(code) := m if {
	some c in data.o6_4.mowing_codes.codes
	c.code == code
	m := c.mowing_method
}
