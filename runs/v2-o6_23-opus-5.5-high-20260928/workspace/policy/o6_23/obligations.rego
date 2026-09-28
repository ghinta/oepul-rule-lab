# Förderverpflichtungen (Bewirtschaftungsauflagen gemäß Projektbestätigung),
# Mindestbewirtschaftung und Kombinationsregeln (o6_23).
package oepul.o6_23

# ---------------------------------------------------------------------------
# GI05/GI06/GI07: Düngeverbot
# ---------------------------------------------------------------------------

parcel_fertilized(p) if object.get(n2(p), "fertilization_applied", false) == true

parcel_fertilized(p) if object.get(p, ["operations", "fertilizer", "mineral_n_kg_per_ha"], 0) > 0

parcel_fertilized(p) if object.get(p, ["operations", "fertilizer", "organic_n_kg_per_ha"], 0) > 0

parcel_has_fertilization_ban(p) if {
	some c in parcel_codes(p)
	rate_row(c).fertilization_banned
}

# ---------------------------------------------------------------------------
# GL02–GL05, GL36, GL37: Schnittzeitpunktverzögerung, früheste Mahd laut Projektbestätigung
# ---------------------------------------------------------------------------

parcel_has_cut_delay(p) if {
	some c in parcel_codes(p)
	c in gl_codes
}

# Dürre 2026: Wird der Schnittzeitpunkt per Landesverordnung verändert, kann die
# Nutzung gemäß den dort festgelegten Terminen erfolgen; Projektbestätigung bleibt
# unverändert, Prämie wird gewährt.
effective_earliest_cut_date(p) := d if {
	year == params.drought_2026.year
	d := object.get(n2(p), "earliest_cut_date_state_ordinance_2026", null)
	is_string(d)
} else := object.get(n2(p), "earliest_cut_date", null)

drought_2026_cut_date_release_used(p) if {
	year == params.drought_2026.year
	is_string(object.get(n2(p), "earliest_cut_date_state_ordinance_2026", null))
}

parcel_cutting_dates(p) := object.get(p, ["operations", "cutting_dates"], [])

cut_before_earliest_date(p) if {
	parcel_has_cut_delay(p)
	d := effective_earliest_cut_date(p)
	is_string(d)
	some c in parcel_cutting_dates(p)
	date_ns(c) < date_ns(d)
}

# ---------------------------------------------------------------------------
# Verstöße gegen Förderverpflichtungen je Schlag
# ---------------------------------------------------------------------------

parcel_obligation_violations(p) := {v | some v in obligation_checks; obligation_violated(p, v)}

obligation_checks := [
	"fertilization_despite_ban",
	"cut_before_earliest_cut_date",
	"earliest_cut_date_missing",
	"project_confirmation_requirements_not_met",
	"minimum_grassland_management_not_met",
]

obligation_violated(p, "fertilization_despite_ban") if {
	parcel_has_fertilization_ban(p)
	parcel_fertilized(p)
}

obligation_violated(p, "cut_before_earliest_cut_date") if cut_before_earliest_date(p)

obligation_violated(p, "earliest_cut_date_missing") if {
	parcel_has_cut_delay(p)
	not is_string(effective_earliest_cut_date(p))
}

# Einhaltung aller verpflichtenden Bewirtschaftungsauflagen gemäß Projektbestätigung.
obligation_violated(p, "project_confirmation_requirements_not_met") if {
	object.get(n2(p), "project_confirmation_complied", true) == false
}

# Mindestbewirtschaftung Grünland: jährlich mindestens einmal vollflächige Mahd
# und Verbringen des Mähgutes oder jährliche vollflächige Beweidung.
obligation_violated(p, "minimum_grassland_management_not_met") if {
	not grassland_minimum_management_met(p)
}

grassland_minimum_management_met(p) if {
	count(parcel_cutting_dates(p)) > 0
	object.get(p, ["operations", "mowing_material_removed"], false) == true
}

grassland_minimum_management_met(p) if object.get(p, ["operations", "full_area_grazed"], false) == true

