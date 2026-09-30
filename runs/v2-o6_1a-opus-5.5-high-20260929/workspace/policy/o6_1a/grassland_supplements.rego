# METADATA
# title: UBB (o6_1a) – Zuschläge auf Grünlandflächen (Kapitel 9)
package oepul.o6_1a.grassland_supplements

import data.oepul.o6_1a.biodiversity_grassland
import data.oepul.o6_1a.common

g_ha := common.mown_grassland_area_ha

cap_20 := g_ha * common.limits.div_supplement_cap_share

ubb_paid_div(p) if {
	biodiversity_grassland.creditable_grassland_div(p)
	not common.credited_from_other_measure(p)
	not common.no_premium(p)
}

ubb_div_parcels := [p | some p in common.grassland_parcels; ubb_paid_div(p)]

ubb_div_area_ha := sum([common.area(p) | some p in ubb_div_parcels])

# UBB-ZG7-001..002: über 7 % hinausgehende Grünland-Biodiversitätsflächen (ohne NAT, EBW, N2, GLÖZ 4)
pure_div_area_ha := sum([common.area(p) | some p in ubb_div_parcels; not common.is_gloez4(p)])

over7_area_ha := common.max_of(0, common.min_of(pure_div_area_ha, cap_20) - (g_ha * common.limits.div_minimum_share))

over7_premium := over7_area_ha * common.rate_or_zero("gruenland_div_ueber_7")

# UBB-ZGZ-001: Grünlandzahl >= 30
gruenlandzahl_area_ha := common.min_of(sum([common.area(p) | some p in ubb_div_parcels; object.get(p, ["soil_index", "gruenlandzahl"], 0) >= common.limits.gruenlandzahl_min]), cap_20)

gruenlandzahl_premium := gruenlandzahl_area_ha * common.rate_or_zero("gruenland_div_gruenlandzahl")

# UBB-ZG3HA-001: mind. 1 Biodiversitätsfläche > 0,05 ha je angefangene 3 ha gemähter Grünlandfläche
required_div_parcels := ceil(g_ha / common.limits.div_supplement_ha_per_parcel)

qualifying_div_parcels := count([p | some p in biodiversity_grassland.creditable_parcels; common.area(p) > common.limits.div_supplement_min_parcel_ha_exclusive])

default per_3ha_condition_met := false

per_3ha_condition_met if {
	g_ha > 0
	qualifying_div_parcels >= required_div_parcels
}

default per_3ha_area_ha := 0

per_3ha_area_ha := common.min_of(ubb_div_area_ha, cap_20) if per_3ha_condition_met

per_3ha_premium := per_3ha_area_ha * common.rate_or_zero("gruenland_div_je_3ha")

# UBB-ZAGF-001: Zuschlag Belassen von Altgrasflächen (ab 2025)
altgras_area_ha := common.min_of(sum([common.area(p) | some p in ubb_div_parcels; common.has_code(p, "DIVAGF"); not agf_violation(p)]), cap_20)

agf_violation(p) if {
	some v in biodiversity_grassland.violations
	v.subject == common.parcel_id(p)
	startswith(v.rule_id, "UBB-DIVG-AGF")
}

altgras_premium := altgras_area_ha * common.rate_or_zero("gruenland_altgras")

# UBB-DIVRSG-009: Zuschlag regionale Grünland-Saatgutmischung
divrs_area_ha := common.min_of(sum([common.area(p) | some p in ubb_div_parcels; biodiversity_grassland.divrs_eligible(p)]), cap_20)

divrs_premium := divrs_area_ha * common.rate_or_zero("gruenland_divrs")

# UBB-STEIL-001..003: Zuschlag gemähte Steilflächen >= 50 % Hangneigung (automatisch)
mown_at_least_once(p) if {
	some e in object.get(p, ["operations", "use_events"], [])
	e.type == "mow"
	common.date_year(e.date) == common.year
}

mown_at_least_once(p) if object.get(p, ["operations", "mown_at_least_once"], false)

steep_eligible(p) if {
	common.is_grassland(p)
	object.get(p, "slope_percent", 0) >= common.limits.steep_slope_min_percent
	common.schlagnutzungsart(p) in {s | some s in common.tables.o6_1a_steep_slope_schlagnutzungsarten}
	mown_at_least_once(p)
	not common.no_premium(p)
	not lse_only(p)
}

lse_only(p) if {
	some c in common.tables.o6_1a_lse_only_parcel_codes
	common.has_code(p, c)
}

steep_area_ha := sum([common.area(p) | some p in common.grassland_parcels; steep_eligible(p)])

steep_premium := steep_area_ha * common.rate_or_zero("gruenland_steilflaechen")

# SRL-TOPUP-001: optionales Landes-Top-up 50 €/ha zum Zuschlag gemähte Steilflächen.
default land_top_up_premium := 0

land_top_up_premium := steep_area_ha * common.limits.land_top_up_steilflaechen_eur_per_ha if {
	object.get(input, ["farm", "oepul", "land_top_up_steilflaechen_granted"], false)
}

total := (((((over7_premium + gruenlandzahl_premium) + per_3ha_premium) + altgras_premium) + divrs_premium) + steep_premium) + land_top_up_premium
