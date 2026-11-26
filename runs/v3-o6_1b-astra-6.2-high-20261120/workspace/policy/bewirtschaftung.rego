package oepul.o6_1b

import rego.v1

recognised_course(c) if {
	c.provider_recognised
	c.participant_eligible
	c.date >= "2022-01-01"
	c.date <= "2025-12-31"
	c.hours > 0
	c.person_retained_at_deadline
	c.allocated_to_this_farm
}

credited_hours(topic) := sum(hours) if {
	courses := input.documentation.bio_training
	is_array(courses)
	ids := {c.event_id | some c in courses; recognised_course(c)}
	all_ids := [c.event_id | some c in courses; recognised_course(c)]
	count(ids) == count(all_ids)
	hours := [c.hours | some c in courses; recognised_course(c); c.topic == topic]
}

training_met if {
	credited_hours("Biodiversität") >= 3
	credited_hours("Biologische Wirtschaftsweise") >= 5
}

# Der Kooperationspartner und der Kulturbereich sind betriebliche Angaben.
# Die Matrix in Anhang L beantwortet zusätzlich die Frage nach der Einzelfläche.
farm_combination_blocked(m, sector, bio_sector) if {
	m in {"1A", "2", "11", "12"}
	bio_sector == "whole"
	is_string(sector)
}

farm_combination_blocked(m, sector, bio_sector) if {
	m in {"1A", "2", "11", "12"}
	bio_sector in {"arable_grassland", "wine_fruit_hops"}
	sector == bio_sector
}

farm_combination_blocked("1C:NPF", _, bio_sector) if {
	year >= 2025
	bio_sector in {"whole", "arable_grassland"}
}

combination_conflicts contains m.measure if {
	some m in contract.parallel_measures
	farm_combination_blocked(m.measure, m.sector, contract.organic_sector)
}

full_mowing_count(p) := count([d | some d in p.oepul.uses; d.kind == "Mahd"; d.removed])

grass_annual_mowing_met(p) if {
	p.land_use == "grassland"
	some code in p.oepul.codes
	grass_variant(code)
	full_mowing_count(p) >= 1
}

altgrass_carryover_met(p) if {
	p.oepul.previous_altgrass
	p.oepul.control_lost
}

altgrass_carryover_met(p) if {
	p.oepul.previous_altgrass
	"DIVSZ" in p.oepul.codes
	p.oepul.same_location
}

altgrass_last_use_met(p) if {
	"DIVAGF" in p.oepul.codes
	grass_annual_mowing_met(p)
	every u in p.oepul.uses { u.date <= key_date(year, "08-15") }
	p.oepul.overwintered_growth
	p.oepul.prohibited_traffic_or_fertilisation == false
}

cleaning_exempt(p, u) if {
	year >= 2025
	p.oepul.first_claim_new_sowing
	u.kind == "Reinigungsschnitt"
	u.removed == false
}

post_grazing_exempt(u) if {
	u.immediate_after_grazing
	u.removed == false
	u.kind in {"Pflegemahd", "Häckseln"}
}

excused_grazing_care(u) if {
	year >= 2025
	post_grazing_exempt(u)
}

regular_arable_use(p, u) if {
	u.kind in {"Mahd", "Häckseln", "Weide", "Pflegemahd", "Reinigungsschnitt"}
	not cleaning_exempt(p, u)
	not excused_grazing_care(u)
}

problem_relief(p) if {
	some s in p.oepul.invasive_species
	problem_plant(s)
	bio_land.invasive_arable_div_ha * 100 > bio_land.arable_div_ha * 25
	p.oepul.invasive_evidence
}

arable_frequency_limit(p) := 3 if drought_relief(p)

else := 2

arable_frequency_met(p) if {
	p.land_use == "arable"
	"DIV" in p.oepul.codes
	not cross_project(p.oepul.codes)
	is_array(p.oepul.uses)
	every u in p.oepul.uses { valid_arable_kind(u.kind, year) }
	n := count([u | some u in p.oepul.uses; regular_arable_use(p, u)])
	n <= arable_frequency_limit(p)
	n + p.oepul.previous_year_counted_uses >= 1
}

early_arable_grazing_allowed(p) if {
	p.land_use == "arable"
	"DIV" in p.oepul.codes
	drought_relief(p)
}

standard_early_mown_area_ha := bio_land.arable_div_ha * 0.25

arable_removal_allowed(p) if {
	p.oepul.break_date >= first_allowed_break(p.oepul.original_sowing_year, p.oepul.winter_crop_or_cover_follows)
	p.oepul.mechanical_removal
}

arable_fallow_base_ha := min([arable * 0.20, bio_land.eligible_fallow_ha])
wild_brood_bonus_ha := min([20, bio_land.qualified_wild_brood_ha])

wild_brood_sowing_met(p) if {
	p.land_use == "arable"
	"WB" in p.oepul.codes
	p.oepul.double_row_spacing
	p.oepul.row_spacing_cm >= 20
	p.oepul.undersown == false
	p.oepul.cereal_percent >= 50
	p.oepul.crop_sowing_date < key_date(year, "03-15")
	is_string(p.oepul.crop_sowing_date)
}

