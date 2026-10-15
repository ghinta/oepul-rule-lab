package oepul.o6_17.eligibility

# Zugangs- und Teilnahmevoraussetzungen (Informationsblatt Kapitel 3 und 7,
# SRL 2.17 Zugangsvoraussetzungen, SRL 1.4, 1.6.1, 1.10.5.2, 1.12.1.1).

import data.oepul.o6_17.common
import data.oepul.o6_17.livestock

cfg := data.o6_17_tables

fw := cfg.general_framework

# Kombinationsverpflichtung: zeitgleich UBB, BIO oder BIO-Teilbetrieb.
combination_fulfilled if common.in_measure({m | some m in cfg.combination.farm_level_required_any_of})

grassland_area_ha := sum([p.area_ha | some p in common.grassland_parcels])

# Landwirtschaftliche Nutzfläche ohne Almweideflächen.
agricultural_area_excl_alpine_ha := sum([p.area_ha |
	some p in common.parcels
	p.land_use in {"arable", "grassland", "special_crop"}
])

grassland_share := grassland_area_ha / agricultural_area_excl_alpine_ha if agricultural_area_excl_alpine_ha > 0

min_grassland_area_ok if grassland_area_ha >= 2.0

grassland_share_ok if grassland_share >= 0.4

valid_start_year if {
	some cp in fw.contract_periods
	cp.start_year == common.contract_start_year
}

application_date := object.get(common.o6, "measure_application_date", null)

# Maßnahmenantrag bis 31.12. vor dem ersten Verpflichtungsjahr.
application_in_time if {
	is_string(application_date)
	is_number(common.contract_start_year)
	application_date <= sprintf("%d-12-31", [common.contract_start_year - 1])
}

legal_form := object.get(input, ["farm", "applicant", "legal_form"], "natural_person")

public_body_share := object.get(input, ["farm", "applicant", "public_body_share_percent"], null)

public_share_ok if public_body_share == null

public_share_ok if {
	is_number(public_body_share)
	public_body_share <= fw.public_body_max_share_percent
}

# Gebietskörperschaften sind für die Maßnahme 17 nicht zugelassen.
applicant_eligible if {
	legal_form != "public_body"
	public_share_ok
}

first_oepul_year := object.get(input, ["farm", "oepul", "first_oepul_participation_year"], null)

protected_cultivation_ha := object.get(input, ["land", "protected_cultivation_area_ha"], 0)

agricultural_area_incl_alpine_ha := sum([p.area_ha |
	some p in common.parcels
	p.land_use in {"arable", "grassland", "special_crop", "alpine_pasture"}
])

farm_min_size_met if protected_cultivation_ha >= fw.farm_minimum_size.protected_cultivation_min_ha

farm_min_size_met if agricultural_area_incl_alpine_ha + protected_cultivation_ha >= fw.farm_minimum_size.agricultural_area_min_ha

access_failures contains "combination_ubb_bio_missing" if not combination_fulfilled

access_failures contains "applicant_not_eligible" if not applicant_eligible

access_failures contains "min_grassland_2ha_first_year" if {
	common.is_first_year
	not min_grassland_area_ok
}

access_failures contains "grassland_share_40_percent_first_year" if {
	common.is_first_year
	not grassland_share_ok
}

access_failures contains "livestock_holding_first_year" if {
	common.is_first_year
	not livestock.is_livestock_holding
}

access_failures contains "invalid_contract_start_year" if {
	common.is_first_year
	not valid_start_year
}

access_failures contains "measure_application_late" if {
	common.is_first_year
	not application_in_time
}

access_failures contains "farm_minimum_size_first_oepul_year" if {
	common.year == first_oepul_year
	not farm_min_size_met
}

# Rechtsfolge: im 1. Jahr kein Vertrag, ab dem 2. Jahr keine Prämie im Jahr.
consequence := "no_contract" if {
	count(access_failures) > 0
	common.is_first_year
} else := "no_premium_in_application_year" if {
	count(access_failures) > 0
} else := "none"

access_requirements_met if count(access_failures) == 0

default access_requirements_met := false
