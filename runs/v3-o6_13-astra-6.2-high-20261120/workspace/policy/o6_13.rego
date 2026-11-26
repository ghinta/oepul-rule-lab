package oepul.o6_13

import rego.v1

tables := data.oepul13_tables
year := input.farm.year
application := input.farm.oepul13

contract_year if {
	year >= 2023
	year <= 2028
}

valid_date(s) if {
	regex.match(`^\d{4}-\d{2}-\d{2}$`, s)
	time.parse_rfc3339_ns(concat("", [s, "T00:00:00Z"]))
}

in_year(s, y) if {
	valid_date(s)
	startswith(s, sprintf("%d-", [y]))
}

timely_entry if {
	contract_year
	year <= 2027
	application.measure_request_date >= "2022-11-02"
	in_year(application.measure_request_date, year - 1)
}

withdrawn if in_year(application.withdrawal_date, year)

takeover_basis if {
	contract_year
	t := application.takeover
	t.previously_not_participating
	t.online_mfa_approved
	t.source_contract_active
	in_year(t.date, year)
	t.date <= sprintf("%d-04-%02d", [year, takeover_day(year)])
	t.transferred_ha > 0
	t.additional_ha >= 0
	t.additional_ha <= t.transferred_ha * 0.5
}

takeover_day(y) := 17 if y in {2023, 2028}

else := 15

contract_basis if timely_entry

contract_basis if {
	contract_year
	application.previous_contract_continuable
}

contract_basis if takeover_basis

# Eine fehlende Datumsangabe ist kein belegter Verzicht auf die Abmeldung.
no_current_withdrawal if application.withdrawal_date == null

no_current_withdrawal if {
	valid_date(application.withdrawal_date)
	not withdrawn
}

producer_ok if application.producer_org_member == false

producer_ok if {
	application.producer_org_member
	application.org_program_compensates_organisms == false
}

applicant_ok if application.legal_form == "natural"

applicant_ok if {
	application.legal_form in tables.legal_forms
	application.legal_form != "natural"
	application.public_control == false
	application.public_share_pct >= 0
	application.public_share_pct <= 25
}

operator_ok if {
	application.own_name
	application.own_account
	application.active_farmer
	application.agricultural_activity
}

size_ok if {
	is_number(application.first_oepul_year)
	application.first_oepul_year >= 2023
	application.first_oepul_year < year
}

size_ok if {
	application.first_oepul_year == year
	protected_size_ha >= 0.5
}

size_ok if {
	application.first_oepul_year == year
	qualifying_size_ha >= 1.5
}

structure_ok(p) if p.protected.structure in tables.structures
expected_use(p) := tables.media[medium] if {
	medium := p.protected.medium_april_1
}

use_ok(p) if p.protected.mfa_use == expected_use(p)
nue(p) if "NUE" in p.protected.codes

# Die fünf Abzugsflächen sind disjunkt. Bei den Gängen wird nur der Überschuss abgezogen.
net_area(p) := ha if {
	s := p.protected.surface
	amounts := [s.sales_ha, s.display_ha, s.storage_ha, s.unused_between_ha, s.aisles_ha, s.necessary_aisles_ha]
	every a in amounts { is_number(a); a >= 0}
	s.necessary_aisles_ha <= s.aisles_ha
	excluded := sum(array.slice(amounts, 0, 5))
	excluded <= p.area_ha
	ha := (p.area_ha - excluded) + s.necessary_aisles_ha
}

# Spannen gelten für den konkreten Registereintrag und die jeweilige Anwendung.
dose_ok(e) if {
	d := e.register_dose
	nonblank(d.unit)
	is_number(d.actual)
	is_number(d.minimum)
	is_number(d.maximum)
	d.minimum >= 0
	d.actual > 0
	d.actual >= d.minimum
	d.actual <= d.maximum
}

dose_ok(e) if {
	object.get(e, "register_dose", null) == null
	e.register_rate_compliant
}

creditable(e) if {
	e.register_listed
	dose_ok(e)
	e.replaces_pesticide
	e.pollination_only == false
}

treatment_ok(p) if {
	structure_ok(p)
	p.protected.full_area_creditable_treatment
	some e in p.protected.uses
	creditable(e)
}

