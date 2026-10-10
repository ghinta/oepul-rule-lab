package oepul.o6_17

# Gesamtentscheidung für die Maßnahme „Humuserhalt und Bodenschutz auf
# umbruchsfähigem Grünland“.

import data.oepul.o6_17.agl
import data.oepul.o6_17.common
import data.oepul.o6_17.eligibility
import data.oepul.o6_17.general
import data.oepul.o6_17.livestock
import data.oepul.o6_17.obligations
import data.oepul.o6_17.premium
import data.oepul.o6_17.sanctions

violations := (obligations.violations | agl.violations) | general.violations

missing_inputs := obligations.missing_inputs | {c | some c in livestock.unknown_rgve_categories; c != null}

decision := {
	"measure": "o6_17",
	"application_year": common.year,
	"contract_active": common.contract_active,
	"access_requirements_met": eligibility.access_requirements_met,
	"access_failures": eligibility.access_failures,
	"access_consequence": eligibility.consequence,
	"livestock": {
		"rgve_total": livestock.rgve_total,
		"fodder_area_ha": livestock.fodder_area_ha,
		"is_livestock_holding": livestock.is_livestock_holding,
	},
	"soil_samples": {
		"required": obligations.required_soil_samples,
		"valid": obligations.valid_soil_sample_count,
	},
	"training_fulfilled": obligations.training_fulfilled,
	"violations": violations,
	"missing_inputs": missing_inputs,
	"premium": premium.summary,
	"sanctions": sanctions.summary,
	"general": general.summary,
}
