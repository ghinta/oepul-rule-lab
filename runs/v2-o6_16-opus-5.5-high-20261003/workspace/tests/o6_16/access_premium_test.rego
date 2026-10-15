package oepul.o6_16_test

import data.oepul.o6_16

# --- Basisfall ---
test_base_case_eligible_without_violations if {
	o6_16.access_eligible with input as base_input
	count(o6_16.obligation_violations) == 0 with input as base_input
}

test_base_case_area_aggregation if {
	o6_16.gwa_arable_area_ha == 10.0 with input as base_input
	o6_16.total_arable_area_ha == 13.0 with input as base_input
}

test_base_case_premium_2026 if {
	# Basisprämie 10 ha x 54 + Bildungszuschlag 10 ha x 60 + PSM-Verzicht Mais 4 ha x 21,6
	p := o6_16.premium with input as base_input
	p.components.base == 540
	p.components.training_first_10ha == 600
	p.components.psm_supplements == 86.4
	p.total == 1226.4
}

test_premium_rates_2023 if {
	inp := object.union(with_year(base_input, 2023), {"farm": {"oepul": {"first_oepul_participation_year": 2022}}})
	p := o6_16.premium with input as inp
	p.components.base == 500
	p.components.training_first_10ha == 300
	p.components.psm_supplements == 80
}

# --- Zugangsvoraussetzungen ---
test_min_area_first_year_violation if {
	small := object.union(parcel_wheat, {"area_ha": 1.5})
	inp := with_year(object.union(with_parcels([small]), {"farm": {"oepul": {"o6_16": {"commitment_start_year": 2025, "measure_application_date": "2024-12-20"}}}}), 2025)
	"O616-ACC-001" in rule_ids(o6_16.access_violations) with input as inp
}

test_min_area_not_required_in_following_years if {
	small := object.union(parcel_wheat, {"area_ha": 1.5})
	inp := with_parcels([small])
	not "O616-ACC-001" in rule_ids(o6_16.access_violations) with input as inp
}

test_combination_obligation_missing if {
	inp := object.union(base_input, {"farm": {"oepul": {"participating_measures": ["1A"]}}})
	"O616-ACC-003" in rule_ids(o6_16.access_violations) with input as inp
	o6_16.premium.total == 0 with input as inp
}

test_combination_obligation_with_immergruen if {
	inp := object.union(base_input, {"farm": {"oepul": {"participating_measures": ["7"]}}})
	not "O616-ACC-003" in rule_ids(o6_16.access_violations) with input as inp
}

test_late_measure_application if {
	inp := object.union(base_input, {"farm": {"oepul": {"o6_16": {"measure_application_date": "2023-01-05"}}}})
	"O616-APP-001" in rule_ids(o6_16.access_violations) with input as inp
}

test_no_entry_after_2025 if {
	inp := object.union(base_input, {"farm": {"oepul": {"o6_16": {"commitment_start_year": 2026, "measure_application_date": "2025-12-01"}}}})
	"O616-APP-002" in rule_ids(o6_16.access_violations) with input as inp
}

test_public_body_not_eligible if {
	inp := object.union(base_input, {"farm": {"applicant": {"is_public_body": true}}})
	"O616-GEN-001" in rule_ids(o6_16.access_violations) with input as inp
}

test_public_share_over_25_percent if {
	inp := object.union(base_input, {"farm": {"applicant": {"legal_form": "legal_person", "public_body_share_percent": 30}}})
	"O616-GEN-001" in rule_ids(o6_16.access_violations) with input as inp
}

test_farm_min_size_first_oepul_year if {
	inp := object.union(base_input, {"farm": {"oepul": {"first_oepul_participation_year": 2026}}, "land": {"total_area_ha": 1.2}})
	"O616-GEN-003" in rule_ids(o6_16.access_violations) with input as inp
}

# --- Prämienberechnung ---
test_base_premium_halved_with_organic if {
	inp := object.union(base_input, {"farm": {"oepul": {"participating_measures": ["1B", "6"]}}})
	p := o6_16.premium with input as inp
	p.components.base == 270
	p.components.psm_supplements == 0
}

test_base_premium_halved_with_eeb if {
	inp := object.union(base_input, {"farm": {"oepul": {"participating_measures": ["2", "6"]}}})
	p := o6_16.premium with input as inp
	p.components.base == 270
	p.components.psm_supplements == 86.4
}

test_psm_supplement_not_in_protection_zone if {
	m := object.union(parcel_maize, {"in_water_protection_area": true})
	p := o6_16.premium with input as with_parcels([parcel_wheat, m])
	p.components.psm_supplements == 0
}

test_psm_supplement_rapeseed if {
	r := object.union(parcel_maize, {"crop": {"crop_category": "oilseed", "crop_name": "Raps"}})
	p := o6_16.premium with input as with_parcels([parcel_wheat, r])
	p.components.psm_supplements == 259.2
}

test_training_supplement_limited_to_first_10_ha if {
	big := object.union(parcel_wheat, {"area_ha": 20.0})
	p := o6_16.premium with input as object.union(with_parcels([big]), {"land": {"total_area_ha": 20.0}})
	p.components.training_first_10ha == 600
	p.components.base == 1080
}

test_op_code_no_premium if {
	w := object.union(parcel_wheat, {"codes": ["OP"]})
	p := o6_16.premium with input as with_parcels([w, parcel_maize])
	p.components.base == 216
}

test_area_increase_cap_after_2025 if {
	big := object.union(parcel_wheat, {"area_ha": 20.0})
	inp := object.union(with_parcels([big]), {"farm": {"oepul": {"o6_16": {"premium_area_2025_ha": 8.0}}}, "land": {"total_area_ha": 20.0}})
	o6_16.base_area_ha == 13.0 with input as inp
}

test_area_increase_cap_50_percent if {
	o6_16.area_increase_cap_ha(20.0) == 30.0
	o6_16.area_increase_cap_ha(4.0) == 9.0
}

test_modulation_factor_220_ha if {
	f := o6_16.modulation_factor(220)
	round(f * 10000) == 9909
	o6_16.modulation_factor(150) == 1
}

test_modulation_factor_large_farm if {
	# 200 x 1 + 100 x 0,9 + 700 x 0,85 + 200 x 0,75 = 1035 / 1200
	f := o6_16.modulation_factor(1200)
	round(f * 100000) == 86250
}

test_payment_cap if {
	o6_16.payment_cap_eur_ha(2023) == 1200.0
	o6_16.payment_cap_eur_ha(2026) == 1300.0
}

test_premium_below_minimum if {
	tiny := object.union(parcel_wheat, {"area_ha": 0.3})
	o6_16.premium_below_minimum with input as with_parcels([tiny])
}

test_upper_austria_topup if {
	ooe := object.union(parcel_wheat, {"kg_number": "49001", "n_reduction_zone": "other"})
	inp := object.union(with_parcels([ooe]), {"farm": {"region": {"federal_state": "Oberösterreich"}}})
	p := o6_16.premium with input as inp
	p.components.upper_austria_topup == 194.4
}
