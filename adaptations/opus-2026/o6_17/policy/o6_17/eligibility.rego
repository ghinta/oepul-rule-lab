# Modul:
#   o6_17 – Zugangs- und Fördervoraussetzungen
package oepul.o6_17

contract_start_year := object.get(o617, "contract_start_year", null)

first_participation_year if application_year == contract_start_year

first_year_min := cfg.general.first_year_minimums

grassland_share := grassland_area_ha / utilised_area_excl_alpine_ha if utilised_area_excl_alpine_ha > 0

combination_obligation_met if ubb_or_bio_participation

# Betriebsmindestgröße im 1. ÖPUL-Teilnahmejahr (SRL 1.6.1)
first_oepul_year if application_year == object.get(input, ["oepul", "first_oepul_year"], null)

farm_minimum_size_met if {
	object.get(input, ["land", "protected_cultivation_area_ha"], 0) >= cfg.general.farm_minimum_size_first_oepul_year.min_protected_cultivation_ha
}

farm_minimum_size_met if {
	object.get(input, ["land", "total_area_ha"], 0) >= cfg.general.farm_minimum_size_first_oepul_year.min_agricultural_area_ha
}

applicant := object.get(input, ["oepul", "applicant"], {})

applicant_type_eligible if object.get(applicant, "applicant_type", "") in {t | some t in cfg.lists.eligible_applicant_types}

public_body_share_ok if object.get(applicant, "public_body_share", 0) <= cfg.lists.public_body_max_share

contract_period_row := row if {
	some row in cfg.general.contract_periods
	row.start_year == contract_start_year
}

entry_application_deadline := sprintf("%d-12-31", [contract_start_year - 1]) if is_number(contract_start_year)

entry_application_timely if {
	d := object.get(o617, "measure_application_date", null)
	is_string(d)
	d <= entry_application_deadline
}

access_violations contains v if {
	not combination_obligation_met
	v := {"rule_id": "O6_17-MB-3.2-COMBINATION-OBLIGATION", "message": "Keine zeitgleiche Teilnahme an UBB, BIO oder BIO-Teilbetrieb"}
}

access_violations contains v if {
	first_participation_year
	grassland_area_ha < first_year_min.min_grassland_ha
	v := {"rule_id": "O6_17-MB-3.3-MIN-GRASSLAND", "message": sprintf("Grünlandfläche im 1. Teilnahmejahr %v ha < %v ha", [grassland_area_ha, first_year_min.min_grassland_ha])}
}

access_violations contains v if {
	first_participation_year
	not grassland_share_sufficient
	v := {"rule_id": "O6_17-MB-3.3-MIN-GRASSLAND-SHARE", "message": "Grünlandanteil an der LN (ohne Almweideflächen) im 1. Teilnahmejahr unter 40 %"}
}

grassland_share_sufficient if grassland_share >= first_year_min.min_grassland_share_of_utilised_area_excl_alpine

access_violations contains v if {
	first_participation_year
	not is_livestock_farm
	v := {"rule_id": "O6_17-MB-3.4-LIVESTOCK-FIRST-YEAR", "message": "Eigenschaft als tierhaltender Betrieb (>= 0,30 RGVE/ha Futterfläche) im 1. Teilnahmejahr nicht erfüllt"}
}

access_violations contains v if {
	first_oepul_year
	not farm_minimum_size_met
	v := {"rule_id": "O6_17-AT-5.3-FARM-MIN-SIZE", "message": "Betriebsmindestgröße im 1. ÖPUL-Teilnahmejahr nicht erreicht"}
}

access_violations contains v if {
	first_participation_year
	not contract_period_row
	v := {"rule_id": "O6_17-MB-7-LAST-ENTRY", "message": "Vertragsbeginn nur 2023, 2024 oder 2025 möglich (letzter Einstieg Förderjahr 2025)"}
}

access_violations contains v if {
	first_participation_year
	not entry_application_timely
	v := {"rule_id": "O6_17-MB-7-APPLICATION-DEADLINE", "message": "Maßnahmenantrag nicht bis 31.12. vor Vertragsbeginn gestellt"}
}

access_violations contains v if {
	not applicant_type_eligible
	v := {"rule_id": "O6_17-AT-5.2-APPLICANT-TYPE", "message": "Förderwerbende Person ist keine zulässige Personenkategorie"}
}

access_violations contains v if {
	not public_body_share_ok
	v := {"rule_id": "O6_17-AT-5.2-PUBLIC-BODY", "message": "Beteiligung von Gebietskörperschaften über 25 % – für o6_17 nicht förderfähig"}
}

access_violations contains v if {
	object.get(applicant, "is_active_farmer", true) == false
	v := {"rule_id": "O6_17-SRL-1.4-ACTIVE-FARMER", "message": "Förderwerbende Person ist kein aktiver Landwirt"}
}

# 1. Verpflichtungsjahr: bei Nichterfüllung kommt kein Vertrag zustande (SRL 1.12.1.1)
contract_established if {
	first_participation_year
	count(access_violations) == 0
}

# Ab dem 2. Verpflichtungsjahr: bei Nichterfüllung keine Prämie im betroffenen Jahr (SRL 1.12.1.1)
premium_blocked_by_access_conditions if count(access_violations) > 0
