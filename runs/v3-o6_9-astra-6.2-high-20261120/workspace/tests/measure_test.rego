package oepul.o6_9_test

import data.oepul.o6_9 as p
import rego.v1

parcel := {"parcel_id": "A", "country": "AT", "land_use": "arable", "area_ha": 2, "n_demand_napv": true, "pure_legumes": false, "total_fertilizer_ban": false}
application := {"parcel_id": "A", "material": "slurry", "originally_liquid": true, "volume_m3": 120, "ineligible_water_m3": 5, "method": "trailing_hose", "technique_meets_definition": true, "ownership": "own", "date": "2026-07-08"}
cattle := {"country": "AT", "species": "cattle", "breed": "Fleckvieh", "gve_category": "cattle_u24", "annual_average": 2}
pig := {"country": "AT", "species": "pigs", "gve_category": "sow", "animal_count": 4, "average_list_submitted": false, "fluctuating": false}
farm := {"farm": {"year": 2026}, "livestock": {"species_groups": [cattle, pig]}, "land": {"arable_area_ha": 2, "parcels": [parcel]}, "o6_9": {"spreading": [application], "separations": [], "spreading_chronological": true, "claims_complete": true, "claims": {"trailing_hose": {"volume_m3": 118, "date": "2026-11-30"}}}}

test_hose_shared_cap_and_water if {
	p.eligible_volume(application) == 115
	p.spread_payable_m3 == 100 with input as farm
	p.assessment.component_eur_before_general_reductions.spreading == 110 with input as farm
}

test_rates_2023_and_2024 if {
	p.rate("injection") == 1.6 with input.farm.year as 2023
	p.rate("injection") == 1.7 with input.farm.year as 2024
	not p.rate("feeding") with input.farm.year as 2024
}

test_lower_claim_controls if {
	p.spread_amount_eur == 55 with input as farm with input.o6_9.claims.trailing_hose.volume_m3 as 50
}

test_shared_cap_ambiguous if {
	events := [application, object.union(application, {"method": "injection"})]
	claims := object.union(farm.o6_9.claims, {"injection": {"date": "2026-11-30", "volume_m3": 50}})
	p.allocation_review_required with input as farm with input.o6_9.spreading as events with input.o6_9.claims as claims
	not p.spread_amount_eur with input as farm with input.o6_9.spreading as events with input.o6_9.claims as claims
}

test_fertilisable_basis if {
	parcels := [parcel, object.union(parcel, {"pure_legumes": true}), object.union(parcel, {"total_fertilizer_ban": true}), object.union(parcel, {"n_demand_napv": false}), object.union(parcel, {"country": "DE"})]
	p.fertilisable_ha == 2 with input.land.parcels as parcels
	not p.fertilisable_ha with input.land.parcels as [object.remove(parcel, {"n_demand_napv"})]
}

test_reject_events if {
	every patch in [{"method": "oscillating"}, {"method": "splash_plate"}, {"material": "solid"}, {"parcel_id": "X"}, {"originally_liquid": false}, {"technique_meets_definition": false}, {"date": "2025-01-01"}] {
		not p.eligible_spreading(object.union(application, patch)) with input as farm
	}
}

test_equipment if {
	not p.equipment_ok({"ownership": "external"})
	p.equipment_ok({"ownership": "external", "service_evidence": true})
	p.equipment_ok({"ownership": "shared", "inspectable_at_participant": true, "invoice_to_participants_available": true})
	not p.equipment_ok({"ownership": "shared", "inspectable_at_participant": true, "invoice_to_participants_available": false})
}

bio := {"material": "digestate", "originally_liquid": true, "substrate_proof": true}

test_digestate_ingredients if {
	ok := [{"name": "Silagen", "confirmed": []}, {"name": "Ölsaatenrückstände", "confirmed": ["extraktionsmittelfrei"]}]
	p.material_ok(object.union(bio, {"substrates": ok}))
	not p.material_ok(object.union(bio, {"substrates": array.concat(ok, [{"name": "Speiseölreste", "confirmed": []}])}))
	not p.material_ok(object.union(bio, {"substrates": [{"name": "Ölsaatenrückstände", "confirmed": []}]}))
	not p.material_ok(object.union(bio, {"substrate_proof": false, "substrates": ok}))
}

