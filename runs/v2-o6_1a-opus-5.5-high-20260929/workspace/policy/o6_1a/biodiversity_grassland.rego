# METADATA
# title: UBB (o6_1a) – Biodiversitätsflächen auf Grünlandflächen (Kapitel 6.2)
package oepul.o6_1a.biodiversity_grassland

import data.oepul.o6_1a.common

bio(p) := object.get(p, "biodiversity", {})

first_year(p) := object.get(bio(p), "first_declared_year", common.year)

year_events(p) := [e | some e in object.get(p, ["operations", "use_events"], []); common.date_year(e.date) == common.year]

nat_codes := {c | some c in common.tables.o6_1a_naturschutz_grassland_cut_date_conditions}

n2_codes := {c | some c in common.tables.o6_1a_natura2000_grassland_cut_date_conditions}

# ---------------------------------------------------------------------------
# Anrechenbarkeit (UBB-DIVG-ANR-001..004)
# ---------------------------------------------------------------------------
creditable_blocked(p) if not common.is_mown_grassland(p)

creditable_blocked(p) if {
	common.has_code(p, "NAT")
	count(common.conditions(p) & nat_codes) == 0
}

creditable_blocked(p) if {
	common.has_code(p, "N2")
	count(common.conditions(p) & n2_codes) == 0
}

creditable_blocked(p) if {
	common.has_code(p, "EBW")
	not object.get(bio(p), "ebw_habitat_type_eligible", false)
}

creditable_grassland_div(p) if {
	common.is_grassland_div(p)
	not creditable_blocked(p)
}

creditable_parcels := [p | some p in common.parcels; creditable_grassland_div(p)]

grassland_div_area_ha := sum([common.area(p) | some p in creditable_parcels])

# ---------------------------------------------------------------------------
# Mindestanlage 7 % (UBB-DIVG-MIN-001..002)
# ---------------------------------------------------------------------------
obligation_applies if common.mown_grassland_area_ha > 2.0

required_grassland_div_ha := common.mown_grassland_area_ha * common.limits.div_minimum_share if obligation_applies

default required_grassland_div_ha_or_zero := 0

required_grassland_div_ha_or_zero := required_grassland_div_ha

violations contains {"rule_id": "UBB-DIVG-MIN-001", "subject": "farm", "message": sprintf("Grünland-Biodiversitätsflächen %v ha unter Mindestanlage %v ha (7 %% der gemähten Grünlandfläche)", [grassland_div_area_ha, required_grassland_div_ha])} if {
	obligation_applies
	grassland_div_area_ha < required_grassland_div_ha - common.eps
}

# ---------------------------------------------------------------------------
# Feldstücksbezogene Anlageverpflichtung (UBB-DIVG-FS-001..002)
# ---------------------------------------------------------------------------
field_pieces := {common.field_piece(p) | some p in common.mown_grassland_parcels}

fp_mown_area(fp) := sum([common.area(p) | some p in common.mown_grassland_parcels; common.field_piece(p) == fp])

fp_credit_kind(p) if creditable_grassland_div(p)

fp_credit_kind(p) if common.area_kind(p) == "gloez_landscape_element"

fp_div_credit(fp) := sum([common.area(p) | some p in common.parcels; common.field_piece(p) == fp; fp_credit_kind(p)])

violations contains {"rule_id": "UBB-DIVG-FS-001", "subject": fp, "message": sprintf("Grünland-Feldstück %s (%v ha gemäht): nur %v ha Biodiversitätsflächen/anrechenbare Flächen (mind. 0,15 ha)", [fp, fp_mown_area(fp), fp_div_credit(fp)])} if {
	common.mown_grassland_area_ha >= 10.0
	some fp in field_pieces
	fp_mown_area(fp) > 5.0
	fp_div_credit(fp) < 0.15 - common.eps
}

# ---------------------------------------------------------------------------
# Allgemeine Auflagen (UBB-DIVG-BW-001..002)
# ---------------------------------------------------------------------------
own_managed(p) if {
	common.is_grassland_div(p)
	not common.has_code(p, "NAT")
	not common.has_code(p, "EBW")
	not common.has_code(p, "N2")
}

