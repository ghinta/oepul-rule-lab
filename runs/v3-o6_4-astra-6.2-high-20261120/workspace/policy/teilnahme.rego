package oepul.o6_4

import data.bergmaehder as tabellen
import rego.v1

farm_size_ok if {
	is_number(input.farm.oepul.first_year)
	input.farm.oepul.first_year >= 2023
	input.farm.oepul.first_year < input.farm.year
}

farm_size_ok if {
	input.farm.oepul.first_year == input.farm.year
	input.farm.oepul.protected_at_ha >= 0.5
	is_number(input.farm.oepul.protected_at_ha)
}

farm_size_ok if {
	input.farm.oepul.first_year == input.farm.year
	input.farm.oepul.countable_at_ha >= 1.5
	is_number(input.farm.oepul.countable_at_ha)
}

applicant_eligible if {
	a := input.farm.oepul.applicant
	a.legal_form in {"natürliche Person", "eingetragene Personengesellschaft", "juristische Person", "Personenvereinigung"}
	private_applicant(a)
	a.own_name_and_account
	a.disposal_of_claimed_land
	a.active_farmer
	a.agricultural_activity
}

private_applicant(a) if a.legal_form == "natürliche Person"

private_applicant(a) if {
	a.public_body_or_institution == false
	a.equivalent_public_control == false
	is_number(a.public_share_pct)
	a.public_share_pct >= 0
	a.public_share_pct <= 25
}

loss_limit(previous_ha) := max([0.5, min([5, previous_ha * 0.05])]) if previous_ha >= 0

recoverable_area(previous_ha, loss_ha) := loss_ha if {
	loss_ha > loss_limit(previous_ha)
	loss_ha <= previous_ha
} else := 0 if {
	loss_ha >= 0
	loss_ha <= previous_ha
	loss_ha <= loss_limit(previous_ha)
}

conversion_allowed(before, after) if {
	some c in tabellen.conversions
	c.from in {before, "Maßnahmenfläche"}
	c.to == after
}

# new_ha umfasst den gesamten zu prüfenden Zuwachs gegenüber der Basis.
# prebound_ha ist der darin enthaltene bereits gleich gebundene Anteil.
eligible_new_area(y, base_2025_ha, new_ha, prebound_ha) := new_ha if {
	y in {2024, 2025}
	prebound_ha >= 0
	prebound_ha <= new_ha
} else := allowed if {
	y in {2026, 2027, 2028}
	base_2025_ha >= 0
	prebound_ha >= 0
	prebound_ha <= new_ha
	allowed := prebound_ha + min([new_ha - prebound_ha, max([5, base_2025_ha * 0.5])])
}

cap_eur_ha(y, category) := row.eur_ha if {
	some row in tabellen.caps
	category == row.category
	y >= row.from_year
	y <= row.to_year
}

band_upper(b, ha) := ha if b.upper_ha == null

else := min([ha, b.upper_ha])

modulation_factor(ha) := sum(parts) / ha if {
	is_number(ha)
	ha > 0
	parts := [amount | some b in tabellen.modulation; amount := b.factor * max([0, band_upper(b, ha) - b.lower_ha])]
}

advance_limit(expected_eur) := 0.75 * expected_eur if {
	expected_eur >= 0
	input.farm.oepul.administrative_checks_complete
}

sanction_percent(y, stage) := row.percent if {
	some row in tabellen.sanctions
	row.stage == stage
	y >= row.from_year
	y <= row.to_year
}

repeated_full_reduction if {
	is_number(input.farm.oepul.full_reductions_this_contract)
	input.farm.oepul.full_reductions_this_contract >= 2
}

reduction_order := tabellen.reductions

point_eligible(e) if {
	e.kind in {"Baum", "Busch", "Baumgruppe", "Buschgruppe", "Streuobstbaum"}
	e.distance_land_m >= 0
	e.distance_land_m <= 5
	e.in_farm_control
	e.crown_diameter_m >= 2
	e.area_m2 > 0
	e.area_m2 <= 100
	spacing_ok(e)
	e.claimed
	e.maintained_all_year
	e.alpine_or_rough_pasture == false
	e.gloez8 == false
}

spacing_ok(e) if e.isolated

spacing_ok(e) if {
	is_number(e.nearest_distance_m)
	e.nearest_distance_m >= 5
}

orchard_species_ok(name, y) if {
	in_period(y)
	some species in tabellen.orchard_species
	species.name == name
	y >= species.from_year
}

crop_classes(name, y) := {row.category | some row in tabellen.crops; row.name == name; row.from_year <= y}

# Sätze einer erteilten GG-Projektauflage nach Wechsel in Naturschutz.
nat_distance_rate(code, y, km, annual) := row.eur_ha if {
	some row in tabellen.nat_distance_rates
	code == row.code
	annual == row.annual
	y >= row.from_year
	y <= row.to_year
	km > row.min_km_exclusive
	within_distance(km, row.max_km_inclusive)
}

within_distance(_, upper) if upper == null

within_distance(km, upper) if {
	is_number(upper)
	km <= upper
}

