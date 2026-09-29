package oepul.o6_24_test

import data.oepul.o6_24

# --- Fixtures ---------------------------------------------------------------

p_wheat := {
	"parcel_id": "P1",
	"area_ha": 1.0,
	"land_use": "arable",
	"crop": {"crop_category": "cereal", "crop_name": "Winterweichweizen", "usually_harvested_late_summer_or_autumn": false},
	"operations": {
		"fertilizer": {"mineral_n_kg_per_ha": 100, "organic_n_kg_per_ha": 30},
		"harvest_share_percent": 100,
		"fertilization_records_kept": true,
	},
	"measures": ["1A", "24"],
	"oepul_codes": [],
	"wrrl_o6_24": {
		"in_area": true,
		"increased_n_permit": false,
		"duengeklassen": [
			{"klasse": "D", "area_ha": 0.7, "n_limit_kg_per_ha": null},
			{"klasse": "B", "area_ha": 0.3, "n_limit_kg_per_ha": null},
		],
		"n_application_periods_compliant": true,
	},
}

p_maize := {
	"parcel_id": "P2",
	"area_ha": 2.5,
	"land_use": "arable",
	"crop": {"crop_category": "maize", "crop_name": "Körnermais", "usually_harvested_late_summer_or_autumn": true},
	"operations": {
		"fertilizer": {"annual_effective_n_kg_per_ha": 150, "mineral_n_kg_per_ha": 400, "organic_n_kg_per_ha": null},
		"harvest_share_percent": 95,
		"fertilization_records_kept": true,
	},
	"measures": ["24", "6"],
	"oepul_codes": [],
	"wrrl_o6_24": {
		"in_area": true,
		"increased_n_permit": false,
		"duengeklassen": [{"klasse": "C", "area_ha": 2.5, "n_limit_kg_per_ha": 175}],
		"n_application_periods_compliant": true,
	},
}

p_permit := {
	"parcel_id": "P3",
	"area_ha": 0.8,
	"land_use": "arable",
	"crop": {"crop_category": "vegetable", "crop_name": "Kraut"},
	"operations": {"fertilizer": {"annual_effective_n_kg_per_ha": 250}, "harvest_share_percent": 100, "fertilization_records_kept": true},
	"measures": ["24"],
	"oepul_codes": ["OPWRRL"],
	"wrrl_o6_24": {"in_area": true, "increased_n_permit": true, "duengeklassen": [], "n_application_periods_compliant": true},
}

p_grass := {
	"parcel_id": "P4",
	"area_ha": 5.0,
	"land_use": "grassland",
	"crop": {"crop_category": "other", "crop_name": "Mähwiese"},
	"operations": {},
	"measures": ["1A"],
	"oepul_codes": [],
	"wrrl_o6_24": {"in_area": false},
}

base := {
	"farm": {
		"year": 2026,
		"region": {"federal_state": "Steiermark", "district": "Leibnitz"},
		"applicant": {"legal_form": "natural_person", "is_public_body": false, "public_body_share_percent": 0, "is_active_farmer": true},
		"oepul": {"first_participation_year": 2023},
	},
	"land": {"total_area_ha": 30, "protected_cultivation_area_ha": 0, "parcels": [p_wheat, p_maize, p_permit, p_grass]},
	"participation": {
		"o6_24": {"contract_start_year": 2024, "measure_application_date": "2023-12-20", "deregistration_date": null},
		"measures": ["1A", "6", "24"],
	},
	"documentation": {"o6_24_betriebsbuch_stored_on_farm": true},
}

with_parcels(ps) := object.union(base, {"land": {"total_area_ha": 30, "protected_cultivation_area_ha": 0, "parcels": ps}})

with_participation(extra) := object.union(base, {"participation": {"o6_24": object.union(base.participation.o6_24, extra), "measures": base.participation.measures}})

with_year(y) := object.union(base, {"farm": object.union(base.farm, {"year": y})})

violation_codes(d) := {v.code | some v in d.violations}

approx(a, b) if abs(a - b) < 0.0001

# --- Basisfall --------------------------------------------------------------