violations contains {"rule_id": "UBB-DIVG-BW-001", "subject": common.parcel_id(p), "message": "Pflanzenschutzmittel mit nicht gemäß VO (EU) 2018/848 zulässigen Wirkstoffen auf Grünland-Biodiversitätsfläche"} if {
	some p in common.parcels
	common.is_grassland_div(p)
	some a in object.get(p, ["operations", "psm_applications"], [])
	common.date_year(a.date) == common.year
	not object.get(a, "organic_approved_only", false)
}

mow_with_removal(p) if {
	some e in year_events(p)
	e.type == "mow"
	object.get(e, "material_removed", false)
}

violations contains {"rule_id": "UBB-DIVG-BW-002", "subject": common.parcel_id(p), "message": "Keine Mahd mit Verbringung des Mähgutes im Vertragsjahr"} if {
	some p in common.parcels
	own_managed(p)
	not mow_with_removal(p)
}

uses(p) := [e | some e in year_events(p); e.type in {"mow", "graze", "mulch", "cleaning_cut"}]

first_use_date(p) := min({e.date | some e in uses(p); e.type in {"mow", "graze"}})

no_premium_2026_code(p) if {
	common.year == 2026
	some c in common.tables.o6_1a_drought_2026_parameters.no_premium_codes
	common.has_code(p, c)
}

advance_days(p) := common.min_of(object.get(bio(p), "phenology_advance_days", 0), 10)

drought_advance(p) := common.tables.o6_1a_drought_2026_parameters.grassland_advance_days if no_premium_2026_code(p)

drought_advance(p) := 0 if not no_premium_2026_code(p)

# ---------------------------------------------------------------------------
# Variante DIVSZ (UBB-DIVG-SZ-001..004)
# ---------------------------------------------------------------------------
single_cut(p) if common.schlagnutzungsart(p) == "Einmähdige Wiese"

jun15(p) := common.shift_date(sprintf("%d-06-15", [common.year]), 0 - (advance_days(p) + drought_advance(p)))

jul15(p) := common.shift_date(sprintf("%d-07-15", [common.year]), 0 - (advance_days(p) + drought_advance(p)))

comparable_second_cut(p) := object.get(bio(p), "comparable_second_cut_date", null)

divsz_earliest(p) := jun15(p) if single_cut(p)

divsz_earliest(p) := jul15(p) if {
	not single_cut(p)
	comparable_second_cut(p) == null
}

divsz_earliest(p) := common.later_date(jun15(p), common.earlier_date(comparable_second_cut(p), jul15(p))) if {
	not single_cut(p)
	comparable_second_cut(p) != null
}

violations contains {"rule_id": "UBB-DIVG-SZ-001", "subject": common.parcel_id(p), "message": sprintf("Erste Nutzung am %s vor dem frühestmöglichen Termin %s (DIVSZ)", [first_use_date(p), divsz_earliest(p)])} if {
	some p in common.parcels
	common.has_code(p, "DIVSZ")
	own_managed(p)
	first_use_date(p) < divsz_earliest(p)
}

violations contains {"rule_id": "UBB-DIVG-SZ-002", "subject": common.parcel_id(p), "message": "Düngung vor der ersten Nutzung (DIVSZ)"} if {
	some p in common.parcels
	common.has_code(p, "DIVSZ")
	own_managed(p)
	some f in object.get(p, ["operations", "fertilization_events"], [])
	common.date_year(f.date) == common.year
	f.date < first_use_date(p)
}

violations contains {"rule_id": "UBB-DIVG-SZ-003", "subject": common.parcel_id(p), "message": "Häckseln vor der ersten Nutzung (DIVSZ)"} if {
	some p in common.parcels
	common.has_code(p, "DIVSZ")
	own_managed(p)
	some e in year_events(p)
	e.type == "mulch"
	e.date <= first_use_date(p)
}

# ---------------------------------------------------------------------------
# Variante DIVNFZ (UBB-DIVG-NFZ-001..004)
# ---------------------------------------------------------------------------
rest_days(p) := common.tables.o6_1a_drought_2026_parameters.divnfz_reduced_rest_days if no_premium_2026_code(p)

