package oepul.o6_10

import rego.v1

farm_conflicts contains {"left": row.left, "right": row.right, "rule_id": "o6_10.combo_all_farm"} if {
	some row in t.farm_conflicts
	input.farm.year >= row.from_year
	active := array.concat(input.farm.oepul.active_measures, object.get(input.farm.oepul, "active_options", []))
	row.left in active
	row.right in active
	pair_excluded(row)
}

pair_excluded(row) if row.partial_organic_exception == false
pair_excluded(_) if input.farm.oepul.partial_organic == false

parcel_combination_conflicts contains {"parcel_id": term.parcel_id, "other": term.other, "rule_id": "o6_10.combine"} if {
	some term in combination_terms
	term.cell.mark == ""
}

parcel_combination_conflicts contains {"parcel_id": p.parcel_id, "other": "K20", "rule_id": "o6_10.k20_combination"} if {
	some p in input.land.parcels
	p.oepul.claimed_for_measure
	input.farm.year in {2023, 2024}
	"K20" in p.oepul.same_area_measures
}

requires_option_application(measure, option) if {
	some row in t.application_options
	measure in row.measures
	row.option == option
}

catch_crop_variant(number, year) := row if {
	some row in t.catch_crop_variants
	row.variant == number
	year >= row.first_year
	year <= row.last_year
}

management_exemption(use, measure, year) if {
	some row in t.management_exemptions
	row.use == use
	measure in row.measures
	year >= row.first_year
	year <= row.last_year
}

public_exception(measure, year) if {
	some row in t.public_exceptions
	row.measure == measure
	year >= row.first_year
	year <= row.last_year
}

annually_variable_units(measure, use) if {
	some row in t.variable_units
	row.measure == measure
	row.use in {"all", use}
}
