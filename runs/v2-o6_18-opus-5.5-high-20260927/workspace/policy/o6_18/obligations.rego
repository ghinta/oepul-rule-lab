# METADATA
# title: ÖPUL 2023 Naturschutz (18) – allgemeine Auflagen und Bewirtschaftungsauflagen laut Projektbestätigung
package oepul.o6_18.obligations

import data.oepul.o6_18.lib
import data.oepul.o6_18.notices_2026

p := lib.params

activities(parcel) := object.get(lib.ns(parcel), "activities", {})

activity(parcel, k) if object.get(activities(parcel), k, false) == true

is_grassland(parcel) if parcel.land_use == "grassland"

# Nutzungen im Jahr: Schnitte plus Weideperioden.
use_count(parcel) := count(lib.cutting_dates(parcel)) + count(lib.grazing_periods(parcel))

used_or_cared(parcel, y) if y in object.get(lib.ns(parcel), "use_or_care_years", [])

used_or_cared(parcel, y) if {
	y == lib.year
	use_count(parcel) > 0
}

# O618-OBL-001: Mindestens eine Nutzung/Pflege alle 2 Jahre.
violations contains v if {
	some parcel in lib.nat_parcels
	object.get(lib.ns(parcel), "year_completed", false)
	not used_or_cared(parcel, lib.year)
	not used_or_cared(parcel, lib.year - 1)
	v := {"rule_id": "O618-OBL-001", "parcel_id": parcel.parcel_id, "message": "Keine Nutzung/Pflege innerhalb von 2 Jahren"}
}

# O618-OBL-002: Maximal 3 Nutzungen von Grünlandflächen pro Jahr.
violations contains v if {
	some parcel in lib.nat_parcels
	is_grassland(parcel)
	use_count(parcel) > p.general_obligations.max_grassland_uses_per_year
	v := {"rule_id": "O618-OBL-002", "parcel_id": parcel.parcel_id, "message": sprintf("%d Nutzungen auf Grünland (max. 3)", [use_count(parcel)])}
}

# O618-OBL-003: Keine maschinelle Entsteinung, Geländekorrekturen, Ablagerungen und Aufschüttungen.
violations contains v if {
	some parcel in lib.nat_parcels
	some k in ["mechanical_stone_removal", "terrain_correction", "deposits", "fill_up"]
	activity(parcel, k)
	v := {"rule_id": "O618-OBL-003", "parcel_id": parcel.parcel_id, "message": sprintf("Verbotene Maßnahme: %v", [k])}
}

# O618-OBL-004: Keine Neuentwässerung.
violations contains v if {
	some parcel in lib.nat_parcels
	activity(parcel, "new_drainage")
	v := {"rule_id": "O618-OBL-004", "parcel_id": parcel.parcel_id, "message": "Neuentwässerung ist verboten"}
}

# O618-OBL-005: Keine Lagerung von Siloballen.
violations contains v if {
	some parcel in lib.nat_parcels
	activity(parcel, "silage_bale_storage")
	v := {"rule_id": "O618-OBL-005", "parcel_id": parcel.parcel_id, "message": "Lagerung von Siloballen ist verboten"}
}

# O618-OBL-006: Keine Ein- oder Nachsaaten auf Grünland, außer Sanierung nach schriftlicher Genehmigung.
reseeding(parcel) := object.get(activities(parcel), "reseeding", {})

reseeding_exception(parcel) if {
	object.get(reseeding(parcel), "reason", null) in p.general_obligations.reseeding_exception_reasons
	object.get(reseeding(parcel), "written_approval", false)
}

violations contains v if {
	some parcel in lib.nat_parcels
	is_grassland(parcel)
	object.get(reseeding(parcel), "performed", false)
	not reseeding_exception(parcel)
	v := {"rule_id": "O618-OBL-006", "parcel_id": parcel.parcel_id, "message": "Ein-/Nachsaat auf Grünland ohne genehmigte Sanierungsausnahme"}
}

# O618-OBL-007: Keine zusätzliche Düngung auf Weideflächen (ausgenommen Mähweiden).
violations contains v if {
	some parcel in lib.nat_parcels
	object.get(lib.ns(parcel), "grassland_type", null) in {"weide", "hutweide"}
	lib.fertilized(parcel)
	v := {"rule_id": "O618-OBL-007", "parcel_id": parcel.parcel_id, "message": "Zusätzliche Düngung auf Weidefläche (keine Mähweide)"}
}

