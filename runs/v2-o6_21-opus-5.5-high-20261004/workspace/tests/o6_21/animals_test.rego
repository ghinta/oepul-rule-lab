package oepul.o6_21.animals_test

import data.oepul.o6_21.animals
import data.oepul.o6_21.fixtures
import data.oepul.o6_21.lib
import data.oepul.o6_21.main

# --- RGVE ------------------------------------------------------------------------------------------

test_base_rgve_four_bulls_full_year if {
	animals.eligible_rgve == 2.4 with input as fixtures.base
}

test_slaughter_on_1_july_counted_pro_rata if {
	slaughtered := object.union(fixtures.bull("AT4", 520), {"on_farm_until": "2025-07-01"})
	inp := fixtures.with_animals(fixtures.base, [fixtures.bull("AT1", 520), fixtures.bull("AT2", 520), fixtures.bull("AT3", 520), slaughtered])

	# 182 Tage / 365 × 0,6 RGVE
	animals.eligible_animal_rgve.AT4 == 0.2992 with input as inp
	animals.eligible_rgve == 2.0992 with input as inp
}

test_animal_grows_into_category_pro_rata if {
	# männliches Kalb, geboren 1.3.2025: Kategorie ab ½ Jahr erst ab 1.9.2025 (122 Tage × 0,6 / 365)
	c := object.union(fixtures.bull("K1", 200), {"birth_date": "2025-03-01", "on_farm_from": "2025-03-01"})
	inp := fixtures.with_animals(fixtures.base, [c])
	animals.eligible_animal_rgve.K1 == 0.2005 with input as inp
}

test_male_over_two_years_counts_1_rgve if {
	old := object.union(fixtures.bull("AT1", 700), {"birth_date": "2022-01-01"})
	inp := fixtures.with_animals(fixtures.base, [old])
	animals.eligible_animal_rgve.AT1 == 1 with input as inp
}

test_female_category_ends_at_two_years if {
	heifer := {
		"ear_tag": "F1", "sex": "female", "birth_date": "2023-07-01", "on_farm_from": "2023-07-01",
		"on_farm_until": null, "current_weight_kg": 450, "stall_compartment_id": "B1",
	}
	m := {"categories": [{"category_id": "female_half_to_2_years", "applied_on": "2024-12-01", "first_year": 2025}]}
	inp := fixtures.with_measure(fixtures.with_animals(fixtures.base, [heifer]), m)

	# 1.1.–30.6.2025 = 181 Tage × 0,6 / 365
	animals.eligible_animal_rgve.F1 == 0.2975 with input as inp
}

test_dwarf_breed_factor if {
	dwarf := object.union(fixtures.bull("Z1", 300), {"is_dwarf_breed": true})
	inp := fixtures.with_animals(fixtures.base, [dwarf])
	animals.eligible_animal_rgve.Z1 == 0.3 with input as inp
}

# --- Abmeldung (Kapitel 6.5) ------------------------------------------------------------------------

test_deregistered_animal_gets_no_premium_in_any_category if {
	m := {
		"categories": [
			{"category_id": "male_lt_half_year", "applied_on": "2023-12-10", "first_year": 2024},
			{"category_id": "male_ge_half_year", "applied_on": "2023-12-10", "first_year": 2024},
		],
		"deregistered_animals": [{"ear_tag": "K1", "reported_on": "2025-10-01", "occasion": "switch_to_full_slatted_floor"}],
	}
	c := object.union(fixtures.bull("K1", 250), {"birth_date": "2025-03-01", "on_farm_from": "2025-03-01"})
	inp := fixtures.with_measure(fixtures.with_animals(fixtures.base, [c, fixtures.bull("AT1", 520)]), m)
	not animals.eligible_animal_rgve.K1 with input as inp
	animals.eligible_animal_rgve.AT1 == 0.6 with input as inp
}

slatted_calf := object.union(fixtures.bull("K1", 250), {
	"birth_date": "2025-01-01", "on_farm_from": "2025-01-01",
	"full_slatted_periods": [{"start": "2025-08-01", "end": "2025-12-31"}],
})

test_calf_moved_to_slatted_after_7_months_ok_if_only_lt_half_category if {
	m := {"categories": [{"category_id": "male_lt_half_year", "applied_on": "2023-12-10", "first_year": 2024}]}
	inp := fixtures.with_measure(fixtures.with_animals(fixtures.base, [slatted_calf]), m)
	not "full_slatted_floor" in animals.issues_of(slatted_calf) with input as inp
	not "K1" in animals.deregistration_required with input as inp
}

