# METADATA
# title: ÖPUL 2023 Naturschutz (18) – Kombinationen (Anhang J, Anhang L, UBB/BIO, EBW)
package oepul.o6_18.combinations

import data.oepul.o6_18.lib

p := lib.params

matrix_row(ch) := row if {
	some row in data.o6_18.annex_j.matrix
	row.chapter == ch
}

chapter_codes(parcel) := {c | some c in lib.auflagen_of(parcel); lib.chapter_of(c)}

# O618-KOMB-001: Kapitel S, A (inkl. T), B, G, W, O untereinander nicht kombinierbar; L/H laut Matrix Anhang J.
violations contains v if {
	some parcel in lib.nat_parcels
	some c1 in chapter_codes(parcel)
	some c2 in chapter_codes(parcel)
	ch1 := lib.chapter_of(c1)
	ch2 := lib.chapter_of(c2)
	ch1 < ch2
	matrix_row(ch1)[ch2] == false
	v := {"rule_id": "O618-KOMB-001", "parcel_id": parcel.parcel_id, "message": sprintf("Auflagen %v (Kapitel %v) und %v (Kapitel %v) laut Anhang J nicht kombinierbar", [c1, ch1, c2, ch2])}
}

# O618-KOMB-002: Verpflichtende Kombinationen (SB/SC nur mit SA01; GF nur mit GE01-GE03; BD nur mit BC01).
required_any(c) := r if {
	a := lib.auflage_by_code[c]
	c == a.code
	r := a.requires_any_of
	r != null
}

required_any(c) := r if {
	a := lib.auflage_by_code[c]
	c != a.code
	r := a.alias_requires_any_of[c]
}

required_any(c) := ["SA01"] if {
	startswith(c, "SC")
	not lib.auflage_by_code[c].requires_any_of
}

violations contains v if {
	some parcel in lib.nat_parcels
	some c in lib.auflagen_of(parcel)
	req := required_any(c)
	not lib.has_any_auflage(parcel, req)
	v := {"rule_id": "O618-KOMB-002", "parcel_id": parcel.parcel_id, "message": sprintf("Auflage %v verpflichtend mit einer von %v zu kombinieren", [c, req])}
}

# O618-KOMB-003: AC01 und AC03 sind mit AA06 nicht kombinierbar.
violations contains v if {
	some parcel in lib.nat_parcels
	some c in lib.auflagen_of(parcel)
	excl := lib.auflage_by_code[c].not_combinable_with
	excl != null
	some x in excl
	lib.has_auflage(parcel, x)
	c < x
	v := {"rule_id": "O618-KOMB-003", "parcel_id": parcel.parcel_id, "message": sprintf("Auflagen %v und %v nicht kombinierbar", [c, x])}
}

# O618-KOMB-004/005: GL06/GL15/GL25 bzw. TA/TB verlangen UBB oder BIO samt Monitoring-Zuschlag.
violations contains v if {
	some req in p.monitoring_requirements
	some parcel in lib.nat_parcels
	some c in req.auflage_codes
	lib.has_auflage(parcel, c)
	not monitoring_fulfilled(req)
	rid := monitoring_rule_id(req.option)
	v := {"rule_id": rid, "parcel_id": parcel.parcel_id, "message": sprintf("Auflage %v erfordert Teilnahme an UBB oder BIO mit Zuschlag Monitoring '%v'", [c, req.option])}
}

monitoring_fulfilled(req) if {
	lib.participates_ubb_or_bio
	req.option in lib.monitoring_options
}

monitoring_rule_id("schnittzeit_phaenologie") := "O618-KOMB-004"

monitoring_rule_id("grosstrappe") := "O618-KOMB-005"

# O618-KOMB-017: Monitoring-Zuschläge (UBB/BIO) nur mit NAT-Teilnahme und passender Auflage auf mind. einem Schlag.
violations contains v if {
	"grosstrappe" in lib.monitoring_options
	not any_nat_auflage(["TA01"])
	v := {"rule_id": "O618-KOMB-017", "parcel_id": null, "message": "Monitoring Großtrappe nur bei Naturschutz-Teilnahme mit Auflage TA01 auf mind. einem Schlag"}
}

