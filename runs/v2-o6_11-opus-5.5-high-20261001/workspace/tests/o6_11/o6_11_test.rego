package oepul.o6_11_test

import data.oepul.o6_11

# ---------------------------------------------------------------------------
# Testdaten
# ---------------------------------------------------------------------------
applicant_ok := {
	"legal_form": "natural_person",
	"is_public_body": false,
	"public_body_share_percent": 0,
	"is_active_farmer": true,
	"farms_in_own_name_and_account": true,
}

m11(start) := {
	"measure_id": "11",
	"contract_start_year": start,
	"application_date": sprintf("%d-12-10", [start - 1]),
	"payment_claim_submitted": true,
}

vineyard(id, area) := {
	"parcel_id": id,
	"area_ha": area,
	"land_use": "special_crop",
	"crop": {"crop_category": "vineyard", "crop_name": null},
}

orchard(id, area, species) := {
	"parcel_id": id,
	"area_ha": area,
	"land_use": "special_crop",
	"crop": {"crop_category": "orchard", "crop_name": species, "is_grafted": true},
}

arable(id, area) := {
	"parcel_id": id,
	"area_ha": area,
	"land_use": "arable",
	"crop": {"crop_category": "cereal", "crop_name": "Weizen"},
}

farm_input(y, measures, parcel_list) := {
	"farm": {
		"year": y,
		"applicant": applicant_ok,
		"oepul": {"first_participation_year": 2023, "measures": measures},
	},
	"land": {"total_area_ha": 20, "parcels": parcel_list},
	"documentation": {"plant_protection_inventory": []},
}

with_parcel_field(parcel, key, value) := object.union(parcel, {key: value})

herbicide_app(date, zone) := {
	"date": date,
	"product_name": "Glyphosat-Produkt",
	"effect_type": "herbicide",
	"active_substances": ["Glyphosat"],
	"is_organic_approved": false,
	"is_area_wide": true,
	"application_zone": zone,
}

rule_ids(vs) := {v.rule_id | some v in vs}

# ---------------------------------------------------------------------------
# Prämie und Prämiensätze
# ---------------------------------------------------------------------------
test_premium_2026_wine_fruit_hop if {
	hop := {"parcel_id": "H1", "area_ha": 1, "land_use": "special_crop", "crop": {"crop_category": "hop", "crop_name": null}}
	inp := farm_input(2026, [m11(2023)], [vineyard("W1", 2), orchard("O1", 1, "Apfel"), hop])
	o6_11.parcel_premium == {"W1": 540, "O1": 270, "H1": 270} with input as inp
	o6_11.premium_payable == 1080 with input as inp
	o6_11.compliant with input as inp
}

test_premium_rate_2023_is_250 if {
	inp := farm_input(2023, [m11(2023)], [vineyard("W1", 1)])
	o6_11.parcel_premium.W1 == 250 with input as inp
}

test_premium_rate_from_2024_is_270 if {
	o6_11.premium_rate("obst", 2024) == 270
	o6_11.premium_rate("hopfen", 2028) == 270
	o6_11.premium_rate("wein", 2023) == 250
}

test_walnut_and_chestnut_no_premium_but_ban_applies if {
	inp := farm_input(2026, [m11(2023)], [orchard("O1", 1, "Walnuss"), orchard("O2", 1, "Edelkastanie"), vineyard("W1", 1)])
	not o6_11.parcel_premium.O1 with input as inp
	not o6_11.parcel_premium.O2 with input as inp
	o6_11.parcel_results.O1.herbicide_ban_applies with input as inp
}

test_fruit_species_from_2025 if {
	inp24 := farm_input(2024, [m11(2023)], [orchard("O1", 1, "Maulbeere"), vineyard("W1", 1)])
	not o6_11.parcel_results.O1.wine_fruit_hop_area with input as inp24
	inp25 := farm_input(2025, [m11(2023)], [orchard("O1", 1, "Maulbeere"), vineyard("W1", 1)])
	o6_11.parcel_results.O1.wine_fruit_hop_area with input as inp25
	o6_11.parcel_premium.O1 == 270 with input as inp25
}

