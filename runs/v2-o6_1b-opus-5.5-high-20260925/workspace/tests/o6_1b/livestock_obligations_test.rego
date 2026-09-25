package oepul.o6_1b_test

import data.oepul.o6_1b

groups_input(gs) := with_patch([{"op": "replace", "path": "/livestock/species_groups", "value": gs}])

test_rgve_and_livestock_category if {
	# 10 Rinder ab 2 Jahre auf 10 ha Grünland + 5 ha Kleegras = 0,667 RGVE/ha
	o6_1b.total_rgve == 10 with input as base_input
	o6_1b.forage_area_ha == 15 with input as base_input
	o6_1b.livestock_category == "livestock_lt_1_4" with input as base_input
}

test_livestock_threshold_0_30 if {
	# 4,5 RGVE / 15 ha = 0,30 -> tierhaltend
	gs := [{"species": "sheep_goats", "rgve_key": "sheep_ge_1", "animal_count": 30, "is_certified_organic": true}]
	o6_1b.is_livestock_farm with input as groups_input(gs)

	# 4,35 RGVE / 15 ha = 0,29 -> nicht-tierhaltend
	gs2 := [{"species": "sheep_goats", "rgve_key": "sheep_ge_1", "animal_count": 29, "is_certified_organic": true}]
	o6_1b.livestock_category == "non_livestock" with input as groups_input(gs2)
}

test_livestock_ge_1_4 if {
	gs := [{"species": "cattle", "rgve_key": "cattle_ge_2", "animal_count": 21, "is_certified_organic": true}]
	o6_1b.livestock_category == "livestock_ge_1_4" with input as groups_input(gs)
}

test_conventional_equids_not_counted if {
	gs := [{"species": "horses", "rgve_key": "horse_large_ge_3", "animal_count": 10, "is_conventional": true, "is_certified_organic": false}]
	o6_1b.total_rgve == 0 with input as groups_input(gs)
	vs := ids(o6_1b.violations) with input as groups_input(gs)
	not "O61B-BV-002" in vs
	"O61B-BV-007" in vs
}

test_conventional_and_organic_equids_not_allowed if {
	gs := [
		{"species": "horses", "rgve_key": "horse_large_ge_3", "animal_count": 2, "is_conventional": true, "is_certified_organic": false},
		{"species": "horses", "rgve_key": "horse_small_ge_3", "animal_count": 1, "is_conventional": false, "is_certified_organic": true},
	]
	"O61B-BV-004" in ids(o6_1b.violations) with input as groups_input(gs)
}

test_own_use_animals_limits if {
	ok := [
		{"species": "pigs", "category": "fattening_pig", "animal_count": 2, "own_use": true, "is_certified_organic": false},
		{"species": "poultry", "category": "chicken", "animal_count": 10, "own_use": true, "is_certified_organic": false},
	]
	count(o6_1b.violations) == 0 with input as groups_input(ok)
	too_many := [{"species": "pigs", "category": "fattening_pig", "animal_count": 3, "own_use": true, "is_certified_organic": false}]
	"O61B-BV-003" in ids(o6_1b.violations) with input as groups_input(too_many)
	wrong_species := [{"species": "poultry", "category": "duck", "animal_count": 2, "own_use": true, "is_certified_organic": false}]
	"O61B-BV-003" in ids(o6_1b.violations) with input as groups_input(wrong_species)
}

test_non_organic_cattle_not_allowed if {
	gs := [{"species": "cattle", "rgve_key": "cattle_ge_2", "animal_count": 5, "is_certified_organic": false}]
	"O61B-BV-002" in ids(o6_1b.violations) with input as groups_input(gs)
}

test_partial_farm_wine_allows_conventional_livestock if {
	inp := json.patch(groups_input([{"species": "cattle", "rgve_key": "cattle_ge_2", "animal_count": 5, "is_certified_organic": false}]), [{"op": "add", "path": "/oepul/o6_1b/partial_farm", "value": {"is_partial": true, "organic_culture_area": "wine_fruit_hops", "separate_facilities_and_land": true, "separate_input_storage": true, "applied_in_measure_application": true}}])
	not "O61B-BV-002" in ids(o6_1b.violations) with input as inp
}

test_psm_coding_until_2025_only if {
	p := object.union(arable("A9", 1, "Winterweizen"), {"operations": {"psm_used": true}})
	inp := json.patch(base_input, [{"op": "add", "path": "/land/parcels/-", "value": p}])
	not "O61B-PSM-001" in ids(o6_1b.violations) with input as inp
	inp25 := json.patch(inp, [{"op": "replace", "path": "/farm/year", "value": 2025}])
	"O61B-PSM-001" in ids(o6_1b.violations) with input as inp25
}

