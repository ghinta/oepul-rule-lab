# Prämienberechnung System Immergrün: Prämienband 70–90 €/ha Ackerfläche,
# Einzelflächen-Kombinierbarkeit (Anhang L), OP-/VF-Codes, Nationalparks,
# Betriebsgrößenmodulation und Mindestauszahlungsbetrag.
package o6_7.premium

import data.o6_7.eligibility
import data.o6_7.exit
import data.o6_7.general
import data.o6_7.lib

prem := lib.params.premium

combinable_codes := {c | some c in lib.combinations.o6_7_parcel_combinable_measures}

# Flächencodes, die einer Maßnahme zugeordnet sind (für Anhang L).
code_measure := {"NAT": "18", "EBW": "19", "UBB": "1A", "BIO": "1B"}

parcel_measures(p) := {m | some m in object.get(p, "oepul_measures", [])} | {code_measure[c] | some c in object.get(p, "oepul_codes", []); code_measure[c]}

no_premium_reasons[p.parcel_id] contains "op_or_vf_code" if {
	some p in lib.arable_parcels
	some c in object.get(p, "oepul_codes", [])
	c in lib.lists.no_premium_parcel_codes
}

no_premium_reasons[p.parcel_id] contains "measure_specific_op_code" if {
	some p in lib.arable_parcels
	lib.params.measure_code in object.get(p, "op_measure_codes", [])
}

no_premium_reasons[p.parcel_id] contains "other_arable_land" if {
	some p in lib.arable_parcels
	p.usage_category in lib.lists.always_ungreened_usage_categories
}

no_premium_reasons[p.parcel_id] contains sprintf("not_combinable_with_%s", [m]) if {
	some p in lib.arable_parcels
	some m in parcel_measures(p)
	m != lib.params.measure_code
	not m in combinable_codes
}

# Weitergeführte 20-jährige Verpflichtungen (K20) sind auf der Einzelfläche
# mit keinen anderen Maßnahmen kombinierbar.
no_premium_reasons[p.parcel_id] contains "k20_not_combinable" if {
	some p in lib.arable_parcels
	"K20" in object.get(p, "oepul_codes", [])
}

no_premium_reasons[p.parcel_id] contains "national_park_no_premium" if {
	some p in lib.arable_parcels
	p.national_park in lib.lists.no_premium_national_parks
}

no_premium_reasons[p.parcel_id] contains "outside_austria" if {
	some p in lib.arable_parcels
	p.is_in_austria == false
}

no_premium_reasons[p.parcel_id] contains "non_eligible_area_type" if {
	some p in lib.arable_parcels
	p.area_type_code in lib.lists.non_eligible_area_type_codes
}

no_premium_reasons[p.parcel_id] contains "gloez8_npf_catch_crop_2024" if {
	some p in lib.arable_parcels
	lib.year == prem.not_eligible_npf_year
	p.gloez8_npf_variant in lib.lists.gloez8_npf_catch_crop_variants_not_eligible_2024
}

# Grünbrachen sind nicht aktiv bewirtschaftet (keine Prämie), zählen aber als
# begrünte Fläche; Biodiversitätsflächen (DIV) von UBB/BIO sind ausgenommen.
no_premium_reasons[p.parcel_id] contains "green_fallow_not_actively_farmed" if {
	some p in lib.arable_parcels
	p.usage_category == "green_fallow"
	not "DIV" in object.get(p, "oepul_codes", [])
}

no_premium_reasons[pid] contains "harvest_obligation_not_met" if {
	some pid in general.harvest_obligation_breach
}

no_premium_reasons[pid] contains "transferred_without_continuation" if {
	some pid in general.transfer_not_continued
}

eligible_parcels contains p if {
	some p in lib.arable_parcels
	not no_premium_reasons[p.parcel_id]
}

eligible_area_ha := sum([p.area_ha | some p in eligible_parcels])

# Maßnahme im Förderjahr gültig (Vertrag besteht und wurde nicht abgemeldet).
default measure_valid := false

measure_valid if {
	eligibility.access_ok
	not exit.withdrawn_in_year
	not lib.participates("6")
	not general.control_refused
	count({v | some v in eligibility.violations; v.rule_id in _contract_blocking_rules}) == 0
}

_contract_blocking_rules := {
	"O67-APPLICANT-TYPE",
	"O67-APPLICANT-PUBLIC-SHARE",
	"O67-APPLICANT-ACTIVE-FARMER",
	"O67-APPLICATION-DEADLINE",
	"O67-LAST-ENTRY",
	"O67-GEN-FARM-MIN-SIZE",
}

# Betriebsgrößenmodulation auf Basis der Gesamtfläche des Betriebes.
total_area_ha := object.get(input, ["land", "total_area_ha"], lib.arable_area_ha)

bracket_ha(b, total) := max([0, min([total, b.to_ha_inclusive]) - b.from_ha_exclusive]) if b.to_ha_inclusive != null

bracket_ha(b, total) := max([0, total - b.from_ha_exclusive]) if b.to_ha_inclusive == null

modulation_factor_for(total) := 1 if {
	total <= 0
} else := sum([(bracket_ha(b, total) * b.payout_share) | some b in lib.general.modulation_brackets]) / total

modulation_factor := modulation_factor_for(total_area_ha)

rate_eur_per_ha := r if {
	r := input.farm.oepul.o6_7.premium_rate_eur_per_ha
	r >= prem.min_eur_per_ha
	r <= prem.max_eur_per_ha
} else := prem.guaranteed_eur_per_ha

round2(x) := round(x * 100) / 100

premium_eur := round2((eligible_area_ha * rate_eur_per_ha) * modulation_factor) if measure_valid

else := 0

premium_min_eur := round2((eligible_area_ha * prem.min_eur_per_ha) * modulation_factor) if measure_valid

else := 0

premium_max_eur := round2((eligible_area_ha * prem.max_eur_per_ha) * modulation_factor) if measure_valid

else := 0

# Von der Gewährung kann abgesehen werden, wenn der Betrag 50 Euro nicht
# überschreitet.
default below_min_payout := false

below_min_payout if premium_eur <= prem.min_payout_eur

# System Immergrün wird nicht in die Obergrenze für Flächenzahlungen
# eingerechnet.
default excluded_from_payment_cap := false

excluded_from_payment_cap if {
	some c in lib.general.payment_caps
	c.year_from <= lib.year
	_cap_open(c.year_to)
	lib.params.measure_code in c.excluded_measures
}

_cap_open(to_year) if to_year == null

_cap_open(to_year) if to_year >= lib.year

summary := {
	"measure_valid": measure_valid,
	"eligible_area_ha": eligible_area_ha,
	"rate_eur_per_ha": rate_eur_per_ha,
	"modulation_factor": modulation_factor,
	"premium_eur": premium_eur,
	"premium_band_eur": {"min": premium_min_eur, "max": premium_max_eur},
	"below_min_payout": below_min_payout,
	"excluded_from_payment_cap": excluded_from_payment_cap,
	"no_premium_parcels": no_premium_reasons,
}
