package oepul.o6_14_test

import data.oepul.o6_14

has_rule(vs, rule_id) if {
	some v in vs
	v.rule_id == rule_id
}

feeding_input(y, feeding, measures) := i if {
	a := object.union(alm("A", 20), {"feeding": feeding, "is_own_alm": true})
	base := mk_input(y, [a], [cattle("cows", "2019-01-01", 15, [stay("A", sprintf("%d-06-01", [y]), sprintf("%d-09-01", [y]))])])
	i := object.union(base, {"farm": object.union(base.farm, {"oepul": {"first_oepul_year": 2023, "participating_measures": measures}})})
}

# --- Futtergrundlage -------------------------------------------------------------

test_alm_own_silage_forbidden_2024 if {
	v := o6_14.obligation_violations with input as feeding_input(2024, {"silage_fed": true, "silage_alm_own": true}, [])
	has_rule(v, "O614-FEED-003")
}

test_alm_own_silage_allowed_2025 if {
	v := o6_14.obligation_violations with input as feeding_input(2025, {"silage_fed": true, "silage_alm_own": true}, [])
	not has_rule(v, "O614-FEED-003")
}

test_external_silage_forbidden_2026 if {
	v := o6_14.obligation_violations with input as feeding_input(2026, {"silage_fed": true, "silage_alm_own": false}, [])
	has_rule(v, "O614-FEED-003")
}

test_alm_silage_to_home_farm_forbidden if {
	v := o6_14.obligation_violations with input as feeding_input(2026, {"alm_silage_moved_to_home_farm": true}, [])
	has_rule(v, "O614-FEED-004")
}

test_heuwirtschaft_own_alm_no_silage_storage if {
	v := o6_14.obligation_violations with input as feeding_input(2026, {"silage_stored": true}, ["heuwirtschaft"])
	has_rule(v, "O614-FEED-006")
}

test_heuwirtschaft_own_alm_own_silage_forbidden if {
	v := o6_14.obligation_violations with input as feeding_input(2026, {"silage_fed": true, "silage_alm_own": true}, ["heuwirtschaft"])
	has_rule(v, "O614-FEED-003")
}

test_basic_fodder_supplementation_forbidden if {
	v := o6_14.obligation_violations with input as feeding_input(2026, {"basic_fodder_supplementation": true}, [])
	has_rule(v, "O614-FEED-001")
}

test_compensatory_feeding_allowed if {
	v := o6_14.obligation_violations with input as feeding_input(2026, {"compensatory_feeding": true}, [])
	count(v) == 0
}

test_alm_foreign_green_fodder_forbidden if {
	v := o6_14.obligation_violations with input as feeding_input(2026, {"alm_foreign_green_fodder_fed": true}, [])
	has_rule(v, "O614-FEED-003")
}

# --- Pflanzenschutz / Duengung -----------------------------------------------------

psm_input(y, types, codes) := mk_input(y, [object.union(alm("A", 20), {"plots": [{"plot_id": "A-1", "codes": codes, "area_wide_psm_types": types}]})], [])

test_psm_code_psmcs_required_2025 if {
	v := o6_14.reporting_violations with input as psm_input(2025, ["organic", "chemical_synthetic"], ["PSMBIO"])
	has_rule(v, "O614-PSM-002")
}

test_psmcs_sufficient_for_both if {
	v := o6_14.reporting_violations with input as psm_input(2025, ["organic", "chemical_synthetic"], ["PSMCS"])
	not has_rule(v, "O614-PSM-002")
}

test_no_psm_coding_from_2026 if {
	v := o6_14.reporting_violations with input as psm_input(2026, ["organic"], [])
	not has_rule(v, "O614-PSM-002")
}

test_non_organic_psm_violation if {
	inp := mk_input(2026, [object.union(alm("A", 20), {"plant_protection": {"non_organic_psm_used": true}})], [])
	v := o6_14.obligation_violations with input as inp
	has_rule(v, "O614-PSM-001")
}

