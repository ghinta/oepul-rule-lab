package oepul.o6_24

import rego.v1

tables := data.wrrl_tables
year := input.farm.year
application := input.farm.wrrl
parcels := input.land.parcels

valid_date(d) if {
	is_string(d)
	regex.match(`^\d{4}-\d{2}-\d{2}$`, d)
	is_number(time.parse_rfc3339_ns(concat("", [d, "T00:00:00Z"])))
}

in_year(row) if {
	row.start_year <= year
	row.end_year == null
}

in_year(row) if {
	row.start_year <= year
	is_number(row.end_year)
	year <= row.end_year
}

rate_eur_ha := r.eur_per_ha if {
	some r in tables.rates
	in_year(r)
}

cap_rows := [r | some r in tables.caps; in_year(r)]
reduction_order := tables.reduction_order
sanction_schedule := {r.level: pct | some r in tables.sanctions; pct := sanction_pct(r)}
sanction_pct(r) := r.percent_before_2027 if year < 2027

else := r.percent_from_2027 if year >= 2027

crop_groups(name) := {r.group | some r in tables.crops; crop_matches(r, name); year >= r.from_year}

zone_area(p) := 0 if {
	p.land_use in {"grassland", "special_crop", "alpine_pasture", "other"}
} else := ha if {
	p.land_use == "arable"
	ha := p.wrrl.zone_ha
	is_number(ha)
	ha >= 0
	is_number(p.area_ha)
	ha <= p.area_ha
}

zone_arable_ha := sum(values) if {
	is_array(parcels)
	values := [n | some p in parcels; n := zone_area(p)]
	count(values) == count(parcels)
}

minimum_met := zone_arable_ha >= 2

timely_entry if {
	year >= 2023
	year <= 2027
	application.application_for_year == year
	d := application.measure_application_date
	valid_date(d)
	d <= sprintf("%d-12-31", [year - 1])
}

withdrawn if {
	d := application.effective_withdrawal_date
	valid_date(d)
	startswith(d, sprintf("%d-", [year]))
}

no_current_withdrawal if application.effective_withdrawal_date == null

no_current_withdrawal if {
	valid_date(application.effective_withdrawal_date)
	not withdrawn
}

takeover_window if {
	d := application.takeover_date
	valid_date(d)
	startswith(d, sprintf("%d-", [year]))
	d <= sprintf("%d-04-%s", [year, april_deadline])
}

april_deadline := "17" if year in {2023, 2028}

else := "15"

takeover_area_ok := extra <= (0.5 * original) if {
	original := application.takeover_original_ha
	extra := application.takeover_extension_ha
	is_number(original)
	is_number(extra)
	original > 0
	extra >= 0
}

application_basis if timely_entry
application_basis if application.previous_contract_continuable == true

application_basis if {
	application.takeover_approved == true
	takeover_window
	takeover_area_ok
}

# Antrags-/Fortführungsstatus vor Bescheid und allfälligen Sanktionen.
contract_status := "abgemeldet" if withdrawn

else := "Mindestfläche unterschritten" if minimum_met == false

else := "kein Zahlungsantrag" if application.annual_mfa_submitted == false

else := "Antragsvoraussetzungen erfüllt" if {
	year >= 2023
	year <= 2028
	minimum_met
	no_current_withdrawal
	application.annual_mfa_submitted == true
	application_basis
}

else := "Neuantrag fehlt oder verspätet" if {
	minimum_met
	no_current_withdrawal
	application.annual_mfa_submitted == true
	application.previous_contract_continuable == false
	application.takeover_approved == false
	known_entry
	not timely_entry
}

else := "offen"

known_entry if application.measure_application_date == null

known_entry if {
	valid_date(application.measure_application_date)
	is_number(application.application_for_year)
}

legal_form_ok(a) if a.legal_form in {"natural", "registered_partnership"}

legal_form_ok(a) if {
	a.legal_form in {"legal_person", "association"}
	is_number(a.public_share_pct)
	a.public_share_pct >= 0
	a.public_share_pct <= 25
}

