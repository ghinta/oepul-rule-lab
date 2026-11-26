package oepul.o6_17_test

import data.oepul.o6_17 as m
import rego.v1

farm := {"year": 2025, "farm_id": "B1", "o6_17": {"start_year": 2025, "active_measures": ["BIO-Teilbetrieb"], "application_date": "2024-12-31"}}
flat := {"parcel_id": "G1", "mfa_use": "Einmähdige Wiese", "land_use": "grassland", "in_austrian_mfa": true, "mown": true, "area_ha": 2, "payable_ha": 2, "payable_ban_union_ha": 0.5, "grassland_score": 20, "slope_percent": 17.99}

test_contract_start_and_end if {
	m.contract_years(2023) == 6
	m.contract_years(2025) == 4
	not m.contract_years(2026)
	m.timely_application with input.farm as farm
	not m.timely_application with input.farm as farm with input.farm.o6_17.application_date as "2025-01-01"
	not m.in_term with input.farm as farm with input.farm.year as 2029
}

test_entry_at_all_three_boundaries if {
	land := {"grassland_area_ha": 2, "agricultural_area_at_ha": 7, "alpine_pasture_area_ha": 2, "parcels": [flat]}
	livestock := {"rgve_groups": [{"kind": "Rind", "breed": "Braunvieh", "age_years": 1, "reference_count": 1, "in_austria": true}]}
	i := {"farm": farm, "land": land, "livestock": livestock}
	m.annual_access with input as i
	not m.annual_access with input as i with input.land.agricultural_area_at_ha as 7.001
	not m.annual_access with input as i with input.land.grassland_area_ha as 1.999
	not m.annual_access with input as i with input.livestock.rgve_groups as []
	not m.annual_access with input as i with input.farm.o6_17.active_measures as []
}

test_continuation_without_first_year_minima if {
	m.annual_access with input.farm as farm with input.farm.year as 2026 with input.farm.o6_17.existing_contract as true
	not m.annual_access with input.farm as farm with input.farm.year as 2026
}

test_forage_includes_other_measures if {
	p := {"land_use": "arable", "in_austrian_mfa": true, "area_ha": 3, "crop": {"crop_name": "Kleegras"}}
	parcels := [object.union(flat, {"mfa_codes": ["NAT"]}), p, object.union(p, {"crop": {"crop_name": "Gerste"}}), object.union(p, {"in_austrian_mfa": false})]
	m.forage_area == 5 with input.land.parcels as parcels
}

test_rgve_key if {
	horse := {"kind": "Equide", "breed_height_m": 1.48, "breed_final_kg": 300, "in_austria": true, "age_years": 3, "reference_count": 2}
	m.group_rgve(horse) == 1
	m.group_rgve(object.union(horse, {"breed_final_kg": 301})) == 2
	m.group_rgve(object.union(horse, {"kind": "Rind", "breed": "Dexter", "age_years": 0.5})) == 0.6
	m.group_rgve(object.union(horse, {"kind": "Rotwild", "age_years": 0.99})) == 0.14
	m.group_rgve(object.union(horse, {"in_austria": false})) == 0
	not m.rgve_total with input.livestock.rgve_groups as [{"kind": "unbekannt", "in_austria": true}]
}

test_tariffs_and_slope_boundary if {
	m.base_rate(2023, 19.99, 17.99) == 30
	m.base_rate(2024, 20, 17.99) == 54
	m.base_rate(2024, 30, 0) == 75.6
	m.base_rate(2024, 40, 0) == 108
	not m.base_rate(2026, 40, 18)
	not m.agl_rate(2024, 18)
	m.agl_rate(2025, 18) == 162
	m.agl_rate(2024, 17.99) == 262
	m.agl_rate(2023, 17.99) == 150
}

