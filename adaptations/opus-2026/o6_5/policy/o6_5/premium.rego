# title: o6_5 – Prämienberechnung
# description: >-
#   Prämiensätze je Tierkategorie und Prämienstufe, Zuschläge für besondere
#   Generhaltungsprogramme und Milchleistungskontrolle, Kürzungsstufen,
#   Betriebsgrößenmodulation und Auszahlungsgrößen.
package oepul.o6_5

# O6_5-PREM-RATES-PERIOD: Antragsjahr 2023 bzw. Prämiensätze ab 01.01.2024.
rate_period := "2023" if {
	year == 2023
} else := "ab_2024"

rate_row(category) := r if {
	some r in data.o6_5.premium_rates
	r.category == category
	r.rate_period == rate_period
}

stage_field := {"A": "stage_a_eur", "B": "stage_b_eur"}

# O6_5-PREM-STAGE-ASSIGNMENT / O6_5-PREM-RATES
base_rate(a) := rate_row(a.animal_category)[stage_field[breed_meta[a.breed].premium_stage]]

# O6_5-PREM-GEP-SURCHARGE: Zuschlag für Rassen mit besonderem Generhaltungsprogramm.
gep_surcharge(a) := rate_row(a.animal_category).gep_surcharge_eur if {
	breed_meta[a.breed].special_gep == true
} else := 0

# O6_5-PREM-MLK-SURCHARGE: Zuschlag für Kühe mit Milchleistungskontrolle.
mlk_surcharge(a) := rate_row(a.animal_category).mlk_surcharge_eur if {
	a.animal_category == "kuh"
	a.milk_recording == true
} else := 0

round2(x) := round(x * 100) / 100

animal_premium(a) := round2((base_rate(a) + gep_surcharge(a)) + mlk_surcharge(a)) if {
	is_number(base_rate(a))
}

# Summe der Prämien aller förderbaren Förderplätze (vor Kürzungen und Modulation).
premium_total_eur := round2(sum([slot_premium(animal_by_id[id]) | some id in eligible_slot_ids]))

# O6_5-GEN-SANCTION-STAGES / O6_5-GEN-SANCTION-2027-RETENTION / O6_5-GEN-EXCLUSION-TWO-100
sanction_stage := object.get(participation, "content_violation_stage", "none")

sanction_stage_row := r if {
	some r in data.o6_5.sanction_stages
	r.stage == sanction_stage
}

excluded_from_measure if {
	object.get(participation, "full_reductions_in_contract_period", 0) >= params.sanction_exclusion_after_full_reductions
}

excluded_from_measure if sanction_stage == "exclusion"

default reduction_percent := 0

reduction_percent := 100 if {
	excluded_from_measure
} else := 0 if {
	sanction_stage == "none"
} else := sanction_stage_row.reduction_percent_from_2027 if {
	year >= params.warning_replaced_by_retention_from_year
} else := sanction_stage_row.reduction_percent

# O6_5-GEN-MODULATION: Betriebsgrößenmodulation nach Gesamtfläche des Betriebes.
total_area_ha := object.get(input, ["land", "total_area_ha"], 0)

bracket_upper(b) := b.upper_ha if {
	b.upper_ha != null
	b.upper_ha < total_area_ha
} else := total_area_ha

modulated_area_ha := sum([x | some b in data.o6_5.modulation_brackets; total_area_ha > b.lower_ha; x := (bracket_upper(b) - b.lower_ha) * b.factor])

modulation_factor := 1 if {
	total_area_ha <= 0
} else := modulated_area_ha / total_area_ha

premium_after_reductions_eur := round2(((premium_total_eur * (100 - reduction_percent)) / 100) * modulation_factor)

# Auszahlungsbetrag für o6_5 (0, wenn Zugangs-/Vertragsvoraussetzungen fehlen).
payout_eur := premium_after_reductions_eur if {
	access_requirements_met
} else := 0

# O6_5-GEN-SMALL-AMOUNT: Auszahlungsbeträge bis 50 Euro können entfallen.
payout_may_be_waived if {
	payout_eur > 0
	payout_eur <= params.small_payout_threshold_eur
}

# O6_5-GEN-PAYMENT-TIMING: Teilzahlung max. 75 %, Auszahlung bis 30.06. des Folgejahres.
max_advance_payment_eur := round2(payout_eur * params.advance_payment_max_share)

payment_deadline := concat("-", [format_int(year + 1, 10), params.payment_deadline_md])
