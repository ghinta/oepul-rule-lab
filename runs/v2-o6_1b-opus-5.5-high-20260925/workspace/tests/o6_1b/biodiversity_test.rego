package oepul.o6_1b_test

import data.oepul.o6_1b

mown(id, a, lu, codes) := {"parcel_id": id, "area_ha": a, "land_use": "grassland", "schlagnutzungsart": lu, "is_mown": true, "oepul_codes": codes}

with_events(p, evs) := object.union(p, {"operations": {"use_events": evs}})

with_div(p, info) := object.union(p, {"constraints": {"biodiversity_area": info}})

# --- 6.1.1 Mindestanlage Acker -----------------------------------------------------------

test_arable_div_7_percent_required if {
	ps := [arable("A1", 19, "Winterweizen"), div_arable("A2", 1, [])]
	"O61B-DA-001" in ids(o6_1b.violations) with input as with_parcels(ps)
}

test_arable_div_no_obligation_up_to_2ha if {
	ps := [arable("A1", 2, "Winterweizen")]
	not "O61B-DA-001" in ids(o6_1b.violations) with input as with_parcels(ps)
}

# Beispiel Kap. 6.1.1: 9 ha Acker und 5 ha gemähtes Grünland -> 0,98 ha in Summe
test_arable_div_substitution_on_grassland_below_10ha if {
	ok := [
		arable("A1", 8.75, "Winterweizen"), div_arable("A2", 0.25, []),
		mown("G1", 4.2, "Mähwiese/-weide drei und mehr Nutzungen", []),
		mown("G2", 0.8, "Mähwiese/-weide zwei Nutzungen", ["DIVNFZ"]),
	]
	not "O61B-DA-001" in ids(o6_1b.violations) with input as with_parcels(ok)

	only_grassland := [
		arable("A1", 9, "Winterweizen"),
		mown("G1", 4.02, "Mähwiese/-weide drei und mehr Nutzungen", []),
		mown("G2", 0.98, "Mähwiese/-weide zwei Nutzungen", ["DIVNFZ"]),
	]
	not "O61B-DA-001" in ids(o6_1b.violations) with input as with_parcels(only_grassland)

	too_little := [
		arable("A1", 9, "Winterweizen"),
		mown("G1", 4.2, "Mähwiese/-weide drei und mehr Nutzungen", []),
		mown("G2", 0.8, "Mähwiese/-weide zwei Nutzungen", ["DIVNFZ"]),
	]
	"O61B-DA-001" in ids(o6_1b.violations) with input as with_parcels(too_little)
}

test_k20_not_creditable if {
	ps := [arable("A1", 18, "Winterweizen"), div_arable("A2", 2, ["K20"])]
	vs := ids(o6_1b.violations) with input as with_parcels(ps)
	"O61B-DA-001" in vs
	"O61B-DA-005" in vs
}

test_nat_fallow_requires_sa01 if {
	nat_ok := with_div(div_arable("A2", 2, ["NAT"]), {"nat_auflagen": ["SA01"]})
	ps := [arable("A1", 18, "Winterweizen"), nat_ok]
	not "O61B-DA-001" in ids(o6_1b.violations) with input as with_parcels(ps)
	nat_used := with_div(div_arable("A2", 2, ["NAT"]), {"nat_auflagen": ["SA01"], "nat_area_used": true})
	"O61B-DA-001" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), nat_used])
}

