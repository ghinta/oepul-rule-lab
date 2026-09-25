# Prämienberechnung, Prämienblockaden, Sanktionsstufen und Modulation der Maßnahme o6_6.
package oepul.o6_6

# --- Prämienblockaden auf Schlagebene --------------------------------------

blocking_codes := {r.code | some r in gc.op_codes_blocking_o6_6.rows}

non_eligible_categories := {r.category | some r in gc.non_eligible_area_categories.rows}

premium_blocks contains {"parcel_id": p.parcel_id, "rule_id": "O6_6-GEN-OP-CODE", "reason": sprintf("Code %s gesetzt", [c])} if {
	some p in cover_parcels
	some c in object.get(p, "oepul_codes", [])
	c in blocking_codes
}

premium_blocks contains {"parcel_id": p.parcel_id, "rule_id": "O6_6-GEN-NON-ELIGIBLE", "reason": sprintf("Nicht förderfähige Fläche (%s)", [p.eligibility_category])} if {
	some p in cover_parcels
	p.eligibility_category in non_eligible_categories
}

premium_blocks contains {"parcel_id": p.parcel_id, "rule_id": "O6_6-GEN-LOCATION-AT", "reason": "Fläche liegt nicht in Österreich"} if {
	some p in cover_parcels
	p.is_in_austria == false
}

premium_blocks contains {"parcel_id": p.parcel_id, "rule_id": "O6_6-GEN-NATIONAL-PARK", "reason": sprintf("Nationalpark %s: keine flächenbezogene ÖPUL-Prämie", [p.national_park])} if {
	some p in cover_parcels
	some r in gc.national_parks_no_area_premium.rows
	r.national_park == p.national_park
	not gc.measure.measure_code in r.premium_exempt_measures
}

premium_blocks contains {"parcel_id": p.parcel_id, "rule_id": "O6_6-GEN-NATIONAL-PARK", "reason": "Nationalparkfläche mit relevanten Bewirtschaftungsauflagen"} if {
	some p in cover_parcels
	is_string(p.national_park)
	p.national_park_relevant_restrictions == true
}

premium_blocks contains {"parcel_id": p.parcel_id, "rule_id": "O6_6-TRANSFER-SUCCESSOR", "reason": "Flächenweitergabe ohne Einhaltung der Bedingungen durch den Nachfolgebetrieb"} if {
	some p in cover_parcels
	transfer_blocks_premium(p)
}

premium_blocks contains {"parcel_id": p.parcel_id, "rule_id": "O6_6-SRL-DOUBLE-FUNDING", "reason": "Leistungsüberschneidung mit Förderung aus anderem Titel der öffentlichen Hand bzw. behördlich vorgeschriebener Auflage"} if {
	some p in cover_parcels
	p.public_funding_overlap == true
}

premium_blocks contains {"parcel_id": p.parcel_id, "rule_id": "O6_6-VARIANT-APPLICATION-DEADLINE", "reason": "Variante nach der Beantragungsfrist erfasst (keine Nachfrist)"} if {
	some p in cover_parcels
	ns(cc(p).variant_applied_on) > ns_md(year, row_of(p).application_deadline)
}

premium_blocks contains {"parcel_id": p.parcel_id, "rule_id": "O6_6-WITHDRAW-VARIANT", "reason": "Variante gestrichen"} if {
	some p in cover_parcels
	cc(p).variant_withdrawn == true
}

# --- Schlagergebnis ---------------------------------------------------------

ineligible_parcel_ids := {v.parcel_id | some v in parcel_violations; v.severity == "ineligible"}

blocked_parcel_ids := {b.parcel_id | some b in premium_blocks}

farm_premium_eligible if {
	not contract_lapses
	not withdrawn_in_current_year
	count({v | some v in farm_violations; v.rule_id in farm_blocking_rule_ids}) == 0
}

farm_blocking_rule_ids := {"O6_6-GEN-FARM-MIN-SIZE", "O6_6-GEN-APPLICANT", "O6_6-MEASURE-APPLICATION", "O6_6-LAST-ENTRY", "O6_6-EXIT"}

creditable(p) if {
	row_of(p)
	not p.parcel_id in ineligible_parcel_ids
	not p.parcel_id in blocked_parcel_ids
}

