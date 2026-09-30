# Prämienberechnung (Kapitel 7 Informationsblatt, SRL 2.2.5, allgemeine
# Bestimmungen zu Modulation, Obergrenzen, Flächenzugang).
package oepul.o6_2

rate_for(category, status, band, y) := r.eur_per_ha if {
	some r in premium_data.rates
	r.area_category == category
	r.livestock_status in {"any", status}
	r.rgve_band in {"any", band}
	r.year_from <= y
	y <= r.year_to
}

non_eligible_types := {t.id | some t in lists.non_eligible_crop_types}

national_park_premium_possible(p) if object.get(p, "national_park", null) == null

national_park_premium_possible(p) if {
	some np in general.national_parks
	np.id == p.national_park
	np.o6_2_premium_possible
}

# Gründe, aus denen eine Parzelle keine o6_2-Prämie erhält: [parcel_id, Grund].
parcel_exclusions contains [p.parcel_id, "not_in_austria"] if {
	some p in parcels
	not parcel_in_austria(p)
}

parcel_exclusions contains [p.parcel_id, "not_eligible_category"] if {
	some p in parcels
	parcel_category(p) == "not_eligible"
}

parcel_exclusions contains [p.parcel_id, "non_eligible_crop_type"] if {
	some p in parcels
	object.get(p, ["crop", "non_eligible_type"], null) in non_eligible_types
}

parcel_exclusions contains [p.parcel_id, "protected_cultivation"] if {
	some p in parcels
	is_protected_cultivation(p)
}

parcel_exclusions contains [p.parcel_id, "code_op_or_vf"] if {
	some p in parcels
	has_no_premium_code(p)
}

parcel_exclusions contains [p.parcel_id, "national_park"] if {
	some p in parcels
	not national_park_premium_possible(p)
}

parcel_exclusions contains [p.parcel_id, "fruit_not_quality_planting_material"] if {
	some p in parcels
	fruit_without_quality_material(p)
}

parcel_exclusions contains [p.parcel_id, "glaez8_npf_forage_until_2024"] if {
	some p in parcels
	glaez8_npf_forage_excluded(p)
}

parcel_exclusions contains [p.parcel_id, "minimum_management_not_met"] if {
	some p in parcels
	not minimum_management_met(p)
}

parcel_exclusions contains [p.parcel_id, "single_area_combination_conflict"] if {
	some p in parcels
	count(parcel_combination_conflicts(p)) > 0
}

exclusion_reasons_of(p) := {r | some [pid, r] in parcel_exclusions; pid == p.parcel_id}

has_no_premium_code(p) if {
	some c in general.no_premium_codes
	c in oepul_codes_of(p)
}

fruit_without_quality_material(p) if {
	p.crop.crop_category == "orchard"
	object.get(p, "fruit_quality_planting_material", true) == false
}

# Bis einschließlich 2024 keine Ackerfutterprämie für GLÖZ-8-NPF Klee/Kleegras/Luzerne.
glaez8_npf_forage_excluded(p) if {
	year <= 2024
	object.get(p, ["crop", "glaez8_npf"], false) == true
	some c in lists.glaez8_npf_forage_crops_without_forage_premium_until_2024
	lower(c) == crop_name_of(p)
}

premium_eligible_parcel(p) if count(exclusion_reasons_of(p)) == 0

parcel_rate(p) := rate_for(parcel_category(p), livestock_status, rgve_band, year) if premium_eligible_parcel(p)

parcel_premium_eur := {p.parcel_id: v |
	some p in parcels
	premium_eligible_parcel(p)
	v := parcel_rate(p) * p.area_ha
}

premium_eligible_area_ha := sum([p.area_ha | some p in parcels; premium_eligible_parcel(p)])

gross_premium_eur := sum([v | some v in parcel_premium_eur])

# Inhaltliche Kürzung gemäß festgelegter Sanktionsstufe.
sanction_level := object.get(o6_2_state, ["sanction", "level"], null)

sanction_reduction_percent := sanction_percent_for(sanction_level, year) if {
	sanction_level != null
} else := 0

excluded_from_measure if sanction_level == "exclusion"

excluded_from_measure if object.get(o6_2_state, ["sanction", "full_reductions_in_contract_period"], 0) >= 2

# Betriebsgrößenmodulation.
tier_share(area, t) := max([0, min([area, t.to_ha]) - t.from_ha]) if t.to_ha != null

tier_share(area, t) := max([0, area - t.from_ha]) if t.to_ha == null

modulation_factor(area) := 1 if area <= 0

modulation_factor(area) := sum([v |
	some t in general.modulation_tiers
	v := (tier_share(area, t) * t.payout_percent) / 100
]) / area if {
	area > 0
}

farm_modulation_factor := modulation_factor(total_farm_area_ha)

# Obergrenze der Flächenzahlungen je ha (Summe aller Flächenzahlungen des Schlags).
area_payment_cap_eur_per_ha := c.eur_per_ha if {
	some c in general.area_payment_caps
	c.applies_to == "standard"
	c.year_from <= year
	year <= c.year_to
}

parcel_net_rate(p) := min([
	((parcel_rate(p) * (100 - sanction_reduction_percent)) / 100) * farm_modulation_factor,
	max([0, area_payment_cap_eur_per_ha - object.get(p, "other_area_payments_eur_per_ha", 0)]),
])

parcel_net_premium_eur := {p.parcel_id: v |
	some p in parcels
	premium_eligible_parcel(p)
	v := parcel_net_rate(p) * p.area_ha
}

net_before_access_reduction_eur := sum([v | some v in parcel_net_premium_eur])

# Flächenzugang ab 2026: max. +50 % auf Basis 2025, mind. +5 ha immer zulässig.
area_2025_ha := object.get(o6_2_state, "committed_area_2025_ha", null)

new_area_additions_ha := object.get(o6_2_state, "new_area_additions_ha", 0)

allowed_area_increase_ha := max([
	(area_2025_ha * general.area_increase.max_increase_percent_after_base) / 100,
	general.area_increase.always_allowed_increase_ha,
]) if {
	area_2025_ha != null
}

area_increase_excess_ha := max([0, new_area_additions_ha - allowed_area_increase_ha]) if {
	year > general.area_increase.base_year
} else := 0

average_net_rate := net_before_access_reduction_eur / premium_eligible_area_ha if {
	premium_eligible_area_ha > 0
} else := 0

access_reduction_eur := min([area_increase_excess_ha, premium_eligible_area_ha]) * average_net_rate

premium_granted if {
	contract_valid
	not no_premium_this_year_due_to_access
	not excluded_from_measure
	object.get(o6_2_state, "payment_application_submitted", true) == true
}

net_premium_eur := max([0, net_before_access_reduction_eur - access_reduction_eur]) if {
	premium_granted
} else := 0

payout_may_be_waived if net_premium_eur <= general.payment.min_payout_eur

max_advance_payment_eur := (net_premium_eur * general.payment.max_advance_percent) / 100
