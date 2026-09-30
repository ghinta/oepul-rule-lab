package oepul.o6_1a.options_notices_general_test

import data.oepul.o6_1a
import data.oepul.o6_1a.biodiversity_arable as ba
import data.oepul.o6_1a.biodiversity_grassland as bg
import data.oepul.o6_1a.general_conditions as gc
import data.oepul.o6_1a.notices_2026
import data.oepul.o6_1a.options

approx(a, b) if abs(a - b) < 0.001

ids(vs) := {v.rule_id | some v in vs}

# --- Punktförmige Landschaftselemente / Streuobst ---
lse(id, extra) := object.union({"id": id, "field_piece_id": "F1", "crown_diameter_m": 3, "area_m2": 50, "min_distance_to_other_m": 6, "distance_to_agricultural_area_m": 2, "under_control": true, "applied_in_mfa": true, "maintained_full_year": true}, extra)

field1 := {"parcel_id": "P", "field_piece_id": "F1", "area_ha": 1.0, "land_use": "grassland", "crop": {"schlagnutzungsart": "Mähwiese/-weide zwei Nutzungen"}}

test_lse_premium_per_element if {
	inp := {"farm": {"year": 2026, "oepul": {"ubb": {"point_landscape_elements": [lse("L1", {}), lse("L2", {"streuobst": true, "fruit_species": "Apfel", "tree_form": "hochstamm", "strong_growing_large_crown": true, "coded_so": true})]}}}, "land": {"parcels": [field1]}}
	approx(options.lse_premium, 13.0 + 8.6) with input as inp
}

test_lse_definition_limits if {
	small := lse("L", {"crown_diameter_m": 1.5})
	"UBB-LSE-001" in ids(options.violations) with input as {"farm": {"year": 2026, "oepul": {"ubb": {"point_landscape_elements": [small]}}}}
	big := lse("L", {"area_m2": 120})
	"UBB-LSE-001" in ids(options.violations) with input as {"farm": {"year": 2026, "oepul": {"ubb": {"point_landscape_elements": [big]}}}}
	alm := lse("L", {"on_alm_or_hutweide": true})
	"UBB-LSE-001" in ids(options.violations) with input as {"farm": {"year": 2026, "oepul": {"ubb": {"point_landscape_elements": [alm]}}}}
	gloez := lse("L", {"is_gloez": true})
	"UBB-LSE-001" in ids(options.violations) with input as {"farm": {"year": 2026, "oepul": {"ubb": {"point_landscape_elements": [gloez]}}}}
}

test_lse_max_80_per_ha_field_piece if {
	els := [lse(sprintf("L%d", [i]), {}) | some i in numbers.range(1, 90)]
	small_field := object.union(field1, {"area_ha": 0.5})
	inp := {"farm": {"year": 2026, "oepul": {"ubb": {"point_landscape_elements": els}}}, "land": {"parcels": [small_field]}}
	options.lse_other_count == 40 with input as inp
	"UBB-LSE-003" in ids(options.violations) with input as inp
}

test_streuobst_species_by_year if {
	mul := lse("M", {"streuobst": true, "fruit_species": "Maulbeere", "tree_form": "halbstamm", "strong_growing_large_crown": true, "coded_so": true})
	"UBB-SO-001" in ids(options.violations) with input as {"farm": {"year": 2024, "oepul": {"ubb": {"point_landscape_elements": [mul]}}}, "land": {"parcels": [field1]}}
	not "UBB-SO-001" in ids(options.violations) with input as {"farm": {"year": 2025, "oepul": {"ubb": {"point_landscape_elements": [mul]}}}, "land": {"parcels": [field1]}}
	wild_plum := lse("W", {"streuobst": true, "fruit_species": "Zwetschke", "wild_form": true, "tree_form": "hochstamm", "strong_growing_large_crown": true, "coded_so": true})
	"UBB-SO-001" in ids(options.violations) with input as {"farm": {"year": 2025, "oepul": {"ubb": {"point_landscape_elements": [wild_plum]}}}, "land": {"parcels": [field1]}}
}

# --- Mehrnutzenhecken ---
hedge(extra) := {"parcel_id": "MNH", "field_piece_id": "F1", "area_ha": 0.4, "land_use": "arable", "area_kind": "mehrnutzenhecke", "crop": {"schlagnutzungsart": "LSE Mehrnutzenhecke"}, "hedge": object.union({"planted_date": "2025-03-01", "state_concept": true, "gis_confirmed": true, "adjacent_own_arable_field_piece": true, "average_width_m": 8, "herbaceous_share_percent": 25, "herbaceous_permanently_green": true}, extra)}

