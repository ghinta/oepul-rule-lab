package oepul.o6_15_test

import data.oepul.o6_15 as policy
import rego.v1

stay := {"alp_id": "A", "herd_id": "F", "arrival": "2026-06-01", "departure": "2026-07-31", "arrival_report": "2026-06-15", "departure_report": "2026-08-14", "herded": true, "milking_dates": [], "channel": "Alm-/Weidemeldung Rinder"}
bull := {"id": "R", "species": "cattle", "breed": "Fleckvieh", "birth_date": "2024-07-01", "count": 1, "claimed_milk": false, "stays": [stay]}
pasture := {"id": "A", "applicant_alp": true, "categories": ["other_cattle"], "herder_ids": ["Anna"], "area_ha": 10, "stocked_rgve": 3, "claimed_dog_ids": [], "in_austria": true, "managed_from_home": false, "in_alpine_register": true, "clear_boundary": true, "grazed_forage_vegetation": true, "daily_care": true, "substantial_part_of_day": true, "night_care_needed": false, "adequate_water": true, "animal_care": true, "treatment_arranged": true, "safety_measures": true, "site_adapted_grazing": true, "suitable_lodging": true, "list_submitted": "2026-07-15"}
general := {"participation_year": 1, "qualifying_at_ha": 1.5, "public_body_or_institution": false, "equivalent_public_influence": false, "controlled_by_excluded_entity": false, "legal_form": "legal_entity", "public_share_pct": 25, "own_name": true, "own_account": true, "disposal_over_land": true, "active_farmer": true, "agricultural_activity": true}
record := {"almbewirtschaftung": true, "annual_mfa": true, "withdrawn_this_year": false, "contract_continued": true, "animals": [bull, object.union(bull, {"id": "R2"}), object.union(bull, {"id": "R3"})], "alps": [pasture], "general": general, "dogs": [], "state_topup": {"granted": false}}
farm := {"farm": {"year": 2026}, "behirtung": record}

test_first_example_two_shepherds if policy.premium(95, 40, 2, 0) == 9909 with input as farm

test_second_example_table_arithmetic if {
	policy.premium(48, 32, 1, 0) == 6696 with input as farm
	policy.premium(52, 15.50, 1, 1) == 5973.60 with input as farm
}

test_rates_and_caps if {
	policy.premium(51, 0, 1, 8) == 2250 + 3500 with input.farm.year as 2023
	policy.premium(51, 0, 2, 0) == 2511 with input.farm.year as 2024
	policy.premium(0, 0, 0, 6) == 3780 with input.farm.year as 2024
	policy.premium(20.5, 0, 1, 0) == 1633.5 with input as farm
	not policy.premium(4, 5, 1, 0) with input as farm
}

test_minimum_and_amount_end_to_end if {
	policy.amounts.A.modulated_eur == 243 with input as farm
	not policy.access with input as farm with input.behirtung.animals as [bull]
	not policy.access with input as farm with input.behirtung.almbewirtschaftung as false
	not policy.amounts.A with input as farm with input.behirtung.withdrawn_this_year as true
	not policy.amounts.A with input as farm with input.behirtung.general.public_share_pct as 25.01
}

test_cattle_age_and_dwarf_boundaries if {
	policy.factor(bull) == 1 with input as farm
	policy.factor(object.union(bull, {"birth_date": "2024-07-02"})) == 0.6 with input as farm
	policy.factor(object.union(bull, {"birth_date": "2026-01-01", "breed": "Dexter"})) == 0.3 with input as farm
	policy.factor(object.union(bull, {"birth_date": "2026-01-02", "breed": "Kerry"})) == 0.2 with input as farm
}

test_equids_use_breed_dimensions if {
	equid := {"species": "equids", "birth_date": "2023-07-01", "breed_height_m": 1.48, "breed_weight_kg": 300}
	policy.factor(equid) == 0.5 with input as farm
	policy.factor(object.union(equid, {"breed_weight_kg": 301})) == 1 with input as farm
	policy.factor(object.union(equid, {"breed_height_m": 1.49})) == 1 with input as farm
	not policy.factor({"species": "deer", "birth_date": "2020-01-01"}) with input as farm
}

