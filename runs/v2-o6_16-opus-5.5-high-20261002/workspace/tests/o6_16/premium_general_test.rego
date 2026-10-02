package oepul.o6_16_test

import data.oepul.o6_16

test_base_premium_2026 if {
	o6_16.premium_total == 1939.2 with input as base_input
	c := o6_16.premium_components.basis with input as base_input
	c.rate_eur_per_ha == 54
	t := o6_16.premium_components.training_first_10ha with input as base_input
	t.area_ha == 10
}

test_premium_rates_2023 if {
	o6_16.premium_rate("basis", 2023) == 50
	o6_16.premium_rate("basis_reduced", 2023) == 25
	o6_16.premium_rate("training_first_10ha", 2023) == 30
	o6_16.premium_rate("leaching_risk_area", 2023) == 500
	not o6_16.premium_rate("cultan", 2024)
	o6_16.premium_rate("cultan", 2025) == 40
}

test_basis_reduced_with_bio_and_no_psm_premium if {
	inp := object.union(base_input, {"farm": {"oepul": {"participating_measures": ["o6_16", "o6_6", "o6_1b"]}}})
	c := o6_16.premium_components.basis_reduced with input as inp
	c.amount_eur == 540
	p := o6_16.premium_components.psm_maize_sorghum with input as inp
	p.amount_eur == 0
}

test_basis_reduced_with_eeb if {
	inp := object.union(base_input, {"farm": {"oepul": {"participating_measures": ["o6_16", "o6_6", "o6_2"]}}})
	o6_16.basis_component == "basis_reduced" with input as inp
	p := o6_16.premium_components.psm_maize_sorghum with input as inp
	p.amount_eur == 259.2
}

test_psm_premium_not_in_protection_zone if {
	p := object.union(maize_parcel, {"oepul": {"in_protection_or_conservation_zone": true}})
	c := o6_16.premium_components.psm_maize_sorghum with input as with_parcels([p, wheat_parcel])
	c.area_ha == 0
}

test_psm_premium_rape_and_seed_maize if {
	r := object.union(wheat_parcel, {"crop": {"crop_category": "oilseed", "crop_name": "Winterraps"}})
	s := object.union(maize_parcel, {"crop": {"crop_name": "Saatmaisvermehrung"}})
	c := o6_16.premium_components.psm_rape_seed_maize with input as with_parcels([r, s])
	c.area_ha == 20
	m := o6_16.premium_components.psm_maize_sorghum with input as with_parcels([r, s])
	m.area_ha == 0
}

test_ooe_top_up if {
	p := object.union(wheat_parcel, {"cadastral_community_number": "51106"})
	c := o6_16.premium_components.upper_austria_top_up with input as with_parcels([p])
	c.amount_eur == 259.2
	inp := object.union(with_parcels([p]), {"farm": {"oepul": {"o6_16": {"upper_austria_top_up_funds_available": false}}}})
	c2 := o6_16.premium_components.upper_austria_top_up with input as inp
	c2.amount_eur == 0
}

test_pig_feeding_premium_all_arable_from_2025 if {
	c := o6_16.premium_components.n_reduced_pig_feeding with input as pig_input(100)
	c.area_ha == 22
	c2 := o6_16.premium_components.n_reduced_pig_feeding with input as with_year(pig_input(100), 2024)
	c2.area_ha == 20
}

test_op_coded_parcel_no_premium if {
	p := object.union(wheat_parcel, {"oepul": {"codes": ["OP"]}})
	o6_16.basis_parcels_ha == 12 with input as with_parcels([maize_parcel, p])
}

# Allgemeine Bedingungen
test_modulation_example_220_ha if {
	approx(o6_16.modulation_factor(220), 0.990909)
	o6_16.modulation_factor(150) == 1
	approx(o6_16.modulation_factor(230), 0.986956)
}

test_modulation_applied_to_total if {
	inp := object.union(base_input, {"land": {"total_area_ha": 220}})
	o6_16.premium_total == 1921.57 with input as inp
}

test_area_reduction_tolerance if {
	o6_16.allowed_area_reduction(4) == 0.5
	o6_16.allowed_area_reduction(40) == 2
	o6_16.allowed_area_reduction(200) == 5
	o6_16.area_reduction_repayment_required(30, 20)
	not o6_16.area_reduction_repayment_required(20, 19)
	inp := with_o16({"premium_area_previous_year_ha": 30})
	"o6_16.general.area_reduction_tolerance" in rule_ids(o6_16.violations) with input as inp
}

test_area_increase_limit if {
	o6_16.limited_increase_area(40, 20, 2026) == 30
	o6_16.limited_increase_area(24, 20, 2026) == 24
	o6_16.limited_increase_area(12, 4, 2026) == 9
	o6_16.limited_increase_area(40, 20, 2025) == 40
	o6_16.limited_increase_area(40, 20, 2024) == 40
}

test_area_increase_limit_in_premium if {
	inp := with_o16({"premium_area_2025_ha": 4})
	c := o6_16.premium_components.basis with input as inp
	c.area_ha == 9
}

test_public_body_excluded if {
	inp := object.union(base_input, {"farm": {"applicant": {"public_body_share_percent": 30}}})
	"o6_16.general.applicant_public_body" in rule_ids(o6_16.violations) with input as inp
	not o6_16.public_body_excluded_for("o6_6", 2026, 30)
	o6_16.public_body_excluded_for("o6_10", 2025, 30)
	not o6_16.public_body_excluded_for("o6_10", 2024, 30)
}