# O618-OBL-008: Keine Ausbringung von Klärschlamm und Klärschlammkompost.
violations contains v if {
	some parcel in lib.nat_parcels
	some e in lib.fertilization_events(parcel)
	e.type in {"klaerschlamm", "klaerschlammkompost"}
	v := {"rule_id": "O618-OBL-008", "parcel_id": parcel.parcel_id, "message": "Ausbringung von Klärschlamm/Klärschlammkompost ist verboten"}
}

# O618-OBL-009: Weidetagebuch bei Auflagen mit verpflichtender Beweidung, tagaktuell.
requires_grazing(parcel) if {
	some c in lib.auflagen_of(parcel)
	lib.auflage_by_code[c].requires_grazing
}

diary(parcel) := object.get(lib.ns(parcel), "grazing_diary", {})

violations contains v if {
	some parcel in lib.nat_parcels
	requires_grazing(parcel)
	not object.get(diary(parcel), "kept", false)
	v := {"rule_id": "O618-OBL-009", "parcel_id": parcel.parcel_id, "message": "Weidetagebuch fehlt trotz Auflage mit verpflichtender Beweidung"}
}

violations contains v if {
	some parcel in lib.nat_parcels
	requires_grazing(parcel)
	object.get(diary(parcel), "kept", false)
	not object.get(diary(parcel), "daily_current", false)
	v := {"rule_id": "O618-OBL-009", "parcel_id": parcel.parcel_id, "message": "Weidetagebuch nicht tagaktuell geführt"}
}

# O618-OBL-013: Zusammengefasste Weideaufzeichnungen nur bei gleicher Bewirtschaftung und erkennbarer Einheit.
violations contains v if {
	some parcel in lib.nat_parcels
	object.get(diary(parcel), "combined_with_other_plots", false)
	not object.get(diary(parcel), "same_management_and_visible_unit", false)
	v := {"rule_id": "O618-OBL-013", "parcel_id": parcel.parcel_id, "message": "Zusammengefasste Weideaufzeichnung ohne gleiche Bewirtschaftung/erkennbare Einheit"}
}

# O618-OBL-010: Abänderung der Bewirtschaftung nur nach Rücksprache und schriftlicher Abänderung der Projektbestätigung.
violations contains v if {
	some parcel in lib.nat_parcels
	object.get(lib.pc(parcel), "management_deviates", false)
	not object.get(lib.pc(parcel), "written_amendment", false)
	v := {"rule_id": "O618-OBL-010", "parcel_id": parcel.parcel_id, "message": "Abweichende Bewirtschaftung ohne schriftliche Abänderung der Projektbestätigung"}
}

# O618-N26-001 (Freigabe 2026): ab 12.08.2026 Nutzung trotz späterem Nutzungstermin zulässig.
effective_date(d) := lib.min2(d, p.drought_2026.naturschutz_use_release_date) if lib.year == 2026

effective_date(d) := d if lib.year != 2026

# O618-OBL-011A: Früheste Mahd laut Projektbestätigung (GL-Auflagen, NM05).
violations contains v if {
	some parcel in lib.nat_parcels
	some c in lib.auflagen_of(parcel)
	lib.auflage_by_code[c].earliest_mowing_date_parameter
	earliest := object.get(lib.pc(parcel), "earliest_mowing_date", null)
	earliest != null
	some d in lib.cutting_dates(parcel)
	d < effective_date(earliest)
	v := {"rule_id": "O618-OBL-011A", "parcel_id": parcel.parcel_id, "message": sprintf("Mahd am %v vor frühestem Mahdtermin %v (Auflage %v)", [d, effective_date(earliest), c])}
}

# O618-OBL-011B: Anzahl der Mahden gemäß GA-Auflage (3/2/1 x Mahd und Abtransport pro Jahr).
violations contains v if {
	some parcel in lib.nat_parcels
	object.get(lib.ns(parcel), "year_completed", false)
	some c in lib.auflagen_of(parcel)
	n := lib.auflage_by_code[c].required_mowings_per_year
	n != null
	count(lib.cutting_dates(parcel)) != n
	v := {"rule_id": "O618-OBL-011B", "parcel_id": parcel.parcel_id, "message": sprintf("Auflage %v verlangt %d Mahd(en), erfolgt: %d", [c, n, count(lib.cutting_dates(parcel))])}
}

