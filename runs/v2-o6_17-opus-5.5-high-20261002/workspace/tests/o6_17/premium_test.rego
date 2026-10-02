package oepul.o6_17_test

import rego.v1

import data.oepul.o6_17

approx(a, b) if abs(a - b) < 0.0001

# --- Grundprämie --------------------------------------------------------------

test_base_rate_tiers_from_2024 if {
	o6_17.base_rate_for(19.9) == 32.4 with input as base_input
	o6_17.base_rate_for(20) == 54.0 with input as base_input
	o6_17.base_rate_for(29.99) == 54.0 with input as base_input
	o6_17.base_rate_for(30) == 75.6 with input as base_input
	o6_17.base_rate_for(40) == 108.0 with input as base_input
}

test_base_rate_tiers_2023 if {
	inp := with_year(2023)
	o6_17.base_rate_for(10) == 30.0 with input as inp
	o6_17.base_rate_for(25) == 50.0 with input as inp
	o6_17.base_rate_for(35) == 70.0 with input as inp
	o6_17.base_rate_for(45) == 100.0 with input as inp
}

test_base_premium_only_below_18_percent if {
	# P1: 6 ha, GLZ 35 -> 75,6 €/ha; P2 (22 %) und Kleegras erhalten keine Grundprämie
	approx(o6_17.base_premium_eur, 453.6) with input as base_input
	not o6_17.base_premium_parcels.P2 with input as base_input
	not o6_17.base_premium_parcels.A1 with input as base_input
}

test_gloez_area_no_base_premium_but_agl if {
	p := parcel_with(agl_meadow, {"gloez_conversion_ban": "gloez4"})
	inp := with_parcels([p, single_cut, clover])
	not o6_17.base_premium_parcels.P1 with input as inp
	o6_17.agl_parcels.P1 with input as inp
}

test_op_code_excludes_premium if {
	p := parcel_with(meadow, {"codes": ["OP"]})
	o6_17.parcel_excluded_reason(p) == "op_code"
	not o6_17.base_premium_parcels.P1 with input as with_parcels([p, single_cut, clover])
}

test_national_park_neusiedlersee_excluded if {
	p := parcel_with(meadow, {"national_park": "neusiedlersee"})
	not o6_17.base_premium_parcels.P1 with input as with_parcels([p, single_cut, clover])
}

test_other_national_park_without_restrictions_eligible if {
	p := parcel_with(meadow, {"national_park": "hohe_tauern", "national_park_relevant_restrictions": false})
	o6_17.base_premium_parcels.P1 with input as with_parcels([p, single_cut, clover])
}

test_sonstige_gruenlandflaechen_not_eligible if {
	p := parcel_with(meadow, {"field_use_type": "sonstige_gruenlandflaechen"})
	o6_17.parcel_excluded_reason(p) == "field_use_not_eligible"
}

test_missing_grassland_number_flagged if {
	p := object.union(object.remove(meadow, ["oepul"]), {"oepul": object.remove(meadow.oepul, ["grassland_number"])})
	"P1" in o6_17.base_parcels_missing_grassland_number with input as with_parcels([p, single_cut, clover])
}

test_naturschutz_not_combinable_on_same_area if {
	p := parcel_with(meadow, {"measures": ["o6_1a", "o6_17", "o6_18"]})
	inp := with_parcels([p, single_cut, clover])
	o6_17.parcel_combination_conflict(p)
	not o6_17.base_premium_parcels.P1 with input as inp
	some c in o6_17.combination_conflicts with input as inp
	c.measures == {"o6_18"}
}

test_heuwirtschaft_combinable if {
	p := parcel_with(meadow, {"measures": ["o6_1b", "o6_3", "o6_17"]})
	not o6_17.parcel_combination_conflict(p)
	o6_17.combinable("o6_17", "o6_9")
	not o6_17.combinable("o6_17", "o6_4")
}

# --- Flächenzugang ----------------------------------------------------------

test_area_increase_full_in_2025 if {
	o6_17.area_increase_factor == 1 with input as with_measure({"measure_area_2025_ha": 2.0})
}

test_area_increase_capped_from_2026 if {
	# Basis 2025: 0,5 ha -> Obergrenze 0,5 + max(0,25; 5) = 5,5 ha; beantragt 6 ha
	inp := object.union(with_measure({"measure_area_2025_ha": 0.5}), {"farm": object.union(with_measure({"measure_area_2025_ha": 0.5}).farm, {"year": 2026})})
	o6_17.premium_area_cap_ha == 5.5 with input as inp
	approx(o6_17.area_increase_factor, 5.5 / 6) with input as inp
}

test_area_increase_50_percent_rule if {
	inp := object.union(with_measure({"measure_area_2025_ha": 20.0}), {"farm": object.union(with_measure({"measure_area_2025_ha": 20.0}).farm, {"year": 2027})})
	o6_17.premium_area_cap_ha == 30 with input as inp
}

