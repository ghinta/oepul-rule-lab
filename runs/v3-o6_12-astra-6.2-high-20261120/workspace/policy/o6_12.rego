package oepul.o6_12

import rego.v1

catalog := data.oepul_tables
year := input.farm.year
contract := input.farm.o6_12

contract_term := term if {
	some term in catalog.contract_terms
	term.start_year == contract.start_year
}

valid_date(d) if {
	regex.match(`^[0-9]{4}-[0-9]{2}-[0-9]{2}$`, d)
	is_number(time.parse_rfc3339_ns(concat("", [d, "T00:00:00Z"])))
}

entry_timely := valid if {
	end := sprintf("%d-12-31", [contract.start_year - 1])
	valid_date(contract.application_date)
	valid := contract.application_date <= end
	contract_term
} else := false if {
	is_number(contract.start_year)
	not contract.start_year in {2023, 2024, 2025}
}

contract_year if {
	contract_term
	year >= contract.start_year
	year <= 2028
	contract.status in {"active", "exit_pending", "exit_approved"}
}

bio_combination_ok := ok if {
	mode := input.farm.bio_measure_scope
	mode in {"none", "whole_farm", "partial_arable_grassland", "partial_wine_fruit_hop"}
	ok := mode in {"none", "partial_arable_grassland"}
}

switch_timely := false if {
	is_string(contract.switch_target)
	contract.switch_target != "1B"
}

else := ok if {
	valid_date(contract.switch_date)
	some row in catalog.switches
	row.source == "12"
	row.target == contract.switch_target
	contract_term
	ok := switch_in_window(contract.switch_date)
}

default switch_in_window(_) := false

switch_in_window(d) if {
	d >= sprintf("%d-01-01", [contract.start_year])
	d <= "2025-12-31"
}

# Kulturzuordnung für Auflagen und Flächensumme. OP und andere Zahlungsmerkmale
# werden erst bei der Schlagprämie berücksichtigt.
crop_group(p) := "outside" if {
	p.country != "AT"
	is_string(p.country)
}

else := "outside" if p.use_name in {"Baumschule", "Baumschulen", "Baumschulfläche", "Baumschulflächen", "Rebschule", "Rebschulen", "Rebschulfläche", "Rebschulflächen"}

else := "vineyard" if {
	p.country == "AT"
	p.use_name in {"Schnittweingarten", "Schnittweingärten"}
}

else := g if {
	p.country == "AT"
	is_string(p.use_name)
	g := p.crop.crop_category
	g in {"vineyard", "hop"}
}

else := "orchard" if {
	p.country == "AT"
	p.crop.crop_category == "orchard"
	some fruit in catalog.fruit
	fruit.name == fruit_name(p.crop)
	fruit.first <= year
}

else := "outside" if {
	p.country == "AT"
	p.crop.crop_category == "orchard"
	name := object.get(p.crop, "oepul_group", p.crop.crop_name)
	is_string(name)
	known_nonfruit(name)
}

else := "outside" if {
	p.country == "AT"
	p.crop.crop_category in {"cereal", "maize", "oilseed", "legume", "root", "vegetable", "fallow", "other"}
	is_string(p.use_name)
}

fruit_name(crop) := crop.oepul_group if is_string(crop.oepul_group)

else := crop.crop_name

known_nonfruit(name) if name == "kein ÖPUL-Obst"

known_nonfruit(name) if {
	some r in catalog.fruit
	r.name == name
	year < r.first
}

covered(p) if crop_group(p) in {"vineyard", "orchard", "hop"}

covered_ha := sum([p.area_ha | some p in input.land.parcels; covered(p)]) if {
	is_array(input.land.parcels)
	every p in input.land.parcels { crop_group(p); is_number(p.area_ha); p.area_ha >= 0}
}

measure_size_ok := ok if {
	year == contract.first_participation_year
	ok := covered_ha >= 0.5
}

else if {
	year > contract.first_participation_year
	year <= 2028
}

farm_size_ok if year > input.farm.first_oepul_year

else if {
	year == input.farm.first_oepul_year
	input.land.protected_at_ha >= 0.5
	is_number(input.land.protected_at_ha)
}

else if {
	year == input.farm.first_oepul_year
	input.land.qualifying_at_ha >= 1.5
	is_number(input.land.qualifying_at_ha)
}

else := false if {
	year == input.farm.first_oepul_year
	is_number(input.land.protected_at_ha)
	is_number(input.land.qualifying_at_ha)
}

applicant_ok := ok if {
	a := input.farm.applicant
	is_boolean(a.active_farmer)
	is_boolean(a.agricultural_activity)
	is_boolean(a.own_name_and_account)
	is_boolean(a.disposal_right)
	is_boolean(a.public_control)
	is_number(a.public_percent)
	is_string(a.legal_form)
	ok := applicant_valid(a)
}

