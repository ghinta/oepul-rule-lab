# Gemeinsame Hilfsfunktionen für ÖPUL 2023 "Tierwohl – Weide" (o6_20).
package oepul.o6_20.common

# Parametertabelle (Zeilen name/value) als Lookup.
params := {p.name: p.value | some p in data.o6_20.parameters}

catalog := data.o6_20.category_catalog

# Kategorientabelle (Zeilen mit category_code) als Lookup.
category_defs := {c.category_code: c | some c in catalog.categories}

tw := object.get(input, ["oepul_measures", "tierwohl_weide"], {})

year := input.farm.year

categories := object.get(tw, "categories", [])

animals := object.get(tw, "animals", [])

applied_category_codes := {c.category_code | some c in categories}

day_ns := 86400000000000

is_date(v) if {
	is_string(v)
	regex.match(`^[0-9]{4}-[0-9]{2}-[0-9]{2}$`, v)
}

date_ns(d) := time.parse_ns("2006-01-02", d)

md_date(y, md) := sprintf("%d-%s", [y, md])

# Anzahl Tage von a (inklusive) bis b (exklusive).
days_between(a, b) := round((date_ns(b) - date_ns(a)) / day_ns)

add_days(d, n) := time.format([time.add_date(date_ns(d), 0, 0, n), "UTC", "2006-01-02"])

# Weidezeitraum 1. April bis einschließlich 31. Oktober (= 214 Tage).
grazing_period_start(y) := md_date(y, params.grazing_period.start_month_day)

grazing_period_end(y) := md_date(y, params.grazing_period.end_month_day)

grazing_period_end_exclusive(y) := md_date(y, params.grazing_period.end_exclusive_month_day)

# Frist für Beilage "Tierwohl – Weide/Stallhaltung": 15. April, in 2023 und 2028 der 17. April.
beilage_deadline(y) := md_date(y, params.beilage_deadline_exception_month_day) if {
	y in params.beilage_deadline_exception_years
} else := md_date(y, params.beilage_deadline_month_day)

# Maßnahmenantrag bis 31. Dezember vor dem ersten Verpflichtungsjahr.
measure_application_deadline(funding_year) := md_date(funding_year - 1, params.measure_application_deadline_month_day)

# Bei doppelt angegebenen Kategorien zählt der erste Eintrag (Duplikate werden als Verstoß gemeldet).
first_category_index(code) := min({i | some i, c in categories; c.category_code == code})

category_entry(code) := categories[first_category_index(code)]

duplicate_category_codes contains code if {
	some i, c in categories
	code := c.category_code
	i != first_category_index(code)
}

category_def(code) := category_defs[code]

regime(code) := category_defs[code].reporting_regime

# Schafe/Ziegen, die zum Stichtag 1. April am Betrieb sind, müssen bis zur Beilagenfrist beantragt werden.
present_at_reference_date(a) if not is_date(object.get(a, "present_from", null))

present_at_reference_date(a) if a.present_from <= md_date(year, params.sheep_goat_reference_date_month_day)

sheep_goat_late_individual_application(a) if {
	regime(a.category_code) == "sheep_goat"
	present_at_reference_date(a)
	d := object.get(a, "application_date", null)
	is_date(d)
	d > beilage_deadline(year)
}
