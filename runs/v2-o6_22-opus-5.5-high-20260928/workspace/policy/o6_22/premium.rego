# Tierwohl – Schweinehaltung (o6_22): premium calculation (EUR/GVE) incl.
# optional supplements and farm-size modulation.
package oepul.o6_22

# Rule: O622-PREM-RATES-01 (premium table, chapter 9 / SRL 2.22 Höhe der Förderung)
rate(c, component, y) := row.eur_per_gve if {
	some row in data.o6_22.premium_rates.rows
	row.measure_category == c
	row.component == component
	row.valid_from_year <= y
	rate_valid_to(row, y)
}

rate_valid_to(row, _) if row.valid_to_year == null

rate_valid_to(row, y) if {
	row.valid_to_year != null
	y <= row.valid_to_year
}

# Rule: O622-PREM-RATES-02 (from 2024 all rates raised by 8 %, rounded to one decimal)
impulse_rate(rate_2023) := round((rate_2023 * data.o6_22.premium_rates.impulse_increase_from_2024.factor) * 10) / 10

component_active(c, "base") if c in active_categories

component_active(c, "unkupiert") if supplement_active_for("unkupiert", c)

component_active(c, "gvo_frei_eiweiss") if supplement_active_for("gvo_frei_eiweiss", c)

component_active(c, "festmistkompostierung") if {
	composting_supplement_active
	supplement_active_for("festmistkompostierung", c)
	not composting_supplement_excluded
}

# Rule: O622-SCOPE-01 / O622-SCOPE-02 / O622-GEN-CAP-01 (base premium plus the three supplements;
# per-GVE premium, the per-hectare caps for area payments are not applied)
premium_components contains {
	"measure_category": c,
	"component": component,
	"gve": gve,
	"eur_per_gve": r,
	"amount_eur": r2(gve * r),
} if {
	some c, gve in category_gve
	some component in ["base", "unkupiert", "gvo_frei_eiweiss", "festmistkompostierung"]
	component_active(c, component)
	r := rate(c, component, year)
}

# Rule: O622-GEN-ACCESS-01 (access conditions: without them no valid contract and no premium)
measure_valid if {
	measure_applied
	min_participation_met
	applicant_eligible
	min_farm_size_ok
	not control_refused
}

gross_premium := r2(sum([p.amount_eur | some p in premium_components])) if measure_valid

else := 0

farm_total_area_ha := object.get(input, ["land", "total_area_ha"], 0)

# Rule: O622-GEN-MOD-01
net_premium := r2(gross_premium * modulation_factor(farm_total_area_ha))
