package oepul.o6_16_test

import data.oepul.o6_16

# --- Weiterbildung und Gewässerschutzkonzept ---
test_training_hours_insufficient if {
	inp := object.union(base_input, {"documentation": {"o6_16": {"training": {"courses": [{"date": "2023-02-01", "hours": 8, "provider_recognized": true}]}}}})
	"O616-TRN-001" in rule_ids(o6_16.obligation_violations) with input as inp
}

test_training_before_2022_not_creditable if {
	inp := object.union(base_input, {"documentation": {"o6_16": {"training": {"courses": [
		{"date": "2021-11-01", "hours": 6, "provider_recognized": true},
		{"date": "2023-02-01", "hours": 4, "provider_recognized": true},
	]}}}})
	o6_16.creditable_training_hours == 4 with input as inp
	"O616-TRN-001" in rule_ids(o6_16.obligation_violations) with input as inp
}

test_training_double_counting_not_creditable if {
	inp := object.union(base_input, {"documentation": {"o6_16": {"training": {"courses": [{"date": "2023-02-01", "hours": 10, "provider_recognized": true, "counted_for_other_commitment": true}]}}}})
	o6_16.creditable_training_hours == 0 with input as inp
}

test_training_not_due_before_2026 if {
	inp := with_year(object.union(base_input, {"documentation": {"o6_16": {"training": {"courses": []}, "water_protection_concept_date": null}}}), 2025)
	not "O616-TRN-001" in rule_ids(o6_16.obligation_violations) with input as inp
	not "O616-TRN-002" in rule_ids(o6_16.obligation_violations) with input as inp
}

test_trained_person_left_before_deadline if {
	inp := object.union(base_input, {"documentation": {"o6_16": {"training": {"trained_person_left_date": "2026-06-30", "replacement_course_completed": false}}}})
	"O616-TRN-004" in rule_ids(o6_16.obligation_violations) with input as inp
}

test_water_protection_concept_missing if {
	inp := object.union(base_input, {"documentation": {"o6_16": {"water_protection_concept_date": "2027-01-10"}}})
	"O616-TRN-002" in rule_ids(o6_16.obligation_violations) with input as inp
}

# --- Bodenuntersuchung ---
test_soil_samples_per_started_5_ha if {
	o6_16.soil_samples_required_for(5.03) == 2
	o6_16.soil_samples_required_for(5.0) == 1
	o6_16.soil_samples_required_for(10.0) == 2
	o6_16.soil_samples_required_for(0.4) == 1
}

test_soil_samples_insufficient if {
	big := object.union(parcel_wheat, {"area_ha": 12.0})
	inp := object.union(with_parcels([big]), {"land": {"total_area_ha": 12.0}})
	o6_16.soil_samples_required == 3 with input as inp
	"O616-SOIL-001" in rule_ids(o6_16.obligation_violations) with input as inp
}

test_soil_sample_not_accredited_not_creditable if {
	inp := object.union(base_input, {"documentation": {"o6_16": {"soil_samples": [
		{"sample_id": "S1", "sample_date": "2024-11-17", "lab_submission_date": "2024-11-18", "accredited_lab": false, "parameters": ["N", "P", "K", "pH", "humus"], "n_parameter": "mineral_n", "method": "sgd", "entered_in_invekos_gis": true},
		{"sample_id": "S2", "sample_date": "2021-12-01", "lab_submission_date": "2021-12-02", "accredited_lab": true, "parameters": ["N", "P", "K", "pH", "humus"], "n_parameter": "mineral_n", "method": "sgd", "entered_in_invekos_gis": true},
	]}}})
	o6_16.creditable_soil_samples == 0 with input as inp
}

test_soil_sample_missing_parameter if {
	inp := object.union(base_input, {"documentation": {"o6_16": {"soil_samples": [{"sample_id": "S1", "sample_date": "2024-11-17", "lab_submission_date": "2024-11-18", "accredited_lab": true, "parameters": ["N", "P", "K", "pH"], "n_parameter": "mineral_n", "method": "sgd"}]}}})
	o6_16.creditable_soil_samples == 0 with input as inp
}

