package oepul.o6_9

import rego.v1

applicant_form_ok if input.farm.applicant.form in {"natural", "registered_partnership"}

applicant_form_ok if {
	a := input.farm.applicant
	a.form in {"legal_person", "association"}
	nonnegative(a.public_share_percent)
	a.public_share_percent <= 25
}

operator_ok if {
	applicant_form_ok
	a := input.farm.applicant
	a.own_name_and_account == true
	a.control_of_land == true
	a.active_farmer == true
	a.agricultural_activity == true
	a.public_body_or_institution == false
}

size_ok if {
	is_number(input.farm.oepul_participation_year)
	input.farm.oepul_participation_year >= 2
}

size_ok if {
	input.farm.oepul_participation_year == 1
	nonnegative(input.land.austrian_protected_cultivation_ha)
	input.land.austrian_protected_cultivation_ha >= 0.5
}

size_ok if {
	input.farm.oepul_participation_year == 1
	nonnegative(input.land.austrian_minimum_size_area_ha)
	input.land.austrian_minimum_size_area_ha >= 1.5
}

crop_groups(name) := {r.group | some r in tables.crop_names; r.name == name; year >= r.from_year}

drought_exception(p) if {
	year == 2026
	p.land_use == "arable"
	p.country == "AT"
	p.drought_no_harvestable_crop == true
	p.heat_drought_sensitive == true
	p.normal_harvest in {"late_summer", "autumn"}
	some row in tables.drought_districts
	row.state == p.federal_state
	district_match(row.district, p)
}

district_match("alle Bezirke", _) := true
district_match(d, p) if d == p.district

harvest_met(p) if {
	nonnegative(p.harvested_removed_percent)
	p.harvested_removed_percent >= 85
	p.harvested_removed_percent <= 100
}

harvest_met(p) if drought_exception(p)

arable_care_ok(p) if {
	arable_or_protected(p)
	p.properly_sown == true
	p.annual_care == true
	harvest_met(p)
}

arable_or_protected(p) if {
	p.land_use == "arable"
	p.arable_forage == false
}

arable_or_protected(p) if p.protected_cultivation == true

modulation_factor := sum([portion |
	some row in tables.modulation
	hi := band_end(row, input.land.home_area_ha)
	width := max([0, hi - row.start])
	portion := width * row.factor
]) / input.land.home_area_ha if {
	input.land.home_area_ha > 0
}

band_end(row, ha) := ha if row.end == null

else := min([row.end, ha])

area_ceiling(group) := row.eur_per_ha if {
	some row in tables.area_caps
	row.group == group
	year >= row.from_year
	year <= row.through_year
}

sanction_schedule := {r.stage: v | some r in tables.sanctions; v := stage_value(r)}
stage_value(r) := r.from_2027 if year >= 2027

else := r.through_2026 if year >= 2023

loss_tolerance_ha(prior) := max([0.5, min([5, 0.05 * prior])]) if nonnegative(prior)

takeover_case if {
	t := annual.takeover
	t.event in {"dissolution", "division", "merger"}
	t.approved_by_ama == true
	t.online_application == true
}

upgrade_allowed(source, target) if {
	some r in tables.upgrades
	r.source == source
	r.target == target
	program_year
	year <= r.through_year
}

contract_group(name) := tables.contract_groups[name]
reduction_order := tables.reduction_order

combination_cell(a, b) := tables.combinations[a][b]
combination_note(n) := tables.combination_notes[n]

# Kontext zur Einzelfläche. Ein Minderungsbetrag ist in Anhang L nicht beziffert.
parcel_combination_ok(a, b, ctx) if {
	cell := combination_cell(a, b)
	cell != ""
	ctx.protected_pots_or_substrate == false
	landscape_condition(cell, ctx)
	vienna_ok({a, b}, ctx)
	pesticide_ok({a, b}, ctx)
	special_strip_ok({a, b}, ctx)
}

landscape_condition(cell, _) if cell != "x1)"
landscape_condition("x1)", ctx) if ctx.landscape_elements_only == true

vienna_ok(pair, _) if pair != {"8", "16"}

vienna_ok(pair, ctx) if {
	pair == {"8", "16"}
	ctx.vienna_humus == false
}

pesticide_ok(pair, _) if pair != {"1B", "16"}

pesticide_ok(pair, ctx) if {
	pair == {"1B", "16"}
	ctx.pesticide_waiver == false
}

special_strip_ok(_, ctx) if ctx.strip in {"none", "other"}

special_strip_ok(pair, ctx) if {
	ctx.strip == "BAW"
	ctx.landscape_elements_only == true
	"8" in pair
	count(pair & {"1A", "1B"}) == 1
}

special_strip_ok(pair, ctx) if {
	ctx.strip == "AG"
	ctx.landscape_elements_only == true
	"16" in pair
	count(pair & {"1A", "1B"}) == 1
}

