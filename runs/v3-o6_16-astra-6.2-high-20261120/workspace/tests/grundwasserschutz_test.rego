package oepul.o6_16_test

import data.oepul.o6_16 as g
import rego.v1

field := {"parcel_id": "S1", "land_use": "arable", "area_ha": 2, "crop": {"crop_name": "Mais"}, "gwa": {"kg_number": "45001", "codes": []}}
parcel(overrides) := object.union(field, {"gwa": object.union(field.gwa, overrides)})

test_contract_and_deadline if {
	g.contract_years(2023) == 6
	g.contract_years(2025) == 4
	not g.contract_years(2026)
	g.entry_timely("schwein", 2028, "2027-12-31")
	not g.entry_timely("schwein", 2028, "2028-01-01")
	not g.entry_timely("wien", 2026, "2025-12-30")
}

test_zone_expansion_and_leading_zero if {
	not g.zone(parcel({"kg_number": "51106"}), 2024)
	g.zone(parcel({"kg_number": "51106"}), 2025)
	g.state(parcel({"kg_number": "01104"}), 2026) == "Wien"
	not g.zone(object.union(field, {"land_use": "grassland"}), 2026)
}

test_entry_threshold if {
	i := {"farm": {"year": 2025, "gwa": {"start_year": 2025, "measures": ["6", "16"]}}, "land": {"parcels": [field]}}
	r := g.auswertung with input as i
	r.betrieb["Mindestfläche_Maßnahme"] == true
	r.betrieb["Begrünungskombination"] == true
	r.schlaege.S1["Grundprämiensatz_EUR_ha"] == 54
	r2 := g.auswertung with input as i with input.land.parcels as [object.union(field, {"area_ha": 1.99})]
	{"regel": "o6_16.einstieg", "schlag": null} in r2.festgestellte_abweichungen
	r3 := g.auswertung with input as i with input.farm.year as 2026 with input.land.parcels as []
	r3.betrieb["Mindestfläche_Maßnahme"] == true
}

test_missing_location_no_false_denial if {
	r := g.auswertung with input as {"farm": {"year": 2025, "gwa": {"start_year": 2025}}, "land": {"parcels": [{"land_use": "arable", "area_ha": 3}]}}
	not "Gebietsacker_ha" in object.keys(r.betrieb)
	count(r.festgestellte_abweichungen) == 0
}

test_cover_exclusive if {
	g.combination_met == false with input.farm.gwa.measures as ["6", "7"]
	g.combination_met == false with input.farm.gwa.measures as []
}

test_nitrogen_thresholds_and_damage if {
	g.carryover(2024, 10, "Wien") == 0
	g.carryover(2024, 20, "übriges Gebiet") == 12
	g.carryover(2025, 20, "übriges Gebiet") == 0
	g.carryover(2025, 30, "Wien") == 24
	g.carryover(2024, 180, "übriges Gebiet") == 108
	g.carryover(2025, 180, "übriges Gebiet") == 60
	g.used_cover_balance(50, 12, 70) == -8
	g.unused_cover_limit(60, 25) == 35
	g.vegetable_deduction(10, 24) == 24
}

test_autumn_exceptions if {
	g.autumn_required(parcel({"previous_balance": 31, "previous_harvest": "2026-09-30"})) with input.farm.year as 2026
	not g.autumn_required(parcel({"previous_balance": 30, "previous_harvest": "2026-09-30"})) with input.farm.year as 2026
	not g.autumn_required(parcel({"previous_crop": "Karotte", "previous_harvest": "2026-10-01"})) with input.farm.year as 2026
	g.autumn_required(parcel({"previous_crop": "Klee", "break_date": "2026-11-14", "previous_harvest": "2026-10-01"})) with input.farm.year as 2026
	not g.autumn_required(parcel({"previous_crop": "Klee", "break_date": "2026-11-15"})) with input.farm.year as 2026
}

test_deadlines_and_sampling if {
	g.samples_required(5) == 1
	g.samples_required(5.03) == 2
	g.vienna_samples_required(5.03) == 4
	g.record_timely("2024-02-20", "2024-03-05")
	not g.record_timely("2024-02-20", "2024-03-06")
	g.planning_dates(2024).plan_due == "2024-02-28"
}

test_person_bound_training if {
	c := {"person_id": "P", "purpose": "Basis", "role": "förderwerbende Person", "hours": 10, "date": "2022-01-01", "accredited": true, "subject_eligible": true, "credited_once": true, "left_on": null}
	g.training_hours("Basis", "P") == 10 with input.farm.gwa.courses as [c]
	g.training_hours("Basis", "P") == 0 with input.farm.gwa.courses as [object.union(c, {"left_on": "2026-11-30"})]
}

