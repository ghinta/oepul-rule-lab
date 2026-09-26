package oepul.o6_14

# Gemeinsame Hilfsfunktionen und Eingabezugriffe fuer die Massnahme
# "Almbewirtschaftung" (o6_14).

year := input.farm.year

af := object.get(input, "alpine_farming", {})

alms := object.get(af, "alms", [])

animals := object.get(af, "animals", [])

measure_input := object.get(af, "measure", {})

nata_input := object.get(af, "nature_conservation_supplement", {})

awp_input := object.get(af, "grazing_plan_supplement", {})

participating_measures := object.get(object.get(input.farm, "oepul", {}), "participating_measures", [])

rgve_key := data.o6_14.rgve_key

rates := data.o6_14.premium_rates

proc := data.o6_14.procedure

combos := data.o6_14.combinations

day_ns := 86400000000000

date_ns(s) := time.parse_ns("2006-01-02", s)

day_number(s) := round(date_ns(s) / day_ns)

days_between(a, b) := round((date_ns(b) - date_ns(a)) / day_ns)

on_or_before(a, b) if date_ns(a) <= date_ns(b)

after(a, b) if date_ns(a) > date_ns(b)

is_true(obj, key) if object.get(obj, key, false) == true

is_false(obj, key) if object.get(obj, key, true) == false

# Jahresabhaengige Fristen (inkl. Ausnahmejahre 2023 und 2028).
deadline_date(deadline_id, y) := d if {
	some row in proc.annual_deadlines
	row.deadline_id == deadline_id
	y in row.exception_years
	d := sprintf("%d-%s", [y, row.exception_month_day])
}

deadline_date(deadline_id, y) := d if {
	some row in proc.annual_deadlines
	row.deadline_id == deadline_id
	not exception_year(row, y)
	d := sprintf("%d-%s", [y, row.month_day])
}

exception_year(row, y) if y in row.exception_years

nata_applied if is_true(nata_input, "applied")

awp_applied if is_true(awp_input, "applied")

alm_by_id[id] := alm if {
	some alm in alms
	id := alm.alm_id
}

animal_by_id[id] := a if {
	some a in animals
	id := a.animal_id
}

participates_in(measure) if measure in participating_measures

round2(x) := round(x * 100) / 100

# Einstiegsgrenzen je Massnahme/Zuschlag (data.o6_14.procedure.last_entry).
last_entry(item) := row if {
	some row in proc.last_entry
	row.item == item
}
