package oepul.o6_14

import rego.v1

farm := object.get(input, "farm", {})
land := object.get(input, "land", {})
livestock := object.get(input, "livestock", {})
documentation := object.get(input, "documentation", {})
preferences := object.get(input, "preferences_constraints", {})

alms := object.get(land, "alpine_pastures", [])
animals := object.get(livestock, "alpine_movements", [])
options := object.get(preferences, "oepul_options", {})
naturschutz_option := object.get(options, "naturschutz_auf_der_alm", false)
almweideplan_option := object.get(options, "almweideplan", false)
reports := object.get(documentation, "oepul_reports", {})
year := object.get(farm, "year", 0)
participate := object.get(preferences, "oepul_participation_requested", false)
first_participation_year := object.get(preferences, "oepul_first_participation_year", false)
contract_start_year := object.get(preferences, "oepul_contract_start_year", 0)

default eligible := false

eligible if {
	participate
	count(alms) > 0
	count(animals) > 0
	first_year_conditions
	all_alms_are_domestic
	all_animals_are_domestic
	all_alms_density_compliant
	all_animals_meet_minimum_days
	animal_species_eligible
	not incompatible_options
	no_prohibited_practices
	naturschutz_compliant
	almweideplan_compliant
	reporting_compliant
}

first_year_conditions if {
	not first_participation_year
}

first_year_conditions if {
	first_participation_year
	total_area >= 3
	total_eligible_rgve >= 3
}

total_area := sum([alm.area_ha | alm := alms[_]])

total_eligible_rgve := sum([animal.gve | animal := animals[_]; animal.alpung_days >= 60])

all_alms_are_domestic if {
	not some_alm_is_foreign
}

some_alm_is_foreign if {
	alm := alms[_]
	alm.is_in_austria != true
}

all_animals_are_domestic if {
	not some_animal_is_foreign
}

some_animal_is_foreign if {
	animal := animals[_]
	animal.is_held_in_austria != true
}

all_animals_meet_minimum_days if {
	not animal_shorter_than_60_days
	all_alm_stocking_days_compliant
}

animal_shorter_than_60_days if {
	animal := animals[_]
	animal.alpung_days < 60
}

minimum_alm_stocking_days[alm.alm_id] := sum([animal.alpung_days | animal := animals[_]; animal.alm_id == alm.alm_id]) if {
	alm := alms[_]
}

alm_stocking_day_violation[alm.alm_id] if {
	alm := alms[_]
	minimum_alm_stocking_days[alm.alm_id] < 60
}

all_alm_stocking_days_compliant if {
	not some_alm_stocking_violation
}

some_alm_stocking_violation if {
	alm_stocking_day_violation[_]
}

alm_rgve[alm.alm_id] := total if {
	alm := alms[_]
	total := sum([animal.gve | animal := animals[_]; animal.alm_id == alm.alm_id; animal.alpung_days >= 60])
}

alm_density[alm.alm_id] := density if {
	alm := alms[_]
	density := alm_rgve[alm.alm_id] / alm.area_ha
}

alm_density_limit(_) := 1.5 if {
	naturschutz_option == true
}

alm_density_limit(alm) := 2.4 if {
	naturschutz_option != true
	almweideplan_option == true
	object.get(object.get(alm, "almweideplan", {}), "strong_intensity", false) == true
	object.get(object.get(alm, "almweideplan", {}), "strong_intensity_reason", "") != ""
}

alm_density_limit(_) := 2.0 if {
	naturschutz_option != true
	not almweideplan_option == true
}

alm_density_limit(alm) := 2.0 if {
	naturschutz_option != true
	almweideplan_option == true
	not object.get(object.get(alm, "almweideplan", {}), "strong_intensity", false) == true
}

alm_density_violation[alm.alm_id] if {
	alm := alms[_]
	alm_density[alm.alm_id] > alm_density_limit(alm)
}

all_alms_density_compliant if {
	not some_alm_density_violation
}

some_alm_density_violation if {
	alm_density_violation[_]
}

incompatible_options if {
	naturschutz_option == true
	almweideplan_option == true
}

no_prohibited_practices if {
	feed_compliant
	pesticide_compliant
	fertilizer_compliant
}

feed_compliant if {
	not some_alm_feed_violation
}

some_alm_feed_violation if {
	alm := alms[_]
	feed := object.get(alm, "feed_practices", {})
	feed.natural_fodder_sufficient != true
}

some_alm_feed_violation if {
	alm := alms[_]
	feed := object.get(alm, "feed_practices", {})
	feed.non_alpine_silage_or_green_fodder == true
}

