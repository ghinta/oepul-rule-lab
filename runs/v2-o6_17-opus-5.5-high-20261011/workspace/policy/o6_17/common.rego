# METADATA
# title: ÖPUL 2023 – Humuserhalt und Bodenschutz auf umbruchsfähigem Grünland (o6_17) – gemeinsame Hilfsregeln
# description: >-
#   Gemeinsame Eingaben, Datentabellen und Hilfsfunktionen für die Maßnahme
#   o6_17 (Intervention 70-15). Alle Tabellen stammen aus data/o6_17/*.json.
package oepul.o6_17

# Datentabellen der Maßnahme (data/o6_17/*.json)
cfg := data.o6_17

# Antragsjahr (Kalenderjahr der Umsetzung, § 21 Abs. 5 GSP-AV)
application_year := input.farm.year

# Maßnahmenspezifische Angaben (vorgeschlagener Profilzweig oepul.o6_17)
o617 := object.get(input, ["oepul", "o6_17"], {})

# Optionaler Bewertungsstichtag (vorgeschlagener Profilzweig oepul.evaluation_date)
evaluation_date := object.get(input, ["oepul", "evaluation_date"], null)

participating_measures := {m | some m in object.get(input, ["oepul", "participating_measures"], [])}

parcels := object.get(input, ["land", "parcels"], [])

parcel_codes(p) := {c | some c in object.get(p, "codes", [])}

is_grassland(p) if p.land_use == "grassland"

# Zeile der Schlagnutzungsart (Grünland) aus data/o6_17/lists.json
field_use_row(p) := row if {
	some row in cfg.lists.grassland_field_use_types
	row.key == object.get(p, "field_use_type", "")
}

field_use_attr(p, attr) := row[attr] if {
	row := field_use_row(p)
}

arable_forage_keys := {r.key | some r in cfg.lists.arable_forage_field_uses}

is_arable_forage(p) if {
	p.land_use == "arable"
	object.get(p, "field_use_type", "") in arable_forage_keys
}

# Gültigkeitszeitraum einer Tabellenzeile (from_year/to_year, to_year null = offen)
year_in_range(y, row) if {
	row.from_year <= y
	row.to_year == null
}

year_in_range(y, row) if {
	row.from_year <= y
	is_number(row.to_year)
	y <= row.to_year
}

value_at_least(_, lower) if lower == null

value_at_least(v, lower) if {
	is_number(lower)
	v >= lower
}

value_below(_, upper) if upper == null

value_below(v, upper) if {
	is_number(upper)
	v < upper
}

# Frist abgelaufen: entweder Bewertungsstichtag nach der Frist oder Antragsjahr nach dem Fristjahr
deadline_passed(deadline) if {
	is_string(evaluation_date)
	evaluation_date > deadline
}

deadline_passed(deadline) if {
	not is_string(evaluation_date)
	application_year > to_number(substring(deadline, 0, 4))
}

ubb_or_bio_participation if {
	some m in cfg.lists.combination_obligation_measures
	m in participating_measures
}

# Flächen mit Umbruchsverbot gemäß GLÖZ 2, GLÖZ 4 oder GLÖZ 9
gloez_conversion_ban(p) if {
	some t in cfg.lists.gloez_conversion_ban_types
	object.get(p, ["constraints", "gloez_conversion_ban", t.key], false) == true
}

# Allgemein nicht prämienfähige Flächen (Sonstige Flächen, Grünlandbrachen, Code OP/VF, Nationalparks)
parcel_excluded_general(p) if {
	row := field_use_row(p)
	row.premium_eligible == false
}

parcel_excluded_general(p) if {
	some c in cfg.lists.non_eligible_parcel_codes
	c in parcel_codes(p)
}

parcel_excluded_general(p) if {
	object.get(p, ["constraints", "national_park"], null) in {np | some np in cfg.lists.national_parks_without_area_premiums}
}

parcel_excluded_general(p) if {
	np := object.get(p, ["constraints", "national_park"], null)
	is_string(np)
	object.get(p, ["constraints", "national_park_relevant_restrictions"], false) == true
}

grassland_area_ha := s if {
	count(parcels) > 0
	s := sum([p.area_ha | some p in parcels; is_grassland(p)])
}

grassland_area_ha := object.get(input, ["land", "grassland_area_ha"], 0) if count(parcels) == 0

arable_forage_area_ha := sum([p.area_ha | some p in parcels; is_arable_forage(p)])

# Landwirtschaftliche Nutzfläche ohne Almweideflächen (Annahme: total_area_ha enthält Almweideflächen)
utilised_area_excl_alpine_ha := object.get(input, ["land", "total_area_ha"], 0) - object.get(input, ["land", "alpine_pasture_area_ha"], 0)
