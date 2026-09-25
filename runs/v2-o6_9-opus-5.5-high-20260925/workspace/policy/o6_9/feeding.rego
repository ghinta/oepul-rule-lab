# Strongly nitrogen-reduced feeding of pigs (from application year 2025).
package oepul.o6_9

cp := data.o6_9

pig_feeding := object.get(input, ["livestock", "pig_feeding"], {})

rations := object.get(pig_feeding, "rations", [])

# Arable area for the density threshold: total arable area without deductions.
arable_area_total_ha := input.land.arable_area_ha if is_number(input.land.arable_area_ha)

else := sum([p.area_ha | some p in parcels; p.land_use == "arable"])

pig_gve_per_arable_ha := pig_gve / arable_area_total_ha if arable_area_total_ha > 0

else := 0

default n_feeding_density_met := false

n_feeding_density_met if pig_gve_per_arable_ha >= params.n_feeding.min_pig_gve_per_arable_ha

protein_limit(category) := row.max_g_per_kg_88dm if {
	some row in cp.crude_protein_limits
	row.animal_category == category
}

ration_compliant(r) if r.crude_protein_g_per_kg_88dm <= protein_limit(r.animal_category)

fattening_categories := {c | some c in cp.fattening_phase_categories} | {"fattening_average"}

fattening_rations := [r | some r in rations; r.animal_category in fattening_categories]

phase_rations := [r | some r in rations; r.animal_category in {c | some c in cp.fattening_phase_categories}]

# Fattening pigs / non-mated gilts: either the average value or the phase
# limits must be met, not both.
default fattening_compliant := false

fattening_compliant if count(fattening_rations) == 0

fattening_compliant if {
	some r in rations
	r.animal_category == "fattening_average"
	ration_compliant(r)
}

fattening_compliant if {
	count(phase_rations) > 0
	every r in phase_rations {
		ration_compliant(r)
	}
}

non_fattening_rations_compliant if {
	every r in rations {
		ration_ok_or_fattening(r)
	}
}

ration_ok_or_fattening(r) if r.animal_category in fattening_categories

ration_ok_or_fattening(r) if ration_compliant(r)

unknown_ration_categories contains r.animal_category if {
	some r in rations
	not protein_limit(r.animal_category)
}

default protein_limits_met := false

protein_limits_met if {
	pig_feeding.all_pigs_covered == true
	count(rations) > 0
	count(unknown_ration_categories) == 0
	non_fattening_rations_compliant
	fattening_compliant
}

valid_protein_source(s) if {
	some row in cp.protein_value_sources
	row.source == s
}

default n_feeding_eligible := false

n_feeding_eligible if {
	participates_n_feeding
	n_feeding_density_met
	protein_limits_met
	not n_feeding_combination_conflict
}

# Premium basis: arable parcels (no national park, no OP code, harvest obligation met).
parcel_has_op_code(p) if {
	"OP" in object.get(p, "oepul_codes", [])
}

parcel_in_national_park(p) if object.get(p, ["constraints", "in_national_park"], false) == true

n_feeding_premium_parcel(p) if {
	p.land_use == "arable"
	parcel_in_austria(p)
	not parcel_in_national_park(p)
	not parcel_has_op_code(p)
	harvest_obligation_met(p)
}

n_feeding_premium_area_ha := sum([p.area_ha | some p in parcels; n_feeding_premium_parcel(p)]) if count(parcels) > 0

else := arable_area_total_ha
