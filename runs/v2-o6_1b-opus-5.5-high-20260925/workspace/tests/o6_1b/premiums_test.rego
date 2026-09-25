package oepul.o6_1b_test

import data.oepul.o6_1b

comp(inp, key) := v if {
	v := o6_1b.premium_components[key] with input as inp
}

year_input(ps, y) := json.patch(with_parcels(ps), [{"op": "replace", "path": "/farm/year", "value": y}])

test_base_farm_premiums if {
	# 20 ha Acker x 235 = 4700
	comp(base_input, "arable_base") == 4700

	# Grünland tierhaltend < 1,4 RGVE/ha: 10 ha x 232,2
	approx(comp(base_input, "grassland_base"), 2322)
	comp(base_input, "transaction_costs") == 400
}

# Beispiel Kap. 8.3: 100 ha Acker, 8 ha DIV -> 1 ha Zuschlag über 7 %
test_over_7_percent_example_1 if {
	ps := [arable("A1", 92, "Winterweizen"), div_arable("D1", 8, [])]
	approx(comp(with_parcels(ps), "arable_div_over_7"), 324)
}

# Beispiel Kap. 8.3: 8 ha DIV (davon 1 ha GLÖZ 4) + 2 ha NAT+DIV -> kein Zuschlag
test_over_7_percent_example_2 if {
	g4 := object.union(div_arable("D2", 1, []), {"constraints": {"biodiversity_area": {"gloez4_buffer_strip": true}}})
	nat := object.union(div_arable("N1", 2, ["NAT"]), {"constraints": {"biodiversity_area": {"nat_auflagen": ["SA01"]}}})
	ps := [arable("A1", 90, "Winterweizen"), div_arable("D1", 7, []), g4, nat]
	comp(with_parcels(ps), "arable_div_over_7") == 0

	# 8 ha Grünbrache + DIV erhalten die Basismodulprämie, NAT-Fläche nicht
	approx(comp(with_parcels(ps), "arable_base"), 98 * 235)
}

test_div_supplements_capped_at_20_percent if {
	ps := [arable("A1", 70, "Winterweizen"), object.union(div_arable("D1", 30, []), {"ackerzahl": 60})]
	inp := with_parcels(ps)

	# über 7 %: 20 - 7 = 13 ha x 324
	approx(comp(inp, "arable_div_over_7"), 13 * 324)

	# Ackerzahl >= 50: max 20 ha x 140
	approx(comp(inp, "arable_div_ackerzahl_50"), 20 * 140)

	# Grünbrache in der Basismodulprämie max. 20 %: 70 + 20 ha
	approx(comp(inp, "arable_base"), 90 * 235)
}

# Beispiel Kap. 8.3: mindestens 3 DIV-Schläge bei 6,01 ha Ackerfläche
test_per_3ha_example if {
	two := [arable("A1", 5.21, "Winterweizen"), div_arable("D1", 0.4, []), div_arable("D2", 0.4, [])]
	comp(with_parcels(two), "arable_div_per_3ha") == 0
	three := [arable("A1", 5.11, "Winterweizen"), div_arable("D1", 0.3, []), div_arable("D2", 0.3, []), div_arable("D3", 0.3, [])]
	approx(comp(with_parcels(three), "arable_div_per_3ha"), 0.9 * 54)
	small := [arable("A1", 5.18, "Winterweizen"), div_arable("D1", 0.4, []), div_arable("D2", 0.4, []), div_arable("D3", 0.03, [])]
	comp(with_parcels(small), "arable_div_per_3ha") == 0
}

# Beispiel Kap. 9.3: mindestens 7 DIV-Schläge bei 18,01 ha gemähter Grünlandfläche
test_grassland_per_3ha_example if {
	o6_1b.arable_div_per_3ha_required == 7 with input as with_parcels([arable("A1", 18.01, "Kleegras")])
}

# Beispiel Kap. 8.6: 50 ha Acker, 5 ha Ackerbohne, 10 ha Sonnenblume, 10 ha Wechselwiese -> 1.836 EUR
test_foerderwuerdige_example if {
	ps := [
		arable("A1", 5, "Ackerbohne"), arable("A2", 10, "Sonnenblume"), arable("A3", 10, "Wechselwiese"),
		arable("A4", 21.5, "Winterweizen"), div_arable("D1", 3.5, []),
	]
	approx(comp(with_parcels(ps), "foerderwuerdige_kulturen"), 1836)
}