test_calf_moved_to_slatted_must_be_deregistered_if_ge_half_category if {
	m := {"categories": [
		{"category_id": "male_lt_half_year", "applied_on": "2023-12-10", "first_year": 2024},
		{"category_id": "male_ge_half_year", "applied_on": "2023-12-10", "first_year": 2024},
	]}
	inp := fixtures.with_measure(fixtures.with_animals(fixtures.base, [slatted_calf]), m)
	"K1" in animals.deregistration_required with input as inp
	"K1" in animals.missing_deregistrations with input as inp
	not animals.eligible_animal_rgve.K1 with input as inp
	{"rule_id": "O6_21-REP-01", "code": "missing_deregistration", "ear_tag": "K1"} in main.violations with input as inp
}

test_tethering_requires_deregistration if {
	t := object.union(fixtures.bull("AT1", 520), {"tethering_periods": [{"start": "2025-02-01", "end": "2025-02-20"}]})
	inp := fixtures.with_animals(fixtures.base, [t])
	"AT1" in animals.deregistration_required with input as inp
}

test_sick_individual_housing_up_to_10_days_keeps_premium if {
	s := object.union(fixtures.bull("AT1", 520), {"individual_housing_periods": [{"start": "2025-02-01", "end": "2025-02-10", "reason": "illness", "bedded": true, "documented": true}]})
	inp := fixtures.with_animals(fixtures.base, [s])
	animals.eligible_animal_rgve.AT1 == 0.6 with input as inp
}

test_sick_individual_housing_11_days_requires_deregistration if {
	s := object.union(fixtures.bull("AT1", 520), {"individual_housing_periods": [{"start": "2025-02-01", "end": "2025-02-11", "reason": "illness", "bedded": true, "documented": true}]})
	inp := fixtures.with_animals(fixtures.base, [s])
	"AT1" in animals.deregistration_required with input as inp
}

test_sick_individual_housing_undocumented_is_violation if {
	s := object.union(fixtures.bull("AT1", 520), {"individual_housing_periods": [{"start": "2025-02-01", "end": "2025-02-05", "reason": "injury", "bedded": true, "documented": false}]})
	inp := fixtures.with_animals(fixtures.base, [s])
	{"rule_id": "O6_21-GROUP-02", "code": "individual_housing_not_documented", "ear_tag": "AT1"} in main.violations with input as inp
}

calf_with_individual_period(end) := object.union(fixtures.bull("K1", 60), {
	"birth_date": "2025-03-01", "on_farm_from": "2025-03-01",
	"individual_housing_periods": [{"start": "2025-03-01", "end": end, "reason": "calf_under_21_days", "bedded": true, "social_contact": true}],
})

test_calf_under_21_days_individual_housing_allowed if {
	m := {"categories": [{"category_id": "male_lt_half_year", "applied_on": "2023-12-10", "first_year": 2024}]}
	c := calf_with_individual_period("2025-03-20")
	inp := fixtures.with_measure(fixtures.with_animals(fixtures.base, [c]), m)
	count(animals.issues_of(c)) == 0 with input as inp
}

test_calf_individual_housing_beyond_21_days_not_allowed if {
	m := {"categories": [{"category_id": "male_lt_half_year", "applied_on": "2023-12-10", "first_year": 2024}]}
	c := calf_with_individual_period("2025-03-25")
	inp := fixtures.with_measure(fixtures.with_animals(fixtures.base, [c]), m)
	"calf_individual_housing_too_old" in animals.issues_of(c) with input as inp
}

# --- Teilnahmefähigkeit -------------------------------------------------------------------------

heifer_calf := {
	"ear_tag": "F1", "sex": "female", "birth_date": "2024-10-01", "on_farm_from": "2024-10-01",
	"on_farm_until": null, "current_weight_kg": 300, "stall_compartment_id": "B1",
}

test_milk_delivery_excludes_female_half_to_two_years if {
	m := {"categories": [{"category_id": "female_half_to_2_years", "applied_on": "2024-12-01", "first_year": 2025}]}
	inp := json.patch(
		fixtures.with_measure(fixtures.with_animals(fixtures.base, [heifer_calf]), m),
		[{"op": "replace", "path": "/farm/dairy/milk_delivery_to_dairy", "value": true}],
	)
	not animals.eligible_animal_rgve.F1 with input as inp
	{"rule_id": "O6_21-ELIG-04", "code": "milk_delivery_excludes_female_half_to_2_years"} in main.violations with input as inp
}