# Beispiel Kap. 6.1.2: 30 ha Acker, Feldstück 6 ha mit GLÖZ-Hecke 0,10 ha und 2 x 0,07 ha DIV
test_field_piece_rule_example if {
	ps := [
		object.union(arable("A1", 3, "Winterweizen"), {"field_piece_id": "FS6"}),
		object.union(arable("A2", 2.86, "Sonnenblumen"), {"field_piece_id": "FS6"}),
		object.union(div_arable("D1", 0.07, []), {"field_piece_id": "FS6"}),
		object.union(div_arable("D2", 0.07, []), {"field_piece_id": "FS6"}),
		object.union(div_arable("D3", 1.96, []), {"field_piece_id": "FS2"}),
		object.union(arable("A3", 22.04, "Kleegras"), {"field_piece_id": "FS2"}),
	]
	fps := [{"field_piece_id": "FS6", "land_use": "arable", "area_ha": 6, "gloez_lse_area_ha": 0.1}]
	inp := json.patch(with_parcels(ps), [{"op": "replace", "path": "/land/field_pieces", "value": fps}])
	vs := ids(o6_1b.violations) with input as inp
	not "O61B-DA-004" in vs
	not "O61B-DA-001" in vs
	inp2 := json.patch(inp, [{"op": "replace", "path": "/land/field_pieces/0/gloez_lse_area_ha", "value": 0}])
	"O61B-DA-004" in ids(o6_1b.violations) with input as inp2
}

# --- 6.1.4.1 Ansaat und Umbruch ---------------------------------------------------------------

test_bee_mixture_requirements if {
	bad := with_div(div_arable("A2", 2, []), {"first_declared_year": 2026, "is_new_sowing": true, "seed_mixture": {"insect_pollinated_partners": 6, "plant_families": 3, "non_insect_share_percent": 5}})
	"O61B-DA-010" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), bad])
	no_sowing := with_div(div_arable("A2", 2, []), {"first_declared_year": 2026, "is_new_sowing": false})
	"O61B-DA-010" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), no_sowing])
	exempt := with_div(div_arable("A2", 2, []), {"first_declared_year": 2026, "is_new_sowing": false, "sowing_exempt_existing": true})
	not "O61B-DA-010" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), exempt])
}

test_sowing_deadline_15_may if {
	late := with_div(div_arable("A2", 2, []), {"first_declared_year": 2026, "sowing_date": "2026-05-20"})
	"O61B-DA-012" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), late])
}

test_break_two_year_rule if {
	early := with_div(div_arable("A2", 2, []), {"first_declared_year": 2025, "break_date": "2026-09-10"})
	"O61B-DA-012" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), early])
	ok := with_div(div_arable("A2", 2, []), {"first_declared_year": 2025, "break_date": "2026-09-15"})
	not "O61B-DA-012" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), ok])
	winter := with_div(div_arable("A2", 2, []), {"first_declared_year": 2025, "break_date": "2026-08-01", "followed_by_winter_crop_or_catch_crop": true})
	not "O61B-DA-012" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), winter])
	winter_early := with_div(div_arable("A2", 2, []), {"first_declared_year": 2025, "break_date": "2026-07-31", "followed_by_winter_crop_or_catch_crop": true})
	"O61B-DA-012" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), winter_early])
	loss := with_div(div_arable("A2", 2, []), {"first_declared_year": 2026, "break_date": "2026-09-10", "loss_of_control": true})
	not "O61B-DA-012" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), loss])
}

# --- 6.1.4.2 Pflege-/Nutzungsauflagen ----------------------------------------------------------

# Beispiel: 1,5 ha Grünbrache + DIV + NAT (Häckseln ab 1.7.) und 2,5 ha Grünbrache + DIV
test_75_percent_rule_with_project_precedence if {
	nat := with_events(with_div(div_arable("N1", 1.5, ["NAT"]), {"nat_auflagen": ["SA01"]}), [{"date": "2026-07-01", "type": "chop"}])
	div_ok := with_events(div_arable("D1", 2.5, []), [{"date": "2026-08-01", "type": "chop"}])
	ok := [arable("A1", 36, "Winterweizen"), nat, div_ok]
	not "O61B-DA-018" in ids(o6_1b.violations) with input as with_parcels(ok)
	div_early := with_events(div_arable("D1", 2.5, []), [{"date": "2026-07-20", "type": "chop"}])
	"O61B-DA-018" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 36, "Winterweizen"), nat, div_early])
}