test_reporting_deadlines if {
	count(policy.stay_days(bull, stay)) == 60 with input as farm
	count(policy.stay_days(bull, object.union(stay, {"arrival_report": "2026-06-16"}))) == 59 with input as farm
	policy.departure_ok(bull, stay)
	not policy.departure_ok(bull, object.union(stay, {"departure_report": "2026-08-15"}))
	goat := {"species": "goats"}
	s := {"arrival": "2026-07-10"}
	policy.flag_timely(goat, s, "2026-07-15") with input as farm
	not policy.flag_timely(goat, s, "2026-07-16") with input as farm
	policy.flag_timely(bull, s, "2026-07-24") with input as farm
	not policy.flag_timely(bull, s, "2026-07-25") with input as farm
	policy.departure_ok({"species": "camelids"}, object.union(stay, {"expected_departure": stay.departure}))
}

test_list_special_year_separate_from_arrival if {
	policy.list_timely({"list_submitted": "2028-07-17"}) with input.farm.year as 2028
	not policy.arrival_ok({"stays": [{"arrival": "2028-07-16"}]}) with input.farm.year as 2028
	not policy.list_timely({"list_submitted": "2026-07-16"}) with input as farm
}

test_contract_deadlines if {
	policy.entry_timely with input.farm.year as 2027 with input.behirtung.entry_application as "2026-12-31"
	not policy.entry_timely with input.farm.year as 2028 with input.behirtung.entry_application as "2027-12-31"
	policy.dog_entry_timely with input.farm.year as 2028 with input.behirtung.dog_entry_application as "2027-12-31"
	not policy.dog_entry_timely with input.farm.year as 2028 with input.behirtung.dog_entry_application as "2028-01-01"
}

test_sequential_animals_and_gap if {
	first := object.union(stay, {"departure": "2026-07-01"})
	second := object.union(stay, {"arrival": "2026-07-10", "arrival_report": "2026-07-10", "departure": "2026-08-09"})
	animals := [object.union(bull, {"stays": [first]}), object.union(bull, {"stays": [second]})]
	count(policy.stocked_days(pasture)) == 60 with input as farm with input.behirtung.animals as animals
	count(policy.herded_days(animals[0])) == 30 with input as farm
	both := object.union(bull, {"stays": [first, second]})
	count(policy.herded_days(both)) == 60 with input as farm
	count(policy.stocked_days(pasture)) == 30 with input as farm with input.behirtung.animals as [animals[0], animals[0]]
}

test_aliquot_across_alps if {
	p2 := object.union(pasture, {"id": "B", "herder_ids": ["Franz"]})
	first := object.union(stay, {"departure": "2026-08-06"})
	after := object.union(stay, {"alp_id": "B", "arrival": "2026-08-06", "arrival_report": "2026-08-07", "departure": "2026-09-19"})
	moved := object.union(bull, {"stays": [first, after]})
	other := object.union(bull, {"id": "B1", "stays": [object.union(stay, {"alp_id": "B"})]})
	animals := [moved, other]
	policy.credited_rgve(moved, pasture) == 0.6 with input as farm with input.behirtung.alps as [pasture, p2] with input.behirtung.animals as animals
	policy.credited_rgve(moved, p2) == 0.4 with input as farm with input.behirtung.alps as [pasture, p2] with input.behirtung.animals as animals
}

milk_dates := array.concat([sprintf("2026-06-%02d", [i]) | some i in numbers.range(1, 30)], [sprintf("2026-07-%02d", [i]) | some i in numbers.range(1, 15)])
cow := object.union(bull, {"claimed_milk": true, "first_calving": "2026-07-01", "stays": [object.union(stay, {"milking_dates": milk_dates})]})

test_milk_thresholds if {
	policy.dairy(cow) with input as farm
	not policy.dairy(object.union(cow, {"first_calving": "2026-07-02"})) with input as farm
	short := object.union(stay, {"milking_dates": array.slice(milk_dates, 0, 44)})
	not policy.dairy(object.union(cow, {"stays": [short]})) with input as farm
	policy.dairy(object.union(cow, {"species": "goats", "birth_date": "2025-07-01"})) with input as farm
	not policy.dairy(object.union(cow, {"species": "goats", "birth_date": "2025-07-02"})) with input as farm
}