nonblank(s) if {
	is_string(s)
	trim_space(s) != ""
}

purchase_proof(e) if e.purchased == false

purchase_proof(e) if {
	e.purchased
	nonblank(e.receipt)
}

recorded(e) if {
	nonblank(e.organism)
	is_number(e.quantity)
	e.quantity > 0
	nonblank(e.unit)
	nonblank(e.reason)
	nonblank(e.objective)
	in_year(e.date, year)
	purchase_proof(e)
}

records_ok(p) if {
	nonblank(p.parcel_id)
	is_array(p.protected.uses)
	some e in p.protected.uses
	creditable(e)
	every u in p.protected.uses { recorded(u) }
}

# Der Normalfall hat eine Bewirtschaftungseinheit pro geschütztem Schlag.
# Gibt es eine explizite Einheitenliste, ist sie für das Jahresminimum maßgebend.
annual_minimum if {
	object.get(input.land, "protected_units", null) == null
	some p in input.land.parcels
	treatment_ok(p)
	records_ok(p)
	use_ok(p)
	net_area(p) > 0
}

annual_minimum if {
	some unit in input.land.protected_units
	nonblank(unit.unit_id)
	unit.structure in tables.structures
	count(unit.parts) > 0
	every part in unit.parts { unit_part_ok(part) }
}

unit_part_ok(part) if {
	part.full_area_creditable_treatment
	some p in input.land.parcels
	p.parcel_id == part.parcel_id
	use_ok(p)
	count(part.credited_events) > 0
	every id in part.credited_events { unit_event_ok(p, id) }
}

unit_event_ok(p, id) if {
	nonblank(id)
	some e in p.protected.uses
	e.event_id == id
	creditable(e)
	recorded(e)
}

lapse_reason contains "kein NUE im Jahres-MFA" if {
	application.mfa_complete
	is_array(input.land.parcels)
	every p in input.land.parcels { is_array(p.protected.codes); not nue(p)}
}

lapse_reason contains "kein Nützlingseinsatz" if application.any_beneficial_use == false

matrix_cell(a, b) := tables.combinations[a][b]

combination_ok(p) if {
	is_array(p.protected.other_premiums)
	count(p.protected.other_premiums) == 0
}

park_ok(p) if {
	nonblank(p.protected.national_park)
	not p.protected.national_park in tables.park_exclusions_13
	p.protected.park_restrictions == false
}

general_land_ok(p) if {
	q := p.protected
	q.country == "AT"
	q.active_production
	q.mainly_agricultural
	q.at_disposal
	q.correct_reference
	q.excluded_use == "none"
	q.public_overlap == false
	q.compulsory_offset == false
	q.trial_prevents_compliance == false
	q.year_obligations_continued
	q.measure_op == false
	is_array(q.codes)
	not "OP" in q.codes
	not "VF" in q.codes
	park_ok(p)
}

cultivation_ok(p) if {
	p.protected.proper_planting
	p.protected.annual_care
}

drought_zone(q) if {
	some zone in tables.drought_districts
	zone.state == q.state
	district_matches(zone.district, object.get(q, "district", null))
}

drought_relief(p) if {
	year == 2026
	q := p.protected
	q.country == "AT"
	q.mfa_use == "A"
	q.drought_no_harvestable_crop
	q.usual_late_summer_autumn_harvest
	q.heat_drought_sensitive
	drought_zone(q)
}

district_matches(allowed, actual) if allowed == actual
district_matches(allowed, _) if allowed == "*"

harvest_ok(p) if {
	p.protected.harvested_removed_pct >= 85
	p.protected.harvested_removed_pct <= 100
}

harvest_ok(p) if drought_relief(p)
harvest_ok(p) if p.protected.harvest_exception_recognised

rate(use, y) := row.eur_ha if {
	some row in tables.rates
	row.use == use
	row.start <= y
	y <= row.end
}

cap(y) := row.eur_ha if {
	some row in tables.caps
	row.group == "13"
	row.start <= y
	y <= row.end
}

band_area(ha, row) := max([0, min([ha, row.upper]) - row.lower]) if is_number(row.upper)

