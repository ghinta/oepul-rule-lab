package oepul.o6_16_test

import data.oepul.o6_16

# Beispiele aus Kapitel 4.3 des Maßnahmenblattes
test_example_eferding_2024 if {
	# Körnermais, Saldo 20 kg/ha, 60 % -> 12 kg/ha
	o6_16.required_n_reduction(20, 2024, "restliche_gebietskulisse") == 12
}

test_example_eferding_2025_no_carryover if {
	# ab 2025 erst über 20 kg/ha anzurechnen
	o6_16.required_n_reduction(20, 2025, "restliche_gebietskulisse") == 0
}

test_example_green_fallow_2024 if {
	# 12 kg/ha auf Grünbrache, im 1. Bestandsjahr auf 60 % = 7,2 kg/ha; danach unter 10 kg/ha kein Übertrag mehr
	o6_16.required_n_reduction(12, 2024, "restliche_gebietskulisse") == 7.2
	o6_16.required_n_reduction(7.2, 2024, "restliche_gebietskulisse") == 0
}

test_example_tullnerfeld if {
	# Zuckerrübe im Tullnerfeld, Saldo 30 kg/ha, 80 % -> 24 kg/ha
	o6_16.required_n_reduction(30, 2025, "oestliches_niederoesterreich_inkl_tullnerfeld") == 24
}

test_example_hail_zollfeld if {
	o6_16.required_n_reduction(180, 2024, "restliche_gebietskulisse") == 108
	o6_16.required_n_reduction(180, 2025, "restliche_gebietskulisse") == 60
}

test_threshold_strictly_greater if {
	not o6_16.carryover_required(10, 2024)
	o6_16.carryover_required(10.5, 2024)
	not o6_16.carryover_required(20, 2026)
}

test_vienna_zone_from_annex_g if {
	p := {"parcel_id": "W", "cadastral_community_number": "1104"}
	o6_16.parcel_zone(p) == "wien"
	o6_16.reduction_factor("wien") == 0.8
	o6_16.reduction_factor("restliche_gebietskulisse") == 0.6
}

test_unused_cover_crop_example if {
	# Saldo-Übertrag 25 kg/ha, Soja Düngebedarf 60 kg/ha -> max. 35 kg/ha
	o6_16.max_unused_cover_crop_n(60, 25) == 35
}

test_vegetable_nmin_deduction if {
	o6_16.vegetable_n_deduction(15, 40) == 40
	o6_16.vegetable_n_deduction(55, 40) == 55
}

test_follow_crop_fertilization_exceeds if {
	p := object.union(maize_parcel, {"n_management": {"follow_crop_n_fertilization_kg_ha": 150}})
	inp := with_parcels([p, wheat_parcel])
	"o6_16.n.carryover_reduction" in rule_ids(o6_16.violations) with input as inp
}

test_missing_zone_reported if {
	p := json.remove(object.union(maize_parcel, {"previous_crop": {"n_saldo_kg_ha": 25}}), ["n_reduction_zone"])
	inp := with_parcels([p])
	count(o6_16.missing_data) > 0 with input as inp
}

test_reduction_factor_once if {
	p := object.union(maize_parcel, {"n_management": {"reduction_factor_applications": 2}})
	"o6_16.n.reduction_factor_once" in rule_ids(o6_16.violations) with input as with_parcels([p])
}

test_legume_offtake_basis if {
	p := object.union(maize_parcel, {
		"previous_crop": {"crop_category": "legume", "crop_name": "Sojabohne", "n_saldo_kg_ha": 0},
		"n_management": {"offtake_basis": "yield_based"},
	})
	"o6_16.n.legume_offtake_basis" in rule_ids(o6_16.violations) with input as with_parcels([p])
}

test_unused_cover_crop_violation if {
	p := object.union(maize_parcel, {"n_management": {"unused_cover_crop_n_kg_ha": 140}})

	# Bedarf 160 - Übertrag 24 = 136
	"o6_16.n.unused_cover_crop_max" in rule_ids(o6_16.violations) with input as with_parcels([p])
}

# Herbst-Anlageverpflichtung
test_autumn_obligation_saldo_over_30 if {
	p := object.union(maize_parcel, {"previous_crop": {"n_saldo_kg_ha": 40, "harvest_date": "2025-08-01"}, "n_management": {"follow_crop_n_fertilization_kg_ha": 100}})
	"o6_16.n.autumn_sowing_obligation" in rule_ids(o6_16.violations) with input as with_parcels([p])
}

test_autumn_obligation_fulfilled_by_cover_crop if {
	p := object.union(maize_parcel, {
		"previous_crop": {"n_saldo_kg_ha": 40, "harvest_date": "2025-08-01"},
		"n_management": {"follow_crop_n_fertilization_kg_ha": 100},
		"operations": {"cover_crop": {"is_used": true, "sowing_date": "2025-08-20"}},
	})
	not "o6_16.n.autumn_sowing_obligation" in rule_ids(o6_16.violations) with input as with_parcels([p])
}

test_autumn_obligation_fulfilled_by_sowing_before_15_11 if {
	p := object.union(maize_parcel, {
		"previous_crop": {"n_saldo_kg_ha": 40, "harvest_date": "2025-08-01"},
		"n_management": {"follow_crop_n_fertilization_kg_ha": 100, "follow_crop_sowing_date": "2025-10-10"},
	})
	not "o6_16.n.autumn_sowing_obligation" in rule_ids(o6_16.violations) with input as with_parcels([p])
}

test_autumn_obligation_late_harvest_exempt if {
	p := object.union(maize_parcel, {"previous_crop": {"n_saldo_kg_ha": 40, "harvest_date": "2025-10-10"}, "n_management": {"follow_crop_n_fertilization_kg_ha": 100}})
	not "o6_16.n.autumn_sowing_obligation" in rule_ids(o6_16.violations) with input as with_parcels([p])
}

test_autumn_obligation_vegetable_parcel if {
	p := object.union(maize_parcel, {"area_ha": 0.5, "previous_crop": {"crop_category": "vegetable", "crop_name": "Karotte", "n_saldo_kg_ha": 5, "harvest_date": "2025-09-01"}})
	"o6_16.n.autumn_sowing_obligation" in rule_ids(o6_16.violations) with input as with_parcels([p])
}

test_autumn_obligation_small_vegetable_parcel_exempt if {
	p := object.union(maize_parcel, {"area_ha": 0.3, "previous_crop": {"crop_category": "vegetable", "crop_name": "Karotte", "n_saldo_kg_ha": 5, "harvest_date": "2025-09-01"}})
	not "o6_16.n.autumn_sowing_obligation" in rule_ids(o6_16.violations) with input as with_parcels([p])
}

test_autumn_obligation_forage_breakup_not_exempt_by_late_harvest if {
	p := object.union(maize_parcel, {"previous_crop": {"crop_category": "other", "crop_name": "Luzerne", "n_saldo_kg_ha": 0, "harvest_date": "2025-10-05", "breakup_date": "2025-10-20"}})
	"o6_16.n.autumn_sowing_obligation" in rule_ids(o6_16.violations) with input as with_parcels([p])
}