test_other_wine_and_special_crop_no_premium if {
	sw := {"parcel_id": "SW", "area_ha": 1, "crop": {"crop_category": "vineyard", "usage_type": "other_wine"}}
	ss := {"parcel_id": "SS", "area_ha": 1, "crop": {"crop_category": "other", "usage_type": "other_special_crop"}}
	inp := farm_input(2026, [m11(2023)], [sw, ss, vineyard("W1", 1)])
	o6_11.parcel_no_premium_reasons(sw) == {"no_premium_usage_type", "generally_non_eligible_area"} with input as inp
	not o6_11.parcel_premium.SS with input as inp
	o6_11.parcel_results.SW.herbicide_ban_applies with input as inp
}

test_ungrafted_fruit_no_premium if {
	o := orchard("O1", 1, "Apfel")
	ungrafted := object.union(o, {"crop": {"crop_category": "orchard", "crop_name": "Apfel", "is_grafted": false}})
	inp := farm_input(2026, [m11(2023)], [ungrafted, vineyard("W1", 1)])
	"ungrafted_fruit" in o6_11.parcel_results.O1.no_premium_reasons with input as inp
}

test_op_code_and_trial_area_no_premium if {
	w1 := with_parcel_field(vineyard("W1", 1), "oepul", {"measures": ["11"], "codes": ["OP"]})
	w2 := with_parcel_field(vineyard("W2", 1), "oepul", {"measures": ["11"], "codes": ["VF"]})
	w3 := with_parcel_field(vineyard("W3", 1), "oepul", {"measures": ["11"], "excluded_measures": ["11"]})
	inp := farm_input(2026, [m11(2023)], [w1, w2, w3, vineyard("W4", 1)])
	o6_11.parcel_premium == {"W4": 270} with input as inp
}

test_national_park_donau_auen_no_premium if {
	w1 := with_parcel_field(vineyard("W1", 1), "oepul", {"measures": ["11"], "national_park": "Donau-Auen"})
	w2 := with_parcel_field(vineyard("W2", 1), "oepul", {"measures": ["11"], "national_park": "Thayatal"})
	inp := farm_input(2026, [m11(2023)], [w1, w2])
	o6_11.parcel_premium == {"W2": 270} with input as inp
}

test_parcel_not_declared_for_measure_no_premium if {
	w1 := with_parcel_field(vineyard("W1", 1), "oepul", {"measures": ["12"]})
	inp := farm_input(2026, [m11(2023)], [w1, vineyard("W2", 1)])
	"not_declared_for_measure" in o6_11.parcel_results.W1.no_premium_reasons with input as inp
}

test_minimum_management_not_met if {
	w1 := object.union(vineyard("W1", 1), {"operations": {"permanent_crop_management": {"harvested_and_removed": false}}})
	inp := farm_input(2026, [m11(2023)], [w1, vineyard("W2", 1)])
	"minimum_management_not_met" in o6_11.parcel_results.W1.no_premium_reasons with input as inp
}

test_payment_cap_proportional if {
	w1 := with_parcel_field(vineyard("W1", 1), "oepul", {"measures": ["11", "10"], "other_area_payments_eur_per_ha": 1130})
	inp := farm_input(2026, [m11(2023)], [w1])

	# 270 + 1130 = 1400 > 1300 -> 270 * 1300 / 1400
	o6_11.parcel_premium.W1 == 270 with input as inp
	o6_11.parcel_payable.W1 == 250.71 with input as inp
	"W1" in o6_11.payment_cap_exceeded_parcels with input as inp
}

test_modulation_220_ha if {
	f := o6_11.modulation_factor_for(220)
	f > 0.99090
	f < 0.99091
	o6_11.modulation_factor_for(150) == 1
	o6_11.modulation_factor_for(1200) == ((((200 * 100) + (100 * 90)) + (700 * 85)) + (200 * 75)) / 120000
}

test_min_payout_notice if {
	inp := farm_input(2026, [m11(2023)], [vineyard("W1", 0.1)])
	o6_11.payout_may_be_withheld with input as inp
}

# ---------------------------------------------------------------------------
# Zugangsvoraussetzungen
# ---------------------------------------------------------------------------
test_minimum_area_first_year_not_met if {
	inp := farm_input(2024, [m11(2024)], [vineyard("W1", 0.4)])
	"O611-MIN-AREA" in rule_ids(o6_11.violations) with input as inp
	o6_11.no_contract with input as inp
	o6_11.premium_before_modulation == 0 with input as inp
}