grass_regional_management_met(p) if {
	p.land_use == "grassland"
	"DIVRS" in p.oepul.codes
	grass_annual_mowing_met(p)
	ordinary := [u | some u in p.oepul.uses; not grass_cleaning(p, u)]
	exported_clean := [u | some u in p.oepul.uses; grass_cleaning(p, u); u.removed]
	count(ordinary) + count(exported_clean) <= 2
	every u in ordinary { u.kind in {"Mahd", "Weide"}; u.date >= key_date(year, "07-15")}
	every u in p.oepul.uses { valid_grass_harvest(u) }
	every t in p.oepul.fertilisers { t in {"Festmist", "Festmistkompost"} }
}

grass_cleaning(p, u) if {
	p.oepul.first_claim_new_sowing
	u.kind == "Reinigungsschnitt"
}

valid_grass_harvest(u) if u.kind in {"Weide", "Reinigungsschnitt"}

valid_grass_harvest(u) if {
	u.kind == "Mahd"
	u.removed
}

arable_fallow_rs_management_met(p) if {
	year >= 2025
	p.land_use == "arable"
	"DIVRS" in p.oepul.codes
	p.oepul.use == "Grünbrache"
	is_array(p.oepul.uses)
	count(p.oepul.uses) <= 1
	count(p.oepul.uses) + p.oepul.previous_year_counted_uses >= 1
	every u in p.oepul.uses { authorised_rs_fallow_operation(p, u) }
}

authorised_rs_fallow_operation(_, u) if {
	u.kind == "Häckseln"
	u.date >= key_date(year, "10-01")
}

authorised_rs_fallow_operation(p, u) if cleaning_exempt(p, u)

arable_forage_rs_management_met(p) if {
	p.land_use == "arable"
	"DIVRS" in p.oepul.codes
	p.oepul.use == "Sonstiges Feldfutter"
	cuts := [u | some u in p.oepul.uses; u.removed]
	count(cuts) in {1, 2}
	every u in p.oepul.uses { forage_rs_use(p, u) }
}

forage_rs_use(_, u) if {
	u.kind == "Mahd"
	u.removed
}

forage_rs_use(p, u) if {
	u.kind == "Reinigungsschnitt"
	p.oepul.first_claim_new_sowing
}

# Für die Acker- und Grünlandquote anrechenbare Projekt- und Sonderflächen.
project_div_credit(p) if {
	p.land_use == "arable"
	"DIV" in p.oepul.codes
	"NAT" in p.oepul.codes
	p.oepul.use == "Grünbrache"
	"SA01" in p.oepul.project_codes
}

project_div_credit(p) if {
	p.land_use == "arable"
	"DIV" in p.oepul.codes
	"EBW" in p.oepul.codes
	p.oepul.use == "Grünbrache"
}

project_div_credit(p) if {
	p.land_use == "grassland"
	"DIVSZ" in p.oepul.codes
	some m in p.oepul.codes
	qualifying_project_code(m, p.oepul.project_codes)
}

project_div_credit(p) if {
	p.land_use == "grassland"
	"DIVSZ" in p.oepul.codes
	"EBW" in p.oepul.codes
	p.oepul.ebw_habitat_and_use_confirmed
	p.oepul.use in {"Einmähdige Wiese", "Mähwiese/-weide zwei Nutzungen"}
}

k20_excluded(p) if {
	p.land_use == "arable"
	"K20" in p.oepul.codes
}

training_deficit[topic] := max([0, hours - credited_hours(topic)]) if {
	some topic, hours in {"Biodiversität": 3, "Biologische Wirtschaftsweise": 5}
}

valid_arable_kind(kind, _) if kind in {"Mahd", "Häckseln", "Pflegemahd", "Reinigungsschnitt"}

valid_arable_kind("Weide", y) if y >= 2025

bio_code_required(p) if {
	contract.organic_sector in {"arable_grassland", "wine_fruit_hops"}
	p.oepul.organic_managed
	p.oepul.crop_sector == contract.organic_sector
}

bio_applicant_status_met if {
	contract.active_farmer
	contract.manages_on_own_account
	contract.public_authority_or_institution == false
}

# Kontrolle der jährlich gemeldeten Abschnitte, mit Zusammenführung mehrerer Begehungen.
indicator_density_met(p) if {
	p.land_use == "grassland"
	p.oepul.use == "Einmähdige Wiese"
}

indicator_density_met(p) if {
	p.land_use == "grassland"
	surveys := [r | some r in p.oepul.species_survey; startswith(r.date, sprintf("%d-", [year])); r.documented]
	sections := {r.strip | some r in surveys}
	count(sections) > 0
	every section in sections {
		names := {n | some r in surveys; r.strip == section; some n in r.indicator_groups}
		kennarten_count(names) >= 5
	}
}
