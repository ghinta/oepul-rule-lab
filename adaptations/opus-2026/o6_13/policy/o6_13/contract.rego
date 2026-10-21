# o6_13 – Beantragung, Vertragszeitraum, Verlängerung, Erlöschen und Ausstieg
package oepul.o6_13

# ---------------------------------------------------------------------------
# O6_13-CON-01: einjährige Maßnahme (Vertragszeitraum = Kalenderjahr)
# ---------------------------------------------------------------------------
is_one_year_measure if {
	some row in general.one_year_measures
	row.measure_code == measure_code
}

contract_period := {
	"start": iso_date(year, "01-01"),
	"end": iso_date(year, "12-31"),
	"calendar_years": params.contract_period_calendar_years,
} if {
	is_one_year_measure
}

# ---------------------------------------------------------------------------
# O6_13-APP-01: Maßnahmenantrag bis spätestens 31.12. vor Vertragsbeginn
# O6_13-APP-02: letzter Einstieg Förderjahr 2027 (Antrag bis 31.12.2026)
# ---------------------------------------------------------------------------
entry_year := object.get(state, "entry_year", null)

application_date := object.get(state, "measure_application_date", null)

application_deadline(entry) := iso_date(entry - 1, params.application_deadline_month_day)

entry_application_timely if {
	is_string(application_date)
	application_date <= application_deadline(entry_year)
}

entry_year_allowed if entry_year <= params.last_entry_year

new_entry_valid if {
	entry_year == year
	entry_application_timely
	entry_year_allowed
}

contract_failures contains {
	"rule_id": "O6_13-APP-01",
	"message": sprintf("Maßnahmenantrag nicht bis %v gestellt", [application_deadline(entry_year)]),
} if {
	entry_year == year
	not entry_application_timely
}

contract_failures contains {
	"rule_id": "O6_13-APP-02",
	"message": sprintf("Einstieg %v nach dem letzten Einstiegsjahr %v nicht möglich", [entry_year, params.last_entry_year]),
} if {
	entry_year == year
	not entry_year_allowed
}

# ---------------------------------------------------------------------------
# O6_13-CON-02: automatische Verlängerung um ein Förderjahr, wenn nicht
#   abgemeldet; Weiterführung durch Mehrfachantrag mit förderrelevanten Flächen
# O6_13-CON-03: kein Nützlingseinsatz (kein Code NUE) in einem Förderjahr ->
#   Vertrag erlischt
# O6_13-APP-07: nach Erlöschen, Ausstieg, Ausschluss oder Nichtabgabe des MFA
#   ist ein neuer Maßnahmenantrag nötig
# ---------------------------------------------------------------------------
renewal_valid if {
	is_number(entry_year)
	entry_year < year
	is_true(state, "contract_active_previous_year")
	is_true(state, "nue_used_previous_year")
	not is_true(state, "withdrawn_previous_year")
	not is_true(state, "excluded_from_measure")
	not is_false(state, "mfa_submitted_previous_year")
}

contract_failures contains {
	"rule_id": "O6_13-CON-03",
	"message": "Vertrag im Vorjahr erloschen (kein Code NUE / kein Nützlingseinsatz) – neuer Maßnahmenantrag erforderlich",
} if {
	is_number(entry_year)
	entry_year < year
	is_false(state, "nue_used_previous_year")
}

contract_failures contains {
	"rule_id": "O6_13-APP-07",
	"message": "Nach Ausstieg, Ausschluss oder Nichtabgabe des Mehrfachantrages ist ein neuerlicher Maßnahmenantrag erforderlich",
} if {
	is_number(entry_year)
	entry_year < year
	some key in ["withdrawn_previous_year", "excluded_from_measure"]
	is_true(state, key)
}

contract_failures contains {
	"rule_id": "O6_13-APP-07",
	"message": "Mehrfachantrag im Vorjahr nicht abgegeben – neuerlicher Maßnahmenantrag erforderlich",
} if {
	is_number(entry_year)
	entry_year < year
	is_false(state, "mfa_submitted_previous_year")
}

contract_failures contains {
	"rule_id": "O6_13-CON-02",
	"message": "Kein laufender Vertrag aus dem Vorjahr vorhanden",
} if {
	is_number(entry_year)
	entry_year < year
	is_false(state, "contract_active_previous_year")
}

contract_failures contains {
	"rule_id": "O6_13-APP-01",
	"message": "Kein Maßnahmenantrag bzw. Einstiegsjahr angegeben",
} if {
	not is_number(entry_year)
}

contract_basis_valid if new_entry_valid

contract_basis_valid if renewal_valid

# Vertrag erlischt nach dem laufenden Jahr, wenn kein NUE-Schlag beantragt ist
contract_lapses_after_year if count(nue_parcels) == 0

new_application_deadline_for_next_year := application_deadline(year + 1)

# ---------------------------------------------------------------------------
# Ausstieg / Abmeldung
# O6_13-EXIT-01: Ausstieg nach Erfüllung des einjährigen Vertragszeitraumes
# O6_13-EXIT-02: Bekanntgabe online im Rahmen des aktuellen Mehrfachantrages
# O6_13-EXIT-03: Abmeldung 1.1.–31.12. -> Maßnahme im betroffenen Jahr nicht
#   gültig; bei Erfüllung bis 31.12. Abmeldung erst ab 1.1. des Folgejahres
# O6_13-EXIT-04: bis zum Ausstieg sind die Förderverpflichtungen einzuhalten
# O6_13-EXIT-05: Ausstieg bis zur Durchführung/Ankündigung einer VOK oder bis
#   zur Mitteilung des Ergebnisses einer Verwaltungskontrolle
# ---------------------------------------------------------------------------
withdrawal := object.get(state, "withdrawal", {})