test_soil_sample_taken_over_with_parcel_not_creditable if {
	inp := object.union(base_input, {"documentation": {"o6_16": {"soil_samples": [{"sample_id": "S1", "sample_date": "2024-11-17", "lab_submission_date": "2024-11-18", "accredited_lab": true, "parameters": ["N", "P", "K", "pH", "humus"], "n_parameter": "mineral_n", "method": "sgd", "taken_over_with_parcel": true}]}}})
	o6_16.creditable_soil_samples == 0 with input as inp
}

test_soil_sample_not_entered_in_gis if {
	inp := object.union(base_input, {"documentation": {"o6_16": {"soil_samples": [
		{"sample_id": "S1", "sample_date": "2024-11-17", "lab_submission_date": "2024-11-18", "accredited_lab": true, "parameters": ["N", "P", "K", "pH", "humus"], "n_parameter": "mineral_n", "method": "sgd", "entered_in_invekos_gis": false},
		{"sample_id": "S2", "sample_date": "2025-03-01", "lab_submission_date": "2025-03-02", "accredited_lab": true, "parameters": ["N", "P", "K", "pH", "humus"], "n_parameter": "mineral_n", "method": "sgd", "entered_in_invekos_gis": true},
	]}}})
	"O616-SOIL-003" in rule_ids(o6_16.obligation_violations) with input as inp
}

# --- Pflanzenschutz ---
test_banned_substance_on_maize if {
	m := object.union(parcel_maize, {"operations": {"psm_applications": [{"date": "2026-05-01", "product_type": "chemical_synthetic", "active_substances": ["S-Metolachlor"]}]}})
	"O616-PSM-001" in rule_ids(o6_16.obligation_violations) with input as with_parcels([parcel_wheat, m])
}

test_banned_substance_allowed_on_wheat if {
	w := object.union(parcel_wheat, {"operations": {"psm_applications": [{"date": "2026-04-01", "product_type": "chemical_synthetic", "active_substances": ["Terbuthylazin"]}]}})
	not "O616-PSM-001" in rule_ids(o6_16.obligation_violations) with input as with_parcels([w, parcel_maize])
}

test_bentazon_only_if_reauthorised if {
	s := object.union(parcel_maize, {"crop": {"crop_name": "Soja"}, "operations": {"psm_applications": [{"date": "2026-05-01", "product_type": "chemical_synthetic", "active_substances": ["Bentazon"]}]}})
	not "O616-PSM-001" in rule_ids(o6_16.obligation_violations) with input as with_parcels([parcel_wheat, s])
	inp := object.union(with_parcels([parcel_wheat, s]), {"context": {"bentazon_reauthorised": true}})
	"O616-PSM-001" in rule_ids(o6_16.obligation_violations) with input as inp
}

test_psm_coding_until_2025 if {
	inp := with_year(base_input, 2025)
	"O616-PSM-002" in rule_ids(o6_16.obligation_violations) with input as inp
	m := object.union(parcel_maize, {"codes": ["PSMCS"]})
	not "O616-PSM-002" in rule_ids(o6_16.obligation_violations) with input as with_year(with_parcels([parcel_wheat, m]), 2025)
}

test_psm_coding_dropped_from_2026 if {
	not "O616-PSM-002" in rule_ids(o6_16.obligation_violations) with input as base_input
}

# --- Oberösterreich ---
ooe_parcel(crop, ops) := object.union(parcel_wheat, {"kg_number": "49001", "n_reduction_zone": "other", "crop": {"crop_name": crop}, "operations": ops})

ooe_input(ps) := object.union(with_parcels(ps), {"farm": {"region": {"federal_state": "Oberösterreich"}}})

test_ooe_soluble_fertilizer_ban_autumn if {
	p := ooe_parcel("Winterweizen", {"fertilizer_applications": [{"date": "2026-11-02", "readily_soluble": true, "readily_available_n_kg_ha": 40}]})
	"O616-OOE-001" in rule_ids(o6_16.obligation_violations) with input as ooe_input([p])
}

