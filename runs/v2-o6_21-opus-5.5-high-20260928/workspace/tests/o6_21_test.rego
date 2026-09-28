package oepul.o6_21_test

import rego.v1

import data.oepul.o6_21

# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

compliant_housing(pen) := {
	"group_housed": true,
	"bedded_system": true,
	"tethered": false,
	"full_slatted": false,
	"pen_id": pen,
}

animal(ear, sex, birth, pen) := {
	"ear_tag": ear,
	"sex": sex,
	"birth_date": birth,
	"on_farm_from": null,
	"on_farm_until": null,
	"kept_in_austria": true,
	"o6_21_deregistered": false,
	"housing": compliant_housing(pen),
	"other_support": {"alm_driven": false, "tierwohl_weide_participation": false, "coupled_support_alm": false},
}

full_year_program := {"participates": true, "programme": "qplus_rind", "from_date": "2020-01-01", "to_date": "2030-12-31"}

base_input := {
	"farm": {
		"year": 2026,
		"suckler_cow_farm": false,
		"oepul_first_participation_year": 2023,
		"applicant": {"type": "natural_person", "public_body_share_percent": 0, "is_active_farmer": true, "agricultural_activity": true},
		"dairy": {"milk_delivery_to_dairy": false, "seasonal_alm_milk_delivery": false},
		"programs": {
			"animal_health_service": {"participates": true, "from_date": "2020-01-01", "to_date": "2030-12-31"},
			"qplus_rind": full_year_program,
		},
	},
	"land": {"total_area_ha": 40, "protected_cultivation_area_ha": 0},
	"livestock": {
		"cattle_animals": [
			animal("AT001", "male", "2025-01-01", "P1"),
			animal("AT002", "male", "2025-01-01", "P1"),
			animal("AT003", "male", "2024-01-01", "P1"),
			animal("AT004", "female", "2025-07-01", "P1"),
		],
		"stall_pens": [{
			"pen_id": "P1",
			"stall_id": "S1",
			"usable_total_area_m2": 30,
			"bedded_lying_area_m2": 12,
			"lying_area_perforation_percent": 0,
			"lying_surface": "fixed_surface",
			"litter_depth_cm": 5,
			"lying_area_soft_and_dry": true,
			"litter_absorbent_and_soft": true,
			"occupants": [{"kind": "young_cattle", "weight_kg": 520, "count": 4}],
		}],
		"stall_buildings": [{
			"stall_id": "S1",
			"system": "closed",
			"three_sided_enclosure": true,
			"roof_over_lying_places": true,
			"floor_fixed": true,
			"floor_material": "concrete",
			"liquid_manure_occurs": false,
			"capacity_for_all_animals": true,
		}],
	},
	"oepul": {
		"o6_21": {
			"applied_categories": ["male_ge_half_year", "female_half_to_2_years"],
			"composting_supplement_applied": true,
			"applications": [
				{"item": "male_ge_half_year", "first_year": 2024, "submitted_date": "2023-11-20"},
				{"item": "female_half_to_2_years", "first_year": 2024, "submitted_date": "2023-11-20"},
				{"item": "festmistkompostierung", "first_year": 2025, "submitted_date": "2024-12-01"},
			],
			"composting": {
				"all_solid_manure_in_windrows_on_farm": true,
				"napv_compliant": true,
				"compost_barn": false,
				"documented_items": ["setup", "turning", "spreading_or_transfer_to_third_parties"],
				"windrows": [{
					"windrow_id": "W1",
					"method": "turned",
					"turning_device": "compost_turner",
					"device_on_farm": true,
					"turning_dates": ["2026-04-01", "2026-04-20"],
				}],
			},
		},
		"controls": {"inspection_refused": false},
	},
}

patched(ops) := json.patch(base_input, ops)

approx(a, b) if abs(a - b) < 0.0001

# ---------------------------------------------------------------------------
# RGVE und Mindestteilnahme
# ---------------------------------------------------------------------------

test_base_case_rgve_and_premium if {
	d := o6_21.decision with input as base_input
	approx(d.total_participating_rgve, 2.8)
	d.minimum_participation_met
	d.measure_payable
	count(d.violations) == 0
	d.premium.base_premium_eur == 544.32
	d.premium.composting_supplement_eur == 60.48
	d.premium.gross_premium_eur == 604.8
	d.premium.net_premium_eur == 604.8
	d.premium.payment_deadline == "2027-06-30"
}