default applicant_valid(_) := false

applicant_valid(a) if {
	a.active_farmer
	a.agricultural_activity
	a.own_name_and_account
	a.disposal_right
	not a.public_control
	a.public_percent <= 25
	a.legal_form in {"natural", "registered_partnership", "legal_person", "association"}
}

exit_available if {
	contract_year
	year >= 2026
	contract.status in {"active", "exit_pending"}
	has_wine
}

has_wine if {
	some p in input.land.parcels
	crop_group(p) == "vineyard"
	is_number(p.area_ha)
	p.area_ha > 0
}

wine_at_notification if contract.wine_at_notification == true

wine_at_notification if {
	object.get(contract, "wine_at_notification", null) == null
	startswith(contract.exit_notification_date, sprintf("%d-", [year]))
	has_wine
}

exit_effect := {"terminated_from": d, "no_recovery_for_short_term": true, "premium_2026_eur": 0} if {
	contract.status == "exit_approved"
	wine_at_notification
	d := contract.exit_notification_date
	valid_date(d)
	startswith(d, "2026-")
	year >= 2026
	contract_term
}

bound_on(d) if {
	contract_year
	valid_date(d)
	startswith(d, sprintf("%d-", [year]))
	contract.status in {"active", "exit_pending"}
}

bound_on(d) if {
	contract_year
	valid_date(d)
	startswith(d, sprintf("%d-", [year]))
	contract.status == "exit_approved"
	d < exit_effect.terminated_from
}

special_order(p, e) if {
	year == 2026
	is_object(p)
	e.order.pest == "Amerikanische Rebzikade"
}

local_order(p, e) if {
	special_order(p, e)
	crop_group(p) == "vineyard"
	p.state in catalog.order_states
	e.order.in_designated_area == true
}

synthetic_exception(e) if e.order.synthetic_required == true
synthetic_exception(e) if e.order.bio_available == false

ordered_use(p, e) if {
	e.order.applies == true
	e.order.active_ingredient_authorized == true
	is_string(e.order.pest)
	not special_order(p, e)
}

ordered_use(p, e) if {
	local_order(p, e)
	e.synthetic == true
	e.order.applies == true
	e.order.active_ingredient_authorized == true
	synthetic_exception(e)
}

order_denied(p, e) if {
	special_order(p, e)
	crop_group(p) != "vineyard"
}

order_denied(p, e) if {
	e.order.applies == false
	is_object(p)
}

order_denied(p, e) if {
	e.order.active_ingredient_authorized == false
	is_object(p)
}

order_denied(p, e) if {
	special_order(p, e)
	e.order.in_designated_area == false
}

order_denied(p, e) if {
	special_order(p, e)
	is_string(p.state)
	not p.state in catalog.order_states
}

order_denied(p, e) if {
	local_order(p, e)
	e.order.synthetic_required == false
	e.order.bio_available == true
}

application_status(p, e) := "kein Insektizid" if {
	is_array(e.effect_types)
	count(e.effect_types) > 0
	not "Insektizid" in e.effect_types
}

else := "Bio-Mittel zulässig" if {
	"Insektizid" in e.effect_types
	e.bio_permitted == true
}

else := "angeordneter Einsatz zulässig" if {
	"Insektizid" in e.effect_types
	e.bio_permitted == false
	ordered_use(p, e)
}

else := "Verstoß" if {
	"Insektizid" in e.effect_types
	e.bio_permitted == false
	order_denied(p, e)
}

else := "Sachverhalt unvollständig"

application_findings contains {"parcel": p.parcel_id, "event": i, "date": e.date, "status": application_status(p, e)} if {
	some p in input.land.parcels
	covered(p)
	some i, e in p.operations.psm_events
	bound_on(e.date)
	e.status == "applied"
}

order_duties contains {"parcel": p.parcel_id, "event": i, "document_order_and_use": true, "ama_submission": submission(e, p), "records": object.get(e.order, "documented", null)} if {
	some p in input.land.parcels
	covered(p)
	some i, e in p.operations.psm_events
	e.status == "applied"
	bound_on(e.date)
	e.order.applies == true
	"Insektizid" in e.effect_types
}

submission(e, p) := "eAMA Eingaben / andere Eingaben" if {
	year <= 2025
	e.synthetic == true
	is_object(p)
}

else := "keine Übermittlung" if local_order(p, e)

else := "keine spezifische Übermittlungsvorgabe ermittelt"

code_for(e) := catalog.psm_codes.bio if e.bio_permitted == true

