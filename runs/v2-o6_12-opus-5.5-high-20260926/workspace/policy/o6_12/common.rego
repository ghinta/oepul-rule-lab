# METADATA
# title: ÖPUL 2023 – Insektizidverzicht Wein, Obst und Hopfen (12) – gemeinsame Hilfsregeln
# description: Stammdaten, Flächenklassifikation und Teilnahmeinformationen für Maßnahme 12.
package oepul.o6_12

measure := data.o6_12.o6_12_measure

general := data.o6_12.oepul_general_parameters

application_year := input.farm.year

parcels := object.get(input, ["land", "parcels"], [])

oepul := object.get(input, ["oepul"], {})

o6_12_input := object.get(oepul, ["o6_12"], {})

# Maßnahmenteilnahmen des Betriebs (Maßnahmenantrag).
participations := object.get(oepul, ["measures"], [])

participating_codes contains m.code if {
	some m in participations
}

participation_12 := m if {
	some m in participations
	m.code == measure.code
}

participates if participation_12

default participates := false

commitment_start_year := participation_12.commitment_start_year

first_commitment_year := commitment_start_year

# Jahr der Datumsangabe im Format YYYY-MM-DD.
year_of(d) := to_number(substring(d, 0, 4))

# Flächentyp gemäß Schlagnutzungsart (Vorschlag special_crop_type) bzw. Rückfall auf crop_category.
special_type(p) := object.get(p, ["crop", "special_crop_type"], null)

type_info(p) := row if {
	some row in data.o6_12.o6_12_special_crop_types
	row.special_crop_type == special_type(p)
}

type_info(p) := info if {
	special_type(p) == null
	woh := data.o6_12.o6_12_crop_category_fallback[p.crop.crop_category]
	info := {
		"label": "Rückfall auf crop_category",
		"woh_type": woh,
		"counts_for_min_area": true,
		"premium_eligible": true,
		"subject_to_insecticide_ban": true,
	}
}

woh_type(p) := type_info(p).woh_type if type_info(p).woh_type != null

is_woh_parcel(p) if woh_type(p)

# Obstkulturen gemäß Definition „Obst im Sinne des ÖPUL 2023“ (inkl. Ergänzungen ab 2025).
fruit_crop_listed(name, year) if {
	some row in data.o6_12.oepul_fruit_crops
	row.valid_from_year <= year
	startswith(lower(name), row.match_key)
}

# Liefert true, wenn der Schlag eine Obstfläche ist, deren Kultur nicht in der Obstliste steht.
fruit_crop_not_listed(p) if {
	woh_type(p) == "fruit"
	name := object.get(p, ["crop", "crop_name"], null)
	name != null
	not fruit_crop_listed(name, application_year)
}

# Fläche zählt für die Mindestteilnahmefläche (Schnittweingärten ja, Rebschulen nein).
counts_for_min_area(p) if {
	is_woh_parcel(p)
	type_info(p).counts_for_min_area
	not fruit_crop_not_listed(p)
}

subject_to_ban(p) if {
	is_woh_parcel(p)
	type_info(p).subject_to_insecticide_ban
}

woh_area_ha := sum([p.area_ha | some p in parcels; counts_for_min_area(p)])

farm_has_wine_area if {
	some p in parcels
	woh_type(p) == "wine"
}

parcel_op_codes(p) := object.get(p, ["oepul", "op_codes"], [])

parcel_measure_codes(p) := object.get(p, ["oepul", "measure_codes"], [])

parcel_psm_codes(p) := object.get(p, ["oepul", "psm_codes"], [])

parcel_applications(p) := object.get(p, ["operations", "plant_protection_applications"], [])
