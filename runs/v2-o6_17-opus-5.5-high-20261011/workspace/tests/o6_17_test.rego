package oepul.o6_17_test

import data.oepul.o6_17

# ---------------------------------------------------------------------------
# Basis-Fixture: tierhaltender Grünlandbetrieb, Einstieg 2025, Teilnahme UBB
# ---------------------------------------------------------------------------
kennarten_5 := ["Wiesen-Salbei", "Hornklee", "Wiesen-Margerite", "Ochsenauge", "Briza media"]

base_parcels := [
	{
		"parcel_id": "P1", "area_ha": 6, "land_use": "grassland", "slope_percent": 10,
		"grassland_figure": 35, "field_use_type": "maehwiese_weide_3plus", "codes": [],
		"operations": {"cutting_dates": ["2025-05-20"], "first_use_type": "mowing"},
	},
	{
		"parcel_id": "P2", "area_ha": 4, "land_use": "grassland", "slope_percent": 25,
		"grassland_figure": 25, "field_use_type": "einmaehdige_wiese", "codes": [],
		"operations": {"cutting_dates": ["2025-07-10"], "first_use_type": "mowing"},
	},
	{
		"parcel_id": "P3", "area_ha": 2, "land_use": "grassland", "slope_percent": 5,
		"grassland_figure": 45, "field_use_type": "maehwiese_weide_2", "codes": ["AGL"],
		"operations": {"cutting_dates": ["2025-06-01"], "first_use_type": "mowing"},
		"agl_survey": {"documented": true, "sections": [{"kennarten": kennarten_5}, {"kennarten": kennarten_5}]},
	},
	{"parcel_id": "P4", "area_ha": 3, "land_use": "arable", "slope_percent": 3, "field_use_type": "kleegras"},
	{"parcel_id": "P5", "area_ha": 5, "land_use": "arable", "slope_percent": 3, "field_use_type": "weizen"},
]

base_input := {
	"farm": {"year": 2025},
	"land": {"total_area_ha": 20, "alpine_pasture_area_ha": 0, "parcels": base_parcels},
	"livestock": {"species_groups": [{"species": "cattle", "rgve_category": "cattle_ge_2y", "animal_count": 5}]},
	"oepul": {
		"participating_measures": ["UBB", "O6_17"],
		"first_oepul_year": 2023,
		"applicant": {"applicant_type": "natural_person", "public_body_share": 0, "is_active_farmer": true},
		"o6_17": {
			"contract_start_year": 2025,
			"measure_application_date": "2024-12-10",
			"eligible_grassland_lt18_mfa2025_ha": 8,
			"soil_samples": [
				{"sample_id": "S1", "drawn_date": "2024-10-01", "lab_submission_date": "2024-10-02", "lab_accredited": true, "method": "richtlinien_sachgerechte_duengung", "parameters": ["ph", "phosphorus", "potassium", "humus"], "entered_in_invekos_gis": true},
				{"sample_id": "S2", "drawn_date": "2025-03-01", "lab_submission_date": "2025-03-05", "lab_accredited": true, "method": "euf", "parameters": ["ph", "phosphorus", "potassium", "humus"], "entered_in_invekos_gis": true},
			],
			"training": [{"hours": 5, "course_date": "2024-02-01", "provider_recognized": true, "grassland_topic": true, "person_role": "applicant"}],
		},
	},
}

with_parcels(ps) := object.union(base_input, {"land": {"total_area_ha": 20, "alpine_pasture_area_ha": 0, "parcels": ps}})

with_o617(extra) := object.union(base_input, {"oepul": object.union(base_input.oepul, {"o6_17": object.union(base_input.oepul.o6_17, extra)})})

r2(x) := round(x * 100) / 100

# ---------------------------------------------------------------------------
# Zugangsvoraussetzungen
# ---------------------------------------------------------------------------
test_base_case_contract_established if {
	o6_17.contract_established with input as base_input
	count(o6_17.access_violations) == 0 with input as base_input
}

test_livestock_density_counts_grassland_and_arable_forage if {
	o6_17.forage_area_ha == 15 with input as base_input
	r2(o6_17.livestock_density_rgve_per_ha) == 0.33 with input as base_input
	o6_17.is_livestock_farm with input as base_input
}

