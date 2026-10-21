# o6_8 - Anhäufungen bei Kartoffeln (AH)
# Kapitel 4.2 des Maßnahmeninformationsblatts und SRL 2.8 (Anhäufungen bei Kartoffeln).
package oepul.o6_8

ridges(p) := object.get(p, ["oepul_o6_8", "potato_ridges"], {})

ah_check(p, field) := object.get(ridges(p), field, null)

parcel_violations contains violation("o6_8.ah.ridges_max_2m", p, "AH", sprintf("Abstand der Anhäufungen %v m überschreitet 2 m.", [ah_check(p, "interval_max_m")])) if {
	some p in parcels
	has_code(p, "AH")
	ah_check(p, "interval_max_m") > params.ah_max_ridge_interval_m
}

parcel_violations contains violation("o6_8.ah.ridges_max_2m", p, "AH", "Anhäufungen sind in den Rinnen der Anpflanzdämme (ausgenommen Fahrgassen) anzulegen.") if {
	some p in parcels
	has_code(p, "AH")
	ah_check(p, "in_furrows_except_tramlines") == false
}

seed_potato_row_omission_permitted(p) if {
	usage(p) == "Saatkartoffeln"
	ah_check(p, "omission_necessary_weed_control_or_safety") == true
}

parcel_violations contains violation("o6_8.ah.seed_potato_every_4th_row", p, "AH", "Verzicht auf Anhäufungen in jeder 4. Reihe nur im Saatkartoffelbau bei Erforderlichkeit (mechanische Unkrautkontrolle, Schutz arbeitender Personen).") if {
	some p in parcels
	has_code(p, "AH")
	ah_check(p, "every_4th_row_omitted") == true
	not seed_potato_row_omission_permitted(p)
}

parcel_violations contains violation("o6_8.ah.created_by_planter", p, "AH", "Anhäufungen sind mittels technischer Einrichtung am Legegerät bzw. bei abgesetztem Legeverfahren zeitnah mit der Dammfräse zu erzeugen.") if {
	some p in parcels
	has_code(p, "AH")
	ah_check(p, "created_by_planter_or_prompt_ridger") == false
}

parcel_violations contains violation("o6_8.ah.distinct_effective_ridges", p, "AH", "Das Gerät ist so einzustellen, dass deutliche, wirksame Erdanhäufungen entstehen.") if {
	some p in parcels
	has_code(p, "AH")
	ah_check(p, "distinct_effective_ridges") == false
}

parcel_violations contains violation("o6_8.ah.maintain_until_haulm_reduction", p, "AH", "Anhäufungen sind zumindest bis zur Krautminderung beizubehalten.") if {
	some p in parcels
	has_code(p, "AH")
	ah_check(p, "maintained_until_haulm_reduction") == false
}

# Erneuerung im Rahmen der Unkrautbekämpfung oder nach Regenereignissen ist zulässig
# und daher kein Verstoß gegen die Beibehaltungspflicht.
ah_renewal_permitted(reason) if reason in {"weed_control", "rain_event"}
