# METADATA
# title: ÖPUL 2023 – Einsatz von Nützlingen im geschützten Anbau (o6_13)
# description: >-
#   Gemeinsame Hilfsregeln und Parameter. Die Parameter stammen aus data/o6_13/*.json.
package oepul.o6_13

measure_code := "o6_13"

measure_number := "13"

params := data.o6_13.measure

general := data.o6_13.general

notices := data.o6_13.notices_2026

year := input.farm.year

parcels := object.get(input, ["land", "parcels"], [])

# Maßnahmenbezogener Zustand (vorgeschlagene Profilerweiterung farm.oepul.o6_13)
state := object.get(input, ["farm", "oepul", "o6_13"], {})

applicant := object.get(input, ["farm", "applicant"], {})

# Jahres-Präfix für ISO-Datumsangaben (YYYY-MM-DD)
year_prefix(y) := sprintf("%d-", [y])

date_in_year(d, y) if {
	is_string(d)
	startswith(d, year_prefix(y))
}

# ISO-Datum aus Jahr und "MM-DD"
iso_date(y, month_day) := sprintf("%d-%s", [y, month_day])

round2(x) := round(x * 100) / 100

round4(x) := round(x * 10000) / 10000

coalesce(x, fallback) := x if {
	x != null
} else := fallback

is_true(obj, key) if object.get(obj, key, false) == true

is_false(obj, key) if object.get(obj, key, null) == false

# Wert aus einer Jahrestabelle (year_from/year_to, year_to = null = offen)
year_row_matches(row, y) if {
	row.year_from <= y
	row.year_to == null
}

year_row_matches(row, y) if {
	row.year_from <= y
	row.year_to != null
	y <= row.year_to
}
