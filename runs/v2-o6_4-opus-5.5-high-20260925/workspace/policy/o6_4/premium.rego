# Höhe der Prämie, Kombinationen, Obergrenzen und Modulation
# (Maßnahmenblatt Kap. 6; SRL 2.4 Höhe der Förderung, 1.9; Anhang L; Allgemeine Bedingungen 9.2, 9.3).
package oepul.o6_4

# O6_4-PREM-001: Prämiensatz je Code und Antragsjahr aus der Prämientabelle.
premium_rate(code, yr) := r.eur_per_ha if {
	some r in data.o6_4.premium_rates.rows
	r.code == code
	r.valid_from_year <= yr
	year_within_upper(r.valid_to_year, yr)
}

year_within_upper(upper, _) if upper == null

year_within_upper(upper, yr) if {
	upper != null
	yr <= upper
}

# GEN-OP-001 / GEN-VF-001: Codes OP bzw. VF – keine Prämie im jeweiligen Jahr.
no_premium_code(p) if {
	some c in object.get(p, "oepul_codes", [])
	c in {x | some x in params.op_code_mandatory_cases.no_premium_codes}
}

# GEN-NP-001: Flächen in Nationalparks erhalten in o6_4 keine Prämie
# (außer es sind keine relevanten Bewirtschaftungsauflagen festgelegt).
national_park_no_premium(p) if {
	object.get(p, ["constraints", "in_national_park"], false) == true
	not object.get(p, ["constraints", "national_park_without_relevant_restrictions"], false) == true
}

# O6_4-PREM-002: Prämiengewährung nur im Jahr der Mahd (BM1–BM3 mit tatsächlicher vollflächiger Mahd).
premium_parcel_reason(pid) := "not_eligible" if {
	enrolled_parcels[pid]
	not parcel_eligible(pid)
} else := "no_unique_code" if {
	not parcel_bm_code(enrolled_parcels[pid])
} else := "no_mowing" if {
	not parcel_bm_code(enrolled_parcels[pid]) in mowing_year_codes
} else := "no_valid_full_mowing" if {
	not valid_full_mowing_this_year(enrolled_parcels[pid])
} else := "op_or_vf_code" if {
	no_premium_code(enrolled_parcels[pid])
} else := "national_park" if {
	national_park_no_premium(enrolled_parcels[pid])
} else := "rate_missing" if {
	not premium_rate(parcel_bm_code(enrolled_parcels[pid]), year)
} else := "premium"

parcel_premium[pid] := round_cent(p.area_ha * premium_rate(parcel_bm_code(p), year)) if {
	some pid, p in enrolled_parcels
	premium_parcel_reason(pid) == "premium"
}

parcel_premium[pid] := 0 if {
	some pid, _ in enrolled_parcels
	premium_parcel_reason(pid) != "premium"
}

round_cent(x) := round(x * 100) / 100

premium_before_modulation := round_cent(sum([v | some v in parcel_premium]))

# O6_4-PREM-003 / GEN-COMB-001: auf der Einzelfläche mit keiner anderen ÖPUL-Maßnahme kombinierbar,
# ausgenommen Abgeltung (punktförmiger) Landschaftselemente in 1A/1B (Anhang L, Fußnote 1).
combination_row := r if {
	some r in data.o6_4.combination_table.rows
	r.measure_id == "4"
}

combination_cell(other_id) := c if {
	some c in combination_row.cells
	c.measure_id == other_id
}

combination_permitted(other_id, component) if {
	cell := combination_cell(other_id)
	cell.marker != null
	not "1" in cell.footnotes
	component != null
}

combination_permitted(other_id, component) if {
	cell := combination_cell(other_id)
	cell.marker != null
	"1" in cell.footnotes
	component == "landscape_element"
}

# Zuordnung Maßnahmen-ID (o6_x) → Spaltenkennung Anhang L.
annex_l_id(mid) := upper(trim_prefix(mid, "o6_"))

combination_conflict contains {"rule_id": "O6_4-PREM-003", "parcel_id": pid, "other_measure": m.measure_id, "premium_component": object.get(m, "premium_component", "area")} if {
	some pid, p in enrolled_parcels
	some m in object.get(p, "oepul_measure_participation", [])
	m.measure_id != measure_id
	not combination_permitted(annex_l_id(m.measure_id), object.get(m, "premium_component", "area"))
}

# GEN-CAP-001: Prämienobergrenze je ha für die Summe flächenbezogener Zahlungen inkl. Landschaftselemente.
premium_cap_per_ha(cap_type, yr) := r.eur_per_ha if {
	some r in params.premium_caps.rows
	r.cap_type == cap_type
	r.year_from <= yr
	year_within_upper(r.year_to, yr)
}

parcel_payment_per_ha(pid) := total if {
	p := enrolled_parcels[pid]
	own := premium_rate(parcel_bm_code(p), year)
	others := sum([v |
		some m in object.get(p, "oepul_measure_participation", [])
		m.measure_id != measure_id
		v := object.get(m, "payment_eur_per_ha", 0)
	])
	total := own + others
}

cap_exceeded contains {"rule_id": "GEN-CAP-001", "parcel_id": pid, "payment_eur_per_ha": v, "cap_eur_per_ha": cap} if {
	some pid, _ in enrolled_parcels
	premium_parcel_reason(pid) == "premium"
	v := parcel_payment_per_ha(pid)
	cap := premium_cap_per_ha("general", year)
	v > cap
}

# GEN-MOD-001: Betriebsgrößenmodulation (gestaffelter Auszahlungsfaktor nach Gesamtfläche).
modulation_factor(total_ha) := 1 if total_ha <= 0

modulation_factor(total_ha) := f if {
	total_ha > 0
	weighted := [v |
		some t in params.modulation_tiers.rows
		v := tier_share(t, total_ha) * t.payout_factor
	]
	f := sum(weighted) / total_ha
}

tier_share(t, total_ha) := max([0, min([tier_upper(t, total_ha), total_ha]) - t.from_ha_exclusive])

tier_upper(t, total_ha) := total_ha if t.to_ha_inclusive == null

tier_upper(t, _) := t.to_ha_inclusive if t.to_ha_inclusive != null

default farm_total_area_ha := 0

farm_total_area_ha := input.land.total_area_ha

premium_after_modulation := round_cent(premium_before_modulation * modulation_factor(farm_total_area_ha))

# GEN-PAY-002: Von der Gewährung kann abgesehen werden, wenn der Auszahlungsbetrag 50 Euro nicht überschreitet.
payment_may_be_waived(amount) if amount <= params.payment.min_payout_eur_exclusive

# GEN-PAY-001: Teilzahlung höchstens 75 % nach Abschluss der Verwaltungskontrollen.
max_advance_payment(amount) := round_cent(amount * params.payment.max_advance_share)