test_ooe_windows if {
	g.closed_period(field, "2026-03-21") with input.farm.year as 2026
	not g.closed_period(field, "2026-03-22") with input.farm.year as 2026
	g.closed_period(field, "2026-10-15") with input.farm.year as 2026
	not g.closed_period(object.union(field, {"crop": {"crop_name": "Klee"}}), "2026-01-10") with input.farm.year as 2026
	not g.split_required(field, 80, false) with input.farm.year as 2026
	g.split_required(field, 81, false) with input.farm.year as 2026
	not g.split_required(field, 81, true) with input.farm.year as 2026
}

test_sudangras_and_bentazon if {
	p := object.union(parcel({"applied_substances": ["Bentazon", "Terbuthylazin"], "bentazon_readmitted": false, "protection_or_conservation_zone": false}), {"crop": {"crop_name": "Sudangras"}})
	g.banned_substances(p) == {"Terbuthylazin"} with input.farm.year as 2026
	g.psm_rate(p) == 21.6 with input.farm.year as 2026 with input.farm.gwa.measures as ["7"]
	not g.psm_rate(p) with input.farm.year as 2026 with input.farm.gwa.measures as ["1B", "7"]
	g.psm_code(2025, true, true) == "PSMCS"
	g.psm_code(2026, true, true) == null
}

test_ag_thresholds if {
	p := parcel({"codes": ["AG", "DIV"], "soil_score": 40, "grassland_2020": false, "gloez4": false, "gloez8": true})
	not g.ag_site(p) with input.farm.year as 2024
	g.ag_site(p) with input.farm.year as 2025
	not g.base_rate(p) with input.farm.year as 2025 with input.farm.gwa.measures as ["6"]
	g.ag_amount(4, 10, 2025) == 1080
	g.education_amount(12, 2024) == 600
	g.ag_earliest_plough(2025) == "2026-09-15"
}

test_cultan_external_invoice if {
	e := {"date": "2026-04-01", "amount": 15, "fertilizer": "Ammoniumlösung", "spike_wheel_injection": true, "ammonium_depot": true, "external_equipment": true, "service_evidence": true}
	g.cultan_application(parcel({"codes": ["CUL"], "cultan_events": [e]})) with input.farm.year as 2026
	not g.cultan_application(parcel({"codes": ["CUL"], "cultan_events": [object.union(e, {"service_evidence": false})]})) with input.farm.year as 2026
}

test_pig_density_and_protein if {
	groups := [{"species": "pigs", "category": "Zucht- und Jungsauen ab 50 kg Lebendgewicht", "annual_mean_at": 4}]
	g.pig_density_met with input.land.arable_area_ha as 2 with input.livestock.species_groups as groups
	g.pig_density_met == false with input.land.arable_area_ha as 2.01 with input.livestock.species_groups as groups
	g.protein_met("Mast 32–60 kg", "phase", 170)
	not g.protein_met("Mast ab 90 kg", "phase", 151)
	g.protein_met("Mast ab 90 kg", "average", 157)
}

test_full_matrix_and_terms if {
	g.matrix_cell("16", "1B") == "a"
	g.matrix_cell("16", "18") == ""
	g.matrix_cell("18", "1A") == "x1)"
	g.cover_variant(1, 2025).min_days == 70
	g.cover_variant(2, 2026).last_sowing == "08-05"
	g.transfer_deadline(2028) == "2028-04-17"
}

test_modulation_caps_tolerances if {
	round(g.modulation_factor(220) * 10000) == 9909
	g.area_cap("allgemein", 2026) == 1300
	g.loss_tolerance(4) == 0.5
	g.loss_tolerance(200) == 5
	g.addition_limit(6) == 5
	g.addition_limit(30) == 15
}

test_2026_harvest_extension if {
	p := parcel({"state": "Steiermark", "district": "Weiz", "no_harvestable_crop_due_to_drought": true, "usual_late_summer_or_autumn_harvest": true, "harvested_and_removed_percent": 0})
	g.harvest_met(p) with input.farm.year as 2026
	not g.harvest_met(p) with input.farm.year as 2025
	not g.harvest_met(parcel({"state": "Steiermark", "district": "Liezen", "no_harvestable_crop_due_to_drought": true, "usual_late_summer_or_autumn_harvest": true})) with input.farm.year as 2026
}