test_base_case_access_and_premium if {
	d := o6_24.decision with input as base
	d.access.conditions_met == true
	approx(d.access.arable_area_in_area_ha, 4.3)
	d.contract.valid_for_year == true
	d.parcels.eligible_parcel_ids == {"P1", "P2"}
	d.premium.rate_eur_per_ha == 54.0
	approx(d.premium.eligible_area_ha, 3.5)
	d.premium.gross_premium_eur == 189
	d.premium.final_premium_eur == 189
	count(d.violations) == 0
	count(d.missing_inputs) == 0
	d.contract.renews_automatically_next_year == true
	d.contract.period == {"start": "2026-01-01", "end": "2026-12-31"}
}

test_rate_2023_is_50 if {
	o6_24.rate_eur_per_ha == 50.0 with input as with_year(2023)
}

test_rate_from_2024_is_54 if {
	o6_24.rate_eur_per_ha == 54.0 with input as with_year(2024)
	o6_24.rate_eur_per_ha == 54.0 with input as with_year(2028)
}

# --- Mindestteilnahme -------------------------------------------------------

test_minimum_area_not_met_contract_lapses if {
	small := object.union(p_maize, {"area_ha": 1.5})
	d := o6_24.decision with input as with_parcels([small])
	d.access.minimum_participation_met == false
	"minimum_arable_area_in_area_not_met" in d.access.failures
	d.contract.valid_for_year == false
	d.contract.lapses == true
	d.contract.new_measure_application_required_for_next_year == true
	d.contract.renews_automatically_next_year == false
	d.premium.final_premium_eur == 0
}

test_minimum_area_exactly_two_ha_met if {
	two := object.union(p_maize, {"area_ha": 2.0})
	o6_24.minimum_participation_met with input as with_parcels([two])
}

test_minimum_area_counts_permit_parcels_in_area if {
	# 1,5 ha förderfähig + 0,8 ha mit Bewilligung = 2,3 ha Ackerfläche im Gebiet
	small := object.union(p_maize, {"area_ha": 1.5})
	o6_24.minimum_participation_met with input as with_parcels([small, p_permit])
}

test_area_outside_region_not_counted if {
	outside := object.union(p_maize, {"area_ha": 10, "wrrl_o6_24": object.union(p_maize.wrrl_o6_24, {"in_area": false})})
	not o6_24.minimum_participation_met with input as with_parcels([outside])
}

# --- Düngeobergrenzen -------------------------------------------------------

test_weighted_limit_example_from_information_sheet if {
	lim := o6_24.parcel_n_limit_kg_per_ha(p_wheat) with input as base
	approx(lim, 133.2)
}

test_unassigned_area_is_class_c if {
	o6_24.entry_class({"klasse": null, "area_ha": 1}) == "C" with input as base
	o6_24.entry_class({"area_ha": 1}) == "C" with input as base
}

test_n_limit_exceeded_is_violation if {
	heavy := object.union(p_wheat, {"operations": object.union(p_wheat.operations, {"fertilizer": {"mineral_n_kg_per_ha": 120, "organic_n_kg_per_ha": 30}})})
	d := o6_24.decision with input as with_parcels([heavy, p_maize])
	some v in d.violations
	v.code == "n_limit_exceeded"
	v.parcel_id == "P1"
	v.limit_n_kg_per_ha == 133.2
}

test_annual_effective_n_takes_precedence if {
	o6_24.parcel_applied_n_kg_per_ha(p_maize) == 150 with input as base
}

test_separate_subparcels_use_own_class if {
	d_part := object.union(p_wheat, {"parcel_id": "P1a", "area_ha": 0.7, "wrrl_o6_24": object.union(p_wheat.wrrl_o6_24, {"duengeklassen": [{"klasse": "D", "area_ha": 0.7, "n_limit_kg_per_ha": null}]}), "operations": object.union(p_wheat.operations, {"fertilizer": {"annual_effective_n_kg_per_ha": 144}})})
	o6_24.parcel_n_limit_kg_per_ha(d_part) == 144 with input as base
	d := o6_24.decision with input as with_parcels([d_part, p_maize])
	not "n_limit_exceeded" in violation_codes(d)
}

