package oepul.o6_2_test

import data.oepul.o6_2

premium_of(inp) := v if {
	v := o6_2.net_premium_eur with input as inp
}

approx(a, b) if abs(a - b) < 0.001

test_base_premium_2026 if {
	# 10 ha Acker x 64,8 + 5 ha Ackerfutter x 75,6 + 15 ha Grünland x 75,6
	gross := o6_2.gross_premium_eur with input as base_input
	approx(gross, 2160)
	approx(premium_of(base_input), 2160)
}

test_premium_2023_rates if {
	inp := json.patch(base_input, [
		{"op": "replace", "path": "/farm/year", "value": 2023},
		{"op": "replace", "path": "/farm/oepul/o6_2/contract_start_year", "value": 2023},
		{"op": "replace", "path": "/farm/oepul/o6_2/application_date", "value": "2022-12-15"},
	])
	gross := o6_2.gross_premium_eur with input as inp
	approx(gross, 2000)
}

test_non_livestock_forage_and_grassland_zero if {
	inp := json.patch(base_input, [{"op": "replace", "path": "/livestock/species_groups", "value": []}])
	gross := o6_2.gross_premium_eur with input as inp
	approx(gross, 648)
}

test_high_density_rate if {
	# 30 RGVE / 20 ha = 1,5 RGVE/ha
	inp := json.patch(base_input, [{"op": "replace", "path": "/livestock/species_groups/0/animal_count", "value": 30}])
	gross := o6_2.gross_premium_eur with input as inp
	approx(gross, 1944)
}

test_second_crop_forage_gets_arable_rate if {
	inp := with_parcel(1, "crop/forage_as_second_crop", true)
	rates := o6_2.parcel_premium_eur with input as inp
	approx(rates.F1, 324)
}

test_glaez8_npf_forage_until_2024 if {
	inp := json.patch(base_input, [
		{"op": "replace", "path": "/farm/year", "value": 2024},
		{"op": "add", "path": "/land/parcels/1/crop/glaez8_npf", "value": true},
	])
	excl := o6_2.parcel_exclusions with input as inp
	["F1", "glaez8_npf_forage_until_2024"] in excl
	later := json.patch(inp, [{"op": "replace", "path": "/farm/year", "value": 2025}])
	excl_later := o6_2.parcel_exclusions with input as later
	not ["F1", "glaez8_npf_forage_until_2024"] in excl_later
}

test_wine_fruit_hop_rate if {
	inp := json.patch(base_input, [{"op": "add", "path": "/land/parcels/-", "value": {"parcel_id": "W1", "area_ha": 2, "land_use": "special_crop", "land_use_code": "WI", "crop": {"crop_category": "vineyard", "crop_name": "Wein"}}}])
	rates := o6_2.parcel_premium_eur with input as inp
	approx(rates.W1, 129.6)
}

test_ungrafted_fruit_no_premium if {
	inp := json.patch(base_input, [{"op": "add", "path": "/land/parcels/-", "value": {"parcel_id": "O1", "area_ha": 1, "land_use": "special_crop", "crop": {"crop_category": "orchard", "crop_name": "Walnuss"}, "fruit_quality_planting_material": false}}])
	excl := o6_2.parcel_exclusions with input as inp
	["O1", "fruit_not_quality_planting_material"] in excl
}

test_fruit_2025_additions if {
	parcel := {"parcel_id": "O2", "area_ha": 1, "land_use": "special_crop", "crop": {"crop_category": "orchard", "crop_name": "Maulbeere"}}
	inp24 := json.patch(base_input, [{"op": "replace", "path": "/farm/year", "value": 2024}, {"op": "add", "path": "/land/parcels/-", "value": parcel}])
	excl24 := o6_2.parcel_exclusions with input as inp24
	["O2", "not_eligible_category"] in excl24
	inp25 := json.patch(base_input, [{"op": "replace", "path": "/farm/year", "value": 2025}, {"op": "add", "path": "/land/parcels/-", "value": parcel}])
	excl25 := o6_2.parcel_exclusions with input as inp25
	not ["O2", "not_eligible_category"] in excl25
}

