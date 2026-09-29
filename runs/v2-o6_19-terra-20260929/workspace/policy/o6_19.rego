package oepul.o6_19

import rego.v1

# Input contract: input.oepul.o6_19 holds the application and the EBW parcels.
# A parcel's project_confirmation contains its binding indicators and observations.

default eligible := false

eligible if {
	input.oepul.o6_19.start_year >= 2023
	input.oepul.o6_19.start_year <= 2025
	input.oepul.o6_19.application_submitted_by_dec_31
	first_year_area >= 1
	every parcel in input.oepul.o6_19.parcels {
		parcel.code_ebw
		parcel.reference_area_present
		parcel.project_confirmation.present
		parcel.land_use in {"arable", "grassland"}
		indicators_complied(parcel)
		regular_care_complied(parcel)
	}
	training_complied
}

first_year_area := sum([p.area_ha | some p in input.oepul.o6_19.parcels]) if input.oepul.o6_19.participation_year == 1
first_year_area := 1 if input.oepul.o6_19.participation_year > 1

indicators_complied(parcel) if {
	every indicator in parcel.project_confirmation.indicators {
		indicator_satisfied(indicator)
	}
}

indicator_satisfied(indicator) if indicator.additional

indicator_satisfied(indicator) if {
	not indicator.additional
	indicator.observed
}

regular_care_complied(parcel) if {
	parcel.project_confirmation.requires_regular_care == false
}

regular_care_complied(parcel) if {
	parcel.project_confirmation.requires_regular_care
	parcel.years_since_last_use_or_care <= 2
}

training_complied if input.oepul.o6_19.training.completed_by_2026_12_31
training_complied if input.oepul.o6_19.current_year < 2027

regional_plan_eligible if {
	eligible
	input.oepul.o6_19.regional_plan.requested
	input.oepul.o6_19.regional_plan.annual_confirmation_present
}

denials contains reason if {
	not input.oepul.o6_19.application_submitted_by_dec_31
	reason := "EBW muss vor Vertragsbeginn bis 31. Dezember beantragt sein"
}

denials contains reason if {
	input.oepul.o6_19.participation_year == 1
	first_year_area < 1
	reason := "Im ersten Teilnahmejahr sind mindestens 1,00 ha erforderlich"
}

denials contains reason if {
	some parcel in input.oepul.o6_19.parcels
	not parcel.project_confirmation.present
	reason := sprintf("Projektbestätigung fehlt für Schlag %s", [parcel.parcel_id])
}

denials contains reason if {
	some parcel in input.oepul.o6_19.parcels
	not indicators_complied(parcel)
	reason := sprintf("Verbindlicher Projektindikator nicht erreicht: %s", [parcel.parcel_id])
}

denials contains reason if {
	some parcel in input.oepul.o6_19.parcels
	parcel.project_confirmation.requires_regular_care
	parcel.years_since_last_use_or_care > 2
	reason := sprintf("Regelmäßige Nutzung/Pflege mindestens jedes zweite Jahr fehlt: %s", [parcel.parcel_id])
}

denials contains reason if {
	input.oepul.o6_19.current_year >= 2027
	not input.oepul.o6_19.training.completed_by_2026_12_31
	reason := "Regionales Vernetzungstreffen bis 31.12.2026 fehlt"
}

denials contains reason if {
	input.oepul.o6_19.regional_plan.requested
	not input.oepul.o6_19.regional_plan.annual_confirmation_present
	reason := "Jährliche Teilnahmebestätigung für Regionalen Naturschutzplan fehlt"
}

premium_per_ha(parcel) := rate if {
	row := data.base_premiums[_]
	row.land_use == parcel.premium.land_use
	row.habitat == parcel.premium.habitat
	rate := row[parcel.premium.conservation_status]
	is_number(rate)
}

premium_per_ha(parcel) := rate if {
	row := data.base_premiums[_]
	row.land_use == "wiese"
	row.habitat == parcel.premium.habitat
	values := row[parcel.premium.conservation_status]
	rate := values[parcel.premium.difficulty_index]
	is_number(rate)
}

special_effort_surcharge(parcel) := 162 if {
	parcel.premium.special_effort_code == "EBBA02"
	input.oepul.o6_19.current_year >= 2025
	parcel.premium.conservation_status == "A"
	parcel.premium.special_effort_justified
}

special_effort_surcharge(parcel) := 108 if {
	parcel.premium.special_effort_code == "EBBA01"
	parcel.premium.special_effort_justified
}

habitat_surcharge(parcel) := 108 if {
	parcel.premium.habitat_code in {"EBHG01", "EBHG02"}
	parcel.premium.protected_asset_layer_share >= 0.5
	parcel.premium.reported_by_state_and_gis_mapped
}

regional_plan_premium := 270 if regional_plan_eligible

fallow_eligible_area_ha := min([input.oepul.o6_19.arable_fallow_area_ha, max([2, input.oepul.o6_19.total_arable_area_ha * 0.25])])

accession_premium_eligible if input.oepul.o6_19.current_year <= 2025

accession_premium_eligible if {
	input.oepul.o6_19.current_year > 2025
	input.oepul.o6_19.accession_area_ha <= max([5, input.oepul.o6_19.area_2025_ha * 0.5])
}

modulation_factor := weighted / input.oepul.o6_19.total_farm_area_ha if {
	area := input.oepul.o6_19.total_farm_area_ha
	area > 0
	weighted := ((min([area, 200]) + (max([min([area, 300]) - 200, 0]) * 0.9)) + (max([min([area, 1000]) - 300, 0]) * 0.85)) + (max([area - 1000, 0]) * 0.75)
}
