package oepul.o6_9

import rego.v1

# The input extension o6_9 is proposed in rules/profile_changes.json. Missing
# facts are never silently converted into eligibility.
allowed_techniques := {"trailing_hose", "trailing_shoe", "injection"}
allowed_manure_types := {"slurry", "liquid_manure", "biogas_slurry"}

application_cap_m3 := object.get(input.o6_9, "dungungswuerdige_area_ha", 0) * data.application_cap_m3_per_dungungswuerdige_ha
separation_cap_m3 := object.get(input.o6_9, "cattle_gve_annual_average", 0) * data.separation_cap_m3_per_cattle_gve

eligible_application_records contains record if {
	record := input.o6_9.applications[_]
	record.manure_type in allowed_manure_types
	record.technique in allowed_techniques
	record.land_use in {"arable", "grassland"}
	record.on_farm_land
	record.record_complete
	not record.external_device
}

eligible_application_records contains record if {
	record := input.o6_9.applications[_]
	record.manure_type in allowed_manure_types
	record.technique in allowed_techniques
	record.land_use in {"arable", "grassland"}
	record.on_farm_land
	record.record_complete
	record.external_device
	record.external_service_evidence
}

application_ineligible_reasons contains reason if {
	record := input.o6_9.applications[_]
	not record.technique in allowed_techniques
	reason := {"parcel_id": record.parcel_id, "reason": "unzulässiges_ausbringungsverfahren"}
}

application_ineligible_reasons contains reason if {
	record := input.o6_9.applications[_]
	not record.manure_type in allowed_manure_types
	reason := {"parcel_id": record.parcel_id, "reason": "nicht_foerderfaehiger_wirtschaftsduenger"}
}

application_ineligible_reasons contains reason if {
	record := input.o6_9.applications[_]
	record.external_device
	not record.external_service_evidence
	reason := {"parcel_id": record.parcel_id, "reason": "nachweis_fremdgeraet_fehlt"}
}

application_ineligible_reasons contains reason if {
	record := input.o6_9.applications[_]
	not record.record_complete
	reason := {"parcel_id": record.parcel_id, "reason": "schlagbezogene_aufzeichnung_unvollstaendig"}
}

claimed_eligible_application_m3 := sum([record.volume_m3 | record := eligible_application_records[_]])
application_volume_within_cap if claimed_eligible_application_m3 <= application_cap_m3
application_volume_excess_m3 := max([0, claimed_eligible_application_m3 - application_cap_m3])
claimed_application_premium_eur := sum([premium |
	record := eligible_application_records[_]
	rate := data.application_rates_eur_per_m3[record.technique]
	premium := record.volume_m3 * rate
])

eligible_separation_records contains record if {
	record := input.o6_9.separations[_]
	record.origin == "own_cattle"
	record.mechanical_separation
	record.record_complete
	not record.external_device
}

eligible_separation_records contains record if {
	record := input.o6_9.separations[_]
	record.origin == "own_cattle"
	record.mechanical_separation
	record.record_complete
	record.external_device
	record.external_service_evidence
}

separation_ineligible_reasons contains reason if {
	record := input.o6_9.separations[_]
	record.origin != "own_cattle"
	reason := {"date": record.date, "reason": "betriebsfremde_rinderguelle_nicht_foerderfaehig"}
}

separation_ineligible_reasons contains reason if {
	record := input.o6_9.separations[_]
	not record.mechanical_separation
	reason := {"date": record.date, "reason": "mechanische_trennung_in_feste_und_fluessige_phase_fehlend"}
}

claimed_eligible_separation_m3 := sum([record.volume_m3 | record := eligible_separation_records[_]])
separation_volume_within_cap if claimed_eligible_separation_m3 <= separation_cap_m3
separation_volume_excess_m3 := max([0, claimed_eligible_separation_m3 - separation_cap_m3])
claimed_separation_premium_eur := claimed_eligible_separation_m3 * data.separation_rate_eur_per_m3

pig_density_gve_per_arable_ha := object.get(input.o6_9, "pig_gve_annual_average", 0) / object.get(input.o6_9, "arable_area_ha", 0) if {
	object.get(input.o6_9, "arable_area_ha", 0) > 0
}

pig_feeding_density_eligible if {
	pig_density_gve_per_arable_ha >= data.minimum_pig_gve_per_arable_ha
}

pig_protein_violations contains violation if {
	ration := input.o6_9.pig_rations[_]
	limit := data.protein_limits_g_per_kg_at_88pct_dm[_]
	ration.category == limit.category
	ration.method == limit.method
	ration.protein_g_per_kg_88pct_dm > limit.maximum_g
	violation := {"category": ration.category, "method": ration.method, "maximum_g": limit.maximum_g, "actual_g": ration.protein_g_per_kg_88pct_dm}
}

pig_protein_compliant if {
	count(input.o6_9.pig_rations) > 0
	count(pig_protein_violations) == 0
	input.o6_9.pig_feeding_evidence_available
	input.o6_9.all_held_pigs_covered
}

pig_feeding_eligible if {
	input.farm.year >= 2025
	pig_feeding_density_eligible
	pig_protein_compliant
	not input.o6_9.gw_acker_same_named_pig_option
}

pig_feeding_premium_eur := object.get(input.o6_9, "arable_area_ha", 0) * data.pig_feeding_rate_eur_per_ha if {
	pig_feeding_eligible
}

annual_participation_satisfied if count(eligible_application_records) > 0
annual_participation_satisfied if count(eligible_separation_records) > 0
annual_participation_satisfied if pig_feeding_eligible
contract_continues if annual_participation_satisfied
contract_ends if not annual_participation_satisfied

premium_result := {
	"application_claimed_eur_before_volume_cap": claimed_application_premium_eur,
	"application_cap_m3": application_cap_m3,
	"application_claimed_m3": claimed_eligible_application_m3,
	"application_volume_within_cap": application_volume_within_cap,
	"separation_claimed_eur_before_volume_cap": claimed_separation_premium_eur,
	"separation_cap_m3": separation_cap_m3,
	"separation_claimed_m3": claimed_eligible_separation_m3,
	"separation_volume_within_cap": separation_volume_within_cap,
	"pig_feeding_premium_eur": object.get({"value": pig_feeding_premium_eur}, "value", 0),
}
