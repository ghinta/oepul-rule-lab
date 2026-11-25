# o6_13 – Förderverpflichtungen Nützlingseinsatz und Aufzeichnungen
package oepul.o6_13

applications_of(p) := object.get(p, "beneficial_organism_applications", [])

non_creditable_use_codes := {row.code | some row in params.non_creditable_organism_uses}

# ---------------------------------------------------------------------------
# O6_13-OBL-01: Einsatz von Organismen gemäß Aufwandsmengen im
#   AGES-Pflanzenschutzmittelregister
# O6_13-OBL-02: anrechenbar nur Anwendungen, die einen PSM-Einsatz ersetzen
# O6_13-OBL-03: Hummelvölker zur Bestäubung sind nicht anrechenbar
# ---------------------------------------------------------------------------
creditable_application(a) if {
	date_in_year(a.date, year)
	a.listed_in_psm_register == true
	a.applied_at_register_rate == true
	a.replaces_psm_use == true
	not object.get(a, "use_type", "plant_protection") in non_creditable_use_codes
}

creditability_checks := [
	["listed_in_psm_register", "O6_13-OBL-01: Organismus nicht im Pflanzenschutzmittelregister geführt"],
	["applied_at_register_rate", "O6_13-OBL-01: Aufwandsmenge nicht gemäß Pflanzenschutzmittelregister"],
	["replaces_psm_use", "O6_13-OBL-02: Anwendung ersetzt keinen Pflanzenschutzmitteleinsatz"],
]

non_creditable_reasons(a) := (flag_reasons(a) | pollination_reasons(a)) | period_reasons(a)

flag_reasons(a) := {check[1] |
	some check in creditability_checks
	object.get(a, check[0], false) != true
}

pollination_reasons(a) := {"O6_13-OBL-03: Hummelvölker für die Bestäubung sind nicht anrechenbar" |
	object.get(a, "use_type", "plant_protection") in non_creditable_use_codes
}

period_reasons(a) := {"Einsatz nicht im Förderjahr" |
	not date_in_year(object.get(a, "date", null), year)
}

parcel_has_creditable_use(p) if {
	some a in applications_of(p)
	creditable_application(a)
}

parcel_has_full_coverage_use(p) if {
	some a in applications_of(p)
	creditable_application(a)
	a.covers_entire_area == true
}

non_creditable_applications contains {
	"parcel_id": p.parcel_id,
	"date": object.get(a, "date", null),
	"organism_species": object.get(a, "organism_species", null),
	"reasons": non_creditable_reasons(a),
} if {
	some p in nue_parcels
	some a in applications_of(p)
	not creditable_application(a)
}

# Maßnahmenebene: zumindest ein Gewächshaus/Folientunnel mit anrechenbarem Einsatz
beneficial_use_obligation_met if {
	some p in nue_parcels
	is_protected_structure(p)
	parcel_has_creditable_use(p)
}

obligation_violations contains {
	"rule_id": "O6_13-OBL-01",
	"message": "Kein anrechenbarer Nützlingseinsatz gemäß Pflanzenschutzmittelregister in zumindest einem Gewächshaus oder Folientunnel",
} if {
	count(nue_parcels) > 0
	not beneficial_use_obligation_met
}

# ---------------------------------------------------------------------------
# O6_13-DOC-01: schlagbezogene Aufzeichnungen über Art und Menge, Belege über
#   Zukauf, Grund und Ziel sowie Datum des Einsatzes
# O6_13-DOC-02: Vorlage oder andere Aufzeichnungen mit den notwendigen Angaben
# ---------------------------------------------------------------------------
record_field_present(a, "purchase_receipt_available") if a.purchase_receipt_available == true

record_field_present(a, key) if {
	key != "purchase_receipt_available"
	v := object.get(a, key, null)
	v != null
	v != ""
}

missing_record_fields(a) := {row.key |
	some row in params.record_required_fields
	not record_field_present(a, row.key)
}

obligation_violations contains {
	"rule_id": "O6_13-DOC-01",
	"message": sprintf("Aufzeichnung unvollständig auf Schlag %v (%v): fehlend %v", [p.parcel_id, object.get(a, "date", "ohne Datum"), sort(missing)]),
} if {
	some p in nue_parcels
	some a in applications_of(p)
	date_in_year(object.get(a, "date", ""), year)
	missing := missing_record_fields(a)
	count(missing) > 0
}

obligation_violations contains {
	"rule_id": "O6_13-DOC-01",
	"message": sprintf("Aufzeichnungen nicht schlagbezogen geführt (Schlag %v)", [p.parcel_id]),
} if {
	some p in nue_parcels
	is_false(object.get(p, "records", {}), "kept_per_parcel")
}

records_complete if {
	not any_doc_violation
}

any_doc_violation if {
	some v in obligation_violations
	v.rule_id == "O6_13-DOC-01"
}
