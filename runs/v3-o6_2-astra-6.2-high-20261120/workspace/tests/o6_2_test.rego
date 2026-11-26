package oepul.o6_2_test

import data.oepul.o6_2 as m
import rego.v1

grass := {"parcel_id": "G", "land_use": "grassland", "area_ha": 10, "mfa": {"country": "AT", "declared": true, "codes": []}}
clover := {"parcel_id": "K", "land_use": "arable", "area_ha": 2, "crop": {"crop_name": "Klee", "is_second_crop": false}, "mfa": {"country": "AT", "declared": true, "codes": []}}
second := object.union(clover, {"parcel_id": "Z", "crop": {"is_second_crop": true}})
cow(count) := {"species": "cattle", "breed": "Fleckvieh", "age_months": 24, "country": "AT", "count_basis": "cattle_database_daily", "annual_mean_count": count}
farm_input(y, ps, gs) := {"farm": {"year": y}, "land": {"parcels": ps}, "livestock": {"species_groups": gs}}

test_contract_boundaries if {
	m.entry_on_time with input.farm.application as {"start_year": 2025, "application_date": "2024-12-31"}
	not m.entry_on_time with input.farm.application as {"start_year": 2025, "application_date": "2025-01-01"}
	not m.entry_on_time with input.farm.application as {"start_year": 2026, "application_date": "2025-12-31"}
	not m.entry_on_time with input.farm.application as {"start_year": 2025, "application_date": "2024-02-30"}
}

test_ubb_and_bio_partial if {
	bio := {"ubb": true, "bio_scope": "wine_fruit_hops", "separate_units": true, "separate_crop_sectors": true, "separate_stores": true}
	m.combination_ok with input.farm.application as bio
	not m.combination_ok with input.farm.application as object.union(bio, {"ubb": false})
	not m.combination_ok with input.farm.application as object.union(bio, {"bio_scope": "whole_farm"})
	not m.combination_ok with input.farm.application as object.union(bio, {"separate_stores": false})
}

test_annex_matrix if {
	count(m.parcel_combinations) == 20
	m.combination_cell("2", "16") == "a"
	m.combination_cell("2", "1B") == ""
	m.combination_cell("2", "23") == "x"
	m.combination_cell("2", "18") == ""
	m.groundwater_base(54) == 27
	m.partner16_rate == 27 with input.farm.year as 2026
	m.partner23_rate("N2GL37") == 540 with input.farm.year as 2025
}

test_parcel_evidence_requirements if {
	third_party := {"mfa": {"exclusively_third_party_breach": true}}
	trial := {"mfa": {"approved_trial_precludes_obligation": true}}
	proceedings := {"third_party_proof_retained": false, "trial_approval_retained": true, "trial_type_size_location_recorded": false}
	m.third_party_evidence_due(third_party) with input.documentation.proceedings as proceedings
	not m.third_party_evidence_due(trial) with input.documentation.proceedings as proceedings
	m.trial_evidence_due(trial) with input.documentation.proceedings as proceedings
	not m.trial_evidence_due(third_party) with input.documentation.proceedings as proceedings
	complete := object.union(proceedings, {"third_party_proof_retained": true, "trial_type_size_location_recorded": true})
	not m.trial_evidence_due(trial) with input.documentation.proceedings as complete
	not m.third_party_evidence_due(third_party) with input.documentation.proceedings as complete
}

test_forage_all_claimed_not_just_payable if {
	nat := object.union(grass, {"mfa": {"claimed_o6_2": false, "other_parcel_measures": ["18"]}})
	foreign := object.union(grass, {"mfa": {"country": "DE"}})
	undeclared := object.union(grass, {"mfa": {"declared": false}})
	m.forage_ha == 12 with input.land.parcels as [nat, clover, second, foreign, undeclared]
	result := m.parcel_exclusions with input.land.parcels as [nat]
	"Kombination" in result.G
}

test_stock_boundaries if {
	every r in [[2.999, "none", 0], [3, "medium", 75.6], [13.999, "medium", 75.6], [14, "high", 64.8]] {
		farm := farm_input(2026, [grass], [cow(r[0])])
		m.stock_band == r[1] with input as farm
		m.base_rates.G == r[2] with input as farm
	}
}

