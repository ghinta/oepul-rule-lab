# o6_10 – Prämienberechnung (Sätze, Zuschlag, Sanktion, Modulation, Obergrenze)
package oepul.o6_10

payment_rules := data.o6_10

# --- Prämiensätze (O610-PREM-RATES, O610-PREM-BAND-2023-2024) ----------------------------

lower_ok(_, lo) if lo == null

lower_ok(s, lo) if {
	lo != null
	s >= lo
}

upper_ok(_, hi) if hi == null

upper_ok(s, hi) if {
	hi != null
	s < hi
}

base_row(p) := row if {
	some row in rates.base
	effective_crop_type(p) in row.applies_to
	lower_ok(slope_of(p), row.slope_min_percent)
	upper_ok(slope_of(p), row.slope_max_percent)
}

supplement_row(p) := row if {
	some row in rates.supplement_organisms_pheromones
	effective_crop_type(p) in row.applies_to
}

fixed_rate_regime if year >= rates.band_regime.fixed_first_year

# Bis 2024: garantierter Mindestbetrag des Prämienbandes; ab 2025: Fixbetrag
applicable_rate(row) := row.fixed_from_2025 if fixed_rate_regime

else := row.band_2023_2024.min

rate_band_max(row) := row.fixed_from_2025 if fixed_rate_regime

else := row.band_2023_2024.max

parcel_supplement_rate(p) := applicable_rate(supplement_row(p)) * eop_reduction_factor if {
	eop_supplement_granted
	params.eop_supplement_parcel_code in parcel_codes(p)
}

else := 0

parcel_supplement_rate_max(p) := rate_band_max(supplement_row(p)) * eop_reduction_factor if {
	eop_supplement_granted
	params.eop_supplement_parcel_code in parcel_codes(p)
}

else := 0

gross_parcel_premiums[p.parcel_id] := {
	"area_ha": parcel_area(p),
	"crop_type": effective_crop_type(p),
	"slope_percent": slope_of(p),
	"rate_row": base_row(p).row_id,
	"base_rate_eur_per_ha": applicable_rate(base_row(p)),
	"base_rate_band_max_eur_per_ha": rate_band_max(base_row(p)),
	"supplement_rate_eur_per_ha": parcel_supplement_rate(p),
	"supplement_rate_band_max_eur_per_ha": parcel_supplement_rate_max(p),
	"base_eur": parcel_area(p) * applicable_rate(base_row(p)),
	"supplement_eur": parcel_area(p) * parcel_supplement_rate(p),
} if {
	contract_valid
	some p in premium_parcels
}

gross_base_eur := sum([v.base_eur | some v in gross_parcel_premiums])

gross_supplement_eur := sum([v.supplement_eur | some v in gross_parcel_premiums])

gross_total_eur := gross_base_eur + gross_supplement_eur

# --- Inhaltliche Kürzung (O610-GEN-SANCTION-STAGES, O610-GEN-SANCTION-MEASURE-LEVEL) -----

findings := object.get(o610, "control_findings", [])

stage_percent(st) := st.reduction_percent_from_2027 if year >= payment_rules.sanction_parameters.warning_replaced_by_withholding_from_year

else := st.reduction_percent_until_2026

finding_percents := [stage_percent(st) |
	some f in findings
	some st in payment_rules.sanction_stages
	st.stage == f.stage
]

# Maßnahmenbezogene Beurteilung inkl. Zuschläge: höchste festgestellte Stufe (Annahme A-09)
default content_reduction_percent := 0

content_reduction_percent := max(finding_percents) if count(finding_percents) > 0

full_reductions_total := object.get(o610, "full_reductions_in_contract_period", 0) + count([f |
	some f in findings
	f.stage == "reduction_100"
])

excluded_from_measure if full_reductions_total >= payment_rules.sanction_parameters.exclusion_after_full_reductions_in_contract_period

excluded_from_measure if {
	some f in findings
	f.stage == "exclusion"
}

# O610-GEN-CONTROL-REFUSAL
control_refused if object.get(o610, "control_refused", false) == true

# --- Modulation (O610-GEN-MODULATION) -------------------------------------------------

total_farm_area_ha := object.get(input, ["land", "total_area_ha"], 0)

band_portion(b, total) := max_num(0, min_num(total, b.to_ha_inclusive) - b.from_ha_exclusive) if b.to_ha_inclusive != null

else := max_num(0, total - b.from_ha_exclusive)

modulation_factor_for(total) := 1 if total <= 0

else := sum([band_payout(b, total) | some b in payment_rules.modulation_bands]) / total

band_payout(b, total) := (band_portion(b, total) * b.payout_percent) / 100

modulation_factor := modulation_factor_for(total_farm_area_ha)

# --- Prämienobergrenze für Flächenzahlungen je Schlag (O610-GEN-CAP) ------------------

applicable_cap := c if {
	some c in payment_rules.area_payment_caps
	c.applies_when == "general"
	year in c.years
	not params.measure_code in c.excluded_measures
}

content_factor := (100 - content_reduction_percent) / 100

parcel_payments[pid] := result if {
	some pid, g in gross_parcel_premiums
	after_mod := ((g.base_eur + g.supplement_eur) * content_factor) * modulation_factor
	per_ha := after_mod / g.area_ha
	p := [q | some q in premium_parcels; q.parcel_id == pid][0]
	other := object.get(p, "other_area_payments_eur_per_ha", 0)
	result := cap_result(after_mod, per_ha, other, g.area_ha)
}

# Anteilige Zurechnung einer Obergrenzen-Überschreitung (Annahme A-10)
cap_result(after_mod, per_ha, other, area) := {
	"after_modulation_eur": after_mod,
	"cap_eur_per_ha": applicable_cap.cap_eur_per_ha,
	"total_area_payments_eur_per_ha": per_ha + other,
	"cap_excess_eur_per_ha": excess,
	"payable_eur": max_num(0, after_mod - (((excess * per_ha) / (per_ha + other)) * area)),
} if {
	per_ha + other > 0
	excess := max_num(0, (per_ha + other) - applicable_cap.cap_eur_per_ha)
}

else := {
	"after_modulation_eur": after_mod,
	"cap_eur_per_ha": null,
	"total_area_payments_eur_per_ha": per_ha + other,
	"cap_excess_eur_per_ha": 0,
	"payable_eur": after_mod,
}

payable_before_blocks_eur := sum([v.payable_eur | some v in parcel_payments])

default payable_total_eur := 0

payable_total_eur := payable_before_blocks_eur if {
	not excluded_from_measure
	not control_refused
	not payment_application_missing
}

# O610-GEN-MIN-PAYOUT: Von der Gewährung kann abgesehen werden, wenn Betrag <= 50 Euro
below_minimum_payout if {
	payable_total_eur > 0
	payable_total_eur <= payment_rules.payment_parameters.minimum_payout_eur
}

# O610-GEN-PAYMENT
payment_deadline := sprintf("%d-%s", [year + payment_rules.payment_parameters.payment_deadline_year_offset, payment_rules.payment_parameters.payment_deadline_month_day])

max_advance_payment_eur := (payable_total_eur * payment_rules.payment_parameters.max_advance_payment_percent) / 100
