package oepul.o6_1a.biodiversity_arable_test

import data.oepul.o6_1a.biodiversity_arable as ba

ids(vs) := {v.rule_id | some v in vs}

approx(a, b) if abs(a - b) < 0.0001

crop(id, fp, a) := {"parcel_id": id, "field_piece_id": fp, "area_ha": a, "land_use": "arable", "crop": {"schlagnutzungsart": "Winterweizen"}}

div_parcel(id, fp, a, extra) := object.union({"parcel_id": id, "field_piece_id": fp, "area_ha": a, "land_use": "arable", "codes": ["DIV"], "crop": {"schlagnutzungsart": "Grünbrache"}, "biodiversity": {"first_declared_year": 2024}}, extra)

meadow(id, fp, a) := {"parcel_id": id, "field_piece_id": fp, "area_ha": a, "land_use": "grassland", "crop": {"schlagnutzungsart": "Mähwiese/-weide zwei Nutzungen"}}

gdiv(id, fp, a) := {"parcel_id": id, "field_piece_id": fp, "area_ha": a, "land_use": "grassland", "codes": ["DIVSZ"], "crop": {"schlagnutzungsart": "Mähwiese/-weide zwei Nutzungen"}}

# --- Mindestanlage 7 % ---
test_minimum_7_percent_violation if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [crop("W", "F1", 9.5), div_parcel("D", "F2", 0.5, {})]}}
	"UBB-DIVA-MIN-001" in ids(ba.violations) with input as inp
}

test_minimum_7_percent_met if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [crop("W", "F1", 9.3), div_parcel("D", "F2", 0.7, {})]}}
	not "UBB-DIVA-MIN-001" in ids(ba.violations) with input as inp
}

test_minimum_not_applicable_up_to_2_ha if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [crop("W", "F1", 2.0)]}}
	not ba.obligation_applies with input as inp
	count(ba.violations) == 0 with input as inp
}

# Beispiel Kapitel 6.1.1: 9 ha Acker, 5 ha gemähtes Grünland; 0,25 ha Acker + 0,80 ha Grünland erfüllt.
test_example_small_farm_grassland_substitution if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [
		crop("W", "F1", 8.75), div_parcel("D", "F2", 0.25, {}),
		meadow("G", "F3", 4.2), gdiv("GD", "F4", 0.8),
	]}}
	ba.minimum_met with input as inp
}

test_example_small_farm_grassland_share_too_low if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [
		crop("W", "F1", 8.0), div_parcel("D", "F2", 1.0, {}),
		meadow("G", "F3", 4.7), gdiv("GD", "F4", 0.3),
	]}}
	approx(ba.arable_div_area_ha, 1.0) with input as inp
	ba.minimum_met with input as inp
	inp2 := {"farm": {"year": 2026}, "land": {"parcels": [
		crop("W", "F1", 8.5), div_parcel("D", "F2", 0.5, {}),
		meadow("G", "F3", 4.7), gdiv("GD", "F4", 0.3),
	]}}
	not ba.minimum_met with input as inp2
}

# --- Feldstücksbezogene Anlage (Beispiel Kapitel 6.1.2) ---
test_field_piece_example_with_gloez_hedge if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [
		crop("K1", "F6", 3.0), crop("K2", "F6", 2.86),
		div_parcel("S1", "F6", 0.07, {}), div_parcel("S2", "F6", 0.07, {}),
		{"parcel_id": "H", "field_piece_id": "F6", "area_ha": 0.10, "land_use": "arable", "area_kind": "gloez_landscape_element"},
		crop("R", "F7", 22.04), div_parcel("D", "F7", 1.96, {}),
	]}}
	not "UBB-DIVA-FS-001" in ids(ba.violations) with input as inp
	approx(ba.fp_div_credit("F6"), 0.24) with input as inp
	not "UBB-DIVA-MIN-001" in ids(ba.violations) with input as inp
}

test_field_piece_violation_without_div if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [crop("K1", "F1", 6.0), crop("K2", "F2", 4.0), div_parcel("D", "F2", 0.8, {})]}}
	"UBB-DIVA-FS-001" in ids(ba.violations) with input as inp
}

test_field_piece_obligation_only_from_10_ha if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [crop("K1", "F1", 6.0), crop("K2", "F2", 3.2), div_parcel("D", "F2", 0.7, {})]}}
	not "UBB-DIVA-FS-001" in ids(ba.violations) with input as inp
}