test_2023_and_npf if {
	p := object.union(clover, {"mfa": {"codes": ["NPF"]}})
	f := farm_input(2023, [p], [cow(1)])
	m.rate(p) == 0 with input as f
	m.rate(clover) == 70 with input as f
	m.rate(p) == 75.6 with input as f with input.farm.year as 2025
	m.rate(second) == 60 with input as f
}

test_no_forage_or_unknown_count if {
	not m.density with input as farm_input(2026, [second], [])
	m.rate(second) == 64.8 with input as farm_input(2026, [second], [])
	not m.base_rates.G with input as farm_input(2026, [grass], [{"species": "cattle", "country": "AT"}])
	not m.forage_ha with input.land.parcels as [{"land_use": "arable", "crop": {"crop_name": "Klee"}, "area_ha": 3, "mfa": {"country": "AT", "declared": true}}]
}

test_dwarf_cattle if {
	every row in [[5.99, 0.2], [6, 0.3], [23.99, 0.3], [24, 0.5]] {
		g := object.union(cow(1), {"breed": "Dexter", "age_months": row[0]})
		m.animal_contribution(g) == row[1]
	}
}

test_equids_boundaries if {
	g := {"species": "horses", "country": "AT", "count_basis": "april_1", "fluctuating_stock": false, "animal_count": 2, "age_months": 6, "breed_height_m": 1.48, "breed_adult_weight_kg": 300}
	m.animal_contribution(g) == 0.6
	m.animal_contribution(object.union(g, {"breed_adult_weight_kg": 301})) == 1.2
	m.animal_contribution(object.union(g, {"breed_height_m": 1.49, "age_months": 36})) == 2
	not m.animal_contribution(object.union(g, {"fluctuating_stock": true}))
}

test_wild_and_pigs if {
	g := {"species": "other", "category": "Rotwild", "country": "AT", "count_basis": "average_list", "annual_mean_count": 4, "age_months": 12, "captive_on_agricultural_land": true}
	m.animal_contribution(g) == 1
	m.animal_contribution(object.union(g, {"age_months": 11})) == 0.28
	m.animal_contribution(object.union(g, {"captive_on_agricultural_land": false})) == 0
	m.animal_contribution({"species": "pigs", "country": "AT", "gve": 100}) == 0
}

test_nitrogen_boundary if {
	n := {"year": 2026, "agricultural_ha_at": 10, "livestock_n_at_kg": 2000, "housing_storage_loss_kg": 200, "alpine_and_common_grazing_n_kg": 100}
	m.nitrogen_ok with input.farm.year as 2026 with input.livestock.nitrogen as n
	not m.nitrogen_ok with input.farm.year as 2026 with input.livestock.nitrogen as object.union(n, {"livestock_n_at_kg": 2001, "sold_manure_n_kg": 200})
	not m.nitrogen_per_ha with input.farm.year as 2025 with input.livestock.nitrogen as n
}

test_fertilizers_even_on_unpaid_parcel if {
	p := {"parcel_id": "E", "land_use": "other", "mfa": {"country": "AT", "agricultural_area": true, "use": "Energieholz", "claimed_o6_2": false}, "operations": {"fertilizer": {"applications": [{"kind": "Einzel-/Mehrnährstoffdünger", "external": true, "contains_n": true}]}}}
	{"parcel": "E", "index": 0, "status": "verboten"} in m.fertilizer_findings with input.land.parcels as [p]
	m.fertilizer_status({"kind": "Mist", "external": true}) == "erlaubt"
	m.fertilizer_status({"kind": "Kompost", "external": true, "eu_organic_allowed": true}) == "erlaubt"
	m.fertilizer_status({"kind": "Schlempe"}) == "verboten"
	m.fertilizer_status({"kind": "Klärschlamm", "external": false}) == "verboten"
}

test_biogas_balance if {
	f := {"kind": "Biogasgülle", "own_slurry_delivered": 12, "cumulative_return": 12}
	m.fertilizer_status(f) == "erlaubt"
	m.fertilizer_status(object.union(f, {"cumulative_return": 12.01})) == "verboten"
	not m.fertilizer_status({"kind": "Biogasgülle", "external": true, "contains_n": true})
}

