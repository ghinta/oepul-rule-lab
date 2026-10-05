package oepul.o6_23

import rego.v1

o623 := object.get(object.get(input, "measure", {}), "o6_23", {})
parcels := object.get(object.get(input, "land", {}), "parcels", [])
application_year := object.get(object.get(input, "farm", {}), "year", 0)

required_n2_codes := [record.code | record := data.o6_23.premium_codes[_]]

premium_record(parcel) := record if {
	code := object.get(parcel, "n2_code", "")
	record := data.o6_23.premium_codes[_]
	record.code == code
}

code_known(parcel) if {
	premium_record(parcel)
}

fertilizer_applied(parcel) if {
	object.get(parcel, "fertilizer_applied", false)
}

fertilizer_applied(parcel) if {
	fertilizer := object.get(object.get(object.get(parcel, "operations", {}), "fertilizer", {}), "mineral_n_kg_per_ha", null)
	fertilizer != null
	fertilizer > 0
}

fertilizer_applied(parcel) if {
	fertilizer := object.get(object.get(object.get(parcel, "operations", {}), "fertilizer", {}), "organic_n_kg_per_ha", null)
	fertilizer != null
	fertilizer > 0
}

fertilizer_compliant(parcel) if {
	record := premium_record(parcel)
	record.fertilizer != "none"
}

fertilizer_compliant(parcel) if {
	record := premium_record(parcel)
	record.fertilizer == "none"
	not fertilizer_applied(parcel)
}

fertilizer_compliant(parcel) := false if {
	record := premium_record(parcel)
	record.fertilizer == "none"
	fertilizer_applied(parcel)
}

country_ok(parcel) if {
	object.get(parcel, "country", "") == "AT"
}

scope_conditions(parcel) if {
	object.get(parcel, "land_use", "") == "grassland"
	object.get(parcel, "is_natura2000_or_high_nature_value", false)
	object.get(parcel, "project_confirmation", false)
	country_ok(parcel)
	code_known(parcel)
	fertilizer_compliant(parcel)
	application_code_ok(parcel)
	cut_date_ok(parcel)
	obligation_combination_ok(parcel)
}

scope_ok(parcel) if {
	scope_conditions(parcel)
}

scope_ok(parcel) := false if {
	not scope_conditions(parcel)
}

application_code_ok(parcel) := value if {
	value := object.get(parcel, "application_code", "") == "N2"
}

cut_date_ok(parcel) if {
	cutoff := object.get(parcel, "project_confirmation_cut_date", null)
	cutoff == null
}

cut_date_ok(parcel) if {
	cutoff := object.get(parcel, "project_confirmation_cut_date", null)
	cutoff != null
	dates := object.get(object.get(parcel, "operations", {}), "cutting_dates", [])
	count(dates) == 0
}

cut_date_ok(parcel) if {
	cutoff := object.get(parcel, "project_confirmation_cut_date", null)
	cutoff != null
	dates := object.get(object.get(parcel, "operations", {}), "cutting_dates", [])
	count(dates) > 0
	dates[0] >= cutoff
}

cut_date_ok(_) if {
	exception_2026_cut_date
}

cut_date_ok(parcel) if {
	cutoff := object.get(parcel, "project_confirmation_cut_date", null)
	cutoff != null
	dates := object.get(object.get(parcel, "operations", {}), "cutting_dates", [])
	count(dates) > 0
	dates[0] < cutoff
	not exception_2026_cut_date
}

parcel_result(parcel) := result if {
	record := premium_record(parcel)
	valid := scope_ok(parcel)
	result := {
		"parcel_id": object.get(parcel, "parcel_id", null),
		"code": record.code,
		"valid": valid,
		"land_use": object.get(parcel, "land_use", null),
		"in_scope_area": object.get(parcel, "is_natura2000_or_high_nature_value", false),
		"project_confirmation": object.get(parcel, "project_confirmation", false),
		"application_code_ok": application_code_ok(parcel),
		"fertilizer_ok": fertilizer_compliant(parcel),
		"cut_date_ok": cut_date_ok(parcel),
		"premium_eur_ha": premium_per_ha(record),
	}
}

premium_per_ha(record) := value if {
	application_year == 2023
	value := record.premium_eur_ha_2023
}

premium_per_ha(record) := value if {
	application_year >= 2024
	value := record.premium_eur_ha_from_2024
}

premium_per_ha(record) := value if {
	application_year < 2023
	value := record.premium_eur_ha_from_2024
}

parcel_results := [parcel_result(parcel) | parcel := parcels[_]; code_known(parcel)]

invalid_parcel if {
	result := parcel_results[_]
	not result.valid
}

all_parcels_valid if {
	count(parcel_results) > 0
	not invalid_parcel
}

minimum_participation if {
	count([result | result := parcel_results[_]; result.valid]) >= 1
}

annual_contract_ok if {
	object.get(o623, "contract_years", 1) == 1
}

auto_extension_ok if {
	annual_contract_ok
	object.get(o623, "withdrawal_not_declared", false)
}

application_on_time if {
	date := object.get(o623, "application_date", "")
	date != ""
	date <= sprintf("%d-12-31", [application_year - 1])
}

last_entry_ok if {
	application_year <= 2027
}

disallowed_measure(measure) if {
	not measure in data.o6_23.allowed_measure_combinations
}

allowed_measure(measure) if {
	measure in data.o6_23.allowed_measure_combinations
}

invalid_combination if {
	measure := object.get(o623, "other_measures", [])[_]
	disallowed_measure(measure)
}

default invalid_combination := false

default base_requirements_ok := false

default application_on_time := false

default last_entry_ok := false

default annual_contract_ok := false

