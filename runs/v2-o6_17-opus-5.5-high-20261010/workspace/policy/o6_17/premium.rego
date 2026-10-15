package oepul.o6_17.premium

# Prämienberechnung (Informationsblatt Kapitel 8; SRL 2.17 Höhe der Förderung;
# Allgemeine Teilnahmebedingungen 5.5, 7.2, 9.2, 9.3; SRL 1.6.2, 1.7.2.4,
# 1.9.2, 1.10.7; Anhang L).

import data.oepul.o6_17.agl
import data.oepul.o6_17.common
import data.oepul.o6_17.eligibility

rates := data.o6_17_tables.premium_rates

fw := data.o6_17_tables.general_framework

annex_l_row := data.o6_17_tables.combination.annex_l_row_17

farm_premium_possible if {
	common.contract_active
	eligibility.access_requirements_met
}

has_no_premium_code(p) if {
	some c in fw.no_premium_parcel_codes
	c.code in common.codes(p)
}

in_national_park(p) if object.get(p, "in_national_park", false) == true

annex_code(m) := "1B" if m == "1B_TB"

else := m

# Anhang L: Maßnahme 17 ist auf der Einzelfläche nur mit 1A, 1B, 2, 3 und 9
# prämienmäßig kombinierbar.
non_combinable_measures(p) := {m |
	some m in common.parcel_measures(p)
	m != "17"
	object.get(annex_l_row, annex_code(m), "") != "x"
}

parcel_combination_ok(p) if count(non_combinable_measures(p)) == 0

# Jede förderfähige Fläche muss mindestens 50 m² (0,005 ha) groß sein.
min_parcel_size_ok(p) if p.area_ha >= 0.005

parcel_generally_payable(p) if {
	min_parcel_size_ok(p)
	not has_no_premium_code(p)
	not in_national_park(p)
	parcel_combination_ok(p)
}

upper_ok(t, _) if t.grassland_number_max_exclusive == null

upper_ok(t, gz) if {
	is_number(t.grassland_number_max_exclusive)
	gz < t.grassland_number_max_exclusive
}

base_tier(p) := t if {
	gz := object.get(p, "grassland_number", null)
	is_number(gz)
	some t in rates.base_tiers
	gz >= t.grassland_number_min
	upper_ok(t, gz)
}

base_rate(p) := r if {
	t := base_tier(p)
	r := t.rate_2023_eur_per_ha
	common.year == 2023
} else := r if {
	t := base_tier(p)
	r := t.rate_from_2024_eur_per_ha
	common.year >= 2024
}

# Grundprämie: Grünland < 18 % Hangneigung, kein GLÖZ 2/4/9-Umbruchsverbot.
base_eligible(p) if {
	farm_premium_possible
	p.land_use == "grassland"
	common.slope_below_18(p)
	not common.gloez_ban(p)
	common.use_type_info(p).base_premium_possible == true
	parcel_generally_payable(p)
	is_number(base_rate(p))
}

base_lines := [line |
	some p in common.grassland_parcels
	base_eligible(p)
	line := {
		"parcel_id": p.parcel_id,
		"area_ha": p.area_ha,
		"tier_id": base_tier(p).tier_id,
		"rate_eur_per_ha": base_rate(p),
		"amount_eur": p.area_ha * base_rate(p),
	}
]

base_area_ha := sum([l.area_ha | some l in base_lines])

base_amount_raw := sum([l.amount_eur | some l in base_lines])

# Flächenzugang ab 2026: max. 50 % auf Basis 2025, mindestens aber +5 ha.
area_basis_2025_ha := object.get(common.o6, "area_basis_2025_ha", null)

addition_cap_ha := cap if {
	common.year > 2025
	is_number(area_basis_2025_ha)
	cap := area_basis_2025_ha + max([
		area_basis_2025_ha * fw.area_addition_cap.max_increase_share,
		fw.area_addition_cap.always_allowed_increase_ha,
	])
}

base_area_factor := min([1, addition_cap_ha / base_area_ha]) if {
	is_number(addition_cap_ha)
	base_area_ha > 0
} else := 1

base_amount := base_amount_raw * base_area_factor

# ---------------------------------------------------------------------------
# Zuschlag artenreiches Grünland (AGL)

year_le(_, to) if to == null

year_le(y, to) if {
	is_number(to)
	y <= to
}

slope_class(p) := "unter_18" if common.slope_below_18(p)

slope_class(p) := "ab_18" if common.slope_from_18(p)

agl_rate(p) := r.rate_eur_per_ha if {
	cls := slope_class(p)
	some r in rates.agl_rates
	r.slope_class == cls
	common.year >= r.valid_from_year
	year_le(common.year, r.valid_to_year)
}

# GLÖZ 2/4/9-Flächen sind für den AGL-Zuschlag nicht ausgeschlossen.
agl_eligible(p) if {
	farm_premium_possible
	p.land_use == "grassland"
	agl.qualifies(p)
	parcel_generally_payable(p)
	is_number(agl_rate(p))
}