test_psm_methods if {
	e := {"method": "Horstbehandlung", "all_actives_organic_allowed": false}
	m.psm_status(grass, e) == "verboten"
	m.psm_status(clover, object.union(e, {"method": "Einzelpflanze"})) == "erlaubt"
	m.psm_status(clover, object.union(e, {"method": "Saatgutbeizung"})) == "verboten"
	m.psm_status(grass, object.union(e, {"all_actives_organic_allowed": true})) == "erlaubt"
	m.psm_status({"land_use": "arable", "crop": {"crop_name": "Weizen"}}, object.union(e, {"baes_use_authorised": true})) == "erlaubt"
}

test_mixed_code_and_repeal if {
	p := object.union(grass, {"operations": {"psm_applications": [{"method": "flächig", "product_class": "organic"}, {"method": "flächig", "product_class": "synthetic"}]}})
	m.required_psm_codes(p) == {"PSMCS"} with input.farm.year as 2025
	m.required_psm_codes(p) == set() with input.farm.year as 2026
}

test_storage_exception if {
	s := {"action": "Lagerung", "disallowed_for_measure": true, "is_psm": true, "permitted_other_crop": true, "quantity_plausible": true, "documented": true}
	m.stock_status(s) == "erlaubt"
	m.stock_status(object.union(s, {"documented": false})) == "verboten"
	m.stock_status(object.union(s, {"action": "Kauf", "is_psm": false})) == "verboten"
}

course := {"person_id": "P", "event_id": "A", "date": "2022-01-01", "hours": 1.5, "topic": "Stickstoffdüngung", "role": "Betriebsführung", "left_on": null, "recognised_provider": true, "other_obligation_credit": false, "other_farm_credit": false}

test_training_individual_events_and_dates if {
	b := object.union(course, {"event_id": "B", "date": "2025-12-31"})
	m.trained_people == {"P"} with input.documentation.courses as [course, b]
	every bad in [{"event_id": "A"}, {"person_id": "Q"}, {"date": "2026-01-01"}, {"left_on": "2025-12-30"}, {"other_obligation_credit": true}, {"recognised_provider": false}, {"role": "Mitwirkende Person"}] {
		m.trained_people == set() with input.documentation.courses as [course, object.union(b, bad)]
	}
}

test_certificate if {
	d := {"certificate_requested": true, "provider_sent_certificate": false, "farm_sent_certificate": false}
	m.certificate_due with input.documentation as d
	not m.certificate_due with input.documentation as object.union(d, {"provider_sent_certificate": true})
}

test_loss_and_access if {
	h := {"previous_year_ha": 200, "relevant_loss_ha": 5.01, "new_ha": 6, "base_2025_ha": 4, "precommitted_ha": 1}
	m.repayable_loss_ha == 5.01 with input.land.commitment as h
	m.repayable_loss_ha == 0 with input.land.commitment as object.union(h, {"relevant_loss_ha": 5})
	m.payable_access_ha == 6 with input.land.commitment as h with input.farm.year as 2026
	m.payable_access_ha == 7 with input.land.commitment as h with input.farm.year as 2025
	m.loss_tolerance == 0.5 with input.land.commitment.previous_year_ha as 1
}

test_drought_only_location_and_crop if {
	p := {"land_use": "arable", "crop": {"crop_name": "Mais"}, "mfa": {"country": "AT", "state": "Steiermark", "district": "Weiz"}, "operations": {"harvest": {"no_harvestable_stand_due_to_drought": true, "typical_late_summer_or_autumn": true, "proper_sowing": true, "annual_care": true}}}
	m.arable_management_ok(p) with input.farm.year as 2026
	not m.drought_waiver(p) with input.farm.year as 2025
	not m.drought_waiver(object.union(p, {"mfa": {"district": "Liezen"}})) with input.farm.year as 2026
	not m.drought_waiver(object.union(p, {"operations": {"harvest": {"typical_late_summer_or_autumn": false}}})) with input.farm.year as 2026
}

test_modulation_caps_sanctions if {
	m.modulation == 218 / 220 with input.land.home_modulation_ha as 220
	m.cap_rule("general").excluded == ["6", "7", "1C"] with input.farm.year as 2025
	m.sanction_percent("Verwarnung") == 0 with input.farm.year as 2026
	m.sanction_percent("Verwarnung") == 1 with input.farm.year as 2027
	m.repeat_exclusion with input.documentation.full_reductions_this_contract as 2
}