test_not_livestock_farm_first_year if {
	inp := object.union(base_input, {"livestock": {"species_groups": [{"rgve_category": "cattle_ge_2y", "animal_count": 4}]}})
	not o6_17.is_livestock_farm with input as inp
	some v in o6_17.access_violations with input as inp
	v.rule_id == "O6_17-MB-3.4-LIVESTOCK-FIRST-YEAR"
}

test_pigs_do_not_count_as_rgve if {
	inp := object.union(base_input, {"livestock": {"species_groups": [{"rgve_category": "breeding_sows_ge_50kg", "animal_count": 100}]}})
	o6_17.rgve_total == 0 with input as inp
}

test_animals_abroad_not_counted if {
	inp := object.union(base_input, {"livestock": {"species_groups": [{"rgve_category": "cattle_ge_2y", "animal_count": 5, "kept_in_austria": false}]}})
	o6_17.rgve_total == 0 with input as inp
}

test_livestock_only_required_in_first_year if {
	inp := object.union(base_input, {"farm": {"year": 2026}, "livestock": {"species_groups": []}})
	not o6_17.first_participation_year with input as inp
	count(o6_17.access_violations) == 0 with input as inp
}

test_min_grassland_first_year if {
	ps := [{"parcel_id": "G", "area_ha": 1.5, "land_use": "grassland", "slope_percent": 5, "grassland_figure": 30, "field_use_type": "maehwiese_weide_2", "operations": {"cutting_dates": ["2025-06-01"]}}]
	inp := object.union(with_parcels(ps), {"land": {"total_area_ha": 1.6, "alpine_pasture_area_ha": 0, "parcels": ps}})
	some v in o6_17.access_violations with input as inp
	v.rule_id == "O6_17-MB-3.3-MIN-GRASSLAND"
}

test_grassland_share_below_40_percent if {
	inp := object.union(base_input, {"land": {"total_area_ha": 40, "alpine_pasture_area_ha": 0, "parcels": base_parcels}})
	some v in o6_17.access_violations with input as inp
	v.rule_id == "O6_17-MB-3.3-MIN-GRASSLAND-SHARE"
}

test_grassland_share_excludes_alpine_pasture if {
	inp := object.union(base_input, {"land": {"total_area_ha": 40, "alpine_pasture_area_ha": 20, "parcels": base_parcels}})
	o6_17.grassland_share == 0.6 with input as inp
}

test_combination_obligation_blocks_premium if {
	inp := object.union(base_input, {"oepul": object.union(base_input.oepul, {"participating_measures": ["O6_17"]})})
	some v in o6_17.access_violations with input as inp
	v.rule_id == "O6_17-MB-3.2-COMBINATION-OBLIGATION"
	o6_17.premium_total_eur == 0 with input as inp
}

test_bio_teilbetrieb_fulfils_combination if {
	inp := object.union(base_input, {"oepul": object.union(base_input.oepul, {"participating_measures": ["BIO_TEILBETRIEB"]})})
	o6_17.combination_obligation_met with input as inp
}

test_entry_after_2025_not_possible if {
	inp := object.union(with_o617({"contract_start_year": 2026, "measure_application_date": "2025-12-01"}), {"farm": {"year": 2026}})
	some v in o6_17.access_violations with input as inp
	v.rule_id == "O6_17-MB-7-LAST-ENTRY"
}

test_late_measure_application if {
	inp := with_o617({"measure_application_date": "2025-01-15"})
	some v in o6_17.access_violations with input as inp
	v.rule_id == "O6_17-MB-7-APPLICATION-DEADLINE"
}

test_public_body_share_over_25_percent if {
	inp := object.union(base_input, {"oepul": object.union(base_input.oepul, {"applicant": {"applicant_type": "legal_person", "public_body_share": 0.3}})})
	some v in o6_17.access_violations with input as inp
	v.rule_id == "O6_17-AT-5.2-PUBLIC-BODY"
}

