package oepul.o6_14

# Praemienberechnung: Erschliessungsstufe, 1 ha je RGVE, Zuschlaege,
# Betriebsgroessenmodulation, Mindestauszahlung.

# --- Erschliessungszustand ------------------------------------------------

access_units(alm) := object.get(alm, "access_units", [])

# Mehrere Teilflaechen mit vergleichbaren Auftriebszeiten: Mittelung
# (gewichtet nach Alptagen, vgl. Beispiel Kapitel 4.2).
effective_access_level(alm) := level if {
	count(access_units(alm)) > 1
	is_true(alm, "access_times_comparable")
	total := sum([u.alp_days | some u in access_units(alm)])
	total > 0
	weighted := sum([(u.access_level * u.alp_days) | some u in access_units(alm)])
	level := round(weighted / total)
}

# Stark abweichende Auftriebszeiten: Teilflaeche mit dem laengeren
# Auftriebszeitraum ist massgeblich; Flaechenausmass unberuecksichtigt.
effective_access_level(alm) := level if {
	count(access_units(alm)) > 1
	not is_true(alm, "access_times_comparable")
	longest := max([u.drive_period_days | some u in access_units(alm)])
	levels := [u.access_level | some u in access_units(alm); u.drive_period_days == longest]
	level := max(levels)
}

effective_access_level(alm) := alm.access_level if count(access_units(alm)) <= 1

alm_access_level[alm_id] := effective_access_level(alm) if some alm_id, alm in alm_by_id

base_rate(level, y) := r.eur_per_ha if {
	some r in rates.base_rates_eur_per_ha
	r.access_level == level
	r.year_from <= y
	y <= r.year_to
}

# --- Praemienfaehige Flaeche ------------------------------------------------

national_park_allows(alm) if {
	np := object.get(alm, "national_park", "none")
	some row in proc.national_parks
	row.national_park == np
	row.almbewirtschaftung_premium == true
}

alm_definition_met(alm) if {
	is_true(alm, "in_alm_cadastre_or_alm_area")
	is_false(alm, "managed_from_home_farm")
	is_true(alm, "boundary_or_management_difference_visible")
}

alm_premium_rgve[alm_id] := x if {
	some alm_id, _ in alm_by_id
	x := sum([premium_rgve_share(id, alm_id) |
		some id, _ in animal_by_id
		animal_premium_eligible(id)
	])
}

alm_premium_eligible(alm_id) if {
	alm := alm_by_id[alm_id]
	alm_min_occupancy_met(alm_id)
	national_park_allows(alm)
	alm_definition_met(alm)
}

# Praemie fuer max. 1,00 ha Almweideflaeche je RGVE, max. im Ausmass der
# (oesterreichischen) Almweideflaeche.
alm_premium_area_ha[alm_id] := min([alm.alm_pasture_area_ha, alm_premium_rgve[alm_id] * rates.max_premium_ha_per_rgve]) if {
	some alm_id, alm in alm_by_id
	alm_premium_eligible(alm_id)
}

alm_premium_area_ha[alm_id] := 0 if {
	some alm_id, _ in alm_by_id
	not alm_premium_eligible(alm_id)
}

alm_base_premium[alm_id] := alm_premium_area_ha[alm_id] * base_rate(alm_access_level[alm_id], year) if some alm_id, _ in alm_by_id

# --- Zuschlag Naturschutz auf der Alm ----------------------------------------

nata_base_rate(y) := r.eur_per_ha if {
	some r in rates.nature_conservation_base_rates_eur_per_ha
	r.year_from <= y
	y <= r.year_to
}

nata_code_rate(code, y) := r.eur_per_ha if {
	some r in rates.nature_conservation_measure_codes
	r.code == code
	r.year_from <= y
}

# Ableitung der Aufwandsstufe aus dem betroffenen Anteil der Almweideflaeche.
nata_code_for_share(theme, share_pct) := r.code if {
	some r in rates.nature_conservation_measure_codes
	r.theme == theme
	share_pct > r.share_min_pct_exclusive
	share_pct <= r.share_max_pct_inclusive
}

nata_measures(alm) := object.get(object.get(alm, "nature_conservation", {}), "measures", [])

nata_codes_rate_sum(alm) := x if {
	x := sum([nata_code_rate(m.code, year) | some m in nata_measures(alm)])
}

