# o6_11 policy module
# o6_11 – Förderverpflichtungen
#
#   Vollständiger Herbizidverzicht, Verbot von Kauf und Lagerung,
#   Ameisensäure, PSM-Codierung im Mehrfachantrag bis 2025.
package oepul.o6_11

psm_applications(p) := object.get(p, ["operations", "psm_applications"], [])

application_year(a) := year_of(a.date) if a.date

application_year(a) := year if not a.date

# Anwendung innerhalb des Vertragszeitraums der Maßnahme (bis zum Ausstieg)
application_in_commitment(a) if {
	contract_start_valid
	application_year(a) >= contract_start_year
	application_year(a) <= year_of(contract_end)
	not application_after_exit(a)
}

application_after_exit(a) if {
	participation.exit_date
	a.date
	a.date > participation.exit_date
}

# Rule O611-HERB-WIRKUNGSTYP: maßgeblich ist der Wirkungstyp „Herbizid“ im
# AGES-Pflanzenschutzmittelregister (auch Stammbehandlungsmittel)
is_herbicide(a) if a.effect_type == cfg.prohibited_substances.effect_type_prohibited

# Rule O611-AMEISENSAEURE: nicht genehmigter Wirkstoff (alle Synonyme)
formic_acid_names := {lower(s) |
	some sub in cfg.prohibited_substances.non_approved_active_substances
	some s in sub.synonyms
}

contains_formic_acid(a) if {
	some s in object.get(a, "active_substances", [])
	lower(s) in formic_acid_names
}

# Rule O611-HERB-BAN / O611-FENCE / O611-STAMM
herbicide_ban_violations contains {
	"parcel_id": p.parcel_id,
	"product": object.get(a, "product_name", null),
	"date": object.get(a, "date", null),
	"zone": object.get(a, "application_zone", "area"),
} if {
	some p in parcels
	herbicide_ban_parcel(p)
	some a in psm_applications(p)
	is_herbicide(a)
	application_in_commitment(a)
}

formic_acid_violations contains {
	"parcel_id": p.parcel_id,
	"product": object.get(a, "product_name", null),
	"date": object.get(a, "date", null),
} if {
	some p in parcels
	some a in psm_applications(p)
	contains_formic_acid(a)
	application_in_commitment(a)
}

# ---------------------------------------------------------------------------
# Kauf und Lagerung (Rules O611-PURCHASE-STORAGE, O611-PURCHASE-OTHER-CROPS,
# O611-PURCHASE-PLAUSIBLE)
# ---------------------------------------------------------------------------
inventory := object.get(input, ["documentation", "plant_protection_inventory"], [])

# Herbizid ist für eine andere (nicht dem Verzicht unterliegende) Kultur des Betriebes bestimmt
inventory_for_other_crop(item) if {
	item.intended_crop_category in non_wfh_crop_categories
}

inventory_justified(item) if {
	inventory_for_other_crop(item)
	item.records_documented == true
	item.quantity_plausible == true
}

purchase_storage_violations contains {
	"product": object.get(item, "product_name", null),
	"reason": "Kauf bzw. Lagerung eines Herbizids ohne zulässigen Einsatz in einer anderen Kultur",
} if {
	participates
	year_in_contract_period
	some item in inventory
	is_herbicide(item)
	not inventory_for_other_crop(item)
}

purchase_storage_violations contains {
	"product": object.get(item, "product_name", null),
	"reason": "Herbizid für andere Kultur: Menge nicht plausibel oder nicht mittels Aufzeichnungen nachgewiesen",
} if {
	participates
	year_in_contract_period
	some item in inventory
	is_herbicide(item)
	inventory_for_other_crop(item)
	not inventory_justified(item)
}

purchase_storage_violations contains {
	"product": object.get(item, "product_name", null),
	"reason": "Ameisensäure ist ein nicht genehmigter Wirkstoff",
} if {
	participates
	year_in_contract_period
	some item in inventory
	contains_formic_acid(item)
}

# ---------------------------------------------------------------------------
# PSM-Codierung im Mehrfachantrag bis einschließlich 2025
# (Rules O611-PSM-CODE-REQ, O611-PSM-CODE-COMBINED, O611-PSM-CODE-HERB,
# O611-PSM-CODE-2026-ABOLISHED)
# ---------------------------------------------------------------------------
psm_coding_required_year if year <= cfg.psm_codes.required_until_year

parcel_codes(p) := {c | some c in object.get(p, ["oepul", "codes"], [])}

area_wide_applications(p) := [a |
	some a in psm_applications(p)
	a.is_area_wide == true
	application_year(a) == year
]

has_cs_herbicide(p) if {
	some a in area_wide_applications(p)
	is_herbicide(a)
	a.is_organic_approved != true
}

has_cs_other(p) if {
	some a in area_wide_applications(p)
	not is_herbicide(a)
	a.is_organic_approved != true
}

has_organic(p) if {
	some a in area_wide_applications(p)
	a.is_organic_approved == true
}

psm_code_needed(p, "PSMCSH") if has_cs_herbicide(p)

psm_code_needed(p, "PSMCS") if has_cs_other(p)

# PSMBIO nur, wenn nicht zugleich chemisch-synthetische Mittel (dann genügt PSMCS)
psm_code_needed(p, "PSMBIO") if {
	has_organic(p)
	not has_cs_other(p)
	not has_cs_herbicide(p)
}

psm_code_list := {row.code | some row in cfg.psm_codes.rows}

required_psm_codes(p) := {code |
	some code in psm_code_list
	psm_code_needed(p, code)
}

# Bei Bio + chemisch-synthetisch ist PSMCS ausreichend; erfüllt PSMBIO-Pflicht
psm_code_satisfied(p, code) if code in parcel_codes(p)

psm_code_satisfied(p, "PSMBIO") if "PSMCS" in parcel_codes(p)

missing_psm_codes contains {"parcel_id": p.parcel_id, "code": code} if {
	participates
	year_in_contract_period
	psm_coding_required_year
	some p in parcels
	parcel_in_measure(p)
	some code in required_psm_codes(p)
	not psm_code_satisfied(p, code)
}
