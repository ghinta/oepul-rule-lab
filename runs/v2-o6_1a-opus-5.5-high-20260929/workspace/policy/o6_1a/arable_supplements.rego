# METADATA
# title: UBB (o6_1a) – Zuschläge auf Ackerflächen (Kapitel 8)
package oepul.o6_1a.arable_supplements

import data.oepul.o6_1a.biodiversity_arable
import data.oepul.o6_1a.common
import data.oepul.o6_1a.general_obligations

a_ha := common.arable_area_ha

cap_20 := a_ha * common.limits.div_supplement_cap_share

# Von UBB prämierte Acker-Biodiversitätsflächen (ohne aus anderen Maßnahmen angerechnete Flächen).
ubb_paid_div(p) if {
	common.is_arable_div(p)
	biodiversity_arable.creditable_arable_div(p)
	not common.credited_from_other_measure(p)
	not common.no_premium(p)
}

ubb_div_parcels := [p | some p in common.arable_parcels; ubb_paid_div(p)]

ubb_div_area_ha := sum([common.area(p) | some p in ubb_div_parcels])

# ---------------------------------------------------------------------------
# UBB-ZA7-001..003: Zuschlag für über 7 % hinausgehende Biodiversitätsflächen (bis max. 20 %)
# ---------------------------------------------------------------------------
pure_div_area_ha := sum([common.area(p) | some p in ubb_div_parcels; not common.is_gloez4(p)])

over7_area_ha := common.max_of(0, common.min_of(pure_div_area_ha, cap_20) - (a_ha * common.limits.div_minimum_share))

over7_premium := over7_area_ha * common.rate_or_zero("acker_div_ueber_7")

# ---------------------------------------------------------------------------
# UBB-ZAZ-001..002: Zuschlag Ackerzahl >= 50
# ---------------------------------------------------------------------------
ackerzahl_area_ha := common.min_of(sum([common.area(p) | some p in ubb_div_parcels; object.get(p, ["soil_index", "ackerzahl"], 0) >= common.limits.ackerzahl_min]), cap_20)

ackerzahl_premium := ackerzahl_area_ha * common.rate_or_zero("acker_div_ackerzahl")

# ---------------------------------------------------------------------------
# UBB-Z3HA-001..002: Zuschlag mind. 1 Biodiversitätsfläche > 0,05 ha je angefangene 3 ha Ackerfläche
# ---------------------------------------------------------------------------
required_div_parcels := ceil(a_ha / common.limits.div_supplement_ha_per_parcel)

qualifying_div_parcels := count([p | some p in biodiversity_arable.creditable_parcels; common.area(p) > common.limits.div_supplement_min_parcel_ha_exclusive])

default per_3ha_condition_met := false

per_3ha_condition_met if {
	a_ha > 0
	qualifying_div_parcels >= required_div_parcels
}

per_3ha_area_ha := common.min_of(ubb_div_area_ha, cap_20) if per_3ha_condition_met

default per_3ha_area_ha_or_zero := 0

per_3ha_area_ha_or_zero := per_3ha_area_ha

per_3ha_premium := per_3ha_area_ha_or_zero * common.rate_or_zero("acker_div_je_3ha")

# ---------------------------------------------------------------------------
# UBB-DIVRSA-005..006: Zuschlag regionale Acker-Saatgutmischung (bis max. 20 %)
# ---------------------------------------------------------------------------
divrs_area(variant) := sum([common.area(p) | some p in ubb_div_parcels; biodiversity_arable.divrs_eligible(p); biodiversity_arable.divrs_variant(p) == variant])

divrs_feldfutter_ha := common.min_of(divrs_area("sonstiges_feldfutter"), cap_20)

divrs_gruenbrache_ha := common.min_of(divrs_area("gruenbrache"), cap_20 - divrs_feldfutter_ha)

divrs_premium := (divrs_feldfutter_ha * common.rate_or_zero("acker_divrs_feldfutter")) + (divrs_gruenbrache_ha * common.rate_or_zero("acker_divrs_gruenbrache"))

