# Prämienberechnung, Obergrenzen, Modulation und Kürzungen (o6_23).
package oepul.o6_23

# ---------------------------------------------------------------------------
# Prämiensätze je Auflage (Kapitel 7 Informationsblatt, SRL 2.23.4)
# ---------------------------------------------------------------------------

rate_for(code, y) := rate_row(code).eur_per_ha_2023 if y == params.measure.first_srl_year

rate_for(code, y) := rate_row(code).eur_per_ha_from_2024 if y >= params.measure.rates_increase_from_year

# Die Prämie ergibt sich aus der Summe der Teilprämien der Auflagen je Schlag.
parcel_rate_eur_per_ha(p) := sum([rate_for(c, year) | some c in parcel_codes(p)])

# ---------------------------------------------------------------------------
# Obergrenzen für Flächenzahlungen je Schlag (SRL 1.9.2.1, Allg. 9.2)
# ---------------------------------------------------------------------------

cap_row(cap_id) := r if {
	some r in params.premium_caps
	r.cap_id == cap_id
}

cap_amount(cap_id, y) := a.eur_per_ha if {
	some a in cap_row(cap_id).eur_per_ha_by_year
	y >= a.from_year
	a.until_year == null
} else := a.eur_per_ha if {
	some a in cap_row(cap_id).eur_per_ha_by_year
	y >= a.from_year
	y <= a.until_year
}

parcel_cap_id(p) := "naturschutz_or_ebw" if {
	some m in object.get(parcel_oepul(p), "measures", [])
	m in {"18", "19"}
} else := "default"

parcel_cap_eur_per_ha(p) := cap_amount(parcel_cap_id(p), year)

parcel_other_payments_eur_per_ha(p) := object.get(parcel_oepul(p), "other_area_payments_eur_per_ha", 0)

parcel_capped_rate_eur_per_ha(p) := min([
	parcel_rate_eur_per_ha(p),
	max([0, parcel_cap_eur_per_ha(p) - parcel_other_payments_eur_per_ha(p)]),
])

default parcel_cap_exceeded(_) := false

parcel_cap_exceeded(p) if parcel_capped_rate_eur_per_ha(p) < parcel_rate_eur_per_ha(p)

# ---------------------------------------------------------------------------
# Brutto-Prämie je Schlag und Betrieb
# ---------------------------------------------------------------------------

premium_parcels contains p if {
	some p in eligible_parcels
	count(parcel_combination_conflicts(p)) == 0
	count(parcel_annex_j_conflicts(p)) == 0
}

parcel_premium_eur(p) := round((parcel_capped_rate_eur_per_ha(p) * p.area_ha) * 100) / 100

gross_premium_eur := sum([parcel_premium_eur(p) | some p in premium_parcels])

# ---------------------------------------------------------------------------
# Inhaltliche Kürzungen (Allg. 8.2, SRL 1.12.1.3)
# ---------------------------------------------------------------------------

violation_stage := object.get(o6_23_input, "content_violation_stage", "none")

sanction_reduction_percent := 0 if violation_stage == "none"

sanction_reduction_percent := s.reduction_percent if {
	some s in params.sanction_stages
	s.stage == violation_stage
	year < params.warning_replaced_from_year
}

# Ab 2027 statt Verwarnung Einbehalt von 1 % der Maßnahmenprämie.
sanction_reduction_percent := s.reduction_percent_from_2027 if {
	some s in params.sanction_stages
	s.stage == violation_stage
	year >= params.warning_replaced_from_year
}

# Ausschluss aus der Maßnahme und Rückforderung bei zweimaliger 100 %-Kürzung im
# Vertragszeitraum.
excluded_from_measure if {
	object.get(o6_23_input, "full_reductions_in_contract_period", 0) >= params.exclusion_after_full_reductions_in_contract_period
}

premium_after_sanctions_eur := round(((gross_premium_eur * (100 - sanction_reduction_percent)) / 100) * 100) / 100

# ---------------------------------------------------------------------------
# Betriebsgrößenmodulation (SRL 1.9.2.2, Allg. 9.3)
# ---------------------------------------------------------------------------

farm_area_ha := object.get(input, ["land", "total_area_ha"], 0)

band_share_area(b, area) := max([0, min([area, b.to_ha]) - b.from_ha]) if b.to_ha != null

band_share_area(b, area) := max([0, area - b.from_ha]) if b.to_ha == null

modulation_factor := 1 if farm_area_ha <= 0

modulation_factor := f if {
	farm_area_ha > 0
	weighted := sum([(band_share_area(b, farm_area_ha) * b.payout_share) | some b in params.modulation_bands])
	f := weighted / farm_area_ha
}

net_premium_eur := round((premium_after_sanctions_eur * modulation_factor) * 100) / 100

# Von der Gewährung kann abgesehen werden, wenn der Auszahlungsbetrag 50 Euro
# nicht überschreitet.
payout_below_minimum if net_premium_eur <= params.payment.minimum_payout_eur

advance_payment_max_eur := round((net_premium_eur * params.payment.advance_payment_max_share) * 100) / 100

payment_due_by := sprintf("%d-%s", [year + 1, params.payment.latest_payment_month_day_following_year])