test_takeover_special_date if {
	r := {"date": "2028-04-17", "previously_participating": false, "online_mfa": true, "ama_approved": true, "acquired_committed_ha": 10, "extension_ha": 5}
	m.takeover_ok with input.farm.year as 2028 with input.farm.application.takeover as r
	not m.takeover_ok with input.farm.year as 2028 with input.farm.application.takeover as object.union(r, {"extension_ha": 5.01})
	not m.takeover_ok with input.farm.year as 2026 with input.farm.application.takeover as object.union(r, {"date": "2026-04-16"})
}

test_fruit_year_and_quality if {
	p := {"land_use": "special_crop", "crop": {"crop_name": "Papau", "crop_category": "orchard", "high_quality_stock": false}, "parcel_id": "O"}
	m.rate(p) == 64.8 with input.farm.year as 2025
	not m.rate(p) with input.farm.year as 2024
	result := m.parcel_exclusions with input.land.parcels as [p]
	"Obstqualität" in result.O
}

test_div_change_and_project if {
	m.div_change("DIVSZ", "DIVNFZ", "2026-06-15")
	not m.div_change("DIVSZ", "DIVNFZ", "2026-06-16")
	not m.div_change("DIVNFZ", "DIVSZ", "2026-05-20")
	p := {"land_use": "arable", "mfa": {"ubb_arable_div": true, "codes": ["OPUBB"], "other_use_restrictions": false}, "operations": {"div_uses_this_year": 3}}
	m.third_div_use(p) with input.farm.year as 2026
	not m.third_div_use(object.union(p, {"mfa": {"other_use_restrictions": true}})) with input.farm.year as 2026
}

test_status_drop_and_access_failure_are_different if {
	m.annual_stock_change.obligations_continue with input as farm_input(2026, [grass], []) with input.livestock.previous_rgve_per_forage_ha as 0.30
	m.missing_combination_consequence == "keine Jahresprämie" with input.farm as {"year": 2026, "application": {"start_year": 2025, "ubb": false}}
	m.missing_combination_consequence == "kein Vertrag" with input.farm as {"year": 2025, "application": {"start_year": 2025, "bio_scope": "whole_farm"}}
	not m.missing_combination_consequence with input.farm as {"year": 2025, "application": {"start_year": 2025}}
}

test_minimum_size_two_alternatives if {
	a := {"year": 2025, "application": {"first_oepul_year": 2025}}
	m.minimum_size_ok with input.farm as a with input.land as {"protected_cultivation_at_ha": 0.5, "mfa_minimum_size_area_at_ha": 0.5}
	m.minimum_size_ok with input.farm as a with input.land.mfa_minimum_size_area_at_ha as 1.5
	not m.minimum_size_ok with input.farm as a with input.land as {"protected_cultivation_at_ha": 0.49, "mfa_minimum_size_area_at_ha": 1.49}
	m.minimum_size_ok with input.farm.year as 2026 with input.farm.application.first_oepul_year as 2025
}

test_actual_tariff_amount_and_op if {
	p := object.union(second, {"mfa": {"eligible_o6_2_ha": 1.5, "claimed_o6_2": true}})
	m.amount_before_adjustments.Z == 97.2 with input as farm_input(2026, [p], [])
	not m.amount_before_adjustments.Z with input as farm_input(2026, [object.union(p, {"mfa": {"codes": ["OP"]}})], [])
}

test_rate_all_four_uses if {
	every y_rate in [[2023, 60], [2024, 64.8], [2028, 64.8]] {
		f := farm_input(y_rate[0], [grass], [cow(14)])
		every p in [second, clover, grass, {"land_use": "special_crop", "crop": {"crop_category": "hop"}}] {
			m.rate(p) == y_rate[1] with input as f
		}
	}
}

test_crop_lists_and_matrix_notes if {
	m.crop_classes({"crop": {"crop_name": "Pak Choi"}}) == {"Feldgemüse"}
	m.crop_classes({"crop": {"crop_name": "Gemenge", "cereal_share_pct": 49.99}}) == {"Kein Getreide"}
	m.nature_chapter_cell("S", "H") == "nein"
	m.nature_chapter_cell("G", "L") == "ja"
	m.combination_note("2") != ""
	m.pig_gve_per_head("Ferkel ab 8 kg Lebendgewicht") == 0.07
}

