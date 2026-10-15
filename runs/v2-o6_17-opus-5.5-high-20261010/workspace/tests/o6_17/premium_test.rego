package oepul.o6_17.premium_test

import data.oepul.o6_17.agl
import data.oepul.o6_17.common
import data.oepul.o6_17.fixtures
import data.oepul.o6_17.premium

test_base_premium_by_grassland_number_2025 if {
	common.round2(premium.base_amount) == 226.8 with input as fixtures.base_input
}

test_grassland_number_tiers if {
	premium.base_tier({"grassland_number": 19.9}).tier_id == "gz_unter_20"
	premium.base_tier({"grassland_number": 20}).tier_id == "gz_20_bis_unter_30"
	premium.base_tier({"grassland_number": 39.9}).tier_id == "gz_30_bis_unter_40"
	premium.base_tier({"grassland_number": 40}).tier_id == "gz_ab_40"
}

test_rates_2023_differ_from_2024 if {
	premium.base_rate({"grassland_number": 45}) == 100.0 with input as fixtures.with_year(2023)
	premium.base_rate({"grassland_number": 45}) == 108.0 with input as fixtures.with_year(2024)
	premium.base_rate({"grassland_number": 10}) == 32.4 with input as fixtures.with_year(2026)
}

test_no_base_premium_on_slope_from_18 if {
	not premium.base_eligible(fixtures.parcel_g2) with input as fixtures.base_input
}

test_no_base_premium_on_gloez_ploughing_ban if {
	not premium.base_eligible(fixtures.parcel_g3) with input as fixtures.base_input
}

test_agl_allowed_on_gloez_parcel if {
	g := object.union(fixtures.parcel_g3, {"grassland_use_type": "streuwiese"})
	premium.agl_eligible(g) with input as fixtures.base_input
}

test_agl_rates_by_year_and_slope if {
	premium.agl_rate(fixtures.parcel_g1) == 150.0 with input as fixtures.with_year(2023)
	premium.agl_rate(fixtures.parcel_g1) == 262.0 with input as fixtures.with_year(2024)
	not premium.agl_rate(fixtures.parcel_g2) with input as fixtures.with_year(2024)
	premium.agl_rate(fixtures.parcel_g2) == 162.0 with input as fixtures.with_year(2025)
}

test_agl_cap_guaranteed_2ha if {
	premium.agl_cap_ha == 2.0 with input as fixtures.base_input
	common.round2(premium.agl_amount) == 433.09 with input as fixtures.base_input
}

test_agl_cap_15_percent_until_2024 if {
	big := object.union(fixtures.parcel_g1, {"area_ha": 40.0})
	inp := object.union(fixtures.with_parcels([big, fixtures.parcel_a1]), {"farm": {"year": 2024}})
	premium.agl_cap_ha == 6.0 with input as inp
	inp25 := fixtures.with_parcels([big, fixtures.parcel_a1])
	premium.agl_cap_ha == 10.0 with input as inp25
}

test_agl_requires_code_and_five_kennarten if {
	no_code := object.union(fixtures.parcel_g1, {"codes": []})
	not agl.qualifies(no_code) with input as fixtures.base_input
	poor := object.union(fixtures.parcel_g1, {"o6_17": {"agl_survey": object.union(fixtures.good_survey, {"sections": [{"section_id": "A", "species_found": ["Wiesen-Salbei", "Hornklee", "Zittergras", "Weißklee"]}]})}})
	not agl.qualifies(poor) with input as fixtures.base_input
}

test_kennart_with_several_species_counts_once if {
	sec := {"species_found": ["Primula elatior", "Primula veris", "Schlüsselblume"]}
	count(agl.section_kennarten(sec)) == 1
}

test_agl_first_use_must_be_mowing if {
	grazed := object.union(fixtures.parcel_g1, {"o6_17": {"agl_survey": object.union(fixtures.good_survey, {"first_use_is_mowing": false})}})
	not agl.qualifies(grazed) with input as fixtures.base_input
}

