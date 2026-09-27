# METADATA
# title: ÖPUL 2023 Naturschutz (18) – Teilnahme- und Zugangsvoraussetzungen
package oepul.o6_18.eligibility

import data.oepul.o6_18.lib

p := lib.params

# O618-ELIG-001: Projektbestätigung der für Naturschutz zuständigen Landesstelle ist Voraussetzung.
violations contains v if {
	some parcel in lib.nat_parcels
	not object.get(lib.pc(parcel), "present", false)
	v := {"rule_id": "O618-ELIG-001", "parcel_id": parcel.parcel_id, "message": "NAT-Schlag ohne Projektbestätigung der für Naturschutz zuständigen Stelle des Landes"}
}

# O618-ELIG-002: Mindestens ein Schlag je Teilnahmejahr nach den Vorgaben der Maßnahme.
violations contains v if {
	lib.participates("18")
	count(lib.nat_parcels) < p.min_participating_plots_per_year
	v := {"rule_id": "O618-ELIG-002", "parcel_id": null, "message": "Kein Schlag mit Code NAT im Teilnahmejahr beantragt"}
}

# O618-ELIG-003: Förderung nur für Acker- und Grünlandflächen (ohne Almen).
violations contains v if {
	some parcel in lib.nat_parcels
	not parcel.land_use in p.eligible_land_uses
	v := {"rule_id": "O618-ELIG-003", "parcel_id": parcel.parcel_id, "message": sprintf("Nutzungsart %v ist in Naturschutz nicht förderfähig (nur Acker/Grünland ohne Alm)", [parcel.land_use])}
}

# O618-ELIG-004: Maßnahmenantrag bis spätestens 31.12. vor Vertragsbeginn.
application_deadline := sprintf("%d-12-31", [lib.nat.contract_start_year - 1])

violations contains v if {
	app := object.get(lib.nat, "application_date", null)
	app != null
	app > application_deadline
	v := {"rule_id": "O618-ELIG-004", "parcel_id": null, "message": sprintf("Maßnahmenantrag %v nach Frist %v", [app, application_deadline])}
}

# O618-ELIG-005: Letzter Einstieg mit Förderjahr 2025 (Beantragung bis 31.12.2024).
violations contains v if {
	start := object.get(lib.nat, "contract_start_year", null)
	start != null
	start > p.contract.last_entry_year
	v := {"rule_id": "O618-ELIG-005", "parcel_id": null, "message": sprintf("Vertragsbeginn %d nach letztem Einstiegsjahr %d", [start, p.contract.last_entry_year])}
}

violations contains v if {
	start := object.get(lib.nat, "contract_start_year", null)
	start != null
	start < 2023
	v := {"rule_id": "O618-ELIG-005", "parcel_id": null, "message": "Vertragsbeginn vor ÖPUL 2023 nicht möglich"}
}

# O618-ELIG-006: Vertragszeitraum bis 31.12.2028; Dauer je Beginnjahr 6/5/4 Jahre.
contract_duration_years := opt.duration_years if {
	some opt in p.contract.start_options
	opt.start_year == lib.nat.contract_start_year
}

contract_end_date := p.contract.end_date

in_contract_period if {
	lib.nat.contract_start_year <= lib.year
	lib.year <= 2028
}

# O618-ELIG-007: Beantragung eines Schlages über Code NAT in der Feldstücksliste.
violations contains v if {
	some parcel in lib.parcels
	count(lib.auflagen_of(parcel)) > 0
	object.get(parcel, ["naturschutz", "applied_for_measure"], false)
	not lib.is_nat(parcel)
	v := {"rule_id": "O618-ELIG-007", "parcel_id": parcel.parcel_id, "message": "Schlag für Naturschutz vorgesehen, aber nicht mit Code NAT gekennzeichnet"}
}

# O618-ELIG-008: Für die Auszahlung muss eine Naturschutz-Referenzfläche vorhanden sein.
no_payment_parcels contains parcel.parcel_id if {
	some parcel in lib.nat_parcels
	not object.get(lib.ns(parcel), "reference_area_present", false)
}

# O618-ELIG-009: Regionaler Naturschutzplan – jährliche Teilnahmebestätigung zusätzlich zur Projektbestätigung.
regional_plan := object.get(lib.nat, "regional_plan", {})

regional_plan_eligible if {
	object.get(regional_plan, "applied", false)
	object.get(regional_plan, "participation_confirmation", false)
	some parcel in lib.nat_parcels
	object.get(lib.pc(parcel), "present", false)
}

violations contains v if {
	object.get(regional_plan, "applied", false)
	not object.get(regional_plan, "participation_confirmation", false)
	v := {"rule_id": "O618-ELIG-009", "parcel_id": null, "message": "Zuschlag Regionaler Naturschutzplan ohne jährliche Teilnahmebestätigung"}
}

# O618-ELIG-010: Zuschlag Regionaler Naturschutzplan vor Vertragsbeginn bis 31.12. beantragen; letzter Einstieg 2028 (Antrag bis 31.12.2027).
violations contains v if {
	app := object.get(regional_plan, "application_date", null)
	app != null
	app > p.regional_plan.last_application_date
	v := {"rule_id": "O618-ELIG-010", "parcel_id": null, "message": sprintf("Antrag Regionaler Naturschutzplan %v nach letzter Frist %v", [app, p.regional_plan.last_application_date])}
}