test_rgve_age_band_change_inside_category if {
	# Stier geboren 2024-01-01: 2026 ganzjährig ab 2 Jahre = 1,0 RGVE
	a := animal("X", "male", "2024-01-01", "P1")
	r := o6_21.animal_category_rgve(a, o6_21.categories_by_id.male_ge_half_year) with input as base_input
	approx(r, 1.0)
}

test_rgve_pro_rata_growing_into_category if {
	# geboren 2025-10-01, ab 2026-04-01 in der Kategorie „ab ½ Jahr“: 275 Tage x 0,6 / 365
	a := animal("X", "male", "2025-10-01", "P1")
	r := o6_21.animal_category_rgve(a, o6_21.categories_by_id.male_ge_half_year) with input as base_input
	approx(r, (275 * 0.6) / 365)
}

test_rgve_calf_from_birth_to_half_year if {
	a := animal("X", "female", "2026-03-01", "P1")
	r := o6_21.animal_category_rgve(a, o6_21.categories_by_id.female_lt_half_year) with input as base_input
	approx(r, (184 * 0.4) / 365)
}

test_rgve_slaughtered_animal_pro_rata if {
	a := object.union(animal("X", "male", "2025-01-01", "P1"), {"on_farm_until": "2026-07-01", "exit_reason": "slaughter"})
	r := o6_21.animal_category_rgve(a, o6_21.categories_by_id.male_ge_half_year) with input as base_input
	approx(r, (181 * 0.6) / 365)
	o6_21.no_ama_notification_needed(a)
}

test_rgve_purchased_animal_from_purchase_date if {
	a := object.union(animal("X", "male", "2025-01-01", "P1"), {"on_farm_from": "2026-10-01"})
	r := o6_21.animal_category_rgve(a, o6_21.categories_by_id.male_ge_half_year) with input as base_input
	approx(r, (92 * 0.6) / 365)
}

test_rgve_dwarf_breed if {
	a := object.union(animal("X", "male", "2024-01-01", "P1"), {"breed": "Dexter"})
	r := o6_21.animal_category_rgve(a, o6_21.categories_by_id.male_ge_half_year) with input as base_input
	approx(r, 0.5)
}

test_female_category_ends_at_two_years if {
	# geboren 2024-07-01: 2 Jahre am 2026-07-01, danach nicht mehr teilnahmefähig
	a := animal("X", "female", "2024-07-01", "P1")
	r := o6_21.animal_category_rgve(a, o6_21.categories_by_id.female_half_to_2_years) with input as base_input
	approx(r, (181 * 0.6) / 365)
}

test_minimum_participation_not_met if {
	inp := patched([{"op": "replace", "path": "/livestock/cattle_animals", "value": [animal("AT001", "male", "2025-01-01", "P1")]}])
	d := o6_21.decision with input as inp
	not d.minimum_participation_met
	not d.measure_payable
	d.premium.gross_premium_eur == 0
	some v in d.violations
	v.rule_id == "O6_21-ACC-001"
}

# ---------------------------------------------------------------------------
# Milchanlieferung, TGD, Qplus
# ---------------------------------------------------------------------------

test_milk_delivery_excludes_female_half_to_two if {
	inp := patched([{"op": "replace", "path": "/farm/dairy/milk_delivery_to_dairy", "value": true}])
	d := o6_21.decision with input as inp
	"female_half_to_2_years" in d.excluded_categories
	approx(d.total_participating_rgve, 2.2)
	some v in d.violations
	v.rule_id == "O6_21-ACC-003"
}

test_seasonal_alm_milk_delivery_also_excludes if {
	inp := patched([{"op": "replace", "path": "/farm/dairy/seasonal_alm_milk_delivery", "value": true}])
	"female_half_to_2_years" in o6_21.category_excluded with input as inp
}

many_bulls := [animal(sprintf("B%d", [i]), "male", "2021-01-01", "P1") | some i in numbers.range(1, 12)]

test_animal_health_service_required_above_10_rgve if {
	inp := patched([
		{"op": "replace", "path": "/livestock/cattle_animals", "value": many_bulls},
		{"op": "replace", "path": "/farm/programs/animal_health_service", "value": {"participates": false}},
	])
	o6_21.animal_health_service_required with input as inp
	some v in o6_21.violations with input as inp
	v.rule_id == "O6_21-TGD-001"
}

test_animal_health_service_not_required_below_threshold if {
	inp := patched([{"op": "replace", "path": "/farm/programs/animal_health_service", "value": {"participates": false}}])
	not o6_21.animal_health_service_required with input as inp
	count(o6_21.program_violations) == 0 with input as inp
}

