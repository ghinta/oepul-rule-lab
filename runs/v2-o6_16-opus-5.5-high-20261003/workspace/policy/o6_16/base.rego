# Basisdefinitionen für ÖPUL 2023 – Vorbeugender Grundwasserschutz – Acker (Maßnahme 16 / 70-14).
# Gemeinsame Hilfsregeln: Antragsjahr, Gebietskulisse (Anhang G), Flächenaggregation, Prämiensätze.
package oepul.o6_16

import data.o6_16 as d

year := input.farm.year

parcels := object.get(input, ["land", "parcels"], [])

o16 := object.get(input, ["farm", "oepul", "o6_16"], {})

doc16 := object.get(input, ["documentation", "o6_16"], {})

participating_measures := {m | some m in object.get(input, ["farm", "oepul", "participating_measures"], [])}

# Anhang G: Gebietsabgrenzung nach Katastralgemeinden (KG-Nr.)
annex_g_kg_numbers := {r.kg_number | some r in d.annex_g_cadastral_communities}

annex_g_state_by_kg[r.kg_number] := r.federal_state if {
	some r in d.annex_g_cadastral_communities
}

parcel_codes(p) := {c | some c in object.get(p, "codes", [])}

parcel_crop_name(p) := object.get(p, ["crop", "crop_name"], "")

is_arable(p) if p.land_use == "arable"

# Ackerfläche innerhalb der Gebietskulisse gemäß Anhang G
parcel_in_area(p) if {
	is_arable(p)
	object.get(p, "kg_number", "") in annex_g_kg_numbers
}

parcel_area_state(p) := annex_g_state_by_kg[p.kg_number] if parcel_in_area(p)

area_parcels := [p | some p in parcels; parcel_in_area(p)]

arable_parcels := [p | some p in parcels; is_arable(p)]

gwa_arable_area_ha := sum([p.area_ha | some p in area_parcels])

total_arable_area_ha := sum([p.area_ha | some p in arable_parcels])

wien_area_parcels := [p | some p in area_parcels; parcel_area_state(p) == "Wien"]

wien_arable_area_ha := sum([p.area_ha | some p in wien_area_parcels])

upper_austria_area_parcels := [p | some p in area_parcels; parcel_area_state(p) == "Oberösterreich"]

is_ag_parcel(p) if "AG" in parcel_codes(p)

is_cul_parcel(p) if "CUL" in parcel_codes(p)

# Code OP bzw. maßnahmenbezogener OP-Code: keine Prämie im jeweiligen Förderjahr
parcel_has_op_code(p) if "OP" in parcel_codes(p)

parcel_has_op_code(p) if "OPGWA" in parcel_codes(p)

participates(measure) if measure in participating_measures

commitment_start_year := object.get(o16, "commitment_start_year", null)

first_commitment_year if year == commitment_start_year

# Prämiensatz je Komponente und Antragsjahr (Kapitel 6 Informationsblatt / SRL 2.16)
rate_record(component) := r if {
	some r in d.premium_rates
	r.component == component
}

rate_value(r) := r.rate_2023 if year == 2023

rate_value(r) := r.rate_2024 if year == 2024

rate_value(r) := r.rate_from_2025 if year >= 2025

rate(component) := v if {
	v := rate_value(rate_record(component))
	v != null
}

rate(component) := 0 if {
	v := rate_value(rate_record(component))
	v == null
}

month_day(date) := substring(date, 5, 5)

date_year(date) := to_number(substring(date, 0, 4))

ceil_div(x, y) := ceil(x / y)

min_of(a, b) := a if a <= b

min_of(a, b) := b if a > b

max_of(a, b) := a if a >= b

max_of(a, b) := b if a < b
