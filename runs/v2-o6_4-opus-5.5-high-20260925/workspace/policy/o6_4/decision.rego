# Aggregierte Entscheidung für die Maßnahme o6_4.
package oepul.o6_4

parcel_results[pid] := {
	"eligibility": eligibility[pid],
	"bm_code": object.get(parcel_bm_code_or_null, pid, null),
	"premium_status": premium_parcel_reason(pid),
	"premium_eur": parcel_premium[pid],
} if {
	some pid, _ in enrolled_parcels
}

parcel_bm_code_or_null[pid] := parcel_bm_code(p) if {
	some pid, p in enrolled_parcels
}

decision := {
	"measure_id": measure_id,
	"year": year,
	"application": application_status,
	"applicant_eligible": applicant_eligible_flag,
	"minimum_farm_size_met": minimum_farm_size_flag,
	"parcels": parcel_results,
	"violations": violation,
	"advisories": advisory,
	"combination_conflicts": combination_conflict,
	"cap_exceeded": cap_exceeded,
	"premium_before_modulation_eur": premium_before_modulation,
	"modulation_factor": modulation_factor(farm_total_area_ha),
	"premium_after_modulation_eur": premium_after_modulation,
	"excluded_from_measure": excluded_flag,
}

default applicant_eligible_flag := false

applicant_eligible_flag if applicant_eligible

default minimum_farm_size_flag := false

minimum_farm_size_flag if minimum_farm_size_met

default excluded_flag := false

excluded_flag if excluded_from_measure
