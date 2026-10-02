# o6_16 – relevante AMA-Hinweise 2026 (Dürre, Begrünung, Biodiversitätsflächen)
package oepul.o6_16

# ---------------------------------------------------------------------------
# Dürre 2026: Entfall der Ernteverpflichtung in festgelegten Bezirken (05.08./12.08.2026)
# ---------------------------------------------------------------------------

drought_relief_district(state, district) if {
	some row in notices.drought_harvest_relief_2026.districts
	row.bundesland == state
	row.all_districts == true
	is_string(district)
}

drought_relief_district(state, district) if {
	some row in notices.drought_harvest_relief_2026.districts
	row.bundesland == state
	name_in(district, row.districts)
}

drought_harvest_relief_applies(p) if {
	year == notices.drought_harvest_relief_2026.year
	drought_relief_district(area_state(p), input.farm.region.district)
	object.get(p, ["harvest", "no_harvestable_stand_due_to_drought"], false) == true
	object.get(p, ["harvest", "usually_harvested_late_summer_or_autumn"], true) == true
}

# ---------------------------------------------------------------------------
# Begrünung (Kombinationsverpflichtung o6_6/o6_7): Flächendeckung 2026 nicht beanstandet
# ---------------------------------------------------------------------------

greening_coverage_relief(yr, measure, properly_sown) if {
	yr == notices.greening_coverage_relief_2026.year
	measure in {m | some m in notices.greening_coverage_relief_2026.measures}
	properly_sown == true
}

# o6_6 Varianten 1/2: späteste Anlage 2026
o6_6_latest_sowing_2026(variant) := row.latest_sowing if {
	some row in notices.o6_6_variant_deadlines_2026
	row.variant == variant
}

# o6_7: Fristen 30/50 Tage dürfen 2026 überschritten werden; Zwischenfrucht dennoch bis 20.09./15.10.
o6_7_latest_cover_crop_2026(frost_killed) := notices.o6_7_deadline_relief_2026.frost_killed_mix_latest if frost_killed == true

o6_7_latest_cover_crop_2026(frost_killed) := notices.o6_7_deadline_relief_2026.winter_hardy_latest if frost_killed == false

# ---------------------------------------------------------------------------
# AG-Schläge mit DIV-Code: vorzeitige bzw. dritte Nutzung 2026 nur mit OPUBB/OPBIO
# ---------------------------------------------------------------------------

div_relief := notices.arable_div_relief_2026

op_div_coded(p) if {
	some c in div_relief.required_codes
	has_code(p, c)
}

uses_in_year(p, yr) := count([d | some d in object.get(p, ["operations", "cutting_dates"], []); date_year(d) == yr])

early_use(p, yr) if {
	some d in object.get(p, ["operations", "cutting_dates"], [])
	date_year(d) == yr
	month_day(d) < div_relief.regular_earliest_month_day
}

arable_div_parcels := [p | some p in parcels; is_arable(p); has_code(p, "DIV")]

arable_div_ha := sum([p.area_ha | some p in arable_div_parcels])

early_used_uncoded_div_ha := sum([p.area_ha | some p in arable_div_parcels; early_use(p, year); not op_div_coded(p)])

violations contains {
	"rule_id": "o6_16.notice2026.div_early_use",
	"parcel_id": null,
	"message": "Acker-Biodiversitätsflächen (inkl. AG+DIV) vor dem 1. August über den 25-%-Anteil hinaus genutzt ohne Code OPUBB/OPBIO.",
} if {
	year == div_relief.year
	early_used_uncoded_div_ha > div_relief.regular_unrestricted_share * arable_div_ha
}

violations contains {
	"rule_id": "o6_16.notice2026.div_third_use",
	"parcel_id": p.parcel_id,
	"message": "Dritte Nutzung einer Acker-Biodiversitätsfläche 2026 nur mit Code OPUBB/OPBIO (ohne Prämie).",
} if {
	year == div_relief.year
	some p in arable_div_parcels
	uses_in_year(p, year) > div_relief.max_uses_regular
	not op_div_coded(p)
}