else := max([0, ha - row.lower])

modulation(ha) := sum(weighted) / ha if {
	ha > 0
	weighted := [value | some b in tables.modulation; value := band_area(ha, b) * b.factor]
}

# Richtwert unter den geprüften Voraussetzungen vor individuellen Kürzungen und Bescheid.
standard_premium_eur[p.parcel_id] := amount if {
	contract_year
	contract_basis
	no_current_withdrawal
	application.mfa_complete
	count(lapse_reason) == 0
	size_ok
	producer_ok
	applicant_ok
	operator_ok
	annual_minimum
	some p in input.land.parcels
	nue(p)
	use_ok(p)
	treatment_ok(p)
	records_ok(p)
	general_land_ok(p)
	cultivation_ok(p)
	harvest_ok(p)
	combination_ok(p)
	area := net_area(p)
	area > 0
	amount := (area * min([rate(p.protected.mfa_use, year), cap(year)])) * modulation(application.home_mfa_ha)
}

crop_groups(name, y) := {row.group | some row in tables.crops; row.name == name; row.start <= y}
growth_limited(measure) if measure in tables.limited_growth
payment_deadline(y) := sprintf("%d-06-30", [y + 1])

advance_limit(forecast) := forecast * 0.75 if {
	application.administrative_checks_complete
	forecast >= 0
}

sanction(y, stage, full_cuts) := {"action": "exclude_and_recover"} if {
	stage == "100"
	y >= 2023
	y <= 2028
	is_number(full_cuts)
	full_cuts >= 2
}

else := row.result if {
	some row in tables.sanctions
	row.stage == stage
	stage != "second_100"
	row.start <= y
	y <= row.end
}

area_exception(use, measure, y) if {
	some e in tables.area_exceptions
	e.use == use
	measure in e.measures
	e.start <= y
	y <= e.end
}

switch_allowed(a, b, y) if {
	some r in tables.switches
	r.source == a
	b in r.targets
	y <= r.end
}

contract_schedule(start) := tables.contracts[sprintf("%d", [start])]
special_takeover(measure) if tables.special_takeovers[measure]
cut_order := tables.cut_order
div_variant(code) := tables.div_variants[code]

livestock_factor(group, category) := row.factor if {
	some row in tables.livestock_factors
	row.group == group
	row.category == category
}

combination_footnote(n) := tables.combination_notes[n]

combination_conflicts(p) := {other |
	some other in p.protected.other_premiums
	matrix_cell("13", other) == ""
}

measure_class(measure) := {class |
	some class, measures in tables.contract_classes
	measure in measures
}

dwarf_breed(name) if name in tables.gve_notes.dwarf_breeds

# Eine tatsächliche Anerkennung im Einzelfall kann die AMA erteilen.
harvest_procedure(p) := "automatisch anerkannt" if drought_relief(p)

else := "einzelbetrieblich anerkannt" if p.protected.harvest_exception_recognised

else := "schlagbezogenes Ansuchen mit Nachweisen" if {
	p.protected.harvest_prevented_by_extraordinary_event
	p.protected.harvest_exception_recognised == false
}

exit_window_open if {
	application.inspection_announced_or_started == false
	application.admin_result_communicated == false
}

full_conditionality if {
	application.conditionality_met
	application.social_conditionality_met
}

general_cap(group, y) := row if {
	some row in tables.caps
	row.group == group
	row.start <= y
	y <= row.end
}

public_exception(m, y) if {
	some row in tables.public_exceptions
	row.measure == m
	row.start <= y
	y <= row.end
}

# Nur bekannte Sachverhalte als Ausschlussgründe ausgeben.
drought_inapplicable(_) if year != 2026
drought_inapplicable(p) if p.protected.mfa_use == "GA"
drought_inapplicable(p) if p.protected.drought_no_harvestable_crop == false
drought_inapplicable(p) if p.protected.usual_late_summer_autumn_harvest == false
drought_inapplicable(p) if p.protected.heat_drought_sensitive == false

drought_inapplicable(p) if {
	nonblank(p.protected.state)
	nonblank(p.protected.district)
	not drought_zone(p.protected)
}

