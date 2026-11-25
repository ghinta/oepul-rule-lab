# METADATA
# title: ÖPUL 2023 Naturschutz (18) – Gesamtentscheidung
# description: Bündelt Verstöße, Hinweise und Prämie der Maßnahme o6_18.
package oepul.o6_18

import data.oepul.o6_18.administration
import data.oepul.o6_18.combinations
import data.oepul.o6_18.eligibility
import data.oepul.o6_18.notices_2026
import data.oepul.o6_18.obligations
import data.oepul.o6_18.premium

violations := (((eligibility.violations | obligations.violations) | combinations.violations) | administration.violations) | notices_2026.violations

findings := premium.findings | administration.findings

compliant if count(violations) == 0

decision := {
	"measure": "o6_18",
	"year": input.farm.year,
	"compliant": count(violations) == 0,
	"violations": violations,
	"findings": findings,
	"parcel_premium_eur": premium.parcel_premium,
	"regional_plan_premium_eur": premium.regional_plan_payable,
	"total_premium_eur": total_premium,
	"modulation_factor": premium.modulation_factor,
	"div_countable_parcels": combinations.div_countable,
}

total_premium := premium.total_premium if premium.rates_available

total_premium := null if not premium.rates_available