test_25_percent_early_mowing_allowed if {
	d1 := with_events(div_arable("D1", 0.5, []), [{"date": "2026-06-10", "type": "mow", "removed": true}])
	d2 := with_events(div_arable("D2", 1.5, []), [{"date": "2026-08-05", "type": "mow", "removed": true}])
	not "O61B-DA-018" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 26, "Winterweizen"), d1, d2])
}

test_grazing_only_from_august if {
	g := with_events(div_arable("D1", 2, []), [{"date": "2026-07-15", "type": "graze"}])
	"O61B-DA-019" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), g])
	g_ok := with_events(div_arable("D1", 2, []), [{"date": "2026-08-15", "type": "graze"}])
	not "O61B-DA-019" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), g_ok])
	inp24 := json.patch(with_parcels([arable("A1", 18, "Winterweizen"), g_ok]), [{"op": "replace", "path": "/farm/year", "value": 2024}])
	g24 := with_events(div_arable("D1", 2, []), [{"date": "2024-08-15", "type": "graze"}])
	"O61B-DA-019" in ids(o6_1b.violations) with input as json.patch(inp24, [{"op": "replace", "path": "/land/parcels/1", "value": g24}])
}

test_max_two_uses_and_invasive_exception if {
	evs := [{"date": "2026-08-02", "type": "mow", "removed": true}, {"date": "2026-09-01", "type": "mow", "removed": true}, {"date": "2026-10-01", "type": "chop"}]
	three := with_events(div_arable("D1", 2, []), evs)
	"O61B-DA-019" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), three])
	inv := with_div(three, {"first_declared_year": 2025, "invasive_species_present": true})
	inp := json.patch(with_parcels([arable("A1", 18, "Winterweizen"), inv]), [{"op": "add", "path": "/oepul/o6_1b/invasive_species_over_25_percent_of_arable_div", "value": true}])
	not "O61B-DA-019" in ids(o6_1b.violations) with input as inp
}

test_third_use_2026_with_opbio if {
	evs := [{"date": "2026-06-02", "type": "mow", "removed": true}, {"date": "2026-07-01", "type": "mow", "removed": true}, {"date": "2026-08-10", "type": "mow", "removed": true}]
	opt := with_events(div_arable("D1", 2, ["OPBIO"]), evs)
	vs := ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), div_arable("D2", 1.5, []), opt])
	not "O61B-DA-019" in vs
	not "O61B-DA-018" in vs
	opt25 := with_events(div_arable("D1", 2, ["OPBIO"]), [{"date": "2025-06-02", "type": "mow", "removed": true}, {"date": "2025-07-01", "type": "mow", "removed": true}, {"date": "2025-08-10", "type": "mow", "removed": true}])
	inp25 := json.patch(with_parcels([arable("A1", 18, "Winterweizen"), div_arable("D2", 1.5, []), opt25]), [{"op": "replace", "path": "/farm/year", "value": 2025}])
	"O61B-DA-019" in ids(o6_1b.violations) with input as inp25
}

test_cleaning_cut_first_year_only if {
	new := with_events(with_div(div_arable("D1", 2, []), {"first_declared_year": 2026, "is_new_sowing": true, "seed_mixture": {"insect_pollinated_partners": 8, "plant_families": 4, "non_insect_share_percent": 5}}), [{"date": "2026-06-01", "type": "mow", "cleaning_cut": true, "removed": false}])
	vs := ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), new])
	not "O61B-DA-023" in vs
	not "O61B-DA-018" in vs
	old := with_events(div_arable("D1", 2, []), [{"date": "2026-06-01", "type": "mow", "cleaning_cut": true, "removed": false}])
	"O61B-DA-023" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), old])
}

