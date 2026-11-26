package oepul.o6_10

import rego.v1

# Öffentliche Auswertung. Fehlende Voraussetzungen für einen Tarif lassen die
# betreffende Tarifzeile weg. Findings nennen die konkret zu prüfende Regel.
access_checks.measure_minimum := meets_measure_minimum
access_checks.measure_area_ha := measure_area_ha
access_checks.farm_minimum := farm_minimum
access_checks.contract_route := contract_route
access_checks.ordinary_entry_timely := ordinary_entry_timely(input.farm.oepul.contract)
access_checks.period := contract_period(input.farm.year)
access_checks.approved := input.farm.oepul.contract.ama_approved
access_checks.applicant if applicant_allowed

access_checks.applicant := false if {
	applicant := input.farm.oepul.applicant
	false in [object.get(applicant, "active_farmer", null), object.get(applicant, "agricultural_activity", null), object.get(applicant, "own_name_and_account", null), object.get(applicant, "disposal_rights", null)]
}

access_checks.applicant := false if {
	input.farm.year >= 2025
	input.farm.oepul.applicant.kind != "individual"
	public_entity(input.farm.oepul.applicant)
}

access_checks.applicant := false if input.farm.oepul.applicant.kind == "other"

access_findings contains "o6_10.exit_limit" if contract_route == "withdrawal_after_control"

access_findings contains "o6_10.minimum" if meets_measure_minimum == false

access_findings contains "o6_10.first_area" if farm_minimum == false

access_findings contains "o6_10.applicant" if access_checks.applicant == false

# Bestätigte Zugangshindernisse schließen die individuellen Tarifkomponenten aus.
access_blocked if false in [object.get(access_checks, "measure_minimum", null), object.get(access_checks, "farm_minimum", null), object.get(access_checks, "applicant", null), object.get(access_checks, "approved", null)]

access_blocked if {
	access_checks.ordinary_entry_timely == false
	input.farm.oepul.contract.takeover_requested == false
	not takeover_allowed
}

access_blocked if {
	access_checks.ordinary_entry_timely == false
	input.farm.oepul.takeover.ama_approved == false
}

access_blocked if contract_route == "withdrawn"
access_blocked if {"rule_id": "o6_10.refusal", "outcome": "reject_current_year_and_reverse_contracts"} in administrative_findings
access_blocked if input.farm.oepul.contract.annual_mfa_with_units == false

access_status := "excluded" if access_blocked

else := "confirmed" if {
	access_checks.measure_minimum
	access_checks.farm_minimum
	access_checks.applicant
	access_checks.approved
	contract_route in {"continuation", "new_application", "takeover"}
} else := "unresolved"

land_issue[p.parcel_id] contains "op" if {
	some p in input.land.parcels
	some reason in p.oepul.op_reasons
	some row in t.op_reasons
	reason == row.reason
}

record_findings contains {"parcel_id": p.parcel_id, "rule_id": "o6_10.records", "missing": missing} if {
	some p in input.land.parcels
	crop_group(p)
	p.oepul.in_at
	c := p.operations.erosion
	is_object(c.cover_record)
	events := {kind | some kind in object.get(c, "record_events", [])}
	observed := {e.kind | some e in c.events; year_of(e.date) == input.farm.year}
	reseeds := {"sowing" | some e in c.events; year_of(e.reseeded_on) == input.farm.year}
	missing := missing_cover_records(c.cover_record, [kind | some kind in ((events | observed) | reseeds)])
	count(missing) > 0
}

record_findings contains {"parcel_id": p.parcel_id, "application_index": i, "rule_id": "o6_10.supp_records", "missing": missing} if {
	some p in input.land.parcels
	crop_group(p)
	p.oepul.in_at
	"EOP" in p.oepul.codes
	some i, a in p.operations.erosion.applications
	not other_application_year(a)
	missing := missing_application_records(a)
	count(missing) > 0
}

other_application_year(a) if year_of(a.date) != input.farm.year

access_findings contains "o6_10.conditionality" if {
	some v in input.farm.oepul.conditionality
	v == false
}

access_findings contains "o6_10.organisation" if {
	input.farm.oepul.organisation_program
	some p in input.land.parcels
	"EOP" in p.oepul.codes
}

access_findings contains "o6_10.substitute" if {
	input.farm.oepul.organisation_program == false
	some p in input.land.parcels
	"EOP" in p.oepul.codes
	is_array(input.land.parcels)
	every parcel in input.land.parcels { eop_assessed_or_unclaimed(parcel) }
	count(supplement_parcels) == 0
}

# Nur eine vollständige Negativauskunft belegt einen fehlenden Ersatzeinsatz.
eop_assessed_or_unclaimed(p) if {
	is_array(p.oepul.codes)
	not "EOP" in p.oepul.codes
}

eop_assessed_or_unclaimed(p) if {
	"EOP" in p.oepul.codes
	is_array(p.operations.erosion.applications)
	every a in p.operations.erosion.applications { application_ruled_out(a) }
}

application_ruled_out(a) if a.replaces_psm == false
application_ruled_out(a) if a.register_rate_met == false
application_ruled_out(a) if a.kind == "other"
application_ruled_out(a) if year_of(a.date) != input.farm.year

combination_terms contains {"parcel_id": p.parcel_id, "other": m, "cell": cell} if {
	some p in input.land.parcels
	p.oepul.claimed_for_measure
	some m in p.oepul.same_area_measures
	m != "10"
	cell := combination("10", m)
}

# Tarifvolumen als Band, vor individueller Sanktion, Modulation und Deckelung.
# Die Prüfmerkmale und Dokumentationslücken sind separat im Ergebnis sichtbar.
tariff_components contains {"parcel_id": p.parcel_id, "component": "base", "eur_ha": rate, "eur": [rate[0] * p.area_ha, rate[1] * p.area_ha]} if {
	some p in input.land.parcels
	p.oepul.in_at
	p.oepul.in_mfa
	p.oepul.claimed_for_measure
	not has_land_issue(p.parcel_id)
	not access_blocked
	rate := base_rate(p)
}

tariff_components contains {"parcel_id": p.parcel_id, "component": "EOP", "eur_ha": rate, "eur": [rate[0] * p.area_ha, rate[1] * p.area_ha]} if {
	some p in input.land.parcels
	not has_land_issue(p.parcel_id)
	not access_blocked
	rate := supplement_rate(p)
}

gve_factor(group, category) := r if {
	some r in t.livestock_units
	r.group == group
	r.category == category
}

livestock_notes := t.livestock_notes

term_for(m) := r if {
	some r in t.terms
	r.measure == m
}

multi_term(start) := r if {
	some r in t.multi_start
	r.first_year == start
}

restricted_access(m) if m in t.limited_access

restricted_takeover(m) if {
	some row in t.limited_takeover
	m in row.codes
}

restricted_takeover(m) if {
	some row in t.limited_takeover
	m == row.description
}

assessment := {
	"access_checks": access_checks,
	"access_status": access_status,
	"access_findings": access_findings,
	"parcel_findings": parcel_findings,
	"record_findings": record_findings,
	"administrative_findings": administrative_findings,
	"circumstance_review": circumstance_review,
	"combination_terms": combination_terms,
	"farm_combination_conflicts": farm_conflicts,
	"parcel_combination_conflicts": parcel_combination_conflicts,
	"payment_parameters": payment_parameters,
	"automatic_force_majeure": automatic_force_majeure,
	"tariff_components_before_adjustments": tariff_components,
}

has_land_issue(id) if count(land_issue[id]) > 0
