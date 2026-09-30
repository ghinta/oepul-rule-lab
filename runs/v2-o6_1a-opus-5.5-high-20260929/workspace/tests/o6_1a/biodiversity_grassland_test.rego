package oepul.o6_1a.biodiversity_grassland_test

import data.oepul.o6_1a.biodiversity_grassland as bg

ids(vs) := {v.rule_id | some v in vs}

meadow(id, fp, a) := {"parcel_id": id, "field_piece_id": fp, "area_ha": a, "land_use": "grassland", "crop": {"schlagnutzungsart": "Mähwiese/-weide drei und mehr Nutzungen"}}

gdiv(id, code, extra) := object.union({"parcel_id": id, "field_piece_id": "FX", "area_ha": 0.5, "land_use": "grassland", "codes": [code], "crop": {"schlagnutzungsart": "Mähwiese/-weide zwei Nutzungen"}}, extra)

ev(events) := {"operations": {"use_events": events}}

# --- Mindestanlage / Anrechenbarkeit ---
test_minimum_grassland_7_percent if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [meadow("G", "F1", 9.6), gdiv("D", "DIVSZ", {"area_ha": 0.4})]}}
	"UBB-DIVG-MIN-001" in ids(bg.violations) with input as inp
	inp2 := {"farm": {"year": 2026}, "land": {"parcels": [meadow("G", "F1", 9.3), gdiv("D", "DIVSZ", {"area_ha": 0.7})]}}
	not "UBB-DIVG-MIN-001" in ids(bg.violations) with input as inp2
}

test_bergmaehder_and_pastures_not_in_basis if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [
		{"parcel_id": "B", "area_ha": 5, "land_use": "grassland", "crop": {"schlagnutzungsart": "Bergmähder"}},
		{"parcel_id": "H", "area_ha": 5, "land_use": "grassland", "crop": {"schlagnutzungsart": "Hutweide"}},
		meadow("M", "F1", 1.9),
	]}}
	not bg.obligation_applies with input as inp
}

test_nat_creditable_only_with_cut_date_condition if {
	with_cond := gdiv("N1", "DIVSZ", {"codes": ["DIVSZ", "NAT"], "project_conditions": ["GL12"]})
	without := gdiv("N2", "DIVSZ", {"codes": ["DIVSZ", "NAT"], "project_conditions": ["WF01"]})
	natura := gdiv("N3", "DIVSZ", {"codes": ["DIVSZ", "N2"], "project_conditions": ["N2GL36"]})
	inp := {"farm": {"year": 2026}, "land": {"parcels": [with_cond, without, natura]}}
	bg.grassland_div_area_ha == 1.0 with input as inp
}

test_ebw_requires_eligible_habitat_type if {
	e := gdiv("E", "DIVSZ", {"codes": ["DIVSZ", "EBW"], "biodiversity": {"ebw_habitat_type_eligible": true}})
	bg.grassland_div_area_ha == 0.5 with input as {"farm": {"year": 2026}, "land": {"parcels": [e]}}
	e2 := gdiv("E", "DIVSZ", {"codes": ["DIVSZ", "EBW"]})
	bg.grassland_div_area_ha == 0 with input as {"farm": {"year": 2026}, "land": {"parcels": [e2]}}
}

# Beispiel Kapitel 6.2.2: 10 ha gemäht, Feldstück 7 ha (6 ha gemäht, 1 ha Hutweide), GLÖZ-Hecke 0,10 ha, DIV 0,07 ha.
test_field_piece_example if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [
		meadow("M1", "F7", 5.93), gdiv("D1", "DIVSZ", {"field_piece_id": "F7", "area_ha": 0.07}),
		{"parcel_id": "HW", "field_piece_id": "F7", "area_ha": 1.0, "land_use": "grassland", "crop": {"schlagnutzungsart": "Hutweide"}},
		{"parcel_id": "H", "field_piece_id": "F7", "area_ha": 0.10, "land_use": "grassland", "area_kind": "gloez_landscape_element"},
		meadow("M2", "F8", 3.37), gdiv("D2", "DIVSZ", {"field_piece_id": "F8", "area_ha": 0.63}),
	]}}
	not "UBB-DIVG-FS-001" in ids(bg.violations) with input as inp
	not "UBB-DIVG-MIN-001" in ids(bg.violations) with input as inp
}