test_state_topup if {
	p := object.union(pasture, {"categories": ["dairy_cows"]})
	policy.topup(p) == 40 with input as farm with input.behirtung.alps as [p] with input.behirtung.animals as [cow] with input.behirtung.state_topup as {"granted": true, "funds_timely": true, "notification": "2026-05-15"}
	policy.topup(p) == 0 with input as farm with input.behirtung.state_topup as {"granted": true, "funds_timely": true, "notification": "2026-05-16"}
}

test_category_and_herder_exclusivity if {
	not policy.unique_herders(pasture) with input.behirtung.alps as [pasture, object.union(pasture, {"id": "B"})]
	not policy.category_complete(pasture) with input as farm with input.behirtung.animals as [object.union(bull, {"stays": [object.union(stay, {"herded": false})]})]
	policy.category_complete(object.union(pasture, {"categories": ["goats"]})) with input as farm
}

dog := {"id": "D", "herd_id": "F", "trained_for_herd_protection": true, "permanent_herd_member": true, "day_and_night": true, "independent": true, "recognised_certificate_on_farm": true, "liability_insured": true, "deployments": [stay]}

test_dog_full_period_and_single_claim if {
	p := object.union(pasture, {"claimed_dog_ids": ["D"]})
	policy.dog_ok(dog, p) with input as farm with input.behirtung.alps as [p]
	not policy.dog_ok(dog, p) with input as farm with input.behirtung.alps as [p, object.union(p, {"id": "B"})]
	not policy.dog_ok(object.union(dog, {"deployments": [object.union(stay, {"arrival": "2026-06-02"})]}), p) with input as farm with input.behirtung.alps as [p]
	not policy.dog_ok(object.union(dog, {"liability_insured": false}), p) with input as farm with input.behirtung.alps as [p]
}

test_modulation_basis_and_tiers if {
	policy.modulation({"area_ha": 230, "stocked_rgve": 190}) == 1
	f := policy.modulation({"area_ha": 230, "stocked_rgve": 250})
	abs((f * 230) - 227) < 0.000001
	abs((policy.modulation({"area_ha": 1100, "stocked_rgve": 1200}) * 1100) - 960) < 0.000001
}

test_drought_no_automatic_alpine_waiver if {
	policy.drought_request_possible with input as farm with input.behirtung.drought_prevents_obligation as true
	not policy.care_ok(object.union(pasture, {"adequate_water": false}))
	parcel := {"land_use": "arable", "state": "Steiermark", "district": "Weiz", "usual_late_harvest": true, "heat_and_drought_affected": true, "no_harvestable_crop_due_to_drought": true}
	policy.harvest_exempt(parcel) with input as farm
	not policy.harvest_exempt(object.union(parcel, {"land_use": "alpine_pasture"})) with input as farm
	not policy.harvest_exempt(parcel) with input.farm.year as 2025
}

test_sanctions_and_annex if {
	policy.sanction_effect("Verwarnung", 0).percent == 1 with input.farm.year as 2027
	policy.sanction_effect("Verwarnung", 0).percent == 0 with input.farm.year as 2026
	policy.sanction_effect("100 %", 1).exclusion_and_recovery with input as farm
	policy.combination_cell("1B", "16").mark == "a"
	not policy.combination_cell("15", "14")
	policy.nature_rate("NAW1", 5) == 2.2 with input as farm
}

test_wrong_channel_and_late_milk_flag if {
	wrong := object.union(stay, {"channel": "Alm/Gemeinschaftsweide-Auftriebsliste"})
	count(policy.stay_days(bull, wrong)) == 0 with input as farm
	p := object.union(pasture, {"categories": ["dairy_cows"]})
	late := object.union(cow, {"stays": [object.union(cow.stays[0], {"milk_flag_added": "2026-06-16"})]})
	policy.milk_units(p) == 0 with input as farm with input.behirtung.alps as [p] with input.behirtung.animals as [late]
	policy.milk_units(p) == 1 with input as farm with input.behirtung.alps as [p] with input.behirtung.animals as [cow]
}

