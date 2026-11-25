# METADATA
# title: UBB (o6_1a) – Höhe der Prämie (Kapitel 11), Erosionsausschluss, Modulation, Obergrenzen
package oepul.o6_1a.premium

import data.oepul.o6_1a.arable_supplements
import data.oepul.o6_1a.biodiversity_arable
import data.oepul.o6_1a.common
import data.oepul.o6_1a.grassland_supplements
import data.oepul.o6_1a.livestock
import data.oepul.o6_1a.options

# ---------------------------------------------------------------------------
# UBB-PR-ERO-001..002: Ausschluss der Acker-Basismodulprämie bei erosionsgefährdeten Kulturen
# ---------------------------------------------------------------------------
erosion_crops := {c | some c in common.tables.o6_1a_erosion_prone_crops}

erosion_prone(p) if common.crop_label(p) in erosion_crops

erosion_prone(p) if object.get(p, ["crop", "crop_category"], "") == "maize"

erosion_prone(p) if object.get(p, ["crop", "erosion_prone_crop"], false)

erosion_method(p) := object.get(p, ["operations", "erosion_protection_method"], "none")

erosion_protected(p) if {
	common.participates("8")
	erosion_method(p) == "other_measure_8_method"
}

erosion_protected(p) if {
	common.participates("8")
	erosion_method(p) in {"mulch_seeding", "direct_seeding", "strip_till"}
	some m in {"6", "7"}
	common.participates(m)
}

erosion_excluded(p) if {
	common.is_arable(p)
	common.area(p) > common.limits.erosion_exclusion_min_parcel_ha_exclusive
	object.get(p, "slope_percent", 0) >= common.limits.erosion_exclusion_min_slope_percent
	erosion_prone(p)
	not erosion_protected(p)
}

# ---------------------------------------------------------------------------
# Ausschlüsse auf der Einzelfläche (Anhang L, K20, nicht förderfähige Flächen)
# ---------------------------------------------------------------------------
lse_only(p) if {
	some c in common.tables.o6_1a_lse_only_parcel_codes
	common.has_code(p, c)
}

lse_only(p) if {
	common.is_bergmaehder(p)
	common.participates("4")
}

not_eligible_area(p) if common.no_premium(p)

not_eligible_area(p) if lse_only(p)

not_eligible_area(p) if common.has_code(p, "K20")

not_eligible_area(p) if startswith(common.schlagnutzungsart(p), "Sonstige ")

not_eligible_area(p) if object.get(p, "in_austria", true) == false

not_eligible_area(p) if {
	common.credited_from_other_measure(p)
}

# ---------------------------------------------------------------------------
# UBB-PR-ACK-001: Acker-Basismodulprämie (inkl. DIV, Grünbrache-DIV bis max. 20 %)
# ---------------------------------------------------------------------------
div_gruenbrache(p) if {
	common.schlagnutzungsart(p) == "Grünbrache"
	biodiversity_arable.creditable_arable_div(p)
	common.is_arable_div(p)
}

arable_base_parcel(p) if {
	common.is_arable(p)
	not not_eligible_area(p)
	not erosion_excluded(p)
	common.schlagnutzungsart(p) != "Grünbrache"
}

arable_non_fallow_ha := sum([common.area(p) | some p in common.arable_parcels; arable_base_parcel(p)])

arable_div_fallow_ha := common.min_of(sum([common.area(p) | some p in common.arable_parcels; div_gruenbrache(p); not not_eligible_area(p)]), common.arable_area_ha * common.limits.gruenbrache_basis_cap_share)

arable_base_area_ha := arable_non_fallow_ha + arable_div_fallow_ha

arable_base_premium := arable_base_area_ha * common.rate_or_zero("acker_basis")

# ---------------------------------------------------------------------------
# UBB-PR-GL-001: Grünland-Basismodulprämie (tierhaltend / nicht-tierhaltend)
# ---------------------------------------------------------------------------
grassland_base_area_ha := sum([common.area(p) | some p in common.grassland_parcels; not not_eligible_area(p)])

