package oepul.o6_6

import data.zwf_tabellen as tab
import rego.v1

# Der Jahresbezug ist das Anlagejahr. Zeitpunkte sind lokale Kalendertage ohne Uhrzeit.
day(s) := time.parse_rfc3339_ns(concat("", [s, "T00:00:00Z"])) if {
	is_string(s)
	regex.match(`^\d{4}-\d{2}-\d{2}$`, s)
}

date_in(y, md) := sprintf("%04d-%s", [y, md])

variant_row(v, y) := r if {
	some r in tab.varianten
	r.variant == v
	y >= r.first_year
	y <= r.last_year
}

established(c) := c.harvest_date if c.undersown == true
established(c) := c.sowing_date if c.undersown == false

break_from(c, y) := result if {
	r := variant_row(c.variant, y)
	floor_date := date_in(y + r.year_offset, r.earliest_break)
	r.minimum_days == 0
	result := floor_date
}

break_from(c, y) := result if {
	r := variant_row(c.variant, y)
	r.minimum_days > 0
	earliest := day(established(c)) + (r.minimum_days * 86400000000000)
	result := time.format([max([earliest, day(date_in(y, r.earliest_break))]), "UTC", "2006-01-02"])
}

in_period(c, y, d) if {
	day(d) >= day(established(c))
	day(d) < day(break_from(c, y))
}

insect_partner(s) if {
	s.insect_pollinated == true
	not grass(s)
}

grass(s) if s.family in {"Poaceae", "Gräser", "Süßgräser"}

insect_partner(s) if {
	object.get(s, "insect_pollinated", null) == null
	s.species in tab.insektenbeispiele
	not grass(s)
}

partner_counts(c, s) if {
	c.variant != 1
	s.species != ""
}

partner_counts(c, s) if {
	c.variant == 1
	insect_partner(s)
}

mixture_ok(c, y) if {
	r := variant_row(c.variant, y)
	is_array(c.components)
	count({s.species | some s in c.components; partner_counts(c, s)}) >= r.min_partners
	count({s.family | some s in c.components; partner_counts(c, s); is_string(s.family); s.family != ""}) >= r.min_families
	c.variant != 6
}

mixture_ok(c, y) if {
	variant_row(6, y)
	c.variant == 6
	count(c.components) > 0
	every s in c.components { v6_component(s) }
}

v6_component(s) if {
	s.species in tab.winterkulturen
	s.species != "Grünschnittroggen"
	s.winter_hardy == true
}

v6_component(s) if {
	s.species == "Perko"
	s.winter_hardy == true
}

rye_listed(s) if {
	some r in tab.roggensorten
	r.sorte == s.variety
}

rye_listed(s) if s.seed_act_approved == true

v6_component(s) if {
	s.species == "Grünschnittroggen"
	s.winter_hardy == true
	rye_listed(s)
	object.get(s, "seed_act_approved", null) != false
	rye_provenance_ok(s)
}

rye_provenance_ok(s) if s.farm_saved == false

rye_provenance_ok(s) if {
	s.farm_saved == true
	s.propagation_proof == true
}

cover_relief(c, y) if {
	y == 2026
	c.proper_establishment == true
	c.drought_gap == true
}

cereal_relief(c, y) if {
	y == 2026
	c.proper_establishment == true
	c.drought_volunteers == true
}

rye_exception(c) if {
	c.variant == 6
	every part in c.components { v6_component(part) }
	some s in c.components
	s.species == "Grünschnittroggen"
	v6_component(s)
}

harvest_relief(a, y) if {
	y == 2026
	a.country == "AT"
	a.late_sensitive_crop == true
	a.drought_no_harvest == true
	some r in tab.erntegebiete
	r.land == a.state
	region_matches(r.bezirk, a)
}

region_matches(d, _) if d == "alle Bezirke"
region_matches(d, a) if d == a.district

harvest_status(p, y) := "höhere Gewalt ohne Meldung" if harvest_relief(p.agrar, y)

else := "Erntekriterium erfüllt" if p.agrar.harvest_removed_pct >= 85