test_animal_health_service_2023_from_15_april if {
	inp := patched([
		{"op": "replace", "path": "/farm/year", "value": 2023},
		{"op": "replace", "path": "/livestock/cattle_animals", "value": many_bulls},
		{"op": "replace", "path": "/farm/programs/animal_health_service", "value": {"participates": true, "from_date": "2023-04-15", "to_date": "2023-12-31"}},
	])
	o6_21.animal_health_service_required with input as inp
	not "O6_21-TGD-001" in {v.rule_id | some v in o6_21.program_violations} with input as inp
}

test_animal_health_service_2024_from_15_april_insufficient if {
	inp := patched([
		{"op": "replace", "path": "/farm/year", "value": 2024},
		{"op": "replace", "path": "/livestock/cattle_animals", "value": many_bulls},
		{"op": "replace", "path": "/farm/programs/animal_health_service", "value": {"participates": true, "from_date": "2024-04-15", "to_date": "2024-12-31"}},
	])
	"O6_21-TGD-001" in {v.rule_id | some v in o6_21.program_violations} with input as inp
}

test_qplus_required_for_female_categories if {
	inp := patched([{"op": "replace", "path": "/farm/programs/qplus_rind", "value": {"participates": false}}])
	"O6_21-QPL-001" in {v.rule_id | some v in o6_21.program_violations} with input as inp
}

test_qplus_not_required_for_male_only if {
	inp := patched([
		{"op": "replace", "path": "/farm/programs/qplus_rind", "value": {"participates": false}},
		{"op": "replace", "path": "/oepul/o6_21/applied_categories", "value": ["male_ge_half_year"]},
	])
	not "O6_21-QPL-001" in {v.rule_id | some v in o6_21.program_violations} with input as inp
}

test_qplus_other_programme_not_accepted if {
	inp := patched([{"op": "replace", "path": "/farm/programs/qplus_rind/programme", "value": "other_programme"}])
	"O6_21-QPL-001" in {v.rule_id | some v in o6_21.program_violations} with input as inp
}

# ---------------------------------------------------------------------------
# Platzangebot, Liegefläche, Einstreu
# ---------------------------------------------------------------------------

pen(total, bedded, occupants) := {
	"pen_id": "PX",
	"stall_id": "S1",
	"usable_total_area_m2": total,
	"bedded_lying_area_m2": bedded,
	"lying_area_perforation_percent": 0,
	"lying_surface": "fixed_surface",
	"litter_depth_cm": 5,
	"occupants": occupants,
}

test_example_five_bulls_over_500kg if {
	p := pen(21, 8.4, [{"kind": "young_cattle", "weight_kg": 600, "count": 5}])
	approx(o6_21.pen_required_total_area(p), 21)
	approx(o6_21.pen_required_bedded_area(p), 8.4)
	count(o6_21.pen_violations) == 0 with input.livestock.stall_pens as [p]
}

test_insufficient_total_area if {
	p := pen(20, 8.4, [{"kind": "young_cattle", "weight_kg": 600, "count": 5}])
	"O6_21-HOUS-013" in {v.rule_id | some v in o6_21.pen_violations} with input.livestock.stall_pens as [p]
}

test_insufficient_bedded_area if {
	p := pen(21, 8.0, [{"kind": "young_cattle", "weight_kg": 600, "count": 5}])
	"O6_21-HOUS-007" in {v.rule_id | some v in o6_21.pen_violations} with input.livestock.stall_pens as [p]
}

test_example_mixed_group_with_suckler_cows if {
	p1 := pen(108, 43.2, [{"kind": "cow", "count": 12}, {"kind": "young_cattle", "weight_kg": 300, "count": 12}])
	approx(o6_21.pen_required_total_area(p1), 108)
	approx(o6_21.pen_required_bedded_area(p1), 43.2)
	p2 := pen(108, 43.2, [{"kind": "cow", "count": 12}, {"kind": "young_cattle", "weight_kg": 400, "count": 12}])
	approx(o6_21.pen_required_total_area(p2), 115.2)
	approx(o6_21.pen_required_bedded_area(p2), 46.08)
	"O6_21-HOUS-013" in {v.rule_id | some v in o6_21.pen_violations} with input.livestock.stall_pens as [p2]
}

test_occupancy_plan_example_25_5_m2 if {
	o6_21.max_animals_for_area(25.5, 600) == 6
	o6_21.max_animals_for_area(25.5, 400) == 7
	o6_21.max_animals_for_area(25.5, 300) == 8
	o6_21.max_animals_for_area(25.5, 200) == 10
	o6_21.max_animals_for_area(25.5, 120) == 14
}