# ---------------------------------------------------------------------------
# UBB-SLK-001..009: Seltene, regional wertvolle Kulturpflanzen (max. 10 ha je Sorte)
# ---------------------------------------------------------------------------
variety_row(v) := r if {
	some r in common.tables.o6_1a_rare_crop_varieties
	r.variety == v
	r.from_year <= common.year
}

variety(p) := object.get(p, ["crop", "variety"], "")

slk_pure(p) if object.get(p, ["crop", "pure_variety"], false)

slk_pure(p) if {
	object.get(p, ["crop", "undersown_subordinate_not_harvested"], false)
	not object.get(p, ["crop", "is_mixture"], false)
}

slk_pure(p) if {
	variety(p) in {v | some v in common.tables.o6_1a_rare_crop_striped_exception_varieties}
	object.get(p, ["crop", "striped_poppy_varieties_unmixed"], false)
}

slk_first_use_ok(p) if not object.get(p, ["crop", "is_perennial"], false)

slk_first_use_ok(p) if {
	object.get(p, ["crop", "is_perennial"], false)
	object.get(p, ["crop", "first_use_year"], common.year) == common.year
}

slk_eligible(p) if {
	common.is_arable(p)
	common.has_code(p, "SLK")
	variety_row(variety(p))
	slk_pure(p)
	slk_first_use_ok(p)
	object.get(p, ["crop", "seed_documentation"], false)
	not common.no_premium(p)
}

slk_varieties := {variety(p) | some p in common.arable_parcels; slk_eligible(p)}

slk_area(v) := common.min_of(sum([common.area(p) | some p in common.arable_parcels; slk_eligible(p); variety(p) == v]), common.limits.slk_max_ha_per_variety)

slk_rate(v) := common.rate_or_zero("slk_a") if variety_row(v).premium_level == "A"

slk_rate(v) := common.rate_or_zero("slk_b") if variety_row(v).premium_level == "B"

slk_premium := sum([(slk_area(v) * slk_rate(v)) | some v in slk_varieties])

violations contains {"rule_id": "UBB-SLK-001", "subject": common.parcel_id(p), "message": "SLK-Schlag erfüllt Bedingungen nicht (Sorte laut Sortenliste, sortenreiner Anbau, Dokumentation, mehrjährige Kulturen nur im ersten Nutzungsjahr)"} if {
	some p in common.arable_parcels
	common.has_code(p, "SLK")
	not slk_eligible(p)
	not common.no_premium(p)
}

# ---------------------------------------------------------------------------
# UBB-FWK-001..010: Förderwürdige Ackerkulturen (> 15 %, bis max. 40 %)
# ---------------------------------------------------------------------------
fwk_group_of(crop) := g.group if {
	some g in common.tables.o6_1a_foerderwuerdige_kulturen
	crop in g.crops
}

bhg_crops := {c | some c in common.tables.o6_1a_bhg_crops}

fwk_group_of(crop) := "fwk_bhg" if crop in bhg_crops

main_crop(p) := object.get(p, ["crop", "fwk_main_component"], common.crop_label(p))

bhg_generic(p) if common.schlagnutzungsart(p) in {s | some s in common.tables.o6_1a_bhg_generic_schlagnutzungsarten}

main_group(p) := fwk_group_of(main_crop(p)) if not bhg_generic(p)

main_group(p) := "fwk_bhg" if {
	bhg_generic(p)
	common.has_code(p, "BHG")
	bhg_ok(p)
}

bhg_ok(p) if common.crop_name(p) in bhg_crops

bhg_ok(p) if {
	object.get(p, ["crop", "autochthonous_seed_production"], false)
	object.get(p, ["crop", "seed_harvest_this_year"], false)
}

second_group(p) := fwk_group_of(object.get(p, ["crop", "second_crop_name"], ""))

parcel_groups(p) := {g | g := main_group(p)} | {g | g := second_group(p)}

