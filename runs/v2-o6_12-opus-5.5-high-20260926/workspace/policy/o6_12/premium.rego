# Maßnahme 12 – Prämienberechnung: Prämiensätze, Kürzungen, Modulation, Obergrenze,
# Mindestauszahlungsbetrag und Auszahlungstermine.
package oepul.o6_12

premium_rate(area_type, year) := row.eur_per_ha if {
	some row in data.o6_12.o6_12_premium_rates
	row.area_type == area_type
	row.year_from <= year
	rate_year_to_ok(row, year)
}

rate_year_to_ok(row, _) if row.year_to == null

rate_year_to_ok(row, year) if row.year_to >= year

parcel_gross_premium := {p.parcel_id: amount |
	some p in parcels
	premium_eligible_parcel(p)
	amount := p.area_ha * premium_rate(woh_type(p), application_year)
}

# Leafhopper-Ausstieg 2026, Ausstieg im laufenden Jahr, Kontrollverweigerung und
# Zugangsvoraussetzungen verhindern jede Prämie im Antragsjahr.
premium_blocked_reason contains "not_participating" if not participates

premium_blocked_reason contains "contract_not_active" if {
	participates
	not contract_active_in_year
}

premium_blocked_reason contains "access_requirements_not_met" if not access_requirements_met

premium_blocked_reason contains "exit_in_current_year" if exit_in_current_year

premium_blocked_reason contains "leafhopper_exit_no_premium_2026" if {
	leafhopper_exit_approved
	application_year == year_of(leafhopper_exit_request_date)
}

premium_blocked_reason contains "organic_combination_conflict" if organic_combination_conflict

premium_blocked_reason contains "inspection_refused" if inspection_refused

premium_blocked_reason contains "payment_application_missing" if payment_application_consequence

premium_blocked_reason contains "excluded_after_two_full_reductions" if sanction_exclusion

gross_premium_eur := sum([amount | some amount in parcel_gross_premium]) if count(premium_blocked_reason) == 0

default gross_premium_eur := 0

# --- Inhaltliche Kürzungen (AT 8.2, SRL 1.12.1.3) ---
sanction := object.get(o6_12_input, ["sanction"], {})

sanction_stage_row := row if {
	some row in data.o6_12.oepul_sanction_stages
	row.stage == sanction.stage
}

sanction_reduction_percent := sanction_stage_row.reduction_percent_until_2026 if {
	application_year < general.warning_replaced_by_withholding_from_year
}

sanction_reduction_percent := sanction_stage_row.reduction_percent_from_2027 if {
	application_year >= general.warning_replaced_by_withholding_from_year
}

default sanction_reduction_percent := 0

sanction_exclusion if {
	object.get(sanction, "full_reductions_in_contract_period", 0) >= general.exclusion_after_full_reductions
	not force_majeure_recognised
}

sanction_exclusion if {
	sanction_stage_row.exclusion == true
	not force_majeure_recognised
}

sanction_exclusion_consequence := "exclusion_and_repayment_of_contract_period_premiums" if sanction_exclusion

force_majeure_recognised if object.get(oepul, ["force_majeure", "recognised"], false) == true

effective_reduction_percent := 0 if force_majeure_recognised

effective_reduction_percent := sanction_reduction_percent if not force_majeure_recognised

premium_after_sanction_eur := (gross_premium_eur * (100 - effective_reduction_percent)) / 100

# --- Modulation (AT 9.3, SRL 1.9.2.2) ---
tier_portion(total, tier) := max([0, min([total, tier_upper(tier, total)]) - tier.from_ha])

tier_upper(tier, total) := total if tier.to_ha == null

tier_upper(tier, _) := tier.to_ha if tier.to_ha != null

modulation_factor := 1 if input.land.total_area_ha <= 0

modulation_factor := f if {
	total := input.land.total_area_ha
	total > 0
	weighted := [v |
		some tier in data.o6_12.oepul_modulation_tiers
		v := tier_portion(total, tier) * tier.payout_factor
	]
	f := sum(weighted) / total
}

premium_after_modulation_eur := premium_after_sanction_eur * modulation_factor

# --- Obergrenze für Flächenzahlungen je Schlag (AT 9.2, SRL 1.9.2.1) ---
area_payment_cap_eur_per_ha := row.eur_per_ha if {
	some row in data.o6_12.oepul_area_payment_caps
	row.case == "standard"
	row.year_from <= application_year
	rate_year_to_ok(row, application_year)
}

# Anteil der Maßnahme 12 am Schlag, gekürzt, soweit die Summe aller Flächenzahlungen die
# Obergrenze übersteigt (Annahme: Kappung wirkt auf den Maßnahme-12-Anteil).
parcel_cap_excess_eur := {pid: excess |
	some p in parcels
	pid := p.parcel_id
	amount := parcel_gross_premium[pid]
	other := object.get(p, ["oepul", "other_area_payments_eur_per_ha"], 0)
	excess := max([0, (((amount / p.area_ha) + other) - area_payment_cap_eur_per_ha) * p.area_ha])
}

cap_excess_total_eur := sum([e | some e in parcel_cap_excess_eur]) if count(premium_blocked_reason) == 0

default cap_excess_total_eur := 0

net_premium_eur := max([0, premium_after_modulation_eur - cap_excess_total_eur])

# --- Mindestauszahlung (SRL 1.10.7) ---
total_oepul_payment_eur := object.get(oepul, ["total_payment_eur"], net_premium_eur)

payout_may_be_withheld_below_minimum if total_oepul_payment_eur <= general.min_payout_eur

# --- Auszahlung (AT 9.1, SRL 1.10.7) ---
payout_deadline := sprintf("%d-%s", [application_year + 1, general.payout_deadline_month_day])

advance_payment_max_eur := (net_premium_eur * general.advance_payment_max_percent) / 100

# --- Reihenfolge der Mehrfachkürzungen (SRL 1.12.2) ---
calculation_order := [row.step |
	some pos in numbers.range(1, count(data.o6_12.oepul_reduction_order))
	some row in data.o6_12.oepul_reduction_order
	row.position == pos
]