withdrawal_date := object.get(withdrawal, "declared_date", null)

withdrawal_declared_in_year if date_in_year(withdrawal_date, year)

withdrawal_blocked_by(key) if {
	cutoff := object.get(state, key, null)
	is_string(cutoff)
	cutoff <= withdrawal_date
}

withdrawal_admissible if {
	withdrawal_declared_in_year
	not withdrawal_blocked_by("on_site_check_announced_date")
	not withdrawal_blocked_by("admin_check_result_notified_date")
}

withdrawal_effective_in_year if {
	withdrawal_admissible
	not is_false(withdrawal, "declared_online_in_mfa")
}

contract_failures contains {
	"rule_id": "O6_13-EXIT-03",
	"message": "Abmeldung im laufenden Förderjahr: Maßnahme im betroffenen Förderjahr nicht mehr gültig",
} if {
	withdrawal_effective_in_year
}

withdrawal_findings contains {
	"rule_id": "O6_13-EXIT-05",
	"message": "Ausstieg nach Ankündigung/Durchführung einer Vor-Ort-Kontrolle bzw. Mitteilung einer Verwaltungskontrolle unzulässig – Verpflichtungen und Kontrollergebnis bleiben maßgeblich",
} if {
	withdrawal_declared_in_year
	not withdrawal_admissible
}

withdrawal_findings contains {
	"rule_id": "O6_13-EXIT-02",
	"message": "Ausstieg ist online auf www.eama.at im Rahmen des aktuellen Mehrfachantrages bekannt zu geben",
} if {
	withdrawal_declared_in_year
	is_false(withdrawal, "declared_online_in_mfa")
}

# Frühestmögliche Abmeldung ohne Verlust der Prämie des laufenden Jahres
earliest_withdrawal_without_loss := iso_date(year + 1, "01-01")

# Ausstieg nach Erfüllung des einjährigen Vertragszeitraumes ist jederzeit (ab
# dem Folgejahr) ohne Rückforderung möglich, da es sich um eine einjährige Maßnahme handelt
exit_possible_after_contract_year if is_one_year_measure

contract_in_force if {
	contract_basis_valid
	not withdrawal_effective_in_year
	access_requirements_met
}

# ---------------------------------------------------------------------------
# O6_13-SANC-05: bei einjährigen Maßnahmen kommt bei Nichterfüllung von
# Förder- bzw. Zugangsvoraussetzungen kein Vertrag zustande
# ---------------------------------------------------------------------------
no_contract_due_to_access_failure if {
	is_one_year_measure
	not access_requirements_met
}

# ---------------------------------------------------------------------------
# O6_13-CONV-01: o6_13 ist nicht in der Liste der umwandelbaren Maßnahmen
# ---------------------------------------------------------------------------
conversion_targets(from) := [t |
	some row in general.measure_conversions
	row.from == from
	some t in row.to
]

conversion_available if count(conversion_targets(measure_code)) > 0

# ---------------------------------------------------------------------------
# O6_13-TRANS-01: Maßnahmenübernahme durch einen anderen, bisher nicht
# teilnehmenden Betrieb bis 15.04. (2023 und 2028: 17.04.); Ausweitung
# höchstens 50 %; Antrag im MFA, Genehmigung durch AMA
# ---------------------------------------------------------------------------
takeover_deadline(y) := iso_date(y, md) if {
	md := general.takeover_deadline_month_day_special_years[sprintf("%d", [y])]
} else := iso_date(y, general.takeover_deadline_month_day)

takeover_only_in_individual_cases if {
	some row in general.takeover_individual_case_only_measures
	row.measure_code == measure_code
}

takeover := object.get(state, "takeover", {})

takeover_findings contains {
	"rule_id": "O6_13-TRANS-01",
	"message": sprintf("Maßnahmenübernahme nach der Frist %v", [takeover_deadline(year)]),
} if {
	d := object.get(takeover, "request_date", null)
	is_string(d)
	d > takeover_deadline(year)
}

takeover_findings contains {
	"rule_id": "O6_13-TRANS-01",
	"message": "Übernehmender Betrieb hat bereits an der Maßnahme teilgenommen",
} if {
	is_true(takeover, "taker_already_participating")
}

takeover_findings contains {
	"rule_id": "O6_13-TRANS-01",
	"message": "Maßnahmenübernahme führt zu einer Ausweitung auf andere Flächen um mehr als 50 %",
} if {
	taken := object.get(takeover, "taken_over_area_ha", 0)
	taken > 0
	object.get(takeover, "extension_to_other_areas_ha", 0) > (taken * general.takeover_max_extension_percent) / 100
}

takeover_findings contains {
	"rule_id": "O6_13-TRANS-01",
	"message": "Maßnahmenübernahme erfordert Genehmigung durch die AMA",
} if {
	is_string(object.get(takeover, "request_date", null))
	is_false(takeover, "approved_by_ama")
}
