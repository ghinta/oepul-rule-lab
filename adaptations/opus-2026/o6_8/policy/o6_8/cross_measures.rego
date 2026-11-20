# o6_8 - Wechselwirkungen mit anderen ÖPUL-Maßnahmen
# Anhang L (Kombinationstabelle), Anrechnung von BAW in UBB/BIO und
# Basismodulprämie UBB/BIO auf steilen Schlägen ohne erosionsmindernde Verfahren.
package oepul.o6_8

combination_table := data.o6_8.anhang_l_combination_table

# Prämienmäßige Kombinierbarkeit zweier Maßnahmen auf der Einzelfläche (Anhang L).
combination_cell(a, b) := c if {
	some c in combination_table.cells
	c.row == a
	c.col == b
}

combinable_on_parcel(a, b) if combination_cell(a, b)

combination_with_discount(a, b) if combination_cell(a, b).mark == "a"

combinable_only_for_landscape_elements(a, b) if combination_cell(a, b).footnote == "1"

parcel_violations contains violation("o6_8.combination.anhang_l", p, null, sprintf("Maßnahme %v ist laut Anhang L nicht auf der Einzelfläche mit Erosionsschutz Acker (8) kombinierbar.", [m])) if {
	some p in parcels
	count(codes(p)) > 0
	not has_code(p, "BAW")
	some m in other_measures_on_parcel(p)
	not endswith(m, "_LSE")
	not combinable_on_parcel("8", m)
}

# SRL 2.1.A / 2.1.B: Schläge > 0,5 ha mit überwiegender Hangneigung >= 10 % und
# erosionsgefährdeter Kultur ohne erosionsminderndes Verfahren der Maßnahme 8.
steep_erosion_prone_without_procedure(p) if {
	parcel_area(p) > 0.5
	p.slope_percent >= 10
	p.land_use == "arable"
	erosion_prone_crop(p)
	count(codes(p) & all_codes) == 0
}

ubb_arable_basic_premium_effect(p) := "no_basic_premium" if {
	"1A" in participating_measures
	steep_erosion_prone_without_procedure(p)
}

bio_arable_basic_premium_effect(p) := "no_basic_premium" if {
	"1B" in participating_measures
	steep_erosion_prone_without_procedure(p)
	year <= 2024
} else := "basic_premium_reduced_50_percent" if {
	"1B" in participating_measures
	steep_erosion_prone_without_procedure(p)
	year >= 2025
}
