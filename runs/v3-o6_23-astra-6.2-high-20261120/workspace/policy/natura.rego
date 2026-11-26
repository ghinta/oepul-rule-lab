package oepul.o6_23

import data.natura_reference as ref
import rego.v1

year := input.farm.year
application := input.farm.oepul

# Alle Zeitangaben sind lokale Kalendertage im ISO-Format.
valid_date(d) if {
	is_string(d)
	count(d) == 10
	time.parse_rfc3339_ns(concat("", [d, "T00:00:00Z"]))
}

in_year(d, y) if {
	valid_date(d)
	startswith(d, sprintf("%04d-", [y]))
}

program_year if year in numbers.range(2023, 2028)
contract_period := {"from": sprintf("%d-01-01", [year]), "through": sprintf("%d-12-31", [year])} if program_year
withdrawn if in_year(application.withdrawal_date, year)
no_withdrawal if application.withdrawal_date == null

no_withdrawal if {
	valid_date(application.withdrawal_date)
	application.withdrawal_date > contract_period.through
}

timely_entry if {
	program_year
	year <= 2027
	valid_date(application.entry_application_date)
	application.entry_application_date <= sprintf("%d-12-31", [year - 1])
	application.mfa_submitted == true
}

transfer_ok if {
	program_year
	transfer := application.transfer
	transfer.ama_approved == true
	transfer.previously_participating == false
	transfer.online_mfa == true
	in_year(transfer.date, year)
	transfer.date <= transfer_deadline
	transfer.acquired_ha > 0
	transfer.extra_ha >= 0
	transfer.extra_ha <= transfer.acquired_ha / 2
}

transfer_deadline := sprintf("%d-04-17", [year]) if year in {2023, 2028}

else := sprintf("%d-04-15", [year])

application_route contains "entry" if {
	timely_entry
	no_withdrawal
}

application_route contains "renewal" if {
	program_year
	no_withdrawal
	application.previous_contract == true
	application.reentry_required == false
	application.mfa_submitted == true
}

application_route contains "transfer" if {
	transfer_ok
	no_withdrawal
}

size_ok if application.first_oepul_year == false

size_ok if {
	application.first_oepul_year == true
	is_number(application.protected_at_ha)
	application.protected_at_ha >= 0.5
}

size_ok if {
	application.first_oepul_year == true
	is_number(application.qualifying_at_ha)
	application.qualifying_at_ha >= 1.5
}

person_ok if application.legal_form in {"natural", "registered_partnership"}

person_ok if {
	application.legal_form in {"legal_entity", "association"}
	application.public_share_pct >= 0
	application.public_share_pct <= 25
}

operator_ok if {
	person_ok
	application.equivalent_public_control == false
	application.own_name_account == true
	application.active_farmer == true
	application.agricultural_activity == true
}

claimed(p) if "N2" in p.natura.mfa_codes

site_ok(p) if {
	p.land_use == "grassland"
	p.natura.grassland_type in {"meadow", "mown_pasture"}
	p.natura.zone in {"natura2000", "article10_high_nature_value"}
	p.natura.habitat == true
	p.natura.authority_confirmation == true
}

grass_management_ok(n) if {
	n.active_production == true
	n.full_cut_removed == true
}

grass_management_ok(n) if {
	n.active_production == true
	n.full_grazing == true
}

grass_management_ok(n) if {
	n.active_production == true
	n.mountain_meadow == true
	n.cut_removed_in_two_years == true
}

grass_management_ok(n) if n.management_exception in ref.management_exceptions

parcel_general_ok(p) if {
	n := p.natura
	n.country == "AT"
	n.correctly_identified == true
	n.disposal_right == true
	n.excluded_land == false
	n.trial_breach == false
	n.public_overlap == false
	n.infrastructure_offset == false
	n.year_obligation_kept == true
	n.n2_op == false
	is_array(n.mfa_codes)
	not "OP" in n.mfa_codes
	not "VF" in n.mfa_codes
	grass_management_ok(n)
}

# Ein geänderter Landestermin gilt ausschließlich 2026 und nur bei zutreffender Verordnung.
cut_limit(n, _) := n.ordinance_cut_date if {
	year == 2026
	n.ordinance_changed == true
	in_year(n.ordinance_cut_date, year)
}

