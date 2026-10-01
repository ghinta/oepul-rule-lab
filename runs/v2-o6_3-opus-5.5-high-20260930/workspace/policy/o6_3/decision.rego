# Aggregierte Entscheidung Heuwirtschaft inkl. 2026-Hinweise zu höherer Gewalt.
package o6_3

# N26-HG-01: Antrag auf höhere Gewalt bei trockenheitsbedingter Nichteinhaltbarkeit (2026).
force_majeure := object.get(input, ["farm", "oepul", "force_majeure"], {})

force_majeure_recognised if object.get(force_majeure, "recognised", false) == true

drought_force_majeure_claim_possible if {
	year == 2026
	object.get(force_majeure, "cause", "") == "drought_2026"
	object.get(force_majeure, "obligations_not_maintainable", false) == true
}

force_majeure_submission_channel := "eAMA Register Eingaben – Ansuchen auf Anerkennung höherer Gewalt" if drought_force_majeure_claim_possible

# Inhaltliche Verstöße, die nicht durch anerkannte höhere Gewalt gedeckt sind.
effective_violations := violations if {
	not force_majeure_recognised
} else := set()

decision := {
	"measure": "o6_3",
	"year": year,
	"contract_start_year": contract_start_year,
	"first_contract_year": is_first_contract_year_bool,
	"contract_established": contract_established_bool,
	"access_requirement_failures": access_requirement_failures,
	"livestock_status": livestock_status,
	"total_rgve": total_rgve,
	"forage_area_ha": forage_area_ha,
	"min_participation_area_ha": min_participation_area_ha,
	"option_no_mower_conditioner_active": option_active_bool,
	"rate_eur_per_ha": current_rate,
	"eligible_area_ha": eligible_area_ha,
	"premium_gross_eur": premium_gross_eur,
	"modulation_factor": modulation_factor(farm_total_area_ha),
	"premium_after_modulation_eur": premium_after_modulation_eur,
	"violations": effective_violations,
	"option_application_issues": option_application_issues,
	"takeover_issues": takeover_issues,
	"full_recovery_required": full_recovery_required_bool,
	"area_decrease_repayment_required": area_decrease_repayment_bool,
}

is_first_contract_year_bool if {
	is_first_contract_year
} else := false

contract_established_bool if {
	contract_established
} else := false

full_recovery_required_bool if {
	full_recovery_required
} else := false

area_decrease_repayment_bool if {
	area_decrease_repayment_required
} else := false
