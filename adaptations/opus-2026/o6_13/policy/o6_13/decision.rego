# o6_13 – aggregierte Entscheidung
package oepul.o6_13

default eligible := false

eligible if {
	contract_in_force
	count(nue_parcels) > 0
	eligible_premium_area_ha > 0
	not exclusion_from_measure
}

# Boolesche Zusammenfassungen mit Default false (für eine stets definierte Entscheidung)
default out_access_requirements_met := false

out_access_requirements_met if access_requirements_met

default out_no_contract_due_to_access_failure := false

out_no_contract_due_to_access_failure if no_contract_due_to_access_failure

default out_is_one_year_measure := false

out_is_one_year_measure if is_one_year_measure

default out_contract_period := null

out_contract_period := contract_period

default out_contract_basis_valid := false

out_contract_basis_valid if contract_basis_valid

default out_contract_in_force := false

out_contract_in_force if contract_in_force

default out_contract_lapses_after_year := false

out_contract_lapses_after_year if contract_lapses_after_year

default out_conversion_available := false

out_conversion_available if conversion_available

default out_takeover_only_in_individual_cases := false

out_takeover_only_in_individual_cases if takeover_only_in_individual_cases

default out_minimum_participation_met := false

out_minimum_participation_met if minimum_participation_met

default out_minor_amount := false

out_minor_amount if payment_may_be_withheld_as_minor_amount

decision := {
	"measure": measure_code,
	"year": year,
	"eligible": eligible,
	"access_requirements_met": out_access_requirements_met,
	"access_failures": access_failures,
	"no_contract_due_to_access_failure": out_no_contract_due_to_access_failure,
	"contract": {
		"is_one_year_measure": out_is_one_year_measure,
		"period": out_contract_period,
		"basis_valid": out_contract_basis_valid,
		"in_force": out_contract_in_force,
		"failures": contract_failures,
		"lapses_after_year": out_contract_lapses_after_year,
		"new_application_deadline_for_next_year": new_application_deadline_for_next_year,
		"earliest_withdrawal_without_loss": earliest_withdrawal_without_loss,
		"withdrawal_findings": withdrawal_findings,
		"conversion_available": out_conversion_available,
		"takeover_only_in_individual_cases": out_takeover_only_in_individual_cases,
		"takeover_findings": takeover_findings,
	},
	"minimum_participation_met": out_minimum_participation_met,
	"obligation_violations": obligation_violations,
	"non_creditable_applications": non_creditable_applications,
	"parcels": parcel_results,
	"force_majeure_application_required": force_majeure_application_required,
	"premium": {
		"eligible_area_ha": eligible_premium_area_ha,
		"gross_eur": gross_premium_eur,
		"content_reduction_percent": content_reduction_percent,
		"after_content_reduction_eur": premium_after_content_reduction_eur,
		"modulation_factor": round4(farm_modulation_factor),
		"net_eur": net_premium_eur,
		"payment_deadline": payment_deadline,
		"max_advance_payment_eur": max_advance_payment_eur,
		"may_be_withheld_as_minor_amount": out_minor_amount,
	},
	"sanction": sanction_result,
}