test_missing_class_limit_reported if {
	unknown := object.union(p_maize, {"wrrl_o6_24": object.union(p_maize.wrrl_o6_24, {"duengeklassen": [{"klasse": "A", "area_ha": 2.5, "n_limit_kg_per_ha": null}]})})
	d := o6_24.decision with input as with_parcels([unknown])
	"land.parcels[P2].wrrl_o6_24.duengeklassen" in d.missing_inputs
	not "n_limit_exceeded" in violation_codes(d)
}

test_application_period_violation if {
	late := object.union(p_maize, {"wrrl_o6_24": object.union(p_maize.wrrl_o6_24, {"n_application_periods_compliant": false})})
	d := o6_24.decision with input as with_parcels([late])
	"n_application_period_violated" in violation_codes(d)
}

# --- Aufzeichnungen ---------------------------------------------------------

test_records_missing_even_without_fertilization if {
	unfertilized := object.union(p_maize, {"operations": {"fertilizer": {"annual_effective_n_kg_per_ha": 0}, "harvest_share_percent": 100, "fertilization_records_kept": false}})
	d := o6_24.decision with input as with_parcels([unfertilized])
	"betriebsbuch_parcel_records_missing" in violation_codes(d)
}

test_betriebsbuch_not_on_farm if {
	inp := object.union(base, {"documentation": {"o6_24_betriebsbuch_stored_on_farm": false}})
	d := o6_24.decision with input as inp
	"betriebsbuch_not_stored_on_farm" in violation_codes(d)
}

# --- Codierung / nicht förderfähige Flächen ---------------------------------

test_permit_parcel_requires_opwrrl_and_no_premium if {
	d := o6_24.decision with input as base
	"P3" in d.parcels.opwrrl_coding_required
	not "P3" in d.parcels.eligible_parcel_ids
	not "opwrrl_code_missing" in violation_codes(d)
}

test_permit_parcel_without_code_is_violation if {
	uncoded := object.union(p_permit, {"oepul_codes": []})
	d := o6_24.decision with input as with_parcels([p_maize, uncoded])
	"opwrrl_code_missing" in violation_codes(d)
}

test_fallow_not_eligible_and_requires_code if {
	fallow := object.union(p_maize, {"parcel_id": "P5", "crop": {"crop_category": "fallow", "crop_name": "Ackerbrache"}})
	d := o6_24.decision with input as with_parcels([p_maize, fallow])
	not "P5" in d.parcels.eligible_parcel_ids
	"P5" in d.parcels.opwrrl_coding_required
}

test_op_code_excludes_premium if {
	coded := object.union(p_maize, {"oepul_codes": ["OP"]})
	d := o6_24.decision with input as with_parcels([coded])
	not "P2" in d.parcels.eligible_parcel_ids
}

test_trial_area_vf_excludes_premium if {
	coded := object.union(p_maize, {"oepul_codes": ["VF"]})
	d := o6_24.decision with input as with_parcels([coded])
	not "P2" in d.parcels.eligible_parcel_ids
}

test_non_eligible_crop_excluded if {
	energy := object.union(p_maize, {"crop": {"crop_category": "other", "crop_name": "Energieholz"}})
	d := o6_24.decision with input as with_parcels([energy])
	d.parcels.eligible_parcel_ids == set()
}

test_parcel_not_declared_for_measure_excluded if {
	undeclared := object.union(p_maize, {"measures": ["6"]})
	d := o6_24.decision with input as with_parcels([undeclared])
	d.parcels.eligible_parcel_ids == set()
}

test_national_park_parcel_keeps_premium if {
	np := object.union(p_maize, {"in_national_park": true})
	d := o6_24.decision with input as with_parcels([np])
	"P2" in d.parcels.national_park_parcels_with_premium
	d.premium.final_premium_eur == 135
}

test_statutory_overlap_needs_no_op_code if {
	stat := object.union(p_maize, {"wrrl_o6_24": object.union(p_maize.wrrl_o6_24, {"public_funding_overlap": "statutory"})})
	d := o6_24.decision with input as with_parcels([stat])
	"P2" in d.parcels.eligible_parcel_ids
	not "op_code_missing_overlap" in violation_codes(d)
}

test_public_agreement_overlap_requires_op_code if {
	agr := object.union(p_maize, {"wrrl_o6_24": object.union(p_maize.wrrl_o6_24, {"public_funding_overlap": "public_agreement"})})
	d := o6_24.decision with input as with_parcels([agr])
	"op_code_missing_overlap" in violation_codes(d)
	not "P2" in d.parcels.eligible_parcel_ids
}