test_minimum_area_not_required_in_later_years if {
	inp := farm_input(2026, [m11(2024)], [vineyard("W1", 0.4)])
	not "O611-MIN-AREA" in rule_ids(o6_11.violations) with input as inp
}

test_cutting_vineyard_counts_vine_nursery_not if {
	sw := {"parcel_id": "S1", "area_ha": 0.3, "crop": {"crop_category": "vineyard", "usage_type": "cutting_vineyard"}}
	rs := {"parcel_id": "R1", "area_ha": 0.3, "crop": {"crop_category": "vineyard", "usage_type": "vine_nursery"}}
	inp := farm_input(2025, [m11(2025)], [sw, rs, vineyard("W1", 0.2)])
	o6_11.minimum_area_ha == 0.5 with input as inp
	o6_11.minimum_area_met with input as inp
	o6_11.parcel_results.S1.herbicide_ban_applies with input as inp
	not o6_11.parcel_results.R1.herbicide_ban_applies with input as inp
	not o6_11.parcel_premium.R1 with input as inp
}

test_contract_start_after_2025_invalid if {
	inp := farm_input(2026, [m11(2026)], [vineyard("W1", 1)])
	ids := rule_ids(o6_11.violations) with input as inp
	"O611-LAST-ENTRY" in ids
	"O611-CONTRACT-PERIOD" in ids
}

test_contract_period_years if {
	o6_11.contract_years == 6 with input as farm_input(2023, [m11(2023)], [vineyard("W1", 1)])
	o6_11.contract_years == 4 with input as farm_input(2025, [m11(2025)], [vineyard("W1", 1)])
}

test_application_late if {
	late := object.union(m11(2024), {"application_date": "2024-01-05"})
	inp := farm_input(2024, [late], [vineyard("W1", 1)])
	"O611-APPLY-DEADLINE" in rule_ids(o6_11.violations) with input as inp
}

test_farm_min_size_first_oepul_year if {
	inp := object.union(farm_input(2023, [m11(2023)], [vineyard("W1", 1)]), {"land": {"total_area_ha": 1.2}})
	"O611-GEN-MIN-FARM-SIZE" in rule_ids(o6_11.violations) with input as inp
	inp2 := object.union(inp, {"farm": {"year": 2024}})
	not "O611-GEN-MIN-FARM-SIZE" in rule_ids(o6_11.violations) with input as inp2
}

test_public_body_excluded if {
	inp := object.union(farm_input(2026, [m11(2023)], [vineyard("W1", 1)]), {"farm": {"applicant": {"is_public_body": true}}})
	"O611-GEN-APPLICANT" in rule_ids(o6_11.violations) with input as inp
	o6_11.premium_before_modulation == 0 with input as inp
}

test_legal_person_public_share_over_25 if {
	inp := object.union(farm_input(2026, [m11(2023)], [vineyard("W1", 1)]), {"farm": {"applicant": {"legal_form": "legal_person", "public_body_share_percent": 30}}})
	"Beteiligung von Gebietskörperschaften über 25 %" in o6_11.applicant_violations with input as inp
}

# ---------------------------------------------------------------------------
# Kombinationen
# ---------------------------------------------------------------------------
test_organic_full_farm_excluded if {
	inp := farm_input(2026, [m11(2023), {"measure_id": "1B"}], [vineyard("W1", 1)])
	"O611-COMB-BIO" in rule_ids(o6_11.violations) with input as inp
}

test_organic_partial_arable_grassland_allowed if {
	bio := {"measure_id": "1B", "is_organic_partial_farm": true, "organic_partial_culture_areas": ["arable_grassland"]}
	inp := farm_input(2026, [m11(2023), bio], [vineyard("W1", 1)])
	not o6_11.organic_combination_conflict with input as inp
}

test_organic_partial_wine_fruit_hop_excluded if {
	bio := {"measure_id": "1B", "is_organic_partial_farm": true, "organic_partial_culture_areas": ["wine_fruit_hop"]}
	inp := farm_input(2026, [m11(2023), bio], [vineyard("W1", 1)])
	o6_11.organic_combination_conflict with input as inp
}

