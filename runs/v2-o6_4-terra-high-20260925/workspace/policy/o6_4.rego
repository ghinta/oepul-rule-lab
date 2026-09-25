package oepul.o6_4

import rego.v1

# Rego input extends the canonical profile with the discover-mode proposals in
# rules/profile_changes.json. Each participating parcel is represented in
# input.land.parcels and has a mountain_meadow object.

premium_rate(parcel) := rate if {
	some rate in data.o6_4.premium_rates
	rate.code == parcel.mountain_meadow.code
	input.farm.year >= rate.year_from
	rate.year_to == null
}

premium_rate(parcel) := rate if {
	some rate in data.o6_4.premium_rates
	rate.code == parcel.mountain_meadow.code
	input.farm.year >= rate.year_from
	rate.year_to != null
	input.farm.year <= rate.year_to
}

eligible_altitude(parcel) if {
	parcel.mountain_meadow.is_mountain_meadow
	parcel.mountain_meadow.area_above_1200m_ha > parcel.area_ha / 2
}

compliant_mowing(parcel) if {
	parcel.mountain_meadow.mowing_count <= 1
	parcel.mountain_meadow.mowing_count_last_two_years >= 1
	parcel.mountain_meadow.mowing_count > 0
	parcel.mountain_meadow.mowed_area_ha == parcel.area_ha
	parcel.mountain_meadow.mowings[0].forage_removed
}

compliant_no_mowing_year(parcel) if {
	parcel.mountain_meadow.mowing_count == 0
	parcel.mountain_meadow.code == "BM0"
	parcel.mountain_meadow.mowing_count_last_two_years >= 1
}

compliant_grazing(parcel) if {
	not parcel.mountain_meadow.grazing_occurred
}

compliant_grazing(parcel) if {
	parcel.mountain_meadow.grazing_occurred
	parcel.mountain_meadow.grazing_start_date >= sprintf("%d-08-16", [input.farm.year])
}

compliant_fertilizer(parcel) if {
	every application in parcel.mountain_meadow.fertilizer_applications {
		application.kind == "farmyard_manure"
		application.original_form
	}
}

compliant_psm(parcel) if {
	every application in parcel.mountain_meadow.psm_applications {
		application.bio_eu_2018_848_allowed
	}
}

violations contains violation if {
	parcel := input.land.parcels[_]
	parcel.mountain_meadow.participates
	not eligible_altitude(parcel)
	violation := {"parcel_id": parcel.parcel_id, "rule": "O64.ELIGIBILITY.ALTITUDE", "reason": "more than half of the parcel is not above 1,200 m"}
}

violations contains violation if {
	parcel := input.land.parcels[_]
	parcel.mountain_meadow.participates
	not compliant_mowing(parcel)
	not compliant_no_mowing_year(parcel)
	violation := {"parcel_id": parcel.parcel_id, "rule": "O64.MOWING", "reason": "mowing frequency, full-area mowing, forage removal, or BM0 coding is non-compliant"}
}

violations contains violation if {
	parcel := input.land.parcels[_]
	parcel.mountain_meadow.participates
	not compliant_grazing(parcel)
	violation := {"parcel_id": parcel.parcel_id, "rule": "O64.GRAZING", "reason": "grazing is permitted only as after-grazing from 16 August"}
}

violations contains violation if {
	parcel := input.land.parcels[_]
	parcel.mountain_meadow.participates
	not compliant_fertilizer(parcel)
	violation := {"parcel_id": parcel.parcel_id, "rule": "O64.FERTILIZER", "reason": "only farmyard manure in original form is permitted"}
}

violations contains violation if {
	parcel := input.land.parcels[_]
	parcel.mountain_meadow.participates
	not compliant_psm(parcel)
	violation := {"parcel_id": parcel.parcel_id, "rule": "O64.PSM", "reason": "plant-protection product is not solely EU 2018/848-allowed"}
}

annual_premium[parcel.parcel_id] := amount if {
	parcel := input.land.parcels[_]
	parcel.mountain_meadow.participates
	rate := premium_rate(parcel)
	compliant_mowing(parcel)
	eligible_altitude(parcel)
	compliant_grazing(parcel)
	compliant_fertilizer(parcel)
	compliant_psm(parcel)
	amount := parcel.area_ha * rate.eur_per_ha
}