fert_rule(parcel) := {r |
	some c in lib.auflagen_of(parcel)
	r := lib.auflage_by_code[c].fertilization_rule
	r != null
}

# O618-OBL-011C: Düngeverbot bzw. Verbot zusätzlicher Düngung.
violations contains v if {
	some parcel in lib.nat_parcels
	some r in fert_rule(parcel)
	r in {"ban", "additional_ban"}
	lib.fertilized(parcel)
	v := {"rule_id": "O618-OBL-011C", "parcel_id": parcel.parcel_id, "message": "Düngung trotz Düngeverbot laut Projektbestätigung"}
}

# O618-OBL-011D: Düngung nur mit Festmist.
violations contains v if {
	some parcel in lib.nat_parcels
	some r in fert_rule(parcel)
	r in {"solid_manure_only", "solid_manure_every_second_year", "solid_manure_two_years_from_sept"}
	some e in lib.fertilization_events(parcel)
	e.type != "festmist"
	v := {"rule_id": "O618-OBL-011D", "parcel_id": parcel.parcel_id, "message": sprintf("Düngung mit %v, erlaubt ist nur Festmist", [e.type])}
}

violations contains v if {
	some parcel in lib.nat_parcels
	some r in fert_rule(parcel)
	r in {"solid_manure_only", "solid_manure_every_second_year", "solid_manure_two_years_from_sept", "farm_manure_from_sept", "farm_manure_only"}
	lib.mineral_fertilized(parcel)
	v := {"rule_id": "O618-OBL-011D", "parcel_id": parcel.parcel_id, "message": "Mineralische Düngung bei Festmist-/Wirtschaftsdüngerauflage unzulässig"}
}

# O618-OBL-011E: Düngung mit Wirtschaftsdüngern frühestens ab 01.09. (GI22-GI25, BB07).
violations contains v if {
	some parcel in lib.nat_parcels
	some r in fert_rule(parcel)
	r in {"farm_manure_from_sept", "solid_manure_two_years_from_sept"}
	some e in lib.fertilization_events(parcel)
	substring(e.date, 5, 5) < "09-01"
	v := {"rule_id": "O618-OBL-011E", "parcel_id": parcel.parcel_id, "message": sprintf("Düngung am %v vor dem 01.09.", [e.date])}
}

# O618-OBL-011S: Düngung nur in den festgelegten Jahren (jedes 2. Jahr bzw. Jahre $1/$2).
violations contains v if {
	some parcel in lib.nat_parcels
	some r in fert_rule(parcel)
	r in {"solid_manure_every_second_year", "solid_manure_two_years_from_sept", "every_second_year"}
	allowed := object.get(lib.pc(parcel), "fertilization_allowed_years", null)
	allowed != null
	lib.fertilized(parcel)
	not lib.year in allowed
	v := {"rule_id": "O618-OBL-011S", "parcel_id": parcel.parcel_id, "message": sprintf("Düngung im Jahr %d laut Projektbestätigung nicht erlaubt", [lib.year])}
}

# O618-OBL-011F: Pflanzenschutzmittel-/Pestizidverbot (TC01: ausgenommen Mittel gemäß EU-Bio-Verordnung).
violations contains v if {
	some parcel in lib.nat_parcels
	some c in lib.auflagen_of(parcel)
	lib.auflage_by_code[c].psm_ban
	object.get(parcel, ["operations", "psm_used"], false)
	v := {"rule_id": "O618-OBL-011F", "parcel_id": parcel.parcel_id, "message": sprintf("Pflanzenschutzmitteleinsatz trotz Auflage %v", [c])}
}

violations contains v if {
	some parcel in lib.nat_parcels
	some c in lib.auflagen_of(parcel)
	lib.auflage_by_code[c].psm_ban_except_eu_organic
	object.get(parcel, ["operations", "psm_used"], false)
	not object.get(lib.ns(parcel), "psm_only_eu_organic_approved", false)
	v := {"rule_id": "O618-OBL-011F", "parcel_id": parcel.parcel_id, "message": sprintf("Pestizideinsatz (nicht EU-Bio-konform) trotz Auflage %v", [c])}
}