test_hedge_premium if {
	approx(options.hedge_premium, 400.0) with input as {"farm": {"year": 2026}, "land": {"parcels": [hedge({})]}}
}

test_hedge_conditions if {
	"UBB-MNH-001" in ids(options.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [hedge({"average_width_m": 4})]}}
	"UBB-MNH-001" in ids(options.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [hedge({"herbaceous_used": true})]}}
	"UBB-MNH-001" in ids(options.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [hedge({"planted_date": "2026-06-01"})]}}
	"UBB-MNH-001" in ids(options.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [hedge({"planted_date": "2022-10-01"})]}}
	"UBB-MNH-001" in ids(options.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [hedge({"gis_confirmed": false})]}}
}

# --- Naturschutz-Monitoring ---
mon(prog) := {"program": prog, "participation_confirmation": true, "first_year": 2025, "data_recorded_timely_complete": true, "application_date": "2024-12-01"}

test_monitoring_grosstrappe_requires_naturschutz_ta01 if {
	nat_parcel := {"parcel_id": "N", "area_ha": 1, "land_use": "arable", "codes": ["NAT"], "project_conditions": ["TA01"]}
	ok := {"farm": {"year": 2026, "oepul": {"measures": ["1A", "18"], "ubb": {"monitoring": [mon("grosstrappe")]}}}, "land": {"parcels": [nat_parcel]}}
	approx(options.monitoring_premium, 237.6) with input as ok
	bad := {"farm": {"year": 2026, "oepul": {"measures": ["1A"], "ubb": {"monitoring": [mon("grosstrappe")]}}}, "land": {"parcels": [nat_parcel]}}
	"UBB-MON-001" in ids(options.violations) with input as bad
}

test_monitoring_biodiversity_no_combination_needed if {
	inp := {"farm": {"year": 2026, "oepul": {"measures": ["1A"], "ubb": {"monitoring": [mon("biodiversitaetsmonitoring"), mon("phaenoflex")]}}}}
	approx(options.monitoring_premium, 297.0 + 108.0) with input as inp
}

test_monitoring_first_year_intro_event if {
	m := object.union(mon("phaenoflex"), {"first_year": 2026, "application_date": "2025-12-01"})
	"UBB-MON-001" in ids(options.violations) with input as {"farm": {"year": 2026, "oepul": {"ubb": {"monitoring": [m]}}}}
	m2 := object.union(m, {"intro_event_completed": true})
	not "UBB-MON-001" in ids(options.violations) with input as {"farm": {"year": 2026, "oepul": {"ubb": {"monitoring": [m2]}}}}
}

test_monitoring_last_entry_2028 if {
	m := object.union(mon("phaenoflex"), {"first_year": 2029, "application_date": "2028-12-01"})
	"UBB-ANT-003" in ids(options.violations) with input as {"farm": {"year": 2029, "oepul": {"ubb": {"monitoring": [m]}}}}
}

# --- Sonderregelungen 2026 ---
div_parcel(id, a, codes, events) := {"parcel_id": id, "field_piece_id": id, "area_ha": a, "land_use": "arable", "codes": codes, "crop": {"schlagnutzungsart": "Grünbrache"}, "biodiversity": {"first_declared_year": 2025}, "operations": {"use_events": events}}

# Beispiel Hinweis 22.05.2026: 2 ha DIV, 0,5 ha regulär vor 1.8., restliche 1,5 ha mit OPUBB.
test_2026_early_mowing_with_opubb if {
	regular := div_parcel("R", 0.5, ["DIV"], [{"date": "2026-06-10", "type": "mow", "material_removed": true}])
	coded := div_parcel("C", 1.5, ["DIV", "OPUBB"], [{"date": "2026-06-10", "type": "mow", "material_removed": true}])
	not "UBB-DIVA-PFL-007" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [regular, coded]}}
	uncoded := div_parcel("C", 1.5, ["DIV"], [{"date": "2026-06-10", "type": "mow", "material_removed": true}])
	"UBB-DIVA-PFL-007" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [regular, uncoded]}}
	regular25 := div_parcel("R", 0.5, ["DIV"], [{"date": "2025-06-10", "type": "mow", "material_removed": true}])
	coded25 := div_parcel("C", 1.5, ["DIV", "OPUBB"], [{"date": "2025-06-10", "type": "mow", "material_removed": true}])
	"UBB-DIVA-PFL-007" in ids(ba.violations) with input as {"farm": {"year": 2025}, "land": {"parcels": [regular25, coded25]}}
}

test_2026_grazing_before_august_requires_code if {
	coded := div_parcel("C", 1.0, ["DIV", "OPUBB"], [{"date": "2026-07-01", "type": "graze"}])
	not "UBB-DIVA-PFL-005" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [coded]}}
	uncoded := div_parcel("C", 1.0, ["DIV"], [{"date": "2026-07-01", "type": "graze"}])
	"UBB-DIVA-PFL-005" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [uncoded]}}
}