test_no_fertilizer_and_no_threshing if {
	f := object.union(div_arable("D1", 2, []), {"operations": {"fertilizer_applications": [{"date": "2026-03-01", "type": "solid_manure"}], "use_events": [{"date": "2026-08-20", "type": "thresh"}]}})
	vs := ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), f])
	"O61B-DA-025" in vs
	"O61B-DA-019" in vs
}

test_prohibited_uses_and_removal_method if {
	p := object.union(with_div(div_arable("D1", 2, []), {"removal_implement": "Herbizid"}), {"operations": {"prohibited_uses": ["machine_parking"]}})
	vs := ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), p])
	"O61B-DA-026" in vs
	"O61B-DA-027" in vs
}

test_div_land_use_types if {
	bad := object.union(div_arable("D1", 2, []), {"schlagnutzungsart": "Winterweizen"})
	"O61B-AN-003" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), bad])
	weide := object.union(div_arable("D1", 2, []), {"schlagnutzungsart": "Ackerweide"})
	not "O61B-AN-003" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), weide])
}

# --- 6.1.5 DIVRS Acker ---------------------------------------------------------------------------

divrs_mix := {"species_count": 32, "family_count": 8, "seed_rate_kg_ha": 22, "max_single_species_weight_percent": 4, "regional_origin_certified": true, "documented": true}

divrs_arable(id, a, variant, evs) := {
	"parcel_id": id, "area_ha": a, "land_use": "arable", "schlagnutzungsart": "Sonstiges Feldfutter",
	"crop": {"crop_name": "Sonstiges Feldfutter"}, "oepul_codes": ["DIVRS"],
	"constraints": {"biodiversity_area": {"first_declared_year": 2025, "is_new_sowing": true, "divrs_variant": variant, "seed_mixture": object.union(divrs_mix, {"insect_pollinated_partners": 20, "plant_families": 8, "non_insect_share_percent": 5}), "year_complete": true}},
	"operations": {"use_events": evs},
}

test_divrs_arable_seed_requirements if {
	ok := divrs_arable("R1", 2, "sonstiges_feldfutter", [{"date": "2026-08-05", "type": "mow", "removed": true}])
	not "O61B-DA-028" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), ok])
	bad := json.patch(ok, [{"op": "replace", "path": "/constraints/biodiversity_area/seed_mixture/species_count", "value": 25}])
	"O61B-DA-028" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), bad])
	heavy := json.patch(ok, [{"op": "replace", "path": "/constraints/biodiversity_area/seed_mixture/max_single_species_weight_percent", "value": 8}])
	"O61B-DA-028" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), heavy])
	ecotype := json.patch(heavy, [{"op": "add", "path": "/constraints/biodiversity_area/seed_mixture/ecotype_seed_used", "value": true}])
	not "O61B-DA-028" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), ecotype])
}

test_divrs_arable_care_variants if {
	chop := divrs_arable("R1", 2, "sonstiges_feldfutter", [{"date": "2026-08-05", "type": "chop"}])
	"O61B-DA-030" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), chop])
	gb := object.union(divrs_arable("R1", 2, "gruenbrache", [{"date": "2026-10-02", "type": "chop"}]), {"schlagnutzungsart": "Grünbrache"})
	not "O61B-DA-030" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), gb])
	gb_early := object.union(divrs_arable("R1", 2, "gruenbrache", [{"date": "2026-09-02", "type": "chop"}]), {"schlagnutzungsart": "Grünbrache"})
	"O61B-DA-030" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), gb_early])
}

# --- 6.2 Grünland-Biodiversitätsflächen -------------------------------------------------------