# O618-OBL-011G: Maisverzicht (TD01).
violations contains v if {
	some parcel in lib.nat_parcels
	some c in lib.auflagen_of(parcel)
	lib.auflage_by_code[c].maize_ban
	object.get(parcel, ["crop", "crop_category"], null) == "maize"
	v := {"rule_id": "O618-OBL-011G", "parcel_id": parcel.parcel_id, "message": "Maisanbau trotz Maisverzicht (TD01)"}
}

# O618-OBL-011H: Beweidungsverbot (NW09).
violations contains v if {
	some parcel in lib.nat_parcels
	some c in lib.auflagen_of(parcel)
	lib.auflage_by_code[c].grazing_ban
	lib.is_grazed(parcel)
	v := {"rule_id": "O618-OBL-011H", "parcel_id": parcel.parcel_id, "message": "Beweidung trotz Beweidungsverbot (NW09)"}
}

# O618-OBL-011I: Keine Beweidung vor dem 1. Schnitt (GB01, NW10).
violations contains v if {
	some parcel in lib.nat_parcels
	some c in lib.auflagen_of(parcel)
	lib.auflage_by_code[c].grazing_before_first_cut_ban
	some g in lib.grazing_periods(parcel)
	grazed_before_first_cut(parcel, g)
	v := {"rule_id": "O618-OBL-011I", "parcel_id": parcel.parcel_id, "message": sprintf("Beweidung ab %v vor dem 1. Schnitt (Auflage %v)", [g.start, c])}
}

grazed_before_first_cut(parcel, g) if g.start < lib.first_cut(parcel)

grazed_before_first_cut(parcel, _) if count(lib.cutting_dates(parcel)) == 0

# O618-OBL-011J: Keine Beweidung nach dem letzten Schnitt (NW11).
violations contains v if {
	some parcel in lib.nat_parcels
	some c in lib.auflagen_of(parcel)
	lib.auflage_by_code[c].grazing_after_last_cut_ban
	some g in lib.grazing_periods(parcel)
	g.end > lib.last_cut(parcel)
	v := {"rule_id": "O618-OBL-011J", "parcel_id": parcel.parcel_id, "message": "Beweidung nach dem letzten Schnitt (NW11)"}
}

# O618-OBL-011K: Viehbesatz bei Weideauflagen (WA01 max. 1 RGVE/ha und Jahr, WA03 max. 0,5 RGVE/ha und Jahr).
period_days(g) := lib.days_between(g.start, g.end) + 1

rgve_day_terms(parcel) := [t |
	some g in lib.grazing_periods(parcel)
	some a in object.get(g, "animals", [])
	t := (a.count * key_rgve(a.annex_a_key)) * period_days(g)
]

rgve_days(parcel) := sum(rgve_day_terms(parcel))

key_rgve(k) := r.rgve if {
	some r in data.o6_18.annex_a_gve_key.rows
	r.key == k
	r.rgve != null
}

rgve_per_ha_year(parcel) := (rgve_days(parcel) / 365) / lib.area(parcel) if lib.area(parcel) > 0

violations contains v if {
	some parcel in lib.nat_parcels
	some c in lib.auflagen_of(parcel)
	limit := lib.auflage_by_code[c].max_rgve_per_ha_year
	limit != null
	rgve_per_ha_year(parcel) > limit
	v := {"rule_id": "O618-OBL-011K", "parcel_id": parcel.parcel_id, "message": sprintf("Viehbesatz %.2f RGVE/ha und Jahr über Grenze %v (Auflage %v)", [rgve_per_ha_year(parcel), limit, c])}
}

# NW05/NW06: maximaler GVE-Besatz laut Projektbestätigung.
violations contains v if {
	some parcel in lib.nat_parcels
	lib.has_any_auflage(parcel, ["NW06"])
	limit := object.get(lib.pc(parcel), "max_gve_per_ha", null)
	limit != null
	rgve_per_ha_year(parcel) > limit
	v := {"rule_id": "O618-OBL-011K", "parcel_id": parcel.parcel_id, "message": "Viehbesatz über Maximalbesatz laut Projektbestätigung (NW06)"}
}

# O618-OBL-011L: Zeitfenster zwischen erster und zweiter Nutzung mindestens 9 Wochen (GN03).
violations contains v if {
	some parcel in lib.nat_parcels
	lib.has_auflage(parcel, "GN03")
	count(lib.cutting_dates(parcel)) >= 2
	lib.days_between(lib.sorted_cuts(parcel)[0], lib.sorted_cuts(parcel)[1]) < 63
	v := {"rule_id": "O618-OBL-011L", "parcel_id": parcel.parcel_id, "message": "Weniger als 9 Wochen zwischen erster und zweiter Nutzung (GN03)"}
}