# --- Zuschlag artenreiches Grünland -------------------------------------------

test_agl_automatic_single_cut_meadow_steep_from_2025 if {
	# P2: einmähdige Wiese, 22 % Hangneigung -> 162 €/ha ab 2025
	o6_17.agl_parcels.P2.rate_eur_per_ha == 162.0 with input as base_input
}

test_agl_steep_not_eligible_2024 if {
	not o6_17.agl_parcels.P2 with input as with_year(2024)
}

test_agl_rate_2023_and_2024 if {
	inp23 := with_parcels([agl_meadow, single_cut, clover])
	o6_17.agl_parcels.P1.rate_eur_per_ha == 150.0 with input as object.union(inp23, {"farm": object.union(inp23.farm, {"year": 2023})})
	o6_17.agl_parcels.P1.rate_eur_per_ha == 262.0 with input as object.union(inp23, {"farm": object.union(inp23.farm, {"year": 2024})})
}

test_agl_requires_code_on_multi_cut_meadow if {
	not o6_17.agl_parcels.P1 with input as base_input
}

test_agl_cap_minimum_2_ha if {
	# gemähtes Grünland 7 ha -> 25 % = 1,75 ha < 2,00 ha -> Obergrenze 2,00 ha
	inp := with_parcels([agl_meadow, single_cut, clover])
	o6_17.mown_grassland_ha == 7 with input as inp
	o6_17.agl_cap_ha == 2 with input as inp
	o6_17.agl_eligible_area_ha == 7 with input as inp
	o6_17.agl_premium_area_ha == 2 with input as inp

	# (6 * 262 + 1 * 162) * 2/7
	approx(o6_17.agl_premium_eur, ((6 * 262) + 162) * (2 / 7)) with input as inp
}

test_agl_cap_25_percent_large_farm if {
	big := object.union(agl_meadow, {"area_ha": 40.0})
	inp := with_parcels([big, single_cut, clover])
	o6_17.agl_cap_ha == 10.25 with input as inp
}

test_agl_cap_15_percent_until_2024 if {
	big := object.union(agl_meadow, {"area_ha": 40.0})
	inp := with_parcels([big, single_cut, clover])
	approx(o6_17.agl_cap_ha, 6.15) with input as object.union(inp, {"farm": object.union(inp.farm, {"year": 2024})})
}

test_bergmaehder_not_agl_and_not_mown_basis if {
	berg := object.union(single_cut, {"parcel_id": "B1", "oepul": object.union(single_cut.oepul, {"field_use_type": "bergmaehder"})})
	inp := with_parcels([meadow, berg, clover])
	not o6_17.agl_parcels.B1 with input as inp
	o6_17.mown_grassland_ha == 6 with input as inp
}

# --- Modulation, Obergrenzen, Auszahlung --------------------------------------

test_modulation_example_220_ha if {
	inp := object.union(base_input, {"land": object.union(base_input.land, {"total_area_ha": 220.0})})
	approx(o6_17.modulation_factor, 218 / 220) with input as inp
}

test_modulation_tiers_large_farm if {
	inp := object.union(base_input, {"land": object.union(base_input.land, {"total_area_ha": 1200.0})})

	# 200*1 + 100*0.9 + 700*0.85 + 200*0.75 = 1035
	approx(o6_17.modulation_factor, 1035 / 1200) with input as inp
}

test_modulation_small_farm_full if {
	o6_17.modulation_factor == 1 with input as base_input
}

test_area_payment_cap_1300 if {
	o6_17.area_payment_cap_eur_per_ha == 1300.0 with input as base_input
	p := parcel_with(meadow, {"other_area_payments_eur_per_ha": 1250})
	"P1" in o6_17.parcel_area_payment_cap_exceeded with input as with_parcels([p, single_cut, clover])
}

test_area_payment_cap_naturschutz_1500 if {
	inp := object.union(base_input, {"farm": object.union(base_input.farm, {"oepul": object.union(base_input.farm.oepul, {"measures": [{"measure_id": "o6_1a"}, {"measure_id": "o6_18"}]})})})
	o6_17.area_payment_cap_eur_per_ha == 1500.0 with input as inp
}

test_decision_premium_payable if {
	d := o6_17.decision with input as base_input
	d.contract_concluded
	d.access_conditions_met
	d.violations == set()

	# 453,6 (Grundprämie) + 162 (AGL P2, innerhalb Obergrenze 2 ha)
	approx(d.premium_payable_eur, 615.6)
}

test_payment_threshold_50_eur if {
	tiny := object.union(meadow, {"area_ha": 0.5})
	o6_17.payment_may_be_withheld with input as with_parcels([tiny, clover])
}

test_payment_deadline_and_advance if {
	o6_17.payment_deadline == "2026-06-30" with input as base_input
	approx(o6_17.advance_payment_max_eur, 615.6 * 0.75) with input as base_input
}