else := catalog.psm_codes.synthetic_insecticide if {
	e.synthetic
	"Insektizid" in e.effect_types
}

else := catalog.psm_codes.synthetic_other if {
	e.synthetic
	is_array(e.effect_types)
	count(e.effect_types) > 0
	not "Insektizid" in e.effect_types
}

annual_codes(p) := {code_for(e) | some e in p.operations.psm_events; e.status == "applied"; e.area_wide; bound_on(e.date)} if {
	is_array(p.operations.psm_events)
	every e in p.operations.psm_events { coding_known(e) }
}

coding_known(e) if e.status in {"planned", "cancelled"}

coding_known(e) if {
	e.status == "applied"
	valid_date(e.date)
	not startswith(e.date, sprintf("%d-", [year]))
}

coding_known(e) if {
	e.status == "applied"
	e.area_wide == false
	valid_date(e.date)
}

coding_known(e) if {
	e.status == "applied"
	e.area_wide == true
	valid_date(e.date)
	is_string(code_for(e))
}

minimum_codes(p) := set() if {
	year >= 2026
	is_object(p)
}

else := codes - {catalog.psm_codes.bio} if {
	year <= 2025
	is_array(p.operations.psm_events)
	codes := annual_codes(p)
	catalog.psm_codes.synthetic_other in codes
}

else := annual_codes(p) if {
	year <= 2025
	is_array(p.operations.psm_events)
}

coding_actions contains {"parcel": p.parcel_id, "event": i, "action": action} if {
	year <= 2025
	some p in input.land.parcels
	covered(p)
	some i, e in p.operations.psm_events
	bound_on(e.date)
	e.area_wide
	action := {"planned": "Vorabcodierung möglich", "cancelled": "Vorabcodierung bei absehbarem Nichteinsatz streichen", "applied": "Codes umgehend ergänzen oder ändern"}[e.status]
}

stock_status(s) := "zulässig" if s.bio_permitted == true

else := "Verstoß" if {
	s.bio_permitted == false
	s.legal_other_crop == false
}

else := "Verstoß" if {
	s.bio_permitted == false
	s.legal_other_crop
	s.plausible_amount == false
}

else := "Verstoß" if {
	s.bio_permitted == false
	s.legal_other_crop
	s.records == false
}

else := "zulässig" if {
	s.legal_other_crop
	s.plausible_amount
	s.records
}

else := "Sachverhalt unvollständig"

stock_findings contains {"event": i, "action": s.action, "status": stock_status(s)} if {
	some i, s in input.farm.insecticide_stock
	s.action in {"purchase", "storage"}
	bound_on(s.date)
}

rate_per_ha(group, y) := row.eur_ha if {
	some row in catalog.rates
	row.group == group
	row.first <= y
	y <= row.last
}

combination_cell(partner) := c if {
	some c in catalog.combination_matrix
	c.row == "12"
	c.column == partner
}

organism_bonus(y) := {"minimum_eur_ha": r.minimum * r.retained_fraction, "maximum_eur_ha": r.maximum * r.retained_fraction} if {
	some r in catalog.organism_rates
	r.first <= y
	y <= r.last
}

parcel_exclusions(p) := {reason | some reason in exclusion_labels; excluded(p, reason)}
exclusion_labels := {"Ausgeschlossene Nutzungsart", "Außerhalb Österreichs", "Obstpflanzgut", "Unveredelter Obstbaum", "OP/VF", "Maßnahmenbezogener OP-Code", "Nationalpark", "Nationalparkauflagen", "Keine aktive Produktion", "Fehlende Angabe", "Fehlende Identifikation", "Nicht hauptsächlich landwirtschaftlich", "Auspflanzung", "Jährliche Pflege", "Ernte und Verbringen", "Unterjährige Nichterfüllung", "Verpflichtungszeitraum nicht erfüllbar", "Andere öffentliche Abgeltung oder Verpflichtung", "Versuchsfläche mit Nichterfüllung"}
excluded(p, "Ausgeschlossene Nutzungsart") if p.use_name in catalog.general_excluded_uses

excluded(p, "Außerhalb Österreichs") if {
	is_string(p.country)
	p.country != "AT"
}

excluded(p, "Obstpflanzgut") if {
	crop_group(p) == "orchard"
	p.orchard_quality == false
}

excluded(p, "Unveredelter Obstbaum") if {
	crop_group(p) == "orchard"
	p.ungrafted_tree == true
}

excluded(p, "OP/VF") if {
	some code in p.payment.codes
	code in {"OP", "VF"}
}

excluded(p, "Maßnahmenbezogener OP-Code") if p.payment.op_for_measure
excluded(p, "Nationalpark") if p.payment.national_park in {"Neusiedlersee", "Donau-Auen"}
excluded(p, "Nationalparkauflagen") if p.payment.park_restrictions