cut_limit(n, term) := term.earliest_cut if {
	year == 2026
	n.ordinance_changed == false
	in_year(term.earliest_cut, year)
}

cut_limit(_, term) := term.earliest_cut if {
	year != 2026
	in_year(term.earliest_cut, year)
}

uses_match(r, uses) if {
	r.at_least == true
	is_number(uses)
	uses >= r.uses
}

uses_match(r, uses) if {
	r.at_least == false
	uses == r.uses
}

condition_ok(p, t) if {
	r := ref.rates[t.code]
	r.fertilizer_permitted == false
	p.natura.grassland_type == "meadow"
	p.natura.fertilizer_applied == false
	uses_match(r, p.natura.uses)
}

condition_ok(p, t) if {
	ref.rates[t.code].delay_days > 0
	limit := cut_limit(p.natura, t)
	cuts := p.operations.cutting_dates
	is_array(cuts)
	every d in cuts { in_year(d, year); d >= limit}
}

rate(code, y) := ref.rates[code].eur_ha_2023 if y == 2023
rate(code, y) := ref.rates[code].eur_ha_from_2024 if y in numbers.range(2024, 2028)

chapter(code) := "A" if startswith(code, "T")

else := substring(code, 0, 1)

chapter_conflicts(n) := {code | some code in n.nat_conditions; ref.chapters.G[chapter(code)] == "nein"}

single_condition(n) if {
	count({t.code | some t in n.conditions}) == 1
	is_array(n.nat_conditions)
	count(n.nat_conditions) == 0
}

combination_evidenced(n) if single_condition(n)
combination_evidenced(n) if n.code_combinations_confirmed == true

chapters_reviewed(n) if {
	is_array(n.nat_conditions)
	every c in n.nat_conditions { regex.match("^[A-Z]{2}[0-9]{2}$", c); chapter(c) in object.keys(ref.chapters)}
	count(chapter_conflicts(n)) == 0
	combination_evidenced(n)
}

project_ok(p) if {
	n := p.natura
	is_array(n.conditions)
	count(n.conditions) > 0
	every t in n.conditions { condition_ok(p, t) }
	n.further_terms_met == true
	chapters_reviewed(n)
}

managed(p) if {
	claimed(p)
	site_ok(p)
	project_ok(p)
	p.natura.year_obligation_kept == true
}

minimum_met if {
	some p in input.land.parcels
	managed(p)
}

# Nur feststehende Gegenbelege rechtfertigen einen negativen Mindestteilnahmebefund.
definitely_unmanaged(p) if {
	is_array(p.natura.mfa_codes)
	not claimed(p)
}

definitely_unmanaged(p) if p.natura.authority_confirmation == false
definitely_unmanaged(p) if p.natura.habitat == false
definitely_unmanaged(p) if p.natura.zone == "other"
definitely_unmanaged(p) if p.land_use != "grassland"
definitely_unmanaged(p) if p.natura.grassland_type in {"permanent_pasture", "rough_pasture", "other"}
definitely_unmanaged(p) if p.natura.year_obligation_kept == false
definitely_unmanaged(p) if p.natura.further_terms_met == false

definitely_unmanaged(p) if {
	some t in p.natura.conditions
	ref.rates[t.code].fertilizer_permitted == false
	p.natura.fertilizer_applied == true
}

definitely_unmanaged(p) if {
	some t in p.natura.conditions
	ref.rates[t.code].delay_days > 0
	d := cut_limit(p.natura, t)
	some c in p.operations.cutting_dates
	in_year(c, year)
	c < d
}

minimum_missed if {
	is_array(input.land.parcels)
	every p in input.land.parcels { definitely_unmanaged(p) }
}

minimum_status := "erfüllt" if minimum_met

else := "verfehlt" if minimum_missed

else := "offen"

measure_id(m) := "1B" if m == "1B-Teilbetrieb"

else := m

pair_allowed(_, a, b) if ref.area_combinations[a][b] == "x"

pair_allowed(n, a, b) if {
	ref.area_combinations[a][b] == "x1)"
	some m in n.lse_only_measures
	measure_id(m) in {a, b}
	measure_id(m) in {"1A", "1B"}
}

pairs_ok(n) if {
	is_array(n.other_area_measures)
	every m in n.other_area_measures { ref.area_combinations["23"][measure_id(m)] == "x" }
	ms := {measure_id(m) | some m in n.other_area_measures}
	every a in ms { every b in ms { pair_or_same(n, a, b) } }
}

