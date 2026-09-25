# Premium calculation, modulation and payment for o6_9.
package oepul.o6_9

rate_row_valid(row, y) if {
	row.valid_from <= y
	row.valid_to == null
}

rate_row_valid(row, y) if {
	row.valid_from <= y
	row.valid_to != null
	y <= row.valid_to
}

rate(category, y) := row.rate if {
	some row in data.o6_9.premium_rates
	row.category == category
	rate_row_valid(row, y)
}

default premium_basis_ok := false

premium_basis_ok if {
	measure_contract_valid
	minimum_participation_met
	applicant_eligible
	first_year_min_size_met
}

slurry_premium_components[category] := round2(eligible_slurry_m3(category) * rate(category, year)) if {
	premium_basis_ok
	some category in params.slurry_application_categories
}

separation_premium := round2(eligible_separation_m3 * rate("separation", year)) if premium_basis_ok

else := 0

n_feeding_premium := round2(n_feeding_premium_area_ha * rate("n_reduced_pig_feeding", year)) if {
	premium_basis_ok
	n_feeding_eligible
}

else := 0

premium_components := object.union(slurry_premium_components, {
	"separation": separation_premium,
	"n_reduced_pig_feeding": n_feeding_premium,
})

premium_total_eur := round2(sum([v | some v in premium_components]))

# Modulation by total farm area: 100 % up to 200 ha, 90 % 200-300 ha,
# 85 % 300-1000 ha, 75 % above 1000 ha (piecewise, weighted).
bracket_upper(b, area) := b.to_ha if b.to_ha != null

else := area

bracket_portion(b, area) := max([0, min([area, bracket_upper(b, area)]) - b.from_ha])

modulation_factor(area) := 1 if area <= 0

modulation_factor(area) := f if {
	area > 0
	f := sum([x |
		some b in general.modulation_brackets
		x := bracket_portion(b, area) * b.factor
	]) / area
}

premium_after_modulation_eur := round2(premium_total_eur * modulation_factor(total_area_ha))

# Payments of 50 EUR or less may be withheld.
default payment_may_be_withheld := false

payment_may_be_withheld if premium_after_modulation_eur <= params.payment.min_payment_eur

advance_payment_max_eur := round2(premium_after_modulation_eur * params.payment.advance_payment_max_share)
