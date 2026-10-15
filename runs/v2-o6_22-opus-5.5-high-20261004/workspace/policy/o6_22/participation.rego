# Modul: o6_22 – Teilnahme, Beantragung, Vertrag und Zugangsvoraussetzungen
package oepul.o6_22

# ---------------------------------------------------------------------------
# Beantragung (O622-APP-001, O622-APP-002, O622-APP-003, O622-APP-007)
# ---------------------------------------------------------------------------

# O622-APP-001: Beantragung im Maßnahmenantrag bis spätestens 31. Dezember vor
# dem ersten Förderjahr.
application_in_time(app) if {
	app.applied_on <= year_date(app.first_year - 1, params.application_deadline_mm_dd)
}

# O622-APP-002 / O622-APP-003: letzter Einstieg Kategorien 2027, Zuschläge 2028.
application_entry_year_allowed(app) if {
	application_code_row(app.code).kind == "category"
	app.first_year <= params.last_category_entry_year
}

application_entry_year_allowed(app) if {
	application_code_row(app.code).kind == "surcharge"
	app.first_year <= params.last_surcharge_entry_year
}

# O622-FMK-001: Festmistkompostierung erst ab dem Antragsjahr 2025.
application_surcharge_year_allowed(app) if app.code != "festmistkompostierung"

application_surcharge_year_allowed(app) if {
	app.code == "festmistkompostierung"
	app.first_year >= params.festmist_surcharge_from_year
}

application_valid(app) if {
	application_code_row(app.code)
	application_in_time(app)
	application_entry_year_allowed(app)
	application_surcharge_year_allowed(app)
}

# O622-EXIT-002: Abmeldung im Zeitraum 1.1.–31.12. -> im Förderjahr nicht mehr gültig.
withdrawn_effective(app) if {
	w := object.get(app, "withdrawn_on", null)
	is_string(w)
	w <= year_date(year, params.commitment_end_mm_dd)
}

# O622-CONTRACT-002: einjährige Verträge verlängern sich automatisch.
application_active(app) if {
	app.first_year <= year
	not withdrawn_effective(app)
	application_valid(app)
}

active_codes := {app.code | some app in applications; application_active(app)}

active_categories := {c |
	some code in active_codes
	row := application_code_row(code)
	row.kind == "category"
	c := row.category
}

# ---------------------------------------------------------------------------
# GVE je Kategorie und Mindestteilnahme (O622-ELIG-001, O622-PREM-002)
# ---------------------------------------------------------------------------

category_gve[c] := r4(sum([group_gve_eligible(g) |
	some g in pig_groups
	group_measure_category(g) == c
])) if {
	some c in active_categories
}

participating_gve := r4(sum([gve | some c in active_categories; gve := category_gve[c]]))

# O622-ELIG-001: mindestens 2,00 GVE in Summe über alle beantragten Kategorien.
min_participation_met if participating_gve >= params.min_participation_gve

# O622-CONTRACT-003: Mindestteilnahme nicht eingehalten -> Vertrag erlischt.
measure_contract_lapsed if {
	count(active_categories) > 0
	not min_participation_met
}

# O622-CONTRACT-005: kein prämienfähiges Tier in einer Kategorie -> Vertrag der
# Kategorie erlischt automatisch.
lapsed_categories contains c if {
	some c in active_categories
	category_gve[c] <= 0
}

# ---------------------------------------------------------------------------
# Tiergesundheitsdienst (O622-TGD-001, O622-TGD-002, O622-TGD-003)
# ---------------------------------------------------------------------------

# Förderbare Schweine am Betrieb (alle prämienfähigen Tierliste-Kategorien).
farm_eligible_pig_gve := r4(sum([group_gve_declared(g) | some g in pig_groups]))

animal_health_service_required if farm_eligible_pig_gve > params.animal_health_service_threshold_gve

ahs := object.get(pig_farm, "animal_health_service", {})

