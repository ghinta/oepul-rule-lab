# Anrechnung von EBW-Flächen als Biodiversitätsflächen (DIV/DIVSZ) in UBB (1A) bzw. BIO (1B).
package oepul.o6_19

import rego.v1

habitat_groups := tables.creditable_habitats.groups

parcel_usage_type(p) := object.get(p, ["oepul", "usage_type"], "")

# R-O619-DIV-HABITAT-LIST / R-O619-DIV-USAGE-TYPE: Lebensraum laut Kapitel 7 und je Lebensraumgruppe zulässige Grünland-Schlagnutzungsart.
chapter7_group(p) := g if {
	some g in habitat_groups
	parcel_ebw(p).chapter7_habitat in g.habitats
}

grassland_bdf_habitat_ok(p) if chapter7_group(p)

grassland_bdf_usage_ok(p) if {
	some g in habitat_groups
	parcel_ebw(p).chapter7_habitat in g.habitats
	parcel_usage_type(p) in g.allowed_usage_types
}

# R-O619-DIV-CODING-GRASSLAND: Kennzeichnung mit EBW sowie zusätzlich DIV oder DIVSZ.
has_div_code(p) if has_code(p, "DIV")

has_div_code(p) if has_code(p, "DIVSZ")

# R-O619-DIV-GRASSLAND: Grünlandflächen bestimmter Lebensräume sind als Biodiversitätsflächen anrechenbar.
creditable_grassland_bdf[pid] if {
	some pid, p in ebw_parcels
	participates_ubb_or_bio
	p.land_use == "grassland"
	has_div_code(p)
	grassland_bdf_habitat_ok(p)
	grassland_bdf_usage_ok(p)
}

# R-O619-DIV-SETASIDE: Ackerstilllegungen mit Schlagnutzung Grünbrache sowie Codes EBW und DIV.
creditable_arable_bdf[pid] if {
	some pid, p in ebw_parcels
	participates_ubb_or_bio
	parcel_is_set_aside(p)
	parcel_usage_type(p) == params.set_aside_usage_type
	has_code(p, "DIV")
}

creditable_bdf_ids := {pid | creditable_grassland_bdf[pid]} | {pid | creditable_arable_bdf[pid]}

# Hinweise, warum eine als DIV/DIVSZ codierte EBW-Fläche nicht anrechenbar ist.
bdf_crediting_issues[pid] contains "no_ubb_or_bio_participation" if {
	some pid, p in ebw_parcels
	has_div_code(p)
	not participates_ubb_or_bio
}

bdf_crediting_issues[pid] contains "habitat_not_in_chapter7_list" if {
	some pid, p in ebw_parcels
	has_div_code(p)
	p.land_use == "grassland"
	not grassland_bdf_habitat_ok(p)
}

bdf_crediting_issues[pid] contains "usage_type_not_allowed_for_habitat" if {
	some pid, p in ebw_parcels
	has_div_code(p)
	p.land_use == "grassland"
	grassland_bdf_habitat_ok(p)
	not grassland_bdf_usage_ok(p)
}

bdf_crediting_issues[pid] contains "arable_only_set_aside_creditable" if {
	some pid, p in ebw_parcels
	has_div_code(p)
	p.land_use == "arable"
	not parcel_is_set_aside(p)
}

bdf_crediting_issues[pid] contains "set_aside_requires_gruenbrache_and_div" if {
	some pid, p in ebw_parcels
	has_div_code(p)
	parcel_is_set_aside(p)
	not creditable_arable_bdf[pid]
	participates_ubb_or_bio
}

# R-O619-DIV-MANAGE-PER-PB: angerechnete Flächen sind immer nach der Projektbestätigung zu bewirtschaften.
management_basis[pid] := "projektbestaetigung" if some pid in ebw_parcel_ids

# R-O619-DIV-WHOLE-FARM: ist die gesamte ÖPUL-Fläche in EBW einbringbar und nimmt der Betrieb freiwillig an UBB/BIO teil,
# gelten die Biodiversitätsflächenbedingungen und die 0,15-ha-Auflage auf Feldstücken > 5 ha auch für EBW-Feldstücke.
whole_farm_ebw_with_ubb_bio if {
	ebw.all_oepul_area_ebw_eligible == true
	participates_ubb_or_bio
}

field_piece_area(fp) := max([a |
	some p in parcels
	object.get(p, ["oepul", "field_piece_id"], null) == fp
	a := get_num(p, ["oepul", "field_piece_area_ha"])
])

ebw_field_pieces := {fp |
	some _, p in ebw_parcels
	fp := object.get(p, ["oepul", "field_piece_id"], null)
	is_string(fp)
}

# Biodiversitätsfläche am Feldstück: anrechenbare EBW-Schläge oder gesondert (ohne EBW) als DIV/DIVSZ codierte Schläge.
field_piece_bdf_area(fp) := sum([a |
	some p in parcels
	object.get(p, ["oepul", "field_piece_id"], null) == fp
	is_bdf_on_field_piece(p)
	a := num(p.area_ha)
])

is_bdf_on_field_piece(p) if {
	has_code(p, params.parcel_code)
	p.parcel_id in creditable_bdf_ids
}

is_bdf_on_field_piece(p) if {
	not has_code(p, params.parcel_code)
	has_div_code(p)
}

# R-O619-DIV-FIELD-PIECE-015: mindestens 0,15 ha Biodiversitätsfläche bei Feldstücken größer 5,00 ha.
field_piece_bdf_violations contains {"field_piece_id": fp, "field_piece_area_ha": area, "bdf_area_ha": bdf} if {
	whole_farm_ebw_with_ubb_bio
	some fp in ebw_field_pieces
	area := field_piece_area(fp)
	area > params.biodiversity_field_piece_threshold_ha
	bdf := field_piece_bdf_area(fp)
	bdf < params.biodiversity_field_piece_min_area_ha
}

# R-O619-NPF-GLOEZ8: bis 2024 für den GLÖZ-8-Mindestanteil (4 %) anrechenbare EBW-Stilllegungen mit Code NPF.
gloez8_creditable_set_aside[pid] if {
	some pid, p in ebw_parcels
	year <= params.npf_last_year
	parcel_is_set_aside(p)
	has_code(p, "NPF")
}