test_foreign_slurry_violation if {
	inp := mk_input(2026, [object.union(alm("A", 20), {"fertilisation": {"alm_foreign_slurry_applied": true, "home_farm_manure_applied": true}})], [])
	v := o6_14.obligation_violations with input as inp
	has_rule(v, "O614-FERT-002")
	count([x | some x in v; startswith(x.rule_id, "O614-FERT")]) == 1
}

test_sewage_sludge_violation if {
	inp := mk_input(2026, [object.union(alm("A", 20), {"fertilisation": {"sewage_sludge_applied": true}})], [])
	v := o6_14.obligation_violations with input as inp
	has_rule(v, "O614-FERT-003")
}

test_home_farm_milking_only if {
	a := object.union(alm("A", 20), {"adjacent_to_home_farm": true})
	inp := mk_input(2026, [a], [object.union(cattle("c", "2019-01-01", 5, [stay("A", "2026-06-01", "2026-09-01")]), {"home_stable_only_for_milking": false})])
	v := o6_14.obligation_violations with input as inp
	has_rule(v, "O614-GRAZE-009")
}

test_sheep_without_ear_tag if {
	inp := mk_input(2026, [alm("A", 20)], [{"animal_id": "s", "species": "sheep", "birth_date": "2020-01-01", "stays": [stay("A", "2026-06-01", "2026-09-01")]}])
	v := o6_14.reporting_violations with input as inp
	has_rule(v, "O614-APPL-012")
}

test_equine_planned_down_date_no_report_needed if {
	s := object.union(object.remove(stay("A", "2026-06-01", "2026-09-01"), ["drive_down_report_date"]), {"planned_drive_down_date": "2026-09-01"})
	inp := mk_input(2026, [alm("A", 20)], [{"animal_id": "h", "species": "equine", "equine_size_class": "large", "birth_date": "2018-01-01", "count": 2, "stays": [s]}])
	v := o6_14.reporting_violations with input as inp
	not has_rule(v, "O614-GRAZE-007")
}

test_equine_changed_down_date_requires_correction if {
	s := object.union(object.remove(stay("A", "2026-06-01", "2026-09-01"), ["drive_down_report_date"]), {"planned_drive_down_date": "2026-09-15"})
	inp := mk_input(2026, [alm("A", 20)], [{"animal_id": "h", "species": "equine", "equine_size_class": "large", "birth_date": "2018-01-01", "count": 2, "stays": [s]}])
	v := o6_14.reporting_violations with input as inp
	has_rule(v, "O614-GRAZE-007")
}

test_cattle_down_report_late if {
	s := object.union(stay("A", "2026-06-01", "2026-09-01"), {"drive_down_report_date": "2026-09-20"})
	inp := mk_input(2026, [alm("A", 20)], [cattle("c", "2019-01-01", 1, [s])])
	v := o6_14.reporting_violations with input as inp
	has_rule(v, "O614-GRAZE-007")
}

test_sheep_sold_without_drive_down if {
	a := object.union(sheep("s", "2020-01-01", 1, [stay("A", "2026-06-01", "2026-09-01")]), {"sold_without_drive_down": true, "in_tierwohl_weide_or_rare_breeds": true, "new_drive_up_report_with_new_home_farm": false})
	v := o6_14.reporting_violations with input as mk_input(2026, [alm("A", 20)], [a])
	has_rule(v, "O614-APPL-013")
}

# --- Naturschutz auf der Alm ----------------------------------------------------------

nata_alm_fixture(extra) := object.union(alm("A", 10), object.union(
	{
		"plots": [{"plot_id": "A-1", "codes": ["NATA"], "project_confirmation": true}],
		"nature_conservation": {"participates": true, "project_requirements_met": true, "measures": [{"code": "NAW2"}]},
	},
	extra,
))

nata_course_ok := {"completed": true, "hours": 4, "completion_date": "2024-05-01", "provider_recognized": true, "content_nature_conservation_related": true, "attendee_role": "herder"}

nata_input(alm_obj, n_cows, course) := with_af(
	mk_input(2026, [alm_obj], [cattle("cows", "2019-01-01", n_cows, [stay("A", "2026-06-01", "2026-09-01")])]),
	{"nature_conservation_supplement": {"applied": true, "application_date": "2022-12-10", "commitment_start_year": 2023, "course": course}},
)