test_2026_third_use_with_opubb if {
	events := [{"date": "2026-08-02", "type": "mow", "material_removed": true}, {"date": "2026-09-01", "type": "mow", "material_removed": true}, {"date": "2026-10-01", "type": "mulch"}]
	not "UBB-DIVA-PFL-002" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [div_parcel("C", 1.0, ["DIV", "OPUBB"], events)]}}
	"UBB-DIVA-PFL-002" in ids(ba.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [div_parcel("C", 1.0, ["DIV"], events)]}}
}

test_opubb_parcel_gets_no_premium if {
	inp := {"farm": {"year": 2026}, "land": {"parcels": [div_parcel("C", 1.0, ["DIV", "OPUBB"], [])]}}
	o6_1a.decision.premium.arable_base == 0 with input as inp
}

# Beispiel Hinweis 22.05.2026: Tirol/Vorarlberg 8.6. (Vorverlegung 7 Tage) minus 14 Tage -> ab 25.5.
test_2026_divsz_advance_14_days if {
	p := {"parcel_id": "S", "area_ha": 1, "land_use": "grassland", "codes": ["DIVSZ", "OPUBB"], "crop": {"schlagnutzungsart": "Mähwiese/-weide zwei Nutzungen"}, "biodiversity": {"phenology_advance_days": 7, "comparable_second_cut_date": "2026-05-20"}, "operations": {"use_events": [{"date": "2026-05-25", "type": "mow", "material_removed": true}]}}
	not "UBB-DIVG-SZ-001" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
	early := object.union(p, {"operations": {"use_events": [{"date": "2026-05-24", "type": "mow", "material_removed": true}]}})
	"UBB-DIVG-SZ-001" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [early]}}
}

test_2026_divnfz_49_days_with_opubb if {
	p := {"parcel_id": "N", "area_ha": 1, "land_use": "grassland", "codes": ["DIVNFZ", "OPUBB"], "crop": {"schlagnutzungsart": "Mähwiese/-weide zwei Nutzungen"}, "biodiversity": {"first_use_completed_date": "2026-06-01"}, "operations": {"use_events": [{"date": "2026-05-30", "type": "mow", "material_removed": true}, {"date": "2026-07-21", "type": "mow", "material_removed": true}]}}
	not "UBB-DIVG-NFZ-001" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
	p2 := object.union(p, {"codes": ["DIVNFZ"]})
	"UBB-DIVG-NFZ-001" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p2]}}
}

p(ch) := {"parcel_id": "V", "area_ha": 1, "land_use": "grassland", "codes": [ch.to], "crop": {"schlagnutzungsart": "Mähwiese/-weide zwei Nutzungen"}, "biodiversity": {"variant_change": ch}}

test_variant_change_after_april_15 if {
	not "N26-TR-008" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p({"from": "DIVSZ", "to": "DIVAGF", "date": "2026-06-15"})]}}
	"N26-TR-008" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p({"from": "DIVSZ", "to": "DIVNFZ", "date": "2026-06-16"})]}}
	not "N26-TR-008" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p({"from": "DIVNFZ", "to": "DIVAGF", "date": "2026-08-15"})]}}
	"N26-TR-008" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p({"from": "DIVNFZ", "to": "DIVSZ", "date": "2026-05-01"})]}}
	not "N26-TR-008" in ids(bg.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p({"from": "DIVNFZ", "to": "DIVSZ", "date": "2026-04-10"})]}}
}

test_drought_harvest_exemption_districts if {
	p := {"parcel_id": "M", "area_ha": 3, "land_use": "arable", "crop": {"schlagnutzungsart": "Körnermais"}, "harvest": {"harvested_share_percent": 0, "late_summer_autumn_crop": true, "no_harvestable_stand_due_to_drought": true}}
	not "ATB-MBK-001" in ids(gc.violations) with input as {"farm": {"year": 2026, "region": {"federal_state": "Niederösterreich", "district": "Tulln"}}, "land": {"parcels": [p]}}
	not "ATB-MBK-001" in ids(gc.violations) with input as {"farm": {"year": 2026, "region": {"federal_state": "Steiermark", "district": "Weiz"}}, "land": {"parcels": [p]}}
	not "ATB-MBK-001" in ids(gc.violations) with input as {"farm": {"year": 2026, "region": {"federal_state": "Burgenland", "district": "Oberwart"}}, "land": {"parcels": [p]}}
	"ATB-MBK-001" in ids(gc.violations) with input as {"farm": {"year": 2026, "region": {"federal_state": "Tirol", "district": "Innsbruck-Land"}}, "land": {"parcels": [p]}}
	"ATB-MBK-001" in ids(gc.violations) with input as {"farm": {"year": 2025, "region": {"federal_state": "Niederösterreich", "district": "Tulln"}}, "land": {"parcels": [p]}}
}