test_gloez_elements_not_counted_for_7_percent if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [crop("K1", "F1", 10.0), {"parcel_id": "H", "field_piece_id": "F1", "area_ha": 1.0, "land_use": "arable", "area_kind": "gloez_landscape_element"}]}}
	ba.arable_div_area_ha == 0 with input as inp
}

test_azr_exemption_2023 if {
	p1 := object.union(crop("K1", "F1", 6.0), {"codes": ["AZR"]})
	inp := {"farm": {"year": 2023}, "land": {"parcels": [p1, crop("K2", "F2", 4.0), div_parcel("D", "F2", 0.8, {"biodiversity": {"first_declared_year": 2023, "sowing_date": "2023-04-01", "seed_mixture": {"insect_pollinated_partners": 7, "plant_families": 3, "non_insect_pollinated_share_percent": 5}}})]}}
	not "UBB-DIVA-FS-001" in ids(ba.violations) with input as inp
	"UBB-DIVA-FS-003" in ids(ba.violations) with input as {"farm": {"year": 2024}, "land": {"parcels": [p1]}}
}

# --- Anrechenbarkeit ---
test_k20_and_nat_without_sa01_not_creditable if {
	inp := {"farm": {"year": 2024}, "land": {"parcels": [
		div_parcel("K20", "F1", 1.0, {"codes": ["DIV", "K20"]}),
		div_parcel("NAT1", "F2", 1.0, {"codes": ["DIV", "NAT"], "project_conditions": ["GL01"]}),
		div_parcel("NAT2", "F3", 1.0, {"codes": ["DIV", "NAT"], "project_conditions": ["SA01"]}),
	]}}
	approx(ba.arable_div_area_ha, 1.0) with input as inp
}

test_gloez8_creditable_only_until_2024 if {
	p := div_parcel("G8", "F1", 1.0, {"codes": ["DIV", "GLOEZ8"]})
	ba.arable_div_area_ha == 1.0 with input as {"farm": {"year": 2024}, "land": {"parcels": [p]}}
	ba.arable_div_area_ha == 0 with input as {"farm": {"year": 2025}, "land": {"parcels": [p]}}
}

test_multi_use_hedge_creditable if {
	h := {"parcel_id": "MNH", "field_piece_id": "F1", "area_ha": 0.3, "land_use": "arable", "area_kind": "mehrnutzenhecke", "codes": ["DIV"], "crop": {"schlagnutzungsart": "LSE Mehrnutzenhecke"}}
	ba.arable_div_area_ha == 0.3 with input as {"farm": {"year": 2026}, "land": {"parcels": [h]}}
}

# --- Ansaat ---
new_div := div_parcel("N", "F1", 1.0, {"biodiversity": {"first_declared_year": 2026, "sowing_date": "2026-05-20", "seed_mixture": {"insect_pollinated_partners": 6, "plant_families": 3, "non_insect_pollinated_share_percent": 5}}})

test_seed_mixture_and_sowing_date if {
	vs := ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [new_div]}}
	"UBB-DIVA-ANS-001" in vs
	"UBB-DIVA-ANS-002" in vs
}

test_existing_fallow_exemption if {
	p := div_parcel("E", "F1", 1.0, {"biodiversity": {"first_declared_year": 2026, "sowing_exemption": "existing_fallow_since_2020", "exemption_evidence_ok": true}})
	vs := ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
	not "UBB-DIVA-ANS-001" in vs
	not "UBB-DIVA-ANS-002" in vs
}

test_breakup_two_year_rule if {
	early := div_parcel("B", "F1", 1.0, {"biodiversity": {"first_declared_year": 2025, "breakup_date": "2026-09-01"}})
	"UBB-DIVA-ANS-003" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [early]}}
	winter := div_parcel("B", "F1", 1.0, {"biodiversity": {"first_declared_year": 2025, "breakup_date": "2026-08-05", "followed_by_winter_crop_or_catch_crop": true}})
	not "UBB-DIVA-ANS-003" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [winter]}}
	ok := div_parcel("B", "F1", 1.0, {"biodiversity": {"first_declared_year": 2025, "breakup_date": "2026-09-15"}})
	not "UBB-DIVA-ANS-003" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [ok]}}
	lost := div_parcel("B", "F1", 1.0, {"biodiversity": {"first_declared_year": 2026, "breakup_date": "2026-09-01", "breakup_reason": "loss_of_control"}})
	not "UBB-DIVA-ANS-003" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [lost]}}
}

