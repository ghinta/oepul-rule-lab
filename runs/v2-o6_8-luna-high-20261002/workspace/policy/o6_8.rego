package oepul.o6_8

import rego.v1

farm := object.get(input, "farm", {})
land := object.get(input, "land", {})
parcels := object.get(land, "parcels", [])
region := object.get(farm, "region", {})
year := object.get(farm, "year", 0)
measure_applications := object.get(object.get(farm, "oepul", {}), "measure_applications", [])

contract_end := "2028-12-31"

measure_active(measure_id) if {
	some application in measure_applications
	object.get(application, "measure_id", "") == measure_id
	object.get(application, "active", false) == true
}

has_code(parcel, code) if {
	code in object.get(parcel, "application_codes", [])
}

eligible_parcel[parcel.parcel_id] if {
	some parcel in parcels
	object.get(parcel, "land_use", "") == "arable"
	count(object.get(parcel, "application_codes", [])) > 0
}

minimum_area_satisfied if {
	sum([object.get(parcel, "area_ha", 0) | some parcel in parcels; count(object.get(parcel, "application_codes", [])) > 0]) >= 0.10
}

valid_code[code] if {
	some code in {"MS", "DS", "AH", "BAW", "US"}
}

crop_accepted[parcel.parcel_id] if {
	some parcel in parcels
	some code in object.get(parcel, "application_codes", [])
	crop_name := object.get(object.get(parcel, "crop", {}), "crop_name", "")
	code == "BAW"
	crop_name in data.o6_8_cultures.codes.BAW
}

crop_accepted[parcel.parcel_id] if {
	some parcel in parcels
	some code in object.get(parcel, "application_codes", [])
	crop_name := object.get(object.get(parcel, "crop", {}), "crop_name", "")
	code in {"MS", "DS"}
	crop_name in data.o6_8_cultures.codes.MS_DS
}

crop_accepted[parcel.parcel_id] if {
	some parcel in parcels
	some code in object.get(parcel, "application_codes", [])
	crop_name := object.get(object.get(parcel, "crop", {}), "crop_name", "")
	code == "US"
	crop_name in data.o6_8_cultures.codes.US
}

crop_accepted[parcel.parcel_id] if {
	some parcel in parcels
	some code in object.get(parcel, "application_codes", [])
	crop_name := object.get(object.get(parcel, "crop", {}), "crop_name", "")
	code == "AH"
	crop_name in data.o6_8_cultures.codes.AH
}

measure_6_or_7_active if {
	measure_active("o6_6")
}

measure_6_or_7_active if {
	measure_active("o6_7")
}

baw_entry_path_known(state, kg_number) if {
	state in {"Bgld", "Burgenland"}
	some entry in data.erosion_entry_paths_Bgld.entries
	entry.kg_number == kg_number
}

baw_entry_path_known(state, kg_number) if {
	state in {"Nö", "Niederösterreich"}
	some entry in data.erosion_entry_paths_no_1.entries
	entry.kg_number == kg_number
}

baw_entry_path_known(state, kg_number) if {
	state in {"Nö", "Niederösterreich"}
	some entry in data.erosion_entry_paths_no_2.entries
	entry.kg_number == kg_number
}

baw_entry_path_known(state, kg_number) if {
	state in {"Nö", "Niederösterreich"}
	some entry in data.erosion_entry_paths_no_3.entries
	entry.kg_number == kg_number
}

baw_entry_path_known(state, kg_number) if {
	state in {"Nö", "Niederösterreich"}
	some entry in data.erosion_entry_paths_no_4.entries
	entry.kg_number == kg_number
}

baw_entry_path_known(state, kg_number) if {
	state in {"Oö", "Oberösterreich"}
	some entry in data.erosion_entry_paths_oo_1.entries
	entry.kg_number == kg_number
}

baw_entry_path_known(state, kg_number) if {
	state in {"Oö", "Oberösterreich"}
	some entry in data.erosion_entry_paths_oo_2.entries
	entry.kg_number == kg_number
}

baw_entry_path_known(state, kg_number) if {
	state in {"Oö", "Oberösterreich"}
	some entry in data.erosion_entry_paths_oo_3.entries
	entry.kg_number == kg_number
}

baw_entry_path_known(state, kg_number) if {
	state in {"Oö", "Oberösterreich"}
	some entry in data.erosion_entry_paths_oo_4.entries
	entry.kg_number == kg_number
}

baw_entry_path_known(state, kg_number) if {
	state in {"Stmk", "Steiermark"}
	some entry in data.erosion_entry_paths_stmk_1.entries
	entry.kg_number == kg_number
}

baw_entry_path_known(state, kg_number) if {
	state in {"Stmk", "Steiermark"}
	some entry in data.erosion_entry_paths_stmk_2.entries
	entry.kg_number == kg_number
}

baw_entry_path_known(state, kg_number) if {
	state in {"Stmk", "Steiermark"}
	some entry in data.erosion_entry_paths_stmk_3.entries
	entry.kg_number == kg_number
}