test_gloez_partial_and_automatic_bonus if {
	m.base_amounts == {"G1": 81} with input.farm as farm with input.land.parcels as [flat]
	m.agl_amount_range == {"min_eur": 524, "max_eur": 524} with input.farm as farm with input.land.parcels as [flat]
	not m.agl_candidate(object.union(flat, {"mfa_use": "Bergmähder"}), 2025)
}

test_cap_no_unearned_floor_and_mixed_rates if {
	m.agl_cap(2024, 20) == 3
	m.agl_cap(2025, 20) == 5
	m.agl_payable_area == 0.6 with input.farm as farm with input.land.parcels as [object.union(flat, {"payable_ha": 0.6})]
	steep := object.union(flat, {"parcel_id": "G2", "slope_percent": 18})
	m.agl_payable_area == 2 with input.farm as farm with input.land.parcels as [flat, steep]
	m.agl_amount_range == {"min_eur": 324, "max_eur": 524} with input.farm as farm with input.land.parcels as [flat, steep]
}

observation(name) := {"name": name, "regularly_distributed": true, "identified": true, "flowers": true}
visits := [
	{"date": "2025-05-24", "observations": [observation("Geum rivale"), observation("Pimpinella major"), observation("Pimpinella saxifraga")]},
	{"date": "2025-06-12", "observations": [observation("Galium verum"), observation("Thymian"), observation("Wilde Möhre")]},
]

test_species_union_group_and_section if {
	m.section_qualifies({"visits": visits}, 2025)
	not m.section_qualifies({"visits": [visits[0]]}, 2025)
	not m.section_qualifies({"visits": visits}, 2024)
	p := object.union(flat, {"mfa_use": "Mähwiese/-weide zwei Nutzungen", "mfa_codes": ["AGL"], "first_use": "Mahd", "agl_survey": {"longest_line": true, "edge_distance_m": 5, "approx_two_m_wide": true, "form_complete": true, "transect_sketch": true, "sections": [{"visits": visits}]}})
	m.agl_candidate(p, 2025)
	not m.agl_candidate(object.union(p, {"first_use": "Weide"}), 2025)
	not m.agl_candidate(object.union(p, {"agl_survey": object.union(p.agl_survey, {"sections": [{"visits": visits}, {"visits": [visits[0]]}]})}), 2025)
}

test_sample_count_source_examples if {
	m.required_samples == 1 with input.land.mfa_2025_grassland as [{"area_ha": 5.10, "gloez_ban_union_ha": 0.20, "slope_percent": 0}]
	m.required_samples == 3 with input.land.mfa_2025_grassland as [{"area_ha": 10.40, "gloez_ban_union_ha": 0, "slope_percent": 17}]
	m.required_samples == 0 with input.land.mfa_2025_grassland as [{"area_ha": 10.40, "gloez_ban_union_ha": 0, "slope_percent": 18}]
	not m.required_samples with input.land.mfa_2025_grassland as [{"area_ha": 5, "slope_percent": null}]
}

sample := {"sample_id": "s1", "farm_id": "B1", "from_eligible_grassland": true, "drawn": "2024-11-17", "sent": "2025-12-31", "accredited_lab": true, "method": "EUF", "analysed_parameters": ["pH", "P", "K", "Humus"], "gis_recorded": true, "mfa_year": 2024, "autumn_acquisition": false}

test_sampling_year_deadline_and_transfer if {
	samples := [sample, sample, object.union(sample, {"sample_id": "s2", "farm_id": "B2"}), object.union(sample, {"sample_id": "s3", "sent": "2026-01-01"}), object.union(sample, {"sample_id": "s4", "analysed_parameters": ["P", "K", "pH"]})]
	m.credited_samples == 1 with input.farm as farm with input.documentation.soil_samples as samples
	m.credited_samples == 1 with input.farm as farm with input.documentation.soil_samples as [object.union(sample, {"mfa_year": 2025, "autumn_acquisition": true})]
	m.credited_samples == 0 with input.farm as farm with input.documentation.soil_samples as [object.union(sample, {"mfa_year": 2025})]
}