applicant_ok if {
	a := input.farm.applicant
	legal_form_ok(a)
	a.public_body_or_institution == false
	a.equivalent_or_indirect_public_control == false
	a.own_name_and_account
	a.control_of_declared_land
	a.active_farmer
	a.agricultural_activity
}

size_ok if {
	is_number(input.farm.first_oepul_year)
	input.farm.first_oepul_year < year
}

size_ok if {
	input.farm.first_oepul_year == year
	input.land.protected_cultivation_at_ha >= 0.5
	is_number(input.land.protected_cultivation_at_ha)
}

size_ok if {
	input.farm.first_oepul_year == year
	input.land.minimum_size_eligible_at_ha >= 1.5
	is_number(input.land.minimum_size_eligible_at_ha)
}

# Ausschlussgründe können auch bei sonst unvollständigen Angaben sicher feststehen.
excluded(p) if p.wrrl.increased_n_permit == true
excluded(p) if p.crop.crop_category == "fallow"
excluded(p) if p.wrrl.claimed_correctly == false
excluded(p) if p.wrrl.active_production == false

excluded(p) if {
	some c in p.wrrl.codes
	c in {"OP", "OPWRRL", "VF"}
}

excluded(p) if {
	some c in p.wrrl.exclusions
	c in tables.land_exclusions
}

excluded(p) if {
	p.wrrl.trial.approved_by_ministry
	p.wrrl.trial.prevents_compliance
}

excluded(p) if transfer_action(p) == "Meldung und OP-Codierung; keine Jahresprämie"
excluded(p) if p.wrrl.incident.third_party_solely_responsible == true

base_area(p) := 0 if zone_area(p) == 0

else := 0 if excluded(p)

else := ha if {
	ha := zone_area(p)
	p.wrrl.increased_n_permit == false
	p.wrrl.claimed_correctly == true
	p.wrrl.active_production == true
	is_string(p.crop.crop_category)
	is_array(p.wrrl.codes)
	p.wrrl.exclusions == []
}

# Tarifbetrag auf ausgewiesener Flächenbasis, vor Kontrollen, Kürzungen und Obergrenzen.
base_premium_eur := 0 if contract_status in {"abgemeldet", "Mindestfläche unterschritten", "kein Zahlungsantrag", "Neuantrag fehlt oder verspätet"}

else := 0 if excluded_applicant_or_size

else := sum(areas) * rate_eur_ha if {
	contract_status == "Antragsvoraussetzungen erfüllt"
	applicant_ok
	size_ok
	areas := [n | some p in parcels; n := base_area(p)]
	count(areas) == count(parcels)
}

band_end(b, h) := min([b.upper, h]) if is_number(b.upper)

else := h if b.upper == null

modulation_factor := sum(weighted) / h if {
	h := input.land.mfa_home_area_ha
	is_number(h)
	h > 0
	weighted := [amount | some b in tables.modulation; amount := max([0, band_end(b, h) - b.lower]) * b.factor]
}

effective_class(s) := "C" if s.gis_class == null

else := c if {
	c := s.gis_class
	is_string(c)
	c != ""
}

segment_amount(p, s) := s.area_ha * lim if {
	c := effective_class(s)
	limits := [r.kg_ha | some r in p.wrrl.class_limits; r.class == c]
	count(limits) == 1
	lim := limits[0]
	is_number(lim)
	lim >= 0
	is_number(s.area_ha)
	s.area_ha > 0
}

weighted_limit(p) := sum(amounts) / ha if {
	ha := zone_area(p)
	ha > 0
	segments := p.wrrl.segments
	is_array(segments)
	sum([s.area_ha | some s in segments]) == ha
	amounts := [a | some s in segments; a := segment_amount(p, s)]
	count(amounts) == count(segments)
}