test_weight_class_boundaries if {
	o6_21.space_row(150).total_area_m2_per_animal == 1.8
	o6_21.space_row(151).total_area_m2_per_animal == 2.5
	o6_21.space_row(500).total_area_m2_per_animal == 3.6
	o6_21.space_row(501).total_area_m2_per_animal == 4.2
}

test_perforation_over_5_percent if {
	p := object.union(pen(21, 8.4, [{"kind": "young_cattle", "weight_kg": 600, "count": 5}]), {"lying_area_perforation_percent": 6})
	"O6_21-HOUS-006" in {v.rule_id | some v in o6_21.pen_violations} with input.livestock.stall_pens as [p]
}

test_perforation_5_percent_is_closed if {
	p := object.union(pen(21, 8.4, [{"kind": "young_cattle", "weight_kg": 600, "count": 5}]), {"lying_area_perforation_percent": 5})
	count(o6_21.pen_violations) == 0 with input.livestock.stall_pens as [p]
}

test_hard_rubber_requires_3cm_litter if {
	p := object.union(pen(21, 8.4, [{"kind": "young_cattle", "weight_kg": 600, "count": 5}]), {"lying_surface": "hard_rubber", "litter_depth_cm": 2})
	"O6_21-HOUS-010" in {v.rule_id | some v in o6_21.pen_violations} with input.livestock.stall_pens as [p]
}

test_soft_rubber_no_min_depth_but_litter if {
	p := object.union(pen(21, 8.4, [{"kind": "young_cattle", "weight_kg": 600, "count": 5}]), {"lying_surface": "soft_plastic_or_rubber", "litter_depth_cm": 1, "littered": true})
	count(o6_21.pen_violations) == 0 with input.livestock.stall_pens as [p]
	p2 := object.union(p, {"littered": false})
	"O6_21-HOUS-009" in {v.rule_id | some v in o6_21.pen_violations} with input.livestock.stall_pens as [p2]
}

test_closing_off_subareas if {
	p := object.union(pen(21, 8.4, [{"kind": "young_cattle", "weight_kg": 600, "count": 5}]), {"subareas_closed_off_outside_routine_work": true})
	"O6_21-DEF-006" in {v.rule_id | some v in o6_21.pen_violations} with input.livestock.stall_pens as [p]
}

test_suckler_cow_cubicle_exception if {
	p := object.union(pen(10, 0, [{"kind": "cow", "count": 10}, {"kind": "young_cattle", "weight_kg": 300, "count": 10}]), {
		"cubicle_loose_housing": true,
		"tschg_minimum_met": true,
		"all_animals_over_6_months_have_cubicle": true,
		"calves_have_additional_lying_place": true,
		"calf_creep": {"bedded_lying_area_m2": 3, "occupants": [{"kind": "young_cattle", "weight_kg": 120, "count": 4}]},
	})
	count(o6_21.pen_violations) == 0 with input.livestock.stall_pens as [p] with input.farm.suckler_cow_farm as true
	p2 := object.union(p, {"calf_creep": {"bedded_lying_area_m2": 2, "occupants": [{"kind": "young_cattle", "weight_kg": 120, "count": 4}]}})
	"O6_21-HOUS-019" in {v.rule_id | some v in o6_21.pen_violations} with input.livestock.stall_pens as [p2] with input.farm.suckler_cow_farm as true
	"O6_21-HOUS-013" in {v.rule_id | some v in o6_21.pen_violations} with input.livestock.stall_pens as [p] with input.farm.suckler_cow_farm as false
}

# ---------------------------------------------------------------------------
# Stalldefinition
# ---------------------------------------------------------------------------

test_gravel_floor_not_fixed_and_animals_breach if {
	inp := patched([{"op": "replace", "path": "/livestock/stall_buildings/0/floor_material", "value": "gravel"}])
	"O6_21-DEF-001" in {v.rule_id | some v in o6_21.stall_violations} with input as inp
	d := o6_21.decision with input as inp
	"AT001" in d.deregistration_required
	"AT001" in d.unreported_noncompliance
}

test_open_stall_requirements if {
	b := {"stall_id": "S2", "system": "open", "solid_roof_over_lying_area": true, "liquid_tight_floor": false, "seepage_drain_to_collection_pit": true}
	"O6_21-DEF-003" in {v.rule_id | some v in o6_21.stall_violations} with input.livestock.stall_buildings as [b]
}

