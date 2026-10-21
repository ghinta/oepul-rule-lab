# Zusammenfassende Entscheidung für die Maßnahme o6_2.
package oepul.o6_2

default eligible := false

eligible if {
	contract_valid
	count(access_condition_failures) == 0
	not control_refused
	not excluded_from_measure
}

decision := {
	"measure": "o6_2",
	"year": year,
	"eligible": eligible,
	"contract_valid": contract_valid_value,
	"access_condition_failures": access_condition_failures,
	"contract_failures": contract_failures,
	"livestock_farm": is_livestock_farm_value,
	"stocking_density_rgve_per_ha": object.get({"v": stocking_density_rgve_per_ha}, "v", null),
	"rgve_band": rgve_band,
	"nitrogen_kg_per_ha": object.get({"v": n_per_ha}, "v", null),
	"violations": violations,
	"review_items": review_items,
	"premium_eligible_area_ha": premium_eligible_area_ha,
	"gross_premium_eur": gross_premium_eur,
	"modulation_factor": farm_modulation_factor,
	"net_premium_eur": net_premium_eur_value,
	"repayment_of_all_premiums_required": repayment_value,
	"parcel_exclusions": parcel_exclusions,
	"force_majeure_application_required": force_majeure_application_required,
}

contract_valid_value if {
	contract_valid
} else := false

is_livestock_farm_value if {
	is_livestock_farm
} else := false

net_premium_eur_value := net_premium_eur if {
	eligible
} else := 0

repayment_value if {
	repayment_of_all_premiums_required
} else := false
