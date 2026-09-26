# Maßnahme 12 – Förderverpflichtungen: Insektizidverzicht, behördliche Anordnungen,
# Kauf/Lagerung sowie PSM-Codierung im Mehrfachantrag (bis Antragsjahr 2025).
package oepul.o6_12

authority_orders := object.get(o6_12_input, ["authority_orders"], [])

# --- Behördliche Anordnung zur Schaderregerbekämpfung ---
# Chemisch-synthetischer Wirkstoff ist durch die Anordnung gedeckt, wenn er dezidiert angeordnet
# ist oder keine Bio-Wirkstoffe zur Verfügung stehen (SRL 2.12, Notice Rebzikade 2026).
order_covers_chemical_synthetic(o) if o.prescribes_chemical_synthetic == true

order_covers_chemical_synthetic(o) if o.organic_substances_available == false

authority_exempt(app) if {
	app.authority_ordered_control == true
	some o in authority_orders
	order_covers_chemical_synthetic(o)
}

authority_exempt(app) if {
	app.authority_ordered_control == true
	app.organic_regulation_permitted == true
}

is_insecticide(app) if app.effect_type == "insecticide"

# Insektizide gemäß Verordnung (EU) 2018/848 sind zulässig.
permitted_insecticide(app) if app.organic_regulation_permitted == true

permitted_insecticide(app) if authority_exempt(app)

# Nach genehmigtem rückzahlungsfreiem Ausstieg (Rebzikade) dürfen chemisch-synthetische
# Insektizide nach den gesetzlichen Regelungen eingesetzt werden.
after_approved_exit(app) if {
	leafhopper_exit_approved
	app.application_date >= leafhopper_exit_request_date
}

prohibited_insecticide_use contains {"parcel_id": p.parcel_id, "product_name": app.product_name, "application_date": app.application_date} if {
	participates
	some p in parcels
	subject_to_ban(p)
	some app in parcel_applications(p)
	is_insecticide(app)
	not permitted_insecticide(app)
	not after_approved_exit(app)
}

insecticide_ban_complied if count(prohibited_insecticide_use) == 0

# Anordnung und Einsatz sind zu dokumentieren (SRL 2.12; Notice Rebzikade 2026).
authority_order_documentation_missing contains o.pest if {
	participates
	some o in authority_orders
	object.get(o, "order_documented", false) == false
}

authority_order_documentation_missing contains o.pest if {
	participates
	some o in authority_orders
	object.get(o, "application_documented", false) == false
}

# Im Gebiet mit Bio-Wirkstoff-Option dürfen nur Bio-Wirkstoffe eingesetzt werden.
authority_order_organic_only_breach contains {"parcel_id": p.parcel_id, "product_name": app.product_name} if {
	participates
	some p in parcels
	subject_to_ban(p)
	some app in parcel_applications(p)
	is_insecticide(app)
	app.authority_ordered_control == true
	object.get(app, "organic_regulation_permitted", false) == false
	count(authority_orders) > 0
	every o in authority_orders {
		not order_covers_chemical_synthetic(o)
	}
}

# --- Kauf und Lagerung (MB 4.3; SRL 2.12) ---
insecticide_stock := object.get(o6_12_input, ["insecticide_stock"], [])

purchase_storage_violation contains item.product_name if {
	participates
	some item in insecticide_stock
	stock_relevant(item)
	object.get(item, "organic_regulation_permitted", false) == false
	object.get(item, "permitted_use_in_other_crop", false) == false
}

purchase_storage_violation contains item.product_name if {
	participates
	some item in insecticide_stock
	stock_relevant(item)
	object.get(item, "organic_regulation_permitted", false) == false
	object.get(item, "permitted_use_in_other_crop", false) == true
	not stock_plausible_and_recorded(item)
}

stock_relevant(item) if object.get(item, "purchased", false) == true

stock_relevant(item) if object.get(item, "stored", false) == true

stock_plausible_and_recorded(item) if {
	item.quantity_plausible == true
	item.records_available == true
}

# --- Angabe von Pflanzenschutzmitteleinsätzen (MB 4.2) ---
psm_coding_required if {
	participates
	application_year <= measure.psm_coding_last_year
}

default psm_coding_required := false

is_chemical_synthetic(app) if object.get(app, "chemical_synthetic", false) == true

area_wide(app) if object.get(app, "area_wide", false) == true

psm_codes_expected(p) := codes if {
	apps := [app | some app in parcel_applications(p); area_wide(app)]
	cs_insecticide := [1 | some app in apps; is_chemical_synthetic(app); is_insecticide(app)]
	cs_other := [1 | some app in apps; is_chemical_synthetic(app); not is_insecticide(app)]
	bio := [1 | some app in apps; not is_chemical_synthetic(app)]
	codes := {c |
		some c in ["PSMCSI", "PSMCS", "PSMBIO"]
		code_needed(c, count(cs_insecticide), count(cs_other), count(bio))
	}
}

code_needed("PSMCSI", n_csi, _, _) if n_csi > 0

code_needed("PSMCS", n_csi, n_cso, _) if {
	n_csi == 0
	n_cso > 0
}

# Bio- und chemisch-synthetische Mittel gemeinsam: PSMCS ist ausreichend.
code_needed("PSMBIO", n_csi, n_cso, n_bio) if {
	n_csi == 0
	n_cso == 0
	n_bio > 0
}

psm_code_missing contains {"parcel_id": p.parcel_id, "code": c} if {
	psm_coding_required
	some p in parcels
	is_woh_parcel(p)
	some c in psm_codes_expected(p)
	not psm_code_satisfied(c, parcel_psm_codes(p))
}

psm_code_satisfied(c, codes) if c in codes

# PSMCS darf auch durch PSMCSI abgedeckt sein, wenn zusätzlich andere CS-Mittel eingesetzt werden.
psm_code_satisfied("PSMCS", codes) if "PSMCSI" in codes

# Behördlich angeordneter CS-Insektizideinsatz: zusätzlich Upload der Anordnung via eAMA.
authority_order_upload_missing contains o.pest if {
	psm_coding_required
	some o in authority_orders
	object.get(o, "uploaded_to_eama", false) == false
	some p in parcels
	some app in parcel_applications(p)
	app.authority_ordered_control == true
	is_chemical_synthetic(app)
}

# Codierung ohne tatsächlichen Einsatz ist zu streichen.
psm_code_without_application contains {"parcel_id": p.parcel_id, "code": c} if {
	psm_coding_required
	some p in parcels
	some c in parcel_psm_codes(p)
	count(psm_codes_expected(p)) == 0
	object.get(p, ["oepul", "psm_application_planned"], false) == false
}

# --- Mindestbewirtschaftung Dauer-/Spezialkulturen und Weinflächen (SRL 1.6.3.2) ---
minimum_management_breach contains p.parcel_id if {
	some p in parcels
	is_woh_parcel(p)
	some key in ["proper_planting", "annual_care", "harvest_and_removal"]
	object.get(p, ["operations", "minimum_management", key], true) == false
}
