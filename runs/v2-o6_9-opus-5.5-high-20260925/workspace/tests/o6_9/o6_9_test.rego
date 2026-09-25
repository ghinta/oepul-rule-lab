package oepul.o6_9_test

import data.oepul.o6_9

base_farm := {
	"farm": {
		"farm_id": "AT-TEST-1",
		"year": 2025,
		"region": {"federal_state": "Oberösterreich", "district": "Wels-Land"},
		"oepul_first_participation_year": 2023,
		"applicant": {"legal_form": "natural_person", "is_active_farmer": true},
	},
	"land": {
		"total_area_ha": 60,
		"arable_area_ha": 40,
		"grassland_area_ha": 20,
		"parcels": [
			{"parcel_id": "A1", "area_ha": 20, "land_use": "arable", "crop": {"crop_category": "cereal", "crop_name": "Weizen", "is_pure_legume_stand": false}, "operations": {"harvested_share_percent": 100}},
			{"parcel_id": "A2", "area_ha": 15, "land_use": "arable", "crop": {"crop_category": "maize", "crop_name": "Mais", "is_pure_legume_stand": false}, "operations": {"harvested_share_percent": 100}},
			{"parcel_id": "A3", "area_ha": 5, "land_use": "arable", "crop": {"crop_category": "legume", "crop_name": "Sojabohne", "is_pure_legume_stand": true}, "operations": {"harvested_share_percent": 100}},
			{"parcel_id": "G1", "area_ha": 20, "land_use": "grassland", "crop": {"crop_category": "other", "crop_name": "Wiese", "is_pure_legume_stand": false}},
		],
	},
	"livestock": {
		"has_livestock": true,
		"species_groups": [
			{"species": "pigs", "category": "Mastschweine", "animal_count": 150, "gve": 45, "gve_annual_average": 45},
			{"species": "cattle", "category": "Milchkühe", "animal_count": 30, "gve": 30, "gve_annual_average": 30},
		],
		"pig_feeding": {
			"all_pigs_covered": true,
			"recipe_evidence_available": true,
			"phase_feeding_plausible": true,
			"rations": [
				{"animal_category": "fattening_32_60", "feeding_mode": "phase", "crude_protein_g_per_kg_88dm": 168, "protein_value_source": "manufacturer_declaration"},
				{"animal_category": "fattening_60_90", "feeding_mode": "phase", "crude_protein_g_per_kg_88dm": 150, "protein_value_source": "lab_analysis"},
				{"animal_category": "fattening_from_90", "feeding_mode": "phase", "crude_protein_g_per_kg_88dm": 145, "protein_value_source": "literature_standard"},
			],
		},
	},
	"oepul_applications": [
		{"measure_id": "o6_9", "component": "measure", "applied_on": "2022-12-15", "contract_start_year": 2023, "withdrawn_on": null, "lapsed_in_year": null},
		{"measure_id": "o6_9", "component": "n_reduced_pig_feeding", "applied_on": "2024-11-30", "contract_start_year": 2025, "withdrawn_on": null, "lapsed_in_year": null},
	],
	"manure_management": {
		"declared_volumes": {
			"trailing_hose_m3": 1000,
			"trailing_shoe_m3": 500,
			"injection_m3": 200,
			"separation_m3": 400,
			"declared_on": "2025-11-20",
		},
		"applications": [
			{"parcel_id": "A1", "date": "2025-03-10", "manure_kind": "guelle", "volume_m3": 600, "technique": "trailing_hose", "equipment_source": "own", "crop_name": "Weizen"},
			{"parcel_id": "G1", "date": "2025-04-02", "manure_kind": "guelle", "volume_m3": 400, "technique": "trailing_hose", "equipment_source": "own", "crop_name": "Wiese"},
			{"parcel_id": "A2", "date": "2025-04-20", "manure_kind": "jauche", "volume_m3": 500, "technique": "trailing_shoe", "equipment_source": "own", "crop_name": "Mais"},
			{"parcel_id": "A2", "date": "2025-05-15", "manure_kind": "guelle", "volume_m3": 200, "technique": "injection", "equipment_source": "own", "crop_name": "Mais"},
		],
		"separations": [{"date": "2025-06-01", "volume_m3": 400, "slurry_origin": "own_cattle", "equipment_source": "own"}],
		"evidence": {},
		"biogas_inputs": [],
		"biogas_excluded_components_present": [],
	},
	"documentation": {
		"application_logs_complete": true,
		"separation_records_complete": true,
	},
}