test_grassland_div_7_percent if {
	ps := [arable("A1", 1, "Kleegras"), mown("G1", 9.5, "Mähwiese/-weide drei und mehr Nutzungen", []), mown("G2", 0.5, "Einmähdige Wiese", ["DIVSZ"])]
	"O61B-DG-001" in ids(o6_1b.violations) with input as with_parcels(ps)
	nat := with_div(mown("G2", 0.8, "Einmähdige Wiese", ["DIVSZ", "NAT"]), {"nat_auflagen": ["GL12"]})
	not "O61B-DG-001" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 1, "Kleegras"), mown("G1", 9.2, "Mähwiese/-weide drei und mehr Nutzungen", []), nat])
	nat_bad := with_div(mown("G2", 0.8, "Einmähdige Wiese", ["DIVSZ", "NAT"]), {"nat_auflagen": ["GL30"]})
	"O61B-DG-001" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 1, "Kleegras"), mown("G1", 9.2, "Mähwiese/-weide drei und mehr Nutzungen", []), nat_bad])
}

test_grassland_field_piece_rule if {
	ps := [
		object.union(mown("G1", 6, "Mähwiese/-weide drei und mehr Nutzungen", []), {"field_piece_id": "GF"}),
		object.union(mown("G2", 0.07, "Mähwiese/-weide zwei Nutzungen", ["DIVAGF"]), {"field_piece_id": "GF"}),
		object.union(mown("G3", 3.93, "Mähwiese/-weide zwei Nutzungen", []), {"field_piece_id": "GX"}),
		object.union(mown("G4", 0.7, "Einmähdige Wiese", ["DIVAGF"]), {"field_piece_id": "GX"}),
	]
	fps := [{"field_piece_id": "GF", "land_use": "grassland", "area_ha": 7, "mown_area_ha": 6.07, "gloez_lse_area_ha": 0.1}]
	inp := json.patch(with_parcels(ps), [{"op": "replace", "path": "/land/field_pieces", "value": fps}])
	not "O61B-DG-003" in ids(o6_1b.violations) with input as inp
	inp2 := json.patch(inp, [{"op": "replace", "path": "/land/field_pieces/0/gloez_lse_area_ha", "value": 0}])
	"O61B-DG-003" in ids(o6_1b.violations) with input as inp2
}

divsz(cmp, first) := with_events(with_div(mown("G2", 1, "Mähwiese/-weide zwei Nutzungen", ["DIVSZ"]), {"comparable_second_cut_date": cmp, "year_complete": true}), [{"date": first, "type": "mow", "removed": true}])

divsz_violation(cmp, first) if "O61B-DG-007" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 1, "Kleegras"), mown("G1", 9, "Mähwiese/-weide drei und mehr Nutzungen", []), divsz(cmp, first)])

# Beispiele Kap. 6.2.4.1
test_divsz_examples if {
	divsz_violation("2026-06-10", "2026-06-14")
	not divsz_violation("2026-06-10", "2026-06-15")
	divsz_violation("2026-06-20", "2026-06-19")
	not divsz_violation("2026-06-20", "2026-06-20")
	divsz_violation("2026-07-30", "2026-07-14")
	not divsz_violation("2026-07-30", "2026-07-15")
}

test_divsz_one_cut_meadow_and_phenology if {
	one := with_events(with_div(mown("G2", 1, "Einmähdige Wiese", ["DIVSZ"]), {"year_complete": true}), [{"date": "2026-06-15", "type": "mow", "removed": true}])
	not "O61B-DG-007" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 1, "Kleegras"), mown("G1", 9, "Mähwiese/-weide drei und mehr Nutzungen", []), one])
	shifted := with_events(with_div(mown("G2", 1, "Einmähdige Wiese", ["DIVSZ"]), {"year_complete": true, "phenology_shift_days": 7}), [{"date": "2026-06-08", "type": "mow", "removed": true}])
	not "O61B-DG-007" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 1, "Kleegras"), mown("G1", 9, "Mähwiese/-weide drei und mehr Nutzungen", []), shifted])
}