test_takeover_uses_previous_holder_establishment_year if {
	p := div_parcel("T", "F1", 1.0, {"biodiversity": {"first_declared_year": 2026, "establishment_year": 2025, "breakup_date": "2026-09-15"}})
	not "UBB-DIVA-ANS-003" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
}

# --- Pflege-/Nutzungsauflagen ---
used(id, a, events) := div_parcel(id, "F1", a, {"operations": {"use_events": events}})

test_max_two_uses if {
	p := used("U", 1.0, [{"date": "2026-08-02", "type": "mow", "material_removed": true}, {"date": "2026-09-01", "type": "mulch"}, {"date": "2026-10-01", "type": "mulch"}])
	"UBB-DIVA-PFL-002" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
}

test_post_grazing_care_not_counted_from_2025 if {
	p := used("U", 1.0, [{"date": "2026-08-02", "type": "graze"}, {"date": "2026-08-05", "type": "mulch", "post_grazing_care": true, "material_removed": false}, {"date": "2026-09-20", "type": "graze"}])
	not "UBB-DIVA-PFL-002" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
}

test_grazing_rules if {
	p := used("G", 1.0, [{"date": "2026-07-10", "type": "graze"}])
	"UBB-DIVA-PFL-005" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
	p24 := used("G", 1.0, [{"date": "2024-08-10", "type": "graze"}])
	"UBB-DIVA-PFL-004" in ids(ba.violations) with input as {"farm": {"year": 2024}, "land": {"parcels": [p24]}}
}

test_after_early_mowing_only_one_grazing if {
	small := used("S", 0.2, [{"date": "2026-06-01", "type": "mow", "material_removed": true}, {"date": "2026-08-10", "type": "graze"}, {"date": "2026-09-10", "type": "graze"}])
	big := used("B", 0.8, [{"date": "2026-08-10", "type": "mow", "material_removed": true}])
	"UBB-DIVA-PFL-006" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [small, big]}}
}

test_threshing_forbidden if {
	p := used("T", 1.0, [{"date": "2026-08-10", "type": "thresh"}])
	"UBB-DIVA-PFL-003" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
}

test_at_least_every_second_year if {
	p := div_parcel("N", "F1", 1.0, {"biodiversity": {"first_declared_year": 2024, "used_previous_year": false}})
	"UBB-DIVA-PFL-001" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
}

# Beispiel Kapitel 6.1.4.2: 1,5 ha NAT mit Häckseln ab 1.7. laut Projektbestätigung, 2,5 ha DIV erst ab 1.8.
test_75_percent_rule_nat_example if {
	nat := div_parcel("NAT", "F1", 1.5, {"codes": ["DIV", "NAT"], "project_conditions": ["SA01"], "operations": {"use_events": [{"date": "2026-07-02", "type": "mulch"}]}})
	ok := used("D", 2.5, [{"date": "2026-08-01", "type": "mulch"}])
	not "UBB-DIVA-PFL-007" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [nat, ok]}}
	bad := used("D", 2.5, [{"date": "2026-07-20", "type": "mulch"}])
	"UBB-DIVA-PFL-007" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [nat, bad]}}
}

test_25_percent_early_use_allowed if {
	early := used("E", 1.0, [{"date": "2026-06-10", "type": "mow", "material_removed": true}])
	late := used("L", 3.0, [{"date": "2026-08-10", "type": "mow", "material_removed": true}])
	not "UBB-DIVA-PFL-007" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [early, late]}}
}

test_cleaning_cut_first_year_not_counted if {
	p := div_parcel("C", "F1", 1.0, {"biodiversity": {"first_declared_year": 2026, "sowing_date": "2026-04-10", "seed_mixture": {"insect_pollinated_partners": 8, "plant_families": 4, "non_insect_pollinated_share_percent": 5}}, "operations": {"use_events": [{"date": "2026-06-01", "type": "cleaning_cut", "material_removed": false}]}})
	vs := ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
	not "UBB-DIVA-PFL-007" in vs
	not "UBB-DIVA-PFL-008" in vs
	existing := used("X", 1.0, [{"date": "2026-06-01", "type": "cleaning_cut", "material_removed": false}])
	"UBB-DIVA-PFL-008" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [existing]}}
}