farm_with(patch) := json.patch(base_farm, patch)

rule_ids(vs) := {v.rule_id | some v in vs}

# --- baseline -------------------------------------------------------------

test_base_farm_has_no_violations if {
	count(o6_9.violations) == 0 with input as base_farm
}

test_base_farm_premium_components if {
	c := o6_9.premium_components with input as base_farm
	c.trailing_hose == 1100
	c.trailing_shoe == 750
	c.injection == 340
	c.separation == 600
	c.n_reduced_pig_feeding == 2160
	o6_9.premium_total_eur == 4950 with input as base_farm
	o6_9.premium_after_modulation_eur == 4950 with input as base_farm
	o6_9.advance_payment_max_eur == 3712.5 with input as base_farm
}

# --- rates -----------------------------------------------------------------

test_rates_by_year if {
	o6_9.rate("trailing_hose", 2023) == 1.0
	o6_9.rate("trailing_hose", 2024) == 1.1
	o6_9.rate("trailing_shoe", 2023) == 1.4
	o6_9.rate("trailing_shoe", 2026) == 1.5
	o6_9.rate("injection", 2023) == 1.6
	o6_9.rate("injection", 2027) == 1.7
	o6_9.rate("separation", 2023) == 1.4
	o6_9.rate("separation", 2024) == 1.5
	o6_9.rate("n_reduced_pig_feeding", 2025) == 54.0
	not o6_9.rate("n_reduced_pig_feeding", 2024)
}

# --- fertilisable area and cap --------------------------------------------

test_fertilisable_area_excludes_pure_legumes if {
	o6_9.fertilisable_area_ha == 55 with input as base_farm
	o6_9.slurry_cap_m3 == 2750 with input as base_farm
}

test_fertilisable_area_excludes_total_fertilisation_ban if {
	f := farm_with([{"op": "add", "path": "/land/parcels/3/constraints", "value": {"total_fertilization_ban": true}}])
	o6_9.fertilisable_area_ha == 35 with input as f
}

test_legume_category_without_flag_is_excluded if {
	f := farm_with([{"op": "remove", "path": "/land/parcels/2/crop/is_pure_legume_stand"}])
	o6_9.fertilisable_area_ha == 55 with input as f
}

test_slurry_cap_reduces_proportionally if {
	f := farm_with([{"op": "replace", "path": "/manure_management/declared_volumes/trailing_hose_m3", "value": 3000}])
	o6_9.slurry_cap_exceeded with input as f
	total := sum([o6_9.eligible_slurry_m3(c) | some c in ["trailing_hose", "trailing_shoe", "injection"]]) with input as f
	abs(total - 2750) < 0.001
	"o6_9.premium.slurry_cap_50_m3_per_ha" in rule_ids(o6_9.notices) with input as f
}

# --- separation ------------------------------------------------------------

test_separation_cap_20_m3_per_cattle_gve if {
	f := farm_with([{"op": "replace", "path": "/livestock/species_groups/1/gve_annual_average", "value": 10}])
	o6_9.separation_cap_m3 == 200 with input as f
	o6_9.eligible_separation_m3 == 200 with input as f
	o6_9.separation_premium == 300 with input as f
}

test_separation_external_slurry_not_eligible if {
	f := farm_with([{"op": "replace", "path": "/manure_management/separations/0/slurry_origin", "value": "external"}])
	o6_9.recorded_separation_m3 == 0 with input as f
	"o6_9.separation.records_support_declaration" in rule_ids(o6_9.violations) with input as f
	"o6_9.separation.only_own_cattle_slurry" in rule_ids(o6_9.notices) with input as f
}