test_liquid_manure_container_required if {
	inp := patched([{"op": "replace", "path": "/livestock/stall_buildings/0/liquid_manure_occurs", "value": true}])
	"O6_21-DEF-002" in {v.rule_id | some v in o6_21.stall_violations} with input as inp
}

test_no_stall_at_home_farm if {
	inp := patched([{"op": "replace", "path": "/livestock/stall_buildings", "value": []}])
	"O6_21-COMB-003" in {v.rule_id | some v in o6_21.violations} with input as inp
}

# ---------------------------------------------------------------------------
# Gruppenhaltung, Einzelhaltung, Abmeldung
# ---------------------------------------------------------------------------

test_full_slatted_after_7_months_only_calf_category_no_deregistration if {
	calf := object.union(animal("C1", "male", "2026-01-01", "P1"), {"housing": object.union(compliant_housing("P1"), {"full_slatted": true, "conditions_breached_from": "2026-08-01"})})
	inp := patched([
		{"op": "add", "path": "/livestock/cattle_animals/-", "value": calf},
		{"op": "replace", "path": "/oepul/o6_21/applied_categories", "value": ["male_lt_half_year", "female_half_to_2_years"]},
	])
	not "C1" in o6_21.deregistration_required with input as inp
}

test_full_slatted_after_7_months_with_older_category_requires_deregistration if {
	calf := object.union(animal("C1", "male", "2026-01-01", "P1"), {"housing": object.union(compliant_housing("P1"), {"full_slatted": true, "conditions_breached_from": "2026-08-01"})})
	inp := patched([
		{"op": "add", "path": "/livestock/cattle_animals/-", "value": calf},
		{"op": "replace", "path": "/oepul/o6_21/applied_categories", "value": ["male_lt_half_year", "male_ge_half_year", "female_half_to_2_years"]},
	])
	d := o6_21.decision with input as inp
	"C1" in d.deregistration_required
	"C1" in d.excluded_animals
	not "C1" in {l.ear_tag | some l in o6_21.animal_premium_lines with input as inp}
}

test_deregistered_animal_no_premium_no_notification_violation if {
	bull := object.union(animal("AT003", "male", "2024-01-01", "P1"), {"o6_21_deregistered": true, "housing": object.union(compliant_housing("P1"), {"tethered": true})})
	inp := patched([{"op": "replace", "path": "/livestock/cattle_animals/2", "value": bull}])
	d := o6_21.decision with input as inp
	"AT003" in d.excluded_animals
	not "AT003" in d.unreported_noncompliance
	approx(d.total_participating_rgve, 1.8)
}

test_single_housing_sick_up_to_10_days_ok if {
	a := object.union(animal("AT001", "male", "2025-01-01", "P1"), {"housing": object.union(compliant_housing("P1"), {"single_housing": {"reason": "illness", "days": 10, "bedded": true, "documented": true}})})
	inp := patched([{"op": "replace", "path": "/livestock/cattle_animals/0", "value": a}])
	not "AT001" in o6_21.deregistration_required with input as inp
	count(o6_21.documentation_violations) == 0 with input as inp
}

test_single_housing_over_10_days_requires_deregistration if {
	a := object.union(animal("AT001", "male", "2025-01-01", "P1"), {"housing": object.union(compliant_housing("P1"), {"single_housing": {"reason": "injury", "days": 11, "bedded": true, "documented": true}})})
	inp := patched([{"op": "replace", "path": "/livestock/cattle_animals/0", "value": a}])
	"AT001" in o6_21.deregistration_required with input as inp
	"O6_21-SINGLE-003" in {b.rule_id | some b in o6_21.animal_breaches} with input as inp
}

test_single_housing_undocumented if {
	a := object.union(animal("AT001", "male", "2025-01-01", "P1"), {"housing": object.union(compliant_housing("P1"), {"single_housing": {"reason": "illness", "days": 3, "bedded": true, "documented": false}})})
	inp := patched([{"op": "replace", "path": "/livestock/cattle_animals/0", "value": a}])
	"O6_21-SINGLE-004" in {v.rule_id | some v in o6_21.documentation_violations} with input as inp
}

test_single_housing_without_health_reason if {
	a := object.union(animal("AT001", "male", "2025-01-01", "P1"), {"housing": object.union(compliant_housing("P1"), {"single_housing": {"reason": "other", "days": 2, "bedded": true}})})
	inp := patched([{"op": "replace", "path": "/livestock/cattle_animals/0", "value": a}])
	"O6_21-SINGLE-001" in {b.rule_id | some b in o6_21.animal_breaches} with input as inp
}

