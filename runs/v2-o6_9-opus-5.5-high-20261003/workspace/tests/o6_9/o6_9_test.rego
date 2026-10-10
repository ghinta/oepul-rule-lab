package oepul.o6_9_test

import data.oepul.o6_9

base_parcels := [
	{"parcel_id": "A1", "area_ha": 20, "land_use": "arable", "crop": {"crop_category": "cereal", "crop_name": "Weizen"}, "oepul_measures": ["9", "1A"]},
	{"parcel_id": "A2", "area_ha": 5, "land_use": "arable", "crop": {"crop_category": "legume", "crop_name": "Sojabohne"}},
	{"parcel_id": "G1", "area_ha": 10, "land_use": "grassland", "crop": {"crop_category": "other", "crop_name": "Wiese"}},
	{"parcel_id": "G2", "area_ha": 2, "land_use": "grassland", "crop": {"crop_category": "other", "crop_name": "Wiese"}, "constraints": {"full_fertilization_ban": true}},
]

base_records := [
	{"parcel_ids": ["A1"], "crops": ["Weizen"], "date": "2026-03-10", "manure_type": "slurry", "volume_m3": 400, "technique": "trailing_hose", "land_use": "arable"},
	{"parcel_ids": ["G1"], "crops": ["Wiese"], "date": "2026-04-20", "manure_type": "slurry", "volume_m3": 200, "technique": "trailing_shoe", "land_use": "grassland"},
]

base_input := {
	"farm": {
		"year": 2026,
		"region": {"federal_state": "Oberösterreich", "district": "Wels-Land"},
		"applicant_type": "natural_person",
		"oepul_first_participation_year": 2023,
	},
	"land": {"total_area_ha": 37, "arable_area_ha": 25, "grassland_area_ha": 12, "parcels": base_parcels},
	"livestock": {"species_groups": [
		{"species": "cattle", "category": "cattle_from_2_years", "animal_count": 30, "gve": null},
		{"species": "pigs", "category": "fattening_pig_from_32kg", "animal_count": 100, "annual_average_count": 100, "gve": null},
	]},
	"oepul_measures": {"o6_9": {
		"contract_start_year": 2024,
		"measure_application_date": "2023-12-15",
		"slurry_application": {
			"volumes_m3": {"trailing_hose": 400, "trailing_shoe": 200},
			"quantity_claim_date": "2026-11-20",
			"manure_types": ["slurry"],
			"devices_used": ["trailing_hose", "trailing_shoe"],
			"records": base_records,
		},
		"slurry_separation": {
			"separated_volume_m3": 300,
			"quantity_claim_date": "2026-11-20",
			"mechanical_separation": true,
			"records": [{"date": "2026-05-01", "volume_m3": 300}],
		},
	}},
}

# Flaches Ersetzen (object.union verschmilzt verschachtelte Objekte rekursiv).
shallow_merge(a, b) := object.union(object.remove(a, object.keys(b)), b)

base_measure := base_input.oepul_measures.o6_9

with_measure(patch) := shallow_merge(base_input, {"oepul_measures": {"o6_9": shallow_merge(base_measure, patch)}})

with_app(patch) := with_measure({"slurry_application": shallow_merge(base_measure.slurry_application, patch)})

with_sep(patch) := with_measure({"slurry_separation": shallow_merge(base_measure.slurry_separation, patch)})

rule_ids(vs) := {v.rule_id | some v in vs}

# --- Grundfall -------------------------------------------------------------

test_base_case_eligible if {
	o6_9.eligible with input as base_input
}

test_fertilizable_area_excludes_legume_and_ban if {
	# A1 (20) + G1 (10); Soja und Fläche mit Düngeverbot ausgenommen
	o6_9.fertilizable_area_ha == 30 with input as base_input
}

test_application_premium_2026_rates if {
	p := o6_9.premium with input as base_input
	p.application_by_technique_eur.trailing_hose == 440
	p.application_by_technique_eur.trailing_shoe == 300
	p.application_eur == 740
}

test_application_rates_2023 if {
	o6_9.rate_for("trailing_hose", 2023) == 1.0
	o6_9.rate_for("trailing_shoe", 2023) == 1.4
	o6_9.rate_for("injection", 2023) == 1.6
	o6_9.rate_for("separation", 2023) == 1.4
	o6_9.rate_for("injection", 2025) == 1.7
}

