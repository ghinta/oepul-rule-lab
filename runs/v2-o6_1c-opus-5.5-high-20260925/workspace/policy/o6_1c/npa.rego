# Förderverpflichtungen der Kategorie „Nichtproduktive Ackerflächen" (NPA)
# (Informationsblatt 1C Kap. 5.1, 6, 7; SRL Punkt 2.1C Förderverpflichtungen).
package oepul.o6_1c

removal_methods := data.o6_1c.npa_removal_methods

npa_establishment_options := {o |
	some c in data.o6_1c.measure_categories
	c.category == "npa"
	some o in c.establishment_options
}

# Schläge mit NPA-Angaben (Objekt `npa`) oder NPA-Code gelten als NPA-Schläge.
npa_parcels contains p if {
	some p in parcels
	object.get(p, "npa", null) != null
}

npa_parcels contains p if {
	some p in parcels
	params.npa_code in parcel_codes(p)
}

npa(p) := object.get(p, "npa", {})

npa_first_year(p) if object.get(npa(p), "first_npa_declaration_year", year) == year

npa_events(p) := object.get(npa(p), "maintenance_events", [])

# O61C-NPA-011: Reinigungsschnitt nur im ersten Antragsjahr und nur auf Flächen mit Neuansaat
# (auch bei Umbruch und Neueinsaat einer bestehenden Grünbrache).
cleaning_cut_permitted(p) if {
	npa_first_year(p)
	object.get(npa(p), "establishment_type", null) == "new_sowing"
}

cleaning_cut_permitted(p) if {
	npa_first_year(p)
	object.get(npa(p), "resown_after_breaking_existing_fallow", false) == true
}

valid_cleaning_cut(p, e) if {
	e.type == "cleaning_cut"
	cleaning_cut_permitted(p)
}

# Pflegeschnitte, die zur Maximalanzahl und zur 50 %-Grenze zählen (gültige Reinigungsschnitte ausgenommen).
counted_cuts(p) := [e |
	some e in npa_events(p)
	startswith(e.date, sprintf("%d-", [year]))
	not valid_cleaning_cut(p, e)
]

all_cuts_in_year(p) := [e |
	some e in npa_events(p)
	startswith(e.date, sprintf("%d-", [year]))
]

early_counted_cut(p) if {
	some e in counted_cuts(p)
	e.date < date_in_year(params.npa_late_cut_earliest_month_day)
}

npa_total_area_ha := sum_area(npa_parcels)

npa_early_cut_area_ha := sum([object.get(p, "area_ha", 0) | some p in npa_parcels; early_counted_cut(p)])

# O61C-NPA-012: höchstens 50 % der NPA-Fläche dürfen vor dem 1. August gemäht/gehäckselt werden.
default npa_early_cut_share_exceeded := false

npa_early_cut_share_exceeded if {
	npa_total_area_ha > 0
	npa_early_cut_area_ha > params.npa_late_cut_share * npa_total_area_ha
}

npa_breaking_earliest(p) := date_in_year(params.npa_breaking_earliest_after_winter_or_catch_crop_month_day) if {
	object.get(npa(p), "follow_up_crop", "none") in {"winter_crop", "catch_crop"}
} else := date_in_year(params.npa_breaking_earliest_month_day)

npa_fertilized(p) if object.get(npa(p), "any_fertilization", false) == true

npa_fertilized(p) if object.get(p, ["operations", "fertilizer", "mineral_n_kg_per_ha"], 0) > 0

npa_fertilized(p) if object.get(p, ["operations", "fertilizer", "organic_n_kg_per_ha"], 0) > 0

npa_psm_violation(p) if {
	object.get(p, ["operations", "psm_used"], false) == true
	object.get(npa(p), "psm_only_bio_active_substances", false) != true
}

allowed_removal_method_codes := {m.method | some m in removal_methods.allowed_methods}

npa_violations contains v if {
	some p in npa_parcels
	object.get(p, "land_use", null) != "arable"
	v := {"rule_id": "O61C-NPA-001", "scope": p.parcel_id, "message": "NPA muss eine Ackerfläche sein"}
}

npa_violations contains v if {
	some p in npa_parcels
	not params.npa_code in parcel_codes(p)
	v := {"rule_id": "O61C-APPL-004", "scope": p.parcel_id, "message": "NPA-Schlag ist nicht mit dem Code NPA gekennzeichnet"}
}

npa_violations contains v if {
	some p in npa_parcels
	object.get(p, "schlagnutzungsart", null) != params.npa_schlagnutzungsart
	v := {"rule_id": "O61C-APPL-004", "scope": p.parcel_id, "message": "NPA-Schlag ist nicht mit der Schlagnutzungsart Grünbrache beantragt"}
}

npa_violations contains v if {
	some p in npa_parcels
	not object.get(npa(p), "establishment_type", null) in npa_establishment_options
	v := {"rule_id": "O61C-NPA-002", "scope": p.parcel_id, "message": "Neuansaat, Selbstbegrünung oder Belassen einer bestehenden Grünbrache/dauerhaft begrünten Ackerfläche erforderlich"}
}

