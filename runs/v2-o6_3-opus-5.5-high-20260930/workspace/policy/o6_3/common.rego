# Gemeinsame Hilfsregeln für ÖPUL 2023 – Heuwirtschaft (o6_3).
package o6_3

params := data.o6_3.general_params

year := input.farm.year

o6_3_input := object.get(input, ["farm", "oepul", "o6_3"], {})

contract_start_year := object.get(o6_3_input, "contract_start_year", null)

participating_measures := {m | some m in object.get(input, ["farm", "oepul", "participating_measures"], [])}

parcels := [p | some p in object.get(input, ["land", "parcels"], []); parcel_in_austria(p)]

species_groups := object.get(input, ["livestock", "species_groups"], [])

# GEN-LOC-01: nur in Österreich gelegene Flächen werden berücksichtigt.
parcel_in_austria(p) if object.get(p, "located_in_austria", true) == true

# Vertragsjahr-Logik (O6_3-CP-01, SRL-ACC-01)
is_first_contract_year if year == contract_start_year

contract_year_number := (year - contract_start_year) + 1 if is_number(contract_start_year)

grassland_type(p) := object.get(p, "grassland_type", null)

forage_crop_type(p) := object.get(p, ["crop", "forage_crop_type"], null)

is_second_crop(p) if object.get(p, ["crop", "is_second_crop"], false) == true

is_mown(p) if count(object.get(p, ["operations", "cutting_dates"], [])) > 0

is_grazed(p) if object.get(p, ["operations", "grazed"], false) == true

parcel_measures(p) := {m | some m in object.get(p, "enrolled_measures", [])}

# O6_3-LH-05: Ackerfutterkulturen (inkl. Ackerweide) für die Viehbesatzberechnung.
density_forage_crop_ids := {c.id | some c in data.o6_3.forage_areas.arable_forage_crops; c.counts_for_livestock_density}

# O6_3-PREM-02: prämienfähige Ackerfutterkulturen (ohne Ackerweide).
premium_forage_crop_ids := {c.id | some c in data.o6_3.forage_areas.arable_forage_crops; c.premium_eligible_if_mown}

# O6_3-MIN-01: für die Mindestteilnahme zählende Grünlandtypen (Mähwiesen/Mähweiden).
min_area_grassland_types := {g.id | some g in data.o6_3.forage_areas.grassland_types; g.counts_for_minimum_area}

premium_grassland_types := {g.id | some g in data.o6_3.forage_areas.grassland_types; g.premium_eligible}