test_pig_feeding_rate_only_from_2025 if {
	o6_9.rate_for("pig_feeding", 2025) == 54.0
	not o6_9.rate_for("pig_feeding", 2024)
}

test_application_cap_50_m3_per_fertilizable_ha if {
	inp := with_app({
		"volumes_m3": {"trailing_hose": 2000, "trailing_shoe": 1000},
		"records": [
			{"parcel_ids": ["A1"], "crops": ["Weizen"], "date": "2026-03-10", "manure_type": "slurry", "volume_m3": 2000, "technique": "trailing_hose"},
			{"parcel_ids": ["G1"], "crops": ["Wiese"], "date": "2026-04-20", "manure_type": "slurry", "volume_m3": 1000, "technique": "trailing_shoe"},
		],
	})
	p := o6_9.premium with input as inp

	# Obergrenze 50 m3 x 30 ha = 1500 m3, proportionale Kürzung auf 50 %
	p.application_cap_m3 == 1500
	p.eligible_application_volume_m3 == 1500
	p.application_by_technique_eur.trailing_hose == 1100
	p.application_by_technique_eur.trailing_shoe == 750
}

test_separation_cap_20_m3_per_cattle_gve if {
	inp := with_sep({
		"separated_volume_m3": 900,
		"records": [{"date": "2026-05-01", "volume_m3": 900}],
	})
	p := o6_9.premium with input as inp

	# 30 Rinder ab 2 Jahre = 30 GVE -> max. 600 m3
	p.separation_cap_m3 == 600
	p.separation_eur == 900
}

test_separation_uses_rinderdatenbank_gve_if_given if {
	inp := with_measure({"cattle_gve_annual_average": 10})
	o6_9.separation_cap_m3 == 200 with input as inp
}

test_separation_excludes_external_cattle_slurry if {
	inp := with_sep({"external_cattle_slurry_m3": 100})
	o6_9.eligible_separation_volume_raw == 200 with input as inp
	"O69-MB-022" in rule_ids(o6_9.violations) with input as inp
}

# --- Mindestteilnahme / Vertrag ---------------------------------------------

test_contract_lapses_without_quantities if {
	inp := with_measure({"slurry_application": {}, "slurry_separation": {}})
	o6_9.contract_lapsed with input as inp
	o6_9.new_measure_application_required_for_next_year with input as inp
	"O69-MB-003" in rule_ids(o6_9.violations) with input as inp
}

test_contract_not_lapsed_with_only_pig_feeding if {
	inp := with_measure({"slurry_application": {}, "slurry_separation": {}, "n_reduced_pig_feeding": {"participates": true}})
	not o6_9.contract_lapsed with input as inp
}

test_late_quantity_claim_not_premium_eligible if {
	inp := with_app({"quantity_claim_date": "2026-12-01"})
	"O69-MB-036" in rule_ids(o6_9.violations) with input as inp
	o6_9.premium.application_eur == 0 with input as inp
}

test_measure_application_deadline if {
	inp := with_measure({"measure_application_date": "2024-01-02"})
	"O69-MB-030" in rule_ids(o6_9.violations) with input as inp
}

test_last_entry_year_2027 if {
	inp := with_measure({"contract_start_year": 2028, "measure_application_date": "2027-12-01"})
	"O69-MB-031" in rule_ids(o6_9.violations) with input as inp
}

test_deregistration_within_year_invalidates if {
	inp := with_measure({"deregistration_date": "2026-06-01"})
	o6_9.deregistered_for_year with input as inp
	"O69-MB-040" in rule_ids(o6_9.violations) with input as inp
	o6_9.contract_period.auto_renewal == false with input as inp
}

test_deregistration_from_next_year_ok if {
	inp := with_measure({"deregistration_date": "2027-01-01"})
	not o6_9.deregistered_for_year with input as inp
}

test_exit_blocked_after_control_announcement if {
	inp := with_measure({"deregistration_date": "2026-06-10", "control_announced_date": "2026-06-01"})
	"O69-GEN-014" in rule_ids(o6_9.violations) with input as inp
}

