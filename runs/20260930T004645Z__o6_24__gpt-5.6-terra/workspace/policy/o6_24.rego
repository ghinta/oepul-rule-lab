package oepul.o6_24

import rego.v1

# Required extensions are proposed in rules/profile_changes.json.
required_area_ha := 2.0
premium_per_ha_eur := 54.0

eligible_parcels contains parcel if {
	parcel := input.land.parcels[_]
	parcel.land_use == "arable"
	parcel.o6_24.in_wrrl_area
	not parcel.o6_24.is_fallow
	not parcel.o6_24.has_higher_n_permission
}

eligible_area_ha := sum([parcel.area_ha | parcel := eligible_parcels[_]])

minimum_area_met if {
	eligible_area_ha >= required_area_ha
}

premium_eur := eligible_area_ha * premium_per_ha_eur if {
	minimum_area_met
}

assigned_nitrogen_class(parcel) := parcel.o6_24.nitrogen_class if {
	parcel.o6_24.nitrogen_class != ""
}

assigned_nitrogen_class(parcel) := "C" if {
	parcel.o6_24.nitrogen_class == ""
}

nitrogen_compliant if {
	every parcel in eligible_parcels {
		parcel.o6_24.annual_effective_n_kg_ha <= parcel.o6_24.nitrogen_limit_kg_ha
		parcel.o6_24.n_application_in_permitted_period
	}
}

recordkeeping_compliant if {
	every parcel in input.land.parcels {
		parcel.o6_24.farm_book_recorded
	}
	input.documentation.o6_24.farm_book_retained_at_farm
}

drought_harvest_exception_2026 if {
	input.farm.year == 2026
	parcel := input.land.parcels[_]
	parcel.o6_24.no_harvest_due_to_drought
	state := input.farm.region.federal_state
	allowed := data.automatic_higher_force_harvest_exception_2026[state]
	allowed[_] == "all"
}

drought_harvest_exception_2026 if {
	input.farm.year == 2026
	parcel := input.land.parcels[_]
	parcel.o6_24.no_harvest_due_to_drought
	state := input.farm.region.federal_state
	district := input.farm.region.district
	allowed := data.automatic_higher_force_harvest_exception_2026[state]
	allowed[_] == district
}

violations contains {"code": "minimum_area", "message": "At least 2.00 ha arable land in the WRRL area is required in every participation year."} if {
	not minimum_area_met
}

violations contains {"code": "nitrogen", "message": "Annual effective nitrogen or the legal application period is not compliant on an eligible parcel."} if {
	not nitrogen_compliant
}

violations contains {"code": "farm_book", "message": "The farm book must cover every parcel, including parcels without fertilisation, and be retained on the farm."} if {
	not recordkeeping_compliant
}

violations contains {"code": "high_n_permission", "message": "Arable land with an approval for increased nitrogen application is not eligible and must be coded OPWRRL."} if {
	parcel := input.land.parcels[_]
	parcel.o6_24.in_wrrl_area
	parcel.o6_24.has_higher_n_permission
	not parcel.o6_24.opwrrl_code
}

eligible if {
	minimum_area_met
	nitrogen_compliant
	recordkeeping_compliant
	count(violations) == 0
}