test_op_code_and_national_park_no_premium if {
	inp := json.patch(base_input, [
		{"op": "replace", "path": "/land/parcels/0/oepul_codes", "value": ["OP"]},
		{"op": "add", "path": "/land/parcels/2/national_park", "value": "neusiedlersee"},
	])
	excl := o6_2.parcel_exclusions with input as inp
	["A1", "code_op_or_vf"] in excl
	["G1", "national_park"] in excl
	kalk := with_parcel(2, "national_park", "kalkalpen")
	excl_k := o6_2.parcel_exclusions with input as kalk
	not ["G1", "national_park"] in excl_k
}

test_alpine_pasture_and_greenhouse_not_eligible if {
	inp := json.patch(base_input, [
		{"op": "add", "path": "/land/parcels/-", "value": {"parcel_id": "L1", "area_ha": 20, "land_use": "alpine_pasture", "crop": {"crop_category": "other"}}},
		{"op": "add", "path": "/land/parcels/-", "value": {"parcel_id": "GA1", "area_ha": 0.3, "land_use": "arable", "land_use_code": "GA", "crop": {"crop_category": "vegetable", "crop_name": "Paradeiser"}}},
	])
	excl := o6_2.parcel_exclusions with input as inp
	["L1", "not_eligible_category"] in excl
	["GA1", "protected_cultivation"] in excl
}

test_modulation_factor_example_220_ha if {
	approx(o6_2.modulation_factor(220), 0.9909090909)
	approx(o6_2.modulation_factor(150), 1)
	approx(o6_2.modulation_factor(1100), (((200 + 90) + (700 * 0.85)) + (100 * 0.75)) / 1100)
}

test_area_payment_cap if {
	inp := with_parcel(2, "other_area_payments_eur_per_ha", 1260)
	net := o6_2.parcel_net_premium_eur with input as inp
	approx(net.G1, 600)
}

test_area_increase_limit_after_2025 if {
	inp := json.patch(base_input, [
		{"op": "add", "path": "/farm/oepul/o6_2/committed_area_2025_ha", "value": 20},
		{"op": "add", "path": "/farm/oepul/o6_2/new_area_additions_ha", "value": 12},
	])
	excess := o6_2.area_increase_excess_ha with input as inp
	approx(excess, 2)
	approx(premium_of(inp), 2160 - (2 * 72))
	small := json.patch(inp, [{"op": "replace", "path": "/farm/oepul/o6_2/committed_area_2025_ha", "value": 4}, {"op": "replace", "path": "/farm/oepul/o6_2/new_area_additions_ha", "value": 5}])
	excess_small := o6_2.area_increase_excess_ha with input as small
	excess_small == 0
}

test_sanction_reduction_and_warning_2027 if {
	inp := with_oepul("o6_2/sanction", {"level": "reduction_10", "full_reductions_in_contract_period": 0})
	approx(premium_of(inp), 1944)
	warn26 := with_oepul("o6_2/sanction", {"level": "warning"})
	approx(premium_of(warn26), 2160)
	warn27 := json.patch(warn26, [{"op": "replace", "path": "/farm/year", "value": 2027}])
	approx(premium_of(warn27), 2138.4)
}

test_exclusion_after_two_full_reductions if {
	inp := with_oepul("o6_2/sanction", {"level": "reduction_100", "full_reductions_in_contract_period": 2})
	o6_2.excluded_from_measure with input as inp
	o6_2.repayment_of_all_premiums_required with input as inp
	premium_of(inp) == 0
}

test_payment_application_missing_no_premium if {
	inp := with_oepul("o6_2/payment_application_submitted", false)
	premium_of(inp) == 0
}

test_small_payout_may_be_waived if {
	inp := json.patch(base_input, [{"op": "replace", "path": "/land/parcels", "value": [{"parcel_id": "A9", "area_ha": 0.5, "land_use": "arable", "crop": {"crop_category": "cereal", "crop_name": "Gerste"}}]}, {"op": "replace", "path": "/land/total_area_ha", "value": 0.5}])
	o6_2.payout_may_be_waived with input as inp
	not o6_2.payout_may_be_waived with input as base_input
}

test_max_advance_payment if {
	adv := o6_2.max_advance_payment_eur with input as base_input
	approx(adv, 1620)
}