test_agl_photo_documentation_accepted if {
	photo := object.union(fixtures.parcel_g1, {"o6_17": {"agl_survey": object.union(fixtures.good_survey, {"documented": false, "sketch_documented": false, "photo_documented": true})}})
	agl.qualifies(photo) with input as fixtures.base_input
}

test_agl_code_on_dauerweide_flagged if {
	w := object.union(fixtures.parcel_g3, {"codes": ["AGL"]})
	inp := fixtures.with_parcels([fixtures.parcel_g1, w])
	some v in agl.violations with input as inp
	v.rule_id == "o6_17.agl.code_only_on_maehwiesen"
}

test_einmaehdige_wiese_automatic_without_code if {
	agl.qualifies(fixtures.parcel_g2) with input as fixtures.base_input
}

test_total_premium_base_farm if {
	premium.total_premium_eur == 659.89 with input as fixtures.base_input
}

test_no_premium_without_access_requirements if {
	inp := object.union(fixtures.base_input, {"farm": {"oepul": {"participating_measures": ["17"]}}})
	premium.total_premium_eur == 0 with input as inp
}

test_op_code_and_national_park_exclude_parcel if {
	op := object.union(fixtures.parcel_g1, {"codes": ["OP"]})
	not premium.base_eligible(op) with input as fixtures.base_input
	np := object.union(fixtures.parcel_g1, {"in_national_park": true})
	not premium.base_eligible(np) with input as fixtures.base_input
}

test_annex_l_parcel_combination if {
	naturschutz := object.union(fixtures.parcel_g1, {"oepul_measures": ["1A", "17", "18"]})
	not premium.parcel_combination_ok(naturschutz)
	heu := object.union(fixtures.parcel_g1, {"oepul_measures": ["1B_TB", "3", "9", "17"]})
	premium.parcel_combination_ok(heu)
}

test_modulation_example_220ha if {
	inp := object.union(fixtures.base_input, {"land": {"total_area_ha": 220}})
	round(premium.modulation_factor * 10000) == 9909 with input as inp
}

test_area_addition_cap_from_2026 if {
	big := object.union(fixtures.parcel_g1, {"area_ha": 20.0})
	inp := object.union(fixtures.with_parcels([big, fixtures.parcel_a1]), {"farm": {"year": 2026, "oepul": {"o6_17": {"area_basis_2025_ha": 10.0}}}})
	premium.addition_cap_ha == 15.0 with input as inp
	premium.base_area_factor == 0.75 with input as inp
}

test_minimum_payout_50_eur if {
	tiny := object.union(fixtures.parcel_g1, {"area_ha": 0.5, "codes": [], "grassland_number": 10})
	inp := fixtures.with_parcels([tiny, fixtures.parcel_g2, fixtures.parcel_a1])
	premium.below_minimum_payout with input as object.union(inp, {"farm": {"oepul": {"participating_measures": ["1A", "17"]}}, "land": {"parcels": [tiny]}})
}

test_area_payment_cap_flag if {
	g := object.union(fixtures.parcel_g1, {"oepul_other_payments_eur_per_ha": 1000})
	inp := fixtures.with_parcels([g, fixtures.parcel_g2, fixtures.parcel_a1])
	"G1" in premium.parcels_exceeding_area_payment_cap with input as inp
}

test_payment_deadline_and_advance if {
	premium.payment_deadline == "2026-06-30" with input as fixtures.base_input
	premium.max_advance_payment_eur == 494.92 with input as fixtures.base_input
}

test_parcel_below_50m2_not_payable if {
	tiny := object.union(fixtures.parcel_g1, {"area_ha": 0.004})
	not premium.base_eligible(tiny) with input as fixtures.base_input
	{"parcel_id": "G1", "reason": "below_50m2"} in premium.excluded_parcels with input as fixtures.with_parcels([tiny])
}
