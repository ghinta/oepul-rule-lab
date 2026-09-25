# METADATA
# title: ÖPUL 2023 – Erhaltung gefährdeter Nutztierrassen (o6_5) – gemeinsame Hilfsregeln
# description: >-
#   Datums-, Nachschlage- und Eingabehilfen für die Maßnahme o6_5.
#   Tabellen werden aus data.o6_5 (data/o6_5/*.json) gelesen.
package oepul.o6_5

ns_per_day := 86400000000000

params := data.o6_5.parameters

# Antragsjahr (Förderjahr) aus dem Canonical Farm Profile.
year := input.farm.year

parse_date(s) := time.parse_ns("2006-01-02", s)

# Datum aus Jahr und "MM-DD" bilden.
date_of(y, md) := parse_date(concat("-", [format_int(y, 10), md]))

# Ganze Kalendertage von a bis b (beide in ns).
days_between_ns(a, b) := (b - a) / ns_per_day

val(obj, key) := object.get(obj, key, null)

animals := object.get(input, ["livestock", "endangered_breed_animals"], [])

animal_by_id := {a.animal_id: a | some a in animals}

category_meta := {c.category: c | some c in data.o6_5.animal_categories}

breed_meta := {b.breed: b | some b in data.o6_5.breeds}

species_of(a) := category_meta[a.animal_category].species

participation := object.get(input, ["oepul_participation", "o6_5"], {})

applicant := object.get(input, ["farm", "applicant"], {})

# O6_5-DEF-STICHTAG: Stichtag grundsätzlich 01.04. des Antragsjahres.
stichtag_ns := date_of(year, params.stichtag_md)

# Jahresspezifische Festlegungen (z. B. Dürre 2026).
year_override := o if {
	some o in data.o6_5.year_specific_overrides
	o.year == year
}

# O6_5-OBL-HOLDING-PERIOD / O6_5-2026-HOLDING-PERIOD-AUG31
holding_end_md := year_override.holding_period_end_md if {
	year_override.holding_period_end_md
} else := params.holding_period_end_md

holding_start_ns := date_of(year, params.holding_period_start_md)

holding_end_ns := date_of(year, holding_end_md)

is_cattle(a) if species_of(a) == "cattle"

is_female(a) if category_meta[a.animal_category].sex == "female"

is_male(a) if category_meta[a.animal_category].sex == "male"

# O6_5-DEF-REPLACEMENT-ANIMAL: Ersatztier (Nachbesetzung eines abgegangenen Tieres).
is_replacement(a) if val(a, "replaces_animal_id") != null

# Bezugsdatum für die Kategorieanforderungen: Stichtag 01.04. bzw. 31.05.;
# Ersatztiere müssen die Anforderungen (spätestens) zum Zeitpunkt der
# Nachbesetzung erfüllen (siehe notes/assumptions.md, A-03).
requirement_ref_ns(a) := max([date_of(year, category_meta[a.animal_category].reference_md), parse_date(a.replacement_date)]) if {
	is_replacement(a)
	a.replacement_date != null
} else := date_of(year, category_meta[a.animal_category].reference_md)

departure_date_ns(a) := parse_date(a.departure.date) if {
	a.departure.date != null
}

# Meldung innerhalb von n Kalendertagen ab dem Ereignis (Tag des Ereignisses = Tag 0).
reported_within(reported, event_ns, n) if {
	reported != null
	r := parse_date(reported)
	r >= event_ns
	days_between_ns(event_ns, r) <= n
}