# --- DIVSZ (Beispiele Kapitel 6.2.4.1) ---
test_divsz_example_first if {
	p := gdiv("S", "DIVSZ", object.union({"biodiversity": {"comparable_second_cut_date": "2026-06-10"}}, ev([{"date": "2026-06-14", "type": "mow", "material_removed": true}])))
	"UBB-DIVG-SZ-001" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
	p2 := gdiv("S", "DIVSZ", object.union({"biodiversity": {"comparable_second_cut_date": "2026-06-10"}}, ev([{"date": "2026-06-15", "type": "mow", "material_removed": true}])))
	not "UBB-DIVG-SZ-001" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p2]}}
}

test_divsz_example_second if {
	p := gdiv("S", "DIVSZ", object.union({"biodiversity": {"comparable_second_cut_date": "2026-06-20"}}, ev([{"date": "2026-06-20", "type": "mow", "material_removed": true}])))
	not "UBB-DIVG-SZ-001" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
	p2 := gdiv("S", "DIVSZ", object.union({"biodiversity": {"comparable_second_cut_date": "2026-06-20"}}, ev([{"date": "2026-06-19", "type": "mow", "material_removed": true}])))
	"UBB-DIVG-SZ-001" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p2]}}
}

test_divsz_example_third_always_from_july_15 if {
	p := gdiv("S", "DIVSZ", object.union({"biodiversity": {"comparable_second_cut_date": "2026-07-30"}}, ev([{"date": "2026-07-15", "type": "mow", "material_removed": true}])))
	not "UBB-DIVG-SZ-001" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
}

test_divsz_phenology_advance_max_10_days if {
	p := gdiv("S", "DIVSZ", object.union({"biodiversity": {"phenology_advance_days": 15}}, ev([{"date": "2026-07-05", "type": "mow", "material_removed": true}])))
	not "UBB-DIVG-SZ-001" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
	p2 := gdiv("S", "DIVSZ", object.union({"biodiversity": {"phenology_advance_days": 15}}, ev([{"date": "2026-07-04", "type": "mow", "material_removed": true}])))
	"UBB-DIVG-SZ-001" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p2]}}
}

test_divsz_single_cut_meadow_june_15 if {
	p := gdiv("S", "DIVSZ", object.union({"crop": {"schlagnutzungsart": "Einmähdige Wiese"}}, ev([{"date": "2026-06-16", "type": "mow", "material_removed": true}])))
	not "UBB-DIVG-SZ-001" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
}

test_divsz_no_fertilizer_before_first_use if {
	p := gdiv("S", "DIVSZ", {"operations": {"use_events": [{"date": "2026-07-20", "type": "mow", "material_removed": true}], "fertilization_events": [{"date": "2026-04-01", "type": "slurry"}]}})
	"UBB-DIVG-SZ-002" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
}

test_every_variant_needs_mowing_with_removal if {
	p := gdiv("S", "DIVSZ", ev([{"date": "2026-07-20", "type": "graze"}]))
	"UBB-DIVG-BW-002" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
}

# --- DIVNFZ (Beispiel Kapitel 6.2.4.2: Abtransport 24.6., nächste Überfahrt frühestens 27.8.) ---
test_divnfz_example if {
	ok := gdiv("N", "DIVNFZ", {"biodiversity": {"first_use_completed_date": "2026-06-24"}, "operations": {"use_events": [{"date": "2026-06-22", "type": "mow", "material_removed": true}, {"date": "2026-08-27", "type": "mow", "material_removed": true}]}})
	not "UBB-DIVG-NFZ-001" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [ok]}}
	bad := gdiv("N", "DIVNFZ", {"biodiversity": {"first_use_completed_date": "2026-06-24"}, "operations": {"use_events": [{"date": "2026-06-22", "type": "mow", "material_removed": true}, {"date": "2026-08-26", "type": "mow", "material_removed": true}]}})
	"UBB-DIVG-NFZ-001" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [bad]}}
}

