package oepul.o6_12_test

import data.oepul.o6_12

base_parcels := [
	{
		"parcel_id": "W1", "area_ha": 2.0, "land_use": "special_crop",
		"crop": {"crop_category": "vineyard", "crop_name": "Grüner Veltliner", "special_crop_type": "wine"},
		"oepul": {"measure_codes": ["12", "11"], "op_codes": [], "psm_codes": []},
		"operations": {"plant_protection_applications": []},
	},
	{
		"parcel_id": "O1", "area_ha": 1.0, "land_use": "special_crop",
		"crop": {"crop_category": "orchard", "crop_name": "Apfel", "special_crop_type": "fruit", "fruit_grafted": true},
		"oepul": {"measure_codes": ["12"]},
	},
	{
		"parcel_id": "H1", "area_ha": 0.5, "land_use": "special_crop",
		"crop": {"crop_category": "hop", "crop_name": "Hopfen", "special_crop_type": "hop"},
	},
	{
		"parcel_id": "R1", "area_ha": 0.3, "land_use": "special_crop",
		"crop": {"crop_category": "vineyard", "crop_name": "Rebschule", "special_crop_type": "vine_nursery"},
	},
	{
		"parcel_id": "SW", "area_ha": 0.2, "land_use": "special_crop",
		"crop": {"crop_category": "vineyard", "crop_name": null, "special_crop_type": "other_wine"},
	},
	{
		"parcel_id": "A1", "area_ha": 6.0, "land_use": "arable",
		"crop": {"crop_category": "cereal", "crop_name": "Weizen"},
	},
]

base_input := {
	"farm": {
		"year": 2026,
		"applicant": {
			"person_type": "natural_person",
			"is_active_farmer": true,
			"performs_agricultural_activity": true,
			"farms_in_own_name_and_account": true,
		},
		"certifications": {"organic": {"is_certified": false}},
	},
	"land": {"total_area_ha": 10.0, "parcels": base_parcels},
	"oepul": {
		"first_participation_year": 2023,
		"measures": [{"code": "12", "commitment_start_year": 2024, "application_date": "2023-12-15", "exit_date": null}],
		"payment_application": {"submitted": true},
		"o6_12": {},
	},
}

with_parcel(i, p) := array.concat(array.concat(array.slice(base_parcels, 0, i), [p]), array.slice(base_parcels, i + 1, count(base_parcels)))

w1_with_apps(apps, codes) := object.union(base_parcels[0], {
	"operations": {"plant_protection_applications": apps},
	"oepul": {"measure_codes": ["12"], "psm_codes": codes},
})

input_with_w1(w1) := object.union(base_input, {"land": {"total_area_ha": 10.0, "parcels": with_parcel(0, w1)}})

input_with_o6_12(extra) := object.union(base_input, {"oepul": {"o6_12": extra}})

cs_insecticide := {
	"product_name": "Pyrethroid X", "application_date": "2026-06-20", "effect_type": "insecticide",
	"chemical_synthetic": true, "organic_regulation_permitted": false, "area_wide": true,
	"authority_ordered_control": false,
}

bio_insecticide := {
	"product_name": "Bio-Pyrethrum", "application_date": "2026-06-20", "effect_type": "insecticide",
	"chemical_synthetic": false, "organic_regulation_permitted": true, "area_wide": true,
	"authority_ordered_control": false,
}

cs_fungicide := {
	"product_name": "Fungizid Y", "application_date": "2026-05-10", "effect_type": "fungicide",
	"chemical_synthetic": true, "organic_regulation_permitted": false, "area_wide": true,
	"authority_ordered_control": false,
}

# --- Flächen und Prämie ---
test_woh_area_counts_cutting_vineyards_not_nurseries if {
	o6_12.woh_area_ha == 3.5 with input as base_input
}

test_eligible_parcels_exclude_nursery_and_other_wine if {
	o6_12.premium_eligible_parcel_ids == {"W1", "O1", "H1"} with input as base_input
}

test_other_wine_no_premium_reason if {
	"use_type_not_premium_eligible" in o6_12.parcel_ineligible_reasons.SW with input as base_input
}

test_gross_premium_2026 if {
	o6_12.gross_premium_eur == 945 with input as base_input
}

test_no_violations_base if {
	count(o6_12.violations) == 0 with input as base_input
}