test_min_farm_size_first_oepul_year if {
	inp := object.union(base_input, {"farm": {"oepul": {"first_oepul_participation_year": 2026}}, "land": {"total_area_ha": 1.2}})
	"o6_16.general.min_farm_size" in rule_ids(o6_16.violations) with input as inp
}

test_sanction_stages if {
	o6_16.sanction_reduction_percent(1, 2026) == 0
	o6_16.sanction_reduction_percent(1, 2027) == 1
	o6_16.sanction_reduction_percent(5, 2026) == 25
}

test_payment_rules if {
	o6_16.payment_deadline(2026) == "2027-06-30"
	o6_16.max_advance_payment(1000) == 750
	o6_16.payout_may_be_withheld(50)
	not o6_16.payout_may_be_withheld(50.01)
}

test_area_payment_caps if {
	o6_16.area_payment_cap("standard", 2023) == 1200
	o6_16.area_payment_cap("standard", 2026) == 1300
	o6_16.area_payment_cap("o6_18_o6_19", 2026) == 1500
	o6_16.area_payment_cap_exceeded(1350, "standard", 2026)
}

test_conversion_and_takeover if {
	o6_16.conversion_allowed("o6_16_auswaschungsgefaehrdete_ackerflaechen", "o6_19", "2025-12-31")
	not o6_16.conversion_allowed("o6_16_auswaschungsgefaehrdete_ackerflaechen", "o6_19", "2026-12-31")
	o6_16.takeover_deadline(2026) == "2026-04-15"
	o6_16.takeover_deadline(2028) == "2028-04-17"
	o6_16.takeover_individual_cases_only("o6_16_n_reduced_pig_feeding")
	o6_16.takeover_extension_ok(10, 5)
	not o6_16.takeover_extension_ok(10, 6)
}

test_livestock_farm_definition if {
	o6_16.livestock_farm(3, 10)
	not o6_16.livestock_farm(2.9, 10)
}

test_minimum_harvest_share if {
	p := object.union(wheat_parcel, {"harvest": {"harvested_share": 0.5}})
	inp := object.union(with_parcels([p]), {"farm": {"region": {"district": "Lilienfeld"}}})
	"o6_16.general.minimum_management_harvest" in rule_ids(o6_16.violations) with input as inp
}

# Hinweise 2026
test_drought_relief_tulln_2026 if {
	p := object.union(maize_parcel, {"harvest": {"harvested_share": 0.2, "no_harvestable_stand_due_to_drought": true}})
	inp := with_parcels([p])
	not "o6_16.general.minimum_management_harvest" in rule_ids(o6_16.violations) with input as inp
	"o6_16.general.minimum_management_harvest" in rule_ids(o6_16.violations) with input as with_year(inp, 2025)
}

test_drought_relief_styria_extension if {
	o6_16.drought_relief_district("steiermark", "Leibnitz")
	not o6_16.drought_relief_district("steiermark", "Murau")
	o6_16.drought_relief_district("burgenland", "Güssing")
	o6_16.drought_relief_district("oberoesterreich", "Eferding")
	not o6_16.drought_relief_district("kaernten", "Klagenfurt Land")
}

test_greening_relief_2026 if {
	o6_16.greening_coverage_relief(2026, "o6_6", true)
	not o6_16.greening_coverage_relief(2026, "o6_6", false)
	not o6_16.greening_coverage_relief(2025, "o6_7", true)
	o6_16.o6_6_latest_sowing_2026(2) == "2026-08-10"
	o6_16.o6_7_latest_cover_crop_2026(true) == "2026-09-20"
	o6_16.o6_7_latest_cover_crop_2026(false) == "2026-10-15"
}

test_div_third_use_2026_requires_op_code if {
	p := object.union(ag_parcel, {"oepul": {"codes": ["AG", "DIV"]}, "operations": {"cutting_dates": ["2026-08-02", "2026-09-01", "2026-10-01"]}})
	"o6_16.notice2026.div_third_use" in rule_ids(o6_16.violations) with input as ag_input(p)
	p2 := object.union(p, {"oepul": {"codes": ["AG", "DIV", "OPUBB"]}})
	not "o6_16.notice2026.div_third_use" in rule_ids(o6_16.violations) with input as ag_input(p2)
}

test_div_early_use_beyond_25_percent if {
	p := object.union(ag_parcel, {"oepul": {"codes": ["AG", "DIV"]}, "operations": {"cutting_dates": ["2026-06-15"]}})
	"o6_16.notice2026.div_early_use" in rule_ids(o6_16.violations) with input as ag_input(p)
}

test_decision_structure if {
	d := o6_16.decision with input as base_input
	d.measure == "o6_16"
	d.access_conditions_met == true
	d.premium_total == 1939.2
}

test_annex_l_combination_row if {
	o6_16.combinable_on_parcel("o6_6")
	o6_16.combinable_on_parcel("o6_1b")
	o6_16.combination_with_premium_deduction("o6_1b")
	o6_16.combination_with_premium_deduction("o6_2")
	not o6_16.combination_with_premium_deduction("o6_1a")
	not o6_16.combinable_on_parcel("o6_18")
	not o6_16.combinable_on_parcel("o6_17")
	o6_16.combinable_on_parcel("o6_24")
}