nitrogen_checks[p.parcel_id] := {"limit_kg_ha": lim, "applied_kg_ha": n, "within_limit": n <= lim} if {
	some p in parcels
	lim := weighted_limit(p)
	n := p.wrrl.annual_effective_n_kg_ha
	is_number(n)
	n >= 0
}

permit_code_checks[p.parcel_id] := ok if {
	some p in parcels
	zone_area(p) > 0
	p.wrrl.increased_n_permit
	is_array(p.wrrl.codes)
	ok := "OPWRRL" in p.wrrl.codes
}

split_checks[p.parcel_id] := ok if {
	some p in parcels
	zone_area(p) > 0
	p.wrrl.higher_class_separate_application
	is_boolean(p.wrrl.subplots_claimed_separately)
	is_boolean(p.wrrl.subplots_recorded_separately)
	ok := [p.wrrl.subplots_claimed_separately, p.wrrl.subplots_recorded_separately] == [true, true]
}

in_window(e) if {
	some w in e.allowed_windows
	e.date >= w.start
	e.date <= w.end
}

valid_window(w) if {
	valid_date(w.start)
	valid_date(w.end)
	w.start <= w.end
}

event_result(e) := ok if {
	valid_date(e.date)
	startswith(e.date, sprintf("%d-", [year]))
	is_array(e.allowed_windows)
	every w in e.allowed_windows { valid_window(w) }
	ok := in_window_boolean(e)
}

in_window_boolean(e) if in_window(e)

else := false

period_checks[p.parcel_id] := ok if {
	some p in parcels
	zone_area(p) > 0
	events := p.wrrl.n_applications
	is_array(events)
	results := [v | some e in events; v := event_result(e)]
	count(results) == count(events)
	ok := not_false(results)
}

not_false(xs) := false if false in xs

else := true

record_checks[p.parcel_id] := ok if {
	some p in parcels
	ok := p.wrrl.section5_record
	is_boolean(ok)
}

book_checks[k] := v if {
	some k in {"section5_book_kept", "book_on_farm"}
	v := input.documentation[k]
	is_boolean(v)
}

automatic_drought(p) if {
	year == 2026
	p.wrrl.no_harvestable_crop_due_to_drought
	p.wrrl.usual_late_summer_or_autumn_harvest
	p.wrrl.crop_sensitive_to_heat_and_drought
	some r in tables.drought_districts
	p.wrrl.state == r.state
	district_matches(p, r)
}

district_matches(p, r) if p.wrrl.district == r.district
district_matches(_, r) if r.district == null
harvest_ok(p) if automatic_drought(p)
harvest_ok(p) if p.wrrl.harvest_force_majeure_approved == true

harvest_ok(p) if {
	n := p.wrrl.harvested_and_removed_pct
	is_number(n)
	n >= 85
	n <= 100
}

management_ok(p) if {
	p.wrrl.is_arable_forage == false
	p.wrrl.sown_properly
	p.wrrl.maintained_annually
	harvest_ok(p)
}

management_ok(p) if {
	p.wrrl.is_arable_forage
	p.wrrl.full_mow_and_remove
}

management_ok(p) if {
	p.wrrl.is_arable_forage
	p.wrrl.full_grazing
}

management_checks[p.parcel_id] := "erfüllt" if {
	some p in parcels
	zone_area(p) > 0
	management_ok(p)
}

matrix_rows[row.measure] := row.cells if some row in tables.combination_matrix
matrix_cell(a, b) := matrix_rows[a][b]
combination_notes := tables.combination_notes
combination_blocked(_, b) if b == "K20"
combination_blocked(p, _) if p.wrrl.protected_pot_or_substrate
combination_blocked(p, b) if restricted_submeasure(p, b)
combination_blocked(_, b) if matrix_cell("24", b) == ""

combination_status(p, b) := "ausgeschlossen" if combination_blocked(p, b)

else := "kombinierbar" if {
	matrix_cell("24", b) == "x"
	p.wrrl.protected_pot_or_substrate == false
	special_absent(p, b)
}

else := "offen"

special_absent(_, b) if not b in {"8", "16"}

