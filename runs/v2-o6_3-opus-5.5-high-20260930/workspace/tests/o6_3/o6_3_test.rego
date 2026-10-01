package o6_3_test

import data.o6_3

# Basisfall: Beispiel aus dem Merkblatt Kap. 7 (8 ha Mähwiese, 2 ha Dauerweide, 3 ha Kleegras, 5 RGVE).
base_input := {
	"farm": {
		"year": 2026,
		"applicant": {"legal_form": "natural_person", "is_active_farmer": true},
		"oepul": {
			"first_participation_year": 2024,
			"participating_measures": ["o6_1a", "o6_3"],
			"o6_3": {
				"contract_start_year": 2024,
				"measure_application_date": "2023-12-15",
				"option_no_mower_conditioner": {"applied": false},
			},
		},
		"feeding": {
			"silage_produced": false,
			"silage_fed": false,
			"silage_stored": false,
			"green_feeding": {
				"eingrasen_or_pasture_days_apr_sep": 120,
				"communal_pasture_or_alm_days_apr_sep": 0,
				"all_roughage_animals_included": true,
			},
			"feedstuffs": [{"name": "Flüssigmelasse", "feed_id": "fluessigmelasse", "fermentation_in_production": false}],
		},
		"forage_transfers": [{"form": "dry_hay", "recipient_is_hay_farm": false}],
		"machinery": {"mower_conditioner_present": true, "mower_conditioner_used": true},
	},
	"land": {
		"total_area_ha": 13,
		"parcels": [
			{"parcel_id": "G1", "area_ha": 8, "land_use": "grassland", "grassland_type": "maehwiese_maehweide", "crop": {}, "operations": {"cutting_dates": ["2026-06-01", "2026-08-01"]}},
			{"parcel_id": "G2", "area_ha": 2, "land_use": "grassland", "grassland_type": "dauerweide", "crop": {}, "operations": {"cutting_dates": [], "grazed": true}},
			{"parcel_id": "A1", "area_ha": 3, "land_use": "arable", "crop": {"crop_category": "other", "forage_crop_type": "kleegras", "is_second_crop": false}, "operations": {"cutting_dates": ["2026-06-10"]}},
		],
	},
	"livestock": {
		"has_livestock": true,
		"species_groups": [{"species": "cattle", "rgve_category": "cattle_2y_plus", "animal_count": 5, "kept_in_austria": true}],
	},
}

with_farm(patch) := object.union(base_input, {"farm": object.union(base_input.farm, patch)})

with_o6_3(patch) := with_farm({"oepul": object.union(base_input.farm.oepul, {"o6_3": object.union(base_input.farm.oepul.o6_3, patch)})})

with_parcels(ps) := object.union(base_input, {"land": object.union(base_input.land, {"parcels": ps})})

test_merkblatt_example_livestock_density if {
	d := o6_3.livestock_density with input as base_input
	d > 0.38
	d < 0.39
	o6_3.is_livestock_farm with input as base_input
}

test_merkblatt_example_premium if {
	o6_3.eligible_area_ha == 11 with input as base_input
	o6_3.current_rate == 145.8 with input as base_input
	o6_3.premium_gross_eur == 1603.8 with input as base_input
}

test_rate_2023 if {
	inp := object.union(with_o6_3({"contract_start_year": 2023, "measure_application_date": "2022-12-01"}), {"farm": object.union(base_input.farm, {"year": 2023, "oepul": object.union(base_input.farm.oepul, {"o6_3": object.union(base_input.farm.oepul.o6_3, {"contract_start_year": 2023, "measure_application_date": "2022-12-01"})})})})
	o6_3.current_rate == 135.0 with input as inp
}

test_option_no_mower_conditioner_rate_and_violation if {
	inp := with_o6_3({"option_no_mower_conditioner": {"applied": true, "marked_in_mfa_details": true}})
	o6_3.current_rate == 167.4 with input as inp
	"O6_3-OPT-01" in o6_3.violation_rule_ids with input as inp
}

test_option_without_mower_ok if {
	inp := object.union(
		with_o6_3({"option_no_mower_conditioner": {"applied": true, "marked_in_mfa_details": true}}),
		{"farm": object.union(base_input.farm, {
			"machinery": {"mower_conditioner_present": false, "mower_conditioner_used": false},
			"oepul": object.union(base_input.farm.oepul, {"o6_3": object.union(base_input.farm.oepul.o6_3, {"option_no_mower_conditioner": {"applied": true, "marked_in_mfa_details": true}})}),
		})},
	)
	not "O6_3-OPT-01" in o6_3.violation_rule_ids with input as inp
	o6_3.premium_gross_eur == 1841.4 with input as inp
}