test_rate_2023_is_250 if {
	o6_12.premium_rate("wine", 2023) == 250
	o6_12.premium_rate("fruit", 2024) == 270
	o6_12.premium_rate("hop", 2028) == 270
}

test_premium_2023_first_year if {
	inp := object.union(base_input, {
		"farm": {"year": 2023},
		"oepul": {"measures": [{"code": "12", "commitment_start_year": 2023, "application_date": "2022-12-20"}]},
	})
	o6_12.gross_premium_eur == 875 with input as inp
}

test_cutting_vineyard_counts_as_wine if {
	p := object.union(base_parcels[0], {"crop": {"special_crop_type": "cutting_vineyard"}})
	o6_12.woh_type(p) == "wine"
}

test_crop_category_fallback if {
	o6_12.woh_type({"crop": {"crop_category": "hop"}}) == "hop"
}

# --- Mindestteilnahmefläche ---
test_min_participation_fail_first_year if {
	small := [
		{"parcel_id": "W1", "area_ha": 0.4, "crop": {"crop_category": "vineyard", "special_crop_type": "wine"}},
		{"parcel_id": "A1", "area_ha": 3.0, "crop": {"crop_category": "cereal"}},
	]
	inp := object.union(base_input, {
		"farm": {"year": 2025},
		"land": {"total_area_ha": 3.4, "parcels": small},
		"oepul": {"measures": [{"code": "12", "commitment_start_year": 2025, "application_date": "2024-12-01"}]},
	})
	o6_12.access_failure_consequence == "no_contract" with input as inp
	o6_12.gross_premium_eur == 0 with input as inp
}

test_min_participation_not_checked_later_years if {
	small := [{"parcel_id": "W1", "area_ha": 0.4, "crop": {"crop_category": "vineyard", "special_crop_type": "wine"}}]
	inp := object.union(base_input, {"land": {"total_area_ha": 5.0, "parcels": small}})
	o6_12.min_participation_ok with input as inp
}

test_farm_min_size_first_oepul_year if {
	small := [{"parcel_id": "W1", "area_ha": 1.0, "crop": {"crop_category": "vineyard", "special_crop_type": "wine"}}]
	inp := object.union(base_input, {
		"farm": {"year": 2025},
		"land": {"total_area_ha": 1.0, "parcels": small},
		"oepul": {"first_participation_year": 2025, "measures": [{"code": "12", "commitment_start_year": 2025, "application_date": "2024-12-01"}]},
	})
	not o6_12.farm_min_size_ok with input as inp
}

# --- Insektizidverzicht ---
test_cs_insecticide_violation if {
	inp := input_with_w1(w1_with_apps([cs_insecticide], []))
	count(o6_12.prohibited_insecticide_use) == 1 with input as inp
}

test_bio_insecticide_allowed if {
	inp := input_with_w1(w1_with_apps([bio_insecticide], []))
	count(o6_12.prohibited_insecticide_use) == 0 with input as inp
}

test_authority_ordered_cs_allowed if {
	app := object.union(cs_insecticide, {"authority_ordered_control": true})
	order := {
		"pest": "Amerikanische Rebzikade", "federal_state": "Steiermark", "in_designated_area": true,
		"prescribes_chemical_synthetic": true, "organic_substances_available": false,
		"order_documented": true, "application_documented": true, "uploaded_to_eama": false,
	}
	inp := object.union(input_with_w1(w1_with_apps([app], [])), {"oepul": {"o6_12": {"authority_orders": [order]}}})
	count(o6_12.prohibited_insecticide_use) == 0 with input as inp
	o6_12.designated_area_chemical_synthetic_permitted with input as inp
	count(o6_12.violations) == 0 with input as inp
}

test_authority_order_organic_available_cs_not_allowed if {
	app := object.union(cs_insecticide, {"authority_ordered_control": true})
	order := {
		"pest": "Amerikanische Rebzikade", "federal_state": "Burgenland", "in_designated_area": true,
		"prescribes_chemical_synthetic": false, "organic_substances_available": true,
		"order_documented": true, "application_documented": true,
	}
	inp := object.union(input_with_w1(w1_with_apps([app], [])), {"oepul": {"o6_12": {"authority_orders": [order]}}})
	count(o6_12.prohibited_insecticide_use) == 1 with input as inp
	count(o6_12.authority_order_organic_only_breach) == 1 with input as inp
}