test_all_factor_rows_and_end_of_stay if {
	count(data.behirtung.rgve) == 18
	policy.factor({"species": "sheep", "birth_date": "2025-07-02"}) == 0.07 with input as farm
	policy.factor({"species": "goats", "birth_date": "2025-07-01"}) == 0.15 with input as farm
	policy.factor({"species": "camelids", "birth_date": "2025-07-02"}) == 0.07 with input as farm
	policy.factor({"species": "camelids", "birth_date": "2025-07-01"}) == 0.15 with input as farm
	count(policy.actual_days({"arrival": "2026-06-01", "departure": "2026-06-01"})) == 0 with input as farm
	count(policy.actual_days({"arrival": "2025-12-15", "departure": "2026-01-05"})) == 4 with input as farm
}

test_individual_sheep_goats if {
	sheep := object.union(bull, {"species": "sheep", "count": 1, "ear_tag": "AT123"})
	policy.identification_ok(sheep)
	not policy.identification_ok(object.union(sheep, {"ear_tag": ""}))
	not policy.identification_ok(object.union(sheep, {"count": 2}))
	s := object.union(stay, {"channel": "Alm/Gemeinschaftsweide-Auftriebsliste", "arrival_report": "2026-06-09", "departure_report": "2026-08-07"})
	count(policy.stay_days(sheep, s)) == 59 with input as farm
	policy.departure_ok(sheep, s)
	not policy.departure_ok(sheep, object.union(s, {"departure_report": "2026-08-08"}))
}

test_dog_two_separate_stays_no_pooling if {
	p := object.union(pasture, {"claimed_dog_ids": ["D"]})
	q := object.union(p, {"id": "B", "claimed_dog_ids": []})
	a40 := object.union(stay, {"departure": "2026-07-11"})
	b40 := object.union(stay, {"alp_id": "B", "arrival": "2026-07-11", "departure": "2026-08-20"})
	a := object.union(bull, {"stays": [a40, b40]})
	not policy.dog_ok(object.union(dog, {"deployments": [a40, b40]}), p) with input as farm with input.behirtung.animals as [a] with input.behirtung.alps as [p, q]
}

test_repeated_or_overlapping_input_excluded if {
	not policy.amounts.A with input as farm with input.behirtung.animals as [bull, bull, bull]
	cross := object.union(bull, {"stays": [stay, object.union(stay, {"alp_id": "B"})]})
	policy.overlapping_alps(cross)
}

test_general_entries if {
	policy.size_ok with input.behirtung.general as {"participation_year": 1, "protected_at_ha": 0.5}
	not policy.size_ok with input.behirtung.general as {"participation_year": 1, "protected_at_ha": 0.49, "qualifying_at_ha": 1.49}
	policy.size_ok with input.behirtung.general as {"participation_year": 2}
	not policy.applicant_ok with input as farm with input.behirtung.general.equivalent_public_influence as true
	policy.tolerated_loss(200) == 5
	policy.tolerated_loss(2) == 0.5
	policy.tierhaltend with input.land.grassland_area_ha as 8 with input.behirtung.general as {"arable_forage_ha": 2, "average_domestic_rgve": 3}
	policy.transfer_possible with input.behirtung.transfer as {"event": "division", "animal_predecessor": "B1", "land_predecessor": "B1", "online_application": true}
	not policy.transfer_possible with input.behirtung.transfer as {"event": "division", "animal_predecessor": "B1", "land_predecessor": "B2", "online_application": true}
}

test_reentry_and_exit_year if {
	count(policy.reentry_steps(2025, 2026, "2025-12-31")) == 1
	count(policy.reentry_steps(2025, 2026, "2026-01-15")) == 2
	not policy.reentry_steps(2025, 2027, "2026-01-15")
	policy.withdrawal_effective_in("2026-12-31") == 2026
	policy.withdrawal_effective_in("2027-01-01") == 2027
}
