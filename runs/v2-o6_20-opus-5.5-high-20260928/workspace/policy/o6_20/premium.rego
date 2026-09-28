# Prämienberechnung (Informationsblatt Kap. 9, 10; SRL 1.9.2.2, 1.9.3.2, 1.10.7, 2.20.6;
# Allgemeine Teilnahmebedingungen 8.2, 9).
package oepul.o6_20.premium

import data.oepul.o6_20.application
import data.oepul.o6_20.common
import data.oepul.o6_20.eligibility
import data.oepul.o6_20.general
import data.oepul.o6_20.obligations
import data.oepul.o6_20.reporting
import data.oepul.o6_20.rgve

p := data.o6_20.premium

rates := {r.component: r | some r in p.rates_eur_per_rgve}

all_violations := (((eligibility.violations | obligations.violations) | reporting.violations) | application.violations) | general.violations

contract_valid if {
	count(common.categories) > 0
	count({v | some v in all_violations; v.severity == "contract_invalid"}) == 0
}

category_blocked(code) if {
	some v in all_violations
	v.severity == "category_invalid"
	v.category_code == code
}

category_premium_eligible(code) if {
	contract_valid
	eligibility.category_valid(code)
	not category_blocked(code)
	c := common.category_entry(code)
	obligations.base_grazing_met(c)
	not obligations.category_reported_non_compliant(c)
}

supplement_blocked(code) if {
	some v in all_violations
	v.severity == "no_supplement"
	v.category_code == code
}

supplement_eligible(code) if {
	category_premium_eligible(code)
	c := common.category_entry(code)
	obligations.supplement_grazing_met(c)
	not supplement_blocked(code)
}

# Basisprämie: für RGVE mit gleichzeitiger fakultativ gekoppelter Stützung (Almauftrieb) halbiert.
base_premium(code, rate) := (full_rgve * rate) + ((coupled * rate) * p.coupled_alpine_support_base_factor) if {
	category_premium_eligible(code)
	total := rgve.category_rgve(code)
	coupled := min([rgve.category_coupled_rgve(code), total])
	full_rgve := total - coupled
} else := 0

supplement_premium(code, rate) := rgve.category_rgve(code) * rate if supplement_eligible(code)

else := 0

category_results[code] := result if {
	some code in common.applied_category_codes
	common.category_defs[code]
	result := {
		"rgve": rgve.category_rgve(code),
		"coupled_support_rgve": rgve.category_coupled_rgve(code),
		"premium_eligible": is_eligible(code),
		"supplement_eligible": is_supplement_eligible(code),
		"base_premium_min_eur": base_premium(code, rates.base.min),
		"base_premium_max_eur": base_premium(code, rates.base.max),
		"supplement_premium_min_eur": supplement_premium(code, rates.supplement_150.min),
		"supplement_premium_max_eur": supplement_premium(code, rates.supplement_150.max),
	}
}

is_eligible(code) if category_premium_eligible(code)

else := false

is_supplement_eligible(code) if supplement_eligible(code)

else := false

gross_min := sum([(r.base_premium_min_eur + r.supplement_premium_min_eur) | some r in category_results])

gross_max := sum([(r.base_premium_max_eur + r.supplement_premium_max_eur) | some r in category_results])

# Betriebsgrößenmodulation nach Gesamtfläche des Betriebes.
band_area(area, band) := max([0, min([area, band.to_ha]) - band.from_ha]) if band.to_ha != null

band_area(area, band) := max([0, area - band.from_ha]) if band.to_ha == null

modulation_factor(area) := 1 if area <= 0

modulation_factor(area) := sum([(band_area(area, b) * b.share) | some b in p.modulation_bands]) / area if area > 0

farm_area := object.get(input, ["land", "total_area_ha"], 0)

modulation := modulation_factor(farm_area)

# Sanktionsstufen für inhaltliche Verstöße (ab 2027 Einbehalt 1 % statt Verwarnung).
sanction_stage := object.get(common.tw, "sanction_stage", "none")

sanction_percent := 0 if sanction_stage == "none"

sanction_percent := s.reduction_percent if {
	some s in p.sanction_stages
	s.stage == sanction_stage
	common.year < p.warning_replaced_by_withholding_from_year
}

sanction_percent := s.withholding_percent_from_2027 if {
	some s in p.sanction_stages
	s.stage == sanction_stage
	common.year >= p.warning_replaced_by_withholding_from_year
}

exclusion_with_repayment if sanction_stage == "exclusion"

net_min := ((gross_min * modulation) * (100 - sanction_percent)) / 100

net_max := ((gross_max * modulation) * (100 - sanction_percent)) / 100

below_min_payout if net_max <= p.min_payout_threshold_eur

max_advance_min_eur := net_min * p.advance_payment_max_share

payment_deadline := common.md_date(common.year + 1, p.payment_deadline_month_day_following_year)

# Querverweis SRL 2.21: reduzierter Satz in "Tierwohl – Stallhaltung Rinder" bei gleichzeitiger Teilnahme.
o6_21_rate := p.cross_measure_o6_21.reduced_rate_eur_per_rgve if {
	contract_valid
	object.get(input, ["oepul_measures", "tierwohl_stallhaltung_rinder", "participating"], false) == true
}

summary := {
	"contract_valid": is_contract_valid,
	"total_rgve": rgve.total_rgve,
	"categories": category_results,
	"gross_min_eur": gross_min,
	"gross_max_eur": gross_max,
	"modulation_factor": modulation,
	"sanction_percent": sanction_percent,
	"net_guaranteed_min_eur": net_min,
	"net_max_eur": net_max,
	"below_min_payout_threshold": is_below_min_payout,
	"max_advance_payment_eur": max_advance_min_eur,
	"payment_deadline": payment_deadline,
}

is_contract_valid if contract_valid

else := false

is_below_min_payout if below_min_payout

else := false