test_authority_order_documentation_missing if {
	order := {"pest": "Rebzikade", "prescribes_chemical_synthetic": true, "order_documented": false, "application_documented": true}
	inp := input_with_o6_12({"authority_orders": [order]})
	"Rebzikade" in o6_12.authority_order_documentation_missing with input as inp
}

test_insecticide_on_nursery_not_in_scope if {
	nursery := object.union(base_parcels[3], {"operations": {"plant_protection_applications": [cs_insecticide]}})
	inp := object.union(base_input, {"land": {"total_area_ha": 10.0, "parcels": with_parcel(3, nursery)}})
	count(o6_12.prohibited_insecticide_use) == 0 with input as inp
}

# --- Kauf und Lagerung ---
test_storage_of_prohibited_insecticide if {
	inp := input_with_o6_12({"insecticide_stock": [{"product_name": "Pyrethroid X", "stored": true, "organic_regulation_permitted": false, "permitted_use_in_other_crop": false}]})
	"Pyrethroid X" in o6_12.purchase_storage_violation with input as inp
}

test_storage_for_other_crop_with_records_ok if {
	item := {
		"product_name": "Ackerinsektizid", "purchased": true, "organic_regulation_permitted": false,
		"permitted_use_in_other_crop": true, "quantity_plausible": true, "records_available": true,
	}
	inp := input_with_o6_12({"insecticide_stock": [item]})
	count(o6_12.purchase_storage_violation) == 0 with input as inp
}

test_storage_for_other_crop_without_records_violation if {
	item := {
		"product_name": "Ackerinsektizid", "purchased": true, "organic_regulation_permitted": false,
		"permitted_use_in_other_crop": true, "quantity_plausible": true, "records_available": false,
	}
	inp := input_with_o6_12({"insecticide_stock": [item]})
	"Ackerinsektizid" in o6_12.purchase_storage_violation with input as inp
}

# --- PSM-Codierung ---
test_psm_coding_required_2025_psmcsi_missing if {
	app := object.union(cs_insecticide, {"application_date": "2025-06-20"})
	inp := object.union(input_with_w1(w1_with_apps([app], ["PSMCS"])), {"farm": {"year": 2025}})
	{"parcel_id": "W1", "code": "PSMCSI"} in o6_12.psm_code_missing with input as inp
}

test_psm_mixed_bio_and_cs_psmcs_sufficient if {
	app := object.union(cs_fungicide, {"application_date": "2025-05-10"})
	bio := object.union(bio_insecticide, {"application_date": "2025-06-10"})
	inp := object.union(input_with_w1(w1_with_apps([app, bio], ["PSMCS"])), {"farm": {"year": 2025}})
	count(o6_12.psm_code_missing) == 0 with input as inp
}

test_psm_bio_only_requires_psmbio if {
	bio := object.union(bio_insecticide, {"application_date": "2025-06-10"})
	inp := object.union(input_with_w1(w1_with_apps([bio], [])), {"farm": {"year": 2025}})
	{"parcel_id": "W1", "code": "PSMBIO"} in o6_12.psm_code_missing with input as inp
}

test_psm_coding_not_required_2026 if {
	inp := input_with_w1(w1_with_apps([cs_fungicide], []))
	not o6_12.psm_coding_required with input as inp
	count(o6_12.psm_code_missing) == 0 with input as inp
}

test_psm_authority_order_upload_required_2025 if {
	app := object.union(cs_insecticide, {"application_date": "2025-06-20", "authority_ordered_control": true})
	order := {"pest": "Rebzikade", "prescribes_chemical_synthetic": true, "order_documented": true, "application_documented": true, "uploaded_to_eama": false}
	inp := object.union(
		object.union(input_with_w1(w1_with_apps([app], ["PSMCSI"])), {"farm": {"year": 2025}}),
		{"oepul": {"o6_12": {"authority_orders": [order]}}},
	)
	"Rebzikade" in o6_12.authority_order_upload_missing with input as inp
	count(o6_12.prohibited_insecticide_use) == 0 with input as inp
}

# --- Kombinationen ---
test_organic_combination_conflict if {
	inp := object.union(base_input, {"oepul": {"measures": [
		{"code": "12", "commitment_start_year": 2024, "application_date": "2023-12-15"},
		{"code": "1B", "commitment_start_year": 2024, "application_date": "2023-12-15"},
	]}})
	o6_12.organic_combination_conflict with input as inp
	"organic_combination_conflict" in o6_12.premium_blocked_reason with input as inp
}