pair_or_same(_, a, b) if a == b
pair_or_same(n, a, b) if pair_allowed(n, a, b)

gross_components(p) := {code: amount | some code in codes; amount := rate(code, year) * p.area_ha} if {
	program_year
	managed(p)
	is_number(p.area_ha)
	p.area_ha > 0
	codes := {t.code | some t in p.natura.conditions}
}

# Rechenbetrag vor Obergrenze, Modulation, Kontrollfeststellungen und Zahlungsentscheidung.
annual_gross_eur[p.parcel_id] := sum([amount | some _, amount in components]) if {
	some p in input.land.parcels
	count(application_route) > 0
	operator_ok
	size_ok
	parcel_general_ok(p)
	pairs_ok(p.natura)
	components := gross_components(p)
}

bio_participant if {
	some m in application.measures
	measure_id(m) in {"1A", "1B"}
}

div_credit_ha[p.parcel_id] := p.area_ha if {
	program_year
	some p in input.land.parcels
	p.natura.country == "AT"
	p.natura.correctly_identified == true
	is_number(p.area_ha)
	p.area_ha > 0
	bio_participant
	managed(p)
	"DIVSZ" in p.natura.mfa_codes
	some t in p.natura.conditions
	ref.rates[t.code].delay_days > 0
}

div_required_ha := input.land.mown_grassland_excl_mountain_ha * 0.07 if {
	bio_participant
	input.land.mown_grassland_excl_mountain_ha > 2
}

field_requirement[b.field_id] := 0.15 if {
	bio_participant
	input.land.mown_grassland_excl_mountain_ha >= 10
	some b in input.land.field_blocks
	b.mown_excl_mountain_ha > 5
}

cap_group(ms) := "18/19" if {
	some m in ms
	m in {"18", "19"}
}

else := "standard"

active_row(r, y) if {
	y >= r.from_year
	r.to_year == null
}

active_row(r, y) if {
	y >= r.from_year
	is_number(r.to_year)
	y <= r.to_year
}

cap_for(ms, y) := r.eur_ha if {
	some r in ref.caps
	r.group == cap_group(ms)
	active_row(r, y)
}

cap_basis(n, y) := sum([p.eur_ha | some p in n.payments; not p.measure in exclusions]) if {
	is_array(n.payments)
	every p in n.payments { is_string(p.measure); is_number(p.eur_ha); p.eur_ha >= 0}
	some r in ref.caps
	r.group == "standard"
	active_row(r, y)
	exclusions := r.excluded
}

upper(r, ha) := ha if r.upper == null

else := min([r.upper, ha])

modulation_factor(ha) := sum(parts) / ha if {
	ha > 0
	parts := [part | some r in ref.modulation; part := (max([0, upper(r, ha) - r.lower]) * r.percent) / 100]
}

home_factor := modulation_factor(input.land.home_area_ha)
payment_deadline := sprintf("%d-06-30", [year + 1]) if program_year

advance_limit := application.estimated_eur * 0.75 if {
	application.administration_checked == true
	application.estimated_eur >= 0
}

small_payment_discretion if {
	application.payment_eur >= 0
	application.payment_eur <= 50
}

sanction_consequence := {"exclude": true, "recover_term": true} if application.full_cuts_in_term >= ref.sanctions.exclusion.threshold_full_cuts

else := {"percent": ref.sanctions.warning.from_2027_pct} if {
	application.assessed_sanction == "warning"
	year >= 2027
}

else := {"percent": ref.sanctions.warning.through_2026_pct} if {
	application.assessed_sanction == "warning"
	year < 2027
}

else := {"percent": ref.sanctions[application.assessed_sanction].pct} if application.full_cuts_in_term < 2

crop_group(name, y) := r.group if {
	some r in ref.crops
	name == r.name
	y >= r.from_year
}

switch_listed(a, b, y) if {
	some r in ref.switches
	r.source == a
	r.target == b
	y >= 2023
	y <= r.through_year
}

arable_drought_region(state, district, y) if {
	y == 2026
	some d in ref.arable_drought_regions[state]
	d in {district, "alle Bezirke"}
}

