package oepul.o6_1c

# Zusammenfassende Entscheidung für die Maßnahme o6_1c.

parcel_violations := ((npa_violations | afs_definition_violations) | afs_commitment_violations) | general_violations

farm_level_violations := (access_violations | application_violations) | farm_npa_violations

commitment_violations := parcel_violations | farm_npa_violations

decision := {
	"measure": measure_id,
	"year": year,
	"measure_offered": measure_offered_flag,
	"contract_valid": contract_valid_flag,
	"deregistered_in_year": deregistered_in_year_flag,
	"categories": applied_categories,
	"access_violations": access_violations,
	"application_violations": application_violations,
	"commitment_violations": commitment_violations,
	"parcel_exclusions": parcel_exclusions,
	"npa_eligible_area_ha": npa_eligible_area_ha,
	"npa_area_cap_ha": npa_area_cap_ha,
	"afs_eligible_area_ha": afs_eligible_area_ha,
	"modulation_factor": farm_modulation_factor,
	"premium_band": premium_band,
	"sanction_percent_total": sanction_percent_total,
	"excluded_from_measure": excluded_flag,
}

measure_offered_flag if measure_offered

default measure_offered_flag := false

contract_valid_flag if contract_valid

default contract_valid_flag := false

deregistered_in_year_flag if deregistered_in_year

default deregistered_in_year_flag := false

excluded_flag if excluded_from_measure

default excluded_flag := false