test_nata_stocking_limit_1_5 if {
	inp := nata_input(nata_alm_fixture({}), 16, nata_course_ok)
	o6_14.alm_max_stocking_limit.A == 1.5 with input as inp
	o6_14.overstocked("A") with input as inp
}

test_nata_premium_2026 if {
	inp := nata_input(nata_alm_fixture({}), 10, nata_course_ok)
	approx(o6_14.alm_nata_premium.A, 10 * (10 + 8.6)) with input as inp
	count(o6_14.nata_violations) == 0 with input as inp
}

test_nata_requires_project_confirmation_all_plots if {
	a := nata_alm_fixture({"plots": [{"plot_id": "A-1", "codes": ["NATA"], "project_confirmation": true}, {"plot_id": "A-2", "codes": ["NATA"], "project_confirmation": false}]})
	inp := nata_input(a, 10, nata_course_ok)
	v := o6_14.nata_violations with input as inp
	has_rule(v, "O614-ACCESS-004")
	o6_14.alm_nata_premium.A == 0 with input as inp
}

test_nata_plot_without_code if {
	a := nata_alm_fixture({"plots": [{"plot_id": "A-1", "codes": [], "project_confirmation": true}]})
	v := o6_14.deadline_violations with input as nata_input(a, 10, nata_course_ok)
	has_rule(v, "O614-APPL-015")
}

test_nata_fertiliser_in_moor_forbidden if {
	a := nata_alm_fixture({"nature_conservation": {"participates": true, "project_requirements_met": true, "fertilised_habitats": ["moor"]}})
	v := o6_14.nata_violations with input as nata_input(a, 10, nata_course_ok)
	has_rule(v, "O614-NATA-003")
}

test_nata_fertiliser_nardus_allowed if {
	a := nata_alm_fixture({"nature_conservation": {"participates": true, "project_requirements_met": true, "fertilised_habitats": ["nardus_grassland"]}})
	v := o6_14.nata_violations with input as nata_input(a, 10, nata_course_ok)
	not has_rule(v, "O614-NATA-003")
}

test_nata_drainage_upgrade_needs_consent if {
	a := nata_alm_fixture({"nature_conservation": {"participates": true, "project_requirements_met": true, "drainage_upgraded": true}})
	v := o6_14.nata_violations with input as nata_input(a, 10, nata_course_ok)
	has_rule(v, "O614-NATA-004")
}

test_nata_watering_point_in_wetland if {
	a := nata_alm_fixture({"nature_conservation": {"participates": true, "project_requirements_met": true, "watering_point_in_wetland_or_spring": true}})
	v := o6_14.nata_violations with input as nata_input(a, 10, nata_course_ok)
	has_rule(v, "O614-NATA-005")
}

test_nata_course_too_early if {
	course := object.union(nata_course_ok, {"completion_date": "2021-12-31"})
	v := o6_14.nata_violations with input as nata_input(nata_alm_fixture({}), 10, course)
	has_rule(v, "O614-NATA-006")
}

test_nata_course_person_left_without_replacement if {
	course := object.union(nata_course_ok, {"trained_person_left_date_known": true, "trained_person_left_date": "2025-06-01", "replacement_course_completed": false})
	v := o6_14.nata_violations with input as nata_input(nata_alm_fixture({}), 10, course)
	has_rule(v, "O614-NATA-006")
}

test_nata_course_person_left_after_deadline_ok if {
	course := object.union(nata_course_ok, {"trained_person_left_date_known": true, "trained_person_left_date": "2026-03-01"})
	v := o6_14.nata_violations with input as nata_input(nata_alm_fixture({}), 10, course)
	not has_rule(v, "O614-NATA-006")
}

test_nata_code_from_share if {
	o6_14.nata_code_for_share("biotopmanagement", 12) == "NAB2"
	o6_14.nata_code_for_share("weidemanagement", 25) == "NAW3"
	not o6_14.nata_code_for_share("duengemanagement", 1)
}

# --- Almweideplan ---------------------------------------------------------------------