test_invasive_species_exception if {
	p := div_parcel("I", "F1", 1.0, {"biodiversity": {"first_declared_year": 2025, "invasive_species_present": true}, "operations": {"use_events": [{"date": "2026-06-01", "type": "mow"}, {"date": "2026-07-01", "type": "mow"}, {"date": "2026-08-01", "type": "mow"}]}})
	inp := {"farm": {"year": 2026, "oepul": {"ubb": {"arable_div_invasive_share_percent": 30}}}, "land": {"parcels": [p]}}
	not "UBB-DIVA-PFL-002" in ids(ba.violations) with input as inp
	not "UBB-DIVA-PFL-007" in ids(ba.violations) with input as inp
}

# --- Betriebsmittel / Befahren ---
test_fertilizer_psm_driving if {
	p := div_parcel("M", "F1", 1.0, {"operations": {
		"fertilization_events": [{"date": "2026-03-01", "type": "mineral"}],
		"psm_applications": [{"date": "2026-05-01", "organic_approved_only": false}, {"date": "2026-05-02", "organic_approved_only": true}],
		"driving_events": [{"date": "2026-07-01", "purpose": "crossing"}, {"date": "2026-07-15", "purpose": "turning"}],
	}})
	vs := ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
	"UBB-DIVA-BM-001" in vs
	"UBB-DIVA-BM-002" in vs
	"UBB-DIVA-BEF-001" in vs
}

test_only_mechanical_removal if {
	p := div_parcel("R", "F1", 1.0, {"biodiversity": {"first_declared_year": 2024, "removal_method": "chemical"}})
	"UBB-DIVA-BM-003" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
}

# --- DIVRS Acker ---
rs_mix := {"regional_list_species": 32, "regional_list_families": 8, "seed_rate_kg_per_ha": 22, "max_single_species_weight_percent": 5, "regional_origin_certified": true, "documented_labels_invoices": true}

test_divrs_feldfutter_variant if {
	p := {"parcel_id": "RS", "field_piece_id": "F1", "area_ha": 1.0, "land_use": "arable", "codes": ["DIVRS"], "crop": {"schlagnutzungsart": "Sonstiges Feldfutter"}, "biodiversity": {"first_declared_year": 2025, "seed_mixture": rs_mix}, "operations": {"use_events": [{"date": "2026-08-05", "type": "mow", "material_removed": true}]}}
	ba.divrs_eligible(p) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
	mulched := object.union(p, {"operations": {"use_events": [{"date": "2026-08-05", "type": "mulch"}]}})
	not ba.divrs_eligible(mulched) with input as {"farm": {"year": 2026}, "land": {"parcels": [mulched]}}
}

test_divrs_gruenbrache_variant_from_october if {
	p := {"parcel_id": "RS", "field_piece_id": "F1", "area_ha": 1.0, "land_use": "arable", "codes": ["DIVRS"], "crop": {"schlagnutzungsart": "Grünbrache"}, "biodiversity": {"first_declared_year": 2025, "seed_mixture": rs_mix}, "operations": {"use_events": [{"date": "2026-10-02", "type": "mulch"}]}}
	ba.divrs_variant(p) == "gruenbrache" with input as {"farm": {"year": 2026}}
	ba.divrs_eligible(p) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
	early := object.union(p, {"operations": {"use_events": [{"date": "2026-09-20", "type": "mulch"}]}})
	not ba.divrs_eligible(early) with input as {"farm": {"year": 2026}, "land": {"parcels": [early]}}
}

test_divrs_seed_requirements if {
	p := {"parcel_id": "RS", "area_ha": 1.0, "land_use": "arable", "codes": ["DIVRS"], "crop": {"schlagnutzungsart": "Sonstiges Feldfutter"}, "biodiversity": {"seed_mixture": object.union(rs_mix, {"regional_list_species": 25})}}
	"UBB-DIVRSA-001" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
	eco := {"parcel_id": "RS", "area_ha": 1.0, "land_use": "arable", "codes": ["DIVRS"], "crop": {"schlagnutzungsart": "Sonstiges Feldfutter"}, "biodiversity": {"seed_mixture": object.union(rs_mix, {"max_single_species_weight_percent": 12, "ecotype_seed_used": true})}}
	not "UBB-DIVRSA-001" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [eco]}}
}

test_div_code_schlagnutzungsart if {
	p := {"parcel_id": "X", "area_ha": 1.0, "land_use": "arable", "codes": ["DIV"], "crop": {"schlagnutzungsart": "Ackerweide"}}
	"UBB-ANT-010" in ids(ba.violations) with input as {"farm": {"year": 2024}, "land": {"parcels": [p]}}
	not "UBB-ANT-010" in ids(ba.violations) with input as {"farm": {"year": 2025}, "land": {"parcels": [p]}}
}