violations contains v if {
	"schnittzeit_phaenologie" in lib.monitoring_options
	not any_nat_auflage(["GL06", "GL15", "GL25"])
	v := {"rule_id": "O618-KOMB-017", "parcel_id": null, "message": "Monitoring Schnittzeit nach Phänologie nur bei Naturschutz-Teilnahme mit GL06/GL15/GL25 auf mind. einem Schlag"}
}

any_nat_auflage(cs) if {
	some parcel in lib.nat_parcels
	lib.has_any_auflage(parcel, cs)
}

# O618-KOMB-006: Anrechnung NAT-Ackerstilllegung als Biodiversitätsfläche (SA01 inkl. SB01-SB18/SC02, Grünbrache, NAT + DIV).
div_countable_arable contains parcel.parcel_id if {
	lib.participates_ubb_or_bio
	some parcel in lib.nat_parcels
	lib.has_any_auflage(parcel, p.div_accounting.arable.auflage_codes_any_of)
	object.get(parcel, ["oepul", "schlagnutzung"], null) in p.div_accounting.arable.schlagnutzung
	every c in p.div_accounting.arable.required_codes {
		lib.has_code(parcel, c)
	}
}

# O618-KOMB-007: Anrechnung NAT-Grünland mit Schnittzeitpunktverzögerung als Biodiversitätsfläche (NAT + DIVSZ).
div_countable_grassland contains parcel.parcel_id if {
	lib.participates_ubb_or_bio
	some parcel in lib.nat_parcels
	lib.has_any_auflage(parcel, p.div_accounting.grassland.auflage_codes_any_of)
	object.get(parcel, ["oepul", "schlagnutzung"], null) in p.div_accounting.grassland.schlagnutzung
	every c in p.div_accounting.grassland.required_codes {
		lib.has_code(parcel, c)
	}
}

div_countable := div_countable_arable | div_countable_grassland

# O618-KOMB-008: NAT-Schläge mit DIV/DIVSZ, die die Anrechnungsbedingungen nicht erfüllen.
violations contains v if {
	some parcel in lib.nat_parcels
	some dc in ["DIV", "DIVSZ"]
	lib.has_code(parcel, dc)
	not parcel.parcel_id in div_countable
	v := {"rule_id": "O618-KOMB-008", "parcel_id": parcel.parcel_id, "message": sprintf("NAT-Schlag mit Code %v erfüllt die Anrechnungsbedingungen als Biodiversitätsfläche nicht", [dc])}
}

# O618-KOMB-009: Feldstücke > 5 ha: mind. 0,15 ha Biodiversitätsfläche auch bei Einbringung in NAT (bei UBB/BIO).
feldstuecke contains fs if {
	some parcel in lib.parcels
	fs := object.get(parcel, ["oepul", "feldstueck_id"], null)
	fs != null
}

feldstueck_area(fs) := max([object.get(parcel, ["oepul", "feldstueck_area_ha"], 0) |
	some parcel in lib.parcels
	object.get(parcel, ["oepul", "feldstueck_id"], null) == fs
])

feldstueck_div_area(fs) := sum([lib.area(parcel) |
	some parcel in lib.parcels
	object.get(parcel, ["oepul", "feldstueck_id"], null) == fs
	counts_as_div(parcel)
])

counts_as_div(parcel) if parcel.parcel_id in div_countable

counts_as_div(parcel) if {
	not lib.is_nat(parcel)
	some dc in ["DIV", "DIVSZ", "DIVNFZ", "DIVAGF", "DIVRS"]
	lib.has_code(parcel, dc)
}

feldstueck_has_nat(fs) if {
	some parcel in lib.nat_parcels
	object.get(parcel, ["oepul", "feldstueck_id"], null) == fs
}

