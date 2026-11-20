# Teilnahmevoraussetzungen, Vertragszeitraum, Beantragung, Weiterbildung und
# optionaler Zuschlag "Regionaler Naturschutzplan".
package oepul.o6_19

import rego.v1

contract_start_year := ebw.contract_start_year

# R-O619-CONTRACT-PERIOD: Vertragsbeginn 2023/2024/2025 -> 6/5/4 Jahre bis 31.12.2028.
contract_period := cp if {
	some cp in params.contract_periods
	cp.start_year == contract_start_year
}

# R-O619-CONTRACT-PERIOD
contract_start_invalid if {
	is_number(contract_start_year)
	not contract_period
}

is_first_commitment_year if year == contract_start_year

# R-O619-CONTRACT-PERIOD: Verpflichtungsjahr innerhalb des Vertragszeitraums.
within_contract_period if {
	contract_period
	year >= contract_start_year
	year <= 2028
}

# R-O619-APP-DEADLINE: Maßnahmenantrag bis 31.12. vor Vertragsbeginn.
application_deadline := year_end(contract_start_year - 1)

application_timely if date_lte(ebw.measure_application_date, application_deadline)

# R-O619-APP-LAST-ENTRY: letzter Einstieg Förderjahr 2025 (Antrag bis 31.12.2024).
entry_year_allowed if contract_start_year <= params.last_entry_year

# R-O619-MIN-AREA-FIRST-YEAR: im 1. Jahr mind. 1,00 ha förderfähige Fläche.
ebw_eligible_area_total := sum([a | some pid in ebw_parcel_ids; a := parcel_eligible_area[pid]])

min_area_first_year_met if ebw_eligible_area_total >= params.min_first_year_area_ha

# R-O619-MIN-PARCEL-LATER-YEARS: ab dem 2. Jahr mind. ein Schlag nach den Vorgaben bewirtschaftet.
compliant_ebw_parcel_ids := {pid | some pid in ebw_parcel_ids; count(parcel_violations[pid]) == 0}

min_parcel_later_years_met if count(compliant_ebw_parcel_ids) >= params.min_parcels_following_years

# R-O619-PROJECT-CONFIRMATION: Projektbestätigung ist Teilnahmevoraussetzung.
project_confirmation_present if ebw.project_confirmation_present == true

training := object.get(ebw, "training", {})

# R-O619-TRAINING-DEADLINE: Teilnahme an mind. einem regionalen Vernetzungstreffen bis 31.12.2026.
training_attended_in_time if {
	training.attended == true
	date_lte(training.attendance_date, params.training_deadline)
}

# R-O619-TRAINING-PERSON: Betriebsführer/in oder maßgeblich tätige, eingebundene Person.
training_attendee_ok if training.attendee_role in {"farm_manager", "involved_person"}

# R-O619-TRAINING-LEAVE: verlässt die geschulte Person vor dem 31.12.2026 den Betrieb, ist nachzuholen.
trained_person_left_before_deadline if {
	is_string(training.trained_person_left_date)
	training.trained_person_left_date < params.training_deadline
}

training_repeated_in_time if date_lte(training.repeat_attended_date, params.training_deadline)

# R-O619-TRAINING-NO-DOUBLE-COUNT: keine Doppelanrechnung (andere Betriebe/Verpflichtungen).
training_double_counted if training.same_event_credited_elsewhere == true

training_double_counted if training.credited_to_other_farm == true

training_fulfilled if {
	training_attended_in_time
	training_attendee_ok
	not trained_person_left_before_deadline
	not training_double_counted
}

training_fulfilled if {
	training_attended_in_time
	training_attendee_ok
	trained_person_left_before_deadline
	training_repeated_in_time
	not training_double_counted
}

# Die Weiterbildungsfrist kann nur nach dem 31.12.2026 als verletzt beurteilt werden.
training_violation if {
	year > 2026
	not training_fulfilled
}

training_violation if training_double_counted

# R-O619-TRAINING-CONFIRMATION: Besuchsbestätigung nach Aufforderung an die AMA (sofern nicht durch Koordinationsstelle).
training_confirmation_missing if {
	training.confirmation_requested == true
	not training.confirmation_submitted == true
	not training.transmitted_by_coordination_body == true
}

regional_plan := object.get(ebw, "regional_plan", {})

regional_plan_applied if regional_plan.applied == true

# R-O619-RNP-CONFIRMATION: jährliche Teilnahmebestätigung zusätzlich zur Projektbestätigung.
regional_plan_prerequisites_met if {
	regional_plan_applied
	regional_plan.participation_confirmation_present == true
	project_confirmation_present
}

