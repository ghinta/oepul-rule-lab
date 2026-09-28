package oepul.o6_13

import data as o6_13_constants
import rego.v1

# Input contract: input.o6_13 supplies the measure-specific application,
# protected-cultivation parcels, organism applications, and documentary facts.

default eligible := false

eligible if {
	input.o6_13.measure_applied
	not input.o6_13.operation_program_organism_compensated
	input.farm.first_oepul_participation_year == false
	count(eligible_parcels) > 0
}

eligible if {
	input.o6_13.measure_applied
	not input.o6_13.operation_program_organism_compensated
	input.farm.first_oepul_participation_year
	input.o6_13.protected_area_ha >= 0.5
	count(eligible_parcels) > 0
}

eligible if {
	input.o6_13.measure_applied
	not input.o6_13.operation_program_organism_compensated
	input.farm.first_oepul_participation_year
	input.o6_13.total_eligible_area_ha >= 1.5
	count(eligible_parcels) > 0
}

eligible_parcels contains parcel if {
	parcel := input.o6_13.parcels[_]
	parcel.application_code == "NUE"
	parcel.protected_structure in o6_13_constants.eligible_protected_structures
	parcel.land_use_code in o6_13_constants.eligible_land_use_codes
	parcel.active_agricultural_production
	not parcel.sales_display_storage_area
	not parcel.unused_between_structures
	parcel.organism_application_replaces_psm
	parcel.organism_registered_at_ages
	parcel.organism_dose_matches_register
	parcel.records_complete
}

premium_rate_eur_per_ha := row.rate if {
	row := o6_13_constants.premium_rates_eur_per_ha[_]
	input.farm.year >= row.from_year
	row.to_year == null
}

premium_rate_eur_per_ha := row.rate if {
	row := o6_13_constants.premium_rates_eur_per_ha[_]
	input.farm.year >= row.from_year
	input.farm.year <= row.to_year
}

eligible_premium_amounts contains amount if {
	parcel := eligible_parcels[_]
	amount := parcel.area_ha * premium_rate_eur_per_ha
}

premium_eur := sum(eligible_premium_amounts) if {
	eligible
}

violations contains "operation_program_double_funding" if {
	input.o6_13.operation_program_organism_compensated
}

violations contains "no_eligible_greenhouse_or_tunnel" if {
	input.o6_13.measure_applied
	count(eligible_parcels) == 0
}

violations contains "no_nue_use_ends_contract" if {
	input.o6_13.measure_applied
	not input.o6_13.any_nue_use
}

violations contains "application_deadline_missed" if {
	input.o6_13.measure_applied
	input.o6_13.application_submitted_by_december_31 == false
}

violations contains "last_entry_after_2027" if {
	input.farm.first_oepul_participation_year
	input.farm.year > 2027
}

violations contains "incompatible_single_area_premium" if {
	parcel := input.o6_13.parcels[_]
	parcel.application_code == "NUE"
	count(parcel.other_single_area_premiums) > 0
}

violations contains "wrong_land_use_code_for_cultivation" if {
	parcel := input.o6_13.parcels[_]
	parcel.growing_system == "soil"
	parcel.land_use_code != "A"
}

violations contains "wrong_land_use_code_for_cultivation" if {
	parcel := input.o6_13.parcels[_]
	parcel.growing_system in {"pots", "substrate"}
	parcel.land_use_code != "GA"
}

violations contains "wrong_land_use_code_on_april_1" if {
	parcel := input.o6_13.parcels[_]
	parcel.growing_system == "mixed"
	parcel.land_use_code != parcel.growing_system_on_april_1_code
}
