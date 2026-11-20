# METADATA
# title: UBB (o6_1a) – Vertragszeitraum, Beantragung, Maßnahmenkombination, Zugangsvoraussetzungen
package oepul.o6_1a.eligibility

import data.oepul.o6_1a.common

oepul := object.get(input, ["farm", "oepul"], {})

contract_start_year := object.get(common.ubb, "contract_start_year", null)

# UBB-VZ-001: Vertragszeitraum mindestens 4 Jahre bis 31.12.2028 (Beginn 2023: 6, 2024: 5, 2025: 4 Jahre).
contract_period := {"start": row.start, "years": row.years, "end": row.end} if {
	some row in common.tables.o6_1a_contract_periods
	date_year_of(row.start) == contract_start_year
}

date_year_of(d) := common.date_year(d)

contract_active if {
	contract_period
	common.year >= contract_start_year
	common.year <= 2028
}

# UBB-VZ-002: Optionale Zuschläge haben einen Vertragszeitraum von einem Kalenderjahr.
optional_supplement_period := {"start": sprintf("%d-01-01", [common.year]), "end": sprintf("%d-12-31", [common.year])}

# UBB-ANT-001: Maßnahmenantrag bis 31.12. vor Vertragsbeginn; letzter Einstieg Förderjahr 2025.
application_deadline := sprintf("%d-12-31", [contract_start_year - 1]) if contract_start_year != null

violations contains {"rule_id": "UBB-ANT-001", "subject": "farm", "message": "Maßnahmenantrag nach dem 31.12. vor Vertragsbeginn eingereicht"} if {
	d := object.get(common.ubb, "measure_application_date", null)
	d != null
	d > application_deadline
}

violations contains {"rule_id": "UBB-ANT-002", "subject": "farm", "message": "Einstieg in UBB nach dem Förderjahr 2025 nicht möglich"} if {
	contract_start_year != null
	contract_start_year > 2025
}

violations contains {"rule_id": "UBB-VZ-001", "subject": "farm", "message": "Vertragsbeginn muss 01.01.2023, 01.01.2024 oder 01.01.2025 sein"} if {
	contract_start_year != null
	not contract_period
	contract_start_year <= 2025
}

# UBB-KOMB-001: Keine betriebliche Kombination mit Biologischer Wirtschaftsweise (ausgenommen Bio-Teilbetrieb Wein, Obst und Hopfen).
violations contains {"rule_id": "UBB-KOMB-001", "subject": "farm", "message": "UBB ist betrieblich nicht mit Biologischer Wirtschaftsweise kombinierbar"} if {
	common.participates("1A")
	common.participates("1B")
	not object.get(oepul, "bio_teilbetrieb_wein_obst_hopfen", false)
}

# UBB-KOMB-002: Keine gleichzeitige Teilnahme an "Nichtproduktive Ackerflächen"; Agroforststreifen möglich.
violations contains {"rule_id": "UBB-KOMB-002", "subject": "farm", "message": "UBB ist nicht mit der Maßnahmenkategorie Nichtproduktive Ackerflächen kombinierbar"} if {
	common.participates("1A")
	common.participates("1C_nichtproduktive_ackerflaechen")
}

# UBB-KOMB-003: Kombination auf der Einzelfläche gemäß Anhang L.
single_area_combination(m) := row.single_area if {
	some row in common.tables.o6_1a_combination_1a
	row.measure == m
}

# ATB-FWP-001: Förderwerbende Personen; Gebietskörperschaften sind bei UBB ausgeschlossen.
default applicant_eligible := false

applicant_eligible if {
	t := object.get(oepul, "applicant_type", "natural_person")
	t in {"natural_person", "registered_partnership"}
}

applicant_eligible if {
	object.get(oepul, "applicant_type", "natural_person") in {"legal_person", "association"}
	object.get(oepul, "public_body_share", 0) <= common.tables.o6_1a_applicant_limits.public_body_max_share
}

violations contains {"rule_id": "ATB-FWP-001", "subject": "farm", "message": "Förderwerbende Person nicht teilnahmeberechtigt (z. B. Gebietskörperschaft oder Beteiligung > 25 %)"} if {
	common.participates("1A")
	not applicant_eligible
}

