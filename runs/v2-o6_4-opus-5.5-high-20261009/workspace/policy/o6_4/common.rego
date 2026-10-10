# METADATA
# title: ÖPUL 2023 – Bewirtschaftung von Bergmähdern (o6_4) – gemeinsame Hilfsregeln
# description: Datenzugriff, Antragsjahr, teilnehmende Schläge und Datums-Hilfsfunktionen.
package oepul.o6_4

import rego.v1

cfg := data.oepul_data.o6_4

# Antragsjahr = Kalenderjahr der Umsetzung (§ 21 Abs. 5 GSP-AV)
year := input.farm.year

measure_input := object.get(input, ["oepul", "o6_4"], {})

farm_parcels := object.get(input, ["land", "parcels"], [])

# Schläge, die mit der Maßnahme o6_4 beantragt bzw. belegt sind
o6_4_parcels[pid] := p if {
	some p in farm_parcels
	object.get(p, ["mountain_meadow", "enrolled_in_o6_4"], false) == true
	pid := p.parcel_id
}

mountain_meadow(p) := object.get(p, "mountain_meadow", {})

parcel_oepul(p) := object.get(p, "oepul", {})

parcel_ops(p) := object.get(p, "operations", {})

# Jahr aus ISO-Datum (YYYY-MM-DD)
date_year(d) := to_number(substring(d, 0, 4))

# Monat-Tag (MM-DD) aus ISO-Datum
month_day(d) := substring(d, 5, 5)

events_in_year(events) := [e |
	some e in events
	date_year(e.date) == year
]

farm_measures := {m | some m in object.get(input, ["oepul", "participating_measures"], [])}

contract_start_year := date_year(measure_input.contract_start_date)

round2(x) := round(x * 100) / 100