test_separation_external_device_requires_invoice if {
	f := farm_with([{"op": "replace", "path": "/manure_management/separations/0/equipment_source", "value": "external_service"}])
	"o6_9.separation.external_equipment_evidence" in rule_ids(o6_9.violations) with input as f
}

# --- deadlines and contract ------------------------------------------------

test_late_volume_declaration_no_premium if {
	f := farm_with([{"op": "replace", "path": "/manure_management/declared_volumes/declared_on", "value": "2025-12-01"}])
	"o6_9.declaration.deadline_30_november" in rule_ids(o6_9.violations) with input as f
	o6_9.premium_components.trailing_hose == 0 with input as f
	o6_9.premium_components.separation == 0 with input as f
}

test_contract_lapses_without_quantities if {
	f := farm_with([
		{"op": "replace", "path": "/manure_management/declared_volumes", "value": {"declared_on": "2025-11-20"}},
		{"op": "remove", "path": "/oepul_applications/1"},
	])
	o6_9.contract_lapses_this_year with input as f
	"o6_9.contract.lapse_no_quantity" in rule_ids(o6_9.violations) with input as f
}

test_n_feeding_alone_keeps_contract if {
	f := farm_with([{"op": "replace", "path": "/manure_management/declared_volumes", "value": {"declared_on": "2025-11-20"}}])
	o6_9.minimum_participation_met with input as f
	not o6_9.contract_lapses_this_year with input as f
}

test_measure_application_after_31_december_is_late if {
	f := farm_with([{"op": "replace", "path": "/oepul_applications/0/applied_on", "value": "2023-01-05"}])
	not o6_9.measure_contract_valid with input as f
	"o6_9.contract.application_deadline" in rule_ids(o6_9.violations) with input as f
	o6_9.premium_total_eur == 0 with input as f
}

test_last_entry_year_2027 if {
	ok := farm_with([
		{"op": "replace", "path": "/farm/year", "value": 2027},
		{"op": "replace", "path": "/oepul_applications/0/applied_on", "value": "2026-12-31"},
		{"op": "replace", "path": "/oepul_applications/0/contract_start_year", "value": 2027},
	])
	o6_9.measure_contract_valid with input as ok
	late := farm_with([
		{"op": "replace", "path": "/farm/year", "value": 2028},
		{"op": "replace", "path": "/oepul_applications/0/applied_on", "value": "2027-12-31"},
		{"op": "replace", "path": "/oepul_applications/0/contract_start_year", "value": 2028},
	])
	not o6_9.measure_contract_valid with input as late
}

test_withdrawal_during_year_invalidates_year if {
	f := farm_with([{"op": "replace", "path": "/oepul_applications/0/withdrawn_on", "value": "2025-06-30"}])
	not o6_9.measure_contract_valid with input as f
}

test_withdrawal_from_next_year_keeps_current_year if {
	f := farm_with([{"op": "replace", "path": "/oepul_applications/0/withdrawn_on", "value": "2026-01-01"}])
	o6_9.measure_contract_valid with input as f
}

test_lapsed_contract_requires_new_application if {
	f := farm_with([{"op": "replace", "path": "/oepul_applications/0/lapsed_in_year", "value": 2024}])
	not o6_9.measure_contract_valid with input as f
	g := farm_with([
		{"op": "replace", "path": "/oepul_applications/0/lapsed_in_year", "value": 2024},
		{"op": "add", "path": "/oepul_applications/-", "value": {"measure_id": "o6_9", "component": "measure", "applied_on": "2024-12-20", "contract_start_year": 2025}},
	])
	o6_9.measure_contract_valid with input as g
}

test_mfa_deadline if {
	o6_9.mfa_deadline(2025) == "2025-04-15"
	o6_9.mfa_deadline(2023) == "2023-04-17"
	o6_9.mfa_deadline(2028) == "2028-04-17"
}