# Meldung 22.05.2026: Tirol/Vorarlberg 8. Juni vorverlegt, zusätzlich 14 Tage mit OPBIO -> 25. Mai
test_divsz_drought_2026_advance if {
	p := with_events(with_div(mown("G2", 1, "Mähwiese/-weide zwei Nutzungen", ["DIVSZ", "OPBIO"]), {"comparable_second_cut_date": "2026-05-25", "phenology_shift_days": 7, "year_complete": true}), [{"date": "2026-05-25", "type": "mow", "removed": true}])
	not "O61B-DG-007" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 1, "Kleegras"), mown("G1", 9, "Mähwiese/-weide drei und mehr Nutzungen", []), mown("G3", 1, "Einmähdige Wiese", ["DIVAGF"]), p])
	p_no := json.patch(p, [{"op": "replace", "path": "/oepul_codes", "value": ["DIVSZ"]}])
	"O61B-DG-007" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 1, "Kleegras"), mown("G1", 9, "Mähwiese/-weide drei und mehr Nutzungen", []), p_no])
}

divnfz(evs, extra) := with_events(with_div(mown("G2", 1, "Mähwiese/-weide zwei Nutzungen", array.concat(["DIVNFZ"], extra)), {"first_use_completed_date": "2026-06-24", "year_complete": true}), evs)

divnfz_violation(p) if "O61B-DG-011" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 1, "Kleegras"), mown("G1", 9, "Mähwiese/-weide drei und mehr Nutzungen", []), p])

# Beispiel Kap. 6.2.4.2: Mahd 22.6., Ballenabtransport 24.6. -> nächste Überfahrt frühestens 27.8.
test_divnfz_example_63_days if {
	divnfz_violation(divnfz([{"date": "2026-06-22", "type": "mow", "removed": true}, {"date": "2026-08-26", "type": "mow", "removed": true}], []))
	not divnfz_violation(divnfz([{"date": "2026-06-22", "type": "mow", "removed": true}, {"date": "2026-08-27", "type": "mow", "removed": true}], []))
	o6_1b.divnfz_first_allowed_date(divnfz([], [])) == "2026-08-27" with input as base_input
}

test_divnfz_fertilizer_in_rest_period if {
	p := object.union(divnfz([{"date": "2026-06-22", "type": "mow", "removed": true}, {"date": "2026-09-01", "type": "mow", "removed": true}], []), {"operations": {"fertilizer_applications": [{"date": "2026-07-10", "type": "slurry"}]}})
	divnfz_violation(p)
}

# Meldung 22.05.2026: Verkürzung auf 7 Wochen (49 Tage) bei OPBIO
test_divnfz_drought_2026_49_days if {
	p := divnfz([{"date": "2026-06-22", "type": "mow", "removed": true}, {"date": "2026-08-13", "type": "mow", "removed": true}], ["OPBIO"])
	not divnfz_violation(p)
	p2 := divnfz([{"date": "2026-06-22", "type": "mow", "removed": true}, {"date": "2026-08-12", "type": "mow", "removed": true}], ["OPBIO"])
	divnfz_violation(p2)
}

test_divnfz_second_use_required if {
	p := divnfz([{"date": "2026-06-22", "type": "mow", "removed": true}], [])
	"O61B-DG-013" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 1, "Kleegras"), mown("G1", 9, "Mähwiese/-weide drei und mehr Nutzungen", []), p])
}

test_divagf_last_use_15_august if {
	late := with_events(with_div(mown("G2", 1, "Mähwiese/-weide zwei Nutzungen", ["DIVAGF"]), {"year_complete": true}), [{"date": "2026-06-20", "type": "mow", "removed": true}, {"date": "2026-08-20", "type": "graze"}])
	"O61B-DG-015" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 1, "Kleegras"), mown("G1", 9, "Mähwiese/-weide drei und mehr Nutzungen", []), late])
	next_year := with_div(mown("G2", 1, "Mähwiese/-weide zwei Nutzungen", ["DIVNFZ"]), {"previous_year_code": "DIVAGF"})
	"O61B-DG-016" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 1, "Kleegras"), mown("G1", 9, "Mähwiese/-weide drei und mehr Nutzungen", []), next_year])
}

