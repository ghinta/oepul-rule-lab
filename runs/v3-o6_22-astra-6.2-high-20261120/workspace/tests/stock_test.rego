package oepul.o6_22_test

import data.oepul.o6_22 as pig
import rego.v1

test_stock_class_rows_match_inventory if {
	rows := data.o6_22_tables.stock_classes
	is_array(rows)
	count(rows) == 10
	count({row.id | some row in rows}) == count(rows)
	every row in rows {
		f := farm([group(row.id, 1, 0)], [row.category])
		pig.category_gve(row.category) == row.gve with input as f
		pig.farm_pig_gve == row.gve with input as f
	}
}

group(cat, n, withdrawn) := {"species": "pigs", "category": cat, "animal_count": n, "held_in_austria": true, "withdrawn_count": withdrawn}

farm(groups, cats) := {"farm": {"year": 2026}, "land": {"total_area_ha": 220, "alpine_pasture_area_ha": 0}, "livestock": {"species_groups": groups}, "oepul_22": {"stock_basis": "april_1", "fluctuating_stock": false, "categories": cats}}

test_two_gve_across_categories if {
	f := farm([group("sow_covered", 1, 0), group("fattening_80", 5, 0)], ["sow", "fattening"])
	pig.minimum_met with input as f
	pig.participating_gve == 2 with input as f
	pig.premium_components == {"sow": {"base": 43.2}, "fattening": {"base": 105.3}} with input as f
}

test_withdrawal_drops_below_minimum if {
	f := farm([group("sow_covered", 4, 1)], ["sow"])
	pig.minimum_met == false with input as f
	pig.premium_components == {} with input as f
}

test_no_dilution_by_non_pigs_or_excluded_classes if {
	foreign := object.union(group("sow_covered", 10, 0), {"held_in_austria": false})
	f := farm([foreign, group("sow_covered", 4, 0), group("breeding_boar", 12, 0), group("outdoor_wild_boar", 10, 0), {"species": "cattle", "gve": 30}], ["sow"])
	pig.farm_pig_gve == 2 with input as f
	pig.participating_gve == 2 with input as f
}

test_invalid_inventory_remains_undefined if {
	f := farm([group("fattening_80", 5, 6)], ["fattening"])
	not pig.participating_gve with input as f
	not pig.farm_pig_gve with input as farm([group("unmapped", 5, 0)], ["sow"])
	not pig.participating_gve with input as farm([group("unmapped", 5, 0)], ["sow"])
	not pig.participating_gve with input as farm([{"species": "pigs", "category": "sow_covered", "animal_count": 4, "withdrawn_count": 0}], ["sow"])
}

test_tgd_includes_eligible_unselected_and_withdrawn if {
	f := farm([group("sow_covered", 20, 16), group("piglet_8", 1, 0)], ["sow"])
	pig.tgd_required with input as f
	pig.participating_gve == 2 with input as f
	pig.tgd_required == false with input as farm([group("sow_covered", 20, 0)], ["sow"])
}

test_tgd_2023_transition if {
	t := {"recognised_for_pigs": true, "start": "2023-04-15", "end": "2023-12-31"}
	f := farm([group("sow_covered", 21, 0)], ["sow"])
	pig.tgd_period_ok with input as f with input.farm.year as 2023 with input.oepul_22.tgd as t
	not pig.tgd_period_ok with input as f with input.farm.year as 2023 with input.oepul_22.tgd as object.union(t, {"start": "2023-04-16"})
	not pig.tgd_period_ok with input as f with input.oepul_22.tgd as object.union(t, {"start": "2026-01-02", "end": "2026-12-31"})
}

test_fluctuating_stock_requires_average if {
	g := object.union(group("sow_covered", 0, 0.4), {"year_average_count": 4.4})
	f := farm([g], ["sow"])
	not pig.participating_gve with input as f with input.oepul_22.fluctuating_stock as true
	pig.participating_gve == 2 with input as f with input.oepul_22.stock_basis as "average"
}

