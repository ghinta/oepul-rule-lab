# Allgemeine Teilnahmebedingungen ÖPUL 2023, SRL Allgemeiner Teil, GSP-AV, NAPV und Meldungen 2026 (o6_9)
package oepul.o6_9

farm := object.get(input, "farm", {})

gc := tables.general_conditions

measure_requested if count(measure) > 0

# O69-GEN-001: förderwerbende Personen; Gebietskörperschaften nicht förderfähig (Maßnahme 9 ist keine Ausnahme).
applicant_type := object.get(farm, "applicant_type", "natural_person")

applicant_type_row := row if {
	some row in gc.eligible_applicant_types
	row.applicant_type == applicant_type
}

public_body_exception_applies if {
	some m in gc.public_body_exception_measures
	m.code == measure_codes.srl_measure
}

applicant_eligible if {
	applicant_type_row.max_public_body_share_percent == null
}

applicant_eligible if {
	applicant_type_row.max_public_body_share_percent != null
	object.get(farm, "public_body_share_percent", 0) <= applicant_type_row.max_public_body_share_percent
}

applicant_eligible if {
	applicant_type == "public_body"
	public_body_exception_applies
}

# O69-GEN-002: Betrieb im eigenen Namen und auf eigene Rechnung, aktiver Landwirt, landwirtschaftliche Tätigkeit.
applicant_status_unmet contains "own_name_and_account" if is_false(farm, "manages_in_own_name_and_account")

applicant_status_unmet contains "active_farmer" if is_false(farm, "is_active_farmer")

applicant_status_unmet contains "agricultural_activity" if is_false(farm, "exercises_agricultural_activity")

# O69-GEN-003 / O69-GEN-004: Betriebsmindestgröße nur im ersten ÖPUL-Teilnahmejahr.
first_oepul_year if object.get(farm, "oepul_first_participation_year", 0) == year

minimum_farm_size_met if not first_oepul_year

minimum_farm_size_met if {
	first_oepul_year
	object.get(input, ["land", "protected_cultivation_area_ha"], 0) >= gc.minimum_farm_size_first_year.protected_cultivation_ha
}

minimum_farm_size_met if {
	first_oepul_year
	total_area_ha >= gc.minimum_farm_size_first_year.agricultural_area_ha
}

# O69-GEN-005: Flächen in Österreich, Tiere in Österreich gehalten.
animals_abroad := [i | some i, g in species_groups; is_false(g, "kept_in_austria")]

# O69-GEN-006 / O69-NOT-001 / O69-NOT-002: Mindestbewirtschaftung auf Ackerflächen (Ernte >= 85 %), Dürre 2026.
drought_district_match(state, district) if {
	some row in tables.drought_2026_districts.rows
	row.federal_state == state
	row.district in {"*", district}
}

parcel_region(p) := [object.get(p, "federal_state", object.get(farm, ["region", "federal_state"], "")), object.get(p, "district", object.get(farm, ["region", "district"], ""))]

harvest_obligation_waived_2026(p) if {
	year == tables.drought_2026_districts.year
	[state, district] := parcel_region(p)
	drought_district_match(state, district)
	is_true(p, "no_harvestable_crop_due_to_drought")
	is_true(p, "late_summer_or_autumn_harvest_crop")
}

minimum_management_unmet(p) if {
	p.land_use == "arable"
	not object.get(p, ["crop", "crop_category"], "") == "fallow"
	object.get(p, "harvest_share", 1) < 0.85
	not harvest_obligation_waived_2026(p)
	not is_true(p, "force_majeure_recognised")
}

# O69-GEN-008: Code OP – keine ÖPUL-Prämie; O69-GEN-007: nicht förderfähige Flächen.
op_coded(p) if {
	some c in object.get(p, "oepul_codes", [])
	c in {"OP", "OP9", "VF"}
}

parcel_premium_eligible(p) if {
	not op_coded(p)
	not minimum_management_unmet(p)
	not is_true(p, "non_eligible_area")
	not is_true(p, "in_national_park")
	not is_false(p, "located_in_austria")
}

# O69-GEN-017 / O69-SRL-009: Einzelflächenkombination gemäß Anhang L.
non_combinable_measures := {row.other_measure | some row in tables.combination_table.rows; not row.combinable}

combination_conflicts contains {"parcel_id": p.parcel_id, "measure": m} if {
	some p in parcels
	"9" in object.get(p, "oepul_measures", [])
	some m in object.get(p, "oepul_measures", [])
	m in non_combinable_measures
}

combination_conflicts contains {"parcel_id": p.parcel_id, "measure": "GA_pot_substrate"} if {
	some p in parcels
	"9" in object.get(p, "oepul_measures", [])
	is_true(p, "protected_cultivation_pot_or_substrate")
}