some_alm_feed_violation if {
	alm := alms[_]
	feed := object.get(alm, "feed_practices", {})
	feed.own_alpine_silage == true
	feed.own_alpine_silage_fed_on_same_alm != true
}

pesticide_compliant if {
	not some_alm_pesticide_violation
}

some_alm_pesticide_violation if {
	alm := alms[_]
	inputs := object.get(alm, "alm_inputs", {})
	inputs.pesticide_used == true
	inputs.pesticide_bio_only != true
}

fertilizer_compliant if {
	not some_alm_fertilizer_violation
}

some_alm_fertilizer_violation if {
	alm := alms[_]
	inputs := object.get(alm, "alm_inputs", {})
	inputs.fertilizer_used == true
	inputs.fertilizer_bio_allowed != true
}

some_alm_fertilizer_violation if {
	alm := alms[_]
	inputs := object.get(alm, "alm_inputs", {})
	inputs.non_alpine_slurry_or_liquid_manure == true
}

some_alm_fertilizer_violation if {
	alm := alms[_]
	inputs := object.get(alm, "alm_inputs", {})
	inputs.sewage_sludge == true
}

some_alm_fertilizer_violation if {
	alm := alms[_]
	inputs := object.get(alm, "alm_inputs", {})
	inputs.separated_home_farm_slurry_solids == true
}

contract_end_year := 2028

contract_years := 2029 - contract_start_year if {
	contract_start_year >= 2023
	contract_start_year <= 2025
}

contract_years := 1 if {
	almweideplan_option == true
}

recognized_animal_species := {"cattle", "sheep", "goats", "equines", "camelids"}
rgve_factors := data.o6_14.rgve_factors
annex_e_footnotes := data.o6_14.annex_e_footnotes

animal_species_eligible if {
	not some_ineligible_species
}

some_ineligible_species if {
	animal := animals[_]
	not animal.species in recognized_animal_species
}

eligible_animals[animal.animal_id] := animal if {
	animal := animals[_]
	animal.alpung_days >= 60
}

days_counting_rule := {
	"arrival_day_included": true,
	"departure_day_included": false,
	"interruptions_count": false,
}

reporting_rules := {
	"cattle": {"arrival_days": 14, "departure_days": 14, "late_credit_days": 14},
	"sheep_goats": {"arrival_days": 7, "departure_days": 7, "late_credit_days": 7},
	"equines_camelids": {"arrival_days": 7, "departure_days": 7, "late_credit_days": 7},
}

reporting_compliant if {
	reports.cattle_arrival_days <= 14
	reports.cattle_departure_days <= 14
	reports.other_arrival_days <= 7
	reports.other_departure_days <= 7
}

naturschutz_compliant if {
	naturschutz_option != true
}

naturschutz_compliant if {
	naturschutz_option == true
	not some_naturschutz_violation
}

some_naturschutz_violation if {
	alm := alms[_]
	ns := object.get(alm, "naturschutz", {})
	ns.project_confirmation_for_all_parcels != true
}

some_naturschutz_violation if {
	alm := alms[_]
	ns := object.get(alm, "naturschutz", {})
	ns.sensitive_area_fertilizer_free != true
}

some_naturschutz_violation if {
	alm := alms[_]
	ns := object.get(alm, "naturschutz", {})
	ns.no_terrain_correction != true
}

some_naturschutz_violation if {
	alm := alms[_]
	ns := object.get(alm, "naturschutz", {})
	ns.no_new_drainage != true
}

some_naturschutz_violation if {
	alm := alms[_]
	ns := object.get(alm, "naturschutz", {})
	ns.troughs_not_in_wetlands != true
}

some_naturschutz_violation if {
	alm := alms[_]
	course := object.get(object.get(alm, "naturschutz", {}), "course", {})
	course.hours < 4
}

some_naturschutz_violation if {
	alm := alms[_]
	course := object.get(object.get(alm, "naturschutz", {}), "course", {})
	course.completed_by > "2025-12-31"
}

some_naturschutz_violation if {
	alm := alms[_]
	course := object.get(object.get(alm, "naturschutz", {}), "course", {})
	course.relevant_content != true
}

some_naturschutz_violation if {
	alm := alms[_]
	course := object.get(object.get(alm, "naturschutz", {}), "course", {})
	course.recognized_provider != true
}

almweideplan_compliant if {
	almweideplan_option != true
}

almweideplan_compliant if {
	almweideplan_option == true
	not some_almweideplan_violation
}

some_almweideplan_violation if {
	alm := alms[_]
	plan := object.get(alm, "almweideplan", {})
	plan.plan_for_all_alms != true
}