rest_days(p) := 63 if not no_premium_2026_code(p)

nfz_end(p) := object.get(bio(p), "first_use_completed_date", null)

activity_dates(p) := ({e.date | some e in year_events(p)} | {f.date | some f in object.get(p, ["operations", "fertilization_events"], [])}) | {d.date | some d in object.get(p, ["operations", "driving_events"], []); d.purpose != "crossing"}

violations contains {"rule_id": "UBB-DIVG-NFZ-001", "subject": common.parcel_id(p), "message": sprintf("Nutzungsfreier Zeitraum von %d Kalendertagen nach der ersten Nutzung nicht eingehalten (Tätigkeit am %s)", [rest_days(p), d])} if {
	some p in common.parcels
	common.has_code(p, "DIVNFZ")
	own_managed(p)
	nfz_end(p) != null
	some d in activity_dates(p)
	d > nfz_end(p)
	common.days_between(nfz_end(p), d) <= rest_days(p)
}

second_use(p) if {
	some e in year_events(p)
	e.type in {"mow", "graze"}
	nfz_end(p) != null
	e.date > nfz_end(p)
}

violations contains {"rule_id": "UBB-DIVG-NFZ-002", "subject": common.parcel_id(p), "message": "Keine zweite Nutzung im Kalenderjahr (DIVNFZ)"} if {
	some p in common.parcels
	common.has_code(p, "DIVNFZ")
	own_managed(p)
	not second_use(p)
}

violations contains {"rule_id": "UBB-DIVG-NFZ-003", "subject": common.parcel_id(p), "message": "Häckseln des Aufwuchses der ersten und zweiten Nutzung nicht erlaubt (DIVNFZ)"} if {
	some p in common.parcels
	common.has_code(p, "DIVNFZ")
	own_managed(p)
	some e in year_events(p)
	e.type == "mulch"
	not object.get(e, "post_grazing_care", false)
}

violations contains {"rule_id": "UBB-DIVG-NFZ-004", "subject": common.parcel_id(p), "message": "Dokumentation der ersten und zweiten Nutzung fehlt (bis Antragsjahr 2024)"} if {
	common.year <= 2024
	some p in common.parcels
	common.has_code(p, "DIVNFZ")
	own_managed(p)
	not object.get(bio(p), "use_dates_documented", false)
}

# ---------------------------------------------------------------------------
# Variante DIVAGF (UBB-DIVG-AGF-001..004)
# ---------------------------------------------------------------------------
aug15 := sprintf("%d-08-15", [common.year])

violations contains {"rule_id": "UBB-DIVG-AGF-001", "subject": common.parcel_id(p), "message": sprintf("Nutzung, Befahren oder Düngung am %s nach dem 15. August (DIVAGF)", [d])} if {
	some p in common.parcels
	common.has_code(p, "DIVAGF")
	own_managed(p)
	some d in activity_dates(p)
	d > aug15
}

violations contains {"rule_id": "UBB-DIVG-AGF-003", "subject": common.parcel_id(p), "message": "Altgrasfläche des Vorjahres ist lagegenau mit DIVSZ zu beantragen"} if {
	some p in common.parcels
	object.get(bio(p), "previous_year_code", "") == "DIVAGF"
	not common.has_code(p, "DIVSZ")
	not object.get(bio(p), "loss_of_control", false)
}

# ---------------------------------------------------------------------------
# Zuschlag Neueinsaat regionale Grünland-Saatgutmischung DIVRS (UBB-DIVRSG-001..008)
# ---------------------------------------------------------------------------
divrs_parcels := [p | some p in common.grassland_parcels; common.has_code(p, "DIVRS")]

mix(p) := object.get(bio(p), "seed_mixture", {})

site_ok(p) if {
	object.get(p, ["soil_index", "gruenlandzahl"], 0) >= 30
	object.get(p, "slope_percent", 100) < 18
}