else := "flächenbezogene OP-Codes anderer betroffener Maßnahmen, kein OPZWF wegen Ernte" if {
	is_number(p.agrar.harvest_removed_pct)
	p.agrar.harvest_removed_pct < 85
	p.operations.cover_crop.is_used == true
	p.operations.cover_crop.active_sowing == true
}

else := "Erntekriterium unterschritten" if {
	is_number(p.agrar.harvest_removed_pct)
	p.agrar.harvest_removed_pct < 85
}

entry_ok(f, y) if {
	y >= 2023
	y <= 2027
	day(f.application_date) >= day(date_in(y - 1, "01-01"))
	day(f.application_date) <= day(date_in(y - 1, "12-31"))
}

change_ok(c, y) if {
	r := variant_row(c.variant, y)
	c.change_kind in {"new", "extend", "switch"}
	day(c.change_date) <= day(date_in(y, r.apply_by))
}

change_ok(c, y) if {
	variant_row(c.variant, y)
	c.change_kind in {"withdraw", "reduce"}
	day(c.change_date)
}

erosion_variant(v) if v in {2, 4, 5, 6}

equivalent_lease(c, y) if {
	erosion_variant(c.variant)
	c.transfer.lease_to_evergreen == true
	day(c.transfer.date) > day(date_in(y, "12-31"))
}

takeover_day(y) := "04-17" if y in {2023, 2028}

else := "04-15"

takeover_limits_ok(t, y) if {
	day(t.date) > day(date_in(y - 1, "12-31"))
	day(t.date) <= day(date_in(y, takeover_day(y)))
	t.previously_participating == false
	t.prior_ha > 0
	t.additional_ha >= 0
	t.additional_ha <= t.prior_ha * 0.5
}

combination_cell(left, right) := r if {
	some r in tab.kombinationen
	r.zeile == left
	r.spalte == right
}

combination_notes := tab.kombinationsfussnoten
deduction_order := tab.kuerzungsfolge

crop_classes(name, y) := {k | some k in {"getreide", "ackerfutter", "feldgemuese"}; name in tab[k]} | {"obst" | some x in tab.obst; x.kultur == name; y >= x.ab}

cap_row(case_name, y) := r if {
	some r in tab.obergrenzen
	r.fall == case_name
	y >= r.von
	y <= r.bis
}

sanction(level, y) := r.bis_2026 if {
	some r in tab.kuerzungen
	r.stufe == level
	y < 2027
}

sanction(level, y) := r.ab_2027 if {
	some r in tab.kuerzungen
	r.stufe == level
	y >= 2027
}

tier_end(r, ha) := ha if r.bis_ha == null

else := min([r.bis_ha, ha])

modulation(ha) := sum(parts) / ha if {
	ha > 0
	parts := [part | some r in tab.modulation; part := max([0, tier_end(r, ha) - r.ab_ha]) * r.faktor]
}

# Rechengröße für bereits als prämienfähig festgestellte Hektar.
premium_band(v, y, eligible_ha, home_ha) := {"min_eur": (r.min_eur_ha * eligible_ha) * factor, "max_eur": (r.max_eur_ha * eligible_ha) * factor} if {
	variant_row(v, y)
	eligible_ha >= 0
	eligible_ha <= home_ha
	factor := modulation(home_ha)
	some r in tab.praemien
	r.variant == v
}

farm_findings contains "zwf.acker.minimum" if {
	is_number(input.land.arable_area_ha)
	input.land.arable_area_ha < 1.5
}

farm_findings contains "zwf.erloeschen" if {
	input.farm.zwf.prior_contract == true
	claimed_count == 0
}

farm_findings contains "zwf.erloeschen" if {
	input.farm.zwf.prior_contract == true
	is_number(input.land.arable_area_ha)
	input.land.arable_area_ha < 1.5
}

farm_findings contains "zwf.immergruen" if "7" in input.farm.zwf.measures
farm_findings contains "zwf.konditionalitaet" if input.farm.zwf.conditionality == false

