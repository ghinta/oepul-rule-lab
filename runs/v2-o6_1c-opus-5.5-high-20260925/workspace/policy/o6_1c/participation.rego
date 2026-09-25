# Teilnahme-, Antrags- und Vertragsregeln der Maßnahme 1C
# (Informationsblatt 1C Kap. 3, 6; Allgemeine Teilnahmebedingungen Kap. 5.2, 5.3, 5.9, 6;
# SRL Punkte 1.4, 1.6.1, 1.7.1.1, 1.9.4, 1.10.5, 1.12.1.1).
package oepul.o6_1c

applicant_rules := data.o6_1c.applicant_rules

measure_lists := data.o6_1c.measure_lists

# --- Angebotszeitraum -------------------------------------------------------------

# O61C-CONTRACT-001: Maßnahme ab Antragsjahr 2025 und längstens bis zum Ende der SRL-Laufzeit 2028.
default measure_offered_in_year := false

measure_offered_in_year if {
	year >= params.offered_from_year
	year <= params.programme_last_year
}

# --- Beantragung ------------------------------------------------------------------

measure_1c_participations contains p if {
	some p in participations
	p.measure_code == params.measure_code
}

# O61C-APPL-001: Beantragung im Maßnahmenantrag bis 31.12. vor Vertragsbeginn.
application_deadline_for(first_contract_year) := date_of(first_contract_year - 1, params.application_deadline_month_day)

application_in_time(p) if {
	object.get(p, "application_date", null) != null
	p.application_date <= application_deadline_for(p.first_contract_year)
}

# O61C-APPL-002: Letzter Einstieg mit Förderjahr 2027 (Beantragung bis 31.12.2026).
entry_year_allowed(p) if {
	p.first_contract_year >= params.offered_from_year
	p.first_contract_year <= params.last_contract_start_year
}

# O61C-CONTRACT-003 / O61C-GEN-APPL-003: automatische Verlängerung, Weiterführung über den Mehrfachantrag.
default mfa_submitted := false

mfa_submitted if object.get(oepul, "mfa_submitted", true) == true

# O61C-GEN-APPL-004: Abmeldung im laufenden Förderjahr -> Maßnahme im betroffenen Jahr nicht gültig.
deregistration_invalidates_year(p) if deregistered_in_year(p)

# Abmeldung in einem Vorjahr beendet die Teilnahme; Wiedereinstieg nur mit neuem Maßnahmenantrag.
deregistered_before_year(p) if {
	d := object.get(p, "deregistration_date", null)
	d != null
	d < date_in_year("01-01")
}

reentry_requires_new_application(p) if deregistered_before_year(p)

category_contract_valid(p) if {
	measure_offered_in_year
	application_in_time(p)
	entry_year_allowed(p)
	p.first_contract_year <= year
	not deregistration_invalidates_year(p)
	not deregistered_before_year(p)
	mfa_submitted
	applicant_eligible
	min_farm_size_met
	not category_blocked(p)
}

contract_valid_for_category(category) if {
	some p in measure_1c_participations
	object.get(p, "category", null) == category
	category_contract_valid(p)
}

# --- Kombinationsausschluss NPA mit UBB/BIO ---------------------------------------

# O61C-APPL-003: Betriebe in UBB (1A) oder BIO (1B, ausgenommen Teilbetrieb Wein/Obst/Hopfen)
# können nicht an der Kategorie „Nichtproduktive Ackerflächen" teilnehmen.
default ubb_or_bio_conflict := false

ubb_or_bio_conflict if participates("1A")

ubb_or_bio_conflict if {
	some p in participations
	p.measure_code == "1B"
	not deregistered_in_year(p)
	object.get(p, "option", null) != "teilbetrieb_wein_obst_hopfen"
}

category_blocked(p) if {
	object.get(p, "category", null) == "npa"
	ubb_or_bio_conflict
}

# --- Förderwerbende Personen ------------------------------------------------------

# O61C-GEN-APPL-010: zulässige Rechtsformen; Gebietskörperschaften ab 2025 bei 1C zulässig.
default public_body_allowed_for_1c := false

public_body_allowed_for_1c if {
	some m in applicant_rules.public_body_exception_measures
	m.measure_code == params.measure_code
	year >= m.year_from
}

default legal_form_eligible := false

legal_form_eligible if {
	some f in applicant_rules.eligible_legal_forms
	f.legal_form == object.get(applicant, "legal_form", null)
}

legal_form_eligible if {
	object.get(applicant, "legal_form", null) == applicant_rules.public_body_legal_form
	public_body_allowed_for_1c
}