npa_violations contains v if {
	some p in npa_parcels
	object.get(npa(p), "establishment_type", null) == "new_sowing"
	npa_first_year(p)
	d := object.get(npa(p), "sowing_date", null)
	d != null
	d > date_in_year(params.npa_new_sowing_deadline_month_day)
	v := {"rule_id": "O61C-NPA-003", "scope": p.parcel_id, "message": sprintf("Neuansaat am %s nach dem 15. Mai", [d])}
}

npa_violations contains v if {
	some p in npa_parcels
	object.get(npa(p), "establishment_type", null) == "new_sowing"
	npa_first_year(p)
	object.get(npa(p), "sowing_date", null) == null
	v := {"rule_id": "O61C-NPA-003", "scope": p.parcel_id, "message": "Neuansaat ohne Ansaatdatum"}
}

npa_violations contains v if {
	some p in npa_parcels
	d := object.get(npa(p), "breaking_date", null)
	d != null
	startswith(d, sprintf("%d-", [year]))
	d < npa_breaking_earliest(p)
	v := {"rule_id": "O61C-NPA-004", "scope": p.parcel_id, "message": sprintf("Umbruch am %s vor dem frühestmöglichen Termin %s", [d, npa_breaking_earliest(p)])}
}

npa_violations contains v if {
	some p in npa_parcels
	object.get(npa(p), "breaking_date", null) != null
	object.get(npa(p), "used_after_breaking", false) == true
	v := {"rule_id": "O61C-NPA-005", "scope": p.parcel_id, "message": "Nutzung nach Umbruch vor dem 31. Dezember (Nutzungsverbot)"}
}

npa_violations contains v if {
	some p in npa_parcels
	npa_psm_violation(p)
	v := {"rule_id": "O61C-NPA-006", "scope": p.parcel_id, "message": "Einsatz nicht bio-konformer Pflanzenschutzmittel auf NPA"}
}

npa_violations contains v if {
	some p in npa_parcels
	npa_fertilized(p)
	v := {"rule_id": "O61C-NPA-007", "scope": p.parcel_id, "message": "Düngung auf NPA verboten"}
}

npa_violations contains v if {
	some p in npa_parcels
	m := object.get(npa(p), "removal_method", null)
	m != null
	m != "none"
	not m in allowed_removal_method_codes
	v := {"rule_id": "O61C-NPA-008", "scope": p.parcel_id, "message": sprintf("Beseitigung mit unzulässiger Methode %v (nur Häckseln oder Einarbeiten)", [m])}
}

npa_violations contains v if {
	some p in npa_parcels
	count(counted_cuts(p)) > params.npa_max_cuts_per_year
	v := {"rule_id": "O61C-NPA-009", "scope": p.parcel_id, "message": sprintf("%d Pflegeschnitte im Jahr (maximal 2)", [count(counted_cuts(p))])}
}

npa_violations contains v if {
	some p in npa_parcels
	not npa_first_year(p)
	count(all_cuts_in_year(p)) == 0
	object.get(npa(p), "maintenance_in_previous_year", true) == false
	v := {"rule_id": "O61C-NPA-010", "scope": p.parcel_id, "message": "Keine Pflegemahd bzw. kein Häckseln im laufenden und im Vorjahr (mindestens jedes zweite Jahr)"}
}

npa_violations contains v if {
	some p in npa_parcels
	some e in all_cuts_in_year(p)
	e.type == "cleaning_cut"
	not cleaning_cut_permitted(p)
	v := {"rule_id": "O61C-NPA-011", "scope": p.parcel_id, "message": sprintf("Reinigungsschnitt am %s unzulässig (nur im ersten Antragsjahr auf Neuansaatflächen)", [e.date])}
}

npa_violations contains v if {
	npa_early_cut_share_exceeded
	v := {"rule_id": "O61C-NPA-012", "scope": "farm", "message": sprintf("%.2f ha von %.2f ha NPA vor dem 1. August gemäht/gehäckselt (maximal 50 %%)", [npa_early_cut_area_ha, npa_total_area_ha])}
}

npa_violations contains v if {
	some p in npa_parcels
	some e in all_cuts_in_year(p)
	object.get(e, "biomass_removed", false) == true
	v := {"rule_id": "O61C-NPA-013", "scope": p.parcel_id, "message": sprintf("Mähgut am %s verbracht (nur Pflegemahd ohne Abtransport zulässig)", [e.date])}
}

npa_violations contains v if {
	some p in npa_parcels
	some e in all_cuts_in_year(p)
	object.get(e, "biomass_used", false) == true
	v := {"rule_id": "O61C-NPA-013", "scope": p.parcel_id, "message": sprintf("Mähgut vom %s genutzt", [e.date])}
}

npa_violations contains v if {
	some p in npa_parcels
	object.get(npa(p), "grazed", false) == true
	v := {"rule_id": "O61C-NPA-014", "scope": p.parcel_id, "message": "Beweidung von NPA nicht erlaubt"}
}

npa_violations contains v if {
	some p in npa_parcels
	some other in object.get(parcel_status(p), "other_measure_premium_codes", [])
	not combinable_on_single_area(params.measure_code, other)
	v := {"rule_id": "O61C-PREM-004", "scope": p.parcel_id, "message": sprintf("NPA ist prämienmäßig nicht mit Maßnahme %v auf der Einzelfläche kombinierbar", [other])}
}

# O61C-PREM-004: NPA ist auf keine anderen Verpflichtungen der SRL anrechenbar.
npa_creditable_to_other_obligations := false
