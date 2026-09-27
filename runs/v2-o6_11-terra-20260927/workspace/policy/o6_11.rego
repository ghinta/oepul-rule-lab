package oepul.o6_11

import rego.v1

# This policy evaluates only facts supplied under input.o6_11; profile-change
# proposals document the facts absent from the canonical farm profile.
default eligible := false

special_crop(parcel) if parcel.crop.crop_category in {"vineyard", "orchard", "hop"}

enrolled_area := sum([parcel.area_ha |
	parcel := input.land.parcels[_]
	special_crop(parcel)
	object.get(parcel, "o6_11", {"enrolled": false}).enrolled
])

all_special_area := sum([parcel.area_ha |
	parcel := input.land.parcels[_]
	special_crop(parcel)
])

herbicide_violation contains parcel.parcel_id if {
	parcel := input.land.parcels[_]
	special_crop(parcel)
	application := object.get(parcel.operations, "plant_protection_applications", [])[_]
	application.effect_type == "Herbizid"
}

herbicide_violation contains parcel.parcel_id if {
	parcel := input.land.parcels[_]
	special_crop(parcel)
	object.get(parcel.operations, "psm_used", false)
	object.get(parcel.operations, "psm_effect_type", "") == "Herbizid"
}

uncovered_special_parcels := [parcel.parcel_id |
	parcel := input.land.parcels[_]
	special_crop(parcel)
	not object.get(parcel, "o6_11", {"enrolled": false}).enrolled
]

all_special_parcels_enrolled if count(uncovered_special_parcels) == 0

eligible if {
	input.o6_11.participation.requested
	input.o6_11.participation.contract_start_year in {2023, 2024, 2025}
	input.o6_11.participation.first_commitment_year_area_ha >= 0.5
	all_special_parcels_enrolled
	count(herbicide_violation) == 0
	not input.o6_11.inventory.has_prohibited_herbicide_purchase
	not input.o6_11.inventory.has_prohibited_herbicide_storage
	not input.o6_11.participation.incompatible_bio_combination
}

violations contains {"code": "minimum_area", "message": "Im ersten Verpflichtungsjahr sind mindestens 0,50 ha erforderlich."} if {
	input.o6_11.participation.first_commitment_year_area_ha < 0.5
}

violations contains {"code": "complete_scope", "message": "Alle Wein-, Obst- und Hopfenflächen des Betriebes müssen einbezogen sein."} if {
	not all_special_parcels_enrolled
}

violations contains {"code": "herbicide_use", "parcel_ids": herbicide_violation, "message": "Herbizide mit Wirkungstyp Herbizid sind auf der gesamten Fläche verboten."} if count(herbicide_violation) > 0

violations contains {"code": "purchase_or_storage", "message": "Kauf oder Lagerung eines für die Maßnahme unzulässigen Herbizids ist verboten."} if {
	input.o6_11.inventory.has_prohibited_herbicide_purchase
}

violations contains {"code": "purchase_or_storage", "message": "Kauf oder Lagerung eines für die Maßnahme unzulässigen Herbizids ist verboten."} if {
	input.o6_11.inventory.has_prohibited_herbicide_storage
}

violations contains {"code": "bio_combination", "message": "Die betriebliche Kombination mit Biologischer Wirtschaftsweise ist nur beim Bio-Teilbetrieb Acker und Grünland zulässig."} if input.o6_11.participation.incompatible_bio_combination

premium_rate(parcel) := rate if {
	special_crop(parcel)
	row := data.o6_11.premium_rates_eur_per_ha[_]
	row.crop == parcel.crop.crop_category
	input.farm.year >= row.year_from
	row.year_to == null
	rate := row.rate
}

premium_rate(parcel) := rate if {
	special_crop(parcel)
	row := data.o6_11.premium_rates_eur_per_ha[_]
	row.crop == parcel.crop.crop_category
	input.farm.year >= row.year_from
	input.farm.year <= row.year_to
	rate := row.rate
}

premium_excluded(parcel) if parcel.crop.crop_name in data.o6_11.non_premium_crop_names
premium_excluded(parcel) if object.get(parcel, "land_use_name", "") in data.o6_11.non_premium_land_use_names
premium_excluded(parcel) if object.get(parcel, "o6_11", {}).op_code

premium_by_parcel contains {"parcel_id": parcel.parcel_id, "area_ha": parcel.area_ha, "rate_eur_per_ha": rate, "gross_eur": parcel.area_ha * rate} if {
	parcel := input.land.parcels[_]
	object.get(parcel, "o6_11", {"enrolled": false}).enrolled
	not premium_excluded(parcel)
	rate := premium_rate(parcel)
}

gross_premium_eur := sum([entry.gross_eur | entry := premium_by_parcel[_]])

modulation_factor := factor if {
	area := input.land.total_area_ha
	area > 0
	factor := ((((min([area, 200]) * 1) + (max([min([area, 300]) - 200, 0]) * 0.9)) + (max([min([area, 1000]) - 300, 0]) * 0.85)) + (max([area - 1000, 0]) * 0.75)) / area
}

modulated_premium_eur := gross_premium_eur * modulation_factor
