package oepul.o6_10

import rego.v1

t := data.o6_10_tables

# A crop group is a legal classification. A catalogue name can refine orchard,
# including grouped entries such as related Aronia cultivars.
crop_group(p) := p.crop.crop_category if {
	p.crop.crop_category in {"vineyard", "hop"}
	p.oepul.excluded_crop_use == false
} else := "orchard" if {
	p.crop.crop_category == "orchard"
	p.oepul.excluded_crop_use == false
	name := fruit_name(p)
	some f in t.fruit
	lower(name) == lower(f.name)
	input.farm.year >= f.first_year
}

is_cereal(name) if {
	some x in t.cereals
	lower(name) == lower(x)
}

crop_list(name) := t[name] if name in {"fodder", "vegetables", "non_cereals", "div_variants"}

# An incomplete list must not establish loss of the contract.
classification_known(p) if p.oepul.in_at == false
classification_known(p) if p.oepul.in_mfa == false
classification_known(p) if p.oepul.excluded_crop_use == true

classification_known(p) if {
	is_string(p.crop.crop_category)
	not p.crop.crop_category in {"vineyard", "hop", "orchard"}
}

classification_known(p) if {
	p.oepul.in_at == true
	p.oepul.in_mfa == true
	p.oepul.excluded_crop_use == false
	p.crop.crop_category in {"vineyard", "hop"}
	is_number(p.area_ha)
	p.area_ha >= 0
}

classification_known(p) if {
	p.oepul.in_at == true
	p.oepul.in_mfa == true
	p.oepul.excluded_crop_use == false
	p.crop.crop_category == "orchard"
	orchard_classification_known(p)
	is_number(input.farm.year)
	is_number(p.area_ha)
	p.area_ha >= 0
}

orchard_classification_known(p) if is_string(p.oepul.fruit_group)

orchard_classification_known(p) if {
	some f in t.fruit
	lower(p.crop.crop_name) == lower(f.name)
}

known_measure_area_ha := sum([p.area_ha |
	some p in input.land.parcels
	p.oepul.in_at == true
	p.oepul.in_mfa == true
	crop_group(p)
	is_number(p.area_ha)
	p.area_ha >= 0
]) if {
	is_array(input.land.parcels)
}

measure_area_ha := known_measure_area_ha if {
	is_array(input.land.parcels)
	every p in input.land.parcels { classification_known(p) }
}

meets_measure_minimum if known_measure_area_ha >= 0.5

else := false if measure_area_ha < 0.5

farm_minimum if {
	is_number(input.farm.oepul.first_year)
	input.farm.oepul.first_year < input.farm.year
} else if {
	input.farm.oepul.first_year == input.farm.year
	is_number(input.land.mfa_protected_ha)
	input.land.mfa_protected_ha >= 0.5
} else := result if {
	input.farm.oepul.first_year == input.farm.year
	is_number(input.land.mfa_qualifying_ha)
	result := input.land.mfa_qualifying_ha >= 1.5
	any_lower_bound_known(result)
}

any_lower_bound_known(true) := true
any_lower_bound_known(false) if is_number(input.land.mfa_protected_ha)

public_entity(applicant) if applicant.kind == "public"

public_entity(applicant) if {
	is_number(applicant.public_share_pct)
	applicant.public_share_pct > 25
}

public_entity(applicant) if applicant.equivalent_or_indirect_public_control == true

permitted_form(applicant) if {
	applicant.kind in {"individual", "registered_partnership", "legal_person", "association", "public"}
	public_exception("10", input.farm.year)
}

permitted_form(applicant) if {
	input.farm.year >= 2025
	applicant.kind == "individual"
}

permitted_form(applicant) if {
	input.farm.year >= 2025
	applicant.kind in {"individual", "registered_partnership", "legal_person", "association"}
	applicant.equivalent_or_indirect_public_control == false
	is_number(applicant.public_share_pct)
	not public_entity(applicant)
}

applicant_allowed if {
	applicant := input.farm.oepul.applicant
	applicant.active_farmer
	applicant.agricultural_activity
	applicant.own_name_and_account
	applicant.disposal_rights
	permitted_form(applicant)
}