test_renewal_exceptions if {
	e := {"kind": "Drainage", "minor_deviation": true, "area_m2": 300}
	m.allowed_disturbance({}, e)
	not m.allowed_disturbance({}, object.union(e, {"area_m2": 300.01}))
	fill := {"kind": "Aufschüttung", "area_m2": 301, "reseeded": true, "state_law_observed": true, "prior_authorisation": false}
	not m.allowed_disturbance({}, fill)
	m.allowed_disturbance({}, object.union(fill, {"prior_authorisation": true}))
	m.allowed_disturbance({}, {"kind": "Schädlingssanierung", "necessary": true, "evidence_retained": true})
	not m.allowed_disturbance({}, {"kind": "Schädlingssanierung", "necessary": true, "evidence_retained": false})
}

test_break_on_unpaid_parcel if {
	p := object.union(flat, {"payable_ha": 0, "operations": {"grass_events": [{"kind": "Pflügen", "sward_destroyed": true}, {"kind": "Acker-Grünland-Flächentausch"}]}})
	count(m.tillage_breaches) == 2 with input.farm as farm with input.land.parcels as [p]
}

test_training_person_dates_and_no_double_credit if {
	c := {"event_id": "a", "person_id": "p", "date": "2022-01-01", "subject": "Grünlandbewirtschaftung", "hours": 5, "operator": true, "recognised_provider": true, "subject_requirements_met": true, "credited_farms": 1, "credited_obligations": 1, "departure_date": null}
	bad := [object.union(c, {"event_id": "b", "date": "2021-12-31"}), object.union(c, {"event_id": "c", "departure_date": "2025-12-30"}), object.union(c, {"event_id": "d", "credited_obligations": 2})]
	m.training_hours("p", "Grünlandbewirtschaftung") == 5 with input.documentation.courses as array.concat([c, c], bad)
	m.training_outstanding == {"Biologische Wirtschaftsweise", "Biodiversität"} with input.farm as farm with input.documentation.courses as [c]
}

test_area_limits_and_modulation if {
	m.loss_tolerance(2) == 0.5
	m.repayable_loss(20, 1) == 0
	m.repayable_loss(20, 1.01) == 1.01
	m.loss_tolerance(200) == 5
	m.eligible_additions(2024, 10, 9, 1) == 10
	m.eligible_additions(2026, 8, 9, 2) == 7
	m.eligible_additions(2026, 20, 11, 0) == 10
	m.modulation(220) == 218 / 220
	m.modulation(1001) == (((200 + 90) + 595) + 0.75) / 1001
}

test_takeover_distinct_from_entry if {
	m.takeover_window(2028, "2028-04-17", 2, 1)
	not m.takeover_window(2028, "2028-04-18", 2, 1)
	not m.takeover_window(2026, "2026-04-16", 2, 1)
	not m.takeover_window(2026, "2026-04-15", 2, 1.01)
}

test_cross_measure_and_years if {
	m.combination("17", "9").mark == "x"
	m.combination("17", "18").mark == ""
	m.combination("1B", "16").mark == "a"
	m.combination("1A", "18").cell_notes == [1]
	m.sanction_levels(2026).Verwarnung == 0
	m.sanction_levels(2027).Verwarnung == 1
	m.exclude_after_cuts with input.documentation.full_cuts_in_contract as 2
}

test_drought_scope if {
	p := {"federal_state": "Steiermark", "district": "Graz", "land_use": "arable", "harvest_drought": {"assessment_date": "2026-08-12", "usual_late_harvest": true, "heat_drought_affected": true, "no_harvestable_stand": true}}
	m.drought_harvest_exception(p) with input.farm.year as 2026
	not m.drought_harvest_exception(object.union(p, {"land_use": "grassland"})) with input.farm.year as 2026
	not m.drought_harvest_exception(p) with input.farm.year as 2025
	not m.drought_harvest_exception(object.union(p, {"harvest_drought": object.union(p.harvest_drought, {"assessment_date": "2026-08-11"})})) with input.farm.year as 2026
	m.div_change("DIVSZ", "DIVNFZ", "2026-06-15")
	not m.div_change("DIVSZ", "DIVNFZ", "2026-06-16")
}