test_switch_to_organic_deadline if {
	ok := object.union(m11(2023), {"conversion_target": "1B", "conversion_application_date": "2025-12-15"})
	inp := farm_input(2026, [ok, {"measure_id": "1B"}], [vineyard("W1", 1)])
	o6_11.switch_to_organic_allowed with input as inp
	not o6_11.organic_combination_conflict with input as inp
	"Umstieg in Biologische Wirtschaftsweise wirksam" in o6_11.premium_withheld_reasons with input as inp
	not o6_11.exit_repayment_required with input as object.union(inp, {"farm": {"oepul": {"measures": [object.union(ok, {"exit_date": "2025-12-31"})]}}})
	late := object.union(m11(2023), {"conversion_target": "1B", "conversion_application_date": "2026-01-10"})
	inp2 := farm_input(2026, [late], [vineyard("W1", 1)])
	"O611-SWITCH-BIO" in rule_ids(o6_11.violations) with input as inp2
}

test_parcel_combination_annex_l if {
	w1 := with_parcel_field(vineyard("W1", 1), "oepul", {"measures": ["11", "10", "12", "2"]})
	w2 := with_parcel_field(vineyard("W2", 1), "oepul", {"measures": ["11", "16"]})
	w3 := with_parcel_field(vineyard("W3", 1), "oepul", {"measures": ["11", "1A"]})
	inp := farm_input(2026, [m11(2023)], [w1, w2, w3])
	o6_11.parcel_combination_conflicts == {{"parcel_id": "W2", "other_measure": "16"}} with input as inp
	o6_11.parcel_combination_limited == {{"parcel_id": "W3", "other_measure": "1A", "footnote": "1"}} with input as inp
}

test_annex_l_matrix_symmetric_for_11 if {
	row := {c.column_measure | some c in data.o6_11.combination_table.cells; c.row_measure == "11"}
	col := {c.row_measure | some c in data.o6_11.combination_table.cells; c.column_measure == "11"}
	row == {"1A", "2", "10", "12"}
	row == col
}

# ---------------------------------------------------------------------------
# Herbizidverzicht, Ameisensäure, Kauf/Lagerung
# ---------------------------------------------------------------------------
test_herbicide_area_fence_stem if {
	w1 := object.union(vineyard("W1", 1), {"operations": {"psm_applications": [herbicide_app("2026-04-10", "area")]}})
	w2 := object.union(vineyard("W2", 1), {"operations": {"psm_applications": [herbicide_app("2026-04-10", "fence_line")]}})
	w3 := object.union(vineyard("W3", 1), {"operations": {"psm_applications": [herbicide_app("2026-04-10", "stem")]}})
	inp := farm_input(2026, [m11(2023)], [w1, w2, w3])
	rule_ids(o6_11.violations) == {"O611-HERB-BAN", "O611-FENCE", "O611-STAMM"} with input as inp
	not o6_11.compliant with input as inp
}

test_herbicide_on_arable_not_violation if {
	a1 := object.union(arable("A1", 5), {"operations": {"psm_applications": [herbicide_app("2026-04-10", "area")]}})
	inp := farm_input(2026, [m11(2023)], [a1, vineyard("W1", 1)])
	count(o6_11.herbicide_ban_violations) == 0 with input as inp
}

test_herbicide_after_exit_not_violation if {
	exited := object.union(m11(2023), {"exit_date": "2026-03-01", "exit_type": "voluntary"})
	w1 := object.union(vineyard("W1", 1), {"operations": {"psm_applications": [herbicide_app("2026-04-10", "area")]}})
	inp := farm_input(2026, [exited], [w1])
	count(o6_11.herbicide_ban_violations) == 0 with input as inp
	o6_11.exit_repayment_required with input as inp
	"Ausstieg/Abmeldung im Antragsjahr" in o6_11.premium_withheld_reasons with input as inp
}

test_loss_of_control_no_repayment if {
	exited := object.union(m11(2023), {"exit_date": "2026-03-01", "exit_type": "loss_of_control"})
	inp := farm_input(2026, [exited], [vineyard("W1", 1)])
	not o6_11.exit_repayment_required with input as inp
}