op_trigger(p, "Erntepflicht verfehlt") if {
	p.protected.harvested_removed_pct >= 0
	p.protected.harvested_removed_pct < 85
	p.protected.harvest_exception_recognised == false
	drought_inapplicable(p)
}

op_trigger(p, "öffentliche Leistungsüberschneidung") if p.protected.public_overlap
op_trigger(p, "behördlicher Ausgleich oder Infrastrukturnutzung") if p.protected.compulsory_offset
op_trigger(p, "keine durchgehende Erfüllung") if p.protected.year_obligations_continued == false

op_reasons(p) := {reason |
	some reason in ["Erntepflicht verfehlt", "öffentliche Leistungsüberschneidung", "behördlicher Ausgleich oder Infrastrukturnutzung", "keine durchgehende Erfüllung"]
	op_trigger(p, reason)
}

breach_action(p) := {"code": "maßnahmenbezogener OP", "nachweis": "am Betrieb aufbewahren und bei Kontrolle vorlegen", "schaden": "bilateral klären"} if {
	p.protected.breach_cause == "third_party_only"
}

else := {"wahl": ["betroffenen Code im MFA löschen", "Selbstanzeige an die AMA"]} if {
	p.protected.breach_cause == "other"
}

trial_record_complete(p) if {
	q := p.protected
	q.trial_prevents_compliance
	"VF" in q.codes
	nonblank(q.trial.approval_document)
	nonblank(q.trial.description)
	nonblank(q.trial.location)
	q.trial.area_ha > 0
}

combination_correction_open if {
	application.payment_notice_received == false
	application.control_objection == false
}

small_payment_discretion(eur) if {
	eur >= 0
	eur <= 50
}

applicable_sanction := sanction(year, application.sanction_stage, application.full_cuts_this_contract)

contract_effect := "im Abmeldejahr ungültig" if withdrawn

else := "erloschen" if count(lapse_reason) > 0

else := "Antragsgrundlage und jährliche Mindestteilnahme belegt" if {
	contract_basis
	no_current_withdrawal
	application.mfa_complete
	producer_ok
	size_ok
	annual_minimum
	some p in input.land.parcels
	nue(p)
	treatment_ok(p)
}

non_cereal_mixture(p) if {
	p.crop.is_mixture
	p.crop.cereal_share_pct >= 0
	p.crop.cereal_share_pct < 50
}

arable_fodder(p) if {
	"Ackerfutter" in crop_groups(p.crop.crop_name, year)
	p.crop.crop_name != "Ackerweide"
}

arable_fodder(p) if {
	p.crop.crop_name == "Ackerweide"
	p.crop.exclusively_grazed
}

excluded_land_label(name) if name in tables.excluded_land_uses
breach_categories := tables.breach_categories

valid_mfa_components if {
	is_array(input.land.mfa_area_components)
	every row in input.land.mfa_area_components {
		nonblank(row.code)
		nonblank(row.country)
		is_number(row.area_m2)
		floor(row.area_m2) == row.area_m2
		row.area_m2 >= 0
	}
}

qualifying_size_ha := sum(areas) / 10000 if {
	valid_mfa_components
	areas := [row.area_m2 |
		some row in input.land.mfa_area_components
		row.country == "AT"
		term := tables.size_components[row.code]
		term.start <= year
		year <= term.end
	]
}

else := application.at_qualifying_mfa_ha if {
	object.get(input, ["land", "mfa_area_components"], null) == null
	is_number(application.at_qualifying_mfa_ha)
}

protected_size_ha := sum(areas) / 10000 if {
	valid_mfa_components
	every row in input.land.mfa_area_components { protected_flag_known(row) }
	areas := [row.area_m2 |
		some row in input.land.mfa_area_components
		row.country == "AT"
		row.code in {"A", "GA"}
		row.protected_cultivation
	]
}

else := application.at_protected_mfa_ha if {
	object.get(input, ["land", "mfa_area_components"], null) == null
	is_number(application.at_protected_mfa_ha)
}

protected_flag_known(row) if row.country != "AT"
protected_flag_known(row) if not row.code in {"A", "GA"}
protected_flag_known(row) if is_boolean(row.protected_cultivation)