violations contains v if {
	lib.participates_ubb_or_bio
	some fs in feldstuecke
	feldstueck_has_nat(fs)
	feldstueck_area(fs) > p.div_accounting.feldstueck_threshold_ha
	feldstueck_div_area(fs) < p.div_accounting.feldstueck_min_div_area_ha
	v := {"rule_id": "O618-KOMB-009", "parcel_id": null, "message": sprintf("Feldstück %v > 5 ha ohne mind. 0,15 ha Biodiversitätsfläche", [fs])}
}

# O618-KOMB-010: Keine Prämienkombination auf der Einzelfläche außer Natura 2000 (23) und Landschaftselement-Abgeltung (1A/1B).
allowed_single_area := {m | some row in data.o6_18.annex_l_row_18.combinations; m := row.measure_id}

conflicting_single_area_measures(parcel) := {m |
	some m in object.get(parcel, ["oepul", "other_area_measures"], [])
	not m in allowed_single_area
}

violations contains v if {
	some parcel in lib.nat_parcels
	bad := conflicting_single_area_measures(parcel)
	count(bad) > 0
	v := {"rule_id": "O618-KOMB-010", "parcel_id": parcel.parcel_id, "message": sprintf("NAT-Fläche prämienmäßig nicht kombinierbar mit %v", [bad])}
}

# 1A/1B auf NAT-Einzelfläche nur hinsichtlich Abgeltung der Landschaftselemente (Fußnote 1).
violations contains v if {
	some parcel in lib.nat_parcels
	some m in object.get(parcel, ["oepul", "other_area_measures"], [])
	m in {"1A", "1B"}
	not object.get(parcel, ["oepul", "ubb_bio_only_landscape_elements"], false)
	v := {"rule_id": "O618-KOMB-010", "parcel_id": parcel.parcel_id, "message": sprintf("Maßnahme %v auf NAT-Fläche nur betreffend Abgeltung der Landschaftselemente kombinierbar", [m])}
}

# O618-KOMB-012: NAT ist mit EBW am Betrieb kombinierbar (keine Einzelflächen-Doppelförderung).
farm_level_combinable(m) if m in p.farm_level_combinable_measures

violations contains v if {
	some parcel in lib.nat_parcels
	lib.has_code(parcel, "EBW")
	v := {"rule_id": "O618-KOMB-012", "parcel_id": parcel.parcel_id, "message": "Schlag gleichzeitig mit NAT und EBW codiert – Kombination nur auf Betriebsebene"}
}

# O618-KOMB-014: NPF-Code (bis 2024) – Anrechnung für GLÖZ 8, keine ÖPUL-Prämie.
npf_parcels contains parcel.parcel_id if {
	some parcel in lib.nat_parcels
	lib.has_code(parcel, "NPF")
	lib.year <= p.npf_code_until_year
}

violations contains v if {
	some parcel in lib.nat_parcels
	lib.has_code(parcel, "NPF")
	lib.year > p.npf_code_until_year
	v := {"rule_id": "O618-KOMB-014", "parcel_id": parcel.parcel_id, "message": "Code NPF ist ab dem Antragsjahr 2025 nicht mehr zulässig"}
}

# O618-KOMB-015: K20-Flächen auf der Einzelfläche mit keinen anderen Maßnahmen kombinierbar.
k20_parcel(parcel) if {
	some c in lib.auflagen_of(parcel)
	lib.auflage_by_code[c].chapter == "K"
}

k20_parcel(parcel) if lib.has_code(parcel, "K20")

violations contains v if {
	some parcel in lib.nat_parcels
	k20_parcel(parcel)
	count(object.get(parcel, ["oepul", "other_area_measures"], [])) > 0
	v := {"rule_id": "O618-KOMB-015", "parcel_id": parcel.parcel_id, "message": "K20-Fläche auf der Einzelfläche mit keiner anderen Maßnahme kombinierbar"}
}

# O618-KOMB-016: Als DIV angerechnete NAT-Flächen erhalten die NAT-Prämie (keine UBB-Prämie) und zählen nicht für den >7 %-Zuschlag.
div_counted_receive_nat_premium_only := div_countable