test_separation_without_spreading if {
	e := {"own_cattle_slurry": true, "mechanically_separated_on_farm": true, "date": "2026-03-02", "volume_m3": 30, "ownership": "own"}
	p.separation_amount_eur == 36 with input as farm with input.o6_9.spreading as [] with input.o6_9.separations as [e] with input.o6_9.claims.separation as {"date": "2026-11-30", "volume_m3": 30}
	not p.eligible_separation(object.union(e, {"own_cattle_slurry": false})) with input as farm
}

test_gve_sources if {
	p.pig_density_met with input as farm
	not p.pig_density_met with input as farm with input.land.arable_area_ha as 2.01
	not p.gve_total("pigs") with input.livestock.species_groups as [object.union(pig, {"fluctuating": true})]
	p.gve_total("pigs") == 0.5 with input.livestock.species_groups as [object.union(pig, {"fluctuating": true, "average_list_submitted": true, "annual_average": 1})]
	p.animal_factor(object.union(cattle, {"breed": "Dexter", "gve_category": "dwarf_u24"})) == 0.3
}

test_calendar_deadlines if {
	p.base_entry_ok with input.farm.year as 2027 with input.o6_9.base_application_date as "2026-12-31"
	not p.base_entry_ok with input.farm.year as 2028 with input.o6_9.base_application_date as "2027-12-31"
	p.feed_entry_ok with input.farm.year as 2028 with input.o6_9.base_contract_active as true with input.o6_9.feed_application_date as "2027-12-31"
	p.mfa_timely with input.farm.year as 2028 with input.o6_9.mfa_date as "2028-04-17"
	not p.mfa_timely with input.farm.year as 2026 with input.o6_9.mfa_date as "2026-04-16"
	not p.claimed_volume("trailing_hose") with input as farm with input.o6_9.claims.trailing_hose.date as "2026-12-01"
	not p.valid_date("2026-02-30")
}

test_no_claim_and_renewal if {
	p.no_annual_claim with input as farm with input.o6_9.claims as {} with input.o6_9.feeding.participating as false
	not p.no_annual_claim with input as farm with input.o6_9.claims as {} with input.o6_9.feeding.participating as true
	p.contract_continuation with input as farm with input.o6_9.base_contract_active as true with input.o6_9.withdrawal_date as null with input.o6_9.mfa_date as "2026-04-15"
}

feeding := {"all_pigs_covered": true, "participating": true, "groundwater_option": false, "recipes_88_available": true, "ingredients": [{"kind": "compound", "protein_source": "manufacturer"}], "rations": [{"category": "lactating", "protein_g_kg_88": 155}]}

test_feeding_alone if {
	p.feed_amount_eur == 108 with input as farm with input.o6_9.spreading as [] with input.o6_9.feeding as feeding with input.o6_9.eligible_arable_ha as 2
	not p.feeding_ok with input as farm with input.o6_9.feeding as object.union(feeding, {"groundwater_option": true})
	not p.feeding_ok with input as farm with input.farm.year as 2024 with input.o6_9.feeding as feeding
}

test_ration_alternatives if {
	rs := [{"category": "finishing", "weight_kg": 32, "protein_g_kg_88": 170}, {"category": "finishing", "weight_kg": 60, "protein_g_kg_88": 155}, {"category": "finishing", "weight_kg": 90, "protein_g_kg_88": 150}]
	p.rations_ok({"rations": rs, "finishing_mean_g_kg_88": 157})
	p.rations_ok({"rations": rs, "finishing_mean_g_kg_88": 158, "phase_technically_possible": true, "phase_actually_used": true})
	not p.rations_ok({"rations": rs, "finishing_mean_g_kg_88": 158, "phase_technically_possible": false, "phase_actually_used": true})
	not p.rations_ok({"rations": [{"category": "finishing", "weight_kg": 90, "protein_g_kg_88": 151}], "phase_technically_possible": true, "phase_actually_used": true})
	not p.rations_ok({"rations": [{"category": "lactating", "protein_g_kg_88": 156}], "finishing_mean_g_kg_88": 155})
}