test_formic_acid_synonym if {
	app := {"date": "2026-05-01", "product_name": "Säure", "effect_type": "other", "active_substances": ["Methansäure"], "is_area_wide": false}
	o1 := object.union(orchard("O1", 1, "Apfel"), {"operations": {"psm_applications": [app]}})
	inp := farm_input(2026, [m11(2023)], [o1])
	"O611-AMEISENSAEURE" in rule_ids(o6_11.violations) with input as inp
}

test_inventory_herbicide_for_cereal_documented_ok if {
	item := {"product_name": "H", "effect_type": "herbicide", "intended_crop_category": "cereal", "records_documented": true, "quantity_plausible": true}
	inp := object.union(farm_input(2026, [m11(2023)], [vineyard("W1", 1), arable("A1", 5)]), {"documentation": {"plant_protection_inventory": [item]}})
	count(o6_11.purchase_storage_violations) == 0 with input as inp
}

test_inventory_herbicide_not_documented_violation if {
	item := {"product_name": "H", "effect_type": "herbicide", "intended_crop_category": "cereal", "records_documented": false, "quantity_plausible": true}
	inp := object.union(farm_input(2026, [m11(2023)], [vineyard("W1", 1), arable("A1", 5)]), {"documentation": {"plant_protection_inventory": [item]}})
	"O611-PURCHASE-STORAGE" in rule_ids(o6_11.violations) with input as inp
}

test_inventory_herbicide_without_other_crop_violation if {
	item := {"product_name": "H", "effect_type": "herbicide", "intended_crop_category": "vineyard", "records_documented": true, "quantity_plausible": true}
	inp := object.union(farm_input(2026, [m11(2023)], [vineyard("W1", 1)]), {"documentation": {"plant_protection_inventory": [item]}})
	count(o6_11.purchase_storage_violations) == 1 with input as inp
}

# ---------------------------------------------------------------------------
# PSM-Codierung bis 2025
# ---------------------------------------------------------------------------
test_psm_code_herbicide_requires_psmcsh_2025 if {
	w1 := object.union(vineyard("W1", 1), {"operations": {"psm_applications": [herbicide_app("2025-04-10", "area")]}})
	inp := farm_input(2025, [m11(2023)], [w1])
	o6_11.missing_psm_codes == {{"parcel_id": "W1", "code": "PSMCSH"}} with input as inp
}

test_psm_code_bio_and_cs_psmcs_sufficient if {
	apps := [
		{"date": "2024-05-01", "effect_type": "fungicide", "is_organic_approved": true, "is_area_wide": true},
		{"date": "2024-06-01", "effect_type": "fungicide", "is_organic_approved": false, "is_area_wide": true},
	]
	o1 := object.union(orchard("O1", 1, "Apfel"), {"operations": {"psm_applications": apps}, "oepul": {"measures": ["11"], "codes": ["PSMCS"]}})
	inp := farm_input(2024, [m11(2023)], [o1])
	o6_11.required_psm_codes(o1) == {"PSMCS"} with input as inp
	count(o6_11.missing_psm_codes) == 0 with input as inp
}

test_psm_code_bio_only_requires_psmbio if {
	apps := [{"date": "2024-05-01", "effect_type": "fungicide", "is_organic_approved": true, "is_area_wide": true}]
	o1 := object.union(orchard("O1", 1, "Apfel"), {"operations": {"psm_applications": apps}})
	inp := farm_input(2024, [m11(2023)], [o1])
	o6_11.missing_psm_codes == {{"parcel_id": "O1", "code": "PSMBIO"}} with input as inp
}

test_psm_code_not_required_from_2026 if {
	apps := [{"date": "2026-05-01", "effect_type": "fungicide", "is_organic_approved": false, "is_area_wide": true}]
	o1 := object.union(orchard("O1", 1, "Apfel"), {"operations": {"psm_applications": apps}})
	inp := farm_input(2026, [m11(2023)], [o1])
	count(o6_11.missing_psm_codes) == 0 with input as inp
	"O611-PSM-CODE-2026-ABOLISHED" in rule_ids(o6_11.notices) with input as inp
}