# Beispiel Kap. 8.6: 10 % DIV, 3 % DIV mit NAT, 5 % Sonnenblume, 5 % Raps -> Schwelle 15 % erreicht
test_foerderwuerdige_threshold_with_div if {
	nat := object.union(div_arable("N1", 3, ["NAT"]), {"constraints": {"biodiversity_area": {"nat_auflagen": ["SA01"]}}})
	ps := [div_arable("D1", 10, []), nat, arable("A1", 5, "Sonnenblume"), arable("A2", 5, "Raps"), arable("A3", 77, "Winterweizen")]
	o6_1b.fw_threshold_met with input as with_parcels(ps)
	approx(comp(with_parcels(ps), "foerderwuerdige_kulturen"), 10 * 86.4)
	no_div := [arable("A1", 5, "Sonnenblume"), arable("A2", 5, "Raps"), arable("A3", 90, "Winterweizen")]
	comp(with_parcels(no_div), "foerderwuerdige_kulturen") == 0
}

test_second_crop_higher_rate_counts_once if {
	p := object.union(arable("A1", 10, "Wechselwiese"), {"crop": {"crop_name": "Wechselwiese", "second_crop_name": "Erbsen"}})
	ps := [p, arable("A2", 40, "Winterweizen")]
	approx(comp(with_parcels(ps), "foerderwuerdige_kulturen"), 10 * 129.6)
}

test_npf_code_excludes_until_2024 if {
	p := object.union(arable("A1", 10, "Luzerne"), {"oepul_codes": ["NPF"]})
	ps := [p, arable("A2", 40, "Winterweizen")]
	comp(year_input(ps, 2024), "foerderwuerdige_kulturen") == 0
	approx(comp(year_input(ps, 2025), "foerderwuerdige_kulturen"), 10 * 64.8)
}

test_erosion_reduction if {
	mais := object.union(arable("A1", 2, "Körnermais"), {"slope_percent": 12})
	ps := [mais, arable("A2", 8, "Winterweizen")]
	approx(comp(year_input(ps, 2025), "arable_base"), (8 * 235) + ((2 * 235) * 0.5))
	approx(comp(year_input(ps, 2024), "arable_base"), 8 * 221.4)
	mais_es := object.union(mais, {"operations": {"erosion_reducing_method": true}})
	inp := json.patch(year_input([mais_es, arable("A2", 8, "Winterweizen")], 2025), [{"op": "replace", "path": "/oepul/participating_measures", "value": ["o6_1b", "o6_8"]}])
	approx(comp(inp, "arable_base"), 10 * 235)
	small := object.union(arable("A1", 0.5, "Körnermais"), {"slope_percent": 12})
	approx(comp(year_input([small, arable("A2", 9.5, "Winterweizen")], 2025), "arable_base"), 10 * 235)
}

slk(id, a, variety) := object.union(arable(id, a, "Mais"), {"oepul_codes": ["SLK"], "crop": {"crop_name": "Mais", "variety": variety, "is_variety_pure": true, "seed_documented": true}})

test_slk_cap_and_tiers if {
	ps := [slk("S1", 8, "Gailtaler Weißmais"), slk("S2", 4, "Gailtaler Weißmais"), arable("A1", 38, "Winterweizen")]

	# Stufe B, max. 10 ha pro Sorte
	approx(comp(with_parcels(ps), "slk"), 10 * 270)
	soblus := object.union(arable("S3", 2, "Sonnenblume"), {"oepul_codes": ["SLK"], "crop": {"crop_name": "Sonnenblume", "variety": "Soblus", "is_variety_pure": true, "seed_documented": true}})
	approx(comp(year_input([soblus, arable("A1", 8, "Winterweizen")], 2025), "slk"), 2 * 129.6)
	comp(year_input([soblus, arable("A1", 8, "Winterweizen")], 2024), "slk") == 0
	"O61B-ZA-004" in ids(o6_1b.violations) with input as year_input([soblus, arable("A1", 8, "Winterweizen")], 2024)
}

