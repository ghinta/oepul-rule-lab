# Prämienberechnung (Kapitel 6 Informationsblatt; SRL 2.16 „Höhe der Förderung“; Modulation und Flächenzugang).
package oepul.o6_16

import data.o6_16 as d

parcel_in_national_park(p) if object.get(p, "in_national_park", false) == true

parcel_in_protection_zone(p) if object.get(p, "in_water_protection_area", false) == true

parcel_in_protection_zone(_) if object.get(input, ["farm", "region", "water_protection_zone"], false) == true

# Grundsätzlich prämienfähige Schläge (keine AG-Fläche, kein OP-Code, kein Nationalpark)
premium_parcel(p) if {
	not is_ag_parcel(p)
	not parcel_has_op_code(p)
	not parcel_in_national_park(p)
}

base_parcels := [p | some p in area_parcels; premium_parcel(p)]

base_area_raw_ha := sum([p.area_ha | some p in base_parcels])

# Flächenzugang: 2024 und 2025 zur Gänze; danach max. 50 % auf Basis 2025, mindestens + 5,00 ha
area_increase_cap_ha(base_2025) := base_2025 + max_of(0.5 * base_2025, 5.0)

base_area_ha := min_of(base_area_raw_ha, area_increase_cap_ha(b25)) if {
	year >= 2026
	b25 := object.get(o16, "premium_area_2025_ha", null)
	b25 != null
}

base_area_ha := base_area_raw_ha if {
	not base_area_capped
}

base_area_capped if {
	year >= 2026
	object.get(o16, "premium_area_2025_ha", null) != null
}

# Basisprämie nur zu 50 % bei Teilnahme an „Biologische Wirtschaftsweise“ (1B) oder „Einschränkung ertragssteigernder Betriebsmittel“ (2)
base_component := "base_with_bio_or_eeb" if participates("1B")

base_component := "base_with_bio_or_eeb" if {
	not participates("1B")
	participates("2")
}

base_component := "base" if {
	not participates("1B")
	not participates("2")
}

premium_base := round2(base_area_ha * rate(base_component))

premium_training := round2(min_of(10, base_area_ha) * rate("training_first_10ha"))

# Zuschläge Pflanzenschutzmittelverzicht: nicht mit 1B kombinierbar, nicht in Schutz- und Schongebieten
psm_supplement_of(p) := r.psm_supplement if {
	some r in d.psm_restricted_crops
	r.crop == parcel_crop_name(p)
	r.psm_supplement != null
}

psm_parcel_amount(p) := p.area_ha * rate(psm_supplement_of(p))

premium_psm := round2(sum([psm_parcel_amount(p) |
	some p in base_parcels
	not participates("1B")
	not parcel_in_protection_zone(p)
	psm_supplement_of(p)
]))

premium_upper_austria := round2(sum([p.area_ha |
	some p in upper_austria_area_parcels
	premium_parcel(p)
]) * rate("upper_austria_topup"))

premium_ag := round2(ag_premium_area_ha * rate("ag_option"))

# Wien: keine Kombination mit Mulch-/Direktsaat/Strip-Till der Maßnahme 8 auf der Einzelfläche
premium_wien := round2(sum([p.area_ha |
	some p in wien_area_parcels
	premium_parcel(p)
	object.get(p, "erosion_protection_mulch_direct_striptill", false) != true
]) * rate("wien_humus")) if {
	wien_option_applied
}

premium_wien := 0 if not wien_option_applied

# Schweinefütterung: bis 2024 nur Gebietskulisse, ab 2025 auch Ackerflächen außerhalb
pig_premium_parcels := [p | some p in area_parcels; premium_parcel(p)] if year <= 2024

pig_premium_parcels := [p | some p in arable_parcels; premium_parcel(p)] if year >= 2025

premium_pig := round2(sum([p.area_ha | some p in pig_premium_parcels]) * rate("pig_feeding")) if {
	pig_option_applied
	pig_density_met
}

premium_pig := 0 if not pig_option_premium_due

pig_option_premium_due if {
	pig_option_applied
	pig_density_met
}

premium_cultan := round2(sum([p.area_ha |
	some p in cul_parcels
	parcel_in_area(p)
	premium_parcel(p)
	year >= 2025
]) * rate("cultan"))

premium_components := {
	"base": premium_base,
	"training_first_10ha": premium_training,
	"psm_supplements": premium_psm,
	"upper_austria_topup": premium_upper_austria,
	"ag_option": premium_ag,
	"wien_humus": premium_wien,
	"pig_feeding": premium_pig,
	"cultan": premium_cultan,
}

premium_total_before_modulation := round2(sum([v | some v in premium_components]))

# --- Betriebsgrößenmodulation ---
bracket_portion(total, b) := max_of(0, min_of(total, b.to_ha) - b.from_ha) if b.to_ha != null

bracket_portion(total, b) := max_of(0, total - b.from_ha) if b.to_ha == null

bracket_paid(total, b) := bracket_portion(total, b) * b.payout_share

modulation_factor(total) := 1 if total <= 0

modulation_factor(total) := f if {
	total > 0
	f := sum([bracket_paid(total, b) | some b in d.modulation_brackets]) / total
}

farm_modulation_factor := modulation_factor(object.get(input, ["land", "total_area_ha"], 0))

premium_total := round2(premium_total_before_modulation * farm_modulation_factor) if access_eligible

premium_total := 0 if not access_eligible

# Bagatellgrenze: von der Gewährung kann abgesehen werden, wenn der Auszahlungsbetrag 50 Euro nicht überschreitet
premium_below_minimum if premium_total <= 50

premium := {
	"eligible": access_eligible,
	"components": premium_components,
	"total_before_modulation": premium_total_before_modulation,
	"modulation_factor": farm_modulation_factor,
	"total": premium_total,
}

# Obergrenze der flächenbezogenen Zahlungen je ha (ohne Begrünung 6/7)
payment_cap_eur_ha(y) := c.cap_eur_ha if {
	some c in d.payment_caps
	startswith(c.scope, "Summe")
	y >= c.year_from
	c.year_to == null
}

payment_cap_eur_ha(y) := c.cap_eur_ha if {
	some c in d.payment_caps
	startswith(c.scope, "Summe")
	y >= c.year_from
	c.year_to != null
	y <= c.year_to
}
