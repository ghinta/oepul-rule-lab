# o6_24 – Vertragszeitraum, Verlängerung, Ausstieg, Übernahme, Kombination
# Einjährige Maßnahme mit automatischer Verlängerung; Kombinationen gemäß Anhang L.
package oepul.o6_24

# --- Einjährige Maßnahme (Punkt 1.7.1.1 SRL) ---
is_one_year_measure if {
	some m in cfg.one_year_measures
	m.code == measure_code
}

is_multi_year_measure if measure_code in {m | some m in cfg.multi_year_measures}

contract_period := {
	"start": date_string(year, 1, 1),
	"end": date_string(year, 12, 31),
}

# --- Abmeldung / Ausstieg ---
deregistration_date := object.get(participation, "deregistration_date", null)

deregistration_year := to_number(substring(deregistration_date, 0, 4)) if deregistration_date != null

# Abmeldung zwischen 1.1. und 31.12. des Förderjahres: Maßnahme im Förderjahr nicht mehr gültig.
default deregistered_for_year := false

deregistered_for_year if deregistration_year == year

# Abmeldung in einem früheren Jahr: Vertrag bereits beendet.
deregistered_before_year if deregistration_year < year

# Ein Ausstieg ist nach Erfüllung des einjährigen Vertragszeitraumes (ab 1.1. des Folgejahres) möglich.
earliest_deregistration_date_keeping_year := date_string(year + 1, 1, 1)

# Kontrollverweigerung: Antrag abgelehnt, keine Prämie, Verträge beendet.
control_refused if participation.control_refused == true

# --- Vertragsstatus ---
default contract_valid_for_year := false

contract_valid_for_year if {
	is_one_year_measure
	contract_start_year <= year
	access_conditions_met
	not deregistered_for_year
	not deregistered_before_year
	not control_refused
	not circumstance_premium_blocked
}

# Mindestteilnahme nicht erreicht: Vertrag erlischt; neuer fristgerechter Maßnahmenantrag nötig.
default contract_lapses := false

contract_lapses if not minimum_participation_met

default new_measure_application_required_for_next_year := false

new_measure_application_required_for_next_year if contract_lapses

new_measure_application_required_for_next_year if deregistered_for_year

new_measure_application_required_for_next_year if deregistered_before_year

new_measure_application_required_for_next_year if participation.multiple_application_not_submitted == true

# Automatische Verlängerung um ein weiteres Förderjahr, wenn nicht abgemeldet.
default renews_automatically_next_year := false

renews_automatically_next_year if {
	contract_valid_for_year
	not new_measure_application_required_for_next_year
}

# Einjährige Maßnahme: kein Rückzahlungsrisiko aus mehrjährigem Vertragszeitraum.
default multi_year_repayment_applicable := false

multi_year_repayment_applicable if is_multi_year_measure

# Flächenabgangstoleranz (5 % / 5 ha / 0,5 ha) gilt nur für mehrjährige Maßnahmen.
default area_reduction_tolerance_applicable := false

area_reduction_tolerance_applicable if is_multi_year_measure

# Beschränkung des prämienfähigen Flächenzugangs (50 % Basis 2025, mind. 5 ha).
default area_increase_premium_restricted := false

area_increase_premium_restricted if {
	some row in cfg.area_increase_restricted_measures
	row.code == measure_code
}

# Maßnahmenwechsel in höherwertige Maßnahmen: für 24 keine Umwandlung vorgesehen.
conversion_targets := {row.to | some row in cfg.measure_conversions; row.from == measure_code}

conversion_available if count(conversion_targets) > 0

# --- Maßnahmenübernahme (flächenbezogen) bis 15.04. (2023/2028: 17.04.) ---
takeover_deadline(y) := d if {
	some d in deadline("takeover").exception_dates
	startswith(d, sprintf("%d-", [y]))
} else := date_string(y, deadline("takeover").month, deadline("takeover").day)

takeover := object.get(participation, "takeover", null)

takeover_failures contains "takeover_after_deadline" if {
	takeover != null
	date_ns(takeover.date) > date_ns(takeover_deadline(year))
}

takeover_failures contains "takeover_extension_exceeds_50_percent" if {
	takeover != null
	takeover.additional_area_ha > thresholds.takeover_max_extension_share * takeover.taken_over_area_ha
}

takeover_failures contains "taker_already_participating" if {
	takeover != null
	takeover.taker_already_participating == true
}

takeover_failures contains "takeover_requires_ama_approval" if {
	takeover != null
	takeover.ama_approved != true
}

takeover_allowed if {
	takeover != null
	count(takeover_failures) == 0
}

# --- Kombination auf der Einzelfläche (Anhang L) ---
combination_row := {row.code: row | some row in data.o6_24.combinations.o6_24_row}

non_combinable_codes := {code | some code, row in combination_row; row.combinable == false}

combinable_codes := {code | some code, row in combination_row; row.combinable == true}

combination_conflicts contains {"parcel_id": p.parcel_id, "measure": m} if {
	some p in parcels
	parcel_declared_for_measure(p)
	some m in parcel_measures(p)
	m in non_combinable_codes
}

# Betriebliche Ausschlüsse (Punkt 1.9.4 SRL): Maßnahmen, die mit 24 nicht gleichzeitig am Betrieb möglich sind.
farm_level_excluded_measures contains other if {
	some pair in cfg.farm_level_exclusion_pairs
	measure_code in pair.measures
	some other in pair.measures
	other != measure_code
}

farm_level_exclusion_conflicts contains m if {
	some m in object.get(input, ["participation", "measures"], [])
	m in farm_level_excluded_measures
}
