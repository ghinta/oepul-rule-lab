package oepul.o6_21.application_eligibility_test

import data.oepul.o6_21.application
import data.oepul.o6_21.eligibility
import data.oepul.o6_21.fixtures
import data.oepul.o6_21.main
import data.oepul.o6_21.premium

cat(id, applied_on, first_year) := {"category_id": id, "applied_on": applied_on, "first_year": first_year}

# --- Beantragung und Vertragszeitraum --------------------------------------------------------------

test_category_valid_with_timely_application if {
	application.valid_categories == {"male_ge_half_year"} with input as fixtures.base
}

test_category_application_after_31_december_is_late if {
	inp := fixtures.with_measure(fixtures.base, {"categories": [cat("male_ge_half_year", "2025-01-05", 2025)]})
	count(application.valid_categories) == 0 with input as inp
	{"rule_id": "O6_21-APP-01", "code": "late_category_application", "category_id": "male_ge_half_year"} in main.violations with input as inp
}

test_automatic_renewal_in_following_years if {
	inp := fixtures.with_year(fixtures.base, 2027)
	"male_ge_half_year" in application.valid_categories with input as inp
}

test_last_entry_categories_2027 if {
	ok := fixtures.with_year(fixtures.with_measure(fixtures.base, {"categories": [cat("male_ge_half_year", "2026-12-31", 2027)]}), 2027)
	"male_ge_half_year" in application.valid_categories with input as ok
	late := fixtures.with_year(fixtures.with_measure(fixtures.base, {"categories": [cat("male_ge_half_year", "2027-12-20", 2028)]}), 2028)
	count(application.valid_categories) == 0 with input as late
	{"rule_id": "O6_21-APP-03", "code": "category_entry_after_last_entry_year", "category_id": "male_ge_half_year"} in main.violations with input as late
}

test_last_entry_supplement_2028 if {
	m := {
		"categories": [cat("male_ge_half_year", "2023-12-10", 2024)],
		"composting_supplement": {"applied_on": "2027-12-31", "first_year": 2028},
	}
	inp := fixtures.with_year(fixtures.with_measure(fixtures.base, m), 2028)
	application.supplement_valid with input as inp
	m2 := object.union(m, {"composting_supplement": {"applied_on": "2028-12-31", "first_year": 2029}})
	inp2 := fixtures.with_year(fixtures.with_measure(fixtures.base, m2), 2029)
	not application.supplement_valid with input as inp2
}

test_supplement_requires_valid_category if {
	m := {"categories": [], "composting_supplement": {"applied_on": "2024-12-10", "first_year": 2025}}
	inp := fixtures.with_measure(fixtures.base, m)
	not application.supplement_valid with input as inp
}

test_exit_during_year_invalidates_that_year if {
	m := {
		"categories": [cat("male_ge_half_year", "2023-12-10", 2024)],
		"exits": [{"scope": "measure", "declared_on": "2025-06-01"}],
	}
	inp := fixtures.with_measure(fixtures.base, m)
	count(application.valid_categories) == 0 with input as inp
	premium.net_amount == 0 with input as inp
}

test_exit_in_previous_year_ends_contract_from_that_year if {
	m := {
		"categories": [cat("male_ge_half_year", "2023-12-10", 2024)],
		"exits": [{"scope": "category", "category_id": "male_ge_half_year", "declared_on": "2026-01-10"}],
	}
	inp := fixtures.with_measure(fixtures.base, m)
	"male_ge_half_year" in application.valid_categories with input as inp
	count(application.valid_categories) == 0 with input as fixtures.with_year(inp, 2026)
}

test_exit_after_control_announcement_is_ineffective if {
	m := {
		"categories": [cat("male_ge_half_year", "2023-12-10", 2024)],
		"exits": [{"scope": "measure", "declared_on": "2025-06-10"}],
		"control_announced_on": "2025-06-01",
	}
	inp := fixtures.with_measure(fixtures.base, m)
	"male_ge_half_year" in application.valid_categories with input as inp
	count(application.exits_ineffective_after_control) == 1 with input as inp
}

