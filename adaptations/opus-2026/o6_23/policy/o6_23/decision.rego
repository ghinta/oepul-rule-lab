# Zusammenfassende Entscheidung für o6_23.
package oepul.o6_23

parcel_results[p.parcel_id] := {
	"codes": sort([c | some c in parcel_codes(p)]),
	"unknown_codes": sort([c | some c in parcel_unknown_codes(p)]),
	"access_failures": sort([r | some r in parcel_access_failures(p)]),
	"obligation_violations": sort([v | some v in parcel_obligation_violations(p)]),
	"combination_conflicts": sort([m | some m in parcel_combination_conflicts(p)]),
	"annex_j_conflicts": sort([c | some c in parcel_annex_j_conflicts(p)]),
	"eligible": parcel_access_ok(p),
	"premium_granted": p in premium_parcels,
	"rate_eur_per_ha": parcel_rate_eur_per_ha(p),
	"capped_rate_eur_per_ha": parcel_capped_rate_eur_per_ha(p),
	"cap_exceeded": parcel_cap_exceeded(p),
	"premium_eur": parcel_premium_value(p),
	"national_park_premium_allowed": national_park_premium_allowed_value(p),
	"biodiversity_creditable": p.parcel_id in biodiversity_creditable_parcels,
	"drought_2026_cut_date_release_used": drought_2026_cut_date_release_used_value(p),
	"use_frequency_mismatch": use_frequency_mismatch_value(p),
} if {
	some p in n2_parcels
}

parcel_premium_value(p) := parcel_premium_eur(p) if p in premium_parcels

parcel_premium_value(p) := 0 if not p in premium_parcels

national_park_premium_allowed_value(p) if national_park_premium_allowed(p)

national_park_premium_allowed_value(p) := false if not national_park_premium_allowed(p)

drought_2026_cut_date_release_used_value(p) if drought_2026_cut_date_release_used(p)

drought_2026_cut_date_release_used_value(p) := false if not drought_2026_cut_date_release_used(p)

use_frequency_mismatch_value(p) if use_frequency_mismatch(p)

use_frequency_mismatch_value(p) := false if not use_frequency_mismatch(p)

# Mindestteilnahme: in jedem Teilnahmejahr zumindest ein Schlag nach den Vorgaben.
minimum_participation_met if count(premium_parcels) >= params.measure.minimum_parcels_per_year

any_obligation_violation if {
	some p in premium_parcels
	count(parcel_obligation_violations(p)) > 0
}

farm_failures contains "applicant_not_eligible" if not applicant_eligible

farm_failures contains "minimum_farm_size_not_met" if not minimum_farm_size_met

farm_failures contains "contract_not_active" if not contract_active_in_year

farm_failures contains "minimum_participation_not_met" if not minimum_participation_met

farm_failures contains "on_site_check_refused" if {
	object.get(input, ["farm", "oepul", "on_site_check_refused"], false) == true
}

farm_failures contains "excluded_from_measure" if excluded_from_measure

# Nichteinhaltung der Konditionalität: Verwaltungssanktionen gemäß Art. 83 bis 86
# VO (EU) 2021/2116 (Höhe nicht aus den Quellen berechenbar).
farm_findings contains "conditionality_not_complied" if {
	object.get(input, ["farm", "oepul", "conditionality_compliant"], true) == false
}

farm_findings contains "obligation_violations_present" if any_obligation_violation

farm_findings contains "payout_may_be_withheld_below_50_eur" if {
	count(farm_failures) == 0
	payout_below_minimum
}

farm_findings contains "project_confirmation_without_n2_code" if count(parcels_with_confirmation_without_n2_code) > 0

farm_findings contains "divsz_code_missing_on_cut_delay_parcel" if count(biodiversity_divsz_missing) > 0

farm_findings contains "divsz_code_without_cut_delay" if count(biodiversity_divsz_without_cut_delay) > 0

farm_findings contains "reentry_requires_new_application" if reentry_requires_new_application

# Bei Nichterfüllung von Zugangsvoraussetzungen kommt bei einjährigen Maßnahmen
# kein gültiger Vertrag zustande.
default contract_valid := false

contract_valid if count(farm_failures) == 0

premium_eur := net_premium_eur if contract_valid

premium_eur := 0 if not contract_valid

decision := {
	"measure": params.measure.measure_id,
	"year": year,
	"contract_valid": contract_valid,
	"farm_failures": sort([f | some f in farm_failures]),
	"farm_findings": sort([f | some f in farm_findings]),
	"applicant_failures": sort([f | some f in applicant_failures]),
	"parcels": parcel_results,
	"gross_premium_eur": gross_premium_eur,
	"sanction_reduction_percent": sanction_reduction_percent,
	"modulation_factor": modulation_factor,
	"premium_eur": premium_eur,
	"biodiversity_creditable_area_ha": biodiversity_creditable_area_ha,
	"payment_due_by": payment_due_by,
}