some_almweideplan_violation if {
	alm := alms[_]
	plan := object.get(alm, "almweideplan", {})
	plan.course.hours < 4
}

some_almweideplan_violation if {
	alm := alms[_]
	plan := object.get(alm, "almweideplan", {})
	plan.course.relevant_content != true
}

some_almweideplan_violation if {
	alm := alms[_]
	plan := object.get(alm, "almweideplan", {})
	plan.course.recognized_provider != true
}

some_almweideplan_violation if {
	alm := alms[_]
	plan := object.get(alm, "almweideplan", {})
	plan.plan_created_by_deadline != true
}

some_almweideplan_violation if {
	alm := alms[_]
	plan := object.get(alm, "almweideplan", {})
	plan.contains_required_assessment != true
}

some_almweideplan_violation if {
	alm := alms[_]
	plan := object.get(alm, "almweideplan", {})
	plan.communicated_to_workers != true
}

application_deadline_met if {
	documentation.oepul_application_date <= sprintf("%d-12-31", [year - 1])
}

field_list_deadline_met if {
	year != 2023
	year != 2028
	documentation.oepul_field_list_date <= sprintf("%d-04-15", [year])
}

field_list_deadline_met if {
	year == 2023
	documentation.oepul_field_list_date <= "2023-04-17"
}

field_list_deadline_met if {
	year == 2028
	documentation.oepul_field_list_date <= "2028-04-17"
}

stocking_list_deadline_met if {
	year != 2023
	year != 2028
	documentation.oepul_stocking_list_date <= sprintf("%d-07-15", [year])
}

stocking_list_deadline_met if {
	year == 2023
	documentation.oepul_stocking_list_date <= "2023-07-17"
}

stocking_list_deadline_met if {
	year == 2028
	documentation.oepul_stocking_list_date <= "2028-07-17"
}

payment_application := "Alm/Gemeinschaftsweide-Auftriebsliste or Alm-/Weidemeldung Rinder"

stocking_list_waiver if {
	documentation.oepul_only_cattle == true
	all_alms_stage_one
	documentation.oepul_participates_tierwohl_behirtung != true
	not some_strong_almweideplan
}

all_alms_stage_one if {
	not some_non_stage_one_alm
}

some_non_stage_one_alm if {
	alm := alms[_]
	alm.access_stage != "stage_1"
}

some_strong_almweideplan if {
	alm := alms[_]
	object.get(object.get(alm, "almweideplan", {}), "strong_intensity", false) == true
}

nata_required if {
	naturschutz_option == true
}

premium_area[alm.alm_id] := min([alm.area_ha, alm_rgve[alm.alm_id]]) if {
	alm := alms[_]
}

premium_base[alm.alm_id] := value if {
	alm := alms[_]
	area := premium_area[alm.alm_id]
	rate := data.o6_14.rates.almweide[alm.access_stage][sprintf("%d", [year])]
	value := area * rate
}

naturschutz_codes[code] if {
	alm := alms[_]
	code_object := object.get(object.get(alm, "naturschutz", {}), "project_codes", [])[_]
	code := code_object.code
}

naturschutz_code_premium_per_ha := sum([data.o6_14.naturschutz_code_rates[code] | naturschutz_codes[code]])

naturschutz_base_premium_per_ha := data.o6_14.rates.naturschutz_base[sprintf("%d", [year])] if {
	naturschutz_option == true
}

almweideplan_premium[alm.alm_id] := value if {
	alm := alms[_]
	almweideplan_option == true
	value := min([20, premium_area[alm.alm_id]]) * data.o6_14.rates.almweideplan[sprintf("%d", [year])]
}

premium_base_total := sum([premium_base[id] | id := object.keys(premium_base)[_]])
modulation_basis := min([total_area, total_eligible_rgve])

modulation_factor := 1.0 if {
	modulation_basis <= 200
}

modulation_factor := (200 + ((modulation_basis - 200) * 0.9)) / modulation_basis if {
	modulation_basis > 200
	modulation_basis <= 300
}

modulation_factor := ((200 + (100 * 0.9)) + ((modulation_basis - 300) * 0.85)) / modulation_basis if {
	modulation_basis > 300
	modulation_basis <= 1000
}

modulation_factor := (((200 + (100 * 0.9)) + (700 * 0.85)) + ((modulation_basis - 1000) * 0.75)) / modulation_basis if {
	modulation_basis > 1000
}

modulated_premium_total := premium_base_total * modulation_factor

rego_symbols := {
	"eligible": eligible,
	"alm_density": alm_density,
	"premium_base": premium_base,
	"modulation_factor": modulation_factor,
	"reporting_rules": reporting_rules,
	"days_counting_rule": days_counting_rule,
}
