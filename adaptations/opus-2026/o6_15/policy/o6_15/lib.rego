# Hilfsfunktionen und Datenzugriffe für ÖPUL 2023 – Tierwohl – Behirtung (o6_15).
package oepul.o6_15

params := data.o6_15.measure_parameters

rates := data.o6_15.premium_rates

rgve_rows := data.o6_15.rgve_key.rows

reductions := data.o6_15.reductions

day_ns := 86400000000000

year := input.farm.year

alms := object.get(object.get(input, "alpine_farming", {}), "alms", [])

herding_application := object.get(object.get(input, "alpine_farming", {}), "herding_application", {})

date_ns(d) := time.parse_rfc3339_ns(sprintf("%sT00:00:00Z", [d]))

month_day_ns(y, md) := date_ns(sprintf("%d-%s", [y, md]))

july_first_ns := month_day_ns(year, "07-01")

# Stichtag 1. Juli minus n Monate
reference_minus_months_ns(months) := time.add_date(july_first_ns, 0, 0 - months, 0)

days_between(from, to) := round((date_ns(to) - date_ns(from)) / day_ns)

min_of(a, b) := a if a <= b

min_of(a, b) := b if b < a

max_of(a, b) := a if a >= b

max_of(a, b) := b if b > a

round2(x) := round(x * 100) / 100

# Alter am Stichtag 1. Juli in vollen Monaten mindestens `months`
age_at_least_months(birth_date, months) if {
	date_ns(birth_date) <= reference_minus_months_ns(months)
}

# ---------------------------------------------------------------------------
# RGVE-Schlüssel (Kapitel 10 Informationsblatt, Anhang A SRL)
# ---------------------------------------------------------------------------

rgve_row_by_id(category_id) := row if {
	some row in rgve_rows
	row.id == category_id
}

animal_species(a) := a.species

animal_is_dwarf(a) if object.get(a, "is_dwarf_breed", false) == true

animal_is_dwarf(a) if object.get(a, "breed", "") in data.o6_15.annex_a_gve_key.dwarf_cattle_breeds

animal_equid_size(a) := "large" if {
	a.species == "equid"
	object.get(a, "equid_large_breed", false) == true
}

animal_equid_size(a) := "small" if {
	a.species == "equid"
	object.get(a, "equid_large_breed", false) == false
}

animal_equid_size(a) := null if a.species != "equid"

row_matches_age(row, birth_date) if {
	age_at_least_months(birth_date, row.min_age_months)
	row.max_age_months_exclusive == null
}

row_matches_age(row, birth_date) if {
	age_at_least_months(birth_date, row.min_age_months)
	row.max_age_months_exclusive != null
	not age_at_least_months(birth_date, row.max_age_months_exclusive)
}

derived_rgve_category(a) := row.id if {
	some row in rgve_rows
	row.species == a.species
	row.dwarf_breed == animal_is_dwarf_bool(a)
	row.equid_size == animal_equid_size(a)
	row_matches_age(row, a.birth_date)
}

animal_is_dwarf_bool(a) if animal_is_dwarf(a)

animal_is_dwarf_bool(a) := false if not animal_is_dwarf(a)

# Explizit angegebene Kategorie hat Vorrang, sonst Ableitung aus Geburtsdatum
animal_rgve_category(a) := a.rgve_category if {
	object.get(a, "rgve_category", null) != null
}

animal_rgve_category(a) := derived_rgve_category(a) if {
	object.get(a, "rgve_category", null) == null
	object.get(a, "birth_date", null) != null
}

animal_rgve_factor(a) := rgve_row_by_id(animal_rgve_category(a)).rgve_per_head

animal_count(a) := object.get(a, "count", 1)

reporting_rule(species) := r if {
	some r in params.reporting_rules
	r.species == species
}
