package oepul.o6_12

import rego.v1

# The input extensions documented in profile_changes.json make evidence explicit;
# an absent required fact deliberately yields no positive eligibility decision.
eligible_crop(parcel) if {
	data.eligible_crop_categories[_] == parcel.crop.crop_category
}

participating_parcels contains parcel if {
	parcel := input.land.parcels[_]
	eligible_crop(parcel)
}

eligible_area_ha := sum([parcel.area_ha | parcel := participating_parcels[_]])

minimum_participation_met if {
	eligible_area_ha >= 0.5
}

disallowed_application(application) if {
	application.ages_effect_type == "Insektizid"
	not application.bio_2018_848_permitted
	not application.officially_ordered
}

farmwide_insecticide_waiver_met if {
	every parcel in participating_parcels {
		every application in object.get(parcel.operations, "insecticide_applications", []) {
			not disallowed_application(application)
		}
	}
}

official_order_exception_met(application) if {
	application.officially_ordered
	application.officially_authorised_active_ingredient
	application.official_order_documented
	application.application_documented
}

official_order_exception_met(application) if {
	application.bio_2018_848_permitted
}

disallowed_inventory_item(item) if {
	not item.bio_2018_848_permitted
	not item.used_only_on_other_cultures
}

disallowed_inventory_item(item) if {
	not item.bio_2018_848_permitted
	item.used_only_on_other_cultures
	not item.quantity_plausible_for_crops
}

disallowed_inventory_item(item) if {
	not item.bio_2018_848_permitted
	item.used_only_on_other_cultures
	not item.records_available
}

purchase_or_storage_compliant if {
	every item in object.get(input, "insecticide_inventory", []) {
		not disallowed_inventory_item(item)
	}
}

rate_is_current(row) if {
	row.year_to == null
}

rate_is_current(row) if {
	input.farm.year <= row.year_to
}

premium_rate(parcel) := rate if {
	row := data.premium_rates_eur_per_ha[_]
	row.crop_category == parcel.crop.crop_category
	input.farm.year >= row.year_from
	rate_is_current(row)
	rate := row.rate
}

premium_for_parcel(parcel) := 0 if {
	parcel.o6_12_nonpremium
}

premium_for_parcel(parcel) := parcel.area_ha * premium_rate(parcel) if {
	eligible_crop(parcel)
	not parcel.o6_12_nonpremium
	parcel.crop.crop_category != "orchard"
}

premium_for_parcel(parcel) := parcel.area_ha * premium_rate(parcel) if {
	eligible_crop(parcel)
	not parcel.o6_12_nonpremium
	parcel.crop.crop_category == "orchard"
	parcel.crop.is_grafted
}

unmodulated_premium := sum([premium_for_parcel(parcel) | parcel := participating_parcels[_]])

modulation_factor(area_ha) := factor if {
	band := data.modulation_bands[_]
	area_ha > band.lower_exclusive_ha
	band.upper_inclusive_ha != null
	area_ha <= band.upper_inclusive_ha
	factor := band.factor
}

modulation_factor(area_ha) := factor if {
	band := data.modulation_bands[_]
	area_ha > band.lower_exclusive_ha
	band.upper_inclusive_ha == null
	factor := band.factor
}

erosion_organism_supplement_factor := 0.5 if {
	input.farm.participations[_].measure == "o6_12"
	input.farm.erosionschutz_organism_supplement
}

erosion_organism_supplement_factor := 1 if {
	not input.farm.erosionschutz_organism_supplement
}

modulated_premium := unmodulated_premium * modulation_factor(input.land.total_area_ha)

psm_code_required(application) := "PSMCSI" if {
	input.farm.year <= 2025
	application.chemical_synthetic
	application.ages_effect_type == "Insektizid"
}

psm_code_required(application) := "PSMCS" if {
	input.farm.year <= 2025
	application.chemical_synthetic
	application.ages_effect_type != "Insektizid"
}

psm_code_required(application) := "PSMBIO" if {
	input.farm.year <= 2025
	not application.chemical_synthetic
	application.bio_2018_848_permitted
}

psm_coding_required if input.farm.year <= 2025

psm_coding_not_required if input.farm.year >= 2026

contract_end_date := "2028-12-31"

measure_eligible if {
	minimum_participation_met
	farmwide_insecticide_waiver_met
	purchase_or_storage_compliant
	not input.farm.organic_whole_farm
}