# --- Mindestbewirtschaftung / Dürre 2026 ------------------------------------

test_harvest_below_85_percent_without_code_violation if {
	poor := object.union(p_maize, {"operations": object.union(p_maize.operations, {"harvest_share_percent": 60})})
	d := o6_24.decision with input as with_parcels([poor])
	"harvest_obligation_not_met_without_op_code" in violation_codes(d)
	not "P2" in d.parcels.eligible_parcel_ids
}

test_drought_2026_waiver_in_leibnitz if {
	dry := object.union(p_maize, {"operations": object.union(p_maize.operations, {"harvest_share_percent": 0, "no_harvestable_stand_due_to_drought": true})})
	d := o6_24.decision with input as with_parcels([dry])
	not "harvest_obligation_not_met_without_op_code" in violation_codes(d)
	"P2" in d.parcels.eligible_parcel_ids
}

test_drought_waiver_not_in_2025 if {
	dry := object.union(p_maize, {"operations": object.union(p_maize.operations, {"harvest_share_percent": 0, "no_harvestable_stand_due_to_drought": true})})
	inp := object.union(with_parcels([dry]), {"farm": object.union(base.farm, {"year": 2025})})
	d := o6_24.decision with input as inp
	"harvest_obligation_not_met_without_op_code" in violation_codes(d)
}

test_drought_waiver_not_in_unlisted_district if {
	dry := object.union(p_maize, {"district": "Murau", "operations": object.union(p_maize.operations, {"harvest_share_percent": 0, "no_harvestable_stand_due_to_drought": true})})
	d := o6_24.decision with input as with_parcels([dry])
	"harvest_obligation_not_met_without_op_code" in violation_codes(d)
}

test_drought_waiver_requires_late_harvest_crop if {
	dry := object.union(p_wheat, {"operations": object.union(p_wheat.operations, {"harvest_share_percent": 0, "no_harvestable_stand_due_to_drought": true})})
	d := o6_24.decision with input as with_parcels([dry, p_maize])
	"harvest_obligation_not_met_without_op_code" in violation_codes(d)
}

test_drought_waiver_burgenland_all_districts if {
	p := object.union(p_maize, {"federal_state": "Burgenland", "district": "Oberwart"})
	o6_24.drought_region_match(p) with input as base
}

test_ackerfutter_requires_mowing_or_grazing if {
	clover := object.union(p_maize, {"crop": {"crop_category": "legume", "crop_name": "Kleegras"}, "operations": {"fertilizer": {"annual_effective_n_kg_per_ha": 0}, "cutting_dates": [], "fertilization_records_kept": true}})
	d := o6_24.decision with input as with_parcels([clover])
	"ackerfutter_min_use_not_met" in violation_codes(d)
	mown := object.union(clover, {"operations": object.union(clover.operations, {"cutting_dates": ["2026-06-01"]})})
	d2 := o6_24.decision with input as with_parcels([mown])
	not "ackerfutter_min_use_not_met" in violation_codes(d2)
	"P2" in d2.parcels.eligible_parcel_ids
}

# --- Kombination ------------------------------------------------------------

test_combination_with_naturschutz_conflicts if {
	nat := object.union(p_maize, {"measures": ["24", "18"]})
	d := o6_24.decision with input as with_parcels([nat])
	{"parcel_id": "P2", "measure": "18"} in d.contract.combination_conflicts
	not "P2" in d.parcels.eligible_parcel_ids
}

test_combination_with_ubb_zwischenfrucht_ok if {
	d := o6_24.decision with input as base
	count(d.contract.combination_conflicts) == 0
}

test_combination_table_complete if {
	count(data.o6_24.combinations.o6_24_row) == 20
	o6_24.combinable_codes == {"1A", "1B", "2", "3", "6", "7", "8", "9", "16"}
}

test_no_farm_level_exclusion_for_24 if {
	inp := object.union(base, {"participation": {"o6_24": base.participation.o6_24, "measures": ["1B", "7", "24"]}})
	o6_24.farm_level_exclusion_conflicts == set() with input as inp
}

