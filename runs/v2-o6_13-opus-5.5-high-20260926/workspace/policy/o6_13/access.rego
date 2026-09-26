# o6_13 – Förderwerbende Personen, Betriebsmindestgröße und Zugangsvoraussetzungen
package oepul.o6_13

# ---------------------------------------------------------------------------
# O6_13-GEN-APPL-01 / -02: zulässige Rechtsformen, Beteiligung von
# Gebietskörperschaften höchstens 25 %
# ---------------------------------------------------------------------------
legal_form_row(code) := row if {
	some row in general.applicant_legal_forms
	row.code == code
}

access_failures contains {
	"rule_id": "O6_13-GEN-APPL-01",
	"message": "Rechtsform der förderwerbenden Person ist nicht förderfähig",
} if {
	lf := object.get(applicant, "legal_form", null)
	lf != null
	not legal_form_row(lf)
}

access_failures contains {
	"rule_id": "O6_13-GEN-APPL-02",
	"message": "Beteiligung von Gebietskörperschaften übersteigt 25 %",
} if {
	row := legal_form_row(applicant.legal_form)
	row.max_public_body_share_percent != null
	object.get(applicant, "public_body_share_percent", 0) > row.max_public_body_share_percent
}

# ---------------------------------------------------------------------------
# O6_13-GEN-APPL-03: Gebietskörperschaften sind nur bei den gelisteten
# Maßnahmen zugelassen; o6_13 ist nicht gelistet.
# ---------------------------------------------------------------------------
public_body_exception_applies(y) if {
	some row in general.public_body_exception_measures
	row.measure_code == measure_code
	year_row_matches({"year_from": coalesce(row.year_from, 0), "year_to": row.year_to}, y)
}

access_failures contains {
	"rule_id": "O6_13-GEN-APPL-03",
	"message": "Gebietskörperschaften und deren Einrichtungen sind in o6_13 keine förderwerbenden Personen",
} if {
	is_true(applicant, "is_public_body")
	not public_body_exception_applies(year)
}

# ---------------------------------------------------------------------------
# O6_13-GEN-APPL-04: aktiver Landwirt, landwirtschaftliche Tätigkeit,
# Bewirtschaftung im eigenen Namen und auf eigene Rechnung, Verfügungsgewalt
# ---------------------------------------------------------------------------
applicant_requirement_keys := [
	"is_active_farmer",
	"has_agricultural_activity",
	"farms_in_own_name_and_account",
	"has_control_over_declared_areas",
]

access_failures contains {
	"rule_id": "O6_13-GEN-APPL-04",
	"message": sprintf("Voraussetzung für förderwerbende Person nicht erfüllt: %s", [key]),
} if {
	some key in applicant_requirement_keys
	is_false(applicant, key)
}

# ---------------------------------------------------------------------------
# O6_13-GEN-SIZE-01 / -02: Betriebsmindestgröße nur im 1. ÖPUL-Teilnahmejahr
# ---------------------------------------------------------------------------
first_oepul_participation_year := object.get(input, ["farm", "oepul", "first_participation_year"], year)

is_first_oepul_year if first_oepul_participation_year == year

protected_cultivation_area_ha := object.get(input, ["land", "protected_cultivation_area_ha"], sum([p.area_ha |
	some p in parcels
	is_protected_structure(p)
]))

# Fläche nach § 25 GSP-AV zuzüglich GA-, K20-, GLÖZ-LE-, Mehrnutzenhecken- und Agroforstflächen
minimum_size_total_area_ha := object.get(input, ["land", "total_area_ha"], 0) + object.get(input, ["land", "minimum_size_additional_area_ha"], 0)

minimum_farm_size_met if protected_cultivation_area_ha >= general.minimum_farm_size_first_year.protected_cultivation_min_ha

minimum_farm_size_met if minimum_size_total_area_ha >= general.minimum_farm_size_first_year.total_area_min_ha

minimum_farm_size_required if is_first_oepul_year

access_failures contains {
	"rule_id": "O6_13-GEN-SIZE-01",
	"message": "Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr nicht erreicht (0,50 ha geschützter Anbau oder 1,50 ha Fläche)",
} if {
	minimum_farm_size_required
	not minimum_farm_size_met
}

# ---------------------------------------------------------------------------
# O6_13-ACC-01: keine Teilnahme an operationellem Programm mit Abgeltung des
# Organismeneinsatzes (unabhängig von der tatsächlichen Abgeltung am Betrieb)
# ---------------------------------------------------------------------------
access_failures contains {
	"rule_id": "O6_13-ACC-01",
	"message": "Mitglied einer Erzeugerorganisation mit operationellem Programm zum Organismeneinsatz – Teilnahme ausgeschlossen",
} if {
	is_true(state, "member_of_producer_organisation_with_op_covering_organisms")
}

# ---------------------------------------------------------------------------
# O6_13-ACC-02: Mindestteilnahme – zumindest ein Gewächshaus oder Folientunnel
# je Teilnahmejahr nach den Vorgaben der Maßnahme bewirtschaftet
# ---------------------------------------------------------------------------
compliant_structures contains p.parcel_id if {
	some p in nue_parcels
	is_protected_structure(p)
	parcel_has_creditable_use(p)
}

minimum_participation_met if count(compliant_structures) >= 1

access_failures contains {
	"rule_id": "O6_13-ACC-02",
	"message": "Kein Gewächshaus oder Folientunnel nach den Vorgaben der Maßnahme bewirtschaftet (Mindestteilnahme)",
} if {
	count(nue_parcels) > 0
	not minimum_participation_met
}

# ---------------------------------------------------------------------------
# O6_13-GEN-LOC-01: geförderte Flächen müssen in Österreich liegen
# (flächenbezogen in parcels.rego geprüft)
# ---------------------------------------------------------------------------
access_requirements_met if count(access_failures) == 0
