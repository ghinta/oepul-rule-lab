package oepul.o6_1c

# Prämienberechnung: Prämienbänder, 4-%-Grenze, GLÖZ 4, Modulation.

# O6_1C-SCOPE-001: Prämie für nichtproduktive Ackerflächen und Agroforststreifen.
rate(category) := row if {
	some row in data.o6_1c.premium_rates.rows
	row.category == category
}

arable_area_ha := object.get(input, ["land", "arable_area_ha"], 0)

# O6_1C-NPA-014: NPA bis maximal 4 % der Ackerfläche prämienfähig.
npa_area_cap_ha := rate("npa").max_share_of_arable_area * arable_area_ha

# O6_1C-NPA-016: GLÖZ-4-Flächenteil nicht förderbar.
npa_area_before_cap_ha := sum([(object.get(p, "area_ha", 0) - npa_gloez4_area_ha(p)) |
	some p in npa_parcels
	eligible(p)
])

npa_eligible_area_ha := min_of(npa_area_before_cap_ha, npa_area_cap_ha)

afs_eligible_area_ha := sum([object.get(p, "area_ha", 0) |
	some p in afs_parcels
	eligible(p)
	afs_meets_definition(p)
])

# O6_1C-PREM-001 / O6_1C-PREM-002: Prämienbänder je Kategorie.
category_area_ha := {
	"npa": npa_eligible_area_ha,
	"agroforest": afs_eligible_area_ha,
}

premium_band_unmodulated := {
	"min_eur": sum([(category_area_ha[c] * rate(c).min_eur_per_ha) | some c in applied_categories_with_rates]),
	"max_eur": sum([(category_area_ha[c] * rate(c).max_eur_per_ha) | some c in applied_categories_with_rates]),
}

applied_categories_with_rates contains c if {
	some c in applied_categories
	rate(c)
	year >= data.o6_1c.premium_rates.valid_from_year
}

# O6_1C-PREM-004: Betriebsgrößenmodulation (gesamte Fläche des Betriebes).
band_share(total, band) := max_of(0, min_of(total, band.to_ha) - band.from_ha) if band.to_ha != null

band_share(total, band) := max_of(0, total - band.from_ha) if band.to_ha == null

modulation_factor(total) := 1 if total <= 0

modulation_factor(total) := f if {
	total > 0
	f := sum([(band_share(total, b) * b.payout_factor) | some b in data.o6_1c.modulation.bands]) / total
}

farm_total_area_ha := object.get(input, ["land", "total_area_ha"], 0)

farm_modulation_factor := modulation_factor(farm_total_area_ha)

# O6_1C-PREM-003: Prämienbänder je nach beantragter Fläche und verfügbaren
# Mitteln; garantiert ist der Mindestbetrag.
premium_band := {
	"min_eur": premium_band_unmodulated.min_eur * farm_modulation_factor,
	"max_eur": premium_band_unmodulated.max_eur * farm_modulation_factor,
	"guaranteed_eur": premium_band_unmodulated.min_eur * farm_modulation_factor,
} if {
	contract_valid
}

premium_band := {"min_eur": 0, "max_eur": 0, "guaranteed_eur": 0} if not contract_valid

# O6_1C-PREM-005: Ab 2025 keine Einrechnung von o6_1c in die
# Prämienobergrenze von 1.300 €/ha.
counts_towards_area_payment_cap := false if {
	year >= 2025
	measure_id in {m | some m in params.general.area_payment_cap_excluded_measures_from_2025}
}

# O6_1C-PREM-006: Auszahlung bis 30. Juni des Folgejahres; Teilzahlung
# höchstens 75 % nach abgeschlossener Verwaltungskontrolle.
payment_deadline := date_of(year + 1, params.general.payment_deadline_mmdd_following_year)

max_advance_payment_eur := params.general.advance_payment_max_share * premium_band.guaranteed_eur

# O6_1C-PREM-007: Von der Gewährung kann abgesehen werden, wenn der
# Auszahlungsbetrag 50 Euro nicht überschreitet.
payment_may_be_waived if {
	contract_valid
	premium_band.max_eur <= params.general.payment_waiver_threshold_eur
}
