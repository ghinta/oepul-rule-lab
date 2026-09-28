# Gemeinsame Hilfsregeln für die ÖPUL-Maßnahme 19 "Ergebnisorientierte Bewirtschaftung" (EBW).
# Tabellen liegen unter data.oepul_o6_19 (siehe rules/data_inventory.json).
package oepul.o6_19

import rego.v1

tables := data.oepul_o6_19

params := tables.measure_parameters

general_tables := tables.general

year := input.farm.year

ebw := object.get(input, ["oepul", "o6_19"], {})

participation := object.get(input, ["oepul", "participation"], {})

participates_ubb_or_bio if participation.ubb == true

participates_ubb_or_bio if participation.bio == true

parcels := object.get(input, ["land", "parcels"], [])

parcel_codes(p) := object.get(p, ["oepul", "codes"], [])

parcel_ebw(p) := object.get(p, ["oepul", "ebw"], {})

has_code(p, code) if code in parcel_codes(p)

# R-O619-APP-EBW-CODE: Schläge werden über den Code EBW in der Feldstücksliste beantragt.
ebw_parcels[p.parcel_id] := p if {
	some p in parcels
	has_code(p, params.parcel_code)
}

ebw_parcel_ids := {pid | some pid, _ in ebw_parcels}

num(x) := x if is_number(x)

num(x) := 0 if not is_number(x)

get_num(obj, path) := num(object.get(obj, path, 0))

round2(x) := round(x * 100) / 100

# Datum als "YYYY-MM-DD"; lexikographischer Vergleich ist chronologisch.
date_lte(a, b) if {
	is_string(a)
	is_string(b)
	a <= b
}

year_end(y) := sprintf("%d-12-31", [y])
