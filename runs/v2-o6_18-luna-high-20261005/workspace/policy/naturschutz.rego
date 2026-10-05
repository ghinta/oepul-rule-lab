package oepul.o6_18

import rego.v1

default decision := {"eligible": false, "violations": ["project_confirmation_required"], "known_codes": [], "premium_eur_ha": 0}

farm := object.get(input, "farm", {})
land := object.get(input, "land", {})
parcels := object.get(land, "parcels", [])
parcel := parcels[0] if count(parcels) > 0
parcel := {} if count(parcels) == 0
app := object.get(input, "application", {})
documentation := object.get(input, "documentation", {})
year := object.get(farm, "year", object.get(input, "year", 0))
codes := [code | item := object.get(parcel, "naturschutz_codes", [])[_]; code := object.get(item, "code", item)]
known_codes := {row.code | row := data.o6_18.naturschutz_auflagen.rows[_]}

code_known if count(codes) == 0

code_known if {
	count(codes) > 0
	every code in codes { code in known_codes }
}

some_project_confirmation if {
	some item in parcels
	object.get(item, "project_confirmation", false) == true
}

violations contains "wrong_measure" if object.get(app, "measure", "o6_18") != "o6_18"

violations contains "project_confirmation_required" if {
	object.get(app, "project_confirmation", false) != true
	not some_project_confirmation
}

violations contains "minimum_participation_missing" if object.get(app, "has_managed_parcel", true) == false

violations contains "parcel_outside_scope" if {
	some item in parcels
	land_use := object.get(item, "land_use", "")
	land_use != "arable"
	land_use != "grassland"
}

violations contains "unknown_annex_i_code" if not code_known
violations contains "nat_code_required" if object.get(app, "nat_code", true) == false
violations contains "nature_reference_area_required" if object.get(app, "nature_reference_area", true) == false
violations contains "use_or_care_interval" if object.get(app, "use_or_care_within_two_years", true) == false
violations contains "grassland_use_frequency" if object.get(app, "grassland_uses_per_year", 0) > 3
violations contains "prohibited_intervention" if object.get(app, "prohibited_interventions", false) == true

violations contains "grassland_resowing_without_approval" if {
	object.get(app, "grassland_resowing", false) == true
	object.get(app, "grassland_resowing_written_approval", false) != true
}

violations contains "additional_grazing_fertilization" if {
	object.get(app, "additional_grazing_fertilization", false) == true
	object.get(parcel, "is_mown_pasture", false) != true
}

violations contains "sludge_application" if object.get(app, "sludge_or_sludge_compost_applied", false) == true

violations contains "project_confirmation_not_amended" if {
	object.get(app, "management_changed", false) == true
	object.get(app, "project_confirmation_amended", false) != true
}

violations contains "grazing_diary_required" if {
	object.get(app, "grazing_required", false) == true
	object.get(documentation, "grazing_diary_complete", false) != true
}

violations contains "phenology_monitoring_required" if {
	some code in codes
	code in {"GL06", "GL15", "GL25"}
	object.get(app, "phenology_monitoring", false) != true
}

violations contains "great_bustard_monitoring_required" if {
	some code in codes
	code in {"TA01", "TB01"}
	object.get(app, "great_bustard_monitoring", false) != true
}

violations contains "regional_participation_confirmation_required" if {
	object.get(app, "regional_plan", false) == true
	object.get(app, "regional_participation_confirmation", false) != true
}

violations contains "regional_goals_missing" if {
	object.get(app, "regional_plan", false) == true
	object.get(app, "regional_goals_and_confirmation", true) == false
}

violations contains "div_nat_code_required" if {
	object.get(app, "div_credit", false) == true
	object.get(app, "nat_code", true) != true
}

violations contains "div_code_required" if {
	object.get(app, "div_credit", false) == true
	object.get(app, "div_code", "") == ""
}

violations contains "div_minimum_area" if {
	object.get(app, "ubb_or_bio", false) == true
	object.get(parcel, "field_piece_area_ha", 0) > 5
	object.get(parcel, "div_area_ha", 0) < 0.15
}

violations contains "early_arable_use_requires_op_code" if {
	year == data.o6_18.duerre_2026.year
	object.get(app, "early_arable_biodiversity_use", false) == true
	op := object.get(app, "op_code", "")
	not code_allowed(op, data.o6_18.duerre_2026.early_arable_biodiversity.requires_code)
}

violations contains "early_arable_use_limit" if {
	year == data.o6_18.duerre_2026.year
	object.get(app, "early_arable_biodiversity_use", false) == true
	object.get(app, "biodiversity_use_count", 0) > data.o6_18.duerre_2026.early_arable_biodiversity.max_uses
}

