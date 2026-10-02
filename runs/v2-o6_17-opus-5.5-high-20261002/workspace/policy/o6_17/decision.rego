# o6_17 – aggregierte Entscheidung
# Fasst Zugangsvoraussetzungen, Verpflichtungen und Prämie zusammen.
package oepul.o6_17

import rego.v1

default contract_concluded := false

default access_conditions_met := false

default is_livestock_farm := false

default premium_payable := false

default livestock_density_value := null

livestock_density_value := livestock_density

violations := (((((((access_violations | ploughing_violations) | fill_up_declaration_violations) | renewal_equipment_violations) | training_violations) | soil_sampling_violations) | agl_violations) | general_violations) | combination_conflicts

obligation_violation_count := count(violations) - count(access_violations)

premium_payable if {
	contract_concluded
	not no_premium_due_to_access
	count(access_violations) == 0
}

premium_payable_eur := premium_after_modulation_eur if premium_payable

premium_payable_eur := 0 if not premium_payable

decision := {
	"measure": "o6_17",
	"year": year,
	"contract_concluded": contract_concluded,
	"contract_end": contract_end,
	"access_conditions_met": access_conditions_met,
	"is_livestock_farm": is_livestock_farm,
	"livestock_density_rgve_per_ha": livestock_density_value,
	"base_premium_eur": base_premium_eur,
	"agl_premium_eur": agl_premium_eur,
	"agl_cap_ha": agl_cap_ha,
	"modulation_factor": modulation_factor,
	"premium_payable_eur": premium_payable_eur,
	"violations": violations,
}