special_absent(p, b) if {
	b == "8"
	p.wrrl.baw == false
}

special_absent(p, b) if {
	b == "16"
	p.wrrl.ag == false
}

restricted_submeasure(p, b) if {
	b == "8"
	p.wrrl.baw
}

restricted_submeasure(p, b) if {
	b == "16"
	p.wrrl.ag
}

combination_checks[p.parcel_id] := {b: status | some b in p.wrrl.other_measures; b != "24"; status := combination_status(p, b)} if {
	some p in parcels
	is_array(p.wrrl.other_measures)
	zone_area(p) > 0
}

# Ausnahmen werden nur verneint, wenn sie anhand der Eingaben ausgeschlossen sind.
drought_excluded(_) if {
	is_number(year)
	year != 2026
}

drought_excluded(p) if p.wrrl.no_harvestable_crop_due_to_drought == false
drought_excluded(p) if p.wrrl.usual_late_summer_or_autumn_harvest == false
drought_excluded(p) if p.wrrl.crop_sensitive_to_heat_and_drought == false

drought_excluded(p) if {
	is_string(p.wrrl.state)
	is_string(p.wrrl.district)
	not district_listed(p)
}

district_listed(p) if {
	some row in tables.drought_districts
	row.state == p.wrrl.state
	district_matches(p, row)
}

management_failed(p) if {
	p.wrrl.is_arable_forage == false
	p.wrrl.sown_properly == false
}

management_failed(p) if {
	p.wrrl.is_arable_forage == false
	p.wrrl.maintained_annually == false
}

management_failed(p) if {
	p.wrrl.is_arable_forage == false
	is_number(p.wrrl.harvested_and_removed_pct)
	p.wrrl.harvested_and_removed_pct >= 0
	p.wrrl.harvested_and_removed_pct < 85
	p.wrrl.harvest_force_majeure_approved == false
	drought_excluded(p)
}

management_failed(p) if {
	p.wrrl.is_arable_forage
	p.wrrl.full_mow_and_remove == false
	p.wrrl.full_grazing == false
}

management_checks[p.parcel_id] := "verletzt" if {
	some p in parcels
	zone_area(p) > 0
	management_failed(p)
}

management_checks[p.parcel_id] := "offen" if {
	some p in parcels
	zone_area(p) > 0
	not management_ok(p)
	not management_failed(p)
}

# Schlagobergrenze für die gewöhnliche WRRL-Fläche. Die Eingabebeträge sind bereits moduliert
# und enthalten gegebenenfalls auf den Schlag umgelegte Zahlungen für Landschaftselemente.
standard_cap(amounts) := {"subject_eur_ha": subject, "ceiling_eur_ha": r.eur_per_ha, "excess_eur_ha": max([0, subject - r.eur_per_ha])} if {
	is_array(amounts)
	every contribution in amounts {
		is_string(contribution.measure)
		is_number(contribution.eur_ha)
		contribution.eur_ha >= 0
	}
	some r in cap_rows
	r.category == "standard"
	subject := sum([contribution.eur_ha | some contribution in amounts; not contribution.measure in r.excluded])
}

# Null in der Übersicht bedeutet fehlende/ungeeignete Eingaben.
default area_or_null := null

area_or_null := zone_arable_ha

default base_or_null := null

base_or_null := base_premium_eur

default factor_or_null := null

factor_or_null := modulation_factor
decision := {
	"contract_status": contract_status, "applicant_status": applicant_status, "farm_size_status": farm_size_status, "parcel_base_before_checks": parcel_base, "parcel_duties": parcel_duties, "zone_arable_ha": area_or_null,
	"base_premium_before_checks_eur": base_or_null, "modulated_tariff_before_other_adjustments_eur": modulated_or_null, "home_modulation_factor": factor_or_null,
	"nitrogen": nitrogen_checks, "application_windows": period_checks, "subplot_duties": split_checks,
	"permit_code": permit_code_checks, "book": book_checks, "parcel_records": record_checks,
	"management": management_checks, "combinations": combination_checks,
}