# --- n-reduced pig feeding -------------------------------------------------

test_n_feeding_density_below_threshold if {
	f := farm_with([{"op": "replace", "path": "/livestock/species_groups/0/gve_annual_average", "value": 30}])
	not o6_9.n_feeding_density_met with input as f
	"o6_9.feeding.access_min_1_gve_per_ha" in rule_ids(o6_9.violations) with input as f
	o6_9.premium_components.n_reduced_pig_feeding == 0 with input as f
}

test_n_feeding_density_exactly_one if {
	f := farm_with([{"op": "replace", "path": "/livestock/species_groups/0/gve_annual_average", "value": 40}])
	o6_9.n_feeding_density_met with input as f
}

test_n_feeding_not_before_2025 if {
	f := farm_with([
		{"op": "replace", "path": "/oepul_applications/1/contract_start_year", "value": 2024},
		{"op": "replace", "path": "/oepul_applications/1/applied_on", "value": "2023-12-01"},
	])
	not o6_9.participates_n_feeding with input as f
	"o6_9.feeding.application_deadline" in rule_ids(o6_9.violations) with input as f
}

test_fattening_average_alternative_to_phase if {
	f := farm_with([
		{"op": "replace", "path": "/livestock/pig_feeding/rations/1/crude_protein_g_per_kg_88dm", "value": 156},
		{"op": "add", "path": "/livestock/pig_feeding/rations/-", "value": {"animal_category": "fattening_average", "feeding_mode": "average", "crude_protein_g_per_kg_88dm": 157, "protein_value_source": "lab_analysis"}},
	])
	o6_9.protein_limits_met with input as f
}

test_fattening_both_options_failed if {
	f := farm_with([
		{"op": "replace", "path": "/livestock/pig_feeding/rations/1/crude_protein_g_per_kg_88dm", "value": 156},
		{"op": "add", "path": "/livestock/pig_feeding/rations/-", "value": {"animal_category": "fattening_average", "feeding_mode": "average", "crude_protein_g_per_kg_88dm": 158, "protein_value_source": "lab_analysis"}},
	])
	not o6_9.protein_limits_met with input as f
	"o6_9.feeding.protein_limits" in rule_ids(o6_9.violations) with input as f
}

test_gestating_sow_limit_125 if {
	f := farm_with([{"op": "add", "path": "/livestock/pig_feeding/rations/-", "value": {"animal_category": "sow_gestating", "crude_protein_g_per_kg_88dm": 126, "protein_value_source": "lab_analysis"}}])
	not o6_9.protein_limits_met with input as f
	g := farm_with([{"op": "add", "path": "/livestock/pig_feeding/rations/-", "value": {"animal_category": "sow_gestating", "crude_protein_g_per_kg_88dm": 125, "protein_value_source": "lab_analysis"}}])
	o6_9.protein_limits_met with input as g
}

test_all_pigs_must_be_covered if {
	f := farm_with([{"op": "replace", "path": "/livestock/pig_feeding/all_pigs_covered", "value": false}])
	not o6_9.protein_limits_met with input as f
}

test_phase_feeding_requires_plausibility if {
	f := farm_with([{"op": "replace", "path": "/livestock/pig_feeding/phase_feeding_plausible", "value": false}])
	"o6_9.feeding.phase_feeding_plausibility" in rule_ids(o6_9.violations) with input as f
}

test_recipe_evidence_required if {
	f := farm_with([{"op": "replace", "path": "/livestock/pig_feeding/recipe_evidence_available", "value": false}])
	"o6_9.feeding.recipe_evidence" in rule_ids(o6_9.violations) with input as f
}

test_invalid_protein_value_source if {
	f := farm_with([{"op": "replace", "path": "/livestock/pig_feeding/rations/0/protein_value_source", "value": "estimate"}])
	"o6_9.feeding.protein_value_source" in rule_ids(o6_9.violations) with input as f
}