test_conversions if {
	m.conversion_allowed("WI", "D", "2")
	m.conversion_allowed("D", "L", "2")
	not m.conversion_allowed("L", "A", "2")
	m.conversion_allowed("A", "LSE Agroforststreifen", "1C")
	not m.conversion_allowed("A", "LSE Agroforststreifen", "2")
}

test_general_management_exceptions if {
	p := {"mfa": {"management_exception": "K20", "parcel_measures": ["K20"]}}
	m.special_management(p) with input.farm.year as 2024
	not m.special_management(p) with input.farm.year as 2025
	m.forage_management_ok(object.union(grass, {"mfa": {"mountain_meadow": true}, "operations": {"harvest": {"full_cut_removed_last_year": true}}}))
	not m.forage_management_ok(grass)
}

test_area_code_not_evidence_of_legal_psm_use if {
	p := object.union(grass, {"mfa": {"codes": ["PSMCS"]}, "operations": {"psm_applications": [{"product_class": "synthetic", "method": "flächig", "all_actives_organic_allowed": false}]}})
	m.missing_psm_codes == {} with input as farm_input(2025, [p], [])
	{"parcel": "G", "index": 0, "status": "verboten"} in m.psm_findings with input as farm_input(2025, [p], [])
}

test_burgenland_all_districts_vs_unlisted_district if {
	p := {"land_use": "arable", "mfa": {"state": "Burgenland", "country": "AT", "district": "Jennersdorf"}, "operations": {"harvest": {"typical_late_summer_or_autumn": true, "no_harvestable_stand_due_to_drought": true}}}
	m.drought_waiver(p) with input.farm.year as 2026
	not m.drought_waiver(object.union(p, {"mfa": {"state": "Niederösterreich", "district": "Lilienfeld"}})) with input.farm.year as 2026
}

test_drought_does_not_waive_sowing_or_care if {
	p := {"land_use": "arable", "crop": {"crop_name": "Mais"}, "mfa": {"country": "AT", "state": "Wien"}, "operations": {"harvest": {"typical_late_summer_or_autumn": true, "no_harvestable_stand_due_to_drought": true, "proper_sowing": false, "annual_care": true}}}
	m.drought_waiver(p) with input.farm.year as 2026
	not m.arable_management_ok(p) with input.farm.year as 2026
}

test_training_cutoff_unknown_and_duplicate_proof if {
	d := {"course_history_complete": true, "training_assessment_date": "2025-12-31", "courses": [course]}
	m.training_at_deadline == "Stundennachweis fehlt" with input.farm.year as 2025 with input.documentation as d
	m.training_at_deadline == "Einzelfallprüfung Stichtag" with input.documentation.courses as [object.union(course, {"left_on": "2025-12-31"})]
	not m.training_at_deadline with input.documentation as {"courses": []}
}

test_participation_program_lists if {
	m.commitment_class("2") == "mehrjährig" with input.farm.year as 2026
	not m.annually_variable("2")
	not m.public_body_exception("2") with input.farm.year as 2026
	not m.special_takeover("2")
	m.public_body_exception("10") with input.farm.year as 2024
	not m.public_body_exception("10") with input.farm.year as 2025
}

test_fractional_forage_at_exact_upper_threshold if {
	young := {"species": "sheep_goats", "category": "Schaf", "country": "AT", "age_months": 9, "fluctuating_stock": false, "count_basis": "april_1", "animal_count": 63}
	p := object.union(grass, {"area_ha": 3.15})
	f := farm_input(2026, [p], [young])
	m.rgve == 4.41 with input as f
	m.density == 1.4 with input as f
	m.base_rates.G == 64.8 with input as f
}

test_canonical_cereal_and_walnuts if {
	m.rate({"land_use": "arable", "crop": {"crop_name": null, "crop_category": "cereal"}}) == 64.8 with input.farm.year as 2026
	p := {"parcel_id": "W", "land_use": "special_crop", "area_ha": 1, "crop": {"crop_name": "Walnüsse", "crop_category": "orchard", "high_quality_stock": false}, "mfa": {"country": "AT", "claimed_o6_2": true, "eligible_o6_2_ha": 1, "codes": ["OP"]}}
	"Obst" in m.crop_classes(p) with input.farm.year as 2026
	not m.amount_before_adjustments.W with input as farm_input(2026, [p], [])
}