# O69-GEN-024b: Obergrenze für Flächenzahlungen je Schlag.
area_payment_cap(scope, y) := row.cap_eur_per_ha if {
	some row in gc.area_payment_caps
	row.scope == scope
	y >= row.year_from
	rate_row_open_or_covers(row, y)
}

area_cap_exceeded_parcels contains p.parcel_id if {
	some p in parcels
	has_value(p, "area_payments_eur_per_ha")
	p.area_payments_eur_per_ha > area_payment_cap("general", year)
}

# O69-GEN-026: höhere Gewalt binnen drei Wochen melden.
force_majeure := object.get(measure, "force_majeure", {})

force_majeure_notified_in_time if {
	has_value(force_majeure, "able_to_notify_date")
	has_value(force_majeure, "notified_date")
	date_ns(force_majeure.notified_date) - date_ns(force_majeure.able_to_notify_date) <= ((gc.force_majeure_notification_weeks * 7) * 24) * 3600000000000
}

# O69-NAPV-002 / O69-NAPV-003: Abgleich der Ausbringungsaufzeichnungen mit NAPV-Verbotszeiträumen und Bodenzustand.
in_period(md, start_md, end_md) if {
	start_md > end_md
	md >= start_md
}

in_period(md, start_md, end_md) if {
	start_md > end_md
	md <= end_md
}

record_land_scope(r) := "grassland_and_arable_forage" if object.get(r, "land_use", "") == "grassland"

record_land_scope(r) := "grassland_and_arable_forage" if {
	object.get(r, "land_use", "") == "arable"
	is_true(r, "arable_forage")
}

record_land_scope(r) := "arable_excluding_forage" if {
	object.get(r, "land_use", "") == "arable"
	not is_true(r, "arable_forage")
}

napv_ban_conflicts contains i if {
	some i, r in application_records
	has_value(r, "date")
	scope := record_land_scope(r)
	some period in tables.fertilizable_area.napv_application_ban_periods
	period.land_scope == scope
	in_period(month_day(r.date), napv_ban_start(period, r), napv_ban_end(period, r))
}

napv_ban_start(period, r) := period.ban_start_month_day if not is_true(r, "napv_late_application_exception")

napv_ban_start(period, r) := "11-01" if {
	is_true(r, "napv_late_application_exception")
	period.extended_until_month_day != null
}

napv_ban_start(period, r) := period.ban_start_month_day if {
	is_true(r, "napv_late_application_exception")
	period.extended_until_month_day == null
}

napv_ban_end(period, r) := period.early_end_month_day if {
	is_true(r, "napv_early_demand_crop")
	period.early_end_month_day != null
}

napv_ban_end(period, r) := period.ban_end_month_day if not napv_early_end_applies(period, r)

napv_early_end_applies(period, r) if {
	is_true(r, "napv_early_demand_crop")
	period.early_end_month_day != null
}

napv_soil_conflicts contains i if {
	some i, r in application_records
	object.get(r, "soil_state", "normal") in {"frozen", "water_saturated", "flooded", "snow_covered"}
}

violations contains {"rule_id": "O69-GEN-001", "message": "Förderwerbende Person kommt für die Maßnahme nicht in Betracht"} if {
	measure_requested
	not applicant_eligible
}

violations contains {"rule_id": "O69-GEN-002", "message": sprintf("Persönliche Fördervoraussetzung nicht erfüllt: %v", [c])} if {
	measure_requested
	some c in applicant_status_unmet
}

violations contains {"rule_id": "O69-GEN-003", "message": "Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr nicht erreicht"} if {
	measure_requested
	not minimum_farm_size_met
}

violations contains {"rule_id": "O69-GEN-005", "message": "Flächen außerhalb Österreichs werden nicht gefördert"} if {
	measure_requested
	is_false(farm, "all_areas_in_austria")
}

violations contains {"rule_id": "O69-GEN-005", "message": sprintf("Tiergruppe %d nicht in Österreich gehalten – nicht anrechenbar", [i])} if {
	measure_requested
	some i in animals_abroad
}

violations contains {"rule_id": "O69-GEN-017", "message": sprintf("Schlag %v: Maßnahme 9 nicht kombinierbar mit %v", [c.parcel_id, c.measure])} if {
	some c in combination_conflicts
}

violations contains {"rule_id": "O69-GEN-028", "message": "Kontrolle verweigert oder verhindert – Antrag abzulehnen, Verträge beenden und rückabwickeln"} if {
	is_true(measure, "controls_refused")
	not is_true(force_majeure, "occurred")
}

violations contains {"rule_id": "O69-GEN-026", "message": "Höhere Gewalt nicht binnen drei Wochen gemeldet"} if {
	is_true(force_majeure, "occurred")
	not force_majeure_notified_in_time
}

