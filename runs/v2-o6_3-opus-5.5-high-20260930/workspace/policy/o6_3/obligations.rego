# Förderverpflichtungen der Heuwirtschaft (Merkblatt Kap. 5, SRL 2.3.4) und Mindestbewirtschaftung.
package o6_3

feeding := object.get(input, ["farm", "feeding"], {})

machinery := object.get(input, ["farm", "machinery"], {})

forage_transfers := object.get(input, ["farm", "forage_transfers"], [])

flag(obj, key) if object.get(obj, key, false) == true

not_permitted_feed_ids := {f.id | some f in data.o6_3.feed_rules.not_permitted_feed_examples}

# O6_3-OBL-01: Verzicht auf Silagebereitung und Silagefütterung am gesamten Betrieb.
violations contains {"rule_id": "O6_3-OBL-01", "detail": "Silagebereitung am Betrieb"} if flag(feeding, "silage_produced")

violations contains {"rule_id": "O6_3-OBL-01", "detail": "Silagefütterung am Betrieb"} if flag(feeding, "silage_fed")

# O6_3-OBL-02: Pressen von nicht ohne Folie lagerfähigem Mähgut ist unzulässig.
violations contains {"rule_id": "O6_3-OBL-02", "detail": "Pressen von nicht ohne Folie lagerfähigem Mähgut"} if {
	flag(feeding, "non_storable_without_foil_pressed")
}

# O6_3-OBL-03: Grünmais/Grünfutter-Trocknung erlaubt, Gärungsprozess muss ausgeschlossen sein.
violations contains {"rule_id": "O6_3-OBL-03", "detail": "Gärungsprozess bei Grünfutter nicht ausgeschlossen"} if {
	flag(feeding, "green_forage_fermentation_occurred")
}

# O6_3-OBL-04: Futtermittel, bei deren Produktion eine Gärung (Silierung) stattfindet, sind nicht zugelassen.
violations contains {"rule_id": "O6_3-OBL-04", "detail": sprintf("Futtermittel mit Gärung: %v", [f.name])} if {
	some f in object.get(feeding, "feedstuffs", [])
	fermented_feed(f)
}

fermented_feed(f) if object.get(f, "fermentation_in_production", false) == true

fermented_feed(f) if object.get(f, "feed_id", "") in not_permitted_feed_ids

# O6_3-OBL-05: Heugewinnung kombiniert mit Grünfütterung im überwiegenden Teil der Vegetationsperiode.
green_feeding := object.get(feeding, "green_feeding", {})

green_feeding_days := object.get(green_feeding, "eingrasen_or_pasture_days_apr_sep", 0) + object.get(green_feeding, "communal_pasture_or_alm_days_apr_sep", 0)

green_feeding_majority_met if {
	green_feeding_days > params.vegetation_period.days * params.green_feeding_majority_share
	object.get(green_feeding, "all_roughage_animals_included", false) == true
}

violations contains {"rule_id": "O6_3-OBL-05", "detail": "Grünfütterung nicht im überwiegenden Teil der Vegetationsperiode für alle Raufutterverzehrer"} if {
	total_rgve > 0
	not green_feeding_majority_met
}

# O6_3-OBL-06: generelles Lagerungsverbot, auch keine Aufbrauchfrist für Silagevorräte.
violations contains {"rule_id": "O6_3-OBL-06", "detail": "Lagerung von Silage am Betrieb"} if flag(feeding, "silage_stored")

violations contains {"rule_id": "O6_3-OBL-06", "detail": "Aufbrauchen betriebseigener Silagevorräte nach Vertragsbeginn"} if {
	flag(feeding, "own_silage_stock_used_after_contract_start")
}

# O6_3-OBL-07: Abgabe von Mähgut an Dritte nur als trockenes Heu.
violations contains {"rule_id": "O6_3-OBL-07", "detail": sprintf("Mähgutabgabe in Form %v", [t.form])} if {
	some t in forage_transfers
	t.form != "dry_hay"
}

# O6_3-OBL-08: einmaliges Kreiseln mit anschließendem Wegfahren unzulässig.
violations contains {"rule_id": "O6_3-OBL-08", "detail": "einmaliges Kreiseln mit anschließendem Wegfahren"} if {
	some t in forage_transfers
	flag(t, "one_time_tedding_then_removed")
}

# O6_3-OBL-09: keine Maßnahmen, die auf Silageverwendung schließen lassen (auch außerhalb des Betriebes).
violations contains {"rule_id": "O6_3-OBL-09", "detail": "Hinweis auf Silageverwendung des Mähguts"} if {
	some t in forage_transfers
	flag(t, "indicates_silage_use")
}

# O6_3-OBL-10: keine Abgabe von Grünfutter zwischen zwei Heuwirtschaftsbetrieben.
violations contains {"rule_id": "O6_3-OBL-10", "detail": "Grünfutterabgabe an einen Heuwirtschaftsbetrieb"} if {
	some t in forage_transfers
	t.form == "green_forage"
	flag(t, "recipient_is_hay_farm")
}

# O6_3-OBL-11: kein Gärheu bzw. keine Heulage aus dem Aufwuchs.
violations contains {"rule_id": "O6_3-OBL-11", "detail": "Gärheu/Heulage"} if flag(feeding, "haylage_or_fermented_hay_produced")

# O6_3-OPT-01: bei Option kein Mähaufbereiter-Einsatz und kein Gerät am Betrieb.
violations contains {"rule_id": "O6_3-OPT-01", "detail": "Mähaufbereiter eingesetzt"} if {
	option_requested
	flag(machinery, "mower_conditioner_used")
}

violations contains {"rule_id": "O6_3-OPT-01", "detail": "Mähaufbereiter am Betrieb vorhanden"} if {
	option_requested
	flag(machinery, "mower_conditioner_present")
}

# GEN-MBK-01: Mindestbewirtschaftung auf Grünland und Ackerfutterflächen.
violations contains {"rule_id": "GEN-MBK-01", "detail": sprintf("Parzelle %v ohne Mahd/Beweidung", [p.parcel_id])} if {
	some p in parcels
	counts_as_forage_area(p)
	grassland_type(p) != "bergmaehder"
	not is_mown(p)
	not is_grazed(p)
}

violations contains {"rule_id": "GEN-MBK-01", "detail": sprintf("Bergmähder %v nicht innerhalb von 2 Jahren gemäht", [p.parcel_id])} if {
	some p in parcels
	grassland_type(p) == "bergmaehder"
	not is_mown(p)
	not object.get(p, ["operations", "mown_previous_year"], false) == true
}

violation_rule_ids := {v.rule_id | some v in violations}

# PREM-03: Förderbedingungen sind auch bei Nicht-Gewährung der Prämie einzuhalten.
obligations_apply if is_number(contract_start_year)