test_tail_scope_and_full_withdrawal if {
	ok := object.union(group("piglet_8", 40, 0), {"participants_uncut_all_year": true})
	other := object.union(group("piglet_20", 10, 10), {"participants_uncut_all_year": false})
	f := farm([ok, other, group("sow_covered", 12, 0)], ["piglet", "sow"])
	pig.premium_components.piglet.tail == 756 with input as f with input.oepul_22.uncut_categories as ["piglet"]
	not pig.tail_ok("piglet") with input as f with input.livestock.species_groups as [ok, object.union(other, {"withdrawn_count": 9})]
	not pig.tail_ok("sow") with input as f
}

test_categories_lapse_independently if {
	f := farm([group("sow_uncovered", 5, 0), group("fattening_80", 10, 10)], ["sow", "fattening"])
	pig.minimum_met with input as f
	pig.category_lapses("fattening") with input as f
	not pig.category_lapses("sow") with input as f
}

test_year_specific_rates if {
	pig.rate("piglet", "tail", 2023) == 250
	pig.rate("piglet", "tail", 2024) == 270
	pig.rate("fattening", "base", 2023) == 65
	pig.rate("sow", "feed", 2026) == 64.8
	pig.rate("sow", "compost", 2025) == 21.6
	not pig.rate("sow", "compost", 2024)
	not pig.rate("sow", "tail", 2025)
}

test_deadlines if {
	pig.entry_timely("category", "2026-12-31", 2027)
	not pig.entry_timely("category", "2027-01-01", 2027)
	not pig.entry_timely("category", "2027-12-31", 2028)
	pig.entry_timely("option", "2027-12-31", 2028)
	pig.correction_timely("2024-02-01", "2024-02-29")
	not pig.correction_timely("2024-02-01", "2024-03-01")
}

test_correction_requires_attachments if {
	c := {"payment_notice_received": "2024-02-01", "correction_filed": "2024-02-29", "online_tierliste": true, "movement_evidence_uploaded": true, "sketch_attached": false}
	not pig.valid_correction(c) with input.farm.year as 2024
	pig.valid_correction(object.union(c, {"sketch_attached": true})) with input.farm.year as 2024
}

test_status_separates_missing_evidence_from_known_shortfall if {
	f := farm([group("sow_covered", 21, 0)], ["sow"])
	pig.assessment.contract_checks == {"applicant": "incomplete", "holding_size": "incomplete", "animal_health_period": "incomplete"} with input as f
	pig.assessment.contract_checks.animal_health_period == "not_met" with input as f with input.oepul_22.tgd as {"recognised_for_pigs": false}
	pig.assessment.contract_checks.holding_size == "not_met" with input as f with input.oepul_22.first_opul_year as true with input.oepul_22.qualifying_at_ha as 1.49 with input.oepul_22.protected_cultivation_at_ha as 0.49
}

test_young_boar_and_breeding_boar if {
	pig.animal_class_for_boar(50, true) == "breeding_boar"
	pig.animal_class_for_boar(50, false) == "fattening_50"
	pig.animal_class_for_boar(85, false) == "fattening_80"
	pig.animal_class_for_boar(32, false) == "young_32"
}

test_positive_annual_fraction_and_tiny_withdrawal if {
	g := object.union(group("piglet_8", 0, 0.03), {"year_average_count": 0.13})
	f := farm([g], ["piglet"])
	pig.participating_gve == 0.007 with input as f with input.oepul_22.stock_basis as "average"
	not pig.category_lapses("piglet") with input as f with input.oepul_22.stock_basis as "average"
}

test_vis_reporting_and_deregistration_actions if {
	g := object.union(group("fattening_110", 20, 0), {"full_category_period_conforming": false})
	f := farm([g], ["fattening"])
	a := pig.required_actions with input as f with input.oepul_22.movements as [{"kind": "arrival", "reported_to_vis": false}]
	{r.rule_id | some r in a} == {"22-abmeldung", "22-vis"}
}

test_following_year_free_range_land if {
	p := {"parcel_id": "F1", "land_use": "arable", "freiland_use": {"prior_year_unpaved_pig_range": true, "back_in_rotation": false}}
	a := pig.required_actions with input.land.parcels as [p]
	some action in a
	action.rule_id == "22-freilandflaeche"
	action.parcel_id == "F1"
}
