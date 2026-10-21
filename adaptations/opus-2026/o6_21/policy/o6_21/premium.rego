# Prämienberechnung (o6_21, Kapitel 9 und 10; SRL 1.9.2.2, 1.10.7, 1.12.2).
package oepul.o6_21.premium

import data.oepul.o6_21.administration
import data.oepul.o6_21.animals
import data.oepul.o6_21.composting
import data.oepul.o6_21.eligibility
import data.oepul.o6_21.lib

# O6_21-PREM-01/02: Summe der tierbezogenen Prämien (Standard- bzw. reduzierter Satz je RGVE).
animal_premium_total := lib.r2(sum([v | some v in animals.animal_premium]))

# O6_21-PREM-03: Zuschlag Festmistkompostierung je RGVE in der Maßnahme.
supplement_rate := lib.rate("supplement_solid_manure_composting", lib.year)

supplement_amount := lib.r2(animals.eligible_rgve * supplement_rate) if {
	composting.supplement_compliant
	count(eligibility.access_issues) == 0
}

supplement_amount := 0 if {
	not composting.supplement_compliant
}

supplement_amount := 0 if {
	composting.supplement_compliant
	count(eligibility.access_issues) > 0
}

measure_blocked if count(eligibility.access_issues) > 0

measure_blocked if administration.control_refused

measure_blocked if administration.exclusion_from_measure

measure_blocked if count(administration.applicant_issues) > 0

gross_amount := 0 if measure_blocked

gross_amount := lib.r2(animal_premium_total + supplement_amount) if not measure_blocked

# O6_21-SANC-01: inhaltliche Kürzung bezieht sich auf die Maßnahme inklusive aller Zuschläge.
after_sanctions := lib.r2((gross_amount * (100 - administration.content_reduction_percent)) / 100)

# O6_21-MOD-01: Betriebsgrößenmodulation nach Gesamtfläche des Betriebes.
farm_area := object.get(input, ["land", "total_area_ha"], 0)

modulation_factor := lib.modulation_factor(farm_area)

net_amount := lib.r2(after_sanctions * modulation_factor)

# O6_21-PAY-01: von der Gewährung kann abgesehen werden, wenn der Betrag 50 € nicht überschreitet.
payout_may_be_withheld if {
	net_amount > 0
	net_amount <= lib.tables.payment.min_payout_eur_exclusive
}

summary := {
	"year": lib.year,
	"eligible_rgve": animals.eligible_rgve,
	"rgve_by_category": animals.rgve_by_category,
	"animal_premium_total": animal_premium_total,
	"supplement_amount": supplement_amount,
	"gross_amount": gross_amount,
	"content_reduction_percent": administration.content_reduction_percent,
	"after_sanctions": after_sanctions,
	"modulation_factor": lib.r4(modulation_factor),
	"net_amount": net_amount,
	"max_advance_payment": administration.max_advance_payment(net_amount),
}