test_drought_scope if {
	d := object.union(parcel, {"federal_state": "Steiermark", "district": "Weiz", "normal_harvest": "autumn", "heat_drought_sensitive": true, "drought_no_harvestable_crop": true})
	p.drought_exception(d) with input.farm.year as 2026
	not p.drought_exception(d) with input.farm.year as 2025
	not p.drought_exception(object.union(d, {"district": "Liezen"})) with input.farm.year as 2026
}

test_combination_matrix if {
	p.combination_cell("9", "16") == "x"
	p.combination_cell("9", "18") == ""
	p.combination_cell("1A", "4") == "x1)"
	p.combination_cell("1B", "16") == "a"
	p.combination_cell("10", "12") == "x3)"
}

test_modulation_and_sanctions if {
	p.modulation_factor == 0.9375 with input.land.home_area_ha as 400
	p.sanction_schedule.warning == "Verwarnung" with input.farm.year as 2026
	p.sanction_schedule.warning == 1 with input.farm.year as 2027
}

test_device_descriptions if {
	p.technique_ok({"method": "trailing_hose", "device": {"near_ground": true, "contact_pressure": false, "loose_flexible_hoses": true}})
	p.technique_ok({"method": "trailing_shoe", "device": {"contact_pressure": true, "application_share": true, "direct_on_infiltrable_soil": true}})
	p.technique_ok({"method": "injection", "device": {"opens_soil": true, "into_soil_same_pass": true}})
	not p.technique_ok({"method": "injection", "technique_meets_definition": true, "device": {"opens_soil": true, "into_soil_same_pass": false}})
}

test_grouped_records if {
	a := {"parcel_id": "A", "crop": "Weizen", "quantity": 20, "area_ha": 2, "method": "injection", "date": "2026-03-10"}
	b := object.union(a, {"parcel_id": "B", "area_ha": 3})
	p.group_log_ok([a, b], 5)
	not p.group_log_ok([a, b], 2)
	not p.group_log_ok([a, object.union(b, {"quantity": 25})], 5)
	not p.group_log_ok([a, object.union(b, {"crop": "Gerste"})], 5)
	not p.group_log_ok([a, object.union(b, {"date": "2026-03-11"})], 5)
	not p.group_log_ok([a, object.union(b, {"method": "trailing_shoe"})], 5)
}

test_conflicting_sources_need_review if {
	bio_event := object.union(application, object.union(bio, {"substrates": [{"name": "Maisquellwasser"}]}))
	count(p.review_items) == 2 with input as farm with input.o6_9.spreading as [bio_event] with input.o6_9.feeding.rations as [{"category": "unserved_gilt", "weight_kg": 44}]
	not p.material_ok(bio_event)
	not p.rations_ok({"rations": [{"category": "unserved_gilt", "weight_kg": 44}], "finishing_mean_g_kg_88": 140})
}

test_category_limits if {
	every row in [
		{"category": "piglet", "weight_kg": 8, "protein_g_kg_88": 166},
		{"category": "served_gilt", "weight_kg": 50, "protein_g_kg_88": 125},
		{"category": "pregnant", "weight_kg": 180, "protein_g_kg_88": 125},
		{"category": "boar", "weight_kg": 50, "protein_g_kg_88": 170},
		{"category": "lactating", "weight_kg": 180, "protein_g_kg_88": 155},
	] {
		p.rations_ok({"rations": [row]})
		not p.rations_ok({"rations": [object.union(row, {"protein_g_kg_88": row.protein_g_kg_88 + 1})]})
	}
	p.feed_source_ok({"kind": "individual", "tested": false, "protein_source": "literature"})
	not p.feed_source_ok({"kind": "individual", "tested": true, "protein_source": "literature"})
	not p.feed_source_ok({"kind": "compound", "protein_source": "literature"})
}