test_combination_with_o6_16_supplement_excluded if {
	f := farm_with([{"op": "add", "path": "/oepul_applications/-", "value": {"measure_id": "o6_16", "component": "n_reduced_pig_feeding_supplement", "applied_on": "2024-12-01", "contract_start_year": 2025}}])
	o6_9.n_feeding_combination_conflict with input as f
	not o6_9.n_feeding_eligible with input as f
	"o6_9.combination.o6_16_n_feeding" in rule_ids(o6_9.violations) with input as f
}

test_n_feeding_area_excludes_national_park_and_op if {
	f := farm_with([
		{"op": "add", "path": "/land/parcels/0/constraints", "value": {"in_national_park": true}},
		{"op": "add", "path": "/land/parcels/1/oepul_codes", "value": ["OP"]},
	])
	o6_9.n_feeding_premium_area_ha == 5 with input as f
	o6_9.n_feeding_density_met with input as f
}

test_gve_from_annex_a_key if {
	g := {"species": "pigs", "gve_key_category": "young_fattening_pigs_ge_32kg", "average_animal_count": 100}
	o6_9.gve_of(g) == 30
	s := {"species": "pigs", "gve_key_category": "breeding_young_sows_ge_50kg", "average_animal_count": 10}
	o6_9.gve_of(s) == 5
	c := {"species": "cattle", "gve_key_category": "cattle_ge_2y", "average_animal_count": 12}
	o6_9.gve_of(c) == 12
}

test_animals_abroad_not_counted if {
	f := farm_with([{"op": "add", "path": "/livestock/species_groups/1/kept_in_austria", "value": false}])
	o6_9.cattle_gve == 0 with input as f
}

# --- slurry application -----------------------------------------------------

test_swivel_distributor_not_eligible if {
	f := farm_with([{"op": "replace", "path": "/manure_management/applications/0/technique", "value": "swivel_distributor"}])
	o6_9.recorded_eligible_m3("trailing_hose") == 400 with input as f
	"o6_9.slurry.records_support_declaration" in rule_ids(o6_9.violations) with input as f
}

test_diluted_solid_manure_not_eligible if {
	f := farm_with([{"op": "replace", "path": "/manure_management/applications/0/manure_kind", "value": "festmist_mit_wasser"}])
	some x in o6_9.ineligible_application_records with input as f
	"manure_kind_not_eligible" in x.reasons
}

test_application_on_special_crop_not_eligible if {
	f := farm_with([
		{"op": "add", "path": "/land/parcels/-", "value": {"parcel_id": "W1", "area_ha": 2, "land_use": "special_crop", "crop": {"crop_category": "vineyard"}}},
		{"op": "add", "path": "/manure_management/applications/-", "value": {"parcel_id": "W1", "date": "2025-09-01", "manure_kind": "guelle", "volume_m3": 50, "technique": "trailing_hose"}},
	])
	o6_9.recorded_eligible_m3("trailing_hose") == 1000 with input as f
}

test_biogas_with_non_permitted_input if {
	f := farm_with([
		{"op": "replace", "path": "/manure_management/applications/2/manure_kind", "value": "biogasguelle"},
		{"op": "replace", "path": "/manure_management/biogas_inputs", "value": ["plant_products_grassland_arable", "slaughter_waste"]},
		{"op": "replace", "path": "/manure_management/evidence", "value": {"biogas_input_evidence_available": true}},
	])
	o6_9.biogas_ineligible with input as f
	o6_9.recorded_eligible_m3("trailing_shoe") == 0 with input as f
}

test_biogas_with_edible_oil_residues if {
	f := farm_with([{"op": "replace", "path": "/manure_management/biogas_excluded_components_present", "value": ["edible_oil_residues"]}])
	o6_9.biogas_ineligible with input as f
}

