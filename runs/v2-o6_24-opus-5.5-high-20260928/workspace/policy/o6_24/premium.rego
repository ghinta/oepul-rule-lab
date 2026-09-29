# o6_24 – Prämienfähigkeit und Prämienberechnung
# Prämiensatz je Jahr, prämienfähige Fläche, Kürzung, Modulation, Obergrenze, Auszahlung.
package oepul.o6_24

# --- Prämiensatz ---
rate_eur_per_ha := r.eur_per_ha if {
	some r in data.o6_24.premium.rates
	r.valid_from_year <= year
	r.valid_to_year == null
} else := r.eur_per_ha if {
	some r in data.o6_24.premium.rates
	r.valid_from_year <= year
	year <= r.valid_to_year
}

non_eligible_crop(p) if crop_name(p) in {c | some c in cfg.non_eligible_crop_names}

no_premium_code(p) if {
	some row in cfg.no_premium_codes
	row.code in parcel_codes(p)
}

# Fehlerfreie Prämienfähigkeit einer Einzelfläche in Maßnahme 24.
parcel_premium_eligible(p) if {
	parcel_is_arable(p)
	parcel_in_area(p)
	parcel_declared_for_measure(p)
	not parcel_is_fallow(p)
	not parcel_has_increased_n_permit(p)
	not no_premium_code(p)
	not non_eligible_crop(p)
	object.get(p, "located_in_austria", true) != false
	object.get(p, "is_gloez_landscape_element", false) != true
	object.get(p, "mainly_agricultural_use", true) != false
	not op_code_required_for_overlap(parcel_overlap(p))
	parcel_min_management_met(p)
	not combination_conflict_parcel(p)
}

combination_conflict_parcel(p) if {
	some c in combination_conflicts
	c.parcel_id == p.parcel_id
}

eligible_parcels := [p |
	some p in parcels
	parcel_premium_eligible(p)
]

eligible_parcel_ids := {p.parcel_id | some p in eligible_parcels}

# Nationalparkflächen sind in Maßnahme 24 nicht von der Prämie ausgeschlossen.
national_park_parcels_with_premium contains p.parcel_id if {
	some p in eligible_parcels
	p.in_national_park == true
}

eligible_area_ha := sum([p.area_ha | some p in eligible_parcels])

gross_premium_eur := round2(eligible_area_ha * rate_eur_per_ha)

# --- Inhaltliche Kürzung (Stufenschema) ---
sanction_step := object.get(participation, "sanction_step", null)

sanction_reduction_percent(step, y) := pct if {
	some row in cfg.sanction_steps
	row.step == step
	valid_for_year(row, y)
	pct := row.reduction_percent
}

applied_sanction_percent := sanction_reduction_percent(sanction_step, year) if sanction_step != null

else := 0

excluded_from_measure if sanction_step == "exclusion"

# --- Modulation nach Betriebsgröße (Heimfläche) ---
tier_portion(total, t) := max([0, min([total, t.up_to_ha]) - t.above_ha]) if t.up_to_ha != null

tier_portion(total, t) := max([0, total - t.above_ha]) if t.up_to_ha == null

modulation_factor(total) := 1 if total <= 0

modulation_factor(total) := f if {
	total > 0
	parts := [v | some t in cfg.modulation_tiers; v := tier_portion(total, t) * t.factor]
	f := sum(parts) / total
}

farm_modulation_factor := modulation_factor(object.get(input, ["land", "total_area_ha"], 0))

# --- Obergrenze der flächenbezogenen Zahlungen je Schlag ---
standard_area_cap_eur_per_ha := c.eur_per_ha if {
	some c in cfg.area_payment_caps
	c.scope == "standard"
	valid_for_year(c, year)
}

parcel_other_payments(p) := object.get(wrrl(p), "other_area_payments_eur_per_ha", 0)

area_cap_excess(p) := x if {
	combined := rate_eur_per_ha + parcel_other_payments(p)
	combined > standard_area_cap_eur_per_ha
	x := {
		"parcel_id": p.parcel_id,
		"combined_eur_per_ha": combined,
		"cap_eur_per_ha": standard_area_cap_eur_per_ha,
		"excess_eur_per_ha": combined - standard_area_cap_eur_per_ha,
		"wrrl_share_of_excess_eur_per_ha": ((combined - standard_area_cap_eur_per_ha) * rate_eur_per_ha) / combined,
	}
}

area_cap_exceedances contains area_cap_excess(p) if {
	some p in eligible_parcels
	area_cap_excess(p)
}

area_cap_reduction_eur := sum([v |
	some p in eligible_parcels
	x := area_cap_excess(p)
	v := p.area_ha * x.wrrl_share_of_excess_eur_per_ha
])

# --- Berechnungskette (Reihenfolge: inhaltliche Kürzung -> Modulation -> Obergrenze) ---
premium_after_sanction_eur := (gross_premium_eur * (100 - applied_sanction_percent)) / 100

premium_after_modulation_eur := premium_after_sanction_eur * farm_modulation_factor

premium_after_cap_eur := max([0, premium_after_modulation_eur - (((area_cap_reduction_eur * farm_modulation_factor) * (100 - applied_sanction_percent)) / 100)])

default premium_granted := false

premium_granted if {
	contract_valid_for_year
	not excluded_from_measure
}

final_premium_eur := round2(premium_after_cap_eur) if premium_granted

else := 0

# Auszahlungsbetrag <= 50 EUR: Von der Gewährung kann abgesehen werden.
default payout_may_be_withheld := false

payout_may_be_withheld if {
	final_premium_eur > 0
	final_premium_eur <= thresholds.min_payout_eur
}

max_advance_payment_eur := round2(final_premium_eur * thresholds.max_advance_payment_share)

payout_deadline := date_string(year + deadline("payout").relative_year, deadline("payout").month, deadline("payout").day)