test_farm_minimum_size_in_first_oepul_year if {
	ps := [{"parcel_id": "G", "area_ha": 1.2, "land_use": "grassland", "slope_percent": 5, "grassland_figure": 30, "field_use_type": "maehwiese_weide_2"}]
	inp := object.union(object.union(base_input, {"oepul": object.union(base_input.oepul, {"first_oepul_year": 2025})}), {"land": {"total_area_ha": 1.2, "alpine_pasture_area_ha": 0, "parcels": ps}})
	some v in o6_17.access_violations with input as inp
	v.rule_id == "O6_17-AT-5.3-FARM-MIN-SIZE"
}

test_contract_duration_by_start_year if {
	o6_17.contract_duration_years == 4 with input as base_input
	o6_17.contract_duration_years == 6 with input as with_o617({"contract_start_year": 2023})
}

# ---------------------------------------------------------------------------
# Prämien
# ---------------------------------------------------------------------------
test_base_premium_2025_by_grassland_figure if {
	r2(o6_17.base_premium_parcel_eur.P1) == 453.6 with input as base_input
	r2(o6_17.base_premium_parcel_eur.P3) == 216 with input as base_input
	not o6_17.base_premium_parcel_eur.P2 with input as base_input
}

test_base_premium_2023_rates if {
	inp := object.union(with_o617({"contract_start_year": 2023, "measure_application_date": "2022-12-01"}), {"farm": {"year": 2023}})
	r2(o6_17.base_premium_parcel_eur.P1) == 420 with input as inp
	r2(o6_17.base_premium_parcel_eur.P3) == 200 with input as inp
}

test_grassland_figure_20_falls_in_second_band if {
	p := {"area_ha": 1, "grassland_figure": 20}
	o6_17.base_rate_eur_per_ha(p) == 54 with input as base_input
	o6_17.base_rate_eur_per_ha({"area_ha": 1, "grassland_figure": 19.9}) == 32.4 with input as base_input
}

test_gloez_excludes_base_but_not_agl if {
	p3 := object.union(base_parcels[2], {"constraints": {"gloez_conversion_ban": {"gloez9": true}}})
	inp := with_parcels([base_parcels[0], base_parcels[1], p3, base_parcels[3], base_parcels[4]])
	not o6_17.base_premium_parcel_eur.P3 with input as inp
	o6_17.agl_premium_parcel_eur.P3 > 0 with input as inp
}

test_agl_cap_25_percent_of_mown_grassland if {
	o6_17.mown_grassland_ha == 12 with input as base_input
	o6_17.agl_area_cap_ha == 3 with input as base_input
	o6_17.agl_requested_area_ha == 6 with input as base_input
	o6_17.agl_paid_share == 0.5 with input as base_input
	r2(o6_17.agl_premium_parcel_eur.P2) == 324 with input as base_input
	r2(o6_17.agl_premium_parcel_eur.P3) == 262 with input as base_input
}

test_agl_cap_minimum_2_ha if {
	inp := with_parcels([base_parcels[2]])
	o6_17.agl_area_cap_ha == 2 with input as inp
	o6_17.agl_paid_share == 1 with input as inp
}

test_agl_cap_15_percent_until_2024 if {
	inp := object.union(base_input, {"farm": {"year": 2024}})
	r2(o6_17.agl_area_cap_ha) == 2 with input as inp
}

test_agl_slope_ge18_only_from_2025 if {
	inp := object.union(base_input, {"farm": {"year": 2024}})
	not o6_17.agl_premium_parcel_eur.P2 with input as inp
	o6_17.agl_premium_parcel_eur.P2 with input as base_input
}

test_agl_section_with_four_kennarten_fails if {
	p3 := object.union(base_parcels[2], {"agl_survey": {"documented": true, "sections": [{"kennarten": kennarten_5}, {"kennarten": ["Hornklee", "Lotus corniculatus", "Zittergras", "Thymian", "Löwenzahn"]}]}})
	inp := with_parcels([base_parcels[0], base_parcels[1], p3])
	not o6_17.agl_eligible(p3) with input as inp
	some v in o6_17.violations with input as inp
	v.rule_id == "O6_17-MB-6.6-AGL-CONDITIONS"
}

test_agl_first_use_must_be_mowing if {
	p3 := object.union(base_parcels[2], {"operations": {"cutting_dates": ["2025-06-01"], "first_use_type": "grazing"}})
	not o6_17.agl_conditions_met(p3) with input as base_input
}