violations contains "early_grassland_use_requires_op_code" if {
	year == data.o6_18.duerre_2026.year
	object.get(app, "early_grassland_biodiversity_use", false) == true
	op := object.get(app, "op_code", "")
	not code_allowed(op, data.o6_18.duerre_2026.early_grassland_biodiversity.requires_code)
}

violations contains "divsz_comparable_second_cut_required" if {
	year == data.o6_18.duerre_2026.year
	object.get(app, "early_grassland_biodiversity_use", false) == true
	object.get(app, "div_code", "") == "DIVSZ"
	object.get(app, "comparable_second_cut", false) != data.o6_18.duerre_2026.early_grassland_biodiversity.divsz_comparator_second_cut_required
}

violations contains "third_use_requires_op_code" if {
	year == data.o6_18.duerre_2026.year
	object.get(app, "biodiversity_use_count", 0) == 3
	op := object.get(app, "op_code", "")
	not code_allowed(op, data.o6_18.duerre_2026.third_arable_biodiversity_use.requires_code)
}

code_allowed(code, allowed) if code in allowed

violations contains "naturschutz_date_exception_not_applicable" if {
	year == 2026
	object.get(app, "naturschutz_date_exception", false) == true
	object.get(app, "use_date", "") < "2026-08-12"
}

chapter(code) := substring(code, 0, 1)

violations contains "incompatible_annex_j_chapters" if {
	some pair in data.o6_18.kombinationen.incompatible_pairs
	some first in codes
	some second in codes
	first != second
	chapter(first) == pair[0]
	chapter(second) == pair[1]
}

violations contains "incompatible_annex_j_chapters" if {
	some pair in data.o6_18.kombinationen.incompatible_pairs
	some first in codes
	some second in codes
	first != second
	chapter(first) == pair[1]
	chapter(second) == pair[0]
}

violations contains "fallow_area_limit" if object.get(app, "nat_fallow_area_ha", 0) > max([object.get(land, "arable_area_ha", 0) * 0.25, 2])

violations contains "gloez_not_premium_eligible" if {
	some item in parcels
	object.get(item, "gloez4_or_gloez8_part", false) == true
}

violations contains "application_deadline" if {
	submission := object.get(app, "submission_date", "")
	deadline := object.get(app, "deadline", "")
	submission != ""
	deadline != ""
	submission > deadline
}

violations contains "switch_after_deadline" if object.get(app, "switch_date", "") > "2025-12-31"
violations contains "austrian_location" if object.get(object.get(farm, "region", {}), "country", "Austria") != "Austria"
violations contains "full_period_not_met" if object.get(app, "obligations_full_period", true) == false

violations contains "area_access_limit" if {
	access_year := object.get(app, "access_year", 2024)
	access_year > 2025
	object.get(app, "added_area_ha", 0) > max([object.get(app, "base_2025_area_ha", 0) * 0.5, 5])
}

violations contains "sanction_assessed" if object.get(app, "violation_assessed", false) == true

violations contains "harvest_requirement" if {
	some item in parcels
	object.get(item, "land_use", "") == "arable"
	object.get(item, "harvested_percent", 100) < 85
	not automatic_higher_force_exception
}

automatic_higher_force_exception if object.get(app, "automatic_drought_exception", false) == true

automatic_higher_force_exception if {
	year == data.o6_18.duerre_2026.year
	object.get(app, "drought_no_harvestable_stock", false) == true
	state := object.get(object.get(farm, "region", {}), "federal_state", "")
	covered := object.get(data.o6_18.duerre_2026.automatic_higher_force_harvest.states, state, [])
	covered == "all"
}

automatic_higher_force_exception if {
	year == data.o6_18.duerre_2026.year
	object.get(app, "drought_no_harvestable_stock", false) == true
	state := object.get(object.get(farm, "region", {}), "federal_state", "")
	district := object.get(object.get(farm, "region", {}), "district", "")
	covered := object.get(data.o6_18.duerre_2026.automatic_higher_force_harvest.states, state, [])
	covered != "all"
	district in covered
}

premium_modulation := 1 if object.get(land, "total_area_ha", 0) <= 200

premium_modulation := 0.9 if {
	object.get(land, "total_area_ha", 0) > 200
	object.get(land, "total_area_ha", 0) <= 300
}

premium_modulation := 0.85 if {
	object.get(land, "total_area_ha", 0) > 300
	object.get(land, "total_area_ha", 0) <= 1000
}

premium_modulation := 0.75 if object.get(land, "total_area_ha", 0) > 1000
premium_eur_ha := sum([row.premium_eur_ha | row := data.o6_18.praemiensaetze.rows[_]; row.code in codes; row.premium_eur_ha != null])

decision := {
	"eligible": count(violations) == 0,
	"violations": sort([violation | violation := violations[_]]),
	"known_codes": sort([code | code := codes[_]; code in known_codes]),
	"premium_eur_ha": premium_eur_ha * premium_modulation,
}