ahs_required_start(y) := year_date(y, params.animal_health_service_2023_start_mm_dd) if y == 2023

ahs_required_start(y) := year_date(y, params.commitment_start_mm_dd) if y != 2023

animal_health_service_ok if {
	ahs.participates == true
	ahs.participation_from <= ahs_required_start(year)
	ahs.participation_to >= year_date(year, params.commitment_end_mm_dd)
}

# ---------------------------------------------------------------------------
# Förderwerbende Person, Betriebsmindestgröße, Übernahme
# ---------------------------------------------------------------------------

applicant := object.get(input, ["farm", "applicant"], {})

applicant_type_row(t) := row if {
	some row in general.eligible_applicant_types
	row.type == t
}

# O622-GEN-002: Gebietskörperschaften nicht förderwerbend (o6_22 ist keine Ausnahme);
# juristische Personen/Personenvereinigungen nur bis 25 % öffentlicher Beteiligung.
applicant_type_ok if {
	row := applicant_type_row(applicant.type)
	row.public_share_limit_applies == false
}

applicant_type_ok if {
	row := applicant_type_row(applicant.type)
	row.public_share_limit_applies == true
	object.get(applicant, "public_authority_share_percent", 0) <= params.public_authority_max_share_percent
}

# O622-GEN-003: aktiver Landwirt und landwirtschaftliche Tätigkeit.
applicant_ok if {
	applicant_type_ok
	object.get(applicant, "is_active_farmer", false) == true
}

# O622-GEN-004: Betriebsmindestgröße nur im ersten ÖPUL-Teilnahmejahr.
first_oepul_year if object.get(input, ["farm", "first_oepul_participation_year"], 0) == year

farm_min_size_ok if not first_oepul_year

farm_min_size_ok if {
	first_oepul_year
	object.get(input, ["land", "protected_cultivation_area_ha"], 0) >= params.farm_min_size_protected_cultivation_ha
}

farm_min_size_ok if {
	first_oepul_year
	object.get(input, ["land", "total_area_ha"], 0) >= params.farm_min_size_agricultural_area_ha
}

takeover := object.get(measure_input, "takeover", {"is_takeover": false})

# O622-GEN-006: Übernahme nur in Einzelfällen (Betriebsauflösung, -teilung,
# -zusammenlegung); Tiere und Flächen vom selben Vorbetrieb.
takeover_ok if object.get(takeover, "is_takeover", false) == false

takeover_ok if {
	takeover.is_takeover == true
	takeover.reason in general.takeover_individual_case_reasons
	takeover.animals_and_areas_from_same_predecessor == true
}

# ---------------------------------------------------------------------------
# Kategorienzuordnung Eber (O622-CAT-004, O622-CAT-005)
# ---------------------------------------------------------------------------

# Jungeber zwischen 32 und 50 kg und nicht im Deckeinsatz befindliche Eber über
# 50 kg sind Jung- und Mastschweine; Zuchteber im Deckeinsatz sind nicht prämienfähig.
boar_measure_category(weight_kg, used_for_mating) := "mastschweine" if {
	weight_kg >= 32
	weight_kg < 50
	is_boolean(used_for_mating)
}

boar_measure_category(weight_kg, used_for_mating) := "mastschweine" if {
	weight_kg >= 50
	used_for_mating == false
}

boar_measure_category(weight_kg, used_for_mating) := "nicht_praemienfaehig" if {
	weight_kg >= 50
	used_for_mating == true
}

# O622-CAT-003 / O622-CAT-006: Jungsauen ab 50 kg erst ab dem Decken in der
# Kategorie Zuchtsauen; davor (und ausgemerzte Zuchttiere) Jung- und Mastschweine.
gilt_or_culled_measure_category(weight_kg, mated, culled) := "zuchtsauen" if {
	weight_kg >= 50
	mated == true
	culled == false
}

gilt_or_culled_measure_category(weight_kg, mated, culled) := "mastschweine" if {
	weight_kg >= 32
	mated == false
	is_boolean(culled)
}

