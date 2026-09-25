# Contract, application deadlines, participation, withdrawal and combinations.
package oepul.o6_9

measure_applications contains a if {
	some a in applications
	a.measure_id == "o6_9"
	object.get(a, "component", "measure") == "measure"
}

n_feeding_applications contains a if {
	some a in applications
	a.measure_id == "o6_9"
	a.component == "n_reduced_pig_feeding"
}

# Measure application must be filed in the Maßnahmenantrag by 31.12. before
# the contract start; last entry into the measure is contract year 2027.
measure_application_timely(a) if {
	a.contract_start_year <= params.contract.last_entry_year_measure
	a.applied_on <= year_end(a.contract_start_year - 1)
}

# N-reduced pig feeding: first possible year 2025, last entry 2028
# (application by 31.12.2027), requires valid participation in the measure.
n_feeding_application_timely(a) if {
	a.contract_start_year >= params.n_feeding.first_application_year
	a.contract_start_year <= params.contract.last_entry_year_n_feeding
	a.applied_on <= year_end(a.contract_start_year - 1)
}

# A withdrawal (Abmeldung) filed between 01.01. and 31.12. invalidates the
# measure for that whole year.
withdrawn_for_year(a, y) if {
	w := object.get(a, "withdrawn_on", null)
	is_string(w)
	w <= year_end(y)
}

# A contract lapses in a year without any declared quantity or n-feeding
# participation; afterwards a new timely application is needed.
lapsed_before(a, y) if {
	l := object.get(a, "lapsed_in_year", null)
	is_number(l)
	l < y
}

application_active(a, y) if {
	a.contract_start_year <= y
	not withdrawn_for_year(a, y)
	not lapsed_before(a, y)
}

default measure_contract_valid := false

measure_contract_valid if {
	some a in measure_applications
	measure_application_timely(a)
	application_active(a, year)
}

default participates_n_feeding := false

participates_n_feeding if {
	year >= params.n_feeding.first_application_year
	measure_contract_valid
	some a in n_feeding_applications
	n_feeding_application_timely(a)
	application_active(a, year)
}

# Farm-level exclusion: n-reduced feeding in o6_9 and the equally named
# optional supplement in o6_16 cannot be combined.
default n_feeding_combination_conflict := false

n_feeding_combination_conflict if {
	participates_n_feeding
	some a in applications
	a.measure_id == "o6_16"
	a.component == "n_reduced_pig_feeding_supplement"
	application_active(a, year)
}

# Annex L: single-area combinability of measure 9 with another measure.
single_area_combinable(measure_id) := row.single_area_combinable if {
	some row in data.o6_9.combinations.annex_l_row_9
	row.measure_id == measure_id
}

declared := object.get(manure, "declared_volumes", {})

declared_m3(category) := number_or_zero(object.get(declared, sprintf("%s_m3", [category]), 0))

declared_slurry_total_m3 := sum([declared_m3(c) | some c in params.slurry_application_categories])

declared_separation_m3 := declared_m3("separation")

# Minimum participation: slurry applied near-ground, cattle slurry separated
# or participation in n-reduced pig feeding in every participation year.
default minimum_participation_met := false

minimum_participation_met if declared_slurry_total_m3 > 0

minimum_participation_met if declared_separation_m3 > 0

minimum_participation_met if participates_n_feeding

default contract_lapses_this_year := false

contract_lapses_this_year if {
	measure_contract_valid
	not minimum_participation_met
}

# Premium-relevant quantities must be declared in the MFA by 30.11. of the year.
default volumes_declared_in_time := false

volumes_declared_in_time if {
	d := declared.declared_on
	is_string(d)
	d <= dated(year, params.declaration.volume_declaration_deadline_mmdd)
}

# MFA submission deadline: 15.04., in 2023 and 2028 17.04.
mfa_deadline(y) := dated(y, row.mfa_submission_deadline_mmdd) if {
	some row in params.mfa_deadline_exceptions
	row.year == y
}

else := dated(y, params.declaration.mfa_submission_deadline_mmdd_default)

# Takeover of o6_9 only in individual cases of farm dissolution, division or merger.
takeover_allowed(reason) if reason in {r | some r in general.takeover_permitted_reasons}

# One-year measure list (SRL 1.7.1.1).
is_one_year_measure(measure_id) if {
	some m in general.one_year_measures
	m.measure_id == measure_id
}