# R-O619-RNP-LAST-ENTRY: letzter Einstieg Förderjahr 2028 (Antrag bis 31.12.2027).
regional_plan_application_timely if {
	date_lte(regional_plan.application_date, params.regional_plan_last_application_deadline)
	date_lte(regional_plan.application_date, year_end(regional_plan.first_year - 1))
}

# R-O619-RNP-AUTO-RENEWAL: verlängert sich automatisch, wenn nicht abgemeldet und Teilnahmebestätigung vorliegt.
regional_plan_renewed if {
	regional_plan_applied
	not regional_plan.deregistered == true
	regional_plan.participation_confirmation_present == true
}

# R-O619-RNP-RATE: 250 EUR/Betrieb (2023), 270 EUR/Betrieb (ab 2024).
regional_plan_rate := r.eur_per_farm if {
	some r in params.regional_plan_surcharge
	year >= r.year_from
	year <= r.year_to
}

# R-O619-RNP-ONCE-WITH-NAT: bei gleichzeitiger Teilnahme an NAT nur einmal pro Jahr und Betrieb.
regional_plan_already_paid_via_naturschutz if participation.naturschutz_regional_plan_granted == true

regional_plan_surcharge_eur := regional_plan_rate if {
	regional_plan_prerequisites_met
	regional_plan_application_timely
	regional_plan_renewed
	not regional_plan_already_paid_via_naturschutz
}

default regional_plan_surcharge_eur := 0

# Teilnahmebezogene Verstöße (Zugangsvoraussetzungen und Förderverpflichtungen auf Betriebsebene).
participation_violations contains {"rule_id": "R-O619-CONTRACT-PERIOD", "message": "Vertragsbeginn liegt außerhalb der zulässigen Vertragszeiträume (2023, 2024, 2025)."} if contract_start_invalid

participation_violations contains {"rule_id": "R-O619-APP-DEADLINE", "message": "Maßnahmenantrag nicht bis 31.12. vor Vertragsbeginn gestellt."} if not application_timely

participation_violations contains {"rule_id": "R-O619-APP-LAST-ENTRY", "message": "Einstieg nach dem Förderjahr 2025 ist nicht mehr möglich."} if not entry_year_allowed

participation_violations contains {"rule_id": "R-O619-PROJECT-CONFIRMATION", "message": "Keine Projektbestätigung vorhanden."} if not project_confirmation_present

participation_violations contains {"rule_id": "R-O619-MIN-AREA-FIRST-YEAR", "message": "Im ersten Teilnahmejahr weniger als 1,00 ha förderfähige EBW-Fläche."} if {
	is_first_commitment_year
	not min_area_first_year_met
}

participation_violations contains {"rule_id": "R-O619-MIN-PARCEL-LATER-YEARS", "message": "Ab dem zweiten Teilnahmejahr wird kein Schlag nach den Vorgaben der Maßnahme bewirtschaftet."} if {
	not is_first_commitment_year
	not min_parcel_later_years_met
}

participation_violations contains {"rule_id": "R-O619-TRAINING-DEADLINE", "message": "Weiterbildungsverpflichtung (regionales Vernetzungstreffen bis 31.12.2026) nicht erfüllt."} if training_violation

participation_violations contains {"rule_id": "R-O619-TRAINING-CONFIRMATION", "message": "Besuchsbestätigung trotz Aufforderung nicht an die AMA übermittelt."} if training_confirmation_missing

# R-O619-ACCESS-FAIL-CONSEQUENCE / SRL 1.12.1.1: Folgen nicht erfüllter Zugangsvoraussetzungen.
access_violation_rule_ids := {
	"R-O619-CONTRACT-PERIOD", "R-O619-APP-DEADLINE", "R-O619-APP-LAST-ENTRY",
	"R-O619-PROJECT-CONFIRMATION", "R-O619-MIN-AREA-FIRST-YEAR", "R-O619-MIN-PARCEL-LATER-YEARS",
}

access_violated if {
	some v in participation_violations
	v.rule_id in access_violation_rule_ids
}

access_consequence := "no_contract" if {
	access_violated
	is_first_commitment_year
}

access_consequence := "no_premium_this_year" if {
	access_violated
	not is_first_commitment_year
}

access_consequence := "none" if not access_violated

# R-O619-NO-ADDITIONAL-MEASURE: die Maßnahme verlangt keine Teilnahme an einer weiteren ÖPUL-Maßnahme.
additional_measure_required := false

# R-O619-COMBI-NATURSCHUTZ-FARM: EBW ist am Betrieb mit der Maßnahme "Naturschutz" (18) kombinierbar.
farm_level_combinable_measures := {"18"}
