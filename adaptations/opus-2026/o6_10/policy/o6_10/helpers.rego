# ÖPUL 2023 – Erosionsschutz Wein, Obst und Hopfen (o6_10) – Hilfsfunktionen
# Gemeinsame Konstanten, Datenzugriffe und Datums-/Flächenfunktionen.
package oepul.o6_10

# Datentabellen (data/o6_10/*.json)
params := data.o6_10.programme_parameters

defs := data.o6_10.definitions

rates := data.o6_10.premium_rates

year := input.farm.year

parcels := object.get(input, ["land", "parcels"], [])

o610 := object.get(input, ["farm", "oepul", "o6_10"], {})

participating_measures := {m | some m in object.get(input, ["farm", "oepul", "participating_measures"], [])}

nanos_per_day := ((24 * 60) * 60) * 1000000000

# Datum (YYYY-MM-DD) in Nanosekunden
date_ns(d) := time.parse_ns("2006-01-02", d)

# Datum aus Jahr und "MM-DD"
md_ns(y, md) := date_ns(sprintf("%04d-%s", [y, md]))

year_of(d) := time.date(date_ns(d))[0]

min_num(a, b) := a if a <= b

else := b

max_num(a, b) := a if a >= b

else := b

parcel_codes(p) := {c | some c in object.get(p, "oepul_codes", [])}

parcel_measures(p) := {m | some m in object.get(p, "oepul_measures", [])}

parcel_area(p) := object.get(p, "area_ha", 0)

# Neigung (fehlend/null => 0 %, siehe notes/assumptions.md)
slope_of(p) := s if {
	s := object.get(p, "slope_percent", null)
	s != null
}

else := 0

# Deklarierte Dauerkulturart; Rückfall auf crop.crop_category des Canonical Profile
declared_crop_type(p) := t if {
	t := object.get(p, ["permanent_crop", "type"], null)
	t != null
}

else := "vine" if {
	p.crop.crop_category == "vineyard"
}

else := "fruit" if {
	p.crop.crop_category == "orchard"
}

else := "hop" if {
	p.crop.crop_category == "hop"
}

else := "none"

# O610-ELIG-TERRACE-SLOPE: Terrassen nur mit mind. 25 % durchschnittlicher Hangneigung;
# darunter wird die Fläche als normale Weinfläche behandelt (Annahme A-03).
effective_crop_type(p) := "vine" if {
	declared_crop_type(p) == "vine_terrace"
	slope_of(p) < params.terrace_min_avg_slope_percent
}

else := declared_crop_type(p)

is_terrace(p) if effective_crop_type(p) == "vine_terrace"

eligible_crop_types := {t.type | some t in defs.eligible_crop_types}

premium_group(p) := t.premium_group if {
	some t in defs.eligible_crop_types
	t.type == effective_crop_type(p)
}

default premium_group_of_type(_) := "none"

premium_group_of_type(ct) := t.premium_group if {
	some t in defs.eligible_crop_types
	t.type == ct
}