test_agl_automatic_for_streuwiese_without_survey if {
	p := {"parcel_id": "S", "area_ha": 1, "land_use": "grassland", "slope_percent": 2, "grassland_figure": 15, "field_use_type": "streuwiese"}
	o6_17.agl_eligible(p) with input as base_input
}

test_agl_not_for_bergmaehder if {
	p := {"parcel_id": "B", "area_ha": 1, "land_use": "grassland", "slope_percent": 40, "grassland_figure": 10, "field_use_type": "bergmaehder", "codes": ["AGL"]}
	not o6_17.agl_eligible(p) with input as base_input
}

test_total_premium_2025 if {
	r2(o6_17.premium_total_eur) == 1255.6 with input as base_input
	o6_17.modulation_factor == 1 with input as base_input
}

test_modulation_example_220_ha if {
	inp := object.union(base_input, {"land": {"total_area_ha": 220, "alpine_pasture_area_ha": 0, "parcels": base_parcels}})
	round(o6_17.modulation_factor * 10000) == 9909 with input as inp
}

test_modulation_1200_ha if {
	inp := object.union(base_input, {"land": {"total_area_ha": 1200, "alpine_pasture_area_ha": 0, "parcels": base_parcels}})
	round(o6_17.modulation_factor * 10000) == 8625 with input as inp
}

test_area_payment_cap_per_parcel if {
	p1 := object.union(base_parcels[0], {"other_area_payments_eur": 7700})
	inp := with_parcels([p1, base_parcels[1], base_parcels[2], base_parcels[3], base_parcels[4]])
	r2(o6_17.premium_parcel_eur.P1) == 100 with input as inp
}

test_area_addition_limit_from_2026 if {
	inp := object.union(with_o617({"committed_area_2025_ha": 4}), {"farm": {"year": 2026}})
	o6_17.premium_eligible_area_limit_ha == 9 with input as inp
	o6_17.addition_scale == 1 with input as inp
	inp2 := object.union(with_o617({"committed_area_2025_ha": 2}), {"farm": {"year": 2026}})
	o6_17.premium_eligible_area_limit_ha == 7 with input as inp2
	r2(o6_17.addition_scale) == 0.88 with input as inp2
}

test_no_area_addition_limit_in_2025 if {
	inp := with_o617({"committed_area_2025_ha": 2})
	not o6_17.premium_eligible_area_limit_ha with input as inp
	o6_17.addition_scale == 1 with input as inp
}

test_minimum_payment_threshold if {
	ps := [{"parcel_id": "G", "area_ha": 1, "land_use": "grassland", "slope_percent": 5, "grassland_figure": 10, "field_use_type": "dauerweide", "operations": {"full_grazing": true}}]
	inp := with_parcels(ps)
	o6_17.payment_may_be_withheld_minimum with input as inp
	not o6_17.payment_may_be_withheld_minimum with input as base_input
}

test_sonstige_gruenlandflaeche_and_op_code_not_eligible if {
	p := {"parcel_id": "X", "area_ha": 1, "land_use": "grassland", "slope_percent": 5, "grassland_figure": 30, "field_use_type": "sonstige_gruenlandflaeche"}
	not o6_17.base_premium_eligible(p) with input as base_input
	q := {"parcel_id": "Y", "area_ha": 1, "land_use": "grassland", "slope_percent": 5, "grassland_figure": 30, "field_use_type": "maehwiese_weide_2", "codes": ["OP"]}
	not o6_17.base_premium_eligible(q) with input as base_input
}

test_national_park_neusiedlersee_not_eligible if {
	p := {"parcel_id": "N", "area_ha": 1, "land_use": "grassland", "slope_percent": 5, "grassland_figure": 30, "field_use_type": "maehwiese_weide_2", "constraints": {"national_park": "Neusiedlersee"}}
	not o6_17.base_premium_eligible(p) with input as base_input
}

# ---------------------------------------------------------------------------
# Förderverpflichtungen
# ---------------------------------------------------------------------------
conversion_input(e) := with_parcels([object.union(base_parcels[0], {"operations": {"cutting_dates": ["2025-05-20"], "grassland_conversions": [e]}})])

