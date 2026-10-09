package oepul.o6_1c

# Förderverpflichtungen der Kategorie "Nichtproduktive Ackerflächen" (NPA).

npa_params := params.npa

npa_parcels contains p if {
	some p in parcels
	object.get(p, ["o6_1c", "category"], null) == "npa"
}

npa(p) := object.get(p, ["o6_1c", "npa"], {})

npa_establishment_types := {"new_sowing", "self_greening", "retained_existing"}

# O6_1C-NPA-001: Neuansaat (Selbstbegrünung zulässig) oder Belassen bestehender
# Grünbrachen bzw. dauerhaft begrünter Ackerflächen.
npa_violations contains violation("O6_1C-NPA-001", p, "Neuansaat/Selbstbegrünung oder Belassen einer bestehenden Grünbrache bzw. dauerhaft begrünten Ackerfläche erforderlich") if {
	some p in npa_parcels
	not npa(p).establishment in npa_establishment_types
}

# O6_1C-NPA-002: Neuansaat bis spätestens 15. Mai des Antragsjahres.
npa_violations contains violation("O6_1C-NPA-002", p, "Neuansaat muss bis spätestens 15. Mai des Antragsjahres erfolgen") if {
	some p in npa_parcels
	npa(p).establishment == "new_sowing"
	npa(p).sowing_date > date_of(year, npa_params.latest_new_sowing_mmdd)
}

# O6_1C-NPA-003 / O6_1C-NPA-004: Umbruch frühestens 15.09.; bei Anbau einer
# Winterung oder Zwischenfrucht bereits ab 01.08.
earliest_breaking_date(p) := date_of(year, npa_params.earliest_breaking_with_follow_crop_mmdd) if {
	object.get(npa(p), "follow_crop", "none") in {c | some c in npa_params.follow_crops_allowing_early_breaking}
}

earliest_breaking_date(p) := date_of(year, npa_params.earliest_breaking_mmdd) if {
	not object.get(npa(p), "follow_crop", "none") in {c | some c in npa_params.follow_crops_allowing_early_breaking}
}

npa_violations contains violation("O6_1C-NPA-003", p, sprintf("Umbruch erst ab %s zulässig", [earliest_breaking_date(p)])) if {
	some p in npa_parcels
	bd := object.get(npa(p), "breaking_date", null)
	bd != null
	bd < earliest_breaking_date(p)
}

# O6_1C-NPA-005: Kein Pflanzenschutzmittel (außer Bio-Wirkstoffe) und keine
# Düngung ab 01.01. des ersten Antragsjahres bis zum Umbruch.
npa_psm_violation(p) if {
	object.get(p, ["operations", "psm_used"], false) == true
	not npa(p).psm_only_bio_permitted_substances == true
}

npa_fertilized(p) if npa(p).fertilizer_applied == true

npa_fertilized(p) if object.get(p, ["operations", "fertilizer", "mineral_n_kg_per_ha"], 0) > 0

npa_fertilized(p) if object.get(p, ["operations", "fertilizer", "organic_n_kg_per_ha"], 0) > 0

npa_violations contains violation("O6_1C-NPA-005", p, "Einsatz von Pflanzenschutzmitteln (ausgenommen gemäß VO (EU) 2018/848 zulässige Wirkstoffe) verboten") if {
	some p in npa_parcels
	npa_psm_violation(p)
}

npa_violations contains violation("O6_1C-NPA-005", p, "Jegliche Düngung ist bis zum Umbruch bzw. zur anderweitigen Deklaration verboten") if {
	some p in npa_parcels
	npa_fertilized(p)
}

# O6_1C-NPA-006: Beseitigung nur mechanisch (Häckseln oder Einarbeiten).
npa_violations contains violation("O6_1C-NPA-006", p, "Beseitigung nur mit mechanischen Methoden (Häckseln oder Einarbeiten) zulässig") if {
	some p in npa_parcels
	method := object.get(npa(p), "removal_method", "none")
	not method in {m | some m in npa_params.allowed_removal_methods}
}

# O6_1C-NPA-011 / O6_1C-NPA-012: Reinigungsschnitt nur im ersten Antragsjahr
# auf Flächen mit Neuansaat (oder Umbruch und Neueinsaat bestehender Grünbrachen).
cleaning_cut_permitted(p) if {
	object.get(npa(p), "first_application_year", null) == year
	npa(p).establishment in {"new_sowing", "self_greening"}
}

cleaning_cut_permitted(p) if {
	object.get(npa(p), "first_application_year", null) == year
	npa(p).existing_green_fallow_broken_and_resown == true
}

cut_events(p) := object.get(npa(p), "cutting_events", [])

# Schnitte, die zur Höchstanzahl und 50-%-Grenze zählen.
regular_cuts(p) := [e |
	some e in cut_events(p)
	counts_as_regular_cut(p, e)
]

counts_as_regular_cut(_, e) if e.type in {"care_mowing", "mulching"}

counts_as_regular_cut(p, e) if {
	e.type == "cleaning_cut"
	not cleaning_cut_permitted(p)
}

npa_violations contains violation("O6_1C-NPA-012", p, "Reinigungsschnitt nur im ersten Antragsjahr auf Flächen mit Neuansaat zulässig, nicht auf bestehenden Grünbrachen") if {
	some p in npa_parcels
	some e in cut_events(p)
	e.type == "cleaning_cut"
	not cleaning_cut_permitted(p)
}