test_biogas_requires_input_evidence if {
	f := farm_with([
		{"op": "replace", "path": "/manure_management/applications/2/manure_kind", "value": "biogasguelle"},
		{"op": "replace", "path": "/manure_management/biogas_inputs", "value": ["farm_manure", "corn_steep_liquor"]},
	])
	not o6_9.biogas_ineligible with input as f
	"o6_9.slurry.biogas_input_evidence" in rule_ids(o6_9.violations) with input as f
}

test_external_service_requires_invoice if {
	f := farm_with([{"op": "replace", "path": "/manure_management/applications/0/equipment_source", "value": "external_service"}])
	"o6_9.slurry.external_equipment_evidence" in rule_ids(o6_9.violations) with input as f
	g := farm_with([
		{"op": "replace", "path": "/manure_management/applications/0/equipment_source", "value": "external_service"},
		{"op": "replace", "path": "/manure_management/evidence", "value": {"external_service_invoices_available": true}},
	])
	not "o6_9.slurry.external_equipment_evidence" in rule_ids(o6_9.violations) with input as g
}

test_shared_slurry_tanker_conditions if {
	f := farm_with([
		{"op": "replace", "path": "/manure_management/applications/0/equipment_source", "value": "shared_purchase"},
		{"op": "replace", "path": "/manure_management/evidence", "value": {"shared_equipment_inspectable": true}},
	])
	"o6_9.slurry.shared_equipment" in rule_ids(o6_9.violations) with input as f
}

test_incomplete_application_logs if {
	f := farm_with([{"op": "replace", "path": "/documentation/application_logs_complete", "value": false}])
	"o6_9.slurry.record_keeping" in rule_ids(o6_9.violations) with input as f
}

test_records_must_be_chronological if {
	f := farm_with([{"op": "replace", "path": "/manure_management/applications/0/date", "value": "2025-10-10"}])
	"o6_9.slurry.record_keeping" in rule_ids(o6_9.violations) with input as f
}

test_grouped_record_area_must_be_sum if {
	grouped := {"parcel_ids": ["A1", "A2"], "area_ha": 35, "date": "2025-03-10", "manure_kind": "guelle", "volume_m3": 600, "technique": "trailing_hose"}
	o6_9.grouped_record_area_ok(grouped) with input as base_farm
	wrong := object.union(grouped, {"area_ha": 20})
	not o6_9.grouped_record_area_ok(wrong) with input as base_farm
}

test_records_groupable_only_if_identical if {
	a := {"crop_name": "Weizen", "volume_m3_per_ha": 20, "date": "2025-03-10", "technique": "trailing_hose"}
	o6_9.records_groupable(a, a)
	not o6_9.records_groupable(a, object.union(a, {"technique": "injection"}))
}

# --- general conditions -----------------------------------------------------

test_modulation_factor if {
	o6_9.modulation_factor(150) == 1
	abs(o6_9.modulation_factor(220) - (218 / 220)) < 0.000001
	abs(o6_9.modulation_factor(1200) - ((((200 + 90) + 595) + 150) / 1200)) < 0.000001
}

test_modulation_applied_to_premium if {
	f := farm_with([{"op": "replace", "path": "/land/total_area_ha", "value": 220}])
	o6_9.premium_after_modulation_eur == 4905 with input as f
}

test_minimum_payment_notice if {
	f := farm_with([
		{"op": "replace", "path": "/manure_management/declared_volumes", "value": {"trailing_hose_m3": 40, "declared_on": "2025-11-01"}},
		{"op": "replace", "path": "/manure_management/applications", "value": [{"parcel_id": "A1", "date": "2025-03-10", "manure_kind": "guelle", "volume_m3": 40, "technique": "trailing_hose"}]},
		{"op": "replace", "path": "/manure_management/separations", "value": []},
		{"op": "remove", "path": "/oepul_applications/1"},
	])
	o6_9.payment_may_be_withheld with input as f
	"o6_9.payment.min_amount" in rule_ids(o6_9.notices) with input as f
}

