# Prämienberechnung, Prämienbegrenzungen, Modulation und Mindestbetrag (o6_9)
package oepul.o6_9

# O69-MB-041 / O69-SRL-005: Prämiensatz je Verfahren und Jahr gemäß Tabelle.
rate_for(technique, y) := row.rate_eur if {
	some row in tables.premium_rates.rows
	row.technique == technique
	y >= row.year_from
	rate_row_open_or_covers(row, y)
}

rate_row_open_or_covers(row, _) if row.year_to == null

rate_row_open_or_covers(row, y) if {
	row.year_to != null
	y <= row.year_to
}

# O69-MB-044 / O69-SRL-007 / O69-NAPV-001: düngungswürdige Fläche = Acker- und Grünlandflächen mit N-Düngebedarf.
non_fertilizable_crop_names := {lower(row.crop) | some row in tables.fertilizable_area.non_fertilizable_crops}

parcel_without_n_demand(p) if lower(object.get(p, ["crop", "crop_name"], "")) in non_fertilizable_crop_names

parcel_without_n_demand(p) if is_true(object.get(p, "crop", {}), "is_legume_pure_stand")

parcel_without_n_demand(p) if {
	object.get(p, ["crop", "crop_category"], "") in {c | some c in tables.fertilizable_area.non_fertilizable_crop_categories}
	not is_false(object.get(p, "crop", {}), "is_legume_pure_stand")
}

parcel_without_n_demand(p) if is_true(object.get(p, "constraints", {}), "full_fertilization_ban")

parcel_fertilizable(p) if {
	p.land_use in {u | some u in tables.fertilizable_area.eligible_land_uses}
	not parcel_without_n_demand(p)
}

fertilizable_area_ha := sum([p.area_ha | some p in parcels; parcel_fertilizable(p)])

# O69-MB-042: Prämie für maximal 50 m³ je ha düngungswürdiger (nicht gedüngter) Acker- und Grünlandfläche.
application_cap_m3 := tables.premium_rates.caps.application_m3_per_fertilizable_ha * fertilizable_area_ha

eligible_application_volume := min2(eligible_application_volume_raw, application_cap_m3)

# Annahme A-03: Kürzung bei Überschreitung der Obergrenze proportional über alle Verfahren.
application_scaling := eligible_application_volume / application_volume_total if application_volume_total > 0

application_scaling := 0 if application_volume_total == 0

application_premium_by_technique[t] := round2((v * application_scaling) * rate_for(t, year)) if {
	claims_application_volume
	some t, v in claimed_application_volumes
	v > 0
}

application_premium := sum([v | some _, v in application_premium_by_technique])

# O69-MB-043: Prämie für Gülleseparierung höchstens für 20 m³ je Rinder-GVE und Jahr.
eligible_separation_volume := min2(eligible_separation_volume_raw, separation_cap_m3)

default separation_premium := 0

separation_premium := round2(eligible_separation_volume * rate_for("separation", year)) if claims_separation_volume

# O69-MB-045: 54 €/ha Ackerfläche für stark N-reduzierte Fütterung (ab 2025).
pig_feeding_premium_area_ha := sum([p.area_ha | some p in parcels; p.land_use == "arable"; parcel_premium_eligible(p)]) if count(parcels) > 0

pig_feeding_premium_area_ha := arable_area_ha if count(parcels) == 0

default pig_feeding_premium := 0

pig_feeding_premium := round2(pig_feeding_premium_area_ha * rate_for("pig_feeding", year)) if pig_feeding_premium_eligible

# O69-MB-046 / O69-GEN-025: Summe vor Modulation; Prämiengewährung gemäß beantragter Menge.
premium_before_modulation := round2((application_premium + separation_premium) + pig_feeding_premium)

# O69-GEN-023: Betriebsgrößenmodulation in Abhängigkeit zur gesamten Fläche des Betriebes.
band_share(band, area) := (min2(area, band.to_ha) - band.from_ha) * band.payout_share if {
	band.to_ha != null
	area > band.from_ha
}

band_share(band, area) := (area - band.from_ha) * band.payout_share if {
	band.to_ha == null
	area > band.from_ha
}

modulation_factor := 1 if total_area_ha <= 0

modulation_factor := sum([band_share(b, total_area_ha) | some b in tables.general_conditions.modulation_bands]) / total_area_ha if {
	total_area_ha > 0
}

premium_after_modulation := round2(premium_before_modulation * modulation_factor)

# O69-GEN-024: Mindestbetrag – keine Gewährung, wenn der Betrag 50 € nicht überschreitet (kann-Bestimmung).
below_minimum_payment if premium_after_modulation <= tables.general_conditions.minimum_payment_eur

# O69-GEN-030: Übererklärung bei nach Einheiten berechneten Prämien (§ 46 Abs. 1, 2 und 4 GSP-AV).
overdeclaration_payment(claimed, determined) := determined if claimed <= determined

overdeclaration_payment(claimed, determined) := determined if {
	claimed > determined
	claimed - determined <= 0.03 * determined
}

overdeclaration_payment(claimed, determined) := max2(determined - (1.5 * (claimed - determined)), 0) if {
	claimed > determined
	claimed - determined > 0.03 * determined
}

# O69-GEN-020: Stufen der inhaltlichen Kürzung; ab 2027 Einbehalt von 1 % statt Verwarnung.
sanction_percent(stage, y) := row.reduction_percent if {
	some row in tables.general_conditions.sanction_stages
	row.stage == stage
	sanction_row_applies(row, y)
}

sanction_row_applies(row, y) if {
	not has_value(row, "applies_until_year")
	not has_value(row, "applies_from_year")
	y > 0
}

sanction_row_applies(row, y) if y <= row.applies_until_year

sanction_row_applies(row, y) if y >= row.applies_from_year

# O69-GSP-008: mehrere Verstöße kumulieren durch Addition, höchstens 100 % der Jahresprämie.
cumulated_sanction_percent(percents) := min2(sum(percents), 100)

# O69-GEN-022: Teilzahlung höchstens 75 %; Auszahlung bis 30. Juni des Folgejahres, nicht vor 1. Dezember.
payment_schedule := {
	"advance_payment_max_eur": round2(premium_after_modulation * tables.general_conditions.advance_payment_max_share),
	"payments_not_before": year_date(year, tables.deadlines.payment.payments_not_before_month_day),
	"final_payment_by": year_date(year + 1, tables.deadlines.payment.payout_by_month_day),
}

premium := {
	"year": year,
	"application_by_technique_eur": application_premium_by_technique,
	"application_eur": application_premium,
	"application_cap_m3": application_cap_m3,
	"eligible_application_volume_m3": eligible_application_volume,
	"fertilizable_area_ha": fertilizable_area_ha,
	"separation_eur": separation_premium,
	"separation_cap_m3": separation_cap_m3,
	"eligible_separation_volume_m3": eligible_separation_volume,
	"pig_feeding_eur": pig_feeding_premium,
	"total_before_modulation_eur": premium_before_modulation,
	"modulation_factor": modulation_factor,
	"total_after_modulation_eur": premium_after_modulation,
	"below_minimum_payment": below_minimum_payment,
}

default below_minimum_payment := false

# O69-GEN-031: Reihenfolge der Mehrfachkürzungen (SRL 1.12.2).
deduction_order := tables.general_conditions.deduction_order