# Hinweis (keine Sanktion abgeleitet): Nutzungshäufigkeit weicht von der
# Nutzungskategorie der GI-Auflage ab.
use_frequency_mismatch(p) if {
	some c in parcel_codes(p)
	row := rate_row(c)
	row.group == "GI"
	uses := count(parcel_cutting_dates(p)) + object.get(p, ["operations", "grazing_uses"], 0)
	not use_frequency_matches(row, uses)
}

use_frequency_matches(row, uses) if {
	row.use_frequency_or_more
	uses >= row.use_frequency
}

use_frequency_matches(row, uses) if {
	not row.use_frequency_or_more
	uses == row.use_frequency
}

# ---------------------------------------------------------------------------
# Kombinationen (Anhang J, Anhang L, Maßnahmenblatt Kapitel 7)
# ---------------------------------------------------------------------------

combinable_measures := {m.measure | some m in combinations.o6_23_parcel_combinable_measures}

annex_l_row(measure) := r if {
	some r in combinations.annex_l_combination_table.rows
	r.measure == measure
}

annex_l_combinable(other) if annex_l_row(measure_code).cells[other].symbol != ""

normalized_measure(m) := "1B" if m == "1B_TB"

normalized_measure(m) := m if m != "1B_TB"

# Andere ÖPUL-Maßnahmen mit Prämie auf demselben Schlag, die nicht kombinierbar sind.
parcel_combination_conflicts(p) := {m |
	some m in object.get(parcel_oepul(p), "measures", [])
	m != measure_code
	not m in combinable_measures
	not annex_l_combinable(normalized_measure(m))
}

annex_j_chapter(code) := combinations.annex_j_chapter_combination.chapter_aliases[substring(code, 0, 1)]

annex_j_chapter(code) := substring(code, 0, 1) if {
	not combinations.annex_j_chapter_combination.chapter_aliases[substring(code, 0, 1)]
}

annex_j_combinable(c1, c2) if {
	some row in combinations.annex_j_chapter_combination.matrix
	row.row == c1
	row.cells[c2] == true
}

# N2-Auflagen gehören zum Kapitel G (Mähwiesen und -weiden).
n2_chapter := combinations.annex_j_chapter_combination.n2_codes_chapter

# Naturschutz-Auflagen (Maßnahme 18) auf demselben Schlag aus Kapiteln, die mit
# Kapitel G nicht kombinierbar sind.
parcel_annex_j_conflicts(p) := {c |
	some c in object.get(parcel_oepul(p), "naturschutz_codes", [])
	ch := annex_j_chapter(c)
	ch != n2_chapter
	not annex_j_combinable(n2_chapter, ch)
}

# ---------------------------------------------------------------------------
# Anrechnung auf 7 %-Biodiversitätsflächen (UBB/BIO)
# ---------------------------------------------------------------------------

parcel_creditable_as_biodiversity(p) if {
	some c in parcel_codes(p)
	rate_row(c).creditable_as_biodiversity_area
}

biodiversity_creditable_parcels contains p.parcel_id if {
	some p in eligible_parcels
	parcel_creditable_as_biodiversity(p)
	object.get(n2(p), "divsz_code_marked", false) == true
}

biodiversity_creditable_area_ha := sum([p.area_ha |
	some p in eligible_parcels
	p.parcel_id in biodiversity_creditable_parcels
])

# Schnittzeitpunktauflage vorhanden, aber Code DIVSZ fehlt (keine Anrechnung).
biodiversity_divsz_missing contains p.parcel_id if {
	some p in eligible_parcels
	parcel_creditable_as_biodiversity(p)
	object.get(n2(p), "divsz_code_marked", false) != true
}

# DIVSZ-Code auf N2-Fläche ohne Schnittzeitpunktauflage (nicht anrechenbar).
biodiversity_divsz_without_cut_delay contains p.parcel_id if {
	some p in n2_parcels
	object.get(n2(p), "divsz_code_marked", false) == true
	not parcel_creditable_as_biodiversity(p)
}