grassland_rate := common.rate_or_zero("gruenland_basis_tierhaltend") if livestock.is_livestock_farm

grassland_rate := common.rate_or_zero("gruenland_basis_nicht_tierhaltend") if not livestock.is_livestock_farm

grassland_base_premium := grassland_base_area_ha * grassland_rate

# ---------------------------------------------------------------------------
# Summen, Modulation (ATB-MOD-001) und Übersicht
# ---------------------------------------------------------------------------
gross_premium := ((((arable_base_premium + grassland_base_premium) + arable_supplements.total) + grassland_supplements.total) + options.lse_premium) + (options.hedge_premium + options.monitoring_premium)

farm_total_area_ha := sum([common.area(p) | some p in common.parcels; object.get(p, "in_austria", true); p.land_use != "alpine_pasture"])

band_upper(b, t) := t if b.to_ha_inclusive == null

band_upper(b, _) := b.to_ha_inclusive if b.to_ha_inclusive != null

band_area(t, b) := common.max_of(0, common.min_of(t, band_upper(b, t)) - b.from_ha_exclusive)

# Staffel: bis 200 ha 100 %, >200–300 ha 90 %, >300–1.000 ha 85 %, >1.000 ha 75 %.
modulated_area(t) := sum([(band_area(t, b) * b.factor) | some b in common.tables.o6_1a_modulation_brackets])

default modulation_factor := 1.0

modulation_factor := modulated_area(farm_total_area_ha) / farm_total_area_ha if farm_total_area_ha > 0

net_premium := common.round2(gross_premium * modulation_factor)

# ATB-OG-001: Förderobergrenze je ha für die Summe der flächenbezogenen Zahlungen am Schlag.
cap_case(p) := "naturschutz_ebw" if {
	some c in {"NAT", "EBW"}
	common.has_code(p, c)
}

cap_case(p) := "standard" if {
	not common.has_code(p, "NAT")
	not common.has_code(p, "EBW")
}

payment_cap_per_ha(p) := band.rate if {
	some row in common.tables.o6_1a_payment_caps_eur_per_ha
	row.case == cap_case(p)
	some band in row.rates
	common.in_band(band, common.year)
}

violations contains {"rule_id": "ATB-OG-001", "subject": common.parcel_id(p), "message": sprintf("Summe flächenbezogener Zahlungen %v €/ha überschreitet Obergrenze %v €/ha", [t, payment_cap_per_ha(p)])} if {
	some p in common.parcels
	t := object.get(p, "total_area_payments_eur_per_ha", null)
	t != null
	t > payment_cap_per_ha(p)
}

breakdown := {
	"arable_base": arable_base_premium,
	"grassland_base": grassland_base_premium,
	"arable_div_over_7": arable_supplements.over7_premium,
	"arable_ackerzahl": arable_supplements.ackerzahl_premium,
	"arable_per_3ha": arable_supplements.per_3ha_premium,
	"arable_divrs": arable_supplements.divrs_premium,
	"slk": arable_supplements.slk_premium,
	"foerderwuerdige_kulturen": arable_supplements.fwk_premium,
	"wildkraeuter_brutflaechen": arable_supplements.wb_premium,
	"pheromonfallen": arable_supplements.pzr_premium,
	"grassland_div_over_7": grassland_supplements.over7_premium,
	"grassland_gruenlandzahl": grassland_supplements.gruenlandzahl_premium,
	"grassland_per_3ha": grassland_supplements.per_3ha_premium,
	"grassland_altgras": grassland_supplements.altgras_premium,
	"grassland_divrs": grassland_supplements.divrs_premium,
	"steilflaechen": grassland_supplements.steep_premium,
	"land_top_up_steilflaechen": grassland_supplements.land_top_up_premium,
	"landschaftselemente": options.lse_premium,
	"mehrnutzenhecken": options.hedge_premium,
	"monitoring": options.monitoring_premium,
	"gross": gross_premium,
	"modulation_factor": modulation_factor,
	"net": net_premium,
}