test_ooe_soluble_fertilizer_maize_until_march_21 if {
	p := ooe_parcel("Mais", {"fertilizer_applications": [{"date": "2026-03-10", "readily_soluble": true, "readily_available_n_kg_ha": 40}]})
	"O616-OOE-001" in rule_ids(o6_16.obligation_violations) with input as ooe_input([p])
	w := ooe_parcel("Winterweizen", {"fertilizer_applications": [{"date": "2026-03-10", "readily_soluble": true, "readily_available_n_kg_ha": 40}]})
	not "O616-OOE-001" in rule_ids(o6_16.obligation_violations) with input as ooe_input([w])
}

test_ooe_arable_forage_exempt_from_ban if {
	p := ooe_parcel("Kleegras", {"fertilizer_applications": [{"date": "2026-11-02", "readily_soluble": true, "readily_available_n_kg_ha": 40}]})
	not "O616-OOE-001" in rule_ids(o6_16.obligation_violations) with input as ooe_input([p])
}

test_ooe_split_dose_over_80 if {
	p := ooe_parcel("Winterweizen", {"fertilizer_applications": [{"date": "2026-04-02", "readily_soluble": true, "readily_available_n_kg_ha": 90}]})
	"O616-OOE-002" in rule_ids(o6_16.obligation_violations) with input as ooe_input([p])
}

test_ooe_split_dose_slurry_via_annex2 if {
	# 140 kg N Schweinegülle x 65 % NH4-N = 91 kg/ha
	p := ooe_parcel("Winterweizen", {"fertilizer_applications": [{"date": "2026-04-02", "readily_soluble": true, "fertilizer_type": "Schweinegülle", "total_n_after_losses_kg_ha": 140}]})
	"O616-OOE-002" in rule_ids(o6_16.obligation_violations) with input as ooe_input([p])
}

test_ooe_slow_release_exempt_from_split if {
	p := ooe_parcel("Winterweizen", {"fertilizer_applications": [{"date": "2026-04-02", "readily_soluble": false, "slow_release": true, "readily_available_n_kg_ha": 90}]})
	not "O616-OOE-002" in rule_ids(o6_16.obligation_violations) with input as ooe_input([p])
}

test_ooe_variant_3_not_allowed if {
	p := ooe_parcel("Winterweizen", {"cover_crop": {"is_used": true, "variant": 3}})
	"O616-OOE-003" in rule_ids(o6_16.obligation_violations) with input as ooe_input([p])
}

test_ooe_psm_without_inspection if {
	p := ooe_parcel("Winterweizen", {"psm_applications": [{"date": "2026-05-01", "product_type": "chemical_synthetic", "active_substances": ["X"]}]})
	"O616-OOE-004" in rule_ids(o6_16.obligation_violations) with input as ooe_input([p])
	q := ooe_parcel("Winterweizen", {"psm_applications": [{"date": "2026-05-01", "product_type": "chemical_synthetic", "active_substances": ["X"], "warning_service_documented": true}]})
	not "O616-OOE-004" in rule_ids(o6_16.obligation_violations) with input as ooe_input([q])
}

test_ooe_rules_not_applied_outside_upper_austria if {
	p := object.union(parcel_wheat, {"operations": {"fertilizer_applications": [{"date": "2026-11-02", "readily_soluble": true, "readily_available_n_kg_ha": 90}]}})
	not "O616-OOE-001" in rule_ids(o6_16.obligation_violations) with input as with_parcels([p])
	not "O616-OOE-002" in rule_ids(o6_16.obligation_violations) with input as with_parcels([p])
}

# --- Option AG ---
ag_parcel := {
	"parcel_id": "AG1",
	"area_ha": 2.0,
	"land_use": "arable",
	"kg_number": "20001",
	"codes": ["AG"],
	"average_arable_index": 35,
	"crop": {"crop_category": "fallow", "crop_name": "Grünbrache"},
	"operations": {"tillage_type": "no_till"},
	"plot_records": {"complete": true},
	"ag_option": {"first_declared_year": 2025, "sowing_date": "2025-04-20", "winter_hardy_mix": true, "mix_contains_legumes": false, "mowing_or_mulching_years": [2025]},
}

test_ag_premium_and_no_base_premium if {
	p := o6_16.premium with input as with_parcels([parcel_wheat, parcel_maize, ag_parcel])
	p.components.ag_option == 1080
	p.components.base == 540
}