# Haupt- und Zweitkultur förderwürdig: der höhere Zuschlag wird gewährt, die Fläche zählt einmal.
group_rates(p) := {common.rate_or_zero(g) | some g in parcel_groups(p)}

fwk_parcel(p) if {
	common.is_arable(p)
	count(group_rates(p)) > 0
	not common.no_premium(p)
	not common.has_code(p, "DIV")
	not common.has_code(p, "DIVRS")
	not npf_excluded(p)
}

npf_excluded(p) if {
	common.year <= 2024
	common.has_code(p, "NPF")
}

fwk_parcel_rate(p) := max(group_rates(p))

fwk_area_ha := sum([common.area(p) | some p in common.arable_parcels; fwk_parcel(p)])

div_over_7_for_fwk_ha := common.max_of(0, biodiversity_arable.arable_div_area_ha - (a_ha * common.limits.div_minimum_share))

fwk_share := (fwk_area_ha + div_over_7_for_fwk_ha) / a_ha if a_ha > 0

default fwk_threshold_met := false

fwk_threshold_met if fwk_share > common.limits.fwk_min_share_exclusive

fwk_cap := a_ha * common.limits.fwk_cap_share

fwk_rates := {fwk_parcel_rate(p) | some p in common.arable_parcels; fwk_parcel(p)}

fwk_area_at(r) := sum([common.area(p) | some p in common.arable_parcels; fwk_parcel(p); fwk_parcel_rate(p) == r])

fwk_area_above(r) := sum([fwk_area_at(r2) | some r2 in fwk_rates; r2 > r])

# Höchste Prämienstufe zuerst, bis max. 40 % der Ackerfläche.
fwk_paid_at(r) := common.max_of(0, common.min_of(fwk_area_at(r), fwk_cap - fwk_area_above(r)))

default fwk_premium := 0

fwk_premium := sum([(fwk_paid_at(r) * r) | some r in fwk_rates]) if fwk_threshold_met

violations contains {"rule_id": "UBB-ANT-030", "subject": common.parcel_id(p), "message": "BHG-Kultur auf Schlagnutzungsart Heilpflanzen/Gewürzpflanzen/Sonstige Ackerkulturen ohne Code BHG oder ohne zulässige Kultur im Zusatztext"} if {
	some p in common.arable_parcels
	bhg_generic(p)
	not main_group(p)
	crop_is_bhg_candidate(p)
}

crop_is_bhg_candidate(p) if common.crop_name(p) in bhg_crops

crop_is_bhg_candidate(p) if common.has_code(p, "BHG")

violations contains {"rule_id": "UBB-ANT-031", "subject": common.parcel_id(p), "message": "Autochthone Wildpflanze in Jahren ohne Samenernte nicht mit BHG-Code angeben"} if {
	some p in common.arable_parcels
	common.has_code(p, "BHG")
	object.get(p, ["crop", "autochthonous_seed_production"], false)
	not object.get(p, ["crop", "seed_harvest_this_year"], false)
}

# ---------------------------------------------------------------------------
# UBB-WBF-001..008: Wildkräuter- und Brutflächen (max. 20 ha)
# ---------------------------------------------------------------------------
wb(p) := object.get(p, "wildkraut", {})

wb_window_end(p) := common.earlier_date(sprintf("%d-06-30", [common.year]), object.get(wb(p), "threshing_date", sprintf("%d-06-30", [common.year])))

in_wb_window(p, d) if {
	d >= sprintf("%d-03-15", [common.year])
	d <= wb_window_end(p)
}

wb_violation(p) if not general_obligations.is_cereal(p)

wb_violation(p) if object.get(wb(p), "row_spacing_cm", 0) < 20

wb_violation(p) if object.get(wb(p), "undersown", false)

wb_violation(p) if {
	object.get(wb(p), "spring_cereal", false)
	object.get(wb(p), "sowing_date", "9999-12-31") >= sprintf("%d-03-15", [common.year])
}

wb_violation(p) if {
	some f in object.get(p, ["operations", "fertilization_events"], [])
	in_wb_window(p, f.date)
}