test_takeover_only_in_single_cases if {
	ok := with_measure({"takeover": {"is_takeover": true, "reason": "farm_division", "animals_and_areas_same_previous_farm": true, "date": "2026-04-10"}})
	not "O69-GEN-018" in rule_ids(o6_9.violations) with input as ok
	bad := with_measure({"takeover": {"is_takeover": true, "reason": "purchase", "animals_and_areas_same_previous_farm": true, "date": "2026-04-10"}})
	"O69-GEN-018" in rule_ids(o6_9.violations) with input as bad
}

test_takeover_deadline_17_april_2028 if {
	o6_9.takeover_deadline(2028) == "2028-04-17"
	o6_9.takeover_deadline(2026) == "2026-04-15"
}

# --- Ausbringungstechnik, Wirtschaftsdünger, Aufzeichnungen ----------------

test_swivel_distributor_not_recognised if {
	inp := with_app({"devices_used": ["swivel_distributor"]})
	"O69-MB-015" in rule_ids(o6_9.violations) with input as inp
}

test_impact_plate_not_recognised if {
	inp := with_app({"devices_used": ["impact_plate_on_nozzle_boom"]})
	"O69-MB-015" in rule_ids(o6_9.violations) with input as inp
}

test_broadcast_record_not_eligible if {
	recs := array.concat(base_records, [{"parcel_ids": ["A1"], "crops": ["Weizen"], "date": "2026-05-01", "manure_type": "slurry", "volume_m3": 10, "technique": "broadcast"}])
	inp := with_app({"records": recs})
	"O69-MB-014" in rule_ids(o6_9.violations) with input as inp
}

test_solid_manure_with_water_not_eligible if {
	inp := with_app({"solid_manure_with_water_volume_m3": 100, "manure_types": ["slurry", "solid_manure"]})
	ids := rule_ids(o6_9.violations) with input as inp
	"O69-MB-011" in ids
	"O69-MB-007" in ids
	o6_9.eligible_application_volume_raw == 500 with input as inp
}

test_biogas_with_cooking_oil_fully_ineligible if {
	inp := with_app({"biogas_slurry": {"volume_m3": 150, "feedstocks": ["farm_manure", "cooking_oil_residues"], "feedstock_proof_available": true}})
	not o6_9.biogas_slurry_eligible with input as inp
	o6_9.ineligible_biogas_volume == 150 with input as inp
	"O69-MB-010" in rule_ids(o6_9.violations) with input as inp
}

test_biogas_defined_feedstocks_eligible_but_needs_proof if {
	inp := with_app({"biogas_slurry": {"volume_m3": 150, "feedstocks": ["farm_manure", "corn_steep_liquor", "molasses"]}})
	o6_9.biogas_slurry_eligible with input as inp
	"O69-MB-020" in rule_ids(o6_9.violations) with input as inp
}

test_records_missing if {
	inp := with_app({"records": []})
	"O69-MB-016" in rule_ids(o6_9.violations) with input as inp
}

test_records_not_chronological if {
	recs := [base_records[1], base_records[0]]
	inp := with_app({"records": recs})
	"O69-MB-016" in rule_ids(o6_9.violations) with input as inp
}

test_aggregated_record_requires_same_crop if {
	recs := [{"parcel_ids": ["A1", "G1"], "crops": ["Weizen", "Wiese"], "date": "2026-03-10", "manure_type": "slurry", "volume_m3": 600, "technique": "trailing_hose"}]
	inp := with_app({"volumes_m3": {"trailing_hose": 600}, "records": recs})
	"O69-MB-017" in rule_ids(o6_9.violations) with input as inp
}

test_aggregated_record_area_must_be_summed if {
	recs := [{"parcel_ids": ["A1", "G1"], "crops": ["Wiese"], "date": "2026-03-10", "manure_type": "slurry", "volume_m3": 600, "technique": "trailing_hose", "area_ha": 20}]
	inp := with_app({"volumes_m3": {"trailing_hose": 600}, "records": recs})
	"O69-MB-017" in rule_ids(o6_9.violations) with input as inp
}

test_claimed_volume_exceeds_records if {
	inp := with_app({"volumes_m3": {"trailing_hose": 500, "trailing_shoe": 200}})
	"O69-GEN-021" in rule_ids(o6_9.violations) with input as inp
}

test_contractor_requires_invoice if {
	inp := with_app({"contractor_used": true})
	"O69-MB-018" in rule_ids(o6_9.violations) with input as inp
}

