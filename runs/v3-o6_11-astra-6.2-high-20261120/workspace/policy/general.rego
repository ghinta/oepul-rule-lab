package oepul.o6_11

import data.o6_11_tables as t
import rego.v1

public_share_ok(a) if a.form in {"natural", "registered_partnership"}

public_share_ok(a) if {
	a.form in {"legal", "association"}
	is_number(a.public_share_pct)
	a.public_share_pct >= 0
	a.public_share_pct <= 25
}

applicant_ok if {
	a := input.farm.applicant
	public_share_ok(a)
	a.public_entity_or_controlled == false
	every key in ["own_name", "own_account", "controls_land", "active_farmer", "agricultural_activity"] { a[key] == true }
}

farm_size_ok if input.farm.year > input.farm.opul.first_year

farm_size_ok if {
	input.farm.year == input.farm.opul.first_year
	input.farm.opul.protected_at_ha >= 0.5
	is_number(input.farm.opul.protected_at_ha)
}

farm_size_ok if {
	input.farm.year == input.farm.opul.first_year
	input.farm.opul.qualifying_at_ha >= 1.5
	is_number(input.farm.opul.qualifying_at_ha)
}

cultivation_ok(p) if {
	every key in ["properly_planted", "annual_care", "harvested", "harvest_removed"] { p.operations[key] == true }
}

nationalpark_excluded(p) if p.mfa.national_park in {"Neusiedlersee", "Donau-Auen"}

nationalpark_excluded(p) if {
	p.mfa.national_park != "none"
	p.mfa.park_relevant_conditions == true
}

parcel_exclusions[p.parcel_id] contains "Ausland" if {
	some p in input.land.parcels
	is_string(p.mfa.country)
	p.mfa.country != "AT"
}

parcel_exclusions[p.parcel_id] contains "Nationalpark" if {
	some p in input.land.parcels
	nationalpark_excluded(p)
}

parcel_exclusions[p.parcel_id] contains "nicht für 11 beantragt" if {
	some p in input.land.parcels
	p.mfa.claimed_11 == false
}

parcel_exclusions[p.parcel_id] contains "Flächenidentifikation" if {
	some p in input.land.parcels
	p.mfa.correctly_identified == false
}

parcel_exclusions[p.parcel_id] contains "GLÖZ-Landschaftselement" if {
	some p in input.land.parcels
	p.mfa.gaec_feature == true
}

parcel_exclusions[p.parcel_id] contains "nicht hauptsächlich landwirtschaftlich" if {
	some p in input.land.parcels
	p.mfa.mainly_agricultural == false
}

parcel_exclusions[p.parcel_id] contains "fehlende aktive Produktion" if {
	some p in input.land.parcels
	p.mfa.active_production == false
}

parcel_exclusions[p.parcel_id] contains "nicht prämienfähige Nutzung" if {
	some p in input.land.parcels
	excluded_use(p)
}

parcel_exclusions[p.parcel_id] contains "ausgeschlossene Kultur" if {
	some p in input.land.parcels
	lower(p.mfa.use) in {"energieholz", "niederwald mit kurzumtrieb", "palmkätzchenproduktion", "rebschule", "rebschulen", "baumschule", "baumschulen", "sonstige ackerflächen", "sonstige grünlandflächen", "sonstige hutweideflächen", "sonstige flächen im geschützten anbau"}
}

parcel_exclusions[p.parcel_id] contains "OP" if {
	some p in input.land.parcels
	"OP" in p.mfa.codes
}

parcel_exclusions[p.parcel_id] contains "maßnahmenbezogenes OP" if {
	some p in input.land.parcels
	p.mfa.op_for_11 == true
}

parcel_exclusions[p.parcel_id] contains "Versuchsfläche" if {
	some p in input.land.parcels
	"VF" in p.mfa.codes
}

parcel_exclusions[p.parcel_id] contains "Versuchsfläche" if {
	some p in input.land.parcels
	p.mfa.approved_trial_prevents_compliance == true
}

takeover_deadline(y) := sprintf("%d-04-17", [y]) if y in {2023, 2028}

else := sprintf("%d-04-15", [y])