regional_mix_ok(p) if {
	m := mix(p)
	object.get(m, "regional_list_species", 0) >= 30
	object.get(m, "regional_list_families", 0) >= 7
	object.get(m, "seed_rate_kg_per_ha", 0) >= 20
	single_species_ok(m)
	object.get(m, "regional_origin_certified", false)
	object.get(m, "documented_labels_invoices", false)
}

single_species_ok(m) if object.get(m, "max_single_species_weight_percent", 100) <= 5

single_species_ok(m) if object.get(m, "ecotype_seed_used", false)

sown_in_time(p) if {
	d := object.get(bio(p), "sowing_date", null)
	d != null
	d <= sprintf("%d-05-15", [first_year(p)])
}

first_year_new_sowing(p) if first_year(p) == common.year

counting_uses(p) := [e | some e in year_events(p); e.type in {"mow", "graze"}]

divrs_violation(p) if not site_ok(p)

divrs_violation(p) if not regional_mix_ok(p)

divrs_violation(p) if not sown_in_time(p)

divrs_violation(p) if count(counting_uses(p)) > 2

divrs_violation(p) if {
	some e in counting_uses(p)
	common.month_day(e.date) < "07-15"
}

divrs_violation(p) if {
	some e in year_events(p)
	e.type == "mulch"
}

divrs_violation(p) if {
	some e in year_events(p)
	e.type == "cleaning_cut"
	not first_year_new_sowing(p)
}

divrs_violation(p) if {
	some f in object.get(p, ["operations", "fertilization_events"], [])
	common.date_year(f.date) == common.year
	not f.type in {"solid_manure", "solid_manure_compost"}
}

divrs_violation(_) if common.year > 2028

divrs_violation(p) if object.get(bio(p), "divrs_continuous_since_sowing", true) == false

divrs_eligible(p) if {
	common.has_code(p, "DIVRS")
	common.is_grassland(p)
	not divrs_violation(p)
}

violations contains {"rule_id": "UBB-DIVRSG-001", "subject": common.parcel_id(p), "message": "Auflagen der DIVRS-Grünlandfläche nicht erfüllt (Standort, Saatgut, Termine, Nutzung, Düngung)"} if {
	some p in divrs_parcels
	divrs_violation(p)
}

# ---------------------------------------------------------------------------
# Kennzeichnung (UBB-ANT-020..021)
# ---------------------------------------------------------------------------
violations contains {"rule_id": "UBB-ANT-020", "subject": common.parcel_id(p), "message": sprintf("Grünland-Biodiversitätscode auf Schlagnutzungsart %s nicht zulässig", [common.schlagnutzungsart(p)])} if {
	some p in common.grassland_parcels
	common.is_grassland_div(p)
	not common.schlagnutzungsart(p) in {s | some s in common.tables.o6_1a_grassland_div_schlagnutzungsarten}
}

violations contains {"rule_id": "UBB-ANT-021", "subject": common.parcel_id(p), "message": "Aus NAT/EBW/N2 angerechnete Grünland-Biodiversitätsflächen sind mit DIVSZ zu kennzeichnen"} if {
	some p in common.grassland_parcels
	common.is_grassland_div(p)
	some c in {"NAT", "EBW", "N2"}
	common.has_code(p, c)
	not common.has_code(p, "DIVSZ")
}

# ---------------------------------------------------------------------------
# Variantenwechsel nach dem 15. April (N26-TR-008)
# ---------------------------------------------------------------------------
variant_change_allowed(ch) if {
	ch.date <= sprintf("%d-04-15", [common.date_year(ch.date)])
}

variant_change_allowed(ch) if {
	some r in common.tables.o6_1a_grassland_div_variant_changes_after_april_15
	r.from == ch.from
	r.to == ch.to
	r.allowed
	common.month_day(ch.date) <= r.until_month_day
}

violations contains {"rule_id": "N26-TR-008", "subject": common.parcel_id(p), "message": sprintf("Wechsel von %s auf %s am %s nicht zulässig", [ch.from, ch.to, ch.date])} if {
	some p in common.parcels
	ch := object.get(bio(p), "variant_change", null)
	ch != null
	not variant_change_allowed(ch)
}