test_drought_exception_not_for_project_areas if {
	p := {"parcel_id": "N", "area_ha": 1, "land_use": "arable", "codes": ["DIV", "NAT", "OPUBB"], "crop": {"schlagnutzungsart": "Grünbrache"}, "biodiversity": {"drought_early_use": true}}
	"N26-TR-006" in ids(notices_2026.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
	not notices_2026.early_use_exception_2026(p) with input as {"farm": {"year": 2026}}
}

# --- Allgemeine Teilnahmebedingungen ---
test_area_reduction_tolerance if {
	within := {"farm": {"year": 2026, "oepul": {"ubb": {"area_history": {"previous_year_ha": 40, "current_year_ha": 38}}}}}
	not "ATB-ABG-001" in ids(gc.violations) with input as within
	over := {"farm": {"year": 2026, "oepul": {"ubb": {"area_history": {"previous_year_ha": 40, "current_year_ha": 37.9}}}}}
	"ATB-ABG-001" in ids(gc.violations) with input as over
	approx(gc.repayment_area_ha, 2.1) with input as over
	small := {"farm": {"year": 2026, "oepul": {"ubb": {"area_history": {"previous_year_ha": 5, "current_year_ha": 4.5}}}}}
	not "ATB-ABG-001" in ids(gc.violations) with input as small
	large := {"farm": {"year": 2026, "oepul": {"ubb": {"area_history": {"previous_year_ha": 200, "current_year_ha": 194}}}}}
	"ATB-ABG-001" in ids(gc.violations) with input as large
	lost := {"farm": {"year": 2026, "oepul": {"ubb": {"area_history": {"previous_year_ha": 200, "current_year_ha": 180, "loss_of_control_ha": 20}}}}}
	not "ATB-ABG-001" in ids(gc.violations) with input as lost
}

test_area_increase_limit if {
	inp := {"farm": {"year": 2026, "oepul": {"ubb": {"area_history": {"base_2025_ha": 20, "current_year_ha": 31}}}}}
	gc.max_premium_eligible_area_ha == 30 with input as inp
	"ATB-ZUG-001" in ids(gc.violations) with input as inp
	small := {"farm": {"year": 2026, "oepul": {"ubb": {"area_history": {"base_2025_ha": 4, "current_year_ha": 9}}}}}
	gc.max_premium_eligible_area_ha == 9 with input as small
	gc.max_premium_eligible_area_ha == 50 with input as {"farm": {"year": 2025, "oepul": {"ubb": {"area_history": {"base_2025_ha": 20, "current_year_ha": 50}}}}}
}

test_sanction_levels if {
	gc.sanction_reduction_percent(0) == 0 with input as {"farm": {"year": 2026}}
	gc.sanction_reduction_percent(0) == 1 with input as {"farm": {"year": 2027}}
	gc.sanction_reduction_percent(4) == 25 with input as {"farm": {"year": 2026}}
	gc.exclusion_due_to_repeated_full_reduction with input as {"farm": {"year": 2026, "oepul": {"ubb": {"full_reductions_in_contract_period": 2}}}}
}

test_minimum_management_div_exempt if {
	d := {"parcel_id": "D", "area_ha": 1, "land_use": "arable", "codes": ["DIV"], "crop": {"schlagnutzungsart": "Sonstiges Feldfutter"}, "operations": {"use_events": []}}
	not "ATB-MBK-002" in ids(gc.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [d]}}
	g := {"parcel_id": "G", "area_ha": 1, "land_use": "grassland", "crop": {"schlagnutzungsart": "Mähwiese/-weide zwei Nutzungen"}, "operations": {"use_events": [{"date": "2026-06-01", "type": "mulch"}]}}
	"ATB-MBK-002" in ids(gc.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [g]}}
}

test_transfer_without_continuation_needs_op if {
	p := {"parcel_id": "T", "area_ha": 1, "land_use": "arable", "transfer": {"transferred_during_year": true}}
	"ATB-VD-001" in ids(gc.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p]}}
	p2 := object.union(p, {"codes": ["OPUBB"]})
	not "ATB-VD-001" in ids(gc.violations) with input as {"farm": {"year": 2026}, "land": {"parcels": [p2]}}
}

test_payment_deadline if {
	gc.payment_deadline == "2027-06-30" with input as {"farm": {"year": 2026}}
}