test_ag_premium_capped_at_20_percent if {
	big_ag := object.union(ag_parcel, {"area_ha": 5.0})
	inp := object.union(with_parcels([parcel_wheat, big_ag]), {"land": {"total_area_ha": 11.0}})
	o6_16.ag_premium_area_ha == 2.2 with input as inp
}

test_ag_arable_index_over_40 if {
	a := object.union(ag_parcel, {"average_arable_index": 45})
	inp := with_parcels([parcel_wheat, a])
	"O616-AG-001" in rule_ids(o6_16.ag_issues) with input as inp
	o6_16.premium.components.ag_option == 0 with input as inp
}

test_ag_former_grassland_2020_not_eligible if {
	a := object.union(ag_parcel, {"grassland_in_mfa_2020": true})
	not o6_16.ag_parcel_eligible(a) with input as with_parcels([parcel_wheat, a])
}

test_ag_wrong_land_use if {
	a := object.union(ag_parcel, {"crop": {"crop_name": "Winterweizen"}})
	not o6_16.ag_parcel_eligible(a) with input as with_parcels([parcel_wheat, a])
}

test_ag_div_requires_ubb_or_bio if {
	a := object.union(ag_parcel, {"codes": ["AG", "DIV"]})
	o6_16.ag_parcel_eligible(a) with input as with_parcels([parcel_wheat, a])
	inp := object.union(with_parcels([parcel_wheat, a]), {"farm": {"oepul": {"participating_measures": ["6"]}}})
	not o6_16.ag_parcel_eligible(a) with input as inp
}

test_ag_npf_until_2024_no_premium if {
	a := object.union(ag_parcel, {"codes": ["AG", "NPF"], "ag_option": {"first_declared_year": 2024, "sowing_date": "2024-04-20"}})
	inp := with_year(with_parcels([parcel_wheat, a]), 2024)
	o6_16.ag_npf_no_premium(a) with input as inp
	o6_16.ag_eligible_area_ha == 0 with input as inp
}

test_ag_early_ploughing if {
	a := object.union(ag_parcel, {"ag_option": {"ploughing_date": "2026-09-01"}})
	"O616-AG-003" in rule_ids(o6_16.obligation_violations) with input as with_parcels([parcel_wheat, a])
	b := object.union(ag_parcel, {"ag_option": {"ploughing_date": "2026-09-15"}})
	not "O616-AG-003" in rule_ids(o6_16.obligation_violations) with input as with_parcels([parcel_wheat, b])
}

test_ag_takeover_counts_previous_establishment_year if {
	a := object.union(ag_parcel, {"ag_option": {"first_declared_year": 2026, "previous_holder_establishment_year": 2025, "ploughing_date": "2026-09-15", "existing_stand_retained": true}})
	not "O616-AG-003" in rule_ids(o6_16.obligation_violations) with input as with_parcels([parcel_wheat, a])
}

test_ag_late_sowing_with_legumes if {
	a := object.union(ag_parcel, {"ag_option": {"sowing_date": "2025-05-20", "mix_contains_legumes": true}})
	"O616-AG-002" in rule_ids(o6_16.obligation_violations) with input as with_parcels([parcel_wheat, a])
}

test_ag_mowing_every_second_year if {
	a := object.union(ag_parcel, {"ag_option": {"mowing_or_mulching_years": [2024]}})
	"O616-AG-005" in rule_ids(o6_16.obligation_violations) with input as with_parcels([parcel_wheat, a])
}

test_ag_grazing_prohibited if {
	a := object.union(ag_parcel, {"ag_option": {"grazing": true}})
	"O616-AG-006" in rule_ids(o6_16.obligation_violations) with input as with_parcels([parcel_wheat, a])
}

test_ag_fertilizer_prohibited if {
	a := object.union(ag_parcel, {"ag_option": {"fertilizer_or_psm_used": true}})
	"O616-AG-004" in rule_ids(o6_16.obligation_violations) with input as with_parcels([parcel_wheat, a])
}