wb(id, a) := object.union(arable(id, a, "Winterroggen"), {"oepul_codes": ["WB"], "operations": {"row_spacing_cm": 25, "undersown": false}})

test_wildkraeuter_cap_20ha if {
	ps := [wb("W1", 15), wb("W2", 10), arable("A1", 75, "Kleegras")]
	approx(comp(with_parcels(ps), "wildkraeuter_brutflaechen"), 20 * 270)
	narrow := object.union(wb("W1", 5), {"operations": {"row_spacing_cm": 15}})
	"O61B-ZA-012" in ids(o6_1b.violations) with input as with_parcels([narrow, arable("A1", 20, "Kleegras")])
	fert := object.union(wb("W1", 5), {"operations": {"fertilizer_applications": [{"date": "2026-04-01", "type": "solid_manure"}]}})
	"O61B-ZA-012" in ids(o6_1b.violations) with input as with_parcels([fert, arable("A1", 20, "Kleegras")])
}

test_pheromone_traps if {
	ok := object.union(arable("Z1", 4, "Zuckerrüben"), {"oepul_codes": ["PZR"], "operations": {"pheromone_traps": {"traps_per_ha": 15, "installed_within_days_after_sowing": 10, "days_in_field": 36, "emptying_count": 2, "removed_before_harvest": true, "records_complete": true, "pheromone_receipts_kept": true}}})
	approx(comp(with_parcels([ok, arable("A1", 16, "Kleegras")]), "pheromonfallen"), 4 * 150)
	bad := json.patch(ok, [{"op": "replace", "path": "/operations/pheromone_traps/traps_per_ha", "value": 12}])
	"O61B-ZA-013" in ids(o6_1b.violations) with input as with_parcels([bad, arable("A1", 16, "Kleegras")])
	comp(year_input([ok, arable("A1", 16, "Kleegras")], 2024), "pheromonfallen") == 0
}

test_kreislauf_acker if {
	ps := [arable("A1", 4, "Luzerne"), arable("A2", 16, "Winterweizen")]

	# 20 % Leguminosen/Feldfutter, nicht-tierhaltender Betrieb
	no_animals := json.patch(with_parcels(ps), [{"op": "replace", "path": "/livestock/species_groups", "value": []}])
	approx(comp(no_animals, "kreislauf_acker"), 4 * 40)

	# 10 RGVE auf 4 ha Futterfläche = 2,5 RGVE/ha -> kein Zuschlag
	comp(with_parcels(ps), "kreislauf_acker") == 0
	low := json.patch(with_parcels([arable("A1", 3, "Luzerne"), arable("A2", 17, "Winterweizen")]), [{"op": "replace", "path": "/livestock/species_groups", "value": []}])
	comp(low, "kreislauf_acker") == 0
	comp(json.patch(no_animals, [{"op": "replace", "path": "/farm/year", "value": 2024}]), "kreislauf_acker") == 0
}

test_grassland_base_tiers if {
	non := json.patch(base_input, [{"op": "replace", "path": "/livestock/species_groups", "value": []}])
	approx(comp(non, "grassland_base"), 10 * 75.6)
	high := json.patch(base_input, [{"op": "replace", "path": "/livestock/species_groups", "value": [{"species": "cattle", "rgve_key": "cattle_ge_2", "animal_count": 30, "is_certified_organic": true}]}])
	approx(comp(high, "grassland_base"), 10 * 221.4)
	comp(high, "kreislauf_gruenland") == 0
}

# Beispiel Kap. 9.1: 3 % NAT+DIV und 5 % reine DIV -> kein Zuschlag für zusätzliche Flächen
test_grassland_over_7_example if {
	nat := object.union(mown("N1", 3, "Einmähdige Wiese", ["DIVSZ", "NAT"]), {"constraints": {"biodiversity_area": {"nat_auflagen": ["GL05"]}}})
	ps := [arable("A1", 1, "Kleegras"), nat, mown("D1", 5, "Mähwiese/-weide zwei Nutzungen", ["DIVAGF"]), mown("G1", 92, "Mähwiese/-weide drei und mehr Nutzungen", [])]
	comp(with_parcels(ps), "grassland_div_over_7") == 0
	approx(comp(with_parcels(ps), "grassland_divagf"), 5 * 150)
}

