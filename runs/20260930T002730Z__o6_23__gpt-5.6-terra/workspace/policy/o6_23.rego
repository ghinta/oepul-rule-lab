package oepul.o6_23

import data.o6_23_tables

default eligible := false

# A parcel is eligible only when it has been applied for, has a valid land-authority
# project confirmation and carries one of the nine Natura-2000 management codes.
eligible if {
	input.application.o6_23.applied
	some parcel in input.land.parcels
	parcel.natura2000.selected
	parcel.natura2000.project_confirmation_present
	o6_23_tables.premiums_eur_per_ha[parcel.natura2000.management_code]
}

eligible_parcels contains parcel.parcel_id if {
	input.application.o6_23.applied
	parcel := input.land.parcels[_]
	parcel.natura2000.selected
	parcel.natura2000.project_confirmation_present
	o6_23_tables.premiums_eur_per_ha[parcel.natura2000.management_code]
}

premium_eur[parcel.parcel_id] := amount if {
	parcel := input.land.parcels[_]
	parcel.parcel_id in eligible_parcels
	rate := o6_23_tables.premiums_eur_per_ha[parcel.natura2000.management_code].amount
	amount := parcel.area_ha * rate
}

violations contains {"parcel_id": parcel.parcel_id, "code": "missing_project_confirmation"} if {
	parcel := input.land.parcels[_]
	parcel.natura2000.selected
	not parcel.natura2000.project_confirmation_present
}

violations contains {"parcel_id": parcel.parcel_id, "code": "unknown_management_code"} if {
	parcel := input.land.parcels[_]
	parcel.natura2000.selected
	not o6_23_tables.premiums_eur_per_ha[parcel.natura2000.management_code]
}

violations contains {"parcel_id": parcel.parcel_id, "code": "project_requirements_not_met"} if {
	parcel := input.land.parcels[_]
	parcel.natura2000.selected
	not parcel.natura2000.project_requirements_met
}

# Chapter letters in the combination table must be compatible when two obligations
# are declared for the same parcel.
violations contains {"parcel_id": parcel.parcel_id, "code": "incompatible_obligation_combination"} if {
	parcel := input.land.parcels[_]
	parcel.natura2000.selected
	a := parcel.natura2000.obligation_chapters[_]
	b := parcel.natura2000.obligation_chapters[_]
	a != b
	not o6_23_tables.combination_matrix[a][b]
}

can_use_2026_drought_cut_exception(parcel) if {
	parcel.natura2000.selected
	parcel.natura2000.cut_date_changed_by_land_regulation
}