violations contains {"rule_id": "O69-GEN-009", "message": "Förderverpflichtungen nicht während der gesamten Verpflichtungsdauer erfüllt"} if {
	measure_requested
	not commitment_fulfilled_whole_year
}

violations contains {"rule_id": "O69-GEN-036", "message": "Leistung wird bereits aus anderem öffentlichen Titel gefördert oder ist gesetzlich/behördlich vorgeschrieben"} if {
	is_true(measure, "same_service_funded_or_prescribed_otherwise")
}

warnings contains {"rule_id": "O69-NAPV-002", "message": sprintf("Aufzeichnung %d: Ausbringung im NAPV-Verbotszeitraum", [i])} if {
	some i in napv_ban_conflicts
}

warnings contains {"rule_id": "O69-NAPV-003", "message": sprintf("Aufzeichnung %d: Ausbringung auf gefrorenen, wassergesättigten, überschwemmten oder schneebedeckten Boden", [i])} if {
	some i in napv_soil_conflicts
}

warnings contains {"rule_id": "O69-GEN-024", "message": "Auszahlungsbetrag überschreitet 50 € nicht – von der Gewährung kann abgesehen werden"} if {
	measure_requested
	below_minimum_payment
}

warnings contains {"rule_id": "O69-GEN-024b", "message": sprintf("Schlag %v: Obergrenze für Flächenzahlungen überschritten", [pid])} if {
	some pid in area_cap_exceeded_parcels
}

warnings contains {"rule_id": "O69-GEN-006", "message": sprintf("Schlag %v: Ernte auf weniger als 85 %% – keine Prämie auf diesem Schlag", [p.parcel_id])} if {
	participates_pig_feeding
	some p in parcels
	minimum_management_unmet(p)
}

warnings contains {"rule_id": "O69-NOT-001", "message": sprintf("Schlag %v: Ernteverpflichtung 2026 dürrebedingt automatisch als höhere Gewalt anerkannt", [p.parcel_id])} if {
	some p in parcels
	harvest_obligation_waived_2026(p)
}

# Pflichten (Dokumentations-, Melde- und Aufbewahrungspflichten) für teilnehmende Betriebe.
obligations contains {"rule_id": "O69-MB-016", "obligation": "Chronologische, schlagbezogene Aufzeichnungen über Menge, Art, Zeitpunkt und Verfahren der bodennahen Ausbringung führen"} if {
	application_volume_total > 0
}

obligations contains {"rule_id": "O69-MB-023", "obligation": "Aufzeichnungen über Datum und Menge der Gülleseparierung führen"} if {
	separated_volume_claimed > 0
}

obligations contains {"rule_id": "O69-MB-019", "obligation": "Einsatz gemeinschaftlicher Geräte idealerweise mit Kubikmeter- bzw. Einsatzstundenzähler im Betriebsbuch dokumentieren (Empfehlung)"} if {
	shared_equipment_in_use
}

shared_equipment_in_use if is_true(object.get(application, "shared_equipment", {}), "used")

shared_equipment_in_use if is_true(object.get(separation, "shared_equipment", {}), "used")

obligations contains {"rule_id": "O69-MB-039", "obligation": "Ausstieg der AMA online über eAMA im Rahmen des aktuellen Mehrfachantrages bekannt geben"} if {
	measure_requested
}

obligations contains {"rule_id": "O69-GEN-016", "obligation": "Förderverpflichtungen bis zum Ausstieg einhalten"} if {
	measure_requested
}

obligations contains {"rule_id": "O69-GEN-027", "obligation": sprintf("Förderrelevante Unterlagen bis Ende %d aufbewahren (4 Jahre ab Ende des Kalenderjahres der Zahlung)", [year + gc.records_retention_years_one_year_measures])} if {
	measure_requested
}

obligations contains {"rule_id": "O69-GEN-032", "obligation": "Änderungen der tatsächlichen oder rechtlichen Verhältnisse unverzüglich melden; Betriebsübertragung binnen vier Wochen anzeigen"} if {
	measure_requested
}

obligations contains {"rule_id": "O69-GEN-037", "obligation": "Konditionalität (Klima/Umwelt, öffentliche Gesundheit, Pflanzengesundheit, Tierwohl) und soziale Konditionalität einhalten"} if {
	measure_requested
}

obligations contains {"rule_id": "O69-GEN-028", "obligation": "Kontrollen zulassen, Auskunftsperson stellen und förderrelevante Unterlagen vorlegen"} if {
	measure_requested
}

obligations contains {"rule_id": "O69-MB-029", "obligation": "Rezepturen mit Rohproteingehalt je kg Futtermittel (88 % TM) vorhalten; Phasenfütterung bei VOK plausibel machen"} if {
	participates_pig_feeding
}
