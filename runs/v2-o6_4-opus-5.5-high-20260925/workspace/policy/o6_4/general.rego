# Allgemeine Teilnahmebedingungen, soweit für o6_4 maßgeblich
# (Allgemeine Bedingungen 5.2, 5.3, 7.1, 7.2, 8.2; SRL 1.4, 1.6, 1.7.2, 1.12).
package oepul.o6_4

# GEN-APPL-001: förderwerbende Personen; Gebietskörperschaften (Beteiligung > 25 %) für o6_4 ausgeschlossen;
# aktive Landwirtin/aktiver Landwirt, Bewirtschaftung im eigenen Namen und auf eigene Rechnung.
applicant_eligible if {
	participation.applicant_type in {t | some t in params.applicants.eligible_applicant_types}
	object.get(participation, "public_body_share_percent", 0) <= params.applicants.max_public_body_share_percent
	participation.is_active_farmer == true
	participation.manages_in_own_name_and_account == true
}

# GEN-MIN-001/-002: Betriebsmindestgröße nur im ersten ÖPUL-Teilnahmejahr.
minimum_farm_size_met if not first_participation_year

minimum_farm_size_met if {
	first_participation_year
	object.get(participation, "protected_cultivation_area_ha", 0) >= params.minimum_farm_size_first_year.protected_cultivation_min_ha
}

minimum_farm_size_met if {
	first_participation_year
	object.get(input.land, "total_area_ha", 0) >= params.minimum_farm_size_first_year.agricultural_area_min_ha
}

first_participation_year if participation.first_oepul_participation_year == year

# GEN-AREA-RED-001: Toleranz für Flächenverringerungen: bis 5 % des Vorjahres, höchstens 5 ha,
# jedenfalls 0,50 ha pro Jahr.
area_reduction_tolerance_ha(previous_ha) := max([
	params.area_reduction_tolerance.always_allowed_ha_per_year,
	min([previous_ha * params.area_reduction_tolerance.max_share_of_previous_year, params.area_reduction_tolerance.max_ha_per_year]),
])

# Rückzahlungspflichtige Differenzfläche (gesamte Differenz bei Überschreitung, sonst 0).
# exempt_ha: Verlust der Verfügungsgewalt bzw. jedenfalls zulässige Umwandlungen.
area_reduction_repayment_ha(previous_ha, current_ha, exempt_ha) := d if {
	d := (previous_ha - current_ha) - exempt_ha
	d > area_reduction_tolerance_ha(previous_ha)
} else := 0

# GEN-AREA-ADD-001: Flächenzugänge 2024 und 2025 zur Gänze prämienfähig; danach max. +50 %
# auf Basis 2025, eine Vergrößerung um bis zu 5 ha jedenfalls zulässig.
premium_eligible_area_limit_ha(area_2025_ha, yr) := l if {
	not yr in {y | some y in params.area_addition_limits.fully_eligible_years}
	yr > params.area_addition_limits.base_year
	l := area_2025_ha + max([
		area_2025_ha * params.area_addition_limits.max_increase_share_of_base,
		params.area_addition_limits.increase_always_allowed_ha,
	])
}

area_addition_excess_ha(current_ha, area_2025_ha, yr) := max([0, current_ha - premium_eligible_area_limit_ha(area_2025_ha, yr)]) if {
	yr > params.area_addition_limits.base_year
} else := 0

# GEN-SANC-001: Sanktionsstufen; ab 2027 statt Verwarnung Einbehalt von 1 %.
sanction_reduction_percent(stage, yr) := s.retention_percent_from_2027 if {
	some s in params.sanction_stages.rows
	s.stage == stage
	s.type == "warning"
	yr >= params.sanction_stages.warning_replaced_by_retention_from_year
} else := s.reduction_percent if {
	some s in params.sanction_stages.rows
	s.stage == stage
}

# Ausschluss bei zweimaliger 100 %-Kürzung im Vertragszeitraum.
excluded_from_measure if {
	object.get(measure_record, "full_reductions_100pct_count", 0) >= params.sanction_stages.exclusion_after_full_reductions
}

# SRL-SANC-ACCESS-001: Nichterfüllung von Zugangsvoraussetzungen bei mehrjährigen Maßnahmen.
access_failure_consequence(commitment_year) := "no_contract" if {
	commitment_year == 1
} else := "no_premium_in_year"

# GEN-DUR-002: unterjährige Flächenweitergabe ohne Weiterführung bis Jahresende → keine Prämie (Code OP).
violation contains {"rule_id": "GEN-DUR-002", "parcel_id": pid, "message": "Fläche unterjährig weitergegeben ohne Weiterführung der Verpflichtung – Code OP erforderlich"} if {
	some pid, p in enrolled_parcels
	object.get(p, "transferred_mid_year_without_continuation", false) == true
	not "OP" in object.get(p, "oepul_codes", [])
}

# SRL-FM-002: dauerhafte flächen-/bewirtschaftungsverändernde Umstände – Prämie im Eintrittsjahr nur,
# wenn Eintritt nach dem 15.04. (bzw. höhere Gewalt/außergewöhnliche Umstände).
premium_in_year_of_permanent_circumstance(_, force_majeure) if force_majeure == true

premium_in_year_of_permanent_circumstance(event_date, _) if {
	yr := date_parts(event_date)[0]
	date_ns(event_date) > date_ns(sprintf("%d-04-15", [yr]))
}

# O6_4-XM-001/-002/-003: Bergmähder zählen nicht zur gemähten Grünlandbezugsfläche anderer Maßnahmen
# (UBB/BIO-Biodiversitätsflächen, Heuwirtschaft-Mindestfläche, Zuschlag artenreiches Grünland).
grassland_basis_excluding_mountain_meadows_ha := sum([p.area_ha |
	some p in input.land.parcels
	p.land_use == "grassland"
	not object.get(p, ["mountain_meadow", "declared_as_mountain_meadow"], false) == true
])