test_kreislauf_gruenland_8_percent if {
	ps := [arable("A1", 1, "Kleegras"), mown("D1", 0.9, "Mähwiese/-weide zwei Nutzungen", ["DIVAGF"]), mown("G1", 9.1, "Mähwiese/-weide drei und mehr Nutzungen", [])]
	approx(comp(with_parcels(ps), "kreislauf_gruenland"), 10 * 40)
	ps2 := [arable("A1", 1, "Kleegras"), mown("D1", 0.8, "Mähwiese/-weide zwei Nutzungen", ["DIVAGF"]), mown("G1", 9.2, "Mähwiese/-weide drei und mehr Nutzungen", [])]
	comp(with_parcels(ps2), "kreislauf_gruenland") == 0
}

test_steep_mown_with_topup if {
	steep := object.union(mown("S1", 2, "Mähwiese/-weide zwei Nutzungen", []), {"slope_percent": 55})
	ps := [arable("A1", 1, "Kleegras"), steep]
	approx(comp(with_parcels(ps), "steep_mown"), 2 * 432)
	inp := json.patch(with_parcels(ps), [{"op": "add", "path": "/oepul/o6_1b/land_topup_steep_granted", "value": true}])
	approx(comp(inp, "steep_mown"), 2 * 482)
}

test_wine_fruit_hops_rates if {
	walnut := {"parcel_id": "O1", "area_ha": 1, "land_use": "special_crop", "schlagnutzungsart": "Walnüsse", "crop": {"crop_name": "Walnuss", "crop_category": "orchard", "is_grafted": true}}
	wine := {"parcel_id": "W1", "area_ha": 2, "land_use": "special_crop", "schlagnutzungsart": "Wein", "crop": {"crop_name": "Wein", "crop_category": "vineyard"}}
	nursery := {"parcel_id": "R1", "area_ha": 1, "land_use": "special_crop", "schlagnutzungsart": "Rebschulen", "crop": {"crop_name": "Wein", "crop_category": "vineyard"}}
	approx(comp(with_parcels([walnut, wine, nursery]), "wine_fruit_hops"), 540 + (2 * 756))
}

test_bee_hives_tiers if {
	inp := with_patch([{"op": "add", "path": "/oepul/o6_1b/beekeeping", "value": {"economic_colony_hives": 150, "organic_control": true, "declared_in_mfa": true, "sector_programme_organic_feed_or_wax_compensated": false}}])
	approx(comp(inp, "bio_bee_hives"), (100 * 30.2) + (50 * 25.9))
	inp_max := with_patch([{"op": "add", "path": "/oepul/o6_1b/beekeeping", "value": {"economic_colony_hives": 1000, "organic_control": true, "declared_in_mfa": true}}])
	approx(comp(inp_max, "bio_bee_hives"), (100 * 30.2) + (800 * 25.9))
	inp_sector := with_patch([{"op": "add", "path": "/oepul/o6_1b/beekeeping", "value": {"economic_colony_hives": 50, "organic_control": true, "declared_in_mfa": true, "sector_programme_organic_feed_or_wax_compensated": true}}])
	comp(inp_sector, "bio_bee_hives") == 0
}

lse(id, fp, extra) := object.union({"element_id": id, "field_piece_id": fp, "distance_to_farmland_m": 0, "crown_diameter_m": 3, "area_m2": 20, "min_distance_to_other_element_m": 6}, extra)

test_landscape_elements_and_cap if {
	els := array.concat(
		[lse(sprintf("T%d", [i]), "F1", {"oepul_codes": ["SO"], "fruit_species": "Apfel", "stem_form": "Hochstamm"}) | some i in numbers.range(1, 3)],
		[lse(sprintf("B%d", [i]), "F1", {}) | some i in numbers.range(1, 2)],
	)
	inp := with_patch([{"op": "add", "path": "/land/point_landscape_elements", "value": els}])
	approx(comp(inp, "landscape_elements"), (3 * 13) + (2 * 8.6))

	# Feldstück 0,05 ha -> max. 4 Elemente
	inp_small := json.patch(inp, [{"op": "replace", "path": "/land/field_pieces/0/area_ha", "value": 0.05}])
	approx(comp(inp_small, "landscape_elements"), (3 * 13) + 8.6)
	bad := with_patch([{"op": "add", "path": "/land/point_landscape_elements", "value": [lse("X", "F1", {"crown_diameter_m": 1.5})]}])
	"O61B-LE-001" in ids(o6_1b.violations) with input as bad
	peach24 := json.patch(with_patch([{"op": "add", "path": "/land/point_landscape_elements", "value": [lse("P", "F1", {"oepul_codes": ["SO"], "fruit_species": "Pfirsich", "stem_form": "Halbstamm"})]}]), [{"op": "replace", "path": "/farm/year", "value": 2024}])
	"O61B-SO-001" in ids(o6_1b.violations) with input as peach24
}