combination_discount(a, b, ctx) if {
	parcel_combination_ok(a, b, ctx)
	combination_cell(a, b) == "a"
}

combination_discount(a, b, ctx) if {
	parcel_combination_ok(a, b, ctx)
	combination_cell(a, b) == "x3)"
	ctx.organism_supplement == true
}

grass_care_ok(p) if {
	p.mountain_hay_meadow == true
	p.full_cut_removed_within_two_years == true
}

grass_care_ok(p) if {
	p.mountain_hay_meadow == false
	grass_or_forage(p)
	p.full_cut_removed_this_year == true
}

grass_care_ok(p) if {
	p.mountain_hay_meadow == false
	grass_or_forage(p)
	p.fully_grazed_this_year == true
}

grass_or_forage(p) if p.land_use == "grassland"

grass_or_forage(p) if {
	p.land_use == "arable"
	p.arable_forage == true
}

conditionality_met if {
	input.farm.administration.conditionality_compliant == true
	input.farm.administration.social_conditionality_compliant == true
}

# Positive Feststellungen, auch wenn die übrigen Angaben unvollständig sind.
area_exclusions contains {"parcel_id": p.parcel_id, "reason": reason} if {
	some p in input.land.parcels
	some reason in parcel_reasons(p)
}

parcel_reasons(p) := {reason | some reason in ["Ausland", "MFA-Fläche fehlt", "Fehlidentifikation", "Nutzung", "Hauptnutzung", "Nationalpark", "Versuchsfläche", "OP", "Leistungsüberschneidung", "Infrastrukturauflage", "Verpflichtungsdauer"]; excluded_for(p, reason)}

excluded_for(p, "Ausland") if {
	is_string(p.country)
	p.country != "AT"
}

excluded_for(p, "MFA-Fläche fehlt") if p.payment_controls.claimed_for_measure == false
excluded_for(p, "Fehlidentifikation") if p.payment_controls.correctly_identified == false
excluded_for(p, "Nutzung") if p.payment_controls.use_code in tables.ineligible_uses
excluded_for(p, "Hauptnutzung") if p.payment_controls.primarily_agricultural == false
excluded_for(p, "Nationalpark") if p.payment_controls.national_park in {"Neusiedlersee", "Donau-Auen"}

excluded_for(p, "Nationalpark") if {
	is_string(p.payment_controls.national_park)
	p.payment_controls.national_park != ""
	p.payment_controls.national_park_relevant_obligations == true
}

excluded_for(p, "Versuchsfläche") if "VF" in p.payment_controls.mfa_codes

excluded_for(p, "OP") if {
	some code in p.payment_controls.mfa_codes
	code in {"OP", annual.measure_op_code}
	code != ""
}

excluded_for(p, "OP") if "OP" in p.payment_controls.mfa_codes
excluded_for(p, "Leistungsüberschneidung") if p.payment_controls.overlap_public_or_legal == true
excluded_for(p, "Infrastrukturauflage") if p.payment_controls.prescribed_infrastructure_use == true
excluded_for(p, "Verpflichtungsdauer") if p.payment_controls.full_period_compliance == false

takeover_area_ok if {
	takeover_case
	t := annual.takeover
	t.previous_participant == false
	in_year(t.date)
	t.date <= sprintf("%04d-04-%02d", [year, april_day])
	nonnegative(t.additional_ha)
	nonnegative(t.transferred_ha)
	t.additional_ha <= 0.5 * t.transferred_ha
}

payment_deadline := sprintf("%04d-06-30", [year + 1]) if program_year

advance_max_eur(expected) := expected * 0.75 if {
	nonnegative(expected)
	input.farm.administration.administrative_checks_complete == true
}

sanction_outcome := "Ausschluss und Rückforderung" if {
	input.farm.administration.graded_stage == "100"
	nonnegative(input.farm.administration.prior_full_reductions_in_contract)
	input.farm.administration.prior_full_reductions_in_contract >= 1
} else := sanction_schedule[input.farm.administration.graded_stage] if {
	input.farm.administration.graded_stage != "100"
} else := 100 if {
	input.farm.administration.graded_stage == "100"
	input.farm.administration.prior_full_reductions_in_contract == 0
}

management_exception(feature, measure) if {
	some row in tables.management_exceptions
	feature == row.feature
	measure in row.measures
	year <= object.get(row, "through_year", 2028)
	program_year
}

public_body_exception(measure) if {
	some row in tables.public_body_exceptions
	row.measure == measure
	year >= row.from_year
	year <= row.through_year
}

conversion_allowed(source, target, measure) if {
	some row in tables.permitted_conversions
	source in row.from
	target in row.to
	measure in object.get(row, "measures", [measure])
}

multiannual_term(first_year) := row.years if {
	some row in tables.long_terms
	row.start_year == first_year
}