test_option_requires_mfa_cross if {
	inp := with_o6_3({"option_no_mower_conditioner": {"applied": true, "marked_in_mfa_details": false}})
	"O6_3-APP-03" in o6_3.option_application_issues with input as inp
	o6_3.current_rate == 145.8 with input as inp
}

test_non_livestock_later_year_zero_premium_but_obligations if {
	inp := object.union(base_input, {"livestock": {"has_livestock": true, "species_groups": [{"rgve_category": "cattle_2y_plus", "animal_count": 3}]}})
	not o6_3.is_livestock_farm with input as inp
	o6_3.current_rate == 0 with input as inp
	o6_3.premium_gross_eur == 0 with input as inp
	count(o6_3.access_requirement_failures) == 0 with input as inp
	o6_3.obligations_apply with input as inp
}

first_year_input := with_farm({
	"year": 2024,
	"oepul": object.union(base_input.farm.oepul, {"first_participation_year": 2024}),
})

test_first_year_contract_established if {
	o6_3.contract_established with input as first_year_input
	o6_3.premium_gross_eur > 0 with input as first_year_input
}

test_first_year_non_livestock_no_contract if {
	inp := object.union(first_year_input, {"livestock": {"species_groups": [{"rgve_category": "sheep_1y_plus", "animal_count": 10}]}})
	"O6_3-LH-01" in o6_3.access_requirement_failures with input as inp
	o6_3.no_contract_first_year with input as inp
	o6_3.premium_gross_eur == 0 with input as inp
}

test_first_year_min_area_excludes_streuwiese_bergmaehder if {
	ps := [
		{"parcel_id": "G1", "area_ha": 1.5, "land_use": "grassland", "grassland_type": "maehwiese_maehweide", "operations": {"cutting_dates": ["2024-06-01"]}},
		{"parcel_id": "G2", "area_ha": 3, "land_use": "grassland", "grassland_type": "streuwiese", "operations": {"cutting_dates": ["2024-09-01"]}},
		{"parcel_id": "G3", "area_ha": 3, "land_use": "grassland", "grassland_type": "bergmaehder", "operations": {"cutting_dates": ["2024-08-01"]}},
	]
	inp := object.union(first_year_input, {"land": {"total_area_ha": 7.5, "parcels": ps}, "livestock": {"species_groups": [{"rgve_category": "cattle_2y_plus", "animal_count": 5}]}})
	o6_3.min_participation_area_ha == 1.5 with input as inp
	"O6_3-MIN-01" in o6_3.access_requirement_failures with input as inp
}

test_min_area_counts_naturschutz_grassland_but_no_premium if {
	ps := [
		{"parcel_id": "G1", "area_ha": 1, "land_use": "grassland", "grassland_type": "maehwiese_maehweide", "operations": {"cutting_dates": ["2024-06-01"]}},
		{"parcel_id": "N1", "area_ha": 1.2, "land_use": "grassland", "grassland_type": "maehwiese_maehweide", "enrolled_measures": ["o6_18"], "operations": {"cutting_dates": ["2024-07-01"]}},
	]
	inp := object.union(first_year_input, {"land": {"total_area_ha": 2.2, "parcels": ps}})
	o6_3.min_participation_area_met with input as inp
	o6_3.eligible_area_ha == 1 with input as inp
	o6_3.naturschutz_gm01_surcharge_eur_per_ha == 108 with input as inp
}

test_following_year_below_two_ha_allowed if {
	ps := [{"parcel_id": "G1", "area_ha": 1, "land_use": "grassland", "grassland_type": "maehwiese_maehweide", "operations": {"cutting_dates": ["2026-06-01"]}}]
	inp := object.union(base_input, {"land": {"total_area_ha": 1, "parcels": ps}, "livestock": {"species_groups": [{"rgve_category": "cattle_2y_plus", "animal_count": 1}]}})
	not "O6_3-MIN-01" in o6_3.access_requirement_failures with input as inp
	o6_3.premium_gross_eur == 145.8 with input as inp
}

test_combination_obligation_missing if {
	inp := with_farm({"oepul": object.union(base_input.farm.oepul, {"participating_measures": ["o6_3"]})})
	"O6_3-COMB-01" in o6_3.access_requirement_failures with input as inp
	o6_3.premium_gross_eur == 0 with input as inp
}

test_bio_teilbetrieb_satisfies_combination if {
	inp := with_farm({"oepul": object.union(base_input.farm.oepul, {"participating_measures": ["o6_1b_teilbetrieb", "o6_3"]})})
	o6_3.combination_obligation_met with input as inp
}

