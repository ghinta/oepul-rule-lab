# ÖPUL 2023 - allgemeine Teilnahmebedingungen mit Bezug zu o6_8
# Förderwerbende Personen, Betriebsmindestgröße, Vertragszeitraum,
# Antragstellung, Flächenabgänge, Maßnahmenübernahme, Auszahlung,
# Obergrenzen, Modulation und Sanktionsstufen.
package oepul.o6_8

# ---------------------------------------------------------------------------
# Vertragszeitraum und Antragstellung
# ---------------------------------------------------------------------------

contract_start_year := object.get(o68, "contract_start_year", null)

contract_period(start_year) := cp if {
	some cp in params.contract_periods
	cp.start_year == start_year
}

contract_duration_years(start_year) := contract_period(start_year).years

contract_start_valid if contract_period(contract_start_year)

contract_active if {
	contract_start_valid
	year >= contract_start_year
	date_ns(ymd(year, "12-31")) <= date_ns(params.contract_end)
}

application_deadline(start_year) := ymd(start_year - 1, "12-31")

application_timely if {
	on_or_before(o68.application_submitted_date, application_deadline(contract_start_year))
}

entry_year_allowed(start_year) if start_year <= params.last_entry_year

farm_violations contains farm_violation("o6_8.contract.duration", "Vertragsbeginn muss 01.01.2023, 01.01.2024 oder 01.01.2025 sein (Vertragsende 31.12.2028).") if {
	contract_start_year != null
	not contract_start_valid
}

farm_violations contains farm_violation("o6_8.application.last_entry_2025", "Letzter Einstieg in die Maßnahme ist das Förderjahr 2025 (Beantragung bis 31.12.2024).") if {
	contract_start_year != null
	not entry_year_allowed(contract_start_year)
}

farm_violations contains farm_violation("o6_8.application.deadline_31_dec", "Maßnahmenantrag muss bis 31.12. vor Vertragsbeginn eingereicht werden.") if {
	contract_start_year != null
	object.get(o68, "application_submitted_date", null) != null
	not application_timely
}

# Folge der Nichterfüllung von Förder- bzw. Zugangsvoraussetzungen (SRL 1.12.1.1).
access_failure_consequence := "no_contract" if {
	year == contract_start_year
} else := "no_premium_for_year"

# ---------------------------------------------------------------------------
# Förderwerbende Personen, Lage, Betriebsmindestgröße
# ---------------------------------------------------------------------------

applicant := object.get(oepul, "applicant", {})

applicant_type_allowed if applicant.legal_form in general.applicant_types_allowed

applicant_public_share_ok if {
	object.get(applicant, "public_body_share_percent", 0) <= general.max_public_body_share_percent
}

applicant_eligible if {
	applicant_type_allowed
	applicant_public_share_ok
	applicant.is_active_farmer == true
}

# o6_8 ist nicht unter den Maßnahmen, an denen Gebietskörperschaften teilnehmen dürfen.
public_body_exempt_for_o6_8 if "8" in general.public_body_exempt_measures

farm_violations contains farm_violation("gen.applicant.eligible_persons", "Förderwerbende Person erfüllt die Voraussetzungen (Rechtsform, Beteiligung Gebietskörperschaften <= 25 %, aktiver Landwirt) nicht.") if {
	count(applicant) > 0
	not applicant_eligible
}

first_participation_year := object.get(oepul, "first_participation_year", null)

min_farm_size_required if year == first_participation_year

min_farm_size_met if {
	object.get(input, ["land", "protected_cultivation_area_ha"], 0) >= general.min_farm_size.protected_cultivation_ha
}

min_farm_size_met if {
	object.get(input, ["land", "total_area_ha"], 0) >= general.min_farm_size.agricultural_area_ha
}

farm_violations contains farm_violation("gen.min_farm_size.first_year", "Im ersten ÖPUL-Teilnahmejahr sind mindestens 0,50 ha geschützter Anbau oder 1,50 ha landwirtschaftliche Fläche erforderlich.") if {
	min_farm_size_required
	not min_farm_size_met
}

parcel_in_austria(p) if parcel_location(p).country == "AT"

# ---------------------------------------------------------------------------
# Mindestbewirtschaftung und Förderfähigkeit von Flächen
# ---------------------------------------------------------------------------

is_fodder_crop(p) if usage(p) in {x | some x in definitions.ackerfutter}

# BAW-Flächen sind von den Mindestbewirtschaftungskriterien ausgenommen.
min_management_category(p) := "exempt_baw" if {
	has_code(p, "BAW")
} else := "fodder" if {
	is_fodder_crop(p)
} else := "arable"

harvested_share(p) := object.get(p, ["oepul_o6_8", "harvest", "harvested_share_percent"], null)

harvest_obligation_met(p) if harvested_share(p) >= general.min_harvest_share_percent

harvest_obligation_met(p) if harvest_obligation_waived(p)

harvest_obligation_breached(p) if {
	min_management_category(p) == "arable"
	harvested_share(p) != null
	not harvest_obligation_met(p)
}

national_park_excluded(p) if {
	np := parcel_location(p).national_park
	np in {x | some x in general.national_parks_without_area_premiums}
}

national_park_excluded(p) if {
	np := parcel_location(p).national_park
	np != null
	object.get(p, ["oepul_o6_8", "location", "national_park_relevant_obligations"], false) == true
}

op_code_set(p) if {
	some c in object.get(p, ["oepul_o6_8", "op_codes"], [])
	c in {x | some x in params.op_codes_without_o6_8_premium}
}