conversion_violation(e) if {
	some v in o6_17.violations with input as conversion_input(e)
	v.rule_id == "O6_17-MB-6.1-NO-CONVERSION"
}

test_ploughing_is_conversion_violation if {
	conversion_violation({"kind": "ploughing", "area_m2": 5000, "reason": "none"})
}

test_minor_deviation_up_to_300_m2 if {
	not conversion_violation({"kind": "vegetable_garden", "area_m2": 300, "reason": "none"})
	conversion_violation({"kind": "vegetable_garden", "area_m2": 301, "reason": "none"})
}

test_fill_over_300_m2_requires_permit if {
	conversion_violation({"kind": "fill", "area_m2": 800, "reseeded": true, "permit_obtained": false, "reason": "none"})
	not conversion_violation({"kind": "fill", "area_m2": 800, "reseeded": true, "permit_obtained": true, "reason": "none"})
}

test_pest_damage_exception_requires_documentation if {
	not conversion_violation({"kind": "renewal_by_ploughing", "area_m2": 20000, "reason": "pest_damage", "documented": true})
	conversion_violation({"kind": "renewal_by_ploughing", "area_m2": 20000, "reason": "pest_damage", "documented": false})
}

test_biodiversity_reseeding_exception_requires_ubb_or_bio if {
	e := {"kind": "renewal_by_ploughing", "area_m2": 3000, "reason": "biodiversity_reseeding", "documented": true}
	not conversion_violation(e)
	inp := object.union(conversion_input(e), {"oepul": object.union(base_input.oepul, {"participating_measures": []})})
	some v in o6_17.violations with input as inp
	v.rule_id == "O6_17-MB-6.1-NO-CONVERSION"
}

test_arable_grassland_swap_violation if {
	some v in o6_17.violations with input as with_o617({"arable_grassland_swap": true})
	v.rule_id == "O6_17-MB-6.1-NO-ARABLE-GRASSLAND-SWAP"
}

test_renewal_equipment_closed_list if {
	ok := with_parcels([object.union(base_parcels[0], {"operations": {"cutting_dates": ["2025-05-20"], "renewal_equipment": ["saatstriegel", "walze"]}})])
	count([v | some v in o6_17.violations with input as ok; v.rule_id == "O6_17-MB-6.2-RENEWAL-EQUIPMENT"]) == 0
	bad := with_parcels([object.union(base_parcels[0], {"operations": {"cutting_dates": ["2025-05-20"], "renewal_equipment": ["kreiselegge"]}})])
	some v in o6_17.violations with input as bad
	v.rule_id == "O6_17-MB-6.2-RENEWAL-EQUIPMENT"
}

training_violation(inp) if {
	some v in o6_17.violations with input as inp
	v.rule_id == "O6_17-MB-6.4-TRAINING"
}

test_training_five_hours_met if {
	inp := object.union(base_input, {"farm": {"year": 2026}})
	o6_17.training_obligation_met with input as inp
	not training_violation(inp)
}

test_training_insufficient_after_deadline if {
	inp := object.union(with_o617({"training": [{"hours": 3, "course_date": "2024-02-01", "provider_recognized": true, "grassland_topic": true, "person_role": "applicant"}]}), {"farm": {"year": 2026}})
	training_violation(inp)
}

test_training_not_checked_before_deadline if {
	inp := with_o617({"training": []})
	not training_violation(inp)
}

test_training_course_before_2022_not_creditable if {
	c := {"hours": 5, "course_date": "2021-11-01", "provider_recognized": true, "grassland_topic": true, "person_role": "applicant"}
	not o6_17.creditable_course(c) with input as base_input
}

test_training_person_left_before_deadline if {
	c := {"hours": 5, "course_date": "2023-01-10", "provider_recognized": true, "grassland_topic": true, "person_role": "significantly_involved_person", "person_left_farm_date": "2025-06-30"}
	not o6_17.creditable_course(c) with input as base_input
	c2 := object.union(c, {"person_left_farm_date": "2026-03-01"})
	o6_17.creditable_course(c2) with input as base_input
}