# O6_1C-NPA-007: Pflegemahd oder Häckseln mindestens 1 x jedes zweite Jahr.
npa_violations contains violation("O6_1C-NPA-007", p, "Pflegemahd oder Häckseln mindestens einmal jedes zweite Jahr erforderlich") if {
	some p in npa_parcels
	count(regular_cuts(p)) == 0
	npa(p).cut_in_previous_year == false
	object.get(application, "commitment_year_completed", false) == true
}

# O6_1C-NPA-008: Mähen/Häckseln maximal 2 x pro Jahr.
npa_violations contains violation("O6_1C-NPA-008", p, "Mähen/Häckseln maximal zweimal pro Jahr erlaubt") if {
	some p in npa_parcels
	count(regular_cuts(p)) > npa_params.max_cuts_per_year
}

# O6_1C-NPA-009: Mähgut nicht verbringen/nutzen; keine Beweidung.
npa_violations contains violation("O6_1C-NPA-009", p, "Mähgut darf nicht von der Fläche verbracht und genutzt werden") if {
	some p in npa_parcels
	some e in cut_events(p)
	e.biomass_removed == true
}

npa_violations contains violation("O6_1C-NPA-009", p, "Beweidung nichtproduktiver Ackerflächen ist nicht erlaubt") if {
	some p in npa_parcels
	npa(p).grazed == true
}

# O6_1C-NPA-010: Auf 50 % der NPA-Fläche je Kalenderjahr Mähen/Häckseln
# frühestens am 1. August (Reinigungsschnitt zählt nicht).
restricted_cut_date := date_of(year, npa_params.earliest_restricted_cut_mmdd)

early_cut_parcels contains p if {
	some p in npa_parcels
	some e in regular_cuts(p)
	e.date < restricted_cut_date
}

npa_total_area_ha := sum_area(npa_parcels)

npa_early_cut_area_ha := sum_area(early_cut_parcels)

farm_npa_violations contains farm_violation("O6_1C-NPA-010", "Mähen/Häckseln vor dem 1. August auf mehr als 50 % der nichtproduktiven Ackerflächen") if {
	npa_early_cut_area_ha > npa_params.restricted_cut_share * npa_total_area_ha
}

# O6_1C-NPA-013: Nach Umbruch Nutzungsverbot bis einschließlich 31.12.
npa_violations contains violation("O6_1C-NPA-013", p, "Nach Umbruch gilt bis einschließlich 31. Dezember ein Nutzungsverbot") if {
	some p in npa_parcels
	object.get(npa(p), "breaking_date", null) != null
	npa(p).used_after_breaking == true
}

# O6_1C-NPA-015: NPA prämienmäßig mit keiner anderen Maßnahme auf der
# Einzelfläche kombinierbar (Anhang L, Zeile/Spalte 1C leer).
annex_l_cell(row, col) := cell if {
	some cell in data.o6_1c.annex_l_combination.cells
	cell.row == row
	cell.col == col
}

combinable_on_single_area(row, col) if annex_l_cell(row, col).combinable == true

measure_code(m) := upper(trim_prefix(m, "o6_"))

npa_violations contains violation("O6_1C-NPA-015", p, sprintf("Nichtproduktive Ackerfläche ist prämienmäßig nicht mit %s auf der Einzelfläche kombinierbar", [m])) if {
	some p in npa_parcels
	some m in object.get(p, "other_oepul_measures", [])
	not combinable_on_single_area("1C", measure_code(m))
}

npa_violations contains violation("O6_1C-NPA-015", p, "Nichtproduktive Ackerflächen können nicht auf andere Verpflichtungen der SRL ÖPUL 2023 angerechnet werden") if {
	some p in npa_parcels
	count(object.get(npa(p), "credited_to_other_obligations", [])) > 0
}

# O6_1C-APP-003: NPA in der Feldstücksliste als "Grünbrache" mit Code NPA.
npa_violations contains violation("O6_1C-APP-003", p, "Nichtproduktive Ackerflächen sind mit Schlagnutzungsart Grünbrache und Code NPA zu beantragen") if {
	some p in npa_parcels
	object.get(p, "field_use_type", null) != params.application.npa_field_use_type
}

npa_violations contains violation("O6_1C-APP-003", p, "Nichtproduktive Ackerflächen sind mit Schlagnutzungsart Grünbrache und Code NPA zu beantragen") if {
	some p in npa_parcels
	not params.application.npa_code in parcel_codes(p)
}

# O6_1C-NPA-016: GLÖZ-4-Pufferstreifen auf dem betroffenen Flächenteil nicht förderbar.
npa_gloez4_area_ha(p) := min_of(object.get(npa(p), "gloez4_buffer_area_ha", 0), object.get(p, "area_ha", 0))

# O6_1C-NPA-017: NPA von der Grünlandwerdung ausgenommen.
excluded_from_grassland_conversion contains parcel_id(p) if {
	some p in npa_parcels
}

# O6_1C-COMB-001: Auswertung einer Zelle aus Anhang L inkl. Legende (x/a) und
# Fußnoten 1) bis 4) als Einschränkung der Kombinierbarkeit.
annex_l_footnote_text(id) := fn.text if {
	some fn in data.o6_1c.annex_l_combination.footnotes
	fn.id == id
}

combination_assessment(row, col) := {
	"combinable": cell.combinable,
	"premium_deduction": cell.premium_deduction,
	"restriction": annex_l_footnote_text(cell.footnote),
} if {
	cell := annex_l_cell(row, col)
	cell.footnote != null
}

combination_assessment(row, col) := {
	"combinable": cell.combinable,
	"premium_deduction": cell.premium_deduction,
	"restriction": null,
} if {
	cell := annex_l_cell(row, col)
	cell.footnote == null
}
