package oepul.o6_1a.supplements_premium_test

import data.oepul.o6_1a.arable_supplements as az
import data.oepul.o6_1a.grassland_supplements as gz
import data.oepul.o6_1a.premium

approx(a, b) if abs(a - b) < 0.001

ids(vs) := {v.rule_id | some v in vs}

field(id, a, sna) := {"parcel_id": id, "field_piece_id": id, "area_ha": a, "land_use": "arable", "crop": {"schlagnutzungsart": sna, "botanical_species": sna}}

div_parcel(id, a, extra) := object.union({"parcel_id": id, "field_piece_id": id, "area_ha": a, "land_use": "arable", "codes": ["DIV"], "crop": {"schlagnutzungsart": "Grünbrache"}, "biodiversity": {"first_declared_year": 2024}}, extra)

meadow(id, a) := {"parcel_id": id, "field_piece_id": id, "area_ha": a, "land_use": "grassland", "crop": {"schlagnutzungsart": "Mähwiese/-weide drei und mehr Nutzungen"}}

gdiv(id, a, extra) := object.union({"parcel_id": id, "field_piece_id": id, "area_ha": a, "land_use": "grassland", "codes": ["DIVSZ"], "crop": {"schlagnutzungsart": "Mähwiese/-weide zwei Nutzungen"}}, extra)

# Beispiel Kapitel 8.4: 100 ha Acker, 8 ha DIV -> 1 ha Zuschlag über 7 %.
test_over7_example_one_ha if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [field("W", 92, "Mais"), div_parcel("D", 8, {})]}}
	approx(az.over7_area_ha, 1.0) with input as inp
	approx(az.over7_premium, 410.4) with input as inp
}

# Beispiel Kapitel 8.4: 8 ha DIV (davon 1 ha GLÖZ 4) + 2 ha NAT+DIV -> kein Zuschlag.
test_over7_example_no_supplement if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [
		field("W", 90, "Mais"), div_parcel("D1", 7, {}), div_parcel("D2", 1, {"codes": ["DIV", "GLOEZ4"]}),
		div_parcel("N", 2, {"codes": ["DIV", "NAT"], "project_conditions": ["SA01"]}),
	]}}
	az.over7_area_ha == 0 with input as inp
}

test_over7_capped_at_20_percent if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [field("W", 70, "Mais"), div_parcel("D", 30, {})]}}
	approx(az.over7_area_ha, 13.0) with input as inp
}

test_ackerzahl_supplement if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [field("W", 9, "Mais"), div_parcel("D", 1, {"soil_index": {"ackerzahl": 50}})]}}
	approx(az.ackerzahl_premium, 140.0) with input as inp
	approx(az.ackerzahl_premium, 75.6) with input as {"farm": {"year": 2024}, "land": {"parcels": [field("W", 9, "Mais"), div_parcel("D", 1, {"soil_index": {"ackerzahl": 50}})]}}
}

# Beispiel Kapitel 8.3: 6,01 ha Acker -> mindestens 3 DIV-Schläge > 0,05 ha.
test_per_3ha_rounding_up if {
	two := {"farm": {"year": 2026}, "land": {"parcels": [field("W", 5.61, "Mais"), div_parcel("D1", 0.2, {}), div_parcel("D2", 0.2, {})]}}
	az.required_div_parcels == 3 with input as two
	not az.per_3ha_condition_met with input as two
	three := {"farm": {"year": 2026}, "land": {"parcels": [field("W", 5.41, "Mais"), div_parcel("D1", 0.2, {}), div_parcel("D2", 0.2, {}), div_parcel("D3", 0.2, {})]}}
	az.per_3ha_condition_met with input as three
	small := {"farm": {"year": 2026}, "land": {"parcels": [field("W", 5.76, "Mais"), div_parcel("D1", 0.2, {}), div_parcel("D2", 0.2, {}), div_parcel("D3", 0.05, {})]}}
	not az.per_3ha_condition_met with input as small
}

# Beispiel Kapitel 8.6: 50 ha Acker, 5 ha Ackerbohne, 10 ha Sonnenblume, 10 ha Wechselwiese -> 1.836 €.
test_fwk_example_1836 if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [
		field("AB", 5, "Ackerbohne"), field("SB", 10, "Sonnenblume"), field("WW", 10, "Wechselwiese"), field("W", 25, "Weizen"),
	]}}
	az.fwk_threshold_met with input as inp
	approx(az.fwk_premium, 1836.0) with input as inp
}

