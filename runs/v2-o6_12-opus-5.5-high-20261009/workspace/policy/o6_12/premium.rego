package oepul.o6_12

# Prämienberechnung, Modulation, Obergrenzen, Auszahlung.

rate_for(category, yr) := r.eur_per_ha if {
	some r in data.o6_12.premium_rates
	r.crop_category == category
	r.year_from <= yr
	yr <= r.year_to
}

parcel_premium_eur[p.parcel_id] := p.area_ha * rate_for(crop_category(p), year) if {
	some p in parcels
	p.parcel_id in eligible_parcel_ids
}

gross_premium_eur := sum([a | some a in parcel_premium_eur])

# Gründe, aus denen im betrachteten Jahr keine Maßnahmenprämie gewährt wird.
premium_blocking_reasons contains "not_participating" if not participates

premium_blocking_reasons contains "no_valid_contract" if {
	participates
	not contract_established
}

premium_blocking_reasons contains "year_outside_contract_period" if {
	participates
	not year_in_contract_period
}

premium_blocking_reasons contains "access_conditions_not_met" if {
	participates
	access_condition_consequence != "none"
}

premium_blocking_reasons contains "rebzikade_exit_in_year" if {
	rebzikade_exit_year == year
}

premium_blocking_reasons contains "rebzikade_exit_in_previous_year" if {
	rebzikade_exit_year < year
}

premium_blocking_reasons contains "deregistered_in_year" if {
	exit_in_current_year
	not rebzikade_exit_without_repayment
}

premium_blocking_reasons contains "annual_payment_application_missing" if annual_payment_application_missing

premium_blocking_reasons contains "control_refused" if {
	participates
	o612.control_refused == true
}

premium_blocking_reasons contains "excluded_from_measure" if excluded_from_measure

premium_granted if count(premium_blocking_reasons) == 0

# --- Übererklärung (§ 42 Abs. 4, § 46 GSP-AV) ----------------------------------

sanction_rules := data.o6_12.sanction_rules

declared_area_ha := object.get(o612, "declared_area_ha", eligible_area_ha)

determined_area_ha := object.get(o612, "determined_area_ha", declared_area_ha)

overdeclaration_ha := max([declared_area_ha - determined_area_ha, 0])

overdeclaration_sanctioned if {
	overdeclaration_ha > 0
	overdeclaration_ha > (sanction_rules.overdeclaration_tolerance_percent / 100) * determined_area_ha
}

overdeclaration_sanctioned if {
	overdeclaration_ha > sanction_rules.overdeclaration_tolerance_ha
}

premium_basis_area_ha := max([determined_area_ha - (sanction_rules.overdeclaration_multiplier * overdeclaration_ha), 0]) if {
	overdeclaration_sanctioned
} else := min([declared_area_ha, determined_area_ha])

# Durchschnittlicher Prämiensatz der förderfähigen Flächen (für die flächenbasierte Kürzung).
average_rate_eur_per_ha := gross_premium_eur / eligible_area_ha if eligible_area_ha > 0

else := 0

premium_after_area_check_eur := premium_basis_area_ha * average_rate_eur_per_ha

# --- Modulation (SRL 1.9.2.2) ---------------------------------------------------

band_upper(b, total) := min([total, b.to_ha_inclusive]) if b.to_ha_inclusive != null

band_upper(b, total) := total if b.to_ha_inclusive == null

band_weight(b, total) := w if {
	portion := band_upper(b, total) - b.from_ha_exclusive
	portion > 0
	w := portion * b.payment_factor
}

band_weight(b, total) := 0 if band_upper(b, total) - b.from_ha_exclusive <= 0

modulation_factor(total) := 1 if total <= 0

modulation_factor(total) := f if {
	total > 0
	f := sum([band_weight(b, total) | some b in data.o6_12.modulation_bands]) / total
}

farm_modulation_factor := modulation_factor(object.get(input, ["land", "total_area_ha"], 0))

# --- Auszahlungsschätzung -------------------------------------------------------

payment_estimate_eur := 0 if not premium_granted

else := round(((premium_after_area_check_eur * (1 - (content_reduction_percent / 100))) * farm_modulation_factor) * 100) / 100

# Von der Gewährung kann abgesehen werden, wenn der Betrag 50 Euro nicht überschreitet.
payment_may_be_waived if {
	premium_granted
	payment_estimate_eur <= data.o6_12.payment_rules.minimum_payment_eur
}

advance_payment_max_eur := payment_estimate_eur * data.o6_12.payment_rules.advance_payment_max_share

payment_deadline := sprintf("%d-%s", [year + 1, data.o6_12.payment_rules.payment_deadline_month_day_following_year])

payments_not_before := sprintf("%d-%s", [year, data.o6_12.payment_rules.payments_not_before_month_day])

# --- Obergrenze für Flächenzahlungen je Schlag (SRL 1.9.2.1) -----------------------

general_area_cap_eur_per_ha := c.eur_per_ha if {
	some c in data.o6_12.area_payment_caps
	c.cap_id == "general"
	c.year_from <= year
	year <= c.year_to
}

parcel_cap_excess_eur_per_ha[p.parcel_id] := excess if {
	some p in parcels
	p.parcel_id in eligible_parcel_ids
	total := rate_for(crop_category(p), year) + object.get(p, "other_area_payments_eur_per_ha", 0)
	excess := total - general_area_cap_eur_per_ha
	excess > 0
}

# --- Zusammenfassung ------------------------------------------------------------

decision := {
	"measure": "o6_12",
	"year": year,
	"participates": participates,
	"contract_established": contract_established,
	"access_condition_failures": access_condition_failures,
	"eligible_parcel_ids": eligible_parcel_ids,
	"eligible_area_ha": eligible_area_ha,
	"gross_premium_eur": gross_premium_eur,
	"premium_blocking_reasons": premium_blocking_reasons,
	"obligation_breaches": obligation_breaches,
	"content_reduction_percent": content_reduction_percent,
	"modulation_factor": farm_modulation_factor,
	"payment_estimate_eur": payment_estimate_eur,
	"repayment_required_reasons": repayment_required_reasons,
}