test_calf_single_housing_under_21_days if {
	ok := {"reason": "calf", "calf_age_days_at_end": 20, "bedded": true, "social_contact": true, "days": 20}
	a := object.union(animal("AT001", "male", "2025-01-01", "P1"), {"housing": object.union(compliant_housing("P1"), {"single_housing": ok})})
	inp := patched([{"op": "replace", "path": "/livestock/cattle_animals/0", "value": a}])
	not "AT001" in o6_21.deregistration_required with input as inp
	bad := object.union(ok, {"social_contact": false})
	a2 := object.union(a, {"housing": object.union(compliant_housing("P1"), {"single_housing": bad})})
	inp2 := patched([{"op": "replace", "path": "/livestock/cattle_animals/0", "value": a2}])
	"AT001" in o6_21.deregistration_required with input as inp2
}

test_year_round_outdoor_not_eligible if {
	a := object.union(animal("AT001", "male", "2025-01-01", "P1"), {"housing": object.union(compliant_housing("P1"), {"year_round_outdoor_without_stall": true})})
	inp := patched([{"op": "replace", "path": "/livestock/cattle_animals/0", "value": a}])
	"O6_21-COMB-002" in {b.rule_id | some b in o6_21.animal_breaches} with input as inp
}

test_animal_kept_abroad_excluded if {
	a := object.union(animal("AT001", "male", "2025-01-01", "P1"), {"kept_in_austria": false})
	inp := patched([{"op": "replace", "path": "/livestock/cattle_animals/0", "value": a}])
	"AT001" in o6_21.animal_excluded with input as inp
}

# ---------------------------------------------------------------------------
# Prämie
# ---------------------------------------------------------------------------

test_reduced_rate_for_weide_participation if {
	a := object.union(animal("AT004", "female", "2025-07-01", "P1"), {"other_support": {"tierwohl_weide_participation": true}})
	inp := patched([{"op": "replace", "path": "/livestock/cattle_animals/3", "value": a}])
	d := o6_21.decision with input as inp
	d.premium.base_premium_eur == 524.88
}

test_reduced_rate_for_alm if {
	a := object.union(animal("AT004", "female", "2025-07-01", "P1"), {"other_support": {"alm_driven": true}})
	o6_21.animal_rate(a) == 162.0 with input as base_input
	o6_21.animal_rate(animal("Y", "male", "2025-01-01", "P1")) == 194.4 with input as base_input
}

test_rates_2023 if {
	o6_21.rate_row.standard_eur_per_rgve == 180.0 with input.farm.year as 2023
	o6_21.rate_row.reduced_eur_per_rgve == 150.0 with input.farm.year as 2023
	o6_21.rate_row.composting_supplement_eur_per_rgve == 20.0 with input.farm.year as 2023
	o6_21.rate_row.composting_supplement_eur_per_rgve == 21.6 with input.farm.year as 2027
}

test_modulation_220_ha if {
	f := o6_21.modulation_factor(220)
	round(f * 10000) / 100 == 99.09
	o6_21.modulation_factor(150) == 1
	approx(o6_21.modulation_factor(1100), (((200 + (100 * 0.9)) + (700 * 0.85)) + (100 * 0.75)) / 1100)
}

test_modulation_applied_to_premium if {
	d := o6_21.decision with input as patched([{"op": "replace", "path": "/land/total_area_ha", "value": 220}])
	d.premium.net_premium_eur == round((604.8 * (218 / 220)) * 100) / 100
}

test_payment_helpers if {
	o6_21.max_advance_payment(1000) == 750
	o6_21.payout_may_be_withheld(50)
	not o6_21.payout_may_be_withheld(50.01)
}

# ---------------------------------------------------------------------------
# Festmistkompostierung
# ---------------------------------------------------------------------------

windrow_patch(w) := patched([{"op": "replace", "path": "/oepul/o6_21/composting/windrows", "value": [w]}])

test_composting_turnings_interval_too_short if {
	inp := windrow_patch({"windrow_id": "W1", "method": "turned", "turning_device": "compost_turner", "device_on_farm": true, "turning_dates": ["2026-04-01", "2026-04-10"]})
	"O6_21-COMP-002" in {v.rule_id | some v in o6_21.composting_violations} with input as inp
	d := o6_21.decision with input as inp
	d.premium.composting_supplement_eur == 0
}

