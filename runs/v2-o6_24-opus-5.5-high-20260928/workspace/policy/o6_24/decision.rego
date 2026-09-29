# o6_24 – Gesamtentscheidung
# Aggregiert Zugang, Vertrag, Auflagen, Kombination und Prämie zu einem Ergebnisobjekt.
package oepul.o6_24

# Konditionalität: Einhaltung ist Voraussetzung für die Förderung in voller Höhe.
default conditionality_breach := false

conditionality_breach if input.compliance.conditionality_breach == true

# Besondere Umstände (Punkt 1.7.4 SRL): Prämie im Jahr des Eintritts grundsätzlich nicht gewährt,
# außer höhere Gewalt oder Eintritt nach dem 15.04.
circumstance := object.get(participation, "circumstance", null)

default circumstance_premium_blocked := false

circumstance_premium_blocked if {
	circumstance != null
	circumstance.force_majeure != true
	date_ns(circumstance.date) <= date_ns(date_string(year, 4, 15))
}

circumstance_repayment_waivable if {
	circumstance != null
	circumstance.reported == true
}

decision := {
	"measure": "o6_24",
	"year": year,
	"access": {
		"conditions_met": access_conditions_met,
		"failures": access_failures,
		"arable_area_in_area_ha": arable_area_in_area_ha,
		"minimum_participation_met": minimum_participation_met,
	},
	"contract": {
		"valid_for_year": contract_valid_for_year,
		"period": contract_period,
		"lapses": contract_lapses,
		"renews_automatically_next_year": renews_automatically_next_year,
		"new_measure_application_required_for_next_year": new_measure_application_required_for_next_year,
		"multi_year_repayment_applicable": multi_year_repayment_applicable,
		"area_increase_premium_restricted": area_increase_premium_restricted,
		"area_reduction_tolerance_applicable": area_reduction_tolerance_applicable,
		"combination_conflicts": combination_conflicts,
		"farm_level_exclusion_conflicts": farm_level_exclusion_conflicts,
	},
	"parcels": {
		"eligible_parcel_ids": eligible_parcel_ids,
		"opwrrl_coding_required": opwrrl_coding_required,
		"national_park_parcels_with_premium": national_park_parcels_with_premium,
	},
	"premium": {
		"rate_eur_per_ha": rate_eur_per_ha,
		"eligible_area_ha": eligible_area_ha,
		"gross_premium_eur": gross_premium_eur,
		"sanction_percent": applied_sanction_percent,
		"modulation_factor": farm_modulation_factor,
		"area_cap_exceedances": area_cap_exceedances,
		"granted": premium_granted,
		"final_premium_eur": final_premium_eur,
		"payout_may_be_withheld": payout_may_be_withheld,
		"max_advance_payment_eur": max_advance_payment_eur,
		"payout_deadline": payout_deadline,
		"conditionality_breach": conditionality_breach,
		"circumstance_premium_blocked": circumstance_premium_blocked,
	},
	"violations": violations,
	"missing_inputs": missing_inputs,
}
