# o6_10 – Maßnahmenkombination (Anhang L), Einstufung als einjährige Maßnahme, Hinweise
package oepul.o6_10

annex_l := data.o6_10.annex_l_combination_table

annex_l_cell(row, col) := c if {
	some c in annex_l.cells
	c.row_measure == row
	c.column_measure == col
}

# O610-COMB-ANNEX-L: auf der Einzelfläche mit Maßnahme 10 kombinierbare Maßnahmen
combinable_with_10 := {c.column_measure | some c in annex_l.cells; c.row_measure == params.measure_code}

combination_conflicts contains {
	"parcel_id": p.parcel_id,
	"measure": m,
	"rule_id": "O610-COMB-ANNEX-L",
	"reason": sprintf("Maßnahme %s ist gemäß Anhang L auf der Einzelfläche nicht mit Maßnahme 10 kombinierbar", [m]),
} if {
	some p in vfh_parcels
	some m in parcel_measures(p)
	m != params.measure_code
	not m in combinable_with_10
}

combination_notes contains {
	"parcel_id": p.parcel_id,
	"measure": m,
	"rule_id": "O610-COMB-ANNEX-L",
	"footnotes": [annex_l.footnotes[f] | some f in annex_l_cell(params.measure_code, m).footnotes],
} if {
	some p in vfh_parcels
	some m in parcel_measures(p)
	m in combinable_with_10
	count(annex_l_cell(params.measure_code, m).footnotes) > 0
}

# O610-GEN-ONE-YEAR-CLASS: Maßnahme 10 ist einjährig
measure_is_one_year if {
	some m in data.o6_10.measure_catalog.one_year_measures
	m.code == params.measure_code
}

area_access_restricted if params.measure_code in data.o6_10.measure_catalog.area_access_restricted_measures

# O610-GEN-ONE-YEAR-OPTIONS-2028: Zuschläge bei einjährigen Maßnahmen bis inkl. Förderjahr 2028
supplement_application_possible if {
	measure_is_one_year
	year <= params.supplement_last_funding_year
}

# O610-GEN-CONDITIONALITY: Hinweis auf Kürzung nach Art. 83–89 VO (EU) 2021/2116
notices contains {
	"rule_id": "O610-GEN-CONDITIONALITY",
	"notice": "Konditionalitätsverstoß gemeldet: Kürzung gemäß Art. 83 bis 86 bzw. 87 bis 89 VO (EU) 2021/2116 zusätzlich zur Maßnahmenprämie",
} if {
	object.get(input, ["farm", "oepul", "conditionality_breach"], false) == true
}

notices contains {
	"rule_id": "O610-GEN-COMBINATION-CORRECTION",
	"notice": "Unmögliche Maßnahmenkombination: Korrektur bis zum Erhalt der Auszahlungsmitteilung zulässig, sofern keine Beanstandung bei einer Vor-Ort-Kontrolle vorliegt",
} if {
	count(combination_conflicts) > 0
}

notices contains {
	"rule_id": "O610-2026-DROUGHT-GREENING",
	"notice": "Dürre 2026: fehlende Flächendeckung bzw. Ausfallgetreide über 50 % trotz ordnungsgemäßer Anlage wird automatisch als höhere Gewalt anerkannt (keine Meldung erforderlich)",
} if {
	count(drought_2026_relief_parcels) > 0
}

notices contains {
	"rule_id": "O610-2026-EXIT12-EOP",
	"notice": "Rückzahlungsfreier Ausstieg aus Maßnahme 12 im Jahr 2026: Maßnahme 12 nicht mehr in participating_measures führen, sofern Ausstieg genehmigt (Annahme A-12)",
} if {
	year == 2026
	object.get(input, ["farm", "oepul", "exited_measure_12_rebzikade_2026"], false) == true
	"12" in participating_measures
}

notices contains {
	"rule_id": "O610-GEN-MIN-PAYOUT",
	"notice": "Auszahlungsbetrag übersteigt 50 Euro nicht: von der Gewährung kann abgesehen werden",
} if {
	below_minimum_payout
}

notices contains {
	"rule_id": "O610-GEN-CONTROL-REFUSAL",
	"notice": "Kontrolle verweigert bzw. verhindert: Antrag abzulehnen, keine Prämie für das laufende Jahr",
} if {
	control_refused
}

notices contains {
	"rule_id": "O610-GEN-PREAPPLICATION",
	"notice": "Kein Mehrfachantrag mit förderrelevanten Flächen abgegeben: keine Zahlung im Antragsjahr",
} if {
	payment_application_missing
}