test_grassland_conversion_tolerance if {
	inp := with_patch([{"op": "add", "path": "/oepul/o6_1b/grassland", "value": {"converted_ha": 1.2, "new_grassland_ha": 0}}])
	"O61B-GL-001" in ids(o6_1b.violations) with input as inp
	inp2 := with_patch([{"op": "add", "path": "/oepul/o6_1b/grassland", "value": {"converted_ha": 1.2, "new_grassland_ha": 0.5}}])
	not "O61B-GL-001" in ids(o6_1b.violations) with input as inp2
	inp3 := with_patch([{"op": "add", "path": "/oepul/o6_1b/grassland", "value": {"reference_area_ha": 11.5}}])
	"O61B-GL-001" in ids(o6_1b.violations) with input as inp3
}

test_diversification_cereal_maize_75 if {
	ps := [arable("A1", 4, "Winterweizen"), arable("A2", 2, "Silomais"), arable("A3", 1.5, "Körnermais"), arable("A4", 0.6, "Sommergerste"), arable("A5", 1.9, "Kleegras")]

	# Weizen 4 + Mais 3,5 + Gerste 0,6 = 8,1 von 10 ha = 81 %
	"O61B-AD-001" in ids(o6_1b.violations) with input as with_parcels(ps)
}

test_diversification_single_crop_55_and_species_grouping if {
	# Körnermais und Silomais gelten als eine Kultur: 6 von 10 ha = 60 %
	ps := [arable("A1", 3, "Silomais"), arable("A2", 3, "Körnermais"), arable("A3", 4, "Kleegras")]
	"O61B-AD-002" in ids(o6_1b.violations) with input as with_parcels(ps)
}

test_diversification_fallow_exempt_from_2025 if {
	ps := [arable("A1", 6, "Grünbrache"), arable("A2", 4, "Winterweizen")]
	not "O61B-AD-002" in ids(o6_1b.violations) with input as with_parcels(ps)
	inp24 := json.patch(with_parcels(ps), [{"op": "replace", "path": "/farm/year", "value": 2024}])
	"O61B-AD-002" in ids(o6_1b.violations) with input as inp24
}

test_diversification_not_below_5ha if {
	ps := [arable("A1", 5, "Winterweizen")]
	not "O61B-AD-001" in ids(o6_1b.violations) with input as with_parcels(ps)
}

test_mixture_below_50_percent_cereal_not_cereal if {
	gemenge := object.union(arable("A2", 5, "Erbsen-Getreide Gemenge"), {"crop": {"crop_name": "Erbsen-Getreide Gemenge", "species": "Gerste", "cereal_share_percent": 40}})
	ps := [arable("A1", 4, "Winterweizen"), gemenge, arable("A3", 1, "Kleegras")]
	not "O61B-AD-001" in ids(o6_1b.violations) with input as with_parcels(ps)
}

test_training_deadline if {
	inp := with_patch([{"op": "replace", "path": "/oepul/o6_1b/training/courses", "value": [{"hours": 3, "topic": "biodiversity", "date": "2021-12-01", "provider_recognized": true}, {"hours": 5, "topic": "organic", "date": "2024-02-01", "provider_recognized": true, "credited_elsewhere": true}]}])
	vs := ids(o6_1b.violations) with input as inp
	"O61B-WB-001" in vs
	"O61B-WB-002" in vs
	inp25 := json.patch(inp, [{"op": "replace", "path": "/farm/year", "value": 2025}])
	not "O61B-WB-001" in ids(o6_1b.violations) with input as inp25
}

test_ungrafted_fruit_requires_op_code if {
	p := {"parcel_id": "O1", "area_ha": 1, "land_use": "special_crop", "schlagnutzungsart": "Walnüsse", "crop": {"crop_name": "Walnuss", "crop_category": "orchard", "is_grafted": false}}
	inp := json.patch(base_input, [{"op": "add", "path": "/land/parcels/-", "value": p}])
	"O61B-FL-006" in ids(o6_1b.violations) with input as inp
	o6_1b.premium_components.wine_fruit_hops == 0 with input as inp
}

test_harvest_obligation_and_drought_waiver_2026 if {
	late := object.union(arable("A9", 2, "Sojabohne"), {"crop": {"crop_name": "Sojabohne", "late_harvest_crop": true}, "operations": {"harvested_share_percent": 0, "no_harvestable_stand_due_to_drought": true}})
	inp := json.patch(base_input, [{"op": "add", "path": "/land/parcels/-", "value": late}])

	# Tulln (NÖ) liegt in der Gebietskulisse vom 05.08.2026
	not "O61B-ATB-004" in ids(o6_1b.violations) with input as inp
	inp_sbg := json.patch(inp, [{"op": "replace", "path": "/farm/region", "value": {"federal_state": "Salzburg", "district": "Zell am See"}}])
	"O61B-ATB-004" in ids(o6_1b.violations) with input as inp_sbg
	"A9" in o6_1b.force_majeure_report_required with input as inp_sbg

	# Erweiterung 12.08.2026: Steiermark, Bezirk Weiz
	inp_stmk := json.patch(inp, [{"op": "replace", "path": "/farm/region", "value": {"federal_state": "Steiermark", "district": "Weiz"}}])
	not "O61B-ATB-004" in ids(o6_1b.violations) with input as inp_stmk
}
