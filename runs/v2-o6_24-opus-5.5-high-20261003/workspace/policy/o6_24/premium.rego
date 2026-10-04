package oepul.o6_24

import rego.v1

# Prämie (Maßnahmenblatt 7; SRL 2.24 Höhe der Förderung), Modulation, Obergrenze,
# Flächenabweichungen und inhaltliche Sanktionen (Allgemeine Teilnahmebedingungen 8.2,
# 9; SRL 1.9, 1.12; GSP-AV §§ 11, 46 bis 48).

premium_rate_eur_per_ha := r.eur_per_ha if {
	some r in premium_data.rates
	farm_year >= r.from_year
	farm_year <= r.to_year
}

non_eligible_codes := {c | some c in premium_data.non_eligible_codes}

# Gründe, aus denen ein Schlag in der Gebietskulisse nicht prämienfähig ist.
parcel_ineligibility[p.parcel_id] contains "Bewilligung zu erhöhten Stickstoffdüngergaben (Code OPWRRL)" if {
	some p in area_arable_parcels
	object.get(wrrl_of(p), "increased_n_permit", false) == true
}

parcel_ineligibility[p.parcel_id] contains sprintf("Code %s", [c]) if {
	some p in area_arable_parcels
	some c in codes_of(p)
	c in non_eligible_codes
}

parcel_ineligibility[p.parcel_id] contains "Brachfläche (SRL 2.24)" if {
	some p in area_arable_parcels
	is_fallow(p)
}

parcel_ineligibility[p.parcel_id] contains "Mindestbewirtschaftung nicht erfüllt" if {
	some p in area_arable_parcels
	not min_management_met(p)
}

parcel_ineligibility[pid] contains reason if {
	some pid, reasons in op_required_reasons
	area_arable_parcels[pid]
	some reason in reasons
}

parcel_ineligibility[p.parcel_id] contains "Fläche nicht in Österreich" if {
	some p in area_arable_parcels
	parcel_outside_austria(p)
}

parcel_ineligibility[p.parcel_id] contains "Fläche kleiner 50 m²" if {
	some p in area_arable_parcels
	parcel_below_min_size(p)
}

parcel_ineligibility[p.parcel_id] contains "nicht hauptsächlich landwirtschaftlich genutzt" if {
	some p in area_arable_parcels
	non_agricultural_use_excess(p)
}

parcel_ineligibility[p.parcel_id] contains "Fläche nicht für o6_24 im Mehrfachantrag angegeben" if {
	some p in area_arable_parcels
	object.get(p, ["oepul", "declared_for_o6_24"], true) == false
}

parcel_ineligibility[pid] contains "Maßnahmenkombination auf der Einzelfläche nicht zulässig (Anhang L)" if {
	some pid, _ in combination_conflicts
	area_arable_parcels[pid]
}

# Maßnahmenblatt 5: prämienfähige Flächen werden anhand der Gebietskulisse ermittelt.
eligible_parcels contains pid if {
	some pid, _ in area_arable_parcels
	not parcel_ineligibility[pid]
}

eligible_area_ha := sum([area_arable_parcels[pid].area_ha | some pid in eligible_parcels])

# Maßnahmenblatt 5 (Bewilligungsflächen mit OPWRRL kennzeichnen).
opwrrl_code_missing contains p.parcel_id if {
	some p in area_arable_parcels
	object.get(wrrl_of(p), "increased_n_permit", false) == true
	not "OPWRRL" in codes_of(p)
}

gross_premium_eur := round((eligible_area_ha * premium_rate_eur_per_ha) * 100) / 100 if {
	participation_eligible
} else := 0

# Modulation nach Gesamtfläche des Betriebes (Allgemeine Teilnahmebedingungen 9.3).
tier_area(total, tier) := max([0, min([total, tier_upper(tier, total)]) - tier.from_ha_exclusive])

tier_upper(tier, total) := tier.to_ha_inclusive if {
	is_number(tier.to_ha_inclusive)
} else := total

modulation_factor := 1 if {
	object.get(input, ["land", "total_area_ha"], 0) <= 200
} else := f if {
	total := input.land.total_area_ha
	weighted := [w |
		some t in data.o6_24.oepul_modulation.tiers
		w := tier_area(total, t) * t.payout_share
	]
	f := sum(weighted) / total
}

# Inhaltliche Sanktionen (GSP-AV § 48; Allgemeine Teilnahmebedingungen 8.2).
stages := data.o6_24.oepul_sanktionsstufen.stages

findings := object.get(o624, "content_findings", [])

finding_level(f) := min([6, f.base_level + object.get(f, "previous_occurrences_same_obligation", 0)])

stage_percent(level) := 1 if {
	level == 0
	farm_year >= 2027
} else := s.reduction_percent if {
	some s in stages
	s.level == level
}

content_reduction_percent := min([100, sum([stage_percent(finding_level(f)) | some f in findings])])

previous_100pct_reductions := object.get(o624, "previous_100pct_reductions_in_period", 0)

measure_exclusion if {
	content_reduction_percent == 100
	previous_100pct_reductions + 1 >= data.o6_24.oepul_sanktionsstufen.exclusion_after_100pct_count
}

# Flächenabweichung (GSP-AV § 46): Übererklärung > 3 % oder > 2 ha -> Abzug 1,5-fache Differenz.
declared_area := object.get(o624, "declared_area_ha", eligible_area_ha)

determined_area := object.get(o624, "determined_area_ha", declared_area)

area_difference := declared_area - determined_area

area_sanction_applies if {
	area_difference > 0
	area_difference > determined_area * 0.03
}

area_sanction_applies if area_difference > 2

calculation_area_ha := max([0, determined_area - (1.5 * area_difference)]) if {
	area_sanction_applies
} else := min([declared_area, determined_area])

# GSP-AV § 47: Untererklärung – Kürzung bis zu 3 % bei Differenz über 3 %.
under_declaration_reduction_possible if {
	undeclared := object.get(oepul, "undeclared_parcels_area_ha", 0)
	total_declared := object.get(input, ["land", "total_area_ha"], 0)
	undeclared > total_declared * 0.03
}

premium_after_area_and_content := round((((calculation_area_ha * premium_rate_eur_per_ha) * (100 - content_reduction_percent)) / 100) * 100) / 100 if {
	participation_eligible
	not measure_exclusion
	not controls_obstructed
} else := 0

premium_after_modulation := round((premium_after_area_and_content * modulation_factor) * 100) / 100

# Obergrenze für Flächenzahlungen (SRL 1.9.2.1) je Schlag.
area_payment_cap := r.eur_per_ha if {
	some r in data.o6_24.oepul_flaechenzahlung_obergrenzen.rows
	r.key == "general"
	farm_year >= r.year_from
	farm_year <= r.year_to
}

cap_exceeded_parcels[pid] := total if {
	some pid in eligible_parcels
	other := object.get(area_arable_parcels[pid], ["oepul", "other_area_payments_eur_per_ha"], 0)
	total := other + (premium_rate_eur_per_ha * modulation_factor)
	total > area_payment_cap
}

# GSP-AV § 11 / SRL 1.10.7: Auszahlungsbetrag bis 50 Euro kann entfallen.
payment_may_be_waived if {
	premium_after_modulation > 0
	premium_after_modulation <= data.o6_24.oepul_zahlung.min_payment_eur
}