takeover_ok if {
	a := input.farm.o6_11.takeover
	y := input.farm.year
	y >= 2023
	y <= 2028
	valid_date(a.filed)
	a.filed >= sprintf("%d-01-01", [y])
	a.filed <= takeover_deadline(y)
	a.previously_participating == false
	a.submitted_online == true
	a.ama_approved == true
	takeover_expansion_ok(a.transferred_ha, a.extra_ha)
}

loss_tolerance(previous) := max([0.5, min([5, 0.05 * previous])]) if {
	previous >= 0
	is_number(previous)
}

band_end(row, area) := area if row.upper == null

else := min([area, row.upper])

modulation_factor(area) := weighted / area if {
	is_number(area)
	area > 0
	weighted := sum([part | some row in t.modulation; part := max([0, band_end(row, area) - row.lower]) * row.factor])
}

cap_schedule(group, y) := row if {
	some row in t.caps
	row.group == group
	row.year_from <= y
	y <= row.year_to
}

sanction(stage, y, prior_full) := {"percent": row.pct, "exclusion_and_recovery": repeat} if {
	some row in t.sanctions
	row.stage == stage
	row.from_year <= y
	y <= row.through_year
	repeat := repeat_full_cut(stage, prior_full)
}

repeat_full_cut("100", n) if n >= 1

else := false

repeat_full_cut(stage, _) if stage == "second_100"
repeat_full_cut(stage, _) := false if not stage in {"100", "second_100"}

crop_list(group, name) if name in t.crop_lists[group]

gve_factor(category, group) := row if {
	some row in t.gve
	row.category == category
	row.group == group
}

# Matrix values refer to premium combinations on the same parcel only.
combination(left, right) := {"mark": mark, "left": t.measure_names[left], "right": t.measure_names[right], "notes": notes} if {
	mark := t.combination_matrix[left][right]
	nums := ({n | some n in object.keys(t.combination_notes); contains(mark, concat("", [n, ")"]))} | {n | some n in {"2"}; "13" in [left, right]}) | {n | some n in {"4"}; some m in [left, right]; m in {"8", "16"}}
	notes := {n: t.combination_notes[n] | some n in nums}
}

district_in_scope(state, district) if district in t.drought_districts[state]
district_in_scope(state, _) if "alle Bezirke" in t.drought_districts[state]

drought_harvest_relief(p, y) if {
	y == 2026
	p.land_use == "arable"
	p.mfa.country == "AT"
	district_in_scope(p.mfa.federal_state, p.mfa.district)
	p.operations.drought.late_summer_or_autumn_harvest == true
	p.operations.drought.sensitive_crop == true
	p.operations.drought.no_harvestable_stand == true
}

# Program reference tables also support mixed holdings and companion measures.
annual_contract(name) if name in t.annual_measures
multiannual_contract(name) if name in t.multiannual_measures
annual_available_units(name) if name in t.annual_units
restricted_access(name) if name in t.limited_access
special_takeover(name) if name in t.exceptional_takeovers
management_exception(entry) if entry in t.management_exceptions
public_exception_entry(entry) if entry in t.public_applicant_exceptions
reduction_step(n) := t.reduction_order[n - 1] if n >= 1
div_variant(code) := t.div_variants[code]
dwarf_breed(breed) if breed in t.gve_notes.Zwergrinder

annual_loss_review(previous, loss) := {"limit_ha": limit, "recoverable_area_ha": area} if {
	limit := loss_tolerance(previous)
	is_number(loss)
	loss >= 0
	loss <= previous
	area := repayment_difference(loss, limit)
}

repayment_difference(loss, limit) := loss if loss > limit

else := 0

# Scope is the cap on the sum, before allocating any reduction to measures.
capped_parcel_sum(group, y, payments) := sum(exempt) + min([sum(included), row.eur_ha]) if {
	row := cap_schedule(group, y)
	is_array(payments)
	every p in payments { is_string(p.measure); is_number(p.eur_ha); p.eur_ha >= 0}
	exempt := [p.eur_ha | some p in payments; p.measure in row.omitted_measures]
	included := [p.eur_ha | some p in payments; not p.measure in row.omitted_measures]
}

payment_due(year) := sprintf("%d-06-30", [year + 1]) if {
	year >= 2023
	year <= 2028
}

maximum_advance(expected, checks_complete) := expected * 0.75 if {
	checks_complete == true
	is_number(expected)
	expected >= 0
}

small_payment_discretion(amount) if {
	is_number(amount)
	amount >= 0
	amount <= 50
}