test_ag_conversion_deadline if {
	o6_16.ag_conversion_allowed("18", "2025-12-31")
	not o6_16.ag_conversion_allowed("18", "2026-01-02")
	not o6_16.ag_conversion_allowed("8", "2025-06-01")
}

# --- Zuschlag Wien ---
wien_parcel := object.union(parcel_wheat, {"parcel_id": "W1", "kg_number": "1104", "n_reduction_zone": "vienna"})

wien_input(ps) := object.union(with_parcels(ps), {"farm": {"region": {"federal_state": "Wien"}, "oepul": {"o6_16": {"wien_humus": {"applied": true, "application_date": "2022-12-01", "scientific_project_confirmation": true}}}}})

test_wien_premium if {
	p := o6_16.premium with input as wien_input([wien_parcel])
	p.components.wien_humus == 712.8
}

test_wien_premium_not_with_mulch_seeding if {
	w := object.union(wien_parcel, {"erosion_protection_mulch_direct_striptill": true})
	p := o6_16.premium with input as wien_input([w])
	p.components.wien_humus == 0
}

test_wien_no_inversion_tillage if {
	w := object.union(wien_parcel, {"operations": {"tillage_type": "plough"}})
	"O616-WIEN-002" in rule_ids(o6_16.obligation_violations) with input as wien_input([w])
	m := object.union(wien_parcel, {"operations": {"tillage_type": "plough", "inversion_tillage_after_maize": true}})
	not "O616-WIEN-002" in rule_ids(o6_16.obligation_violations) with input as wien_input([m])
}

test_wien_requires_area_in_vienna if {
	"O616-WIEN-001" in rule_ids(o6_16.access_violations) with input as wien_input([parcel_wheat])
}

test_wien_project_confirmation_required if {
	inp := object.union(wien_input([wien_parcel]), {"farm": {"oepul": {"o6_16": {"wien_humus": {"scientific_project_confirmation": false}}}}})
	"O616-WIEN-003" in rule_ids(o6_16.access_violations) with input as inp
}

test_wien_double_soil_samples if {
	o6_16.wien_soil_samples_required == 4 with input as wien_input([wien_parcel])
}

test_wien_additional_training_hours if {
	"O616-WIEN-004" in rule_ids(o6_16.obligation_violations) with input as wien_input([wien_parcel])
	inp := object.union(wien_input([wien_parcel]), {"documentation": {"o6_16": {"training": {"courses": [
		{"date": "2023-02-01", "hours": 10, "provider_recognized": true},
		{"date": "2024-02-01", "hours": 3, "provider_recognized": true, "wien_additional": true},
	]}}}})
	not "O616-WIEN-004" in rule_ids(o6_16.obligation_violations) with input as inp
}

# --- Zuschlag Schweinefütterung ---
pig_input(groups, y) := with_year(object.union(base_input, {"farm": {"oepul": {"o6_16": {"pig_feeding": {"applied": true, "application_date": "2024-12-01", "start_year": 2025}}}}, "livestock": {"has_livestock": true, "species_groups": groups}, "documentation": {"o6_16": {"pig_feeding_recipes_documented": true}}}), y)

fattening_avg := {"species": "pigs", "category": "growing_finishing_32_60kg", "animal_count": 45, "annual_average_count": 45, "gve": null, "feeding": {"mode": "average", "crude_protein_average_g_per_kg": 155}}

test_pig_density_computation if {
	# 45 Mastschweine x 0,3 GVE = 13,5 GVE / 13 ha Acker = 1,04 GVE/ha
	o6_16.pig_density_met with input as pig_input([fattening_avg], 2026)
	low := object.union(fattening_avg, {"annual_average_count": 40})
	not o6_16.pig_density_met with input as pig_input([low], 2026)
	"O616-PIG-001" in rule_ids(o6_16.access_violations) with input as pig_input([low], 2026)
}

test_pig_premium_all_arable_from_2025 if {
	p := o6_16.premium with input as pig_input([fattening_avg], 2026)
	p.components.pig_feeding == 702
}

test_pig_premium_only_area_until_2024 if {
	inp := object.union(pig_input([fattening_avg], 2024), {"farm": {"oepul": {"o6_16": {"pig_feeding": {"application_date": "2023-12-01", "start_year": 2024}}}}})
	p := o6_16.premium with input as inp
	p.components.pig_feeding == 540
}

