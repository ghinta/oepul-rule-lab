# Gemeinsame Hilfsfunktionen für ÖPUL 2023 „Tierwohl – Stallhaltung Rinder“ (o6_21).
package oepul.o6_21

import rego.v1

params := data.o6_21.parameters

space := data.o6_21.space_requirements

day_ns := 86400000000000

far_future_ns := time.parse_ns("2006-01-02", "2200-01-01")

measure_year := input.farm.year

year_start_ns := time.parse_ns("2006-01-02", sprintf("%d-01-01", [measure_year]))

year_end_excl_ns := time.add_date(year_start_ns, 1, 0, 0)

days_in_year := (year_end_excl_ns - year_start_ns) / day_ns

date_ns(d) := time.parse_ns("2006-01-02", d)

overlap_days(s1, e1, s2, e2) := d if {
	s := max([s1, s2])
	e := min([e1, e2])
	e > s
	d := (e - s) / day_ns
} else := 0

o6_21_input := object.get(input, ["oepul", "o6_21"], {})

applied_categories := {c | some c in object.get(o6_21_input, "applied_categories", [])}

composting_supplement_applied if o6_21_input.composting_supplement_applied == true

cattle := object.get(input, ["livestock", "cattle_animals"], [])

pens := object.get(input, ["livestock", "stall_pens"], [])

stall_buildings := object.get(input, ["livestock", "stall_buildings"], [])

categories_by_id := {c.id: c | some c in data.o6_21.categories}

pens_by_id := {p.pen_id: p | some p in pens}

buildings_by_id := {b.stall_id: b | some b in stall_buildings}

# O6_21-CAT-001: nur die vier geschlossen aufgezählten Tierkategorien sind wählbar.
unknown_applied_categories := {c | some c in applied_categories; not categories_by_id[c]}

birth_ns(a) := date_ns(a.birth_date)

on_farm_from_ns(a) := date_ns(a.on_farm_from) if is_string(a.on_farm_from)

else := birth_ns(a)

on_farm_until_ns(a) := date_ns(a.on_farm_until) if is_string(a.on_farm_until)

else := far_future_ns

presence_start_ns(a) := max([year_start_ns, birth_ns(a), on_farm_from_ns(a)])

presence_end_ns(a) := min([year_end_excl_ns, on_farm_until_ns(a)])

age_offset_ns(a, months) := time.add_date(birth_ns(a), 0, months, 0)

age_limit_ns(a, months) := age_offset_ns(a, months) if is_number(months)

else := far_future_ns

# O6_21-HOUS-003 / O6_21-HOUS-004 / O6_21-HOUS-005: Verpflichtungsfenster je Tier und Kategorie
# (ab Geburt bzw. ab ½ Jahr bzw. ab Zukauf, bis ½ Jahr, 2 Jahre, Abgang oder 31.12.).
obligation_window(a, cat) := [s, e] if {
	a.sex == cat.sex
	s := max([presence_start_ns(a), age_offset_ns(a, cat.min_age_months)])
	e := min([presence_end_ns(a), age_limit_ns(a, cat.max_age_months_exclusive)])
	e > s
}

# O6_21-RGVE-003: Zwergrinder (Dahomey, Dexter, Kerry, Zwergzebu).
is_dwarf(a) if a.is_dwarf_breed == true

is_dwarf(a) if a.breed in data.o6_21.rgve_key.dwarf_breeds

# O6_21-RGVE-001: RGVE-Schlüssel.
band_factor(band, a) := band.rgve_dwarf if is_dwarf(a)

else := band.rgve_standard

# O6_21-RGVE-002 / O6_21-PREM-003: anteilige RGVE (Jahresdurchschnitt) je Tier und Kategorie.
animal_category_rgve(a, cat) := r if {
	w := obligation_window(a, cat)
	weighted := [x |
		some band in data.o6_21.rgve_key.age_bands
		d := overlap_days(w[0], w[1], age_offset_ns(a, band.min_age_months), age_limit_ns(a, band.max_age_months_exclusive))
		x := band_factor(band, a) * d
	]
	r := sum(weighted) / days_in_year
}

round2(x) := round(x * 100) / 100