farm_calculations.Vertragsjahre := contract_years(input.farm.oepul.start_year)
farm_calculations["Antrag fristgerecht"] := entry_timely(input.farm.oepul.start_year, input.farm.oepul.application_date)
farm_calculations["Wechsel zulässig"] := switch_permitted(input.farm.oepul.start_year, input.farm.oepul.switch.date, input.farm.oepul.switch.target)
farm_calculations["Abgangstoleranz ha"] := loss_limit(input.farm.oepul.previous_measure_ha)
farm_calculations["Rückzahlungspflichtige Differenz ha"] := recoverable_area(input.farm.oepul.previous_measure_ha, input.farm.oepul.nonexempt_loss_ha)
farm_calculations["Prämienfähiger Zuwachs ha"] := eligible_new_area(input.farm.year, object.get(input.farm.oepul, "measure_2025_ha", null), input.farm.oepul.cumulative_gain_ha, gain_prebound(input.farm.year))
farm_calculations.Modulationsfaktor := modulation_factor(input.farm.oepul.home_modulation_ha)
farm_calculations["Obergrenze EUR/ha"] := cap_eur_ha(input.farm.year, "Regel")
farm_calculations["Maximale Teilzahlung EUR"] := advance_limit(input.farm.oepul.expected_payment_eur)
farm_calculations["Sanktionssatz Prozent"] := sanction_percent(input.farm.year, input.farm.oepul.assessed_stage)

gve_factor(category) := r if {
	some r in tabellen.gve
	r.category == category
}

stocking_class(rgve, forage_ha) := rgve >= (0.3 * forage_ha) if {
	is_number(rgve)
	rgve >= 0
	forage_ha > 0
}

drought_arable_area(state, district, y) if {
	y == 2026
	some r in tabellen.arable_drought_districts
	r.state == state
	r.district in {"*", district}
}

div_variant(code) := tabellen.div_variants[code]

# Gegenstand sind die in der allgemeinen Liste genannten Maßnahmen/Optionen.
measure_in_group(group, name) if {
	some row in tabellen.general_lists
	row.group == group
	row.entry == name
}

streuobst_eligible(e, y) if {
	point_eligible(e)
	e.kind == "Streuobstbaum"
	orchard_species_ok(e.species, y)
	e.tall_or_half_standard
	e.vigorous_large_crown
	e.shared_permanent_support == false
}

qualifying_point_elements[p.parcel_id] contains index if {
	some p in input.land.parcels
	p.bergmahd.enrolled
	some index, e in p.bergmahd.point_elements
	point_eligible(e)
}

farm_calculations["Übernahmefrist eingehalten"] := takeover_timely(input.farm.year, input.farm.oepul.takeover.date)
farm_calculations["Übernahmevoraussetzungen erfüllt"] if takeover_possible(input.farm.oepul.takeover, input.farm.year)

# Anerkannte Flächen- und Behördenentscheidungen bleiben bei der Rechtsfolgenprüfung eigenständig.
trial_records_ok(p) if {
	p.bergmahd.trial_prevents_compliance
	t := p.bergmahd.trial_documentation
	t.written_approval_available
	t.type_extent_location_recorded
	t.vf_declared
}

third_party_proof_ok(p) if {
	f := p.bergmahd.third_party_fault
	f.exclusive
	f.proof_available
	f.measure_op_declared
}

# SRL 1.12 sieht die Modulation vor der Obergrenze je Schlag vor.
# Die Eingabe umfasst alle obergrenzenrelevanten Beträge einschließlich LSE
# nach etwaigen inhaltlichen Kürzungen und vor der Modulation.
modulated_capped_eur(amount, ha, home_ha, year) := min([amount * modulation_factor(home_ha), ha * cap_eur_ha(year, "Regel")]) if {
	amount >= 0
	ha > 0
}

measure_name(code) := tabellen.matrix_measures[code]

farm_size_result if farm_size_ok

else := false if {
	input.farm.oepul.first_year == input.farm.year
	is_number(input.farm.oepul.protected_at_ha)
	is_number(input.farm.oepul.countable_at_ha)
	input.farm.oepul.protected_at_ha < 0.5
	input.farm.oepul.countable_at_ha < 1.5
}

else := null

farm_calculations["Betriebsmindestgröße erfüllt"] := farm_size_result

gain_prebound(y) := 0 if y in {2024, 2025}

else := input.farm.oepul.prebound_gain_ha

# Mögliche Rechtsfolgen aus dem Jahresnachweis, ohne vorgreifende Sanktionsstufe.
transfer_year_result(p) := "fortgeführt" if {
	t := p.bergmahd.transfer
	year_of(t.date) == input.farm.year
	t.continued_to_year_end
	t.successor_measure in {"4", "18", "19"}
}

else := "melden, OP, keine Jahresprämie" if {
	t := p.bergmahd.transfer
	year_of(t.date) == input.farm.year
	t.continued_to_year_end == false
}

parcel_procedure[p.parcel_id] := result if {
	some p in input.land.parcels
	p.bergmahd.enrolled
	result := transfer_year_result(p)
}
