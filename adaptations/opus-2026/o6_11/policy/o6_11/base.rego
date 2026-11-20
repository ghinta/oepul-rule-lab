# METADATA
# title: ÖPUL 2023 – Herbizidverzicht Wein, Obst und Hopfen (o6_11) – Grundlagen
# description: >-
#   Gemeinsame Hilfsregeln: Antragsjahr, Teilnahme an Maßnahme 11,
#   Klassifizierung von Wein-, Obst- und Hopfenflächen.
package oepul.o6_11

cfg := data.o6_11

measure_id := "11"

year := input.farm.year

parcels := object.get(input, ["land", "parcels"], [])

oepul_measures := object.get(input, ["farm", "oepul", "measures"], [])

# Teilnahmeeintrag der Maßnahme 11 (erster Eintrag, falls mehrfach angegeben)
participations := [m | some m in oepul_measures; m.measure_id == measure_id]

participates if count(participations) > 0

participation := participations[0] if participates

contract_start_year := participation.contract_start_year

# Weitere Maßnahmen des Betriebes (Maßnahmen-IDs gemäß SRL, z. B. "1A", "1B", "12")
farm_measure_ids contains m.measure_id if {
	some m in oepul_measures
}

year_of(date_string) := to_number(substring(date_string, 0, 4))

# ---------------------------------------------------------------------------
# Nutzungsart je Schlag (Rule O611-ELIG-CROPS, O611-SCHNITTWEIN-COUNTS,
# O611-REBSCHULE-EXCL)
# ---------------------------------------------------------------------------
usage_type_rows := {row.usage_type: row | some row in cfg.usage_types}

default_usage_by_category := {row.default_for_crop_category: row.usage_type |
	some row in cfg.usage_types
	row.default_for_crop_category != null
}

parcel_usage_type(p) := p.crop.usage_type if {
	p.crop.usage_type != null
} else := default_usage_by_category[p.crop.crop_category] if {
	default_usage_by_category[p.crop.crop_category]
} else := "not_wine_fruit_hop"

parcel_usage_row(p) := usage_type_rows[parcel_usage_type(p)]

parcel_area(p) := object.get(p, "area_ha", 0)

parcel_species(p) := object.get(p, ["crop", "crop_name"], null)

# Obstarten gemäß Definition (Rule O611-DEF-OBST); ab 2025 zusätzliche Arten
fruit_species_valid(species) if {
	species in cfg.fruit_crops.base
}

fruit_species_valid(species) if {
	some row in cfg.fruit_crops.from_2025
	row.species == species
	year >= row.valid_from_year
}

# Obstfläche: Art unbekannt (null) -> als Obst gemäß Nutzungsart behandelt
fruit_species_ok(p) if parcel_species(p) == null

fruit_species_ok(p) if fruit_species_valid(parcel_species(p))

# Wein-, Obst- oder Hopfenfläche im Sinne der Maßnahme
is_wfh_parcel(p) if {
	row := parcel_usage_row(p)
	row.is_wine_fruit_hop_area
	row.usage_type != "fruit"
}

is_wfh_parcel(p) if {
	parcel_usage_type(p) == "fruit"
	fruit_species_ok(p)
}

# Herbizidverzicht gilt für die gesamte Wein-, Obst- und Hopfenfläche
# des Betriebes (inkl. Schnittweingärten, nicht für Rebschulen)
herbicide_ban_parcel(p) if {
	is_wfh_parcel(p)
	parcel_usage_row(p).herbicide_ban_applies
}

# Fläche, die für die Mindestteilnahmefläche zählt (Rule O611-MIN-AREA)
counts_for_minimum_area(p) if {
	is_wfh_parcel(p)
	parcel_usage_row(p).counts_for_minimum_area
}

wfh_parcel_ids contains p.parcel_id if {
	some p in parcels
	is_wfh_parcel(p)
}

herbicide_ban_parcel_ids contains p.parcel_id if {
	some p in parcels
	herbicide_ban_parcel(p)
}

# Kulturen, die nicht dem Herbizidverzicht unterliegen (für Rule O611-PURCHASE-OTHER-CROPS)
non_wfh_crop_categories contains p.crop.crop_category if {
	some p in parcels
	not herbicide_ban_parcel(p)
}