reduction_order := ref.reduction_order
contract_reference := ref.contract_reference
div_variants := ref.div_variants
public_exceptions := ref.public_exceptions
management_exceptions := ref.management_exceptions
restricted_transfers := ref.restricted_transfers
restricted_additions := ref.restricted_additions
combination_notes := ref.combination_notes

definitely_unmanaged(p) if {
	some term in p.natura.conditions
	r := ref.rates[term.code]
	r.fertilizer_permitted == false
	is_number(p.natura.uses)
	not uses_match(r, p.natura.uses)
}

definitely_unmanaged(p) if count(chapter_conflicts(p.natura)) > 0

definitely_unmanaged(p) if {
	p.natura.code_combinations_confirmed == false
	not single_condition(p.natura)
}

definitely_unmanaged(p) if {
	p.natura.grassland_type == "mown_pasture"
	some t in p.natura.conditions
	ref.rates[t.code].fertilizer_permitted == false
}

definitely_unmanaged(p) if {
	is_array(p.natura.conditions)
	count(p.natura.conditions) == 0
}

# Regelbezogene, positiv feststellbare Befunde.
parcel_findings contains {"parcel_id": p.parcel_id, "rule_id": "N2.confirmation"} if {
	some p in input.land.parcels
	claimed(p)
	p.natura.authority_confirmation == false
}

parcel_findings contains {"parcel_id": p.parcel_id, "rule_id": "N2.nat_combo", "code": c} if {
	some p in input.land.parcels
	claimed(p)
	some c in chapter_conflicts(p.natura)
}

parcel_findings contains {"parcel_id": p.parcel_id, "rule_id": "N2.premium_combo", "measure": m} if {
	some p in input.land.parcels
	claimed(p)
	some m in p.natura.other_area_measures
	not ref.area_combinations["23"][measure_id(m)] == "x"
}

parcel_findings contains {"parcel_id": p.parcel_id, "rule_id": concat("", ["N2.", trim_prefix(t.code, "N2")]), "cut": d, "earliest": limit} if {
	some p in input.land.parcels
	claimed(p)
	some t in p.natura.conditions
	ref.rates[t.code].delay_days > 0
	limit := cut_limit(p.natura, t)
	some d in p.operations.cutting_dates
	in_year(d, year)
	d < limit
}

full_conditionality if application.conditionality_met == true

# Auf die Mindestverpflichtung angerechnete Fremdmaßnahmenfläche zählt für die
# Schwelle des Zuschlags für zusätzliche Biodiversitätsflächen mit null Hektar.
bonus_threshold_contribution[id] := 0 if div_credit_ha[id] > 0

arable_substitution_possible if {
	bio_participant
	input.land.arable_area_ha > 2
	input.land.arable_area_ha <= 10
}

capped_total_eur_ha(n, y) := min([cap_for(n.other_area_measures, y), cap_basis(n, y)])

units_for(group, category, heads) := {"unit": r.unit, "value": heads * r.per_head} if {
	is_number(heads)
	heads >= 0
	some r in ref.livestock_units
	r.group == group
	r.category == category
}

dwarf_breeds := ref.dwarf_breeds

# Status der Teilnahmevoraussetzungen. Die behördliche Genehmigung ist gesondert.
participation_status := "im Förderjahr abgemeldet" if withdrawn

else := "Mindestteilnahme verfehlt" if minimum_missed

else := "Teilnahmevoraussetzungen belegt" if {
	count(application_route) > 0
	operator_ok
	size_ok
	some p in input.land.parcels
	managed(p)
	parcel_general_ok(p)
}

else := "offen"

combination_correction_possible if {
	application.payout_notice_received == false
	application.control_objection == false
}

exit_window_open if {
	application.inspection_announced_or_started == false
	application.administrative_result_received == false
}

trial_record_complete(n) if {
	n.trial_breach == true
	n.trial_authorization_on_file == true
	n.trial_details_recorded == true
	"VF" in n.mfa_codes
}

op_required(n) if n.harvest_obligation_unfulfilled == true
op_required(n) if n.public_overlap == true
op_required(n) if n.infrastructure_offset == true
op_required(n) if n.year_obligation_kept == false

remedy_for(n) := "maßnahmenbezogener OP-Code und Belege" if {
	n.breach == true
	n.third_party_only == true
}

remedy_for(n) := "MFA-Code korrigieren oder Selbstanzeige" if {
	n.breach == true
	n.third_party_only == false
}