test_shared_tanker_requires_invoice_to_participants if {
	inp := with_app({"shared_equipment": {"used": true, "available_or_controllable": true, "invoice_issued_to_participants": false}})
	"O69-MB-019" in rule_ids(o6_9.violations) with input as inp
}

test_application_on_non_farm_parcel if {
	recs := [{"parcel_ids": ["X9"], "crops": ["Weizen"], "date": "2026-03-10", "manure_type": "slurry", "volume_m3": 400, "technique": "trailing_hose"}, base_records[1]]
	inp := with_app({"records": recs})
	"O69-MB-013" in rule_ids(o6_9.violations) with input as inp
}

# --- Separation ---------------------------------------------------------------

test_separation_must_be_mechanical if {
	inp := with_sep({"mechanical_separation": false})
	"O69-MB-021" in rule_ids(o6_9.violations) with input as inp
}

test_separation_records_required if {
	inp := with_sep({"records": []})
	"O69-MB-023" in rule_ids(o6_9.violations) with input as inp
}

test_separation_contractor_requires_invoice if {
	inp := with_sep({"contractor_used": true})
	"O69-MB-024" in rule_ids(o6_9.violations) with input as inp
}

# --- Stark stickstoffreduzierte Fütterung von Schweinen ----------------------

pig_ok := {
	"participates": true,
	"start_year": 2026,
	"application_date": "2025-12-20",
	"held_categories": ["piglet_8_32kg", "grower_finisher_32_60kg", "finisher_60_90kg", "finisher_from_90kg", "sow_lactating"],
	"rations": [
		{"animal_category": "piglet_8_32kg", "crude_protein_g_per_kg_88dm": 165, "protein_value_basis": "feed_analysis"},
		{"animal_category": "sow_lactating", "crude_protein_g_per_kg_88dm": 150, "protein_value_basis": "manufacturer_declaration"},
	],
	"fattening_average_crude_protein_g_per_kg_88dm": 156,
	"recipe_evidence_available": true,
}

pig_input(patch) := object.union(base_input, {
	"land": object.union(base_input.land, {"arable_area_ha": 25}),
	"livestock": {"species_groups": [
		{"species": "cattle", "category": "cattle_from_2_years", "animal_count": 30, "gve": null},
		{"species": "pigs", "category": "fattening_pig_from_32kg", "animal_count": 100, "annual_average_count": 100, "gve": null},
	]},
	"oepul_measures": {"o6_9": object.union(base_input.oepul_measures.o6_9, {"n_reduced_pig_feeding": object.union(pig_ok, patch)})},
})

test_pig_gve_threshold_met if {
	# 100 Mastschweine x 0,3 = 30 GVE / 25 ha = 1,2 GVE/ha
	abs(o6_9.pig_gve - 30) < 0.000001 with input as pig_input({})
	o6_9.pig_feeding_access_met with input as pig_input({})
}

test_pig_gve_threshold_not_met if {
	inp := pig_input({"pig_gve_annual_average": 20})
	not o6_9.pig_feeding_access_met with input as inp
	"O69-MB-005" in rule_ids(o6_9.violations) with input as inp
}

test_pig_feeding_premium_54_eur_per_eligible_arable_ha if {
	p := o6_9.premium with input as pig_input({})

	# Ackerfläche lt. Schlägen A1 (20) + A2 (5) = 25 ha
	p.pig_feeding_eur == 1350
}

test_pig_feeding_not_before_2025 if {
	inp := object.union(pig_input({}), {"farm": object.union(base_input.farm, {"year": 2024})})
	"O69-MB-001" in rule_ids(o6_9.violations) with input as inp
	not o6_9.participates_pig_feeding with input as inp
}

test_crude_protein_limit_exceeded if {
	inp := pig_input({"rations": [
		{"animal_category": "piglet_8_32kg", "crude_protein_g_per_kg_88dm": 170, "protein_value_basis": "feed_analysis"},
		{"animal_category": "sow_lactating", "crude_protein_g_per_kg_88dm": 150, "protein_value_basis": "feed_analysis"},
	]})
	"O69-MB-026" in rule_ids(o6_9.violations) with input as inp
	o6_9.premium.pig_feeding_eur == 0 with input as inp
}

