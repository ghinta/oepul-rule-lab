package oepul.o6_2

import rego.v1

# Input extension: input.o6_2 records measure-specific declarations and events.
rates := data.premium_rates_eur_per_ha

is_ackerfutter(parcel) if {
	parcel.land_use == "arable"
	data.ackerfutter_crop_names[_] == parcel.crop.crop_name
}

fodder_area := sum([p.area_ha | p := input.land.parcels[_]; p.land_use == "grassland"]) + sum([p.area_ha | p := input.land.parcels[_]; is_ackerfutter(p)])

livestock_density := input.o6_2.eligible_rgve / fodder_area if fodder_area > 0

is_livestock_farm if livestock_density >= 0.3

rate_year := "2023" if input.farm.year == 2023
rate_year := "2024_and_later" if input.farm.year >= 2024

premium_rate(parcel) := rate if {
	parcel.land_use == "arable"
	not is_ackerfutter(parcel)
	rate := rates[rate_year].arable
}

premium_rate(parcel) := rate if {
	is_ackerfutter(parcel)
	not is_livestock_farm
	rate := rates[rate_year].arable_fodder_non_livestock
}

premium_rate(parcel) := rate if {
	is_ackerfutter(parcel)
	is_livestock_farm
	livestock_density < 1.4
	rate := rates[rate_year].arable_fodder_livestock_lt_1_4_rgve
}

premium_rate(parcel) := rate if {
	is_ackerfutter(parcel)
	is_livestock_farm
	livestock_density >= 1.4
	rate := rates[rate_year].arable_fodder_livestock_gte_1_4_rgve
}

premium_rate(parcel) := rate if {
	parcel.land_use == "grassland"
	not is_livestock_farm
	rate := rates[rate_year].grassland_non_livestock
}

premium_rate(parcel) := rate if {
	parcel.land_use == "grassland"
	is_livestock_farm
	livestock_density < 1.4
	rate := rates[rate_year].grassland_livestock_lt_1_4_rgve
}

premium_rate(parcel) := rate if {
	parcel.land_use == "grassland"
	is_livestock_farm
	livestock_density >= 1.4
	rate := rates[rate_year].grassland_livestock_gte_1_4_rgve
}

premium_rate(parcel) := rate if {
	parcel.land_use == "special_crop"
	parcel.crop.crop_category in {"vineyard", "orchard", "hop"}
	rate := rates[rate_year].wine_fruit_hops
}

violations contains {"rule_id": "o6_2.eligibility.ubb", "message": "Zeitgleiche Teilnahme an UBB fehlt."} if not input.o6_2.ubb_participation

violations contains {"rule_id": "o6_2.nitrogen.external", "message": "Betriebsfremdes stickstoffhaltiges Düngemittel ist unzulässig.", "event": e} if {
	e := input.o6_2.fertilizer_events[_]
	e.is_external
	e.contains_nitrogen
	not e.is_farmyard_manure
	not e.is_eu_2018_848_compost
	not e.is_biogas_slurry_return
}

violations contains {"rule_id": "o6_2.nitrogen.biogas_return", "message": "Biogasgülle darf nur in entsprechender rückgenommener Menge nach Verbringung eigener Gülle bezogen werden.", "event": e} if {
	e := input.o6_2.fertilizer_events[_]
	e.is_biogas_slurry_return
	not e.corresponds_to_own_slurry_sent_to_biogas
}

violations contains {"rule_id": "o6_2.nitrogen.other_residues", "message": "Anderer organischer Rückstand ist unzulässig.", "event": e} if {
	e := input.o6_2.fertilizer_events[_]
	e.material in {"Kartoffelrestfruchtwasser", "Maisquellwasser", "Carbokalk", "Schlempe", "Melasse"}
}

violations contains {"rule_id": "o6_2.nitrogen.sewage_sludge", "message": "Klärschlamm ist ein unzulässiges Betriebsmittel.", "event": e} if {
	e := input.o6_2.fertilizer_events[_]
	e.material == "Klärschlamm"
}

violations contains {"rule_id": "o6_2.nitrogen.cap", "message": "Tierhaltungs-Stickstoff überschreitet 170 kg N/ha LN."} if {
	input.o6_2.livestock_nitrogen_kg_after_stall_storage_losses - input.o6_2.alpine_or_common_pasture_nitrogen_kg > 170 * input.o6_2.agricultural_area_ha_austria
}

violations contains {"rule_id": "o6_2.psm.fodder_grassland", "message": "Flächige PSM-Anwendung auf Ackerfutter oder Grünland ist unzulässig.", "event": e} if {
	e := input.o6_2.psm_events[_]
	e.land_category in {"arable_fodder", "grassland"}
	e.application in {"broadcast", "seed_treatment"}
	not e.eu_2018_848_active_ingredients_only
	not e.individual_plant_treatment
}

violations contains {"rule_id": "o6_2.purchase_storage", "message": "Kauf oder Lagerung eines unzulässigen Betriebsmittels ist verboten.", "item": i} if {
	i := input.o6_2.inventory_items[_]
	i.is_unpermitted_for_o6_2
	i.action in {"purchased", "stored"}
	not i.psm_allowed_for_other_cultures_with_plausible_records
}

violations contains {"rule_id": "o6_2.training", "message": "Erforderliche dreistündige Weiterbildung bis 31.12.2025 fehlt."} if {
	input.farm.year >= 2026
	not input.o6_2.training.completed_by_2025_12_31
}

violations contains {"rule_id": "o6_2.organic_combination", "message": "Betriebliche Kombination mit BIO ist unzulässig; Ausnahme ist BIO-Teilbetrieb Wein, Obst und Hopfen."} if {
	input.o6_2.bio_participation
	not input.o6_2.bio_partial_farm_wine_fruit_hops_only
}

eligible if count(violations) == 0