test_composting_front_loader_not_eligible if {
	inp := windrow_patch({"windrow_id": "W1", "method": "turned", "turning_device": "front_loader", "device_on_farm": true, "turning_dates": ["2026-04-01", "2026-04-20"]})
	"O6_21-COMP-004" in {v.rule_id | some v in o6_21.composting_violations} with input as inp
}

test_composting_manure_spreader_needs_full_turnover if {
	w := {"windrow_id": "W1", "method": "turned", "turning_device": "manure_spreader", "external_use_documented": true, "turning_dates": ["2026-04-01", "2026-04-20"]}
	"O6_21-COMP-005" in {v.rule_id | some v in o6_21.composting_violations} with input as windrow_patch(w)
	o6_21.composting_supplement_eligible with input as windrow_patch(object.union(w, {"full_turnover_ensured": true}))
}

test_composting_external_turner_needs_proof if {
	w := {"windrow_id": "W1", "method": "turned", "turning_device": "compost_turner", "turning_dates": ["2026-04-01", "2026-04-20"]}
	"O6_21-COMP-003" in {v.rule_id | some v in o6_21.composting_violations} with input as windrow_patch(w)
}

test_composting_mixed_windrow_from_2025 if {
	w := {"windrow_id": "W1", "method": "mixed_layered", "plant_materials": ["shrub_cuttings"]}
	o6_21.composting_supplement_eligible with input as windrow_patch(w)
	inp := json.patch(windrow_patch(w), [{"op": "replace", "path": "/farm/year", "value": 2024}])
	"O6_21-COMP-006" in {v.rule_id | some v in o6_21.composting_violations} with input as inp
}

test_composting_turn_free_straw_rich_manure_alone if {
	w := {"windrow_id": "W1", "method": "turn_free_with_admixture", "organic_material_admixture_substantial": false, "composting_process_applied": true, "straw_rich_manure_only": true}
	vs := {v.rule_id | some v in o6_21.composting_violations} with input as windrow_patch(w)
	"O6_21-COMP-007" in vs
	"O6_21-COMP-008" in vs
}

test_composting_compost_barn_excluded if {
	inp := patched([{"op": "replace", "path": "/oepul/o6_21/composting/compost_barn", "value": true}])
	"O6_21-COMP-012" in {v.rule_id | some v in o6_21.composting_violations} with input as inp
}

test_composting_documentation_incomplete if {
	inp := patched([{"op": "replace", "path": "/oepul/o6_21/composting/documented_items", "value": ["setup"]}])
	"O6_21-COMP-009" in {v.rule_id | some v in o6_21.composting_violations} with input as inp
}

test_composting_not_all_manure if {
	inp := patched([{"op": "replace", "path": "/oepul/o6_21/composting/all_solid_manure_in_windrows_on_farm", "value": false}])
	not o6_21.composting_supplement_eligible with input as inp
}

# ---------------------------------------------------------------------------
# Beantragung, Vertrag, Ausstieg
# ---------------------------------------------------------------------------

test_late_application if {
	inp := patched([{"op": "replace", "path": "/oepul/o6_21/applications/0/submitted_date", "value": "2024-01-10"}])
	d := o6_21.decision with input as inp
	"O6_21-APP-001" in {v.rule_id | some v in d.violations}
	not "AT001" in {l.ear_tag | some l in o6_21.animal_premium_lines with input as inp}
}

test_late_reapplication_with_written_request if {
	inp := patched([{"op": "replace", "path": "/oepul/o6_21/applications/0", "value": {"item": "male_ge_half_year", "first_year": 2026, "submitted_date": "2026-01-20", "late_reapplication_after_lapse": true, "written_request_to_ama": true}}])
	o6_21.contract_valid("male_ge_half_year") with input as inp
}

test_last_entry_years if {
	inp := patched([
		{"op": "replace", "path": "/farm/year", "value": 2028},
		{"op": "add", "path": "/oepul/o6_21/applications/-", "value": {"item": "male_lt_half_year", "first_year": 2028, "submitted_date": "2027-12-01"}},
		{"op": "replace", "path": "/oepul/o6_21/applications/2", "value": {"item": "festmistkompostierung", "first_year": 2028, "submitted_date": "2027-12-01"}},
	])
	vs := {[v.rule_id, v.item] | some v in o6_21.application_violations} with input as inp
	["O6_21-APP-002", "male_lt_half_year"] in vs
	not ["O6_21-APP-002", "festmistkompostierung"] in vs
}

test_exit_during_year_invalidates_measure if {
	inp := patched([{"op": "add", "path": "/oepul/o6_21/exits", "value": [{"item": "measure", "date": "2026-05-01"}]}])
	d := o6_21.decision with input as inp
	not d.measure_payable
	d.premium.gross_premium_eur == 0
}