test_ubb_and_bio_excluded_without_teilbetrieb if {
	inp := with_farm({"oepul": object.union(base_input.farm.oepul, {"participating_measures": ["o6_1a", "o6_1b", "o6_3"]})})
	"SRL-COMB-02" in o6_3.access_requirement_failures with input as inp
}

test_silage_violations if {
	inp := with_farm({"feeding": object.union(base_input.farm.feeding, {"silage_produced": true, "silage_stored": true, "haylage_or_fermented_hay_produced": true, "non_storable_without_foil_pressed": true})})
	ids := o6_3.violation_rule_ids with input as inp
	"O6_3-OBL-01" in ids
	"O6_3-OBL-06" in ids
	"O6_3-OBL-11" in ids
	"O6_3-OBL-02" in ids
}

test_fermented_byproducts_not_permitted if {
	inp := with_farm({"feeding": object.union(base_input.farm.feeding, {"feedstuffs": [
		{"name": "Biertreber", "feed_id": "biertreber"},
		{"name": "Rüben-Schnitzelpellets", "feed_id": "rueben_schnitzelpellets", "fermentation_in_production": false},
	]})})
	vs := o6_3.violations with input as inp
	count([v | some v in vs; v.rule_id == "O6_3-OBL-04"]) == 1
}

test_green_feeding_majority_required if {
	inp := with_farm({"feeding": object.union(base_input.farm.feeding, {"green_feeding": {"eingrasen_or_pasture_days_apr_sep": 60, "communal_pasture_or_alm_days_apr_sep": 30, "all_roughage_animals_included": true}})})
	"O6_3-OBL-05" in o6_3.violation_rule_ids with input as inp
}

test_alm_days_count_for_green_feeding if {
	inp := with_farm({"feeding": object.union(base_input.farm.feeding, {"green_feeding": {"eingrasen_or_pasture_days_apr_sep": 40, "communal_pasture_or_alm_days_apr_sep": 80, "all_roughage_animals_included": true}})})
	not "O6_3-OBL-05" in o6_3.violation_rule_ids with input as inp
}

test_forage_transfer_rules if {
	inp := with_farm({"forage_transfers": [
		{"form": "green_forage", "recipient_is_hay_farm": true},
		{"form": "dry_hay", "one_time_tedding_then_removed": true},
	]})
	ids := o6_3.violation_rule_ids with input as inp
	"O6_3-OBL-07" in ids
	"O6_3-OBL-10" in ids
	"O6_3-OBL-08" in ids
}

test_second_crop_forage_not_counted if {
	ps := [
		{"parcel_id": "G1", "area_ha": 8, "land_use": "grassland", "grassland_type": "maehwiese_maehweide", "operations": {"cutting_dates": ["2026-06-01"]}},
		{"parcel_id": "A2", "area_ha": 4, "land_use": "arable", "crop": {"forage_crop_type": "klee", "is_second_crop": true}, "operations": {"cutting_dates": ["2026-09-01"]}},
	]
	inp := object.union(base_input, {"land": {"total_area_ha": 12, "parcels": ps}})
	o6_3.forage_area_ha == 8 with input as inp
	o6_3.eligible_area_ha == 8 with input as inp
}

test_ackerweide_counts_for_density_not_premium if {
	ps := [
		{"parcel_id": "G1", "area_ha": 8, "land_use": "grassland", "grassland_type": "maehwiese_maehweide", "operations": {"cutting_dates": ["2026-06-01"]}},
		{"parcel_id": "A3", "area_ha": 2, "land_use": "arable", "crop": {"forage_crop_type": "ackerweide"}, "operations": {"cutting_dates": ["2026-06-01"], "grazed": true}},
	]
	inp := object.union(base_input, {"land": {"total_area_ha": 10, "parcels": ps}})
	o6_3.forage_area_ha == 10 with input as inp
	o6_3.eligible_area_ha == 8 with input as inp
}

test_animals_abroad_not_counted if {
	inp := object.union(base_input, {"livestock": {"species_groups": [
		{"rgve_category": "cattle_2y_plus", "animal_count": 5, "kept_in_austria": false},
		{"rgve_category": "sheep_1y_plus", "animal_count": 10},
	]}})
	o6_3.total_rgve == 1.5 with input as inp
}

test_pigs_not_rgve if {
	inp := object.union(base_input, {"livestock": {"species_groups": [{"rgve_category": "pigs_breeding_sows_50kg_plus", "animal_count": 50}]}})
	o6_3.total_rgve == 0 with input as inp
}