date_ns(date) := time.parse_rfc3339_ns(concat("", [date, "T00:00:00Z"])) if is_string(date)
year_of(date) := time.date(date_ns(date))[0]

withdrawn(contract) if year_of(contract.withdrawn_on) == input.farm.year
no_withdrawal(contract) if contract.withdrawn_on == null
no_withdrawal(contract) if year_of(contract.withdrawn_on) > input.farm.year

# Fristen knüpfen an den Kontrollzeitpunkt an. Bei gleichem Kalendertag
# lässt sich die Reihenfolge mit Datumsangaben allein nicht ermitteln.
withdrawal_timing(contract) := "after_control" if {
	withdrawn(contract)
	some key in {"control_announced_on", "onsite_on", "administrative_result_on"}
	date_ns(contract[key]) < date_ns(contract.withdrawn_on)
} else := "clear" if {
	withdrawn(contract)
	every key in {"control_announced_on", "onsite_on", "administrative_result_on"} {
		control_after_or_absent(contract[key], contract.withdrawn_on)
	}
} else := "unresolved" if withdrawn(contract)

control_after_or_absent(control, _) if control == null
control_after_or_absent(control, day) if date_ns(control) > date_ns(day)

contract_route := "withdrawal_after_control" if {
	withdrawal_timing(input.farm.oepul.contract) == "after_control"
} else := "withdrawal_timing_unresolved" if {
	withdrawal_timing(input.farm.oepul.contract) == "unresolved"
} else := "withdrawn" if {
	withdrawn(input.farm.oepul.contract)
} else := "below_minimum" if {
	meets_measure_minimum == false
} else := "takeover" if {
	takeover_allowed
	no_withdrawal(input.farm.oepul.contract)
	input.farm.oepul.contract.annual_mfa_with_units
	meets_measure_minimum
} else := "continuation" if {
	contract := input.farm.oepul.contract
	contract.previous_active
	contract.annual_mfa_with_units
	no_withdrawal(contract)
	meets_measure_minimum
	input.farm.year in numbers.range(2023, 2028)
} else := "new_application" if {
	contract := input.farm.oepul.contract
	contract.previous_active == false
	contract.annual_mfa_with_units
	no_withdrawal(contract)
	ordinary_entry_timely(contract)
	meets_measure_minimum
}

takeover_allowed if {
	tariff_year(input.farm.year)
	takeover := input.farm.oepul.takeover
	takeover.previously_participating == false
	takeover.mfa_online
	takeover.ama_approved
	takeover.transferred_ha > 0
	takeover.additional_ha >= 0
	takeover.additional_ha <= takeover.transferred_ha * 0.5
	year_of(takeover.applied_on) == input.farm.year
	takeover.applied_on <= takeover_cutoff(input.farm.year)
}

takeover_cutoff(y) := sprintf("%d-04-17", [y]) if y in {2023, 2028}

else := sprintf("%d-04-15", [y])

terrace(p) if {
	crop_group(p) == "vineyard"
	p.oepul.wine_terrace
	is_number(p.oepul.section_slope_pct)
	p.oepul.section_slope_pct >= 25
}

fruit_name(p) := p.oepul.fruit_group if is_string(p.oepul.fruit_group)

else := p.crop.crop_name

# Die Einstiegsfrist betrifft den regulären Neuantrag. Die genehmigte
# Übernahme hat eigene Voraussetzungen.
ordinary_entry_timely(contract) := false if {
	contract.previous_active == false
	is_number(input.farm.year)
	not input.farm.year in numbers.range(2023, 2027)
} else := valid if {
	contract.previous_active == false
	y := year_of(contract.applied_on)
	valid := y == (input.farm.year - 1)
	contract.applied_on >= "2022-11-02"
} else := false if {
	contract.previous_active == false
	date_ns(contract.applied_on) < date_ns("2022-11-02")
}

contract_period(y) := {"from": sprintf("%d-01-01", [y]), "through": sprintf("%d-12-31", [y])} if tariff_year(y)