# ATB-MIN-001: Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr.
minimum_size_area_ha := sum([common.area(p) | some p in common.parcels; object.get(p, "in_austria", true)])

default minimum_farm_size_met := false

minimum_farm_size_met if object.get(oepul, "protected_cultivation_area_ha", 0) >= common.tables.o6_1a_minimum_farm_size.protected_cultivation_ha

minimum_farm_size_met if minimum_size_area_ha >= common.tables.o6_1a_minimum_farm_size.agricultural_area_ha

first_oepul_year := object.get(oepul, "first_oepul_year", contract_start_year)

violations contains {"rule_id": "ATB-MIN-001", "subject": "farm", "message": "Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr nicht erreicht (0,50 ha geschützter Anbau oder 1,50 ha)"} if {
	common.year == first_oepul_year
	not minimum_farm_size_met
}

# ATB-LAGE-001: Geförderte Flächen müssen in Österreich liegen.
violations contains {"rule_id": "ATB-LAGE-001", "subject": common.parcel_id(p), "message": "Fläche außerhalb Österreichs ist nicht förderfähig und wird nicht berücksichtigt"} if {
	some p in common.parcels
	object.get(p, "in_austria", true) == false
}

# ATB-WECHSEL-001: Umwandlung UBB -> Biologische Wirtschaftsweise bis spätestens 31.12.2025 ohne Rückzahlung.
conversion_to_bio_without_repayment if {
	c := object.get(common.ubb, "conversion_to_bio_date", null)
	c != null
	c <= "2025-12-31"
}

# ATB-UEB-001: Maßnahmenübernahme bis 15.04. (2023 und 2028: 17.04.), max. 50 % Ausweitung.
takeover_deadline(y) := sprintf("%d-%s", [y, md]) if {
	md := object.get(common.tables.o6_1a_takeover_deadlines.special_years, sprintf("%d", [y]), common.tables.o6_1a_takeover_deadlines.default_month_day)
}

violations contains {"rule_id": "ATB-UEB-001", "subject": "farm", "message": "Maßnahmenübernahme nach der Frist (15.04. bzw. 17.04.) beantragt"} if {
	t := object.get(common.ubb, "takeover", null)
	t != null
	t.application_date > takeover_deadline(common.date_year(t.application_date))
}

violations contains {"rule_id": "ATB-UEB-002", "subject": "farm", "message": "Maßnahmenübernahme führt zu einer Ausweitung auf andere Flächen um mehr als 50 %"} if {
	t := object.get(common.ubb, "takeover", null)
	t != null
	t.additional_area_ha > t.taken_over_area_ha * common.tables.o6_1a_takeover_deadlines.max_extension_share
}

violations contains {"rule_id": "ATB-UEB-003", "subject": "farm", "message": "Übernahme des Zuschlags Naturschutz-Monitoring nur bei Betriebsauflösung, -teilung oder -zusammenlegung"} if {
	t := object.get(common.ubb, "takeover", null)
	t != null
	object.get(t, "includes_monitoring", false)
	not object.get(t, "reason", "") in {"betriebsaufloesung", "betriebsteilung", "betriebszusammenlegung"}
}

# ATB-AUS-001 / SRL-VZ-002: Ausstieg vor Ende des Vertragszeitraums führt zur Rückforderung.
repayment_due_to_exit if {
	object.get(common.ubb, "exit_before_contract_end", false)
	not object.get(common.ubb, "exit_reason", "other") in {"loss_of_control", "conversion_to_bio", "revision_clause", "permanent_circumstances_recognized"}
}

# SRL-ZA-001: Fehlender Zahlungsantrag – keine Zahlung, Verpflichtung bleibt aufrecht;
# nach einem Jahr ohne Nachreichung endet die Verpflichtung mit Rückforderung.
default payment_application_missing := false

payment_application_missing if object.get(common.ubb, "payment_application_submitted", true) == false

obligation_ended_missing_application if {
	payment_application_missing
	object.get(common.ubb, "payment_application_overdue_more_than_one_year", false)
}

# SRL-AUSZ-003: Förderung kann unterbleiben, wenn der Auszahlungsbetrag 50 Euro nicht übersteigt.
payment_may_be_waived(amount) if amount <= 50