test_training_double_counting_not_allowed if {
	c := {"hours": 5, "course_date": "2023-01-10", "provider_recognized": true, "grassland_topic": true, "person_role": "applicant", "credited_to_other_obligation": true}
	not o6_17.creditable_course(c) with input as base_input
}

test_soil_samples_required_examples if {
	o6_17.soil_samples_required == 1 with input as with_o617({"eligible_grassland_lt18_mfa2025_ha": 4.9})
	o6_17.soil_samples_required == 3 with input as with_o617({"eligible_grassland_lt18_mfa2025_ha": 10.4})
	o6_17.soil_samples_required == 2 with input as base_input
}

test_soil_base_computed_from_parcels_in_2025 if {
	inp := with_o617({"eligible_grassland_lt18_mfa2025_ha": null})
	o6_17.soil_sample_base_ha == 8 with input as inp
}

test_soil_samples_insufficient_after_deadline if {
	inp := object.union(with_o617({"eligible_grassland_lt18_mfa2025_ha": 10.4}), {"farm": {"year": 2026}})
	some v in o6_17.violations with input as inp
	v.rule_id == "O6_17-MB-6.5-SOIL-SAMPLES"
}

test_soil_sample_requirements if {
	s := {"sample_id": "X", "drawn_date": "2021-12-01", "lab_submission_date": "2021-12-02", "lab_accredited": true, "method": "euf", "parameters": ["ph", "phosphorus", "potassium", "humus"]}
	not o6_17.valid_soil_sample(s) with input as base_input
	s2 := object.union(s, {"drawn_date": "2025-11-01", "lab_submission_date": "2026-01-05"})
	not o6_17.valid_soil_sample(s2) with input as base_input
	s3 := object.union(s, {"drawn_date": "2025-11-01", "lab_submission_date": "2025-11-05", "parameters": ["ph", "phosphorus", "potassium"]})
	not o6_17.valid_soil_sample(s3) with input as base_input
	s4 := object.union(s, {"drawn_date": "2025-11-01", "lab_submission_date": "2025-11-05"})
	o6_17.valid_soil_sample(s4) with input as base_input
}

test_minimum_management_on_grassland if {
	p1 := object.union(base_parcels[0], {"operations": {"cutting_dates": [], "full_grazing": false}})
	inp := with_parcels([p1])
	some v in o6_17.violations with input as inp
	v.rule_id == "O6_17-SRL-1.6.3.3-MIN-MANAGEMENT"
}

# ---------------------------------------------------------------------------
# Vertragszeitraum, Flächenänderungen, Sanktionen
# ---------------------------------------------------------------------------
test_area_reduction_tolerance if {
	inp := with_o617({"previous_year_committed_area_ha": 20, "committed_area_ha": 18.8})
	o6_17.area_reduction_tolerance_ha == 1 with input as inp
	o6_17.area_reduction_repayment_required with input as inp
	inp2 := with_o617({"previous_year_committed_area_ha": 100, "committed_area_ha": 95.5})
	not o6_17.area_reduction_repayment_required with input as inp2
	inp3 := with_o617({"previous_year_committed_area_ha": 6, "committed_area_ha": 5.6})
	o6_17.area_reduction_tolerance_ha == 0.5 with input as inp3
	not o6_17.area_reduction_repayment_required with input as inp3
	inp4 := with_o617({"previous_year_committed_area_ha": 200, "committed_area_ha": 194})
	o6_17.area_reduction_tolerance_ha == 5 with input as inp4
	o6_17.area_reduction_repayment_area_ha == 6 with input as inp4
}

test_loss_of_control_exempt_from_reduction if {
	inp := with_o617({"previous_year_committed_area_ha": 20, "committed_area_ha": 15, "reduction_exempt_ha": 4.5})
	not o6_17.area_reduction_repayment_required with input as inp
}

test_early_exit_repayment if {
	o6_17.early_exit_repayment_required with input as with_o617({"exit_date": "2026-05-01", "exit_reason": "voluntary"})
	not o6_17.early_exit_repayment_required with input as with_o617({"exit_date": "2026-05-01", "exit_reason": "force_majeure"})
}