test_pig_crude_protein_average_exceeded if {
	g := object.union(fattening_avg, {"feeding": {"crude_protein_average_g_per_kg": 160}})
	"O616-PIG-003" in rule_ids(o6_16.obligation_violations) with input as pig_input([g], 2026)
}

test_pig_phase_feeding_alternative if {
	g := {"species": "pigs", "category": "finishing_90kg_plus", "animal_count": 50, "gve": null, "feeding": {"mode": "phase", "crude_protein_max_g_per_kg": 150}}
	inp := object.union(pig_input([g], 2026), {"documentation": {"o6_16": {"phase_feeding_plausible": true}}})
	not "O616-PIG-003" in rule_ids(o6_16.obligation_violations) with input as inp
	h := object.union(g, {"feeding": {"crude_protein_max_g_per_kg": 152}})
	"O616-PIG-003" in rule_ids(o6_16.obligation_violations) with input as pig_input([h], 2026)
	"O616-PIG-005" in rule_ids(o6_16.obligation_violations) with input as pig_input([g], 2026)
}

test_pig_sow_limits if {
	sow := {"species": "pigs", "category": "sow_pregnant", "animal_count": 30, "gve": null, "feeding": {"crude_protein_max_g_per_kg": 126}}
	"O616-PIG-003" in rule_ids(o6_16.obligation_violations) with input as pig_input([fattening_avg, sow], 2026)
}

test_pig_not_with_measure_9 if {
	inp := object.union(pig_input([fattening_avg], 2026), {"farm": {"oepul": {"participating_measures": ["1A", "6", "9_pig_feeding"]}}})
	"O616-PIG-002" in rule_ids(o6_16.access_violations) with input as inp
}

test_pig_last_entry_2028 if {
	inp := object.union(pig_input([fattening_avg], 2029), {"farm": {"oepul": {"o6_16": {"pig_feeding": {"start_year": 2029, "application_date": "2028-12-01"}}}}})
	"O616-APP-003" in rule_ids(o6_16.access_violations) with input as inp
}

# --- Zuschlag Cultan ---
cul_parcel := object.union(parcel_maize, {"parcel_id": "C1", "codes": ["CUL"], "operations": {"fertilizer_applications": [{"date": "2026-04-10", "method": "cultan_injection", "fertilizer_type": "AHL", "amount_kg_ha": 120}]}})

test_cultan_premium if {
	p := o6_16.premium with input as with_parcels([parcel_wheat, cul_parcel])
	p.components.cultan == 160
}

test_cultan_not_before_2025 if {
	inp := with_year(with_parcels([parcel_wheat, cul_parcel]), 2024)
	"O616-CUL-001" in rule_ids(o6_16.access_violations) with input as inp
	o6_16.premium_cultan == 0 with input as inp
}

test_cultan_requires_injection if {
	c := object.union(cul_parcel, {"operations": {"fertilizer_applications": [{"date": "2026-04-10", "method": "broadcast"}]}})
	"O616-CUL-002" in rule_ids(o6_16.obligation_violations) with input as with_parcels([parcel_wheat, c])
}

test_cultan_contractor_invoice if {
	c := object.union(cul_parcel, {"operations": {"fertilizer_applications": [{"date": "2026-04-10", "method": "cultan_injection", "fertilizer_type": "AHL", "amount_kg_ha": 120, "by_contractor": true}]}})
	"O616-CUL-004" in rule_ids(o6_16.obligation_violations) with input as with_parcels([parcel_wheat, c])
}

test_cultan_records_incomplete if {
	c := object.union(cul_parcel, {"operations": {"fertilizer_applications": [{"date": "2026-04-10", "method": "cultan_injection"}]}})
	"O616-CUL-003" in rule_ids(o6_16.obligation_violations) with input as with_parcels([parcel_wheat, c])
}

test_cultan_outside_area if {
	c := object.union(cul_parcel, {"kg_number": "99999"})
	"O616-CUL-001" in rule_ids(o6_16.access_violations) with input as with_parcels([parcel_wheat, c])
}