# ---------------------------------------------------------------------------
# Allgemeine Abwicklung
# ---------------------------------------------------------------------------
test_sanction_warning_retention_from_2027 if {
	inp26 := object.union(farm_input(2026, [m11(2023)], [vineyard("W1", 1)]), {"farm": {"oepul": {"sanction_level": "warning"}}})
	o6_11.sanction_reduction_percent == 0 with input as inp26
	inp27 := object.union(inp26, {"farm": {"year": 2027}})
	o6_11.sanction_reduction_percent == 1 with input as inp27
	o6_11.premium_payable == 267.3 with input as inp27
}

test_sanction_r25 if {
	inp := object.union(farm_input(2026, [m11(2023)], [vineyard("W1", 2)]), {"farm": {"oepul": {"sanction_level": "r25"}}})
	o6_11.premium_payable == 405 with input as inp
}

test_exclusion_after_two_full_reductions if {
	inp := object.union(farm_input(2026, [m11(2023)], [vineyard("W1", 1)]), {"farm": {"oepul": {"full_reduction_count_in_contract_period": 2}}})
	o6_11.excluded_from_measure with input as inp
	o6_11.premium_payable == 0 with input as inp
}

test_takeover_deadlines if {
	base := farm_input(2026, [m11(2023)], [vineyard("W1", 1)])
	ok := object.union(base, {"farm": {"oepul": {"takeover": {"takeover_date": "2028-04-17", "taking_farm_previously_in_measure": false, "taken_over_area_ha": 2, "expansion_area_ha": 1}}}})
	o6_11.takeover_valid with input as ok
	late := object.union(base, {"farm": {"oepul": {"takeover": {"takeover_date": "2026-04-16", "taking_farm_previously_in_measure": false, "taken_over_area_ha": 2, "expansion_area_ha": 0}}}})
	"Übernahme nach dem 15.04. (2023/2028: 17.04.)" in o6_11.takeover_violations with input as late
	big := object.union(base, {"farm": {"oepul": {"takeover": {"takeover_date": "2026-04-01", "taking_farm_previously_in_measure": true, "taken_over_area_ha": 2, "expansion_area_ha": 1.5}}}})
	count(o6_11.takeover_violations) == 2 with input as big
}

test_area_reduction_no_repayment_for_annual_flexible_measure if {
	inp := object.union(farm_input(2026, [m11(2023)], [vineyard("W1", 1)]), {"farm": {"oepul": {"previous_year_measure_area_ha": 20}}})
	o6_11.annual_area_flexible with input as inp
	o6_11.area_reduction_ha == 19 with input as inp
	not o6_11.area_reduction_repayment_required with input as inp
	not o6_11.area_addition_restricted
}

test_area_reduction_tolerance_formula if {
	o6_11.area_reduction_tolerance_ha(4) == 0.5
	o6_11.area_reduction_tolerance_ha(40) == 2
	o6_11.area_reduction_tolerance_ha(400) == 5
}

test_permanent_circumstance_before_cutoff_withholds_premium if {
	c := {"type": "permanent", "occurrence_date": "2026-03-01", "reported": true}
	inp := object.union(farm_input(2026, [m11(2023)], [vineyard("W1", 1)]), {"farm": {"oepul": {"special_circumstances": [c]}}})
	o6_11.premium_withheld_for_year with input as inp
	c2 := object.union(c, {"occurrence_date": "2026-05-01"})
	inp2 := object.union(inp, {"farm": {"oepul": {"special_circumstances": [c2]}}})
	not o6_11.premium_withheld_for_year with input as inp2
	count(o6_11.unreported_circumstances) == 0 with input as inp2
}

test_temporary_circumstance_conditions_met_keeps_premium if {
	c := {"type": "temporary", "occurrence_date": "2026-03-01", "reported": false, "all_conditions_met_on_changed_areas": true}
	inp := object.union(farm_input(2026, [m11(2023)], [vineyard("W1", 1)]), {"farm": {"oepul": {"special_circumstances": [c]}}})
	not o6_11.premium_withheld_for_year with input as inp
	"O611-GEN-FORCE-MAJEURE" in rule_ids(o6_11.notices) with input as inp
}

