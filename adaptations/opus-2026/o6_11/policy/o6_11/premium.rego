# o6_11 policy module
# o6_11 – Prämienberechnung
#
#   Prämienfähigkeit je Schlag, Prämiensätze, Obergrenze für
#   Flächenzahlungen, Betriebsgrößenmodulation und Mindestauszahlung.
package oepul.o6_11

# ---------------------------------------------------------------------------
# Prämiensatz (Rule O611-PREMIUM-RATE)
# ---------------------------------------------------------------------------
premium_rate(category, y) := row.eur_per_ha if {
	some row in cfg.premium_rates.rows
	row.category == category
	y >= row.year_from
	y <= row.year_to
}

# Rule O611-NO-PREMIUM-TYPES: Walnüsse und Edelkastanien erhalten keine Prämie
species_excluded_from_premium(p) if {
	some row in cfg.premium_rates.no_premium_usage_types
	row.usage_type == parcel_usage_type(p)
	object.get(row, "fruit_species", null) == parcel_species(p)
}

species_excluded_from_premium(p) if {
	some row in cfg.premium_rates.no_premium_usage_types
	row.usage_type == parcel_usage_type(p)
	not row.fruit_species
}

parcel_premium_category(p) := cat if {
	cat := parcel_usage_row(p).premium_category
	cat != null
	is_wfh_parcel(p)
	not species_excluded_from_premium(p)
}

# ---------------------------------------------------------------------------
# Gründe für keine Prämie auf einem Schlag
# ---------------------------------------------------------------------------
parcel_oepul(p) := object.get(p, "oepul", {})

parcel_no_premium_reasons(p) := {reason |
	some reason in parcel_no_premium_reason_candidates
	parcel_no_premium(p, reason)
}

parcel_no_premium_reason_candidates := {
	"not_declared_for_measure",
	"no_premium_usage_type",
	"generally_non_eligible_area",
	"ungrafted_fruit",
	"op_code",
	"op_case",
	"measure_specific_op_code",
	"national_park",
	"outside_austria",
	"gaec_landscape_element",
	"trial_area",
	"public_funding_overlap",
	"minimum_management_not_met",
	"not_actively_farmed",
}

# Rule O611-GEN-NON-ELIGIBLE (nicht für die Maßnahme angegeben)
parcel_no_premium(p, "not_declared_for_measure") if not parcel_in_measure(p)

# Rule O611-NO-PREMIUM-TYPES
parcel_no_premium(p, "no_premium_usage_type") if not parcel_premium_category(p)

# Rule O611-REBSCHULE-EXCL / O611-GEN-NON-ELIGIBLE
parcel_no_premium(p, "generally_non_eligible_area") if count(non_eligible_categories(p)) > 0

non_eligible_categories(p) := {cat.id |
	some cat in cfg.non_eligible_areas.categories
	parcel_usage_type(p) in cat.usage_types
}

# Rule O611-OBST-VEREDELT: nur veredeltes Pflanzgut (sonst Code OP)
parcel_no_premium(p, "ungrafted_fruit") if {
	parcel_usage_type(p) == "fruit"
	p.crop.is_grafted == false
}

# Rule O611-GEN-OP-CODE
parcel_no_premium(p, "op_code") if "OP" in object.get(parcel_oepul(p), "codes", [])

# Verpflichtende OP-Codierung: liegt ein Fall gemäß Liste vor, gibt es keine Prämie
parcel_no_premium(p, "op_case") if count(parcel_op_cases(p)) > 0

parcel_op_cases(p) := {c.id |
	some c in cfg.op_code_cases
	c.id in object.get(parcel_oepul(p), "op_cases", [])
}

# Fall gemäß OP-Liste, aber kein OP-Code gesetzt (Rule O611-GEN-OP-CODE)
missing_op_codes contains {"parcel_id": p.parcel_id, "cases": parcel_op_cases(p)} if {
	participates
	some p in parcels
	parcel_in_measure(p)
	count(parcel_op_cases(p)) > 0
	not "OP" in object.get(parcel_oepul(p), "codes", [])
	not measure_id in object.get(parcel_oepul(p), "excluded_measures", [])
}

parcel_no_premium(p, "measure_specific_op_code") if measure_id in object.get(parcel_oepul(p), "excluded_measures", [])

# Rule O611-GEN-NATIONALPARK
parcel_no_premium(p, "national_park") if {
	np := object.get(parcel_oepul(p), "national_park", null)
	np in cfg.non_eligible_areas.national_parks_no_area_premium.parks
	not measure_id in cfg.non_eligible_areas.national_parks_no_area_premium.exempt_measures
}

# Rule O611-GEN-LOCATION-AT
parcel_no_premium(p, "outside_austria") if object.get(parcel_oepul(p), "located_in_austria", true) == false

# Rule O611-GEN-NON-ELIGIBLE
parcel_no_premium(p, "gaec_landscape_element") if object.get(parcel_oepul(p), "is_gaec_landscape_element", false) == true

# Rule O611-GEN-TRIAL-AREA
parcel_no_premium(p, "trial_area") if object.get(parcel_oepul(p), "is_trial_area", false) == true

parcel_no_premium(p, "trial_area") if "VF" in object.get(parcel_oepul(p), "codes", [])

# Rule O611-GEN-NO-DOUBLE-FUNDING
parcel_no_premium(p, "public_funding_overlap") if object.get(parcel_oepul(p), "public_funding_overlap", false) == true

# Rule O611-GEN-MIN-MGMT
parcel_no_premium(p, "minimum_management_not_met") if {
	mgmt := object.get(p, ["operations", "permanent_crop_management"], {})
	some key in ["properly_planted", "annual_care_done", "harvested_and_removed"]
	mgmt[key] == false
}