excluded(p, reason) if {
	some k, label in {"active": "Keine aktive Produktion", "declared": "Fehlende Angabe", "identified": "Fehlende Identifikation", "mainly_agricultural": "Nicht hauptsächlich landwirtschaftlich", "planted": "Auspflanzung", "annual_care": "Jährliche Pflege", "harvest_removed": "Ernte und Verbringen", "full_year": "Unterjährige Nichterfüllung", "term_possible": "Verpflichtungszeitraum nicht erfüllbar"}
	label == reason
	p.payment[k] == false
}

excluded(p, "Andere öffentliche Abgeltung oder Verpflichtung") if p.payment.public_overlap
excluded(p, "Versuchsfläche mit Nichterfüllung") if p.payment.trial_noncompliance

payment_facts_known(p) if {
	every k in {"active", "declared", "identified", "mainly_agricultural", "planted", "annual_care", "harvest_removed", "full_year", "term_possible", "public_overlap", "trial_noncompliance", "park_restrictions", "op_for_measure"} { is_boolean(p.payment[k]) }
	is_array(p.payment.codes)
	is_string(p.payment.national_park)
}

fruit_quality_known(p) if crop_group(p) != "orchard"

fruit_quality_known(p) if {
	is_boolean(p.orchard_quality)
	is_boolean(p.ungrafted_tree)
}

# Grundbetrag vor Sanktionen, betrieblicher Modulation und gemeinsamer Obergrenze.
parcel_base_eur(p) := 0 if {
	exit_effect
	year >= 2026
	is_object(p)
}

else := 0 if count(parcel_exclusions(p)) > 0

else := 0 if crop_group(p) == "outside"

else := amount if {
	contract_year
	contract.status in {"active", "exit_pending"}
	covered(p)
	payment_facts_known(p)
	fruit_quality_known(p)
	is_string(p.use_name)
	p.area_ha >= 0
	amount := p.area_ha * rate_per_ha(crop_group(p), year)
}

takeover_ok := ok if {
	takeover := contract.takeover
	valid_date(takeover.date)
	startswith(takeover.date, sprintf("%d-", [year]))
	year >= 2023
	year <= 2028
	day := takeover_april_day(year)
	deadline := sprintf("%d-04-%s", [year, day])
	is_boolean(takeover.previously_participating)
	is_boolean(takeover.ama_approved)
	is_number(takeover.taken_ha)
	is_number(takeover.additional_ha)
	ok := valid_takeover(takeover, deadline)
}

default valid_takeover(_, _) := false

valid_takeover(takeover, deadline) if {
	takeover.taken_ha > 0
	takeover.additional_ha >= 0
	takeover.additional_ha <= 0.5 * takeover.taken_ha
	takeover.date <= deadline
	not takeover.previously_participating
	takeover.ama_approved
}

takeover_april_day(y) := "17" if y in {2023, 2028}

else := "15"

loss_tolerance(previous_ha) := max([0.5, min([5, 0.05 * previous_ha])]) if {
	previous_ha >= 0
	is_number(previous_ha)
}

sanction_consequence(level, y) := r.consequence if {
	some r in catalog.sanctions
	r.level == level
	y >= 2023
	r.consequence
}

else := r.through_2026 if {
	some r in catalog.sanctions
	r.level == level
	y >= 2023
	y <= 2026
}

else := r.from_2027 if {
	some r in catalog.sanctions
	r.level == level
	y >= 2027
}

payment_deadline(y) := sprintf("%d-06-30", [y + 1])

advance_limit(amount) := amount * 0.75 if {
	amount >= 0
	is_number(amount)
}

cap_per_ha(group, y) := row if {
	some row in catalog.caps
	group == row.group
	row.first <= y
	y <= row.last
}

upper_ha(band, h) := min([h, band.upper]) if is_number(band.upper)

else := h

modulation_factor(h) := sum([part | some band in catalog.modulation; part := max([0, upper_ha(band, h) - band.lower]) * band.fraction]) / h if {
	is_number(h)
	h > 0
}

deduction_sequence := catalog.deduction_order
culture_list(group) := catalog.culture_groups[group]
div_variant(code) := catalog.div_variants[code]

drought_harvest_waiver(p) if {
	year == 2026
	p.land_use == "arable"
	p.drought.late_summer_or_autumn
	p.drought.heat_sensitive
	p.drought.no_harvestable_stand
	some r in catalog.drought_districts
	p.state == r.state
	r.district in {"alle Bezirke", p.district}
	valid_date(p.drought.assessment_date)
	p.drought.assessment_date >= r.published
	startswith(p.drought.assessment_date, "2026-")
}
