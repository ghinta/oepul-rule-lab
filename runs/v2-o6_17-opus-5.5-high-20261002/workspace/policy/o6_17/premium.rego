# o6_17 Prämienberechnung
#
#   Förderfähigkeit von Schlägen, Prämiensätze nach Grünlandzahl, Zuschlag
#   artenreiches Grünland inkl. Obergrenze, Kombinierbarkeit (Anhang L),
#   Flächenzugangsbeschränkung, Modulation und Flächenzahlungsobergrenze
#   (Merkblatt o6_17 Kap. 8; SRL 2.17; SRL 1.7.2.4, 1.9.2; Allg. Bedingungen 7.2, 9.2, 9.3).
package oepul.o6_17

import rego.v1

rates := tables.premium_rates

slope_limit := rates.base_slope_max_exclusive_percent

year_in_range(entry) if {
	entry.year_from <= year
	entry.year_to == null
}

year_in_range(entry) if {
	entry.year_from <= year
	entry.year_to != null
	year <= entry.year_to
}

# ---------------------------------------------------------------------------
# Allgemeine Ausschlüsse auf Schlagebene (Allg. Bedingungen 5.5.1, 5.5.2)
# ---------------------------------------------------------------------------

national_parks_without_premium := {n.code | some n in tables.lists.national_parks_no_area_premium}

parcel_excluded_reason(p) := "op_code" if "OP" in parcel_codes(p)

else := "trial_area_vf" if "VF" in parcel_codes(p)

else := "measure_specific_op_code" if object.get(p, ["oepul", "o6_17_op_code"], false) == true

else := "national_park" if object.get(p, ["oepul", "national_park"], "none") in national_parks_without_premium

else := "national_park_restrictions" if {
	object.get(p, ["oepul", "national_park"], "none") != "none"
	object.get(p, ["oepul", "national_park_relevant_restrictions"], false) == true
}

else := "outside_austria" if object.get(p, ["oepul", "in_austria"], true) == false

else := "field_use_not_eligible" if field_use_types[parcel_field_use(p)].premium_eligible == false

else := "combination_not_permitted" if parcel_combination_conflict(p)

parcel_excluded(p) if parcel_excluded_reason(p)

# ---------------------------------------------------------------------------
# Kombinierbarkeit auf der Einzelfläche (SRL 1.9.4; Anhang L)
# ---------------------------------------------------------------------------

matrix := tables.combination_matrix

matrix_measures := {m | some m in matrix.measures}

combinable(a, b) if {
	some cell in matrix.cells
	cell.row_measure == a
	cell.column_measure == b
}

combination_cell(a, b) := cell if {
	some cell in matrix.cells
	cell.row_measure == a
	cell.column_measure == b
}

parcel_combination_conflicts(p) := {m |
	some m in parcel_measures(p)
	m != "o6_17"
	m in matrix_measures
	not combinable("o6_17", m)
}

parcel_combination_conflict(p) if count(parcel_combination_conflicts(p)) > 0

combination_conflicts contains {
	"rule_id": "O617-COMB-ANHANG-L",
	"parcel_id": p.parcel_id,
	"measures": parcel_combination_conflicts(p),
} if {
	some p in parcels
	parcel_combination_conflict(p)
}

# ---------------------------------------------------------------------------
# Grundprämie (Grünland < 18 % Hangneigung)
# ---------------------------------------------------------------------------

base_parcel_eligible(p) if {
	in_contract_period
	is_grassland(p)
	is_number(p.slope_percent)
	p.slope_percent < slope_limit
	not parcel_gloez_ineligible(p)
	not parcel_excluded(p)
}

grassland_number_in_tier(glz, tier) if {
	tier.grassland_number_min == null
	glz < tier.grassland_number_max_exclusive
}

grassland_number_in_tier(glz, tier) if {
	tier.grassland_number_min != null
	glz >= tier.grassland_number_min
	tier.grassland_number_max_exclusive == null
}

grassland_number_in_tier(glz, tier) if {
	tier.grassland_number_min != null
	tier.grassland_number_max_exclusive != null
	glz >= tier.grassland_number_min
	glz < tier.grassland_number_max_exclusive
}

base_rate_for(glz) := tier.eur_per_ha if {
	is_number(glz)
	some tier in rates.base
	year_in_range(tier)
	grassland_number_in_tier(glz, tier)
}

base_rate(p) := base_rate_for(object.get(p, ["oepul", "grassland_number"], null))

base_premium_parcels[p.parcel_id] := {
	"area_ha": p.area_ha,
	"rate_eur_per_ha": base_rate(p),
	"amount_eur": p.area_ha * base_rate(p),
} if {
	some p in parcels
	base_parcel_eligible(p)
	is_number(object.get(p, ["oepul", "grassland_number"], null))
}

base_parcels_missing_grassland_number contains p.parcel_id if {
	some p in parcels
	base_parcel_eligible(p)
	not is_number(object.get(p, ["oepul", "grassland_number"], null))
}

base_premium_area_ha := sum([b.area_ha | some b in base_premium_parcels])

base_premium_raw_eur := sum([b.amount_eur | some b in base_premium_parcels])