test_divnfz_crossing_allowed_driving_not if {
	p := gdiv("N", "DIVNFZ", {"biodiversity": {"first_use_completed_date": "2026-06-24"}, "operations": {"use_events": [{"date": "2026-06-22", "type": "mow", "material_removed": true}, {"date": "2026-09-01", "type": "mow", "material_removed": true}], "driving_events": [{"date": "2026-07-10", "purpose": "crossing"}]}})
	not "UBB-DIVG-NFZ-001" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
	p2 := gdiv("N", "DIVNFZ", {"biodiversity": {"first_use_completed_date": "2026-06-24"}, "operations": {"use_events": [{"date": "2026-06-22", "type": "mow", "material_removed": true}, {"date": "2026-09-01", "type": "mow", "material_removed": true}], "fertilization_events": [{"date": "2026-07-10", "type": "slurry"}]}})
	"UBB-DIVG-NFZ-001" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p2]}}
}

test_divnfz_second_use_mandatory if {
	p := gdiv("N", "DIVNFZ", {"biodiversity": {"first_use_completed_date": "2026-06-24"}, "operations": {"use_events": [{"date": "2026-06-22", "type": "mow", "material_removed": true}]}})
	"UBB-DIVG-NFZ-002" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
}

test_divnfz_documentation_only_until_2024 if {
	p := gdiv("N", "DIVNFZ", {"biodiversity": {"first_use_completed_date": "2024-06-24"}, "operations": {"use_events": [{"date": "2024-06-22", "type": "mow", "material_removed": true}, {"date": "2024-09-01", "type": "graze"}]}})
	"UBB-DIVG-NFZ-004" in ids(bg.violations) with input as {"farm": {"year": 2024}, "land": {"parcels": [p]}}
	p25 := gdiv("N", "DIVNFZ", {"biodiversity": {"first_use_completed_date": "2025-06-24"}, "operations": {"use_events": [{"date": "2025-06-22", "type": "mow", "material_removed": true}, {"date": "2025-09-01", "type": "graze"}]}})
	not "UBB-DIVG-NFZ-004" in ids(bg.violations) with input as {"farm": {"year": 2025}, "land": {"parcels": [p25]}}
}

# --- DIVAGF ---
test_divagf_last_use_august_15 if {
	p := gdiv("A", "DIVAGF", ev([{"date": "2026-06-20", "type": "mow", "material_removed": true}, {"date": "2026-08-20", "type": "graze"}]))
	"UBB-DIVG-AGF-001" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
	ok := gdiv("A", "DIVAGF", ev([{"date": "2026-06-20", "type": "mow", "material_removed": true}, {"date": "2026-08-15", "type": "graze"}]))
	not "UBB-DIVG-AGF-001" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [ok]}}
}

test_divagf_followed_by_divsz if {
	p := gdiv("A", "DIVNFZ", {"biodiversity": {"previous_year_code": "DIVAGF"}})
	"UBB-DIVG-AGF-003" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
}

# --- DIVRS Grünland ---
rs_mix := {"regional_list_species": 31, "regional_list_families": 7, "seed_rate_kg_per_ha": 20, "max_single_species_weight_percent": 4, "regional_origin_certified": true, "documented_labels_invoices": true}

rs(extra) := gdiv("R", "DIVRS", object.union({"slope_percent": 12, "soil_index": {"gruenlandzahl": 35}, "biodiversity": {"first_declared_year": 2025, "sowing_date": "2025-05-10", "seed_mixture": rs_mix}, "operations": {"use_events": [{"date": "2026-07-20", "type": "mow", "material_removed": true}], "fertilization_events": [{"date": "2026-09-01", "type": "solid_manure"}]}}, extra))

test_divrs_grassland_eligible if {
	bg.divrs_eligible(rs({})) with input as {"farm": {"year": 2026}}
}

test_divrs_grassland_site_and_timing if {
	not bg.divrs_eligible(rs({"slope_percent": 18})) with input as {"farm": {"year": 2026}}
	not bg.divrs_eligible(rs({"soil_index": {"gruenlandzahl": 29}})) with input as {"farm": {"year": 2026}}
	not bg.divrs_eligible(rs({"operations": {"use_events": [{"date": "2026-07-10", "type": "mow", "material_removed": true}]}})) with input as {"farm": {"year": 2026}}
	not bg.divrs_eligible(rs({"operations": {"use_events": [{"date": "2026-07-20", "type": "mow", "material_removed": true}], "fertilization_events": [{"date": "2026-09-01", "type": "slurry"}]}})) with input as {"farm": {"year": 2026}}
}

test_nat_div_must_use_divsz_code if {
	p := gdiv("N", "DIVNFZ", {"codes": ["DIVNFZ", "NAT"], "project_conditions": ["GL01"]})
	"UBB-ANT-021" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
}
