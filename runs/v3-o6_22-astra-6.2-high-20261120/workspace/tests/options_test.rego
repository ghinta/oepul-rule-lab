package oepul.o6_22_test

import data.oepul.o6_22 as pig
import rego.v1

test_protein_definition_exactly_twenty if {
	pig.protein_feed({"kind": "compound", "roughage": false, "protein_pct_dm": 20}) == false
	pig.protein_feed({"kind": "compound", "roughage": false, "protein_pct_dm": 20.01})
	pig.protein_feed({"kind": "single", "roughage": false, "typical_protein_pct_dm": 22, "protein_pct_dm": 19})
	pig.protein_feed({"roughage": true, "protein_pct_dm": 35}) == false
}

test_feed_all_species_and_purchased_proof if {
	f := {"kind": "single", "roughage": false, "typical_protein_pct_dm": 40, "homegrown": false, "european_origin": true, "gmo_free": true, "origin_and_gmo_documented": true}
	pig.feed_ok with input.oepul_22 as {"feed_inventory_complete_year": true, "feed_lots": [f]}
	not pig.feed_ok with input.oepul_22 as {"feed_inventory_complete_year": true, "feed_lots": [f, object.union(f, {"gmo_free": false, "destination": "laying_hens"})]}
	not pig.feed_ok with input.oepul_22 as {"feed_inventory_complete_year": true, "feed_lots": [object.union(f, {"origin_and_gmo_documented": false})]}
	not pig.feed_ok with input.oepul_22 as {"feed_lots": []}
}

turn(d) := {"date": d, "device": "turner", "on_farm": true}
pile(d) := {"method": "turning", "turns": [turn("2026-01-01"), turn(d)]}

test_two_turns_at_least_fourteen_days_apart if {
	pig.pile_ok(pile("2026-01-15"))
	not pig.pile_ok(pile("2026-01-14"))
	not pig.pile_ok({"method": "turning", "turns": [turn("2026-01-01")]})
}

test_equivalent_device_and_external_proof if {
	t := {"device": "spreader", "equivalent_result": true, "fully_turned": true, "external_use_documented": true}
	pig.turn_ok(t)
	not pig.turn_ok(object.union(t, {"fully_turned": false}))
	not pig.turn_ok(object.union(t, {"device": "front_loader"}))
	not pig.turn_ok(object.union(t, {"external_use_documented": false}))
}

test_no_turn_alternative if {
	m := {"method": "mixed_or_layered", "significant_added_organics": true, "added_material": "green_cuttings", "composting_process_used": true}
	pig.pile_ok(m)
	not pig.pile_ok(object.union(m, {"significant_added_organics": false}))
}

test_compost_whole_farm_year_and_all_piles if {
	c := {"all_species_manure_piled_on_farm": true, "compost_barn": false, "nitrate_programme_met": true, "operations_documented": true, "piles": [pile("2026-01-15")]}
	pig.compost_ok with input.farm.year as 2026 with input.oepul_22.composting as c
	not pig.compost_ok with input.farm.year as 2024 with input.oepul_22.composting as c
	not pig.compost_ok with input.farm.year as 2026 with input.oepul_22.composting as object.union(c, {"piles": [pile("2026-01-15"), pile("2026-01-10")]})
	not pig.compost_ok with input.farm.year as 2026 with input.oepul_22.composting as object.union(c, {"compost_barn": true})
}

test_base_and_three_options_2026 if {
	g := object.union(group("fattening_110", 10, 0), {"participants_uncut_all_year": true})
	f := farm([g], ["fattening"])
	a := object.union(f.oepul_22, {"uncut_categories": ["fattening"], "feed_option": true, "feed_lots": [{"roughage": true}], "feed_inventory_complete_year": true, "compost_option": true, "composting": {"all_species_manure_piled_on_farm": true, "compost_barn": false, "nitrate_programme_met": true, "operations_documented": true, "piles": [pile("2026-01-15")]}})
	pig.premium_components.fattening == {"base": 210.6, "tail": 194.4, "feed": 194.4, "compost": 64.8} with input as f with input.oepul_22 as a
}

test_qualifying_area_first_year_only if {
	pig.farm_size_ok with input.oepul_22 as {"first_opul_year": false}
	pig.farm_size_ok with input.oepul_22 as {"first_opul_year": true, "protected_cultivation_at_ha": 0.5}
	pig.farm_size_ok with input.oepul_22 as {"first_opul_year": true, "qualifying_at_ha": 1.5}
	not pig.farm_size_ok with input.oepul_22 as {"first_opul_year": true, "protected_cultivation_at_ha": 0.49, "qualifying_at_ha": 1.49}
}

test_public_share_and_controlling_influence if {
	a := {"legal_form": "association", "public_share_pct": 25, "equivalent_public_control": false, "controlled_subsidiary": false, "public_body_or_institution": false, "own_name": true, "own_account": true, "control_of_claimed_land": true, "active_farmer": true, "agriculturally_active": true}
	pig.applicant_ok with input.oepul_22.applicant as a
	not pig.applicant_ok with input.oepul_22.applicant as object.union(a, {"public_share_pct": 25.01})
	not pig.applicant_ok with input.oepul_22.applicant as object.union(a, {"equivalent_public_control": true})
}

test_modulation_marginal_and_sanction_transition if {
	pig.modulation_factor(220) == 218 / 220
	pig.modulation_factor(1100) == 960 / 1100
	pig.sanction("warning", 2026) == 0
	pig.sanction("warning", 2027) == 1
	pig.sanction_consequence(100, 2026, 2).exclude
}

test_scope_of_drought_relief if {
	p := {"state": "Steiermark", "district": "Weiz", "arable": true, "normal_harvest": "autumn", "no_harvest_due_to_drought": true}
	pig.harvest_exception(p) with input.farm.year as 2026
	not pig.harvest_exception(object.union(p, {"district": "Liezen"})) with input.farm.year as 2026
	not pig.harvest_exception(p) with input.farm.year as 2027
}

test_dates_for_crop_lists_and_measure_lists if {
	not pig.listed_crop("fruit", "Papau", 2024)
	pig.listed_crop("fruit", "Papau", 2025)
	pig.programme_list_contains("annual_measures", "22", 2027)
	not pig.programme_list_contains("public_exceptions", "22", 2026)
	pig.area_cap("general", 2025).excluded_measures == [6, 7, "1C"]
}