# Beispiel Kapitel 8.6: 10 % DIV, 3 % DIV mit NAT, 5 % Sonnenblume, 5 % Raps -> Schwelle erreicht (16 %).
test_fwk_threshold_counts_div_over_7 if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [
		div_parcel("D", 10, {}), div_parcel("N", 3, {"codes": ["DIV", "NAT"], "project_conditions": ["SA01"]}),
		field("SB", 5, "Sonnenblume"), field("R", 5, "Raps"), field("W", 77, "Weizen"),
	]}}
	az.fwk_threshold_met with input as inp
	approx(az.fwk_premium, 864.0) with input as inp
}

test_fwk_below_threshold if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [field("SB", 15, "Sonnenblume"), field("W", 85, "Weizen")]}}
	not az.fwk_threshold_met with input as inp
	az.fwk_premium == 0 with input as inp
}

test_fwk_second_crop_higher_rate if {
	p := object.union(field("K", 20, "Kleegras"), {"crop": {"second_crop_name": "Erbsen"}})
	inp := {"farm": {"year": 2026}, "land": {"parcels": [p, field("W", 80, "Weizen")]}}
	approx(az.fwk_premium, 20 * 129.6) with input as inp
}

test_fwk_npf_excluded_until_2024 if {
	p := object.union(field("L", 20, "Luzerne"), {"codes": ["NPF"]})
	inp := {"farm": {"year": 2024}, "land": {"parcels": [p, field("L2", 10, "Luzerne"), field("W", 70, "Weizen")]}}
	approx(az.fwk_area_ha, 10) with input as inp
}

test_bhg_generic_needs_code if {
	p := {"parcel_id": "H", "area_ha": 20, "land_use": "arable", "crop": {"schlagnutzungsart": "Heilpflanzen", "crop_name": "Kamille"}}
	"UBB-ANT-030" in ids(az.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
	p2 := object.union(p, {"codes": ["BHG"]})
	az.fwk_parcel(p2) with input as {"farm": {"year": 2026}, "land": {"parcels": [p2]}}
}

# --- SLK ---
slk(id, a, v) := {"parcel_id": id, "area_ha": a, "land_use": "arable", "codes": ["SLK"], "crop": {"schlagnutzungsart": "Winterroggen", "variety": v, "pure_variety": true, "seed_documentation": true}}

test_slk_max_10_ha_per_variety if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [slk("S1", 8, "Schlägler"), slk("S2", 4, "Schlägler"), slk("S3", 2, "Kematener")]}}
	approx(az.slk_premium, (10 * 129.6) + (2 * 270.0)) with input as inp
}

test_slk_requires_pure_variety_and_list if {
	mix := object.union(slk("S1", 2, "Schlägler"), {"crop": {"pure_variety": false, "is_mixture": true}})
	"UBB-SLK-001" in ids(az.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [mix]}}
	soblus := slk("S2", 2, "Soblus")
	"UBB-SLK-001" in ids(az.violations) with input as {"farm": {"year": 2024}, "land": {"parcels": [soblus]}}
	not "UBB-SLK-001" in ids(az.violations) with input as {"farm": {"year": 2025}, "land": {"parcels": [soblus]}}
}

test_slk_perennial_only_first_use_year if {
	p := object.union(slk("K", 2, "Steirerklee (Erhaltungssorte)"), {"crop": {"is_perennial": true, "first_use_year": 2025}})
	not az.slk_eligible(p) with input as {"farm": {"year": 2026}}
}

# --- Wildkräuter- und Brutflächen ---
wb(id, a, extra) := object.union({"parcel_id": id, "area_ha": a, "land_use": "arable", "codes": ["WB"], "crop": {"schlagnutzungsart": "Winterroggen", "botanical_species": "Roggen"}, "wildkraut": {"row_spacing_cm": 25, "undersown": false}}, extra)

test_wb_max_20_ha if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [wb("W1", 15, {}), wb("W2", 10, {})]}}
	approx(az.wb_premium, 20 * 270.0) with input as inp
}