test_average_count_preferred if {
	inp := object.union(base_input, {"livestock": {"species_groups": [{"rgve_category": "cattle_6m_to_2y", "animal_count": 10, "average_count": 5}]}})
	o6_3.total_rgve == 3 with input as inp
}

test_op_and_national_park_parcels_excluded if {
	ps := [
		{"parcel_id": "G1", "area_ha": 8, "land_use": "grassland", "grassland_type": "maehwiese_maehweide", "operations": {"cutting_dates": ["2026-06-01"]}},
		{"parcel_id": "G4", "area_ha": 1, "land_use": "grassland", "grassland_type": "maehwiese_maehweide", "oepul_codes": ["OP"], "operations": {"cutting_dates": ["2026-06-01"]}},
		{"parcel_id": "G5", "area_ha": 1, "land_use": "grassland", "grassland_type": "maehwiese_maehweide", "national_park": {"name": "Donau-Auen"}, "operations": {"cutting_dates": ["2026-06-01"]}},
		{"parcel_id": "G6", "area_ha": 1, "land_use": "grassland", "grassland_type": "maehwiese_maehweide", "enrolled_measures": ["o6_4"], "operations": {"cutting_dates": ["2026-06-01"]}},
	]
	inp := object.union(base_input, {"land": {"total_area_ha": 11, "parcels": ps}})
	o6_3.eligible_area_ha == 8 with input as inp
}

test_combinable_with_ubb_on_parcel if {
	o6_3.single_parcel_combinable("o6_3", "o6_1a")
	o6_3.single_parcel_combinable("o6_3", "o6_17")
	not o6_3.single_parcel_combinable("o6_3", "o6_18")
	not o6_3.single_parcel_combinable("o6_3", "o6_8")
}

test_anhang_l_row_3_complete if {
	row := {c.col | some c in data.o6_3.combination_table.cells; c.row == "3"}
	row == {"1A", "1B", "2", "6", "7", "9", "16", "17", "24"}
}

test_modulation_example_220_ha if {
	f := o6_3.modulation_factor(220)
	f > 0.9909
	f < 0.9910
	o6_3.modulation_factor(150) == 1
}

test_area_increase_limited_from_2026 if {
	inp := with_o6_3({"area_change": {"base_2025_grassland_measure_area_ha": 4}})
	o6_3.allowed_grassland_increase_ha == 5 with input as inp
	o6_3.eligible_grassland_area_ha == 8 with input as inp
	inp2 := with_o6_3({"area_change": {"base_2025_grassland_measure_area_ha": 2}})
	o6_3.eligible_grassland_area_ha == 7 with input as inp2
}

test_area_decrease_tolerance if {
	o6_3.allowed_decrease_ha(8) == 0.5
	o6_3.allowed_decrease_ha(40) == 2
	o6_3.allowed_decrease_ha(200) == 5
	inp := with_o6_3({"area_change": {"previous_year_grassland_measure_area_ha": 10, "current_grassland_measure_area_ha": 8}})
	o6_3.area_decrease_repayment_required with input as inp
	o6_3.area_decrease_repayment_ha == 2 with input as inp
	inp2 := with_o6_3({"area_change": {"previous_year_grassland_measure_area_ha": 10, "current_grassland_measure_area_ha": 8, "decrease_loss_of_disposal_ha": 2}})
	not o6_3.area_decrease_repayment_required with input as inp2
}

test_late_application_and_last_entry if {
	inp := object.union(first_year_input, {"farm": object.union(first_year_input.farm, {"oepul": object.union(first_year_input.farm.oepul, {"o6_3": object.union(base_input.farm.oepul.o6_3, {"measure_application_date": "2024-01-15"})})})})
	"O6_3-APP-01" in o6_3.access_requirement_failures with input as inp
	inp2 := with_o6_3({"contract_start_year": 2026, "measure_application_date": "2025-12-01"})
	"O6_3-APP-02" in o6_3.access_requirement_failures with input as inp2
}

test_public_body_not_eligible if {
	inp := with_farm({"applicant": {"legal_form": "legal_entity", "public_body_share_percent": 30}})
	"GEN-ELIG-01" in o6_3.access_requirement_failures with input as inp
}

test_takeover_deadline_2028 if {
	o6_3.takeover_deadline(2028) == "2028-04-17"
	o6_3.takeover_deadline(2026) == "2026-04-15"
	inp := with_o6_3({"takeover": {"is_takeover": true, "takeover_date": "2026-04-16"}})
	"GEN-TAKEOVER-01" in o6_3.takeover_issues with input as inp
}