parcel_results[pid] := result if {
	some p in cover_parcels
	pid := p.parcel_id
	result := {
		"variant": cc(p).variant,
		"area_ha": p.area_ha,
		"creditable": creditable_flag(p),
		"violations": sort([v.rule_id | some v in parcel_violations; v.parcel_id == pid]),
		"premium_blocks": sort([b.rule_id | some b in premium_blocks; b.parcel_id == pid]),
		"premium_min_eur": parcel_premium(p, "premium_min_eur_per_ha"),
		"premium_max_eur": parcel_premium(p, "premium_max_eur_per_ha"),
	}
}

creditable_flag(p) if creditable(p)

else := false

parcel_premium(p, field) := round((p.area_ha * row_of(p)[field]) * 100) / 100 if {
	creditable(p)
	farm_premium_eligible
} else := 0

# --- Prämienband, Sanktion, Modulation --------------------------------------

gross_premium_min_eur := sum([parcel_premium(p, "premium_min_eur_per_ha") | some p in cover_parcels])

gross_premium_max_eur := sum([parcel_premium(p, "premium_max_eur_per_ha") | some p in cover_parcels])

sanction_level := object.get(input, ["farm", "oepul", "content_violation_level"], "none")

sanction_row := r if {
	some r in gc.sanction_levels.rows
	r.level == sanction_level
	r.from_year <= year
	year <= r.to_year
}

sanction_exclusion if sanction_row.exclusion

# Ab 2027 ersetzt ein Einbehalt von 1 % die Verwarnung.
effective_sanction_level := "retention_1" if {
	sanction_level == "warning"
	year >= 2027
} else := sanction_level

effective_sanction_percent := r.reduction_percent if {
	some r in gc.sanction_levels.rows
	r.level == effective_sanction_level
	r.from_year <= year
	year <= r.to_year
} else := 0

total_area_ha := object.get(input, ["land", "total_area_ha"], 0)

tier_share(t, a) := max({0, min({a, upper(t, a)}) - t.from_ha})

upper(t, a) := t.to_ha if is_number(t.to_ha)

else := a

modulation_factor := 1 if total_area_ha <= 0

else := sum([(tier_share(t, total_area_ha) * t.payout_factor) | some t in gc.modulation_tiers.rows]) / total_area_ha

apply_reductions(gross) := round(((gross * (1 - (effective_sanction_percent / 100))) * modulation_factor) * 100) / 100

net_premium_min_eur := 0 if sanction_exclusion

else := apply_reductions(gross_premium_min_eur)

net_premium_max_eur := 0 if sanction_exclusion

else := apply_reductions(gross_premium_max_eur)

# Von der Gewährung kann abgesehen werden, wenn der Auszahlungsbetrag 50 Euro nicht überschreitet.
below_min_payment if net_premium_min_eur <= gc.payment.min_payment_eur

# o6_6 wird bei den Prämienobergrenzen für Flächenzahlungen nicht eingerechnet.
counts_toward_area_payment_cap := false if gc.measure.excluded_from_area_payment_caps

else := true

reduction_steps := [r.reduction | some r in gc.reduction_order.rows]

decision := {
	"measure": "o6_6",
	"year": year,
	"min_arable_area_met": flag_min_arable_area_met,
	"contract_lapses": flag_contract_lapses,
	"farm_premium_eligible": flag_farm_premium_eligible,
	"farm_violations": farm_violations,
	"parcel_results": parcel_results,
	"combination_conflicts": combination_conflicts,
	"gross_premium_min_eur": gross_premium_min_eur,
	"gross_premium_max_eur": gross_premium_max_eur,
	"sanction_percent": effective_sanction_percent,
	"modulation_factor": modulation_factor,
	"net_premium_min_eur": net_premium_min_eur,
	"net_premium_max_eur": net_premium_max_eur,
	"below_min_payment": flag_below_min_payment,
	"counts_toward_area_payment_cap": counts_toward_area_payment_cap,
	"missing_inputs": missing_inputs,
}

flag_min_arable_area_met if min_arable_area_met

else := false

flag_contract_lapses if contract_lapses

else := false

flag_farm_premium_eligible if farm_premium_eligible

else := false

flag_below_min_payment if below_min_payment

else := false