farm_findings contains "zwf.mindestbetrieb" if {
	f := input.farm.zwf
	f.first_year == true
	is_number(f.qualifying_ha)
	is_number(f.protected_ha)
	f.qualifying_ha < 1.5
	f.protected_ha < 0.5
}

farm_findings contains "zwf.antrag.einstieg" if {
	f := input.farm.zwf
	f.new_entry == true
	day(f.application_date)
	not entry_ok(f, input.farm.year)
}

farm_findings contains "zwf.ausstieg.jahr" if {
	f := input.farm
	startswith(f.zwf.exit_date, sprintf("%04d-", [f.year]))
	day(f.zwf.exit_date)
}

# Prüfwerte für Kombinationen. Der amtliche gebiets- und jahresbezogene
# GIS-Befund entscheidet bei parzellenscharfen Gebietsbeschränkungen.
listed_kg(kg_nr) := r if {
	some r in tab.gwa_katastralgemeinden
	r.kg_nr == kg_nr
}

multi_year_term(y) := r if {
	some r in tab.mehrjahresdauer
	r.beginn == y
}

multi_year_switch(from, to) if {
	some r in tab.wechsel_mehrjaehrig
	r.von == from
	to in r.nach
}

parcel_calendar[p.parcel_id] := {"anlage_bis": date_in(y, r.sow_by), "antrag_bis": date_in(y, r.apply_by), "umbruch_ab": b} if {
	some p in input.land.parcels
	c := p.operations.cover_crop
	c.claimed == true
	y := input.farm.year
	r := variant_row(c.variant, y)
	b := break_from(c, y)
}

assessment := {"betriebsbefunde": farm_findings, "schlagbefunde": findings, "arbeitsgaenge": event_findings, "termine": parcel_calendar, "korrekturen": corrections, "fachlich_offen": review_needed, "ernte": harvest_results, "praemienband_festgestellte_flaeche": assessed_premiums}

harvest_results[p.parcel_id] := harvest_status(p, input.farm.year) if {
	some p in input.land.parcels
	p.land_use == "arable"
	p.agrar.standard_harvest_obligation == true
}

contract_status := "erloschen" if "zwf.erloeschen" in farm_findings

else := "im Abmeldejahr ungültig" if "zwf.ausstieg.jahr" in farm_findings

else := "automatische Verlängerung beantragt" if {
	input.farm.year >= 2023
	input.farm.year <= 2028
	f := input.farm.zwf
	f.prior_contract == true
	f.exit_date == null
	f.annual_mfa == true
	claimed_count > 0
	input.land.arable_area_ha >= 1.5
}

claimed_count := input.farm.zwf.claimed_parcels if is_number(input.farm.zwf.claimed_parcels)

else := count([p | some p in input.land.parcels; p.operations.cover_crop.claimed == true]) if {
	is_array(input.land.parcels)
	every p in input.land.parcels { is_boolean(p.operations.cover_crop.claimed) }
}

# Nur den bestätigten prämienfähigen Umfang in einen Eurobetrag umrechnen.
assessed_premiums[p.parcel_id] := premium_band(c.variant, input.farm.year, c.accepted_ha, input.farm.zwf.home_area_ha) if {
	some p in input.land.parcels
	c := p.operations.cover_crop
	c.claimed == true
	is_number(c.accepted_ha)
	c.accepted_ha <= p.area_ha
	not confirmed_exclusion(p.parcel_id)
}

farm_findings contains "zwf.betrieb" if {
	applicant := input.farm.zwf.applicant
	some k in {"active_farmer", "agricultural_activity", "own_name", "own_account"}
	applicant[k] == false
}

farm_findings contains "zwf.ausstieg.kontrolle" if {
	f := input.farm.zwf
	day(f.exit_date) > day(f.control_cutoff)
}

farm_findings contains "zwf.antrag.einstieg" if {
	f := input.farm.zwf
	f.new_entry == true
	f.application_date == null
}

farm_findings contains "zwf.mfa.verlaengerung" if {
	input.farm.zwf.prior_contract == true
	input.farm.zwf.annual_mfa == false
}

