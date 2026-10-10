package oepul.o6_12

# Gemeinsame Hilfsdefinitionen für die Maßnahme 12 "Insektizidverzicht Wein, Obst und Hopfen".

params := data.o6_12.measure_parameters

year := input.farm.year

parcels := object.get(input, ["land", "parcels"], [])

o612 := object.get(input, ["oepul", "o6_12"], {})

participating_measures := {m | some m in object.get(input, ["oepul", "participating_measures"], [])}

participates if o612.participating == true

measure_crop_categories := {c | some c in params.eligible_crop_categories}

eligible_land_use_codes := {c | some c in params.eligible_land_use_codes}

ineligible_usage_types := {t.usage_type | some t in data.o6_12.ineligible_usage_types}

usage_type(p) := object.get(p, ["crop", "usage_type"], "regular")

parcel_codes(p) := {c | some c in object.get(p, "oepul_codes", [])}

crop_category(p) := object.get(p, ["crop", "crop_category"], "other")

# Wein-, Obst- und Hopfenflächen des Betriebes (Geltungsbereich des Insektizidverzichts).
# Schnittweingärten zählen zur Weinfläche, Reb- und Baumschulen nicht.
is_wine_fruit_hop_parcel(p) if {
	crop_category(p) in measure_crop_categories
	not usage_type(p) in {"rebschule", "baumschule"}
}

# Flächen, die für die Mindestteilnahmefläche angerechnet werden.
counts_for_minimum_area(p) if {
	is_wine_fruit_hop_parcel(p)
	not usage_type(p) in ineligible_usage_types
	object.get(p, "country", "AT") == "AT"
}

listed_fruit_crops(yr) := {f.crop_name | some f in data.o6_12.fruit_crops; f.valid_from_year <= yr}

contract_period := cp if {
	some cp in data.o6_12.contract_periods
	cp.start_year == o612.contract_start_year
}

contract_end_year := to_number(substring(params.contract_end_date, 0, 4))

# Vertragszeitraum läuft im betrachteten Jahr.
year_in_contract_period if {
	contract_period
	o612.contract_start_year <= year
	year <= contract_end_year
}

date_ns(d) := time.parse_ns("2006-01-02", d)

date_on_or_before(a, b) if date_ns(a) <= date_ns(b)

exit_obj := object.get(o612, "exit", {})

exit_requested if exit_obj.requested == true

has_vineyard if {
	some p in parcels
	crop_category(p) == "vineyard"
	not usage_type(p) in {"rebschule"}
}