test_fattening_phase_feeding_alternative if {
	inp := pig_input({
		"fattening_average_crude_protein_g_per_kg_88dm": 160,
		"rations": array.concat(pig_ok.rations, [
			{"animal_category": "grower_finisher_32_60kg", "crude_protein_g_per_kg_88dm": 170, "protein_value_basis": "feed_analysis"},
			{"animal_category": "finisher_60_90kg", "crude_protein_g_per_kg_88dm": 155, "protein_value_basis": "feed_analysis"},
			{"animal_category": "finisher_from_90kg", "crude_protein_g_per_kg_88dm": 150, "protein_value_basis": "feed_analysis"},
		]),
		"phase_feeding_plausible": true,
	})
	o6_9.fattening_group_compliant with input as inp
	o6_9.uses_phase_feeding with input as inp
	not "O69-MB-027" in rule_ids(o6_9.violations) with input as inp
}

test_fattening_neither_average_nor_phase if {
	inp := pig_input({
		"fattening_average_crude_protein_g_per_kg_88dm": 160,
		"rations": array.concat(pig_ok.rations, [
			{"animal_category": "grower_finisher_32_60kg", "crude_protein_g_per_kg_88dm": 172, "protein_value_basis": "feed_analysis"},
			{"animal_category": "finisher_60_90kg", "crude_protein_g_per_kg_88dm": 155, "protein_value_basis": "feed_analysis"},
			{"animal_category": "finisher_from_90kg", "crude_protein_g_per_kg_88dm": 150, "protein_value_basis": "feed_analysis"},
		]),
	})
	"O69-MB-027" in rule_ids(o6_9.violations) with input as inp
}

test_phase_feeding_requires_plausibility if {
	inp := pig_input({
		"fattening_average_crude_protein_g_per_kg_88dm": 160,
		"rations": array.concat(pig_ok.rations, [
			{"animal_category": "grower_finisher_32_60kg", "crude_protein_g_per_kg_88dm": 170, "protein_value_basis": "feed_analysis"},
			{"animal_category": "finisher_60_90kg", "crude_protein_g_per_kg_88dm": 150, "protein_value_basis": "feed_analysis"},
			{"animal_category": "finisher_from_90kg", "crude_protein_g_per_kg_88dm": 145, "protein_value_basis": "feed_analysis"},
		]),
	})
	"O69-MB-029" in rule_ids(o6_9.violations) with input as inp
}

test_missing_ration_for_held_category if {
	inp := pig_input({"held_categories": array.concat(pig_ok.held_categories, ["boar_from_50kg"])})
	"boar_from_50kg" in o6_9.missing_rations with input as inp
}

test_invalid_protein_basis if {
	inp := pig_input({"rations": [
		{"animal_category": "piglet_8_32kg", "crude_protein_g_per_kg_88dm": 160, "protein_value_basis": "estimate"},
		{"animal_category": "sow_lactating", "crude_protein_g_per_kg_88dm": 150, "protein_value_basis": "feed_analysis"},
	]})
	"O69-MB-028" in rule_ids(o6_9.violations) with input as inp
}

test_pig_feeding_and_gwa_topup_exclusive if {
	inp := object.union(pig_input({}), {"oepul_measures": {"o6_9": {"participates_gwa_n_reduced_feeding_topup": true}}})
	"O69-MB-033" in rule_ids(o6_9.violations) with input as inp
	o6_9.premium.pig_feeding_eur == 0 with input as inp
}

test_pig_feeding_last_entry_2028 if {
	inp := pig_input({"start_year": 2029, "application_date": "2028-12-01"})
	"O69-MB-032" in rule_ids(o6_9.violations) with input as inp
}

test_gestating_sow_limit_125 if {
	o6_9.cp_limit("sow_gestating_or_gilt_mated_from_50kg") == 125
	o6_9.cp_limit("boar_from_50kg") == 170
}

# --- Modulation, Mindestbetrag, Sanktionen ------------------------------------

test_modulation_220_ha if {
	inp := object.union(base_input, {"land": object.union(base_input.land, {"total_area_ha": 220})})
	f := o6_9.modulation_factor with input as inp
	abs(f - (218 / 220)) < 0.000001
}

test_modulation_small_farm_full if {
	o6_9.modulation_factor == 1 with input as base_input
}