agl_lines := [line |
	some p in common.grassland_parcels
	agl_eligible(p)
	line := {
		"parcel_id": p.parcel_id,
		"area_ha": p.area_ha,
		"slope_class": slope_class(p),
		"rate_eur_per_ha": agl_rate(p),
		"amount_eur": p.area_ha * agl_rate(p),
	}
]

agl_area_ha := sum([l.area_ha | some l in agl_lines])

mown_grassland_ha := sum([p.area_ha |
	some p in common.grassland_parcels
	common.use_type_info(p).counts_as_mown_grassland == true
])

agl_cap_row := c if {
	some c in rates.agl_caps
	common.year >= c.valid_from_year
	year_le(common.year, c.valid_to_year)
}

# Max. 15 % (bis 2024) bzw. 25 % (ab 2025) des gemähten Grünlands, jedenfalls 2 ha.
agl_cap_ha := max([agl_cap_row.max_share_of_mown_grassland * mown_grassland_ha, agl_cap_row.guaranteed_min_ha])

agl_area_factor := min([1, agl_cap_ha / agl_area_ha]) if agl_area_ha > 0

else := 1

agl_amount := sum([l.amount_eur | some l in agl_lines]) * agl_area_factor

# ---------------------------------------------------------------------------
# Betriebsgrößenmodulation

farm_area_ha := object.get(input, ["land", "total_area_ha"], sum([p.area_ha | some p in common.parcels]))

tier_upper(t, a) := a if t.to_ha_inclusive == null

else := t.to_ha_inclusive

tier_portion(t, a) := max([0, min([a, tier_upper(t, a)]) - t.from_ha_exclusive])

weighted_portion(t) := tier_portion(t, farm_area_ha) * t.payout_share

modulation_factor := f if {
	farm_area_ha > 0
	f := sum([w | some t in fw.modulation_tiers; w := weighted_portion(t)]) / farm_area_ha
} else := 1

amount_before_modulation := base_amount + agl_amount

total_premium_eur := common.round2(amount_before_modulation * modulation_factor)

below_minimum_payout if total_premium_eur <= fw.payment.minimum_payout_eur

# ---------------------------------------------------------------------------
# Prämienobergrenze für flächenbezogene Zahlungen je Schlag

cap_scope(p) := "naturschutz_ebw" if {
	some m in common.parcel_measures(p)
	m in {"18", "19"}
} else := "standard"

parcel_cap(p) := c.cap_eur_per_ha if {
	some c in fw.area_payment_caps
	c.scope == cap_scope(p)
	common.year >= c.valid_from_year
	year_le(common.year, c.valid_to_year)
}

parcel_rate_sum(p) := sum([r | some l in array.concat(base_lines, agl_lines); l.parcel_id == p.parcel_id; r := l.rate_eur_per_ha])

parcels_exceeding_area_payment_cap contains p.parcel_id if {
	some p in common.grassland_parcels
	total := parcel_rate_sum(p) + object.get(p, "oepul_other_payments_eur_per_ha", 0)
	total > parcel_cap(p)
}

# ---------------------------------------------------------------------------
# Auszahlung

payment_deadline := sprintf("%d-%s", [common.year + 1, fw.payment.payment_deadline_month_day_following_year])

max_advance_payment_eur := common.round2(total_premium_eur * fw.payment.max_advance_share)

excluded_parcels contains {"parcel_id": p.parcel_id, "reason": reason} if {
	some p in common.grassland_parcels
	some reason in exclusion_reasons(p)
}

exclusion_reasons(p) := {r |
	some r in ["slope_from_18_base", "gloez_ploughing_ban", "no_premium_code", "national_park", "not_combinable_on_parcel", "use_type_not_eligible", "grassland_number_missing", "below_50m2"]
	excluded_by(p, r)
}

excluded_by(p, "slope_from_18_base") if common.slope_from_18(p)

excluded_by(p, "gloez_ploughing_ban") if common.gloez_ban(p)

excluded_by(p, "no_premium_code") if has_no_premium_code(p)

excluded_by(p, "national_park") if in_national_park(p)

excluded_by(p, "not_combinable_on_parcel") if not parcel_combination_ok(p)

excluded_by(p, "use_type_not_eligible") if common.use_type_info(p).base_premium_possible == false

excluded_by(p, "below_50m2") if not min_parcel_size_ok(p)

excluded_by(p, "grassland_number_missing") if not is_number(object.get(p, "grassland_number", null))

summary := {
	"farm_premium_possible": farm_premium_possible,
	"base_lines": base_lines,
	"base_amount_eur": common.round2(base_amount),
	"base_area_factor": base_area_factor,
	"agl_lines": agl_lines,
	"agl_cap_ha": agl_cap_ha,
	"agl_area_factor": agl_area_factor,
	"agl_amount_eur": common.round2(agl_amount),
	"modulation_factor": modulation_factor,
	"total_premium_eur": total_premium_eur,
	"below_minimum_payout": below_minimum_payout,
	"payment_deadline": payment_deadline,
	"max_advance_payment_eur": max_advance_payment_eur,
	"parcels_exceeding_area_payment_cap": parcels_exceeding_area_payment_cap,
	"excluded_parcels": excluded_parcels,
}

default farm_premium_possible := false

default below_minimum_payout := false
