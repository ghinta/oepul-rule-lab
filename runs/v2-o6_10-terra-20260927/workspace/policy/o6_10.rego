package oepul.o6_10

import rego.v1

in_rate_year(rate) if rate.to_year == null
in_rate_year(rate) if input.farm.year <= rate.to_year

within_slope_max(rate, _) if rate.slope_max_exclusive == null
within_slope_max(rate, parcel) if parcel.slope_percent < rate.slope_max_exclusive

# premium_rate returns the applicable base rate record for one eligible parcel.
premium_rate(parcel) := rate if {
	rate := data.rates_eur_per_ha[_]
	rate.crop == parcel.crop.crop_category
	input.farm.year >= rate.from_year
	in_rate_year(rate)
	parcel.slope_percent >= rate.slope_min
	within_slope_max(rate, parcel)
}

surcharge_rate := rate if {
	rate := data.organisms_or_pheromones_surcharge[_]
	input.farm.year >= rate.from_year
	in_rate_year(rate)
}

discounted_surcharge_rate := amount if {
	rate := surcharge_rate
	input.o6_10.participates_in_insecticide_waiver_or_organic
	amount := rate.fixed * 0.5
}

discounted_surcharge_rate := rate.fixed if {
	rate := surcharge_rate
	not input.o6_10.participates_in_insecticide_waiver_or_organic
}

is_target_parcel(parcel) if parcel.crop.crop_category == "vineyard"
is_target_parcel(parcel) if parcel.crop.crop_category == "orchard"
is_target_parcel(parcel) if parcel.crop.crop_category == "hop"

covered_area_ha := sum([p.area_ha | p := input.land.parcels[_]; is_target_parcel(p)])

drought_cover_exception(parcel) if {
	input.farm.year == 2026
	parcel.o6_10.cover.ordinarily_established
	parcel.o6_10.cover.drought_prevents_full_cover
}

drought_cereal_exception(parcel) if {
	drought_cover_exception(parcel)
	parcel.o6_10.cover.drought_caused_volunteer_cereal_excess
}

violations contains {"rule_id": "O610.002", "message": "Mindestteilnahmefläche von 0,50 ha nicht erreicht"} if {
	covered_area_ha < 0.5
}

violations contains {"rule_id": "O610.007", "parcel_id": p.parcel_id, "message": "Fahrgassenbegrünung ist nicht ganzjährig und flächendeckend"} if {
	p := input.land.parcels[_]
	is_target_parcel(p)
	not p.o6_10.is_terrace
	not p.o6_10.cover.is_year_round_and_full
	not drought_cover_exception(p)
}

violations contains {"rule_id": "O610.009", "parcel_id": p.parcel_id, "message": "Offener Stammstreifen überschreitet die zulässige Breite"} if {
	p := input.land.parcels[_]
	is_target_parcel(p)
	p.crop.crop_category == "vineyard"
	p.o6_10.cover.open_trunk_strip_cm > 80
}

violations contains {"rule_id": "O610.009", "parcel_id": p.parcel_id, "message": "Offener Stammstreifen überschreitet die zulässige Breite"} if {
	p := input.land.parcels[_]
	is_target_parcel(p)
	p.crop.crop_category in {"orchard", "hop"}
	p.o6_10.cover.open_trunk_strip_cm > 100
}

violations contains {"rule_id": "O610.010", "parcel_id": p.parcel_id, "message": "Sondersystem erreicht weniger als 60 Prozent Begrünung"} if {
	p := input.land.parcels[_]
	is_target_parcel(p)
	p.o6_10.cover.non_single_row_or_wide_system
	p.o6_10.cover.covered_percent < 60
}

violations contains {"rule_id": "O610.011", "parcel_id": p.parcel_id, "message": "Unzulässige Begrünungskultur"} if {
	p := input.land.parcels[_]
	is_target_parcel(p)
	p.o6_10.cover.is_organic_mulch_or_self_greening
}

violations contains {"rule_id": "O610.012", "parcel_id": p.parcel_id, "message": "Getreide- oder Maisanteil über 50 Prozent"} if {
	p := input.land.parcels[_]
	is_target_parcel(p)
	p.o6_10.cover.cereal_maize_percent > 50
	not p.o6_10.cover.oat_or_summer_barley_as_nurse_crop
	not drought_cereal_exception(p)
}

violations contains {"rule_id": "O610.019", "parcel_id": p.parcel_id, "message": "Pflanzenschutzmittel auf Fahrgassenbegrünung eingesetzt"} if {
	p := input.land.parcels[_]
	is_target_parcel(p)
	p.o6_10.cover.psm_on_cover_used
}

violations contains {"rule_id": "O610.020", "message": "Optionaler Zuschlag ist wegen operationellem Programm ausgeschlossen"} if {
	input.o6_10.requests_organisms_or_pheromones_surcharge
	input.o6_10.operation_programme_compensates_organisms_or_pheromones
}