nata_premium_eligible(alm_id) if {
	alm := alm_by_id[alm_id]
	nata_alm(alm)
	not awp_applied
	project_confirmation_all_plots(alm)
}

alm_nata_premium[alm_id] := alm_premium_area_ha[alm_id] * (nata_base_rate(year) + nata_codes_rate_sum(alm)) if {
	some alm_id, alm in alm_by_id
	nata_premium_eligible(alm_id)
}

alm_nata_premium[alm_id] := 0 if {
	some alm_id, _ in alm_by_id
	not nata_premium_eligible(alm_id)
}

# --- Zuschlag Almweideplan -------------------------------------------------

awp_premium_eligible if {
	awp_applied
	year >= rates.grazing_plan_supplement.year_from
	not nata_applied
	count(awp_obligation_violations) == 0
}

alm_awp_premium[alm_id] := min([alm_premium_area_ha[alm_id], rates.grazing_plan_supplement.max_ha_per_alm]) * rates.grazing_plan_supplement.eur_per_ha if {
	some alm_id, _ in alm_by_id
	awp_premium_eligible
}

alm_awp_premium[alm_id] := 0 if {
	some alm_id, _ in alm_by_id
	not awp_premium_eligible
}

# --- Modulation ------------------------------------------------------------

# Bemessungsgrundlage: Summe der praemienfaehigen Hektar (= Minimum aus RGVE
# und Almweideflaeche) aller Almen des Betriebes, getrennt von der Heimflaeche.
modulation_base_ha := sum([alm_premium_area_ha[alm_id] | some alm_id, _ in alm_by_id])

tier_portion(total, t) := max([0, min([total, t.to_ha_inclusive]) - t.from_ha_exclusive]) if t.to_ha_inclusive != null

tier_portion(total, t) := max([0, total - t.from_ha_exclusive]) if t.to_ha_inclusive == null

modulation_factor_for(total) := 1 if total <= 0

modulation_factor_for(total) := f if {
	total > 0
	paid := sum([(tier_portion(total, t) * t.payout_factor) | some t in rates.modulation_tiers])
	f := paid / total
}

modulation_factor := modulation_factor_for(modulation_base_ha)

# --- Summen ------------------------------------------------------------------

premium_before_modulation := sum([((alm_base_premium[alm_id] + alm_nata_premium[alm_id]) + alm_awp_premium[alm_id]) | some alm_id, _ in alm_by_id])

premium_total := premium_before_modulation * modulation_factor if access_conditions_met

premium_total := 0 if not access_conditions_met

# Von der Gewaehrung kann abgesehen werden, wenn der Betrag 50 Euro nicht
# ueberschreitet.
payout_may_be_withheld if premium_total <= rates.minimum_payout_eur

advance_payment_max := premium_total * rates.advance_payment_max_share

area_payment_cap(cap_id, y) := r.eur_per_ha if {
	some r in rates.area_payment_caps_eur_per_ha
	r.cap_id == cap_id
	r.year_from <= y
	y <= r.year_to
}

alm_rate_per_ha(alm_id) := (base_rate(alm_access_level[alm_id], year) + nata_rate_part(alm_id)) + awp_rate_part(alm_id)

nata_rate_part(alm_id) := nata_base_rate(year) + nata_codes_rate_sum(alm_by_id[alm_id]) if nata_premium_eligible(alm_id)

nata_rate_part(alm_id) := 0 if not nata_premium_eligible(alm_id)

awp_rate_part(_) := rates.grazing_plan_supplement.eur_per_ha if awp_premium_eligible

awp_rate_part(_) := 0 if not awp_premium_eligible

premium_summary := {
	"year": year,
	"alms": {alm_id: {
		"access_level": alm_access_level[alm_id],
		"premium_rgve": round2(alm_premium_rgve[alm_id]),
		"premium_area_ha": round2(alm_premium_area_ha[alm_id]),
		"base_premium_eur": round2(alm_base_premium[alm_id]),
		"nature_conservation_premium_eur": round2(alm_nata_premium[alm_id]),
		"grazing_plan_premium_eur": round2(alm_awp_premium[alm_id]),
	} |
		some alm_id, _ in alm_by_id
	},
	"modulation_base_ha": round2(modulation_base_ha),
	"modulation_factor": modulation_factor,
	"premium_before_modulation_eur": round2(premium_before_modulation),
	"premium_total_eur": round2(premium_total),
}
