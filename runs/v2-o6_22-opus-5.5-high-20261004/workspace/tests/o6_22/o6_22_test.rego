package oepul.o6_22_test

import data.oepul.o6_22

# ---------------------------------------------------------------------------
# Referenzbetrieb
# ---------------------------------------------------------------------------

test_base_farm_compliant if {
	count(violation_ids(base_input)) == 0
	o6_22.compliant with input as base_input
}

test_base_participating_gve if {
	o6_22.participating_gve == 54 with input as base_input
	o6_22.category_gve.mastschweine == 30 with input as base_input
	o6_22.category_gve.ferkel == 14 with input as base_input
	o6_22.category_gve.zuchtsauen == 10 with input as base_input
}

test_base_premium_2025 if {
	# 30*70,2 + 14*194,4 + 10*86,4 + 30*64,8 (unkupiert) + 54*64,8 (GVO) + 54*21,6 (Festmist)
	o6_22.premium_before_modulation == 12301.2 with input as base_input
	o6_22.premium_after_modulation == 12301.2 with input as base_input
}

test_decision_object if {
	d := o6_22.decision with input as base_input
	d.measure == "o6_22"
	d.intervention == "70-19"
	d.min_participation_met == true
	d.animal_health_service_required == true
	d.measure_payable == true
}

# ---------------------------------------------------------------------------
# Kategorien, GVE-Schlüssel, Zuordnung
# ---------------------------------------------------------------------------

test_gve_key_complete if {
	count(data.o6_22.categories.tierliste_categories) == 10
	o6_22.tierliste_category("ferkel_20_32").gve_per_head == 0.07
	o6_22.tierliste_category("jungsauen_nicht_gedeckt_ab_50").measure_category == "mastschweine"
	o6_22.tierliste_category("jungsauen_gedeckt_ab_50").gve_per_head == 0.5
}

test_zuchteber_not_eligible if {
	inp := patched([{"op": "replace", "path": "/livestock/species_groups/0/pig_tierliste_category", "value": "zuchteber_ab_50"}])
	o6_22.category_gve.mastschweine == 0 with input as inp
	"mastschweine" in o6_22.lapsed_categories with input as inp
}

test_boar_classification if {
	o6_22.boar_measure_category(40, true) == "mastschweine"
	o6_22.boar_measure_category(90, false) == "mastschweine"
	o6_22.boar_measure_category(90, true) == "nicht_praemienfaehig"
}

test_gilt_classification if {
	o6_22.gilt_or_culled_measure_category(60, false, false) == "mastschweine"
	o6_22.gilt_or_culled_measure_category(60, true, false) == "zuchtsauen"
	o6_22.gilt_or_culled_measure_category(150, true, true) == "mastschweine"
}

# ---------------------------------------------------------------------------
# Mindestteilnahme, Vertragslage, Beantragung
# ---------------------------------------------------------------------------

test_min_participation_not_met if {
	inp := patched([
		{"op": "replace", "path": "/livestock/species_groups", "value": [object.union(base_input.livestock.species_groups[0], {"average_animal_count": 6, "animal_count": 6})]},
		{"op": "replace", "path": "/farm/oepul_measures/o6_22/applications", "value": [base_input.farm.oepul_measures.o6_22.applications[1]]},
	])
	o6_22.participating_gve == 1.8 with input as inp
	"O622-ELIG-001" in violation_ids(inp)
	o6_22.premium_before_modulation == 0 with input as inp
}