test_wb_conditions if {
	narrow := wb("W", 5, {"wildkraut": {"row_spacing_cm": 15}})
	"UBB-WBF-001" in ids(az.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [narrow]}}
	fert := wb("W", 5, {"operations": {"fertilization_events": [{"date": "2026-04-01", "type": "mineral"}]}})
	"UBB-WBF-001" in ids(az.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [fert]}}
	late_spring := wb("W", 5, {"wildkraut": {"row_spacing_cm": 25, "spring_cereal": true, "sowing_date": "2026-03-20"}})
	"UBB-WBF-001" in ids(az.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [late_spring]}}
	after_threshing := wb("W", 5, {"wildkraut": {"row_spacing_cm": 25, "threshing_date": "2026-06-20"}, "operations": {"fertilization_events": [{"date": "2026-06-25", "type": "mineral"}]}})
	not "UBB-WBF-001" in ids(az.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [after_threshing]}}
}

# --- Pheromonfallen ---
pzr(extra) := object.union({"parcel_id": "Z", "area_ha": 4, "land_use": "arable", "codes": ["PZR"], "crop": {"schlagnutzungsart": "Zuckerrüben"}, "pheromone_traps": {"traps_per_ha": 15, "reference_sowing_date": "2026-03-20", "installation_date": "2026-04-03", "days_in_field": 35, "emptied_count": 2, "removed_before_harvest": true, "records_complete": true, "pheromone_receipts_kept": true, "lures_obtained_annually": true, "traps_kept_until_sept_30": true}}, extra)

test_pzr_eligible if {
	approx(az.pzr_premium, 600.0) with input as {"farm": {"year": 2026}, "land": {"parcels": [pzr({})]}}
	az.pzr_premium == 0 with input as {"farm": {"year": 2024}, "land": {"parcels": [pzr({})]}}
}

test_pzr_conditions if {
	late := pzr({"pheromone_traps": {"installation_date": "2026-04-05"}})
	"UBB-PZR-001" in ids(az.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [late]}}
	few := pzr({"pheromone_traps": {"traps_per_ha": 14}})
	"UBB-PZR-001" in ids(az.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [few]}}
	fodder := pzr({"crop": {"schlagnutzungsart": "Futterrüben"}})
	"UBB-PZR-001" in ids(az.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [fodder]}}
	prev := pzr({"crop": {"schlagnutzungsart": "Winterweizen", "sugar_beet_previous_year": true}})
	not "UBB-PZR-001" in ids(az.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [prev]}}
}

# --- Grünland-Zuschläge ---
# Beispiel Kapitel 9.1: 3 % NAT+DIV, 5 % DIV -> kein Zuschlag für zusätzliche Flächen.
test_grassland_over7_example if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [
		meadow("M", 92), gdiv("N", 3, {"codes": ["DIVSZ", "NAT"], "project_conditions": ["GL05"]}), gdiv("D", 5, {}),
	]}}
	gz.over7_area_ha == 0 with input as inp
}

test_grassland_over7_supplement if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [meadow("M", 90), gdiv("D", 10, {})]}}
	approx(gz.over7_premium, 3 * 108.0) with input as inp
}

# Beispiel Kapitel 9.3: 18,01 ha gemähtes Grünland -> mindestens 7 DIV-Schläge.
test_grassland_per_3ha_example if {
	gz.required_div_parcels == 7 with input as {"farm": {"year": 2026}, "land": {"parcels": [meadow("M", 18.01)]}}
}

test_altgras_supplement_from_2025 if {
	p := gdiv("A", 1, {"codes": ["DIVAGF"], "operations": {"use_events": [{"date": "2026-06-20", "type": "mow", "material_removed": true}]}})
	inp := {"farm": {"year": 2026}, "land": {"parcels": [meadow("M", 9), p]}}
	approx(gz.altgras_premium, 150.0) with input as inp
	inp24 := {"farm": {"year": 2024}, "land": {"parcels": [meadow("M", 9), gdiv("A", 1, {"codes": ["DIVAGF"], "operations": {"use_events": [{"date": "2024-06-20", "type": "mow", "material_removed": true}]}})]}}
	gz.altgras_premium == 0 with input as inp24
}

