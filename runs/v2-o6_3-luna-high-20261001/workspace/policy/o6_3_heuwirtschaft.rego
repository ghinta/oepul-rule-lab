package oepul.o6_3

import rego.v1

default eligible := false

default first_year_access := false

default drought_exception_applies := false

eligible if {
	input.farm.heuwirtschaft.measure == "o6_3"
	first_year_access
	input.farm.heuwirtschaft.contract_start_year >= 2023
	input.farm.heuwirtschaft.contract_start_year <= 2025
	compliance_ok
	count(violation) == 0
}

compliance_ok if {
	input.farm.heuwirtschaft.silage_preparation_and_feeding == false
	input.farm.heuwirtschaft.feed_fermentation == false
	input.farm.heuwirtschaft.silage_storage == false
	input.farm.heuwirtschaft.green_feeding_majority_april_to_september == true
	input.farm.heuwirtschaft.third_party_cuttings_only_dry_hay == true
}

first_year_access if {
	input.farm.heuwirtschaft.participation.combined_measure in data.eligible_combinations
	input.farm.heuwirtschaft.first_year.mown_meadow_meadow_pasture_ha >= 2
	tierholding(input)
}

tierholding(profile) if {
	fodder_area_for(profile) > 0
	rgve_total_for(profile) / fodder_area_for(profile) >= 0.3
}

tierholding(profile) := false if {
	fodder_area_for(profile) <= 0
}

tierholding(profile) := false if {
	fodder_area_for(profile) > 0
	rgve_total_for(profile) / fodder_area_for(profile) < 0.3
}

rgve_total := rgve_total_for(input)

rgve_total_for(profile) := 0 if {
	count(profile.livestock.species_groups) == 0
}

rgve_total_for(profile) := total if {
	count(profile.livestock.species_groups) > 0
	total := sum([value |
		group := profile.livestock.species_groups[_]
		factor := rgve_rate(group)
		value := group.animal_count * factor
	])
}

rgve_rate(group) := rate if {
	row := data.rgve_rates[_]
	row.animal == rgve_animal(group.species)
	row.class == group.category
	rate := row.rgve
}

rgve_animal("cattle") := "rinder"
rgve_animal("sheep_goats") := "schafe"
rgve_animal("horses") := "grosse_equiden"

fodder_area_ha := fodder_area_for(input)

fodder_area_for(profile) := total if {
	total := sum([value |
		parcel := profile.land.parcels[_]
		parcel.oepul.is_applied == true
		object.get(parcel.oepul, "is_second_crop", false) == false
		fodder_parcel(parcel)
		value := parcel.area_ha
	])
}

fodder_parcel(parcel) if {
	parcel.land_use == "grassland"
}

fodder_parcel(parcel) if {
	parcel.land_use == "arable"
	parcel.oepul.crop_name in data.arable_fodder_for_livestock_calculation
}

premium_area_ha := total if {
	total := sum([value |
		parcel := input.land.parcels[_]
		parcel.oepul.is_applied == true
		parcel.oepul.is_premium_eligible == true
		object.get(parcel.oepul, "is_second_crop", false) == false
		value := parcel.area_ha
	])
}

premium_eur_per_ha := rate if {
	row := data.premium_rates_eur_per_ha[_]
	input.farm.heuwirtschaft.year >= row.from_year
	rate_year_valid(row)
	row.tierholding == tierholding(input)
	row.no_mower_conditioner == input.farm.heuwirtschaft.no_mower_conditioner_option
	rate := row.rate
}

premium_eur_per_ha := 0 if {
	not tierholding(input)
}

rate_year_valid(row) if {
	row.to_year == null
}

rate_year_valid(row) if {
	row.to_year != null
	input.farm.heuwirtschaft.year <= row.to_year
}

premium_eur := premium_eur_per_ha * premium_area_ha

drought_exception_applies if {
	input.farm.heuwirtschaft.year == 2026
	input.farm.heuwirtschaft.drought_exception_area == true
	input.farm.heuwirtschaft.no_harvestable_stand == true
	some parcel in input.land.parcels
	parcel.land_use == "arable"
}

violation contains {"id": "O63.V.SILAGE_PREPARATION", "message": "Silagebereitung oder Silagefütterung ist am gesamten Betrieb nicht zulässig."} if {
	input.farm.heuwirtschaft.silage_preparation_and_feeding != false
}

violation contains {"id": "O63.V.FERMENTATION", "message": "Ein Gärungsprozess bei Futter oder eingesetzten Nebenprodukten muss ausgeschlossen sein."} if {
	input.farm.heuwirtschaft.feed_fermentation != false
}

violation contains {"id": "O63.V.SILAGE_STORAGE", "message": "Silage darf ab Vertragsbeginn am gesamten Betrieb nicht gelagert werden."} if {
	input.farm.heuwirtschaft.silage_storage != false
}

violation contains {"id": "O63.V.GREEN_FEEDING", "message": "Heugewinnung ist im überwiegenden Teil der Vegetationsperiode mit Eingrasen oder Weide für alle raufutterverzehrenden Tiere zu kombinieren."} if {
	input.farm.heuwirtschaft.green_feeding_majority_april_to_september != true
}

violation contains {"id": "O63.V.HAY_DELIVERY", "message": "Mähgut darf an Dritte nur als trockenes Heu abgegeben werden."} if {
	input.farm.heuwirtschaft.third_party_cuttings_only_dry_hay != true
}

violation contains {"id": "O63.V.MOWER_CONDITIONER", "message": "Bei beantragter Option darf kein Mähaufbereiter eingesetzt werden oder am Betrieb vorhanden sein."} if {
	input.farm.heuwirtschaft.no_mower_conditioner_option == true
	mower_conditioner_noncompliant
}

mower_conditioner_noncompliant if {
	input.farm.heuwirtschaft.mower_conditioner_used == true
}

mower_conditioner_noncompliant if {
	input.farm.heuwirtschaft.mower_conditioner_present == true
}

violation contains {"id": "O63.V.MINIMUM_AREA", "message": "Im ersten Verpflichtungsjahr müssen mindestens 2,00 ha Mähwiesen und Mähweiden ohne Streuwiesen und Bergmähder bewirtschaftet werden."} if {
	input.farm.heuwirtschaft.first_year.mown_meadow_meadow_pasture_ha < 2
}

violation contains {"id": "O63.V.TIERHOLDING", "message": "Im ersten Verpflichtungsjahr müssen mindestens 0,30 RGVE je ha Futterfläche erreicht werden."} if {
	not tierholding(input)
}

result := {
	"eligible": eligible,
	"first_year_access": first_year_access,
	"rgve_total": rgve_total,
	"fodder_area_ha": fodder_area_ha,
	"premium_area_ha": premium_area_ha,
	"premium_eur_per_ha": premium_eur_per_ha,
	"premium_eur": premium_eur,
	"drought_exception_applies": drought_exception_applies,
	"violations": violation,
}
