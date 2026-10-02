# o6_16 – anwendbare allgemeine Teilnahmebedingungen ÖPUL 2023
package oepul.o6_16

# ---------------------------------------------------------------------------
# 5.2 Förderwerbende Personen (Gebietskörperschaften ausgeschlossen, o6_16 nicht in der Ausnahmeliste)
# ---------------------------------------------------------------------------

public_body_excluded_for(measure, yr, share) if {
	share > general.public_body_max_share_percent
	not public_body_exception(measure, yr)
}

public_body_exception(measure, yr) if {
	some e in general.public_body_exception_measures
	e.measure_id == measure
	not year_before(yr, e.from_year)
	not year_after(yr, e.until_year)
}

year_before(yr, from) if {
	is_number(from)
	yr < from
}

year_after(yr, until) if {
	is_number(until)
	yr > until
}

violations contains {
	"rule_id": "o6_16.general.applicant_public_body",
	"parcel_id": null,
	"message": "Gebietskörperschaften bzw. Einrichtungen mit mehr als 25 % Beteiligung von Gebietskörperschaften sind für o6_16 nicht förderwerbend.",
} if {
	participates_o6_16
	public_body_excluded_for("o6_16", year, object.get(input, ["farm", "applicant", "public_body_share_percent"], 0))
}

violations contains {
	"rule_id": "o6_16.general.applicant_type",
	"parcel_id": null,
	"message": "Rechtsform der förderwerbenden Person nicht zulässig.",
} if {
	participates_o6_16
	lf := input.farm.applicant.legal_form
	not lf in {t | some t in general.applicant_types}
}

# ---------------------------------------------------------------------------
# 5.3 Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr
# ---------------------------------------------------------------------------

min_farm_size_met if object.get(input, ["land", "protected_cultivation_area_ha"], 0) >= general.min_farm_size_first_year.protected_cultivation_ha

min_farm_size_met if object.get(input, ["land", "total_area_ha"], 0) >= general.min_farm_size_first_year.agricultural_area_ha

violations contains {
	"rule_id": "o6_16.general.min_farm_size",
	"parcel_id": null,
	"message": "Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr (1,50 ha bzw. 0,50 ha geschützter Anbau) nicht erreicht.",
} if {
	object.get(input, ["farm", "oepul", "first_oepul_participation_year"], null) == year
	not min_farm_size_met
}

# ---------------------------------------------------------------------------
# 5.4/5.5 Mindestbewirtschaftung auf Ackerflächen (AG ausgenommen), Dürre-Ausnahme 2026
# ---------------------------------------------------------------------------

harvest_share(p) := object.get(p, ["harvest", "harvested_share"], null)

violations contains {
	"rule_id": "o6_16.general.minimum_management_harvest",
	"parcel_id": p.parcel_id,
	"message": sprintf("Ernte und Verbringen des Erntegutes auf nur %v des Schlages (mindestens 85 %%); Code OP erforderlich.", [harvest_share(p)]),
} if {
	some p in basis_parcels
	not is_arable_forage(p)
	is_number(harvest_share(p))
	harvest_share(p) < general.mindestbewirtschaftung.arable_harvest_min_share
	not drought_harvest_relief_applies(p)
}

# ---------------------------------------------------------------------------
# 5.9/6 Vertragszeitraum mehrjähriger Maßnahmen, Abmeldung
# ---------------------------------------------------------------------------

is_multi_year_measure(m) if m in {x | some x in general.multi_year_measures_until_2028}

# Abmeldung: im Zeitraum 1.1.-31.12. -> Maßnahme im betroffenen Förderjahr nicht gültig
deregistration_effective_year(deregistration_date) := date_year(deregistration_date)

# Ausstieg aus mehrjährigen Maßnahmen vor Vertragsende -> Rückforderung
early_exit_repayment(exit_year) if exit_year <= params.contract_period.end_year

# ---------------------------------------------------------------------------
# 6.2 Maßnahmenwechsel (AG -> Naturschutz/EBW) bis 31.12.2025
# ---------------------------------------------------------------------------

conversion_allowed(from, to, application_date) if {
	some c in general.measure_conversions
	c.from == from
	to in {t | some t in c.to}
	date_le(application_date, general.measure_conversion_latest)
}