awp_course_ok := {"completed": true, "hours": 4, "completion_date": "2025-03-01", "provider_recognized": true, "covers_required_topics": true, "attendee_role": "farm_manager"}

awp_plan_ok := {
	"created_date": "2026-05-01",
	"covers_all_alms": true,
	"assessment_site_yield": true,
	"assessment_ecological_value": true,
	"development_goals_and_management_needs": true,
	"grazing_and_steering_measures_per_plot": true,
	"created_with_or_communicated_to_involved_persons": true,
	"annual_review_documented": true,
}

awp_input(alm_obj, n_cows, plan) := with_af(
	mk_input(2026, [alm_obj], [cattle("cows", "2019-01-01", n_cows, [stay("A", "2026-06-01", "2026-09-01")])]),
	{"grazing_plan_supplement": {"applied": true, "application_date": "2024-11-20", "first_application_year": 2025, "course": awp_course_ok, "plan": plan}},
)

test_awp_premium_first_20_ha if {
	inp := awp_input(alm("A", 30), 30, awp_plan_ok)
	approx(o6_14.alm_awp_premium.A, 400) with input as inp
}

test_awp_premium_below_20_ha if {
	inp := awp_input(alm("A", 30), 12, awp_plan_ok)
	approx(o6_14.alm_awp_premium.A, 240) with input as inp
}

test_awp_increased_intensity_2_4 if {
	a := object.union(alm("A", 10), {"grazing_plan": {"increased_intensity_applied": true, "increased_intensity_justified_in_plan": true, "increased_intensity_declared_in_drive_up_list": true}})
	inp := awp_input(a, 22, awp_plan_ok)
	o6_14.alm_max_stocking_limit.A == 2.4 with input as inp
	not o6_14.overstocked("A") with input as inp
}

test_awp_increased_intensity_without_justification if {
	a := object.union(alm("A", 10), {"grazing_plan": {"increased_intensity_applied": true, "increased_intensity_justified_in_plan": false}})
	inp := awp_input(a, 22, awp_plan_ok)
	o6_14.overstocked("A") with input as inp
	v := o6_14.awp_violations with input as inp
	has_rule(v, "O614-AWP-006")
}

test_awp_plan_after_15_july if {
	plan := object.union(awp_plan_ok, {"created_date": "2026-07-16"})
	inp := awp_input(alm("A", 30), 30, plan)
	v := o6_14.awp_violations with input as inp
	has_rule(v, "O614-AWP-003")
	o6_14.alm_awp_premium.A == 0 with input as inp
}

test_awp_review_missing_second_year if {
	plan := object.remove(awp_plan_ok, ["annual_review_documented"])
	v := o6_14.awp_violations with input as awp_input(alm("A", 30), 30, plan)
	has_rule(v, "O614-AWP-005")
}

test_awp_incomplete_plan if {
	plan := object.remove(awp_plan_ok, ["assessment_ecological_value"])
	v := o6_14.awp_violations with input as awp_input(alm("A", 30), 30, plan)
	has_rule(v, "O614-AWP-004")
}

test_awp_not_combinable_with_nata if {
	inp := with_af(awp_input(alm("A", 30), 30, awp_plan_ok), {"nature_conservation_supplement": {"applied": true, "application_date": "2022-12-10"}})
	v := o6_14.nata_violations with input as inp
	has_rule(v, "O614-AWP-008")
	o6_14.alm_awp_premium.A == 0 with input as inp
}

test_awp_entry_2029_not_possible if {
	inp := with_af(awp_input(alm("A", 30), 30, awp_plan_ok), {"grazing_plan_supplement": {"applied": true, "application_date": "2028-11-20", "first_application_year": 2029}})
	v := o6_14.deadline_violations with input as inp
	has_rule(v, "O614-APPL-003")
}

test_awp_takeover_only_individual_cases if {
	o6_14.awp_takeover_allowed("farm_division")
	not o6_14.awp_takeover_allowed("sale_of_area")
}

test_awp_auto_renewal if {
	o6_14.awp_active_next_year with input as awp_input(alm("A", 30), 30, awp_plan_ok)
}