test_no_lapse_on_missing_volume if {
	not p.no_annual_claim with input as farm with input.o6_9.feeding.participating as false with input.o6_9.claims as {"injection": {"date": "2026-09-10"}}
	p.no_annual_claim with input as farm with input.farm.year as 2024 with input.o6_9.claims as {}
}

test_application_date_and_withdrawal if {
	not p.base_entry_ok with input.farm.year as 2027 with input.o6_9.base_application_date as "2027-01-01"
	not p.feed_entry_ok with input.farm.year as 2028 with input.o6_9.base_contract_active as false with input.o6_9.feed_application_date as "2027-12-31"
	p.withdrawn_in_year with input.farm.year as 2026 with input.o6_9.withdrawal_date as "2026-12-31"
	not p.withdrawn_in_year with input.farm.year as 2026 with input.o6_9.withdrawal_date as "2027-01-01"
}

test_minimum_size_and_ownership if {
	p.size_ok with input.farm.oepul_participation_year as 1 with input.land.austrian_protected_cultivation_ha as 0.50
	p.size_ok with input.farm.oepul_participation_year as 1 with input.land.austrian_minimum_size_area_ha as 1.50
	not p.size_ok with input.farm.oepul_participation_year as 1 with input.land.austrian_minimum_size_area_ha as 1.49 with input.land.austrian_protected_cultivation_ha as 0.49
	p.size_ok with input.farm.oepul_participation_year as 2
	p.applicant_form_ok with input.farm.applicant as {"form": "legal_person", "public_share_percent": 25}
	not p.applicant_form_ok with input.farm.applicant as {"form": "legal_person", "public_share_percent": 25.1}
	not p.public_body_exception("9") with input.farm.year as 2026
}

test_precise_matrix_exceptions if {
	ctx := {"protected_pots_or_substrate": false, "strip": "none", "landscape_elements_only": false}
	p.parcel_combination_ok("9", "16", ctx)
	not p.parcel_combination_ok("9", "16", object.union(ctx, {"strip": "AG"}))
	not p.parcel_combination_ok("1A", "4", ctx)
	p.parcel_combination_ok("1A", "4", object.union(ctx, {"landscape_elements_only": true}))
	not p.parcel_combination_ok("1B", "16", object.union(ctx, {"pesticide_waiver": true}))
	p.combination_discount("10", "12", object.union(ctx, {"organism_supplement": true}))
}

test_geography_by_plot_not_headquarters if {
	d := object.union(parcel, {"federal_state": "Wien", "normal_harvest": "autumn", "heat_drought_sensitive": true, "drought_no_harvestable_crop": true, "properly_sown": true, "annual_care": true, "arable_forage": false})
	p.arable_care_ok(d) with input.farm.year as 2026 with input.farm.region.federal_state as "Tirol"
	not p.arable_care_ok(object.union(d, {"properly_sown": false})) with input.farm.year as 2026
	not p.arable_care_ok(object.union(d, {"normal_harvest": "other"})) with input.farm.year as 2026
}

test_scoped_op if {
	count(p.parcel_reasons(object.union(parcel, {"payment_controls": {"mfa_codes": ["OPBIO"]}}))) == 0 with input.o6_9.measure_op_code as "OP9"
	"OP" in p.parcel_reasons(object.union(parcel, {"payment_controls": {"mfa_codes": ["OP"]}}))
}

test_takeover_and_sanction if {
	takeover := {"event": "division", "online_application": true, "approved_by_ama": true, "previous_participant": false, "date": "2028-04-17", "transferred_ha": 2, "additional_ha": 1}
	p.takeover_area_ok with input.farm.year as 2028 with input.o6_9.takeover as takeover
	not p.takeover_area_ok with input.farm.year as 2028 with input.o6_9.takeover as object.union(takeover, {"additional_ha": 1.01})
	p.sanction_outcome == "Ausschluss und Rückforderung" with input.farm.administration as {"graded_stage": "100", "prior_full_reductions_in_contract": 1}
	p.advance_max_eur(100) == 75 with input.farm.administration.administrative_checks_complete as true
}