applicant_disqualified if {
	a := input.farm.applicant
	some key in {"public_body_or_institution", "equivalent_or_indirect_public_control"}
	a[key] == true
}

applicant_disqualified if {
	a := input.farm.applicant
	some key in {"own_name_and_account", "control_of_declared_land", "active_farmer", "agricultural_activity"}
	a[key] == false
}

applicant_disqualified if input.farm.applicant.legal_form == "other"

applicant_disqualified if {
	a := input.farm.applicant
	a.legal_form in {"legal_person", "association"}
	is_number(a.public_share_pct)
	a.public_share_pct > 25
}

applicant_status := "zugelassen" if applicant_ok

else := "ausgeschlossen" if applicant_disqualified

else := "offen"

size_too_small if {
	input.farm.first_oepul_year == year
	a := input.land.protected_cultivation_at_ha
	b := input.land.minimum_size_eligible_at_ha
	is_number(a)
	is_number(b)
	a >= 0
	b >= 0
	a < 0.5
	b < 1.5
}

farm_size_status := "erfüllt" if size_ok

else := "unterschritten" if size_too_small

else := "offen"

# Der Zahlungsbetrag ist auch dann null, wenn ein eigenständiger sicherer Ausschluss besteht.
excluded_applicant_or_size if applicant_disqualified
excluded_applicant_or_size if size_too_small

payment_deadline := sprintf("%d-06-30", [year + 1]) if is_number(year)

max_advance_eur := 0.75 * input.farm.payment.expected_total_eur if {
	input.farm.payment.administrative_checks_complete == true
	is_number(input.farm.payment.expected_total_eur)
	input.farm.payment.expected_total_eur >= 0
}

small_payment_discretion if {
	amount := input.farm.payment.final_total_eur
	is_number(amount)
	amount >= 0
	amount <= 50
}

sanction_outcome := {"exclude_and_recover": true} if {
	n := input.farm.payment.hundred_pct_reductions_same_contract
	is_number(n)
	n >= 2
}

else := {"reduction_pct": percentage} if {
	is_number(input.farm.payment.hundred_pct_reductions_same_contract)
	input.farm.payment.hundred_pct_reductions_same_contract < 2
	input.farm.payment.hundred_pct_reductions_same_contract >= 0
	percentage := sanction_schedule[input.farm.payment.assessed_level]
}

# Behandlung eines gemeldeten Ausstiegs bei bekanntem Kontrollstand.
exit_before_control if {
	proposed := application.proposed_exit_date
	valid_date(proposed)
	is_array(application.control_cutoffs)
	every d in application.control_cutoffs { valid_date(d); proposed < d}
}

# Bei einem Ereignis am selben Tag ist die tatsächliche zeitliche Reihenfolge zu klären.
combo_correction_available if {
	application.impossible_combination_found
	application.control_objection == false
	application.payout_notice_received == false
}

harvest_op_action(p) := "flächenbezogene OP-Codes; kein OPZWF" if {
	p.wrrl.harvest_duty_unmet
	p.wrrl.intercrop_variant_established == true
}

else := "OP oder maßnahmenbezogener OP-Code" if {
	p.wrrl.harvest_duty_unmet
	p.wrrl.intercrop_variant_established == false
}

parcel_base[p.parcel_id] := {"area_ha": n, "tariff_eur": n * rate_eur_ha} if {
	some p in parcels
	n := base_area(p)
}

parcel_duties[p.parcel_id] := {
	"stickstoff": object.get(nitrogen_checks, p.parcel_id, null),
	"zeitraeume": object.get(period_checks, p.parcel_id, null),
	"aufzeichnung": object.get(record_checks, p.parcel_id, null),
} if {
	some p in parcels
	zone_area(p) > 0
}

term_group(code) := row.term if {
	some row in tables.contract_groups
	row.measure == code
}

multiyear_term(code, start) := row if {
	term_group(code) == "mehrjährig"
	some row in tables.multiyear_terms
	row.start == start
}

