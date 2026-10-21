# Teilnahmevoraussetzungen, Antragstellung und Maßnahmenkombination auf
# Betriebsebene (Kapitel 3 und 6 Merkblatt; SRL 1.4, 1.6.1, 1.9.4, 1.10.5.2, 2.7).
package o6_7.eligibility

import data.o6_7.lib

o67 := object.get(input, ["farm", "oepul", "o6_7"], {})

applicant := object.get(input, ["farm", "applicant"], {})

# --- Mindestteilnahme: jedes Teilnahmejahr mindestens 1,50 ha Ackerfläche ---
default access_ok := false

access_ok if lib.arable_area_ha >= lib.params.access.min_arable_area_ha

violations contains {
	"rule_id": "O67-ACCESS-MIN-ARABLE",
	"code": "arable_area_below_1_5_ha",
	"arable_area_ha": lib.arable_area_ha,
} if {
	not access_ok
}

# --- Förderwerbende Personen ---
territorial_exception_applies if {
	some m in lib.lists.territorial_authority_exception_measures
	m.measure_code == lib.params.measure_code
	m.from_year <= lib.year
	_open_or_after(m.to_year)
}

_open_or_after(to_year) if to_year == null

_open_or_after(to_year) if to_year >= lib.year

applicant_type(code) := t if {
	some t in lib.lists.applicant_types
	t.code == code
}

violations contains {
	"rule_id": "O67-APPLICANT-TYPE",
	"code": "applicant_type_not_eligible",
	"legal_form": applicant.legal_form,
} if {
	applicant.legal_form
	not applicant_type(applicant.legal_form)
}

# Für System Immergrün gilt der Ausschluss von Gebietskörperschaften und
# Einrichtungen mit mehr als 25 % Beteiligung von Gebietskörperschaften nicht.
violations contains {
	"rule_id": "O67-APPLICANT-PUBLIC-SHARE",
	"code": "public_body_influence_over_25_percent",
} if {
	t := applicant_type(applicant.legal_form)
	t.public_share_limit_applies
	applicant.public_body_share_percent > lib.params.general.public_body_max_share_percent
	not territorial_exception_applies
}

violations contains {
	"rule_id": "O67-APPLICANT-ACTIVE-FARMER",
	"code": "not_active_farmer_or_no_agricultural_activity",
} if {
	applicant.is_active_farmer == false
}

violations contains {
	"rule_id": "O67-APPLICANT-ACTIVE-FARMER",
	"code": "not_active_farmer_or_no_agricultural_activity",
} if {
	applicant.carries_out_agricultural_activity == false
}

violations contains {
	"rule_id": "O67-APPLICANT-OWN-ACCOUNT",
	"code": "farm_not_managed_in_own_name_and_account",
} if {
	applicant.manages_in_own_name_and_account == false
}

# --- Antragstellung ---
application_deadline_day(contract_year) := lib.mmdd_day(contract_year - 1, lib.params.contract.application_deadline_mmdd)

violations contains {
	"rule_id": "O67-APPLICATION-DEADLINE",
	"code": "measure_application_after_31_december",
	"application_date": o67.application_date,
} if {
	lib.day(o67.application_date) > application_deadline_day(o67.first_contract_year)
}

violations contains {
	"rule_id": "O67-LAST-ENTRY",
	"code": "entry_after_last_entry_year_2027",
	"first_contract_year": o67.first_contract_year,
} if {
	o67.first_contract_year > lib.params.contract.last_entry_contract_year
}

violations contains {
	"rule_id": "O67-LAST-ENTRY",
	"code": "application_after_31_12_2026",
	"application_date": o67.application_date,
} if {
	lib.day(o67.application_date) > lib.day(lib.params.contract.last_application_date)
}

# --- Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr ---
first_oepul_year if input.farm.oepul.first_participation_year == lib.year

farm_min_size_ok if object.get(input, ["land", "total_area_ha"], 0) >= lib.params.general.first_year_min_total_area_ha

farm_min_size_ok if object.get(input, ["land", "protected_cultivation_area_ha"], 0) >= lib.params.general.first_year_min_protected_cultivation_ha

violations contains {
	"rule_id": "O67-GEN-FARM-MIN-SIZE",
	"code": "farm_below_minimum_size_in_first_oepul_year",
} if {
	first_oepul_year
	not farm_min_size_ok
}

# --- Maßnahmenkombination auf Betriebsebene ---
violations contains {
	"rule_id": "O67-COMB-NOT-WITH-6",
	"code": "simultaneous_participation_in_6_and_7",
} if {
	lib.participates("6")
	lib.participates("7")
}

# Zugangsvoraussetzungen anderer Maßnahmen, die System Immergrün (oder
# Zwischenfruchtanbau) voraussetzen.
violations contains {
	"rule_id": "O67-COMB-PREREQUISITE-FOR-8-16",
	"code": "measure_requires_participation_in_6_or_7",
	"measure_code": req.code,
} if {
	some req in lib.lists.measures_requiring_participation_in_6_or_7
	lib.participates(req.code)
	_requirement_scope_active(req.code)
	not lib.participates("6")
	not lib.participates("7")
}

_requirement_scope_active("16")

_requirement_scope_active("8") if {
	some m in object.get(input, ["farm", "oepul", "participations"], [])
	m.measure_code == "8"
	object.get(m, "year", lib.year) == lib.year
	"mulch_direct_strip_till" in object.get(m, "options", [])
}

# --- Mehrjährigkeit: einjährige Maßnahme ---
is_one_year_measure if {
	some m in lib.lists.one_year_measures
	m.code == lib.params.measure_code
}