exit_window_ok(c, y, date) if {
	c.variant in {1, 3}
	day(date) >= day(date_in(y + 1, "01-01"))
}

exit_window_ok(c, y, date) if {
	c.variant in {2, 4, 5, 6, 7}
	day(date) > day(break_from(c, y))
}

# Abweichende Datumsformulierungen und Arbeitsfolgen am selben Tag erfordern
# eine Einzelfallprüfung, wenn die Ereignisreihenfolge nicht dokumentiert ist.
review_needed contains {"parcel_id": p.parcel_id, "rule_id": "zwf.v7.ende", "date": e.date} if {
	some p in input.land.parcels
	c := p.operations.cover_crop
	c.claimed == true
	c.variant == 7
	some e in c.events
	e.kind in {"mineral_n", "pesticide", "herbicide", "slug_pellets"}
	e.date == break_from(c, input.farm.year)
}

review_needed contains {"parcel_id": p.parcel_id, "rule_id": "zwf.psm.folgesaat", "date": e.date} if {
	some p in input.land.parcels
	c := p.operations.cover_crop
	c.claimed == true
	c.variant in {1, 2, 3, 4, 5, 6}
	some e in c.events
	pesticide(e)
	e.date == c.next_sowing
	day(e.date) >= day(break_from(c, input.farm.year))
	no_prior_removal(c, input.farm.year, e)
	object.get(e, "after_next_sowing", null) == null
}

confirmed_exclusion(id) if {
	some key in parcel_rules[id]
	key in {"zwf.npf", "zwf.versuch", "zwf.code.op", "zwf.nationalpark", "zwf.inland", "zwf.ausschluss", "zwf.ausschluss.gloez", "zwf.hauptfrucht.mfa", "zwf.acker.schlag"}
}

confirmed_exclusion(_) if "zwf.acker.minimum" in farm_findings
confirmed_exclusion(_) if "zwf.ausstieg.jahr" in farm_findings

contract_groups(measure) := {r.gruppe | some r in tab.vertragsgruppen; r.massnahme == measure}

public_exception(measure, y) if {
	some r in tab.oeffentliche_ausnahmen
	r.massnahme == measure
	y >= r.von
	y <= r.bis
}

minimum_management_exception(code, measure, y) if {
	some r in tab.ausnahmen_mindestbewirtschaftung
	r.flaeche == code
	measure in r.massnahmen
	y >= r.von
	y <= r.bis
}

other_measure_restrictions := {"zugang": tab.zugangsbeschraenkung, "uebernahme_im_einzelfall": tab.uebernahme_einzelfall}

applicant_form_ok(a, y) if {
	y >= 2023
	y <= 2028
	a.legal_form in {"natural_person", "registered_partnership", "legal_entity", "association"}
}

applicant_form_ok(a, y) if {
	a.legal_form in {"public_body", "public_institution"}
	public_exception("6", y)
}

farm_findings contains "zwf.zugang.schlag" if claimed_count == 0

farm_findings contains "zwf.person" if {
	applicant := input.farm.zwf.applicant
	applicant.legal_form == "other_ineligible"
	not applicant_form_ok(applicant, input.farm.year)
}

review_needed contains {"parcel_id": p.parcel_id, "rule_id": "zwf.antrag.spaet", "date": c.change_date} if {
	some p in input.land.parcels
	c := p.operations.cover_crop
	c.change_kind == "switch"
	y := input.farm.year
	previous := variant_row(c.previous_variant, y)
	target := variant_row(c.variant, y)
	previous.apply_by < target.apply_by
	day(c.change_date) > day(date_in(y, previous.apply_by))
	change_ok(c, y)
}

combination_details(left, right) := {"zelle": cell, "zeile": row, "spalte": col, "hinweise": notes} if {
	cell := combination_cell(left, right)
	some row in tab.matrix_massnahmen
	row.kennung == left
	some col in tab.matrix_massnahmen
	col.kennung == right
	indices := array.concat(cell.fussnoten, array.concat(row.fussnoten, col.fussnoten))
	notes := [n | some n in tab.kombinationsfussnoten; n.nr in indices]
}
