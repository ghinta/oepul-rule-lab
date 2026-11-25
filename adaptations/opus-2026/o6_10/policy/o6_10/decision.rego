# o6_10 – Gesamtentscheidung
# Aggregiert Teilnahme, Verpflichtungsverstöße, Zuschlag und Prämie für ein Antragsjahr.
package oepul.o6_10

decision := {
	"measure": "o6_10",
	"year": year,
	"contract_status": contract_status,
	"contract_valid": contract_valid,
	"vfh_area_ha": vfh_area_ha,
	"access_violations": access_violations,
	"takeover_rejections": takeover_rejections,
	"ineligible_parcels": ineligible_parcels,
	"premium_exclusions": premium_exclusions,
	"obligation_violations": obligation_violations,
	"farm_obligation_violations": farm_obligation_violations,
	"pending_reestablishments": pending_reestablishments,
	"combination_conflicts": combination_conflicts,
	"combination_notes": combination_notes,
	"eop": {
		"requested": eop_requested_flag,
		"granted": eop_supplement_granted,
		"rejections": eop_rejections,
		"reduction_factor": eop_reduction_factor,
	},
	"premium": {
		"gross_base_eur": gross_base_eur,
		"gross_supplement_eur": gross_supplement_eur,
		"gross_total_eur": gross_total_eur,
		"content_reduction_percent": content_reduction_percent,
		"modulation_factor": modulation_factor,
		"parcels": parcel_payments,
		"payable_total_eur": payable_total_eur,
		"payment_deadline": payment_deadline,
		"max_advance_payment_eur": max_advance_payment_eur,
		"excluded_from_measure": excluded_from_measure_flag,
	},
	"notices": notices,
}

default excluded_from_measure_flag := false

excluded_from_measure_flag if excluded_from_measure

default eop_requested_flag := false

eop_requested_flag if eop_requested