test_takeover_deadline if {
	o6_17.takeover_permitted with input as with_o617({"takeover": {"date": "2028-04-17", "expansion_share": 0.2}})
	not o6_17.takeover_permitted with input as with_o617({"takeover": {"date": "2027-04-16", "expansion_share": 0.2}})
	not o6_17.takeover_permitted with input as with_o617({"takeover": {"date": "2027-04-10", "expansion_share": 0.6}})
}

test_sanction_cumulation_and_escalation if {
	inp := with_o617({"findings": [{"year": 2025, "base_stage": 3}, {"year": 2025, "base_stage": 2}]})
	o6_17.content_reduction_percent == 7 with input as inp
	inp2 := with_o617({"findings": [{"year": 2025, "base_stage": 3, "prior_occurrences_same_obligation": 1}]})
	o6_17.content_reduction_percent == 10 with input as inp2
}

test_warning_becomes_one_percent_from_2027 if {
	o6_17.content_reduction_percent == 0 with input as with_o617({"findings": [{"year": 2025, "base_stage": 1}]})
	inp := object.union(with_o617({"findings": [{"year": 2027, "base_stage": 1}]}), {"farm": {"year": 2027}})
	o6_17.content_reduction_percent == 1 with input as inp
}

test_exclusion_after_second_full_reduction if {
	inp := with_o617({"findings": [{"year": 2025, "base_stage": 7}], "previous_full_reductions": 1})
	o6_17.exclusion_from_measure with input as inp
	not o6_17.exclusion_from_measure with input as with_o617({"findings": [{"year": 2025, "base_stage": 7}]})
}

test_overdeclaration_sanction if {
	p1 := object.union(base_parcels[0], {"determined_area_ha": 5})
	inp := with_parcels([p1, base_parcels[2]])
	o6_17.overdeclaration_ha == 1 with input as inp
	o6_17.overdeclaration_sanction_applies with input as inp
	o6_17.overdeclaration_payment_basis_ha == 5.5 with input as inp
}

test_force_majeure_notice_three_weeks if {
	ok := with_o617({"force_majeure_events": [{"able_to_notify_date": "2025-06-01", "notification_date": "2025-06-22"}]})
	count([v | some v in o6_17.violations with input as ok; v.rule_id == "O6_17-GSPAV-6-FORCE-MAJEURE-NOTICE"]) == 0
	late := with_o617({"force_majeure_events": [{"able_to_notify_date": "2025-06-01", "notification_date": "2025-06-23"}]})
	some v in o6_17.violations with input as late
	v.rule_id == "O6_17-GSPAV-6-FORCE-MAJEURE-NOTICE"
}

test_decision_document if {
	d := o6_17.decision with input as base_input
	d.measure == "o6_17"
	d.first_participation_year == true
	d.soil_samples_required == [2]
}

# ---------------------------------------------------------------------------
# Datenintegrität der übernommenen Tabellen
# ---------------------------------------------------------------------------
test_kennarten_list_complete if {
	count(data.o6_17.kennarten.species) == 50
	count({k.id | some k in data.o6_17.kennarten.species}) == 50
}

test_combination_row_17_matches_annex_l if {
	some row in data.o6_17.combination_table.rows
	row.measure == "17"
	{c.with | some c in row.cells} == {"1A", "1B", "2", "3", "9"}
}

test_combination_table_symmetric_for_17 if {
	every m in {"1A", "1B", "2", "3", "9"} {
		some row in data.o6_17.combination_table.rows
		row.measure == m
		some c in row.cells
		c.with == "17"
	}
}

test_rgve_key_selected_factors if {
	some r1 in data.o6_17.rgve_key.rgve_conversion
	r1.key == "cattle_ge_2y"
	r1.rgve_per_head == 1
	some r2 in data.o6_17.rgve_key.rgve_conversion
	r2.key == "camelids_deer_game_lt_1y"
	r2.rgve_per_head == 0.07
	count([r | some r in data.o6_17.rgve_key.rgve_conversion; r.counts_for_livestock_status]) == 20
}

test_premium_tables_complete if {
	count(data.o6_17.premium_rates.base_premium_rates) == 8
	count(data.o6_17.premium_rates.agl_premium_rates) == 3
	count(data.o6_17.gloez.gloez9.habitat_types) == 25
}
