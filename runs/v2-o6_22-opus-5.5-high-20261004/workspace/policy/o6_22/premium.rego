# Modul: o6_22 – Prämienberechnung, Modulation und Sanktionen
package oepul.o6_22

# ---------------------------------------------------------------------------
# Prämiensätze (O622-PREM-001, O622-PREM-004)
# ---------------------------------------------------------------------------

rate_row_matches(row, y) if {
	row.from_year <= y
	row.to_year == null
}

rate_row_matches(row, y) if {
	row.from_year <= y
	is_number(row.to_year)
	y <= row.to_year
}

base_rate(c, y) := row.rate_eur_per_gve if {
	some row in rates.base
	row.category == c
	rate_row_matches(row, y)
}

surcharge_rate(s, c, y) := row.rate_eur_per_gve if {
	some row in rates.surcharges
	row.surcharge == s
	row.category == c
	rate_row_matches(row, y)
}

# O622-CONTRACT-003 / O622-EXIT-002 / Zugangsvoraussetzungen (O622-GEN-018).
measure_payable if {
	min_participation_met
	applicant_ok
	farm_min_size_ok
	takeover_ok
}

payable_categories := {c |
	measure_payable
	some c in active_categories
	not c in lapsed_categories
}

# ---------------------------------------------------------------------------
# Prämie je Kategorie und Zuschlag (O622-PREM-002, O622-PREM-003)
# ---------------------------------------------------------------------------

base_premium[c] := r2(category_gve[c] * base_rate(c, year)) if some c in payable_categories

unkupiert_premium[c] := r2(category_gve[c] * surcharge_rate("unkupiert", c, year)) if {
	some c in payable_categories
	c in unkupiert_active_categories
}

gvo_premium[c] := r2(category_gve[c] * surcharge_rate("gvo_frei", c, year)) if {
	gvo_active
	some c in payable_categories
}

festmist_premium[c] := r2(category_gve[c] * surcharge_rate("festmistkompostierung", c, year)) if {
	festmist_active
	some c in payable_categories
}

premium_before_modulation := r2(((sum([v | some v in base_premium]) + sum([v | some v in unkupiert_premium])) + sum([v | some v in gvo_premium])) + sum([v | some v in festmist_premium]))

# ---------------------------------------------------------------------------
# Betriebsgrößenmodulation (O622-GEN-011)
# ---------------------------------------------------------------------------

tier_hectares(tier, area) := max([0, min([area, tier.to_ha_inclusive]) - tier.from_ha_exclusive]) if is_number(tier.to_ha_inclusive)

tier_hectares(tier, area) := max([0, area - tier.from_ha_exclusive]) if tier.to_ha_inclusive == null

modulation_factor(area) := 1 if area <= 0

modulation_factor(area) := r4(sum([x | some t in general.modulation_tiers; x := tier_hectares(t, area) * t.payout_share]) / area) if area > 0

farm_area_ha := object.get(input, ["land", "total_area_ha"], 0)

premium_after_modulation := r2(premium_before_modulation * modulation_factor(farm_area_ha))

# O622-GEN-013: AMA kann von der Gewährung absehen, wenn der Betrag 50 € nicht überschreitet.
below_minimum_payment if premium_after_modulation <= params.minimum_payment_eur

# ---------------------------------------------------------------------------
# Sanktionen (O622-GEN-008, O622-GEN-009, O622-GEN-010)
# ---------------------------------------------------------------------------

# Prozentsatz einer Sanktionsstufe; ab 2027 Einbehalt von 1 % statt Verwarnung.
sanction_percent(level, y) := params.sanction_warning_replacement_percent if {
	level == 1
	y >= params.sanction_warning_replaced_from_year
}

sanction_percent(level, y) := row.reduction_percent if {
	some row in general.sanction_levels
	row.level == level
	not warning_replaced(level, y)
}

warning_replaced(level, y) if {
	level == 1
	y >= params.sanction_warning_replaced_from_year
}

# Wiederholter Verstoß gegen dieselbe Förderungsverpflichtung: + 1 Stufe je Wiederholung.
escalated_level(level, prior_same_obligation) := min([7, level + prior_same_obligation])

# Kumulation mehrerer Verstöße, begrenzt auf 100 % der Jahresprämie.
cumulated_sanction_percent(levels, y) := min([100, sum([sanction_percent(l, y) | some l in levels])])

premium_after_sanction(amount, percent) := r2(amount * (1 - (percent / 100)))

# Zweimalige 100-%-Kürzung in der Förderperiode -> Ausschluss und Rückforderung.
exclusion_after_two_full_reductions(full_reduction_count) if full_reduction_count >= 2

# ---------------------------------------------------------------------------
# Abweichungen bei Tieren (O622-GEN-017)
# ---------------------------------------------------------------------------

# Prämie auf Basis ermittelter Tiere; bei Differenz > 3 % Kürzung um das 1,5-fache
# der Differenz (Prämienbasis), höchstens auf 0.
overdeclaration_adjusted_premium(applied_premium, determined_premium) := determined_premium if {
	diff := applied_premium - determined_premium
	diff <= (determined_premium * params.overdeclaration_tolerance_percent) / 100
}

overdeclaration_adjusted_premium(applied_premium, determined_premium) := r2(max([0, determined_premium - (params.overdeclaration_penalty_factor * (applied_premium - determined_premium))])) if {
	diff := applied_premium - determined_premium
	diff > (determined_premium * params.overdeclaration_tolerance_percent) / 100
}

# ---------------------------------------------------------------------------
# Fristen allgemeiner Verfahren (O622-GEN-012, O622-GEN-014, O622-GEN-015, O622-GEN-016)
# ---------------------------------------------------------------------------

payment_deadline(y) := year_date(y + 1, params.payment_deadline_mm_dd_following_year)

max_advance_payment(amount) := r2(amount * params.max_advance_payment_share)

force_majeure_notification_in_time(able_from, notified_on) if {
	days_between(able_from, notified_on) <= params.force_majeure_notification_weeks * 7
}

natural_circumstance_notification_in_time(detected_on, notified_on) if {
	days_between(detected_on, notified_on) <= params.natural_circumstances_notification_weeks * 7
}

document_retention_until(y) := year_date(y + params.document_retention_years_one_year_measures, params.commitment_end_mm_dd)