test_seasonal_alpine_milk_delivery_also_excludes if {
	m := {"categories": [{"category_id": "female_half_to_2_years", "applied_on": "2024-12-01", "first_year": 2025}]}
	inp := json.patch(
		fixtures.with_measure(fixtures.with_animals(fixtures.base, [heifer_calf]), m),
		[{"op": "add", "path": "/farm/dairy/seasonal_alpine_milk_delivery", "value": true}],
	)
	animals.milk_delivery with input as inp
	not animals.eligible_animal_rgve.F1 with input as inp
}

test_animal_kept_abroad_not_eligible if {
	abroad := object.union(fixtures.bull("AT1", 520), {"kept_in_austria": false})
	inp := fixtures.with_animals(fixtures.base, [abroad])
	not animals.eligible_animal_rgve.AT1 with input as inp
}

test_animal_not_determined_at_control_not_eligible if {
	missing := object.union(fixtures.bull("AT1", 520), {"determined_at_control": false})
	inp := fixtures.with_animals(fixtures.base, [missing])
	not animals.eligible_animal_rgve.AT1 with input as inp
}

test_year_round_outdoor_animal_not_eligible if {
	outdoor := object.union(fixtures.bull("AT1", 520), {"year_round_outdoor_without_stall": true, "stall_compartment_id": null})
	inp := fixtures.with_animals(fixtures.base, [outdoor])
	not animals.eligible_animal_rgve.AT1 with input as inp
}

test_female_animal_not_in_male_category if {
	inp := fixtures.with_animals(fixtures.base, [heifer_calf])
	count(animals.participating_categories(heifer_calf)) == 0 with input as inp
}

# --- Prämiensätze je Tier -------------------------------------------------------------------------

test_reduced_rate_for_pasture_measure_animal if {
	p := object.union(fixtures.bull("AT1", 520), {"pasture_measure_o6_20": true})
	inp := fixtures.with_animals(fixtures.base, [p, fixtures.bull("AT2", 520)])
	animals.animal_premium.AT1 == 97.2 with input as inp
	animals.animal_premium.AT2 == 116.64 with input as inp
}

test_reduced_rate_for_alpine_and_coupled_support if {
	a1 := object.union(fixtures.bull("AT1", 520), {"alpine_pasture_measure_premium": true})
	a2 := object.union(fixtures.bull("AT2", 520), {"coupled_support_alpine": true})
	inp := fixtures.with_animals(fixtures.base, [a1, a2])
	animals.animal_rate_id(a1) == "reduced_overlap" with input as inp
	animals.animal_rate_id(a2) == "reduced_overlap" with input as inp
}

test_rate_2023_standard if {
	inp := json.patch(fixtures.base, [
		{"op": "replace", "path": "/farm/year", "value": 2023},
		{"op": "replace", "path": "/farm/programmes/animal_health_service_cattle", "value": fixtures.full_year(2023)},
		{"op": "replace", "path": "/oepul_measures/o6_21/categories/0", "value": {"category_id": "male_ge_half_year", "applied_on": "2022-12-10", "first_year": 2023}},
	])
	b := object.union(fixtures.bull("AT1", 520), {"birth_date": "2022-01-01", "on_farm_from": "2022-01-01"})
	animals.animal_premium.AT1 == 108 with input as fixtures.with_animals(inp, [b])
}

# --- Erlöschen von Kategorien ------------------------------------------------------------------

test_category_without_eligible_animal_lapses if {
	m := {"categories": [
		{"category_id": "male_ge_half_year", "applied_on": "2023-12-10", "first_year": 2024},
		{"category_id": "female_lt_half_year", "applied_on": "2023-12-10", "first_year": 2024},
	]}
	inp := fixtures.with_measure(fixtures.base, m)
	animals.categories_lapsing == {"female_lt_half_year"} with input as inp
	{"rule_id": "O6_21-APP-06", "code": "category_lapses_after_year", "category_id": "female_lt_half_year"} in main.notices with input as inp
}

test_force_majeure_excuses_noncompliance if {
	t := object.union(fixtures.bull("AT1", 520), {
		"tethering_periods": [{"start": "2025-02-01", "end": "2025-02-20"}],
		"noncompliance_force_majeure_event_id": "FM1",
	})
	m := {
		"categories": [{"category_id": "male_ge_half_year", "applied_on": "2023-12-10", "first_year": 2024}],
		"force_majeure_events": [{"event_id": "FM1", "case_id": "official_disease_orders", "able_to_report_from": "2025-02-01", "reported_on": "2025-02-15", "documented": true}],
	}
	inp := fixtures.with_measure(fixtures.with_animals(fixtures.base, [t]), m)
	not "AT1" in animals.deregistration_required with input as inp
	lib.year == 2025 with input as inp
}