# --- Förderwerbende Person / Betriebsmindestgröße ----------------------------

test_public_body_not_eligible if {
	inp := object.union(base, {"farm": object.union(base.farm, {"applicant": object.union(base.farm.applicant, {"is_public_body": true})})})
	d := o6_24.decision with input as inp
	"applicant_not_eligible" in d.access.failures
	d.premium.final_premium_eur == 0
}

test_public_body_share_above_25_not_eligible if {
	inp := object.union(base, {"farm": object.union(base.farm, {"applicant": object.union(base.farm.applicant, {"legal_form": "legal_person", "public_body_share_percent": 26})})})
	not o6_24.applicant_eligible with input as inp
	inp2 := object.union(base, {"farm": object.union(base.farm, {"applicant": object.union(base.farm.applicant, {"legal_form": "legal_person", "public_body_share_percent": 25})})})
	o6_24.applicant_eligible with input as inp2
}

test_non_active_farmer_not_eligible if {
	inp := object.union(base, {"farm": object.union(base.farm, {"applicant": object.union(base.farm.applicant, {"is_active_farmer": false})})})
	not o6_24.applicant_eligible with input as inp
}

test_first_year_farm_min_size if {
	inp := object.union(base, {
		"farm": object.union(base.farm, {"oepul": {"first_participation_year": 2026}}),
		"land": {"total_area_ha": 1.4, "protected_cultivation_area_ha": 0, "parcels": base.land.parcels},
	})
	not o6_24.farm_min_size_met with input as inp
	inp2 := object.union(inp, {"land": {"total_area_ha": 1.4, "protected_cultivation_area_ha": 0.5, "parcels": base.land.parcels}})
	o6_24.farm_min_size_met with input as inp2
}

test_farm_min_size_not_required_after_first_year if {
	inp := object.union(base, {"land": {"total_area_ha": 1.0, "protected_cultivation_area_ha": 0, "parcels": base.land.parcels}})
	o6_24.farm_min_size_met with input as inp
}

# --- Beantragung / Vertrag --------------------------------------------------

test_application_after_31_december_not_timely if {
	d := o6_24.decision with input as with_participation({"contract_start_year": 2026, "measure_application_date": "2026-01-02"})
	"measure_application_not_timely" in d.access.failures
	d.contract.valid_for_year == false
}

test_application_on_31_december_timely if {
	o6_24.application_timely with input as with_participation({"contract_start_year": 2026, "measure_application_date": "2025-12-31"})
}

test_last_entry_2027 if {
	o6_24.entry_year_allowed with input as with_participation({"contract_start_year": 2027, "measure_application_date": "2026-12-31"})
	inp := object.union(with_participation({"contract_start_year": 2028, "measure_application_date": "2027-12-31"}), {"farm": object.union(base.farm, {"year": 2028})})
	not o6_24.entry_year_allowed with input as inp
}

test_deregistration_within_year_invalidates_year if {
	d := o6_24.decision with input as with_participation({"deregistration_date": "2026-11-30"})
	d.contract.valid_for_year == false
	d.premium.final_premium_eur == 0
	d.contract.new_measure_application_required_for_next_year == true
}

test_deregistration_next_year_keeps_current_year if {
	d := o6_24.decision with input as with_participation({"deregistration_date": "2027-01-01"})
	d.contract.valid_for_year == true
	d.premium.final_premium_eur == 189
	o6_24.earliest_deregistration_date_keeping_year == "2027-01-01" with input as base
}

test_one_year_measure_characteristics if {
	d := o6_24.decision with input as base
	o6_24.is_one_year_measure with input as base
	d.contract.multi_year_repayment_applicable == false
	d.contract.area_reduction_tolerance_applicable == false
	d.contract.area_increase_premium_restricted == false
	not o6_24.conversion_available with input as base
}

test_control_refusal_blocks_premium if {
	d := o6_24.decision with input as with_participation({"control_refused": true})
	d.contract.valid_for_year == false
	d.premium.final_premium_eur == 0
}

test_takeover_deadline if {
	o6_24.takeover_deadline(2026) == "2026-04-15" with input as base
	o6_24.takeover_deadline(2028) == "2028-04-17" with input as base
	o6_24.takeover_deadline(2023) == "2023-04-17" with input as base
}