# ---------------------------------------------------------------------------
# 6.3 Maßnahmenübernahme
# ---------------------------------------------------------------------------

takeover_deadline(yr) := md_date(yr, general.takeover.deadline_month_day_2023_2028) if yr in {2023, 2028}

takeover_deadline(yr) := md_date(yr, general.takeover.deadline_month_day) if not yr in {2023, 2028}

takeover_individual_cases_only(component) if component in {x | some x in general.takeover_individual_cases_only}

takeover_extension_ok(taken_over_ha, extension_ha) if extension_ha <= general.takeover.max_extension_share * taken_over_ha

# ---------------------------------------------------------------------------
# 7.1 Flächenabgang – Toleranz
# ---------------------------------------------------------------------------

allowed_area_reduction(previous_ha) := max([
	min([general.area_reduction_tolerance.max_share * previous_ha, general.area_reduction_tolerance.max_ha]),
	general.area_reduction_tolerance.always_allowed_ha,
])

area_reduction_repayment_required(previous_ha, current_ha) if previous_ha - current_ha > allowed_area_reduction(previous_ha)

violations contains {
	"rule_id": "o6_16.general.area_reduction_tolerance",
	"parcel_id": null,
	"message": sprintf("Flächenverringerung von %v ha auf %v ha übersteigt die Toleranz; Rückzahlung für die gesamte Differenzfläche.", [prev, basis_parcels_ha]),
} if {
	prev := o16.premium_area_previous_year_ha
	is_number(prev)
	not object.get(o16, "area_reduction_due_to_loss_of_control", false) == true
	area_reduction_repayment_required(prev, basis_parcels_ha)
}

# ---------------------------------------------------------------------------
# 7.2 Flächenzugang – Prämienfähigkeit (ab 2026 max. +50 % auf Basis 2025, mind. +5 ha)
# ---------------------------------------------------------------------------

limited_increase_area(current_ha, _, yr) := current_ha if yr in {y | some y in general.area_increase.fully_eligible_years}

limited_increase_area(current_ha, _, yr) := current_ha if yr < general.area_increase.base_year

limited_increase_area(current_ha, base_2025_ha, yr) := min([current_ha, base_2025_ha + max([general.area_increase.max_share * base_2025_ha, general.area_increase.always_allowed_ha])]) if yr > general.area_increase.base_year

# ---------------------------------------------------------------------------
# 8.2 Sanktionsstufen
# ---------------------------------------------------------------------------

sanction_reduction_percent(stage, yr) := s.reduction_percent if {
	yr < 2027
	some s in general.sanction_stages
	s.stage == stage
}

sanction_reduction_percent(stage, yr) := s.reduction_percent_from_2027 if {
	yr >= 2027
	some s in general.sanction_stages
	s.stage == stage
}

# ---------------------------------------------------------------------------
# 9.1-9.3 Auszahlung, Obergrenzen, Modulation
# ---------------------------------------------------------------------------

payment_deadline(yr) := md_date(yr + 1, general.payment_deadline_month_day_next_year)

max_advance_payment(expected_eur) := expected_eur * general.advance_payment_max_share

payout_may_be_withheld(amount_eur) if amount_eur <= general.min_payout_eur

area_payment_cap(scope, yr) := c.eur_per_ha if {
	some c in general.area_payment_caps
	c.scope == scope
	c.year_from <= yr
	yr <= c.year_to
}

area_payment_cap_exceeded(sum_eur_per_ha, scope, yr) if sum_eur_per_ha > area_payment_cap(scope, yr)

band_portion(total_ha, band) := max([0, min([total_ha, band.to_ha]) - band.from_ha]) if is_number(band.to_ha)

band_portion(total_ha, band) := max([0, total_ha - band.from_ha]) if band.to_ha == null

modulation_factor(total_ha) := 1 if total_ha <= 0

modulation_factor(total_ha) := sum([x |
	some b in general.modulation_bands
	x := band_portion(total_ha, b) * b.payout_share
]) / total_ha if {
	total_ha > 0
}

# ---------------------------------------------------------------------------
# 5.7 Tierhaltender Betrieb (allgemeine Definition)
# ---------------------------------------------------------------------------

livestock_farm(rgve, forage_ha) if {
	forage_ha > 0
	rgve / forage_ha >= general.livestock_farm_min_rgve_per_ha_forage
}