# Rule O611-GEN-ACTIVE-PRODUCTION
parcel_no_premium(p, "not_actively_farmed") if object.get(parcel_oepul(p), "actively_farmed", true) == false

parcel_premium_eligible(p) if {
	parcel_premium_category(p)
	count(parcel_no_premium_reasons(p)) == 0
}

# ---------------------------------------------------------------------------
# Prämie je Schlag (brutto, vor Kürzungen)
# ---------------------------------------------------------------------------
premium_year_valid if {
	participates
	year_in_contract_period
	not access_conditions_failed
	not premium_withheld_for_year
}

parcel_rate(p) := premium_rate(parcel_premium_category(p), year)

parcel_premium[p.parcel_id] := round((parcel_area(p) * parcel_rate(p)) * 100) / 100 if {
	premium_year_valid
	some p in parcels
	parcel_premium_eligible(p)
}

premium_eligible_area_ha := sum([parcel_area(p) |
	premium_year_valid
	some p in parcels
	parcel_premium_eligible(p)
])

premium_before_modulation := sum([v | some v in parcel_premium])

# ---------------------------------------------------------------------------
# Inhaltliche Kürzung (Rule O611-GEN-SANCTION-LEVELS)
# ---------------------------------------------------------------------------
sanction_level := object.get(input, ["farm", "oepul", "sanction_level"], null)

warning_with_retention if {
	sanction_level == "warning"
	year >= cfg.sanctions.warning_retention_from_year
}

sanction_reduction_percent := 0 if sanction_level == null

sanction_reduction_percent := pct if {
	warning_with_retention
	some row in cfg.sanctions.levels
	row.level == "warning"
	pct := row.from_2027_reduction_percent
}

sanction_reduction_percent := pct if {
	sanction_level != null
	not warning_with_retention
	some row in cfg.sanctions.levels
	row.level == sanction_level
	pct := row.reduction_percent
}

sanction_factor := (100 - sanction_reduction_percent) / 100

# ---------------------------------------------------------------------------
# Betriebsgrößenmodulation (Rule O611-GEN-MODULATION)
# ---------------------------------------------------------------------------
band_share(band, total) := max([0, min([total, band_upper(band, total)]) - band.from_ha])

band_upper(band, total) := total if band.to_ha == null

band_upper(band, _) := band.to_ha if band.to_ha != null

modulation_factor_for(total) := 1 if total <= 0

modulation_factor_for(total) := f if {
	total > 0
	weighted := sum([w | some b in cfg.modulation.bands; w := band_share(b, total) * b.payout_percent])
	f := weighted / (total * 100)
}

modulation_factor := modulation_factor_for(object.get(input, ["land", "total_area_ha"], 0))

# ---------------------------------------------------------------------------
# Obergrenze für Flächenzahlungen je Schlag (Rule O611-GEN-CAP)
# ---------------------------------------------------------------------------
cap_scope(p) := "13" if "13" in parcel_measures(p)

cap_scope(p) := "18_19" if {
	not "13" in parcel_measures(p)
	some m in ["18", "19"]
	m in parcel_measures(p)
}

cap_scope(p) := "general" if {
	not "13" in parcel_measures(p)
	not "18" in parcel_measures(p)
	not "19" in parcel_measures(p)
}

parcel_payment_cap(p) := row.eur_per_ha if {
	some row in cfg.payment_caps.rows
	row.scope == cap_scope(p)
	year >= row.year_from
	year <= row.year_to
}

parcel_other_payments(p) := object.get(parcel_oepul(p), "other_area_payments_eur_per_ha", 0)

# Satz je ha nach inhaltlicher Kürzung und Modulation (Reihenfolge gemäß SRL 1.12.2)
reduced_rate(p) := (parcel_rate(p) * sanction_factor) * modulation_factor

# Proportionale Kürzung der Maßnahme-11-Prämie, wenn die Summe die Obergrenze übersteigt
capped_rate(p) := reduced_rate(p) if {
	reduced_rate(p) + parcel_other_payments(p) <= parcel_payment_cap(p)
} else := (reduced_rate(p) * parcel_payment_cap(p)) / (reduced_rate(p) + parcel_other_payments(p))

payment_cap_exceeded_parcels contains p.parcel_id if {
	premium_year_valid
	some p in parcels
	parcel_premium_eligible(p)
	capped_rate(p) < reduced_rate(p)
}

# Auszahlungsbetrag je Schlag nach Kürzungen
parcel_payable[p.parcel_id] := round((parcel_area(p) * capped_rate(p)) * 100) / 100 if {
	premium_year_valid
	not excluded_from_measure
	some p in parcels
	parcel_premium_eligible(p)
}

premium_after_sanction := round((premium_before_modulation * sanction_factor) * 100) / 100

premium_after_modulation := round((premium_after_sanction * modulation_factor) * 100) / 100

premium_payable := sum([v | some v in parcel_payable])

# Reihenfolge der Mehrfachkürzungen (Rule O611-GEN-REDUCTION-ORDER)
reduction_order := [row.step |
	some i in numbers.range(1, count(cfg.sanctions.reduction_order))
	some row in cfg.sanctions.reduction_order
	row.order == i
]

# Teilzahlung nach Verwaltungskontrolle höchstens 75 % (Rule O611-GEN-PAYMENT)
advance_payment_max_eur := round(premium_payable * cfg.general_conditions.advance_payment_max_percent) / 100

# Rule O611-GEN-MIN-PAYOUT: Auszahlungsbetrag bis 50 Euro kann entfallen
payout_may_be_withheld if {
	premium_payable <= cfg.general_conditions.minimum_payout_eur
}