test_organic_partial_farm_arable_grassland_ok if {
	inp := object.union(base_input, {"oepul": {
		"measures": [
			{"code": "12", "commitment_start_year": 2024, "application_date": "2023-12-15"},
			{"code": "1B", "commitment_start_year": 2024, "application_date": "2023-12-15"},
		],
		"organic_partial_farm": {"is_partial_farm": true, "organic_culture_area": "arable_grassland"},
	}})
	not o6_12.organic_combination_conflict with input as inp
}

test_anhang_l_statuses if {
	o6_12.combination_status("11") == "combinable"
	o6_12.combination_status("2") == "combinable"
	o6_12.combination_status("1A") == "landscape_elements_only"
	o6_12.combination_status("10") == "premium_reduction_measure_10_organisms"
	o6_12.combination_status("1B") == "not_combinable"
	o6_12.combination_status("13") == "not_combinable"
}

test_parcel_combination_not_permitted if {
	w1 := object.union(base_parcels[0], {"oepul": {"measure_codes": ["12", "1B"]}})
	inp := input_with_w1(w1)
	["W1", "1B"] in o6_12.parcel_combination_not_permitted with input as inp
}

test_measure_10_supplement_reduction if {
	inp := object.union(base_input, {"oepul": {"measures": [
		{"code": "12", "commitment_start_year": 2024, "application_date": "2023-12-15"},
		{"code": "10", "commitment_start_year": 2026},
	]}})
	o6_12.measure_10_organism_supplement_reduction_percent == 50 with input as inp
}

# --- Rebzikade 2026 ---
leafhopper := {
	"requested": true, "request_date": "2026-06-20", "reason_leafhopper_stated": true,
	"submitted_via_eama_force_majeure_form": true, "approved": true,
}

test_leafhopper_exit_no_premium_no_repayment if {
	inp := object.union(base_input, {"oepul": {
		"measures": [{"code": "12", "commitment_start_year": 2024, "application_date": "2023-12-15", "exit_date": "2026-06-20"}],
		"o6_12": {"leafhopper_exit": leafhopper},
	}})
	o6_12.leafhopper_exit_approved with input as inp
	o6_12.gross_premium_eur == 0 with input as inp
	o6_12.exit_consequence == "no_repayment" with input as inp
	o6_12.contract_end_after_leafhopper_exit == "2026-06-20" with input as inp
}

test_leafhopper_exit_cs_after_exit_not_violation if {
	app := object.union(cs_insecticide, {"application_date": "2026-07-01"})
	inp := object.union(input_with_w1(w1_with_apps([app], [])), {"oepul": {"o6_12": {"leafhopper_exit": leafhopper}}})
	count(o6_12.prohibited_insecticide_use) == 0 with input as inp
}

test_leafhopper_exit_requires_wine_area if {
	no_wine := [base_parcels[1], base_parcels[2]]
	inp := object.union(base_input, {
		"land": {"total_area_ha": 5.0, "parcels": no_wine},
		"oepul": {"o6_12": {"leafhopper_exit": leafhopper}},
	})
	"farm_has_no_wine_area" in o6_12.leafhopper_exit_findings with input as inp
	not o6_12.leafhopper_exit_approved with input as inp
}

test_leafhopper_exit_not_before_2026 if {
	early := object.union(leafhopper, {"request_date": "2025-06-01"})
	inp := input_with_o6_12({"leafhopper_exit": early})
	"exit_before_2026_not_covered" in o6_12.leafhopper_exit_findings with input as inp
}

# --- Ausstieg, Wechsel, Vertragszeitraum ---
test_regular_exit_requires_repayment if {
	inp := object.union(base_input, {"oepul": {"measures": [{"code": "12", "commitment_start_year": 2024, "application_date": "2023-12-15", "exit_date": "2027-01-01"}]}})
	o6_12.exit_consequence == "repayment_of_premiums_since_contract_start" with input as inp
}

test_exit_blocked_after_control_announcement if {
	inp := object.union(base_input, {"oepul": {
		"measures": [{"code": "12", "commitment_start_year": 2024, "application_date": "2023-12-15", "exit_date": "2026-08-01"}],
		"controls": {"on_site_control_announced_or_done": true},
	}})
	o6_12.exit_blocked_by_control with input as inp
}