switch_targets(code) := {row.target | some row in tables.switch_pairs; row.source == code; year <= row.last_switch_year}

growth_limited(code) := value if value := code in tables.growth_limited_measures

multiyear_loss_tolerance(code, prior_ha) := max([0.5, min([5, 0.05 * prior_ha])]) if {
	term_group(code) == "mehrjährig"
	is_number(prior_ha)
	prior_ha >= 0
}

allowed_conversions := tables.allowed_conversions

crop_matches(row, name) if lower(row.name) == lower(name)

crop_matches(row, name) if {
	some alias in row.aliases
	lower(alias) == lower(name)
}

mixture_excluded_as_grain(p) if {
	pct := p.crop.mixture_grain_pct
	is_number(pct)
	pct >= 0
	pct < 50
}

conditionality_for_full_payment := ok if {
	c := input.farm.conditionality
	is_boolean(c.standards_met)
	is_boolean(c.social_standards_met)
	ok := [c.standards_met, c.social_standards_met] == [true, true]
}

incident_action(p) := "Maßnahmen-OP; Nachweis am Betrieb und Vorlage bei Kontrolle" if p.wrrl.incident.third_party_solely_responsible == true

else := "Codekorrektur oder Selbstanzeige erforderlich" if {
	p.wrrl.incident.third_party_solely_responsible == false
	p.wrrl.incident.mfa_code_corrected == false
	p.wrrl.incident.reported_to_ama == false
}

else := "MFA korrigiert" if p.wrrl.incident.mfa_code_corrected == true

else := "Selbstanzeige eingereicht" if p.wrrl.incident.reported_to_ama == true

trial_documents(p) := ok if {
	t := p.wrrl.trial
	t.approved_by_ministry
	t.prevents_compliance
	is_array(p.wrrl.codes)
	is_boolean(t.written_approval_on_farm)
	is_boolean(t.type_area_location_recorded)
	ok := ["VF" in p.wrrl.codes, t.written_approval_on_farm, t.type_area_location_recorded] == [true, true, true]
}

transfer_action(p) := "Fortführung bis Jahresende nachgewiesen" if {
	t := p.wrrl.transfer
	t.occurred_during_year
	t.successor_complies_to_year_end
	t.same_or_higher_measure
}

else := "Meldung und OP-Codierung; keine Jahresprämie" if {
	t := p.wrrl.transfer
	t.occurred_during_year
	false in [object.get(t, "successor_complies_to_year_end", null), object.get(t, "same_or_higher_measure", null)]
}

parcel_cap_checks[p.parcel_id] := result if {
	some p in parcels
	zone_area(p) > 0
	rows := input.farm.payment.parcel_contributions
	is_array(rows)
	contributions := [r | some r in rows; r.parcel_id == p.parcel_id]
	count(contributions) > 0

	# Nur die gewöhnliche WRRL-Schlagobergrenze. Sonderobergrenzen stehen in cap_rows.
	every r in contributions { not r.measure in {"13", "18", "19", "K20"} }
	result := standard_cap(contributions)
}

default modulated_or_null := null

modulated_or_null := 0 if base_premium_eur == 0

else := amount if amount := base_premium_eur * modulation_factor

# Aus der gedruckten Zelle folgende Prämienwirkung. Bedingungen der Fußnoten 2 und 4
# sind zusätzlich am konkreten Schlag zu prüfen.
matrix_terms(a, b) := "dieselbe Maßnahme" if {
	a == b
	is_object(matrix_rows[a])
}

else := terms if {
	mark := matrix_cell(a, b)
	terms := {
		"": "keine gemeinsame Flächenprämie",
		"x": "kombinierbar",
		"a": "kombinierbar mit Prämienabschlag",
		"x 1)": "nur Abgeltung der Landschaftselemente",
		"x 3)": "kombinierbar; bei Zuschlag Einsatz von Organismen mit Prämienabschlag",
	}[mark]
}
