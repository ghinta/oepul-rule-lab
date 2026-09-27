# METADATA
# title: ÖPUL 2023 Naturschutz (18) – gemeinsame Hilfsfunktionen
# description: Zugriff auf Daten (Anhang I/J/L, Parameter) und Eingabe-Normalisierung.
package oepul.o6_18.lib

params := data.o6_18.parameters

auflagen := data.o6_18.annex_i.auflagen

year := input.farm.year

measures := object.get(input, ["farm", "oepul", "measures"], [])

monitoring_options := object.get(input, ["farm", "oepul", "ubb_bio_monitoring_options"], [])

nat := object.get(input, ["farm", "oepul", "naturschutz"], {})

parcels := object.get(input, ["land", "parcels"], [])

# Anhang I: Nachschlagen einer Auflage über Hauptcode oder Alias (z. B. GE01/BC01).
auflage_by_code[code] := a if {
	some a in auflagen
	code := a.code
}

auflage_by_code[code] := a if {
	some a in auflagen
	some code in a.aliases
}

participates(m) if m in measures

participates_ubb_or_bio if participates("1A")

participates_ubb_or_bio if participates("1B")

codes(p) := object.get(p, ["oepul", "codes"], [])

has_code(p, c) if c in codes(p)

is_nat(p) if has_code(p, "NAT")

nat_parcels := [p | some p in parcels; is_nat(p)]

pc(p) := object.get(p, ["naturschutz", "project_confirmation"], {})

auflagen_of(p) := object.get(pc(p), "auflagen", [])

has_auflage(p, c) if c in auflagen_of(p)

has_any_auflage(p, cs) if {
	some c in cs
	has_auflage(p, c)
}

ns(p) := object.get(p, "naturschutz", {})

area(p) := object.get(p, "area_ha", 0)

cutting_dates(p) := object.get(p, ["operations", "cutting_dates"], [])

grazing_periods(p) := object.get(ns(p), "grazing_periods", [])

fertilization_events(p) := object.get(ns(p), "fertilization_events", [])

is_grazed(p) if count(grazing_periods(p)) > 0

fertilized(p) if count(fertilization_events(p)) > 0

fertilized(p) if object.get(p, ["operations", "fertilizer", "mineral_n_kg_per_ha"], 0) > 0

fertilized(p) if object.get(p, ["operations", "fertilizer", "organic_n_kg_per_ha"], 0) > 0

mineral_fertilized(p) if object.get(p, ["operations", "fertilizer", "mineral_n_kg_per_ha"], 0) > 0

mineral_fertilized(p) if {
	some e in fertilization_events(p)
	e.type == "mineral"
}

# Kapitelbuchstabe gemäß Anhang J (T zählt zu A).
chapter_of(code) := data.o6_18.annex_j.chapter_letter_map[substring(code, 0, 1)]

# Prämiensatz (Euro/ha) einer Auflage im Antragsjahr y.
rate_for(code, y) := r.eur_per_ha if {
	a := auflage_by_code[code]
	some r in a.rates
	r.from_year <= y
	y <= r.to_year
}

valid_in_year(code, y) if {
	a := auflage_by_code[code]
	a.valid_from_year <= y
	y <= a.valid_to_year
}

# Wert aus einer Jahrestabelle [{from_year,to_year,eur}] für Jahr y.
year_value(table, y) := row.eur if {
	some row in table
	row.from_year <= y
	y <= row.to_year
}

sorted_cuts(p) := sort(cutting_dates(p))

first_cut(p) := sorted_cuts(p)[0] if count(cutting_dates(p)) > 0

last_cut(p) := sorted_cuts(p)[count(cutting_dates(p)) - 1] if count(cutting_dates(p)) > 0

days_between(a, b) := (time.parse_ns("2006-01-02", b) - time.parse_ns("2006-01-02", a)) / ((24 * 60) * 60e9)

max2(a, b) := a if a >= b

max2(a, b) := b if b > a

min2(a, b) := a if a <= b

min2(a, b) := b if b < a