test_switch_to_organic_valid_2025 if {
	inp := input_with_o6_12({"switch_to_organic": {"requested": true, "effective_date": "2025-12-31"}})
	o6_12.switch_valid with input as inp
}

test_switch_to_organic_too_late if {
	inp := input_with_o6_12({"switch_to_organic": {"requested": true, "effective_date": "2026-01-01"}})
	not o6_12.switch_valid with input as inp
	"switch_to_organic_after_deadline" in o6_12.contract_findings with input as inp
}

test_contract_period_2025_four_years if {
	inp := object.union(base_input, {"oepul": {"measures": [{"code": "12", "commitment_start_year": 2025, "application_date": "2024-12-31"}]}})
	o6_12.contract_period.duration_years == 4 with input as inp
	o6_12.contract_period.end_date == "2028-12-31" with input as inp
}

test_entry_2026_not_possible if {
	inp := object.union(base_input, {"oepul": {"measures": [{"code": "12", "commitment_start_year": 2026, "application_date": "2026-01-15"}]}})
	"entry_after_last_entry_year" in o6_12.contract_findings with input as inp
	"measure_application_after_deadline" in o6_12.contract_findings with input as inp
}

test_takeover_deadline_2028_is_17_april if {
	inp := object.union(base_input, {"farm": {"year": 2028}, "oepul": {"o6_12": {"takeover": {"requested": true, "date": "2028-04-16", "taker_previously_participating": false, "expansion_percent": 20, "ama_approved": true}}}})
	o6_12.takeover_valid with input as inp
}

test_takeover_too_late_2026 if {
	inp := input_with_o6_12({"takeover": {"requested": true, "date": "2026-04-16", "taker_previously_participating": false, "expansion_percent": 60}})
	"takeover_after_deadline" in o6_12.takeover_findings with input as inp
	"takeover_expansion_above_50_percent" in o6_12.takeover_findings with input as inp
}

test_area_bound_annually_and_no_addition_restriction if {
	o6_12.area_bound_annually
	not o6_12.area_addition_restricted
}

test_area_reduction_tolerance if {
	o6_12.area_reduction_tolerance_ha(100) == 5
	o6_12.area_reduction_tolerance_ha(4) == 0.5
	o6_12.area_reduction_tolerance_ha(400) == 5
}

test_payment_application_missing_no_payment if {
	inp := object.union(base_input, {"oepul": {"payment_application": {"submitted": false, "years_overdue": 0}}})
	o6_12.payment_application_consequence == "commitment_continues_no_payment" with input as inp
	o6_12.gross_premium_eur == 0 with input as inp
}

# --- Förderwerbende Person ---
test_public_body_not_eligible if {
	inp := object.union(base_input, {"farm": {"applicant": {"person_type": "public_body"}}})
	"applicant_type_not_eligible" in o6_12.applicant_findings with input as inp
}

test_legal_person_public_share_above_25 if {
	inp := object.union(base_input, {"farm": {"applicant": {"person_type": "legal_person", "public_body_share_percent": 30}}})
	"public_body_share_above_25_percent" in o6_12.applicant_findings with input as inp
}

# --- Schlagbezogene Förderfähigkeit ---
test_national_park_neusiedlersee_excluded if {
	w1 := object.union(base_parcels[0], {"location": {"national_park": "neusiedlersee"}})
	inp := input_with_w1(w1)
	"national_park_without_area_premiums" in o6_12.parcel_ineligible_reasons.W1 with input as inp
}

test_national_park_kalkalpen_eligible if {
	w1 := object.union(base_parcels[0], {"location": {"national_park": "kalkalpen"}})
	inp := input_with_w1(w1)
	"W1" in o6_12.premium_eligible_parcel_ids with input as inp
}

test_ungrafted_fruit_excluded if {
	o1 := object.union(base_parcels[1], {"crop": {"fruit_grafted": false}})
	inp := object.union(base_input, {"land": {"total_area_ha": 10.0, "parcels": with_parcel(1, o1)}})
	"fruit_not_grafted_planting_material" in o6_12.parcel_ineligible_reasons.O1 with input as inp
}