# ---------------------------------------------------------------------------
# Flächenzugang ab 2026: max. +50 % auf Basis 2025, mindestens +5 ha (SRL 1.7.2.4)
# ---------------------------------------------------------------------------

increase_limit := tables.general_tables.area_increase_limit

premium_area_cap_ha := measure.measure_area_2025_ha + max([
	increase_limit.max_increase_share * measure.measure_area_2025_ha,
	increase_limit.min_increase_ha_always,
]) if {
	year > increase_limit.base_year
	is_number(object.get(measure, "measure_area_2025_ha", null))
}

area_increase_factor := 1 if not premium_area_cap_ha

area_increase_factor := 1 if {
	premium_area_cap_ha
	base_premium_area_ha <= premium_area_cap_ha
}

area_increase_factor := premium_area_cap_ha / base_premium_area_ha if {
	base_premium_area_ha > premium_area_cap_ha
}

base_premium_eur := base_premium_raw_eur * area_increase_factor

# ---------------------------------------------------------------------------
# Zuschlag artenreiches Grünland (AGL)
# ---------------------------------------------------------------------------

agl_slope_class(p) := "lt_18" if p.slope_percent < slope_limit

else := "ge_18"

agl_rate(p) := entry.eur_per_ha if {
	some entry in rates.agl
	entry.slope_class == agl_slope_class(p)
	year_in_range(entry)
}

agl_parcel_eligible(p) if {
	in_contract_period
	is_grassland(p)
	is_number(p.slope_percent)
	fu := field_use_types[parcel_field_use(p)]
	fu.agl_mode in {"code_agl_required", "automatic"}
	agl_rate(p)
	not parcel_excluded(p)
	agl_parcel_requirements_met(p, fu.agl_mode)
}

agl_parcel_requirements_met(_, "automatic") := true

agl_parcel_requirements_met(p, "code_agl_required") if {
	"AGL" in parcel_codes(p)
	agl_species_requirement_met(p)
	agl_first_use_mowing(p)
	agl_documentation_complete(p)
}

mown_grassland_ha := sum([p.area_ha |
	some p in parcels
	is_grassland(p)
	fu := field_use_types[parcel_field_use(p)]
	fu.mown == true
	fu.code != "bergmaehder"
])

agl_cap_rule := entry if {
	some entry in rates.agl_cap
	year_in_range(entry)
}

# Max. 15 % (bis 2024) bzw. 25 % (ab 2025) des gemähten Grünlands, jedenfalls aber 2,00 ha.
agl_cap_ha := max([agl_cap_rule.max_share_of_mown_grassland * mown_grassland_ha, agl_cap_rule.minimum_cap_ha])

agl_parcels[p.parcel_id] := {
	"area_ha": p.area_ha,
	"rate_eur_per_ha": agl_rate(p),
	"amount_eur": p.area_ha * agl_rate(p),
} if {
	some p in parcels
	agl_parcel_eligible(p)
}

agl_eligible_area_ha := sum([a.area_ha | some a in agl_parcels])

agl_premium_area_ha := min([agl_eligible_area_ha, agl_cap_ha])

agl_cap_factor := 1 if agl_eligible_area_ha <= agl_cap_ha

agl_cap_factor := agl_cap_ha / agl_eligible_area_ha if agl_eligible_area_ha > agl_cap_ha

agl_premium_eur := sum([a.amount_eur | some a in agl_parcels]) * agl_cap_factor

# ---------------------------------------------------------------------------
# Summe, Modulation, Obergrenzen
# ---------------------------------------------------------------------------

premium_gross_eur := base_premium_eur + agl_premium_eur

modulation_tiers := tables.general_tables.modulation_tiers

tier_upper(tier, total) := tier.to_ha_inclusive if tier.to_ha_inclusive != null

else := total

modulation_factor := 1 if object.get(input, ["land", "total_area_ha"], 0) <= 0

modulation_factor := factor if {
	total := input.land.total_area_ha
	total > 0
	parts := [((min([total, tier_upper(tier, total)]) - tier.from_ha_exclusive) * tier.payout_share) |
		some tier in modulation_tiers
		total > tier.from_ha_exclusive
	]
	factor := sum(parts) / total
}

premium_after_modulation_eur := premium_gross_eur * modulation_factor

area_payment_cap_scope := "o6_18_or_o6_19" if {
	some m in farm_measures
	m in {"o6_18", "o6_19"}
} else := "general"

area_payment_cap_eur_per_ha := entry.eur_per_ha if {
	some entry in tables.general_tables.area_payment_caps
	entry.scope == area_payment_cap_scope
	year_in_range(entry)
}

parcel_area_payment_cap_exceeded contains p.parcel_id if {
	some p in parcels
	b := object.get(base_premium_parcels, p.parcel_id, {"rate_eur_per_ha": 0})
	a := object.get(agl_parcels, p.parcel_id, {"rate_eur_per_ha": 0})
	other := object.get(p, ["oepul", "other_area_payments_eur_per_ha"], 0)
	(b.rate_eur_per_ha + a.rate_eur_per_ha) + other > area_payment_cap_eur_per_ha
}