test_inspection_refused if {
	inp := object.union(farm_input(2026, [m11(2023)], [vineyard("W1", 1)]), {"farm": {"oepul": {"on_site_inspection_refused": true}}})
	"O611-GEN-CONTROL-REFUSAL" in rule_ids(o6_11.violations) with input as inp
	o6_11.premium_before_modulation == 0 with input as inp
}

test_missing_payment_claim if {
	m := object.union(m11(2023), {"payment_claim_submitted": false, "payment_claim_overdue_more_than_one_year": true})
	inp := farm_input(2026, [m], [vineyard("W1", 1)])
	o6_11.premium_before_modulation == 0 with input as inp
	o6_11.commitment_ended_by_missing_claim with input as inp
}

test_decision_object_shape if {
	inp := farm_input(2026, [m11(2023)], [vineyard("W1", 1), arable("A1", 2)])
	d := o6_11.decision with input as inp
	d.measure == "o6_11"
	d.participates
	d.contract_valid
	d.compliant
	d.premium_payable_eur == 270
	d.parcels.A1.wine_fruit_hop_area == false
}

test_not_participating if {
	inp := farm_input(2026, [], [vineyard("W1", 1)])
	d := o6_11.decision with input as inp
	d.participates == false
	d.contract_valid == false
}

test_op_case_requires_op_code if {
	w1 := with_parcel_field(vineyard("W1", 1), "oepul", {"measures": ["11"], "op_cases": ["commitment_not_full_contract_period"]})
	inp := farm_input(2026, [m11(2023)], [w1, vineyard("W2", 1)])
	"O611-GEN-OP-CODE" in rule_ids(o6_11.violations) with input as inp
	"op_case" in o6_11.parcel_results.W1.no_premium_reasons with input as inp
	w1b := with_parcel_field(vineyard("W1", 1), "oepul", {"measures": ["11"], "op_cases": ["commitment_not_full_contract_period"], "codes": ["OP"]})
	inp2 := farm_input(2026, [m11(2023)], [w1b, vineyard("W2", 1)])
	not "O611-GEN-OP-CODE" in rule_ids(o6_11.violations) with input as inp2
}

test_cap_scope_selection if {
	o6_11.cap_scope({"oepul": {"measures": ["11", "10"]}}) == "general"
	o6_11.cap_scope({"oepul": {"measures": ["18"]}}) == "18_19"
	o6_11.parcel_payment_cap({"oepul": {"measures": ["11"]}}) == 1200 with input as {"farm": {"year": 2023}}
	o6_11.parcel_payment_cap({"oepul": {"measures": ["11"]}}) == 1300 with input as {"farm": {"year": 2026}}
}

test_reduction_order_from_data if {
	order := o6_11.reduction_order
	count(order) == 11
	order[4] == "Inhaltliche Kürzungen (1.12.1.3)"
	order[6] == "Modulation des Prämienausmaßes (1.9.2.2)"
}

test_sanction_then_modulation_then_cap if {
	w1 := with_parcel_field(vineyard("W1", 10), "oepul", {"measures": ["11"], "other_area_payments_eur_per_ha": 1100})
	inp := object.union(farm_input(2026, [m11(2023)], [w1]), {"land": {"total_area_ha": 300}, "farm": {"oepul": {"sanction_level": "r10"}}})

	# 270 * 0.9 = 243; Modulation 300 ha: (200*100 + 100*90)/30000 = 0.96667 -> 234.9 €/ha
	# 234.9 + 1100 = 1334.9 > 1300 -> 234.9 * 1300 / 1334.9 = 228.76 €/ha -> 2287.6 €
	pay := o6_11.parcel_payable.W1 with input as inp
	pay > 2287.5
	pay < 2287.7
	o6_11.premium_after_sanction == 2430 with input as inp
}

test_measure_11_is_multi_year if {
	o6_11.is_multi_year_measure
}

test_advance_payment_max_75_percent if {
	inp := farm_input(2026, [m11(2023)], [vineyard("W1", 2)])
	o6_11.advance_payment_max_eur == 405 with input as inp
}

test_conditionality_notice if {
	inp := object.union(farm_input(2026, [m11(2023)], [vineyard("W1", 1)]), {"farm": {"oepul": {"conditionality_compliant": false}}})
	"O611-GEN-CONDITIONALITY" in rule_ids(o6_11.notices) with input as inp
}
