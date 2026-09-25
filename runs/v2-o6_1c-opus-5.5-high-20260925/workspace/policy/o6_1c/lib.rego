# Gemeinsame Hilfsfunktionen und Eingabezugriffe für ÖPUL 2023 – Maßnahme 1C
# „Nichtproduktive Ackerflächen und Agroforststreifen".
package oepul.o6_1c

params := data.o6_1c.measure_parameters

year := input.farm.year

# ISO-Datum (YYYY-MM-DD) für einen Monat/Tag im Antragsjahr bzw. einem beliebigen Jahr.
date_in_year(month_day) := sprintf("%d-%s", [year, month_day])

date_of(y, month_day) := sprintf("%d-%s", [y, month_day])

default arable_area_ha := 0

arable_area_ha := input.land.arable_area_ha

default total_area_ha := 0

total_area_ha := input.land.total_area_ha

parcels := object.get(input, ["land", "parcels"], [])

agroforestry_strips := object.get(input, ["land", "agroforestry_strips"], [])

feldstuecke := object.get(input, ["land", "feldstuecke"], [])

participations := object.get(input, ["farm", "oepul", "measure_participations"], [])

applicant := object.get(input, ["farm", "applicant"], {})

oepul := object.get(input, ["farm", "oepul"], {})

parcel_codes(p) := object.get(p, "oepul_codes", [])

parcel_status(p) := object.get(p, "oepul_status", {})

# Teilnahme an einer Maßnahme (unabhängig von Kategorie/Option), sofern im Antragsjahr nicht abgemeldet.
participates(code) if {
	some p in participations
	p.measure_code == code
	not deregistered_in_year(p)
}

participation_in_category(code, category) if {
	some p in participations
	p.measure_code == code
	object.get(p, "category", null) == category
	not deregistered_in_year(p)
}

deregistered_in_year(p) if {
	d := object.get(p, "deregistration_date", null)
	d != null
	d >= date_in_year("01-01")
	d <= date_in_year("12-31")
}

sum_area(items) := sum([object.get(i, "area_ha", 0) | some i in items])

min_of(a, b) := a if a <= b

min_of(a, b) := b if a > b

max_of(a, b) := a if a >= b

max_of(a, b) := b if a < b
