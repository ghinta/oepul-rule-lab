# Tierwohl – Schweinehaltung (o6_22): general ÖPUL 2023 participation conditions
# (Allgemeine Teilnahmebedingungen / Sonderrichtlinie Allgemeiner Teil) as far
# as they apply to this one-year, animal-related measure.
package oepul.o6_22

applicant := object.get(input, ["farm", "applicant"], {})

applicant_type_codes := {row.code | some row in general.applicant_types}

# Rule: O622-GEN-APPL-03 (public bodies only for the listed measures; o6_22 is not listed)
public_body_allowed(measure, _) if {
	some row in general.public_body_exempt_measures
	row.measure == measure
	object.get(row, "from_year", null) == null
	object.get(row, "to_year", null) == null
}

public_body_allowed(measure, y) if {
	some row in general.public_body_exempt_measures
	row.measure == measure
	row.to_year != null
	y <= row.to_year
}

public_body_allowed(measure, y) if {
	some row in general.public_body_exempt_measures
	row.measure == measure
	row.from_year != null
	y >= row.from_year
}

# Rule: O622-GEN-APPL-01 (eligible legal forms)
applicant_issues contains "legal_form_not_eligible" if {
	applicant.legal_form
	not applicant.legal_form in applicant_type_codes
}

# Rule: O622-GEN-APPL-03 (public bodies / >25 % public participation excluded for o6_22)
applicant_issues contains "public_body_excluded" if {
	applicant.is_public_body == true
	not public_body_allowed(params.measure_code, year)
}

applicant_issues contains "public_body_share_above_25_percent" if {
	applicant.public_body_share_percent > 25
	not public_body_allowed(params.measure_code, year)
}

# Rule: O622-GEN-APPL-02 (active farmer, agricultural activity, own name and account)
applicant_issues contains "not_active_farmer" if applicant.is_active_farmer == false

applicant_issues contains "no_agricultural_activity" if applicant.carries_out_agricultural_activity == false

applicant_issues contains "farm_not_managed_in_own_name_and_account" if applicant.farm_managed_in_own_name_and_account == false

applicant_eligible if count(applicant_issues) == 0

violations contains {
	"rule_id": "O622-GEN-APPL-01",
	"severity": "access_condition",
	"message": sprintf("Applicant not eligible: %v", [reason]),
} if {
	some reason in applicant_issues
}

# Rule: O622-GEN-MINSIZE-01 / O622-GEN-MINSIZE-02 (minimum farm size only in the first ÖPUL year)
min_farm_size_required if oepul_farm.first_participation_year == year

min_farm_size_met if object.get(input, ["land", "protected_cultivation_area_ha"], 0) >= general.min_farm_size_first_year.protected_cultivation_min_ha

min_farm_size_met if object.get(input, ["land", "total_area_ha"], 0) >= general.min_farm_size_first_year.agricultural_area_min_ha

min_farm_size_ok if not min_farm_size_required

min_farm_size_ok if min_farm_size_met

violations contains {
	"rule_id": "O622-GEN-MINSIZE-01",
	"severity": "access_condition",
	"message": "First ÖPUL year: at least 0.50 ha protected cultivation or 1.50 ha agricultural area required",
} if {
	not min_farm_size_ok
}

# Rule: O622-GEN-CONTROL-01 (refusal of on-the-spot controls: application rejected)
control_refused if oepul_farm.control_refused == true

violations contains {
	"rule_id": "O622-GEN-CONTROL-01",
	"severity": "application_rejected",
	"message": "On-the-spot control refused or prevented: application rejected, no premium for the current year, contracts terminated",
} if {
	control_refused
}

# Rule: O622-GEN-TAKEOVER-01 (takeover only in individual cases: dissolution, division or merger;
# animals and areas from the same previous farm)
takeover := object.get(app, "takeover", {})

takeover_reason_codes := {row.code | some row in general.takeover_allowed_reasons}

takeover_single_case_only(measure) if {
	some row in general.takeover_single_case_only
	row.measure == measure
}

violations contains {
	"rule_id": "O622-GEN-TAKEOVER-01",
	"severity": "application_invalid",
	"message": "Takeover of o6_22 only possible in individual cases of farm dissolution, division or merger",
} if {
	takeover.is_takeover == true
	takeover_single_case_only(params.measure_code)
	not takeover.reason in takeover_reason_codes
}

violations contains {
	"rule_id": "O622-GEN-TAKEOVER-01",
	"severity": "application_invalid",
	"message": "Takeover of an animal-related measure requires animals and areas from the same previous farm",
} if {
	takeover.is_takeover == true
	takeover.animals_and_areas_from_same_previous_farm == false
}

# Rule: O622-GEN-SWITCH-01 (measure switch only along the listed pairs; o6_22 is not listed)
switch_allowed(from_label, to_label) if {
	some row in general.measure_switch_matrix
	row.from == from_label
	to_label in row.to
}

# Rule: O622-GEN-COMB-01 (combination allowed unless excluded; no exclusion lists o6_22)
combination_excluded(a, b) if {
	some pair in general.farm_level_excluded_combinations
	a in pair.group_a
	b in pair.group_b
}

combination_excluded(a, b) if {
	some pair in general.farm_level_excluded_combinations
	b in pair.group_a
	a in pair.group_b
}

combination_allowed(a, b) if not combination_excluded(a, b)

# Rule: O622-GEN-MOD-01 (Betriebsgrößenmodulation by total farm area)
tier_upper(t, area) := t.to_ha_inclusive if t.to_ha_inclusive != null

else := area

tier_portion(t, area) := max([0, min([area, tier_upper(t, area)]) - t.from_ha_exclusive])

modulation_factor(area) := 1 if area <= 0

modulation_factor(area) := sum([weighted |
	some t in general.modulation_tiers
	weighted := tier_portion(t, area) * t.payout_factor
]) / area if {
	area > 0
}

# Rule: O622-GEN-SANCTION-01 (sanction stages; from 2027 1 % retention instead of a warning)
sanction_reduction_percent(stage, y) := row.reduction_percent_from_2027 if {
	some row in general.sanction_stages
	row.stage == stage
	y >= 2027
}

sanction_reduction_percent(stage, y) := row.reduction_percent if {
	some row in general.sanction_stages
	row.stage == stage
	y < 2027
}

# Rule: O622-GEN-SANCTION-01 (exclusion after two 100 % reductions within the contract period)
exclusion_triggered(full_reductions_in_contract_period) if full_reductions_in_contract_period >= 2

# Rule: O622-GEN-PAY-02 (payment may be waived if the amount does not exceed EUR 50)
payout_may_be_waived(amount) if amount <= general.payment.min_payout_eur_exclusive

# Rule: O622-GEN-PAY-01 (advance payment max. 75 %)
max_advance_payment(amount) := r2((amount * general.payment.advance_payment_max_percent) / 100)

# Rule: O622-GEN-PAY-01 (payout by 30 June of the following year)
payout_deadline(y) := sprintf("%d-%s", [y + 1, general.payment.payout_deadline_month_day_following_year])
