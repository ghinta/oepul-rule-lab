# Maßnahme 12 – Maßnahmenkombinationen: betrieblicher Ausschluss mit „Biologische
# Wirtschaftsweise“ und Einzelflächenkombination gemäß Anhang L.
package oepul.o6_12

organic_partial_farm := object.get(oepul, ["organic_partial_farm"], {})

# Bio-Teilbetrieb mit Kulturbereich Acker und Grünland (MB 5).
organic_partial_farm_arable_grassland if {
	organic_partial_farm.is_partial_farm == true
	organic_partial_farm.organic_culture_area == "arable_grassland"
}

organic_combination_conflict if {
	participates
	"1B" in participating_codes
	not organic_partial_farm_arable_grassland
}

default organic_combination_conflict := false

# --- Anhang L: Einzelflächenkombination ---
anhang_l_cell(a, b) := cell if {
	some cell in data.o6_12.oepul_anhang_l_cells
	cell.row == a
	cell.column == b
}

anhang_l_cell(a, b) := cell if {
	some cell in data.o6_12.oepul_anhang_l_cells
	cell.row == b
	cell.column == a
	not anhang_l_direct(a, b)
}

anhang_l_direct(a, b) if {
	some cell in data.o6_12.oepul_anhang_l_cells
	cell.row == a
	cell.column == b
}

footnote_effect(n) := row.effect if {
	some row in data.o6_12.oepul_anhang_l_footnotes
	row.footnote == n
}

combination_status(other) := "combinable" if {
	cell := anhang_l_cell(measure.code, other)
	cell.marker == "x"
	cell.footnote == null
}

combination_status(other) := "combinable_with_premium_reduction" if {
	cell := anhang_l_cell(measure.code, other)
	cell.marker == "a"
}

combination_status(other) := footnote_effect(cell.footnote) if {
	cell := anhang_l_cell(measure.code, other)
	cell.marker == "x"
	cell.footnote != null
}

combination_status(other) := "not_combinable" if {
	anhang_l_known_measure(other)
	not anhang_l_cell(measure.code, other)
}

combination_status(other) := "unknown_measure_code" if not anhang_l_known_measure(other)

anhang_l_known_measure(code) if {
	some row in data.o6_12.oepul_anhang_l_measures
	row.code == code
}

anhang_l_marker_meaning(marker) := row.meaning if {
	some row in data.o6_12.oepul_anhang_l_markers
	row.marker == marker
}

parcel_combinations := {pid: statuses |
	some p in parcels
	is_woh_parcel(p)
	pid := p.parcel_id
	statuses := {other: combination_status(other) |
		some other in parcel_measure_codes(p)
		other != measure.code
	}
}

parcel_combination_not_permitted contains [pid, other] if {
	some pid, statuses in parcel_combinations
	some other, status in statuses
	status == "not_combinable"
}

# Zuschlag „Einsatz von Organismen oder Pheromonen“ (10) wird bei Teilnahme an 12 um 50 % reduziert.
measure_10_organism_supplement_reduction_percent := data.o6_12.oepul_measure_10_organism_supplement_reduction.reduction_percent if {
	participates
	"10" in participating_codes
}
