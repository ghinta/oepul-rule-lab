# Tierwohl – Schweinehaltung (o6_22): aggregated decision document.
package oepul.o6_22

group_issue_list := [issue | some issue in group_issues]

result := {
	"measure": params.measure_code,
	"year": year,
	"active_categories": active_categories,
	"active_supplements": active_supplement_keys,
	"category_gve": category_gve,
	"participating_gve": participating_gve,
	"min_participation_met": min_participation_met,
	"measure_valid": measure_valid,
	"category_contract_lapsed": category_contract_lapsed,
	"tgd_required": tgd_required,
	"group_issues": group_issue_list,
	"required_deregistration_count": required_deregistration_count,
	"premium_components": premium_components,
	"gross_premium_eur": gross_premium,
	"modulation_factor": modulation_factor(farm_total_area_ha),
	"net_premium_eur": net_premium,
	"payout_may_be_waived": payout_waivable,
	"violations": violations,
	"missing_inputs": missing_inputs,
	"advisories": advisories,
}

default min_participation_met := false

default tgd_required := false

default measure_valid := false

default payout_waivable := false

# Rule: O622-GEN-PAY-02
payout_waivable if payout_may_be_waived(net_premium)
