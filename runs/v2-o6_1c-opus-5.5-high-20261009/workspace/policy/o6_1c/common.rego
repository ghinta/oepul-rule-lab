package oepul.o6_1c

# Gemeinsame Hilfsregeln für die Maßnahme 31-05 / o6_1c
# "Nichtproduktive Ackerflächen und Agroforststreifen".

measure_id := "o6_1c"

params := data.o6_1c.parameters

year := input.farm.year

parcels := object.get(input, ["land", "parcels"], [])

oepul := object.get(input, ["farm", "oepul"], {})

application := object.get(oepul, "o6_1c", {})

# O6_1C-CAT-001: Teilnahme über die Maßnahmenkategorien "npa" (Nichtproduktive
# Ackerflächen) und/oder "agroforest" (Agroforststreifen).
applied_categories := {c | some c in object.get(application, "categories", [])}

participating_measures := {m | some m in object.get(oepul, "participating_measures", [])}

# ISO-Datum "JJJJ-MM-TT" für ein Jahr und einen Monat-Tag-Wert bilden.
date_of(y, mmdd) := sprintf("%d-%s", [y, mmdd])

parcel_codes(p) := {c | some c in object.get(p, "oepul_codes", [])}

parcel_id(p) := object.get(p, "parcel_id", "unknown")

violation(rule_id, p, msg) := {
	"rule_id": rule_id,
	"parcel_id": parcel_id(p),
	"message": msg,
}

farm_violation(rule_id, msg) := {
	"rule_id": rule_id,
	"parcel_id": null,
	"message": msg,
}

sum_area(ps) := sum([object.get(p, "area_ha", 0) | some p in ps])

min_of(a, b) := a if a <= b

min_of(a, b) := b if b < a

max_of(a, b) := a if a >= b

max_of(a, b) := b if b > a