test_exit_from_next_year_keeps_current_year if {
	inp := patched([{"op": "add", "path": "/oepul/o6_21/exits", "value": [{"item": "measure", "date": "2027-01-01"}]}])
	d := o6_21.decision with input as inp
	d.measure_payable
}

test_exit_after_control_announcement if {
	inp := patched([{"op": "add", "path": "/oepul/o6_21/exits", "value": [{"item": "measure", "date": "2027-01-01", "after_control_announcement_or_result": true}]}])
	"O6_21-EXIT-005" in {v.rule_id | some v in o6_21.application_violations} with input as inp
}

test_category_lapses_without_eligible_animal if {
	inp := patched([
		{"op": "replace", "path": "/oepul/o6_21/applied_categories", "value": ["male_ge_half_year", "female_half_to_2_years", "female_lt_half_year"]},
		{"op": "add", "path": "/oepul/o6_21/applications/-", "value": {"item": "female_lt_half_year", "first_year": 2025, "submitted_date": "2024-12-01"}},
	])
	d := o6_21.decision with input as inp
	"female_lt_half_year" in d.lapsed_categories
	not "male_ge_half_year" in d.lapsed_categories
}

test_stall_sketch_required_until_2024 if {
	inp := patched([{"op": "replace", "path": "/farm/year", "value": 2024}])
	o6_21.stall_sketch_required with input as inp
	"O6_21-SKETCH-001" in {v.rule_id | some v in o6_21.application_violations} with input as inp
	not o6_21.stall_sketch_required with input as base_input
}

test_unknown_category_rejected if {
	inp := patched([{"op": "replace", "path": "/oepul/o6_21/applied_categories", "value": ["male_ge_half_year", "female_half_to_2_years", "cows"]}])
	"O6_21-CAT-001" in {v.rule_id | some v in o6_21.application_violations} with input as inp
}

test_takeover_only_individual_cases if {
	bad := patched([{"op": "add", "path": "/oepul/o6_21/takeover", "value": {"reason": "lease", "animals_and_areas_from_same_predecessor": true}}])
	"O6_21-GEN-008" in {v.rule_id | some v in o6_21.application_violations} with input as bad
	ok := patched([{"op": "add", "path": "/oepul/o6_21/takeover", "value": {"reason": "farm_division", "animals_and_areas_from_same_predecessor": true}}])
	o6_21.takeover_admissible with input as ok
}

# ---------------------------------------------------------------------------
# Allgemeine Bedingungen
# ---------------------------------------------------------------------------

test_public_body_not_eligible if {
	inp := patched([{"op": "replace", "path": "/farm/applicant/type", "value": "public_body"}])
	d := o6_21.decision with input as inp
	"O6_21-GEN-001" in {v.rule_id | some v in d.violations}
	not d.measure_payable
}

test_legal_person_public_share_over_25 if {
	inp := patched([
		{"op": "replace", "path": "/farm/applicant/type", "value": "legal_person"},
		{"op": "replace", "path": "/farm/applicant/public_body_share_percent", "value": 26},
	])
	"O6_21-GEN-001" in {v.rule_id | some v in o6_21.general_violations} with input as inp
}

test_first_year_minimum_farm_size if {
	inp := patched([
		{"op": "replace", "path": "/farm/oepul_first_participation_year", "value": 2026},
		{"op": "replace", "path": "/land/total_area_ha", "value": 1.2},
	])
	"O6_21-GEN-004" in {v.rule_id | some v in o6_21.general_violations} with input as inp
	inp2 := json.patch(inp, [{"op": "replace", "path": "/land/protected_cultivation_area_ha", "value": 0.5}])
	count(o6_21.general_violations) == 0 with input as inp2
}

test_inspection_refused if {
	inp := patched([{"op": "replace", "path": "/oepul/controls/inspection_refused", "value": true}])
	d := o6_21.decision with input as inp
	not d.measure_payable
}

test_sanction_stages if {
	o6_21.sanction_reduction_percent("warning", 2026) == 0
	o6_21.sanction_reduction_percent("warning", 2027) == 1
	o6_21.sanction_reduction_percent("reduction_25", 2027) == 25
	o6_21.exclusion_from_measure(2)
	not o6_21.exclusion_from_measure(1)
}

test_livestock_holding_farm_definition if {
	o6_21.livestock_holding_farm(3, 10)
	not o6_21.livestock_holding_farm(2, 10)
}
