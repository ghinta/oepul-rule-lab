# Gemeinsame Hilfsfunktionen für ÖPUL 2023 – Tierwohl – Stallhaltung Rinder (o6_21).
# Datumswerte werden als "YYYY-MM-DD" erwartet.
package oepul.o6_21.lib

day_ns := 86400000000000

tables := data.o6_21

thresholds := tables.thresholds

deadlines := tables.deadlines

measure_input := object.get(input, ["oepul_measures", "o6_21"], {})

year := input.farm.year

parse_date(d) := time.parse_ns("2006-01-02", d)

year_start_ns(y) := parse_date(sprintf("%d-01-01", [y]))

year_end_ns(y) := parse_date(sprintf("%d-12-31", [y]))

days_in_year := round((year_end_ns(year) - year_start_ns(year)) / day_ns) + 1

date_year(d) := time.date(parse_date(d))[0]

# Rundung auf vier Nachkommastellen, um Gleitkomma-Artefakte bei Flächenvergleichen zu vermeiden.
r4(x) := round(x * 10000) / 10000

# Rundung auf zwei Nachkommastellen (Euro-Beträge).
r2(x) := round(x * 100) / 100

# Inklusive Tagesüberlappung zweier Intervalle [a1, a2] und [b1, b2] in Nanosekunden.
overlap_days(a1, a2, b1, b2) := d if {
	s := max([a1, b1])
	e := min([a2, b2])
	e >= s
	d := round((e - s) / day_ns) + 1
}

overlap_days(a1, a2, b1, b2) := 0 if {
	max([a1, b1]) > min([a2, b2])
}

days_between(from_date, to_date) := round((parse_date(to_date) - parse_date(from_date)) / day_ns)

# Altersgrenzen eines Tieres (½ Jahr und 2 Jahre ab Geburt).
half_year_ns(animal) := time.add_date(parse_date(animal.birth_date), 0, 6, 0)

two_years_ns(animal) := time.add_date(parse_date(animal.birth_date), 2, 0, 0)

# Obergrenze innerhalb des int64-Nanosekundenbereichs.
far_future_ns := parse_date("2200-12-31")

age_band_interval(animal, "lt_half_year") := [parse_date(animal.birth_date), half_year_ns(animal) - day_ns]

age_band_interval(animal, "half_to_2_years") := [half_year_ns(animal), two_years_ns(animal) - day_ns]

age_band_interval(animal, "ge_2_years") := [two_years_ns(animal), far_future_ns]

# Anwesenheit des Tieres am Betrieb im Förderjahr (taggenau laut Rinderdatenbank).
presence_start_ns(animal) := max([year_start_ns(year), parse_date(animal.on_farm_from)])

presence_end_ns(animal) := min([year_end_ns(year), parse_date(animal.on_farm_until)]) if {
	is_string(object.get(animal, "on_farm_until", null))
}

presence_end_ns(animal) := year_end_ns(year) if {
	not is_string(object.get(animal, "on_farm_until", null))
}

band_days(animal, band) := overlap_days(
	presence_start_ns(animal),
	presence_end_ns(animal),
	age_band_interval(animal, band)[0],
	age_band_interval(animal, band)[1],
)

is_dwarf(animal) := object.get(animal, "is_dwarf_breed", false)

rgve_factor(band, dwarf) := f if {
	some row in tables.rgve_key
	row.age_band == band
	row.dwarf_breed == dwarf
	f := row.rgve_per_head
}

# Anteilige RGVE eines Tieres in einer Altersstufe (Jahresdurchschnitt).
band_rgve(animal, band) := (band_days(animal, band) * rgve_factor(band, is_dwarf(animal))) / days_in_year

category_def(cat_id) := c if {
	some c in tables.animal_categories
	c.category_id == cat_id
}

animal_in_category(animal, cat_id) if {
	category_def(cat_id).sex == animal.sex
}

category_rgve(animal, cat_id) := sum([band_rgve(animal, band) | some band in category_def(cat_id).age_bands])

category_days(animal, cat_id) := sum([band_days(animal, band) | some band in category_def(cat_id).age_bands])

rate(rate_id, y) := r.eur_per_rgve if {
	some r in tables.premium_rates
	r.rate_id == rate_id
	r.valid_from_year <= y
	r.valid_to_year == null
}

rate(rate_id, y) := r.eur_per_rgve if {
	some r in tables.premium_rates
	r.rate_id == rate_id
	r.valid_from_year <= y
	r.valid_to_year != null
	y <= r.valid_to_year
}

space_row_for_weight(w) := row if {
	some row in tables.space_requirements
	weight_above_min(row, w)
	weight_below_max(row, w)
}

weight_above_min(row, _) if row.min_weight_kg_exclusive == null

weight_above_min(row, w) if {
	row.min_weight_kg_exclusive != null
	w > row.min_weight_kg_exclusive
}

weight_below_max(row, _) if row.max_weight_kg_inclusive == null

weight_below_max(row, w) if {
	row.max_weight_kg_inclusive != null
	w <= row.max_weight_kg_inclusive
}

assessment_date := object.get(measure_input, "assessment_date", sprintf("%d-12-31", [year]))

age_days_at(animal, d) := round((parse_date(d) - parse_date(animal.birth_date)) / day_ns)

age_under_half_year_at(animal, d) if {
	parse_date(d) < half_year_ns(animal)
}

modulation_factor(area) := 1 if area <= 0

modulation_factor(area) := f if {
	area > 0
	parts := [part |
		some band in tables.modulation_bands
		upper := band_upper(band, area)
		upper > band.from_ha_exclusive
		part := (upper - band.from_ha_exclusive) * band.payout_share
	]
	f := sum(parts) / area
}

band_upper(band, area) := area if band.to_ha_inclusive == null

band_upper(band, area) := min([area, band.to_ha_inclusive]) if band.to_ha_inclusive != null