test_sanction_levels if {
	o6_3.sanction_share("warning", 2026) == 0
	o6_3.sanction_share("warning", 2027) == 0.01
	o6_3.sanction_share("reduction_25", 2026) == 0.25
	inp := with_o6_3({"hundred_percent_reductions_in_contract_period": 2})
	o6_3.excluded_from_measure with input as inp
	o6_3.premium_gross_eur == 0 with input as inp
}

test_exit_requires_full_recovery if {
	inp := with_o6_3({"exit": {"exited": true, "exit_year": 2026}})
	o6_3.full_recovery_required with input as inp
	o6_3.premium_gross_eur == 0 with input as inp
	inp2 := with_o6_3({"exit": {"exited": true, "exit_year": 2026, "force_majeure_or_exceptional_circumstances_recognised": true}})
	not o6_3.full_recovery_required with input as inp2
}

test_premium_cap_general_and_naturschutz if {
	ps := [{"parcel_id": "G1", "area_ha": 8, "land_use": "grassland", "grassland_type": "maehwiese_maehweide", "other_capped_oepul_payments_eur_per_ha": 1200, "operations": {"cutting_dates": ["2026-06-01"]}}]
	inp := object.union(base_input, {"land": {"total_area_ha": 8, "parcels": ps}})
	"G1" in o6_3.cap_exceeded_parcels with input as inp
	o6_3.cap_for(2026, "o6_18_o6_19") == 1500
	o6_3.cap_for(2023, "general") == 1200
}

test_small_payout_may_be_waived if {
	ps := [{"parcel_id": "G1", "area_ha": 0.3, "land_use": "grassland", "grassland_type": "maehwiese_maehweide", "operations": {"cutting_dates": ["2026-06-01"]}}]
	inp := object.union(base_input, {"land": {"total_area_ha": 0.3, "parcels": ps}, "livestock": {"species_groups": [{"rgve_category": "cattle_2y_plus", "animal_count": 1}]}})
	o6_3.payout_may_be_waived with input as inp
}

test_minimum_management_violation if {
	ps := [{"parcel_id": "G9", "area_ha": 8, "land_use": "grassland", "grassland_type": "maehwiese_maehweide", "operations": {"cutting_dates": []}}]
	inp := object.union(base_input, {"land": {"total_area_ha": 8, "parcels": ps}})
	"GEN-MBK-01" in o6_3.violation_rule_ids with input as inp
}

test_rgve_key_complete if {
	count(data.o6_3.rgve_key.rows) == 20
	o6_3.rgve_factor("red_deer_1y_plus") == 0.25
	o6_3.rgve_factor("equids_large_adult_3y_plus") == 1.0
}

test_drought_2026_force_majeure_claim if {
	inp := with_farm({"oepul": object.union(base_input.farm.oepul, {"force_majeure": {"cause": "drought_2026", "obligations_not_maintainable": true, "recognised": true}}), "feeding": object.union(base_input.farm.feeding, {"green_feeding": {"eingrasen_or_pasture_days_apr_sep": 10, "all_roughage_animals_included": true}})})
	o6_3.drought_force_majeure_claim_possible with input as inp
	count(o6_3.effective_violations) == 0 with input as inp
	"O6_3-OBL-05" in o6_3.violation_rule_ids with input as inp
}

test_decision_object if {
	d := o6_3.decision with input as base_input
	d.livestock_status == "tierhaltend"
	d.premium_after_modulation_eur == 1603.8
	d.contract_established == false
	d.first_contract_year == false
}

test_contract_period_table if {
	inp := with_o6_3({"contract_start_year": 2025, "measure_application_date": "2024-12-31"})
	p := o6_3.contract_period with input as inp
	p.years == 4
}

test_non_eligible_area_type_excluded if {
	ps := [
		{"parcel_id": "G1", "area_ha": 8, "land_use": "grassland", "grassland_type": "maehwiese_maehweide", "operations": {"cutting_dates": ["2026-06-01"]}},
		{"parcel_id": "G7", "area_ha": 2, "land_use": "grassland", "grassland_type": "maehwiese_maehweide", "non_eligible_area_type": "versuchsflaeche_vf", "operations": {"cutting_dates": ["2026-06-01"]}},
	]
	inp := object.union(base_input, {"land": {"total_area_ha": 10, "parcels": ps}})
	o6_3.eligible_area_ha == 8 with input as inp
	o6_3.parcel_exclusions(ps[1]) == {"GEN-AREA-01"}
}

test_heuwirtschaft_is_multi_year if {
	o6_3.is_multi_year_measure
}