violations contains v if {
	app := object.get(regional_plan, "application_date", null)
	app != null
	app > sprintf("%d-12-31", [lib.year - 1])
	v := {"rule_id": "O618-ELIG-010", "parcel_id": null, "message": "Zuschlag Regionaler Naturschutzplan nicht bis 31.12. vor dem Förderjahr beantragt"}
}

# O618-ELIG-011: Automatische Verlängerung des Zuschlags, wenn nicht abgemeldet und Teilnahmebestätigung vorliegt.
regional_plan_renews_next_year if {
	object.get(regional_plan, "applied", false)
	not object.get(regional_plan, "deregistered", false)
	object.get(regional_plan, "participation_confirmation", false)
	lib.year < 2028
}

# O618-ELIG-012: Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr (0,50 ha geschützter Anbau oder 1,50 ha).
violations contains v if {
	object.get(input, ["farm", "oepul", "first_oepul_year"], null) == lib.year
	object.get(input, ["farm", "oepul", "protected_cultivation_area_ha"], 0) < p.min_farm_size_first_year.protected_cultivation_ha
	object.get(input, ["land", "total_area_ha"], 0) < p.min_farm_size_first_year.total_area_ha
	v := {"rule_id": "O618-ELIG-012", "parcel_id": null, "message": "Betriebsmindestgröße im ersten ÖPUL-Jahr nicht erreicht"}
}

# O618-ELIG-013: Förderwerbende Personen; Gebietskörperschaften bzw. Beteiligung > 25 % ausgeschlossen.
applicant := object.get(input, ["farm", "oepul", "applicant"], {})

violations contains v if {
	t := object.get(applicant, "type", null)
	t != null
	not t in p.applicant.eligible_types
	v := {"rule_id": "O618-ELIG-013", "parcel_id": null, "message": sprintf("Förderwerbende Person vom Typ %v für Naturschutz nicht zulässig", [t])}
}

violations contains v if {
	object.get(applicant, "public_share_percent", 0) > p.applicant.max_public_share_percent
	v := {"rule_id": "O618-ELIG-013", "parcel_id": null, "message": "Beteiligung von Gebietskörperschaften über 25 %"}
}

# O618-ELIG-014: Auflagen müssen in Anhang I definiert und im Antragsjahr gültig sein.
violations contains v if {
	some parcel in lib.nat_parcels
	some c in lib.auflagen_of(parcel)
	not lib.auflage_by_code[c]
	v := {"rule_id": "O618-ELIG-014", "parcel_id": parcel.parcel_id, "message": sprintf("Auflage %v ist nicht in Anhang I definiert", [c])}
}

violations contains v if {
	some parcel in lib.nat_parcels
	some c in lib.auflagen_of(parcel)
	lib.auflage_by_code[c]
	not lib.valid_in_year(c, lib.year)
	v := {"rule_id": "O618-ELIG-014", "parcel_id": parcel.parcel_id, "message": sprintf("Auflage %v ist im Antragsjahr %d nicht gültig", [c, lib.year])}
}

# O618-ELIG-015: GG-Auflagen (lange Wegzeit) nur für Bergmähder und begründete Ausnahmefälle.
violations contains v if {
	some parcel in lib.nat_parcels
	some c in lib.auflagen_of(parcel)
	lib.auflage_by_code[c].bergmahd_or_justified_exception_only
	not object.get(lib.ns(parcel), "is_bergmahd", false)
	not object.get(lib.ns(parcel), "gg_exception_justified", false)
	v := {"rule_id": "O618-ELIG-015", "parcel_id": parcel.parcel_id, "message": sprintf("Auflage %v nur für Bergmähder oder begründete Ausnahmefälle", [c])}
}

# O618-ELIG-016: HG01/HG02 nur auf gemeldeten und im AMA-GIS eingezeichneten Flächen.
violations contains v if {
	some parcel in lib.nat_parcels
	some c in lib.auflagen_of(parcel)
	lib.auflage_by_code[c].habitat_layer_required
	not object.get(lib.ns(parcel), "habitat_layer_registered", false)
	v := {"rule_id": "O618-ELIG-016", "parcel_id": parcel.parcel_id, "message": sprintf("Auflage %v nur auf von Landesdienststellen gemeldeten, im GIS eingezeichneten Flächen", [c])}
}

# O618-ELIG-017: Flächengrößenbedingungen einzelner Auflagen (GD01 bis 1 ha, GD02 < 0,30 ha, AG02 < 0,50 ha).
violations contains v if {
	some parcel in lib.nat_parcels
	some c in lib.auflagen_of(parcel)
	m := lib.auflage_by_code[c].max_plot_area
	m != null
	area_exceeds(lib.area(parcel), m)
	v := {"rule_id": "O618-ELIG-017", "parcel_id": parcel.parcel_id, "message": sprintf("Schlaggröße %v ha unzulässig für Auflage %v", [lib.area(parcel), c])}
}

area_exceeds(a, m) if {
	m.strict
	a >= m.max_ha
}

area_exceeds(a, m) if {
	not m.strict
	a > m.max_ha
}

# O618-ELIG-019: Geförderte Flächen müssen in Österreich liegen.
violations contains v if {
	some parcel in lib.nat_parcels
	object.get(parcel, ["oepul", "located_in_austria"], true) == false
	v := {"rule_id": "O618-ELIG-019", "parcel_id": parcel.parcel_id, "message": "Fläche liegt nicht in Österreich"}
}