test_papau_fruit_from_2025 if {
	o6_12.fruit_crop_listed("Papau", 2025)
	not o6_12.fruit_crop_listed("Papau", 2024)
	o6_12.fruit_crop_listed("Walnuss", 2023)
}

test_op_code_excludes_parcel if {
	w1 := object.union(base_parcels[0], {"oepul": {"op_codes": ["OP"]}})
	inp := input_with_w1(w1)
	not "W1" in o6_12.premium_eligible_parcel_ids with input as inp
}

test_transfer_without_continuation_excluded if {
	w1 := object.union(base_parcels[0], {"oepul": {"transferred_during_year": true, "successor_continues_commitment": false}})
	inp := input_with_w1(w1)
	"transferred_without_continuation" in o6_12.parcel_ineligible_reasons.W1 with input as inp
}

test_minimum_management_breach if {
	w1 := object.union(base_parcels[0], {"operations": {"minimum_management": {"harvest_and_removal": false}}})
	inp := input_with_w1(w1)
	"W1" in o6_12.minimum_management_breach with input as inp
	not "W1" in o6_12.premium_eligible_parcel_ids with input as inp
}

# --- Kürzungen, Modulation, Obergrenze, Auszahlung ---
test_warning_zero_until_2026_one_percent_from_2027 if {
	o6_12.sanction_reduction_percent == 0 with input as input_with_o6_12({"sanction": {"stage": "warning"}})
	inp27 := object.union(input_with_o6_12({"sanction": {"stage": "warning"}}), {"farm": {"year": 2027}})
	o6_12.sanction_reduction_percent == 1 with input as inp27
}

test_sanction_25_percent_applied if {
	inp := input_with_o6_12({"sanction": {"stage": "25"}})
	o6_12.premium_after_sanction_eur == 708.75 with input as inp
}

test_exclusion_after_two_full_reductions if {
	inp := input_with_o6_12({"sanction": {"stage": "100", "full_reductions_in_contract_period": 2}})
	o6_12.sanction_exclusion_consequence == "exclusion_and_repayment_of_contract_period_premiums" with input as inp
	o6_12.gross_premium_eur == 0 with input as inp
}

test_force_majeure_suppresses_sanction if {
	inp := object.union(input_with_o6_12({"sanction": {"stage": "25"}}), {"oepul": {"force_majeure": {"recognised": true}}})
	o6_12.effective_reduction_percent == 0 with input as inp
}

test_modulation_220_ha if {
	inp := object.union(base_input, {"land": {"total_area_ha": 220.0}})
	f := o6_12.modulation_factor with input as inp
	abs(f - 0.990909) < 0.00001
}

test_area_payment_cap_excess if {
	w1 := object.union(base_parcels[0], {"oepul": {"other_area_payments_eur_per_ha": 1100}})
	inp := input_with_w1(w1)
	o6_12.parcel_cap_excess_eur.W1 == 140 with input as inp
	o6_12.net_premium_eur == 805 with input as inp
}

test_payout_deadline_and_advance if {
	o6_12.payout_deadline == "2027-06-30" with input as base_input
	o6_12.advance_payment_max_eur == 708.75 with input as base_input
}

test_min_payout_threshold if {
	inp := object.union(base_input, {"oepul": {"total_payment_eur": 40}})
	o6_12.payout_may_be_withheld_below_minimum with input as inp
	not o6_12.payout_may_be_withheld_below_minimum with input as base_input
}

test_force_majeure_claim_required if {
	inp := object.union(base_input, {"oepul": {"force_majeure": {"obligations_not_met_due_to_drought": true}}})
	o6_12.force_majeure_claim_required with input as inp
}

test_decision_object if {
	d := o6_12.decision with input as base_input
	d.measure == "12"
	d.net_premium_eur == 945
	d.psm_coding_required == false
}

test_unknown_measure_code_in_combination if {
	o6_12.combination_status("99") == "unknown_measure_code"
	o6_12.anhang_l_marker_meaning("a") == "auf der Einzelfläche kombinierbar mit Prämienabschlag"
}

test_multi_year_and_takeover_not_restricted if {
	o6_12.is_multi_year_measure
	not o6_12.takeover_restricted_to_single_cases
}

test_calculation_order_modulation_before_cap if {
	order := o6_12.calculation_order
	count(order) == 11
	startswith(order[6], "Modulation")
	startswith(order[7], "Berechnung der Obergrenze")
}
