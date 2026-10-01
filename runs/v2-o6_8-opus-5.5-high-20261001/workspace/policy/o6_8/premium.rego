# o6_8 - Mindestteilnahme, Prämienberechnung und Gesamtentscheidung
# Kapitel 3.3 und 6 des Maßnahmeninformationsblatts, SRL 2.8 (Höhe der
# Förderung) sowie Modulation und Flächenobergrenzen (SRL 1.9.2).
package oepul.o6_8

violations := parcel_violations | farm_violations

# --- Verfahrenskonformität je Schlag und Code ------------------------------

parcel_code_violations(p, c) := {v |
	some v in parcel_violations
	v.parcel_id == pid(p)
	v.code in {c, null}
}

code_compliant(p, c) if {
	has_code(p, c)
	c in all_codes
	crop_eligible_for_code(p, c)
	count(parcel_code_violations(p, c)) == 0
	count(parcel_exclusions(p)) == 0
}

# --- Mindestteilnahme 0,10 ha ----------------------------------------------

participating_parcels contains pid(p) if {
	some p in parcels
	some c in codes(p)
	code_compliant(p, c)
}

participation_area_ha := sum([parcel_area(p) |
	some p in parcels
	pid(p) in participating_parcels
])

min_participation_met if participation_area_ha >= params.min_participation_area_ha

farm_violations contains farm_violation("o6_8.min_participation.area_0_10_ha", sprintf("Teilnahmefläche %v ha unterschreitet die jährliche Mindestteilnahme von 0,10 ha.", [participation_area_ha])) if {
	not min_participation_met
}

# Ersatzweise Erfüllung der Mindestteilnahme durch AH, BAW oder US, wenn MS/DS nicht möglich ist.
min_participation_without_ms_ds_ha := sum([parcel_area(p) |
	some p in parcels
	some c in (codes(p) & {"AH", "BAW", "US"})
	code_compliant(p, c)
])

# --- Zugangsvoraussetzungen auf Betriebsebene ------------------------------

access_blocking_rules := {
	"o6_8.contract.duration",
	"o6_8.application.last_entry_2025",
	"o6_8.application.deadline_31_dec",
	"gen.applicant.eligible_persons",
	"gen.min_farm_size.first_year",
	"o6_8.min_participation.area_0_10_ha",
}

farm_access_failures := {v.rule_id | some v in farm_violations; v.rule_id in access_blocking_rules}

farm_access_ok if {
	contract_active
	count(farm_access_failures) == 0
}

# --- Prämienfähigkeit je Code ------------------------------------------------

code_premium_blocked(_, c) if {
	c in {"MS", "DS"}
	not combination_obligation_met
}

code_premium_blocked(p, c) if {
	c in {"MS", "DS"}
	vienna_humus_option_blocks(p)
}

code_premium_blocked(p, "BAW") if baw_npf_no_premium(p)

code_premium_blocked(p, c) if {
	c in {"MS", "DS", "AH"}
	ms_ds_ah_conflict(p)
}

code_premium_eligible(p, c) if {
	farm_access_ok
	code_compliant(p, c)
	not code_premium_blocked(p, c)
}

rate(code, y) := r.eur_per_ha if {
	some r in rate_table.rates
	r.code == code
	year_in_range(r, y)
}

code_area_ha(p, c) := baw_eligible_area_ha(p) if {
	c == "BAW"
} else := parcel_area(p)

code_premium_eur(p, c) := round2(code_area_ha(p, c) * rate(c, year)) if {
	code_premium_eligible(p, c)
} else := 0

us_bio_surcharge_eur(p) := round2(parcel_area(p) * rate("US_BIO", year)) if {
	code_premium_eligible(p, "US")
	"1B" in participating_measures
} else := 0

parcel_premium_eur(p) := sum([code_premium_eur(p, c) | some c in codes(p)]) + us_bio_surcharge_eur(p)

parcel_results[pid(p)] := {
	"codes": codes(p),
	"compliant_codes": {c | some c in codes(p); code_compliant(p, c)},
	"premium_eligible_codes": {c | some c in codes(p); code_premium_eligible(p, c)},
	"exclusions": parcel_exclusions(p),
	"premium_by_code_eur": {c: code_premium_eur(p, c) | some c in codes(p)},
	"us_bio_surcharge_eur": us_bio_surcharge_eur(p),
	"premium_eur": parcel_premium_eur(p),
	"area_cap_exceeded": area_cap_exceeded(p),
} if {
	some p in parcels
	count(codes(p)) > 0
}

# --- Flächenobergrenze je Schlag ---------------------------------------------

area_cap_exceeded(p) if {
	parcel_area(p) > 0
	other := object.get(p, ["oepul_o6_8", "other_area_payments_eur_per_ha"], 0)
	(parcel_premium_eur(p) / parcel_area(p)) + other > area_cap_eur_per_ha(year)
} else := false

# --- Gesamtergebnis ------------------------------------------------------------

premium_gross_eur := round2(sum([parcel_premium_eur(p) | some p in parcels]))

farm_modulation_factor := modulation_factor(object.get(input, ["land", "total_area_ha"], 0))

premium_after_modulation_eur := round2(premium_gross_eur * farm_modulation_factor)

decision := {
	"measure": "o6_8",
	"year": year,
	"contract_active": contract_active,
	"farm_access_ok": farm_access_ok,
	"farm_access_failures": farm_access_failures,
	"access_failure_consequence": access_failure_consequence,
	"combination_obligation_applies": combination_obligation_applies,
	"combination_obligation_met": combination_obligation_met,
	"participation_area_ha": participation_area_ha,
	"min_participation_met": min_participation_met,
	"violations": violations,
	"unlisted_code_combinations": unlisted_code_combinations,
	"application_notices": application_notices,
	"parcel_results": parcel_results,
	"premium_gross_eur": premium_gross_eur,
	"modulation_factor": farm_modulation_factor,
	"premium_after_modulation_eur": premium_after_modulation_eur,
	"payment_deadline": payment_deadline(year),
}

default contract_active := false

default farm_access_ok := false

default combination_obligation_applies := false

default combination_obligation_met := false

default min_participation_met := false