legal_basis(citation) if {
	some row in t.legal_bases
	row.citation == citation
}

partial_farm_requirements if {
	input.farm.o6_11.bio_participation == "partial_arable_grassland"
	b := input.farm.bio_partial
	every requirement in ["independent_facilities", "independent_land", "separate_crop_groups", "separate_psm_storage", "separate_fertilizer_storage", "separate_seed_storage", "option_applied"] {
		b[requirement] == true
	}
}

trial_documentation_findings contains {"parcel_id": p.parcel_id, "missing": key} if {
	some p in input.land.parcels
	p.mfa.approved_trial_prevents_compliance == true
	some key in ["approved_document_available", "type_documented", "area_documented", "location_documented"]
	p.commitment_change[key] == false
}

trial_documentation_findings contains {"parcel_id": p.parcel_id, "missing": "VF"} if {
	some p in input.land.parcels
	p.mfa.approved_trial_prevents_compliance == true
	is_array(p.mfa.codes)
	not "VF" in p.mfa.codes
}

# Trigger only the relevant MFA marking. A general OP code and another
# measure's specific OP code have different consequences.
required_op_markings[p.parcel_id] contains "OP oder maßnahmenbezogenes OP" if {
	active
	some p in input.land.parcels
	scope(p, input.farm.year)
	p.commitment_change.overlapping_public_obligation == true
}

required_op_markings[p.parcel_id] contains "OP für Maßnahme 11" if {
	active
	some p in input.land.parcels
	scope(p, input.farm.year)
	p.commitment_change.reason == "third_party_fault"
}

required_op_markings[p.parcel_id] contains "OP oder maßnahmenbezogenes OP" if {
	active
	some p in input.land.parcels
	scope(p, input.farm.year)
	p.commitment_change.reason == "transfer_of_control"
	p.commitment_change.successor_continues_same_or_higher == false
}

required_op_markings[p.parcel_id] contains "OP" if {
	active
	some p in input.land.parcels
	crop_group(p, input.farm.year) == "orchard"
	p.mfa.country == "AT"
	p.crop.ungrafted_tree == true
}

takeover_expansion_ok(assumed, extra) := ok if {
	is_number(assumed)
	assumed > 0
	is_number(extra)
	extra >= 0
	ok := extra <= (assumed / 2)
}

conditionality_for_full_payment if {
	input.farm.opul_procedure.conditionality_met == true
	input.farm.opul_procedure.social_conditionality_met == true
}

combination_correction_open if {
	p := input.farm.opul_procedure
	p.payment_notice_received == false
	p.inspection_objection == false
}

ordinary_exit_window_open if {
	p := input.farm.opul_procedure
	p.inspection_announced_or_started == false
	p.admin_result_received == false
}

# Conditions for the four footnotes are explicit. Callers supply a complete
# list of the options present on this parcel (empty when none).
combination_terms(left, right, options) := terms if {
	left != right
	row := combination(left, right)
	is_array(options)
	pair := {left, right}
	terms := matrix_terms(pair, row.mark, options)
}

matrix_terms(pair, mark, options) := {"compatible": false, "basis": "Topf-/Substratkultur"} if {
	"13_pot_substrate" in options
} else := {"compatible": false, "basis": "Humusaufbau Wien / 8"} if {
	"16_vienna" in options
	"8" in pair
}

else := {"compatible": false, "basis": "PSM-Verzicht / BIO"} if {
	"16_psm_waiver" in options
	"1B" in pair
} else := {"compatible": false, "basis": "keine Kombination ausgewiesen"} if {
	mark == ""
} else := {"compatible": true, "basis": "nur Landschaftselemente"} if {
	mark == "x 1)"
} else := {"compatible": true, "basis": "nur Landschaftselemente"} if {
	some code in {"1A", "1B"}
	code in pair
	some opt in {"8_BAW", "16_AG"}
	opt in options
} else := {"compatible": true, "basis": "Abschlag auf den optionalen Zuschlag", "supplement_factor": 0.5} if {
	mark == "x 3)"
	"10_organisms" in options
} else := {"compatible": true, "basis": "Prämienabschlag"} if {
	mark == "a"
} else := {"compatible": true, "basis": "auf der Einzelfläche kombinierbar"}

requires_measure_application(option_entry) if option_entry in t.application_options