# O618-OBL-011M: 2. Nutzung erst ab Termin laut Projektbestätigung (GN01, GN02 ab 01.09.).
violations contains v if {
	some parcel in lib.nat_parcels
	lib.has_any_auflage(parcel, ["GN01", "GN02"])
	d2 := object.get(lib.pc(parcel), "second_use_earliest_date", null)
	d2 != null
	count(lib.cutting_dates(parcel)) >= 2
	lib.sorted_cuts(parcel)[1] < effective_date(d2)
	v := {"rule_id": "O618-OBL-011M", "parcel_id": parcel.parcel_id, "message": sprintf("2. Nutzung vor %v", [effective_date(d2)])}
}

# O618-OBL-011N: Frühe erste Mahd vor Termin und weitere Mahd (GK02, BG01).
violations contains v if {
	some parcel in lib.nat_parcels
	lib.has_any_auflage(parcel, ["GK02", "BG01"])
	before := object.get(lib.pc(parcel), "first_mowing_before_date", null)
	before != null
	count(lib.cutting_dates(parcel)) > 0
	lib.first_cut(parcel) >= before
	v := {"rule_id": "O618-OBL-011N", "parcel_id": parcel.parcel_id, "message": sprintf("1. Mahd nicht vor %v", [before])}
}

violations contains v if {
	some parcel in lib.nat_parcels
	lib.has_any_auflage(parcel, ["GK02", "BG01"])
	object.get(lib.ns(parcel), "year_completed", false)
	count(lib.cutting_dates(parcel)) < 2
	v := {"rule_id": "O618-OBL-011N", "parcel_id": parcel.parcel_id, "message": "Keine weitere Mahd nach früher erster Mahd"}
}

# O618-OBL-011O: Bewässerungsverbot (NA06, NV07).
violations contains v if {
	some parcel in lib.nat_parcels
	some c in lib.auflagen_of(parcel)
	lib.auflage_by_code[c].irrigation_ban
	object.get(lib.ns(parcel), "irrigation_used", false)
	v := {"rule_id": "O618-OBL-011O", "parcel_id": parcel.parcel_id, "message": sprintf("Bewässerung trotz Auflage %v", [c])}
}

# O618-OBL-011P: Silageverbot (NA22, GM01).
violations contains v if {
	some parcel in lib.nat_parcels
	some c in lib.auflagen_of(parcel)
	lib.auflage_by_code[c].silage_ban
	object.get(lib.ns(parcel), "silage_produced", false)
	v := {"rule_id": "O618-OBL-011P", "parcel_id": parcel.parcel_id, "message": sprintf("Silageproduktion trotz Auflage %v", [c])}
}

# O618-OBL-011Q: Beweidungszeitraum laut Projektbestätigung (WA01/WA03/BA03/BA04: frühestens ab $1, längstens bis $2).
violations contains v if {
	some parcel in lib.nat_parcels
	lib.has_any_auflage(parcel, ["WA01", "WA03", "BA03", "BA04", "NW17"])
	start := object.get(lib.pc(parcel), "grazing_window_start", null)
	start != null
	some g in lib.grazing_periods(parcel)
	g.start < start
	v := {"rule_id": "O618-OBL-011Q", "parcel_id": parcel.parcel_id, "message": sprintf("Beweidung ab %v vor erlaubtem Beginn %v", [g.start, start])}
}

violations contains v if {
	some parcel in lib.nat_parcels
	lib.has_any_auflage(parcel, ["WA01", "WA03", "BA03", "BA04", "NW17"])
	end := object.get(lib.pc(parcel), "grazing_window_end", null)
	end != null
	some g in lib.grazing_periods(parcel)
	g.end > end
	v := {"rule_id": "O618-OBL-011Q", "parcel_id": parcel.parcel_id, "message": sprintf("Beweidung bis %v nach erlaubtem Ende %v", [g.end, end])}
}

