package oepul.o6_12

import rego.v1

# Mehrere Teilentscheidungen können gleichzeitig auf einen Schlag zutreffen.
# Fehlende Eingaben bleiben in den Teilentscheidungen als null sichtbar.
assessment := {
	"measure": "o6_12",
	"year": year,
	"entry_checks": entry_checks, "farm_access": eligibility, "area_base_before_sanctions_modulation_caps_eur": base_result,
	"parcel_results": [parcel_result(p) | some p in input.land.parcels],
	"applications": application_findings,
	"ordered_controls": order_duties,
	"document_findings": document_findings,
	"purchase_and_storage": stock_findings,
	"coding_actions": coding_actions,
	"exit": exit_result,
} if {
	is_array(input.land.parcels)
}

exit_result := v if v := exit_effect

else := null

entry_checks := object.union(
	{
		"applicant": null, "farm_first_year_size": null, "measure_first_year_size": null,
		"bio_combination": null, "regular_application_timely": null,
	},
	{k: v | some pair in checks; k := pair[0]; v := pair[1]},
)

checks contains ["applicant", v] if v := applicant_ok
checks contains ["farm_first_year_size", v] if v := farm_size_ok
checks contains ["measure_first_year_size", v] if v := measure_size_ok
checks contains ["bio_combination", v] if v := bio_combination_ok
checks contains ["regular_application_timely", v] if v := entry_timely
parcel_result(p) := {
	"parcel_id": p.parcel_id, "group": group_or_null(p), "premium_exclusions": parcel_exclusions(p), "actions": parcel_actions(p),
	"area_base_before_farm_checks_eur": base_or_null(p), "required_psm_codes": codes_or_null(p),
	"missing_psm_codes": missing_codes(p),
}

group_or_null(p) := g if g := crop_group(p)

else := null

base_or_null(p) := v if v := parcel_base_eur(p)

else := null

codes_or_null(p) := minimum_codes(p) if {
	covered(p)
	contract_year
	is_array(p.operations.psm_events)
}

else := set() if year >= 2026

else := null

missing_codes(p) := codes - {c | some c in p.payment.codes} if {
	codes := codes_or_null(p)
	is_set(codes)
	is_array(p.payment.codes)
} else := null

# Vollständiger Flächengrundbetrag über alle Schläge, wenn der betriebliche
# Zugang und die Flächenmerkmale feststehen. Die Sanktion wird separat bestimmt.
screened_base_eur := 0 if exit_effect

else := 0 if eligibility == "Zugangsvoraussetzung nicht erfüllt"

else := sum([v | some p in input.land.parcels; v := parcel_base_eur(p)]) if {
	eligibility == "betrieblicher Zugang erfüllt"
	is_array(input.land.parcels)
	every p in input.land.parcels { is_number(parcel_base_eur(p)) }
}

eligibility := "genehmigter Sonderausstieg" if exit_effect

else := "Vertrag beendet" if contract_ended

else := "Zugangsvoraussetzung nicht erfüllt" if {
	contract_year
	false in access_values
}

else := "betrieblicher Zugang erfüllt" if {
	contract_year
	every v in access_values { v == true }
}

else := "fehlende Angaben oder Vertragsklärung"

access_values := [entry_checks.applicant, entry_checks.farm_first_year_size, entry_checks.measure_first_year_size, entry_checks.bio_combination]
base_result := n if n := screened_base_eur

else := null

contract_ended if contract.status == "ended"