baw_eligible[parcel.parcel_id] if {
	some parcel in parcels
	has_code(parcel, "BAW")
	erosion := object.get(parcel, "erosion", {})
	object.get(erosion, "erosion_entry_path_share", 0) >= 0.25
	kg_number := object.get(erosion, "erosion_entry_path_kg_number", "")
	baw_entry_path_known(object.get(region, "federal_state", ""), kg_number)
}

baw_area_cap_satisfied[parcel.parcel_id] if {
	some parcel in parcels
	has_code(parcel, "BAW")
	erosion := object.get(parcel, "erosion", {})
	object.get(erosion, "erosion_entry_path_area_ha", 0) > 0
	object.get(parcel, "area_ha", 0) <= 4 * object.get(erosion, "erosion_entry_path_area_ha", 0)
}

premium_eur_per_ha[code] := amount if {
	year == 2023
	rates := {"MS": 50, "DS": 80, "AH": 150, "BAW": 550, "US": 75, "US_BIO_SURCHARGE": 15}
	amount := rates[code]
}

premium_eur_per_ha[code] := amount if {
	year >= 2024
	rates := {"MS": 54, "DS": 86.4, "AH": 162, "BAW": 594, "US": 81, "US_BIO_SURCHARGE": 16.2}
	amount := rates[code]
}

drought_district_allowed if {
	year == 2026
	state := object.get(region, "federal_state", "")
	object.get(data.drought_2026_exempt_districts.all_districts, state, false) == true
}

drought_district_allowed if {
	year == 2026
	state := object.get(region, "federal_state", "")
	district := object.get(region, "district", "")
	some listed in object.get(data.drought_2026_exempt_districts.districts, state, [])
	listed == district
}

harvest_exception_2026[parcel.parcel_id] if {
	some parcel in parcels
	year == 2026
	drought_district_allowed
	object.get(object.get(parcel, "operations", {}), "harvestable_stand", true) == false
}

us_coverage_exception_2026[parcel.parcel_id] if {
	some parcel in parcels
	year == 2026
	has_code(parcel, "US")
	erosion := object.get(parcel, "erosion", {})
	object.get(erosion, "undersow_orderly_with_required_partners", false) == true
}

violations contains {"parcel_id": parcel.parcel_id, "rule_id": "O68-003", "reason": "MS/DS requires measure 6 or 7"} if {
	some parcel in parcels
	some erosion_code in {"MS", "DS"}
	has_code(parcel, erosion_code)
	not measure_6_or_7_active
}

violations contains {"parcel_id": parcel.parcel_id, "rule_id": "O68-006", "reason": "culture is not accepted for MS/DS"} if {
	some parcel in parcels
	some code in ["MS", "DS"]
	has_code(parcel, code)
	crop_name := object.get(object.get(parcel, "crop", {}), "crop_name", "")
	not crop_name in data.o6_8_cultures.codes.MS_DS
}

violations contains {"parcel_id": parcel.parcel_id, "rule_id": "O68-020", "reason": "invalid O6_8 code"} if {
	some parcel in parcels
	some code in object.get(parcel, "application_codes", [])
	not valid_code[code]
}

violations contains {"parcel_id": parcel.parcel_id, "rule_id": "O68-021", "reason": "BAW exceeds four times the entry path"} if {
	some parcel in parcels
	has_code(parcel, "BAW")
	not baw_area_cap_satisfied[parcel.parcel_id]
}

violations contains {"parcel_id": parcel.parcel_id, "rule_id": "O68-024", "reason": "MS/DS and AH cannot be combined"} if {
	some parcel in parcels
	some erosion_code in {"MS", "DS"}
	has_code(parcel, erosion_code)
	has_code(parcel, "AH")
}

violations contains {"parcel_id": parcel.parcel_id, "rule_id": "O68-026", "reason": "BAW cannot be combined with another measure"} if {
	some parcel in parcels
	has_code(parcel, "BAW")
	some measure_code in object.get(parcel, "measure_codes", [])
	not object.get(measure_code, "measure_id", "") in {"o6_1a", "o6_1b", ""}
}

violations contains {"parcel_id": parcel.parcel_id, "rule_id": "O68-034", "reason": "funded parcel is outside Austria"} if {
	some parcel in parcels
	object.get(parcel, "country", "AT") != "AT"
}

compliant if {
	minimum_area_satisfied
	count(violations) == 0
}

decision := {
	"measure": "o6_8",
	"contract_end": contract_end,
	"minimum_area_satisfied": minimum_area_satisfied,
	"eligible_parcels": eligible_parcel,
	"baw_eligible": baw_eligible,
	"baw_area_cap_satisfied": baw_area_cap_satisfied,
	"harvest_exception_2026": harvest_exception_2026,
	"us_coverage_exception_2026": us_coverage_exception_2026,
	"violations": violations,
	"compliant": compliant,
}