test_min_participation_exactly_two if {
	o6_22.min_participation_met with input as patched([
		{"op": "replace", "path": "/livestock/species_groups", "value": [object.union(base_input.livestock.species_groups[2], {"average_animal_count": 4, "animal_count": 4})]},
		{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/pens/0/sow_counts/zuchtsau", "value": 4},
	])
}

test_stichtag_used_without_average_list if {
	inp := patched([
		{"op": "replace", "path": "/farm/mfa/uses_average_animal_list", "value": false},
		{"op": "replace", "path": "/farm/mfa/stock_fluctuates", "value": false},
		{"op": "replace", "path": "/livestock/species_groups/0/animal_count", "value": 80},
	])
	o6_22.category_gve.mastschweine == 24 with input as inp
}

test_application_too_late if {
	inp := patched([{"op": "replace", "path": "/farm/oepul_measures/o6_22/applications/1/applied_on", "value": "2025-01-05"}])
	"O622-APP-001" in violation_ids(inp)
	not "mastschweine" in o6_22.active_categories with input as inp
}

test_last_entry_years if {
	inp := patched([
		{"op": "add", "path": "/farm/oepul_measures/o6_22/applications/-", "value": {"code": "unkupiert_ferkel", "applied_on": "2028-11-01", "first_year": 2029, "withdrawn_on": null}},
		{"op": "replace", "path": "/farm/oepul_measures/o6_22/applications/1/first_year", "value": 2028},
		{"op": "replace", "path": "/farm/oepul_measures/o6_22/applications/1/applied_on", "value": "2027-12-01"},
	])
	ids := violation_ids(inp)
	"O622-APP-002" in ids
	"O622-APP-003" in ids
}

test_unkupiert_for_sows_not_available if {
	inp := patched([{"op": "add", "path": "/farm/oepul_measures/o6_22/applications/-", "value": {"code": "unkupiert_zuchtsauen", "applied_on": "2024-12-01", "first_year": 2025, "withdrawn_on": null}}])
	"O622-APP-008" in violation_ids(inp)
}

test_withdrawal_during_year_invalidates_category if {
	inp := patched([{"op": "replace", "path": "/farm/oepul_measures/o6_22/applications/0/withdrawn_on", "value": "2025-06-30"}])
	not "ferkel" in o6_22.active_categories with input as inp
	o6_22.participating_gve == 40 with input as inp
}

test_withdrawal_after_year_keeps_category if {
	inp := patched([{"op": "replace", "path": "/farm/oepul_measures/o6_22/applications/0/withdrawn_on", "value": "2026-01-02"}])
	"ferkel" in o6_22.active_categories with input as inp
}

test_category_without_animals_lapses if {
	inp := patched([{"op": "replace", "path": "/livestock/species_groups/1/deregistered_average_count", "value": 200}])
	"ferkel" in o6_22.lapsed_categories with input as inp
	not o6_22.base_premium.ferkel with input as inp
}

# ---------------------------------------------------------------------------
# Tiergesundheitsdienst
# ---------------------------------------------------------------------------

test_tgd_missing if {
	inp := patched([{"op": "replace", "path": "/livestock/pig_farm/animal_health_service/participation_from", "value": "2025-02-01"}])
	"O622-TGD-001" in violation_ids(inp)
}

test_tgd_2023_from_april_15_sufficient if {
	o6_22.animal_health_service_ok with input as patched([
		{"op": "replace", "path": "/farm/year", "value": 2023},
		{"op": "replace", "path": "/livestock/pig_farm/animal_health_service/participation_from", "value": "2023-04-15"},
		{"op": "replace", "path": "/livestock/pig_farm/animal_health_service/participation_to", "value": "2023-12-31"},
	])
}

test_tgd_not_required_up_to_10_gve if {
	inp := patched([
		{"op": "replace", "path": "/livestock/species_groups", "value": [base_input.livestock.species_groups[2]]},
		{"op": "replace", "path": "/livestock/pig_farm/animal_health_service/participates", "value": false},
	])
	not o6_22.animal_health_service_required with input as inp
	not "O622-TGD-001" in violation_ids(inp)
}

# ---------------------------------------------------------------------------
# Platzangebot und Liegefläche (Beispiele des Informationsblatts)
# ---------------------------------------------------------------------------

test_example_25_pigs_over_85kg if {
	pen := {"animal_count": 25, "average_weight_kg": 90}
	o6_22.required_total_area_fattening(pen) == 27.5
	o6_22.required_littered_lying_area_fattening(pen) == 11
}

test_example_occupancy_plan_15m2 if {
	o6_22.max_animals_in_pen(15, 40) == 21
	o6_22.max_animals_in_pen(15, 70) == 16
	o6_22.max_animals_in_pen(15, 100) == 13
}

test_weight_class_boundaries if {
	o6_22.weight_class(20).weight_class == "bis_20"
	o6_22.weight_class(20.5).weight_class == "bis_32"
	o6_22.weight_class(85).weight_class == "bis_85"
	o6_22.weight_class(85.1).weight_class == "ab_85"
}

test_space_violation if {
	"O622-SPACE-002" in violation_ids(patched([{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/pens/0/usable_total_area_m2", "value": 27}]))
}

test_closed_outdoor_run_not_counted if {
	inp := patched([
		{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/pens/0/usable_total_area_m2", "value": 32},
		{"op": "add", "path": "/livestock/species_groups/0/housing/stall/pens/0/outdoor_run_area_m2", "value": 6},
		{"op": "add", "path": "/livestock/species_groups/0/housing/stall/pens/0/outdoor_run_permanent_access", "value": false},
	])
	"O622-SPACE-002" in violation_ids(inp)
}

test_littered_lying_area_violation if {
	"O622-SPACE-001" in violation_ids(patched([{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/pens/0/littered_lying_area_m2", "value": 10.9}]))
}

test_perforation_limit if {
	"O622-LIE-001" in violation_ids(patched([{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/pens/0/lying_area_perforation_percent", "value": 6}]))
	not "O622-LIE-001" in violation_ids(patched([{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/pens/0/lying_area_perforation_percent", "value": 5}]))
}

test_sow_space if {
	pen := {"sow_counts": {"zuchtsau": 2, "gedeckte_jungsau": 2}}
	o6_22.required_total_area_sows(pen) == 10
	o6_22.required_lying_area_sows(pen) == 4.5
	"O622-SPACE-005" in violation_ids(patched([{"op": "replace", "path": "/livestock/species_groups/2/housing/stall/pens/0/littered_lying_area_m2", "value": 25}]))
}

test_exempt_sow_pen_not_checked if {
	ids := violation_ids(base_input)
	not "O622-GRP-001" in ids
	not "O622-LIE-001" in ids
}

test_enrichment_required if {
	"O622-ENR-001" in violation_ids(patched([{"op": "replace", "path": "/livestock/species_groups/1/housing/stall/pens/0/enrichment_permanently_available", "value": false}]))
	"O622-ENR-001" in violation_ids(patched([{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/pens/0/minimal_bedding", "value": true}]))
}

test_group_housing_required if {
	"O622-GRP-001" in violation_ids(patched([{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/pens/0/group_housed", "value": false}]))
}

test_stall_definition if {
	"O622-STALL-001" in violation_ids(patched([{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/structure/paved_floor", "value": false}]))
	"O622-STALL-002" in violation_ids(patched([{"op": "replace", "path": "/livestock/species_groups/2/housing/stall/structure/seepage_to_collection_pit", "value": false}]))
}

# ---------------------------------------------------------------------------
# Gruppenhaltung Sauen, Einzeltierhaltung, bestehende Stallungen
# ---------------------------------------------------------------------------

test_sow_group_housing_new_stall if {
	sgh := {"stall_built_or_rebuilt_since_2013": true, "sufficient_group_space_without_construction": false}
	o6_22.sow_group_housing_required(sgh, 10, 30)
	not o6_22.sow_group_housing_required(sgh, 9, 30) with input as base_input
	not o6_22.sow_group_housing_required(sgh, 40, 4) with input as base_input
}

test_sow_transitional_rule if {
	sgh := {"stall_built_or_rebuilt_since_2013": false, "sufficient_group_space_without_construction": false}
	o6_22.required_group_start_days_after_mating(sgh) == 28 with input as base_input
	o6_22.required_group_end_days_before_farrowing(sgh) == 7 with input as base_input
	sgh_ok := object.union(sgh, {"sufficient_group_space_without_construction": true})
	o6_22.required_group_start_days_after_mating(sgh_ok) == 10 with input as base_input
	o6_22.required_group_start_days_after_mating(sgh) == 10 with input as patched([{"op": "replace", "path": "/farm/year", "value": 2034}])
}

test_sow_group_housing_violation if {
	"O622-GRP-006" in violation_ids(patched([{"op": "replace", "path": "/livestock/species_groups/2/housing/sow_group_housing/group_from_day_after_mating", "value": 20}]))
	not "O622-GRP-006" in violation_ids(patched([
		{"op": "replace", "path": "/livestock/species_groups/2/housing/sow_group_housing/group_from_day_after_mating", "value": 20},
		{"op": "replace", "path": "/livestock/species_groups/2/housing/sow_group_housing/stall_built_or_rebuilt_since_2013", "value": false},
		{"op": "replace", "path": "/livestock/species_groups/2/housing/sow_group_housing/sufficient_group_space_without_construction", "value": false},
	]))
}

test_single_housing_rules if {
	long := patched([{"op": "replace", "path": "/livestock/species_groups/0/pig_welfare/single_housing_events", "value": [{"days": 12, "health_reason": true, "littered": true, "documented": true, "deregistered": false}]}])
	"O622-GRP-003" in violation_ids(long)
	short_ok := patched([{"op": "replace", "path": "/livestock/species_groups/0/pig_welfare/single_housing_events", "value": [{"days": 10, "health_reason": true, "littered": true, "documented": true, "deregistered": false}]}])
	count(violation_ids(short_ok)) == 0
	no_reason := patched([{"op": "replace", "path": "/livestock/species_groups/0/pig_welfare/single_housing_events", "value": [{"days": 5, "health_reason": false, "littered": true, "documented": false, "deregistered": false}]}])
	"O622-GRP-002" in violation_ids(no_reason)
	"O622-GRP-004" in violation_ids(no_reason)
}

test_existing_stall_partial_participation if {
	missing := patched([{"op": "replace", "path": "/livestock/species_groups/0/pig_welfare/non_compliant_average_count", "value": 24}])
	"O622-ALL-002" in violation_ids(missing)
	ok := patched([
		{"op": "replace", "path": "/livestock/species_groups/0/pig_welfare/non_compliant_average_count", "value": 24},
		{"op": "replace", "path": "/livestock/species_groups/0/deregistered_average_count", "value": 24},
	])
	not "O622-ALL-002" in violation_ids(ok)
	o6_22.category_gve.mastschweine == 22.8 with input as ok
}

test_not_continuously_compliant_whole_group if {
	"O622-ALL-002" in violation_ids(patched([{"op": "replace", "path": "/livestock/species_groups/0/pig_welfare/continuous_compliance_from_eligible_weight", "value": false}]))
}

# ---------------------------------------------------------------------------
# Freilandhaltung
# ---------------------------------------------------------------------------

test_free_range_example_rotational_3_gve_per_ha if {
	inp := with_free_range(compliant_free_range)
	o6_22.free_range_stocking_gve_per_ha(inp.livestock.species_groups[3]) == 3 with input as inp
	count(violation_ids(inp)) == 0
}

test_free_range_overstocked if {
	inp := with_free_range(object.union(compliant_free_range, {"rotational_paddocks": false}))
	"O622-FREE-001" in violation_ids(inp)
}

test_free_range_water_permit_limit if {
	inp := with_free_range(object.union(compliant_free_range, {"water_permit_max_gve_per_ha": 2}))
	"O622-FREE-001" in violation_ids(inp)
}

test_free_range_max_one_year if {
	"O622-FREE-002" in violation_ids(with_free_range(object.union(compliant_free_range, {"continuous_use_months": 13})))
}

test_free_range_flags if {
	ids := violation_ids(with_free_range(object.union(compliant_free_range, {"double_fence_or_solid_enclosure": false, "feeding_place_roofed": false, "records_complete": false})))
	"O622-FREE-003" in ids
	"O622-FREE-004" in ids
	"O622-FREE-008" in ids
}

test_wild_boar_not_eligible if {
	inp := patched([
		{"op": "add", "path": "/livestock/species_groups/-", "value": object.union(free_range_group(compliant_free_range), {"pig_welfare": {"is_wild_boar": true}})},
	])
	"O622-FREE-009" in violation_ids(inp)
	o6_22.category_gve.mastschweine == 30 with input as inp
}

test_free_range_parcel_land_use if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/0/pig_free_range_run", "value": true},
	])
	"O622-FREE-010" in violation_ids(inp)
	not "O622-FREE-010" in violation_ids(patched([
		{"op": "replace", "path": "/land/parcels/0/pig_free_range_run", "value": true},
		{"op": "replace", "path": "/land/parcels/0/mfa_land_use_type", "value": "Sonstige Ackerflächen"},
	]))
}

# ---------------------------------------------------------------------------
# Zuschläge
# ---------------------------------------------------------------------------

test_unkupiert_docked_animals if {
	"O622-UNK-001" in violation_ids(patched([{"op": "replace", "path": "/livestock/species_groups/0/pig_welfare/participating_animals_all_undocked_full_year", "value": false}]))
}

test_protein_feed_definition if {
	o6_22.is_protein_feed({"type": "compound", "crude_protein_percent_dm": 22})
	not o6_22.is_protein_feed({"type": "compound", "crude_protein_percent_dm": 20})
	not o6_22.is_protein_feed({"type": "single_component", "typical_crude_protein_percent_dm": 21, "is_roughage": true})
}

test_gvo_non_compliant_feed if {
	inp := patched([{"op": "add", "path": "/livestock/pig_farm/protein_feed/feeds/-", "value": {"name": "GVO-Soja Legehennen", "type": "single_component", "typical_crude_protein_percent_dm": 46, "gmo_free": false, "origin_continent": "south_america", "produced_on_farm": false, "proof_documents_available": true}}])
	"O622-GVO-001" in violation_ids(inp)
}

test_gvo_missing_proof if {
	"O622-GVO-004" in violation_ids(patched([{"op": "replace", "path": "/livestock/pig_farm/protein_feed/feeds/0/proof_documents_available", "value": false}]))
}

test_gvo_stored_rest if {
	"O622-GVO-002" in violation_ids(patched([{"op": "replace", "path": "/livestock/pig_farm/protein_feed/non_compliant_protein_feed_stored_or_fed", "value": true}]))
}

test_festmist_interval_too_short if {
	"O622-FMK-003" in violation_ids(patched([{"op": "replace", "path": "/livestock/pig_farm/manure_composting/heaps/0/turn_dates", "value": ["2025-05-01", "2025-05-10"]}]))
}

test_festmist_front_loader if {
	"O622-FMK-003" in violation_ids(patched([{"op": "replace", "path": "/livestock/pig_farm/manure_composting/heaps/0/turning_device", "value": "front_loader"}]))
}

test_festmist_mixed_heap_without_turning if {
	heap := {"heap_id": "M2", "turn_dates": [], "mixed_with_plant_material": true, "plant_material_noteworthy_share": true, "composting_procedure_applied": true, "straw_rich_manure_only": false}
	count(violation_ids(patched([{"op": "replace", "path": "/livestock/pig_farm/manure_composting/heaps", "value": [heap]}]))) == 0
	"O622-FMK-003" in violation_ids(patched([{"op": "replace", "path": "/livestock/pig_farm/manure_composting/heaps", "value": [object.union(heap, {"straw_rich_manure_only": true})]}]))
}

test_festmist_compost_barn if {
	"O622-FMK-010" in violation_ids(patched([{"op": "replace", "path": "/livestock/pig_farm/manure_composting/is_compost_barn", "value": true}]))
}

test_festmist_not_before_2025 if {
	inp := patched([
		{"op": "replace", "path": "/farm/oepul_measures/o6_22/applications/5/first_year", "value": 2024},
		{"op": "replace", "path": "/farm/oepul_measures/o6_22/applications/5/applied_on", "value": "2023-12-01"},
	])
	"O622-FMK-001" in violation_ids(inp)
}

test_festmist_napv_unpaved if {
	inp := patched([
		{"op": "replace", "path": "/livestock/pig_farm/manure_composting/heaps_on_unpaved_ground", "value": true},
		{"op": "add", "path": "/livestock/pig_farm/manure_composting/napv", "value": {"distance_to_surface_water_m": 30, "flat_non_sandy_ground": true, "no_runoff_risk_to_surface_water": true, "not_waterlogged_soil": true, "groundwater_distance_m": 2, "heap_covered": false}},
	])
	"O622-FMK-009" in violation_ids(inp)
}

# ---------------------------------------------------------------------------
# Melde- und Dokumentationspflichten
# ---------------------------------------------------------------------------

test_tierliste_deadline if {
	"O622-APP-005" in violation_ids(patched([{"op": "replace", "path": "/farm/mfa/tierliste_submitted_on", "value": "2025-04-16"}]))
}

test_average_list_required if {
	"O622-APP-004" in violation_ids(patched([{"op": "replace", "path": "/farm/mfa/uses_average_animal_list", "value": false}]))
}

test_average_list_correction if {
	late := patched([
		{"op": "add", "path": "/farm/mfa/payment_notice_received_on", "value": "2026-01-15"},
		{"op": "replace", "path": "/farm/mfa/average_list_corrections", "value": [{"corrected_on": "2026-02-20", "reason": "verkauf", "proofs_uploaded": false, "proof_fields": ["anzahl"]}]},
	])
	ids := violation_ids(late)
	"O622-APP-004" in ids
	"O622-REP-006" in ids
	w := {x.message | some x in o6_22.warnings with input as late}
	count(w) == 2
}

test_stall_sketch_until_2024 if {
	inp_2024 := patched([{"op": "replace", "path": "/farm/year", "value": 2024}])
	"O622-DOC-001" in violation_ids(inp_2024)
	not "O622-DOC-001" in violation_ids(base_input)
}

test_vis_reporting if {
	"O622-REP-004" in violation_ids(patched([{"op": "replace", "path": "/livestock/pig_farm/vis_reports_complete", "value": false}]))
}

# ---------------------------------------------------------------------------
# Allgemeine Teilnahmebedingungen
# ---------------------------------------------------------------------------

test_applicant_public_authority if {
	"O622-GEN-002" in violation_ids(patched([{"op": "replace", "path": "/farm/applicant/type", "value": "territorial_authority"}]))
	"O622-GEN-002" in violation_ids(patched([
		{"op": "replace", "path": "/farm/applicant/type", "value": "legal_person"},
		{"op": "replace", "path": "/farm/applicant/public_authority_share_percent", "value": 30},
	]))
	not "O622-GEN-002" in violation_ids(patched([
		{"op": "replace", "path": "/farm/applicant/type", "value": "legal_person"},
		{"op": "replace", "path": "/farm/applicant/public_authority_share_percent", "value": 25},
	]))
}

test_takeover_rules if {
	"O622-GEN-006" in violation_ids(patched([{"op": "replace", "path": "/farm/oepul_measures/o6_22/takeover", "value": {"is_takeover": true, "reason": "pacht", "animals_and_areas_from_same_predecessor": true}}]))
	not "O622-GEN-006" in violation_ids(patched([{"op": "replace", "path": "/farm/oepul_measures/o6_22/takeover", "value": {"is_takeover": true, "reason": "betriebsteilung", "animals_and_areas_from_same_predecessor": true}}]))
}

test_animals_abroad_not_eligible if {
	inp := patched([{"op": "replace", "path": "/livestock/species_groups/1/pig_welfare/kept_in_austria", "value": false}])
	"O622-GEN-001" in violation_ids(inp)
	o6_22.category_gve.ferkel == 0 with input as inp
}

test_farm_min_size_first_year if {
	inp := patched([
		{"op": "replace", "path": "/farm/first_oepul_participation_year", "value": 2025},
		{"op": "replace", "path": "/land/total_area_ha", "value": 1.2},
	])
	"O622-GEN-004" in violation_ids(inp)
	o6_22.premium_before_modulation == 0 with input as inp
}

# ---------------------------------------------------------------------------
# Prämie, Modulation, Sanktionen
# ---------------------------------------------------------------------------

test_rates_2023 if {
	o6_22.base_rate("ferkel", 2023) == 180
	o6_22.base_rate("ferkel", 2026) == 194.4
	o6_22.surcharge_rate("unkupiert", "ferkel", 2023) == 250
	o6_22.surcharge_rate("unkupiert", "mastschweine", 2024) == 64.8
	not o6_22.surcharge_rate("festmistkompostierung", "zuchtsauen", 2024)
	o6_22.surcharge_rate("festmistkompostierung", "zuchtsauen", 2025) == 21.6
}

test_deregistered_animals_reduce_premium if {
	inp := patched([{"op": "replace", "path": "/livestock/species_groups/0/deregistered_average_count", "value": 24}])
	o6_22.category_gve.mastschweine == 22.8 with input as inp
	o6_22.base_premium.mastschweine == 1600.56 with input as inp
}

test_modulation_examples if {
	o6_22.modulation_factor(220) == 0.9909
	o6_22.modulation_factor(230) == 0.9870
	o6_22.modulation_factor(150) == 1
	o6_22.modulation_factor(1500) == 0.84
	o6_22.modulation_factor(0) == 1
}

test_premium_after_modulation_220ha if {
	inp := patched([{"op": "replace", "path": "/land/total_area_ha", "value": 220}])
	o6_22.premium_after_modulation == 12189.26 with input as inp
}

test_minimum_payment if {
	inp := patched([
		{"op": "replace", "path": "/livestock/species_groups", "value": [object.union(base_input.livestock.species_groups[0], {"average_animal_count": 7, "animal_count": 7})]},
		{"op": "replace", "path": "/livestock/species_groups/0/housing/stall/pens/0/animal_count", "value": 7},
		{"op": "replace", "path": "/farm/oepul_measures/o6_22/applications", "value": [base_input.farm.oepul_measures.o6_22.applications[1]]},
	])
	o6_22.premium_after_modulation == 147.42 with input as inp
	not o6_22.below_minimum_payment with input as inp
	o6_22.below_minimum_payment with input as patched([{"op": "replace", "path": "/farm/oepul_measures/o6_22/applications", "value": []}])
}

test_sanction_levels if {
	o6_22.sanction_percent(1, 2026) == 0
	o6_22.sanction_percent(1, 2027) == 1
	o6_22.sanction_percent(4, 2027) == 10
	o6_22.cumulated_sanction_percent([3, 6], 2025) == 55
	o6_22.cumulated_sanction_percent([7, 6], 2025) == 100
	o6_22.escalated_level(3, 2) == 5
	o6_22.escalated_level(6, 3) == 7
	o6_22.premium_after_sanction(1000, 25) == 750
	o6_22.exclusion_after_two_full_reductions(2)
	not o6_22.exclusion_after_two_full_reductions(1)
}

test_overdeclaration if {
	o6_22.overdeclaration_adjusted_premium(1000, 980) == 980
	o6_22.overdeclaration_adjusted_premium(1000, 900) == 750
	o6_22.overdeclaration_adjusted_premium(1000, 300) == 0
}

test_procedural_deadlines if {
	o6_22.payment_deadline(2025) == "2026-06-30"
	o6_22.max_advance_payment(1000) == 750
	o6_22.force_majeure_notification_in_time("2025-07-01", "2025-07-22")
	not o6_22.force_majeure_notification_in_time("2025-07-01", "2025-07-23")
	o6_22.natural_circumstance_notification_in_time("2025-03-01", "2025-03-20")
	o6_22.document_retention_until(2025) == "2029-12-31"
}