# Gründe, aus denen auf einem Schlag keine o6_8-Prämie gewährt wird.
exclusion_reasons := {
	"op_code", "outside_austria", "national_park", "trial_area_vf", "public_funding_overlap",
	"harvest_obligation_not_met", "commitment_not_fulfilled_whole_year", "not_eligible_land_use",
}

parcel_exclusions(p) := {r | some r in exclusion_reasons; excluded_for(p, r)}

excluded_for(p, "op_code") if op_code_set(p)

excluded_for(p, "outside_austria") if not parcel_in_austria(p)

excluded_for(p, "national_park") if national_park_excluded(p)

excluded_for(p, "trial_area_vf") if {
	object.get(p, ["oepul_o6_8", "trial_area_vf"], false) == true
}

excluded_for(p, "public_funding_overlap") if {
	object.get(p, ["oepul_o6_8", "public_funding_overlap"], false) == true
}

excluded_for(p, "harvest_obligation_not_met") if harvest_obligation_breached(p)

excluded_for(p, "commitment_not_fulfilled_whole_year") if {
	object.get(p, ["oepul_o6_8", "transferred_without_continuation"], false) == true
}

excluded_for(p, "not_eligible_land_use") if {
	p.land_use != "arable"
}

# Pflicht zur Vergabe eines OP-Codes, wenn ein Ausschlussgrund vorliegt, aber kein OP-Code gesetzt ist.
parcel_violations contains violation("gen.op_code.mandatory", p, null, "Code OP bzw. maßnahmenbezogener OP-Code ist zu vergeben (z. B. Ernteverpflichtung nicht erfüllt).") if {
	some p in parcels
	count(codes(p)) > 0
	some reason in parcel_exclusions(p)
	reason in {"harvest_obligation_not_met", "public_funding_overlap", "commitment_not_fulfilled_whole_year"}
	not op_code_set(p)
}

# ---------------------------------------------------------------------------
# Flächenänderungen, Ausstieg, Übernahme, Umwandlung
# ---------------------------------------------------------------------------

# o6_8-Flächen sind an die jährlich verfügbaren Flächen gebunden (SRL 1.7.2.5).
area_annually_variable if "8" in general.annually_variable_area_measures

# o6_8 unterliegt keiner Beschränkung der Prämienfähigkeit von Flächenzugängen (SRL 1.7.2.4).
area_increase_premium_restricted if "8" in general.area_increase_restricted_measures

area_reduction_tolerance_ha(previous_area_ha) := max([
	general.area_reduction_tolerance.min_ha_always,
	min([previous_area_ha * general.area_reduction_tolerance.max_share, general.area_reduction_tolerance.max_ha]),
])

area_reduction_repayment_applies(previous_area_ha, current_area_ha) if {
	not area_annually_variable
	previous_area_ha - current_area_ha > area_reduction_tolerance_ha(previous_area_ha)
}

exit_year := object.get(o68, "exit_year", null)

exit_reason := object.get(o68, "exit_reason", null)

repayment_free_exit_reasons := {"loss_of_disposal", "revision_clause", "permanent_circumstances_reported"}

early_exit_repayment_required if {
	exit_year != null
	exit_year <= 2028
	not exit_reason in repayment_free_exit_reasons
}

farm_transfer_continuation_required if object.get(o68, "farm_handover_to_successor", false) == true

missing_payment_application_no_premium if object.get(o68, "payment_application_submitted", true) == false

missing_payment_application_ends_commitment if {
	missing_payment_application_no_premium
	object.get(o68, "late_payment_application_within_one_year", false) == false
}

takeover_special_year(y) if y in {2023, 2028}

takeover_deadline(y) := ymd(y, general.takeover.deadline_mmdd_2023_2028) if {
	takeover_special_year(y)
} else := ymd(y, general.takeover.deadline_mmdd)

takeover_allowed(takeover_date, taken_over_area_ha, expansion_area_ha) if {
	on_or_before(takeover_date, takeover_deadline(date_year(takeover_date)))
	expansion_area_ha <= taken_over_area_ha * general.takeover.max_expansion_share
}

measure_switch_allowed(from_measure, to_measure, application_date) if {
	from_measure == "8_BAW"
	to_measure in {x | some x in params.baw_conversion_targets}
	on_or_before(application_date, params.baw_conversion_deadline)
}

# ---------------------------------------------------------------------------
# Auszahlung, Obergrenzen, Modulation, Sanktionen
# ---------------------------------------------------------------------------

payment_deadline(y) := ymd(y + 1, general.payment.due_mmdd_following_year)

max_advance_payment_eur(expected_eur) := expected_eur * general.payment.max_advance_share

payout_may_be_withheld(amount_eur) if amount_eur <= general.payment.min_payout_eur

area_cap_eur_per_ha(y) := c.eur_per_ha if {
	some c in general.area_payment_caps
	c.scope == "standard"
	year_in_range(c, y)
}

modulation_bracket_upper(b, total_ha) := min([b.to_ha, total_ha]) if {
	b.to_ha != null
} else := total_ha

modulation_factor(total_ha) := 1 if {
	total_ha <= 0
} else := f if {
	weighted := sum([part |
		some b in general.modulation_brackets
		portion := max([0, modulation_bracket_upper(b, total_ha) - b.from_ha])
		part := portion * b.factor
	])
	f := weighted / total_ha
}

sanction_stage(stage, y) := s if {
	some s in general.sanction_stages
	s.stage == stage
	year_in_range(s, y)
}

reduction_order := general.multiple_reduction_order