test_explicit_op_blocks_17_but_partner_code_alone_does_not if {
	p := object.union(flat, {"mfa_codes": ["OP"]})
	count(m.base_amounts) == 0 with input.farm as farm with input.land.parcels as [p]
	m.agl_payable_area == 0 with input.farm as farm with input.land.parcels as [p]
	m.agl_payable_area == 2 with input.farm as farm with input.land.parcels as [object.union(flat, {"mfa_codes": ["OPBIO"]})]
}

test_incomplete_profile_does_not_get_farm_projection if {
	count(m.premium_input_gaps) > 0 with input.land.parcels as [{"area_ha": 2, "land_use": "grassland"}]
	not m.premium_projection with input as {"farm": farm}
}

test_seed_catalog_and_weight_exception if {
	row := data.o17_tables.regional_grass_seed[0]
	part := {"scientific_name": row.scientific_name, "family": row.family, "regional_origin_at_proven": true, "weight_percent": 5}
	m.valid_seed_part({"certified_ecotype": false}, part)
	not m.valid_seed_part({"certified_ecotype": false}, object.union(part, {"weight_percent": 5.01}))
	m.valid_seed_part({"certified_ecotype": true}, object.union(part, {"weight_percent": 7, "scientific_name": "externer Ökotyp"}))
	not m.valid_seed_part({"certified_ecotype": true}, object.union(part, {"regional_origin_at_proven": false}))
}

test_management_and_national_park if {
	p := object.union(flat, {"management": {"category": "Grünland", "whole_mown_and_removed_this_year": false, "whole_grazed_this_year": true}})
	m.management_met(p)
	not m.management_met(object.union(p, {"mfa_use": "Bergmähder"}))
	m.management_met({"management": {"exemption_measure": "18", "exemption_use": "Grünbrache NAT"}}) with input.farm.year as 2026
	park := object.union(flat, {"oepul_assessment": {"national_park": "Donau-Auen"}})
	count(m.parcel_exclusions.G1) == 1 with input.land.parcels as [park]
}

test_divsz_tirol_may_example if {
	g := {"variant": "DIVSZ", "partner": "UBB", "early_exception": true, "other_restrictive_conditions": false, "phenology_days": 7, "comparable_second_cut_started": true, "use_date": "2026-05-25"}
	p := {"land_use": "grassland", "mfa_codes": ["OPUBB"], "constraints": {"biodiversity_area": {"is_biodiversity_area": true}}, "div_grass": g}
	m.divsz_use_allowed(p) with input.farm.year as 2026
	not m.divsz_use_allowed(object.union(p, {"mfa_codes": []})) with input.farm.year as 2026
	not m.divsz_use_allowed(object.union(p, {"div_grass": object.union(g, {"use_date": "2026-05-24"})})) with input.farm.year as 2026
	not m.divsz_use_allowed(object.union(p, {"div_grass": object.union(g, {"comparable_second_cut_started": false})})) with input.farm.year as 2026
	m.div_rest_days(object.union(p, {"div_grass": object.union(g, {"variant": "DIVNFZ"})})) == 49 with input.farm.year as 2026
}

test_bio_cycle_strict_thresholds if {
	ms := {"year": 2025, "o6_17": {"active_measures": ["BIO"]}}
	g := {"mown_ha": 10, "div_or_species_rich_union_ha": 0.81}
	m.bio_cycle_rate == 40 with input.farm as ms with input.land.bio_circular_grass as g with m.stocking_density as 0.3
	not m.bio_cycle_rate with input.farm as ms with input.land.bio_circular_grass as object.union(g, {"div_or_species_rich_union_ha": 0.8}) with m.stocking_density as 0.3
	not m.bio_cycle_rate with input.farm as ms with input.land.bio_circular_grass as g with m.stocking_density as 1.4
}