test_takeover_checks if {
	ok := {"date": "2026-04-10", "taken_over_area_ha": 10, "additional_area_ha": 5, "taker_already_participating": false, "ama_approved": true}
	o6_24.takeover_allowed with input as with_participation({"takeover": ok})
	late := object.union(ok, {"date": "2026-04-16", "additional_area_ha": 6})
	f := o6_24.takeover_failures with input as with_participation({"takeover": late})
	f == {"takeover_after_deadline", "takeover_extension_exceeds_50_percent"}
}

test_circumstance_before_15_april_blocks_premium if {
	d := o6_24.decision with input as with_participation({"circumstance": {"date": "2026-03-01", "force_majeure": false, "reported": true}})
	d.premium.circumstance_premium_blocked == true
	d.premium.final_premium_eur == 0
	d2 := o6_24.decision with input as with_participation({"circumstance": {"date": "2026-05-01", "force_majeure": false, "reported": true}})
	d2.premium.final_premium_eur == 189
	d3 := o6_24.decision with input as with_participation({"circumstance": {"date": "2026-03-01", "force_majeure": true, "reported": true}})
	d3.premium.final_premium_eur == 189
}

# --- Prämienberechnung ------------------------------------------------------

test_modulation_example_220_ha if {
	f := o6_24.modulation_factor(220) with input as base
	approx(f, 218 / 220)
	o6_24.round2(f * 100) == 99.09 with input as base
}

test_modulation_tiers if {
	o6_24.modulation_factor(200) == 1 with input as base
	approx(o6_24.modulation_factor(300), 290 / 300) with input as base
	approx(o6_24.modulation_factor(1000), 885 / 1000) with input as base
	approx(o6_24.modulation_factor(1200), 1035 / 1200) with input as base
}

test_modulated_premium if {
	inp := object.union(base, {"land": {"total_area_ha": 220, "protected_cultivation_area_ha": 0, "parcels": base.land.parcels}})
	d := o6_24.decision with input as inp
	d.premium.final_premium_eur == o6_24.round2((189 * 218) / 220) with input as inp
}

test_sanction_steps if {
	d := o6_24.decision with input as with_participation({"sanction_step": "reduction_5"})
	d.premium.sanction_percent == 5
	approx(d.premium.final_premium_eur, 179.55)
	o6_24.sanction_reduction_percent("warning", 2026) == 0 with input as base
	o6_24.sanction_reduction_percent("warning", 2027) == 1 with input as base
}

test_exclusion_no_premium if {
	d := o6_24.decision with input as with_participation({"sanction_step": "exclusion"})
	d.premium.granted == false
	d.premium.final_premium_eur == 0
}

test_area_cap_exceeded if {
	capped := object.union(p_maize, {"wrrl_o6_24": object.union(p_maize.wrrl_o6_24, {"other_area_payments_eur_per_ha": 1280})})
	d := o6_24.decision with input as with_parcels([capped])
	some x in d.premium.area_cap_exceedances
	x.parcel_id == "P2"
	x.excess_eur_per_ha == 34
	share := (34 * 54) / 1334
	approx(d.premium.final_premium_eur, o6_24.round2(135 - (2.5 * share)))
}

test_area_cap_2023_is_1200 if {
	o6_24.standard_area_cap_eur_per_ha == 1200.0 with input as with_year(2023)
	o6_24.standard_area_cap_eur_per_ha == 1300.0 with input as with_year(2026)
}

test_small_payout_may_be_withheld if {
	tiny := object.union(p_maize, {"area_ha": 0.5})
	coded := object.union(p_maize, {"parcel_id": "P9", "area_ha": 1.6, "oepul_codes": ["OP"]})
	d := o6_24.decision with input as with_parcels([tiny, coded])
	d.premium.final_premium_eur == 27
	d.premium.payout_may_be_withheld == true
}

test_payout_deadline_and_advance if {
	d := o6_24.decision with input as base
	d.premium.payout_deadline == "2027-06-30"
	d.premium.max_advance_payment_eur == 141.75
}

test_conditionality_breach_flagged if {
	inp := object.union(base, {"compliance": {"conditionality_breach": true}})
	d := o6_24.decision with input as inp
	d.premium.conditionality_breach == true
}
