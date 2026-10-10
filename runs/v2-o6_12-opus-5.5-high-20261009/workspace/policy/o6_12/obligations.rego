package oepul.o6_12

# Förderverpflichtungen: Insektizidverzicht, Kauf/Lagerung, behördliche Anordnungen, PSM-Codierung,
# Mindestbewirtschaftung.

authority_orders := {o.order_id: o | some o in object.get(o612, "authority_orders", [])}

applications(p) := object.get(p, "psm_applications", [])

is_bio_permitted(a) if a.eu_2018_848_permitted == true

is_chemical_synthetic(a) if a.chemical_synthetic == true

# Nach einem genehmigten rückzahlungsfreien Ausstieg (Rebzikade 2026) gilt der Verzicht nicht mehr.
after_commitment_end(a) if {
	rebzikade_exit_without_repayment
	date_on_or_before(exit_obj.request_date, a.date)
}

# Behördlich angeordnete Bekämpfung (SRL 2.12; Rebzikade-Hinweis 2026):
# zulässig, wenn der behördlich zugelassene Wirkstoff eingesetzt wird; sind Bio-Wirkstoffe erlaubt
# und verfügbar, dürfen nur diese eingesetzt werden, außer der chemisch-synthetische Wirkstoff ist
# dezidiert angeordnet.
authority_order_covers(a) if {
	order := authority_orders[a.authority_order_id]
	a.substance_approved_by_order == true
	is_bio_permitted(a)
	order.order_id
}

authority_order_covers(a) if {
	order := authority_orders[a.authority_order_id]
	a.substance_approved_by_order == true
	not is_bio_permitted(a)
	order.chemical_synthetic_explicitly_ordered == true
}

authority_order_covers(a) if {
	order := authority_orders[a.authority_order_id]
	a.substance_approved_by_order == true
	not is_bio_permitted(a)
	order.bio_substances_available == false
}

commitment_active if {
	participates
	year_in_contract_period
}

prohibited_insecticide_applications contains {"parcel_id": p.parcel_id, "date": a.date, "product": object.get(a, "product_name", null)} if {
	commitment_active
	some p in parcels
	is_wine_fruit_hop_parcel(p)
	some a in applications(p)
	a.action_type == "insecticide"
	not is_bio_permitted(a)
	not authority_order_covers(a)
	not after_commitment_end(a)
}

insecticide_ban_complied if {
	commitment_active
	count(prohibited_insecticide_applications) == 0
}

# Behördlich angeordnete Einsätze: Anordnung und Einsatz sind zu dokumentieren.
authority_order_documentation_missing contains a.authority_order_id if {
	commitment_active
	some p in parcels
	some a in applications(p)
	a.authority_order_id
	order := authority_orders[a.authority_order_id]
	not order.documented_on_farm == true
}

authority_order_documentation_missing contains a.authority_order_id if {
	commitment_active
	some p in parcels
	some a in applications(p)
	a.authority_order_id
	not authority_orders[a.authority_order_id]
}

# Bis inkl. Antragsjahr 2025: Hochladen der behördlichen Anordnung via eAMA bei chemisch-synthetischen Insektiziden.
authority_order_upload_missing contains a.authority_order_id if {
	commitment_active
	year <= params.psm_coding_last_application_year
	some p in parcels
	some a in applications(p)
	a.action_type == "insecticide"
	is_chemical_synthetic(a)
	order := authority_orders[a.authority_order_id]
	not order.uploaded_to_eama == true
}

authority_order_upload_required if year <= params.psm_coding_last_application_year

# --- Kauf und Lagerung (Merkblatt 4.3, SRL 2.12) ------------------------------

stock_items := object.get(o612, "insecticide_stock", [])

prohibited_insecticide_stock contains object.get(item, "product_name", "unknown") if {
	commitment_active
	some item in stock_items
	item.is_insecticide == true
	not item.eu_2018_848_permitted == true
	not item.intended_for_other_crops == true
	not authority_orders[object.get(item, "authority_order_id", "")]
}

stock_for_other_crops_not_substantiated contains object.get(item, "product_name", "unknown") if {
	commitment_active
	some item in stock_items
	item.is_insecticide == true
	not item.eu_2018_848_permitted == true
	item.intended_for_other_crops == true
	not stock_substantiated(item)
}

stock_substantiated(item) if {
	item.quantity_plausible == true
	item.records_kept == true
}

# --- PSM-Codierung im Mehrfachantrag (Merkblatt 4.2, nur bis Antragsjahr 2025) --

psm_coding_required if year <= params.psm_coding_last_application_year

flat_applications(p) := [a | some a in applications(p); object.get(a, "flat_application", true) == true]

has_chem_insecticide(p) if {
	some a in flat_applications(p)
	a.action_type == "insecticide"
	is_chemical_synthetic(a)
}

has_chem_other(p) if {
	some a in flat_applications(p)
	a.action_type != "insecticide"
	is_chemical_synthetic(a)
}

has_bio_only(p) if {
	count(flat_applications(p)) > 0
	not has_chem_insecticide(p)
	not has_chem_other(p)
}

required_psm_codes(p) := codes if {
	ci := {"PSMCSI" | has_chem_insecticide(p)}
	co := {"PSMCS" | has_chem_other(p)}
	bo := {"PSMBIO" | has_bio_only(p)}
	codes := (ci | co) | bo
}

missing_psm_codes[p.parcel_id] contains code if {
	participates
	psm_coding_required
	some p in parcels
	is_wine_fruit_hop_parcel(p)
	some code in required_psm_codes(p)
	not code in parcel_codes(p)
}

# --- Mindestbewirtschaftung auf Dauer-/Spezialkulturflächen (SRL 1.6.3.2) -------

minimum_management_violations[p.parcel_id] contains k if {
	participates
	some p in parcels
	p.parcel_id in {q.parcel_id | some q in parcels; is_wine_fruit_hop_parcel(q)}
	some k in ["properly_planted", "annual_care", "harvested"]
	object.get(p, ["minimum_management", k], true) == false
}

# --- Gesamtübersicht der Verpflichtungsverstöße -------------------------------

obligation_breaches contains "insecticide_use" if count(prohibited_insecticide_applications) > 0

obligation_breaches contains "insecticide_purchase_or_storage" if count(prohibited_insecticide_stock) > 0

obligation_breaches contains "insecticide_stock_other_crops_not_substantiated" if count(stock_for_other_crops_not_substantiated) > 0

obligation_breaches contains "authority_order_not_documented" if count(authority_order_documentation_missing) > 0

obligation_breaches contains "authority_order_not_uploaded" if count(authority_order_upload_missing) > 0

obligation_breaches contains "psm_codes_missing" if count(missing_psm_codes) > 0
