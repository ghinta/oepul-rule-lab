package oepul.o6_24

import rego.v1

# Zusammenfassung: ÖPUL-Förderverpflichtungen (sanktionsrelevant nach GSP-AV § 48),
# wasserrechtliche Basisbefunde und Hinweise.

commitment_violations contains {"rule_id": "o6_24.fert.n_limit", "parcel_id": pid, "detail": d} if {
	some pid, d in n_limit_exceeded
	not has_increased_n_permit(pid)
}

commitment_violations contains {"rule_id": "o6_24.fert.period", "parcel_id": pid, "detail": dates} if {
	some pid, dates in applications_outside_period
}

commitment_violations contains {"rule_id": "o6_24.fert.increase_10pct_conditions", "parcel_id": pid, "detail": keys} if {
	some pid, keys in increase_10pct_not_valid
	n_limit_exceeded[pid]
}

commitment_violations contains {"rule_id": "o6_24.fert.separate_plot", "parcel_id": pid, "detail": "Teilflächen mit höherer Düngeklasse als eigener Schlag zu beantragen"} if {
	separate_plot_required[pid]
}

commitment_violations contains {"rule_id": "o6_24.records.farm", "parcel_id": null, "detail": v} if {
	some v in farm_record_violations
}

commitment_violations contains {"rule_id": "o6_24.records.plot", "parcel_id": pid, "detail": missing} if {
	some pid, missing in plot_record_missing
}

commitment_violations contains {"rule_id": "o6_24.records.one_week", "parcel_id": pid, "detail": dates} if {
	some pid, dates in late_entries
}

commitment_violations contains {"rule_id": "o6_24.apply.opwrrl_code", "parcel_id": pid, "detail": "Bewilligungsfläche nicht mit OPWRRL gekennzeichnet"} if {
	some pid in opwrrl_code_missing
}

baseline_findings contains {"rule_id": "o6_24.gwsp.permit_required", "parcel_id": pid, "detail": reasons} if {
	some pid, reasons in gwsp_permit_required_reasons
}

baseline_findings contains {"rule_id": "o6_24.gwsp.wrg_175_210", "parcel_id": pid, "detail": d} if {
	some pid, d in wrg_permit_required
}

baseline_findings contains {"rule_id": "o6_24.gwsp.wg2_permits", "parcel_id": null, "detail": k} if {
	some k in wg2_permit_missing
}

baseline_findings contains {"rule_id": "o6_24.fert.soy", "parcel_id": pid, "detail": "Sojabohnendüngung ohne zulässige Begründung"} if {
	soy_fertilization_not_justified[pid]
}

notes contains {"rule_id": "o6_24.fert.napv_reference", "parcel_id": pid, "detail": "keine Tabellenobergrenze – NAPV-Obergrenze maßgeblich (nicht in Quellen)"} if {
	napv_limit_required[pid]
}

notes contains {"rule_id": "o6_24.fert.period_row_assumed", "parcel_id": pid, "detail": "Kultur in Tab. 4 nicht eindeutig – Zeile 'andere Kulturen außer Begrünungen' angenommen"} if {
	period_row_assumed[pid]
}

notes contains {"rule_id": "o6_24.notice2026.individual_request", "parcel_id": pid, "detail": "einzelflächenbezogenes Ansuchen auf höhere Gewalt erforderlich"} if {
	individual_force_majeure_request_required[pid]
}

notes contains {"rule_id": "o6_24.gen.force_majeure_deadline", "parcel_id": null, "detail": c} if {
	some c in force_majeure_late
}

notes contains {"rule_id": "o6_24.gen.combination", "parcel_id": pid, "detail": c} if {
	some pid, c in combination_conflicts
}

notes contains {"rule_id": "o6_24.gen.area_cap", "parcel_id": pid, "detail": t} if {
	some pid, t in cap_exceeded_parcels
}

decision := {
	"measure": "o6_24",
	"year": farm_year,
	"wrrl_arable_area_ha": wrrl_arable_area_ha,
	"min_participation_met": min_participation_met_bool,
	"contract_valid": contract_valid_bool,
	"participation_eligible": participation_eligible_bool,
	"participation_reasons": participation_reasons,
	"eligible_parcels": eligible_parcels,
	"parcel_ineligibility": parcel_ineligibility,
	"eligible_area_ha": eligible_area_ha,
	"premium_rate_eur_per_ha": premium_rate_or_null,
	"gross_premium_eur": gross_premium_eur,
	"content_reduction_percent": content_reduction_percent,
	"premium_after_modulation_eur": premium_after_modulation,
	"modulation_factor": modulation_factor,
	"n_limits_kg_per_ha": n_limit_kg_per_ha,
	"commitment_violations": commitment_violations,
	"baseline_findings": baseline_findings,
	"notes": notes,
}

min_participation_met_bool if {
	min_participation_met
} else := false

contract_valid_bool if {
	contract_valid
} else := false

participation_eligible_bool if {
	participation_eligible
} else := false

default premium_rate_or_null := null

premium_rate_or_null := premium_rate_eur_per_ha
