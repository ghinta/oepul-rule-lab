# Förderbedingungen (Maßnahmenblatt Kap. 4, 5.1; SRL 2.4 Förderverpflichtungen).
# Die Auflagen gelten auf allen Maßnahmenflächen, auch in Jahren mit Codierung BM0.
package oepul.o6_4

# O6_4-MOW-001: zumindest jedes zweite Jahr vollflächige Mahd inkl. Verbringung des Mähgutes.
violation contains {"rule_id": "O6_4-MOW-001", "parcel_id": pid, "message": "keine vollflächige Mahd mit Verbringung im laufenden Jahr und keine Mahd im Vorjahr"} if {
	some pid, p in enrolled_parcels
	not valid_full_mowing_this_year(p)
	not mowed_previous_year(p)
}

# O6_4-MOW-002: maximal eine Mahd pro Jahr.
violation contains {"rule_id": "O6_4-MOW-002", "parcel_id": pid, "message": sprintf("%d Mahden im Jahr – maximal eine Mahd zulässig", [mowing_count(p)])} if {
	some pid, p in enrolled_parcels
	mowing_count(p) > 1
}

# O6_4-MOW-003: Mähen und Liegenlassen des Erntegutes oder Häckseln ist nicht zulässig.
violation contains {"rule_id": "O6_4-MOW-003", "parcel_id": pid, "message": "Fläche gehäckselt – nicht zulässig"} if {
	some pid, p in enrolled_parcels
	mowing_info(p).mulched == true
}

violation contains {"rule_id": "O6_4-MOW-003", "parcel_id": pid, "message": "Mähgut nicht von der Fläche verbracht – nicht zulässig"} if {
	some pid, p in enrolled_parcels
	mowed_this_year(p)
	mown_material_not_removed(p)
}

mown_material_not_removed(p) if mowing_info(p).mown_material_left_lying == true

mown_material_not_removed(p) if mowing_info(p).mown_material_removed == false

# O6_4-GRAZE-001: grundsätzlich keine Beweidung; Nachweide ab 16. August jährlich zulässig.
violation contains {"rule_id": "O6_4-GRAZE-001", "parcel_id": pid, "message": sprintf("Beweidung am %s vor dem 16. August", [d])} if {
	some pid, p in enrolled_parcels
	some d in object.get(p, ["operations", "grazing_dates"], [])
	date_parts(d)[0] == year
	before_month_day(d, 8, 16)
}

# O6_4-FERT-001/-002/-003: Verzicht auf Düngemittel, Klärschlamm und kompostierten Klärschlamm;
# ausgenommen Festmist in ursprünglicher Form und eigene häusliche Abwässer.
allowed_fertilizer_types := {f.type | some f in data.o6_4.input_substances.fertilizer_types; f.allowed}

violation contains {"rule_id": "O6_4-FERT-001", "parcel_id": pid, "message": sprintf("unzulässige Ausbringung: %s", [t])} if {
	some pid, p in enrolled_parcels
	some t in object.get(p, ["operations", "fertilizer", "applied_types"], [])
	not t in allowed_fertilizer_types
}

violation contains {"rule_id": "O6_4-FERT-001", "parcel_id": pid, "message": "mineralische Stickstoffdüngung angegeben"} if {
	some pid, p in enrolled_parcels
	object.get(p, ["operations", "fertilizer", "mineral_n_kg_per_ha"], 0) > 0
}

# O6_4-PSM-001: keine Pflanzenschutzmittel außer solchen mit ausschließlich gemäß VO (EU) 2018/848 zulässigen Wirkstoffen.
violation contains {"rule_id": "O6_4-PSM-001", "parcel_id": pid, "message": "Pflanzenschutzmittel ohne ausschließlich bio-zulässige Wirkstoffe eingesetzt"} if {
	some pid, p in enrolled_parcels
	object.get(p, ["operations", "psm_used"], false) == true
	not object.get(p, ["operations", "psm_only_bio_approved_substances"], false) == true
}

# O6_4-CODE-002/-004: Codierung BM1/BM2/BM3 im Jahr der Mahd je nach Mähverfahren, BM0 ohne Mahd.
violation contains {"rule_id": "O6_4-CODE-002", "parcel_id": pid, "message": "kein eindeutiger Code BM0/BM1/BM2/BM3 angegeben"} if {
	some pid, p in enrolled_parcels
	count(parcel_bm_codes(p)) != 1
}

violation contains {"rule_id": "O6_4-CODE-004", "parcel_id": pid, "message": "Mahd durchgeführt, aber mit BM0 codiert"} if {
	some pid, p in enrolled_parcels
	parcel_bm_code(p) == "BM0"
	mowed_this_year(p)
}

violation contains {"rule_id": "O6_4-CODE-004", "parcel_id": pid, "message": sprintf("Code %s angegeben, aber keine Mahd im Jahr", [parcel_bm_code(p)])} if {
	some pid, p in enrolled_parcels
	parcel_bm_code(p) in mowing_year_codes
	not mowed_this_year(p)
}

# O6_4-CODE-003: Code richtet sich nach dem (überwiegenden) Mähverfahren; Ausmähen mit der Sense ändert ihn nicht.
violation contains {"rule_id": "O6_4-CODE-003", "parcel_id": pid, "message": sprintf("Code %s passt nicht zum Mähverfahren %s", [code, method])} if {
	some pid, p in enrolled_parcels
	code := parcel_bm_code(p)
	code in mowing_year_codes
	method := mowing_info(p).method
	method != code_method(code)
}

# Codierung, die dem tatsächlichen Mähverfahren entspricht.
expected_code_for_method(method) := c.code if {
	some c in data.o6_4.mowing_codes.codes
	c.mowing_method == method
}