test_reentry_after_exit_requires_new_application if {
	m := {
		"categories": [
			cat("male_ge_half_year", "2023-12-10", 2024),
			cat("male_ge_half_year", "2026-11-30", 2027),
		],
		"exits": [{"scope": "measure", "declared_on": "2026-01-10"}],
	}
	inp := fixtures.with_measure(fixtures.base, m)
	count(application.valid_categories) == 0 with input as fixtures.with_year(inp, 2026)
	"male_ge_half_year" in application.valid_categories with input as fixtures.with_year(inp, 2027)
}

test_lapsed_category_not_valid_next_year if {
	m := {"categories": [object.union(cat("male_ge_half_year", "2023-12-10", 2024), {"lapsed_after_year": 2024})]}
	inp := fixtures.with_measure(fixtures.base, m)
	count(application.valid_categories) == 0 with input as inp
}

test_late_reentry_via_correction_and_request_accepted if {
	entry := object.union(cat("male_ge_half_year", "2025-01-20", 2025), {
		"late_reentry_correction_submitted": true,
		"late_reentry_written_request_submitted": true,
		"late_reentry_accepted": true,
	})
	inp := fixtures.with_measure(fixtures.base, {"categories": [entry]})
	"male_ge_half_year" in application.valid_categories with input as inp
}

test_takeover_only_on_dissolution_division_or_merger if {
	m := {
		"categories": [cat("male_ge_half_year", "2023-12-10", 2024)],
		"takeover": {"is_takeover": true, "reason": "other", "animals_and_areas_from_same_previous_holding": true},
	}
	inp := fixtures.with_measure(fixtures.base, m)
	"takeover_not_permitted" in eligibility.access_issues with input as inp
	m2 := object.union(m, {"takeover": {"is_takeover": true, "reason": "farm_division", "animals_and_areas_from_same_previous_holding": true}})
	not "takeover_not_permitted" in eligibility.access_issues with input as fixtures.with_measure(fixtures.base, m2)
}

test_takeover_requires_same_previous_holding if {
	m := {
		"categories": [cat("male_ge_half_year", "2023-12-10", 2024)],
		"takeover": {"is_takeover": true, "reason": "farm_merger", "animals_and_areas_from_same_previous_holding": false},
	}
	"takeover_not_permitted" in eligibility.access_issues with input as fixtures.with_measure(fixtures.base, m)
}

test_replaced_category_still_binding_without_deregistration if {
	m := {"categories": [
		object.union(cat("male_ge_half_year", "2023-12-10", 2024), {"replaced_by_category_id": "male_lt_half_year"}),
		cat("male_lt_half_year", "2024-12-10", 2025),
	]}
	inp := fixtures.with_measure(fixtures.base, m)
	"male_ge_half_year" in application.replaced_categories_still_binding with input as inp
}

# --- Mindestteilnahme, TGD, Qplus -----------------------------------------------------------------

test_min_participation_2_rgve_met if {
	eligibility.min_participation_met with input as fixtures.base
}

test_min_participation_not_met_blocks_premium if {
	inp := fixtures.with_animals(fixtures.base, [fixtures.bull("AT1", 520), fixtures.bull("AT2", 520), fixtures.bull("AT3", 520)])
	"min_participation_not_met" in eligibility.access_issues with input as inp
	eligibility.contract_lapses with input as inp
	premium.net_amount == 0 with input as inp
}

bulls(n) := [fixtures.bull(sprintf("AT%d", [i]), 520) | some i in numbers.range(1, n)]

test_animal_health_service_not_required_at_exactly_10_rgve if {
	inp := json.patch(fixtures.with_animals(fixtures.base, bulls(17)), [{"op": "remove", "path": "/farm/programmes/animal_health_service_cattle"}])

	# 17 × 0,6 = 10,2 RGVE → erforderlich; 16 × 0,6 = 9,6 → nicht erforderlich
	eligibility.animal_health_service_required with input as inp
	"animal_health_service_missing" in eligibility.access_issues with input as inp
	inp16 := json.patch(fixtures.with_animals(fixtures.base, bulls(16)), [{"op": "remove", "path": "/farm/programmes/animal_health_service_cattle"}])
	not eligibility.animal_health_service_required with input as inp16
}

