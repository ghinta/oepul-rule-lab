# o6_13 – Prämienhöhe, Obergrenze, Modulation und Auszahlung
package oepul.o6_13

# ---------------------------------------------------------------------------
# O6_13-PREM-01: 2023: 2.000 €/ha; ab 2024: 2.160 €/ha (A und GA)
# ---------------------------------------------------------------------------
premium_rate(field_use_type, y) := row.eur_per_ha if {
	some row in params.premium_rates
	row.field_use_type == field_use_type
	year_row_matches(row, y)
}

# ---------------------------------------------------------------------------
# O6_13-CAP-01: Obergrenze für Flächenzahlungen je Schlag für o6_13
#   (2023: 2.000 €/ha, ab 2024: 2.160 €/ha)
# ---------------------------------------------------------------------------
area_payment_cap(y) := row.eur_per_ha if {
	some row in general.area_payment_caps
	row.cap_group == measure_code
	year_row_matches(row, y)
}

capped_rate(field_use_type, y) := min([premium_rate(field_use_type, y), area_payment_cap(y)])

parcel_premium_eur(p) := round2(eligible_area_ha(p) * capped_rate(declared_field_use_type(p), year)) if {
	parcel_premium_eligible(p)
} else := 0

parcel_results := [r |
	some p in parcels
	nue_coded(p)
	r := {
		"parcel_id": p.parcel_id,
		"field_use_type": declared_field_use_type(p),
		"declared_area_ha": p.area_ha,
		"eligible_area_ha": eligible_area_ha(p),
		"premium_eligible": parcel_premium_eligible_flag(p),
		"rate_eur_per_ha": parcel_rate(p),
		"premium_eur": parcel_premium_eur(p),
		"issues": parcel_issue_list(p),
	}
]

parcel_rate(p) := capped_rate(declared_field_use_type(p), year) if {
	declared_field_use_type(p) in params.eligible_field_use_types
} else := 0

parcel_premium_eligible_flag(p) if {
	parcel_premium_eligible(p)
} else := false

eligible_premium_area_ha := round4(sum([eligible_area_ha(p) |
	some p in nue_parcels
	parcel_premium_eligible(p)
]))

gross_premium_eur := round2(sum([parcel_premium_eur(p) | some p in nue_parcels]))

# ---------------------------------------------------------------------------
# O6_13-MOD-01: Modulation nach Gesamtfläche des Betriebes
# ---------------------------------------------------------------------------
bracket_portion(b, area) := max([0, min([area, b.to_ha]) - b.from_ha]) if {
	b.to_ha != null
} else := max([0, area - b.from_ha])

modulation_factor(area) := 1 if {
	area <= 0
} else := weighted_payout_ha(area) / area

weighted_payout_ha(area) := sum([v |
	some b in general.modulation_brackets
	v := (bracket_portion(b, area) * b.payout_percent) / 100
])

farm_total_area_ha := object.get(input, ["land", "total_area_ha"], 0)

farm_modulation_factor := modulation_factor(farm_total_area_ha)

# ---------------------------------------------------------------------------
# Berechnungsreihenfolge (O6_13-SANC-07): inhaltliche Kürzung -> Obergrenze je
# Maßnahme -> Modulation -> Obergrenze Flächenzahlungen (bereits je Schlag
# über capped_rate berücksichtigt)
# ---------------------------------------------------------------------------
premium_after_content_reduction_eur := round2((gross_premium_eur * (100 - content_reduction_percent)) / 100)

net_premium_eur := round2(premium_after_content_reduction_eur * farm_modulation_factor) if {
	contract_in_force
} else := 0

# ---------------------------------------------------------------------------
# O6_13-PAY-01..03: Auszahlung bis 30.06. des Folgejahres, Teilzahlung max.
# 75 %, Bagatellgrenze 50 €
# ---------------------------------------------------------------------------
payment_deadline := iso_date(year + 1, general.payment.payment_deadline_month_day_following_year)

max_advance_payment_eur := round2((net_premium_eur * general.payment.max_advance_payment_percent) / 100)

payment_may_be_withheld_as_minor_amount if net_premium_eur <= general.payment.minimum_payment_threshold_eur
