package oepul.o6_11

import data as ref
import rego.v1

farm := object.get(input, "farm", {})
land := object.get(input, "land", {})
parcels := object.get(land, "parcels", [])
oepul := object.get(farm, "oepul", {})
measure_applications := object.get(oepul, "measure_applications", [])

target_category(p) := category if {
	category := object.get(object.get(p, "crop", {}), "crop_category", null)
	category in ref.eligible_crop_categories
}

excluded_orchard_crop(p) if {
	category := object.get(object.get(p, "crop", {}), "crop_category", null)
	category == "orchard"
	crop_name := object.get(object.get(p, "crop", {}), "crop_name", null)
	crop_name in ref.excluded_orchard_crops
}

target_parcel(p) if {
	target_category(p)
	land_use := object.get(p, "land_use", null)
	land_use == "special_crop"
}

target_area_ha := total if {
	values := [p.area_ha | some p in parcels; target_parcel(p)]
	total := sum(values)
}

first_year := object.get(farm, "year", null)

default minimum_participation_area_satisfied := false

minimum_participation_area_satisfied if {
	target_area_ha >= 0.5
}

protected_cultivation_area_ha := object.get(land, "protected_cultivation_area_ha", 0)
oepul_eligible_area_ha := object.get(land, "oepul_eligible_area_ha", 0)
k20_continuation_only := object.get(oepul, "k20_continuation_only", false)

default general_minimum_farm_size_satisfied := false

general_minimum_farm_size_satisfied if {
	protected_cultivation_area_ha >= 0.5
}

general_minimum_farm_size_satisfied if {
	oepul_eligible_area_ha >= 1.5
}

general_minimum_farm_size_satisfied if {
	k20_continuation_only
}

contract_start_year := object.get(oepul, "o6_11_contract_start_year", null)

contract_end_year := 2028 if {
	contract_start_year in {2023, 2024, 2025}
}

contract_duration_years := duration if {
	contract_start_year in {2023, 2024, 2025}
	duration := (contract_end_year - contract_start_year) + 1
}

contract_duration_satisfied if {
	contract_duration_years >= 4
}

application_year := object.get(oepul, "o6_11_application_year", null)

application_deadline_satisfied if {
	application_year == null
}

application_deadline_satisfied if {
	application_year >= 2023
	application_year <= 2025
}

last_entry_satisfied if {
	application_year == null
}

last_entry_satisfied if {
	application_year <= 2025
}

herbicide_application(app) if {
	effect_type := object.get(app, "effect_type", null)
	effect_type == "Herbizid"
}

herbicide_application(app) if {
	object.get(app, "is_herbicide", false)
}

herbicide_use_on_target_parcel if {
	some p in parcels
	target_parcel(p)
	operations := object.get(p, "operations", {})
	applications := object.get(operations, "pesticide_applications", [])
	some app in applications
	herbicide_application(app)
}

default herbicide_ban_satisfied := false

herbicide_ban_satisfied if {
	not herbicide_use_on_target_parcel
}

formic_acid_use_on_target_parcel if {
	some p in parcels
	target_parcel(p)
	operations := object.get(p, "operations", {})
	applications := object.get(operations, "pesticide_applications", [])
	some app in applications
	ingredient := object.get(app, "active_ingredient", "")
	lower(ingredient) == "ameisensäure"
}

purchase_or_storage_of_herbicide if {
	purchases := object.get(oepul, "herbicide_purchases_storage", [])
	some item in purchases
	object.get(item, "is_herbicide", false)
	not object.get(item, "permitted_for_other_crops", false)
}

default purchase_storage_ban_satisfied := false

purchase_storage_ban_satisfied if {
	not purchase_or_storage_of_herbicide
}

bio_participation_conflict if {
	some m in measure_applications
	object.get(m, "measure_id", "") == "o6_1b"
	object.get(m, "active", false)
	object.get(m, "participation_type", "whole_farm") != "teilbetrieb_acker_gruenland"
}

default combination_satisfied := false

combination_satisfied if {
	not bio_participation_conflict
}

premium_eur_per_ha := value if {
	first_year == 2023
	value := ref.premium_eur_per_ha["2023"]
}

premium_eur_per_ha := value if {
	first_year >= 2024
	value := ref.premium_eur_per_ha["2024_and_later"]
}

premium_eligible_parcel(p) if {
	target_parcel(p)
	not object.get(p, "o6_11_code", "") == "OP"
	not object.get(p, "o6_11_code", "") == "OP11"
	not excluded_orchard_crop(p)
	plant_material := object.get(object.get(p, "crop", {}), "plant_material_is_grafted", true)
	plant_material
}

premium_area_ha := total if {
	values := [p.area_ha | some p in parcels; premium_eligible_parcel(p)]
	total := sum(values)
}

premium_amount_eur := amount if {
	rate := premium_eur_per_ha
	area := premium_area_ha
	amount := rate * area
}

psm_reporting_required if {
	first_year <= 2025
}

psm_reporting_not_required if {
	first_year >= 2026
}

o6_11_measure_application if {
	some m in measure_applications
	object.get(m, "measure_id", "") == "o6_11"
}

default area_access_is_annually_bound := false

area_access_is_annually_bound if {
	o6_11_measure_application
}

violations contains {"code": "minimum_participation_area", "severity": "access"} if {
	not minimum_participation_area_satisfied
}

violations contains {"code": "general_minimum_farm_size", "severity": "access"} if {
	not general_minimum_farm_size_satisfied
}

violations contains {"code": "contract_duration", "severity": "access"} if {
	contract_start_year != null
	not contract_duration_satisfied
}

violations contains {"code": "herbicide_use", "severity": "content"} if {
	herbicide_use_on_target_parcel
}

violations contains {"code": "formic_acid_use", "severity": "content"} if {
	formic_acid_use_on_target_parcel
}

violations contains {"code": "purchase_or_storage", "severity": "content"} if {
	purchase_or_storage_of_herbicide
}

violations contains {"code": "bio_combination", "severity": "combination"} if {
	bio_participation_conflict
}

decision := {
	"measure": "o6_11",
	"eligible": minimum_participation_area_satisfied,
	"general_minimum_farm_size_satisfied": general_minimum_farm_size_satisfied,
	"target_area_ha": target_area_ha,
	"premium_area_ha": premium_area_ha,
	"premium_eur_per_ha": premium_eur_per_ha,
	"premium_amount_eur": premium_amount_eur,
	"contract_end_year": contract_end_year,
	"herbicide_ban_satisfied": herbicide_ban_satisfied,
	"purchase_storage_ban_satisfied": purchase_storage_ban_satisfied,
	"combination_satisfied": combination_satisfied,
	"violations": violations,
	"profile_requirements": [
		"farm.oepul.o6_11_application_year",
		"farm.oepul.o6_11_contract_start_year",
		"farm.oepul.measure_applications[]",
		"land.parcels[].operations.pesticide_applications[]",
		"farm.oepul.herbicide_purchases_storage[]",
	],
}