test_steep_slope_supplement if {
	steep := object.union(meadow("S", 2), {"slope_percent": 50, "operations": {"use_events": [{"date": "2026-07-01", "type": "mow", "material_removed": true}]}})
	approx(gz.steep_premium, 864.0) with input as {"farm": {"year": 2026}, "land": {"parcels": [steep]}}
	pasture := object.union(steep, {"crop": {"schlagnutzungsart": "Dauerweide"}})
	gz.steep_premium == 0 with input as {"farm": {"year": 2026}, "land": {"parcels": [pasture]}}
	nat := object.union(steep, {"codes": ["NAT"]})
	gz.steep_premium == 0 with input as {"farm": {"year": 2026}, "land": {"parcels": [nat]}}
	approx(gz.land_top_up_premium, 100.0) with input as {"farm": {"year": 2026, "oepul": {"land_top_up_steilflaechen_granted": true}}, "land": {"parcels": [steep]}}
}

# --- Prämie gesamt ---
test_erosion_exclusion if {
	maize := {"parcel_id": "M", "area_ha": 2, "land_use": "arable", "slope_percent": 12, "crop": {"schlagnutzungsart": "Silomais", "crop_category": "maize"}}
	premium.erosion_excluded(maize) with input as {"farm": {"year": 2026}}
	premium.arable_base_premium == 0 with input as {"farm": {"year": 2026}, "land": {"parcels": [maize]}}
	mulch := object.union(maize, {"operations": {"erosion_protection_method": "mulch_seeding"}})
	not premium.erosion_excluded(mulch) with input as {"farm": {"year": 2026, "oepul": {"measures": ["1A", "8", "6"]}}}
	premium.erosion_excluded(mulch) with input as {"farm": {"year": 2026, "oepul": {"measures": ["1A", "8"]}}}
	small := object.union(maize, {"area_ha": 0.5})
	not premium.erosion_excluded(small) with input as {"farm": {"year": 2026}}
}

test_gruenbrache_div_base_capped_at_20_percent if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [field("W", 7, "Weizen"), div_parcel("D", 3, {})]}}
	approx(premium.arable_base_area_ha, 9.0) with input as inp
	approx(premium.arable_base_premium, 765.0) with input as inp
}

test_plain_gruenbrache_not_eligible if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [field("W", 7, "Weizen"), field("G", 3, "Grünbrache")]}}
	approx(premium.arable_base_area_ha, 7.0) with input as inp
}

test_grassland_base_by_livestock_status if {
	g := {"parcel_id": "G", "area_ha": 10, "land_use": "grassland", "crop": {"schlagnutzungsart": "Mähwiese/-weide zwei Nutzungen"}}
	approx(premium.grassland_base_premium, 270.0) with input as {"farm": {"year": 2026}, "land": {"parcels": [g]}}
	approx(premium.grassland_base_premium, 756.0) with input as {"farm": {"year": 2026}, "land": {"parcels": [g]}, "livestock": {"species_groups": [{"rgve_category": "rinder_ab_2", "animal_count": 5}]}}
}

test_nat_and_opubb_parcels_get_no_ubb_premium if {
	nat := {"parcel_id": "N", "area_ha": 5, "land_use": "grassland", "codes": ["NAT"], "crop": {"schlagnutzungsart": "Mähwiese/-weide zwei Nutzungen"}}
	op := {"parcel_id": "O", "area_ha": 5, "land_use": "grassland", "codes": ["OPUBB"], "crop": {"schlagnutzungsart": "Mähwiese/-weide zwei Nutzungen"}}
	premium.grassland_base_premium == 0 with input as {"farm": {"year": 2026}, "land": {"parcels": [nat, op]}}
}

test_national_park_neusiedlersee_no_premium if {
	g := {"parcel_id": "G", "area_ha": 10, "land_use": "grassland", "national_park": "Neusiedlersee", "crop": {"schlagnutzungsart": "Mähwiese/-weide zwei Nutzungen"}}
	premium.grassland_base_premium == 0 with input as {"farm": {"year": 2026}, "land": {"parcels": [g]}}
}

# Beispiel Allgemeine Teilnahmebedingungen 9.3: 220 ha -> 99,09 %.
test_modulation_example_220_ha if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [field("W", 220, "Weizen")]}}
	abs(premium.modulation_factor - 0.990909) < 0.00001 with input as inp
}

test_modulation_bands if {
	abs(premium.modulated_area(1100) - (((200 + 90) + 595) + 75)) < 0.0001
}

test_payment_cap if {
	p := {"parcel_id": "P", "area_ha": 1, "land_use": "grassland", "total_area_payments_eur_per_ha": 1400}
	"ATB-OG-001" in ids(premium.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
	pn := object.union(p, {"codes": ["NAT"]})
	not "ATB-OG-001" in ids(premium.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [pn]}}
}
