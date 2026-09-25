package oepul.o6_3

import rego.v1

# Input fields prefixed heuwirtschaft are proposed in rules/profile_changes.json.
default eligible_first_year := false

default silage_compliant := false

default green_feeding_compliant := false

default mowing_conditioner_compliant := false

rgve(category) := data.rgve_factors[category]

roughage_rgve := sum([(animal.count * rgve(animal.category)) |
	some animal in input.heuwirtschaft.animals
	data.roughage_categories[_] == animal.category
])

fodder_area_ha := sum([parcel.area_ha |
	some parcel in input.land.parcels
	parcel.land_use == "grassland"
]) + sum([parcel.area_ha |
	some parcel in input.land.parcels
	parcel.land_use == "arable"
	data.eligible_arable_fodder_crops[_] == parcel.crop.crop_name
	not parcel.heuwirtschaft_second_crop
])

livestock_density := roughage_rgve / fodder_area_ha if fodder_area_ha > 0

tierhaltend if livestock_density >= 0.30

eligible_meadow_area_ha := sum([parcel.area_ha |
	some parcel in input.land.parcels
	parcel.land_use == "grassland"
	parcel.heuwirtschaft_use == "mown_meadow_or_pasture"
])

has_required_base_measure if input.heuwirtschaft.base_measure == "ubb"
has_required_base_measure if input.heuwirtschaft.base_measure == "bio"
has_required_base_measure if input.heuwirtschaft.base_measure == "bio_partial"

eligible_first_year if {
	has_required_base_measure
	eligible_meadow_area_ha >= 2
	tierhaltend
}

silage_compliant if {
	not input.heuwirtschaft.silage.prepared
	not input.heuwirtschaft.silage.fed
	not input.heuwirtschaft.silage.stored
	not input.heuwirtschaft.silage.own_stock_consumed
	every transfer in input.heuwirtschaft.mowing_material_transfers {
		transfer.form == "dry_hay"
	}
}

green_feeding_compliant if {
	input.heuwirtschaft.green_feeding.during_majority_of_vegetation
	input.heuwirtschaft.green_feeding.applies_to_all_roughage_animals
}

mowing_conditioner_compliant if {
	input.heuwirtschaft.option_no_mowing_conditioner
	not input.heuwirtschaft.mowing_conditioner_used
	not input.heuwirtschaft.mowing_conditioner_present
}

premium_rate_eur_per_ha := 0 if not tierhaltend

premium_rate_eur_per_ha := 167.4 if {
	tierhaltend
	input.heuwirtschaft.option_no_mowing_conditioner
	mowing_conditioner_compliant
}

premium_rate_eur_per_ha := 145.8 if {
	tierhaltend
	not input.heuwirtschaft.option_no_mowing_conditioner
}

eligible_premium_area_ha := sum([parcel.area_ha |
	parcel = input.land.parcels[_]
	parcel.heuwirtschaft_use == "mown_meadow_or_pasture"
]) + sum([parcel.area_ha |
	some parcel in input.land.parcels
	parcel.land_use == "arable"
	data.eligible_arable_fodder_crops[_] == parcel.crop.crop_name
	not parcel.heuwirtschaft_second_crop
])

annual_gross_premium_eur := eligible_premium_area_ha * premium_rate_eur_per_ha

violation["missing_required_base_measure"] if not has_required_base_measure
violation["minimum_2ha_or_tierhaltend_not_met"] if not eligible_first_year
violation["silage_or_mowing_material_rule_not_met"] if not silage_compliant
violation["green_feeding_rule_not_met"] if not green_feeding_compliant

violation["mowing_conditioner_option_not_met"] if {
	input.heuwirtschaft.option_no_mowing_conditioner
	not mowing_conditioner_compliant
}