test_minimum_payment_warning if {
	inp := with_measure({
		"slurry_application": shallow_merge(base_measure.slurry_application, {
			"volumes_m3": {"trailing_hose": 20},
			"records": [{"parcel_ids": ["A1"], "crops": ["Weizen"], "date": "2026-03-10", "manure_type": "slurry", "volume_m3": 20, "technique": "trailing_hose"}],
		}),
		"slurry_separation": {},
	})
	o6_9.below_minimum_payment with input as inp
	"O69-GEN-024" in rule_ids(o6_9.warnings) with input as inp
}

test_overdeclaration_sanction if {
	o6_9.overdeclaration_payment(1000, 1000) == 1000
	o6_9.overdeclaration_payment(1020, 1000) == 1000
	o6_9.overdeclaration_payment(1100, 1000) == 850
	o6_9.overdeclaration_payment(2000, 500) == 0
}

test_sanction_stage_warning_becomes_one_percent_2027 if {
	o6_9.sanction_percent(1, 2026) == 0
	o6_9.sanction_percent(1, 2027) == 1
	o6_9.sanction_percent(5, 2026) == 25
	o6_9.cumulated_sanction_percent([50, 25, 50]) == 100
}

test_payment_schedule if {
	s := o6_9.payment_schedule with input as base_input
	s.final_payment_by == "2027-06-30"
	s.payments_not_before == "2026-12-01"
}

# --- Allgemeine Bedingungen -----------------------------------------------------

test_public_body_not_eligible if {
	inp := object.union(base_input, {"farm": object.union(base_input.farm, {"applicant_type": "public_body"})})
	"O69-GEN-001" in rule_ids(o6_9.violations) with input as inp
	o6_9.no_valid_contract with input as inp
}

test_legal_person_public_share_over_25 if {
	inp := object.union(base_input, {"farm": object.union(base_input.farm, {"applicant_type": "legal_person", "public_body_share_percent": 30})})
	"O69-GEN-001" in rule_ids(o6_9.violations) with input as inp
}

test_minimum_farm_size_first_year if {
	inp := object.union(base_input, {
		"farm": object.union(base_input.farm, {"oepul_first_participation_year": 2026}),
		"land": object.union(base_input.land, {"total_area_ha": 1.2}),
	})
	"O69-GEN-003" in rule_ids(o6_9.violations) with input as inp
}

test_minimum_farm_size_not_required_later if {
	inp := object.union(base_input, {"land": object.union(base_input.land, {"total_area_ha": 1.2})})
	o6_9.minimum_farm_size_met with input as inp
}

test_combination_conflict_naturschutz if {
	parcels := [object.union(base_parcels[0], {"oepul_measures": ["9", "18"]}), base_parcels[1], base_parcels[2], base_parcels[3]]
	inp := object.union(base_input, {"land": object.union(base_input.land, {"parcels": parcels})})
	"O69-GEN-017" in rule_ids(o6_9.violations) with input as inp
}

test_combination_ubb_allowed if {
	count(o6_9.combination_conflicts) == 0 with input as base_input
}

test_op_coded_parcel_no_pig_premium if {
	parcels := [object.union(base_parcels[0], {"oepul_codes": ["OP"]}), base_parcels[1], base_parcels[2], base_parcels[3]]
	inp := object.union(pig_input({}), {"land": object.union(base_input.land, {"parcels": parcels})})
	o6_9.premium.pig_feeding_eur == 270 with input as inp
}

test_harvest_below_85_percent_excluded if {
	parcels := [object.union(base_parcels[0], {"harvest_share": 0.5}), base_parcels[1], base_parcels[2], base_parcels[3]]
	inp := object.union(pig_input({}), {"land": object.union(base_input.land, {"parcels": parcels})})
	o6_9.premium.pig_feeding_eur == 270 with input as inp
}

test_drought_2026_waives_harvest_obligation if {
	parcels := [
		object.union(base_parcels[0], {"harvest_share": 0, "no_harvestable_crop_due_to_drought": true, "late_summer_or_autumn_harvest_crop": true}),
		base_parcels[1], base_parcels[2], base_parcels[3],
	]
	inp := object.union(pig_input({}), {"land": object.union(base_input.land, {"parcels": parcels})})
	o6_9.premium.pig_feeding_eur == 1350 with input as inp
	"O69-NOT-001" in rule_ids(o6_9.warnings) with input as inp
}

test_drought_styria_extension if {
	o6_9.drought_district_match("Steiermark", "Leibnitz")
	o6_9.drought_district_match("Burgenland", "Oberwart")
	not o6_9.drought_district_match("Tirol", "Innsbruck-Land")
}