gilt_or_culled_measure_category(weight_kg, mated, culled) := "mastschweine" if {
	weight_kg >= 32
	is_boolean(mated)
	culled == true
}

# ---------------------------------------------------------------------------
# Verstöße
# ---------------------------------------------------------------------------

violations contains {
	"rule_id": "O622-APP-001",
	"message": sprintf("Antrag '%v' für %v nicht bis 31.12. des Vorjahres gestellt (gestellt am %v)", [app.code, app.first_year, app.applied_on]),
} if {
	some app in applications
	application_code_row(app.code)
	not application_in_time(app)
}

violations contains {
	"rule_id": "O622-APP-002",
	"message": sprintf("Einstieg in Kategorie '%v' für Förderjahr %v nach dem letzten Einstiegsjahr 2027", [app.code, app.first_year]),
} if {
	some app in applications
	application_code_row(app.code).kind == "category"
	not application_entry_year_allowed(app)
}

violations contains {
	"rule_id": "O622-APP-003",
	"message": sprintf("Einstieg in Zuschlag '%v' für Förderjahr %v nach dem letzten Einstiegsjahr 2028", [app.code, app.first_year]),
} if {
	some app in applications
	application_code_row(app.code).kind == "surcharge"
	not application_entry_year_allowed(app)
}

violations contains {
	"rule_id": "O622-APP-008",
	"message": sprintf("Unbekannter Antragscode '%v' (z. B. Zuschlag unkupiert für Zuchtsauen nicht vorgesehen)", [app.code]),
} if {
	some app in applications
	not application_code_row(app.code)
}

violations contains {
	"rule_id": "O622-FMK-001",
	"message": "Zuschlag Festmistkompostierung ist erst ab dem Antragsjahr 2025 beantragbar",
} if {
	some app in applications
	app.code == "festmistkompostierung"
	not application_surcharge_year_allowed(app)
}

violations contains {
	"rule_id": "O622-ELIG-001",
	"message": sprintf("Mindestteilnahme nicht erreicht: %v GVE < 2,00 GVE über alle beantragten Kategorien", [participating_gve]),
} if {
	measure_contract_lapsed
}

violations contains {
	"rule_id": "O622-TGD-001",
	"message": sprintf("Über 10,00 GVE förderbare Schweine (%v GVE): ganzjährige Teilnahme an einem anerkannten Tiergesundheitsdienst erforderlich", [farm_eligible_pig_gve]),
} if {
	count(active_categories) > 0
	animal_health_service_required
	not animal_health_service_ok
}

violations contains {
	"rule_id": "O622-GEN-002",
	"message": "Förderwerbende Person nicht teilnahmeberechtigt (Rechtsform oder Beteiligung von Gebietskörperschaften > 25 %)",
} if {
	count(active_categories) > 0
	not applicant_type_ok
}

violations contains {
	"rule_id": "O622-GEN-003",
	"message": "Förderwerbende Person ist kein aktiver Landwirt",
} if {
	count(active_categories) > 0
	applicant_type_ok
	not applicant_ok
}

violations contains {
	"rule_id": "O622-GEN-004",
	"message": "Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr nicht erreicht (0,50 ha geschützter Anbau oder 1,50 ha)",
} if {
	count(active_categories) > 0
	not farm_min_size_ok
}

violations contains {
	"rule_id": "O622-GEN-006",
	"message": "Maßnahmenübernahme nur bei Betriebsauflösung, -teilung oder -zusammenlegung und mit Tieren und Flächen vom selben Vorbetrieb zulässig",
} if {
	not takeover_ok
}

violations contains {
	"rule_id": "O622-GEN-001",
	"message": sprintf("Gruppe %v: Tiere werden nicht in Österreich gehalten und sind nicht förderbar", [group_label(i, g)]),
} if {
	some i, g in pig_groups
	not kept_in_austria(g)
}
