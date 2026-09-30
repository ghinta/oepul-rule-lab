# Gemeinsame Hilfsregeln für die ÖPUL-Maßnahme
# "Einschränkung ertragssteigernder Betriebsmittel" (o6_2, SRL-Maßnahme 2).
package oepul.o6_2

lists := data.o6_2_lists

general := data.o6_2_general

premium_data := data.o6_2_premium

rgve_data := data.o6_2_rgve

combos := data.o6_2_combinations

drought := data.o6_2_drought_2026

year := input.farm.year

parcels := object.get(input, ["land", "parcels"], [])

oepul := object.get(input, ["farm", "oepul"], {})

o6_2_state := object.get(oepul, "o6_2", {})

participating_measures := {m | some m in object.get(oepul, "participating_measures", [])}

crop_name_of(p) := lower(object.get(p, ["crop", "crop_name"], "")) if {
	object.get(p, ["crop", "crop_name"], null) != null
} else := ""

oepul_codes_of(p) := {c | some c in object.get(p, "oepul_codes", [])}

# Parzellen außerhalb Österreichs werden nicht gefördert und nicht berücksichtigt.
parcel_in_austria(p) if object.get(p, "is_in_austria", true) == true

# Ackerfutterkulturen gemäß Definition (Futtergräser, Wechselwiese, Kleegras,
# Klee, Luzerne, Sonstiges Feldfutter, Ackerweide).
is_arable_forage_crop(p) if {
	p.land_use == "arable"
	some c in lists.arable_forage_crops
	lower(c) == crop_name_of(p)
}

forage_as_second_crop(p) if object.get(p, ["crop", "forage_as_second_crop"], false) == true

# Ackerfutter als Hauptkultur (Zweitkultur zählt als Ackerfläche).
is_arable_forage_main(p) if {
	is_arable_forage_crop(p)
	not forage_as_second_crop(p)
}

is_fruit_crop(p) if {
	some c in lists.fruit_crops
	lower(c) == crop_name_of(p)
}

is_fruit_crop(p) if {
	year >= 2025
	some c in lists.fruit_crops_from_2025
	lower(c) == crop_name_of(p)
}

is_wine_fruit_hop(p) if {
	p.land_use == "special_crop"
	p.crop.crop_category in {"vineyard", "hop"}
}

is_wine_fruit_hop(p) if {
	p.land_use == "special_crop"
	p.crop.crop_category == "orchard"
	is_fruit_crop(p)
}

# Prämienkategorie einer Parzelle gemäß Kapitel 7 des Informationsblatts.
parcel_category(p) := "arable_forage" if {
	is_arable_forage_main(p)
} else := "arable" if {
	p.land_use == "arable"
} else := "grassland" if {
	p.land_use == "grassland"
} else := "wine_fruit_hop" if {
	is_wine_fruit_hop(p)
} else := "not_eligible"

# Futterfläche = Grünland + Ackerfutterflächen (ohne Ackerfutter als Zweitkultur),
# unabhängig davon, in welche Maßnahme die Fläche eingebracht ist.
is_fodder_area(p) if {
	parcel_in_austria(p)
	p.land_use == "grassland"
}

is_fodder_area(p) if {
	parcel_in_austria(p)
	is_arable_forage_main(p)
}

# Grünland- und Ackerfutterflächen für das Pflanzenschutzmittelverbot
# (tatsächliche Kultur, auch bei Beantragung als Zweitkultur).
is_psm_restricted_area(p) if p.land_use == "grassland"

is_psm_restricted_area(p) if is_arable_forage_crop(p)

agricultural_area_ha := sum([p.area_ha |
	some p in parcels
	parcel_in_austria(p)
	p.land_use != "alpine_pasture"
])

total_farm_area_ha := input.land.total_area_ha if {
	input.land.total_area_ha > 0
} else := agricultural_area_ha