default auto_extension_ok := false

default minimum_participation := false

default all_parcels_valid := false

default premium_cap_ok := false

default withdrawal_allowed := false

default withdrawal_invalid_current_year := false

default exception_2026_cut_date := false

default divsz_2026_early_use_allowed := false

base_requirements_ok if {
	object.get(o623, "requested", false)
	minimum_participation
	all_parcels_valid
	annual_contract_ok
	application_on_time
	last_entry_ok
	not invalid_combination
}

parcel_premium(parcel) := value if {
	scope_ok(parcel)
	value := premium_per_ha(premium_record(parcel)) * object.get(parcel, "area_ha", 0)
}

premium_total := sum([parcel_premium(parcel) | parcel := parcels[_]])

modulation_factor := 1 if {
	total_area := object.get(object.get(input, "land", {}), "total_area_ha", 0)
	total_area <= 200
}

modulation_factor := (200 + ((total_area - 200) * 0.9)) / total_area if {
	total_area := object.get(object.get(input, "land", {}), "total_area_ha", 0)
	total_area > 200
	total_area <= 300
}

modulation_factor := ((200 + (100 * 0.9)) + ((total_area - 300) * 0.85)) / total_area if {
	total_area := object.get(object.get(input, "land", {}), "total_area_ha", 0)
	total_area > 300
	total_area <= 1000
}

modulation_factor := (((200 + (100 * 0.9)) + (700 * 0.85)) + ((total_area - 1000) * 0.75)) / total_area if {
	total_area := object.get(object.get(input, "land", {}), "total_area_ha", 0)
	total_area > 1000
}

modulated_premium_total := premium_total * modulation_factor

premium_cap_ok if {
	combined := object.get(o623, "combined_premium_eur_ha", null)
	combined == null
}

premium_cap_ok if {
	combined := object.get(o623, "combined_premium_eur_ha", null)
	combined != null
	combined <= 1300
}

withdrawal_allowed if {
	object.get(o623, "contract_year_completed", false)
}

withdrawal_invalid_current_year if {
	date := object.get(o623, "withdrawal_date", "")
	date >= sprintf("%d-01-01", [application_year])
	date <= sprintf("%d-12-31", [application_year])
}

general_grassland_management_ok(parcel) if {
	object.get(parcel, "land_use", "") != "grassland"
}

general_grassland_management_ok(parcel) if {
	object.get(parcel, "land_use", "") == "grassland"
	object.get(parcel, "annual_full_area_mown_or_grazed", false)
}

exception_2026_cut_date if {
	application_year == 2026
	object.get(o623, "state_regulation_adjusted", false)
	object.get(o623, "cut_date_changed", false)
}

divsz_2026_early_use_allowed if {
	application_year == 2026
	object.get(o623, "biodiversity_area_code", "") == "DIVSZ"
	object.get(o623, "early_use_days", 0) > 0
	object.get(o623, "second_mowing_on_comparable_fields", false)
}

divsz_2026_premium_status := "not_paid" if {
	divsz_2026_early_use_allowed
	object.get(o623, "early_use_premium_code", "") in ["OPUBB", "OPBIO"]
}

divsz_2026_premium_status := "paid" if {
	not divsz_2026_early_use_allowed
}

divsz_2026_premium_status := "invalid" if {
	divsz_2026_early_use_allowed
	not object.get(o623, "early_use_premium_code", "") in ["OPUBB", "OPBIO"]
}

default divsz_2026_premium_status := "paid"

status := "eligible" if {
	base_requirements_ok
}

status := "not_eligible" if {
	not base_requirements_ok
}

application_status := "requested" if {
	object.get(o623, "requested", false)
}

application_status := "not_requested" if {
	not object.get(o623, "requested", false)
}

allowed_chapter_pair(chapter_a, chapter_b) := allowed if {
	allowed := object.get(object.get(object.get(data.o6_23, "combination_chapters", {}), chapter_a, {}), chapter_b, false)
}

chapter_pair_is_allowed(chapter_a, chapter_b) := allowed if {
	allowed := allowed_chapter_pair(chapter_a, chapter_b)
}

obligation_chapters(parcel) := chapters if {
	obligations := object.get(parcel, "project_confirmation_obligations", [])
	chapters := [object.get(obligation, "chapter", "") | obligation := obligations[_]]
}

invalid_obligation_combination(parcel) if {
	chapters := obligation_chapters(parcel)
	first := chapters[i]
	second := chapters[j]
	i < j
	not chapter_pair_is_allowed(first, second)
}

obligation_combination_ok(parcel) if {
	not invalid_obligation_combination(parcel)
}

evaluate := {
	"measure": "o6_23",
	"compliant": base_requirements_ok,
	"status": status,
	"application_status": application_status,
	"application_on_time": application_on_time,
	"last_entry_ok": last_entry_ok,
	"annual_contract_ok": annual_contract_ok,
	"auto_extension_ok": auto_extension_ok,
	"minimum_participation": minimum_participation,
	"all_parcels_valid": all_parcels_valid,
	"invalid_combination": invalid_combination,
	"premium_eur": premium_total,
	"modulation_factor": modulation_factor,
	"modulated_premium_eur": modulated_premium_total,
	"premium_cap_ok": premium_cap_ok,
	"withdrawal_allowed": withdrawal_allowed,
	"withdrawal_invalid_current_year": withdrawal_invalid_current_year,
	"exception_2026_cut_date": exception_2026_cut_date,
	"divsz_2026_early_use_allowed": divsz_2026_early_use_allowed,
	"divsz_2026_premium_status": divsz_2026_premium_status,
	"parcel_results": parcel_results,
}