test_applicant_public_body_share if {
	f := farm_with([{"op": "replace", "path": "/farm/applicant", "value": {"legal_form": "legal_person", "public_body_share_percent": 30, "is_active_farmer": true}}])
	not o6_9.applicant_eligible with input as f
	"o6_9.general.applicant" in rule_ids(o6_9.violations) with input as f
	g := farm_with([{"op": "replace", "path": "/farm/applicant", "value": {"legal_form": "legal_person", "public_body_share_percent": 25, "is_active_farmer": true}}])
	o6_9.applicant_eligible with input as g
}

test_public_body_not_eligible_for_o6_9 if {
	f := farm_with([{"op": "replace", "path": "/farm/applicant", "value": {"legal_form": "public_body", "is_active_farmer": true}}])
	not o6_9.applicant_eligible with input as f
}

test_first_year_min_farm_size if {
	f := farm_with([
		{"op": "replace", "path": "/farm/oepul_first_participation_year", "value": 2025},
		{"op": "replace", "path": "/land/total_area_ha", "value": 1.2},
	])
	not o6_9.first_year_min_size_met with input as f
	g := farm_with([
		{"op": "replace", "path": "/farm/oepul_first_participation_year", "value": 2025},
		{"op": "replace", "path": "/land/total_area_ha", "value": 1.2},
		{"op": "add", "path": "/land/protected_cultivation_area_ha", "value": 0.5},
	])
	o6_9.first_year_min_size_met with input as g
}

test_drought_2026_harvest_exemption if {
	f := farm_with([
		{"op": "replace", "path": "/farm/year", "value": 2026},
		{"op": "replace", "path": "/land/parcels/0/operations", "value": {"harvested_share_percent": 0, "no_harvestable_crop_due_to_drought": true}},
	])
	p := f.land.parcels[0]
	o6_9.harvest_obligation_met(p) with input as f
	g := farm_with([
		{"op": "replace", "path": "/farm/year", "value": 2026},
		{"op": "replace", "path": "/farm/region", "value": {"federal_state": "Tirol", "district": "Innsbruck-Land"}},
		{"op": "replace", "path": "/land/parcels/0/operations", "value": {"harvested_share_percent": 0, "no_harvestable_crop_due_to_drought": true}},
	])
	not o6_9.harvest_obligation_met(g.land.parcels[0]) with input as g
}

test_drought_steiermark_extension if {
	o6_9.drought_district_listed("Steiermark", "Leibnitz")
	o6_9.drought_district_listed("Burgenland", "Oberwart")
	not o6_9.drought_district_listed("Steiermark", "Liezen")
}

test_harvest_obligation_violation_on_n_feeding_area if {
	f := farm_with([{"op": "replace", "path": "/land/parcels/1/operations/harvested_share_percent", "value": 80}])
	"o6_9.general.min_management_harvest" in rule_ids(o6_9.violations) with input as f
	o6_9.n_feeding_premium_area_ha == 25 with input as f
}

test_annex_l_combinations if {
	o6_9.single_area_combinable("o6_16") == true
	o6_9.single_area_combinable("o6_18") == false
	o6_9.single_area_combinable("o6_1b") == true
	o6_9.single_area_combinable("o6_4") == false
}

test_sanction_stage_warning_becomes_retention_2027 if {
	o6_9.sanction_reduction_share(0, 2026) == 0
	o6_9.sanction_reduction_share(0, 2027) == 0.01
	o6_9.sanction_reduction_share(4, 2025) == 0.25
}

test_takeover_only_on_restructuring if {
	o6_9.takeover_allowed("farm_merger")
	not o6_9.takeover_allowed("purchase_of_parcels")
}

test_area_payment_cap if {
	o6_9.area_payment_cap_eur_per_ha(2023) == 1200
	o6_9.area_payment_cap_eur_per_ha(2026) == 1300
}

test_one_year_measure if {
	o6_9.is_one_year_measure("o6_9")
	not o6_9.is_one_year_measure("o6_16")
}

test_decision_document if {
	d := o6_9.decision with input as base_farm
	d.measure == "o6_9"
	d.premium_total_eur == 4950
	d.measure_contract_valid == true
}