test_general_size_and_legal_form if {
	m.farm_size_ok with input.farm.year as 2023 with input.farm.first_oepul_year as 2023 with input.land.protected_cultivation_at_ha as 0.5
	m.applicant_form_ok with input.farm.applicant as {"form": "juristische Person", "public_body_or_institution": false, "public_share_percent": 25}
	not m.applicant_form_ok with input.farm.applicant as {"form": "juristische Person", "public_body_or_institution": false, "public_share_percent": 25.01}
	count(m.incompatible_pair) == 1 with input.farm.o6_17.active_measures as ["BIO", "UBB"]
}

test_full_seed_mix_and_contract_year if {
	rows := data.o17_tables.regional_grass_seed

	# Über die Familien der gesamten Liste verteilte 30 Arten.
	parts := [{"family": r.family, "scientific_name": r.scientific_name, "regional_origin_at_proven": true, "weight_percent": weight} |
		some i, r in rows
		i % 2 == 0
		i < 60
		weight := 3 + ceil(max([0, 20 - i]) / 20)
	]
	seed := {"permanent_div_reseeding": true, "kg_per_ha": 20, "seedbed_prepared": true, "sowing_date": "2025-05-15", "labels_and_invoices": true, "certified_ecotype": false, "parts": parts}
	p := {"land_use": "grassland", "grassland_score": 30, "slope_percent": 17.9, "operations": {"regional_seed": seed}}
	m.regional_seed(p) with input.farm.year as 2025
	not m.regional_seed(object.union(p, {"slope_percent": 18})) with input.farm.year as 2025
	not m.regional_seed(p) with input.farm.year as 2026
}

test_combination_headers_and_genus_groups if {
	not m.combination_in_year("17", "1C", 2024)
	m.combination_in_year("17", "1C", 2025).mark == ""
	some r in data.o17_tables.indicator_species
	r.name == "Thymian"
	m.species_match("Thymus pulegioides", r)
	not m.species_match("Prunella vulgaris", r)
}

test_weight_limit_is_per_species if {
	m.weights_within_species_limit({"certified_ecotype": false, "parts": [{"scientific_name": "Geum urbanum", "weight_percent": 2}, {"scientific_name": "Geum urbanum", "weight_percent": 3}]})
	not m.weights_within_species_limit({"certified_ecotype": false, "parts": [{"scientific_name": "Geum urbanum", "weight_percent": 3}, {"scientific_name": "Geum urbanum", "weight_percent": 3}]})
}

test_stacked_cap_changes_in_2025 if {
	p := {"ceiling_group": "regulär", "stacked_area_payments": [{"measure_code": "17", "eur_per_ha": 108}, {"measure_code": "1B", "eur_per_ha": 1192}, {"measure_code": "10", "eur_per_ha": 30}, {"measure_code": "6", "eur_per_ha": 50}]}
	m.over_ceiling(p, 2024) == 0
	m.over_ceiling(p, 2025) == 30
	m.max_advance == 375 with input.documentation.payment as {"administrative_checks_complete": true, "approved_annual_eur": 500}
	not m.max_advance with input.documentation.payment as {"administrative_checks_complete": false, "approved_annual_eur": 500}
}

test_operator_succession_and_allowed_conversion if {
	m.control_transfer_exception({"transferred_control": true, "operator_succession": false})
	not m.control_transfer_exception({"transferred_control": true, "operator_succession": true})
	m.permitted_conversion({"old_use": "G", "new_use": "L"})
	not m.permitted_conversion({"old_use": "G", "new_use": "A"})
}