# Die 25 %-Grenze für Beteiligungen von Gebietskörperschaften (bestimmender Einfluss) gilt
# nicht für die Maßnahme 1C (SRL 1.4 Ausnahme ab Antragsjahr 2025).
default public_share_ok := false

public_share_ok if public_body_allowed_for_1c

public_share_ok if {
	not public_body_allowed_for_1c
	object.get(applicant, "public_body_share_percent", 0) <= 25
}

default applicant_eligible := false

applicant_eligible if {
	legal_form_eligible
	public_share_ok
	object.get(applicant, "is_active_farmer", false) == true
	object.get(applicant, "carries_out_agricultural_activity", false) == true
	object.get(applicant, "manages_farm_in_own_name_and_account", false) == true
}

# --- Betriebsmindestgröße (nur im 1. ÖPUL-Teilnahmejahr) --------------------------

default first_oepul_year := false

first_oepul_year if object.get(oepul, "first_participation_year", year) == year

min_size_area_ha := (total_area_ha + sum_area(agroforestry_strips)) + object.get(input, ["land", "landscape_elements_area_ha"], 0)

default min_farm_size_met := false

min_farm_size_met if not first_oepul_year

min_farm_size_met if {
	first_oepul_year
	min_size_area_ha >= applicant_rules.min_farm_size_first_year.agricultural_area_min_ha
}

min_farm_size_met if {
	first_oepul_year
	object.get(input, ["land", "protected_cultivation_area_ha"], 0) >= applicant_rules.min_farm_size_first_year.protected_cultivation_min_ha
}

# --- Einjährige Maßnahme, Übernahme, Umwandlung, Flächenzugang ---------------------

# O61C-CONTRACT-002: 1C ist eine einjährige Maßnahme (Vertragszeitraum = Kalenderjahr).
default is_one_year_measure := false

is_one_year_measure if {
	some m in measure_lists.one_year_measures
	m.measure_code == params.measure_code
}

commitment_period := {
	"start": date_in_year(params.contract_period_start_month_day),
	"end": date_in_year(params.contract_period_end_month_day),
}

# O61C-GEN-TAKE-001: Maßnahmenübernahme bis 15.04. (2023 und 2028: 17.04.).
takeover_deadline(y) := date_of(y, measure_lists.takeover_rules.deadline_month_day_special_years) if {
	y in measure_lists.takeover_rules.special_years
} else := date_of(y, measure_lists.takeover_rules.deadline_month_day)

default takeover_individual_case_only := false

takeover_individual_case_only if {
	some m in measure_lists.takeover_individual_case_only
	m.measure_code == params.measure_code
}

takeover_violations contains msg if {
	some t in object.get(oepul, "takeovers", [])
	t.measure_code == params.measure_code
	t.date > takeover_deadline(year)
	msg := sprintf("Maßnahmenübernahme am %s nach Frist %s", [t.date, takeover_deadline(year)])
}

takeover_violations contains msg if {
	some t in object.get(oepul, "takeovers", [])
	t.measure_code == params.measure_code
	t.taken_over_area_ha > 0
	t.extension_to_other_area_ha > measure_lists.takeover_rules.max_extension_share * t.taken_over_area_ha
	msg := "Maßnahmenübernahme würde die Maßnahmenfläche um mehr als 50 % auf andere Flächen ausweiten"
}

# O61C-GEN-CONV-001: 1C ist in keiner zulässigen Maßnahmenumwandlung enthalten.
conversion_targets_1c := {t |
	some c in measure_lists.measure_conversions
	c.from == params.measure_code
	some t in c.to
}

default measure_conversion_possible := false

measure_conversion_possible if count(conversion_targets_1c) > 0

# O61C-GEN-AREA-001: keine Beschränkung der Prämienfähigkeit von Flächenzugängen für 1C.
default area_increase_restricted := false

area_increase_restricted if {
	some m in measure_lists.area_increase_restricted_measures
	m.measure_code == params.measure_code
}

# O61C-GEN-AREA-002: Toleranz bei Flächenabgängen mehrjähriger Maßnahmen (5 %, max. 5 ha, jedenfalls 0,5 ha).
area_reduction_tolerance_ha(previous_year_area_ha) := max_of(
	measure_lists.area_reduction_tolerance.always_allowed_ha_per_year,
	min_of(
		measure_lists.area_reduction_tolerance.max_share_per_year * previous_year_area_ha,
		measure_lists.area_reduction_tolerance.max_ha_per_year,
	),
)