test_force_majeure_three_weeks if {
	ok := with_measure({"force_majeure": {"occurred": true, "able_to_notify_date": "2026-06-01", "notified_date": "2026-06-20"}})
	not "O69-GEN-026" in rule_ids(o6_9.violations) with input as ok
	late := with_measure({"force_majeure": {"occurred": true, "able_to_notify_date": "2026-06-01", "notified_date": "2026-06-30"}})
	"O69-GEN-026" in rule_ids(o6_9.violations) with input as late
}

test_controls_refused if {
	inp := with_measure({"controls_refused": true})
	"O69-GEN-028" in rule_ids(o6_9.violations) with input as inp
}

test_napv_ban_period_warning if {
	recs := array.concat(base_records, [{"parcel_ids": ["G1"], "crops": ["Wiese"], "date": "2026-12-05", "manure_type": "slurry", "volume_m3": 0, "technique": "trailing_shoe", "land_use": "grassland"}])
	inp := with_app({"records": recs})
	"O69-NAPV-002" in rule_ids(o6_9.warnings) with input as inp
}

test_napv_arable_early_demand_crop if {
	recs := [{"parcel_ids": ["A1"], "crops": ["Gerste"], "date": "2026-02-05", "manure_type": "slurry", "volume_m3": 400, "technique": "trailing_hose", "land_use": "arable", "napv_early_demand_crop": true}, base_records[1]]
	inp := with_app({"records": recs})
	count(o6_9.napv_ban_conflicts) == 0 with input as inp
}

test_napv_frozen_soil_warning if {
	recs := [object.union(base_records[0], {"soil_state": "frozen"}), base_records[1]]
	inp := with_app({"records": recs})
	"O69-NAPV-003" in rule_ids(o6_9.warnings) with input as inp
}

test_obligations_listed if {
	ids := {o.rule_id | some o in o6_9.obligations} with input as base_input
	"O69-MB-016" in ids
	"O69-MB-023" in ids
	"O69-GEN-027" in ids
}

test_one_year_measure if {
	o6_9.is_one_year_measure
	o6_9.measure_codes.gsp_av_intervention == "70-08"
}

test_categories_by_year if {
	cats := o6_9.measure_categories with input as object.union(base_input, {"farm": object.union(base_input.farm, {"year": 2024})})
	not "n_reduced_pig_feeding" in cats
	"n_reduced_pig_feeding" in o6_9.measure_categories with input as base_input
}

test_area_payment_cap_values if {
	o6_9.area_payment_cap("general", 2023) == 1200.0
	o6_9.area_payment_cap("general", 2026) == 1300.0
}

test_decision_shape if {
	d := o6_9.decision with input as base_input
	d.eligible == true
	d.premium.total_after_modulation_eur == 1190
}

test_no_weekend_extension_for_measure_deadlines if {
	o6_9.deadline_weekend_extension_applies == false
}

test_post_deadline_correction if {
	o6_9.post_deadline_correction_allowed({"increases_premium": false, "still_verifiable": true})
	not o6_9.post_deadline_correction_allowed({"increases_premium": true, "still_verifiable": true})
	not o6_9.post_deadline_correction_allowed({"still_verifiable": true, "after_control_notice_or_finding": true})
}

test_revision_clause if {
	inp := with_measure({"revision_adaptation_refused": true})
	o6_9.revision_clause_contract_ended with input as inp
	o6_9.revision_clause_repayment_for_past == false with input as inp
}

test_multiple_application_deadline if {
	o6_9.multiple_application_deadline(2023) == "2023-04-17"
	o6_9.multiple_application_deadline(2026) == "2026-04-15"
}

test_commitment_whole_year if {
	inp := with_measure({"obligations_fulfilled_whole_year": false})
	"O69-GEN-009" in rule_ids(o6_9.violations) with input as inp
}

test_farm_transfer_recipient if {
	inp := with_measure({"farm_transferred_after_mfa": true, "all_conditions_met_in_transferred_farm": true})
	o6_9.farm_transfer_payment_recipient == "transferor" with input as inp
}

test_deduction_order_starts_with_overdeclaration if {
	startswith(o6_9.deduction_order[0], "Kürzungen und Sanktionen bei Übererklärungen")
	count(o6_9.deduction_order) == 11
}