test_animal_health_service_must_cover_full_year if {
	inp := json.patch(fixtures.with_animals(fixtures.base, bulls(20)), [{
		"op": "replace", "path": "/farm/programmes/animal_health_service_cattle",
		"value": {"participating": true, "from": "2025-03-01", "until": "2025-12-31"},
	}])
	"animal_health_service_missing" in eligibility.access_issues with input as inp
}

female_measure := {"categories": [
	cat("male_ge_half_year", "2023-12-10", 2024),
	cat("female_lt_half_year", "2023-12-10", 2024),
]}

test_qplus_required_for_female_categories if {
	inp := fixtures.with_measure(fixtures.base, female_measure)
	"quality_programme_missing" in eligibility.access_issues with input as inp
	inp2 := fixtures.set_path(inp, "/farm/programmes/quality_programme_female_cattle", object.union(fixtures.full_year(2025), {"programme": "Qplus Rind"}))
	not "quality_programme_missing" in eligibility.access_issues with input as inp2
}

test_qplus_other_programme_not_accepted if {
	inp := fixtures.set_path(
		fixtures.with_measure(fixtures.base, female_measure),
		"/farm/programmes/quality_programme_female_cattle",
		object.union(fixtures.full_year(2025), {"programme": "Sonstiges Programm"}),
	)
	"quality_programme_missing" in eligibility.access_issues with input as inp
}

test_2023_participation_from_15_april_sufficient if {
	m := {"categories": [cat("female_lt_half_year", "2022-12-10", 2023)]}
	inp := fixtures.set_path(
		fixtures.with_year(fixtures.with_measure(fixtures.base, m), 2023),
		"/farm/programmes/quality_programme_female_cattle",
		{"programme": "Qplus Rind", "participating": true, "from": "2023-04-15", "until": "2023-12-31"},
	)
	eligibility.quality_programme_ok with input as inp
	inp24 := fixtures.set_path(
		fixtures.with_year(fixtures.with_measure(fixtures.base, m), 2024),
		"/farm/programmes/quality_programme_female_cattle",
		{"programme": "Qplus Rind", "participating": true, "from": "2024-04-15", "until": "2024-12-31"},
	)
	not eligibility.quality_programme_ok with input as inp24
}

# --- Betriebsmindestgröße und allgemeine Pflichten -----------------------------------------------

test_farm_min_size_in_first_oepul_year if {
	inp := json.patch(fixtures.base, [
		{"op": "add", "path": "/farm/oepul_first_participation_year", "value": 2025},
		{"op": "replace", "path": "/land/total_area_ha", "value": 1.2},
	])
	"farm_min_size_not_met" in eligibility.access_issues with input as inp
	{"rule_id": "O6_21-ELIG-05", "code": "farm_min_size_not_met"} in main.violations with input as inp
	inp_ok := json.patch(inp, [{"op": "replace", "path": "/land/total_area_ha", "value": 1.5}])
	not "farm_min_size_not_met" in eligibility.access_issues with input as inp_ok
}

test_farm_min_size_not_required_from_second_oepul_year if {
	inp := json.patch(fixtures.base, [
		{"op": "add", "path": "/farm/oepul_first_participation_year", "value": 2023},
		{"op": "replace", "path": "/land/total_area_ha", "value": 0.4},
	])
	not "farm_min_size_not_met" in eligibility.access_issues with input as inp
}

test_general_obligations_listed_when_participating if {
	{"rule_id": "O6_21-GEN-01", "code": "comply_with_conditionality_and_social_conditionality"} in main.general_obligations with input as fixtures.base
	count(main.general_obligations) == 0 with input as fixtures.with_measure(fixtures.base, {"categories": []})
}
