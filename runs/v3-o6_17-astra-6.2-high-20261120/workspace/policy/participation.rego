package oepul.o6_17

import data.o17_tables as tab
import rego.v1

between_years(r, y) if {
	y >= r.first_year
	y <= r.last_year
}

below_upper(_, upper) if upper == null

below_upper(n, upper) if {
	is_number(upper)
	n < upper
}

contract_years(start) := row.years if {
	some row in tab.contract_terms
	row.start == start
}

in_term if {
	contract_years(input.farm.o6_17.start_year) > 0
	input.farm.year >= input.farm.o6_17.start_year
	input.farm.year <= 2028
}

date_ok(d) if is_number(time.parse_rfc3339_ns(sprintf("%sT00:00:00Z", [d])))

timely_application if {
	y := input.farm.o6_17.start_year
	contract_years(y) > 0
	d := input.farm.o6_17.application_date
	date_ok(d)
	d <= sprintf("%d-12-31", [y - 1])
}

companion if {
	some m in input.farm.o6_17.active_measures
	m in tab.companion_measures
}

first_year_land if {
	input.land.grassland_area_ha >= 2
	ln := input.land.agricultural_area_at_ha - input.land.alpine_pasture_area_ha
	ln >= input.land.grassland_area_ha
	100 * input.land.grassland_area_ha >= 40 * ln
}

# MFA-Flächen des laufenden Jahres. Umbruchsverbote oder andere Maßnahmen
# reduzieren den Futterflächennenner nicht.
forage(p) if {
	p.in_austrian_mfa
	p.land_use == "grassland"
}

forage(p) if {
	p.in_austrian_mfa
	p.land_use == "arable"
	some c in tab.forage_crops
	lower(p.crop.crop_name) == lower(c)
}

forage_area := sum([p.area_ha | some p in input.land.parcels; forage(p)]) if {
	is_array(input.land.parcels)
	every p in input.land.parcels {
		is_boolean(p.in_austrian_mfa)
		is_string(p.land_use)
		p.area_ha >= 0
		forage_data_present(p)
	}
}

forage_data_present(p) if p.land_use != "arable"
forage_data_present(p) if is_string(p.crop.crop_name)

cattle_class(breed) := "Zwergrind" if breed in tab.dwarf_breeds

else := "Rind" if is_string(breed)

animal_class(g) := cattle_class(g.breed) if g.kind == "Rind"
animal_class(g) := g.kind if g.kind in {"Schaf", "Ziege"}

animal_class(g) := "Equide klein" if {
	g.kind == "Equide"
	g.breed_height_m > 0
	g.breed_height_m <= 1.48
	g.breed_final_kg > 0
	g.breed_final_kg <= 300
}

animal_class(g) := "Equide groß" if {
	g.kind == "Equide"
	g.breed_height_m > 1.48
}

animal_class(g) := "Equide groß" if {
	g.kind == "Equide"
	g.breed_final_kg > 300
}

animal_class(g) := "Jungwild und junge Neuweltkamele" if {
	g.kind in {"Rotwild", "Damwild und anderes Zuchtwild", "Neuweltkamele"}
	g.age_years < 1
}

animal_class(g) := g.kind if {
	g.kind in {"Rotwild", "Damwild und anderes Zuchtwild", "Neuweltkamele"}
	g.age_years >= 1
}

group_rgve(g) := factor.rgve * g.reference_count if {
	g.in_austria
	g.kind != "Sonstige Nicht-RGVE"
	g.reference_count >= 0
	some factor in tab.rgve_factors
	factor.group == animal_class(g)
	g.age_years >= factor.min_age_years
	below_upper(g.age_years, factor.below_age_years)
}

group_rgve(g) := 0 if g.in_austria == false
group_rgve(g) := 0 if g.kind == "Sonstige Nicht-RGVE"

rgve_total := sum(values) if {
	groups := input.livestock.rgve_groups
	is_array(groups)
	values := [v | some g in groups; v := group_rgve(g)]
	count(values) == count(groups)
}

stocking_density := rgve_total / forage_area if forage_area > 0

# Jahresbezogene Zugangskriterien. In Folgejahren setzt die Bewertung einen
# tatsächlich wirksamen bestehenden Vertrag voraus.
annual_access if {
	in_term
	companion
	input.farm.year == input.farm.o6_17.start_year
	first_year_land
	stocking_density >= 0.3
}

annual_access if {
	in_term
	companion
	input.farm.year > input.farm.o6_17.start_year
	input.farm.o6_17.existing_contract
}

applicant_form_ok if {
	a := input.farm.applicant
	a.public_body_or_institution == false
	a.form in {"natürliche Person", "eingetragene Personengesellschaft"}
}

applicant_form_ok if {
	a := input.farm.applicant
	a.public_body_or_institution == false
	a.form in {"juristische Person", "Personenvereinigung"}
	a.public_share_percent >= 0
	a.public_share_percent <= 25
}

farm_size_ok if input.farm.year > input.farm.first_oepul_year

farm_size_ok if {
	input.farm.year == input.farm.first_oepul_year
	input.land.protected_cultivation_at_ha >= 0.5
}

farm_size_ok if {
	input.farm.year == input.farm.first_oepul_year
	input.land.oepul_minimum_area_at_ha >= 1.5
}

loss_tolerance(previous) := max([0.5, min([5, previous * 0.05])]) if previous >= 0
repayable_loss(previous, reduction) := reduction if reduction > loss_tolerance(previous)

else := 0 if {
	previous >= 0
	reduction >= 0
}

eligible_additions(y, base, new_ha, carried_ha) := new_ha + carried_ha if {
	y in {2024, 2025}
	new_ha >= 0
	carried_ha >= 0
} else := min([new_ha, max([5, base * 0.5])]) + carried_ha if {
	y >= 2026
	y <= 2028
	base >= 0
	new_ha >= 0
	carried_ha >= 0
}

takeover_window(y, d, transferred, additional) if {
	y >= 2023
	y <= 2028
	date_ok(d)
	startswith(d, sprintf("%d-", [y]))
	end := object.get({"2023": "04-17", "2028": "04-17"}, sprintf("%d", [y]), "04-15")
	d <= sprintf("%d-%s", [y, end])
	transferred > 0
	additional >= 0
	additional <= transferred * 0.5
}

applicant_ok if {
	applicant_form_ok
	a := input.farm.applicant
	a.own_name
	a.own_account
	a.disposal_rights
	a.active_farmer
	a.agricultural_activity
}

contract_basis if {
	in_term
	input.farm.o6_17.existing_contract
}

contract_basis if {
	in_term
	timely_application
}

contract_basis if {
	in_term
	t := input.farm.area_movements
	t.previously_participating == false
	t.takeover_approved
	takeover_window(input.farm.year, t.takeover_date, t.transferred_ha, t.additional_ha)
}

# Nur Zugangskriterien. Fachauflagen, Kontrollen und Auszahlung haben eigene Befunde.
access_requirements_met if {
	count(incompatible_pair) == 0
	annual_access
	contract_basis
	applicant_ok
	farm_size_ok
}

exclude_after_cuts if input.documentation.full_cuts_in_contract >= 2

area_movement_assessment := {
	"loss_tolerance_ha": loss_tolerance(m.previous_committed_ha),
	"repayable_loss_ha": repayable_loss(m.previous_committed_ha, m.reduction_without_exception_ha),
	"eligible_additions_and_transfers_ha": eligible_additions(input.farm.year, m.committed_2025_ha, m.cumulative_new_ha, m.carried_commitment_ha),
} if {
	m := input.farm.area_movements
}