test_grassland_div_requires_mowing_with_removal if {
	grazed := with_events(with_div(mown("G2", 1, "Mähwiese/-weide zwei Nutzungen", ["DIVSZ"]), {"year_complete": true}), [{"date": "2026-07-20", "type": "graze"}])
	"O61B-DG-006" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 1, "Kleegras"), mown("G1", 9, "Mähwiese/-weide drei und mehr Nutzungen", []), grazed])
}

divrs_gl(glz, slope, evs, fert) := {
	"parcel_id": "R2", "area_ha": 1, "land_use": "grassland", "schlagnutzungsart": "Mähwiese/-weide zwei Nutzungen", "is_mown": true,
	"oepul_codes": ["DIVRS"], "gruenlandzahl": glz, "slope_percent": slope,
	"constraints": {"biodiversity_area": {"first_declared_year": 2025, "sowing_date": "2025-04-20", "seed_mixture": divrs_mix, "year_complete": true}},
	"operations": {"use_events": evs, "fertilizer_applications": fert},
}

divrs_gl_ids(p) := x if {
	x := ids(o6_1b.violations) with input as with_parcels([arable("A1", 1, "Kleegras"), mown("G1", 9, "Mähwiese/-weide drei und mehr Nutzungen", []), p])
}

test_divrs_grassland_conditions if {
	ok := divrs_gl(35, 10, [{"date": "2026-07-16", "type": "mow", "removed": true}], [{"date": "2026-03-01", "type": "solid_manure"}])
	count(divrs_gl_ids(ok)) == 0
	"O61B-DG-018" in divrs_gl_ids(divrs_gl(25, 10, [{"date": "2026-07-16", "type": "mow", "removed": true}], []))
	"O61B-DG-018" in divrs_gl_ids(divrs_gl(35, 18, [{"date": "2026-07-16", "type": "mow", "removed": true}], []))
	"O61B-DG-020" in divrs_gl_ids(divrs_gl(35, 10, [{"date": "2026-07-10", "type": "mow", "removed": true}], []))
	"O61B-DG-020" in divrs_gl_ids(divrs_gl(35, 10, [{"date": "2026-07-16", "type": "mow", "removed": true}, {"date": "2026-08-20", "type": "mow", "removed": true}, {"date": "2026-10-01", "type": "graze"}], []))
	"O61B-DG-021" in divrs_gl_ids(divrs_gl(35, 10, [{"date": "2026-07-16", "type": "mow", "removed": true}], [{"date": "2026-03-01", "type": "slurry"}]))
}

# Meldung 22.05.2026: Variantenwechsel nach dem 15. April
test_grassland_variant_change_2026 if {
	ok := with_div(mown("G2", 1, "Mähwiese/-weide zwei Nutzungen", ["DIVAGF"]), {"variant_changes": [{"from": "DIVSZ", "to": "DIVAGF", "date": "2026-06-15"}]})
	not "O61B-N26-004" in divrs_gl_ids(ok)
	late := with_div(mown("G2", 1, "Mähwiese/-weide zwei Nutzungen", ["DIVAGF"]), {"variant_changes": [{"from": "DIVSZ", "to": "DIVAGF", "date": "2026-06-16"}]})
	"O61B-N26-004" in divrs_gl_ids(late)
	back := with_div(mown("G2", 1, "Mähwiese/-weide zwei Nutzungen", ["DIVSZ"]), {"variant_changes": [{"from": "DIVNFZ", "to": "DIVSZ", "date": "2026-05-01"}]})
	"O61B-N26-004" in divrs_gl_ids(back)
	nfz_agf := with_div(mown("G2", 1, "Mähwiese/-weide zwei Nutzungen", ["DIVAGF"]), {"variant_changes": [{"from": "DIVNFZ", "to": "DIVAGF", "date": "2026-08-15"}]})
	not "O61B-N26-004" in divrs_gl_ids(nfz_agf)
}