# O61C-GEN-AREA-003: Umwandlung von Maßnahmenflächen in LSE Agroforststreifen ist ein zulässiger Abgang.
default conversion_to_afs_is_allowed_reduction := false

conversion_to_afs_is_allowed_reduction if {
	some c in measure_lists.allowed_land_use_conversions
	"LSE Agroforststreifen" in c.to
}

# O61C-GEN-APPL-006: Maßnahmenausstieg nur bis zur (Ankündigung der) Vor-Ort-Kontrolle
# bzw. bis zur Mitteilung des Ergebnisses einer Verwaltungskontrolle.
exit_possible(exit_date) if {
	not exit_blocked_by_control(exit_date)
}

exit_blocked_by_control(exit_date) if {
	c := object.get(oepul, "onsite_control_announced_date", null)
	c != null
	exit_date >= c
}

exit_blocked_by_control(exit_date) if {
	c := object.get(oepul, "admin_control_result_notified_date", null)
	c != null
	exit_date >= c
}

participation_violations contains v if {
	not applicant_eligible
	count(measure_1c_participations) > 0
	v := {"rule_id": "O61C-GEN-APPL-010", "scope": "farm", "message": "Förderwerbende Person erfüllt die Voraussetzungen (Rechtsform, aktiver Landwirt, landwirtschaftliche Tätigkeit, eigener Name/Rechnung) nicht"}
}

participation_violations contains v if {
	count(measure_1c_participations) > 0
	not min_farm_size_met
	v := {"rule_id": "O61C-GEN-APPL-011", "scope": "farm", "message": "Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr nicht erreicht (1,50 ha bzw. 0,50 ha geschützter Anbau)"}
}

participation_violations contains v if {
	some p in measure_1c_participations
	not application_in_time(p)
	v := {"rule_id": "O61C-APPL-001", "scope": "farm", "message": sprintf("Maßnahmenantrag für Kategorie %v nicht bis %s gestellt", [object.get(p, "category", null), application_deadline_for(p.first_contract_year)])}
}

participation_violations contains v if {
	some p in measure_1c_participations
	not entry_year_allowed(p)
	v := {"rule_id": "O61C-APPL-002", "scope": "farm", "message": sprintf("Einstiegsjahr %d außerhalb 2025–2027", [p.first_contract_year])}
}

participation_violations contains v if {
	some p in measure_1c_participations
	category_blocked(p)
	v := {"rule_id": "O61C-APPL-003", "scope": "farm", "message": "Kategorie Nichtproduktive Ackerflächen ist bei Teilnahme an UBB oder BIO (ausgenommen Bio-Teilbetrieb Wein, Obst, Hopfen) ausgeschlossen"}
}

participation_violations contains v if {
	some p in measure_1c_participations
	deregistration_invalidates_year(p)
	v := {"rule_id": "O61C-GEN-APPL-004", "scope": "farm", "message": sprintf("Abmeldung am %s: Kategorie %v im Förderjahr %d nicht gültig", [p.deregistration_date, object.get(p, "category", null), year])}
}

participation_violations contains v if {
	some p in measure_1c_participations
	reentry_requires_new_application(p)
	v := {"rule_id": "O61C-GEN-APPL-005", "scope": "farm", "message": "Nach Ausstieg ist ein Wiedereinstieg nur mit neuerlichem Maßnahmenantrag möglich"}
}

participation_violations contains v if {
	some msg in takeover_violations
	v := {"rule_id": "O61C-GEN-TAKE-001", "scope": "farm", "message": msg}
}

participation_violations contains v if {
	count(measure_1c_participations) > 0
	not measure_offered_in_year
	v := {"rule_id": "O61C-CONTRACT-001", "scope": "farm", "message": sprintf("Maßnahme 1C wird im Jahr %d nicht angeboten", [year])}
}

# O61C-GEN-MULTI-001: 1C ist weder mehrjährige Maßnahme noch an jährlich variable Flächen gebunden.
default is_multi_year_measure := false

is_multi_year_measure if {
	some m in measure_lists.multi_year_measures
	m.measure_code == params.measure_code
}

default is_annually_variable_area_measure := false

is_annually_variable_area_measure if {
	some m in measure_lists.annually_variable_area_measures
	m.measure_code == params.measure_code
}

# O61C-GEN-OPT-001: Optionen/Zuschläge einjähriger Maßnahmen bis inklusive Förderjahr 2028.
one_year_options_until_year := measure_lists.one_year_rules.options_until_year