test_multi_use_hedge if {
	h := {"hedge_id": "H1", "area_ha": 0.5, "planted_date": "2024-03-01", "avg_width_m": 8, "herbaceous_share_percent": 25, "adjoins_own_arable_field_piece": true, "long_side_adjoins_forest_or_flat_lse": false, "state_concept": true, "confirmed_by_state_in_gis": true}
	approx(comp(with_patch([{"op": "add", "path": "/land/multi_use_hedges", "value": [h]}]), "multi_use_hedges"), 500)
	narrow := object.union(h, {"avg_width_m": 4})
	"O61B-MH-002" in ids(o6_1b.violations) with input as with_patch([{"op": "add", "path": "/land/multi_use_hedges", "value": [narrow]}])
}

test_monitoring_combination if {
	m := {"programme": "grosstrappe", "participation_confirmation": true, "data_complete": true, "applied_in_measure_application": true}
	inp := with_patch([{"op": "add", "path": "/oepul/o6_1b/monitoring", "value": [m]}])
	"O61B-MO-002" in ids(o6_1b.violations) with input as inp
	comp(inp, "monitoring") == 0
	inp_ok := json.patch(inp, [
		{"op": "replace", "path": "/oepul/participating_measures", "value": ["o6_1b", "o6_18"]},
		{"op": "add", "path": "/oepul/o6_1b/nat_auflagen_farm", "value": ["TA01"]},
	])
	approx(comp(inp_ok, "monitoring"), 237.6)
	bio := with_patch([{"op": "add", "path": "/oepul/o6_1b/monitoring", "value": [{"programme": "biodiversitaet", "participation_confirmation": true, "data_complete": true, "applied_in_measure_application": true, "first_year": true, "intro_event_completed": false}]}])
	"O61B-MO-001" in ids(o6_1b.violations) with input as bio
}

test_transaction_costs_from_2025 if {
	comp(year_input(base_parcels, 2024), "transaction_costs") == 0
	comp(year_input(base_parcels, 2025), "transaction_costs") == 400
}

# ATB 9.3 Beispiel: 220 ha -> 99,09 %
test_modulation_example if {
	inp := with_patch([{"op": "replace", "path": "/land/total_area_ha", "value": 220}])
	f := o6_1b.modulation_factor with input as inp
	abs(f - 0.990909) < 0.00001
	o6_1b.modulation_factor == 1 with input as base_input
}

test_other_measure_div_gets_no_bio_premium if {
	nat := object.union(div_arable("N1", 2, ["NAT"]), {"ackerzahl": 60, "constraints": {"biodiversity_area": {"nat_auflagen": ["SA01"]}}})
	ps := [arable("A1", 18, "Winterweizen"), nat]
	comp(with_parcels(ps), "arable_div_ackerzahl_50") == 0
	approx(comp(with_parcels(ps), "arable_base"), 18 * 235)
}

test_opbio_parcel_no_premium if {
	p := object.union(arable("A5", 2, "Winterweizen"), {"oepul_codes": ["OPBIO"]})
	inp := json.patch(base_input, [{"op": "add", "path": "/land/parcels/-", "value": p}])
	comp(inp, "arable_base") == 4700
}

test_national_park_no_premium if {
	p := object.union(arable("A5", 2, "Winterweizen"), {"national_park": "Neusiedlersee"})
	inp := json.patch(base_input, [{"op": "add", "path": "/land/parcels/-", "value": p}])
	comp(inp, "arable_base") == 4700
}