# O618-OBL-011R: Mähweide-Nutzungsmuster (GA15/GA17 max. 2 x Weide, mind. 1 x Mahd, max. 3 Nutzungen; GA16/GA18 1 x Weide und 1 x Mahd).
violations contains v if {
	some parcel in lib.nat_parcels
	object.get(lib.ns(parcel), "year_completed", false)
	some c in lib.auflagen_of(parcel)
	pat := lib.auflage_by_code[c].maehweide_pattern
	pat != null
	not maehweide_ok(parcel, pat)
	v := {"rule_id": "O618-OBL-011R", "parcel_id": parcel.parcel_id, "message": sprintf("Nutzungsmuster der Mähweide-Auflage %v nicht eingehalten", [c])}
}

maehweide_ok(parcel, pat) if {
	pat.max_grazings
	count(lib.grazing_periods(parcel)) <= pat.max_grazings
	count(lib.cutting_dates(parcel)) >= pat.min_mowings
	use_count(parcel) <= pat.max_uses
}

maehweide_ok(parcel, pat) if {
	pat.grazings
	count(lib.grazing_periods(parcel)) == pat.grazings
	count(lib.cutting_dates(parcel)) == pat.mowings
}

# O618-OBL-011T: Befahren der Mähwiese/Mähweide bis zum 1. Schnitt verboten (GB01).
violations contains v if {
	some parcel in lib.nat_parcels
	lib.has_any_auflage(parcel, ["GB01"])
	object.get(lib.ns(parcel), "driven_on_before_first_cut", false)
	v := {"rule_id": "O618-OBL-011T", "parcel_id": parcel.parcel_id, "message": "Befahren vor dem 1. Schnitt (GB01)"}
}

# O618-OBL-011U: Verzicht auf Erneuerung/Wartung von Drainagen (GC01-GC03) und Grabenfräsen (GC04).
violations contains v if {
	some parcel in lib.nat_parcels
	lib.has_any_auflage(parcel, ["GC01", "GC02", "GC03"])
	activity(parcel, "drainage_maintenance")
	v := {"rule_id": "O618-OBL-011U", "parcel_id": parcel.parcel_id, "message": "Erneuerung oder Wartung von Drainagen verboten"}
}

violations contains v if {
	some parcel in lib.nat_parcels
	lib.has_any_auflage(parcel, ["GC04"])
	activity(parcel, "trench_milling")
	v := {"rule_id": "O618-OBL-011U", "parcel_id": parcel.parcel_id, "message": "Grabenräumung mit Grabenfräse verboten (GC04)"}
}

# O618-OBL-012: Nachweide auf Bergmahd-Naturschutzflächen nur, wenn als Auflage ausgewiesen (auch nicht ab 16.08.).
violations contains v if {
	some parcel in lib.nat_parcels
	object.get(lib.ns(parcel), "is_bergmahd", false)
	count(lib.cutting_dates(parcel)) > 0
	some g in lib.grazing_periods(parcel)
	g.start > lib.last_cut(parcel)
	not lib.has_any_auflage(parcel, p.nachweide_allowing_codes)
	v := {"rule_id": "O618-OBL-012", "parcel_id": parcel.parcel_id, "message": "Nachweide auf Bergmahd-Naturschutzfläche ohne entsprechende Auflage"}
}

# O618-OBL-014: Ernteverpflichtung (85 %) auf bewirtschafteten NAT-Ackerflächen (Kapitel A); 2026 Dürre-Ausnahme.
chapter_a_arable(parcel) if {
	some c in lib.auflagen_of(parcel)
	lib.chapter_of(c) == "A"
}

violations contains v if {
	some parcel in lib.nat_parcels
	parcel.land_use == "arable"
	chapter_a_arable(parcel)
	share := object.get(lib.ns(parcel), "harvest_share", null)
	share != null
	share < 0.85
	not drought_harvest_exempt(parcel)
	v := {"rule_id": "O618-OBL-014", "parcel_id": parcel.parcel_id, "message": sprintf("Ernte nur auf %v des Schlages (mind. 85 %%)", [share])}
}

drought_harvest_exempt(parcel) if {
	lib.year == 2026
	object.get(lib.ns(parcel), "drought_no_harvestable_crop", false)
	notices_2026.harvest_exemption_district
}

# O618-OBL-015: NAT-Grünbrachen sind von den Mindestbewirtschaftungskriterien ausgenommen.
minimum_criteria_exempt contains parcel.parcel_id if {
	some parcel in lib.nat_parcels
	object.get(parcel, ["oepul", "schlagnutzung"], null) == "Grünbrache"
}