test_sample_provenance_and_deadline if {
	s := {"id": "P1", "arable_sample": true, "farm_id": "AT1", "taken": "2022-01-01", "sent": "2026-12-31", "accredited": true, "method": "EUF", "parameters": ["P", "K", "pH", "Humus", "N nachlieferbar"]}
	g.sample_valid(s) with input.farm.farm_id as "AT1"
	not g.sample_valid(s) with input.farm.farm_id as "AT2"
	not g.sample_valid(object.union(s, {"sent": "2027-01-01"})) with input.farm.farm_id as "AT1"
	not g.sample_valid(object.union(s, {"parameters": ["P", "K", "pH", "N mineralisch"]})) with input.farm.farm_id as "AT1"
}

test_unused_cover_reduction_once if {
	g.unused_cover_credit(50, "übriges Gebiet", 10, true, false) == 40
	g.unused_cover_credit(30, "übriges Gebiet", 10, true, true) == 40
	g.unused_cover_credit(50, "Wien", 10, false, false) == 60
}

test_ag_eligible_area_capped if {
	p := object.union(parcel({"soil_score": 40, "codes": ["AG"], "grassland_2020": false, "gloez4": false}), {"crop": {"crop_name": "Grünbrache"}, "area_ha": 4})
	i := {"farm": {"year": 2026}, "land": {"arable_area_ha": 10, "parcels": [p]}}
	g.betrieb["AG_Tabellenbetrag_vor_weiteren_Kürzungen_EUR"] == 1080 with input as i
	excluded := object.union(p, {"gwa": object.union(p.gwa, {"gloez4": true})})
	g.betrieb["AG_Tabellenbetrag_vor_weiteren_Kürzungen_EUR"] == 0 with input as i with input.land.parcels as [excluded]
}

test_switch_transfer_and_full_loss if {
	g.valid_transfer(10, 5, "2028-04-17", 2028)
	not g.valid_transfer(10, 5.01, "2028-04-17", 2028)
	g.repayable_loss(100, 5) == 0
	g.repayable_loss(100, 5.01) == 5.01
	g.eligible_new_area(2026, 20, 8, 5) == 2
	g.switch_allowed("16-AG", "19", "2025-12-31")
	not g.switch_allowed("16-AG", "19", "2026-01-01")
}

test_drought_still_requires_latest_date_and_duration if {
	g.evergreen_2026_dates_met("2026-09-20", "abfrostend", 42, "2026-09-20", true, true)
	not g.evergreen_2026_dates_met("2026-09-21", "abfrostend", 42, "2026-09-21", true, true)
	not g.evergreen_2026_dates_met("2026-10-15", "überwiegend winterhart", 41, "2026-10-15", true, true)
	not g.cover_emergence_excused(2026, "6", false, true)
}

test_farm_level_and_field_level_distinct if {
	g.access_consequence("mehrjährige Maßnahme", false, false) == "keine Maßnahmenprämie im betroffenen Jahr"
	g.access_consequence("mehrjährige Maßnahme", true, false) == "kein gültiger Vertrag"
	g.lowest_sanction(2026) == "Verwarnung"
	g.lowest_sanction(2027) == 1
	g.exclusion_after_full_reductions([100, 10, 100])
	not g.exclusion_after_full_reductions([100, 50])
}

test_cultan_each_injection_requires_evidence if {
	e := {"date": "2026-04-01", "amount": 15, "fertilizer": "Ammoniumlösung", "spike_wheel_injection": true, "ammonium_depot": true, "external_equipment": true, "service_evidence": true}
	not g.cultan_application(parcel({"codes": ["CUL"], "cultan_events": [e, object.union(e, {"service_evidence": false})]})) with input.farm.year as 2026
}

test_regional_factor_from_kg if {
	g.balance_region(field) == "übriges Gebiet" with input.farm.year as 2026
	g.balance_region(parcel({"kg_number": "01104"})) == "Wien" with input.farm.year as 2026
	not g.balance_region(parcel({"kg_number": "32001"})) with input.farm.year as 2026
}

test_bentazon_unknown if {
	p := parcel({"applied_substances": ["Bentazon"]})
	not g.banned_substances(p) with input.farm.year as 2026
}

test_known_ban_remains_visible_with_open_bentazon_status if {
	p := parcel({"applied_substances": ["Bentazon", "Metazachlor"]})
	g.banned_substances(p) == {"Metazachlor"} with input.farm.year as 2026
}

test_div_exceptions_do_not_cancel_ag_rules if {
	g.div_early_code_required(2026, "Beweidung", "2026-07-31", false)
	not g.div_early_code_required(2026, "Mahd", "2026-07-31", false)
	g.div_early_code_required(2026, "Mahd", "2026-07-31", true)
	not g.div_early_code_required(2026, "Mahd", "2026-08-01", true)
	g.div_third_use_code(2026, 3)
	g.ag_other_payment_permitted("1B", "Landschaftselement")
	not g.ag_other_payment_permitted("1B", "Basisprämie")
}