wb_violation(p) if {
	some a in object.get(p, ["operations", "psm_applications"], [])
	in_wb_window(p, a.date)
}

wb_violation(p) if {
	some d in object.get(p, ["operations", "driving_events"], [])
	d.purpose != "crossing"
	in_wb_window(p, d.date)
}

wb_violation(p) if {
	some e in object.get(p, ["operations", "use_events"], [])
	e.type in {"mechanical_weeding", "harvest_whole_plant"}
	in_wb_window(p, e.date)
}

wb_eligible(p) if {
	common.is_arable(p)
	common.has_code(p, "WB")
	not wb_violation(p)
	not common.no_premium(p)
}

wb_area_ha := common.min_of(sum([common.area(p) | some p in common.arable_parcels; wb_eligible(p)]), common.limits.wildkraeuter_max_ha_per_farm)

wb_premium := wb_area_ha * common.rate_or_zero("wildkraeuter_brutflaechen")

violations contains {"rule_id": "UBB-WBF-001", "subject": common.parcel_id(p), "message": "Wildkräuter- und Brutfläche erfüllt Bedingungen nicht"} if {
	some p in common.arable_parcels
	common.has_code(p, "WB")
	wb_violation(p)
}

# ---------------------------------------------------------------------------
# UBB-PZR-001..010: Pheromonfallen bei Zuckerrüben (ab 2025)
# ---------------------------------------------------------------------------
pz(p) := object.get(p, "pheromone_traps", {})

pzr_crop_ok(p) if common.schlagnutzungsart(p) in {s | some s in common.tables.o6_1a_pzr_schlagnutzungsarten}

pzr_crop_ok(p) if object.get(p, ["crop", "sugar_beet_previous_year"], false)

pzr_install_ok(p) if {
	sow := object.get(pz(p), "reference_sowing_date", null)
	inst := object.get(pz(p), "installation_date", null)
	sow != null
	inst != null
	common.days_between(sow, inst) <= 14
}

pzr_violation(_) if common.year < 2025

pzr_violation(p) if not pzr_crop_ok(p)

pzr_violation(p) if object.get(pz(p), "traps_per_ha", 0) < 15

pzr_violation(p) if not pzr_install_ok(p)

pzr_violation(p) if object.get(pz(p), "days_in_field", 0) < 35

pzr_violation(p) if object.get(pz(p), "emptied_count", 0) < 2

pzr_violation(p) if not object.get(pz(p), "removed_before_harvest", false)

pzr_violation(p) if not object.get(pz(p), "records_complete", false)

pzr_violation(p) if not object.get(pz(p), "pheromone_receipts_kept", false)

pzr_violation(p) if not object.get(pz(p), "lures_obtained_annually", false)

pzr_violation(p) if not object.get(pz(p), "traps_kept_until_sept_30", false)

pzr_violation(p) if {
	object.get(pz(p), "breakup", false)
	not object.get(pz(p), "breakup_documented", false)
}

pzr_violation(p) if {
	object.get(pz(p), "breakup", false)
	object.get(pz(p), "resown_sugar_beet", false)
	not object.get(pz(p), "traps_kept_or_reinstalled", false)
}

pzr_eligible(p) if {
	common.is_arable(p)
	common.has_code(p, "PZR")
	not pzr_violation(p)
	not common.no_premium(p)
}

pzr_area_ha := sum([common.area(p) | some p in common.arable_parcels; pzr_eligible(p)])

pzr_premium := pzr_area_ha * common.rate_or_zero("pheromonfallen")

violations contains {"rule_id": "UBB-PZR-001", "subject": common.parcel_id(p), "message": "Pheromonfallen-Zuschlag: Förderbedingungen nicht erfüllt"} if {
	some p in common.arable_parcels
	common.has_code(p, "PZR")
	pzr_violation(p)
}

total := ((((((over7_premium + ackerzahl_premium) + per_3ha_premium) + divrs_premium) + slk_premium) + fwk_premium) + wb_premium) + pzr_premium
